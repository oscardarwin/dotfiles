{ stylix, importHomeModules, ... }: {
  homeModules = importHomeModules [
    "chrome.nix"
    "nixGL.nix"

    "fonts.nix"
    "firefox.nix"
    "git.nix"
    "sway"
    "nixvim"
    "shell.nix"
    "terminal.nix"
    "screen.nix"
    "qutebrowser"
    "packages.nix"
    "stylix.nix"
    "wofi.nix"
  ] ++ [
    stylix.homeModules.stylix
    {
      wayland.windowManager.sway.config.output = {
        "DP-1" = {
          position = "0 -1440";
        };
        "eDP-1" = {
          position = "0 0";
        };
      };
    }
  ];

  config = { pkgs, lib, ... }: {
    home = {
      packages = [
        pkgs.slack
        pkgs.vscode
        pkgs.openconnect
      ];
      username = "oscar";
      homeDirectory = "/home/oscar";
      stateVersion = "23.11";
    };

    modules.eww = {
      networkInterface = "wlp0s20f3";
      battery = "BAT0";
    };
    programs = {
      home-manager.enable = true;
      fish = {
        shellAliases = {
          bl = "poetry run black --config ../black_config/pyproject.toml";
          mypy = "mypy --config-file ~/configs/mypy-config/mypy_strict.ini";
          ruff = "poetry run ruff check --fix .";
          login_prod = "uai_dev_login --environment_name=PRODUCTION";
          login_stage = "uai_dev_login --environment_name=STAGING";
        };
        shellInitLast = ''
          set -x PYENV_ROOT $HOME/.pyenv

          if test -d "$PYENV_ROOT/bin"
              set -x PATH $PYENV_ROOT/bin $PATH
          end

          status --is-interactive; and pyenv init - | source
          status --is-interactive; and pyenv virtualenv-init - | source
        '';
      };

      ssh.matchBlocks."gitlab.com" = {
        hostname = "gitlab.com";
        identityFile = "~/.ssh/uai_gitlab_oscar";
        forwardAgent = true;
      };

      pco-sway = {
        setWorkspaceKeybindings = {
          "w" = lib.mkForce {
            workspaceName = "web";
            executable = "${pkgs.chromium}/bin/chromium";
          };
          "c" = lib.mkForce {
            workspaceName = "chat";
            executable = "${pkgs.slack}/bin/slack";
          };
        };
      };

    };
    nix.package = pkgs.nix;

    programs.nixvim.plugins.conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          python = [ "virtual-env-black" ];
        };
        formatters = {
          virtual-env-black = {
            command = "poetry";
            args = [ "run" "black" "--quiet" "--config" "../black_config/pyproject.toml" "-" ];
            stdin = true;
          };
        };
      };
    };
  };
}
