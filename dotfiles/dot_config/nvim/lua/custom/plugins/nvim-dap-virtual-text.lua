-- Inline debug text
return {
  'theHamsta/nvim-dap-virtual-text',
  lazy = true,
  opts = {
    -- Display debug text as comments
    commented = true,
    -- Customize VText
    display_callback = function(var, buf, stackframe, node, options)
      if options.virt_text_pos == 'inline' then
        return ' = ' .. var.value
      else
        return var.name .. ' = ' .. var.value
      end
    end,
  },
}
