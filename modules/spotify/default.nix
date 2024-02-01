{ pkgs, ... }: {
  home-manager.users.hallayus = {
    services.spotifyd = {
      enable = true;
      settings = {
        global = {
          username = "oscar.henry.darwin@gmail.com";
          password_cmd = "op read op://Personal/Spotify/password";
          device_name = "nix";
        };
      };
    };
  };
  environment.systemPackages = [
    pkgs.spotify-tui
  ];
}
