require('spandan.lazystrap')
require('spandan.settings')
require('lazy').setup(require('spandan.plugins'), {
  ui = require('spandan.lazyui')
})
require('spandan.keymaps').keymaps()
require('spandan.theme').apply_theme()
