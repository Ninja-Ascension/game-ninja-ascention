-- Initialize push notification center state machine.
local function init_push_notification_combining_terminal()
	--铁匠铺合成的推送(装备)
    local push_notification_combining_equipment_terminal = {
        _name = "push_notification_combining_equipment",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getEquipmentAllTip() == true then
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

    --铁匠铺合成的推送(英雄)
    local push_notification_combining_hero_terminal = {
        _name = "push_notification_combining_hero",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getHeroCombiningAllTip() == true then
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

    state_machine.add(push_notification_combining_equipment_terminal)
    state_machine.add(push_notification_combining_hero_terminal)
    state_machine.init()
end
init_push_notification_combining_terminal()

function getEquipmentAllTip()
    for i,v in pairs(_ED.user_prop) do
        -- 如果该道具需要的数量不为0且拥有的数量>=需要的数量，并且该道具为装备碎片
        if tonumber(v.coming_need_number) ~= 0 and tonumber(v.prop_number) >= tonumber(v.coming_need_number) then 
            local equip_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.user_prop_template), prop_mould.change_of_equipment))
            if equip_mould_id > 0 then
				return true
			end
        end
    end
    return false
end

function getHeroCombiningAllTip()
    for i,v in pairs(_ED.user_prop) do
        -- 如果该道具需要的数量不为0且拥有的数量>=需要的数量，并且该道具为英雄碎片
        if tonumber(v.coming_need_number) ~= 0 and tonumber(v.prop_number) >= tonumber(v.coming_need_number) then 
            local ship_mould_id =  zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.user_prop_template), prop_mould.use_of_ship))
            if ship_mould_id > 0 then
            	return true
			end
        end
    end
    return false
end