{
  den.aspects.git = {
    homeManager = {
      pkgs,
      lib,
      ...
    }: {
      programs.git = {
        enable = true;

        settings = {
          init = {
            defaultBranch = "main";
          };
          url = {
            "https://github.com/" = {
              insteadOf = [
                "gh:"
                "github:"
              ];
            };
          };
        };

        settings = {
          user.name = "Magi3r";
          user.email = "jvd@outlook.de";

          alias = {
            st = "status";
            pu = "push";
            co = "checkout";
            cm = "commit";
          };
        };
      };

      programs.delta = {
        enable = true;
        enableGitIntegration = true;
        options = {
          line-numbers = true;
          side-by-side = true;
        };
      };
    };
  };
}
