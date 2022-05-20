local M = {}

function M.setup()
  return {
    settings = {
      python = {
        pythonPath = 'python3',
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
    single_file_support = true,
  }
end

return M
