# defines all hosts + users + homes.
# then config their aspects in as many files you want
{
  # wubbaboo user at limgrave host.
  den.hosts.x86_64-linux.limgrave.users.wubbaboo = {
    hashedPassword = "$y$j9T$axI5ncI6myGVqaMUzh3RW.$bAhI.rL0pWgXA1lgrpVohABTDekKAroqFoleZbaYkE0";
    description = "Wubbaboo";
    extraGroups = []; # "libvirtd" "kvm" "adbusers" "docker" "i2c" | managed by den: "networkmanager" "wheel"
  };

  # define an standalone home-manager for wubbaboo
  # den.homes.x86_64-linux."wubbaboo@limgrave" = { };
}
