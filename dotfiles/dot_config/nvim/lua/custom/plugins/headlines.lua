-- Prettify header lines in markdown and such
local supported_ft = { 'markdown', 'norg', 'rmd', 'org' }

return {
  'lukas-reineke/headlines.nvim',
  opts = function()
    local opts = {}
    for _, ft in ipairs(supported_ft) do
      opts[ft] = {
        headline_highlights = {},
        -- disable bullets for now. See https://github.com/lukas-reineke/headlines.nvim/issues/66
        bullets = {},
      }
      for i = 1, 6 do
        local hl = 'Headline' .. i
        vim.api.nvim_set_hl(0, hl, { link = 'Headline', default = true })
        table.insert(opts[ft].headline_highlights, hl)
      end
    end
    return opts
  end,
  ft = supported_ft,
  config = function(_, opts)
    -- PERF: schedule to prevent headlines slowing down opening a file
    vim.schedule(function()
      require('headlines').setup(opts)
      require('headlines').refresh()
    end)
  end,
}
