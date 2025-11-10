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
    keymapp
    fish

    kdiff3 
    hardinfo2 
    vlc 
    wayland-utils 
    wl-clipboard 

    libsForQt5.breeze-icons
    qt5.full
    libxkbcommon
    dbus
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
  services.dbus.enable = true;
  services.dbus.packages = with pkgs; [ dbus ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.

  #---------------------------PRINTERS-------------------------------
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  #-----------------------------NFC----------------------------------
  hardware.nfc-nci.enable = true;
  #-----------------------------PN543--------------------------------
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    glib
    gtk3
    atk
    pango
    cairo
    gdk-pixbuf
    xorg.libX11
    xorg.libXext
    xorg.libxcb
    xorg.libXrender
    xorg.libXrandr
    xorg.libXi
    xorg.libXfixes
    xorg.libXcomposite
    xorg.libXcursor
    mesa
    libGL
    freetype
    fontconfig
    zlib
    libpng
    libjpeg
    nss
    nspr
    fuse
    appimage-run
    libusb1
    libnfc
  ];
  #DO NOT TOUCH!
  system.stateVersion = "25.05"; 
}
