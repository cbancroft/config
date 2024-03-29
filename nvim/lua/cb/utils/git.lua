local M = {}

local if_nil = vim.F.if_nil

local function git_cmd(opts)
  local plenary_loaded, Job = pcall(require, "plenary.job")
  if not plenary_loaded then
    return 1, { "" }
  end

  opts = opts or {}
  opts.cwd = opts.cwd or get_base_dir()()

  local stderr = {}
  local stdout, ret = Job
    :new({
      command = "git",
      args = opts.args,
      cwd = opts.cwd,
      on_stderr = function(_, data)
        table.insert(stderr, data)
      end,
    })
    :sync()

  if not vim.tbl_isempty(stderr) then
    print(stderr)
  end

  if not vim.tbl_isempty(stdout) then
    print(stdout)
  end

  return ret, stdout
end

local function safe_deep_fetch()
  local ret, result = git_cmd { args = { "rev-parse", "--is-shallow-repository" } }
  if ret ~= 0 then
    print "Git fetch failed! Check the log for further information"
    return
  end
  -- git fetch --unshallow will cause an error on a a complete clone
  local fetch_mode = result[1] == "true" and "--unshallow" or "--all"
  ret = git_cmd { args = { "fetch", fetch_mode } }
  if ret ~= 0 then
    print "Git fetch failed! Check the log for further information"
    return
  end
  return true
end

return M

