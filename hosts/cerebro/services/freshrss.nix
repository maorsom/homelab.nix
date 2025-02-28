{config,lib,pkgs,...}: 
let
  domain = "rss.somech.lab";
in {

  services.freshrss = {
    enable = true;
    authType = "none";
    dataDir = "/data/rss";
    baseUrl = "https://${domain}";
    virtualHost = null;
  };

  services.caddy.virtualHosts.${domain} = {
    extraConfig = ''
      tls internal
      reverse_proxy http://localhost:8082
    '';
  };

}
