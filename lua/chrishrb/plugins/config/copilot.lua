-- setup copilot
local copilot = require("copilot")

copilot.setup {
  suggestion = { enabled = false },
  panel = { enabled = false },
}

-- setup copilot chat
local copilotChat = require("CopilotChat")
copilotChat.setup()

-- setup which-key mappings
local which_key = require("which-key")
local which_key_config = require("chrishrb.plugins.config.whichkey")

local mappings = {
  c = {
    name = "Copilot",
    c = { "<cmd>CopilotChatToggle<CR>", "Chat" },
    f = { "<cmd>CopilotChatFix<CR>", "Fix diagnostics" },
    m = { "<cmd>CopilotChatCommit<CR>", "Write commit message" },
  },
}

local vmappings = {
  c = {
    name = "Copilot",
    e = { "<cmd>CopilotChatExplain<CR>", "Explain code" },
    t = { "<cmd>CopilotChatTests<CR>", "Generate tests" },
    f = { "<cmd>CopilotChatFix<CR>", "Fix bug in selected code" },
    o = { "<cmd>CopilotChatOptimize<CR>", "Optimize code" },
    d = { "<cmd>CopilotChatDocs<CR>", "Write docs for selected code" },
  },
};

which_key.register(mappings, which_key_config.opts)
which_key.register(vmappings, which_key_config.vopts)
