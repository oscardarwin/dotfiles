{ pkgs, lib, osConfig, config, ... }:
let
  openrouter_model = {
    model_name = "openrouter_free";
    litellm_params = {
      model = "openrouter/openrouter/free";
      api_key = "os.environ/OPENROUTER_API_KEY";
    };
  };

  openai_gpt_41_mini = {
    model_name = "gpt_4.1_mini";
    litellm_params = {
      model = "openai/gpt-4.1-mini";
      api_key = "os.environ/OPENAI_API_KEY";
    };
  };

  openai_gpt_sol = {
    model_name = "gpt_sol";
    litellm_params = {
      model = "openai/responses/gpt-6.1-sol";
      api_key = "os.environ/OPENAI_API_KEY";
    };
  };
in
{
  options.my.litellm.port = lib.mkOption {
    type = lib.types.port;
    default = 8080;
    description = "LiteLLM proxy port";
  };

  options.my.litellm.models = lib.mkOption {
    type = lib.types.listOf (lib.types.submodule {
      options = {
        model_name = lib.mkOption {
          type = lib.types.str;
          description = "The display name or identifier for the model.";
          example = "openrouter-free";
        };

        litellm_params = lib.mkOption {
          description = "Parameters passed directly to LiteLLM.";
          type = lib.types.submodule {
            options = {
              model = lib.mkOption {
                type = lib.types.str;
                description = "The provider-specific model string.";
              };
              api_key = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "The API key or environment variable reference.";
              };
              api_base = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "The endpoint of the model";
              };
            };
          };
        };
      };
    });
    default = [ ];
    description = "A list of model configurations for LiteLLM.";
  };

  options.my.litellm.default_model = lib.mkOption
    {
      type = lib.types.str;
      default = openrouter_model.model_name;
    };

  config =
    let
      litellmConfig =
        (pkgs.formats.yaml { }).generate "litellm-config.yaml" {
          model_list = config.my.litellm.models;
          extra_body = {
            provider.sort = "throughput";
          };

          litellm_settings = {
            drop_params = true;
          };
        };
    in
    {
      home.packages = [
        pkgs.litellm
      ];

      my.litellm.models = [
        openrouter_model
        openai_gpt_41_mini
        openai_gpt_sol
      ];

      systemd.user.services.litellm = {
        Unit = {
          Description = "LiteLLM Proxy Server";
          After = [
            "network.target"
            "ollama.service"
          ];
        };

        Service = {
          Type = "simple";

          ExecStart =
            "${pkgs.litellm}/bin/litellm --config ${litellmConfig} --port ${toString config.my.litellm.port}";

          EnvironmentFile =
            osConfig.clan.core.vars.generators.litellm.files.openrouter_api_key_env.path;

          Restart = "on-failure";
          RestartSec = "5s";
        };

        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };

}
