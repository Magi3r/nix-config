{pkgs, ...}: {
  environment.systemPackages = [pkgs.xwayland-satellite];
  services = {
    # login manager
    displayManager.defaultSession = "niri";
  };

  programs.niri.enable = true;
}
