{ ... }: {
  services.openssh = {
    enable = true;
    passwordAuthentication = true;
  };
}
