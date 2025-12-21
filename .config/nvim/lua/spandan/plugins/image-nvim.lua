return {
    "3rd/image.nvim",
    -- 1. Remove "luarocks.nvim" from dependencies. 
    -- You don't want the plugin manager trying to handle rocks on Nix.
    -- dependencies = { "luarocks.nvim" }, 
    
    -- 2. Explicitly disable the build step so it doesn't try to run luarocks
    build = false, 

    config = function()
        require("image").setup({
            rocks = {
                -- 3. Ensure the internal logic doesn't try to install rocks
                enabled = false, 
            },
            backend = "kitty",
            integrations = {
                markdown = {
                    enabled = true,
                    clear_in_insert_mode = false,
                    download_remote_images = true,
                    only_render_image_at_cursor = false,
                    filetypes = { "markdown", "vimwiki" },
                },
                neorg = {
                    enabled = true,
                    filetypes = { "norg" },
                },
            },
        })
    end
}
