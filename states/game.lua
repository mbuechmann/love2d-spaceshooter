local Ship = require "../models/ship"
local Asteroid = require "../models/asteroid"
local ShipRenderer = require "../renderers/ship_renderer"
local AsteroidRenderer = require "../renderers/asteroid_renderer"

local Game = {}

function Game:new(w, h)
  local game = {}
  setmetatable(game, {__index = self})

  game.w = w
  game.h = h
  game.ship = Ship:new(w, h)
  game.asteroids = {}

  game:initLevel(1)

  return game
end

function Game:draw()
  ShipRenderer.render(self.ship)
  for _, asteroid in ipairs(self.asteroids) do
    AsteroidRenderer.render(asteroid)
  end
end

function Game:update(dt)
  self.ship:update(dt)
  for _, asteroid in ipairs(self.asteroids) do
    asteroid:update(dt)
  end
end

function Game:keypressed(key)
  if key == "up" then
    self.ship:thrust(true)
  end
  if key == "left" then
    self.ship:left(true)
  end
  if key == "right" then
    self.ship:right(true)
  end
  if key == "space" then
  end
end

function Game:keyreleased(key)
  if key == "up" then
    self.ship:thrust(false)
  end
  if key == "left" then
    self.ship:left(false)
  end
  if key == "right" then
    self.ship:right(false)
  end
end

function Game:initLevel(level)
  self.level = level

  for _ = 1, level + 1 do
    table.insert(self.asteroids, Asteroid:new(self.w, self.h))
  end
end

return Game
