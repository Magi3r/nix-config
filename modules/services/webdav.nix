{den, ...}: {
  den.aspects.services.webdav = {host, ...}: {
    nixos = {config, ...}: let
      url = "webdav.${config.networking.domain}";
      port = config.alloc.ports.blocks.webdav.start;
    in {
      alloc.ports.blocks.webdav = {};
      sops.secrets.webdav_env = {};

      systemd.tmpfiles.rules = [
        "d /var/lib/minecraft/e2ee 0600 root root -"
      ];

      services.webdav = {
        enable = true;
        environmentFile = config.sops.secrets.webdav_env.path;
        settings = {
          address = "127.0.0.1";
          port = port;
          behindProxy = true;
          directory = "/var/lib/webdav";
          permissions = "";
          users = [
            {
              username = "{env}ENV_USERNAME";
              password = "{env}ENV_PASSWORD";
              permissions = "CRUD";
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
