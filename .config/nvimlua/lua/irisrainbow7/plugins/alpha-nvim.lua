local if_nil = vim.F.if_nil
local fnamemodify = vim.fn.fnamemodify
local filereadable = vim.fn.filereadable

local emoji = '✖'
-- local latest_commit = vim.fn.system("cd ~/neovim && git log -1 --format='%cr'"):gsub("\n", "")
local latest_commit = "not fetched"

local default_header = {
    type = "text",
    val = {
        [[                                  __]],
        [[     ___     ___    ___   __  __ /\_\    ___ ___]],
        [[    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\]],
        [[   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \]],
        [[   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
        [[    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/   ]]
            .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch .. "-dev"
            .. " (build: " .. latest_commit .. ")",
    },
    opts = {
        hl = {
          {{"Keyword", 0, -1}},
          {{"Keyword", 0, -1}},
          {{"Keyword", 0, -1}},
          {{"Keyword", 0, -1}},
          {{"Keyword", 0, -1}},
          {{"Keyword", 0, 74}, {"NvimBuild", 74, 74 + #latest_commit}, {"Keyword", 74 + #latest_commit, -1}}
        },
        shrink_margin = false,
        -- wrap = "overflow";
    },
}


--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
local function button(sc, txt, keybind, keybind_opts, hl)
    local opts = {
        position = "left",
        shortcut = "[" .. sc .. "] ",
        cursor = 1,
        -- width = 50,
        align_shortcut = "left",
        hl_shortcut = { { "Operator", 0, 1 }, { "Number", 1, #sc + 1 }, { "Operator", #sc + 1, #sc + 2 } },
        shrink_margin = false,
        hl = hl,
    }
    if keybind then
        keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { "n", sc, keybind, keybind_opts }
    end

    local function on_press()
        local key = vim.api.nvim_replace_termcodes(keybind .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "t", false)
    end

    return {
        type = "button",
        val = txt,
        on_press = on_press,
        opts = opts,
    }
end

local nvim_web_devicons = {
    enabled = true,
    highlight = true,
}

local function get_extension(fn)
    local match = fn:match("^.+(%..+)$")
    local ext = ""
    if match ~= nil then
        ext = match:sub(2)
    end
    return ext
end

local function icon(fn)
    local nwd = require("nvim-web-devicons")
    local ext = get_extension(fn)
    return nwd.get_icon(fn, ext, { default = true })
end

local function file_button(fn, sc, short_fn, autocd)
    short_fn = if_nil(short_fn, fn)
    local ico_txt
    local fb_hl = {}
    if nvim_web_devicons.enabled then
        local ico, hl = icon(fn)
        local hl_option_type = type(nvim_web_devicons.highlight)
        if hl_option_type == "boolean" then
            if hl and nvim_web_devicons.highlight then
                table.insert(fb_hl, { hl, 0, #ico })
            end
        end
        if hl_option_type == "string" then
            table.insert(fb_hl, { nvim_web_devicons.highlight, 0, #ico })
        end
        ico_txt = ico .. "  "
    else
        ico_txt = ""
    end
    local cd_cmd = (autocd and " | cd %:p:h" or "")
    local file_button_el = button(sc, ico_txt .. short_fn, "<cmd>e " .. fn .. cd_cmd .." <CR>")
    local fn_start = short_fn:match(".*[/\\]")
    if fn_start ~= nil then
        table.insert(fb_hl, { "Comment", #ico_txt, #fn_start + #ico_txt })
    end
    file_button_el.opts.hl = fb_hl
    return file_button_el
end

local default_mru_ignore = { "gitcommit" }

local mru_opts = {
    ignore = function(path, ext)
        return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
    end,
    autocd = false
}

--- @param start number
--- @param cwd string? optional
--- @param items_number number? optional number of items to generate, default = 10
local function mru(start, cwd, items_number, opts)
    opts = opts or mru_opts
    items_number = if_nil(items_number, 10)
    local oldfiles = {}
    for _, v in pairs(vim.v.oldfiles) do
        if #oldfiles == items_number then
            break
        end
        local cwd_cond
        if not cwd then
            cwd_cond = true
        else
            cwd_cond = vim.startswith(v, cwd)
        end
        local ignore = (opts.ignore and opts.ignore(v, get_extension(v))) or false
        if (filereadable(v) == 1) and cwd_cond and not ignore then
            oldfiles[#oldfiles + 1] = v
        end
    end

    local tbl = {}
    for i, fn in ipairs(oldfiles) do
        local short_fn
        if cwd then
            short_fn = fnamemodify(fn, ":.")
        else
            short_fn = fnamemodify(fn, ":~")
        end
        local file_button_el = file_button(fn, tostring(i + start - 1), short_fn,opts.autocd)
        tbl[i] = file_button_el
    end
    return {
        type = "group",
        val = tbl,
        opts = {},
    }
end

local function mru_title()
    return string.rep(emoji, 12) .. " 最近編集したファイル（カレントディレクトリ: " .. vim.fn.getcwd() .. "） " .. string.rep(emoji, 12)
end

local section = {
    header = default_header,
    top_buttons = {
        type = "group",
        val = {
            button("e", "  新規ファイル" , ":ene <BAR> startinsert <CR>", {}, "Function"),
        },
    },
    -- note about MRU: currently this is a function,
    -- since that means we can get a fresh mru
    -- whenever there is a DirChanged. this is *really*
    -- inefficient on redraws, since mru does a lot of I/O.
    -- should probably be cached, or maybe figure out a way
    -- to make it a reference to something mutable
    -- and only mutate that thing on DirChanged
    mru = {
        type = "group",
        val = {
            { type = "padding", val = 1 },
            { type = "text", val = string.rep(emoji, 50) .. " 最近編集したファイル " .. string.rep(emoji, 50), opts = { hl = "SpecialComment" } },
            { type = "padding", val = 1 },
            {
                type = "group",
                val = function()
                    return { mru(2) }
                end,
            },
        },
    },
    mru_cwd = {
        type = "group",
        val = {
            { type = "padding", val = 1 },
            { type = "text", val = mru_title, opts = { hl = "SpecialComment", shrink_margin = false } },
            { type = "padding", val = 1 },
            {
                type = "group",
                val = function()
                    return { mru(12, vim.fn.getcwd()) }
                end,
                opts = { shrink_margin = false },
            },
        },
    },
    bookmarks = {
        type = "group",
        val = {
            { type = "text", val = string.rep(emoji, 24) .. "  ブックマーク " .. string.rep(emoji, 24), opts = { hl = "SpecialComment" } },
            { type = "padding", val = 1 },
            button("l", "󰚰  Lazy check", "<cmd>:Lazy check<CR>", {}, "Constant"),
            button("m", "󰚰  Mason", "<cmd>:Mason<CR>", {}, "Constant"),
            button("c", "  vim config", "<cmd>:e ~/.config/nvimlua/<CR>", {}, "Constant"),
            button("z", "  zsh config", "<cmd>:e ~/.zshrc<CR>", {}, "Constant")
        }
    },
    bottom_buttons = {
        type = "group",
        val = {
            button("q", "󰩈 終了", "<cmd>q <CR>", {}, "Type"),
        },
    },
    footer = {
        type = "group",
        val = {},
    },
}

local config = {
    layout = {
        { type = "padding", val = 1 },
        section.header,
        { type = "padding", val = 1 },
        { type = "text", val = string.rep("🔸🔹", 46), opts = { hl = "SpecialComment" } },
        { type = "padding", val = 1 },
        section.top_buttons,
        section.mru,
        section.mru_cwd,
        { type = "padding", val = 1 },
        section.bookmarks,
        { type = "padding", val = 1 },
        { type = "text", val = string.rep("🔸🔹", 20) , opts = { hl = "SpecialComment" } },
        { type = "padding", val = 1 },
        section.bottom_buttons,
        section.footer,
    },
    opts = {
        margin = 3,
        redraw_on_resize = false,
        setup = function()
            vim.api.nvim_create_autocmd('DirChanged', {
                pattern = '*',
                group = "alpha_temp",
                callback = function () require('alpha').redraw() end,
            })
            local timer = vim.uv.new_timer()
            vim.api.nvim_create_user_command("Blink", function()
                local i = 0
                vim.bo.modifiable = true
                timer:start(300, 300, function()
                  if i % 2 == 0 then
                    vim.schedule(function()
                      vim.api.nvim_buf_set_lines(0, 8, 9, false, {'   ' .. string.rep("🔸🔹", 46)})
                    end)
                  else
                    vim.schedule(function()
                      vim.api.nvim_buf_set_lines(0, 8, 9, false, {'   ' .. string.rep("🔹🔸", 46)})
                    end)
                  end
                  i = i + 1
                end)
            end, { force = true, range = true, nargs = "*" })
            vim.keymap.set('n', '<C-c>', function()
              timer:close()
            end)
        end,
    },
}

return {
    icon = icon,
    button = button,
    file_button = file_button,
    mru = mru,
    mru_opts = mru_opts,
    section = section,
    config = config,
    -- theme config
    nvim_web_devicons = nvim_web_devicons,
    -- deprecated
    opts = config,
}
