-- Python DAP Integration
return {
  'mfussenegger/nvim-dap-python',
  config = function()
    require('dap-python').setup('python', {})
  end,
}
