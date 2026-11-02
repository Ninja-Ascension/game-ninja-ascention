--[[
    author: Rock
    time:2019-10-25 11:10:15
--]]
CombinationCardClipHead = CombinationCardClipHead or {}



function CombinationCardClipHead.createCircleSprite(_senderBack,_senderIcon)
    if not _senderBack or not _senderIcon then
        return
    end
    local Draw_rect = cc.Node:create()
    Draw_rect:setAnchorPoint(cc.p(0.5,0.5))
    local Image_sp = cc.Sprite:create("images/ui/text/TF_res/combination_card/combination_card_toux_1.png")
    Image_sp:setAnchorPoint(cc.p(0.5,0.5))
    Draw_rect:addChild(Image_sp)
    
    local Clip_node = cc.ClippingNode:create(Draw_rect)
    Clip_node:setInverted(false)
    Clip_node:setAlphaThreshold(0)
    _senderIcon:setAnchorPoint(cc.p(0.5,0.5))
    _senderIcon:setPosition(cc.p(Clip_node:getContentSize().width/2,Clip_node:getContentSize().height/2))
    Clip_node:addChild(_senderIcon)
    Clip_node:setAnchorPoint(cc.p(0.5,0.5))
    Clip_node:setPosition(cc.p(_senderBack:getContentSize().width/2,_senderBack:getContentSize().height/2))
    _senderBack:addChild(Clip_node)
end


function CombinationCardClipHead.createHeroIcon(shipId)
    -- 挂上卡牌icon
    local evo_image = dms.string(dms["ship_mould"], tonumber(shipId), ship_mould.fitSkillTwo)
    if not evo_image then
        return nil
    end
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local evo_mould_id = 0
    local ship = fundShipWidthTemplateId(tonumber(shipId))
    if ship ~= nil then
        local ship_evo = zstring.split(ship.evolution_status, "|")
        evo_mould_id = smGetSkinEvoIdChange(ship)
    else
        local captain_name = dms.int(dms["ship_mould"], tonumber(shipId), ship_mould.captain_name)
        evo_mould_id = evo_info[captain_name]
    end
    local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    local icons = cc.Sprite:create(string.format("images/ui/props/props_%d.png", picIndex))
    
    icons:setScale(0.8)

    return icons
            
end

-- 置灰头像
function CombinationCardClipHead.createGrayHeroIcon(shipId)
    -- 挂上卡牌icon
    local evo_image = dms.string(dms["ship_mould"], tonumber(shipId), ship_mould.fitSkillTwo)
    if not evo_image then
        return nil
    end
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local evo_mould_id = 0
    local ship = fundShipWidthTemplateId(tonumber(shipId))
    if ship ~= nil then
        local ship_evo = zstring.split(ship.evolution_status, "|")
        evo_mould_id = smGetSkinEvoIdChange(ship)
    else
        local captain_name = dms.int(dms["ship_mould"], tonumber(shipId), ship_mould.captain_name)
        evo_mould_id = evo_info[captain_name]
    end
    local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    local icons = cc.Sprite:create(string.format("images/ui/props/props_%d.png", picIndex))
    display:gray(icons)

    return icons
            
end