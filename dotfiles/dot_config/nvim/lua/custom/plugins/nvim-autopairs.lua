-- Auto complete brackets and such
return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {
    check_ts = true, -- treesitter enable
    ts_config = {
      lua = { 'string' }, -- No pairs in lua strings
      javascript = { 'template_string' }, -- no pairs in JS template strings
    },
  },
}
