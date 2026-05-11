{ config, lib, ... }:

let
  dummyLiteLLMApiKey = "DUMMY";

  port = toString config.my.litellm.port;

  mkName = model: lib.replaceStrings [ ":" "." "-" ] [ "_" "_" "_" ] model;

  mkProvider = model: {
    name = mkName model;

    value = {
      model = model;

      __inherited_from = "openai";

      endpoint = "http://localhost:${port}/v1";

      api_key_name = dummyLiteLLMApiKey;
    };
  };

  providers =
    builtins.listToAttrs
      (map mkProvider config.my.litellm.models);

  defaultProvider = mkName (builtins.elemAt config.my.litellm.models 0);

  model = "";

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
