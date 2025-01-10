{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    libresprite
  ];
}
