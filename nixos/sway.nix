{ config, pkgs, lib, ... }:
let
  #------------------------------OPTIONS------------------------------
  custom_options = import ./options.nix;
in
{
	#packages
	environment.systemPackages = with pkgs; [
		grim #screenshot
		slurp #screenshot
		wl-clipboard #clipboard
		mako #notifications
	];
  #------------------------------MIME TYPES & FILE ASSOCIATIONS------------------------------
	xdg.mime.enable = true;
	
	environment.etc."xdg/mimeapps.list".text = ''
		[Default Applications]
		inode/directory=org.kde.dolphin.desktop
		x-scheme-handler/file=org.kde.dolphin.desktop
	'';
  #------------------------------------------------------------------------------------------
	#enable gnome-keyring secrets valut.
	services.gnome.gnome-keyring.enable = true;

	#SWAY CONFIG
	#note: it's not possibile to configure it with nix
	#so we keep the configuration file inside ~/.config/home-manager
	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true;
                extraOptions = [ " --config=/home/eris/.config/home-manager/sway-config " ]
                ++ (if custom_options.hasGTX10xx then [ " --unsupported-gpu " ] else []);
	};

	#ly configuration
	services.displayManager.ly = {
		enable = true;
	};

	#kanshi systemd service
	systemd.user.services.kanshi = {
		description = "kanshi daemon";
		serviceConfig = {
		Type = "simple";
			ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
		};
	};

	#Polkit config
	security.polkit.enable = true;
	systemd = {
		user.services.polkit-gnome-authentication-agent-1 = {
			description = "polkit-gnome-authentication-agent-1";
			wantedBy = [ "graphical-session.target" ];
			wants = [ "graphical-session.target" ];
			after = [ "graphical-session.target" ];
			serviceConfig = {
				Type = "simple";
				ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
				Restart = "on-failure";
				RestartSec = 1;
				TimeoutStopSec = 10;
			};
		};
	};
        #Fixing performance
        security.pam.loginLimits = [
          { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
        ];
}
