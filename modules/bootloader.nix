{
  den.aspects.bootloader = {
    nixos = {
      boot.loader.limine.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    };
  };
}
