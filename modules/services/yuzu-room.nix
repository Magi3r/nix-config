{
      den,
      inputs,
      lib,
      ...
    }: {
      flake-file.inputs = {
        room-reg-impl = {
          url = "github:simvux/room-reg-impl";
          flake = false;
        };
      };

      den.aspects.services.yuzu-room = {
        nixos = {
          config,
          pkgs,
          ...
        }: let
          url = "fun.${config.networking.domain}";
          lobbyPort = config.alloc.ports.blocks.yuzu-lobby.start;
          roomPort = config.alloc.ports.blocks.yuzu-room.start;

          roomRegPkg = pkgs.rustPlatform.buildRustPackage {
            pname = "room-reg-impl";
            version = "0.1.0";
            src = inputs.room-reg-impl;
            cargoLock.lockFile = "${inputs.room-reg-impl}/Cargo.lock";
          };

          configRon = pkgs.writeText "config.ron" ''
            Config(
                port: ${toString lobbyPort},
                timeout_seconds: 30,
                user_limits: {},
            )
          '';
        in {
          alloc.ports.blocks.yuzu-lobby = {};

          users.users.yuzu-lobby = {
            isSystemUser = true;
            group = "yuzu-lobby";
          };
          users.groups.yuzu-lobby = {};
        # Lobby browser
          systemd.services.yuzu-lobby = {
            description = "Room Registration Web Service (Lobby Browser)";
            wantedBy = ["multi-user.target"];
            after = ["network.target"];

            environment = {
                ROCKET_ADDRESS = "127.0.0.1";
            };

            serviceConfig = {
              Type = "simple";
              User = "yuzu-lobby";
              Group = "yuzu-lobby";
              StateDirectory = "yuzu-lobby";
              WorkingDirectory = "/var/lib/yuzu-lobby";
              ExecStartPre = pkgs.writeShellScript "yuzu-lobby-pre" ''
                ln -sf ${configRon} /var/lib/yuzu-lobby/config.ron
              '';
              ExecStart = "${roomRegPkg}/bin/room-reg-impl";
              StandardInput = "null";
              Restart = "always";
              RestartSec = 5;

              # Security hardening
              NoNewPrivileges = true;
              ProtectSystem = "strict";
              ProtectHome = true;
              PrivateTmp = true;
            };
          };

          services.caddy.virtualHosts.${url}.extraConfig = ''
            reverse_proxy localhost:${toString lobbyPort}
          '';

          # Game Room
          # Secret containing the room password
          sops.secrets.yuzuroom = {};

          alloc.ports.blocks.yuzu-room = {};

          # OCI container definition
          virtualisation.oci-containers.containers.yuzu-room = {
            image = "k4rian/yuzu-room:latest";
            autoStart = true;
            ports = [
              "${toString roomPort}:${toString roomPort}/tcp"
              "${toString roomPort}:${toString roomPort}/udp"
            ];
            volumes = [
              "/etc/localtime:/etc/localtime:ro"
              # Mount SOPS secret directly to where k4rian/yuzu-room expects docker secrets
              "${config.sops.secrets.yuzuroom.path}:/run/secrets/yuzuroom:ro"
            ];
            environment = {
              YUZU_BINDADDR = "0.0.0.0";
              YUZU_PORT = "${toString roomPort}";
              YUZU_ROOMNAME = "yuzu Room";
              YUZU_PREFGAME = "Any";
              YUZU_MAXMEMBERS = "8";
              YUZU_BANLISTFILE = "bannedlist.ybl";
              YUZU_LOGFILE = "yuzu-room.log";

              YUZU_ROOMDESC = "yuzu Room";
              YUZU_PREFGAMEID = "0100965017338000";
              YUZU_PASSWORD=""; # Set by secret file
              YUZU_ISPUBLIC = "1";
              YUZU_TOKEN = "citrusfruit";
              YUZU_WEBAPIURL = "https://${url}"; # Points to the room-reg-impl web service
            };
          };

                    systemd.services."docker-yuzu-room" = {
            # Order after and depend on both the lobby backend and Caddy
            after = [
              "yuzu-lobby.service"
              "caddy.service"
            ];
            requires = [
              "yuzu-lobby.service"
              "caddy.service"
            ];

            serviceConfig = {
              # Poll until the lobby service responds with HTTP 200
              ExecStartPre = pkgs.writeShellScript "wait-for-yuzu-lobby" ''
                echo "Waiting for Yuzu lobby (https://${url}/lobby) to be healthy..."
                for i in $(seq 1 60); do
                  if ${pkgs.curl}/bin/curl -skf "https://${url}/lobby" >/dev/null 2>&1; then
                    echo "Lobby is healthy and accepting connections!"
                    exit 0
                  fi
                  sleep 1
                done

                echo "Timed out waiting for Yuzu lobby service to become healthy!"
                exit 1
              '';

              # Auto-restart if disconnected or failed
              RestartSec = 10;
            };
          };

          # Firewall openings for game traffic
          networking.firewall = {
            allowedTCPPorts = [ roomPort ];
            allowedUDPPorts = [ roomPort ];
          };
        };
      };
    }