-- Initialize push notification center state machine.
local function init_push_notification_adventure_mercenary_terminal()
	-- 佣兵空了
    local push_notification_center_adventure_mercenary_update_terminal = {
        _name = "push_notification_adventure_mercenary_update",
        _init = function (terminal)
        	app.load("client.loader.EnvironmentDatas")
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getIsFull() == false then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width + 17 , params._widget:getContentSize().height + 15))
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

    state_machine.add(push_notification_center_adventure_mercenary_update_terminal)	
    state_machine.init()
end
init_push_notification_adventure_mercenary_terminal()

function getIsFull()

	local formentionNumber = 0
	
	if funOpenConditionJudge(54) == false then 
		return true			
	end
	local isFull = true
	-- for i,w in pairs(_ED.formetion_list) do
	-- 	if zstring.tonumber(w[1]) == 1 then
	-- 		formentionNumber = i
	-- 			break
	-- 		end
	-- end
	
	for j,v in pairs(_ED.formetion) do
		if j > 1 then 
			if v == "0" then
				isFull = false
				break
			end
			if v == "-1" then
				isFull = true
				break
			end
		end
	end
	return isFull
end
