{ pkgs, lib, ... }:
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

  my.litellm.models = lib.forEach loadModels (model: {
    model_name = model;

    litellm_params = {
      model = "ollama/${model}";
      api_base = "http://127.0.0.1:${toString osConfig.services.ollama.port}";
    };
  });

}
