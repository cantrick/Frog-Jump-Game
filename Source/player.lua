import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'

local gfx <const> = playdate.graphics
local pd <const> = playdate
local Point <const> = playdate.geometry.point

class('Player').extends(gfx.sprite)

local playerImage = gfx.image.new("Images/player.png")
local crouchImage = gfx.image.new("Images/player_crouch.png")

-- player states:
-- 0 : moving/walking
-- 1 : crouched down/holding A
-- 2 : mid air
local GRAVITY <const> = 0.5

function Player:init(x, y, image)
    self:moveTo(x, y)
    self:setImage(playerImage)
    self:setCollideRect(0, 0, self:getSize())

    self.moveSpeed = 4
    self.isGrounded = false
    self.moving = false
    self.state = 0
    self.yVel = 0
    self.dir = 0 --center:0, left:1, right:2
    self.jumpDir = 0

    self.x, self.y, self.collisions, self.len = self:moveWithCollisions(self.x, self.y)
    
end

function Player:doCollision()
    --check to make sure we are grounded
    if self:overlappingSprites()[1] ~= nil then
        self.yVel = 0
        self:wallCollision()
    else
        self.isGrounded = false
    end

    if self.isGrounded ~= true then
        self.yVel += GRAVITY

        if self.moving then
            if self.dir == 1 then
                self:moveBy(-GRAVITY, self.yVel)
            elseif self.dir == 2 then
                self:moveBy(GRAVITY, self.yVel)
            end
        else
            self:moveBy(0, self.yVel)
        end
    end
end

function Player:wallCollision()
    sprites = self:overlappingSprites()
    --check if the player is above the wall
    --if so, do top collision. if not, do side collision
    wallTop = sprites[1].y - sprites[1].height/2
    playerPos = self.y-11

    print("wall: "..wallTop.." -- ".. playerPos..": playerpos")
    if playerPos <= wallTop then
        self:moveTo(self.x, wallTop-10)
        playerPos = wallTop
    end
    self.isGrounded = true

end

function Player:update()
    Player.super.update(self)

    if self.state == 0 then
        self.jumpDir = 0
        if self.isGrounded then
            --self.yVel = 0
            if pd.buttonIsPressed(pd.kButtonLeft) then
                self:moveBy(-self.moveSpeed, 0)
                self.moving = true
                self.dir = 1
            elseif pd.buttonIsPressed(pd.kButtonRight) then
                self:moveBy(self.moveSpeed, 0)
                self.moving = true
                self.dir = 2
            end

            if pd.buttonJustReleased(pd.kButtonLeft) then
                self.moving = false
                self.dir = 0
            elseif pd.buttonJustReleased(pd.kButtonRight) then
                self.moving = false
                self.dir = 0
            end

            if self.dir ~= 0 and not (pd.buttonIsPressed(pd.kButtonLeft) or pd.buttonIsPressed(pd.kButtonRight)) then
                self.moving = false
                self.dir = 0
            end
        end

        self:doCollision()

        
    end

    if self.state ~= 2 then
        if self.isGrounded then
            if pd.buttonIsPressed(pd.kButtonA) then
                self:setImage(crouchImage)
                self.state = 1
                if pd.buttonIsPressed(pd.kButtonLeft) then
                    self.dir = 1
                elseif pd.buttonIsPressed(pd.kButtonRight) then
                    self.dir = 2
                else
                    self.dir = 0
                end
            end
        
            if pd.buttonJustReleased(pd.kButtonA) then
                self:setImage(playerImage)
                self.jumpDir = self.dir
                self.yVel = -8
                self.isGrounded = false
                self.state = 2
            end
        end
    end

    if self.state == 2 then
        --do jump
        if self.jumpDir == 1 then
            self:moveBy(-3, self.yVel)
        elseif self.jumpDir == 2 then
            self:moveBy(3, self.yVel)
        else
            self:moveBy(0, self.yVel)
        end
        
        if self:overlappingSprites()[1] ~= nil then
            self.yVel = 0
            self:wallCollision()
            self.isGrounded = true
            self.state = 0
        else
            self.isGrounded = false
        end

        if self.isGrounded ~= true then
            --TODO: clamp yVel at a max of like 10? to prevent going too fast
            self.yVel += GRAVITY
            self:moveBy(0, self.yVel)
        end
    end

    if self.yVel > 8 then
        self.yVel = 8
    end
    
end
