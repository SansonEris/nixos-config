{ config, pkgs, ... }:
{
    #FISH CONFIG
    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = {
          body = "fortune -n 25 | cowsay -f tux";
        };
        fish_prompt = {
          body = ''
            set_color $fish_color_user
            echo -n $USER
            set_color normal
            echo -n '@'
            set_color $fish_color_host
            echo -n (prompt_hostname)
            set_color normal
            echo -n ':'
            set_color $fish_color_cwd
            echo -n (prompt_pwd)
            set_color normal
            echo -n '$ '
          '';
        };
        n = {
          body = ''
                    # Block nesting of nnn in subshells
                    if test -n "$NNNLVL" -a "$NNNLVL" -ge 1
                        echo "nnn is already running"
                        return
                    end
                    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
                    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
                    # see. To cd on quit only on ^G, remove the "-x" from both lines below,
                    # without changing the paths.
                    if test -n "$XDG_CONFIG_HOME"
                        set -x NNN_TMPFILE "$XDG_CONFIG_HOME/nnn/.lastd"
                    else
                        set -x NNN_TMPFILE "$HOME/.config/nnn/.lastd"
                    end
                    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
                    # stty start undef
                    # stty stop undef
                    # stty lwrap undef
                    # stty lnext undef
                    # The command function allows one to alias this function to `nnn` without
                    # making an infinitely recursive alias
                    command nnn $argv
                    if test -e $NNN_TMPFILE
                        source $NNN_TMPFILE
                        rm -- $NNN_TMPFILE
                    end
          '';
        };
      };
      shellAliases = {
        idf_env = "nix develop ~/Coding/shells/nixpkgs-esp-dev#esp-idf-full --command fish";
        toggle = "swaymsg output eDP-1 toggle";
        nix-rebuild = "sudo nixos-rebuild switch";
      };
      interactiveShellInit = ''
  # Colori vivaci e decisi per Fish
        set -g fish_color_normal e0e0e0
        set -g fish_color_command 00d7ff
        set -g fish_color_quote 5fff5f
        set -g fish_color_redirection ff79c6
        set -g fish_color_end d787ff
        set -g fish_color_error ff5f5f
        set -g fish_color_param ffffff
        set -g fish_color_comment 8787af
        set -g fish_color_match --background=5f5f87
        set -g fish_color_selection ffffff --bold --background=5f5f87
        set -g fish_color_search_match ffd787 --background=5f5f87
        set -g fish_color_history_current --bold
        set -g fish_color_operator ff79c6
        set -g fish_color_escape 00d7ff
        set -g fish_color_cwd 5fafff
        set -g fish_color_cwd_root ff5f5f
        set -g fish_color_valid_path --underline
        set -g fish_color_autosuggestion 8787af
        set -g fish_color_user 5fff87
        set -g fish_color_host e0e0e0
        set -g fish_color_cancel -r
        set -g fish_pager_color_completion e0e0e0
        set -g fish_pager_color_description ffd787 ff8700
        set -g fish_pager_color_prefix 5fafff --bold --underline
        set -g fish_pager_color_progress ffffff --background=5f5f87
  # Colori vivaci e decisi per ls
        set -gx LS_COLORS 'di=1;38;2;95;175;255:ln=1;38;2;255;121;198:so=1;38;2;215;135;255:pi=1;38;2;255;215;135:ex=1;38;2;95;255;135:bd=1;38;2;0;215;255:cd=1;38;2;0;215;255:su=1;38;2;255;255;255:sg=1;38;2;224;224;224:tw=1;38;2;95;175;255:ow=1;38;2;95;175;255:*.tar=1;38;2;255;95;95:*.zip=1;38;2;255;95;95:*.jpg=1;38;2;255;121;198:*.png=1;38;2;255;121;198:*.gif=1;38;2;255;121;198'
      '';
    };
  }
