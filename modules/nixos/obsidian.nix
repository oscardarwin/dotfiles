{ pkgs, ... }:
let
  obsidian_pkg = with pkgs; appimageTools.wrapType2
    ({
      # or wrapType1
      name = "obsidian";
      src = fetchurl {
        sha256 = "sha256-B4sz3cZSdm391x5vGjM60uWxusFb2EVGVeRv+aDisCE=";
        url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/Obsidian-1.5.3.AppImage";
      };
    });
in
{
  environment.systemPackages = [
    obsidian_pkg
  ];
}

