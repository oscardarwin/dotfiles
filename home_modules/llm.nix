{ config, ... }:
let
  dummyLiteLLMApiKey = "DUMMY";
  port = config.my.litellm.port;
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
