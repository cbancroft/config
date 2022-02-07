_ = R 'lspconfig'
if not _ then
  return
end

R 'cbancroft.lsp.lsp-installer'
R('cbancroft.lsp.handlers').setup()
