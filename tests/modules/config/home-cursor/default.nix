{
  # Ensure backwards compatibility with existing configs
  home-cursor-legacy =
    { realPkgs, ... }:
    {
      config = {
        home.pointerCursor = {
          package = realPkgs.catppuccin-cursors.macchiatoBlue;
          name = "catppuccin-macchiato-blue-standard";
          size = 64;
          gtk.enable = true;
          hyprcursor.enable = true;
          x11.enable = true;
        };

        home.stateVersion = "24.11";

        nmt.script = ''
          assertFileContent \
            home-path/share/icons/catppuccin-macchiato-blue-cursors/index.theme \
            ${./expected-index.theme}

          hmEnvFile=home-path/etc/profile.d/hm-session-vars.sh
          assertFileExists $hmEnvFile
          assertFileRegex $hmEnvFile 'XCURSOR_THEME="catppuccin-macchiato-blue-standard"'
          assertFileRegex $hmEnvFile 'XCURSOR_SIZE="64"'
          assertFileRegex $hmEnvFile 'HYPRCURSOR_THEME="catppuccin-macchiato-blue-standard"'
          assertFileRegex $hmEnvFile 'HYPRCURSOR_SIZE="64"'
        '';
      };
    };

  home-cursor-legacy-disabled =
    { ... }:
    {
      config = {
        home.pointerCursor = null;

        home.stateVersion = "24.11";

        test.asserts.warnings.expected = [
          ''
            Setting home.pointerCursor to null is deprecated.
            Please update your configuration to explicitly set:

              home.pointerCursor.enable = false;
          ''
        ];

        nmt.script = ''
          assertPathNotExists home-path/share/icons/catppuccin-macchiato-blue-cursors/index.theme

          hmEnvFile=home-path/etc/profile.d/hm-session-vars.sh
          assertFileExists $hmEnvFile
          assertFileNotRegex $hmEnvFile 'XCURSOR_THEME="catppuccin-macchiato-blue-standard"'
          assertFileNotRegex $hmEnvFile 'XCURSOR_SIZE="32"'
          assertFileNotRegex $hmEnvFile 'HYPRCURSOR_THEME="catppuccin-macchiato-blue-standard"'
          assertFileNotRegex $hmEnvFile 'HYPRCURSOR_SIZE="32"'
        '';
      };
    };

  home-cursor-legacy-disabled-with-enable =
    { realPkgs, ... }:
    {
      config = {
        home.pointerCursor = {
          enable = false;
          package = realPkgs.catppuccin-cursors.macchiatoBlue;
          name = "catppuccin-macchiato-blue-standard";
          size = 64;
          gtk.enable = true;
          hyprcursor.enable = true;
          x11.enable = true;
        };

        home.stateVersion = "24.11";

        nmt.script = ''
          assertPathNotExists home-path/share/icons/catppuccin-macchiato-blue-cursors/index.theme

          hmEnvFile=home-path/etc/profile.d/hm-session-vars.sh
          assertFileExists $hmEnvFile
          assertFileNotRegex $hmEnvFile 'XCURSOR_THEME="catppuccin-macchiato-blue-standard"'
          assertFileNotRegex $hmEnvFile 'XCURSOR_SIZE="32"'
          assertFileNotRegex $hmEnvFile 'HYPRCURSOR_THEME="catppuccin-macchiato-blue-standard"'
          assertFileNotRegex $hmEnvFile 'HYPRCURSOR_SIZE="32"'
        '';
      };
    };

  home-cursor-legacy-enabled-with-enable =
    { realPkgs, ... }:
    {
      config = {
        home.pointerCursor = {
          enable = true;
          package = realPkgs.catppuccin-cursors.macchiatoBlue;
          name = "catppuccin-macchiato-blue-standard";
          size = 64;
          gtk.enable = true;
          hyprcursor.enable = true;
          x11.enable = true;
        };

        home.stateVersion = "24.11";

        nmt.script = ''
          assertFileContent \
            home-path/share/icons/catppuccin-macchiato-blue-cursors/index.theme \
            ${./expected-index.theme}

          hmEnvFile=home-path/etc/profile.d/hm-session-vars.sh
          assertFileExists $hmEnvFile
          assertFileRegex $hmEnvFile 'XCURSOR_THEME="catppuccin-macchiato-blue-standard"'
          assertFileRegex $hmEnvFile 'XCURSOR_SIZE="64"'
          assertFileRegex $hmEnvFile 'HYPRCURSOR_THEME="catppuccin-macchiato-blue-standard"'
          assertFileRegex $hmEnvFile 'HYPRCURSOR_SIZE="64"'
        '';

      };
    };

  home-cursor =
    { realPkgs, ... }:
    {
      config = {
        home.pointerCursor = {
          enable = true;
          package = realPkgs.catppuccin-cursors.macchiatoBlue;
          name = "catppuccin-macchiato-blue-standard";
          size = 64;
          gtk.enable = true;
          hyprcursor.enable = true;
          x11.enable = true;
        };

        home.stateVersion = "25.05";

        nmt.script = ''
          assertFileContent \
            home-path/share/icons/catppuccin-macchiato-blue-cursors/index.theme \
            ${./expected-index.theme}

          hmEnvFile=home-path/etc/profile.d/hm-session-vars.sh
          assertFileExists $hmEnvFile
          assertFileRegex $hmEnvFile 'XCURSOR_THEME="catppuccin-macchiato-blue-standard"'
          assertFileRegex $hmEnvFile 'XCURSOR_SIZE="64"'
          assertFileRegex $hmEnvFile 'HYPRCURSOR_THEME="catppuccin-macchiato-blue-standard"'
          assertFileRegex $hmEnvFile 'HYPRCURSOR_SIZE="64"'
        '';
      };
    };

  home-cursor-disabled =
    { realPkgs, ... }:
    {
      config = {
        home.pointerCursor = {
          enable = false;
          package = realPkgs.catppuccin-cursors.macchiatoBlue;
          name = "catppuccin-macchiato-blue-standard";
          size = 64;
          gtk.enable = true;
          hyprcursor.enable = true;
          x11.enable = true;
        };

        home.stateVersion = "25.05";

        nmt.script = ''
          assertPathNotExists home-path/share/icons/catppuccin-macchiato-blue-cursors/index.theme

          hmEnvFile=home-path/etc/profile.d/hm-session-vars.sh
          assertFileExists $hmEnvFile
          assertFileNotRegex $hmEnvFile 'XCURSOR_THEME="catppuccin-macchiato-blue-standard"'
          assertFileNotRegex $hmEnvFile 'XCURSOR_SIZE="32"'
          assertFileNotRegex $hmEnvFile 'HYPRCURSOR_THEME="catppuccin-macchiato-blue-standard"'
          assertFileNotRegex $hmEnvFile 'HYPRCURSOR_SIZE="32"'
        '';
      };
    };
}
