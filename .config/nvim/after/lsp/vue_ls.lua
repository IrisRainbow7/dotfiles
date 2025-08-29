local mason_tsdk_path = vim.fn.expand("$MASON/packages/vtsls/node_modules/@vtsls/language-server/node_modules/typescript/lib")

return {
  init_options = {
    typescript = {
      tsdk = mason_tsdk_path,
    },
  },
  on_new_config = function(new_config, new_root_dir)
    local lib_path = vim.fs.find("node_modules/typescript/lib", { path = new_root_dir, upward = true })[1]
    if lib_path then
      new_config.init_options.typescript.tsdk = lib_path
    end
  end,
}
