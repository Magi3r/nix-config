{
  den.aspects.ghostty = {user, ...}: {
    homeManager = {
      pkgs,
      lib,
      ...
    }: {
      programs.ghostty = {
        enable = true;
        enableFishIntegration = true;
        enableBashIntegration = true;
        settings = {
          theme = "TokyoNight Moon";
        };
      };
    };
  };
}
