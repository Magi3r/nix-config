{
  den,
  inputs,
  lib,
  __findFile,
  ...
}: {
  flake-file.inputs = {
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects."farum-azula" = {
    # host NixOS configuration
    nixos = {...}: {
      imports = [
        inputs.disko.nixosModules.disko
        ./_hosts/farum-azula/disko.nix
        ./_hosts/farum-azula/hardware-configuration.nix
      ];

      networking.domain = "new.magi3r.de";

      # Webtropia static point-to-point network configuration
      networking.useNetworkd = true;
      networking.networkmanager.enable = lib.mkForce false;

      # 1. Fast in-memory compressed swap for minor spikes
      zramSwap = {
        enable = true;
        priority = 100;
        memoryPercent = 25; # ~2 GiB zram device
      };

      # 2. SSD swapfile as the ultimate safety net
      swapDevices = [
        {
          device = "/var/lib/swapfile";
          size = 6 * 1024; # 6 GiB
          priority = 10;
        }
      ];

      # Dont use swap if not nessecary
      boot.kernel.sysctl = {
        "vm.swappiness" = 10;
      };

      systemd.network = {
        enable = true;
        networks."10-wan" = {
          matchConfig.Name = "en* eth*";
          address = [
            "89.163.214.203/32"
            "2001:4ba0:cafe:281::1/128"
          ];
          routes = [
            {
              Gateway = "169.254.1.1";
              GatewayOnLink = true;
            }
            {
              Gateway = "fe80::1";
              GatewayOnLink = true;
            }
          ];
          dns = [
            "62.141.32.3"
            "62.141.32.4"
            "1.1.1.1"
          ];
        };
      };
    };

    includes = [
      <bootloader/grub>
      <ssh>
      <wubbaboo>
      <builder>

      <services/caddy>
      <services/anno-domini>
      <services/headscale>
      <services/minecraft>
      <services/bentopdf>
      <services/datefinder-bot>
      <services/webdav>
      <services/foundryvtt>
      <services/yuzu-room>
    ];
  };
}
