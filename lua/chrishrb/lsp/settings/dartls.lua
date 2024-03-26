return {
  lsp = {
    color = {
      enabled = true,
    },
    on_attach = require("chrishrb.lsp.handlers").on_attach,
    capabilities = require("chrishrb.lsp.handlers").capabilities,
    snippets = {
      enableSnippets = true,
    }
  }
}
