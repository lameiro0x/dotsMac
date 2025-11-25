return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm",       -- otras opciones: "night", "moon", "day"
      transparent = true,    -- ACTIVA LA TRANSPARENCIA
      terminal_colors = true,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = {},
        variables = {},
        sidebars = "transparent",
        floats = "transparent",
      },
    },
  },
}