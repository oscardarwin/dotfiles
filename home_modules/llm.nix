{ config, lib, ... }:

let
  dummyLiteLLMApiKey = "DUMMY";

  port = toString config.my.litellm.port;

  mkName = model: lib.replaceStrings [ ":" "." "-" ] [ "_" "_" "_" ] model;

  mkProvider = model: {
    name = mkName model.model_name;

    value = {
      model = model.model_name;

      __inherited_from = "openai";

      endpoint = "http://localhost:${port}/v1";

      api_key_name = dummyLiteLLMApiKey;
    };
  };

  providersList = map mkProvider config.my.litellm.models;
  providers = builtins.listToAttrs providersList;
  defaultProvider = (builtins.elemAt providersList 0).name;
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
          inherit providers;
          provider = defaultProvider;
        };
      };
    };
  };
}
