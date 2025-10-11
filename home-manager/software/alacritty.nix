{ config, pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 16.0;
      };
      window = {
        opacity = 1;  
        padding = {
          x = 8;
          y = 8;
        };
      };
      env = {
        TERM = "xterm-256color";
      };
    };
  };
}
