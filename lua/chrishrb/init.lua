require('nixCatsUtils').setup {
  non_nix_value = true,
}

require "chrishrb.utils"    -- util functions 
require "chrishrb.plugins"  -- load plugins
require "chrishrb.lsp"      -- lsp configuration

require "chrishrb.config.options"          -- general configuration
require "chrishrb.config.keymaps"          -- keymaps
require "chrishrb.config.commands"         -- user specifi commands
require "chrishrb.config.disable_builtins" -- disable not used builtins
require "chrishrb.autocommands"            -- user specific autocommands
