# defines all hosts + users + homes.
# then config their aspects in as many files you want
{
  # wubbaboo user at limgrave host.
  den.hosts.x86_64-linux.limgrave.users.wubbaboo = {
    hashedPassword = "$y$j9T$axI5ncI6myGVqaMUzh3RW.$bAhI.rL0pWgXA1lgrpVohABTDekKAroqFoleZbaYkE0";
    description = "Wubbaboo";
    extraGroups = []; # "libvirtd" "kvm" "adbusers" "docker" "i2c" | managed by den: "networkmanager" "wheel"
  };

  # wubbaboo user at altus host (Raspberry Pi 5 server).
  den.hosts.aarch64-linux.altus.users.wubbaboo = {
    hashedPassword = "$y$j9T$axI5ncI6myGVqaMUzh3RW.$bAhI.rL0pWgXA1lgrpVohABTDekKAroqFoleZbaYkE0";
    description = "Altus";
    extraGroups = [];
  };

  # wubbaboo user at gelmir host (Oracle Cloud VPS server).
  den.hosts.aarch64-linux.gelmir.users.wubbaboo = {
    hashedPassword = "$y$j9T$NqA028hjFPZMX8y0NLMHV/$d4IyA/j2iMQyv1cFjjiR6tIv5AMQL1Rupxee2MMcUNB";
    description = "Gelmir";
    extraGroups = [];
  };

  # wubbaboo user at farum-azula host (Webtropia VPS server).
  den.hosts.x86_64-linux."farum-azula".users.wubbaboo = {
    hashedPassword = "$y$j9T$NqA028hjFPZMX8y0NLMHV/$d4IyA/j2iMQyv1cFjjiR6tIv5AMQL1Rupxee2MMcUNB";
    description = "Farum Azula";
    extraGroups = [];
  };

  # define an standalone home-manager for wubbaboo
  # den.homes.x86_64-linux."wubbaboo@limgrave" = { };
  # den.homes.aarch64-linux."wubbaboo@altus" = { };
}
