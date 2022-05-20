local M = {}
function M.setup()
  return {
    cmd = {
      "clangd",
      "--background-index",
      "--suggest-missing-includes",
      "--clang-tidy",
      "--header-insertion=iwyu"
    },
    init_options = {
      clangdFileStatus = true,
    }
  }
end

return M
