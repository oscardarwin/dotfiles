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
in
{
  home.sessionVariables = {
    ${dummyLiteLLMApiKey} = "dummy"; # avante expects an api key
  };

  programs.nixvim = {
    plugins = {
      avante = {
        enable = true;
        settings = {
          provider = defaultProvider;
          providers = providers;
        };
      };
    };
  };
}
