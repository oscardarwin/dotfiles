{ pkgs, ... }:
let
  loadModels = [ "gemma3:1b" "qwen2.5-coder:7b" "deepseek-r1:8b" "qwen3.5:4b" ];
in
{
  environment.systemPackages = [
    pkgs.ollama
  ];

  services.ollama = {
    package = pkgs.ollama-cuda;
    inherit loadModels;
    enable = true;
  };
}
