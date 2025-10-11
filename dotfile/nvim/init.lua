--                                     ██
--                                    ░░
--  ███████   █████   ██████  ██    ██ ██ ██████████
-- ░░██░░░██ ██░░░██ ██░░░░██░██   ░██░██░░██░░██░░██
--  ░██  ░██░███████░██   ░██░░██ ░██ ░██ ░██ ░██ ░██
--  ░██  ░██░██░░░░ ░██   ░██ ░░████  ░██ ░██ ░██ ░██
--  ███  ░██░░██████░░██████   ░░██   ░██ ███ ░██ ░██
-- ░░░   ░░  ░░░░░░  ░░░░░░     ░░    ░░ ░░░  ░░  ░░
--
--  ▓▓▓▓▓▓▓▓▓▓
-- ░▓ author ▓ xero <x@xero.style>
-- ░▓ code   ▓ https://code.x-e.ro/dotfiles
-- ░▓ mirror ▓ https://git.io/.files
-- ░▓▓▓▓▓▓▓▓▓▓
-- ░░░░░░░░░░

require("general")
require("ui")
require("commands")

vim.cmd [[
	highlight Normal guibg=none
	highlight NormalNC guibg=none
	highlight SignColumn guibg=none
	highlight VertSplit guibg=none
]]


if vim.g.noplugins == nil then
	require("lazy-plugins")
	else
		vim.cmd("source " .. vim.fn.stdpath("data") .. "/lazy/evangelion.nvim/extras/evangelion.vim")
		end

vim.cmd("colorscheme industry")
