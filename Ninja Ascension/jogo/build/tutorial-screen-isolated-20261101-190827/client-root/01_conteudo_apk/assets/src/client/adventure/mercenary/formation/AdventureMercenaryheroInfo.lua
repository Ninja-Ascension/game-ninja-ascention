-- ----------------------------------------------------------------------------------------------------
-- 说明：武将阵容和仓库的上端属性界面
-------------------------------------------------------------------------------------------------------
AdventureMercenaryheroInfo = class("AdventureMercenaryheroInfoClass", Window)
    
function AdventureMercenaryheroInfo:ctor()
    self.super:ctor()
    self.roots = {}
    self.hero = nil
	self.cell = nil
    -- 显示出战阵容中强化后面的数据
    self.textStrong = nil
    self.hetiSkillText = nil
    self.hetiSKillPanel = nil
    self.skillId = 0
    self.ArmatureNode_heti_skill = nil
    self.jineng_Text = nil 
    self.jineng_Text0 = nil
    self.skill_panel1 = nil
    self.skill_panel2 = nil
    self.skill_panel3 = nil
    self.skill_panel4 = nil
    self.skill_panel5 = nil
    self.siwei_ycPanel = nil
    self.siwei_ycPanelShow = nil
    self.siwei_ycNameText = nil

    -- load lua file.

    app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
    app.load("client.adventure.cells.skill.adventure_skill_icon_cell")
    app.load("client.adventure.utils.AdventureSkillInfoSee")
    app.load("client.adventure.utils.AdventureSiWeiInfoSee")

    -- Initialize adventure mercenary package state machine.
    local function init_adventure_mercenary_package_terminal()
        -- 觉醒
        local adventure_mercenary_package_hero_awaken_terminal = {
            _name = "adventure_mercenary_package_hero_awaken",
            _init = function (terminal)
                -- app.load("client.adventure.mercenary.formation.AdventureGeneralAwaken")
                -- app.load("client.adventure.mercenary.formation.AdventureHeroAwaken")
                app.load("client.adventure.mercenary.formation.AdventureHeroAwakenManager")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- local mode = params
                -- if mode == 0 then -- 觉醒
                --     fwin:open(AdventureGeneralAwaken:new():init(), fwin._ui)
                -- else -- 武将觉醒+限界突破
                --     fwin:open(AdventureHeroAwaken:new():init(), fwin._ui)
                -- end
                fwin:open(AdventureHeroAwakenManager:new():init(instance.hero,nil,1), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 强化
        local adventure_mercenary_package_equipment_strengthen_terminal = {
            _name = "adventure_mercenary_package_equipment_strengthen",
            _init = function (terminal)
                app.load("client.adventure.mercenary.formation.AdventureFateStrengthen")
                app.load("client.adventure.mercenary.formation.AdventureStrengthenManager")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local hero = instance.hero
                if tonumber(hero.captain_type) == 0 then -- 主角宿命武器
                    fwin:open(AdventureFateStrengthen:new():init(hero,nil,"adventure_mercenary_package_update_strong_strengthen"), fwin._windows)
                else -- 武具、宝具强化
                    fwin:open(AdventureStrengthenManager:new():init(hero,nil,"adventure_mercenary_package_update_strong_strengthen"), fwin._windows)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新强化显示
        local adventure_mercenary_package_update_strong_strengthen_terminal = {
            _name = "adventure_mercenary_package_update_strong_strengthen",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local hero_info = fwin:find("AdventureMercenaryheroInfoClass")
            	if hero_info ~= nil	then
            		hero_info:onUpdateStrong()
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_mercenary_package_sort_update_attribute_info_terminal = {
			_name = "adventure_mercenary_package_sort_update_attribute_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.hero = params
                if (params.hero) then
                	instance.hero = params.hero
                	instance.cell = params.cell
                end

                instance:onUpdateDrawAttribute()
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		--佣兵签约属性刷新
		local adventure_mercenary_hero_formation_update_agreement_info_terminal = {
			_name = "adventure_mercenary_hero_formation_update_agreement_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				instance:onUpdateAgreementInfo()
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		local adventure_mercenary_package_sort_update_skill_info_terminal = {
			_name = "adventure_mercenary_package_sort_update_skill_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if zstring.tonumber(params._datas.cell.drawShowType)==2 then
					local equipData = dms.element(dms["equipment_mould"], params._datas.cell.skill.id)
					instance:onUpdateSkillInfo(dms.atoi(equipData, equipment_mould.skill_mould),true)
				else	
					instance:onUpdateSkillInfo(params._datas.cell.skill.id,false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		-- 更换武器
		local adventure_mercenary_package_equipment_change_terminal = {
			_name = "adventure_mercenary_package_equipment_change",
            _init = function (terminal)
            	app.load("client.adventure.mercenary.equipment.AdventurEquipmentFateListView")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(AdventurEquipmentFateListView:new():init(instance.hero), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

        state_machine.add(adventure_mercenary_package_hero_awaken_terminal)
        state_machine.add(adventure_mercenary_package_equipment_strengthen_terminal)
        state_machine.add(adventure_mercenary_package_update_strong_strengthen_terminal)
        state_machine.add(adventure_mercenary_package_sort_update_skill_info_terminal)
        state_machine.add(adventure_mercenary_package_sort_update_attribute_info_terminal)
        state_machine.add(adventure_mercenary_package_equipment_change_terminal)
        state_machine.add(adventure_mercenary_hero_formation_update_agreement_info_terminal)
        
        state_machine.init()
    end
    
    -- call func init adventure mercenary package state machine.
    init_adventure_mercenary_package_terminal()
end

function AdventureMercenaryheroInfo:init()
    return self
end


function AdventureMercenaryheroInfo:onUpdateDraw()
	local root = self.roots[1]
end

-- 刷新强化显示数据
function AdventureMercenaryheroInfo:onUpdateStrong()
	local shipData = dms.element(dms['ship_mould'], self.hero.ship_template_id)
	local CurrentAwakenLv,maxAwakenLv = getShipAwakenLv(self.hero.ship_template_id, dms.atoi(shipData, ship_mould.base_mould))
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_jx_cishu"):setString(CurrentAwakenLv.."/"..maxAwakenLv)
	local maxStronglv = get_ship_max_equip_strength_level(self.hero.ship_template_id)
	local stronglv = self.hero.equipment_strengthen_level
	if stronglv == nil then
		stronglv = 0
	end
	self.textStrong:setString(stronglv .. "/" .. maxStronglv)
	
	local Text_zhanli = ccui.Helper:seekWidgetByName(self.roots[1], "Text_yongbing_zhanli") 
	Text_zhanli:setString(self.hero.hero_fight)
	if (self.cell) then
		state_machine.excute("adventure_hero_icon_cell_update_cell", 0, {self.cell, self.hero.hero_fight})
	end	
end

function AdventureMercenaryheroInfo:onUpdateSkillInfo(mouldid,isbaoju)
	local root = self.roots[1]
	self.jineng_Text = ccui.Helper:seekWidgetByName(root, "Text_role_jineng")
	self.jineng_Text0 = ccui.Helper:seekWidgetByName(root, "Text_role_jineng_0")
	self.skillId = mouldid
	ccui.Helper:seekWidgetByName(root, "Panel_qiyue"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_jineng"):setVisible(true)
	
	if mouldid== nil then
		-- 无技能
		self.ArmatureNode_heti_skill:setVisible(false)
		self.jineng_Text :setString(_string_piece_info[381])
		self.jineng_Text0:setString(_string_piece_info[382])
	else
		-- 有技能
		self.jineng_Text:setString(dms.string(dms["skill_mould"], mouldid, skill_mould.skill_name))
		self.jineng_Text0:setString(dms.string(dms["skill_mould"], mouldid, skill_mould.skill_describe))
		local mould_data = dms.element(dms["skill_mould"], mouldid)
		self.ArmatureNode_heti_skill:setVisible(false)
		
		if isbaoju == true then 
		-- 是否是宝具
			if tonumber(self.hero.treasure_strengthen_level) > 0 then 
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

function AdventureMercenaryheroInfo:onUpdateAgreementInfo()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Panel_qiyue"):setVisible(true)
	ccui.Helper:seekWidgetByName(root, "Panel_jineng"):setVisible(false)
	local titleText = ccui.Helper:seekWidgetByName(root, "Text_qiyue")
	titleText:setString(tipStringInfo_hero_agreement_states[1])
	local agreementStates = zstring.tonumber(self.hero.agreementStates)
 	local show_data = {}
	local agreementIndex = -1
	if agreementStates == 1 then 
		agreementIndex=dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.price)
		titleText:setString(tipStringInfo_hero_agreement_states[9])
	elseif agreementStates == 2 then 
		agreementIndex = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.need_honor)
		titleText:setString(tipStringInfo_hero_agreement_states[10])
	else
	end
	if agreementIndex ~= -1 then 
		--有签约状态
		local add_speed =dms.int(dms["contract_mould"], agreementIndex, contract_mould.add_speed)
		local add_denfence =dms.int(dms["contract_mould"], agreementIndex, contract_mould.add_denfence)
		local add_adv =dms.int(dms["contract_mould"], agreementIndex, contract_mould.add_adv)
		local add_authority =dms.int(dms["contract_mould"], agreementIndex, contract_mould.add_authority)
	    if add_speed > 0 then 
        	table.insert(show_data,{add_type = 1,add_value = add_speed})
    	end
	    if add_denfence > 0 then
	        table.insert(show_data,{add_type = 2,add_value = add_denfence})
	    end
	    if add_adv > 0 then 
	        table.insert(show_data,{add_type = 3,add_value = add_adv})
	    end
	    if add_authority > 0 then 
	        table.insert(show_data,{add_type = 4,add_value = add_authority})
	    end
	end

	for i=1,4 do
		local siweiPanel = ccui.Helper:seekWidgetByName(root, "Panel_siwei_"..i) 
		local siweiText = ccui.Helper:seekWidgetByName(root, "Text_qiyuesiwei_"..i) 
		siweiText:setString("")
		
		siweiPanel:setVisible(false)
		siweiPanel:removeAllChildren(true)
		siweiPanel:removeBackGroundImage()
		if agreementIndex ~= 1 then 
			if i <= #show_data then 
				local one_data = show_data[i]
                local shuxing_type = zstring.tonumber(one_data.add_type)
                local yijie_icon = string.format("images/ui/icon/icon_shuxin_%d.png", shuxing_type)
                siweiPanel:setBackGroundImage(yijie_icon)
                siweiPanel:setVisible(true)
                siweiText:setString("+" .. one_data.add_value)
			end
		end
	end
end

function AdventureMercenaryheroInfo:onUpdateDrawAttribute()
	local root = self.roots[1]
	local isChoice = nil
	local hero_lv = self.hero.ship_grade
	if (hero_lv == nil) then
		hero_lv = 1
	end
	if self.hero == nil then
		return
	end
	local Text_role_dj = ccui.Helper:seekWidgetByName(root, "Text_role_dj")
	Text_role_dj:setString("LV"..hero_lv)
	local Text_role_pz = ccui.Helper:seekWidgetByName(root, "Text_role_pz") 
	local shipData = dms.element(dms["ship_mould"], self.hero.ship_template_id)
	
	if shipData == nil then
		return
	end

	local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
	Panel_role:removeAllChildren(true)
	
	local cell = AdventureHeroIconCell:createCell()
	cell:init(11, {ship_template_id = self.hero.ship_template_id}, 1, 0, nil, nil, nil, nil, 0)
	Panel_role:addChild(cell)

	local index = dms.atoi(shipData, ship_mould.ship_type)+1
	Text_role_pz:setString(_ship_types_by_color[index])
	local Text_zhanli = ccui.Helper:seekWidgetByName(root, "Text_yongbing_zhanli") 
	Text_zhanli:setString(self.hero.hero_fight)

	
	self.jineng_Text:setString("")
	self.jineng_Text0:setString("")

	self.skill_panel1:removeAllChildren(true)
	self.skill_panel2:removeAllChildren(true)
	self.skill_panel3:removeAllChildren(true)
	self.skill_panel4:removeAllChildren(true)
	self.skill_panel5:removeAllChildren(true)

	local siweiIndex ,leavel = getSiweiAttribute(self.hero)
	local config = dms.string(dms["pirates_config"], 308, pirates_config.param)
	
	if tonumber(self.hero.ship_breakthrough_level) >= tonumber(config) then 

		self.siwei_ycPanelShow:setColor(cc.c3b(255, 255, 255))
		self.siwei_ycNameText:setColor(cc.c3b(255, 165, 0))
	else
		self.siwei_ycNameText:setColor(cc.c3b(150, 150, 150))
		self.siwei_ycPanelShow:setColor(cc.c3b(150, 150, 150))
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

	local Text_rolename = ccui.Helper:seekWidgetByName(root, "Text_rolename")
	if dms.atoi(shipData, ship_mould.captain_type) == 0 then
		Text_rolename:setString(_ED.user_info.user_name)
		ccui.Helper:seekWidgetByName(root, "Panel_skill"):setVisible(false)
		if zstring.tonumber(_ED.user_ship[self.hero.ship_id].equipment[1].user_equiment_id) == 0 then
			ccui.Helper:seekWidgetByName(root, "Panel_zhujue"):setVisible(false)
			self:onUpdateSkillInfo(nil)
		else
			ccui.Helper:seekWidgetByName(root, "Panel_zhujue"):setVisible(true)
			local equipInfo = dms.element(dms["equipment_mould"], zstring.tonumber(_ED.user_ship[self.hero.ship_id].equipment[1].user_equiment_template))
			local cells = AdventureSkillIconCell:createCell()
			cells:init(0, {id=zstring.tonumber(_ED.user_ship[self.hero.ship_id].equipment[1].user_equiment_template)},0,2)
			ccui.Helper:seekWidgetByName(root, "Panel_prop"):removeAllChildren(true)
			ccui.Helper:seekWidgetByName(root, "Panel_prop"):addChild(cells)
			ccui.Helper:seekWidgetByName(root, "Text_name"):setString(dms.atos(equipInfo, equipment_mould.equipment_name))
			self:onUpdateSkillInfo(dms.atoi(equipInfo, equipment_mould.skill_mould),false)
		end
		
	else
		Text_rolename:setString(self.hero.captain_name)
		ccui.Helper:seekWidgetByName(root, "Panel_zhujue"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_skill"):setVisible(true)
		
		if dms.atoi(shipData, ship_mould.deadly_skill_mould) ~= -1 then
			local cells = AdventureSkillIconCell:createCell()
			cells:init(1, {id=dms.atoi(shipData, ship_mould.deadly_skill_mould)},0)
			self.skill_panel1:addChild(cells)
			ccui.Helper:seekWidgetByName(root, "Image_skill_1"):setVisible(false)
			if isChoice == nil then
				isChoice = cells
				self:onUpdateSkillInfo(dms.atoi(shipData, ship_mould.deadly_skill_mould),false)
			end
		else
			ccui.Helper:seekWidgetByName(root, "Image_skill_1"):setVisible(true)
		end
		if dms.atoi(shipData, ship_mould.fitSkillOne) ~= -1 then
			local cells = AdventureSkillIconCell:createCell()
			cells:init(1, {id=dms.atoi(shipData, ship_mould.fitSkillOne)},0)
			self.skill_panel2:addChild(cells)
			ccui.Helper:seekWidgetByName(root, "Image_skill_2"):setVisible(false)
			if isChoice == nil then
				isChoice = cells
				self:onUpdateSkillInfo(dms.atoi(shipData, ship_mould.fitSkillOne),false)
			end
			
		else
			ccui.Helper:seekWidgetByName(root, "Image_skill_2"):setVisible(true)
		end
		if dms.atoi(shipData, ship_mould.fitSkillTwo) ~= -1 then
			local cells = AdventureSkillIconCell:createCell()
			cells:init(1, {id=dms.atoi(shipData, ship_mould.fitSkillTwo)},0)
			self.skill_panel3:addChild(cells)
			ccui.Helper:seekWidgetByName(root, "Image_skill_3"):setVisible(false)
			if isChoice == nil then
				isChoice = cells
				self:onUpdateSkillInfo(dms.atoi(shipData, ship_mould.fitSkillTwo),false)
			end
		else
			ccui.Helper:seekWidgetByName(root, "Image_skill_3"):setVisible(true)
		end
		if dms.atoi(shipData, ship_mould.treasureSkill) ~= -1 then
			local cells = AdventureSkillIconCell:createCell()
			cells:init(1, {id=dms.atoi(shipData, ship_mould.treasureSkill)},0,2)
			self.skill_panel4:addChild(cells)
			ccui.Helper:seekWidgetByName(root, "Image_skill_4"):setVisible(false)
			if isChoice == nil then
				isChoice = cells
				local equipData = dms.element(dms["equipment_mould"], dms.atoi(shipData, ship_mould.treasureSkill))
				self:onUpdateSkillInfo(dms.atoi(equipData, equipment_mould.skill_mould),true)
			end
		else
			ccui.Helper:seekWidgetByName(root, "Image_skill_4"):setVisible(true)
		end
		--契约
		
		local cellAgreement = AdventureSkillIconCell:createCell()
		cellAgreement:init(4, {mould_data = self.hero.agreementStates},0,2)
		self.skill_panel5:addChild(cellAgreement)
		ccui.Helper:seekWidgetByName(root, "Image_skill_5"):setVisible(false)
			
		if isChoice ~= nil then
			AdventureSkillIconCell._show_skill_larger = nil
			state_machine.excute("adventure_skill_icon_cell_show_hero_warehouse_larger", 0, {_datas={cell = isChoice}})
		end
	end
	local CurrentAwakenLv,maxAwakenLv = getShipAwakenLv2(self.hero.ship_template_id,dms.atoi(shipData, ship_mould.base_mould))
	ccui.Helper:seekWidgetByName(root, "Text_jx_cishu"):setString(CurrentAwakenLv.."/"..maxAwakenLv)
	local maxStronglv = get_ship_max_equip_strength_level(self.hero.ship_template_id)
	local stronglv = self.hero.equipment_strengthen_level
	if stronglv == nil then
		stronglv = 0
	end
	self.textStrong:setString(stronglv .. "/" .. maxStronglv)
end

function AdventureMercenaryheroInfo:onEnterTransitionFinish()
    local csbAdventureMercenaryPackage = csb.createNode("packs/Mercenary/yongbing_shuxing.csb")
    local root = csbAdventureMercenaryPackage:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMercenaryPackage)
    -- 显示强化标签数据
    self.textStrong = ccui.Helper:seekWidgetByName(root, "Text_qh_cishu")
	self.hetiSkillText = ccui.Helper:seekWidgetByName(root, "Text_mingdan")				
	self.hetiSkillText:setVisible(false)
	self.hetiSKillPanel = ccui.Helper:seekWidgetByName(root, "Panel_skill_heti")	
	local armaturePanle  = ccui.Helper:seekWidgetByName(root, "Panel_jineng")	
	

	self.jineng_Text = ccui.Helper:seekWidgetByName(root, "Text_role_jineng")
	self.jineng_Text0 = ccui.Helper:seekWidgetByName(root, "Text_role_jineng_0")

	self.skill_panel1 = ccui.Helper:seekWidgetByName(root, "Panel_skill_1")
	self.skill_panel2 = ccui.Helper:seekWidgetByName(root, "Panel_skill_2")
	self.skill_panel3 = ccui.Helper:seekWidgetByName(root, "Panel_skill_3")
	self.skill_panel4 = ccui.Helper:seekWidgetByName(root, "Panel_skill_4")
	self.skill_panel5 = ccui.Helper:seekWidgetByName(root, "Panel_skill_5")
	self.siwei_ycPanel = ccui.Helper:seekWidgetByName(root, "Panel_siwei_show_1")
    self.siwei_ycNameText = ccui.Helper:seekWidgetByName(root, "Text_role_siwei")
	self.siwei_ycPanelShow = ccui.Helper:seekWidgetByName(root, "Panel_siwei_show_0")
	self.ArmatureNode_heti_skill = armaturePanle:getChildByName("ArmatureNode_stage") -- 技能动画
	draw.initArmature(self.ArmatureNode_heti_skill, nil, -1, 0, 1)
   	csb.animationChangeToAction(self.ArmatureNode_heti_skill, 0, 0, false)

	local function formationTouchListener(sender, eventType)
		if eventType == ccui.TouchEventType.began then

			fwin:open(AdventureSkillInfoSee:new():init(3,{ id = self.skillId}, self.hetiSKillPanel), fwin._ui)
		elseif eventType == ccui.TouchEventType.moved then 
		else 
			fwin:close(fwin:find("AdventureSkillInfoSeeClass"))
		end
	end

	self.hetiSkillText:addTouchEventListener(formationTouchListener)

	local function formationSiweiTouchListener(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			fwin:open(AdventureSiWeiInfoSee:new():init(self.siwei_ycPanel,2), fwin._dialog)
		elseif eventType == ccui.TouchEventType.moved then 
		else 
			fwin:close(fwin:find("AdventureSiWeiInfoSeeClass"))
		end
	end
	self.siwei_ycPanel:setTouchEnabled(true)
	self.siwei_ycPanel:setVisible(true)
	self.siwei_ycPanel:addTouchEventListener(formationSiweiTouchListener)

    -- 觉醒
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_juexing"),       nil, 
    {
        terminal_name = "adventure_mercenary_package_hero_awaken",   
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qianghua"),       nil, 
    {
        terminal_name = "adventure_mercenary_package_equipment_strengthen",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
	-- 进入武器列表
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change"),       nil, 
    {
        terminal_name = "adventure_mercenary_package_equipment_change",      
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
end

function AdventureMercenaryheroInfo:onExit()
    state_machine.remove("adventure_mercenary_package_hero_awaken")
    state_machine.remove("adventure_mercenary_package_equipment_strengthen")
    state_machine.remove("adventure_mercenary_package_update_strong_strengthen")
    state_machine.remove("adventure_mercenary_package_sort_update_attribute_info")
    state_machine.remove("adventure_mercenary_package_sort_update_skill_info")
    state_machine.remove("adventure_mercenary_package_equipment_change")
    state_machine.remove("adventure_mercenary_hero_formation_update_agreement_info")
    
end
