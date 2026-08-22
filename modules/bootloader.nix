{
  den.aspects.bootloader = {
    limine = {
      nixos = {
        boot.loader.limine.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
      };
    };

    systemd-boot = {
      nixos = {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
      };
    };
  };
}
