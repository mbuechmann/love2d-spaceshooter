local Ship = require "../models/ship"
local Bullet = require "../models/bullet"
local Asteroid = require "../models/asteroid"

local Game = {}

function Game:new(w, h)
  local game = {}
  setmetatable(game, {__index = self})

  game.w = w
  game.h = h
  game.ship = Ship:new(w, h)
  game.asteroids = {}
  game.bullets = {}

  game:initLevel(1)

  return game
end

function Game:draw()
  self.ship:draw()
  for _, asteroid in ipairs(self.asteroids) do
    asteroid:draw()
  end
  for _, bullet in ipairs(self.bullets) do
    bullet:draw()
  end
end

local function updateAsteroids(asteroids, dt)
  for _, asteroid in ipairs(asteroids) do
    asteroid:update(dt)
  end
end

local function updateBullets(bullets, dt)
  for i = #bullets, 1, -1 do
    local bullet = bullets[i]
    if bullet:isExpired() then
      table.remove(bullets, i)
    else
      bullet:update(dt)
    end
  end
end

local function processCollisions(asteroids, bullets, ship, dt)
end

function Game:update(dt)
  self.ship:update(dt)
  updateAsteroids(self.asteroids, dt)
  updateBullets(self.bullets, dt)
  processCollisions(self.asteroids, self.bullets, self.ship, dt)
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
    self:addBullet()
  end
end

function Game:addBullet()
  local x, y = self.ship:tip()
  table.insert(self.bullets, Bullet:new(self.w, self.h, x, y, self.ship.rot))
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
