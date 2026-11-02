-- ----------------------------------------------------------------------------------------------------
-- 说明：分解返还预览界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ResolveReturnPreview = class("ResolveReturnPreviewClass", Window)

function ResolveReturnPreview:ctor()
	closeLastWindow("ResolveReturnPreviewClass")
	
    self.super:ctor()
    
	self.roots = {}
	
	self.enum_type = {
		_HeroResolve = 1,		-- 武将分解
		_EquipResolve = 2,		-- 装备分解
		_HeroReborn = 3,		-- 武将重生
		_EquipReborn = 4,       -- 宝物重生
		_MagicCardResolve = 5,       -- 魔陷分解
		_MagicCardReborn = 6,       -- 魔陷重生
		_EquipNewReborn = 7,       -- 装备重生
		_PetReborn = 8,       -- 宠物重生
		_PetResolve = 9,       -- 宠物分解
	}	
	
	self._relove_type = 1
	self._need_res = nil
	self.type_change_array = {1,5,18,6,7,13,14,33}
	if __lua_project_id == __lua_project_yugioh then 
		app.load("client.cells.magicCard.magic_trup_card_icon_cell")
	end
	
    -- Initialize ResolveReturnPreview page state machine.
    local function init_resolve_return_terminal()
        local resolve_return_close_terminal = {
            _name = "resolve_return_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local resolve_return_request_terminal = {
            _name = "resolve_return_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function responseGetRewardCallback(response)
					_ED.baseFightingCount = calcTotalFormationFight()
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						state_machine.unlock("hero_resolve_do")
						
					end
					if instance == nil or instance.roots == nil then
						return
					end
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local getRewardWnd = DrawRareReward:new()
						if instance._relove_type == instance.enum_type._HeroResolve then
							getRewardWnd:init(9)
						elseif instance._relove_type == instance.enum_type._EquipResolve then 
							getRewardWnd:init(9)
						elseif instance._relove_type == instance.enum_type._PetResolve then
							getRewardWnd:init(9)
						else
							getRewardWnd:init(16)
						end
						fwin:open(getRewardWnd)
						--> print("=====1======",self._relove_type)
						--> print("===2========",self.enum_type._HeroResolve)
						--> print("====3=======",self.enum_type._EquipResolve)
						--> print("====4=======",self.enum_type._HeroReborn)
						if instance._relove_type == instance.enum_type._HeroResolve then
							state_machine.excute("hero_resolve_over_update", 0, "hero_resolve_over_update.")
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
								state_machine.excute("hero_resolve_amiation_play",0,"hero_resolve_amiation_play")
							end
						elseif instance._relove_type == instance.enum_type._EquipResolve then 
							state_machine.excute("equip_resolve_over_update", 0, "equip_resolve_over_update.")
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
								state_machine.excute("equip_resolve_amiation_play",0,"equip_resolve_amiation_play")
							end
						elseif instance._relove_type == instance.enum_type._HeroReborn then 
							state_machine.excute("hero_reborn_over_update", 0, "hero_reborn_over_update.")
						elseif instance._relove_type == instance.enum_type._MagicCardResolve then 
							state_machine.excute("magic_card_resolve_over_update", 0, "magic_card_resolve_over_update.")
						elseif instance._relove_type == instance.enum_type._MagicCardReborn then 
							state_machine.excute("magic_card_reborn_over_update", 0, "hero_reborn_over_update.")
						elseif instance._relove_type == instance.enum_type._EquipNewReborn  then 
							state_machine.excute("equip_reborn_over_update", 0, "equip_reborn_over_update.")
						elseif instance._relove_type == instance.enum_type._PetResolve  then 
							state_machine.excute("pet_resolve_over_update", 0, "pet_resolve_over_update.")
						elseif instance._relove_type == instance.enum_type._PetReborn  then 
							state_machine.excute("pet_reborn_over_update", 0, "pet_reborn_over_update.")
						else
							state_machine.excute("treasure_reborn_over_update", 0, "treasure_reborn_over_update.")
						end
					end
					if instance._relove_type == instance.enum_type._HeroResolve then
						if fwin:find("HeroResolvePageClass") ~= nil then
							fwin:find("HeroResolvePageClass").isDropping = false
						end
					elseif instance._relove_type == instance.enum_type._EquipResolve then
						if fwin:find("EquipResolvePageClass") ~= nil then
							fwin:find("EquipResolvePageClass").isDropping = false
						end
					elseif instance._relove_type == instance.enum_type._MagicCardResolve then 
						if fwin:find("MagicCardResolvePageClass") ~= nil then
							fwin:find("MagicCardResolvePageClass").isDropping = false
						end
					elseif instance._relove_type == instance.enum_type._PetResolve then 
						if fwin:find("PetResolvePageClass") ~= nil then
							fwin:find("PetResolvePageClass").isDropping = false
						end
					end
					fwin:close(instance)
				end
				
				local num = 0
				local str = ""
				for i, v in pairs(instance._need_res) do
					if v ~= nil then
						local instance = nil
						if self._relove_type == self.enum_type._HeroResolve then
							instance = v.ship_id
						elseif self._relove_type == self.enum_type._EquipResolve then
							instance = v.user_equiment_id
						elseif self._relove_type == self.enum_type._HeroReborn then 
							instance = v.ship_id
						elseif self._relove_type == self.enum_type._MagicCardResolve then 
							instance = v.id
						elseif self._relove_type == self.enum_type._MagicCardReborn then 
							instance = v.id
						elseif self._relove_type == self.enum_type._PetResolve or self._relove_type == self.enum_type._PetReborn then
							instance = v.ship_id
						else
							instance = v.user_equiment_id
						end
						
						str = str .. instance .. "\r\n"
						num = num + 1
					end	
				end
				
				instance:setVisible(false)
				if self._relove_type == self.enum_type._HeroResolve then
					fwin:find("HeroResolvePageClass").isDropping = true
					state_machine.excute("hero_resolve_remove_hero_x", 0, "hero_resolve_remove_hero_x.")
				elseif self._relove_type == self.enum_type._EquipResolve then
					fwin:find("EquipResolvePageClass").isDropping = true
					state_machine.excute("equip_resolve_remove_equip_x", 0, "equip_resolve_remove_equip_x.")
				elseif self._relove_type == self.enum_type._MagicCardResolve then 
					fwin:find("MagicCardResolvePageClass").isDropping = true
					state_machine.excute("magic_card_resolve_remove_hero_x", 0, "magic_card_resolve_remove_hero_x.")
				end
				if self._relove_type == self.enum_type._HeroResolve or self._relove_type == self.enum_type._EquipResolve 
					or self._relove_type == self.enum_type._MagicCardResolve then
					protocol_command.refining.param_list = ""..(self._relove_type - 1).."\r\n"..num.."\r\n"..str
					NetworkManager:register(protocol_command.refining.code, nil, nil, nil, nil, responseGetRewardCallback, false, nil)
				elseif self._relove_type == self.enum_type._MagicCardReborn then 
					protocol_command.rebirth.param_list = "2".."\r\n"..str
					NetworkManager:register(protocol_command.rebirth.code, nil, nil, nil, nil, responseGetRewardCallback, false, nil)
				elseif self._relove_type == self.enum_type._EquipNewReborn then 
					protocol_command.rebirth.param_list = "1".."\r\n"..str
					NetworkManager:register(protocol_command.rebirth.code, nil, nil, nil, nil, responseGetRewardCallback, false, nil)
				elseif self._relove_type == self.enum_type._PetResolve then 
					protocol_command.refining.param_list = "5".."\r\n"..num.."\r\n"..str
					NetworkManager:register(protocol_command.refining.code, nil, nil, nil, nil, responseGetRewardCallback, false, nil)
				elseif self._relove_type == self.enum_type._PetReborn then 
					protocol_command.rebirth.param_list = "0".."\r\n"..str
					NetworkManager:register(protocol_command.rebirth.code, nil, nil, nil, nil, responseGetRewardCallback, false, nil)
				else
					protocol_command.rebirth.param_list = ""..(self._relove_type - 3).."\r\n"..str
					NetworkManager:register(protocol_command.rebirth.code, nil, nil, nil, nil, responseGetRewardCallback, false, nil)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(resolve_return_close_terminal)
        state_machine.add(resolve_return_request_terminal)
        state_machine.init()
    end
    
    init_resolve_return_terminal()
end

function ResolveReturnPreview:onEnterTransitionFinish()
	local csbfenjiefanhuan = csb.createNode("refinery/refinery_fenjiefanhuan.csb")
	self:addChild(csbfenjiefanhuan)
	local root = csbfenjiefanhuan:getChildByName("root")
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("refinery/refinery_fenjiefanhuan.csb")
    csbfenjiefanhuan:runAction(action)
    action:gotoFrameAndPlay(0, action:getDuration(), false)

	if self.enum_type._HeroResolve == self._relove_type then
		ccui.Helper:seekWidgetByName(root, "Text_1"):setString(_string_piece_info[234])
	elseif self.enum_type._EquipResolve == self._relove_type then
		ccui.Helper:seekWidgetByName(root, "Text_1"):setString(_string_piece_info[235])
	elseif self.enum_type._HeroReborn == self._relove_type then
		ccui.Helper:seekWidgetByName(root, "Text_1"):setString(_string_piece_info[236])
		ccui.Helper:seekWidgetByName(root, "Text_60"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_203"):setVisible(false)
		local config = zstring.split(dms.string(dms["pirates_config"], 181, pirates_config.param), ",")
		ccui.Helper:seekWidgetByName(root, "Panel_20"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_15555_0"):setString(config[1])
	elseif self.enum_type._EquipReborn == self._relove_type then
		ccui.Helper:seekWidgetByName(root, "Text_1"):setString(_string_piece_info[237])
		ccui.Helper:seekWidgetByName(root, "Text_60"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_203"):setVisible(false)
		local config = zstring.split(dms.string(dms["pirates_config"], 228, pirates_config.param), ",")
		ccui.Helper:seekWidgetByName(root, "Panel_20"):setVisible(true)
		local quality = 0
		for i, v in pairs(self._need_res) do
			if v ~= nil then
				quality = dms.int(dms["equipment_mould"],v.user_equiment_template,equipment_mould.grow_level)
				ccui.Helper:seekWidgetByName(root, "Text_15555_0"):setString(config[quality+1])
				break
			end
		end
	elseif self.enum_type._MagicCardResolve == self._relove_type then
	 	ccui.Helper:seekWidgetByName(root, "Text_1"):setString(_magic_card_tip[10])
	elseif self.enum_type._MagicCardReborn == self._relove_type then 
		ccui.Helper:seekWidgetByName(root, "Text_1"):setString(_magic_card_tip[11])
		ccui.Helper:seekWidgetByName(root, "Text_60"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_203"):setVisible(false)
	elseif self.enum_type._EquipNewReborn == self._relove_type then 
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			ccui.Helper:seekWidgetByName(root, "Text_1"):setString(_string_piece_info[427])
		else
			ccui.Helper:seekWidgetByName(root, "Text_1"):setString(_string_piece_info[383])
		end
		ccui.Helper:seekWidgetByName(root, "Text_60"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_203"):setVisible(false)
		local config = zstring.split(dms.string(dms["pirates_config"], 182, pirates_config.param), ",")
		ccui.Helper:seekWidgetByName(root, "Panel_20"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_15555_0"):setString(config[1])
	end
	-- [[绘制滚动层
	-- local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
	-- local panel = ccui.Layout:create()
	-- panel:setContentSize(m_ScrollView:getContentSize())
	-- panel:setPosition(cc.p(0,0))
	
	-- m_ScrollView:addChild(panel)
	-- local sSize = panel:getContentSize()
	-- local controlSize = m_ScrollView:getInnerContainerSize()
	-- local cellWidth = sSize.width / 4
	
	-- local function addRewardScrollView(_reward, _index)
		-- local tempCell = ResourcesIconCell:createCell()
		-- tempCell:init(self.type_change_array[_reward.type], _reward.value, _reward.mould_id)
		-- local cellHeight = tempCell:getContentSize().height
		-- print("controlSize.width=="..controlSize.width)
		-- local row = math.floor((_index) / 4)
		-- local col = math.floor((_index) % 4)+1
		-- print("高/宽=="..row.."/"..col)
		-- local controlHeight = row * cellHeight
		-- if controlHeight < sSize.height then
			-- controlSize.height = sSize.height
		-- else
			-- controlSize.height = controlHeight + cellHeight
		-- end
		
		-- m_ScrollView:setInnerContainerSize(cc.size(controlSize.width, controlSize.width*(row+1)))
		
		-- local pos = cc.p(cellWidth * col + (cellWidth - tempCell:getContentSize().width)/2,
			-- sSize.height - cellHeight * row)
		-- tempCell:setPosition(pos)
		-- panel:addChild(tempCell)
		-- tempCell:showName(_reward.mould_id,self.type_change_array[_reward.type])
		-- panel:setPositionY(controlSize.height - sSize.height)
		-- local tempCell = ResourcesIconCell:createCell()
		-- tempCell:init(self.type_change_array[_reward.type], _reward.value, _reward.mould_id)
		-- panel:addChild(tempCell)
		-- local row = math.floor((_index) / 4)
		-- local col = math.floor((_index) % 4)
		-- local pos = cc.p(tempCell:getContentSize().width * (col-1),
		-- tempCell:getContentSize().height*(row))
		-- tempCell:setPosition(pos)
		-- tempCell:showName(_reward.mould_id,self.type_change_array[_reward.type])
		-- if controlSize.height > tempCell:getContentSize().height*(row+1) then
			-- m_ScrollView:setInnerContainerSize(cc.size(controlSize.width, controlSize.height))
		-- else
			-- m_ScrollView:setInnerContainerSize(cc.size(controlSize.width, tempCell:getContentSize().height*(row+1)))
		-- end
		-- panel:setPositionY(controlSize.height - tempCell:getContentSize().height*(row+1))
		-- return tempCell
	-- end
	
	-------------------------------------------
		-- [[绘制滚动层
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
	local panel = ccui.Layout:create()
	panel:setContentSize(m_ScrollView:getContentSize())
	
	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)
	m_ScrollView:addChild(panel)
	local sSize = panel:getContentSize()
	local controlSize = m_ScrollView:getInnerContainerSize()
	local cellWidth = sSize.width / 4
	local function addRewardScrollView(_reward, _index)
		local tempCell = nil 
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
			if zstring.tonumber(_reward.mould_type) == 6 then 
				--获取英雄基本模板ID
				local baseHeroId = dms.int(dms["ship_mould"], _reward.mould_id, ship_mould.base_mould) 
				tempCell = ResourcesIconCell:createCell()
				tempCell:init(self.type_change_array[_reward.mould_type], _reward.value,baseHeroId)
			elseif zstring.tonumber(_reward.mould_type) == 7 then 
				--魔陷卡

				tempCell = MagicTrupCardIconCell:createCell()
				tempCell:init(_reward.mould_id,_reward.value)
			else
				tempCell = ResourcesIconCell:createCell()
				tempCell:init(self.type_change_array[_reward.mould_type], _reward.value, _reward.mould_id)
			end
		else
			tempCell = ResourcesIconCell:createCell()
			tempCell:init(self.type_change_array[_reward.mould_type], _reward.value, _reward.mould_id)
		end
		
		panel:addChild(tempCell)
		tempCell:showName(_reward.mould_id,self.type_change_array[_reward.mould_type])
		local cellHeight = tempCell:getContentSize().height+20

		local row = math.floor((_index - 1) / 4 + 1)
		local col = math.floor((_index - 1) % 4)
		
		local controlHeight = row * cellHeight
		
		if controlHeight < sSize.height then
			controlSize.height = sSize.height
		else
			controlSize.height = controlHeight + cellHeight
		end
		local pos = nil
		if table.getn(_ED.resolve_preview_info.res_info) > 16 then
			m_ScrollView:setInnerContainerSize(cc.size(controlSize.width, controlSize.height - cellHeight))
			
			pos = cc.p(cellWidth * col + (cellWidth - tempCell:getContentSize().width)/2,
				sSize.height - cellHeight * row-cellHeight+20)
		else
			m_ScrollView:setInnerContainerSize(cc.size(controlSize.width, controlSize.height))
			
			pos = cc.p(cellWidth * col + (cellWidth - tempCell:getContentSize().width)/2,
				sSize.height - cellHeight * row)
		end
		tempCell:setPosition(pos)
		panel:setPositionY(controlSize.height - sSize.height)
		return tempCell
	end
	-------------------------------------------
	local function initRewardScrollView()
		panel:removeAllChildren(true)
		for i, v in ipairs(_ED.resolve_preview_info.res_info) do
			addRewardScrollView(v, i)
		end
	end	--]]
	
	initRewardScrollView()
	
	-- 关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "resolve_return_close", 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	-- 取消
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
	{
		terminal_name = "resolve_return_close", 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	-- 确定
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2_0"), nil, 
	{
		terminal_name = "resolve_return_request", 
		isPressedActionEnabled = true
	}, 
	nil, 0)
end

function ResolveReturnPreview:onExit()
	-- state_machine.remove("resolve_return_close")
	-- state_machine.remove("resolve_return_request")
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		state_machine.unlock("hero_resolve_do")
	end
end

function ResolveReturnPreview:init(_relove_type, _need_res)
	self._relove_type = _relove_type
	self._need_res = _need_res
end
