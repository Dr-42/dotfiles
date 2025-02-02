return {
  {
    "Febri-i/snake.nvim",
    dependencies = {
      "Febri-i/fscreen.nvim"
    },
    opts = {}
  },
  {
    "NStefan002/2048.nvim",
    cmd = "Play2048",
    config = true,
  },
  {
    "ActionScripted/tetris.nvim",
    cmd = { "Tetris" },
    keys = { { "<leader>T", "<cmd>Tetris<cr>", desc = "Tetris" } },
    opts = {
      -- your awesome configuration here
    },
  }
}
