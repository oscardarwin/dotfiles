{ pkgs, ... }:
let
  ollamaModel = "gemma3:1b";
in
{

  environment.systemPackages = [
    pkgs.ollama
  ];

  services.ollama = {
    enable = true;
    loadModels = [ ollamaModel ];
  };
}
