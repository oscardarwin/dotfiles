{ ... }: {
  services.openssh = {
    enable = true;
  };

  home-manager.users.hallayus.programs.ssh = {
    enable = true;
    extraConfig = ''IdentityAgent ~/.1password/agent.sock'';
    # addKeysToAgent = "~/.ssh/github";
  };

  home-manager.users.hallayus.services.ssh-agent = {
    enable = true;
  };
}
