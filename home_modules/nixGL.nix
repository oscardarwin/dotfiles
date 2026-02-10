{ pkgs, inputs, ... }: {

  home.packages = [
    pkgs.hello
    (import inputs.nixGL { inherit pkgs; }).nixGLIntel
  ];
}
