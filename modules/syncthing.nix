{den, ...}: {
  den.aspects.syncthing = {
    nixos = {
      pkgs,
      config,
      ...
    }: {
      sops.secrets.syncthing-gui-password = {};

      services.syncthing = {
        enable = true;
        openDefaultPorts = true;
        guiPasswordFile = config.sops.secrets.syncthing-gui-password.path;
        settings.gui.user = "admin";
      };
    };
    # provides.to-users.homeManager = { pkgs, ... }: {
    #   home.packages = [ pkgs.syncthingtray ];
    # };
  };
}
