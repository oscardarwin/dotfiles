{ ... }: {
  home-manager.users.hallayus.programs.git = {
    enable = true;
    includes = [{ path = "~/.config/git/user"; }];
    extraConfig = { gpg.format = "ssh"; };
    signing = {
      key = "~/.ssh/github.pub";
      signByDefault = true;
    };
  };
}
