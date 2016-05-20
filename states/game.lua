local Ship = require "../models/ship"
local Bullet = require "../models/bullet"
local Asteroid = require "../models/asteroid"

local font = love.graphics.newFont("assets/fonts/Vectorb.ttf", 20)
love.graphics.setFont(font)

local Game = {}

function Game:new(w, h)
  local game = {}
  setmetatable(game, {__index = self})

  game.w = w
  game.h = h
  game.ship = Ship:new(w, h)
  game.asteroids = {}
  game.debris = {}
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
  for _, debris in ipairs(self.debris) do
    debris:draw()
  end

  local str = string.format("%02d", self.level)
  love.graphics.printf(str, 0, 20, self.w, "center")
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

local function updateDebris(debris, dt)
  for i = #debris, 1, -1 do
    local d = debris[i]
    if d:isExpired() then
      table.remove(debris, i)
    else
      d:update(dt)
    end
  end
end

local function processCollisions(asteroids, bullets, debris)
  for i = #bullets, 1, -1 do
    local bullet = bullets[i]
    for j = #asteroids, 1, -1 do
      local asteroid = asteroids[j]
      if asteroid.shape:contains(bullet.x, bullet.y) then
        local newAsteroids, newDebris = asteroid:spawn()
        for _, a in pairs(newAsteroids) do
          table.insert(asteroids, a)
        end
        for _, d in pairs(newDebris) do
          table.insert(debris, d)
        end
        table.remove(bullets, i)
        table.remove(asteroids, j)
      end
    end
  end
end

function Game:update(dt)
  self.ship:update(dt)
  updateAsteroids(self.asteroids, dt)
  updateBullets(self.bullets, dt)
  updateDebris(self.debris, dt)
  processCollisions(self.asteroids, self.bullets, self.debris, self.ship, dt)
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
