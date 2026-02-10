{ ... }: {
  virtualisation.docker.enable = true;
  users.users.hallayus.extraGroups = [ "docker" ];
}
