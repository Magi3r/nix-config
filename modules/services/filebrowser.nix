{
  den,
  __findFile,
  inputs,
  ...
}: {
  den.aspects.services.filebrowser = {
    includes = [
      <virtualisation>
    ];

    nixos = {
      config,
      pkgs,
      lib,
      ...
    }: let
      url = "files.${config.networking.domain}";
      port = config.alloc.ports.blocks.filebrowser.start;

      configFile = inputs.self + "/assets/config/filebrowserquantum/config.yaml";
    in {
      alloc.ports.blocks.filebrowser = {};

      systemd.tmpfiles.rules = [
        "d /var/lib/filebrowser 0755 1000 1000 -"
        "d /var/lib/filebrowser/data 0755 1000 1000 -"
        "d /var/lib/filebrowser/srv 0755 1000 1000 -"
      ];

      systemd.services."docker-filebrowser".preStart = lib.mkBefore ''
        cp -f ${configFile} /var/lib/filebrowser/data/config.yaml
        chown 1000:1000 /var/lib/filebrowser/data/config.yaml
        chmod 0644 /var/lib/filebrowser/data/config.yaml
      '';

      virtualisation.oci-containers.containers.filebrowser = {
        image = "gtstef/filebrowser:2.0.7-beta";
        autoStart = true;
        user = "1000:1000";
        ports = [
          "127.0.0.1:${toString port}:80"
        ];
        volumes = [
          "${configFile}:/etc/filebrowser/config.yaml:ro"
          "/var/lib/filebrowser/data:/home/filebrowser/data"
          "/var/lib/filebrowser/srv:/srv/files"
        ];
        environment = {
          FILEBROWSER_CONFIG = "/etc/filebrowser/config.yaml";
          TZ = "Europe/Berlin";
        };
      };

      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };
}
