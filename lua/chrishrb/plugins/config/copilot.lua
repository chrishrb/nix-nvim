local status_ok, copilot = pcall(require, "copilot")
if not status_ok then
  print("nok")
  return
end

-- INFO: disable copilot

-- copilot.setup({
--   suggestion = { enabled = false },
--   panel = { enabled = false },
-- })

