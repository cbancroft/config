local ls = require 'luasnip'
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node

local snippet = s
local snippets = {}

local same = function(index)
  return f(function(args)
    return args[1]
  end, { index })
end

local str = function(text)
  return t { text }
end

local newline = function(text)
  return t { '', text }
end

local shortcut = function(val)
  if type(val) == 'string' then
    return { t { val }, i(0) }
  end
  if type(val) == 'table' then
    for k, v in ipairs(val) do
      if type(v) == 'string' then
        val[k] = t { v }
      end
    end
  end
  return val
end

local make = function(tbl)
  local result = {}
  for k, v in pairs(tbl) do
    table.insert(result, (snippet({ trig = k, desc = v.desc }, shortcut(v))))
  end

  return result
end

-- Every unspecified option will be set to the default.
ls.config.set_config {
  history = true,
  -- Update more often, :h events for more info.
  updateevents = 'TextChanged,TextChangedI',
}

--stylua: ignore
snippets.lua = make {
  ignore = "--stylua: ignore",
  lf = {
    desc = "table function",
    "local ", i(1), " = function(", i(2), ")", newline "  ", i(0), newline "end",
  },

  f = { "function(", i(1), ")", i(0), newline "end" },

}

local js_attr_split = function(args, old_state)
  local val = args[1][1]
  local split = vim.split(val, '.', { plain = true })

  local choices = {}
  local thus_far = {}
  for index = 0, #split - 1 do
    table.insert(thus_far, 1, split[#split - index])
    table.insert(choices, t { table.concat(thus_far, '.') })
  end

  return sn(nil, c(1, choices))
end

local fill_line = function(char)
  return function()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_get_lines(0, row - 2, row, false)
    return string.rep(char, #lines[1] - #lines[2])
  end
end


--stylua: ignore
snippets.rst = make({
	jsa = {
		":js:attr:`", d(2, js_attr_split, { 1 }), " <", i(1), ">", "`",
  },

	link = { ".. _", i(1), ":" },

	head = f(fill_line("="), {}),
	sub = f(fill_line("-"), {}),
	subsub = f(fill_line("^"), {}),

	ref = { ":ref:`", same(1), " <", i(1), ">`" },
})

ls.snippets = snippets

require('luasnip.loaders.from_vscode').load()

-- You can also use lazy loading so you only get in memory snippets of languages you use
require('luasnip/loaders/from_vscode').lazy_load()

vim.cmd [[
  imap <silent><expr> <c-k> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<c-k>'
  inoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>

  imap <silent><expr> <C-l> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-l>'

  snoremap <silent> <c-k> <cmd>lua require('luasnip').jump(1)<CR>
  snoremap <silent> <c-j> <cmd>lua require('luasnip').jump(-1)<CR>
]]
