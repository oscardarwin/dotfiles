{ config, lib, ... }:

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
  '';
in
{
  programs.waybar = {
    enable = true;
    settings.mainBar = lib.importJSON ./waybar-config.json;
    style = lib.mkForce css; # Use the inline string instead of a file
  };
}






