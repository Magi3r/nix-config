{den, ...}: {
  den.aspects.services.taskchampion = {host, ...}: {
    nixos = {config, ...}: let
      url = "tasks.${config.networking.domain}";
      port = config.alloc.ports.blocks.taskchampion.start;
    in {
      alloc.ports.blocks.taskchampion = {};
      sops.secrets."taskwarrior/client_id" = {};

      # Render the environment file required by taskchampion-sync-server
      sops.templates."taskchampion.env".content = ''
        CLIENT_ID=${config.sops.placeholder."taskwarrior/client_id"}
      '';

      services.taskchampion-sync-server = {
        enable = true;
        port = port;
        allowClientIds = [];
      };
      systemd.services.taskchampion-sync-server.serviceConfig.EnvironmentFile =
        config.sops.templates."taskchampion.env".path;

      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };
}
