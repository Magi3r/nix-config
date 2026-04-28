{
  den.aspects.print-and-scan = {
    nixos = {
      services.printing.enable = true;
      hardware.sane.enable = true;
    };
    # config applied for all users
    provides.to-users = {user, ...}: {
      user.extraGroups = [
        "scanner"
        "lp"
      ];
    };
  };
}
