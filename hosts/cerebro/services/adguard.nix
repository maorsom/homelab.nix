{config,lib,pkgs,...}: 
let
  domain = "ad.somech.lab";
in {

  services.adguardhome = {
    enable = true;
    openFirewall = false; 
    host = "0.0.0.0";
    settings = {
      dns = {
        bind_port = 53;  
        upstream_dns = [ "127.0.0.1:5335" ];
      };
      http = {
        address = "0.0.0.0";
        port = 3000;
      };
      querylog = {enabled = true;};
      statistics = {enabled = true; interval = "1h";};
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
      tls internal
      reverse_proxy http://localhost:3000
    '';
  };

  services.prometheus.extraScrapeConfigs = lib.mkBefore [
  {
    job_name = "adguard";
    scrape_interval = "15s";
    static_configs = [
      { targets = [ "localhost:3000" ]; }
    ];
  }];
}
