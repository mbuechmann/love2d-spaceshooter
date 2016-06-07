local shapes = require "HC.shapes"

local COORDS = { 0, -10, 5, 5, 0, 0, -5, 5 }
local THRUSTER = {-3, 2, 0, 0, 3, 2, 0, 7}
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

  ship.area = {width = w, height = h}
  ship.accelerating = false
  ship.steeringLeft = false
  ship.steeringRight = false

  ship.vx = 0
  ship.vy = 0
  ship.rot = 0

  ship.shape = shapes.newPolygonShape(unpack(COORDS))
  ship.thruster = shapes.newPolygonShape(unpack(THRUSTER))
  local x = w / 2 or 100
  local y = h / 2 or 450
  ship.shape:move(x, y)
  ship.thruster:move(x, y)

  return ship
end

function Ship:tip()
  -- TODO: Don't use underscored fields
  local _, _, x, y = self.shape._polygon:unpack()
  return x, y
end

function Ship:center()
  return self.shape:center()
end

function Ship:update(dt)
  if self.accelerating then
    self.vx = self.vx - math.sin(self.rot) * dt * ACCELRATION
    self.vy = self.vy - math.cos(self.rot) * dt * ACCELRATION
  end
  self.shape:move(self.vx, self.vy)
  self.thruster:move(self.vx, self.vy)

  local vrot = 0
  if self.steeringLeft  then vrot = vrot + ROTATION_SPEED end
  if self.steeringRight then vrot = vrot - ROTATION_SPEED end

  local dRot = vrot * dt
  self.shape:setRotation(-self.rot)
  self.thruster:rotate(-dRot, self.shape:center())
  self.rot = (self.rot + vrot * dt) % (math.pi * 2)

  local v = math.sqrt(self.vx * self.vx + self.vy * self.vy)
  if v > MAX_SPEED then
    local factor = MAX_SPEED / v
    self.vx = self.vx * factor
    self.vy = self.vy * factor
  end

  local x, y = self.shape:center()
  if x < 0 then
    self.shape:move(self.area.width, 0)
    self.thruster:move(self.area.width, 0)
  end
  if x > self.area.width then
    self.shape:move(-self.area.width, 0)
    self.thruster:move(-self.area.width, 0)
  end
  if y < 0 then
    self.shape:move(0, self.area.height)
    self.thruster:move(0, self.area.height)
  end
  if y > self.area.height then
    self.shape:move(0, -self.area.height)
    self.thruster:move(0, -self.area.height)
  end
end

function Ship:draw()
  if self.accelerating then
    self.thruster:draw("line")
  end
  self.shape:draw("line")
end

function Ship:thrust(on)
  self.accelerating = on
  engineSource:setLooping(on)
  if on then
    engineSource:play()
  end
end

function Ship:left(on)
  self.steeringLeft = on
end

function Ship:right(on)
  self.steeringRight = on
end

return Ship
