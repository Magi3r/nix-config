{inputs,...}:{
  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  imports = [
    inputs.noctalia.homeModules.default
  ]

  programs.noctalia-shell = {
    enable = true;
}
  }

}
