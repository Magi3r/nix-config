{
  den.aspects.services.caddy = {
    pkgs,
    lib,
    ...
  }: {
    nixos = {config, ...}: {
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
