GameState = require "states/game"

WIDTH = 640
HEIGHT = 480

function love.load()
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
