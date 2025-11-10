# default.nix - Overlay per i paccketti dell'Home Manager
final: prev:
{
  #i3blocks blocklets vivien/i3blocks-contrib su github
  i3blocks-contrib-battery = prev.callPackage ./packages/i3-blocks-contrib-battery.nix { };
  i3blocks-contrib-mediaplayer = prev.callPackage ./packages/i3-blocks-contrib-mediaplayer.nix { };
  i3blocks-contrib-volume = prev.callPackage ./packages/i3-blocks-contrib-volume.nix { };
  i3blocks-contrib-wifi = prev.callPackage ./packages/i3-blocks-contrib-wifi.nix { };
  i3blocks-contrib-cpu_usage = prev.callPackage ./packages/i3-blocks-contrib-cpu_usage.nix { };
  i3blocks-contrib-ssid = prev.callPackage ./packages/i3-blocks-contrib-ssid.nix { };
  i3blocks-contrib-time = prev.callPackage ./packages/i3-blocks-contrib-time.nix { };
  ghidra-fix = prev.callPackage ./packages/ghidra-fix.nix { };
  lzhuf-py = prev.callPackage ./packages/lzhuf-py/lzhuf-py.nix { };
  qlcplus-v5 = prev.callPackage ./qlcplus-v5.nix {};
  #metapacchetto con tutti i blocklets
  i3blocks-contrib = prev.buildEnv {
    name = "i3blocks-contrib";
    paths = [
      final.i3blocks-contrib-battery
      final.i3blocks-contrib-mediaplayer
      final.i3blocks-contrib-volume
      final.i3blocks-contrib-wifi
      final.i3blocks-contrib-cpu_usage
      final.i3blocks-contrib-ssid
      final.i3blocks-contrib-time
    ];
  };
}
