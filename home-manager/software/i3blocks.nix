{ config, pkgs, lib, ... }:
{
  programs.i3blocks.enable = true;
  programs.i3blocks.bars = {
    config = {
      cpu_usage =  {
        command = "${pkgs.i3blocks-contrib-cpu_usage}/scripts/cpu_usage";
        interval = 10;
        LABEL = "CPU ";
      };
      battery = lib.hm.dag.entryAfter [ "cpu_usage" ] {
        command = "${pkgs.i3blocks-contrib-battery}/scripts/battery";
        interval = 5;
        LABEL = "BAT ";
      };
      volume = lib.hm.dag.entryAfter [ "battery" "cpu_usage" ] {
        command = "${pkgs.i3blocks-contrib-volume}/scripts/volume";
        LABEL="VOL ";
        interval="once";
        signal=10;
      };
      ssid = lib.hm.dag.entryAfter [ "battery" "volume" "cpu_usage" ] {
        command = "${pkgs.i3blocks-contrib-ssid}/scripts/ssid";
        INTERFACE="wlp2s0";
        interval=5;
      };
      wifi = lib.hm.dag.entryAfter [ "battery" "ssid" "volume" "cpu_usage" ] {
        command = "${pkgs.i3blocks-contrib-wifi}/scripts/.wifi-wrapped";
        label="wifi:";
        INTERFACE="wlp2s0";
        interval=5;
      };
      time = lib.hm.dag.entryAfter [ "battery" "ssid" "wifi" "volume" "cpu_usage" ] {
        command = "${pkgs.i3blocks-contrib-time}/scripts/time";
        STRFTIME_FORMAT="%Y-%m-%d %H:%M";
        TZONES="$DEFAULT_TZ";
        interval = 1;
      };
      
    };
  };
}
