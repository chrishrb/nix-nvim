# Copyright (c) 2023 BirdeeHub, chrishrb
# Licensed under the MIT license

{
  description = "chrishrb's nix-nvim";

  inputs = {
    # LAZY WRAPPER ONLY WORKS ON UNSTABLE
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    nixCats.inputs.nixpkgs.follows = "nixpkgs";
    nixCats.inputs.flake-utils.follows = "flake-utils";

    # plugins that are not in nixpkg
    gx-nvim = {
      url = "github:chrishrb/gx.nvim";
      flake = false;
    };
    nvim-tmux-navigation = {
      url = "github:alexghergh/nvim-tmux-navigation";
      flake = false;
    };
    nvim-nio = {
      url = "github:nvim-neotest/nvim-nio";
      flake = false;
    };
  };

  # see :help nixCats.flake.outputs
  outputs = { self, nixpkgs, flake-utils, nixCats, ... }@inputs: let
    utils = nixCats.utils;
    luaPath = "${./.}";
    forEachSystem = flake-utils.lib.eachSystem flake-utils.lib.allSystems;
    # the following extra_pkg_config contains any values
    # which you want to pass to the config set of nixpkgs
    # import nixpkgs { config = extra_pkg_config; inherit system; }
    # will not apply to module imports
    # as that will have your system values
    extra_pkg_config = {
      # allowUnfree = true;
    };
    # sometimes our overlays require a ${system} to access the overlay.
    # management of this variable is one of the harder parts of using flakes.

    # so I have done it here in an interesting way to keep it out of the way.

    # First, we will define just our overlays per system.
    # later we will pass them into the builder, and the resulting pkgs set
    # will get passed to the categoryDefinitions and packageDefinitions
    # which follow this section.

    # this allows you to use pkgs.${system} whenever you want in those sections
    # without fear.
    system_resolved = forEachSystem (system: let
      # see :help nixCats.flake.outputs.overlays
      standardPluginOverlay = utils.standardPluginOverlay;


      # you may define more overlays in the overlays directory, and import them
      # in the default.nix file in that directory.
      # see overlays/default.nix for how to add more overlays in that directory.
      # or see :help nixCats.flake.nixperts.overlays
      dependencyOverlays = [ (utils.mergeOverlayLists nixCats.dependencyOverlays.${system}
      ((import ./overlays inputs) ++ [
        (utils.standardPluginOverlay inputs)
        # add any flake overlays here.
      ])) ];
      # these overlays will be wrapped with ${system}
      # and we will call the same flake-utils function
      # later on to access them.
    in { inherit dependencyOverlays; });
    inherit (system_resolved) dependencyOverlays;
    # see :help nixCats.flake.outputs.categories
    # and
    # :help nixCats.flake.outputs.categoryDefinitions.scheme
    categoryDefinitions = { pkgs, settings, categories, name, ... }@packageDef: {
      # to define and use a new category, simply add a new list to a set here, 
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # propagatedBuildInputs:
      # this section is for dependencies that should be available
      # at BUILD TIME for plugins. WILL NOT be available to PATH
      # However, they WILL be available to the shell 
      # and neovim path when using nix develop
      propagatedBuildInputs = {
        generalBuildInputs = with pkgs; [
        ];
      };

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          universal-ctags ripgrep fd gcc
          nix-doc nil nixd nixfmt-rfc-style # nix
          lua-language-server stylua # lua
          vscode-langservers-extracted  # html, css, json
          nodePackages.bash-language-server # bash
          yaml-language-server # yaml
        ];
        go = with pkgs; [
          gopls
          delve
        ];
        python = with pkgs.python311Packages; [
          python-lsp-server
        ];
        web = with pkgs; [
          nodePackages.typescript-language-server
          tailwindcss-language-server
          nodePackages.eslint
          nodePackages.volar
          nodePackages.prettier
        ];
        java = with pkgs; [
          jdt-language-server
        ];
        devops = with pkgs; [
          terraform-ls
        ];
        latex = with pkgs; [
          texlab
        ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = {
        lazy = with pkgs.vimPlugins; [
          lazy-nvim
        ];
        go = with pkgs.vimPlugins; [
          nvim-dap-go
        ];
        python = with pkgs.vimPlugins; [
          nvim-dap-python
        ];
        java = with pkgs.vimPlugins; [
          nvim-jdtls
        ];
        debug = with pkgs.vimPlugins; [
          nvim-dap
          nvim-dap-ui
          nvim-dap-virtual-text
          pkgs.nixCatsBuilds.nvim-nio
        ];
        general = with pkgs.vimPlugins; {
          theme = builtins.getAttr packageDef.categories.colorscheme {
            # Theme switcher without creating a new category
            "catppuccin" = catppuccin-nvim;
            # "tokyonight" = tokyonight-nvim;
          };
          look = [
            lualine-nvim
            tabline-nvim
            alpha-nvim
            nvim-web-devicons
          ];
          navigation = [
            nvim-tree-lua
            which-key-nvim
          ];
          lsp = [
            nvim-lspconfig
            hover-nvim
            none-ls-nvim
            trouble-nvim
          ];
          cmp = [
            nvim-cmp
            cmp-buffer
            cmp-path
            cmp-cmdline
            cmp-nvim-lsp
            cmp-nvim-lsp-document-symbol

            cmp_luasnip
            luasnip
            friendly-snippets

            cmp-under-comparator
            cmp-spell

            copilot-cmp
          ];
          ai = [
            copilot-lua
          ];
          core = [
            plenary-nvim
            nvim-treesitter.withAllGrammars
            nvim-ts-autotag
            telescope-nvim
            telescope-fzf-native-nvim
            vim-fugitive
            gitsigns-nvim
          ];
          utils = [
            nvim-autopairs
            nvim-surround
            indent-blankline-nvim
            nvim-comment
            BufOnly-vim
            vim-bbye
            project-nvim
            mkdir-nvim
            bigfile-nvim
          ];
          custom = with pkgs.nixCatsBuilds; [
            nvim-tmux-navigation
            gx-nvim
          ];
        };
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      optionalPlugins = {
        custom = with pkgs.nixCatsBuilds; [ ];
        gitPlugins = with pkgs.neovimPlugins; [ ];
        general = with pkgs.vimPlugins; [ ];
      };

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        general = with pkgs; [
          # libgit2
        ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        test = {
          subtest1 = {
            CATTESTVAR = "It worked!";
          };
          subtest2 = {
            CATTESTVAR3 = "It didn't work!";
          };
        };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        test = [
          '' --set CATTESTVAR2 "It worked again!"''
        ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages
      extraPythonPackages = {
        test = (_:[]);
      };
      extraPython3Packages = {
        python = (py:[
          py.debugpy
          py.python-lsp-server
        ]);
      };
      extraLuaPackages = {
        test = [ (_:[]) ];
      };
    };

    extraJavaItems = pkgs: {
      java-test = pkgs.vscode-extensions.vscjava.vscode-java-test;
      java-debug-adapter = pkgs.vscode-extensions.vscjava.vscode-java-debug;
    };

    # packageDefinitions:

    # Now build a package with specific categories from above
    # All categories you wish to include must be marked true,
    # but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.
    # It is directly translated to a Lua table, and a get function is defined.
    # The get function is to prevent errors when querying subcategories.

    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions = {
      # these also recieve our pkgs variable
      chrisNvim = { pkgs, ... }@misc: {
        # see :help nixCats.flake.outputs.settings
        settings = {
          # will check for config in the store rather than .config
          wrapRc = true;
          configDirName = "chrishrb-nvim";
          aliases = [ "vi" "vim" ];
          # caution: this option must be the same for all packages.
          # nvimSRC = inputs.neovim;
        };
        # see :help nixCats.flake.outputs.packageDefinitions
        categories = {
          lazy = true;
          generalBuildInputs = true;
          general = true;
          debug = true;

          # languages
          go = true;
          python = true;
          web = true;
          java = true;
          javaExtras = extraJavaItems pkgs;
          devops = true;
          latex = false;
          ai = false;

          # this does not have an associated category of plugins, 
          # but lua can still check for it
          lspDebugMode = true;

          # you could also pass something else:
          colorscheme = "catppuccin";
        };
      };
    };

    # In this section, the main thing you will need to do is change the default package name
    # to the name of the packageDefinitions entry you wish to use as the default.
    defaultPackageName = "chrisNvim";
  in

  # see :help nixCats.flake.outputs.exports
  forEachSystem (system: let
    inherit (utils) baseBuilder;
    customPackager = baseBuilder luaPath {
      inherit nixpkgs system dependencyOverlays extra_pkg_config;
    } categoryDefinitions;
    nixCatsBuilder = customPackager packageDefinitions;
    # this is just for using utils such as pkgs.mkShell
    # The one used to build neovim is resolved inside the builder
    # and is passed to our categoryDefinitions and packageDefinitions
    pkgs = import nixpkgs { inherit system; };
  in {
    # these outputs will be wrapped with ${system} by flake-utils.lib.eachDefaultSystem

    # this will make a package out of each of the packageDefinitions defined above
    # and set the default package to the one named here.
    packages = utils.mkPackages nixCatsBuilder packageDefinitions defaultPackageName;

    # this will make an overlay out of each of the packageDefinitions defined above
    # and set the default overlay to the one named here.

    # TODO: comment out after #19 is solved
    #overlays = utils.mkOverlays nixCatsBuilder packageDefinitions defaultPackageName;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShell = pkgs.mkShell {
      name = defaultPackageName;
      packages = [ (nixCatsBuilder defaultPackageName) ];
      inputsFrom = [ ];
      shellHook = ''
      '';
    };

    # To choose settings and categories from the flake that calls this flake.
    # and you export overlays so people dont have to redefine stuff.
    inherit customPackager;
  }) // {

    # these outputs will be NOT wrapped with ${system}

    # we also export a nixos module to allow configuration from configuration.nix
    nixosModules.default = utils.mkNixosModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions nixpkgs;
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions nixpkgs;
    };
    # now we can export some things that can be imported in other
    # flakes, WITHOUT needing to use a system variable to do it.
    # and update them into the rest of the outputs returned by the
    # eachDefaultSystem function.
    inherit utils categoryDefinitions packageDefinitions dependencyOverlays;
    inherit (utils) templates baseBuilder;
    keepLuaBuilder = utils.baseBuilder luaPath;
  };

}
