{den, ...}: {
  den.aspects.virtualisation = {
    nixos = {pkgs, ...}: {
      virtualisation.docker = {
        enable = true;
        autoPrune = {
          enable = true;
          dates = "weekly";
        };
      };
      virtualisation.oci-containers.backend = "docker";
      environment.systemPackages = with pkgs; [
        docker-compose
      ];
    };
  };
}
