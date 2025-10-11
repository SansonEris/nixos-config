{ config, pkgs, ... }:
{

    #aggiungo i pacchetti custom
    nixpkgs.overlays = [
        (import ./custom_repo) ]; imports = [
        ./software/nvim.nix
        ./software/fish.nix
        ./software/nnn.nix
        ./software/alacritty.nix
        ./software/i3blocks.nix
    ];

    #enable unfree software
    nixpkgs.config.allowUnfree = true;
	home = {
		username = "eris";
		homeDirectory = "/home/eris";
		stateVersion = "25.05";
        packages = with pkgs; [
          dos2unix
          go
          unzip
          zip
          spotify
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
          (pkgs.python3.withPackages (ps: with ps; [ lzhuf-py ]))
          #lzhuf-py #custom_repo
        ];
	};
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
      };
    };
  }

