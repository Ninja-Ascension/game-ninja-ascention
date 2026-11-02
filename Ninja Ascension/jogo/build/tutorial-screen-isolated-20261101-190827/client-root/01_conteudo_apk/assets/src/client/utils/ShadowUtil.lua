
--加残影
--node 节点
--deltime 间隔生成时间
function ShadowUtil_addGhost(node,parent,positionX,positionY)
    local size = node:getBoundingBox()
    local posx,posy = node:getPosition()
    -- dump(size)
    -- print("pox:"..posx.."  posy:"..posy, size.width, size.height, size.x, size.y)
    if size.width < 1 then
        return
    end
    local canvas = cc.RenderTexture:create(size.width,size.height)
    node:setPosition(posx - size.x, posy - size.y)
    canvas:begin()
    node:visit()
    canvas:endToLua()
    cc.render()
    node:setPosition(posx,posy)

    -- debug.print_r(node._self.parent:getAnchorPoint())
    -- debug.print_r(node._self.parent:getContentSize())

    local s = node._self.parent:getContentSize()

    local ghostSp = cc.Sprite:createWithTexture(canvas:getSprite():getTexture())
    ghostSp:setAnchorPoint(0.5, 0)
    -- ghostSp:setPosition(positionX + size.width / 2 - (posx - size.x), positionY - (posy - size.y))
    ghostSp:setPosition(positionX - (posx - size.x) + size.width / 2, positionY - (posy - size.y) + s.height / 2)

    ghostSp:setColor(cc.c3b(255, 215, 104))
    ghostSp:setFlippedY(true)
    ghostSp:setScale(0.8)
    local fade = cc.Sequence:create(cc.FadeTo:create(0.8, 0),cc.CallFunc:create(function ()
        ghostSp:removeFromParent()
    end))
    parent:addChild(ghostSp)
    ghostSp:runAction(fade)
end

function ShadowUtil_addGhost_mode4(node,parent,positionX,positionY)
    local size = node:getBoundingBox()
    local posx,posy = node:getPosition()
    -- dump(size)
    -- print("pox:"..posx.."  posy:"..posy, size.width, size.height, size.x, size.y)
    if size.width < 1 then
        return
    end
    local canvas = cc.RenderTexture:create(size.width,size.height)
    node:setPosition(posx - size.x, posy - size.y)
    canvas:begin()
    node:visit()
    canvas:endToLua()
    cc.render()
    node:setPosition(posx,posy)

    -- debug.print_r(node._self.parent:getAnchorPoint())
    -- debug.print_r(node._self.parent:getContentSize())

    local s = node._self.parent:getContentSize()

    local ghostSp = cc.Sprite:createWithTexture(canvas:getSprite():getTexture())
    ghostSp:setAnchorPoint(0.5, 0)
    -- ghostSp:setPosition(positionX + size.width / 2 - (posx - size.x), positionY - (posy - size.y))
    ghostSp:setPosition(positionX - (posx - size.x) + size.width / 2, positionY - (posy - size.y))

    ghostSp:setFlippedY(true)
    ghostSp:setOpacity(119)
    local fade = cc.Sequence:create(cc.FadeTo:create(0.25, 0),cc.CallFunc:create(function ()
        ghostSp:removeFromParent()
    end))
    parent:addChild(ghostSp, node:getLocalZOrder() + 1)
    ghostSp:runAction(fade)
end

function ShadowUtil_createSprite(node)
    local size = node:getBoundingBox()
    local posx,posy = node:getPosition()
    node:setAnchorPoint(cc.p(0, 0))
    local canvas = cc.RenderTexture:create(1024,768)
    node:setPosition(0, 0)
    canvas:begin()
    node:visit()
    canvas:endToLua()
    cc.render()
    node:setPosition(posx,posy)

    local ghostSp = cc.Sprite:createWithTexture(canvas:getSprite():getTexture())
    ghostSp:setAnchorPoint(cc.p(0, 0))
    ghostSp:setPosition(cc.p(0, 0))
    ghostSp:setFlippedY(true)
    return ghostSp
end

function ShadowUtil_saveToFile( filename, width, height )
    local color = cc.LayerColor:create(cc.c4b(math.random(0, 255), math.random(0, 255), math.random(0, 255), math.random(0, 255)))
    local canvas = cc.RenderTexture:create(width,height)
    canvas:begin()
    color:visit()
    canvas:endToLua()
    cc.render()

    canvas:saveToFile(filename, cc.IMAGE_FORMAT_PNG, true)
end
