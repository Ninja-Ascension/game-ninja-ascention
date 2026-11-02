-- ----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战鼓舞
-------------------------------------------------------------------------------------------------------

CrossServerBattelAddition = class("CrossServerBattelAdditionClass", Window)

local cross_server_battel_addition_open_terminal = {
    _name = "cross_server_battel_addition_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local function responseCrossServerBattelAdditionInitCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				local CrossServerBattelAdditionWindow = fwin:find("CrossServerBattelAdditionClass")
		    	if CrossServerBattelAdditionWindow == nil then
		    		fwin:open(CrossServerBattelAddition:new():init(params), fwin._view)
		    	end
			end
		end
		protocol_command.cross_mine_user_feed.param_list = -1 .. "\r\n" .. -1 .. "\r\n" .. 1
		NetworkManager:register(protocol_command.cross_mine_user_feed.code, nil, nil, nil, nil, responseCrossServerBattelAdditionInitCallback, false, nil)
   		-- fwin:open(CrossServerBattelAddition:new():init(params), fwin._view)
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(cross_server_battel_addition_open_terminal)
state_machine.init()

function CrossServerBattelAddition:ctor()
    self.super:ctor()
	self.roots = {}
	self.add_type = 1 -- 1全服 2 个人
	self._armature = nil

	self.createList = false --是否显示list

	app.load("client.l_digital.cells.campaign.CrossServerBattel.cross_service_addition_cell")

	local function init_cross_server_battel_addition_terminal()
		--
		local cross_server_battel_addition_close_terminal = {
            _name = "cross_server_battel_addition_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("CrossServerBattelAdditionClass"))
				fwin:close(fwin:find("CrossServerBattelShopTopClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_addition_switch_terminal = {
            _name = "cross_server_battel_addition_switch",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local _type = params._datas._type
				if _type then
					instance.add_type = _type
					instance:onTabListChange(_type)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_addition_update_terminal = {
            _name = "cross_server_battel_addition_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local _type = tonumber(params)
				if _type then
					instance:updateLevelExp(_type)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_addition_to_list_terminal = {
            _name = "cross_server_battel_addition_to_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local _type = instance.add_type
				if _type then
					instance.createList = true
					instance:onTabListChange(_type)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_addition_show_buff_terminal = {
            _name = "cross_server_battel_addition_show_buff",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local _type = instance.add_type
				if _type then
					instance.createList = false
					instance:showDefaultPanel(_type)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }       

        state_machine.add(cross_server_battel_addition_close_terminal)
        state_machine.add(cross_server_battel_addition_switch_terminal)
        state_machine.add(cross_server_battel_addition_update_terminal)
        state_machine.add(cross_server_battel_addition_to_list_terminal)
        state_machine.add(cross_server_battel_addition_show_buff_terminal)
		state_machine.init()
	end
	init_cross_server_battel_addition_terminal()
end

function CrossServerBattelAddition:onUpdateDraw()
	local root = self.roots[1]
	local Text_cross_role_add_chat_infor = ccui.Helper:seekWidgetByName(root, "Text_cross_role_add_chat_infor")
	local Button_cross_service_additon_close = ccui.Helper:seekWidgetByName(root, "Button_cross_service_additon_close")
	Text_cross_role_add_chat_infor:setString(tipStringInfo_cross_server_battel_tips[14])
	Button_cross_service_additon_close:setVisible(self.createList)

	self:onTabListChange(1)
	local actionIndex = _enum_animation_l_frame_index.animation_skill_attacking
	self:updateDrawRole(actionIndex)
end

function CrossServerBattelAddition:showDefaultPanel( _type )
	local root = self.roots[1]
	local Panel_cross_addition_lv = ccui.Helper:seekWidgetByName(root, "Panel_cross_addition_lv")
	local listview = ccui.Helper:seekWidgetByName(root, "ListView_cross_service_additon")
	local Button_cross_service_additon_close = ccui.Helper:seekWidgetByName(root, "Button_cross_service_additon_close")
	listview:removeAllItems()
	Panel_cross_addition_lv:setVisible(not self.createList)
	Button_cross_service_additon_close:setVisible(self.createList)
	if self.createList then
		return
	end 
	local Text_cross_addition_atk_t = ccui.Helper:seekWidgetByName(root, "Text_cross_addition_atk_t")
	local Text_cross_addition_atk_n = ccui.Helper:seekWidgetByName(root, "Text_cross_addition_atk_n")
	local Text_cross_addition_atk_top_t = ccui.Helper:seekWidgetByName(root, "Text_cross_addition_atk_top_t")

	local Text_cross_addition_defense_t = ccui.Helper:seekWidgetByName(root, "Text_cross_addition_defense_t")
	local Text_cross_addition_defense_n = ccui.Helper:seekWidgetByName(root, "Text_cross_addition_defense_n")
	local Text_cross_addition_defense_top_t = ccui.Helper:seekWidgetByName(root, "Text_cross_addition_defense_top_t")

	local Text_cross_addition_blood_t = ccui.Helper:seekWidgetByName(root, "Text_cross_addition_blood_t")
	local Text_cross_addition_blood_n = ccui.Helper:seekWidgetByName(root, "Text_cross_addition_blood_n")
	local Text_cross_addition_blood_top_t = ccui.Helper:seekWidgetByName(root, "Text_cross_addition_blood_top_t")

	local level = 0
	local add_attributes = nil
	local next_add_attributes = nil
	local all_type_info = dms.searchs(dms["cross_mine_war_encouraging_exp"], cross_mine_war_encouraging_exp._type, _type)
	local max_level = tonumber(_ED.cross_server_battel_addition_info.MaxLevel)
	if _type == 1 then
		level = _ED.cross_server_battel_addition_info.crossMineServerOreBeastInfo.oreBeastLevel
		add_attributes = self:getNextExp(_type, level)[2]
		next_add_attributes = self:getNextExp(_type, level)[3]
	elseif _type == 2 then
		level = _ED.cross_server_battel_addition_info.userOreBeastInfo.level
		add_attributes = self:getNextExp(_type, level)[2]
		next_add_attributes = self:getNextExp(_type, level)[3]
	end

	if add_attributes then
		local add_attribute = zstring.splits(add_attributes, "|", ",")
		Text_cross_addition_atk_n:setString(add_attribute[1][2] .. "%")
		Text_cross_addition_defense_n:setString(add_attribute[2][2] .. "%")
		Text_cross_addition_blood_n:setString(add_attribute[3][2] .. "%")

		if level < max_level and next_add_attributes then
			local next_add_attribute = zstring.splits(next_add_attributes, "|", ",")
			Text_cross_addition_atk_top_t:setString(string.format(tipStringInfo_cross_server_battel_tips[9], tonumber(next_add_attribute[1][2])))
			Text_cross_addition_defense_top_t:setString(string.format(tipStringInfo_cross_server_battel_tips[10], tonumber(next_add_attribute[2][2])))
			Text_cross_addition_blood_top_t:setString(string.format(tipStringInfo_cross_server_battel_tips[11], tonumber(next_add_attribute[3][2])))
			Text_cross_addition_atk_top_t:setColor(cc.c3b(63,255,55))
			Text_cross_addition_defense_top_t:setColor(cc.c3b(63,255,55))
			Text_cross_addition_blood_top_t:setColor(cc.c3b(63,255,55))
		elseif level >= max_level then
			Text_cross_addition_atk_top_t:setString(tipStringInfo_cross_server_battel_tips[12])
			Text_cross_addition_defense_top_t:setString(tipStringInfo_cross_server_battel_tips[12])
			Text_cross_addition_blood_top_t:setString(tipStringInfo_cross_server_battel_tips[12])
			Text_cross_addition_atk_top_t:setColor(cc.c3b(254,41,41))
			Text_cross_addition_defense_top_t:setColor(cc.c3b(254,41,41))
			Text_cross_addition_blood_top_t:setColor(cc.c3b(254,41,41))
		end
	end
end

function CrossServerBattelAddition:getNextExp( _type, level )
	local all_type_info = dms.searchs(dms["cross_mine_war_encouraging_exp"], cross_mine_war_encouraging_exp._type, _type)
	local currentInfo = nil
	local max_ids = #all_type_info
	for i,v in ipairs(all_type_info) do
		if tonumber(v[cross_mine_war_encouraging_exp.level]) == level then
			currentInfo = v
			break
		end
	end
	local next_exps = dms.int(dms["cross_mine_war_encouraging_exp"], tonumber(currentInfo[cross_mine_war_encouraging_exp.id]) + 1, cross_mine_war_encouraging_exp.need_exps)
	local add_attribute = dms.string(dms["cross_mine_war_encouraging_exp"], tonumber(currentInfo[cross_mine_war_encouraging_exp.id]), cross_mine_war_encouraging_exp.add_additional)
	local next_add_attribute = dms.string(dms["cross_mine_war_encouraging_exp"], tonumber(currentInfo[cross_mine_war_encouraging_exp.id]) + 1, cross_mine_war_encouraging_exp.add_additional)
	if _type == 1 and tonumber(currentInfo[cross_mine_war_encouraging_exp.id]) >= max_ids then
		next_exps = -1
	elseif _type == 2 and not next_exps then
		next_exps = -1
	end
	return {next_exps, add_attribute, next_add_attribute}
end

function CrossServerBattelAddition:updateLevelExp(_type)
	local root = self.roots[1]
	local level = 0
	local exp = 0
	local next_exps = 0
	if _type == 1 then
		level = _ED.cross_server_battel_addition_info.crossMineServerOreBeastInfo.oreBeastLevel
		exp = _ED.cross_server_battel_addition_info.crossMineServerOreBeastInfo.oreBeastExp
		next_exps = self:getNextExp(_type, level)[1]
	elseif _type == 2 then
		level = _ED.cross_server_battel_addition_info.userOreBeastInfo.level
		exp = _ED.cross_server_battel_addition_info.userOreBeastInfo.exp
		next_exps = self:getNextExp(_type, level)[1]
	end
	
	local LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
	local txt_level  = ccui.Helper:seekWidgetByName(root, "Text_24")
	local num = ccui.Helper:seekWidgetByName(root, "Text_24_0")

	if next_exps == -1 then
		LoadingBar_1:setPercent(1*100)
		txt_level:setString(level)
		num:setString(tipStringInfo_cross_server_battel_tips[8])
	else
		LoadingBar_1:setPercent(exp/next_exps*100)
		txt_level:setString(level)
		num:setString(exp .. "/" .. next_exps)
	end
end

function CrossServerBattelAddition:onTabListChange(_type)
	local root = self.roots[1]
	local listview = ccui.Helper:seekWidgetByName(root, "ListView_cross_service_additon")
	local tab_btn_all = ccui.Helper:seekWidgetByName(root, "Button_cross_service_addition_all")
	local tab_btn_per = ccui.Helper:seekWidgetByName(root, "Button_cross_service_addition_personal")
	local Image_cross_service_additon_t_1 = ccui.Helper:seekWidgetByName(root, "Image_cross_service_additon_t_1")
	local Image_cross_service_additon_t_2 = ccui.Helper:seekWidgetByName(root, "Image_cross_service_additon_t_2")

	if _type == 1 then
		tab_btn_all:setHighlighted(true)
		tab_btn_all:setTouchEnabled(false)

		tab_btn_per:setHighlighted(false)
		tab_btn_per:setTouchEnabled(true)

		Image_cross_service_additon_t_1:setVisible(true)
		Image_cross_service_additon_t_2:setVisible(false)
	else
		tab_btn_all:setHighlighted(false)
		tab_btn_all:setTouchEnabled(true)

		tab_btn_per:setHighlighted(true)
		tab_btn_per:setTouchEnabled(false)

		Image_cross_service_additon_t_1:setVisible(false)
		Image_cross_service_additon_t_2:setVisible(true)
	end

	self:updateLevelExp(_type)
	self:showDefaultPanel(_type)
	listview:removeAllItems()

	if self.createList then
		for i = 1, #dms["cross_mine_war_encouraging_param"] do
			local additionCellInfo = dms.element(dms["cross_mine_war_encouraging_param"], i)
			local cell = CrossServiceAdditionCell:createCell()
			cell:init({additionCellInfo, _type})
			listview:addChild(cell)
		end

		listview:refreshView()
		self.cacheListView = listview
		self.currentInnerContainer = listview:getInnerContainer()
		self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	end
end

function CrossServerBattelAddition:updateDrawRole(actionIndex)
	local root = self.roots[1]
	local Panel_cross_role = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_cross_role")
	local hero_fight = 0
	local ship_id = 0
	for i,v in pairs(_ED.user_ship) do
		if zstring.tonumber(v.hero_fight) > hero_fight then
			hero_fight = zstring.tonumber(v.hero_fight)
			ship_id = i
		end
	end
	if ship_id and ship_id ~= 0 then
		local evo_mould_id = smGetSkinEvoIdChange(_ED.user_ship[ship_id])
		local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)

	 	app.load("client.battle.fight.FightEnum")
		if self._armature == nil then
			Panel_cross_role:removeAllChildren(true)
			self._armature = sp.spine_sprite(Panel_cross_role, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				self._armature:setScaleX(-1)
			end
		end

		if self._armature then
			self._armature.animationNameList = spineAnimations
			sp.initArmature(self._armature, true)
			local function changeActionCallback( armatureBack )
			-- if self.play_index == 14 then
			-- 	if self ~= nil and self.roots ~= nil then
			-- 		state_machine.excute("formation_hero_develop_play_hero_animation",0,self.animation_index)
			-- 	end	
		    end

		    local function checkFrameEvent(events, mode)
			    if events ~= n and #events > 0 then
			        for i, v in pairs(events) do
			            if v == mode then
			                return true
			            end
			        end
			    end
			    return false
			end

		    local function onFrameEventRole(bone,evt,originFrameIndex,currentFrameIndex)
			    local armature = bone:getArmature()
			    local _self = armature._self

			    local frameEvents = zstring.split(evt, "_")
			    if checkFrameEvent(frameEvents, "union") == true then -- 启动角色镜头聚焦
					-- print("start union effect!")
			        local effectIds = zstring.split(frameEvents[2], ",")
			        for i, v in pairs(effectIds) do
						-- print("create union effect:", v)
			            local armatureEffect = _self:createEffect(v, "sprite/effect_")
			            armatureEffect._self = _self
			            armatureEffect._invoke = deleteEffectFile

			            local map = armature -- _self:getParent()
			            map:addChild(armatureEffect)
			        end
			    end
			end
		    self._armature._self = self
		    self._armature:getAnimation():setFrameEventCallFunc(onFrameEventRole)
		    self._armature._invoke = changeActionCallback
		    self._armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		    csb.animationChangeToAction(self._armature, actionIndex, 0, false)
		    self._armature._nextAction = 0
		end
	end
end

function CrossServerBattelAddition:createEffect(fileIndex, fileNameFormat)
    -- 创建光效
    local armature = nil
    if animationMode == 1 then
        -- armature = sp.spine_sprite(self, self._brole._head, spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
        -- armature.animationNameList = spineAnimations
        -- sp.initArmature(armature, true)
        armature = sp.spine_effect(fileIndex, effectAnimations[1], false, nil, nil, nil, nil, nil, nil, fileNameFormat)
        armature.animationNameList = effectAnimations
        sp.initArmature(armature, true)
    else
        local armatureName, fileName = self:loadEffectFile(fileIndex)
        armature = ccs.Armature:create(armatureName)
        armature._fileName = fileName
    end
    -- table.insert(self.animationList, {fileName = fileName, armature = armature})
    local frameListCount = math.floor(armature:getAnimation():getAnimationData():getMovementCount() / 2)
    -- local _tcamp = zstring.tonumber(""..self.roleCamp)
    local _armatureIndex = 0 -- frameListCount * _tcamp
    armature:getAnimation():playWithIndex(_armatureIndex)
    armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
    -- armature:getAnimation():setSpeedScale(1.0 / __fight_recorder_action_time_speed)
    
    local duration = zstring.tonumber(dms.int(dms["duration"], fileIndex, 1))
    armature._duration = duration / 60.0
    return armature
end

function CrossServerBattelAddition:onUpdate(dt)
	if self.cacheListView ~= nil and self.currentInnerContainer ~= nil then
		local size = self.cacheListView:getContentSize()
		local posY = self.currentInnerContainer:getPositionY()
		if self.currentInnerContainerPosY == posY then
			return
		end
		self.currentInnerContainerPosY = posY
		local items = self.cacheListView:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
				v:unload()
			else
				v:reload()
			end
		end
	end
end

function CrossServerBattelAddition:onInit()
	local csbCrossServerShop = csb.createNode("campaign/cross_service/cross_service_addition.csb")
	local root = csbCrossServerShop:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csbCrossServerShop)

    self:onUpdateDraw()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_service_addition_back"), nil, 
	{
		terminal_name = "cross_server_battel_addition_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 2)

    --全服、个人切换
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_service_addition_all"), nil, 
	{
		terminal_name = "cross_server_battel_addition_switch", 
		terminal_state = 0, 
		_type = 1,
		isPressedActionEnabled = true
	},
	nil, 2)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_service_addition_personal"), nil, 
	{
		terminal_name = "cross_server_battel_addition_switch", 
		terminal_state = 0, 
		_type = 2,
		isPressedActionEnabled = true
	},
	nil, 2)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_addition_inspire"), nil, 
	{
		terminal_name = "cross_server_battel_addition_to_list", 
		terminal_state = 0,
		isPressedActionEnabled = true
	},
	nil, 2)


	-- local panel_role = ccui.Helper:seekWidgetByName(root, "Panel_cross_role")
	-- panel_role:setTouchEnabled(true)
	-- fwin:addTouchEventListener(panel_role, nil, 
	-- {
	-- 	terminal_name = "cross_server_battel_addition_to_list", 
	-- 	terminal_state = 0,
	-- 	_type = self.add_type,
	-- 	isPressedActionEnabled = true
	-- },
	-- nil, 2)

	local Button_cross_service_additon_close = ccui.Helper:seekWidgetByName(root, "Button_cross_service_additon_close")
	-- Button_cross_service_additon_close:setTouchEnabled(true)
	fwin:addTouchEventListener(Button_cross_service_additon_close, nil, 
	{
		terminal_name = "cross_server_battel_addition_show_buff", 
		terminal_state = 0,
		isPressedActionEnabled = true
	},
	nil, 2)

	app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelShopTop") 					--顶部用户信息
	local userinfo = CrossServerBattelShopTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

	self:registerOnNodeEvent(self)
	self:registerOnNoteUpdate(self, 1)
end

function CrossServerBattelAddition:init()
	self:onInit()
	return self
end

function CrossServerBattelAddition:onExit()
	-- state_machine.remove("")
end

