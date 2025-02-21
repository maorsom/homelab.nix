{config,lib,pkgs,...}: 
let
  domain = "prometheus.somech.local";
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

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      tls internal
      reverse_proxy http://localhost:9090
    '';
  };

}
