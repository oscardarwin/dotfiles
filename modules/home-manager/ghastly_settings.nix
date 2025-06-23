{ pkgs, ... }: {
  programs = {
    fish = {
      shellAliases = {
        black = "poetry run black --config ../black_config/pyproject.toml";
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
      userName = "oscar.darwin@understand.ai";
      userEmail = "oscar.darwin@understand.ai";
    };

    ssh.matchBlocks."gitlab.com" = {
      hostname = "gitlab.com";
      identityFile = "~/.ssh/id_ed25519";
      forwardAgent = true;
    };

  };
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "auto-allocate-uids"
  ];
}
