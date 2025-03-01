{config,pkgs,...}:
{
  services.unbound = {
    enable = true;
    settings = {
      server = {
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
      };
      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "10.0.0.103#somech.lab"
            "10.0.0.103#ca.somech.lab"
            "10.0.0.103#ad.somech.lab"
            "10.0.0.103#docs.somech.lab"
            "10.0.0.103#grafana.somech.lab"
            "10.0.0.103#prometheus.somech.lab"
            "10.0.0.103#loki.somech.lab"
            "10.0.0.103#rss.somech.lab"
          ];

          forward-tls-upstream = true;  # Protected DNS
        }
      ];
    };
  };
}
