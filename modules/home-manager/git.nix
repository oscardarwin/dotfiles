{ ... }: {
  programs = {
    git = {
      enable = true;
      includes = [{ path = "~/.config/git/user"; }];
      extraConfig = { gpg.format = "ssh"; };
      signing = {
        key = "~/.ssh/github.pub";
        signByDefault = true;
        gpgPath = "/opt/1Password/op-ssh-sign";
      };
    };
    lazygit.enable = true;
  };
}
