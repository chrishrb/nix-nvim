local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "chrishrb.lsp.mason"
require("chrishrb.lsp.handlers").setup()
require "chrishrb.lsp.null-ls"
