{ pkgs, ... }:
let
  obsidian_pkg = with pkgs; appimageTools.wrapType2
    ({
      # or wrapType1
      name = "obsidian";
      src = fetchurl {
        sha256 = "sha256-Bf5IUjM1oX6gGlwXExAdsvEFPYMKXkKLnBFdmhvYCcU=";
        url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.6.7/Obsidian-1.6.7.AppImage";
      };
    });
in
{
  environment.systemPackages = [
    obsidian_pkg
  ];
}

