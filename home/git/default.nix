{
  programs.git = {
    enable = true;

    settings = {
      user.name = "Magi3r";
      user.email = "jvd@outlook.de";

      aliases = {
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
}
