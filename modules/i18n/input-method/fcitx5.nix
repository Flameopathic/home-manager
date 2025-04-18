{
  config,
  pkgs,
  lib,
  ...
}:
let
  im = config.i18n.inputMethod;
  cfg = im.fcitx5;
  fcitx5Package = cfg.fcitx5-with-addons.override { inherit (cfg) addons; };
in
{
  options = {
    i18n.inputMethod.fcitx5 = {
      fcitx5-with-addons = lib.mkOption {
        type = lib.types.package;
        default = pkgs.libsForQt5.fcitx5-with-addons;
        example = lib.literalExpression "pkgs.kdePackages.fcitx5-with-addons";
        description = ''
          The fcitx5 package to use.
        '';
      };
      addons = lib.mkOption {
        type = with lib.types; listOf package;
        default = [ ];
        example = lib.literalExpression "with pkgs; [ fcitx5-rime ]";
        description = ''
          Enabled Fcitx5 addons.
        '';
      };

      waylandFrontend = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Use the Wayland input method frontend.
          See [Using Fcitx 5 on Wayland](https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland).
        '';
      };

      config = lib.mkOption {
        type = with lib.types; either path lines;
        default = "";
        description = ''
          Configuration to be written to {file}`$XDG_DATA_HOME/fcitx5/conf/classicui.conf`
        '';
      };

      themes = lib.mkOption {
        type =
          with lib.types;
          lazyAttrsOf (submodule {
            options = {
              theme = lib.mkOption {
                type = with lib.types; either lines path;
                description = ''
                  The `theme.conf` file of the theme.

                  See https://fcitx-im.org/wiki/Fcitx_5_Theme#Background_images
                  for more information.
                '';
              };
              highlightImage = lib.mkOption {
                type = lib.types.path;
                description = "Path to the SVG of the highlight.";
              };
              panelImage = lib.mkOption {
                type = lib.types.path;
                description = "Path to the SVG of the panel.";
              };
            };
          });
        example = "";
        description = ''
          Themes to be written to {file}`$XDG_DATA_HOME/fcitx5/themes/''${name}`
        '';
        default = { };
      };
    };
  };

  config = lib.mkIf (im.enabled == "fcitx5") {
    i18n.inputMethod.package = fcitx5Package;

    home = {
      sessionVariables =
        {
          GLFW_IM_MODULE = "ibus"; # IME support in kitty
          SDL_IM_MODULE = "fcitx";
          XMODIFIERS = "@im=fcitx";
        }
        // lib.optionalAttrs (!cfg.waylandFrontend) {
          GTK_IM_MODULE = "fcitx";
          QT_IM_MODULE = "fcitx";
        };

      sessionSearchVariables.QT_PLUGIN_PATH = [ "${fcitx5Package}/${pkgs.qt6.qtbase.qtPluginPrefix}" ];
    };

    xdg =
      let
        mkThemeConfig = name: attrs: {
          dataFile = {
            "fcitx5/themes/${name}/highlight.svg".source = lib.mkIf (
              attrs ? highlightImage
            ) attrs.highlightImage;
            "fcitx5/themes/${name}/panel.svg".source = lib.mkIf (attrs ? panelImage) attrs.highlightImage;
            "fcitx5/themes/${name}/theme.conf" = lib.mkIf (attrs ? panelImage) {
              source =
                if builtins.isPath attrs.theme || lib.isStorePath attrs.theme then
                  attrs.theme
                else
                  pkgs.writeText "fcitx5-theme.conf" attrs.theme;
            };
          };
        };
      in
      lib.mkMerge (
        [
          {
            dataFile."fcitx5/conf/classicui.conf".source = lib.mkIf (cfg.config != "") (
              if builtins.isPath cfg.config || lib.isStorePath cfg.config then
                cfg.config
              else
                pkgs.writeText "fcitx5-classicui.conf" cfg.config
            );
          }
        ]
        ++ (builtins.attrValues (lib.mapAttrs mkThemeConfig cfg.themes))
      );

    systemd.user.services.fcitx5-daemon = {
      Unit = {
        Description = "Fcitx5 input method editor";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service.ExecStart = "${fcitx5Package}/bin/fcitx5";
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
