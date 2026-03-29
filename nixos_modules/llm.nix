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
    settings = {
      model_list = [
        {
          model_name = "openrouter-free";
          litellm_params = {
            # litellm strips away the first openrouter before sending to openrouter.
            # The switching end point is actually determined by openrouter/free on the openrouter side, so we need 2..
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
