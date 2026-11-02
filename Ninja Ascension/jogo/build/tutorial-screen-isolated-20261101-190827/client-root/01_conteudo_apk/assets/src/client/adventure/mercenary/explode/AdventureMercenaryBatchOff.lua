-- ----------------------------------------------------------------------------------------------------
-- 说明：武将解雇
-------------------------------------------------------------------------------------------------------
AdventureMercenaryBatchOff = class("AdventureMercenaryBatchOffClass", Window)
local Chane_label_index_BatchOff = 0
local Change_index_batchOff = 0
function AdventureMercenaryBatchOff:ctor()
    self.super:ctor()
    self.roots = {}
	self.showType = 0
	self.heros = nil
	self.heroList = {}
	self.selected = {}
	self.fireNumber = 0
	self.chane_label = nil
	self.currentScrollView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    self.hetiSkillText = nil
	self.ArmatureNode_heti_skill = nil
	self.hetiSKillPanel = nil
	self.skillId = 0
 	self.siwei_ycPanel = nil
    self.siwei_ycPanelShow = nil
    self.siwei_ycNameText = nil
    self.quality_datas = nil
    self.arrStarLevelHeroesWhite = {}--白
	self.arrStarLevelHeroesGreen = {}--绿
	self.arrStarLevelHeroesKohlrabiblue= {}--蓝
	self.arrStarLevelHeroesPurple = {}--紫
	self.arrStarLevelHeroesOrange = {}--橙
	self.arrStarLevelHeroesRed = {}--红
	self.arrStarLevelHeroesPink = {}--粉
    -- Initialize adventure mercenary hero explode state machine.
	app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
	app.load("client.adventure.cells.hero.adventure_hero_selected_cell")
	app.load("client.adventure.cells.skill.adventure_skill_icon_cell")
	
	app.load("client.adventure.utils.AdventureSkillInfoSee")
	app.load("client.adventure.utils.AdventureSkillFitDescriptionSee")
	app.load("client.adventure.utils.AdventureSiWeiInfoSee")
    local function init_adventure_mercenary_hero_explode_terminal()
        -- 去解雇结算
        local adventure_mercenary_hero_explode_settlement_terminal = {
            _name = "adventure_mercenary_hero_explode_settlement",
            _init = function (terminal)
                app.load("client.adventure.mercenary.explode.AdventureMercenaryBatchOffSettlement")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureMercenaryBatchOffSettlement:new():init(self.selected), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         -- 解雇排序的状态机
		local adventure_mercenary_package_sort_update_Batch_terminal = {
			_name = "adventure_mercenary_package_sort_update_Batch",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.choiceIndex = 1
				Chane_label_index_BatchOff = zstring.tonumber(params._datas._showType)
				self:onUpdateDrawBatchOff()
				--state_machine.excute("adventure_mercenary_package_sort_update_attribute_info", 0, self.heroList[self.choiceIndex])
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

        --按照品质选择武将
		local adventure_mercenary_package_sort_off_update_terminal = {
			_name = "adventure_mercenary_package_sort_off_update",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
				self:onUpdateDrawBatchOffByQuality(params)
				instance:updateReturn()
				--state_machine.excute("adventure_mercenary_package_sort_update_attribute_info", 0, self.heroList[self.choiceIndex])
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}


        -- 排序
        local adventure_mercenary_hero_explode_hero_sort_terminal = {
            _name = "adventure_mercenary_hero_explode_hero_sort",
            _init = function (terminal)
                app.load("client.adventure.mercenary.package.AdventureMercenaryPackageOffSort")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	fwin:open(AdventureMercenaryPackageOffSort:new():init(Chane_label_index_BatchOff,2), fwin._ui)
            	
            --    fwin:open(AdventureMercenaryPackageSort:new():init(Chane_label_index_BatchOff,2), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--点击选中的英雄解雇
		local adventure_mercenary_hero_fire_info_update_terminal = {
            _name = "adventure_mercenary_hero_fire_info_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.heros = params._datas.cell.hero
				local isSelected = params._datas.cell.is_select_off 
				if isSelected == false then 
					--没有选中的需要立即选中
					params._datas.cell.is_select_off = true
					self.selected[""..self.heros.ship_id] = self.heros
					params._datas.cell:updateDrawSelectOffSign()
				else
					self.selected[""..self.heros.ship_id] = nil
					params._datas.cell.is_select_off = false
					params._datas.cell:updateDrawSelectOffSign()
				end
				-- local isSelected = false
				-- for j, v in pairs(self.selected) do
				-- 	if zstring.tonumber(v.ship_id) == zstring.tonumber(self.heros.ship_id) then
				-- 		self.fireNumber = self.fireNumber - 1
				-- 		table.remove(self.selected, j)
				-- 		params._datas.cell:removeChildByTag(99,true)
				-- 		isSelected = true
				-- 		break
				-- 	end
				-- end
				-- if isSelected == false then
				-- 	--if self.fireNumber < 10 then
				-- 		self.fireNumber = self.fireNumber + 1
				-- 		table.insert(self.selected, self.heros)
				-- 		local cells = AdventureHeroSelectedCell:createCell()
				-- 		cells:init(0, self.fireNumber)
				-- 		cells:setTag(99)
				-- 		params._datas.cell:addChild(cells)
				-- 		-- ccui.Helper:seekWidgetByName(instance.roots[1], "ScrollView_role"):getInnerContainer():getChildByTag(1):addChild(cells)
				-- 	--end
				-- end
				-- local items = self.currentScrollView:getChildren()
				-- local xxxxx = 0
				--  for i, w in pairs(self.selected) do
				-- 	 for j, z in pairs(items) do
				-- 		if zstring.tonumber(w.ship_id) == zstring.tonumber(z.hero.ship_id) then
				-- 			xxxxx = xxxxx + 1
				-- 			local indexs = z:getChildByTag(99).index
				-- 			if indexs ~=  xxxxx then
				-- 				indexs = xxxxx
				-- 			end
				-- 			z:removeChildByTag(99,true)
				-- 			local cells = AdventureHeroSelectedCell:createCell()
				-- 			cells:init(0, indexs)
				-- 			cells:setTag(99)
				-- 			z:addChild(cells)
				-- 		end
				-- 	 end
				--  end
				self:onUpdateDrawHeroInfo()
				self:updateReturn()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_mercenary_hero_fire_update_skill_info_terminal = {
			_name = "adventure_mercenary_hero_fire_update_skill_info",
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
		
		local adventure_mercenary_hero_fire_update_draw_terminal = {
			_name = "adventure_mercenary_hero_fire_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	self.hero = nil
				self:onUpdateDrawBatchOff()
				self:updateReturn()
				self:onUpdateSkillInfo(nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
	

        state_machine.add(adventure_mercenary_hero_explode_settlement_terminal)
        state_machine.add(adventure_mercenary_hero_explode_hero_sort_terminal)
        state_machine.add(adventure_mercenary_hero_fire_info_update_terminal)
        state_machine.add(adventure_mercenary_hero_fire_update_skill_info_terminal)
        state_machine.add(adventure_mercenary_hero_fire_update_draw_terminal)
        state_machine.add(adventure_mercenary_package_sort_update_Batch_terminal)
        state_machine.add(adventure_mercenary_package_sort_off_update_terminal)
        
        state_machine.init()
    end
    
    -- call func init adventure mercenary hero explode state machine.
    init_adventure_mercenary_hero_explode_terminal()
end

function AdventureMercenaryBatchOff:init()
    return self
end

function AdventureMercenaryBatchOff:updateReturn()
	local root = self.roots[1]
	local Text_huishou = ccui.Helper:seekWidgetByName(root, "Text_huishou")
	local number = 0
	local ship_count = 0
	for i, ship in pairs(self.selected) do
		if ship ~= nil then 
			local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
			number = number + dms.atoi(shipData, ship_mould.refine_get_soul)
			ship_count  = ship_count + 1
		end
		
	end
	if ship_count <= 0 then
		Text_huishou:setString("0")
	else
		Text_huishou:setString(number)
	end
end

function AdventureMercenaryBatchOff:getSortedHeroes(indexs)
	local function fightingCapacity(a,b)
		local al = tonumber(a.hero_fight)
		local bl = tonumber(b.hero_fight)
		local result = false
		if al > bl then
			result = true
		end
		return result 
	end
	
	local function lvCapacity(a,b)
		local al = tonumber(a.ship_grade)
		local bl = tonumber(b.ship_grade)
		local result = false
		if al > bl then
			result = true
		end
		return result 
	end
	
	local function awakenCapacity(a,b)
		local shipData1 = dms.element(dms["ship_mould"], a.ship_template_id)
		local shipData2 = dms.element(dms["ship_mould"], b.ship_template_id)
		local al = dms.atoi(shipData1, ship_mould.initial_rank_level)
		local bl = dms.atoi(shipData2, ship_mould.initial_rank_level)
		local result = false
		if al > bl then
			result = true
		end
		return result 
	end

	local tSortedHeroes = {}
	-- 各星级武将数组
	self.arrStarLevelHeroesWhite = {}--白
	self.arrStarLevelHeroesGreen = {}--绿
	self.arrStarLevelHeroesKohlrabiblue= {}--蓝
	self.arrStarLevelHeroesPurple = {}--紫
	self.arrStarLevelHeroesOrange = {}--橙
	self.arrStarLevelHeroesRed = {}--红
	self.arrStarLevelHeroesPink = {}--粉
	for i, ship in pairs(_ED.user_ship) do
		if ship.ship_id ~= nil then
			local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
			if dms.atoi(shipData, ship_mould.captain_type) ~= 0 then
				if zstring.tonumber(ship.formation_index) <= 0 then
					if dms.atoi(shipData, ship_mould.ship_type) == 0 then
						table.insert(self.arrStarLevelHeroesWhite, ship)
					elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
						table.insert(self.arrStarLevelHeroesGreen, ship)
					elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
						table.insert(self.arrStarLevelHeroesKohlrabiblue, ship)
					elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
						table.insert(self.arrStarLevelHeroesPurple, ship)
					elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
						table.insert(self.arrStarLevelHeroesOrange, ship)
					elseif dms.atoi(shipData, ship_mould.ship_type) == 5 then
						table.insert(self.arrStarLevelHeroesRed, ship)
					elseif dms.atoi(shipData, ship_mould.ship_type) == 6 then
						table.insert(self.arrStarLevelHeroesPink, ship)
					end 
				end 
			end 
		end
	end
	-- table.sort(arrStarLevelHeroesWhite, fightingCapacity)
	for i=1, #self.arrStarLevelHeroesPink do
		table.insert(tSortedHeroes, self.arrStarLevelHeroesPink[i])
	end
	for i=1, #self.arrStarLevelHeroesRed do
		table.insert(tSortedHeroes, self.arrStarLevelHeroesRed[i])
	end
	for i=1, #self.arrStarLevelHeroesOrange do
		table.insert(tSortedHeroes, self.arrStarLevelHeroesOrange[i])
	end
	for i=1, #self.arrStarLevelHeroesPurple do
		table.insert(tSortedHeroes, self.arrStarLevelHeroesPurple[i])
	end
	for i=1, #self.arrStarLevelHeroesKohlrabiblue do
		table.insert(tSortedHeroes, self.arrStarLevelHeroesKohlrabiblue[i])
	end
	for i=1, #self.arrStarLevelHeroesGreen do
		table.insert(tSortedHeroes, self.arrStarLevelHeroesGreen[i])
	end
	for i=1, #self.arrStarLevelHeroesWhite do
		table.insert(tSortedHeroes, self.arrStarLevelHeroesWhite[i])
	end
	
	if indexs == 1 then  -- 觉醒等级排序
		table.sort(tSortedHeroes, awakenCapacity)
	elseif indexs == 2 then	-- 战力等级排序
		table.sort(tSortedHeroes, fightingCapacity)
	elseif indexs == 3 then	-- 等级排序
		table.sort(tSortedHeroes, lvCapacity)
	end
	self.heroList = tSortedHeroes
	return tSortedHeroes
end

function AdventureMercenaryBatchOff:onUpdate(dt)
	if self.currentScrollView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentScrollView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentScrollView:getChildren()
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
				-- if v:getChildByTag(99) ~= nil then
				-- 	local indexs = v:getChildByTag(99).index
				-- 	v:removeChildByTag(99,true)
				-- 	local cells = AdventureHeroSelectedCell:createCell()
				-- 	cells:init(0, indexs)
				-- 	cells:setTag(99)
				-- 	v:addChild(cells)
				-- end
            end
        end
    end
end

function AdventureMercenaryBatchOff:onUpdateSkillInfo(mouldid,isbaoju)
	local root = self.roots[1]
	self.skillId = mouldid 
	local Text_wujineng = ccui.Helper:seekWidgetByName(root, "Text_wujineng")
	local Text_wujineng_0 = ccui.Helper:seekWidgetByName(root, "Text_wujineng_0")
	if mouldid== nil then
		Text_wujineng:setString(_string_piece_info[381])
		Text_wujineng_0:setString(_string_piece_info[382])
		ccui.Helper:seekWidgetByName(root, "Panel_skill_1"):removeAllChildren(true)
		ccui.Helper:seekWidgetByName(root, "Panel_skill_2"):removeAllChildren(true)
		ccui.Helper:seekWidgetByName(root, "Panel_skill_3"):removeAllChildren(true)
		ccui.Helper:seekWidgetByName(root, "Panel_skill_4"):removeAllChildren(true)
		ccui.Helper:seekWidgetByName(root, "Text_wubing"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_rolename"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_zhanli_jiegu"):setString("")
		ccui.Helper:seekWidgetByName(root, "Text_role_dj"):setString("")
		self.siwei_ycPanelShow:setVisible(false)
		self.siwei_ycNameText:setVisible(false)
	else
		Text_wujineng:setString(dms.string(dms["skill_mould"], mouldid, skill_mould.skill_name))
		Text_wujineng_0:setString(dms.string(dms["skill_mould"], mouldid, skill_mould.skill_describe))
		local mould_data = dms.element(dms["skill_mould"], mouldid)
		self.ArmatureNode_heti_skill:setVisible(false)
		if isbaoju == true then 
		-- 是否是宝具
			if tonumber(self.heros.treasure_strengthen_level) > 0 then 
				csb.animationChangeToAction(self.ArmatureNode_heti_skill, 3, 3, false)
			else 
				csb.animationChangeToAction(self.ArmatureNode_heti_skill, 2, 2, false)
			end
			self.ArmatureNode_heti_skill:setVisible(true)
		end
		if (is_skill_union(mould_data)) then
			--是合体技能
			self.hetiSkillText:setVisible(true)
			
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
		end
	end
end

function AdventureMercenaryBatchOff:onUpdateDrawHeroInfo()
	local root = self.roots[1]
	isChoice = nil
	local shipData = dms.element(dms["ship_mould"], self.heros.ship_template_id)
	ccui.Helper:seekWidgetByName(root, "Text_wubing"):setVisible(false)
	local Text_rolename = ccui.Helper:seekWidgetByName(root, "Text_rolename")
	Text_rolename:setVisible(true)
	Text_rolename:setString(self.heros.captain_name)
	local Text_role_dj = ccui.Helper:seekWidgetByName(root, "Text_role_dj")
	Text_role_dj:setString("lv"..self.heros.ship_grade)
	local Text_zhanli = ccui.Helper:seekWidgetByName(root, "Text_zhanli_jiegu")
	Text_zhanli:setString(self.heros.hero_fight)
	local siweiIndex ,leavel = getSiweiAttribute(self.heros)
	local config = dms.string(dms["pirates_config"], 308, pirates_config.param)
	if tonumber(self.heros.ship_breakthrough_level) >= tonumber(config) then 
		self.siwei_ycPanelShow:setColor(cc.c3b(255, 255, 255))
		self.siwei_ycNameText:setColor(cc.c3b(255, 165, 0))
	else
		self.siwei_ycPanelShow:setColor(cc.c3b(150, 150, 150))
		self.siwei_ycNameText:setColor(cc.c3b(150, 150, 150))
		--变灰
	end
	if siweiIndex ~= -1 then 
		self.siwei_ycNameText:setString("".. leavel)
		self.siwei_ycNameText:setVisible(true)
		self.siwei_ycPanelShow:setBackGroundImage(string.format("images/ui/icon/icon_shuxin_%d.png", siweiIndex))
		self.siwei_ycPanelShow:setVisible(true)
	else
		self.siwei_ycNameText:setVisible(false)
		self.siwei_ycPanelShow:setVisible(false)
	end
	ccui.Helper:seekWidgetByName(root, "Panel_skill_1"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_skill_2"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_skill_3"):removeAllChildren(true)
	ccui.Helper:seekWidgetByName(root, "Panel_skill_4"):removeAllChildren(true)
	if dms.atoi(shipData, ship_mould.deadly_skill_mould) ~= -1 then
		local cells = AdventureSkillIconCell:createCell()
		cells:init(3, {id=dms.atoi(shipData, ship_mould.deadly_skill_mould)},0)
		ccui.Helper:seekWidgetByName(root, "Panel_skill_1"):addChild(cells)
		if isChoice == nil then
			isChoice = cells
			self:onUpdateSkillInfo(dms.atoi(shipData, ship_mould.deadly_skill_mould),false)
		end
	else
		ccui.Helper:seekWidgetByName(root, "Panel_skill_1"):setBackGroundImage("images/ui/bg/icon_skill_empty.png")
	end
	if dms.atoi(shipData, ship_mould.fitSkillOne) ~= -1 then
		local cells = AdventureSkillIconCell:createCell()
		cells:init(3, {id=dms.atoi(shipData, ship_mould.fitSkillOne)},0)
		ccui.Helper:seekWidgetByName(root, "Panel_skill_2"):addChild(cells)
		if isChoice == nil then
			isChoice = cells
			self:onUpdateSkillInfo(dms.atoi(shipData, ship_mould.fitSkillOne),false)
		end
	else
		ccui.Helper:seekWidgetByName(root, "Panel_skill_2"):setBackGroundImage("images/ui/bg/icon_skill_empty.png")
	end
	if dms.atoi(shipData, ship_mould.fitSkillTwo) ~= -1 then
		local cells = AdventureSkillIconCell:createCell()
		cells:init(3, {id=dms.atoi(shipData, ship_mould.fitSkillTwo)},0)
		ccui.Helper:seekWidgetByName(root, "Panel_skill_3"):addChild(cells)
		if isChoice == nil then
			isChoice = cells
			self:onUpdateSkillInfo(dms.atoi(shipData, ship_mould.fitSkillTwo),false)
		end
	else
		ccui.Helper:seekWidgetByName(root, "Panel_skill_3"):setBackGroundImage("images/ui/bg/icon_skill_empty.png")
	end
	if dms.atoi(shipData, ship_mould.treasureSkill) ~= -1 then
		local cells = AdventureSkillIconCell:createCell()
		cells:init(3, {id=dms.atoi(shipData, ship_mould.treasureSkill)},0,2)
		ccui.Helper:seekWidgetByName(root, "Panel_skill_4"):addChild(cells)
		if isChoice == nil then
			isChoice = cells
			local equipData = dms.element(dms["equipment_mould"], dms.atoi(shipData, ship_mould.treasureSkill))
			self:onUpdateSkillInfo(dms.atoi(equipData, equipment_mould.skill_mould),false)
		end
	else
		ccui.Helper:seekWidgetByName(root, "Panel_skill_4"):setBackGroundImage("images/ui/bg/icon_skill_empty.png")
	end
	if isChoice ~= nil then
		AdventureSkillIconCell._show_skill_larger = nil
		state_machine.excute("adventure_skill_icon_cell_show_hero_warehouse_larger", 0, {_datas={cell = isChoice}})
	end
end

function AdventureMercenaryBatchOff:onUpdateDrawBatchOffByQuality(changeIndex)
	local root = self.roots[1]
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_role")
	local panel = m_ScrollView:getInnerContainer()
	for i,v in pairs(self.selected) do
		if v ~= nil then 
			local childCell = panel:getChildByName("off_" .. v.ship_id)
			if childCell ~= nil then 
				childCell.is_select_off = false
				childCell:updateDrawSelectOffSign()
			end
		end
	end
	self.selected = {}
	if changeIndex == 6 then 
		--重置
		self:updateReturn()
		return
	end
	-- 白将
	
	if changeIndex >= 0 then 
		for i,v in pairs(self.arrStarLevelHeroesWhite) do
			--没有升级过 没有签约 没有强化,没有觉醒
			if zstring.tonumber(v.ship_grade) == 1 and 
				zstring.tonumber(v.agreementStates) == 0 and 
				zstring.tonumber(v.ship_breakthrough_level) == 0 and 
				zstring.tonumber(v.equipment_strengthen_level) == 0
				then
				self.selected[""..v.ship_id] = v
			end
		end
	end
	if changeIndex >= 1 then 
		for i,v in pairs(self.arrStarLevelHeroesGreen) do
			--没有升级过 没有签约 没有强化,没有觉醒
			if zstring.tonumber(v.ship_grade) == 1 and 
				zstring.tonumber(v.agreementStates) == 0 and 
				zstring.tonumber(v.ship_breakthrough_level) == 0 and 
				zstring.tonumber(v.equipment_strengthen_level) == 0 
				then
				self.selected[""..v.ship_id] = v
			end
		end
	end

	if changeIndex >= 2 then 
		for i,v in pairs(self.arrStarLevelHeroesKohlrabiblue) do
			--没有升级过 没有签约 没有强化,没有觉醒
			if zstring.tonumber(v.ship_grade) == 1 and 
				zstring.tonumber(v.agreementStates) == 0 and 
				zstring.tonumber(v.ship_breakthrough_level) == 0 and 
				zstring.tonumber(v.equipment_strengthen_level) == 0 
				then
				self.selected[""..v.ship_id] = v
			end
		end
	end
	if changeIndex >= 3 then 
		for i,v in pairs(self.arrStarLevelHeroesPurple) do
			--没有升级过 没有签约 没有强化,没有觉醒
			if zstring.tonumber(v.ship_grade) == 1 and 
				zstring.tonumber(v.agreementStates) == 0 and 
				zstring.tonumber(v.ship_breakthrough_level) == 0 and 
				zstring.tonumber(v.equipment_strengthen_level) == 0 
				then
				self.selected[""..v.ship_id] = v
			end
		end
	end
	if changeIndex >= 4 then 
		for i,v in pairs(self.arrStarLevelHeroesOrange) do
			--没有升级过 没有签约 没有强化,没有觉醒
			if zstring.tonumber(v.ship_grade) == 1 and 
				zstring.tonumber(v.agreementStates) == 0 and 
				zstring.tonumber(v.ship_breakthrough_level) == 0 and 
				zstring.tonumber(v.equipment_strengthen_level) == 0 
				then
				self.selected[""..v.ship_id] = v
			end
		end
	end
	
	for i,v in pairs(self.selected) do
		if v ~= nil then 
			local childCell = panel:getChildByName("off_" .. v.ship_id)
			if childCell ~= nil then 
				childCell.is_select_off = true
				childCell:updateDrawSelectOffSign()
			end
		end
	end
end

function AdventureMercenaryBatchOff:onUpdateDraw(index)
	local root = self.roots[1]
	self.selected = {}
	self.fireNumber = 0
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_role")
	m_ScrollView:removeAllChildren(true)
	local panel = m_ScrollView:getInnerContainer()
	panel:setContentSize(m_ScrollView:getContentSize())
	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)
	local sSize = panel:getContentSize()
	local sHeight = sSize.height
	local sWidth = sSize.width
	local controlSize = m_ScrollView:getInnerContainerSize()
	local nextY = sSize.height
	local nextX = sSize.width
	local tHeight = 0
	local cellHeight = 0
	local tWidth = 0
	local wPosition = sWidth/5
	local Hlindex = 0
	local hero_info = {}
	cellHeight = (zstring.tonumber(_ED.user_ship_number)/5+1)*(m_ScrollView:getContentSize().width/5)
	sHeight = math.max(sHeight, cellHeight)
	local first = nil
	panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
	for j, v in pairs(self:getSortedHeroes(index)) do
		local cell = AdventureHeroIconCell:createCell()

		-- local isBim = false
		--if index == 0 then
		cell:init(8, v, 1, 0, nil, v.hero_fight, nil, nil, j)
		cell:setName("off_" .. v.ship_id)
		-- elseif index == 1 then
		-- 	cell:init(8, v, 1, 0, nil, nil, nil, dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.initial_rank_level), j)
		-- elseif index == 2 then
		-- 	cell:init(8, v, 1, 0, nil, v.hero_fight, nil, nil, j)
		-- elseif index == 3 then
		-- 	cell:init(8, v, 1, 0, nil, nil, v.ship_grade, nil, j)
		--end
		
		panel:addChild(cell)
		if j == 1 then
			first = cell
		end
		tWidth = tWidth + wPosition
		if (j-1)%5 ==0 then
			Hlindex = Hlindex+1
			tWidth = 0
			tHeight = sHeight - wPosition*Hlindex  
		end
		if j<= 5 then
			tHeight = sHeight - wPosition
		end
		cell:setPosition(cc.p(tWidth,tHeight))
	end
	m_ScrollView:jumpToTop()
	-- if first ~= nil then
		-- state_machine.excute("adventure_hero_icon_cell_show_hero_warehouse_larger", 0, {_datas={cell = first}})
	-- end
	-- self.heroList
	ccui.Helper:seekWidgetByName(root, "Panel_skill_1"):setBackGroundImage("images/ui/bg/icon_skill_empty.png")
	ccui.Helper:seekWidgetByName(root, "Panel_skill_2"):setBackGroundImage("images/ui/bg/icon_skill_empty.png")
	ccui.Helper:seekWidgetByName(root, "Panel_skill_3"):setBackGroundImage("images/ui/bg/icon_skill_empty.png")
	ccui.Helper:seekWidgetByName(root, "Panel_skill_4"):setBackGroundImage("images/ui/bg/icon_skill_empty.png")
	
	self.currentScrollView = m_ScrollView
	self.currentInnerContainer = self.currentScrollView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventureMercenaryBatchOff:onEnterTransitionFinish()
    local csbAdventureMercenaryBatchOff = csb.createNode("packs/Mercenary/yongbing_jiegu.csb")
    local root = csbAdventureMercenaryBatchOff:getChildByName("root")
    self.chane_label = ccui.Helper:seekWidgetByName(root, "Text_16")
    self.hetiSkillText = ccui.Helper:seekWidgetByName(root, "Text_mingdan")
	self.hetiSkillText:setVisible(false)
	self.hetiSKillPanel = ccui.Helper:seekWidgetByName(root, "Panel_skill_heti")	

	local armaturePanle  = ccui.Helper:seekWidgetByName(root, "Panel_32")	
	self.ArmatureNode_heti_skill = armaturePanle:getChildByName("ArmatureNode_stage") -- 技能动画
	draw.initArmature(self.ArmatureNode_heti_skill, nil, -1, 0, 1)
   	csb.animationChangeToAction(self.ArmatureNode_heti_skill, 0, 0, false)
   	self.siwei_ycPanel = ccui.Helper:seekWidgetByName(root, "Panel_siwei_1")
    self.siwei_ycNameText = ccui.Helper:seekWidgetByName(root, "Text_role_siwei")
	self.siwei_ycPanelShow = ccui.Helper:seekWidgetByName(root, "Panel_siwei_show_0")

    self:onUpdateChane_label(Chane_label_index_BatchOff)
    table.insert(self.roots, root)
    self:addChild(csbAdventureMercenaryBatchOff)
	
	self:onUpdateDrawBatchOff()
	self:updateReturn()

	local function formationTouchListener(sender, eventType)
		if eventType == ccui.TouchEventType.began then
			fwin:open(AdventureSkillInfoSee:new():init(3,{ id = self.skillId}, self.hetiSKillPanel), fwin._dialog)
		elseif eventType == ccui.TouchEventType.moved then 
		else 
			fwin:close(fwin:find("AdventureSkillInfoSeeClass"))
		end
	end
	self.hetiSkillText:addTouchEventListener(formationTouchListener)
	self.hetiSkillText:setTouchEnabled(true)


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

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMercenaryBatchOffClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 去解雇结算
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jiegu"), nil, 
    {
        terminal_name = "adventure_mercenary_hero_explode_settlement", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)

    -- 排序
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change"), nil, 
    {
        terminal_name = "adventure_mercenary_hero_explode_hero_sort", 
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,0)
end

function AdventureMercenaryBatchOff:onExit()
    state_machine.remove("adventure_mercenary_hero_explode_settlement")
    state_machine.remove("adventure_mercenary_hero_explode_hero_sort")
    state_machine.remove("adventure_mercenary_package_sort_update_Batch")
end



--下面的用不到了
function AdventureMercenaryBatchOff:onUpdateDrawBatchOff( )
	local root = self.roots[1]
	self:onUpdateDraw(Chane_label_index_BatchOff)
	self:onUpdateChane_label(Chane_label_index_BatchOff)
	state_machine.excute("adventure_mercenary_package_sort_update_attribute_info", 0, self.heroList[self.choiceIndex])
end
-- 刷新变更排序提示标签
function AdventureMercenaryBatchOff:onUpdateChane_label(Chane_label_index)
	-- local label_index = Chane_label_index
	-- if label_index == 0 then
	-- 	self.chane_label:setString(_string_piece_info[383])	
	-- elseif label_index == 1 then
	-- 	self.chane_label:setString(_string_piece_info[384])
	-- elseif label_index == 2 then
	-- 	self.chane_label:setString(_string_piece_info[385])
	-- elseif label_index == 3 then
	-- 	self.chane_label:setString(_string_piece_info[386])
	-- end
end