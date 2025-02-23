{config,lib,pkgs,...}: 
let
  domain = "rss.somech.lab";
in {

  services.freshrss = {
    enable = true;
    database.type = "sqlite";
    listen.ip = "0.0.0.0";
    listen.port = 8082;
  };

  networking.firewall.extraCommands = ''
    iptables -A INPUT -p tcp --dport 8082 -s 10.0.0.0/24 -j ACCEPT
    iptables -A INPUT -p tcp --dport 8082 -j DROP
  '';

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      tls internal
      reverse_proxy http://localhost:8082
    '';
  };

}
