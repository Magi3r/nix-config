# TODO add descriptive comments
{ pkgs, inputs, lib, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-intel
    # inputs.hardware.nixosModules.common-ssd

    # Import your generated (nixos-generate-config) hardware configuration
    ../hosts/limgrave/hardware-configuration.nix

    # You can also split up your configuration and import pieces of it here:
    ./base.nix
    ../system/audio.nix
    ../system/bluetooth.nix

    ../system/desktop-niri.nix
    ../system/services.nix
    # ../system/virtualisation.nix
  ];


  console.keyMap = lib.mkForce "us";

  networking.hostName = "limgrave";
}
