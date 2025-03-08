{ config, lib, pkgs, ...} :
let
  domain = "ca.somech.lab";
in {

  sops.secrets.intermediate_password = {
    sopsFile = ./certs.yaml;
    path = "/var/lib/step-ca/step-ca-password.txt";
    owner = "step-ca";
    mode = "0600";
  };

  sops.secrets.intermediate_crt = {
    sopsFile = ./certs.yaml;
    path = "/var/lib/step-ca/certs/intermediate_ca.crt";
    owner = "step-ca";
    mode = "0640";
  };

  sops.secrets.intermediate_key = {
    sopsFile = ./certs.yaml;
    path = "/var/lib/step-ca/secrets/intermediate_ca_key";
    owner = "step-ca";
    mode = "0600";
  };

  sops.secrets.root_crt = {
    sopsFile = ./certs.yaml;
    path = "/var/lib/step-ca/certs/root_ca.crt";
    owner = "step-ca";
    mode = "0640";
  };

  environment.etc."ssl/certs/root_ca.crt" = {
    source = config.sops.secrets.root_crt.path;
    user = "root";
    group = "root";
    mode = "0644";
  };

  security.pki.certificates = [ "/etc/ssl/certs/root_ca.crt" ];

  services.step-ca = {
    enable = true;
    port = 4443;
    address = "0.0.0.0";
    openFirewall = true;
    settings = builtins.fromJSON (builtins.readFile ./ca.json);
    intermediatePasswordFile = config.sops.secrets.intermediate_password.path;
  };

  services.tls-cert-manager = {
    enable = true;
  };
}
