{config,lib,pkgs,...}: 
let
  domain = "ad.somech.lab";
in {

  services.adguardhome = {
    enable = true;
    openFirewall = false; 
    host = "0.0.0.0";
    mutableSettings = true;
    settings = {
      dns = {
        bind_port = 53;  
        upstream_dns = [ "127.0.0.1:5353" "8.8.8.8" ];
      };
      http = {
        address = "0.0.0.0";
        port = 3000;
      };
      runtime = {prometheus = {enabled = true;};};
    };
  };

  networking.firewall.extraCommands = ''
    iptables -A INPUT -p tcp --dport 53 -s 10.0.0.0/24 -j ACCEPT
    iptables -A INPUT -p udp --dport 53 -s 10.0.0.0/24 -j ACCEPT
    iptables -A INPUT -p tcp --dport 53 -j DROP
    iptables -A INPUT -p udp --dport 53 -j DROP
  '';

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      reverse_proxy http://localhost:3000
    '';
  };
}
