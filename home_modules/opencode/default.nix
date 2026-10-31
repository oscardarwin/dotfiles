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

      model =
        if cfg.models == [ ]
        then null
        else "$litellm/${cfg.default_model}";

      provider.litellm = {
        name = "LiteLLM";
        npm = "@ai-sdk/openai-compatible";

        options = {
          baseURL = "http://localhost:8080/v1";
        };

        inherit models;
      };
    };

    context = ./coding_guidelines.md;
  };
}
