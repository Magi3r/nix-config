{
  den,
  ...
}: {
  den.aspects.powerManagement = {
    nixos = {pkgs, ...}: {
      powerManagement = {
        enable = true;
        cpuFreqGovernor = "schedutil";
      };
      environment.systemPackages = with pkgs; [
        cpupower
      ];
    };
  };
}
