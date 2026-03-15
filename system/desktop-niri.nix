{ pkgs, ... }:
{

  services = {
    # login manager
    displayManager.defaultSession = "niri";
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
  programs.niri.enable = true;

}
