{ config, pkgs, ... }:
{

    #aggiungo i pacchetti custom
    nixpkgs.overlays = [
      (import ./custom_repo) ]; imports = [
        ./software/nvim.nix
        ./software/fish.nix
        ./software/nnn.nix
        ./software/alacritty.nix ./software/i3blocks.nix
      ];

    #enable unfree software
    nixpkgs.config.allowUnfree = true;
    home = {
      username = "eris";
      homeDirectory = "/home/eris";
      stateVersion = "25.05";
      
      sessionVariables = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
      };

      packages = with pkgs; [
        dos2unix
        go
        unzip
        zip
        i3blocks-contrib #custom_repo
        iw #for wifi blocklet in i3blocks (devo mettere apposto le dipendenze)
        bluetui
        ghidra-fix
        lm_sensors
        imsprog
        ch341eeprom
        gdb
        bear
        binwalk
        radare2
        foremost
        localsend
        python313Packages.ipython
        bemenu
        qemu
        htop
        mullvad-vpn
        roomeqwizard
        qlcplus
        opensoundmeter
        pulsemixer
        zathura
        librewolf
        prismlauncher
        wireshark
        freecad
        kicad
        gimp
        kdePackages.dolphin
        (pkgs.python3.withPackages (ps: with ps; [ lzhuf-py ]))
          #lzhuf-py #custom_repo
        ];
      };
    
    xdg.enable = true;
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "inode/directory" = [ "org.kde.dolphin.desktop" ];
        "x-scheme-handler/file" = [ "org.kde.dolphin.desktop" ];
      };
      associations.added = {
        "inode/directory" = [ "org.kde.dolphin.desktop" ];
      };
    };

      services.gammastep = {
        enable = true;
        provider = "manual";
        latitude = 41.9027835;
        longitude = 12.4963655;
      };

      xdg.userDirs = {
        enable = true;
        desktop = "${config.home.homeDirectory}/Desktop";
        documents = "${config.home.homeDirectory}/Documents";
        download = "${config.home.homeDirectory}/Downloads";
        music = "${config.home.homeDirectory}/Music";
        pictures = "${config.home.homeDirectory}/Pictures";
        publicShare = "${config.home.homeDirectory}/Public";
        templates = "${config.home.homeDirectory}/Templates";
        videos = "${config.home.homeDirectory}/Videos";
      };

      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
      };
    }

