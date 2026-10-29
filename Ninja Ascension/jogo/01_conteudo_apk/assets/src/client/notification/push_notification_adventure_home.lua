-- Initialize push notification center state machine.

local changeNpcId = 1
local function init_push_notification_adventure_home_terminal()
	--首页的月卡推送

    local push_notification_center_adventure_home_mothcard_terminal = {
        _name = "push_notification_adventure_home_mothcard",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getmothCard() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width , params._widget:getContentSize().height))
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

     local push_notification_center_adventure_home_changenpcid_terminal = {
        _name = "push_notification_center_adventure_home_changenpcid",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			changeNpcId = params
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

	 -- 礼包箱
	 local push_notification_center_adventure_home_giftbag_terminal = {
        _name = "push_notification_adventure_home_giftbag",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getgiftBag() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height))
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

 -- 冒险
	 local push_notification_center_adventure_home_adventure_terminal = {
        _name = "push_notification_adventure_home_adventure",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local paramdata = params._datas
			if getIsSearch(paramdata._npcId) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setScale(0.8)
					ball:setPosition(cc.p(params._widget:getContentSize().width + 10, params._widget:getContentSize().height + 10))
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

	 -- 更多
	 local push_notification_center_adventure_more_terminal = {
        _name = "push_notification_center_adventure_more",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local paramdata = params._datas
			if getIsMoreTip() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width + 10, params._widget:getContentSize().height + 10))
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

	-- 招募
	 local push_notification_center_adventure_home_zhaomu_terminal = {
        _name = "push_notification_adventure_home_zhaomu",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getSkyRefresh() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/icon/bg_reward_tag.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(params._widget:getContentSize().width - 30, params._widget:getContentSize().height - 30))
					params._widget:addChild(ball,10)
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

   	--事件
	 local push_notification_adventure_home_event_terminal = {
        _name = "push_notification_adventure_home_event",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
       		getHasEvent()
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }
    
    state_machine.add(push_notification_center_adventure_home_mothcard_terminal)
	state_machine.add(push_notification_center_adventure_home_giftbag_terminal)
	state_machine.add(push_notification_center_adventure_home_adventure_terminal)
	state_machine.add(push_notification_center_adventure_more_terminal)
	state_machine.add(push_notification_center_adventure_home_changenpcid_terminal)
	state_machine.add(push_notification_adventure_home_event_terminal)
	
	-- 招募已经不需要做了
	--state_machine.add(push_notification_center_adventure_home_zhaomu_terminal)	
    state_machine.init()
end
init_push_notification_adventure_home_terminal()

function getmothCard()
	local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
	local isTip = false
	-- 月卡重塑对于老月卡改为表控制
	local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 1000)
	if activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
	else
		local monthCardDayOne = _ED.month_card[_drawMonth[1][1]].surplus_month_card_time	--第一种月卡天数
		local monthCardStateOne = _ED.month_card[_drawMonth[1][1]].draw_month_card_state		--第一种月卡领取状态
		if tonumber(monthCardDayOne) > 0 then
			if tonumber(monthCardStateOne) == 0 then
				--可领取
				isTip = true
			else
				isTip = false
			end
		else
			isTip = true
		end
	end
	return isTip
end

function getsignIn()
	-- 月卡重塑对于老月卡改为表控制
	local activity_sequence_show = dms.searchs(dms["activity_sequence"], 2, 1000)
	if activity_sequence_show ~= nil and tonumber(activity_sequence_show[1][4]) == 2 then
	else
		local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
		local monthCardDayOne = _ED.month_card[_drawMonth[1][1]].surplus_month_card_time	--第一种月卡天数
		local monthCardStateOne = _ED.month_card[_drawMonth[1][1]].draw_month_card_state		--第一种月卡领取状态
		if tonumber(monthCardDayOne) > 0 then
			if tonumber(monthCardStateOne) == 0 then
				return true
			end
		end
	end
	return true
end

function getgiftBag()
	if _ED._reward_centre ~= nil then 
		for k,v in pairs(_ED._reward_centre) do
			return true
		end
	else
		return false
	end
	return false
end

function getIsSearch(npcId)
	if funOpenConditionJudge(55) == false then
		return false
	end
	if changeNpcId == nil then 
		return false
	end
	local npcId = tonumber("" .. changeNpcId)
	local  count = tonumber("" .. _ED.all_npc_reward_count[npcId])
	if count > 0  then
		return true
	end
    return false
end

function getSkyRefresh()
	local interval = (_ED.recruit_sky_temple.refresh_os_time + _ED.recruit_sky_temple.refresh_cd) - os.time()
		if interval <= 0 then
			return true
		end 
	return false 
end 

function getIsMoreTip()
	--是否可以签到
	local hour = tonumber(os.date("%H"))
    local activity_Info = _ED.active_activity[38].activity_Info[1]            -- 取当天数据
    local signStatus = zstring.split(activity_Info.activityInfo_isReward, ",")

    if hour >= 0 and hour < 12 then
        if tonumber(signStatus[1]) == 0 then
            return true
        end
    elseif hour >= 12 and hour < 18 then
        if tonumber(signStatus[2]) == 0 then
            return true
        end
    elseif hour >= 18 and hour < 24 then
        if tonumber(signStatus[3]) == 0 then
            return true
        end
    end
 
    -- 是否有礼包
   	if _ED._reward_centre ~= nil then 
		for k,v in pairs(_ED._reward_centre) do
			return true
		end
	else
		return false
	end
	return false
end

local aaa = false

function getHasEvent()
	local function recruitInitCallBack(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			
		end
	end
	NetworkManager:register(protocol_command.random_event_refresh.code, nil, nil, nil, nil, recruitInitCallBack, false, nil)
end 
