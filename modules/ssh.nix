{ pkgs, ... }: {
  home-manager.users.hallayus = {
    programs.ssh.enable = true;
  }; 
}
