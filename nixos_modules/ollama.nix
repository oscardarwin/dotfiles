{ pkgs, ... }:
{

  environment.systemPackages = [
    pkgs.ollama
  ];

  services.ollama = {
    enable = true;
    loadModels = [ "gemma3:1b" "qwen2.5-coder:7b" "deepseek-r1:8b" ];
  };
}
