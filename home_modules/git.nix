{ ... }: {
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      settings.user = {
        name = "oscardarwin";
        email = "6627886+oscardarwin@users.noreply.github.com";
      };
    };
    lazygit = {
      enable = true;
      settings = {
        customCommands = [{
          key = "c";
          context = "files";
          prompts = [
            {
              type = "menu";
              title = "semantic context?";
              key = "prefix";
              options = [
                {
                  name = "feat";
                  description = "increase minor version";
                  value = "feat";
                }
                {
                  name = "fix";
                  description = "increase bugfix version";
                  value = "fix";
                }
                {
                  name = "chore";
                  description = "hidden change";
                  value = "chore";
                }
                {
                  name = "build";
                  description = "change affecting build";
                  value = "build";
                }
                {
                  name = "ci";
                  description = "change affecting ci";
                  value = "ci";
                }
                {
                  name = "docs";
                  description = "change affecting docs";
                  value = "docs";
                }
                {
                  name = "style";
                  description = "change affecting styling";
                  value = "style";
                }
                {
                  name = "refactor";
                  description = "change affecting refactoring";
                  value = "refactor";
                }
                {
                  name = "perf";
                  description = "change affecting performance";
                  value = "perf";
                }
                {
                  name = "test";
                  description = "change affecting tests";
                  value = "test";
                }
              ];
            }
            {
              type = "menu";
              title = "breaking change?";
              key = "breaking";
              options = [
                {
                  name = "no breaking change";
                  description = "this is a normal change";
                  value = "";
                }
                {
                  name = "breaking change";
                  description = "this is a breaking change";
                  value = "!";
                }
              ];
            }
            {
              type = "input";
              title = "commit message";
              key = "commitMessage";
              initialValue = "";
            }
          ];
          command = "git commit -m '{{.Form.prefix}}{{.Form.breaking}}: {{.Form.commitMessage}}'";
          loadingText = "creating commit";
        }];
      };
    };
  };

}
