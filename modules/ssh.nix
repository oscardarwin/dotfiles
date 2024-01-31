{ ... }: {
  # services.openssh = {
  #   enable = true;
  # };

  # programs.ssh = {
  #   startAgent = true;
  # };
  
  # home-manager.users.hallayus.programs.ssh = {
  #   addKeysToAgent = "~/.ssh/github";
  # };

  home-manager.users.hallayus.services.ssh-agent = {
    enable = true;
  }; 
}
