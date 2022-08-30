import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'

local gfx <const> = playdate.graphics
local pd <const> = playdate
local Point <const> = playdate.geometry.point

class('Wall').extends(gfx.sprite)

function Wall:init(type, level, x, y)
    self.wallImg = gfx.image.new("Images/"..type..level..".png")
    self:moveTo(x, y)
    self:setImage(self.wallImg)
    self:setCollideRect(0, 0, self:getSize())

    self.x, self.y, self.collisions, self.len = self:moveWithCollisions(Point.new(self.x, self.y))

end

function Wall:update()
    Wall.super.update(self)

end

function Wall:collisionResponse(other)
    print("collision????")
	return gfx.sprite.kCollisionTypeFreeze
end