{
  services = {
   xserver = {
      # Enable the X11 windowing system.
      # You can disable this if you're only using the Wayland session.
      enable = true;
      # Configure keymap in X11
      xkb = {
        layout = "de";
        variant = "";
      };
      # Enable touchpad support (enabled default in most desktopManager).
      # libinput.enable = true;
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # openssh = {
    #   enable = true;
    #   settings = {
    #     PasswordAuthentication = false;
    #     PermitRootLogin = "no";
    #     AllowUsers = [ "wubbaboo" ];
    #   };
    # };
  };
}
