-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏绘图工具库
-- -----------------------------------------------------------------------------------------------------
draw = draw or {}

draw.addHeroStar = function(panel,stars_number,stars_level)
    if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
        local sprite_star = cc.Sprite:create("images/ui/pve/pve_checkpoint_star.png")
        local star_size = sprite_star:getContentSize()
        panel:setContentSize(cc.size(star_size.width*stars_number,star_size.height))
        local offset = star_size.width * stars_number / 2
        for i=1,stars_number do
            local star = cc.Sprite:create("images/ui/pve/pve_checkpoint_star.png")
            star:setAnchorPoint(cc.p(0, 0.5))
            star:setPositionX((i - 1 ) * star_size.width - offset)
            panel:addChild(star)
        end
    else
    	local sprite_star = cc.Sprite:create("images/ui/state/small_star_"..stars_level..".png")
    	local star_size = sprite_star:getContentSize()
    	panel:setContentSize(cc.size(star_size.width*stars_number,star_size.height))
    	-- debug.print_r(panel:getContentSize())
    	for i=1,stars_number do
    		local star = cc.Sprite:create("images/ui/state/small_star_"..stars_level..".png")
    		star:setAnchorPoint(cc.p(0, 0.5))
    		star:setPositionX(panel:getContentSize().width/stars_number *(i-1))
    		panel:addChild(star)
    	end
    end
end

-- 兵符星星
draw.addWeaponBookStar = function(panel, stars, direction)
    local sprite_star = cc.Sprite:create("images/ui/state/pve_star_0_bg.png")
    local star_size = sprite_star:getContentSize()
    if direction == 0 then      -- 水平画
        panel:setContentSize(cc.size(star_size.width*5, star_size.height))
    else                        -- 垂直画
        panel:setContentSize(cc.size(star_size.width, star_size.height*5))
    end

    for i=1,5 do
        local star_sp = nil
        if i <= stars then
            star_sp = cc.Sprite:create("images/ui/state/pve_star_0.png")
        else
            star_sp = cc.Sprite:create("images/ui/state/pve_star_0_bg.png")
        end
        if direction == 0 then
            star_sp:setAnchorPoint(cc.p(0, 0.5))
            star_sp:setPositionX(panel:getContentSize().width/5 *(i-1))
        else
            star_sp:setAnchorPoint(cc.p(0.5, 0))
            star_sp:setPositionY(panel:getContentSize().height/5 *(4-i))
        end
        panel:addChild(star_sp)
    end
end

draw.convertChangeToParentPos = function(parent_panel,node)
    local now_node = node
    local index = 0
    local new_pos = cc.p(0,0)
    local con_size = node:getContentSize()
    local pox,poy = node:getPosition()
    local an_point = node:getAnchorPoint()
    local x = 0
    local y = 0

    if an_point.x == 0 and an_point.y == 0 then
    	x = pox + con_size.width / 2 
    	y = poy + con_size.height / 2
    else
    	x = pox
    	y = poy
    end
    while index < 100 do
        index = index + 1
        -- print("==========oldxy==",x,y,index)
        if now_node:getParent() ~= nil then
            local parent_x , parent_y = now_node:getParent():getPosition()
            x = x + parent_x
            y = y + parent_y
            -- print("========parent_x --- parent_y",parent_x , parent_y)
            -- print("==========newxy==",x,y,index)
        end
        if parent_panel == now_node:getParent() then
            -- print("=============break=",parent_panel:getName(),now_node:getParent():getName())
            break
        end
        now_node = now_node:getParent() 
        -- print("======now_node=======",now_node:getName())
    end

    return cc.p(x,y)
end