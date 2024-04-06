if not require("nixCatsUtils").isNixCats then
  return
end

-- debugger config
local jda_server_jar = vim.fn.glob(nixCats("javaExtras.java-debug-adapter") .. "/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar")
local jt_server_jars = vim.fn.glob(nixCats("javaExtras.java-test") .. "/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar")

local bundles = {}
vim.list_extend(bundles, vim.split(jt_server_jars, "\n"))
vim.list_extend(bundles, vim.split(jda_server_jar, "\n"))

return {
  on_attach = function (client, buffer)
    require("chrishrb.lsp.handlers").on_attach(client, buffer)
    require("jdtls").setup_dap { hotcodereplace = "auto" }
    require("jdtls.dap").setup_dap_main_class_configs() -- discover main class
  end,
  capabilities = require("chrishrb.lsp.handlers").capabilities,
	java = {
		-- jdt = {
		--   ls = {
		--     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
		--   }
		-- },
		eclipse = {
			downloadSources = true,
		},
		configuration = {
			updateBuildConfiguration = "interactive",
		},
		maven = {
			downloadSources = true,
		},
		implementationsCodeLens = {
			enabled = true,
		},
		referencesCodeLens = {
			enabled = true,
		},
		references = {
			includeDecompiledSources = true,
		},
		inlayHints = {
			parameterNames = {
				enabled = "all", -- literals, all, none
			},
		},
		format = {
			enabled = false,
			-- settings = {
			--   profile = "asdf"
			-- }
		},
	},
	signatureHelp = { enabled = true },
	completion = {
		favoriteStaticMembers = {
			"org.hamcrest.MatcherAssert.assertThat",
			"org.hamcrest.Matchers.*",
			"org.hamcrest.CoreMatchers.*",
			"org.junit.jupiter.api.Assertions.*",
			"java.util.Objects.requireNonNull",
			"java.util.Objects.requireNonNullElse",
			"org.mockito.Mockito.*",
		},
	},
	contentProvider = { preferred = "fernflower" },
	sources = {
		organizeImports = {
			starThreshold = 9999,
			staticStarThreshold = 9999,
		},
	},
	codeGeneration = {
		toString = {
			template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
		},
		useBlocks = true,
	},
  -- debugger
  init_options = {
    -- workspace = workspace_dir,
    bundles = bundles,
  },
}
