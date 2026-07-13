{
  den.aspects.services.immich = {
    pkgs,
    lib,
    ...
  }: let
    url = "immich.local.magi3r.de";
    # port = 8080;
  in {

    nixos = {config, ...}: let
      port = config.alloc.ports.blocks.immich.start;
    in {
      alloc.ports.blocks.immich = {};
      # sops.secrets.immich_env = {};

      services.immich = {
        enable = true;
        accelerationDevices = null;
        port = port;

        # secretsFile = config.sops.secrets.immich_env.path;
      };

      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${port}
      '';
    };
  };
}
