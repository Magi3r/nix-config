{
  pkgs,
  config,
  inputs,
  ...
}: {
  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;
    # package = pkgs.noctalia-shell;
  };

  home.file.".face" = {
    source = ../../../profile-pic.png;
  };
}
