{ ... }: {
  services.openssh = {
    enable = true;
  };

  home-manager.users.hallayus.programs.ssh = {
    enable = true;
    # addKeysToAgent = "~/.ssh/github";
  };

  home-manager.users.hallayus.services.ssh-agent = {
    enable = true;
  };
}
