{
  inputs,
  ...
}: {
  flake-file.inputs = {
    alloc.url = "github:Aleksanaa/alloc.nix";
  };
  den.aspects.services.caddy = {
    host,
    ...
  }: {

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


    nixos = {
      config,
      pkgs,
      lib,
      ...
    }: {
      imports = [
        (inputs.alloc.nixosModules.default)
      ];

      alloc.ports = {
        start = 30000;
        interval = 1000;
      };
      sops.secrets.caddy_env = {};

      services.caddy = {
        enable = true;
        openFirewall = true;

        package = pkgs.caddy.withPlugins {
          plugins = [
            "github.com/caddy-dns/cloudflare@v0.2.4"
          ];

          hash = "sha256-PWadA5qr/gR2qDcT8l8u1Xku7LM2HIfWTLOkzezCYy0=";
        };
        environmentFile = config.sops.secrets.caddy_env.path;

        email = "jvd@outlook.de";

        extraConfig = ''
          (cloudflare) {
            tls {
              dns cloudflare {env.CF_TOKEN}
            }
          }
        '';

        # Dynamic wildcard certificate for this host's base domain
        virtualHosts = lib.optionalAttrs (config.networking.domain != null && config.networking.domain != "") {
          "*.${config.networking.domain}".extraConfig = ''
            import cloudflare
          '';
        };
      };
    };
  };
}
