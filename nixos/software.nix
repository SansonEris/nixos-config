{ config, pkgs, ... }:
{
  services.libinput.enable = true;#Touchpad support
  services.printing.enable = true;#Printer support

  #Firefox Config
  programs.firefox.enable = true;

  #Thunar Config
  programs.thunar.enable = true;
  programs.xfconf.enable = true; #needed to save preferences
  services.gvfs.enable = true; #Mount, trash, etc.
  services.tumbler.enable = true; #Thumbnail support
  services.udisks2.enable = true;
  services.devmon.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  #Fish config
  programs.fish.enable = true;

}
