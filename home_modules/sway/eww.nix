{ pkgs, lib, config, inputs, ... }:

let
  colorTheme = config.lib.stylix.colors;

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

  workspaceColor = "4c769b";
  workspaceColorFocused = colorTheme.base0D;
  workspaceColorHovered = "45637f";

  contextColor = "8b5655";
  contextColorFocused = colorTheme.base0F;
  contextColorHovered = "695a52";

  textColor = colorTheme.base07;
  ewwScss = ''
    // ===== Base Bar =====
    .bar {
      background-color: #${colorTheme.base00};
      padding: 0 8px;
      font-family: sans-serif;
      font-size: 14px;
    }

    // ===== Shared Button Styling =====
    button {
      border: none;
      border-radius: 4px;
      padding: 4px 8px;
      min-width: 24px;
      color: #${textColor};
    }

    // ===== Context Buttons =====
    .context-button {
      background-color: #${contextColor};

      &:hover {
        background-color: #${contextColorHovered};
      }

      &.focused {
        background-color: #${contextColorFocused};
      }
    }

    // ===== Workspace Buttons =====
    .workspace-button {
      background-color: #${workspaceColor};

      &:hover {
        background-color: #${workspaceColorHovered};
      }

      &.focused {
        background-color: #${workspaceColorFocused};
      }
    }

    // ===== Clock =====
    .clock {
      color: #${textColor};
      font-weight: 500;
    }

    // ===== Battery =====
    .battery {
      color: #${textColor};
    }
  '';
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

  xdg.configFile."eww/eww.scss".text = ewwScss;

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
  








