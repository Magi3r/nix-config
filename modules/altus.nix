{
  den,
  inputs,
  lib,
  __findFile,
  ...
}: {
  flake-file.inputs = {
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi";
    # nixpkgs.follows = "nixos-raspberrypi/nixpkgs";
  };
  flake-file.nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nixos-raspberrypi.cachix.org"
      "https://aarch64.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      "aarch64.cachix.org-1:a0n4cFNfZSaWSdPd5sqWTkpWYgWJHR8Ip2eVpDjP0PA="
    ];
  };

  den.hosts.aarch64-linux.altus = {
    instantiate = {modules, ...}:
      inputs.nixos-raspberrypi.lib.nixosSystem {
        inherit modules;
        specialArgs = {
          inherit (inputs) nixos-raspberrypi;
        };
      };
  };

  den.aspects.altus = {
    nixos = {
      config,
      lib,
      ...
    }: {
      # IMPORTANT: Raspberrypi settings. DO NOT EDIT!
      imports = with inputs.nixos-raspberrypi.nixosModules; [
        raspberry-pi-5.base
        raspberry-pi-5.display-vc4
        raspberry-pi-5.page-size-16k
        ./_hosts/altus/hardware-configuration.nix
      ];
      boot.loader.raspberry-pi.bootloader = "kernel";

      system.nixos.tags = let
        cfg = config.boot.loader.raspberry-pi;
      in [
        "raspberry-pi-${cfg.variant}"
        cfg.bootloader
        config.boot.kernelPackages.kernel.version
      ];

      services.udev.extraRules = ''
        # Ignore partitions with "Required Partition" GPT partition attribute
        # On our RPis this is firmware (/boot/firmware) partition
        ENV{ID_PART_ENTRY_SCHEME}=="gpt", \
          ENV{ID_PART_ENTRY_FLAGS}=="0x1", \
          ENV{UDISKS_IGNORE}="1"
      '';
      nixpkgs.overlays = [
        (final: prev: {
          bat = prev.bat.overrideAttrs (_: {doCheck = false;});
          fish = prev.fish.overrideAttrs (_: {doCheck = false;});
        })
      ];
      # ============================================================
      # TODO: Add config below this
      services.openssh.enable = true;
    };
    includes = [
      <wubbaboo>
      <services/caddy>
      <services/adguard>
      <services/searxng>
+     <services/ntfy>
    ];
  };
}
