{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    hmcl
  ];
}
