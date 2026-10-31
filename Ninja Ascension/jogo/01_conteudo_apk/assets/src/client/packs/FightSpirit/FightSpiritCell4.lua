--[[ ----------------------------------------------------------------------------
-- 合成界面
--]] ----------------------------------------------------------------------------
FightSpiritCell4 = class("FightSpiritCell4Class", Window)

-- 打开窗口
local fight_spirit_hecheng_window_open_terminal = {
	_name = "fight_spirit_hecheng_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local panel = FightSpiritCell4:new():init(params)
        fwin:open(panel)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_hecheng_window_close_terminal = {
	_name = "fight_spirit_hecheng_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritCell4Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_hecheng_window_open_terminal)
state_machine.add(fight_spirit_hecheng_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritCell4:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._quality = 1
	self._suitId = 1
	self._pos = 1
	self._hcFightSpiritIds = {0,0,0}
	-- load lua files.
	app.load("client.packs.FightSpirit.FightSpiritSelect")

	-- Initialize fight spirit cell4 page state machine.
	local function init_fight_spirit_hecheng_terminal()
		-- 显示窗口
		local fight_spirit_hecheng_show_terminal = {
			_name = "fight_spirit_hecheng_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:onUpdateDraw()
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local fight_spirit_hecheng_hide_terminal = {
			_name = "fight_spirit_hecheng_hide",
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

		-- 点击战魂图标
		local fight_spirit_hecheng_click_icon_terminal = {
			_name = "fight_spirit_hecheng_click_icon",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:changeSuitId(params._datas.suitId)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- -- 点击战魂材料图标
		local fight_spirit_hecheng_click_material_terminal = {
			_name = "fight_spirit_hecheng_click_material",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				params._datas.hcFightSpiritIds = instance._hcFightSpiritIds
				params._datas.quality = instance._quality
				params._datas.selectType = 1
				state_machine.excute("fight_spirit_select_window_open", 0, params)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击品质panel
		local fight_spirit_hecheng_click_panel_btn_terminal = {
			_name = "fight_spirit_hecheng_click_panel_btn",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if not instance.panelShow then
					instance.panelShow = true
				else
					instance.panelShow = false
				end
				ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_btn"):setVisible(instance.panelShow)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_arrow_1"):setVisible(instance.panelShow)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_arrow_2"):setVisible(not instance.panelShow)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 选择品质
		local fight_spirit_hecheng_change_select_terminal = {
			_name = "fight_spirit_hecheng_change_select",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:changeQuality(params._datas.quality)
				instance.panelShow = false
				ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_btn"):setVisible(instance.panelShow)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_arrow_1"):setVisible(instance.panelShow)
				ccui.Helper:seekWidgetByName(instance.roots[1], "Image_arrow_2"):setVisible(not instance.panelShow)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 选择位置
		local fight_spirit_hecheng_change_pos_terminal = {
			_name = "fight_spirit_hecheng_change_pos",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:changePos(params._datas.pos)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 一键装备
		local fight_spirit_hecheng_one_key_equip_terminal = {
			_name = "fight_spirit_hecheng_one_key_equip",
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

		-- 打开合成确认
		local fight_spirit_hecheng_open_confirm_terminal = {
			_name = "fight_spirit_hecheng_open_confirm",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local materials = {}
				for i,id in ipairs(instance._hcFightSpiritIds) do
					if id > 0 then
						materials[i] = FightSpiritHandle.getFightSpiritById(id)
					else
						TipDlg.drawTextDailog(tipStringInfo_fight_spirit[7])
						return
					end
				end
				state_machine.excute("fight_spirit_hecheng_confirm_window_open", 0, 
				{
					_datas = {
						materials = materials,
						targetFightSpirit = instance.targetFightSpirit,
					}
				})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(fight_spirit_hecheng_show_terminal)
		state_machine.add(fight_spirit_hecheng_hide_terminal)
		state_machine.add(fight_spirit_hecheng_click_icon_terminal)
		state_machine.add(fight_spirit_hecheng_click_material_terminal)
		state_machine.add(fight_spirit_hecheng_click_panel_btn_terminal)
		state_machine.add(fight_spirit_hecheng_change_select_terminal)
		state_machine.add(fight_spirit_hecheng_change_pos_terminal)
		state_machine.add(fight_spirit_hecheng_one_key_equip_terminal)
		state_machine.add(fight_spirit_hecheng_open_confirm_terminal)
		
	end
	-- call func init fight spirit cell4 state machine.
	init_fight_spirit_hecheng_terminal()
end

-- 对象初始化
function FightSpiritCell4:init(params)
	local rootWindow = params[1] 
    self._rootWindows = rootWindow
    -- self:onInit()
	return self
end

function FightSpiritCell4:onUpdateDraw()
	local root = self.roots[1]

	local listview1 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	listview1:removeAllItems()

	for i = 1, 4 do
		local mouldId = (self._suitId - 1) * 20 + (i - 1) * 5 + self._quality
		local cell = state_machine.excute("fight_spirit_cell2_xl_list_create", 0, {mouldId = mouldId, isStrength = false})
		listview1:addChild(cell)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"), nil,
		{
			terminal_name = "fight_spirit_hecheng_change_pos",
			terminal_state = 0,
			isPressedActionEnabled = true,
			pos = i,
		}, nil, 0)
		cell.pos = i
		if i == self._pos then
			ccui.Helper:seekWidgetByName(cell.roots[1], "Image_light"):setVisible(true)
			self.selectCell = cell
		end
	end
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		listview1:requestRefreshView()
	end
	local costStr = dms.string(dms["play_config"], 231, play_config.param)
	local costs = zstring.split(costStr, "|")
	local num = zstring.split((zstring.split(costs[self._quality], ":")[2]), ",")[3]
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_price"):setString(num)

	ccui.Helper:seekWidgetByName(self.roots[1], "Text_ys"):setString(tipStringInfo_fight_spirit_quality[self._quality])
	
	self:updateHechengFightSpirit()
end

function FightSpiritCell4:updateHechengFightSpirit()
	for i = 1, 4 do
		if i == 1 then
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_zh_"..i):removeAllChildren()
		else
			ccui.Helper:seekWidgetByName(self.roots[1], "Button_add_"..i):removeAllChildren()
			-- DSC重塑
			local addImg = ccui.Helper:seekWidgetByName(self.roots[1], "Image_add_"..i)
			if __lua_project_id == __lua_project_l_digital and addImg then
				addImg:setVisible(true)
			end
		end
	end
	
	self.targetFightSpirit = {}
	self.targetFightSpirit.mouldId = (self._suitId - 1) * 20 + (self._pos - 1) * 5 + self._quality
	self.targetFightSpirit.quality = self._quality

	local cell = ResourcesIconCell:createCell()
	cell:init(73,nil,nil,nil,nil,nil,false,nil,{fightSpirit=self.targetFightSpirit})
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"), nil, 
	{
		terminal_name = "fight_spirit_skill_window_open", 
		terminal_state = 0, 
		fightSpirit1 = self.targetFightSpirit,
		previewType = 1
	}, nil, 0)
	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_zh_1"):addChild(cell)

	self._hcFightSpiritIds = {0,0,0}
end

function FightSpiritCell4:updateSingleHechengFightSpirit(pos)
	ccui.Helper:seekWidgetByName(self.roots[1], "Button_add_"..pos + 1):removeAllChildren()
	-- DSC重塑
	local addImg = ccui.Helper:seekWidgetByName(self.roots[1], "Image_add_"..pos + 1)
	if __lua_project_id == __lua_project_l_digital and addImg then
		addImg:setVisible(true)
	end
	if self._hcFightSpiritIds[pos] > 0 then
		local fightSpirit = FightSpiritHandle.getFightSpiritById(self._hcFightSpiritIds[pos])
		local cell = ResourcesIconCell:createCell()
		cell:init(73,nil,nil,nil,nil,nil,false,nil,{fightSpirit=fightSpirit})
		ccui.Helper:seekWidgetByName(self.roots[1], "Button_add_"..pos + 1):addChild(cell)
		ccui.Helper:seekWidgetByName(cell, "Panel_prop"):setTouchEnabled(false)
		-- DSC重塑
		if __lua_project_id == __lua_project_l_digital then
			addImg:setVisible(false)
		end
	end
end

function FightSpiritCell4:onEnterTransitionFinish()
	-- 加载FightSpiritCell4Window界面资源.
	-- res.packs.FightSpirit_cell_4 = res/packs/FightSpirit/FightSpirit_cell_4.csb
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_cell_4.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- if FightSpiritCell4.__size == nil then
	-- 	FightSpiritCell4.__size = root:getContentSize()
	-- end
	-- self:setContentSize(FightSpiritCell4.__size)
	self:initBtn()

	self:onUpdateDraw()
end

function FightSpiritCell4:initBtn()
	for i = 2, 4 do
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_add_"..i), nil, 
		{
			terminal_name = "fight_spirit_hecheng_click_material", 
			terminal_state = 0, 
			pos = i-1,
			isPressedActionEnabled = true,
		}, nil, 0)
	end

	local listview2 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_2")
	listview2:removeAllItems()

	for i,v in ipairs(dms["fight_spirit_suit_mould"]) do
		local fightSpirit = {}
		fightSpirit.quality = self._quality

		local suitId = dms.atof(v, fight_spirit_suit_mould.id)
		fightSpirit.mouldId = (suitId - 1) * 20 + 1

		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(73,nil,nil,nil,nil,nil,false,nil,{fightSpirit=fightSpirit})

		local cell = ccui.Layout:create()
		cell:setContentSize(120,120)
		cell.suitId = suitId
		listview2:addChild(cell)

		local icon1 = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", 7))
		
		cell:addChild(icon1)
		local propId = dms.string(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.prop_id)
		local icon2 = cc.Sprite:create(string.format("images/ui/props/props_%d.png", propId))
		cell:addChild(icon2)
		
		local icon3 = cc.Sprite:create("images/ui/text/sm_hd/private_custom/icon_add_effect.png")
		cell:addChild(icon3)
		
		icon3:setName("select")
		-- DSC重塑   
		if __lua_project_id == __lua_project_l_digital then 
			local cellHalfSize = {cell:getContentSize().width/2,cell:getContentSize().height/2}
			cell:setAnchorPoint(cc.p(0.5,0.5))
			icon1:setAnchorPoint(cc.p(0.5,0.5))
			icon2:setAnchorPoint(cc.p(0.5,0.5))
			icon3:setAnchorPoint(cc.p(0.5,0.5))
			icon1:setPosition(cellHalfSize[1],cellHalfSize[2])
			icon2:setPosition(cellHalfSize[1],cellHalfSize[2])
			icon3:setPosition(cellHalfSize[1],cellHalfSize[2])
		else
			icon1:setAnchorPoint(cc.p(0,0))
			icon2:setPosition(60,60)
			icon3:setPosition(60,60)
		end
		if suitId == self._suitId then
			icon3:setVisible(true)
			self.selectIcon = icon3
		else
			icon3:setVisible(false)
		end

		cell:setTouchEnabled(true)
		fwin:addTouchEventListener(cell, nil, 
		{
			terminal_name = "fight_spirit_hecheng_click_icon", 
			terminal_state = 0, 
			suitId = suitId,
		}, nil, 0)
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_ys"), nil, 
	{
		terminal_name = "fight_spirit_hecheng_click_panel_btn", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_green"), nil, 
	{
		terminal_name = "fight_spirit_hecheng_change_select", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		quality = 1,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_blue"), nil, 
	{
		terminal_name = "fight_spirit_hecheng_change_select", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		quality = 2,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_purple"), nil, 
	{
		terminal_name = "fight_spirit_hecheng_change_select", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		quality = 3,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_orange"), nil, 
	{
		terminal_name = "fight_spirit_hecheng_change_select", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		quality = 4,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_red"), nil, 
	{
		terminal_name = "fight_spirit_hecheng_change_select", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		quality = 5,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_yjtj"), nil, 
	{
		terminal_name = "fight_spirit_hecheng_one_key_equip", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
	}, nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_hc"), nil, 
	{
		terminal_name = "fight_spirit_hecheng_open_confirm", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
	}, nil, 0)

	self.panelShow = false
	ccui.Helper:seekWidgetByName(self.roots[1], "Panel_btn"):setVisible(self.panelShow)
	ccui.Helper:seekWidgetByName(self.roots[1], "Image_arrow_1"):setVisible(self.panelShow)
	ccui.Helper:seekWidgetByName(self.roots[1], "Image_arrow_2"):setVisible(not self.panelShow)
end

function FightSpiritCell4:changeSuitId(suitId)
	if self._suitId ~= suitId then
		self._suitId = suitId
		self:onUpdateDraw()
		self.selectIcon:setVisible(false)
		local listview2 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_2")
		for i,item in ipairs(listview2:getItems()) do
			if item.suitId == suitId then
				local icon = item:getChildByName("select")
				icon:setVisible(true)
				self.selectIcon = icon
				break
			end
		end
	end
end

function FightSpiritCell4:changeQuality(quality)
	if self._quality ~= quality then
		self._quality = quality
		self:onUpdateDraw()
	end
end

function FightSpiritCell4:changePos(pos)
	if self._pos ~= pos then
		self._pos = pos
		self:updateHechengFightSpirit()
		ccui.Helper:seekWidgetByName(self.selectCell.roots[1], "Image_light"):setVisible(false)
		local listview1 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
		for i,item in ipairs(listview1:getItems()) do
			if item.pos == pos then
				local icon = ccui.Helper:seekWidgetByName(item.roots[1], "Image_light")
				icon:setVisible(true)
				self.selectCell = item
				break
			end
		end
	end
end

function FightSpiritCell4:setHcFightSpirit(fightSpiritId, pos)
	self._hcFightSpiritIds[pos] = fightSpiritId
	self:updateSingleHechengFightSpirit(pos)
end

function FightSpiritCell4:oneKeyEquip()
	local isFull = true
	for i = 1, 3 do
		if self._hcFightSpiritIds[i] <= 0 then
			isFull = false
			break
		end
	end

	if isFull then
		TipDlg.drawTextDailog(tipStringInfo_fight_spirit[29])
		return
	end

	local hasLock = false
	local unequipedFightSpirits = {}
	local allFightSpirits = FightSpiritHandle.getAllFightSpiritsList()
	for i,fightSpirit in ipairs(allFightSpirits) do
		local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
		local rare = dms.string(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.rare)
		if tonumber(rare) == 0 and fightSpirit.shipId <= 0 and self._quality == fightSpirit.quality then
			local isAdd = false
			for i = 1, 3 do
				if self._hcFightSpiritIds[i] == fightSpirit.id then
					isAdd = true
					break
				end
			end
			if not isAdd then
				if fightSpirit.lockStatus == 0 then
					table.insert(unequipedFightSpirits, fightSpirit)
				else
					hasLock = true
				end
			end
		end
	end

	table.sort(unequipedFightSpirits, function (a, b)
		local aSuitId = dms.int(dms["fight_spirit_mould"], a.mouldId, fight_spirit_mould.suit_id)
		local bSuitId = dms.int(dms["fight_spirit_mould"], b.mouldId, fight_spirit_mould.suit_id)
		if a.quality ~= b.quality then
			return a.quality < b.quality
		else
			if a.level ~= b.level then
				return a.level < b.level
			else
				if aSuitId ~= bSuitId then
					return aSuitId > bSuitId
				else
					return a.createTime < b.createTime
				end
			end
		end
	end)

	local addCount = 1
	for i = 1, 3 do
		if self._hcFightSpiritIds[i] <= 0 then
			if unequipedFightSpirits[addCount] then
				self:setHcFightSpirit(unequipedFightSpirits[addCount].id, i)
				addCount = addCount + 1
			else
				self:setHcFightSpirit(-1, i)
				if hasLock then
					TipDlg.drawTextDailog(tipStringInfo_fight_spirit[24])
				else
					TipDlg.drawTextDailog(tipStringInfo_fight_spirit[21])
				end
			end
		end
	end
end

function FightSpiritCell4:onExit()
	-- 释放FightSpiritCell4Window界面资源.
	state_machine.remove("fight_spirit_hecheng_show")
	state_machine.remove("fight_spirit_hecheng_hide")
	state_machine.remove("fight_spirit_hecheng_click_icon")
	state_machine.remove("fight_spirit_hecheng_click_material")
	state_machine.remove("fight_spirit_hecheng_click_panel_btn")
	state_machine.remove("fight_spirit_hecheng_change_select")
	state_machine.remove("fight_spirit_hecheng_change_pos")
	state_machine.remove("fight_spirit_hecheng_one_key_equip")
	state_machine.remove("fight_spirit_hecheng_open_confirm")
end

function FightSpiritCell4:close()
	-- window event : close.
	
end

function FightSpiritCell4:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
