{ pkgs, ... }: {
  programs._1password-gui = {
    enable = true;
    package = pkgs._1password-gui;
    polkitPolicyOwners = [ "hallayus" ];
  };
}
