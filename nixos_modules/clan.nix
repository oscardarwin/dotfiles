{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.clan-core.packages.${pkgs.system}.clan-cli
  ];
}
