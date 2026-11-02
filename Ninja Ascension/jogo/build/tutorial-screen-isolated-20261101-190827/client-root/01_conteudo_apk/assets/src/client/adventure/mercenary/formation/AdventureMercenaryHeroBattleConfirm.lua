-- ----------------------------------------------------------------------------------------------------
-- 说明：武将上阵确认
-------------------------------------------------------------------------------------------------------
AdventureMercenaryHeroBattleConfirm = class("AdventureMercenaryHeroBattleConfirmClass", Window)
    
function AdventureMercenaryHeroBattleConfirm:ctor()
    self.super:ctor()
    self.roots = {}
	
	app.load("client.adventure.cells.skill.adventure_skill_icon_cell")
	self.currentScrollView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
	self.current_type = 0
	self.enum_type = {
		_TYPE_SHOW_BATTLE_CONFIRM = 0,		-- 阵容上阵确认
		_TYPE_SHOW_TRANSFORM_CHOICE_SERVANTS = 1,	-- 选择灵源
		_TYPE_SHOW_TRANSFORM_CHOICE_THEMAIN = 2,	-- 选择灵主
		_TYPE_SHOW_AGREEMENT_CONFIRM = 3,	-- 选择需要签订的英雄
	}
	self.formationId = 0
	self.drawIndex = 0
	self.ship = 0
	self.hetiSkillText = nil
	self.ArmatureNode_heti_skill = nil
	self.hetiSKillPanel = nil
	self.skillId = 0
	self.siwei_ycPanel = nil
    self.siwei_ycPanelShow = nil
    self.siwei_ycNameText = nil

	app.load("client.adventure.utils.AdventureSkillInfoSee")
	app.load("client.adventure.utils.AdventureSkillFitDescriptionSee")	
	app.load("client.adventure.utils.AdventureSiWeiInfoSee")
    -- Initialize adventure mercenary hero handbook state machine.
    local function init_adventure_mercenary_hero_battle_confirm_terminal()
		local adventure_mercenary_hero_battle_list_open_confirm_battle_terminal = {
            _name = "adventure_mercenary_hero_battle_list_open_confirm_battle",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseChoiceHeroBattleCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					
						_ED.formetion_list[self.formationId][self.drawIndex+1] = self.ship.ship_id
						state_machine.excute("adventure_battle_formation_update_draw", 0, nil)
						local drawIndex = tonumber(self.drawIndex)
						fwin:close(fwin:find("AdventureMercenaryHeroBattleConfirmClass"))
					
						if fwin:find("AdventureMercenaryHeroBattleClass") ~= nil then
							fwin:close(fwin:find("AdventureMercenaryHeroBattleClass"))
						end
						if fwin:find("AdventureBattleFormationChangeClass") ~= nil then
							state_machine.excute("adventure_battle_formation_change_update_the_battle", 0, drawIndex)
						end
						state_machine.excute("adventure_mercenary_update_empty", 0, "adventure_mercenary_update_empty.")
					end
				end
            	local str = ""
				str = str..self.drawIndex.."\r\n"	--放入阵型位置 (1 ~ 21)
				str = str..self.ship.ship_id.."\r\n"	--战船ID
				str = str..self.formationId.."\r\n"	--阵型ID
				str = str.."0"
				protocol_command.formation_change.param_list = str

				NetworkManager:register(protocol_command.formation_change.code, nil, nil, nil, nil, responseChoiceHeroBattleCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_mercenary_hero_battle_list_update_skill_info_terminal = {
			_name = "adventure_mercenary_hero_battle_list_update_skill_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if zstring.tonumber(params._datas.cell.drawShowType)==2 then
					local equipData = dms.element(dms["equipment_mould"], params._datas.cell.skill.id)
					self:onUpdateSkillInfo(dms.atoi(equipData, equipment_mould.skill_mould),true)
				else	
					self:onUpdateSkillInfo(params._datas.cell.skill.id,false)
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		-- 灵源选择
		local adventure_mercenary_transform_servants_choice_terminal = {
			_name = "adventure_mercenary_transform_servants_choice",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("adventure_mercenary_transform_update_servants", 0, instance.ship)
				fwin:close(fwin:find("AdventureMercenaryHeroBattleConfirmClass"))
				fwin:close(fwin:find("AdventureMercenaryTransformChoiceClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		--灵主选择
		local adventure_mercenary_transform_themain_choice_terminal = {
			_name = "adventure_mercenary_transform_themain_choice",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("adventure_mercenary_transform_update_themain", 0, instance.ship)
				fwin:close(fwin:find("AdventureMercenaryHeroBattleConfirmClass"))
				fwin:close(fwin:find("AdventureMercenaryTransformChoiceClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		--选择需要签订的英雄
		local adventure_mercenary_agreement_open_terminal = {
			_name = "adventure_mercenary_agreement_open",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("adventure_mercenary_agreement_open_contract", 0, instance.ship)	
            	fwin:close(fwin:find("AdventureMercenaryHeroBattleConfirmClass"))
				fwin:close(fwin:find("AdventureMercenaryAgreementChooseListClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		
		state_machine.add(adventure_mercenary_hero_battle_list_open_confirm_battle_terminal)
		state_machine.add(adventure_mercenary_hero_battle_list_update_skill_info_terminal)
		state_machine.add(adventure_mercenary_transform_servants_choice_terminal)
		state_machine.add(adventure_mercenary_transform_themain_choice_terminal)
		state_machine.add(adventure_mercenary_agreement_open_terminal)
		

        state_machine.init()
    end
    
    -- call func init adventure mercenary hero handbook state machine.
    init_adventure_mercenary_hero_battle_confirm_terminal()
end


function AdventureMercenaryHeroBattleConfirm:init(types, index, drawIndex, ship)
	self.current_type = types
	self.formationId = index
	self.drawIndex = drawIndex
	-- if self.enum_type._TYPE_SHOW_BATTLE_CONFIRM == self.current_type then
	-- 	local AdventureBattleFormationChange = fwin:find("AdventureBattleFormationChangeClass")
	-- 	if AdventureBattleFormationChange~= nil then
	-- 		if AdventureBattleFormationChange.isReplaceHero == false then
	-- 			for j, v in pairs(_ED.formetion_list[self.formationId]) do
	-- 				if zstring.tonumber(v) == 0 then
	-- 					self.drawIndex = j-1
	-- 					break
	-- 				end
	-- 			end
	-- 		end
	-- 		AdventureBattleFormationChange.isReplaceHero = false
	-- 	end
	-- end
	self.ship = ship
    return self
end

function AdventureMercenaryHeroBattleConfirm:onUpdateSkillInfo(mouldid,isbaoju)
	local root = self.roots[1]
	self.skillId  = mouldid
	local Text_52 = ccui.Helper:seekWidgetByName(root, "Text_52")
	Text_52:setString(dms.string(dms["skill_mould"], mouldid, skill_mould.skill_name))
	local Text_52_0 = ccui.Helper:seekWidgetByName(root, "Text_52_0")
	Text_52_0:setString(dms.string(dms["skill_mould"], mouldid, skill_mould.skill_describe))
	if mouldid ~= nil then 
		local mould_data = dms.element(dms["skill_mould"], mouldid)
		self.ArmatureNode_heti_skill:setVisible(false)
		if isbaoju == true then 
		-- 是否是宝具
			if tonumber(self.ship.treasure_strengthen_level) > 0 then 
				csb.animationChangeToAction(self.ArmatureNode_heti_skill, 3, 3, false)
			else 
				csb.animationChangeToAction(self.ArmatureNode_heti_skill, 2, 2, false)
			end
			self.ArmatureNode_heti_skill:setVisible(true)
		end
		if (is_skill_union(mould_data)) then
			--是合体技能
			self.hetiSkillText:setVisible(true)
			self.hetiSkillText:setTouchEnabled(true)
			
			local isfull = is_union_skill_trigger(mouldid)

			if isfull == true then  --- 所有英雄都在 ,播放第二个动画
				csb.animationChangeToAction(self.ArmatureNode_heti_skill, 1, 1, false)
			else 
				-- 有英雄未拥有或是为上阵,播放第一个动画
				csb.animationChangeToAction(self.ArmatureNode_heti_skill, 0, 0, false)
			end
			self.ArmatureNode_heti_skill:setVisible(true)
		else
			self.hetiSkillText:setVisible(false)
			self.hetiSkillText:setTouchEnabled(false)
			
		end
	end
end


function AdventureMercenaryHeroBattleConfirm:onUpdateDraw()
	local root = self.roots[1]
	local isChoice = nil
	local shipData = dms.element(dms["ship_mould"], self.ship.ship_template_id)
	local Text_dj_role = ccui.Helper:seekWidgetByName(root, "Text_dj_role")
	local index = dms.atoi(shipData, ship_mould.ship_type)+1
	Text_dj_role:setString("LV"..self.ship.ship_grade.._ship_types_by_color[index])
	local Text_zhanli_role = ccui.Helper:seekWidgetByName(root, "Text_zhanli_role") 
	Text_zhanli_role:setString(self.ship.hero_fight)
	
	local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	if dms.atoi(shipData, ship_mould.captain_type) == 0 then
		Text_1:setString(_ED.user_info.user_name)
	else
		Text_1:setString(self.ship.captain_name)
	end
	local siweiIndex ,leavel = getSiweiAttribute(self.ship)

	local config = dms.string(dms["pirates_config"], 308, pirates_config.param)
	
	if tonumber(self.ship.ship_breakthrough_level) >= tonumber(config) then 
		self.siwei_ycPanelShow:setColor(cc.c3b(255, 255, 255))
		self.siwei_ycNameText:setColor(cc.c3b(255, 165, 0))
	else
		self.siwei_ycPanelShow:setColor(cc.c3b(150, 150, 150))
		self.siwei_ycNameText:setColor(cc.c3b(150, 150, 150))
		--变灰
	end

	if siweiIndex ~= -1 and dms.atoi(shipData, ship_mould.captain_type) ~= 0 then 
		self.siwei_ycNameText:setString("".. leavel)
		self.siwei_ycNameText:setVisible(true)
		self.siwei_ycPanelShow:setBackGroundImage(string.format("images/ui/icon/icon_shuxin_%d.png", siweiIndex))
		self.siwei_ycPanelShow:setVisible(true)
		self.siwei_ycPanel:setTouchEnabled(true)
	else
		self.siwei_ycNameText:setVisible(false)
		self.siwei_ycPanelShow:setVisible(false)
		self.siwei_ycPanel:setTouchEnabled(false)
	end

	ccui.Helper:seekWidgetByName(root, "Panel_36"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_36_0"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_36_1"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_36_0_0"):removeAllChildren(true)
	
	if dms.atoi(shipData, ship_mould.deadly_skill_mould) ~= -1 then
			local cells = AdventureSkillIconCell:createCell()
			cells:init(2, {id=dms.atoi(shipData, ship_mould.deadly_skill_mould)},0)
			ccui.Helper:seekWidgetByName(root, "Panel_36"):addChild(cells)
			if isChoice == nil then
				isChoice = cells
				self:onUpdateSkillInfo(dms.atoi(shipData, ship_mould.deadly_skill_mould))
			end
		else
			ccui.Helper:seekWidgetByName(root, "Panel_36"):setBackGroundImage("images/ui/bg/icon_skill_empty.png")
		end
		if dms.atoi(shipData, ship_mould.fitSkillOne) ~= -1 then
			local cells = AdventureSkillIconCell:createCell()
			cells:init(2, {id=dms.atoi(shipData, ship_mould.fitSkillOne)},0)
			ccui.Helper:seekWidgetByName(root, "Panel_36_0"):addChild(cells)
			if isChoice == nil then
				isChoice = cells
				self:onUpdateSkillInfo(dms.atoi(shipData, ship_mould.fitSkillOne))
			end
		else
			ccui.Helper:seekWidgetByName(root, "Panel_36_0"):setBackGroundImage("images/ui/bg/icon_skill_empty.png")
		end
		if dms.atoi(shipData, ship_mould.fitSkillTwo) ~= -1 then
			local cells = AdventureSkillIconCell:createCell()
			cells:init(2, {id=dms.atoi(shipData, ship_mould.fitSkillTwo)},0)
			ccui.Helper:seekWidgetByName(root, "Panel_36_1"):addChild(cells)
			if isChoice == nil then
				isChoice = cells
				self:onUpdateSkillInfo(dms.atoi(shipData, ship_mould.fitSkillTwo))
			end
		else
			ccui.Helper:seekWidgetByName(root, "Panel_36_1"):setBackGroundImage("images/ui/bg/icon_skill_empty.png")
		end
		if dms.atoi(shipData, ship_mould.treasureSkill) ~= -1 then
			local cells = AdventureSkillIconCell:createCell()
			cells:init(2, {id=dms.atoi(shipData, ship_mould.treasureSkill)},0,2)
			ccui.Helper:seekWidgetByName(root, "Panel_36_0_0"):addChild(cells)
			if isChoice == nil then
				isChoice = cells
				local equipData = dms.element(dms["equipment_mould"], dms.atoi(shipData, ship_mould.treasureSkill))
				self:onUpdateSkillInfo(dms.atoi(equipData, equipment_mould.skill_mould))
			end
		else
			ccui.Helper:seekWidgetByName(root, "Panel_36_0_0"):setBackGroundImage("images/ui/bg/icon_skill_empty.png")
		end
		if isChoice ~= nil then
			--AdventureSkillIconCell._show_skill_larger = nil
			state_machine.excute("adventure_skill_icon_cell_show_hero_confirm_warehouse_larger", 0, {_datas={cell = isChoice}})
		end
end


function AdventureMercenaryHeroBattleConfirm:onEnterTransitionFinish()
    local csbAdventureMercenaryHeroBattleConfirm = csb.createNode("packs/Mercenary/yongbing_change.csb")
    local root = csbAdventureMercenaryHeroBattleConfirm:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMercenaryHeroBattleConfirm)

	self.hetiSkillText = ccui.Helper:seekWidgetByName(root, "Text_mingdan")
	self.hetiSkillText:setVisible(false)
	self.hetiSKillPanel = ccui.Helper:seekWidgetByName(root, "Panel_skill_heti")	

	local armaturePanle  = ccui.Helper:seekWidgetByName(root, "Panel_2")	
	self.ArmatureNode_heti_skill = armaturePanle:getChildByName("ArmatureNode_stage") -- 技能动画
	draw.initArmature(self.ArmatureNode_heti_skill, nil, -1, 0, 1)
   	csb.animationChangeToAction(self.ArmatureNode_heti_skill, 0, 0, false)

	self.siwei_ycPanel = ccui.Helper:seekWidgetByName(root, "Panel_siwei_1")
    self.siwei_ycNameText = ccui.Helper:seekWidgetByName(root, "Text_role_siwei")
	self.siwei_ycPanelShow = ccui.Helper:seekWidgetByName(root, "Panel_siwei_show_0")
	
	local function formationTouchListener(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			fwin:open(AdventureSkillFitDescriptionSee:new():init(3,{ id = self.skillId}, self.hetiSKillPanel,false), fwin._ui)
		elseif eventType == ccui.TouchEventType.moved then 
		else 
			fwin:close(fwin:find("AdventureSkillFitDescriptionSeeClass"))
		end
	end
	self.hetiSkillText:addTouchEventListener(formationTouchListener)


	local function formationSiweiTouchListener(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			fwin:open(AdventureSiWeiInfoSee:new():init(self.siwei_ycPanel), fwin._dialog)
		elseif eventType == ccui.TouchEventType.moved then 
		else 
			fwin:close(fwin:find("AdventureSiWeiInfoSeeClass"))
		end
	end
	self.siwei_ycPanel:setTouchEnabled(true)
	self.siwei_ycPanel:setVisible(true)
	self.siwei_ycPanel:addTouchEventListener(formationSiweiTouchListener)

	self:onUpdateDraw()
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMercenaryHeroBattleConfirmClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
	if self.enum_type._TYPE_SHOW_BATTLE_CONFIRM == self.current_type then
		-- 确定
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
		{
			terminal_name = "adventure_mercenary_hero_battle_list_open_confirm_battle",      
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	elseif self.enum_type._TYPE_SHOW_TRANSFORM_CHOICE_SERVANTS == self.current_type then
		-- 确定
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
		{
			terminal_name = "adventure_mercenary_transform_servants_choice",      
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	elseif self.enum_type._TYPE_SHOW_TRANSFORM_CHOICE_THEMAIN == self.current_type then
		-- 确定
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
		{
			terminal_name = "adventure_mercenary_transform_themain_choice",      
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	elseif self.enum_type._TYPE_SHOW_AGREEMENT_CONFIRM == self.current_type then 
		-- 确定
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
		{
			terminal_name = "adventure_mercenary_agreement_open",      
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	else
		-- 确定
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure"),       nil, 
		{
			terminal_name = "",      
			terminal_state = 0, 
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end
	
end

function AdventureMercenaryHeroBattleConfirm:onExit()
	state_machine.remove("adventure_mercenary_hero_battle_list_open_confirm_battle")
	state_machine.remove("adventure_mercenary_hero_battle_list_update_skill_info")
	state_machine.remove("adventure_mercenary_transform_servants_choice")
	state_machine.remove("adventure_mercenary_transform_themain_choice")
	state_machine.remove("adventure_mercenary_agreement_open")
end
