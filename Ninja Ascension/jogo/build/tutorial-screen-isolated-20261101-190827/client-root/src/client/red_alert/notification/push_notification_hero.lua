-- Initialize push notification center state machine.
local function init_push_notification_hero_terminal()
	--英雄的推送(羁绊)
    local push_notification_hero_fetters_terminal = {
        _name = "push_notification_hero_fetters",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local ship = params._datas._cell.ship
			if getheroFettersTip(ship) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
			
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --英雄的推送(升星)
    local push_notification_hero_star_up_terminal = {
        _name = "push_notification_hero_star_up",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local ship = params._datas._cell.ship
			if getHeroStarUpTip(ship) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					params._widget:addChild(ball)
					params._widget._nodeChild = ball
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					params._widget:removeChild(params._widget._nodeChild, true)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
			
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    --英雄的推送(突破)
    local push_notification_hero_grade_up_terminal = {
        _name = "push_notification_hero_grade_up",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local ship = params._datas._cell.ship
            if getheroGradeUpTip(ship) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
                    params._widget:addChild(ball)
                    params._widget._nodeChild = ball
                    params._widget._istips = true
                end
            else
                if params._widget._istips == true then
                    params._widget:removeChild(params._widget._nodeChild, true)
                    params._widget._nodeChild = nil
                    params._widget._istips = false
                end
            end
            
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    state_machine.add(push_notification_hero_fetters_terminal)
    state_machine.add(push_notification_hero_star_up_terminal)
    state_machine.add(push_notification_hero_grade_up_terminal)
    state_machine.init()
end
init_push_notification_hero_terminal()

local function checkNeedStarupPush(prop_mould_id , need_count ,need_silver,need_ship_numbers,ship)
	local now_have_prop = false
    -- 如果拥有的金币>=需要的金币，且拥有的道具数量>=需求数量
    if tonumber(_ED.user_info.user_silver) >= need_silver then 
        for i,prop in pairs(_ED.user_prop) do
            if tonumber(prop.user_prop_template) == prop_mould_id then
                if tonumber(prop.prop_number) >= need_count then
                	now_have_prop = true
                else
                    return false
                end
            end
        end
    end

    if now_have_prop == false then
        return false
    end
    -- 如果拥有的英雄数量>=需求数量
    local ship_numbers = findTheSameBaseShipMouldBy(ship)
    if ship_numbers >= need_ship_numbers then
    else
        return false
    end
    return true
end

local function checkNeedPush(prop_mould_id , need_count , need_silver)
    -- 如果拥有的金币>=需要的金币，且拥有的道具数量>=需求数量
    if tonumber(_ED.user_info.user_silver) >= need_silver then 
        for i,prop in pairs(_ED.user_prop) do
            if tonumber(prop.user_prop_template) == prop_mould_id then
                if tonumber(prop.prop_number) >= need_count then
                    return true
                end
            end
        end
    end
    return false
end

--英雄升星
function getHeroStarUpTip(ship)
    local star_id_tab = ship.stars_state
    local can_up_star = true
    for i,v in pairs(star_id_tab) do
        local star_id = v.star_id
        if zstring.tonumber(star_id) == -1 or zstring.tonumber(star_id) == 0 then
            can_up_star = false
        else
            local state = v.state
            local star_data = dms.element(dms["star_mould"],star_id)
            local need_prop1 = dms.atoi(star_data,star_mould.need_prop1)                -- 需求道具
            local need_prop1_count = dms.atoi(star_data,star_mould.need_prop1_count)    -- 需求道具数量
            local need_silver1 = dms.atoi(star_data,star_mould.need_silver1)            -- 需求金币
            if tonumber(state) ~= 1 then
                can_up_star = false
                if checkNeedPush(need_prop1,need_prop1_count,need_silver1) == true then
                    return true
                end
            end
        end
    end

    local required_material_id = dms.string(dms["ship_mould"],ship.ship_template_id,ship_mould.required_material_id)   --进阶需求索引
    local ship_grow_requirement_data = dms.element(dms["ship_grow_requirement"], required_material_id)
    local star_up_need_prop = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_prop1)                 --需求的材料
    local star_up_need_count = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_prop1_count)          --需求的材料数量
    local star_up_need_silver = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_silver)              --需求的金币
    local need_same_card_count = dms.atoi(ship_grow_requirement_data,ship_grow_requirement.need_same_card_count)    --需求同ID武将数量
    if can_up_star == true and 
        checkNeedStarupPush(star_up_need_prop,
                            star_up_need_count,
                            star_up_need_silver,
                            need_same_card_count,
                            ship) == true then  
        return true
    end
    return false
end