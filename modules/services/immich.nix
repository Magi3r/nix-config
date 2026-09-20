{
  den.aspects.services.immich = {host, inputs, ...}: let
    url = "immich.local.magi3r.de";
    # port = 8080;
  in {
    nixos = {config, pkgs, ...}: let
      port = config.alloc.ports.blocks.immich.start;
    in {
      alloc.ports.blocks.immich = {};
      # sops.secrets.immich_env = {};


      # !NOTE: Current stable immich has know security vulnerabilites, so opting in to unstable for now.
      # 1. Disable the stable Immich module
      disabledModules = [ "services/web-apps/immich.nix" ];

      # 2. Import the module from nixos-unstable
      imports = [
        "${inputs.nixpkgs-unstable}/nixos/modules/services/web-apps/immich.nix"
      ];

      services.immich = {
        enable = true;
        accelerationDevices = null;
        port = port;
        # 3. Supply the unstable package
        package = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.immich;

        # secretsFile = config.sops.secrets.immich_env.path;
      };

      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };
}
