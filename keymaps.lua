local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "

--------------------------------------------------
-- Better Escape (insert mode)
--------------------------------------------------
map("i", "jj", "<Esc>", opts)
map("i", "jk", "<Esc>", opts)

--------------------------------------------------
-- Window navigation
--------------------------------------------------
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-l>", "<C-w>l", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-j>", "<C-w>j", opts)

map("t", "<C-h>", "<C-\\><C-n><C-w>h", opts)
map("t", "<C-l>", "<C-\\><C-n><C-w>l", opts)
map("t", "<C-k>", "<C-\\><C-n><C-w>k", opts)
map("t", "<C-j>", "<C-\\><C-n><C-w>j", opts)

--------------------------------------------------
-- Save / buffers
--------------------------------------------------
map("n", "<C-s>", "<cmd>w<cr>", opts)
map("n", "<leader>w", "<cmd>w<cr>", opts)

map("n", "<S-h>", "<cmd>bprevious<cr>", opts)
map("n", "<S-l>", "<cmd>bnext<cr>", opts)

map("n", "<S-q>", "<cmd>bd<cr>", opts)
map("n", "<C-q>", "<cmd>bd<cr>", opts)
map("n", "<leader>bd", "<cmd>bd<cr>", opts)
map("n", "<leader>q", "<cmd>bd<cr>", opts)
map("n", "<leader>c", "<cmd>bd<cr>", opts)

-- close other buffers (keeps current)
map("n", "<leader>bo", "<cmd>%bd|e#|bd#<cr>", opts)

--------------------------------------------------
-- Telescope (files/search) - SAFE
--------------------------------------------------
local ok_telescope, builtin = pcall(require, "telescope.builtin")
if ok_telescope then
  map("n", "<leader><leader>", builtin.find_files, opts) -- space space
  map("n", "<leader>sf", builtin.find_files, opts)       -- space s f

  map("n", "<leader>/", builtin.live_grep, opts)         -- space /
  map("n", "<leader>st", builtin.live_grep, opts)        -- space s t

  map("n", "<leader>sw", builtin.grep_string, opts)      -- space s w
  map("n", "<leader>fp", builtin.oldfiles, opts)         -- space f p (open recent)
else
  -- fallback: at least don't error on startup
  map("n", "<leader><leader>", "<cmd>edit .<cr>", opts)
  map("n", "<leader>sf", "<cmd>edit .<cr>", opts)
end

--------------------------------------------------
-- File tree / project panel
--------------------------------------------------
-- Zed: "space e": RevealInProjectPanel
-- Neovim: toggle file tree (common equivalent)
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", opts)

--------------------------------------------------
-- LSP
--------------------------------------------------
map("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- space c a
map("n", "<leader>.", vim.lsp.buf.code_action, opts)  -- space .
map("n", "<leader>cr", vim.lsp.buf.rename, opts)      -- space c r

map("n", "gd", vim.lsp.buf.definition, opts)
map("n", "gD", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", opts)

map("n", "gi", vim.lsp.buf.implementation, opts)
map("n", "gI", "<cmd>vsplit | lua vim.lsp.buf.implementation()<cr>", opts)

map("n", "gt", vim.lsp.buf.type_definition, opts)
map("n", "gT", "<cmd>vsplit | lua vim.lsp.buf.type_definition()<cr>", opts)

map("n", "gr", vim.lsp.buf.references, opts)

map("n", "]d", vim.diagnostic.goto_next, opts)
map("n", "[d", vim.diagnostic.goto_prev, opts)
map("n", "]e", vim.diagnostic.goto_next, opts)
map("n", "[e", vim.diagnostic.goto_prev, opts)

--------------------------------------------------
-- Diagnostics panel (Trouble) - SAFE
--------------------------------------------------
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", opts) -- space x x

--------------------------------------------------
-- Symbols
--------------------------------------------------
-- Zed: "s s": outline toggle
map("n", "ss", "<cmd>SymbolsOutline<cr>", opts)

-- Zed: "s S": project_symbols toggle
-- Neovim: workspace symbols via telescope (if available)
if ok_telescope then
  map("n", "sS", builtin.lsp_workspace_symbols, opts)
end

--------------------------------------------------
-- Git hunks (gitsigns) - SAFE
--------------------------------------------------
local ok_gs, gs = pcall(require, "gitsigns")
if ok_gs then
  map("n", "]h", gs.next_hunk, opts)
  map("n", "[h", gs.prev_hunk, opts)

  -- Zed: space g h d / space g h r
  map("n", "<leader>ghd", gs.preview_hunk, opts)
  map("n", "<leader>ghr", gs.reset_hunk, opts)
end

--------------------------------------------------
-- Toggle inlay hints
--------------------------------------------------
map("n", "<leader>ti", function()
  -- Neovim 0.10+: vim.lsp.inlay_hint.*
  local ok = pcall(function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end)
  if not ok then
    vim.notify("Inlay hints not supported by this Neovim/server", vim.log.levels.WARN)
  end
end, opts)

--------------------------------------------------
-- Toggle soft wrap
--------------------------------------------------
map("n", "<leader>uw", "<cmd>set wrap!<cr>", opts)

--------------------------------------------------
-- Zen mode (zen-mode.nvim)
--------------------------------------------------
map("n", "<leader>cz", "<cmd>ZenMode<cr>", opts)

--------------------------------------------------
-- Markdown preview (markdown-preview.nvim)
--------------------------------------------------
map("n", "<leader>mp", "<cmd>MarkdownPreview<cr>", opts)
map("n", "<leader>mP", "<cmd>MarkdownPreviewToogle<cr>", opts) -- NOTE: plugin command is "MarkdownPreviewToggle"
-- fix typo safely by also mapping correct one
map("n", "<leader>mP", "<cmd>MarkdownPreviewToggle<cr>", opts)

--------------------------------------------------
-- Search word under cursor (Zed: DeploySearch) already mapped above:
--   <leader>sw -> telescope grep_string
--------------------------------------------------

--------------------------------------------------
-- Comments (visual) - requires Comment.nvim
--------------------------------------------------
-- Zed: "g c" and "space /" in visual
map("v", "gc", function()
  local ok_comment, api = pcall(require, "Comment.api")
  if ok_comment then
    api.toggle.linewise(vim.fn.visualmode())
  end
end, opts)

map("v", "<leader>/", function()
  local ok_comment, api = pcall(require, "Comment.api")
  if ok_comment then
    api.toggle.linewise(vim.fn.visualmode())
  end
end, opts)

--------------------------------------------------
-- Terminal toggle (toggleterm.nvim)
--------------------------------------------------
map("n", "<C-\\>", "<cmd>ToggleTerm<cr>", opts)
map("t", "<C-\\>", "<cmd>ToggleTerm<cr>", opts)

--------------------------------------------------
-- gf: go to file under cursor (built-in)
--------------------------------------------------
map("n", "gf", "<cmd>edit <cfile><cr>", opts)
