{
  den.aspects.services.searxng = {
    pkgs,
    lib,
    ...
  }: let
    url = "homepage.local.magi3r.de";
    # port = 8080;
  in {
    alloc.ports.blocks.searxng = {};

    nixos = {config, ...}: let
      port = config.alloc.ports.blocks.searxng.start;
    in {
      sops.secrets.searxng_env = {};
      services.searx = {
        enable = true;
        domain = url;
        environmentFile = config.sops.secrets.searxng_env.path;
        settings = {
          use_default_settings = {
            engines.remove = [
              "wikidata"
            ];

            server.port = "${port}";
            server.secret_key = "$SECRET_KEY";
          };
        };
      };
    };
  };
}
