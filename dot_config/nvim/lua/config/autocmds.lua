-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Disable auto comment on new line
autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Auto format on save (optional, LazyVim does this by default)
-- autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function()
--     vim.lsp.buf.format()
--   end,
-- })

-- Detect devcontainer and prompt to start it
autocmd("VimEnter", {
  callback = function()
    local cwd = vim.fn.getcwd()
    local devcontainer_json = cwd .. "/.devcontainer/devcontainer.json"
    local devcontainer_root = cwd .. "/.devcontainer.json"

    local config_path = nil
    if vim.fn.filereadable(devcontainer_json) == 1 then
      config_path = devcontainer_json
    elseif vim.fn.filereadable(devcontainer_root) == 1 then
      config_path = devcontainer_root
    end

    if not config_path then
      return
    end

    vim.notify(" Devcontainer detected", vim.log.levels.INFO)

    vim.defer_fn(function()
      vim.ui.select({ "Start devcontainer", "Exec into running devcontainer", "Ignore" }, {
        prompt = "Devcontainer found. What would you like to do?",
      }, function(choice)
        if not choice or choice == "Ignore" then return end
        vim.schedule(function()
          vim.cmd("enew")
          vim.bo.modified = false
          if choice == "Start devcontainer" then
            vim.fn.termopen("echo '=> Starting devcontainer...' && devcontainer up --workspace-folder " .. vim.fn.shellescape(cwd))
          elseif choice == "Exec into running devcontainer" then
            vim.fn.termopen("echo '=> Connecting to devcontainer...' && devcontainer exec --workspace-folder " .. vim.fn.shellescape(cwd) .. " nvim .")
          end
          vim.cmd("startinsert")
        end)
      end)
    end, 500)
  end,
})
