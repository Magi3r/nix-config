# TODO add descriptive comments
{
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # Import your generated (nixos-generate-config) hardware configuration
    ../hosts/server/hardware-configuration.nix

    # You can also split up your configuration and import pieces of it here:
    ./base.nix

    # ../system/virtualisation.nix
  ];

  networking.hostName = "nixos-server"; # FIXME replace with real hostname
}
