{config,lib,...}:{
  services.caddy = {
    enable = true;
    globalConfig = ''

      email maor@wesomech.com
      acme_ca https://ca.somech.lab:4443/acme/acme/directory
      acme_ca_root /etc/step-ca/certs/root_ca.crt

      auto_https disable_redirects
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
