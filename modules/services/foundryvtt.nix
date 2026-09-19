{
  den,
  inputs,
  lib,
  __findFile,
  ...
}: {
  den.aspects.services.foundryvtt = {
    includes = [
      <virtualisation>
    ];

    nixos = {
      host,
      config,
      pkgs,
      ...
    }: let
      url = "ttrpg.${config.networking.domain}";
      port = config.alloc.ports.blocks.foundryvtt.start;
    in {
      alloc.ports.blocks.foundryvtt = {};
      systemd.tmpfiles.rules = [
        "d /var/lib/foundry-vtt 0755 root root -"
      ];

      sops.secrets.foundryvtt_env = {};

      virtualisation.oci-containers.containers = {
        foundry = {
          image = "itzfelddy/foundryvtt:14";
          autoStart = true;
          ports = [
            "127.0.0.1:${toString port}:30000"
          ];
          volumes = [
            "/var/lib/foundryvtt:/data"
          ];
          environmentFiles = [
            config.sops.secrets.foundryvtt_env.path
          ];
          environment = {
            TZ = "Europe/Berlin";
          };
        };
      };
      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };
}
