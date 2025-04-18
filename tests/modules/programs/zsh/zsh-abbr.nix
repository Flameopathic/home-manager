{
  programs.zsh.zsh-abbr = {
    enable = true;
    abbreviations = {
      ga = "git add";
    };
  };

  nmt.script = ''
    abbreviations=home-files/.config/zsh-abbr/user-abbreviations

    assertFileExists $abbreviations
    assertFileContains $abbreviations "abbr ga='git add'"
  '';
}
