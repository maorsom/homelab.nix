{config,pkgs,...}: 
let
  domain = "prometheus.somech.local";
in {
  services.prometheus = {
    enable = true;
    port = 9090;  # Default port for Prometheus
    scrapeConfigs = [
      {
        job_name = "node";
        scrape_interval = "15s";
        static_configs = [
          {
            targets = [ "localhost:9100" ]; # Scrape Node Exporter
          }
        ];
      }
    ];
  };

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      tls internal
      reverse_proxy http://localhost:9090
    '';
  };
}
