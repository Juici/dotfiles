local autoload = require('juici.autoload')
local juici = autoload('juici')

-- Use a real global here to ensure that anything stashed in `juici.g` survives
-- even after the last reference to it goes away.
_G.juici = juici

return juici
