local Geometry = require "../utils/geometry"

local AsteroidRenderer = {}

function AsteroidRenderer.render(asteroid)
  love.graphics.setLineWidth(1.5)
  love.graphics.polygon("line", Geometry.transform(asteroid.shape, asteroid.rot, asteroid.x, asteroid.y))
end

return AsteroidRenderer
