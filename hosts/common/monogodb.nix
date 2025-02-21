{ config, lib, pkgs, ...}: {
  services.mongodb = {
    enable = true;
    dataDir = "/databases/mongodb";
    bind_ip = "0.0.0.0";
    extraConfig = ''
      security:
        authorization: enabled
    '';
  };

  networking.firewall.extraCommands = ''
      iptables -A INPUT -p tcp --dport 27017 -s 10.0.0.103/24 -j ACCEPT
      iptables -A INPUT -p tcp --dport 27017 -j DROP
  '';
}
