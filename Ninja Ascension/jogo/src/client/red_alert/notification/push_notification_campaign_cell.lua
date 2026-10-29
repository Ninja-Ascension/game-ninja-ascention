-- Initialize push notification center state machine.
push_notification_vip_level = nil
push_notification_vip_value = nil
local function init_push_notification_campaign_cell_terminal()
	--日常副本按钮的推送
    local push_notification_campaign_cell_terminal = {
        _name = "push_notification_campaign_cell",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	local id = params._datas._id
			if getcampaignAllTip(id) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*1.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    -- 侠客行扫荡
    local push_notification_campaign_trialtower_terminal = {
        _name = "push_notification_campaign_trialtower",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
            local id = params._datas._id
            if getcampaigntrialtowerTip(id) == true then
                if params._widget._istips == nil or params._widget._istips == false then
                    local ball = cc.Sprite:create("images/ui/bar/tuishong.png")
                    ball:setAnchorPoint(cc.p(0.5, 0.5))
                    ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*1.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

    state_machine.add(push_notification_campaign_cell_terminal)
    state_machine.add(push_notification_campaign_trialtower_terminal)
    state_machine.init()
end
init_push_notification_campaign_cell_terminal()

function getcampaignAllTip(id)
    --1 资源点，2 镖车，3 守卫襄阳，4 装备，5 宝石，6 一代宗师， 7 侠客行
    if id == 1 then
        if funOpenDrawTip(138,false) == false then
            if _ED.city_resource_user_info ~= nil then
                if tonumber(_ED.city_resource_user_info.my_city_id) <= 0 then
                    local server_time = _ED.system_time + (os.time() - _ED.native_time)
                    server_time = os.date("*t", zstring.tonumber(server_time))
                    if server_time.hour >= 8 then
                        return true
                    end
                end
            end
        end
    elseif id == 2 then
        if funOpenDrawTip(120,false) == false then
            local server_time = _ED.system_time + (os.time() - _ED.native_time)
            server_time = os.date("*t", zstring.tonumber(server_time))
            if (server_time.hour >= 12 and server_time.hour <= 13) or (server_time.hour == 13 and server_time.min <= 30) or (server_time.hour >= 20 and server_time.hour <= 22) then
                local leave_tran_times = tonumber(_ED.transport_resouce_info.leave_tran_times)       --剩余运送次数
                local leave_attack_times = tonumber(_ED.transport_resouce_info.leave_attack_times)    --剩余掠夺次数
                if leave_tran_times > 0 or leave_attack_times > 0 then
                    return true
                end
            end
        end
    elseif id == 3 then
        if funOpenDrawTip(129,false) == false then
            local max_attack_times = _ED.push_notification_info.campaign.raiders_max_times
            local leave_attack_times = max_attack_times - _ED.raiders_cut_attack_times
            if leave_attack_times ~= 0 then
                return true
            end
        end
	elseif id == 4 then
        if funOpenDrawTip(111,false) == false then
            -- 初始化VIP等级获得黑石山最大攻击次数，如果VIP等级没有改变不再重新获取最大攻击次数
            if push_notification_vip_level == nil or zstring.tonumber(push_notification_vip_level) ~= tonumber(_ED.vip_grade) then 
                push_notification_vip_level = _ED.vip_grade
                push_notification_vip_value = dms.int(dms["base_consume"],69,base_consume.vip_0_value + tonumber(push_notification_vip_level))
            end
            -- 剩余攻击次数
            local leave_times = push_notification_vip_value - tonumber(_ED.npc_equip_all_attack_times)
            if leave_times > 0 then
                return true
            end
        end
    elseif id == 5 then
        if funOpenDrawTip(112,false) == false then
            -- 最大攻击次数
            local max_times = _ED.push_notification_info.campaign.gem_copy_max_times
            -- 已攻击次数
            local attack_times = 0
            local scene_id = _ED.push_notification_info.campaign.gem_copy_scene_id
            for i,v in pairs(scene_id) do
                -- 如果该NPC已攻打成功，攻击次数+1 
                if tonumber(_ED.get_star_count[v]) > 0 then
                    attack_times = attack_times + 1
                end
            end
            -- 剩余攻击次数
            local leave_times = max_times - attack_times
            if leave_times > 0 then
                return true
            end
        end
    elseif id == 6 then
        -- 判断是否已攻打
        if funOpenDrawTip(115,false) == false then
            if _ED.soul_duplicate.attack_count == 0 then
                return true
            end
        end
    elseif id == 7 then
        if funOpenDrawTip(126,false) == false then
            local leave_times = dms.int(dms["base_consume"],51,base_consume.vip_0_value + tonumber(_ED.vip_grade)) - _ED.three_kings_reset_times
            if leave_times > 0 or _ED.three_kings_sweeping == 1 then
                return true
            end
        end
    end
    
	return false
end

function getcampaigntrialtowerTip()
    if funOpenDrawTip(126,false) == false then
        if _ED.three_kings_sweeping == 1 then
            return true
        end
    end
    return false
end