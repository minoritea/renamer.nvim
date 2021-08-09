local string = require "string"

function renamer_ls(pattern)
  glob = vim.fn.glob(pattern)
  files = vim.split(glob, "\n", true)
  max = 0
  for i, f in ipairs(files) do
    f = vim.trim(f)
    l = string.len(f)
    if l > max then
      max = l
    end
    files[i] = f
  end

  for i, f in ipairs(files) do
    files[i] = f .. string.rep(" ", max + 2 - string.len(f)) .. "-> " .. f
  end

  buff = vim.api.nvim_create_buf(true, true)
  vim.api.nvim_set_current_buf(buff)
  vim.api.nvim_put(files, "", true, true)
end

function renamer_rename()
  lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  commands = {}
  for i, f in ipairs(lines) do
    r = {}
    for v in string.gmatch(f, "%s*%S+%s*") do
      r[#r+1] = vim.trim(v)
    end

    if #r == 3 and (r[2] == "->" or r[2] == "=>") then
      commands[i] = { command = "mv", from = r[1], to = r[3] }
    end
  end
  for i, c in ipairs(commands) do
    vim.api.nvim_command("!" .. c.command .. " " .. c.from .. " " .. c.to)
  end
end
