{config,lib,...}:{
  services.caddy = {
    enable = true;
    virtualHosts."somech.local".extraConfig = ''
      respond "OK"
    '';
    };
}
