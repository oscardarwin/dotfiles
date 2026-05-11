{ config, ... }:
let
  dummyLiteLLMApiKey = "DUMMY";
  port = toString config.my.litellm.port;
  model = config.my.ollama.default_model;
in
{
  programs.nixvim = {
    plugins = {
      avante = {
        enable = true;
        settings = {
          provider = "litellm";
          providers = {
            litellm =
              {
                inherit model;
                __inherited_from = "openai";
                endpoint = "http://localhost:${port}/v1";
                api_key_name = dummyLiteLLMApiKey;
              };
          };
        };
      };
    };
  };
}
