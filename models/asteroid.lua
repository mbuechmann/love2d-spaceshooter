local SHAPES = {
  {
    {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5, 0.5, -0.5}
  },
  {
    {-10, 0, -5, 1, -3, 8, 5, 8, 8, -2, 1, -10, -6, -9},
    {-10, 8, -7, 10, 5, 5, 9, 1, 3, -8, -5, -5, -7, 4},
    {-6, 0, -8, 4, -3, 8, 0, 5, 4, 6, 6, 2, 4, -1, 2, -8, -5, -7}
  },
  {
    {-9, 0, -15, 5, -13, 9, -5, 15, 0, 11, 5, 14, 10, 10, 15, -2, 5, -15, -12, -14, -15, -5},
    {-14, 5, -6, 14, -1, 10, 1, 13, 5, 10, 10, 10, 14, -3, 7, -8, 0, -11, -4, -13, -12, -12, -10, -3},
    {-18, 0, -15, 10, -3, 12, 0, 20, 7, 16, 15, 14, 20, 0, 18, -3, 15, -10, 8, -12, 0, -15, -2, -12, -12, -10}
  }
}
local V = 3
local MAX_VROT = 0.1

local Asteroid = {}

function Asteroid:new(w, h, size, x, y)
  local asteroid = {}

  setmetatable(asteroid, {__index = self})

  asteroid.w = w
  asteroid.h = h

  local a = math.random() * 2 * math.pi
  asteroid.vx   = math.cos(a) * V
  asteroid.vy   = math.sin(a) * V
  asteroid.size = size or 3
  asteroid.x    = math.random() * w
  asteroid.y    = math.random() * h
  asteroid.rot  = math.random() * math.pi * 2
  asteroid.vrot = (math.random() * MAX_VROT * 2) - MAX_VROT

  local shapes = SHAPES[asteroid.size]
  asteroid.shape = shapes[math.random(#shapes)]

  return asteroid
end

function Asteroid:update(dt)
  self.x = self.x + self.vx
  self.y = self.y + self.vy
  self.rot = (self.rot + self.vrot) % (math.pi * 2)

  self.x = self.x % self.w
  self.y = self.y % self.h
end

return Asteroid
