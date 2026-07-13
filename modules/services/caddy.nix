{
  den.aspects.services.caddy = {
    pkgs,
    lib,
    ...
  }: {
    flake-file.inputs = {
      alloc.url = "github:Aleksanaa/alloc.nix";
    };

    # allocates ports from 30000-30999
    # Syntax for using:
    # # { config, lib, ... }:
    # # {
    # #   alloc.ports = {
    # #     start = 1;
    # #     interval = 65535;
    # #     blocks = {
    # #       someService = {
    # #         length = 10;
    # #       };
    # #       anotherService = {
    # #         start = 1714;
    # #         length = 50;
    # #       };
    # #       someOtherService = {
    # #         start = 8;
    # #         length = 6;
    # #       };
    # #     };
    # #   };
    # #   b = config.alloc.ports.blocks.someService.start;
    # # }


    nixos = {config, ...}: {
      alloc.ports = {
        start = 30000;
        interval = 1000;
      };
      sops.secrets.caddy_env = {};

      services.caddy = {
        enable = true;

        package = pkgs.caddy.withPlugins {
          plugins = [
            "github.com/caddy-dns/cloudflare"
          ];

          hash = lib.fakeHash;
        };
        environmentFile = config.sops.secrets.caddy_env.path;

        email = "jvd@outlook.de";

        virtualHosts."*.local.magi3r.de".extraConfig = ''
          tls {
            dns cloudflare {env.CF_TOKEN}
          }
        '';
      };
    };
  };
}
