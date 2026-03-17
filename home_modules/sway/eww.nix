{ pkgs, config, lib, inputs, ... }:

let
  cfg = config.modules.eww;
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

  workspaceColor = "3d5773";
  workspaceColorFocused = colorTheme.base0D;
  workspaceColorHovered = colorTheme.base0D;

  contextColor = "785189";
  contextColorFocused = colorTheme.base0E;
  contextColorHovered = colorTheme.base0E;

  healthy = colorTheme.base0B;
  used = colorTheme.base0A;
  warning = colorTheme.base09;
  critical = colorTheme.base08;

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
      border-radius: 2px;
      padding: 4px 8px;
      min-width: 24px;
      font-size: 16px;

      box-shadow: none;
      text-shadow: none;

      color: #${textColor};
    }

    // ===== Context Buttons =====
    .context-button {
      background: #${contextColor};
      &:hover {
        background: #${contextColorHovered};
      }

      &.focused {
        background: #${contextColorFocused};
      }
    }

    // ===== Workspace Buttons =====
    .workspace-button {
      background: #${workspaceColor};

      &:hover {
        background: #${workspaceColorHovered};
      }

      &.focused {
        background: #${workspaceColorFocused};
      }
    }

    // ===== Clock =====
    .clock {
      color: #${textColor};
      font-weight: 500;
    }


    // ===== Resources =====
    .resource-icon {
      font-size: 1.4em;
      color: #${textColor};
    }

    .resource-high {
      color: #${healthy};
    }
    
    .resource-medium {
      color: #${used};
    }
    
    .resource-low {
      color: #${warning};
    }
    
    .resource-critical {
      color: #${critical};
    }

    .system-on {
      color: #${colorTheme.base0C};
    }
    
    .system-off {
      color: #${colorTheme.base05};
    }

    tooltip {
      background-color: #${colorTheme.base04};
      border: 1px solid #${colorTheme.base07};
    }
    
    tooltip label {
      color: #${textColor};
    }
  '';
in
{
  options.modules.eww = {
    networkInterface = lib.mkOption {
      type = lib.types.str;
      default = "eth0";
      description = "Network interface to monitor";
    };

    battery = lib.mkOption {
      type = lib.types.str;
      default = "BAT0";
      description = "Battery device name";
    };
  };

  config = {
    xdg.configFile."eww/eww.yuck".text = builtins.replaceStrings [
      "@pco-client"
      "@check-services"
      "@date"
      "@nmcli"
      "@battery"
      "@networkinterface"
    ] [
      "${contextsScript}"
      "${servicesScript}"
      "${pkgs.coreutils}/bin/date"
      "${pkgs.networkmanager}/bin/nmcli"
      cfg.battery
      cfg.networkInterface
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
  };
}
  








