{config,lib,pkgs,...}: 
let
  domain = "prometheus.somech.lab";
in {

  services.prometheus = {
    enable = true;
    port = 9090;  # Default port for Prometheus
    scrapeConfigs = lib.mkBefore [
      {
        job_name = "prometheus";
        scrape_interval = "30s";
        static_configs = [{ targets = [ "localhost:9090" ]; }];
      }
    ];
  };

  networking.firewall.extraCommands = ''
    iptables -A INPUT -p tcp --dport 8080 -s 10.0.0.0/24 -j ACCEPT
    iptables -A INPUT -p tcp --dport 8080 -j DROP
  '';

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      reverse_proxy http://localhost:9090
    '';
  };

}
