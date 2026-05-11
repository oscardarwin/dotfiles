{ pkgs, lib, osConfig, config, ... }:

let

  ollamaModels = osConfig.services.ollama.loadModels or [ ];

  ollamaEntries = lib.forEach ollamaModels (model: {
    model_name = model;

    litellm_params = {
      model = "ollama/${model}";
      api_base = "http://127.0.0.1:${toString osConfig.services.ollama.port}";
    };
  });

  openrouterEntries = [
    {
      model_name = "openrouter-free";

      litellm_params = {
        model = "openrouter/openrouter/free";
        api_key = "os.environ/OPENROUTER_API_KEY";
      };
    }
  ];

  model_list = openrouterEntries ++ ollamaEntries;

  litellmConfig =
    (pkgs.formats.yaml { }).generate "litellm-config.yaml" {
      inherit model_list;

      extra_body = {
        provider.sort = "throughput";
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
    type = lib.types.listOf lib.types.str;
    default = map (model: model.model_name) model_list;
    description = "LiteLLM model list";
  };

  config = {
    home.packages = [
      pkgs.litellm
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
