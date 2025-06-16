{ pkgs, ... }: {
  programs = {
    fish = {
      shellAliases = {
        black = "poetry run black --config ../black_config/pyproject.toml";
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
  };
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "auto-allocate-uids"
  ];
}
