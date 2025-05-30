{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.opensnitch-ui;

in
{

  meta.maintainers = [ lib.maintainers.onny ];

  options = {
    services.opensnitch-ui = {
      enable = lib.mkEnableOption "Opensnitch client";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.opensnitch-ui" pkgs lib.platforms.linux)
    ];

    systemd.user.services.opensnitch-ui = {
      Unit = {
        Description = "Opensnitch ui";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Environment = [ "PATH=${config.home.profileDirectory}/bin" ];
        ExecStart = "${pkgs.opensnitch-ui}/bin/opensnitch-ui";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
