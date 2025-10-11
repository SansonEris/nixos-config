# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, lib, ... }:
let
  #------------------------------OPTIONS------------------------------
  custom_options = import ./options.nix;
in
{
  #------------------------------NIX CONFIG------------------------------
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #------------------------------IMPORTS------------------------------
  imports =
    [ 
      ./hardware-configuration.nix
      ./nvim.nix
      ./software.nix
      ./virtualization.nix
      ./steam.nix
      ./localization.nix
      ./ios.nix
      #./esp32-udev-rules.nix
    ]
    ++ (if custom_options.hasGTX10xx then [ ./hw_nvidia.nix ] else [ ])
    ++ (if custom_options.enableSway then [ ./sway.nix ] else []);

  #------------------------------PACKAGES------------------------------
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    alacritty
    git
    fortune
    cowsay
    qutebrowser
    nnn
    nodejs
    home-manager
    usbutils
    libusb1
    zip
    unzip
    tmux
    flashrom
    man-pages
    man-pages-posix
    kdePackages.dolphin
    keymapp
    fish

    # KDE
    kdePackages.discover # Optional: Install if you use Flatpak or fwupd firmware update sevice
    kdePackages.kcalc # Calculator
    kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
    kdePackages.kclock # Clock app
    kdePackages.kcolorchooser # A small utility to select a color
    kdePackages.kolourpaint # Easy-to-use paint program
    kdePackages.ksystemlog # KDE SystemLog Application
    kdePackages.sddm-kcm # Configuration module for SDDM
    kdiff3 # Compares and merges 2 or 3 files or directories
    kdePackages.isoimagewriter # Optional: Program to write hybrid ISO files onto USB disks
    kdePackages.partitionmanager # Optional: Manage the disk devices, partitions and file systems on your computer
    # Non-KDE graphical packages
    hardinfo2 # System information and benchmarks for Linux systems
    vlc # Cross-platform media player and streaming server
    wayland-utils # Wayland utilities
    wl-clipboard # Command-line copy/paste utilities for Wayland
  ];

  #------------------------------USERS------------------------------
  users.users.eris = {
    isNormalUser = true;
    description = "Eris";
    extraGroups = [ "networkmanager" "wheel" "disk" "dialout" "uucp" "docker" "plugdev" "vboxsf" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  #------------------------------BOOTLOADER------------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #------------------------------PIPEWIRE-------------------------------
  # rtkit (optional, recommended) allows Pipewire to use the realtime scheduler for increased performance.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment the following
    #jack.enable = true;
  };
  #------------------------------KDE----------------------------------
  services = {
    desktopManager.plasma6.enable = true;

    displayManager.sddm.enable = false;

    displayManager.sddm.wayland.enable = false;
  };
  #------------------------------SHELL--------------------------------
  users.defaultUserShell = pkgs.fish;
  #------------------------------NETWORK------------------------------
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Enable networking
  networking.networkmanager.enable = true;
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8080 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  #------------------------------MULLVAD------------------------------
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  #------------------------------HARDWARE------------------------------
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true; # Show battery charge of Bluetooth devices
      };
    };
  };
  #moonlander keyboard
  #hardware.keyboard.zsa.enable = true;
  #CH341 programmer kernel module
  #boot.kernelModules = [ "ch341" ];
  services.blueman.enable = true;
  #------------------------------MISC------------------------------
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  services.printing.enable = true;

  #DO NOT TOUCH!
  system.stateVersion = "25.05"; 
}
