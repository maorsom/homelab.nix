{config,pkgs,...}:
{
  services.unbound = {
    enable = true;
    settings = {
      server = {
        tls-cert-bundle = "/etc/ssl/certs/ca-certificates.crt";
        interface = [ "127.0.0.1" ];
        port = 5335;
        access-control = [ "127.0.0.1 allow" ];
        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;
        hide-identity = true;
        hide-version = true;

        local-zone = [
          ''"ad.somech.lab." redirect''
          ''"ca.somech.lab." redirect''
          ''"grafana.somech.lab." redirect''
          ''"prometheus.somech.lab." redirect''
          ''"loki.somech.lab." redirect''
          ''"docs.somech.lab." redirect''
          ''"mongo.somech.lab." static''
        ];
        local-data = [
          ''"ad.somech.lab. IN A 10.0.0.103"''
          ''"ca.somech.lab. IN A 10.0.0.103"''
          ''"grafana.somech.lab. IN A 10.0.0.103"''
          ''"prometheus.somech.lab. IN A 10.0.0.103"''
          ''"loki.somech.lab. IN A 10.0.0.103"''
          ''"docs.somech.lab. IN A 10.0.0.103"'' 
          ''"mongo.somech.lab. IN A 10.0.0.103"'' 
        ];
      };
      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "9.9.9.9#dns.quad9.net"
            "149.112.112.112#dns.quad9.net"
          ];

          forward-tls-upstream = true;  # Protected DNS
        }
      ];
    };
  };
}
