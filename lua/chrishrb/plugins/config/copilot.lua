local copilot = require("copilot")
local copilotChat = require("CopilotChat")

copilot.setup {
  suggestion = { enabled = false },
  panel = { enabled = false },
}

copilotChat.setup()

-- setup which-key mappings
local which_key = require("which-key")
local which_key_config = require("chrishrb.plugins.config.whichkey")

local mappings = {
  c = {
    name = "Copilot",
    c = { "<cmd>CopilotChatToggle<CR>", "Chat" },
    e = { "<cmd>CopilotChatExplain<CR>", "Explain code" },
    t = { "<cmd>CopilotChatTests<CR>", "Generate tests" },
    f = { "<cmd>CopilotChatFix<CR>", "Fix bug" },
    o = { "<cmd>CopilotChatOptimize<CR>", "Optimize code" },
    d = { "<cmd>CopilotChatDocs<CR>", "Write docs for selected code" },
    m = { "<cmd>CopilotChatCommit<CR>", "Write commit message" },
  },
}

which_key.register(mappings, which_key_config.opts)
