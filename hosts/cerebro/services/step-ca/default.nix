{ config, lib, pkgs, ...} :
let
  domain = "ca.somech.lab";
in {

  sops.secrets.intermediate_password = {
    sopsFile = "./certs.yaml";
    owner = "step-ca";
    mode = "0600";
  };

  environment.var.lib."step/secrets/intermediate_password" = {
    text = config.sops.secrets.intermediate_password.path;
    owner = "step-ca";
    group = "step-ca";
    mode = "0600";
  };

  sops.secrets.intermediate_crt = {
    sopsFile = "./certs.yaml";
    owner = "step-ca";
    mode = "0640";
  };

  environment.var.lib."step/secrets/intermediate_ca" = {
    text = config.sops.secrets.intermediate_crt.path;
    owner = "step-ca";
    group = "step-ca";
    mode = "0640";
  };

  sops.secrets.intermediate_key = {
    sopsFile = "./certs.yaml";
    owner = "step-ca";
    mode = "0600";
  };

  environment.var.lib."step/secrets/intermediate_ca_key" = {
    text = config.sops.secrets.intermediate_key.path;
    owner = "step-ca";
    group = "step-ca";
    mode = "0600";
  };

  sops.secrets.root_crt = {
    sopsFile = "./certs.yaml";
    owner = "step-ca";
    mode = "0640";
  };

  environment.var.lib."step/secrets/root_ca" = {
    text = config.sops.secrets.root_crt.path;
    owner = "step-ca";
    group = "step-ca";
    mode = "0640";
  };

  services.step-ca = {
    enable = true;
    port = 4443;
    address = "0.0.0.0";
    openFirewall = true;
    settings = builtins.fromJSON (builtins.readFile ./ca.json);
    intermediatePasswordFile = config.sops.secrets.ca.intermediate_password.path;
  };

  networking.firewall.extraCommands = ''
    iptables -A INPUT -p tcp --dport 4443 -s 10.0.0.0/24 -j ACCEPT
    iptables -A INPUT -p tcp --dport 4443 -j DROP
  '';
}
