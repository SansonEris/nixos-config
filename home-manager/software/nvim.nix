{ config, pkgs, ... }:
let
	#NIXVIM INSTALL
	nixvim = import (builtins.fetchGit {
		url = "https://github.com/nix-community/nixvim";
    	ref = "nixos-25.05"; # for stable
  	});
in
{
	imports = [
		# For home-manager
		nixvim.homeModules.nixvim
	  ];

    home.packages = with pkgs; [
        ccls
        gopls
        clang
        clang-tools
        nixd
    ];

	#NIXVIM CONFIG
  	programs.nixvim = {
		enable = true;
		enableMan = true;
		plugins = {
			lightline.enable = true;
            cmp = {
                enable = true;
                autoEnableSources = false;
                settings = {
                    sources = [
                        { name = "nvim_lsp"; }
                        { name = "path"; }
                        { name = "buffer"; }
                    ];
                    mapping = {
                        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
                        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
                        "<C-Space>" = "cmp.mapping.complete()";
                        "<CR>" = "cmp.mapping.confirm({ select = true })";
                        "<C-e>" = "cmp.mapping.abort()";
                        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
                        "<C-f>" = "cmp.mapping.scroll_docs(4)";
                    };
                };
            };
            cmp-nvim-lsp.enable = true;
            cmp-path.enable = true;
            cmp-buffer.enable = true;
            highlight-colors.enable = true;
		};

        colorschemes.dracula.enable = true;
		extraPlugins = with pkgs.vimPlugins; [
			vim-nix
			nerdtree
			vim-lsp-cxx-highlight
            fzf-vim
            transparent-nvim
            vim-go
		];

        lsp = {
            keymaps = [
                  {
                      key = "gd";
                      lspBufAction = "definition";
                  }
                  {
                      key = "gD";
                      lspBufAction = "references";
                  }
                  {
                      key = "gt";
                      lspBufAction = "type_definition";
                  }
                  {
                      key = "gi";
                      lspBufAction = "implementation";
                  }
                  {
                      key = "K";
                      lspBufAction = "hover";
                  }
                  {
                      action = "<CMD>LspStop<Enter>";
                      key = "<leader>lx";
                  }
                  {
                      action = "<CMD>LspStart<Enter>";
                      key = "<leader>ls";
                  }
                  {
                      action = "<CMD>LspRestart<Enter>";
                      key = "<leader>lr";
                  }
                  {
                      action = "<CMD>Lspsaga hover_doc<Enter>";
                      key = "K";
                  }
            ];
            inlayHints.enable = true;
            servers = {
                nixd = {
                    enable = true;
                    activate = true;
                    settings = {
                        filetypes = [ "nix" ];
                        cmd = [ "nixd" ];
                    };
                };
                ccls = {
                    enable = true;
                    activate = true;
                    settings = {
                        cmd = [
                            "clangd"
                            "--background-index"
                        ];
                        filetypes = [
                            "c"
                            "cpp"
                        ];
                        root_markers = [
                            "compile_commands.json"
                            "compile_flags.txt"
                        ];
                    };
                };
                gopls = {
                    enable = true;
                    activate = true;
                    settings = {
                        cmd = [
                            "gopls"
                        ];
                        filetypes = [
                            "go"
                            "gomod"
                            "gowork"
                            "gotmpl"
                        ];
                        root_markers = [
                            "go.work"
                            "go.mod"
                            ".git"
                        ];
                    };
                };
            };
        };
		keymaps = [
			{
				action = "call Neovide_fullscreen()<cr>";
				key = "<F11>";
			}
			{
				action = ":NERDTree<CR>";
				key = "<C-n>";
			}
			{
				action = ":NERDTreeToggle<CR>";
				key = "<C-t>";
			}
			{
				action = ":Files<CR>";
				key = ";";
			}
		];
		extraConfigVim = ''
          let mapleader=","
          set clipboard=unnamedplus
          set completeopt=noinsert,menuone,noselect
          set cursorline
          set hidden
          set inccommand=split
          set mouse=a
          set number
          set splitbelow splitright
          set title
          set ttimeoutlen=0
          set wildmenu

          set smartindent
          set tabstop=4
          set softtabstop=0
          set shiftwidth=4
          set wrap!

          "golang
          let g:go_fold_enable = ['block', 'import', 'varconst', 'package_comment']
          let g:go_highlight_extra_types = 1
          let g:go_highlight_operators = 1
          let g:go_highlight_functions = 1
          let g:go_highlight_function_calls = 1
          let g:go_highlight_types = 1
          let g:go_highlight_fields = 1

          set guifont=Consolas:h11
          " For Vim<8, replace EndOfBuffer by NonText
          autocmd vimenter * hi EndOfBuffer guibg=NONE ctermbg=NONE
          autocmd vimenter * TransparentEnable

          filetype plugin indent on
          syntax on
          set t_Co=256
          " True color if available
          let term_program=$TERM_PROGRAM
          if $TERM !=? 'xterm-256color'
              set termguicolors
          endif
          if has('termguicolors')
              set termguicolors
          endif
		'';
	};
}
