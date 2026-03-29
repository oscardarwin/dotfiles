{ ... }:
let
  openrouterApiKeyVariableName = "OPENROUTER_API_KEY";
in
{
  services.litellm = {
    enable = true;
    settings = {
      model_list = [
        {
          model_name = "openrouter-free";
          litellm_params = {
            model = "openrouter/free:exacto";
            api_key = "os.environ/${openrouterApiKeyVariableName}";
            api_base = "https://openrouter.ai/api/v1";
          };
        }
      ];
    };
  };
}
