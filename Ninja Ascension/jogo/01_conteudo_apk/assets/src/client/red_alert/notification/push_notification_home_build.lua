-- Initialize push notification center state machine.
push_fate_vip_level = nil
push_notification_vip_gold = nil
push_notification_vip_equip = nil
push_notification_vip_gem = nil
push_notification_vip_soul = nil
local function init_push_notification_home_build_terminal()
	--首页建筑按钮的推送
    local push_notification_home_build_resouce_canget_terminal = {
        _name = "push_notification_home_build_resouce_canget",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)   
			local build_id = params._datas._buildID
			local panel_animation = params._datas._panel_animation
			local pic_id = params._datas._pic_id
			local image = params._datas._image
			local state, ntype = buildCanClick(build_id)
			if state == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local path = "images/ui/function_icon/home_icon_t_".. pic_id ..".png"
					if ntype == 1 then
						path = "images/ui/function_icon/home_icon_t_".. pic_id .."_0.png"
					end
					panel_animation:setBackGroundImage(path)
					params._widget:setVisible(true)
					panel_animation:setVisible(true)
					image:setVisible(true)
					params._widget._istips = true
				end
			else
				if params._widget._istips == true then
					panel_animation:removeBackGroundImage()
					image:setVisible(false)
					params._widget:setVisible(false)
					params._widget._nodeChild = nil
					params._widget._istips = false
				end
			end
			if buildCanUpgrade(build_id) == true 
				and _ED.home_build[""..build_id] ~= nil 
				and zstring.tonumber(_ED.home_build[""..build_id].update_state) ~= 1 then
				if params._widget._istipsUP == nil or params._widget._istipsUP == false then
					ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_point/effect_point.ExportJson")
                    local effice = ccs.Armature:create("effect_point")
                    params._widget._nodeUpChild = effice
                    effice:setPosition(cc.p(params._widget:getContentSize().width, params._widget:getContentSize().height*0.5))
                    effice:getAnimation():playWithIndex(0)
                    params._widget._nodeUpChild = effice
                    params._widget:addChild(effice) 
					params._widget:setVisible(true)
					params._widget._istipsUP = true
				end
			else
				if params._widget._istipsUP == true then
					params._widget._nodeUpChild:setVisible(false)
					params._widget._istipsUP = false
				end
			end
			
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

    -- 聊天(系统)
    local push_notification_home_button_chat_system_terminal = {
        _name = "push_notification_home_button_chat_system",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if _ED._push_chat_system == 1 then
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

    -- 聊天(世界)
    local push_notification_home_button_chat_world_terminal = {
        _name = "push_notification_home_button_chat_world",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if _ED._push_chat_world == 1 then
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

    -- 聊天(私聊)
    local push_notification_home_button_chat_private_terminal = {
        _name = "push_notification_home_button_chat_private",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
			if _ED._push_chat_private == 1 then
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

    state_machine.add(push_notification_home_build_resouce_canget_terminal)
    state_machine.add(push_notification_home_button_chat_system_terminal)
    state_machine.add(push_notification_home_button_chat_world_terminal)
    state_machine.add(push_notification_home_button_chat_private_terminal)
    state_machine.init()
end
init_push_notification_home_build_terminal()

--可搜集资源
function buildCanClick(build_id)
	--新技能
	if tonumber(build_id) == 1 then
		if tonumber(_ED.home_build[""..build_id].level) <= 1 then
			return false
		end
		if _ED.majesty_push_state == true then 
			return true
		end
	end
	--可以领资源
	if (tonumber(build_id) > 8 and tonumber(build_id) < 15) then
		local home_build_id = _ED.home_build[""..build_id]
		if home_build_id == nil then
			return false
		end
		if tonumber(home_build_id.level) <= 1 then
			return false
		end
		local fun_open_tab_id = dms.int(dms["build_mould"],build_id,build_mould.fun_open_tab_id)
		if funOpenDrawTip(fun_open_tab_id,false) == false then  
			local result_time = os.time() + _ED.time_add_or_sub - home_build_id.output_start_time
			if result_time > 40 then
				local update_id = dms.int(dms["build_mould"], build_id, build_mould.update_id)
	            local build_level = zstring.tonumber(home_build_id.level)
				local info = _ED.build_escalate_info[""..update_id][""..build_level]
				local output_count = tonumber(info.output_count)
	            local output_time = tonumber(info.output_time)
				if output_count / output_time * result_time >= 1 then
					return true
				end
			end
		end
	end

	--酒馆可招募
	if tonumber(build_id) == 6 then
		local fun_open_tab_id = dms.int(dms["build_mould"],build_id,build_mould.fun_open_tab_id)
		if funOpenDrawTip(fun_open_tab_id,false) == false then  
			--召唤书
		    local propRecruitCount = 0 
		    if fundPropWidthId(217) ~= nil then 
		        local token = fundPropWidthId(217)
		        propRecruitCount = token.prop_number
		    end
		    --十连书
		    local propRecruitCount_ten = 0 
		    if fundPropWidthId(258) ~= nil then 
		        local token = fundPropWidthId(258)
		        propRecruitCount_ten = token.prop_number
		    end
		    -- 如果拥有召唤书或者免费十次卷
			if tonumber(propRecruitCount) > 0 or tonumber(propRecruitCount_ten) > 0 then
				return true
			end

		end
		if funOpenDrawTip(130,false) == false then  
			local specil_recruit = (tonumber(_ED.free_info[2].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[2].free_start))--神将刷新时间
			if tonumber(specil_recruit) < 0 then
				return true
			end
		end
	end

	--可以合成
	if tonumber(build_id) == 3 then
		local fun_open_tab_id = dms.int(dms["build_mould"],build_id,build_mould.fun_open_tab_id)
		if funOpenDrawTip(fun_open_tab_id,false) == false then  
			-- 如果该道具需要的数量不为0且拥有的数量>=需要的数量
			for i,v in pairs(_ED.user_prop) do
				if tonumber(v.coming_need_number) ~= 0 and tonumber(v.prop_number) >= tonumber(v.coming_need_number) then 
					return true
				end
			end
		end
	end
	--可祭祀
	if tonumber(build_id) == 7 then
		local fun_open_tab_id = dms.int(dms["build_mould"],build_id,build_mould.fun_open_tab_id)
		if funOpenDrawTip(fun_open_tab_id,false) == true then
	        return false
	    end 
	    if push_fate_vip_level == nil or zstring.tonumber(push_fate_vip_level) ~= tonumber(_ED.vip_grade) then 
            push_fate_vip_level = _ED.vip_grade
            push_notification_vip_gold = dms.int(dms["base_consume"],60,base_consume.vip_0_value + tonumber(push_fate_vip_level))
			push_notification_vip_equip = dms.int(dms["base_consume"],62,base_consume.vip_0_value + tonumber(push_fate_vip_level))
			push_notification_vip_gem = dms.int(dms["base_consume"],64,base_consume.vip_0_value + tonumber(push_fate_vip_level))
			push_notification_vip_soul = dms.int(dms["base_consume"],66,base_consume.vip_0_value + tonumber(push_fate_vip_level))
        end
	    --金币祭祀
		if funOpenDrawTip(107,false) == false then
			-- 金币免费祭祀总次数
			local free_times_gold = tonumber(_ED.fate_times[1].free_times)
			-- 金币免费祭祀剩余次数
			local leave_free_times_gold = push_notification_vip_gold - free_times_gold
			if leave_free_times_gold > 0  then
				return true
			end
		end
		--装备祭祀
		if funOpenDrawTip(109,false) == false then
			-- 装备免费祭祀总次数
			local free_times_equip = tonumber(_ED.fate_times[2].free_times)
			-- 装备免费祭祀剩余次数
			local leave_free_times_equip = push_notification_vip_equip - free_times_equip
			if leave_free_times_equip > 0  then
				return true
			end
		end
		--宝石祭祀
		if funOpenDrawTip(108,false) == false then
			-- 宝石免费祭祀总次数
			local free_times_gem = tonumber(_ED.fate_times[3].free_times)
			-- 宝石免费祭祀剩余次数
			local leave_free_times_gem = push_notification_vip_gem - free_times_gem
			if leave_free_times_gem > 0  then
				return true
			end
		end
		--星魂祭祀
		if funOpenDrawTip(110,false) == false then
			-- 星魂免费祭祀总次数
			local free_times_soul = tonumber(_ED.fate_times[4].free_times)
			-- 星魂免费祭祀剩余次数
			local leave_free_times_soul = push_notification_vip_soul - free_times_soul
			if leave_free_times_soul > 0  then
				return true
			end
		end
	end

	--宝物可鉴定
	if tonumber(build_id) == 17 then
		local fun_open_tab_id = dms.int(dms["build_mould"],build_id,build_mould.fun_open_tab_id)
		if funOpenDrawTip(fun_open_tab_id,false) == false then  
			-- 有普通鉴定次数或高级鉴定次数
			if tonumber(_ED.horse_normal_number) > 0 or tonumber(_ED.horse_specil_number) > 0 then
				return true
			end
		end
	end

	--演武场
	if tonumber(build_id) == 4 then
		local fun_open_tab_id = dms.int(dms["build_mould"],build_id,build_mould.fun_open_tab_id)
		if funOpenDrawTip(fun_open_tab_id,false) == false then 
			-- 本次登录尚未查看且拥有100+荣誉值
			if tonumber(_ED.user_info.user_honour) >= 100 and pushNotificationTourneyfield() == true then
				return true
			end
		end
	end

	--天宝阁
	if tonumber(build_id) == 8 then
		local fun_open_tab_id = dms.int(dms["build_mould"],build_id,build_mould.fun_open_tab_id)
		if funOpenDrawTip(fun_open_tab_id,false) == false then  
			local token_times = 0 
			--刷新令
		    if fundPropWidthId(216) ~= nil then 
		        local token = fundPropWidthId(216)
		        token_times = token.prop_number
		    end
		    local high_token_times = 0
            local prop = fundPropWidthId(dms.int(dms["shop_config"], 15, shop_config.param))
            if prop ~= nil then 
                high_token_times = prop.prop_number
            end
		    -- 有免费刷新次数或拥有刷新令
			if zstring.tonumber(_ED.secret_shop_init_info.free_times) > 0 
				or tonumber(token_times) > 0 
				or tonumber(high_token_times) > 0 then
				return true
			end
		end
	end

	-- 剑冢
	if tonumber(build_id) == 16 then
		local fun_open_tab_id = dms.int(dms["build_mould"],build_id,build_mould.fun_open_tab_id)
		if funOpenDrawTip(fun_open_tab_id,false) == false then  
			-- 攻击次数
			if _ED.god_weaponry_open_state == nil or tonumber(_ED.god_weaponry_open_state) ~= 0 then
				if zstring.tonumber(_ED.weaponry_attack_times) > 0 then
					return true
				end
			end
		end
	end

	if tonumber(build_id) >= 20 then
		local home_build_id = _ED.home_build[""..build_id]
		if home_build_id == nil then
			return false
		end
		if tonumber(home_build_id.level) <= 1 then
			return false
		end
		if tonumber(home_build_id.output_start_time) <= 0 then
			return false
		end
		local fun_open_tab_id = dms.int(dms["build_mould"],build_id,build_mould.fun_open_tab_id)
		if funOpenDrawTipEX(fun_open_tab_id,false) == false then 
			local update_id = dms.int(dms["build_mould"], build_id, build_mould.update_id)
            local build_level = zstring.tonumber(home_build_id.level)
            local info = _ED.build_escalate_info[""..update_id][""..build_level]
            local max_volumn = tonumber(info.max_volumn)
            local output_count = tonumber(info.output_count)
            local output_time = tonumber(info.output_time)

			if math.floor((os.time() + _ED.time_add_or_sub - home_build_id.output_start_time) /3600 * output_count) > max_volumn then
				return true
			end
		end
	end
	-- 居所
	if tonumber(build_id) == 18 then
		local fun_open_tab_id = dms.int(dms["build_mould"],build_id,build_mould.fun_open_tab_id)
		if funOpenDrawTipEX(fun_open_tab_id,false) == false then
			for i=20,26 do
		        local build_info = _ED.home_build[""..i]
		        if build_info ~= nil then
		            local output_start_time = build_info.output_start_time
		            local level = zstring.tonumber(build_info.level)
		            local update_id = dms.int(dms["build_mould"], i, build_mould.update_id)
		            local escalate_info = _ED.build_escalate_info[""..update_id][""..level]
		            local output_count = zstring.tonumber(escalate_info.output_count)
		            local output_time = zstring.tonumber(escalate_info.output_time)
                    local max_volumn = zstring.tonumber(escalate_info.max_volumn)

                    -- 可收获
                    if tonumber(build_info.level) > 1 then
			            if math.floor((os.time() + _ED.time_add_or_sub - output_start_time)/3600 * output_count) >= max_volumn then
	                        return true, 1
	                    end
                    elseif tonumber(build_info.level) == 1 then
                    	return true, 2
                    end
		        end
		    end
		end
	end

	-- 七星台
	if tonumber(build_id) == 15 then
		local fun_open_tab_id = dms.int(dms["build_mould"],build_id,build_mould.fun_open_tab_id)
		if funOpenDrawTip(fun_open_tab_id,false) == false then  
			-- 攻击次数
			local attack_times = dms.int(dms["copy_config"],10,copy_config.param)   -- 总攻击次数
    		local leave_times = attack_times - _ED.seven_star_attack_times  -- 剩余攻击次数
			if leave_times > 0 then
				local index = 0
				local open_number = 0
				for i,v in pairs(_ED.push_notification_info.seven_star) do
					open_number = open_number + 1
					local scene_state = tonumber(_ED.scene_current_state[i])
					if scene_state == #v then
						index = index + 1
					end
				end
				if index ~= open_number then
					return true
				end
			end
		end
	end
	return false
end

--可升级
function buildCanUpgrade(build_id)
	local fun_open_tab_id = dms.int(dms["build_mould"],build_id,build_mould.fun_open_tab_id)
	if tonumber(build_id) >= 19 then
		if funOpenDrawTipEX(fun_open_tab_id,false) == false then 
			if _ED.home_build[""..build_id] == nil then
				return false
			end
			local update_id = dms.int(dms["build_mould"],build_id,build_mould.update_id)
			local level = zstring.tonumber(_ED.home_build[""..build_id].level)
			local update_need_resouce = _ED.build_escalate_info[""..update_id][""..level].update_need_resouce
    		if update_need_resouce ~= nil then 
				-- 需要主城等级
			    local need_home_level = zstring.tonumber(_ED.build_escalate_info[""..update_id][""..level].by_open_home_level)
			    -- 需要玩家等级
			    local need_user_level = zstring.tonumber(_ED.build_escalate_info[""..update_id][""..level].by_open_user_level)
			    -- 当前玩家等级
			    local now_user_level = zstring.tonumber(_ED.user_info.user_grade)
			    -- 当前主城等级
			    local now_home_level = zstring.tonumber(_ED.home_build["1"].level)
			    
			    if now_home_level < need_home_level then
			        return false
			    end
			    if now_user_level < need_user_level then
			        return false
			    end
			    return true
			end
		end
	else
		if (tonumber(build_id) > 8 and tonumber(build_id) < 15) 
			or tonumber(build_id) == 1 
			or tonumber(build_id) == 2 
			or tonumber(build_id) == 17 
			then
			if funOpenDrawTip(fun_open_tab_id,false) == false then  
				if _ED.home_build[""..build_id] == nil then
					return false
				end
				local update_id = dms.int(dms["build_mould"],build_id,build_mould.update_id)
				local level = zstring.tonumber(_ED.home_build[""..build_id].level)
				local update_need_resouce = _ED.build_escalate_info[""..update_id][""..level].update_need_resouce
	    		if update_need_resouce ~= nil then 
					-- 需要主城等级
				    local need_home_level = zstring.tonumber(_ED.build_escalate_info[""..update_id][""..level].by_open_home_level)
				    -- 需要玩家等级
				    local need_user_level = zstring.tonumber(_ED.build_escalate_info[""..update_id][""..level].by_open_user_level)
				    -- 当前玩家等级
				    local now_user_level = zstring.tonumber(_ED.user_info.user_grade)
				    -- 当前主城等级
				    local now_home_level = zstring.tonumber(_ED.home_build["1"].level)
				    
				    if now_home_level < need_home_level then
				        return false
				    end
				    if now_user_level < need_user_level then
				        return false
				    end
				    return true
				end
			end
		end
	end
	return false
end
