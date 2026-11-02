UnionFightNpc = class("UnionFightNpcClass", Window)

function UnionFightNpc:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.mapInfo = nil
	self.chooseCamp = 0

    local function init_union_fight_npc_terminal()
		local union_fight_npc_click_terminal = {
            _name = "union_fight_npc_click",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mapInfo = params._datas.cell.mapInfo
                local campState = params._datas.cell.chooseCamp
                if tonumber(_ED.union_fight_state) == 2 then
                	local function responseCallback( response )
                	end
                	if _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
	                	protocol_command.unino_message_refush.param_list = _ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number
	                	NetworkManager:register(protocol_command.unino_message_refush.code, _ED.union_fight_url, nil, nil, cell, responseCallback, true, nil)
                	end
                end
    			if campState == 1 then
                	if tonumber(mapInfo.mapState) == 0 then
	                	TipDlg.drawTextDailog(tipStringInfo_union_str[59])
                	else
                		if table.nums(mapInfo.defenders) == 0 then
                			state_machine.excute("union_fight_main_request_refresh", 0, mapInfo.mapId)
                		end
                		state_machine.excute("union_fight_formation_open", 0, {mapInfo, instance.chooseCamp})
                	end
                else
                	state_machine.excute("union_fight_formation_open", 0, {mapInfo, instance.chooseCamp})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_npc_get_reward_terminal = {
            _name = "union_fight_npc_get_reward",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance.chooseCamp == 0 then
            		return
            	end
            	local cell = params._datas.cell
                local mapInfo = cell.mapInfo
            	local function responseCallback( response )
            		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            			if response.node ~= nil then
            				response.node:updateRewardState(false)
            				local mapData = dms.element(dms["union_fight_campsite_mould"], mapInfo.mapId)
							local rewards = dms.atos(mapData, union_fight_campsite_mould.reward)
            				local rewardInfo = zstring.split(rewards, ",")
            				local reward = {}
            				reward._reward_item_count = 1
            				reward._reward_list = {{prop_type = tonumber(rewardInfo[1]), 
            					prop_item = tonumber(rewardInfo[2]), item_value = tonumber(rewardInfo[3])}}
            				fwin:open(UnionFightGainReward:new():init(reward), fwin._windows)
            			end
            		end
            	end
            	if _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
	            	protocol_command.draw_union_campsite_reward.param_list = _ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number.."\r\n"..mapInfo.mapId
	            	NetworkManager:register(protocol_command.draw_union_campsite_reward.code, _ED.union_fight_url, nil, nil, cell, responseCallback, true, nil)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_fight_npc_click_terminal)
		state_machine.add(union_fight_npc_get_reward_terminal)
        state_machine.init()
    end
	
    init_union_fight_npc_terminal()
end

function UnionFightNpc:updateInfo( mapInfo )
	self.mapInfo = mapInfo
	self:updateDraw()
end

function UnionFightNpc:updateRewardState( isInit )
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Panel_jl = ccui.Helper:seekWidgetByName(root, "Panel_jl")
	local mapData = dms.element(dms["union_fight_campsite_mould"], self.mapInfo.mapId)
	local reward = dms.atos(mapData, union_fight_campsite_mould.reward)

	local isGetReward = false
	if tonumber(reward) ~= -1 then
		for k,v in pairs(_ED.union_fight_reward_state) do
			if tonumber(self.mapInfo.mapId) == tonumber(v) then
				isGetReward = true
			end
		end
	else
		isGetReward = true
	end

	Panel_jl:removeAllChildren(true)
	Panel_jl:setVisible(false)
	if tonumber(self.mapInfo.mapState) == 3 and self.chooseCamp == 1 then
		if isGetReward == true or isInit == false then
		else
			local rewardUnion = csb.createNode("legion/legion_pve_map_jlicon.csb")
		    Panel_jl:addChild(rewardUnion)

		    local action = csb.createTimeline("legion/legion_pve_map_jlicon.csb")
		    rewardUnion:runAction(action)
		    action:play("animation0", true)
			Panel_jl:setVisible(true)
		end
	end
end

function UnionFightNpc:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh or
		__lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		self:updateRewardState(true)
	end
	local mapData = dms.element(dms["union_fight_campsite_mould"], self.mapInfo.mapId)
	local pic_index = dms.atos(mapData, union_fight_campsite_mould.pic_index)
	local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
	local Sprite_icon = Panel_icon:getChildByName("Sprite_icon")
	local Panel_shibai = ccui.Helper:seekWidgetByName(root, "Panel_shibai")
	Panel_shibai:removeAllChildren(true)
	local Panel_shishou = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		Panel_shishou = ccui.Helper:seekWidgetByName(root, "Panel_shishou")
		Panel_shishou:removeAllChildren(true)
	end
	Sprite_icon:setTexture(string.format("images/ui/play/legion/jianchuan_%d.png", pic_index))
	display:ungray(Sprite_icon)
	if tonumber(self.mapInfo.mapState) == 0 then
		if self.chooseCamp == 1 then
			display:gray(Sprite_icon)
		end
	elseif tonumber(self.mapInfo.mapState) == 2 then
		if self.chooseCamp == 1 then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				local effect_paths = "images/ui/effice/legion_shishou/legion_shishou.ExportJson"
		        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
		        local armature = ccs.Armature:create("legion_shishou")
		        draw.initArmature(armature, nil, -1, 0, 1)
		        local function changeActionCallback( armatureBack )
		        end
		        armature._invoke = changeActionCallback
		        armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		        Panel_shishou:addChild(armature)
			end
		end
	elseif tonumber(self.mapInfo.mapState) == 3 then
        display:gray(Sprite_icon)
        local effect_paths = "images/ui/effice/effect_xiaoyan/effect_xiaoyan.ExportJson"
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
        local armature = ccs.Armature:create("effect_xiaoyan")
        draw.initArmature(armature, nil, -1, 0, 1)
        local function changeActionCallback( armatureBack )
        end
        armature._invoke = changeActionCallback
        armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        Panel_shibai:addChild(armature)
	end
end

function UnionFightNpc:onEnterTransitionFinish()
	local csbUnion = csb.createNode("legion/legion_pve_map_icon.csb")
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

	self:updateDraw()

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_icon"), nil, 
    {
        terminal_name = "union_fight_npc_click", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        cell = self
    }, 
    nil, 0)

	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh or
		__lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
	    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_jl"), nil, 
	    {
	        terminal_name = "union_fight_npc_get_reward", 
	        terminal_state = 0,
	        isPressedActionEnabled = true,
	        cell = self
	    }, 
	    nil, 0)
	end
end

function UnionFightNpc:init(mapInfo, chooseCamp)
	self.mapInfo = mapInfo
	self.chooseCamp = chooseCamp

    -- self:setSwallowTouches(false)
	return self
end

function UnionFightNpc:CreateCell( ... )
	local cell = UnionFightNpc:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
