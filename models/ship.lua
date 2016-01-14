local Geometry = require "../utils/geometry"

local COORDS = { 0, -10, 5, 5, 0, 0, -5, 5 }
local ACCELRATION = 5
local ROTATION_SPEED = math.pi
local MAX_SPEED = 4

local engineSound = love.sound.newSoundData("assets/sounds/Engines.mp3")
local engineSource = love.audio.newSource(engineSound)
engineSource:setLooping(true)

local Ship = {}

function Ship:new(w, h)
  local ship = {}
  setmetatable(ship, {__index = self})

  ship.x = w / 2 or 100
  ship.y = h / 2 or 450
  ship.vx = 0
  ship.vy = 0
  ship.area = {width = w, height = h}
  ship.accelerating = false
  ship.steeringLeft = false
  ship.steeringRight = false
  ship.rot = 0

  return ship
end

function Ship:polygon()
  return Geometry.transform(COORDS, self.rot, self.x, self.y)
end

function Ship:tip()
  local polygon = self:polygon()
  return polygon[1], polygon[2]
end

function Ship:update(dt)
  if self.accelerating then
    self.vx = self.vx - math.sin(self.rot) * dt * ACCELRATION
    self.vy = self.vy - math.cos(self.rot) * dt * ACCELRATION
  end

  local vrot = 0
  if self.steeringLeft  then vrot = vrot + ROTATION_SPEED end
  if self.steeringRight then vrot = vrot - ROTATION_SPEED end

  self.rot = (self.rot + vrot * dt) % (math.pi * 2)

  local v = math.sqrt(self.vx * self.vx + self.vy * self.vy)
  if v > MAX_SPEED then
    local factor = MAX_SPEED / v
    self.vx = self.vx * factor
    self.vy = self.vy * factor
  end

  self.x = (self.x + self.vx) % self.area.width
  self.y = (self.y + self.vy) % self.area.height
end

function Ship:thrust(on)
  self.accelerating = on
  if on then
    engineSource:play()
  else
    engineSource:setLooping(false)
  end
end

function Ship:left(on)
  self.steeringLeft = on
end

function Ship:right(on)
  self.steeringRight = on
end

return Ship
