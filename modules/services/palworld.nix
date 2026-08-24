{
  den,
  __findFile,
  ...
}: {
  den.aspects.services.palworld = {
    includes = [
      <virtualisation>
    ];

    nixos = {
      config,
      pkgs,
      lib,
      ...
    }: {
      # Enable compressed in-memory swap to protect against memory leaks and OOM crashes
      zramSwap = {
        enable = true;
        memoryPercent = 50;
        algorithm = "zstd";
      };
      sops.secrets.palworld_env = {};


      systemd.tmpfiles.rules = [
        "d /var/lib/palworld 0777 root root -"
      ];
      systemd.services."docker-palworld".serviceConfig.Restart = lib.mkForce "always";

      virtualisation.oci-containers.containers = {
        palworld = {
          image = "thijsvanloef/palworld-server-docker:latest";
          autoStart = true;
          ports = [
            "8211:8211/udp"
            "27015:27015/udp"
          ];
          volumes = [
            "/var/lib/palworld:/palworld"
          ];
          environmentFiles = [ config.sops.secrets.palworld_env.path ];
          environment = {
            TZ = "Europe/Berlin";
            PUID = "1000";
            PGID = "1000";
            PORT = "8211";
            QUERY_PORT = "27015";
            PLAYERS = "8";

            # Performance & Multithreading (optimized for 2 cores)
            ENABLE_PERF_THREADING_ARGS = "true";
            WORKER_THREADS_SERVER = "2";
            ARM64_DEVICE = "generic";

            # Updates & Backups
            UPDATE_ON_BOOT = "true";
            BACKUP_ENABLED = "true";
            DELETE_OLD_BACKUPS = "true";
            OLD_BACKUP_DAYS = "7";
            BACKUP_CRON_EXPRESSION = "0 4 * * *";

            # Daily Auto-Reboot (05:00 UTC) to clear memory buildup
            AUTO_REBOOT_ENABLED = "true";
            AUTO_REBOOT_CRON_EXPRESSION = "0 5 * * *";
            AUTO_REBOOT_EVEN_IF_PLAYERS_ONLINE = "false";
            AUTO_REBOOT_WARN_MINUTES = "5";

            # Game Settings Optimized for 2 CPU Cores & Low Memory
            BASE_CAMP_WORKER_MAX_NUM = "10";
            BASE_CAMP_MAX_NUM_IN_GUILD = "6"; # compensation for less pals per base
            ENABLE_INVADER_ENEMY = "true";
            DROP_ITEM_MAX_NUM = "1000";
            DROP_ITEM_ALIVE_MAX_HOURS = "0.500000";
            PAL_SPAWN_NUM_RATE = "0.850000";
            ENABLE_NON_LOGIN_PENALTY = "false";
            DEATH_PENALTY = "None";
            NIGHTTIME_SPEEDRATE = "2.000000";
            BUILD_OBJECT_DETERIORATION_DAMAGE_RATE = "0.000000";
            COLLECTION_OBJECT_RESPAWN_SPEED_RATE = "1.500000";

            SERVER_NAME = "Palworld Server 1.0";
            SERVER_DESCRIPTION = "Palworld Server for Us";
          };
        };
      };

      networking.firewall = {
        allowedUDPPorts = [
          8211
          27015
        ];
      };
    };
  };
}
