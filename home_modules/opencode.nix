{ inputs, config, pkgs, ... }:

let
  cfg = config.my.litellm;

  models = builtins.listToAttrs (
    map
      (model: {
        name = model.model_name;
        value = {
          name = model.model_name;
        };
      })
      cfg.models
  );
in
{
  programs.opencode = {
    enable = true;
    package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}.opencode;

    settings = {
      "$schema" = "https://opencode.ai/config.json";

      # Choose your default LiteLLM model alias.
      # Replace this with one of your configured model_name values.
      model =
        if cfg.models == [ ]
        then null
        else "litellm/${(builtins.head cfg.models).model_name}";

      provider.litellm = {
        name = "LiteLLM";
        npm = "@ai-sdk/openai-compatible";

        options = {
          baseURL = "http://localhost:8080/v1";
        };

        inherit models;
      };
    };
  };
}


