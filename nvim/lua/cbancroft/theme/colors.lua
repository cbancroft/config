local config = require('cbancroft.config')
local colors = {}
local mod = 'cbancroft.theme.integrated.'
local supported_themes = require('cbancroft.theme.plugins').supported_themes

for _, theme in pairs(supported_themes) do
  if theme == config.theme then
    colors = require(mod .. theme)
  end
end

if vim.tbl_isempty(colors) then
  return false
end

return colors
