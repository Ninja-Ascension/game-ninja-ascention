cc.Director:getInstance():getTextureCache():addImage("images/ui/bar/tuishong.png")
push_notification_funding_full_service_count = 0	  -- 军资集结的全部
push_notification_funding_personal_count = 0	  -- 军资集结的个人
push_notification_brothers_personal_count = 0	  -- 兄弟同享
push_notification_eliminate_music_count = 0 --消消乐
local function init_push_notification_treasurehouse_terminal()
	--军资集结的全部
    local push_notification_funding_full_service_terminal = {
        _name = "push_notification_funding_full_service",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local count = gerFundingFullService()
			local isChange = false
	        if count ~= push_notification_funding_full_service_count then
	        	isChange = true
	        end
	        push_notification_funding_full_service_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				else
					-- if params._widget._istips == nil or params._widget._istips == false then
					-- 	local ball = state_machine.excute("util_tips_cretae", 0, {count})
					-- 	ball:setAnchorPoint(cc.p(0.5, 0.5))
					-- 	ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					-- 	params._widget:addChild(ball)
					-- 	params._widget._nodeChild = ball
					-- 	params._widget._istips = true
					-- end
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, {count})
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

    --军资集结的个人
    local push_notification_funding_personal_terminal = {
        _name = "push_notification_funding_personal",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local count = gerFundingPersonal()
			local isChange = false
	        if count ~= push_notification_funding_personal_count then
	        	isChange = true
	        end
	        push_notification_funding_personal_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				else
					-- if params._widget._istips == nil or params._widget._istips == false then
					-- 	local ball = state_machine.excute("util_tips_cretae", 0, {count})
					-- 	ball:setAnchorPoint(cc.p(0.5, 0.5))
					-- 	ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					-- 	params._widget:addChild(ball)
					-- 	params._widget._nodeChild = ball
					-- 	params._widget._istips = true
					-- end
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, {count})
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

	--兄弟同享
    local push_notification_brothers_personal_terminal = {
        _name = "push_notification_brothers_personal",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			local count = gerBrothersPersonal()
			local isChange = false
	        if count ~= push_notification_brothers_personal_count then
	        	isChange = true
	        end
	        push_notification_brothers_personal_count = count
			if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				else
					-- if params._widget._istips == nil or params._widget._istips == false then
					-- 	local ball = state_machine.excute("util_tips_cretae", 0, {count})
					-- 	ball:setAnchorPoint(cc.p(0.5, 0.5))
					-- 	ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					-- 	params._widget:addChild(ball)
					-- 	params._widget._nodeChild = ball
					-- 	params._widget._istips = true
					-- end
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, {count})
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

    -- 超级配件排行奖励推送
    local push_notification_seek_treasure_terminal = {
        _name = "push_notification_seek_treasure",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if getSeekTreasure() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = state_machine.excute("util_tips_cretae", 0, {""})
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

    -- 积分转盘排行奖励推送
    local push_notification_consumption_turntable_terminal = {
        _name = "push_notification_consumption_turntable",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getConsumptionTurntable() == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
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

    -- 七日狂欢奖励单个页面推送
    local push_notification_seven_day_activity_type_terminal = {
        _name = "push_notification_seven_day_activity_type",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local activity_index = params._datas._activity_index
            if getSevenDayActivityTypeTip(activity_index) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
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

    -- 七日狂欢奖励单个推送
    local push_notification_seven_day_activity_terminal = {
        _name = "push_notification_seven_day_activity",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local activity_index = params._datas._activity_index
            local day = params._datas._day
            if getSevenDayActivityTip(day, activity_index) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
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

    --摧枯拉朽排行奖励推送
    local push_notification_treasurehouse_military_exploit_terminal = {
        _name = "push_notification_treasurehouse_military_exploit",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getActivityRankRewardPush(97) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
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
    --火线英雄排行奖励推送
    local push_notification_treasurehouse_leader_senior_terminal = {
        _name = "push_notification_treasurehouse_leader_senior",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getActivityRankRewardPush(99) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
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
    -- 消消乐奖励推送
    local push_notification_treasurehouse_eliminate_music_terminal = {
        _name = "push_notification_treasurehouse_eliminate_music",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local count = getActivityAchievementRewardPush(98)
            local isChange = false
            if count ~= push_notification_eliminate_music_count then
                isChange = true
            end
            push_notification_eliminate_music_count = count
            if count > 0 then
                if isChange == true then
                    if params._widget._istips == true then
                        params._widget:removeChild(params._widget._nodeChild, true)
                        params._widget._nodeChild = nil
                        params._widget._istips = false
                    end
                else
                    -- if params._widget._istips == nil or params._widget._istips == false then
                    --  local ball = state_machine.excute("util_tips_cretae", 0, {count})
                    --  ball:setAnchorPoint(cc.p(0.5, 0.5))
                    --  ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
                    --  params._widget:addChild(ball)
                    --  params._widget._nodeChild = ball
                    --  params._widget._istips = true
                    -- end
                end
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {count})
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
    --军事讲坛排行奖励推送
    local push_notification_treasurehouse_military_pulpit_rank_terminal = {
        _name = "push_notification_treasurehouse_military_pulpit_rank",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getActivityRankRewardPush(101) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
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
    --火力全开排行奖励推送
    local push_notification_treasurehouse_full_vitality_rank_terminal = {
        _name = "push_notification_treasurehouse_full_vitality_rank",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getActivityRankRewardPush(127) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
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
    --火力全开领取奖励推送
    local push_notification_treasurehouse_full_vitality_get_reward_terminal = {
        _name = "push_notification_treasurehouse_full_vitality_get_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getActivityAchievementRewardPush(127) > 0 then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
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
    --慷慨红包排行奖励推送
    local push_notification_largesse_give_rank_terminal = {
        _name = "push_notification_largesse_give_rank",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getActivityRankRewardPush(118) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
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

    --慷慨红包领取奖励推送
    local push_notification_largesse_get_reward_terminal = {
        _name = "push_notification_largesse_get_reward",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getActivityAchievementRewardPush(118) > 0 then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
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
    --军事讲坛免费次数标签推送
    local push_notification_treasurehouse_military_pulpit_free_terminal = {
        _name = "push_notification_treasurehouse_military_pulpit_free",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local index = params._datas._index
            if getActivityFreePush(101, index) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
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
    --折扣卖场标签推送
    local push_notification_discount_store_page_push_terminal = {
        _name = "push_notification_discount_store_page_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local index = params._datas._index
            if discountStorePagePush(index) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
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

    --欢乐团购购买记录标签推送
    local push_notification_happy_buy_record_push_terminal = {
        _name = "push_notification_happy_buy_record_push",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            if getPushActivityType(129) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
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

    --狂欢时刻推送
    local push_notification_canival_hour_terminal = {
        _name = "push_notification_canival_hour",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local nType = params._datas._ntype
            if getCanivalHourPush(nType) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = state_machine.excute("util_tips_cretae", 0, {""})
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

    state_machine.add(push_notification_funding_full_service_terminal)
    state_machine.add(push_notification_funding_personal_terminal)
    state_machine.add(push_notification_brothers_personal_terminal)
    state_machine.add(push_notification_seek_treasure_terminal)
    state_machine.add(push_notification_consumption_turntable_terminal)
    state_machine.add(push_notification_seven_day_activity_type_terminal)
    state_machine.add(push_notification_seven_day_activity_terminal)
    state_machine.add(push_notification_treasurehouse_military_exploit_terminal)
    state_machine.add(push_notification_treasurehouse_leader_senior_terminal)
    state_machine.add(push_notification_treasurehouse_eliminate_music_terminal)
    state_machine.add(push_notification_treasurehouse_military_pulpit_rank_terminal)
    state_machine.add(push_notification_treasurehouse_military_pulpit_free_terminal)
    state_machine.add(push_notification_discount_store_page_push_terminal)
    state_machine.add(push_notification_largesse_give_rank_terminal)
    state_machine.add(push_notification_largesse_get_reward_terminal)
    state_machine.add(push_notification_treasurehouse_full_vitality_rank_terminal)
    state_machine.add(push_notification_treasurehouse_full_vitality_get_reward_terminal)
    state_machine.add(push_notification_happy_buy_record_push_terminal)
    state_machine.add(push_notification_canival_hour_terminal)

    state_machine.init()
end
init_push_notification_treasurehouse_terminal()

-- 
function gerFundingFullService()
	local index = 0 
	if _ED.activity_info["78"].activity_data[1] ~= nil then
		for j, w in pairs(_ED.activity_info["78"].activity_data[1]) do
		 	local complete_count = zstring.split(w.achieve_complete_count, "/")
			if _ED.activity_to_full_service >= zstring.tonumber(complete_count[2]) and tonumber(w.achieve_state) ~= 2 then
				index = index + 1
			end	
		end
	end
	return index
end

function gerFundingPersonal()
	local index = 0 
	if _ED.activity_info["78"].activity_data[2]~= nil then
		for j, w in pairs(_ED.activity_info["78"].activity_data[2]) do
			local complete_count = zstring.split(w.achieve_complete_count, "/")
			if tonumber(complete_count[1]) >= tonumber(complete_count[2]) and tonumber(w.achieve_state) ~= 2 then
				index = index + 1
			end
		end
	end
	return index
end

function gerBrothersPersonal()
	local index = 0 
	if _ED.mould_function_push_info~= nil and _ED.mould_function_push_info["11"]~= nil then
		if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
            index = 0
        else
			index = index + tonumber(_ED.mould_function_push_info["11"].params)
		end
	end
	return index
end	

function getSeekTreasure()
	local activity_info = _ED.activity_info["67"]
	if activity_info ~= nil then
        local activity_add_state = zstring.split(activity_info.activity_add_state,",")
        if tonumber(activity_add_state[10])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
        else
    		local isHaveRank = false
            if _ED.accessories_points_ranking ~= nil then
        	    for i,v in pairs(_ED.accessories_points_ranking) do
        	        if v.name == _ED.user_info.user_name then
        	            isHaveRank = true
        	        end
        	    end
            end
	        if isHaveRank == true then
	            local already_receive = false
	            for k,v in pairs(activity_info.activity_data[1]) do
	                if tonumber(v.achieve_state) == 2 then
	                    already_receive = true
	                    break
	                end
	            end
	            if already_receive == false then
	                return true
	            end 
	        end
	    end
	end
	return false
end

function getConsumptionTurntable()
    local activity_info = _ED.activity_info["81"]
    if activity_info ~= nil then
        local activity_add_state = zstring.split(activity_info.activity_add_state,",")
        if tonumber(activity_add_state[11])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
        else
            local isHaveRank = false
            if zstring.tonumber(activity_add_state[13]) > 0 then
                isHaveRank = true
            end
            if isHaveRank == true then
                local already_receive = false
                for k,v in pairs(activity_info.activity_data[2]) do
                    if tonumber(v.achieve_state) == 2 then
                        already_receive = true
                        break
                    end
                end
                if already_receive == false then
                    return true
                end 
            end
        end
    end
    return false
end

function getSevenDayActivityTip(day, index)
    if index == 3 and day < 8 then
        return false
    end
    local list = getSevenDayActivityRewardList(day, index)
    for j, w in pairs(list) do
        local complete_count = zstring.split(w.achieve_complete_count, "/")
        if tonumber(complete_count[1]) >= tonumber(complete_count[2]) and tonumber(w.achieve_state) ~= 2 then
            return true
        end
    end
    return false
end

function getSevenDayActivityTypeTip(index)
    if __lua_project_id == __lua_project_pacific_rim then
        for i = 1, 7 do
            if getSevenDayActivityTip(i, index) == true then
                return true
            end
        end
    else
        for i = 1, 8 do
            if getSevenDayActivityTip(i, index) == true then
                return true
            end
        end
    end
    return false
end

function getSevenDayActivityTotalTip()
    for i = 1, 4 do
        if getSevenDayActivityTypeTip(i) == true then
            return true
        end
    end
    return false
end

--排行榜类型领奖推送，排行榜信息如果登陆不返回则读取活动里面的排行数据
function getActivityRankRewardPush( params )
    local activity_info = _ED.activity_info[""..params]
    if activity_info ~= nil then
        local activity_add_state = zstring.split(activity_info.activity_add_state,",")
        if tonumber(activity_add_state[3])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
        else
            local points_ranking = {}
            local activity_data = {}
            if tonumber(params) == 97 then
                points_ranking = _ED.military_exploit_points_ranking
                activity_data = activity_info.activity_data[2]
            elseif tonumber(params) == 99 then
                points_ranking = _ED.leader_senior_points_ranking
                activity_data = activity_info.activity_data[1]
            elseif tonumber(params) == 101 then
                points_ranking = _ED.military_pulpit_points_ranking
                activity_data = activity_info.activity_data[1]
            elseif tonumber(params) == 118 then
                points_ranking = _ED.largesse_give_points_ranking
                activity_data = activity_info.activity_data[1]
            elseif tonumber(params) == 127 then
                points_ranking = _ED.full_vitality_activity_rank
                activity_data = activity_info.activity_data[2]
            else

            end
            local isHaveRank = false
            for i,v in pairs(points_ranking) do
                if v.name == _ED.user_info.user_name then
                    isHaveRank = true
                end
            end
            if isHaveRank == true then
                local already_receive = false
                for k,v in pairs(activity_data) do
                    if tonumber(v.achieve_state) == 2 then
                        already_receive = true
                        break
                    end
                end
                if already_receive == false then
                    return true
                end 
            end
        end
    end
    return false
end

--活动成就类型领奖推送
function getActivityAchievementRewardPush( params )
    local index = 0 
    local activity_info = _ED.activity_info[""..params]
    if activity_info ~= nil then
        local activity_data = {} 
        if tonumber(params) == 98 
            or tonumber(params) == 118 
            then
            activity_data = activity_info.activity_data[2]
        elseif tonumber(params) == 127 then
            activity_data = activity_info.activity_data[1]
        end
        for j, w in pairs(activity_data) do
            local complete_count = zstring.split(w.achieve_complete_count, "/")
            if tonumber(complete_count[1]) >= tonumber(complete_count[2]) and tonumber(w.achieve_state) ~= 2 then
                index = index + 1
            end
        end
    end
    return index
end
--活动免费次数推送
function getActivityFreePush( params , page )
    local activity_info = _ED.activity_info[""..params]
    if activity_info ~= nil then
        local activity_add_state = nil
        local timesData = zstring.split(activity_info.activity_add_state , ",")
        if tonumber(timesData[3])/1000 > (tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))) then
            if tonumber(params) == 101 then
                local activity_add_state_array = zstring.split(activity_info.activity_add_state,"|")
                local curr_data = {page}
                if page == 0 then
                    curr_data = {1,2,3}
                end
                for i, v in pairs(curr_data) do
                    activity_add_state = zstring.split(activity_add_state_array[1 + v] , ",")
                    if tonumber(activity_add_state[1]) < tonumber(activity_add_state[2]) then
                        return true
                    end
                end
            end 
        end
    end
    return false
end