local Gemoetry = require("../utils/geometry")

local Bullet = {}

local SPEED = 4.5
local TTL = 3

function Bullet:new(w, h, x, y, rot)
  local bullet = {}
  bullet.w = w
  bullet.h = h
  bullet.x = x
  bullet.y = y
  v = Gemoetry.transform({0, -SPEED}, rot, 0, 0)
  bullet.vx = v[1]
  bullet.vy = v[2]
  bullet.age = 0
  setmetatable(bullet, {__index = self})
  return bullet
end

function Bullet:update(dt)
  self.age = self.age + dt
  self.x = (self.x + self.vx) % self.w
  self.y = (self.y + self.vy) % self.h
end

function Bullet:isExpired()
  return self.age > TTL
end

return  Bullet
