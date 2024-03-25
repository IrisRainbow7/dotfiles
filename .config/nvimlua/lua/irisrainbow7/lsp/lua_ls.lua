local M = {}

---@param names string[]
---@return string[]
M.get_plugin_paths = function(names)
  local plugins = require("lazy.core.config").plugins
  local paths = {}
  for _, name in ipairs(names) do
    if plugins[name] then
      table.insert(paths, plugins[name].dir .. "/lua")
    else
      vim.notify("Invalid plugin name: " .. name)
    end
  end
  return paths
end

---@param plugins string[]
---@return string[]
M.library = function(plugins)
  local paths = M.get_plugin_paths(plugins)
  table.insert(paths, vim.fn.stdpath("config") .. "/lua")
  table.insert(paths, vim.env.VIMRUNTIME .. "/lua")
  table.insert(paths, "${3rd}/luv/library")
  table.insert(paths, "${3rd}/busted/library")
  table.insert(paths, "${3rd}/luassert/library")
  return paths
end

M.settings = {
  Lua = {
    diagnostics = {
      globals = {'vim'}
    },
    runtime = {
      version = "LuaJIT",
      pathStrict = true,
      path = { "?.lua", "?/init.lua" },
    },
    workspace = {
      library = M.library({ "lazy.nvim" }),
      checkThirdParty = "Disable",
    },
  }
}

return M
