	return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	config = function()
		require ('telescope').setup({})
		local builtin = require('telescope.builtin')
		
		-- Function to find the app root when in apps/ directory
		local function find_app_root()
			local cwd = vim.fn.getcwd()
			local apps_match = string.match(cwd, "(.-/apps/[^/]+)")
			if apps_match then
				return apps_match
			end
			return nil
		end
		
		-- Custom git_files that respects app boundaries
		local function git_files_in_app()
			local app_root = find_app_root()
			if app_root then
				builtin.git_files({ cwd = app_root })
			else
				builtin.git_files()
			end
		end
		
		vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
		vim.keymap.set('n', '<C-p>', git_files_in_app, {})
		vim.keymap.set('n', '<leader>pws', function()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string({ search = word})
		end
		)
		vim.keymap.set('n', '<leader>pWs', function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word})
		end
		)
		vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
		vim.keymap.set('n', '<leader>ps', function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end
		)
		vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
	end
}
