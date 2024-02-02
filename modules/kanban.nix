{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.haskellPackages.taskell
  ];
}
