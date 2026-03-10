{ pkgs, ... }: {

  services = {
    # login manager
    displayManager.defaultSession = "niri";
    displayManager.sddm.enable = "true";
  };
  programs.niri.enable = true;

}
