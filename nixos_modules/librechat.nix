# librechat.nix — NixOS module
#
# Pairs with your home-manager litellm.nix. Because services.librechat is a
# system service it can't read HM options directly, so my.litellm.port is
# re-declared here at the NixOS level. Set it to the same value in both
# places, or pull both into a shared `let port = 8080;` in your flake.
{ pkgs, lib, config, ... }:
let
  # Mirror the model list derivation from your HM litellm module so the
  # LibreChat endpoint default list stays in sync with what LiteLLM serves.
  ollamaModels = config.services.ollama.loadModels or [ ];

  openrouterModelNames = [ "openrouter-free" ];

  # LiteLLM exposes models under the model_name you gave them, so these
  # match the model_name values in your litellm config.
  allModelNames = openrouterModelNames ++ ollamaModels;

  litellmPort = config.my.litellm.port;
  litellmBaseURL = "http://127.0.0.1:${toString litellmPort}/v1";
in
{
  options.my.litellm.port = lib.mkOption {
    type = lib.types.port;
    default = 8080;
    description = ''
      LiteLLM proxy port. Must match the value set in your home-manager
      litellm.nix (options.my.litellm.port). Keep these in sync.
    '';
  };

  config = {
    clan.core.vars.generators.librechat = {
      # openssl is needed for generating secrets
      runtimeInputs = [ pkgs.openssl ];

      prompts.openrouter_api_key = {
        description = "OpenRouter API key for LibreChat (starts with sk-or-...)";
        type = "hidden";
        # The raw key is only used during generation; it is not stored.
        persist = false;
      };

      files.env = {
        # This file contains secrets, so it is encrypted at rest via your
        # configured clan backend (sops or password-store) and deployed to
        # the machine at activation time.
        secret = true;
        # The librechat systemd service needs to read this file.
        owner = "librechat";
      };

      script = ''
        # Generate all required LibreChat cryptographic secrets.
        # These are written once and stay stable across deployments
        # unless you explicitly re-run the generator with --regenerate.
        CREDS_KEY=$(openssl rand -hex 32)
        CREDS_IV=$(openssl rand -hex 16)
        JWT_SECRET=$(openssl rand -hex 32)
        JWT_REFRESH_SECRET=$(openssl rand -hex 32)

        # Read the prompted OpenRouter key.
        OPENROUTER_API_KEY=$(cat $prompts/openrouter_api_key)

        # Write the single env file that credentialsFile points to.
        # Each line is KEY=value — no quoting, no export, no comments.
        cat > $out/env <<EOF
        CREDS_KEY=$CREDS_KEY
        CREDS_IV=$CREDS_IV
        JWT_SECRET=$JWT_SECRET
        JWT_REFRESH_SECRET=$JWT_REFRESH_SECRET
        MONGO_URI=mongodb://127.0.0.1:27017/LibreChat
        OPENROUTER_API_KEY=$OPENROUTER_API_KEY
        ALLOW_REGISTRATION=false
        EOF
      '';
    };
    # LibreChat requires MongoDB for chat history and user storage.
    services.mongodb.enable = true;

    services.librechat = {
      enable = true;

      # Secrets file — must contain at minimum:
      #   CREDS_KEY=<64 hex chars>    (openssl rand -hex 32)
      #   CREDS_IV=<32 hex chars>     (openssl rand -hex 16)
      #   JWT_SECRET=<random>
      #   JWT_REFRESH_SECRET=<random>
      #   MONGO_URI=mongodb://127.0.0.1:27017/LibreChat
      #
      # If you add ALLOW_REGISTRATION=false here too, only you can sign up.
      credentialsFile =
        config.clan.core.vars.generators.librechat.files.env.path;

      settings = {
        version = "1.0.8";
        cache = true;

        # Disable the built-in OpenAI/Anthropic/etc. endpoints so only
        # LiteLLM shows up in the model picker.
        endpoints = {
          openAI = {
            # Setting apiKey to an empty placeholder effectively disables it
            # without hiding the endpoint entirely; set disabled = true if you
            # want it gone from the UI.
            disabled = true;
          };
          anthropic.disabled = true;
          google.disabled = true;

          custom = [
            {
              # Any OpenAI-compatible endpoint appears here. LiteLLM speaks
              # the OpenAI API, so no special handling is needed.
              name = "LiteLLM";

              # LiteLLM doesn't enforce auth by default on localhost. If you
              # add a master_key to your litellm config, put it in the
              # credentialsFile above as LITELLM_API_KEY and reference it
              # here as "\${LITELLM_API_KEY}".
              apiKey = "litellm";

              baseURL = litellmBaseURL;

              models = {
                # Static fallback list, derived from the same sources as your
                # HM litellm config so they stay consistent.
                default = allModelNames;
                # fetch = true tells LibreChat to also call GET /v1/models on
                # startup and merge any additional models LiteLLM reports.
                fetch = true;
              };

              # Use the first model for auto-titling conversations.
              titleConvo = true;
              titleModel = builtins.head allModelNames;

              modelDisplayLabel = "LiteLLM";

              # Pass through all parameters LiteLLM and your backends accept.
              # Drop ones that cause issues with specific providers.
              dropParams = [ ];
            }
          ];
        };

        # Optional: make the interface a bit cleaner for a personal setup.
        interface = {
          # Hide the model selector header label since everything goes via
          # LiteLLM anyway and the endpoint name already says "LiteLLM".
          endpointsMenu = true;
          modelSelect = true;
          parameters = true;
          sidePanel = true;
          presets = true;
        };
      };
    };
  };
}
