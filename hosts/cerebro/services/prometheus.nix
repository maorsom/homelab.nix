{config,pkgs,...}: {

  services.prometheus = {
    enable = true;
    port = 9090;  # Default port for Prometheus
    domain = "prometheus.somech.local";
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

  services.caddy.virtualHosts.${config.services.grafana.domain} = {
    extraConfig = ''
      tls internal
      reverse_proxy http://localhost:2342
    '';
  };
}
