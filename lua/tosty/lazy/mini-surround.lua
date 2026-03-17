return {
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.surround").setup()
		local hipatterns = require('mini.hipatterns')
		hipatterns.setup({
			highlighters = {
				-- Highlight hex color strings (`#rrggbb`) using that color
				hex_color = hipatterns.gen_highlighter.hex_color(),
			},
		})
	end
}
