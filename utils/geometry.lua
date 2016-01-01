local Geometry = {}

function Geometry.transform(polygon, rot, xOff, yOff)
  local result = {}

  for i = 1, #polygon, 2 do
    local x = polygon[i]
    local y = polygon[i + 1]

    result[i]     = xOff + math.cos(rot) * x + math.sin(rot) * y
    result[i + 1] = yOff - math.sin(rot) * x + math.cos(rot) * y
  end

  return result
end


return Geometry
