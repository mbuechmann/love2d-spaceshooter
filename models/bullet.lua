local laserSound = love.sound.newSoundData("assets/sounds/Lazer.mp3")

local Bullet = {}

local SPEED = 6
local TTL = 3

function Bullet:new(w, h, x, y, rot)
  local bullet = {}
  setmetatable(bullet, {__index = self})

  bullet.w = w
  bullet.h = h
  bullet.x = x
  bullet.y = y
  bullet.vx = math.sin(rot) * -SPEED
  bullet.vy = math.cos(rot) * -SPEED
  bullet.age = 0

  local laserSource = love.audio.newSource(laserSound)
  laserSource:play()
  return bullet
end

function Bullet:update(dt)
  self.age = self.age + dt
  self.x = (self.x + self.vx) % self.w
  self.y = (self.y + self.vy) % self.h
end

function Bullet:draw()
  love.graphics.rectangle("line", self.x - 1, self.y - 1, 2, 2)
end

function Bullet:isExpired()
  return self.age > TTL
end

return  Bullet
