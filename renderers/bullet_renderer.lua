local BulletRenderer = {}

function BulletRenderer.render(bullet)
  love.graphics.rectangle("line", bullet.x - 1, bullet.y - 1, 2, 2)
end

return BulletRenderer
