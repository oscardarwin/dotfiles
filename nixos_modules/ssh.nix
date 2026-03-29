{ ... }: {
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "prohibit-password";
  };
}
