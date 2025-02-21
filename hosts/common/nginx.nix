{config,lib,...}:{
  services.caddy = {
    enable = true;
    globalConfig = ''
      servers {
          metrics
      }
    '';
  };

  services.prometheus.scrapeConfigs = lib.mkBefore [
    {
      job_name = "caddy";
      scrape_interval = "15s";
      static_configs = [
        { targets = [ "localhost:2019" ]; }
      ];
    }
  ];
}
