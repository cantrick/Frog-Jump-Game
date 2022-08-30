import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'wall'

local gfx <const> = playdate.graphics
local pd <const> = playdate
local Point <const> = playdate.geometry.point

class('Zone').extends(gfx.sprite)

function Zone:init()
    self.moveSpeed = 4
    self.level = 1
    self.backgroundImage = gfx.image.new('Images/bg'..self.level..'.png')
    self.levelObjects = json.decodeFile("levelObjects.json")
    self.levelSprites = {}

    self:changeLevel(self.level)

end

function Zone:changeLevel(level)
    --generate background given the level
    self.backgroundImage = gfx.image.new('Images/bg'..level..'.png')
    assert(self.backgroundImage)
    gfx.sprite.setBackgroundDrawingCallback(
        function( x, y, width, height )
            gfx.setClipRect( x, y, width, height ) -- let's only draw the part of the screen that's dirty
            self.backgroundImage:draw( 0, 0 )
            gfx.clearClipRect() -- clear so we don't interfere with drawing that comes after this
        end
    )

    self:loadLevelObjects(level)
end

function Zone:loadLevelObjects(level)
    --load all level objects and add colliders
    --print(self.levelObjects["wall"][tostring(self.level)][1].x)
    --remove all level objects first?
    local walls = self.levelObjects["wall"][tostring(level)]
    local floors = self.levelObjects["floor"][tostring(level)]

    for i, wall in pairs(walls) do
        newWall = Wall("wall", level, wall.x, wall.y)
        newWall:add()
        table.insert(self.levelSprites, newWall)
    end

    for i, floor in pairs(floors) do
        newFloor = Wall("floor", level, floor.x, floor.y)
        newFloor:add()
        table.insert(self.levelSprites, newFloor)
    end
end

function Zone:update()
    Zone.super.update(self)

end


