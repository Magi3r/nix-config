{
  den.aspects.services.homepage = {
    pkgs,
    lib,
    ...
  }: let
    url = "homepage.local.magi3r.de";
  in {
    nixos = {config, ...}:{
      services.homepage-dashboard = {
        enable = true;

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
        reverse_proxy localhost:${config.homepage-dashboard.port}
      '';
    };

    networking.firewall = {
      allowedTCPPorts = [
        53
      ];

      allowedUDPPorts = [
        53
      ];
    };
  };
}
