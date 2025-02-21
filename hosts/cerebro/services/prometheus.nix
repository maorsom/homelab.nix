{config,lib,pkgs,...}: 
let
  domain = "prometheus.somech.local";
in {

  services.prometheus.extraScrapeConfigs = lib.mkOption {
    default = [];
    type = lib.types.listOf lib.types.attrs;
    description = "Extra scrape configurations for Prometheus.";
  };

  services.prometheus = {
    enable = true;
    port = 9090;  # Default port for Prometheus
    scrateConfig = lib.mkMerge [
      {
        job_name = "prometheus";
        scrape_interval = "30s";
        static_configs = [{ targets = [ "localhost:9090" ]; }];
      }
      config.services.prometheus.extraScrapeConfigs
    ];
  };

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      tls internal
      reverse_proxy http://localhost:9090
    '';
  };

}
