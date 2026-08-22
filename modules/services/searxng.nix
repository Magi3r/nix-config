{
  den.aspects.services.searxng = {
    host,
    ...
  }: let
    url = "searxng.remote.magi3r.de";
    # port = 8080;
  in {

    nixos = {config, ...}: let
      port = config.alloc.ports.blocks.searxng.start;
    in {
      alloc.ports.blocks.searxng = {};
      sops.secrets.searxng_env = {};
      services.searx = {
        enable = true;
        domain = url;
        environmentFile = config.sops.secrets.searxng_env.path;
        settings = {
          use_default_settings = true;
          server = {
            port = port;
            secret_key = "@SECRET_KEY@";
          };
          engines = [
            {
              name = "wikidata";
              engine = "wikidata";
              disabled = true;
            }
          ];
        };
      };

      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };
}
