{ pkgs, osConfig, ... }:
let
  port = "8080";
  model = "openrouter-free";
  dummyLiteLLMApiKey = "LITELLM_API_KEY";
  litellmConfig = (pkgs.formats.yaml { }).generate "litellm-config.yaml" {
    model_list = [
      {
        model_name = model;
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
in
{
  home.packages = [ pkgs.litellm ];

  systemd.user.services.litellm = {
    Unit = {
      Description = "LiteLLM Proxy Server";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.litellm}/bin/litellm --config ${litellmConfig} --port ${port}";
      EnvironmentFile =
        osConfig.clan.core.vars.generators.litellm.files.openrouter_api_key_env.path;
      Restart = "on-failure";
      RestartSec = "5s";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.sessionVariables = {
    ${dummyLiteLLMApiKey} = "dummy"; # avante expects an api key
  };

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
