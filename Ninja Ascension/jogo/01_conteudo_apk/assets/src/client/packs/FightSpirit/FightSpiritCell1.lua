--[[ ----------------------------------------------------------------------------
-- 战魂界面
--]] ----------------------------------------------------------------------------
FightSpiritCell1 = class("FightSpiritCell1Class", Window)

-- 打开窗口
local fight_spirit_main_window_open_terminal = {
	_name = "fight_spirit_main_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local wnd = fwin:find("FightSpiritCell2Class")
		if wnd and wnd.curShipId ~= params[2] then
			params[2] = wnd.curShipId
		end
		local panel = FightSpiritCell1:new():init(params)
        fwin:open(panel)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_main_window_close_terminal = {
	_name = "fight_spirit_main_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritCell1Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_main_window_open_terminal)
state_machine.add(fight_spirit_main_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritCell1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.curShipId = nil
	self.itemList = {}
	self.curListViewIndex = nil
	self.curSuitId = 0

	-- load lua files.

	-- Initialize fight spirit cell1 page state machine.
	local function init_fight_spirit_main_terminal()
		-- 显示窗口
		local fight_spirit_main_show_terminal = {
			_name = "fight_spirit_main_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					local wnd = fwin:find("FightSpiritCell2Class")
					if wnd and wnd.curShipId ~= instance.curShipId then
						instance.curShipId = wnd.curShipId
						instance:setSelected(instance.curShipId, true)
					end
					instance:setVisible(true)
					instance:onUpdateDraw()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local fight_spirit_main_hide_terminal = {
			_name = "fight_spirit_main_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击头像
		local fight_spirit_main_click_avatar_terminal = {
			_name = "fight_spirit_main_click_avatar",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:changeSelectShip(params._datas.shipId)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击页签
		local fight_spirit_main_click_tab_terminal = {
			_name = "fight_spirit_main_click_tab",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if params._datas.tabTag ~= instance.curTabTag then
					instance:changeListView(1)
					instance:filterFightSpirit(params._datas.tabTag)
					instance:updateItemList()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击选择套装
		local fight_spirit_main_click_choose_suit_terminal = {
			_name = "fight_spirit_main_click_choose_suit",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:changeListView(instance.curListViewIndex == 1 and 2 or 1)
				if params._datas.suitId == 0 then
					instance:filterFightSpirit(nil, params._datas.suitId)
					instance:updateItemList()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 选择套装
		local fight_spirit_main_choose_suit_terminal = {
			_name = "fight_spirit_main_choose_suit",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:changeListView(1)
				if params._datas.suitId ~= instance.curSuitId then
					instance:filterFightSpirit(nil, params._datas.suitId)
					instance:updateItemList()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 一键装备
		local fight_spirit_main_one_key_equip_terminal = {
			_name = "fight_spirit_main_one_key_equip",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:oneKeyEquip()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 一键卸载
		local fight_spirit_main_one_key_unequip_terminal = {
			_name = "fight_spirit_main_one_key_unequip",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:oneKeyUnequip()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 属性详情
		local fight_spirit_main_attr_detail_terminal = {
			_name = "fight_spirit_main_attr_detail",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if not instance.noEquip then
					state_machine.excute("fight_spirit_zh_att_window_open", 0, FightSpiritHandle:getShipFightSpiritAttributeById(instance.curShipId))	
				else
					TipDlg.drawTextDailog(tipStringInfo_fight_spirit[30])
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 技能详情
		local fight_spirit_main_skill_detail_terminal = {
			_name = "fight_spirit_main_skill_detail",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local info = FightSpiritHandle:getShipFightSpiritAttributeById(instance.curShipId)
				if info.suit4Id then
					state_machine.excute("fight_spirit_zh_skill_window_open", 0, {shipId = instance.curShipId})
				else
					TipDlg.drawTextDailog(tipStringInfo_fight_spirit[11])
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新界面
		local fight_spirit_main_update_terminal = {
			_name = "fight_spirit_main_update_detail",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:onUpdateDraw()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击装备栏
		local fight_spirit_main_click_icon_terminal = {
			_name = "fight_spirit_main_click_icon",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local info = FightSpiritHandle.getShipFightSpiritInfoById(instance.curShipId)
				local fightSpiritId = info[params._datas.pos]
				if fightSpiritId > 0 then
					local btnList = {"qianghua", "genghuan", "xiexia"}
					if funOpenConditionJudge(202) then
						local fightSpirit = FightSpiritHandle.getFightSpiritById(fightSpiritId)
						local info = FightSpiritHandle.getFightSpiritAwakeInfoByQuaility(fightSpirit.quality)
						if info then
							if info.isAwaken then
								btnList = {"qianghua", "xilian", "genghuan", "xiexia"}
							else
								btnList = {"qianghua", "juexing", "genghuan", "xiexia"}
							end
						end
					end
					state_machine.excute("fight_spirit_skill_window_open", 0, {_datas = {
						fightSpirit1 = FightSpiritHandle.getFightSpiritById(fightSpiritId),
						btnList = btnList,
						shipId = instance.curShipId,
					}})
				else
					state_machine.excute("fight_spirit_zh_equip_window_open", 0, {pos = params._datas.pos, hasEquip = false, shipId = instance.curShipId})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(fight_spirit_main_show_terminal)
		state_machine.add(fight_spirit_main_hide_terminal)
		state_machine.add(fight_spirit_main_click_avatar_terminal)
		state_machine.add(fight_spirit_main_click_tab_terminal)
		state_machine.add(fight_spirit_main_click_choose_suit_terminal)
		state_machine.add(fight_spirit_main_choose_suit_terminal)
		state_machine.add(fight_spirit_main_one_key_equip_terminal)
		state_machine.add(fight_spirit_main_one_key_unequip_terminal)
		state_machine.add(fight_spirit_main_rule_terminal)
		state_machine.add(fight_spirit_main_attr_detail_terminal)
		state_machine.add(fight_spirit_main_skill_detail_terminal)
		state_machine.add(fight_spirit_main_click_icon_terminal)
		state_machine.add(fight_spirit_main_update_terminal)
	end
	-- call func init fight spirit cell1 state machine.
	init_fight_spirit_main_terminal()
end

-- 对象初始化
function FightSpiritCell1:init(params)
	local rootWindow = params[1] 
    self._rootWindows = rootWindow
    self.curShipId = params[2]
    self.types = params[3]
    self:onInit()
	return self
end

function FightSpiritCell1:onInit()
	local csbItem = csb.createNode("packs/FightSpirit/FightSpirit_cell_1.csb")
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbItem)

	if FightSpiritCell1.__size == nil then
		FightSpiritCell1.__size = root:getContentSize()
	end
	self:setContentSize(FightSpiritCell1.__size)
	self:initBtn()
	self:onUpdateDraw()
end

function FightSpiritCell1:getSortedHeroes()
	local function fightingCapacity(a,b)
		local al = tonumber(a.hero_fight)
		local bl = tonumber(b.hero_fight)
		local result = false
		if al > bl then
			result = true
		end
		return result 
	end
	--上阵
	local tSortedHeroes = {}
	--未上阵
	local arrBusyHeroes = {}
	--全部
	local allHeroes = {}
	for j, q in pairs(_ED.user_ship) do
		if zstring.tonumber(q.formation_index) > 0 then
			table.insert(tSortedHeroes, q)
		else
			table.insert(arrBusyHeroes, q)
		end
	end	
	table.sort(tSortedHeroes, fightingCapacity)
	table.sort(arrBusyHeroes, fightingCapacity)
	for i=1, #tSortedHeroes do
		table.insert(allHeroes, tSortedHeroes[i])
	end

	if __lua_project_id == __lua_project_l_naruto
		then
		if self.types == "formation" then
		else
			for i=1, #arrBusyHeroes do
				table.insert(allHeroes, arrBusyHeroes[i])
			end
		end
	else
		for i=1, #arrBusyHeroes do
			table.insert(allHeroes, arrBusyHeroes[i])
		end
	end

	return allHeroes
end

function FightSpiritCell1:initBtn()
    local root = self.roots[1]
	local listview = ccui.Helper:seekWidgetByName(root,"ListView_3")
	listview:removeAllItems()
	app.load("client.cells.ship.hero_icon_list_cell")
	local index
	local height
	for i, ship in pairs(self:getSortedHeroes()) do
        local shipId = tonumber(ship.ship_id)
        if ship then
			local hero_head = HeroIconListCell:createCell()
			hero_head:init(ship,i)
			listview:addChild(hero_head)
			ccui.Helper:seekWidgetByName(hero_head.roots[1], "Panel_prop"):setTouchEnabled(true)
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(hero_head.roots[1], "Panel_prop"), nil, 
			{
				terminal_name = "fight_spirit_main_click_avatar", 
				terminal_state = 0, 
				shipId = shipId,
			}, nil, 0)
			if self.curShipId == shipId then
				self.curCell = hero_head
				hero_head:setSelected(true)
				index = i
				height = hero_head:getContentSize().height
			end
			hero_head.shipId = shipId
        end
    end
    listview:getInnerContainer():setPositionY((index-1)*height)

    self:setCurTabTag(0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_all"), nil,
	{
		terminal_name = "fight_spirit_main_click_tab",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tabTag = 0,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "fight_spirit_main_click_tab",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tabTag = 1,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
	{
		terminal_name = "fight_spirit_main_click_tab",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tabTag = 2,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil,
	{
		terminal_name = "fight_spirit_main_click_tab",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tabTag = 3,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil,
	{
		terminal_name = "fight_spirit_main_click_tab",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tabTag = 4,
	}, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xz"), nil,
	{
		terminal_name = "fight_spirit_main_click_choose_suit",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_install"), nil,
	{
		terminal_name = "fight_spirit_main_one_key_equip",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_Remove"), nil,
	{
		terminal_name = "fight_spirit_main_one_key_unequip",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_det_1"), nil,
	{
		terminal_name = "fight_spirit_main_attr_detail",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_det_2"), nil,
	{
		terminal_name = "fight_spirit_main_skill_detail",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_dis_all"), nil,
	{
		terminal_name = "fight_spirit_main_click_choose_suit",
		terminal_state = 0,
		isPressedActionEnabled = true,
		suitId = 0,
	}, nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fenjie"), nil,
	{
		terminal_name = "fight_spirit_break_down_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	for i = 1, 4 do
		ccui.Helper:seekWidgetByName(root, "Button_stone_icon_"..i):setTouchEnabled(true)
    	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_stone_icon_"..i), nil, 
		{
			terminal_name = "fight_spirit_main_click_icon", 
			terminal_state = 0, 
			pos = i,
			isPressedActionEnabled = true,
		}, nil, 0)
    end
end

function FightSpiritCell1:onUpdateDraw()
    self:initData()
    self:updateUI()
end

function FightSpiritCell1:setCurTabTag(tag)
	local root = self.roots[1]
	if self.curTagBtn then
		self.curTagBtn:setTouchEnabled(true)
		self.curTagBtn:setBright(true)
	end
	self.curTabTag = tag
	if tag == 0 then
		self.curTagBtn = ccui.Helper:seekWidgetByName(root, "Button_all")
	else
		self.curTagBtn = ccui.Helper:seekWidgetByName(root, "Button_"..tag)
	end
	self.curTagBtn:setTouchEnabled(false)
	self.curTagBtn:setBright(false)
end

function FightSpiritCell1:filterFightSpirit(tabTag, suitId)
	if tabTag and tabTag ~= self.curTabTag then
		self:setCurTabTag(tabTag)
	end
	self.curSuitId = suitId or self.curSuitId

	local tmpFightSpirits

	if self.curTabTag == 0 then
		tmpFightSpirits = clone(self.unequipedFightSpirits)
	else
		tmpFightSpirits = clone(self.unequipedFightSpiritsByPos[self.curTabTag])
	end
	if self.curSuitId == 0 then
		self.itemList = tmpFightSpirits
	else
		self.itemList = {}
		for k,v in pairs(tmpFightSpirits) do
			local suitId_ = dms.int(dms["fight_spirit_mould"], v.mouldId, fight_spirit_mould.suit_id)
			if self.curSuitId == suitId_ then
				table.insert(self.itemList, v)
			end
		end
	end
end

function FightSpiritCell1:initData()
	self.unequipedFightSpirits = {}
	self.unequipedFightSpiritsByPos = {}
	for i = 1, 4 do
		self.unequipedFightSpiritsByPos[i] = {}
	end

	local allFightSpirits = FightSpiritHandle.getAllFightSpiritsList()
	for i,fightSpirit in ipairs(allFightSpirits) do
		if fightSpirit.shipId <= 0 then
			table.insert(self.unequipedFightSpirits, fightSpirit)
			local pos = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.pos)
			table.insert(self.unequipedFightSpiritsByPos[pos], fightSpirit)
		end
	end
end

function FightSpiritCell1:updateUI()
	self:changeListView(self.curListViewIndex or 1)
	self:updateItemList()
	self:updateEquipedInfo()
end

function FightSpiritCell1:sortItemList()
	--物品排序和筛选绑定，防止排序不稳定
	self:filterFightSpirit()

	local recommendSuitIds = FightSpiritHandle.getRecommendFightSpirit(self.curShipId)

	table.sort(self.itemList, function (a, b)
		local aSuitId = dms.int(dms["fight_spirit_mould"], a.mouldId, fight_spirit_mould.suit_id)
		local bSuitId = dms.int(dms["fight_spirit_mould"], b.mouldId, fight_spirit_mould.suit_id)
		local keyA = table.getKeyByValue(recommendSuitIds, aSuitId)
		local keyB = table.getKeyByValue(recommendSuitIds, bSuitId)
		if keyA and keyB and keyA ~= keyB then
			return keyA < keyB
		elseif keyA and not keyB then
			return true
		elseif not keyA and keyB then
			return false
		else
			if a.quality ~= b.quality then
				return a.quality > b.quality
			else
				if a.level ~= b.level then
					return a.level > b.level
				else
					if aSuitId ~= bSuitId then
						return aSuitId < bSuitId
					else
						return a.createTime > b.createTime
					end
				end
			end
		end
	end)
end

function FightSpiritCell1:updateItemList()
	self:sortItemList()

	local listview = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	listview:removeAllItems()

	local lineNum = 4
	local lines = math.ceil(#self.itemList / lineNum)
	for i = 1, lines do
		local node = ccui.Layout:create()
		node:setContentSize(listview:getContentSize().width, 120)
		for j = 1, lineNum do
			local index = (i - 1) * lineNum + j
			if index > #self.itemList then
				break
			end
			local fightSpirit = self.itemList[index]
			local cell = ResourcesIconCell:createCell()
			local function callback()
				local pos = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.pos)
				local info = FightSpiritHandle.getShipFightSpiritInfoById(self.curShipId)
				if info[pos] > 0 then
					state_machine.excute("fight_spirit_skill_window_open", nil, {
						_datas = {
							fightSpirit1 = fightSpirit,
							fightSpirit2 = FightSpiritHandle.getFightSpiritById(info[pos]),
							btnList = {"qianghua", "genghuan"},
							shipId = self.curShipId,
						}
					})
				else
					state_machine.excute("fight_spirit_skill_window_open", nil, {
						_datas = {
							fightSpirit1 = fightSpirit,
							btnList = {"qianghua", "zhuangbei"},
							shipId = self.curShipId,
						}
					})
				end
			end
			local recommendSuitIds = FightSpiritHandle.getRecommendFightSpirit(self.curShipId)
			local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
			cell:init(73,nil,nil,nil,nil,nil,true,nil,{fightSpirit=fightSpirit,callback = callback,showRecommend = table.getKeyByValue(recommendSuitIds, suitId),lazy = true})
			cell:setPositionX((j-1) * 120)
			node:addChild(cell)
		end
		listview:addChild(node)
	end

	listview:jumpToTop()
	listview:requestRefreshView()
	listview:forceDoLayout()

	self.currentScrollView = listview
    self.currentInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    --调用一次onUpdate
    self.currentInnerContainerPosY = self.currentInnerContainerPosY + 1

	local listview2 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_2")
	listview2:removeAllItems()

	local suitCounts = {}
	for i,v in ipairs(dms["fight_spirit_suit_mould"]) do
		suitCounts[dms.atof(v, fight_spirit_suit_mould.id)] = 0
	end

	for _,fightSpirit in ipairs(FightSpiritHandle.getAllFightSpiritsList()) do
		local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
		suitCounts[suitId] = suitCounts[suitId] + 1
	end

	for suitId,count in ipairs(suitCounts) do
		local cell = state_machine.excute("fight_spirit_cell1_zh_list_create", 0, {suitId = suitId, count = count})
		listview2:addChild(cell)
	end
	
	listview2:jumpToTop()
	listview2:requestRefreshView()
end

function FightSpiritCell1:onUpdate(dt)
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
            	for i,child in ipairs(v:getChildren()) do
            		child:unload()
            	end
            else
            	for i,child in ipairs(v:getChildren()) do
            		child:reload()
            	end
            end
        end
    end
end

function FightSpiritCell1:updateEquipedInfo()
	local shipId = self.curShipId
	local info = FightSpiritHandle.getShipFightSpiritInfoById(shipId)
	local noEquip = true
	for i,fightSpiritId in ipairs(info) do
		self:updateFightSpiritIcon(fightSpiritId, i)
		if fightSpiritId > 0 then
			noEquip = false
		end
	end

	local root = self.roots[1]

	self.noEquip = noEquip
	ccui.Helper:seekWidgetByName(root, "Text_no_1"):setVisible(noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_atk"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_def"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_hp"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_atk_num"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_def_num"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_hp_num"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_two"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_two_info"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_four"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_four_info"):setVisible(not noEquip)

	local Text_atk_num = ccui.Helper:seekWidgetByName(root, "Text_atk_num")
	local Text_def_num = ccui.Helper:seekWidgetByName(root, "Text_def_num")
	local Text_hp_num = ccui.Helper:seekWidgetByName(root, "Text_hp_num")
	local attrInfo = FightSpiritHandle:getShipFightSpiritAttributeById(shipId)

	Text_atk_num:setString(attrInfo.attrs[1] or 0)
	Text_def_num:setString(attrInfo.attrs[2] or 0)
	Text_hp_num:setString(attrInfo.attrs[0] or 0)
	ccui.Helper:seekWidgetByName(root, "Text_atk"):setString(tipStringInfo_rescue_silkbag[3])
	ccui.Helper:seekWidgetByName(root, "Text_def"):setString(tipStringInfo_rescue_silkbag[4])
	ccui.Helper:seekWidgetByName(root, "Text_hp"):setString(tipStringInfo_rescue_silkbag[2])

	local attrsStr = dms.string(dms["play_config"], 225, play_config.param)
	local attrs = zstring.split(attrsStr, "|")
	local attr2 = zstring.split(attrs[1], ",")
	local attr4 = zstring.split(attrs[2], ",")
	if attrInfo.suit2Active then
		local name, value = getHardenPropertyNameAndValue(attr2[1], attr2[2])
		ccui.Helper:seekWidgetByName(root, "Text_two_info"):setString(name..value..tipStringInfo_fight_spirit[25])
	else
		ccui.Helper:seekWidgetByName(root, "Text_two_info"):setString(tipStringInfo_fight_spirit.NONE)
	end

	if attrInfo.suit4Id then
		ccui.Helper:seekWidgetByName(root, "Text_skill"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_no_2"):setVisible(false)
        
		local name, value = getHardenPropertyNameAndValue(attr4[1], attr4[2])
		ccui.Helper:seekWidgetByName(root, "Text_four_info"):setString(name .. value)

		local skillDesc = dms.string(dms["fight_spirit_suit_mould"], attrInfo.suit4Id, fight_spirit_suit_mould.skill)
		local desc = zstring.split(skillDesc, "|")
		local descIndex = attrInfo.suit4Quality
		local skillDesc = zstring.split(desc[descIndex], ",")
		local skillNameId = dms.string(dms["talent_mould"], skillDesc[2], talent_mould.talent_describe)
    	local word_info = dms.element(dms["word_mould"], skillNameId)
		ccui.Helper:seekWidgetByName(root, "Text_skill"):setString(word_info[3])
	else
		ccui.Helper:seekWidgetByName(root, "Text_four_info"):setString(tipStringInfo_fight_spirit.NONE)
        ccui.Helper:seekWidgetByName(root, "Text_skill"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Text_no_2"):setVisible(true)
	end
end

function FightSpiritCell1:updateFightSpiritIcon(fightSpiritId, index)
	local icon = ccui.Helper:seekWidgetByName(self.roots[1], "Button_stone_icon_"..index)
	icon:removeAllChildren()

	local allFightSpirits = FightSpiritHandle.getAllFightSpirits()
	if fightSpiritId > 0 then
		local fightSpirit = allFightSpirits[fightSpiritId]
		local cell = ResourcesIconCell:createCell()
		cell:init(73,nil,nil,nil,nil,nil,nil,nil,{fightSpirit=fightSpirit, notShowBg = true})
		-- DSC重塑   
		if __lua_project_id == __lua_project_l_digital then 
			cell:setAnchorPoint(cc.p(0.5,0.5))
			cell:setPosition(cc.p(icon:getContentSize().width/2,icon:getContentSize().height/2))
		end
		icon:addChild(cell)
		ccui.Helper:seekWidgetByName(cell, "Panel_prop"):setTouchEnabled(false)
	end
end

function FightSpiritCell1:changeListView(index)
	if self.curListViewIndex ~= index then
		self.curListViewIndex = index
		ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1"):setVisible(index == 1)
		ccui.Helper:seekWidgetByName(self.roots[1], "ListView_2"):setVisible(index ~= 1)
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_dis_all"):setVisible(index ~= 1)
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_tz"):setVisible(index == 1)
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_zh"):setVisible(index ~= 1)
	end
end

function FightSpiritCell1:oneKeyEquip()
	local shipId = self.curShipId
    local recommendSuitIds = FightSpiritHandle.getRecommendFightSpirit(self.curShipId)

    --未装备满战魂
    local function getFightSpiritMostSuitId(equipedFightSpirits)
        local counts = {}
        local allFightSpirits = FightSpiritHandle.getAllFightSpirits()
        for i,fightSpiritId in ipairs(equipedFightSpirits) do
        	if fightSpiritId > 0 then
	            local fightSpirit = allFightSpirits[fightSpiritId]
	            local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
	            if not counts[suitId] then
	                counts[suitId] = 1
	            else
	                counts[suitId] = counts[suitId] + 1
	            end
	        end
        end
        for suitId,count in pairs(counts) do
            if suitId >= 2 then
                return suitId
            end
        end
    end

    --已装备满战魂
    local function getHighterQualityFightSpiritId(fightSpirit)
        local retSpirit = fightSpirit
    	local maxQuaility = fightSpirit.quality
        local maxLev = fightSpirit.level
        local createTime = fightSpirit.createTime
        local chooseId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
        local pos = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.pos)
        for i,v in ipairs(self.unequipedFightSpirits) do
            local mouldId = v.mouldId
            local suitId = dms.int(dms["fight_spirit_mould"], mouldId, fight_spirit_mould.suit_id)
            local pos1 = dms.int(dms["fight_spirit_mould"], mouldId, fight_spirit_mould.pos)
            local quality = v.quality
            if chooseId == suitId and pos == pos1 then
                local changeTag = false
                if not retSpirit then
                    changeTag = true
                else
                    if maxQuaility < quality then
                        changeTag = true
                    elseif maxQuaility == quality then
                        if maxLev < v.level then
                            changeTag = true
                        elseif maxLev == v.level then
                            if createTime < v.createTime then
                                changeTag = true
                            end
                        end
                    end
                end
                if changeTag then
                    maxQuaility = quality
                    maxLev = v.level
                    createTime = v.createTime
                    retSpirit = v
                end
            end
        end
        if retSpirit then
        	return retSpirit.id
        else
        	return -1
        end
    end

    -- 未装备战魂
    local function getSuit4()
        local suitIds = {}
        local suitTags = {}
        local suitCounts = {}
        for i,v in ipairs(self.unequipedFightSpirits) do
            local mouldId = v.mouldId
            local suitId = dms.int(dms["fight_spirit_mould"], mouldId, fight_spirit_mould.suit_id)
            local pos = dms.int(dms["fight_spirit_mould"], mouldId, fight_spirit_mould.pos)

            if not suitTags[suitId] then
                suitTags[suitId] = {}
            end
            if not suitTags[suitId][pos] then
                suitTags[suitId][pos] = true
                if not suitCounts[suitId] then
                    suitCounts[suitId] = 1
                else
                    suitCounts[suitId] = suitCounts[suitId] + 1
                end
            end
        end

        for suitId,count in pairs(suitCounts) do
            if count >= 4 then
                table.insert(suitIds, suitId)
            end
        end
        return suitIds
    end

    local function getSuit2()
        local suitIds = {}
        local suitTags = {}
        local suitCounts = {}
        for i,v in ipairs(self.unequipedFightSpirits) do
            local mouldId = v.mouldId
            local suitId = dms.int(dms["fight_spirit_mould"], mouldId, fight_spirit_mould.suit_id)
            local pos = dms.int(dms["fight_spirit_mould"], mouldId, fight_spirit_mould.pos)

            if not suitTags[suitId] then
                suitTags[suitId] = {}
            end
            if not suitTags[suitId][pos] then
                suitTags[suitId][pos] = true
                if not suitCounts[suitId] then
                    suitCounts[suitId] = 1
                else
                    suitCounts[suitId] = suitCounts[suitId] + 1
                end
            end
        end

        for suitId,count in pairs(suitCounts) do
            if count >= 2 then
                table.insert(suitIds, suitId)
            end
        end
        return suitIds
    end

    local function getRecommend(suitIds)
        local ret = {}
        for _,suitId in ipairs(suitIds) do
            for _,recommendSuitId in ipairs(recommendSuitIds) do
                if suitId == recommendSuitId then
                    table.insert(ret, suitId)
                end
            end
        end
        return ret
    end

    local function getChooseSuit(suitIds)
        if #suitIds == 1 then
            return suitIds[1]
        else
            local retId
            for i,suitId in ipairs(suitIds) do
                if not retId or retId < suitId then
                    retId = suitId
                end
            end
            return retId
        end
    end    

    local function getEquipFightSpiritId(chooseId, pos)
        local maxQuaility
        local maxLev
        local createTime
        local retSpirit
        for i,v in ipairs(self.unequipedFightSpirits) do
            local mouldId = v.mouldId
            local suitId = dms.int(dms["fight_spirit_mould"], mouldId, fight_spirit_mould.suit_id)
            local pos1 = dms.int(dms["fight_spirit_mould"], mouldId, fight_spirit_mould.pos)
            local quality = v.quality
            if (not chooseId or chooseId == suitId) and pos == pos1 then
                local changeTag = false
                if not retSpirit then
                    changeTag = true
                else
                    if maxQuaility < quality then
                        changeTag = true
                    elseif maxQuaility == quality then
                        if maxLev < v.level then
                            changeTag = true
                        elseif maxLev == v.level then
                            if createTime < v.createTime then
                                changeTag = true
                            end
                        end
                    end
                end
                if changeTag then
                    maxQuaility = quality
                    maxLev = v.level
                    createTime = v.createTime
                    retSpirit = v
                end
            end
        end
        --如果没有推荐的战魂，则再筛选一次该位置品质最高的战魂
        if not retSpirit then
            for i,v in ipairs(self.unequipedFightSpirits) do
                local mouldId = v.mouldId
                local suitId = dms.int(dms["fight_spirit_mould"], mouldId, fight_spirit_mould.suit_id)
                local pos1 = dms.int(dms["fight_spirit_mould"], mouldId, fight_spirit_mould.pos)
                local quality = v.quality
                if pos == pos1 then
                    local changeTag = false
                    if not retSpirit then
                        changeTag = true
                    else
                        if maxQuaility < quality then
                            changeTag = true
                        elseif maxQuaility == quality then
                            if maxLev < v.level then
                                changeTag = true
                            elseif maxLev == v.level then
                                if createTime < v.createTime then
                                    changeTag = true
                                end
                            end
                        end
                    end
                    if changeTag then
                        maxQuaility = quality
                        maxLev = v.level
                        createTime = v.createTime
                        retSpirit = v
                    end
                end
            end
        end
        if retSpirit then
        	return retSpirit.id
        else
        	return -1
        end
    end

    local allFightSpirits = FightSpiritHandle.getAllFightSpirits()
    local equipedFightSpirits = FightSpiritHandle.getShipFightSpiritInfoById(shipId)
    local isFull = true
    local isNull = true
    for _,fightSpiritId in ipairs(equipedFightSpirits) do
    	if fightSpiritId > 0 and isNull then
    		isNull = false
    	elseif fightSpiritId < 0 and isFull then
    		isFull = false
    	end
    end
    
    local newEquiped = {-1,-1,-1,-1}
    if isFull then
    	for i,fightSpiritId in ipairs(equipedFightSpirits) do
	    	if fightSpiritId > 0 then
	    		local fightSpirit = allFightSpirits[fightSpiritId]
	    		newEquiped[i] = getHighterQualityFightSpiritId(fightSpirit)
	    	end
	    end
    elseif isNull then
    	local suit4Ids = getSuit4()
    	local chooseId

	    if #suit4Ids ~= 0 then
	        local recommendIds = getRecommend(suit4Ids)
	        if #recommendIds ~= 0 then
	            chooseId = getChooseSuit(recommendIds)
	        else
	            chooseId = getChooseSuit(suit4Ids)
	        end
	    else
	        local suit2Ids = getSuit2()
	        if #suit2Ids ~= 0 then
	            chooseId = getChooseSuit(suit2Ids)
	        end
	    end

	    for i = 1, 4 do
	        newEquiped[i] = getEquipFightSpiritId(chooseId, i)
	    end
    else
    	local chooseId = getFightSpiritMostSuitId(equipedFightSpirits)
    	for i,fightSpiritId in ipairs(equipedFightSpirits) do
    		local newFightSpirit
	    	if fightSpiritId > 0 then
	    		newEquiped[i] = fightSpiritId
	    	else
	            newEquiped[i] = getEquipFightSpiritId(chooseId, i)
	    	end
	    end
    end

    local noNewEquip = true
    for i,v in ipairs(equipedFightSpirits) do
    	if newEquiped[i] ~= v then
    		noNewEquip = false
    		break
    	end
    end
    if noNewEquip then
    	TipDlg.drawTextDailog(tipStringInfo_fight_spirit[19])
    else
	    FightSpiritHandle.setShipFightSpirits(shipId, newEquiped)
	end
end

function FightSpiritCell1:oneKeyUnequip()
	local equipedFightSpirits = FightSpiritHandle.getShipFightSpiritInfoById(self.curShipId)
	local noEquip = true
    for i,v in ipairs(equipedFightSpirits) do
    	if v ~= -1 then
    		noEquip = false
    		break
    	end
    end
    if noEquip then
    	TipDlg.drawTextDailog(tipStringInfo_fight_spirit[20])
    else
	    FightSpiritHandle.setShipFightSpirits(self.curShipId, {-1,-1,-1,-1})
	end
end

function FightSpiritCell1:changeSelectShip(shipId)
	if self.curShipId ~= shipId then
		self.curShipId = shipId
		self:updateItemList()
		self:updateEquipedInfo()
		self:setSelected(shipId)
	end
end

function FightSpiritCell1:setSelected(shipId, updatePos)
	if self.curCell then
		self.curCell:setSelected(false)
		self.curCell = nil
	end
	local index
	local height
	local listview = ccui.Helper:seekWidgetByName(self.roots[1],"ListView_3")
	local items = listview:getItems()
	for i,v in ipairs(items) do
		if v.shipId == shipId then
			v:setSelected(true)
			self.curCell = v
			index = i
			height = v:getContentSize().height
			break
		end
	end
	local container = listview:getInnerContainer()
	if updatePos then
		local posY = (index-1)*height - container:getContentSize().height + listview:getContentSize().height
		posY = math.min(posY, 0)
		listview:getInnerContainer():setPositionY(posY)
	end
end

function FightSpiritCell1:onExit()
	-- 释放FightSpiritCell1Window界面资源.
	state_machine.remove("fight_spirit_main_show")
	state_machine.remove("fight_spirit_main_hide")
	state_machine.remove("fight_spirit_main_click_avatar")
	state_machine.remove("fight_spirit_main_click_tab")
	state_machine.remove("fight_spirit_main_click_choose_suit")
	state_machine.remove("fight_spirit_main_choose_suit")
	state_machine.remove("fight_spirit_main_one_key_equip")
	state_machine.remove("fight_spirit_main_one_key_unequip")
	state_machine.remove("fight_spirit_main_rule")
	state_machine.remove("fight_spirit_main_attr_detail")
	state_machine.remove("fight_spirit_main_skill_detail")
	state_machine.remove("fight_spirit_main_click_icon")
	state_machine.remove("fight_spirit_main_update_detail")
end

function FightSpiritCell1:close()
	-- window event : close.
	
end

function FightSpiritCell1:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
