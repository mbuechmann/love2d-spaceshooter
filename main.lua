local GameState = require "states/game"

local WIDTH = 640
local HEIGHT = 480
local currentState

math.randomseed(os.time())

function love.load()
  love.graphics.setLineWidth(1.5)
  currentState = GameState:new(WIDTH, HEIGHT)
  love.window.setMode(WIDTH, HEIGHT)
end

function love.draw()
  currentState:draw()
end

function love.update(dt)
  currentState:update(dt)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
  currentState:keypressed(key)
end

function love.keyreleased(key)
  currentState:keyreleased(key)
end
