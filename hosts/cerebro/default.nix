{
  modulesPath,
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../common/global
    ./disko-config.nix
    ../common/caddy.nix
    ../common/mongodb.nix
    ./services
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];

    config = {
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "nix-command flakes";
        # Opinionated: disable global registry
        flake-registry = "";
        # Workaround for https://github.com/NixOS/nix/issues/9574
        nix-path = config.nix.nixPath;
      };
      channel.enable = false;

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      trustedUsers = ["@wheel"];
    };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "cerebro";
  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];

  services.journald = {
    extraConfig = ''
      Storage=persistent
      SplitMode=uid
    '';
  };

  networking = {
    interfaces.eth0 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "10.0.0.103";
        prefixLength = 24;
      }];
    };
    defaultGateway = "10.0.0.138";

    # Set DNS Servers
    nameservers = [ "10.0.0.103" ];
  };

  users.users = { 
    sysadmin = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILyvt3eutNJYckqboCsGejfpMvjJSVLjBvx7S71LBhBe"
      ];
      extraGroups = [ "wheel" "adm" "systemd-journal" ];
    };
  };
  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  environment.systemPackages = with pkgs;[
    acme-sh
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
