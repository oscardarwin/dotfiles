{ pkgs, inputs, ... }:
{
  environment.systemPackages = [
    inputs.clan-core.packages.${pkgs.system}.clan-cli
  ];

  clan.core.vars.generators.litellm = {
    files.openrouter_api_key_env = {
      secret = true;
      owner = "oscar";
    };
    prompts.openrouter_api_key = {
      description = "OpenRouter API key (from openrouter.ai/keys)";
      persist = true;
    };
    script = ''
      echo "OPENROUTER_API_KEY=$(cat $prompts/openrouter_api_key)" \
        > $out/openrouter_api_key_env
    '';
  };
}
