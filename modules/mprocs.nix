{ pkgs, ... }: {
  environment.systemPackages = [
    pkgs.mprocs
  ];
}
