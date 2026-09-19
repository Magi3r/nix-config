{den, ...}: {
  den.aspects.services.actual-budget = {host, ...}: {
    nixos = {config, ...}: let
      url = "budget.remote.magi3r.de";
      port = config.alloc.ports.blocks.actual-budget.start;
    in {
      alloc.ports.blocks.actual-budget = {};

      services.actual = {
        enable = true;
        settings = {
          port = port;
        };
      };

      services.caddy.virtualHosts.${url}.extraConfig = ''
        reverse_proxy localhost:${toString port}
      '';
    };
  };
}
