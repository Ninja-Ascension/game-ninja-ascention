--[[ ----------------------------------------------------------------------------
-- 战魂装备
--]] ----------------------------------------------------------------------------
FightSpiritZhEquip = class("FightSpiritZhEquipClass", Window)

-- 打开窗口
local fight_spirit_zh_equip_window_open_terminal = {
	_name = "fight_spirit_zh_equip_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritZhEquipClass") then
			fwin:open(FightSpiritZhEquip:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_zh_equip_window_close_terminal = {
	_name = "fight_spirit_zh_equip_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritZhEquipClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_zh_equip_window_open_terminal)
state_machine.add(fight_spirit_zh_equip_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritZhEquip:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._qualityTag = 0
	-- load lua files.
	app.load("client.packs.FightSpirit.fightspiritzhequipcell")
	
	-- Initialize fight spirit zh equip page state machine.
	local function init_fight_spirit_zh_equip_terminal()
		-- 打开角色创建窗口
		local fight_spirit_zh_equip_open_terminal = {
			_name = "fight_spirit_zh_equip_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local fight_spirit_zh_equip_close_terminal = {
			_name = "fight_spirit_zh_equip_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("fight_spirit_zh_equip_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local fight_spirit_zh_equip_show_terminal = {
			_name = "fight_spirit_zh_equip_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local fight_spirit_zh_equip_hide_terminal = {
			_name = "fight_spirit_zh_equip_hide",
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

		-- 切换页签
		local fight_spirit_zh_equip_change_tag_terminal = {
			_name = "fight_spirit_zh_equip_change_tag",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:setBtnState(instance._qualityTag, true)
				instance._qualityTag = params._datas.tag
				instance:setBtnState(instance._qualityTag, false)
				instance:onUpdateDraw()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(fight_spirit_zh_equip_open_terminal)
		state_machine.add(fight_spirit_zh_equip_close_terminal)
		state_machine.add(fight_spirit_zh_equip_show_terminal)
		state_machine.add(fight_spirit_zh_equip_hide_terminal)
		state_machine.add(fight_spirit_zh_equip_change_tag_terminal)
		state_machine.init()
	end
	-- call func init fight spirit zh equip state machine.
	init_fight_spirit_zh_equip_terminal()
end

-- 对象初始化
function FightSpiritZhEquip:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritZhEquip:onInit(params)
	self._pos = params.pos
	self._hasEquip = params.hasEquip
	self._shipId = params.shipId
end

function FightSpiritZhEquip:onUpdateDraw()
	local root = self.roots[1]

	-- 战魂放置容器
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	self:initData()
	self:updateUI()
end

function FightSpiritZhEquip:initData()
	self.unequipedFightSpirits = {}

	local allFightSpirits = FightSpiritHandle.getAllFightSpiritsList()
	for i,fightSpirit in ipairs(allFightSpirits) do
		if fightSpirit.shipId <= 0 then
			local pos = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.pos)
			if pos == self._pos then
				table.insert(self.unequipedFightSpirits, fightSpirit)
			end
		end
	end
end

function FightSpiritZhEquip:setBtnState(tag, isBright)
	local name
	if tag == 0 then
		name = "all"
	elseif tag == 1 then
		name = "green"
	elseif tag == 2 then
		name = "blue"
	elseif tag == 3 then
		name = "purple"
	elseif tag == 4 then
		name = "orange"
	elseif tag == 5 then
		name = "red"
	elseif tag == 6 then
		name = "jx"
	end
	self["Button_"..name]:setBright(isBright)
	self["Button_"..name]:setTouchEnabled(isBright)
end

function FightSpiritZhEquip:updateUI()
	-- self:changeListView(self._curListViewIndex or 1)
	self:updateItemList()
	-- self:updateEquipedInfo()
end

function FightSpiritZhEquip:filterFightSpirit(qualityTag)
	self._qualityTag = qualityTag or self._qualityTag

	local tmpFightSpirits = clone(self.unequipedFightSpirits)

	if self._qualityTag == 0 then
		self._itemList = tmpFightSpirits
	else
		self._itemList = {}
		for k,v in pairs(tmpFightSpirits) do
			if self._qualityTag == v.quality then
				table.insert(self._itemList, v)
			end
		end
	end
end

function FightSpiritZhEquip:sortItemList()
	--物品排序和筛选绑定，防止排序不稳定
	self:filterFightSpirit()

	local recommendSuitIds = FightSpiritHandle.getRecommendFightSpirit(self._shipId)

	table.sort(self._itemList, function (a, b)
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

function FightSpiritZhEquip:updateItemList()
	self:sortItemList()

	local listview = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	listview:removeAllItems()

	for _,fightSpirit in ipairs(self._itemList) do
		local cell = state_machine.excute("fight_spirit_zh_equip_cell_create", 0, {fightSpirit = fightSpirit, hasEquip = self._hasEquip, shipId = self._shipId})
		listview:addChild(cell)
	end

	listview:jumpToTop()
	listview:requestRefreshView()
end

function FightSpiritZhEquip:onEnterTransitionFinish()
	-- 加载FightSpiritZhEquipWindow界面资源.
	-- res.cocostudio.packs.FightSpirit_zh_equip = res/packs/FightSpirit/FightSpirit_zh_equip.csb
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_zh_equip.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 战魂装备品质选择
	self.Button_all = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_all"), nil,
	{
		terminal_name = "fight_spirit_zh_equip_change_tag",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tag = 0,
	}, nil, 0)	

	-- 战魂装备品质选择
	self.Button_jx = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jx"), nil,
	{
		terminal_name = "fight_spirit_zh_equip_change_tag",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tag = 6,
	}, nil, 0)	

	-- 战魂装备品质选择
	self.Button_red = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_red"), nil,
	{
		terminal_name = "fight_spirit_zh_equip_change_tag",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tag = 5,
	}, nil, 0)	

	-- 战魂装备品质选择
	self.Button_orange = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_orange"), nil,
	{
		terminal_name = "fight_spirit_zh_equip_change_tag",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tag = 4,
	}, nil, 0)	

	-- 战魂装备品质选择
	self.Button_purple = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_purple"), nil,
	{
		terminal_name = "fight_spirit_zh_equip_change_tag",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tag = 3,
	}, nil, 0)	

	-- 战魂装备品质选择
	self.Button_blue = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_blue"), nil,
	{
		terminal_name = "fight_spirit_zh_equip_change_tag",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tag = 2,
	}, nil, 0)	

	-- 战魂装备品质选择
	self.Button_green = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_green"), nil,
	{
		terminal_name = "fight_spirit_zh_equip_change_tag",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tag = 1,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fight_spirit_zh_equip_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self._qualityTag = 0
	self:setBtnState(self._qualityTag, false)
	self:onUpdateDraw()
end

function FightSpiritZhEquip:onExit()
	-- 释放FightSpiritZhEquipWindow界面资源.
	state_machine.remove("fight_spirit_zh_equip_open")
	state_machine.remove("fight_spirit_zh_equip_close")
	state_machine.remove("fight_spirit_zh_equip_show")
	state_machine.remove("fight_spirit_zh_equip_hide")
	state_machine.remove("fight_spirit_zh_equip_change_tag")
end

function FightSpiritZhEquip:close()
	-- window event : close.
	
end

function FightSpiritZhEquip:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
