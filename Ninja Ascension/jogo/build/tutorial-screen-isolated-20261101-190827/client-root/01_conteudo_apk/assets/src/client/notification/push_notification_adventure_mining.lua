-- Initialize push notification center state machine.
local function init_push_notification_adventure_achievement_terminal()
	-- 挖矿
    local push_notification_center_adventure_mining_terminal = {
        _name = "push_notification_adventure_mining",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local paramdata = params._datas
			if getIsCanReceive() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
					ball:setAnchorPoint(cc.p(1, 1))
					if paramdata._isHome == true then
						ball:setPosition(cc.p(params._widget:getContentSize().width - 30 , params._widget:getContentSize().height - 30))
					else
						ball:setPosition(cc.p(params._widget:getContentSize().width , params._widget:getContentSize().height))
					end	
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

    state_machine.add(push_notification_center_adventure_mining_terminal)	
    state_machine.init()
end
init_push_notification_adventure_achievement_terminal()

function getIsCanReceive()
	local config = zstring.split(dms.string(dms["pirates_config"], 300, pirates_config.param), ",")
		for i=1, #config do
			if i <= zstring.tonumber(_ED.mine_work_open_number) then
				if i <= zstring.tonumber(_ED.mine_work_number) then
					if zstring.tonumber(_ED.mine_work_info[i].workshop_surplus_time) == 0  then
						return true
					end 
				end
			end
		end
	return false
end
