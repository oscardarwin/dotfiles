{ pkgs, lib, config, inputs, ... }:

let
  colors = config.lib.stylix.colors;

  servicesScriptDerivation = pkgs.rustPlatform.buildRustPackage {
    pname = "check-services-statuses";
    version = "1.0.0";
    src = ./check_services;
    cargoLock.lockFile = ./check_services/Cargo.lock;
  };

  servicesScript = "${servicesScriptDerivation}/bin/check-services-statuses";

  pcoClientPackage = inputs.pco.packages.${pkgs.system}.pco-client;
  contextsScript = "${pcoClientPackage}/bin/client";

  ewwYuck = builtins.readFile ./eww.yuck;
  ewwScss = builtins.readFile ./eww.scss;
in
{
  xdg.configFile."eww/eww.yuck".text = builtins.replaceStrings [
    "@pco-client"
    "@check-services"
    "@date"
  ] [
    "${contextsScript}"
    "${servicesScript}"
    "${pkgs.coreutils}/bin/date"
  ]
    ewwYuck;

  xdg.configFile."eww/eww.scss".text = builtins.readFile ./eww.scss;

  home.packages = with pkgs; [
    pamixer
    pavucontrol
    jq
    coreutils
    procps
    gnugrep
    gawk
    networkmanager
    eww
  ];

  wayland.windowManager.sway.extraConfig = ''
    exec_always --no-startup-id /bin/sh -c "${pkgs.eww}/bin/eww daemon && until ${pkgs.eww}/bin/eww ping; do sleep 1; done && ${pkgs.eww}/bin/eww open bar"
  '';
}
  








