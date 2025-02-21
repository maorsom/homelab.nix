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
    ../common/nginx.nix
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
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
  };

  users.users = { 
    sysadmin = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILyvt3eutNJYckqboCsGejfpMvjJSVLjBvx7S71LBhBe"
      ];
      extraGroups = [ "wheel" ];
    };
  };
  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.11";
}
