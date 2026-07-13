{
  den.aspects.services.homepage = {
    pkgs,
    lib,
    ...
  }: let
    url = "homepage.local.magi3r.de";
  in {

    nixos = {config, ...}: let
      port = config.alloc.ports.blocks.homepage.start;
    in {
      alloc.ports.blocks.homepage = {};
      services.homepage-dashboard = {
        enable = true;
        port = port;

        widgets = [
          {
            resources = {
              cpu = true;
              disk = "/";
              memory = true;
            };
          }
          {
            search = {
              provider = "duckduckgo";
              target = "_blank";
            };
          }
        ];

        services = [
          {
            "Services" = [
              {
                "Homepage" = {
                  description = "This homepage";
                  href = "https://${url}/";
                };
              }
            ];
          }
        ];
      };

      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${port}
      '';
    };
  };
}
