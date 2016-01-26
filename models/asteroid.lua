local HC = require "HC"
local Polygon  = require "HC.polygon"
local shapes = require "HC.shapes"

local Debris = require "models/debris"

local SHAPES = {
  {
    {-10, 0, -5, 1, -3, 8, 5, 8, 8, -2, 1, -10, -6, -9},
    {-10, 8, -7, 10, 5, 5, 9, 1, 3, -8, -5, -5, -7, 4},
    {-6, 0, -8, 4, -3, 8, 0, 5, 4, 6, 6, 2, 4, -1, 2, -8, -5, -7}
  },
  {
    {-9, 0, -15, 5, -13, 9, -5, 15, 0, 11, 5, 14, 10, 10, 15, -2, 5, -15, -12, -14, -15, -5},
    {-14, 5, -6, 14, -1, 10, 1, 13, 5, 10, 10, 10, 14, -3, 7, -8, 0, -11, -4, -13, -12, -12, -10, -3},
    {-18, 0, -15, 10, -3, 12, 0, 20, 7, 16, 15, 14, 20, 0, 18, -3, 15, -10, 8, -12, 0, -15, -2, -12, -12, -10}
  },
  {
    {-18, 0, -15, 10, -3, 12, 0, 20, 7, 16, 15, 14, 20, 0, 18, -3, 15, -10, 8, -12, 0, -15, -2, -12, -12, -10}
  }
}
local V = 200
local MAX_VROT = 0.1

local Asteroid = {}

local dieSound = love.sound.newSoundData("assets/sounds/Die 2.mp3")

function Asteroid:new(w, h, size, x, y)
  local asteroid = {}
  setmetatable(asteroid, {__index = self})

  asteroid.w = w
  asteroid.h = h

  local a = math.random() * 2 * math.pi
  asteroid.vx   = math.cos(a) * V
  asteroid.vy   = math.sin(a) * V
  asteroid.size = size or #SHAPES
  asteroid.vrot = (math.random() * MAX_VROT * 2) - MAX_VROT

  local rand = math.random(#SHAPES[asteroid.size])
  local shape = SHAPES[asteroid.size][rand]
  asteroid.shape = shapes.newPolygonShape(unpack(shape))
  asteroid.shape:move(x or math.random() * w, y or math.random() * h)

  return asteroid
end

function Asteroid:update(dt)
  self.shape:move(self.vx * dt, self.vy * dt)
  self.shape:rotate(self.vrot)
  x, y = self.shape:center()
  if x < 0 then
    self.shape:move(self.w, 0)
  end
  if x > self.w then
    self.shape:move(-self.w, 0)
  end
  if y < 0 then
    self.shape:move(0, self.h)
  end
  if y > self.h then
    self.shape:move(0, -self.h)
  end
end

function Asteroid:draw()
  self.shape:draw("line")
end

function Asteroid:spawn()
  local dieSource = love.audio.newSource(dieSound)
  dieSource:play()

  if self.size == 1 then
    return {}, {}
  end

  local x, y = self.shape:center()
  return {
    Asteroid:new(self.w, self.h, self.size - 1, x, y),
    Asteroid:new(self.w, self.h, self.size - 1, x, y)
  }, {
    Debris:new(self.w, self.h, x, y)
  }
end

return Asteroid
