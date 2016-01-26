local SPEED = 30

local Debris = {}

function Debris:new(w, h, x, y)
  local debris = {}
  setmetatable(debris, {__index = self})

  debris.w = w
  debris.h = h
  debris.x = x
  debris.y = y

  local rot = math.random() * 2 * math.pi
  debris.vx = math.cos(rot) * SPEED
  debris.vy = math.sin(rot) * SPEED

  return debris
end

function Debris:update(dt)
  self.x = self.x + self.vx * dt
  self.y = self.y + self.vy * dt
end

function Debris:draw()
  love.graphics.points(self.x, self.y)
end

return Debris
