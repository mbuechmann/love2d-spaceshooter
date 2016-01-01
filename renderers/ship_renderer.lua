local Geometry = require "../utils/geometry"

local THRUSTER = {-3, 2, 0, 0, 3, 2, 0, 7}

local ShipRenderer = {}

function ShipRenderer.render(ship)
  love.graphics.setLineWidth(1.5)
  love.graphics.polygon("line", ship:polygon())
  if ship.accelerating then
    love.graphics.polygon(
      "line",
      Geometry.transform(THRUSTER, ship.rot, ship.x, ship.y)
    )
  end
end

return ShipRenderer
