{
  inputs,
  config,
  pkgs,
  ...
}: let
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  imports = [inputs.nvf.homeManagerModules.default];

  programs.nvf = {
    enable = true;
    enableManpages = true;
    settings.vim = {
      lsp.enable = true;
      vimAlias = true;
      viAlias = true;
      withNodeJs = true;
      lineNumberMode = "relNumber";
      enableLuaLoader = true;
      preventJunkFiles = true;

      theme = {
        name = "catppuccin";
        style = "mocha";
      };

      options = {
        laststatus = 3;
        showmode = false;

        cursorline = true;
        cursorlineopt = "number";

        expandtab = true;
        shiftwidth = 2;
        smartindent = true;
        tabstop = 2;
        softtabstop = 2;

        ignorecase = true;
        smartcase = true;
        mouse = "a";

        number = true;
        numberwidth = 2;
        ruler = false;

        signcolumn = "yes";
        splitbelow = true;
        splitright = true;
        timeoutlen = 400;
        undofile = true;

        autoread = true;
        updatetime = 250;
      };

      terminal.toggleterm = {
        enable = true;
        setupOpts.direction = "float";
      };

      clipboard = {
        enable = true;
        registers = "unnamedplus";
        providers = {
          wl-copy.enable = true;
          xsel.enable = true;
        };
      };

      diagnostics = {
        enable = true;
        config = {
          virtual_lines.enable = true;
          underline = true;
        };
      };

      keymaps = [
        {
          key = "jk";
          mode = ["i"];
          action = "<ESC>";
          desc = "Exit insert mode";
        }
        {
          key = "<leader>ff";
          mode = ["n"];
          action = "<cmd>Telescope find_files<cr>";
          desc = "Search files by name";
        }
        {
          key = "<leader>fw";
          mode = ["n"];
          action = "<cmd>Telescope live_grep<cr>";
          desc = "Search files by contents";
        }
        {
          key = "<leader>gt";
          mode = ["n"];
          action = "<cmd>Telescope git_status<cr>";
          desc = "telescope git status";
        }
        {
          key = "<leader>cm";
          mode = ["n"];
          action = "<cmd>Telescope git_commits<cr>";
          desc = "telescope git commits";
        }
        {
          key = "<leader>fb";
          mode = ["n"];
          action = "<cmd>Telescope buffers<cr>";
        }
        {
          key = "<leader>fz";
          mode = ["n"];
          action = "<cmd>Telescope current_buffer_fuzzy_find<cr>";
        }
        {
          key = "<c-n>";
          mode = ["n"];
          action = "<cmd>NvimTreeToggle<cr>";
          desc = "File browser toggle";
        }
        {
          key = "<A-i>";
          mode = ["n"];
          action = ":ToggleTerm<cr>";
          desc = "Show terminal";
        }
        {
          key = "<A-i>";
          mode = ["t"];
          action = "<C-\\><C-n>:ToggleTerm<cr>";
          desc = "Hide terminal";
        }
        {
          key = "<Esc>";
          mode = ["t"];
          action = "<C-\\><C-n>";
          desc = "Exit terminal mode";
        }
        # {
        #   key = "<leader>cC";
        #   mode = ["n"];
        #   action = "<cmd>ClaudeCode --continue<cr>";
        #   desc = "Continue Claude conversation";
        # }
        # {
        #   key = "<leader>cV";
        #   mode = ["n"];
        #   action = "<cmd>ClaudeCode --verbose<cr>";
        #   desc = "Claude verbose mode";
        # }
      ];

      telescope = {
        enable = true;
      };

      spellcheck = {
        enable = true;
        languages = ["en"];
        programmingWordlist.enable = false; # Disabled due to missing spell files
      };

      lsp = {
        formatOnSave = true;
        lspkind.enable = false;
        lightbulb.enable = false;
        lspsaga.enable = false;
        trouble.enable = true;
        lspSignature.enable = true;
        otter-nvim.enable = false;
        nvim-docs-view.enable = false;
      };

      languages = {
        enableFormat = true;
        enableTreesitter = true;
        enableExtraDiagnostics = true;
        nix.enable = true;
        clang.enable = true;
        python.enable = true;
        markdown.enable = true;
        ts = {
          enable = true;
          lsp.enable = true;
          format.type = "prettierd";
          extensions.ts-error-translator.enable = true;
        };
        html.enable = true;
        lua.enable = true;
        css = {
          enable = true;
          format.enable = false; # Disable CSS formatting due to prettier package issue
        };
        rust = {
          enable = true;
          crates.enable = true;
        };
        tailwind.enable = true;
        php.enable = true;
      };
      visuals = {
        nvim-web-devicons.enable = true;
        nvim-cursorline.enable = true;
        cinnamon-nvim.enable = true;
        fidget-nvim.enable = true;
        highlight-undo.enable = true;
        indent-blankline.enable = true;
        rainbow-delimiters.enable = true;
      };

      statusline.lualine = {
        enable = true;
      };

      autopairs.nvim-autopairs.enable = true;
      autocomplete.nvim-cmp.enable = true;
      snippets.luasnip.enable = true;
      treesitter.context.enable = false;
      binds = {
        whichKey.enable = true;
        cheatsheet.enable = true;
      };
      git = {
        enable = true;
        gitsigns.enable = true;
        gitsigns.codeActions.enable = false;
      };
      projects.project-nvim.enable = true;
      dashboard.dashboard-nvim.enable = true;
      filetree.nvimTree.enable = false;
      notify = {
        nvim-notify.enable = false;
        nvim-notify.setupOpts.background_colour = "#${config.lib.stylix.colors.base01}";
      };
      utility = {
        preview.markdownPreview.enable = true;
        ccc.enable = false;
        vim-wakatime.enable = false;
        icon-picker.enable = true;
        surround.enable = true;
        yazi-nvim.enable = true;
        diffview-nvim.enable = true;
        motion = {
          hop.enable = false;
          leap.enable = false;
          precognition.enable = false;
          flash-nvim.enable = true;
        };
        images = {
          image-nvim.enable = false;
        };
      };

      session = {
        nvim-session-manager.enable = false;
      };
      comments = {
        comment-nvim.enable = false;
      };

      tabline.nvimBufferline = {
        enable = true;
        mappings = {
          closeCurrent = "<leader>x";
          cycleNext = "<tab>";
          cyclePrevious = "<S-tab>";
        };
      };

      assistant.copilot.enable = true;

      extraPlugins = {
        plenary-nvim = {
          package = pkgs.vimPlugins.plenary-nvim;
          setup = "";
        };
        nui-nvim = {
          package = pkgs.vimPlugins.nui-nvim;
          setup = "";
        };
        claude-code-nvim = {
          package = pkgs.vimUtils.buildVimPlugin {
            name = "claude-code-nvim";
            src = pkgs.fetchFromGitHub {
              owner = "greggh";
              repo = "claude-code.nvim";
              rev = "275c47615f4424a0329290ce1d0c18a8320fd8b0";
              sha256 = "14n96zq8yldzqf74rj52gz95n20ig1dk02n20rsjd7vraggad9cc";
            };
          };
          setup = ''
            require('claude-code').setup({
              window = {
                split_ratio = 0.5,
                enter_insert = true
              },
              keymaps = {
                toggle = {
                  normal = "<leader>ac",
                },
                variants = {
                  continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
                  verbose = "<leader>cV",  -- Normal mode keymap for Claude Code with verbose flag
                },
              }
            })
          '';
        };
        snacks-nvim = {
          package = pkgs.vimPlugins.snacks-nvim;
          setup = "";
        };
        auto-session = {
          package = pkgs.vimPlugins.auto-session;
          setup = ''
            require('auto-session').setup({
              log_level = "error",
              auto_session_suppress_dirs = { "~/", "/" },
              auto_session_use_git_branch = false,
            })
          '';
        };
        avante-nvim = {
          package = unstable.vimPlugins.avante-nvim;
          setup = ''
            -- Set dummy API key for local provider
            vim.env.OPENAI_API_KEY = "dummy-key-for-local-provider"

            require('avante').setup({
              provider = "openai",
              providers = {
                openai = {
                  endpoint = "http://localhost:11435/v1",
                  model = "claude-sonnet-4-20250514",
                  timeout = 30000,
                  max_tokens = 8192,
                  extra_request_body = {
                    temperature = 0.7,
                  },
                },
              },
            })
          '';
        };
      };

      autocmds = [
        {
          event = ["FocusGained" "BufEnter" "CursorHold" "CursorHoldI"];
          pattern = ["*"];
          command = "if mode() != 'c' | checktime | endif";
        }
        {
          event = ["FileChangedShellPost"];
          pattern = ["*"];
          command = "echohl WarningMsg | echo \"File changed on disk. Buffer reloaded.\" | echohl None";
        }
      ];
    };
  };
}
