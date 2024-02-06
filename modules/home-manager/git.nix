{ ... }: {
  programs = {
    git = {
      enable = true;
      includes = [{ path = "~/.config/git/user"; }];
      extraConfig = { gpg.format = "ssh"; };
      signing = {
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXwNal8WbxW4K7noFVTiKKFwNBMvAh7BsbmISMj1q41";
        signByDefault = true;
        gpgPath = "/opt/1Password/op-ssh-sign";
      };
    };
    lazygit.enable = true;
  };
}
