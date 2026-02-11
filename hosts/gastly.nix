{ stylix, importHomeModules, ... }: {
  homeModules = importHomeModules [
    "uai-keybindings.nix"
    "chrome.nix"
    "nixGL.nix"

    "fonts.nix"
    "firefox.nix"
    "git.nix"
    "window-manager"
    "nixvim"
    "startup.nix"
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
      home.username = "oscar";
      home.homeDirectory = "/home/oscar";
      home.stateVersion = "23.11";
      programs.home-manager.enable = true;
    }
  ];

  config = { pkgs, lib, ... }: {
    home.packages = [
      pkgs.slack
      pkgs.vscode
      pkgs.openconnect
    ];
    programs = {
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

      git = {
        userName = lib.mkForce null;
        userEmail = lib.mkForce null;
      };

      ssh.matchBlocks."gitlab.com" = {
        hostname = "gitlab.com";
        identityFile = "~/.ssh/uai_gitlab_oscar";
        forwardAgent = true;
      };

    };
    nix.package = pkgs.nix;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
      "auto-allocate-uids"
    ];

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
