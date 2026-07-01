{den, ...}: {
  den.aspects.syncthing = {
    nixos = {config, ...}: {
      sops.secrets.syncthing-gui-password = {};

      services.syncthing = {
        enable = true;
        openDefaultPorts = true;
        guiPasswordFile = config.sops.secrets.syncthing-gui-password.path;
        settings.gui.user = "admin";
      };
    };
  };
}
