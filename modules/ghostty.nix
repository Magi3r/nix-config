{
  den.aspects.ghostty = {
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
