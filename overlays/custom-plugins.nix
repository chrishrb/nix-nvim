importName: inputs: let
  overlay = self: super: { 
    ${importName} = {

      # gx.nvim
      gx-nvim = super.vimUtils.buildVimPlugin {
        name = "gx.nvim";
        src = inputs.gx-nvim;
      };

      # nvim-tmux-navigation
      nvim-tmux-navigation = super.vimUtils.buildVimPlugin {
        name = "nvim-tmux-navigation";
        src = inputs.nvim-tmux-navigation;
      };

    };
  };
in
overlay
