-- rose-pine-geist: Rose Pine accents on a neutral near-black ground.
-- Thin wrapper over rose-pine/neovim using its documented per-variant
-- palette override, so all highlight-group mappings (treesitter, LSP,
-- gitsigns, telescope, ...) come from upstream.

local ok, rose_pine = pcall(require, "rose-pine")
if not ok then
	vim.notify(
		"rose-pine-geist requires https://github.com/rose-pine/neovim",
		vim.log.levels.ERROR
	)
	return
end

-- Bust caches so re-running :colorscheme picks up palette edits (dev loop).
package.loaded["rose-pine-geist.palette"] = nil
package.loaded["rose-pine.palette"] = nil

rose_pine.setup({
	variant = "main",
	styles = { transparency = false },
	palette = { main = require("rose-pine-geist.palette") },
})

-- Call rose-pine's entry point directly: a nested :colorscheme inside a
-- colors/ file is silently ignored (load_colors recursion guard).
rose_pine.colorscheme("main")
vim.g.colors_name = "rose-pine-geist"
