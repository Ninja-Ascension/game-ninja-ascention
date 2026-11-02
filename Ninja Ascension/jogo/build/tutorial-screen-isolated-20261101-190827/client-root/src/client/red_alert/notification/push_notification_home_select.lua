-- Initialize push notification center state machine.
local function init_push_notification_home_select_terminal()
	--主界面打开窗口选择的推送(合成)
    local push_notification_home_select_synthesis_terminal = {
        _name = "push_notification_home_select_synthesis",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getSelectAllTip() == true then
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

    --主界面打开窗口选择的推送(升级)
    local push_notification_home_select_up_terminal = {
        _name = "push_notification_home_select_up",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        local build_id = params._datas._build
			if buildCanUpgrade(build_id) == true and zstring.tonumber(_ED.home_build[""..build_id].update_state) ~= 1 then
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

    --荣誉商店
    local push_notification_home_tourneyfield_shop_terminal = {
        _name = "push_notification_home_tourneyfield_shop",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getTourneyfieldShopTip() == true then
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

    state_machine.add(push_notification_home_select_synthesis_terminal)
    state_machine.add(push_notification_home_select_up_terminal)
    state_machine.add(push_notification_home_tourneyfield_shop_terminal)
    state_machine.init()
end
init_push_notification_home_select_terminal()

function getSelectAllTip()
	--可以合成
	local fun_open_tab_id = dms.int(dms["build_mould"],3,build_mould.fun_open_tab_id)
	if funOpenDrawTip(fun_open_tab_id,false) == false then  
		for i,v in pairs(_ED.user_prop) do
			if tonumber(v.coming_need_number) ~= 0 and tonumber(v.prop_number) >= tonumber(v.coming_need_number) then 
				return true
			end
		end
	end
	return false
end

--荣誉商店
function getTourneyfieldShopTip()
	local fun_open_tab_id = dms.int(dms["build_mould"],4,build_mould.fun_open_tab_id)
	if funOpenDrawTip(fun_open_tab_id,false) == false then 
		if tonumber(_ED.user_info.user_honour) >= 100 and pushNotificationTourneyfield() == true then
				return true
			end
		end
	return false
end


