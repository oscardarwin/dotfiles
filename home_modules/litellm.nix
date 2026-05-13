{ pkgs, lib, osConfig, config, ... }:
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
                example = "openrouter/openrouter/free";
              };
              api_key = lib.mkOption {
                type = lib.types.str;
                description = "The API key or environment variable reference.";
                example = "os.environ/OPENROUTER_API_KEY";
              };
            };
          };
        };
      };
    });
    default = [ ];
    description = "A list of model configurations for LiteLLM.";
  };

  config =
    let
      litellmConfig =
        (pkgs.formats.yaml { }).generate "litellm-config.yaml" {
          model_list = config.my.litellm.models;
          extra_body = {
            provider.sort = "throughput";
          };
        };
    in
    {
      home.packages = [
        pkgs.litellm
      ];

      my.litellm.models = [
        {
          model_name = "openrouter_free";
          litellm_params = {
            model = "openrouter/openrouter/free";
            api_key = "os.environ/OPENROUTER_API_KEY";
          };
        }
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
