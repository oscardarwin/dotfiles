{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    beeper
  ];
}
