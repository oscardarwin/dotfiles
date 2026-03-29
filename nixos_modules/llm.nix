{ config, ... }:
{
  clan.core.vars.generators.litellm = {
    files.openrouter_api_key_env = {
      secret = true;
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

  services.litellm = {
    enable = true;
    environmentFile = config.clan.core.vars.generators.litellm.files.openrouter_api_key_env.path;
    environment = {
      LITELLM_LOG = "DEBUG";
    };
    settings = {
      litellm_settings.set_verbose = true;
      model_list = [
        {
          model_name = "openrouter-free";
          litellm_params = {
            model = "openrouter/openrouter/free";
            api_key = "os.environ/OPENROUTER_API_KEY";
          };
        }
      ];
      extra_body = {
        provider = {
          sort = "throughput";
        };
      };
    };
  };
}
