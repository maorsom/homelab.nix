{ config, lib, pkgs, ...}: {
  services.mongodb = {
    enable = true;
    package = pkgs.mongodb-ce;
    bind_ip = "0.0.0.0";
    dbpath = "/databases/mongodb";
    extraConfig = ''
      security:
        authorization: "enabled"

      setParameter:
        authenticationMechanisms: "SCRAM-SHA-256"
    '';
    initialScript = ./initial_data.js;
  };

  networking.firewall.extraCommands = ''
    iptables -A INPUT -p tcp --dport 27017 -s 10.0.0.0/24 -j ACCEPT
    iptables -A INPUT -p tcp --dport 27017 -j DROP
  '';
}
