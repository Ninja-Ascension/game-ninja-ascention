-- ----------------------------------------------------------------------------------------------------
-- 说明：武将上阵列表
-------------------------------------------------------------------------------------------------------
AdventureMercenaryHeroBattle = class("AdventureMercenaryHeroBattleClass", Window)

--临时存储变更排序索引
local Chane_label_index = 0

function AdventureMercenaryHeroBattle:ctor()
    self.super:ctor()
    self.roots = {}
	
	app.load("client.adventure.cells.hero.adventure_hero_icon_cell")
	self.currentScrollView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
	
	self.formationId = 0
	self.drawIndex = 0
	self.heroList = {}
	self.current_hero = nil --当前选中的英雄
	self.isChangeEmpty = false -- 需要改变的位置是否是空的 --- 如果是空的,说明需要重新计算上阵drawIndex
	self.Panel_role_hero1 = nil
	self.Panel_role_hero2 = nil
	self.Panel_role_di1 = nil
	self.Panel_role_di2 = nil
    -- Initialize adventure mercenary hero handbook state machine.
    local function init_adventure_mercenary_hero_battle_terminal()
		local adventure_mercenary_hero_battle_list_open_confirm_terminal = {
            _name = "adventure_mercenary_hero_battle_list_open_confirm",
            _init = function (terminal)
                app.load("client.adventure.mercenary.formation.AdventureMercenaryHeroBattleConfirm")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        	--这里是弹出确认更换更换英雄框  --传入的更换位置一定要先算好
	   
		        local changeIndex = zstring.tonumber(self.drawIndex)
		        if self.isChangeEmpty == true then 
		        	for j, v in pairs(_ED.formetion) do
						if j ~= 1 and zstring.tonumber(v) == 0 then
							changeIndex = j-1
							break
						end
					end
		        end
		        instance:onUpdateChangeHeroDraw(params._datas.cell.hero)
				fwin:open(AdventureMercenaryHeroBattleConfirm:new():init(0, self.formationId,changeIndex, params._datas.cell.hero), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 改变排序
        local adventure_mercenary_hero_battle_sort_terminal = {
            _name = "adventure_mercenary_hero_battle_sort",
            _init = function (terminal)
                app.load("client.adventure.mercenary.package.AdventureMercenaryPackageSort")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureMercenaryPackageSort:new():init(Chane_label_index,3), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 排序的状态机
		local adventure_mercenary_hero_battle_sort_update_terminal = {
			_name = "adventure_mercenary_hero_battle_sort_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				Chane_label_index = zstring.tonumber(params._datas._showType)
				self:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		state_machine.add(adventure_mercenary_hero_battle_list_open_confirm_terminal)
		state_machine.add(adventure_mercenary_hero_battle_sort_terminal)
		state_machine.add(adventure_mercenary_hero_battle_sort_update_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mercenary hero handbook state machine.
    init_adventure_mercenary_hero_battle_terminal()
end

function AdventureMercenaryHeroBattle:getSortedHeroes(indexs)
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
	local arrStarLevelHeroesWhite = {}--白
	local arrStarLevelHeroesGreen = {}--绿
	local arrStarLevelHeroesKohlrabiblue= {}--蓝
	local arrStarLevelHeroesPurple = {}--紫
	local arrStarLevelHeroesOrange = {}--橙
	local arrStarLevelHeroesRed = {}--红
	local arrStarLevelHeroesPink = {}--粉
	for i, ship in pairs(self.heroList) do
		if ship.ship_id ~= nil then
			
			local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
			if dms.atoi(shipData, ship_mould.ship_type) == 0 then
				table.insert(arrStarLevelHeroesWhite, ship)
			elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
				table.insert(arrStarLevelHeroesGreen, ship)
			elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
				table.insert(arrStarLevelHeroesKohlrabiblue, ship)
			elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
				table.insert(arrStarLevelHeroesPurple, ship)
			elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
				table.insert(arrStarLevelHeroesOrange, ship)
			elseif dms.atoi(shipData, ship_mould.ship_type) == 5 then
				table.insert(arrStarLevelHeroesRed, ship)
			elseif dms.atoi(shipData, ship_mould.ship_type) == 6 then
				table.insert(arrStarLevelHeroesPink, ship)
			end 
		end
	end
	-- table.sort(arrStarLevelHeroesWhite, fightingCapacity)
	
	for i=1, #arrStarLevelHeroesPink do
		table.insert(tSortedHeroes, arrStarLevelHeroesPink[i])
	end
	for i=1, #arrStarLevelHeroesRed do
		table.insert(tSortedHeroes, arrStarLevelHeroesRed[i])
	end
	for i=1, #arrStarLevelHeroesOrange do
		table.insert(tSortedHeroes, arrStarLevelHeroesOrange[i])
	end
	for i=1, #arrStarLevelHeroesPurple do
		table.insert(tSortedHeroes, arrStarLevelHeroesPurple[i])
	end
	for i=1, #arrStarLevelHeroesKohlrabiblue do
		table.insert(tSortedHeroes, arrStarLevelHeroesKohlrabiblue[i])
	end
	for i=1, #arrStarLevelHeroesGreen do
		table.insert(tSortedHeroes, arrStarLevelHeroesGreen[i])
	end
	for i=1, #arrStarLevelHeroesWhite do
		table.insert(tSortedHeroes, arrStarLevelHeroesWhite[i])
	end
	
	
	if indexs == 1 then  -- 觉醒等级排序
		table.sort(tSortedHeroes, awakenCapacity)
	elseif indexs == 2 then	-- 战力等级排序
		table.sort(tSortedHeroes, fightingCapacity)
	elseif indexs == 3 then	-- 等级排序
		table.sort(tSortedHeroes, lvCapacity)
	end

	return tSortedHeroes
end

function AdventureMercenaryHeroBattle:init(index, drawIndex,isEmpty)
	self.formationId = index
	self.drawIndex = drawIndex
	self.isChangeEmpty = isEmpty
    return self
end

function AdventureMercenaryHeroBattle:showlist(index)
	local root = self.roots[1]
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_role")
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
	panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
	
	for j, v in pairs(self:getSortedHeroes(index)) do
		local isBim = false
		local cell = AdventureHeroIconCell:createCell()
		cell:init(4, v, 1, 0, nil, v.hero_fight, nil, nil, j)
		panel:addChild(cell)

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

	self.currentScrollView = m_ScrollView
	self.currentInnerContainer = self.currentScrollView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventureMercenaryHeroBattle:onUpdateChangeHeroDraw(hero)
	local root = self.roots[1]
	self.Panel_role_hero1:removeAllChildren()
	self.Panel_role_hero2:removeAllChildren()
	self.Panel_role_di1:removeAllChildren()
	self.Panel_role_di2:removeAllChildren()
	local Text_hero_name = ccui.Helper:seekWidgetByName(root, "Text_hero_name")
	if self.isChangeEmpty == false and self.current_hero ~= nil then 
		Text_hero_name:setVisible(false)
		local mould_data = dms.element(dms["ship_mould"], self.current_hero.ship_template_id)
		local quality = dms.atoi(mould_data, ship_mould.ship_type)
		if mould_data == nil then 
			return
		end
		local qualityImage = string.format("images/ui/quality/icon_prop_%d.png", quality+1)
		self.Panel_role_di1:setBackGroundImage(qualityImage)
		local picIndex = dms.atos(mould_data, ship_mould.head_icon)
		local spriteIcon = string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex))
		self.Panel_role_hero1:setBackGroundImage(spriteIcon)
	else
		Text_hero_name:setVisible(true)
	end
	--交换的英雄
	if hero ~= nil then 
		local mould_data1 = dms.element(dms["ship_mould"], hero.ship_template_id)
		local quality = dms.atoi(mould_data1, ship_mould.ship_type)
		if mould_data1 == nil then 
			return
		end
		local qualityImage = string.format("images/ui/quality/icon_prop_%d.png", quality+1)
		self.Panel_role_di2:setBackGroundImage(qualityImage)
		local picIndex = dms.atos(mould_data1, ship_mould.head_icon)
		local spriteIcon = string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(picIndex))
		self.Panel_role_hero2:setBackGroundImage(spriteIcon)

	end
end

function AdventureMercenaryHeroBattle:onUpdateDraw()
	local root = self.roots[1]
	self.heroList = {}
	for i,w in pairs(_ED.user_ship) do
		local needInsert = true
		for z, r in pairs(_ED.formetion) do
			if z>1 and zstring.tonumber(r)>0 then
				if zstring.tonumber(r) == zstring.tonumber(w.ship_id) then
					needInsert = false
					break
				end
			end
		end
		if needInsert == true then
			table.insert(self.heroList, w)
		end
	end

	self:showlist(Chane_label_index)
	self:onUpdateChane_label(Chane_label_index)
	
	for z, r in pairs(_ED.formetion) do
		if z == self.drawIndex+1 then
			if zstring.tonumber(r)>0 then
				for i,w in pairs(_ED.user_ship) do
					if zstring.tonumber(r) == zstring.tonumber(w.ship_id) then
						
						self.current_hero = w

						break
					end
				end
			else
				self.current_hero = nil
			end
			break
		end
	end
	
end

function AdventureMercenaryHeroBattle:onUpdate(dt)
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
            end
        end
    end
end

-- 刷新变更排序提示标签
function AdventureMercenaryHeroBattle:onUpdateChane_label(Chane_label_index)
	local root = self.roots[1]
	local label_index = Chane_label_index
	if label_index == 0 then
		ccui.Helper:seekWidgetByName(root, "Text_16"):setString(_string_piece_info[383])	
	elseif label_index == 1 then
		ccui.Helper:seekWidgetByName(root, "Text_16"):setString(_string_piece_info[384])
	elseif label_index == 2 then
		ccui.Helper:seekWidgetByName(root, "Text_16"):setString(_string_piece_info[385])
	elseif label_index == 3 then
		ccui.Helper:seekWidgetByName(root, "Text_16"):setString(_string_piece_info[386])
	end
end

function AdventureMercenaryHeroBattle:onEnterTransitionFinish()
    local csbAdventureMercenaryHeroHandbook = csb.createNode("packs/Mercenary/yongbing_changelist.csb")
    local root = csbAdventureMercenaryHeroHandbook:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMercenaryHeroHandbook)
    self.Panel_role_hero1 = ccui.Helper:seekWidgetByName(root, "Panel_role_1")
	self.Panel_role_hero2 = ccui.Helper:seekWidgetByName(root, "Panel_role_2")
	self.Panel_role_di1 = ccui.Helper:seekWidgetByName(root, "Panel_role_di_1")
	self.Panel_role_di2 = ccui.Helper:seekWidgetByName(root, "Panel_role_di_2")

	self:onUpdateDraw()
	self:onUpdateChangeHeroDraw(nil)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMercenaryHeroBattleClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
	
	-- 变更排序
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_choose"),       nil, 
    {
        terminal_name = "adventure_mercenary_hero_battle_sort",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
	
end

function AdventureMercenaryHeroBattle:onExit()
    state_machine.remove("adventure_mercenary_hero_battle_sort")
end
