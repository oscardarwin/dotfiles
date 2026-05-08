{ osConfig, ... }:
let
  openrouterModel = "openrouter/free"; # Standardized model name
  ollamaModel = "gemma3:1b";
in
{

  programs.nixvim.plugins.avante = {
    enable = true;
    settings = {
      provider = "ollama";
      providers = {
        ollama = {
          __inherited_from = "openai";
          endpoint = "http://127.0.0.1:11434/v1";
          model = ollamaModel;
          api_key_name = "";
        };
      };
    };
  };

  home.sessionVariables = {
    OPENROUTER_API_KEY = "$(cat ${osConfig.clan.core.vars.generators.openrouter_api_key.files.openrouter_api_key.path})";
  };
}
