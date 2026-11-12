local ok, lualine = pcall(require, "lualine")
if not ok then return end

-- Helper functions for craftzdog-style statusline

local root_patterns = { ".git", "go.mod", "Cargo.toml", "package.json", "Makefile", "pyproject.toml" }

local function get_cwd()
  return vim.uv.cwd() or vim.fn.getcwd()
end

local function normalize(path)
  if path:sub(1, 1) == "~" then
    path = vim.fn.expand(path)
  end
  path = vim.uv.fs_realpath(path) or path
  return path:gsub("/$", "")
end

local function get_root()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    path = get_cwd()
  end
  path = vim.fs.dirname(path)
  local root = vim.fs.find(root_patterns, { path = path, upward = true })[1]
  if root then
    return normalize(vim.fs.dirname(root))
  end
  return normalize(get_cwd())
end

-- Pretty path: condensed directory + bold filename + modified indicator
local function pretty_path(opts)
  opts = vim.tbl_extend("force", {
    length = 3,
    modified_hl = "MatchParen",
    filename_hl = "Bold",
    readonly_icon = " 󰌾 ",
  }, opts or {})

  return function(self)
    local path = vim.fn.expand("%:p")
    if path == "" then return "" end

    path = normalize(path)
    local cwd = normalize(get_cwd())

    if path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, "[\\/]")

    if opts.length > 0 and #parts > opts.length then
      local truncated = { parts[1], "…" }
      for i = #parts - opts.length + 2, #parts do
        table.insert(truncated, parts[i])
      end
      parts = truncated
    end

    local filename = parts[#parts]
    local dir = ""
    if #parts > 1 then
      dir = table.concat(vim.list_slice(parts, 1, #parts - 1), sep) .. sep
    end

    local hl_group = "lualine_c_normal"
    if self and self.options and self.options.section then
      hl_group = "lualine_" .. self.options.section .. "_normal"
    end

    local dir_part = dir ~= "" and ("%#Comment#" .. dir .. "%#" .. hl_group .. "#") or ""

    local modified = vim.bo.modified
    local readonly = vim.bo.readonly or not vim.bo.modifiable

    local file_hl = modified and opts.modified_hl or opts.filename_hl
    local file_part = file_hl and ("%#" .. file_hl .. "#" .. filename .. "%#" .. hl_group .. "#") or filename

    local result = dir_part .. file_part
    if readonly then
      result = result .. opts.readonly_icon
    end

    return result
  end
end

-- Project Root display
local function root_dir_component()
  return {
    function()
      local root = get_root()
      local name = vim.fs.basename(root)
      return "󱉭 " .. name
    end,
    cond = function()
      return vim.bo.buftype == "" and vim.api.nvim_buf_get_name(0) ~= ""
    end,
    color = { fg = "#34c5b9", gui = "bold" },
  }
end

-- Macro recording indicator
local function macro_recording_component()
  return {
    function()
      return "󰑋 @" .. vim.fn.reg_recording()
    end,
    cond = function()
      return vim.fn.reg_recording() ~= ""
    end,
    color = { fg = "#ff5370", gui = "bold" },
  }
end

lualine.setup({
  options = {
    theme = "auto",
    globalstatus = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter" } },
    refresh = {
      events = {
        "WinEnter",
        "BufEnter",
        "BufWritePost",
        "SessionLoadPost",
        "FileChangedShellPost",
        "VimResized",
        "Filetype",
        "CursorMoved",
        "CursorMovedI",
        "ModeChanged",
        "RecordingEnter",
        "RecordingLeave",
      },
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = {
      root_dir_component(),
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      { pretty_path() },
    },
    lualine_x = {
      macro_recording_component(),
      {
        "diagnostics",
        symbols = {
          error = " ",
          warn = " ",
          info = " ",
          hint = " ",
        },
      },
      {
        "diff",
        symbols = {
          added = " ",
          modified = " ",
          removed = " ",
        },
        source = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed,
            }
          end
        end,
      },
    },
    lualine_y = {
      { "progress", separator = " ", padding = { left = 1, right = 1 } },
    },
    lualine_z = {
      { "location", padding = { left = 1, right = 1 } },
    },
  },
})
