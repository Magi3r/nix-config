{
  den,
  __findFile,
  ...
}: {
  den.aspects.services.datefinder-bot = {host, ...}: {
    includes = [
      <virtualisation>
    ];
    nixos = {config, ...}: let
    in {
      sops.secrets.datefinder_env = {};

      virtualisation.oci-containers.containers = {
        datefinder-bot = {
          image = "magi3r/datefinder-bot";
          autoStart = true;
          environmentFiles = [
            config.sops.secrets.datefinder_env.path
          ];
        };
      };
    };
  };
}
