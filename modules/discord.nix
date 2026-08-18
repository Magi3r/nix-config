{den, ...}: {
  den.aspects.discord = {user, ...}: {
    homeManager = {pkgs, ...}: {
      programs.vesktop = {
        enable = true;
        # settings.SKIP_HOST_UPDATE = true;
      };
    };
  };
}
