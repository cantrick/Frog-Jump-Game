import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'

import 'player'
import 'zone'

local gfx <const> = playdate.graphics
gameState = 1

function setup()
    font = gfx.font.new('Font/dpaint_8')
    gfx.setFont(font)

    zone = Zone()
    zone:add()

    player = Player(87, 80)
    player:add()

    

end

setup()

function debug()
    gfx.drawText('grounded: '..tostring(player.isGrounded), 22, 10)
    --gfx.drawText("num collisions: ".. tostring(player:overlappingSprites()[1]),22, 30)
    gfx.drawText('moving: '..tostring(player.moving), 22, 30)
    gfx.drawText('dir: '..tostring(player.dir) .. " - " .. tostring(player.jumpDir), 22, 50)
    gfx.drawText("playerstate: ".. tostring(player.state),22, 70)

    gfx.drawText("player.yVel: ".. tostring(player.yVel),252, 10)

end


function playdate.update()

    if gameState == 0 then
        --display the start screen
    elseif gameState == 1 then
        --game is running
    end

    gfx.sprite.update()
    debug()
    playdate.timer.updateTimers()
end
