-- Git and version control plugins setup
return {
    -- Git gutter
    {
        "airblade/vim-gitgutter",
        config = function()
            vim.g.gitgutter_max_signs = 2048
        end,
    },

    -- Git wrapper
    {
        "tpope/vim-fugitive",
        config = function()
            vim.api.nvim_create_autocmd("QuickFixCmdPost", {
                pattern = "*grep*",
                callback = function()
                    vim.cmd("cwindow")
                end,
            })
        end,
    },

    -- Commit browser
    {
        "junegunn/gv.vim",
    },

    -- Gist client
    {
        "mattn/gist-vim",
    },
    {
        "APZelos/blamer.nvim"
    },
}
