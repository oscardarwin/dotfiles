{
  services.matrix-tuwunel = {
    enable = true;

    user = "tuwunel";
    group = "tuwunel";

    stateDirectory = "matrix-tuwunel";

    settings.global = {
      server_name = "matrix.example.com";
      address = "127.0.0.1";
      port = 8008;

      allow_registration = false;
      allow_federation = true;
      allow_encryption = true;

      trusted_servers = [ "matrix.org" ];

      max_request_size = 50000000;
    };
  };

  services.nginx = {
    enable = true;

    recommendedTlsSettings = true;
    recommendedProxySettings = true;

    virtualHosts."matrix.example.com" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:8008";
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "TODO";
  };

  services.mautrix-whatsapp = {
    enable = true;

    settings = {
      homeserver = {
        address = "http://127.0.0.1:8008";
        domain = "matrix.example.com";
      };

      appservice = {
        address = "http://127.0.0.1:29318";
        hostname = "127.0.0.1";
        port = 29318;

        database = {
          type = "sqlite3";
          uri = "file:/var/lib/mautrix-whatsapp/mautrix-whatsapp.db?_foreign_keys=on";
        };
      };

      bridge = {
        encryption = {
          allow = true;
          default = true;
        };
      };
    };
  };
}
