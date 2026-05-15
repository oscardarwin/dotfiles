{ pkgs, ... }:
let
  loadModels = [ "gemma3:1b" "qwen2.5-coder:7b" "deepseek-r1:8b" ];
in
{
  environment.systemPackages = [
    pkgs.ollama
  ];

  services.ollama = {
    inherit loadModels;
    enable = true;
  };
}
