{ pkgs, lib, osConfig, ... }:

let
  port = "8080";


  ollamaModels = osConfig.services.ollama.loadModels or [ ];

  ollamaEntries = lib.forEach ollamaModels (model: {
    model_name = model;

    litellm_params = {
      model = "ollama/${model}";
      api_base = "http://127.0.0.1:${osConfig.services.ollama.port}";
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

  litellmConfig =
    (pkgs.formats.yaml { }).generate "litellm-config.yaml" {
      model_list =
        openrouterEntries
        ++ ollamaEntries;

      extra_body = {
        provider.sort = "throughput";
      };
    };

in
{
  home.packages = [
    pkgs.litellm
  ];

  options.my.litellm.port = lib.mkOption {
    type = lib.types.port;
    default = 8080;
    description = "LiteLLM proxy port";
  };

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
        "${pkgs.litellm}/bin/litellm --config ${litellmConfig} --port ${port}";

      EnvironmentFile =
        osConfig.clan.core.vars.generators.litellm.files.openrouter_api_key_env.path;

      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

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
