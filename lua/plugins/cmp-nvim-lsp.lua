return {
  {
    "hrsh7th/cmp-nvim-lua",
    config = function ()
      require("cmp").setup({
        sources = {
          {name = 'nvim_lua'}
        }
      })
    end
  }
}
