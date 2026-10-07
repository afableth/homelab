# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "rtx3060"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  programs.nix-ld.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Users
  security.sudo.wheelNeedsPassword = true;
  users.users = {
    takes = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBteZsu2AShLsWSNRqQmog1c6L3ppd5Wbydnj6BrYfeH"
      ];
    };
    poske = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnJtuVDN563Leul7aThmEEMaMp3cFU+B0ijPGyn0lf+"
      ];
    };
  };

  # Packages
  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  # SSH
  environment.etc."ssh/ca.pub".text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMbidfb92SFVA7qPr6vUqpsRLhFtaEDjngPoYJs/q7bb";
  services.openssh = {
    enable = true;
    settings.TrustedUserCAKeys = "/etc/ssh/ca.pub";
  };

  # Comin
  services.comin = {
    enable = true;
    sshAllowedSignersPath = "/etc/comin/allowed_signers";
    remotes = [
      {
        name = "origin";
        url = "https://github.com/afableth/homelab.git";
        branches.main.name = "main";
      }
    ];
  };
  environment.etc."comin/allowed_signers".text =
    "hello@afabl.fyi ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPnJtuVDN563Leul7aThmEEMaMp3cFU+B0ijPGyn0lf+";

  # Network
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.enable = false;
  networking.interfaces.enp7s0.ipv4.addresses = [
    {
      address = "192.168.5.241";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "192.168.5.5";
  networking.nameservers = [
    "192.168.1.4"
    "1.1.1.1"
  ];

  system.stateVersion = "26.05"; # DON'T CHANGE!

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  boot.kernelPackages = pkgs.linuxPackages_6_12;
  networking.hostId = "32663934";
}
