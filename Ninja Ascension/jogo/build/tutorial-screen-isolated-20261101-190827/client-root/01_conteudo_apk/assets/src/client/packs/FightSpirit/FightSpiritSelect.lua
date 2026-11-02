--[[ ----------------------------------------------------------------------------
-- 战魂选择
--]] ----------------------------------------------------------------------------
FightSpiritSelect = class("FightSpiritSelectClass", Window)

-- 打开窗口
local fight_spirit_select_window_open_terminal = {
	_name = "fight_spirit_select_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritSelectClass") then
			fwin:open(FightSpiritSelect:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_select_window_close_terminal = {
	_name = "fight_spirit_select_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritSelectClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_select_window_open_terminal)
state_machine.add(fight_spirit_select_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritSelect:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit select page state machine.
	local function init_fight_spirit_select_terminal()
		-- 打开角色创建窗口
		local fight_spirit_select_open_terminal = {
			_name = "fight_spirit_select_open",
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
		local fight_spirit_select_close_terminal = {
			_name = "fight_spirit_select_close",
			_init = function (terminal)

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("fight_spirit_select_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local fight_spirit_select_show_terminal = {
			_name = "fight_spirit_select_show",
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
		local fight_spirit_select_hide_terminal = {
			_name = "fight_spirit_select_hide",
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

		-- 点击图标
		local fight_spirit_select_click_icon_terminal = {
			_name = "fight_spirit_select_click_icon",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local fightSpiritId = params._datas.fightSpiritId
				local cell = params._datas.cell
				local key = table.getKeyByValue(instance.fightSpiritIds, fightSpiritId)
				if key then
					table.remove(instance.fightSpiritIds, key)
					ccui.Helper:seekWidgetByName(cell, "Image_xuanzhong"):setVisible(false)
				else
					if (instance.selectType == 1 and #instance.fightSpiritIds == 3) or
						(instance.selectType == 2 and #instance.fightSpiritIds == 5) then
						TipDlg.drawTextDailog(tipStringInfo_fight_spirit[29])
						return
					end
					table.insert(instance.fightSpiritIds, fightSpiritId)
					ccui.Helper:seekWidgetByName(cell, "Image_xuanzhong"):setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 确定按钮
		local fight_spirit_select_ok_terminal = {
			_name = "fight_spirit_select_ok",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance.selectType == 1 then
					local wnd = fwin:find("FightSpiritCell4Class")
	                if wnd ~= nil then
	                	for i = 1, 3 do
	                		if instance.fightSpiritIds[i] then
	                			wnd:setHcFightSpirit(instance.fightSpiritIds[i], i)
	                		else
	                			wnd:setHcFightSpirit(-1, i)
	                		end
	                	end
	                end
	            else
	            	wnd = fwin:find("FightSpiritBreakDownClass")
	                if wnd ~= nil then
	                    for i = 1, 5 do
	                		if instance.fightSpiritIds[i] then
	                			wnd:setHcFightSpirit(instance.fightSpiritIds[i], i)
	                		else
	                			wnd:setHcFightSpirit(-1, i)
	                		end
	                	end
	                end
	            end
				state_machine.excute("fight_spirit_select_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(fight_spirit_select_open_terminal)
		state_machine.add(fight_spirit_select_close_terminal)
		state_machine.add(fight_spirit_select_show_terminal)
		state_machine.add(fight_spirit_select_hide_terminal)
		state_machine.add(fight_spirit_select_click_icon_terminal)
		state_machine.add(fight_spirit_select_ok_terminal)
		state_machine.init()
	end
	-- call func init fight spirit select state machine.
	init_fight_spirit_select_terminal()
end

-- 对象初始化
function FightSpiritSelect:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritSelect:onInit(params)
	self.pos = params._datas.pos
	self.quality = params._datas.quality
	self.selectType = params._datas.selectType	--1、合成 2、分解
	self.fightSpiritIds = params._datas.hcFightSpiritIds
	local temp = {}
	for i,id in ipairs(self.fightSpiritIds) do
		if id > 0 then
			table.insert(temp, id)
		end
	end
	self.fightSpiritIds = temp
end

function FightSpiritSelect:sortItemList()
	local unequipedFightSpirits = {}
	local allFightSpirits = FightSpiritHandle.getAllFightSpiritsList()
	for i,fightSpirit in ipairs(allFightSpirits) do
		local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
		local rare = dms.string(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.rare)
		if fightSpirit.shipId <= 0 then
			if (self.selectType == 1 and self.quality == fightSpirit.quality and
				tonumber(rare) == 0 )
				or (self.selectType == 2 and fightSpirit.quality >= 5 ) then
				table.insert(unequipedFightSpirits, fightSpirit)
			end
		end
	end

	table.sort(unequipedFightSpirits, function (a, b)
		local aSuitId = dms.int(dms["fight_spirit_mould"], a.mouldId, fight_spirit_mould.suit_id)
		local bSuitId = dms.int(dms["fight_spirit_mould"], b.mouldId, fight_spirit_mould.suit_id)
		if a.lockStatus == 0 and b.lockStatus == 1 then
			return true
		elseif a.lockStatus == 1 and b.lockStatus == 0 then
			return false
		elseif a.quality ~= b.quality then
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

	self._itemList = unequipedFightSpirits
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_no"):setVisible(false)
	if not next(unequipedFightSpirits) then
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_no"):setVisible(true)
	end
end

function FightSpiritSelect:onUpdateDraw()
	local root = self.roots[1]

	-- 战魂图标放置容器
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	-- 已穿戴是否显示
	self.CheckBox_xs = ccui.Helper:seekWidgetByName(root, "CheckBox_xs")

	-- 强化战魂经验提示（默认隐藏）
	self.Text_name_0 = ccui.Helper:seekWidgetByName(root, "Text_name_0")

	if self.selectType == 2 then 
		self.Text_name_0:setVisible(false)
	else
		self.Text_name_0:setVisible(true)
	end

	self:sortItemList()

	local listview = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	listview:removeAllItems()

	local lineNum = 4
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		lineNum = 5
	end
	local lines = math.ceil(#self._itemList / lineNum)
	for i = 1, lines do
		local node = ccui.Layout:create()
		node:setContentSize(listview:getContentSize().width, 120)
		for j = 1, lineNum do
			local index = (i - 1) * lineNum + j
			if index > #self._itemList then
				break
			end
			local fightSpirit = self._itemList[index]
			local cell = ResourcesIconCell:createCell()
			
			local function callback()
				local fightSpirit = FightSpiritHandle.getFightSpiritById(fightSpirit.id)
				if fightSpirit.lockStatus == 1 then
					TipDlg.drawTextDailog(tipStringInfo_fight_spirit[23])
				else
					state_machine.excute("fight_spirit_select_click_icon", nil, {
						_datas = {
							fightSpiritId = fightSpirit.id,
							cell = cell,
						}
					})
				end
			end

			cell:init(73,nil,nil,nil,nil,nil,true,nil,{fightSpirit=fightSpirit,callback=callback,lazy = true})
			if table.getKeyByValue(self.fightSpiritIds, fightSpirit.id) then
				if ccui.Helper:seekWidgetByName(cell, "Image_xuanzhong") then
					ccui.Helper:seekWidgetByName(cell, "Image_xuanzhong"):setVisible(true)
				end
			end
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
end

function FightSpiritSelect:onUpdate(dt)
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
            	-- for i,child in ipairs(v:getChildren()) do
            	-- 	child:unload()
            	-- end
            else
            	for i,child in ipairs(v:getChildren()) do
            		child:reload()
            	end
            end
        end
    end
end

function FightSpiritSelect:onEnterTransitionFinish()
	-- 加载FightSpiritSelectWindow界面资源.
	-- res.cocostudio.packs.FightSpirit_select = res/packs/FightSpirit/FightSpirit_select.csb
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_select.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 确定按钮
	self.Button_qd = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qd"), nil,
	{
		terminal_name = "fight_spirit_select_ok",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fight_spirit_select_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function FightSpiritSelect:onExit()
	-- 释放FightSpiritSelectWindow界面资源.
	state_machine.remove("fight_spirit_select_open")
	state_machine.remove("fight_spirit_select_close")
	state_machine.remove("fight_spirit_select_show")
	state_machine.remove("fight_spirit_select_hide")
	state_machine.remove("fight_spirit_select_click_icon")
	state_machine.remove("fight_spirit_select_ok")
end

function FightSpiritSelect:close()
	-- window event : close.
	
end

function FightSpiritSelect:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
