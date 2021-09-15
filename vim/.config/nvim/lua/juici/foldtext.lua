local startswith_num
do
  local b0, b9 = string.byte('09', 1, 2)

  -- Checks if the first character is a number.
  startswith_num = function(char)
    local b = char:byte()
    return b ~= nil and b0 <= b and b <= b9
  end
end

local clean_foldtext
do
  -- Removes comment syntax and foldmarker from the text.
  clean_foldtext = function(text)
    -- Trim whitespace from `text`.
    text = vim.trim(text)

    -- Trim whitespace from the comment string.
    local cms_start = vim.trim(vim.o.commentstring)
    local cms_end = ''

    -- Locate '%s' and use the part before it.
    do
      local sub_start, sub_end = cms_start:find('%s', 1, true)
      if sub_start ~= nil then
        -- Get substring after '%s'.
        cms_end = cms_start:sub(sub_end + 1)
        -- Get substring before '%s'.
        cms_start = cms_start:sub(1, sub_start - 1)
      end
    end

    -- Strip `cms_start` from the start of `text`.
    if vim.startswith(text, cms_start) then
      text = text:sub(#cms_start + 1)
    end
    -- Strip `cms_end` from the end of `text`.
    if vim.endswith(text, cms_end) then
      text = text:sub(1, -1 - #cms_end)
    end

    -- Trim whitespace from `text`.
    text = vim.trim(text)

    -- Strip fold open marker from `text`.
    do
      local fold_open = vim.opt.foldmarker:get()[1]
      local fold_start, fold_end = text:find(fold_open, 1, true)
      if fold_start ~= nil then
        local text_start = text:sub(1, fold_start - 1)
        local text_end = text:sub(fold_end + 1)

        -- Make sure to strip fold level along with the marker.
        while startswith_num(text_end) do
          text_end = text_end:sub(2)
        end

        text = vim.trim(text_start .. vim.trim(text_end))
      end
    end

    return text
  end
end

local foldtext
do
  local dot = '·'
  local marker = '>'
  local ell = 'ℓ'
  if juici.g.is_linux_console then
    ell = ''
  end

  local function fold_char()
    local fold = vim.opt.fillchars:get().fold
    if fold == nil then
      fold = dot
    end
    return fold
  end

  foldtext = function()
    local fold = fold_char()

    local fold_start = vim.v.foldstart
    local fold_end = vim.v.foldend

    local lines = '[' .. (fold_end - fold_start + 1) .. ell .. ']'
    local first = clean_foldtext(vim.api.nvim_buf_get_lines(0, fold_start - 1, fold_start, true)[1])
    local dashes, _ = vim.v.folddashes:gsub('-', fold)

    return marker .. fold:rep(2) .. lines .. dashes .. ' ' .. first .. ' '
  end
end

return foldtext
