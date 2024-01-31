{ pkgs, ... }: {
  # home-manager.users.hallayus = {
    services.openssh = {
      enable = true;
    };

    programs.ssh = {
      startAgent = true;
    };
  #}; 
}
