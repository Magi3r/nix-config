{ pkgs, ... }: {
  # Configure your system-wide user settings (groups, etc), add more users as needed.
  users.mutableUsers = false;
  users.users = {
    # Replace with your username
    wubbaboo = {
      # You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      # initialPassword = "letmein";
      # generated from mkpasswd
      hashedPassword = "$y$j9T$QwRD/qx4a5aw73JUxjgPi/$6qmr8YAhqSKDi4yzNdkjrsdBQ90W3gSjAosu0Nwsn94";
      isNormalUser = true;
      description = "Wubbaboo";
      # openssh.authorizedKeys.keys = [
        # Add your SSH public key(s) here, if you plan on using SSH to connect
      # ];
      # Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "networkmanager" "wheel" ]; # "libvirtd" "kvm" "adbusers" "docker" "i2c"
      packages = [ ];
      shell = pkgs.fish;
    };
  };
}


