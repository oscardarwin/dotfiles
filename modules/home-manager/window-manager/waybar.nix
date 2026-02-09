{ pkgs, config, lib, ... }:

let
  colors = config.lib.stylix.colors;
  css = ''
    * {
      font-size: 12px;
      font-family: "FiraCode Nerd Font", "Symbols Nerd Font", sans-serif;
    }
    window#waybar {
      background: #${colors.base00};
      color: #${colors.base05};
    }

    #workspaces button.focused {
      color: #${colors.base0D};
    }

    #workspaces button:hover {
      background: #${colors.base02};
      border: #${colors.base02};
    }

    #custom-separator {
    	color: #${colors.base00};
    }
    
    #workspaces,
    #clock,
    #pulseaudio,
    #memory,
    #cpu,
    #battery,
    #disk,
    #network,
    #workspaces button {
      border-radius: 0;
      background: #${colors.base00};
      color: #${colors.base05};
      padding: 0 2px;
      margin: 0 2px;
    }
    
    #pulseaudio {
    	color: #${colors.base0D};
    }
    #memory {
    	color: #${colors.base0E};
    }
    #memory.warning {
      color: #${colors.base08}; 
    }
    #cpu {
      color: #${colors.base09};
    }
    #battery {
    	color: #${colors.base0B};
    }
    #disk {
    	color: #${colors.base0A};
    }
    #network {
    	color: #${colors.base0C};
    }
    
    #clock,
    #pulseaudio,
    #memory,
    #cpu,
    #battery,
    #disk,
    #network {
    	padding: 0 10px;
    }
    
    #clock:hover,
    #pulseaudio:hover,
    #memory:hover,
    #cpu:hover,
    #battery:hover,
    #disk:hover,
    #network:hover {
      background: #${colors.base02};
    }
    #custom-services.ok {
      color: #a6e3a1; /* green */
    }
    
    #custom-services.warning {
      color: #f9e2af; /* yellow */
    }
    
    #custom-services.critical {
      color: #f38ba8; /* red */
    }
  '';

  servicesScript = pkgs.writeShellScript "check-services-statuses" ''
    #!/usr/bin/env sh
    set -eu

    # Print store path for debugging (stderr so Waybar ignores it)
    echo "Running from store path: $0" >&2

    # List of user services to monitor
    SERVICES="
    pipewire.service
    wireplumber.service
    swayidle.service
    keyboard-monitor.service
    "

    bad=0
    warn=0
    tooltip="Service status:\\n"

    for svc in $SERVICES; do
      # Get relevant systemd properties, tolerate failures
      props=$(systemctl --user show "$svc" \
        --property=ActiveState,SubState,NRestarts,Result --no-pager || true)

      # Evaluate properties safely
      eval "$props" || true

      # Ensure NRestarts is always numeric
      nrestarts=0
      if [ -n "${NRestarts:-}" ] && [ "${NRestarts:-0}" -eq "${NRestarts:-0}" ] 2>/dev/null; then
        nrestarts=$NRestarts
      fi

      # Build tooltip (escape newlines for JSON)
      tooltip="$tooltip$svc:\\n"
      tooltip="$tooltip  ActiveState=$ActiveState\\n"
      tooltip="$tooltip  SubState=$SubState\\n"
      tooltip="$tooltip  Restarts=$nrestarts\\n"

      # Warning if not active
      if [ "$ActiveState" != "active" ]; then
        warn=1
      fi

      # Critical if restart count too high or failed to start
      if [ "$nrestarts" -ge 5 ] || [ "$Result" = "start-limit-hit" ]; then
        bad=1
      fi
    done

    # Determine icon and class
    if [ "$bad" -eq 1 ]; then
      class="critical"
      icon=""
    elif [ "$warn" -eq 1 ]; then
      class="warning"
      icon=""
    else
      class="ok"
      icon=""
    fi

    # Output JSON for Waybar
    printf '{ "text": "%s", "class": "%s", "tooltip": "%s" }\n' \
      "$icon" "$class" "$tooltip"
  '';


  mainBar = {
    layer = "top";
    position = "bottom";

    modules-left = [
      "sway/workspaces"
    ];

    modules-center = [
      "clock"
    ];

    modules-right = [
      "custom/services"
      "custom/separator"
      "pulseaudio"
      "custom/separator"
      "memory"
      "custom/separator"
      "cpu"
      "custom/separator"
      "disk"
      "custom/separator"
      "battery"
      "custom/separator"
      "network"
    ];

    "custom/separator" = {
      format = " ";
      tooltip = false;
    };

    "sway/workspaces" = {
      disable-scroll = true;
      format = "{name}";
    };

    clock = {
      format = "{:%H:%M}";
      tooltip = true;
      tooltip-format = "{:%Y-%m-%d %a %I:%M %p}";
    };

    pulseaudio = {
      format = "{icon} {volume:2}%";
      format-bluetooth = "{icon}  {volume}%";
      format-muted = "";
      format-icons = {
        headphones = " ";
        default = [ " " " " ];
      };
      scroll-step = 5;
      on-click = "pamixer -t";
      on-click-right = "pavucontrol";
    };

    memory = {
      interval = 5;
      format = "  {}%";
      states.warning = 90;
    };

    cpu = {
      interval = 5;
      format = " {usage:2}%";
    };

    battery = {
      states = {
        good = 95;
        warning = 30;
        critical = 15;
      };
      format = "{icon}{capacity}%";
      format-icons = [
        "  "
        "  "
        "  "
        "  "
        "  "
      ];
    };

    disk = {
      interval = 5;
      format = "  {percentage_used:2}%";
      path = "/";
    };

    network = {
      interface = "wlp2s0";
      format-wifi = " ";
      format-ethernet = " ";
      format-disconnected = " Disconnected";
      tooltip = true;
      tooltip-format = ''
        SSID: {essid}
        Signal: {signalStrength}%
        IP: {ipaddr}
      '';
    };

    "custom/services" = {
      exec = servicesScript;
      interval = 5;
      return-type = "json";
      tooltip = true;
    };
  };

in
{
  programs.waybar = {
    enable = true;
    settings.mainBar = mainBar;
    style = lib.mkForce css; # Use the inline string instead of a file
  };
}






