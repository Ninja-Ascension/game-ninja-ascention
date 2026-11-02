-- Initialize push notification center state machine.
-- 养成的推送
push_notification_cultivate_count = 0	  -- 首页养成
push_notification_cultivate_spirit_count = 0	  -- 数码精神
push_notification_cultivate_talent_count = 0	  -- 数码天赋

local function init_push_notification_cultivate_terminal()

	local push_notification_home_cultivate_terminal = {
		_name = "push_notification_home_cultivate",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			local count = 0
			count = getCultivatePush()
			local isChange = false
	        if count ~= push_notification_cultivate_count then
	        	isChange = true
	        end
	        push_notification_cultivate_count = count
	        if count > 0 or getCultivateArtifactPush() == true 
	        	or getCultivateAchievePush() == true 
	        	or getCultivateConstellationPush() == true 
	        	or getCultivateMatrixPush() == true 
	        	or getCultivateCombinationCardPush() == true 
	        	or getCultivateCardBookPush() == true 
	        	or getCultivateRoleBiographyPush() == true 
        		or getCultivateMythicalAnimalsPush() == true then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				else
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(0.5, 0.5))
					ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
					if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
						ball:setPosition(cc.p(params._widget:getContentSize().width-ball:getContentSize().width*0.5-15, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

	local push_notification_cultivate_spirit_terminal = {
		_name = "push_notification_cultivate_spirit",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			local count = 0
			count = getCultivateSpiritPush()
			local isChange = false
	        if count ~= push_notification_cultivate_spirit_count then
	        	isChange = true
	        end
	        push_notification_cultivate_spirit_count = count

	        if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				else
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
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

	local push_notification_cultivate_talent_terminal = {
		_name = "push_notification_cultivate_talent",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
			local count = 0
			count = getCultivateTalentPush()
			local isChange = false
	        if count ~= push_notification_cultivate_talent_count then
	        	isChange = true
	        end
	        push_notification_cultivate_talent_count = count

	        if count > 0 then
				if isChange == true then
					if params._widget._istips == true then
						params._widget:removeChild(params._widget._nodeChild, true)
						params._widget._nodeChild = nil
						params._widget._istips = false
					end
				else
				end
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
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

	local push_notification_cultivate_artifact_terminal = {
		_name = "push_notification_cultivate_artifact",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
	        if getCultivateArtifactPush() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
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

	local push_notification_cultivate_achieve_terminal = {
		_name = "push_notification_cultivate_achieve",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
	        if getCultivateAchievePush() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
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

	local push_notification_cultivate_achieve_Button_maoxian_terminal = {
		_name = "push_notification_cultivate_achieve_Button_maoxian",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
	        if getCultivateAchieveBtnPush(1) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

	local push_notification_cultivate_achieve_Button_yangcheng_terminal = {
		_name = "push_notification_cultivate_achieve_Button_yangcheng",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
	        if getCultivateAchieveBtnPush(2) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

	local push_notification_cultivate_achieve_Button_huodong_terminal = {
		_name = "push_notification_cultivate_achieve_Button_huodong",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
	        if getCultivateAchieveBtnPush(3) == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
					ball:setPosition(cc.p(ball:getContentSize().width*0.5, params._widget:getContentSize().height-ball:getContentSize().height*0.5))
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

	--合金红点推送
	local push_notification_cultivate_matrix_terminal = {
		_name = "push_notification_cultivate_matrix",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
	        if getCultivateMatrixPush() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
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

	--锦囊红点推送
	local push_notification_cultivate_silkbag_terminal = {
		_name = "push_notification_cultivate_silkbag",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
	        if getCultivateSilkBagPush(tonumber(params._datas._type))  == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
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

	--组合卡红点推送
	local push_notification_cultivate_combination_card_terminal = {
		_name = "push_notification_cultivate_combination_card",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
	        if getCultivateCombinationCardPush() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
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

	--卡册红点推送
	local push_notification_cultivate_card_book_terminal = {
		_name = "push_notification_cultivate_card_book",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
	        if getCultivateCardBookPush() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
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

	--忍列传红点推送
	local push_notification_role_biography_terminal = {
		_name = "push_notification_role_biography",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
	        if getCultivateRoleBiographyPush() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
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

	--神兽红点推送
	local push_notification_mythical_animal_terminal = {
		_name = "push_notification_mythical_animal",
        _init = function (terminal)
        end,
        _inited = false,
        _instance = self,
        _state = 0,
		_invoke = function(terminal, instance, params)
	        if getCultivateMythicalAnimalsPush() == true then
				if params._widget._istips == nil or params._widget._istips == false then
					local ball = cc.Sprite:create("images/ui/bar/tips.png")
					ball:setAnchorPoint(cc.p(1, 1))
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

	state_machine.add(push_notification_mythical_animal_terminal)
	state_machine.add(push_notification_home_cultivate_terminal)
	state_machine.add(push_notification_cultivate_spirit_terminal)
	state_machine.add(push_notification_cultivate_talent_terminal)
	state_machine.add(push_notification_cultivate_artifact_terminal)
	state_machine.add(push_notification_cultivate_achieve_terminal)
	state_machine.add(push_notification_cultivate_achieve_Button_maoxian_terminal)
	state_machine.add(push_notification_cultivate_achieve_Button_yangcheng_terminal)
	state_machine.add(push_notification_cultivate_achieve_Button_huodong_terminal)
	state_machine.add(push_notification_cultivate_matrix_terminal)
	state_machine.add(push_notification_cultivate_silkbag_terminal)
	state_machine.add(push_notification_cultivate_combination_card_terminal)
	state_machine.add(push_notification_cultivate_card_book_terminal)
	state_machine.add(push_notification_role_biography_terminal)

    state_machine.init()
end
init_push_notification_cultivate_terminal()

function getCultivatePush()
	local index = 0 
	index = index + getCultivateSpiritPush()
	index = index + getCultivateTalentPush()
	return index
end

function getCultivateSpiritPush()
	if funOpenDrawTip(122, false) == true then
		return 0
	end
	local index = 0 
	local number = #dms["ship_spirit_group"]
	for i=1, number do
		local needid = zstring.split(dms.string(dms["ship_spirit_group"], i, ship_spirit_group.ship_need_id),",")
		for j, v in pairs(needid) do
            local selected_ship = fundShipWidthTemplateId(v)
            if selected_ship ~= nil then
    			local isMax = false
				if type(selected_ship.shipSpirit) == "string" and selected_ship.shipSpirit:find(":", 1, true) then
					local info = zstring.split(selected_ship.shipSpirit, ":")
					local spirit = zstring.split(info[2],",")
					local infos = dms.searchs(dms["ship_spirit_param"], ship_spirit_param.stalls, spirit[3])
					if tonumber(spirit[1]) >= #infos then
						infos = dms.searchs(dms["ship_spirit_param"], ship_spirit_param.stalls, tonumber(spirit[3] + 1))
						if infos == nil then
							isMax = true
						end
					end
				end
				if isMax == false then
	            	local need_props = zstring.split(dms.string(dms["ship_spirit_group"], i, ship_spirit_group.need_props),"|")
	            	for x=1, #need_props do
		            	local props = zstring.split(need_props[x],",")
		            	if tonumber(getPropAllCountByMouldId(tonumber(props[2]))) > 0 then
		            		index = index + 1
		            	end
		            end
		        end
            end
        end
	end
	return index
end

function getCultivateTalentPush()
	-- Talent data is optional until its original init response arrives.
	if type(_ED.digital_talent_page_is_lock) ~= "table" or _ED.user_info.talent_point == nil then
		return 0
	end
	if funOpenDrawTip(121, false) == true then
		return 0
	end
	local index = 0
	if _ED.digital_talent_page_is_lock ~= nil and _ED.digital_talent_page_is_lock ~= "" and _ED.user_info.talent_point ~= nil then
	else
		-- TODO 减少进入游戏前端向后端请求的次数
		-- local function responseCallback(response)
  --           if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            	if _ED.digital_talent_page_is_lock ~= nil and _ED.digital_talent_page_is_lock ~= "" and _ED.user_info.talent_point ~= nil then
            		state_machine.excute("notification_center_update", 0, "push_notification_cultivate_talent")
            	end
        --     end
        -- end
		-- NetworkManager:register(protocol_command.ship_talent_init.code, nil, nil, nil, nil, responseCallback, false, nil) 
	end

	for i=1, 3 do
		local number = 0 
		if i == 1 then
			number = 7
		elseif i == 2 then
			number = 10
		elseif i == 3 then
			number = 10
		end
		if _ED.digital_talent_page_is_lock[i] == false then

			local pageTalentOne = dms.int(dms["ship_talent_group"],i,ship_talent_group.first_mould)
			for j = 1 ,number do
				local talent_id = pageTalentOne - 1 + j
				local table_data = dms.element(dms["ship_talent_mould"] , talent_id)
				local is_open = true

				local lockString = dms.atos(table_data , ship_talent_mould.unlock_condition)
				if lockString ~= "3" then
					local unLockData = zstring.split(lockString ,"|")
					for i , v in pairs(unLockData) do
		                local needData = zstring.split(v , ",")
		                if tonumber(needData[1]) == 1 then -- 等级判定
		                    if tonumber(_ED.user_info.user_grade) < tonumber(needData[2]) then
		                        is_open = false
		                    end
		                else
		                	local currLv = 0
		                	local needLv = tonumber(needData[3])
		                    local needTalent = _ED.digital_talent_already_add[""..needData[2]]
		                    if needTalent == nil then
		                        is_open = false
		                    else
		                    	currLv = tonumber(needTalent.level)
		                    	if tonumber(needTalent.level) < tonumber(needData[3]) then
			                        is_open = false
			                    end
		                    end
		                end
		            end
		        end

	            if is_open == true then
					local maxLv = dms.atoi(table_data , ship_talent_mould.max_lv)
					local currLv = 0
		            local currTalent = _ED.digital_talent_already_add[""..talent_id]
		            if currTalent ~= nil then
		                currLv = zstring.tonumber(currTalent.level)
		            end
		            if currLv < maxLv then
		            	local needGroup = dms.searchs(dms["ship_talent_param"], ship_talent_param.need_mould, talent_id)
					    local virtueLv = currLv + 1
					    if virtueLv > maxLv then
					    	virtueLv = maxLv
					    end
						local nextData = {}
						for x , k in pairs(needGroup) do
							if tonumber(k[3]) == virtueLv then
								nextData = k
								break
							end
						end
						local needData = zstring.split(nextData[4] , "|")
						local flag = true
						for z = 1 , 2 do
							local need = zstring.split(needData[z] , ",")
							if tonumber(need[1]) == 1 then
								if tonumber(need[3]) > zstring.tonumber(_ED.user_info.user_silver) then
									flag = false
								end
							else
								if tonumber(need[3]) > zstring.tonumber(_ED.user_info.talent_point) then
									flag = false
								end
							end
						end
						if flag == true then
							index = index + 1
						end
		            end
		        end
			end
		end
	end
	return index
end

function getCultivateArtifactPush( ... )
	if true == funOpenDrawTip(123, false) then
        return false
    end
	local count = getPropAllCountByMouldId(242)
	if zstring.tonumber(count) >= 5 then
		return true
	end
	return false
end

function getCultivateAchievePush( ... )
	if true == funOpenDrawTip(124, false) then
        return false
    end
	for i = 1, 3 do
		if getCultivateAchieveBtnPush(i) then
			return true
		end
	end
	return false
end

function getCultivateAchieveBtnPush( index )
	if type(_ED.user_artifact_achieve_info) ~= "table" then return false end
	local achieves = {}
	for i, v in ipairs(_ED.user_artifact_achieve_info) do
        local achievement_type = dms.int(dms["achievement"], v.id, achievement.achievement_type)
        if achievement_type and achievement_type == index then
            local achieve_type = dms.int(dms["achievement"], v.id, 4)
			local condition_type = dms.int(dms["achievement"], v.id, 6)
			local condition = (condition_type == 27 and achieve_type == 2) and dms.int(dms["achievement"], v.id, 8) or dms.int(dms["achievement"], v.id, 7)
			if condition == tonumber(v.speed) then
				return true
			end
        end
    end
    return false
end

function getCultivateConstellationPush( ... )
	if type(_ED.constellation_redot_data) ~= "table" then return false end
	local is_show = false
	if true == funOpenDrawTip(125, false) then
        is_show = false
    else
        for i,v in pairs(_ED.constellation_redot_data) do
            for k,z in pairs(v) do
                for j,n in pairs(z) do
                    if tonumber(n) == 0 then
                        is_show = true
                        break
                    else
                        is_show = false
                    end
                end
            end
        end
    end
    return is_show
end

function getCultivateMatrixPush( ... )
	if type(_ED.alloy_matrix_recruit) ~= "table" then return false end
	if true == funOpenDrawTip(125, false) then
        return false
    end

	function isShowRedot( ship )
        for i=1,3 do
            local lock_levels = zstring.split(dms.string(dms["ship_config"], 39, ship_config.param), "!")[i]
            local lock_level = zstring.splits(lock_levels, "|", ":")
            local have = 0
            local use = 0
            for k,v in ipairs(lock_level) do
                if tonumber(lock_level[k][2]) <= tonumber(_ED.user_info.user_grade) then
                    have = have + 1
                end
            end
            local alloyMatrix = _ED.user_ship[ship.ship_id].alloyMatrix
            if alloyMatrix and alloyMatrix.mmi[i .. ""] then
                use = table.nums(alloyMatrix.mmi[i .. ""])
            end
            if use < have then
                return true
            end
        end
        return false
    end

    local is_free = false
	if tonumber(_ED.alloy_matrix_recruit.goldFreeNum) == 1 or tonumber(_ED.alloy_matrix_recruit.diamonFreeNum) == 1 then
		is_free = true
		return is_free
	else
		is_free = false
	end

	local is_show = false
	for i,ship in pairs(_ED.user_ship) do
        if isShowRedot(ship) then
        	is_show = true
        	break
        end
    end

    return is_show or is_free
end

function getCultivateSilkBagPush(pointType)
	-- 忍具页签的红点
	if 1 == pointType then
		if true == funOpenDrawTip(125, false) then
			return false
		end
		if nil == _ED.silkbag_pack_info then 
			return false
		end 
		local lock_level = dms.int(dms["fun_open_condition"], 120+72, fun_open_condition.level)
		if lock_level > tonumber(_ED.user_info.user_grade) then
			return false
		end


		local function isHaveRedot(shipId, shipTemplateId, slotIndex)
			local isHaveNoUseSilk = false
			if slotIndex > 4 then 
				local excluseSilkData = nil
				local haveUpNum = 0
				for k, v in pairs(_ED.silkbag_pack_info) do
					if tonumber(v.onUseShipId) == shipId and tonumber(v.onUseIndex) == slotIndex then
						return false
					end
					local mType = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.mould_type)
					local eType = dms.int(dms["ship_silk_bag_mould"], tonumber(v.silkBagMouldId), ship_silk_bag_mould.exclusive_id)

					if mType == 2 and eType == shipTemplateId and tonumber(v.onUseIndex) == 1 then 
						excluseSilkData = v
					end
				end
				app.load("client.l_digital.cultivate.silkbag.SilkBagHandler")
				if excluseSilkData and SilkBagHandler.getOpenProtect() and SilkBagHandler.getSilkProtectOpen(excluseSilkData) then 
					for k, v in pairs(_ED.silkbag_pack_info) do
						if tonumber(v.onUseIndex) == -1 then
							local mType = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.mould_type)
							if mType == 3 then
								isHaveNoUseSilk = true
								break
							end
						end
					end
				end
			else
				for k, v in pairs(_ED.silkbag_pack_info) do
					if tonumber(v.onUseShipId) == shipId and tonumber(v.onUseIndex) == slotIndex then
						return false
					end
					local eType = dms.int(dms["ship_silk_bag_mould"], tonumber(v.silkBagMouldId), ship_silk_bag_mould.exclusive_id)
					local mType = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.mould_type)

					local condition = false
					if slotIndex == 1 then
						condition = mType == 2 and eType == shipTemplateId
					else
						condition = mType == 1
					end

					if -1 == tonumber(v.onUseIndex) and condition then
						isHaveNoUseSilk = true
					end
				end
			end

			--如果没有相关类型的忍具
			if not isHaveNoUseSilk then
				return false
			end

			return true
		end

		local curOpenInfo = dms.string(dms["equipment_config"], 20, equipment_config.param)
		local curOpenNum = curOpenInfo == nil and 4 or tonumber(curOpenInfo)
		
		for _, ship in pairs(_ED.user_ship) do
			local shipId = tonumber(ship.ship_id)
			local shipTemplateId = tonumber(ship.ship_template_id)

			if shipId and shipTemplateId then
				--忍具槽位，专属1 普通2,3,4 护佑 5,6,7,8
				for slotIndex = 1, curOpenNum do
					if isHaveRedot(shipId, shipTemplateId, slotIndex) then
						return true
					end
				end
			end
		end
		return false
	end
    return false
end

-- TODO:养成组合卡界面推送
function getCultivateCombinationCardPush()
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.CombinationCard)
	if fun_is_open == true then
		if true == funOpenDrawTip(193, false) then
			return false
		end

		if nil == _ED.combine_card_list_info then
			return false
		end
		app.load("client.l_digital.cultivate.combinationCard.CombinationCardHandle")
		if CombinationCardHandle.getCombinationCardIsUnlock() or CombinationCardHandle.getRedCountFlag() then
			return true
		end
	end

    return false
end

-- 卡册界面推送
function getCultivateCardBookPush()
	if nil == _ED.illustration_info_init then
		return false
	end
	if true == funOpenDrawTip(194, false) then
		return false
	end
	app.load("client.l_digital.cultivate.illustration.IllustrationHandle")
	if IllustrationHandle.getFlagUnlockAllCard() or 0 < #IllustrationHandle.getFlagUplevelAllCard() then
		return true
	end
    return false
end

-- 忍列传界面推送
function getCultivateRoleBiographyPush()
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.RoleBiography)
	if fun_is_open == true then
		if true == funOpenDrawTip(199, false) then
			return false
		end
		app.load("client.l_digital.cultivate.roleBiography.RoleBiographyHandle")
		if RoleBiographyHandle.isShowRoleBiographyRedDot() then
			return true
		end
	end
    return false
end

-- 神兽养成界面推送
function getCultivateMythicalAnimalsPush()
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.MythicalAnimals)
	if fun_is_open == true then
		if true == funOpenDrawTip(200, false) then
			return false
		end
		app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsHandle")
		if MythicalAnimalsHandle.isShowMythicalAnimalsRedDot() then
			return true
		end
	end
    return false
end
