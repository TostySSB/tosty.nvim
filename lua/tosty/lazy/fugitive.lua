return {
    "tpope/vim-fugitive",
    config = function()
        -- Git status
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

        -- Toggle :G blame (open if absent, close if a blame window is visible)
        vim.keymap.set("n", "<leader>gb", function()
            -- Look for an existing fugitive blame window
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.bo[buf].filetype
                if ft == "fugitiveblame" then
                    -- Close the first blame window we find (toggle off)
                    vim.api.nvim_win_close(win, true)
                    return
                end
            end
            -- None found -> open a new blame view (toggle on)
            vim.cmd('Git blame')
        end, { desc = "Toggle Git blame" })

        local Tosty_Fugitive = vim.api.nvim_create_augroup("Tosty_Fugitive", {})

        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = Tosty_Fugitive,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = {buffer = bufnr, remap = false}
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git('push')
                end, opts)

                -- rebase always
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({'pull',  '--rebase'})
                end, opts)

                -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                -- needed if i did not set the branch up correctly
                vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
            end,
        })

        -- Merge conflict helpers
        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
    end
}
