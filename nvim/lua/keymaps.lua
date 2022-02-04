---------------------------------------------------------------
-- Keymaps configuration: neovim and plugins
---------------------------------------------------------------
---------------------------------------------------------------
-- Neovim shortcuts
---------------------------------------------------------------

-- clear search highlighting
MAP('n', '<leader>C', ':nohl<CR>', MAP_DEFAULTS)

-- map Esc to kk
MAP('i', 'kk', '<Esc>', { noremap = true })

-- fast saving with <leader> and s
MAP('n', '<leader>s', ':w<CR>', MAP_DEFAULTS)
MAP('i', '<leader>s', '<C-c>:w<CR>', MAP_DEFAULTS)

-- move around splits using Ctrl + {up, down, left, right}
MAP('n', '<C-Left>', '<C-w>h', MAP_DEFAULTS)
MAP('n', '<C-Down>', '<C-w>j', MAP_DEFAULTS)
MAP('n', '<C-Up>', '<C-w>k', MAP_DEFAULTS)
MAP('n', '<C-Right>', '<C-w>l', MAP_DEFAULTS)

-- close all windows and exit from neovim
MAP('n', '<leader>q', ':qa!<CR>', MAP_DEFAULTS)

---------------------------------------------------------------
-- Applications & Plugins shortcuts:
---------------------------------------------------------------
-- open terminal
MAP('n', '<C-t>', ':Term<CR>', { noremap = true })

-- nvim-tree
MAP('n', '<C-n>', ':NvimTreeToggle<CR>', MAP_DEFAULTS) -- open/close
MAP('n', '<leader>r', ':NvimTreeRefresh<CR>', MAP_DEFAULTS) -- refresh
MAP('n', '<leader>n', ':NvimTreeFindFile<CR>', MAP_DEFAULTS) -- search file

MAP('n', '<leader>cr', ':call cb#save_and_exec()<CR>', MAP_DEFAULTS)
