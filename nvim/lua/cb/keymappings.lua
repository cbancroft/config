local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
  insert_mode = generic_opts_any,
  normal_mode = generic_opts_any,
  visual_mode = generic_opts_any,
  visual_block_mode = generic_opts_any,
  term_mode = { silent = true },
}

local mode_adapters = {
  insert_mode = 'i',
  normal_mode = 'n',
  term_mode = 't',
  visual_mode = 'v',
  visual_block_mode = 'x',
  command_mode = 'c',
}

local defaults = {
  -- @usage change or add keymappings for insert mode
  insert_mode = {
    -- 'jk' for quitting insert mode
    ['jk'] = '<ESC>',
    -- 'kj' for quitting insert mode
    ['kj'] = '<ESC>',
    -- 'jj' for quitting insert mode
    ['kk'] = '<ESC>',
    -- Move current line/block with Alt-j/k
    ['<A-j>'] = '<Esc>:m .+1<CR>==gi',
    ['<A-k>'] = '<Esc>:m .-2<CR>==gi',
  },

  -- @usage change or add keymappings for normal mode
  normal_mode = {
    -- Better window movement
    ["<C-Up>"] = "<C-w>k",
    ["<C-Down>"] = "<C-w>j",
    ["<C-Left>"] = "<C-w>h",
    ["<C-Right>"] = "<C-w>l",

    -- Resize with arrows too
    ["<C-S-Up>"] = ":resize -2<cr>",
    ["<C-S-Down>"] = ":resize +2<cr>",
    ["<C-S-Left>"] = ":vertical resize -2<cr>",
    ["<C-S-Right>"] = ":vertical resize +2<cr>",

    -- Tab switch buffers
    ["<S-l>"] = ":BufferLineCycleNext<CR>",
    ["<S-h>"] = ":BufferLineCyclePrev<CR>",

    -- Move current line/block with Alt-j/k
    ['<A-j>'] = ':m .+1<CR>==',
    ['<A-k>'] = ':m .-2<CR>==',

    -- Quickfix
    ["]q"] = ":cnext<cr>",
    ["[q"] = ":cprev<cr>",
    ["<C-q>"] = ":call QuickFixToggle()<cr>",
  },
  -- @usage change or add keymappings for terminal mode
  term_mode = {
    -- Terminal window navigation
    ["<C-h>"] = "<C-\\><C-N><C-w>h",
    ["<C-j>"] = "<C-\\><C-N><C-w>j",
    ["<C-k>"] = "<C-\\><C-N><C-w>k",
    ["<C-l>"] = "<C-\\><C-N><C-w>l",
  },
  -- @usage change or add keymappings for visual mode
  visual_mode = {
    -- Better indenting
    ["<"] = "<gv",
    [">"] = ">gv",
  },

  -- @usage change or add keymappings for visual block mode
  visual_block_mode = {
    -- Move selected line / block of text in visual mode
    ["K"] = ":move '<-2<CR>gv-gv",
    ["J"] = ":move '>+1<CR>gv-gv",

    -- Move current line / block with Alt-j/k ala vscode.
    ["<A-j>"] = ":m '>+1<CR>gv-gv",
    ["<A-k>"] = ":m '<-2<CR>gv-gv",

  },
  -- @usage change or add keymappings for command mode
  command_mode = {
    -- navigate tab completion with <C-j> and <C-k>
    -- Runs conditionally
    ["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', {expr = true, noremap = true}},
    ["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', {expr = true, noremap = true}},
  },
}

-- Append key mappings to defaults for a given mode
-- @param keymaps The table of key mappings containing a list per mode
function M.append_to_defaults(keymaps)
  for mode, mappings in pairs(keymaps) do
    for k, v in pairs(mappings) do
      defaults[mode][k] = v
    end
  end
end

-- Unsets all keybindings defined in keymaps
-- @param keymaps The table of key mappings containing a list per mode
function M.clear(keymaps)
  local default = M.get_defaults()
  for mode, mappings in pairs(keymaps) do
    local translated_mode = mode_adapters[mode] or mode
    for key, _ in pairs(mappings) do
      -- Some plugins may have overridden some default bindings too
      if default[mode][key] ~= nil or (default[translated_mode] ~= nil and default[translated_mode][key] ~= nil) then
        pcall(vim.api.nvim_del_keymap, translated_mode, key)
      end
    end
  end
end

-- Set key mappings individually
-- @param mode The keymap mode, or an entry from mode_adapters
-- @param key The key of keymap
-- @param val Mapping or tuple of mapping and user defined opt
function M.set_keymaps(mode, key, val)
  local opt = generic_opts[mode] or generic_opts_any
  if type(val) == 'table' then
    opt = val[2]
    val = val[1]
  end

  if val then
    vim.api.nvim_set_keymap(mode, key, val, opt)
  else
    pcall(vim.api.nvim_buf_del_keymap, mode, key)
  end
end

-- Load key mappings for a given node
-- @param mode Keymap mode
-- @param keymaps The list of key mappings
function M.load_mode(mode, keymaps)
  mode = mode_adapters[mode] or mode
  for k,v in pairs(keymaps) do
    M.set_keymaps(mode, k, v)
  end
end

-- Load key mappings for all modes
-- @param keymaps A list of key mappings for each mode
function M.load(keymaps)
  keymaps = keymaps or {}
  for mode, mapping in pairs(keymaps) do
    M.load_mode(mode, mapping)
  end
end

-- Load the default keymappings
function M.load_defaults()
  M.load(M.get_defaults())
  cb.keys = {}
  for idx, _ in pairs(defaults) do
    cb.keys[idx] = {}
  end
end

-- Get the default keymaps
function M.get_defaults()
  return defaults
end

return M
