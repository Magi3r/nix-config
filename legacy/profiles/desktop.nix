# TODO add descriptive comments
{ pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # Import your generated (nixos-generate-config) hardware configuration
    ../hosts/desktop/hardware-configuration.nix

    # You can also split up your configuration and import pieces of it here:
    ./base.nix
    ../system/audio.nix
    ../system/bluetooth.nix

    ../system/desktop.nix
    # ../system/nvidia.nix
    ../system/services.nix
    # ../system/virtualisation.nix
  ];

  networking.hostName = "desktop"; # FIXME replace with real hostname
}
