{den, ...}: {
  den.aspects.powerManagement = {
    nixos = {pkgs, ...}: {
      powerManagement = {
        enable = true;
        cpuFreqGovernor = "schedutil";
      };
    };
  };
}
