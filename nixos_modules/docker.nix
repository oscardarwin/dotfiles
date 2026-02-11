{ ... }: {
  virtualisation.docker.enable = true;
  users.users.oscar.extraGroups = [ "docker" ];
}
