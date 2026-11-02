--[[ ----------------------------------------------------------------------------
-- 战魂觉醒洗练
--]] ----------------------------------------------------------------------------
FightSpiritCell2 = class("FightSpiritCell2Class", Window)

-- 打开窗口
local fight_spirit_awake_window_open_terminal = {
	_name = "fight_spirit_awake_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local wnd = fwin:find("FightSpiritCell1Class")
		if wnd and wnd.curShipId ~= params[2] then
			params[2] = wnd.curShipId
		end
		local panel = FightSpiritCell2:new():init(params)
        fwin:open(panel)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_awake_window_close_terminal = {
	_name = "fight_spirit_awake_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritCell2Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_awake_window_open_terminal)
state_machine.add(fight_spirit_awake_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritCell2:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.curShipId = nil
	self.curIndex = nil
	self.isPack = false
	self.itemList = {}

	-- load lua files.
	app.load("client.packs.FightSpirit.FightSpiritAwakeSuccess")

	-- Initialize fight spirit cell1 page state machine.
	local function init_fight_spirit_awake_terminal()
		-- 显示窗口
		local fight_spirit_awake_show_terminal = {
			_name = "fight_spirit_awake_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					local wnd = fwin:find("FightSpiritCell1Class")
					if wnd and wnd.curShipId ~= instance.curShipId then
						instance.curShipId = wnd.curShipId
						instance:setSelected(instance.curShipId, true)
					end
					instance:updateUI()
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local fight_spirit_awake_hide_terminal = {
			_name = "fight_spirit_awake_hide",
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
		local fight_spirit_awake_click_avatar_terminal = {
			_name = "fight_spirit_awake_click_avatar",
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

		-- 刷新界面
		local fight_spirit_awake_update_terminal = {
			_name = "fight_spirit_awake_update",
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

		-- 点击觉醒
		local fight_spirit_awake_click_awake_button_terminal = {
			_name = "fight_spirit_awake_click_awake_button",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local fightSpirit = instance.fightSpirit
				local info = FightSpiritHandle.getFightSpiritAwakeInfoByQuaility(fightSpirit.quality)
			    local awakeCosts = zstring.split(dms.string(dms["play_config"], 232, pirates_config.param), "!")
			    awakeCosts = zstring.split(awakeCosts[info.awakeIndex], "|")
			    local canAwake = true
			    local lackId
			    for i,v in ipairs(awakeCosts) do
			    	v = zstring.split(v, ",", function (value) return tonumber(value) end)
			    	if tonumber(getPropAllCountByMouldId(v[2])) < v[3] then
			    		canAwake = false
			    		lackId = v[2]
			    		break
			    	end
			    end
			    if canAwake then
			    	local oldFightSpirit = clone(fightSpirit)
			    	local function responseCallback(response)
	        			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	        				smFightingChange()
	        				
							instance:onUpdateDraw()
            				state_machine.excute("sm_role_strengthen_tab_fight_spirit_update_draw", 0, {})
							state_machine.excute("fight_spirit_awake_success_window_open", 0, {oldFightSpirit = oldFightSpirit})
	        			end
	        		end
			    	protocol_command.fight_spirit_awake.param_list = ""..fightSpirit.id
    				NetworkManager:register(protocol_command.fight_spirit_awake.code, nil, nil, nil, nil, responseCallback, false, nil)
			    else
			    	state_machine.excute("fight_spirit_obtain_window_open", 0, {itemId = lackId})
			    end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击锁
		local fight_spirit_awake_click_lock_button_terminal = {
			_name = "fight_spirit_awake_click_lock_button",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local index = params._datas.index
				local isLock = params._datas.isLock
				if isLock then
					local lockCount = 0
					for i,v in ipairs(instance.xilianLockStates) do
						if v then
							lockCount = lockCount + 1
						end
					end
					if lockCount == 3 then
						TipDlg.drawTextDailog(tipStringInfo_fight_spirit[15])
						return
					end
				end
				instance.xilianLockStates[index] = isLock
				instance:updateXilianLockInfo()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击洗练
		local fight_spirit_awake_click_xilian_button_terminal = {
			_name = "fight_spirit_awake_click_xilian_button",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local canXilian = true
			    local lackId
				local costInfo = instance.xilianCostInfo
				for i,v in ipairs(costInfo) do
					if tonumber(getPropAllCountByMouldId(v.id)) < v.num then
			    		canXilian = false
			    		lackId = v.id
			    		break
			    	end
				end
				if canXilian then
					if not _ED.notOpenFightSpiritXilianConfirm then
						state_machine.excute("fight_spirit_xilian_confirm_window_open", 0, 
							{xilianLockStates = instance.xilianLockStates, fightSpirit = instance.fightSpirit})
					else
						state_machine.excute("fight_spirit_xilian_request", 0, {})
					end
			    else
			 		state_machine.excute("fight_spirit_obtain_window_open", 0, {itemId = lackId})
			    end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 洗练请求
		local fight_spirit_xilian_request_terminal = {
			_name = "fight_spirit_xilian_request",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local fightSpiritId = instance.fightSpirit.id
				local function responseCallback(response)
        			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        				smFightingChange()
        				
        				if params.callback then
        					params.callback()
        				end

        				local fightSpirit = FightSpiritHandle.getFightSpiritById(fightSpiritId)
        				instance:updateXilian(fightSpirit)
        			end
        		end
		    	local str = ""
		    	for i,state in ipairs(instance.xilianLockStates) do
		    		if state == -1 then

		    		else
		    			if state then
		    				str = str .. "1"
		    			else
		    				str = str .. "0"
		    			end
		    			if i ~= 4 then
		    				str = str .. ","
		    			end
		    		end
		    	end
		    	protocol_command.fight_spirit_refine.param_list = ""..fightSpiritId .. "\r\n" .. str
				NetworkManager:register(protocol_command.fight_spirit_refine.code, nil, nil, nil, nil, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 洗练请求
		local fight_spirit_xilian_save_terminal = {
			_name = "fight_spirit_xilian_save",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local fightSpiritId = instance.fightSpirit.id
				local function responseCallback(response)
        			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
        				smFightingChange()
        				
        				local fightSpirit = FightSpiritHandle.getFightSpiritById(fightSpiritId)
        				instance:onUpdateDraw()
        			end
        		end

		    	protocol_command.fight_spirit_refine_define.param_list = ""..fightSpiritId .. "\r\n" .. (params._datas.isSave and 1 or 0)
				NetworkManager:register(protocol_command.fight_spirit_refine_define.code, nil, nil, nil, nil, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(fight_spirit_awake_show_terminal)
		state_machine.add(fight_spirit_awake_hide_terminal)
		state_machine.add(fight_spirit_awake_click_avatar_terminal)
		state_machine.add(fight_spirit_awake_update_terminal)
		state_machine.add(fight_spirit_awake_click_awake_button_terminal)
		state_machine.add(fight_spirit_awake_click_lock_button_terminal)
		state_machine.add(fight_spirit_awake_click_xilian_button_terminal)
		state_machine.add(fight_spirit_xilian_request_terminal)
		state_machine.add(fight_spirit_xilian_save_terminal)
	end
	-- call func init fight spirit cell1 state machine.
	init_fight_spirit_awake_terminal()
end

-- 对象初始化
function FightSpiritCell2:init(params)
	local rootWindow = params[1] 
    self._rootWindows = rootWindow
    self.curShipId = params[2]
    self.types = params[3]
    self:onInit()
	return self
end

function FightSpiritCell2:onInit()
	local csbItem = csb.createNode("packs/FightSpirit/FightSpirit_cell_2.csb")
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbItem)

	if FightSpiritCell2.__size == nil then
		FightSpiritCell2.__size = root:getContentSize()
	end
	self:setContentSize(FightSpiritCell2.__size)
	self:initBtn()
	self:onUpdateDraw()
end

function FightSpiritCell2:getSortedHeroes()
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

function FightSpiritCell2:initBtn()
    local root = self.roots[1]
	local listview = ccui.Helper:seekWidgetByName(root,"ListView_2")
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
				terminal_name = "fight_spirit_awake_click_avatar", 
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

    ccui.Helper:seekWidgetByName(root, "Button_bp"):setPressedActionEnabled(true)
    ccui.Helper:seekWidgetByName(root, "Button_bp"):addTouchEventListener(function (sender, eventType)
    	if eventType == ccui.TouchEventType.ended then
    		if not self.isPack then
    			self.isPack = true
    			self:updateItemList()
    		end
    	end
    end)

    ccui.Helper:seekWidgetByName(root, "Button_jx_det_2"):setPressedActionEnabled(true)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jx_det_2"), function (sender, eventType)
    	if eventType == ccui.TouchEventType.ended then
    		state_machine.excute("fight_spirit_jx_att_window_open", nil, {mouldId = self.fightSpirit.mouldId, isAwaken = false})
    	end
    end)

    ccui.Helper:seekWidgetByName(root, "Button_det_2"):setPressedActionEnabled(true)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_det_2"), function (sender, eventType)
    	if eventType == ccui.TouchEventType.ended then
    		state_machine.excute("fight_spirit_jx_att_window_open", nil, {mouldId = self.fightSpirit.mouldId, isAwaken = true})
    	end
    end)

    ccui.Helper:seekWidgetByName(root, "Button_det_1"):setPressedActionEnabled(true)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_det_1"), function (sender, eventType)
    	if eventType == ccui.TouchEventType.ended then
    		state_machine.excute("fight_spirit_sj_att_window_open", nil, {fightSpirit = self.fightSpirit})
    	end
    end)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_th"), nil, 
	{
		terminal_name = "fight_spirit_xilian_save", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		isSave = true,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fq"), nil, 
	{
		terminal_name = "fight_spirit_xilian_save", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		isSave = false,
	}, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jx"), nil, 
	{
		terminal_name = "fight_spirit_awake_click_awake_button", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
	}, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xl"), nil, 
	{
		terminal_name = "fight_spirit_awake_click_xilian_button", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
	}, nil, 0)
    
	for i = 1, 4 do
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lock_"..i), nil, 
		{
			terminal_name = "fight_spirit_awake_click_lock_button", 
			terminal_state = 0, 
			isPressedActionEnabled = true,
			index = i,
			isLock = false,
		}, nil, 0)
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_unlock_"..i), nil, 
		{
			terminal_name = "fight_spirit_awake_click_lock_button", 
			terminal_state = 0, 
			isPressedActionEnabled = true,
			index = i,
			isLock = true,
		}, nil, 0)
	end
end

function FightSpiritCell2:onUpdateDraw()
	self:updateUI()
end

function FightSpiritCell2:updateUI()
    self:updateItemList()
end

function FightSpiritCell2:initData()
	local items = {}
	if self.isPack then
		local unequipedFightSpirits = {}
		local allFightSpirits = FightSpiritHandle.getAllFightSpiritsList()
		for i,fightSpirit in ipairs(allFightSpirits) do
			if fightSpirit.shipId <= 0 and fightSpirit.quality >= 5 then
				table.insert(unequipedFightSpirits, fightSpirit)
			end
		end

		table.sort(unequipedFightSpirits, function (a, b)
			local aSuitId = dms.int(dms["fight_spirit_mould"], a.mouldId, fight_spirit_mould.suit_id)
			local bSuitId = dms.int(dms["fight_spirit_mould"], b.mouldId, fight_spirit_mould.suit_id)
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
		end)

		items = unequipedFightSpirits
	else
		local shipId = self.curShipId
		local info = FightSpiritHandle.getShipFightSpiritInfoById(shipId)
		for i,fightSpiritId in ipairs(info) do
			if fightSpiritId > 0 then
				table.insert(items, FightSpiritHandle.getFightSpiritById(fightSpiritId))
			end
		end
	end
	return items
end

function FightSpiritCell2:onUpdate(dt)
    if self.currentScrollView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentScrollView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentScrollView:getChildren()
        -- if items[1] == nil then
        --     return
        -- end
        local itemSize
        if items[1] then
        	 itemSize = items[1]:getContentSize()
        end
        local firstLoadItem
        local hasUpdateRight = false
        for i, v in ipairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
        		-- v:unload()
            else
            	if not firstLoadItem then
            		firstLoadItem = v
            	end
        		v:reload()
        		local cell = v
        		ccui.Helper:seekWidgetByName(cell.roots[1], "Image_1"):addTouchEventListener(function (sender, eventType)
					if eventType == ccui.TouchEventType.ended then
						self:updateRightLayout(v.info)
						ccui.Helper:seekWidgetByName(self.selectCell.roots[1], "Image_light"):setVisible(false)
						ccui.Helper:seekWidgetByName(cell.roots[1], "Image_light"):setVisible(true)
						self.selectCell = cell
					end
				end)
				if self.fightSpirit and v.info.id == self.fightSpirit.id then
					ccui.Helper:seekWidgetByName(cell.roots[1], "Image_light"):setVisible(true)
					self.selectCell = cell
					self:updateRightLayout(v.info)
					hasUpdateRight = true
				end
            end
        end
        if self.currentScrollView.firstLoad then
			self.currentScrollView.firstLoad = false
			if not hasUpdateRight and firstLoadItem then
				local cell = firstLoadItem
				self:updateRightLayout(cell.info)
				ccui.Helper:seekWidgetByName(cell.roots[1], "Image_light"):setVisible(true)
				self.selectCell = cell
			elseif not hasUpdateRight then
				self:updateRightLayout()
			end
		end
    end
end

function FightSpiritCell2:updateItemList()
	local items = self:initData()
	
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_no"):setVisible(#items == 0)

	local listview = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	listview:removeAllItems()

	listview.firstLoad = true
	for i,v in ipairs(items) do
		local cell = state_machine.excute("fight_spirit_cell2_xl_list_create", 0, {mouldId = v.mouldId, isStrength = true, fightSpirit = v, isLazy = true})
		cell.info = v
		listview:addChild(cell)
	end

	listview:jumpToTop()
	listview:requestRefreshView()
	listview:forceDoLayout()

	-- self:updateRightLayout()
	self.currentScrollView = listview
    self.currentInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    --调用一次onUpdate
    self.currentInnerContainerPosY = self.currentInnerContainerPosY + 1

	if self.isPack then
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_name"):setString(tipStringInfo_fight_spirit[12])
	else
		local ship = _ED.user_ship["" .. self.curShipId]
		local ship_evo = zstring.split(ship.evolution_status, "|")
		local evo_mould_id =  smGetSkinEvoIdChange(ship)
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		local hero_name = word_info[3]
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_name"):setString(hero_name)
	end
end

function FightSpiritCell2:updateRightLayout(fightSpirit)
	if fightSpirit then
		fightSpirit = FightSpiritHandle.getFightSpiritById(fightSpirit.id)
		if self.fightSpirit ~= fightSpirit then
			self.fightSpirit = fightSpirit
			if fightSpirit.quality < 5 then
				ccui.Helper:seekWidgetByName(self.roots[1], "Panel_kong"):setVisible(true)
				ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xilian"):setVisible(false)
				ccui.Helper:seekWidgetByName(self.roots[1], "Panel_juexing"):setVisible(false)
			else
				ccui.Helper:seekWidgetByName(self.roots[1], "Panel_kong"):setVisible(false)
				local info = FightSpiritHandle.getFightSpiritAwakeInfoByQuaility(fightSpirit.quality)
				ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xilian"):setVisible(info.isAwaken)
				ccui.Helper:seekWidgetByName(self.roots[1], "Panel_juexing"):setVisible(not info.isAwaken)
				if info.isAwaken then
					self:updateXilian(fightSpirit)
				else
					self:updateAwake(fightSpirit)
				end
			end
		end
		if fightSpirit.quality < 5 then
			state_machine.excute("fight_spirit_change_awake_btn", 0, {index=1})
		else
			local info = FightSpiritHandle.getFightSpiritAwakeInfoByQuaility(fightSpirit.quality)
			if info.isAwaken then
				state_machine.excute("fight_spirit_change_awake_btn", 0, {index=2})
			else
				state_machine.excute("fight_spirit_change_awake_btn", 0, {index=1})
			end
		end
	else
		self.fightSpirit = nil
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_kong"):setVisible(true)
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_xilian"):setVisible(false)
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_juexing"):setVisible(false)
		state_machine.excute("fight_spirit_change_awake_btn", 0, {index=1})
	end
end

function FightSpiritCell2:updateAwake(fightSpirit)
	function splitAttr(attrs)
		local retAttrs = {}
		local attrList = zstring.split(attrs, "|")
        for _,attrItem in ipairs(attrList) do
            local attrItem = zstring.split(attrItem, ",", function (value) return tonumber(value) end)
            table.insert(retAttrs, attrItem)
        end
        return retAttrs
	end

	local root = self.roots[1]
	local icon1 = ccui.Helper:seekWidgetByName(root, "Panel_icon_1")
	icon1:removeAllChildren()
	local cell = ResourcesIconCell:createCell()
	cell:init(73,nil,nil,nil,nil,nil,true,nil,{fightSpirit=fightSpirit})
	icon1:addChild(cell)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"), nil, 
	{
		terminal_name = "fight_spirit_skill_window_open", 
		terminal_state = 0, 
		fightSpirit1 = fightSpirit,
	}, nil, 0)

	local attrs = splitAttr(fightSpirit.addProperty.main)
	local libId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.main_lib_id)
	local rows = dms.searchs(dms["fight_spirit_talent_mould"], fight_spirit_talent_mould.lib_type, 2,
		fight_spirit_talent_mould.lib_id, libId)
	local row = dms.searchs(rows, fight_spirit_talent_mould.quality, fightSpirit.quality + 1)[1]
	local awakeAttrs = dms.atos(row, fight_spirit_talent_mould.strength_attr)
	awakeAttrs = zstring.split(awakeAttrs, "|")

	local awakeShowAttrs = {}
	for i = 1, 3 do
		local attr = attrs[i]
		ccui.Helper:seekWidgetByName(root, "Text_jx_atk_"..i):setVisible(attr and true or false)
		ccui.Helper:seekWidgetByName(root, "Text_jx_sx_"..i):setVisible(attr and true or false)
		ccui.Helper:seekWidgetByName(root, "Text_jx_atk_"..i+3):setVisible(attr and true or false)
		ccui.Helper:seekWidgetByName(root, "Text_jx_sx_"..i+3):setVisible(attr and true or false)
		ccui.Helper:seekWidgetByName(root, "Image_upupup_"..i):setVisible(attr and true or false)
		if attr then
			local name, value = getHardenPropertyNameAndValue(attr[1], attr[2]+attr[3])
			ccui.Helper:seekWidgetByName(root, "Text_jx_atk_"..i):setString(name)
			ccui.Helper:seekWidgetByName(root, "Text_jx_sx_"..i):setString(value)
			
			local awakeAttr = zstring.split(awakeAttrs[i], ":")
			local baseAttr = zstring.split(awakeAttr[1], ",")
			local strengthAttr = tonumber(awakeAttr[2])
			local name, value = getHardenPropertyNameAndValue(baseAttr[1], tonumber(baseAttr[2])+strengthAttr*(fightSpirit.level-1))
			ccui.Helper:seekWidgetByName(root, "Text_jx_atk_"..i+3):setString(name)
			ccui.Helper:seekWidgetByName(root, "Text_jx_sx_"..i+3):setString(value)
			awakeShowAttrs[i] = {attr[1], tonumber(baseAttr[2]), strengthAttr*(fightSpirit.level-1)}
		end
	end

	local icon2 = ccui.Helper:seekWidgetByName(root, "Panel_icon_2")
	icon2:removeAllChildren()
	local fightSpirit2 = clone(fightSpirit)
	fightSpirit2.quality = fightSpirit2.quality + 1
	fightSpirit2.shipId = -1
	fightSpirit2.awakeShowAttrs = awakeShowAttrs
	local cell2 = ResourcesIconCell:createCell()
	cell2:init(73,nil,nil,nil,nil,nil,true,nil,{fightSpirit=fightSpirit2})
	icon2:addChild(cell2)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell2.roots[1], "Panel_prop"), nil, 
	{
		terminal_name = "fight_spirit_skill_window_open", 
		terminal_state = 0, 
		fightSpirit1 = fightSpirit2,
		previewType = 2
	}, nil, 0)

	local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
	local skillDescs = dms.string(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.skill)
	skillDescs = zstring.split(skillDescs, "|")[fightSpirit.quality+1]
	skillDescs = zstring.split(skillDescs, ",")
	local skillNameId = dms.string(dms["talent_mould"], skillDescs[2], talent_mould.talent_describe)
    local word_info = dms.element(dms["word_mould"], skillNameId)
    ccui.Helper:seekWidgetByName(root, "Text_skill_info"):setString(word_info[3])

	local iconContainer = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon")
	-- local icon1 = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", 7))
	-- icon1:setAnchorPoint(cc.p(0,0))
	-- iconContainer:addChild(icon1)
	local propId = dms.string(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.prop_id)
	local icon2 = cc.Sprite:create(string.format("images/ui/props/props_%d.png", propId))
	iconContainer:addChild(icon2)
	icon2:setPosition(60,60)

    local info = FightSpiritHandle.getFightSpiritAwakeInfoByQuaility(fightSpirit.quality)
    local awakeCosts = zstring.split(dms.string(dms["play_config"], 232, pirates_config.param), "!")
    awakeCosts = zstring.split(awakeCosts[info.awakeIndex], "|")
    for i,v in ipairs(awakeCosts) do
    	local cell = ResourcesIconCell:createCell()
    	v = zstring.split(v, ",", function (value) return tonumber(value) end)
		cell:init(v[1],0,v[2],nil,nil,true,true,1,{callback = function ()
			state_machine.excute("fight_spirit_obtain_window_open", 0, {itemId = v[2]})
		end})
		ccui.Helper:seekWidgetByName(root, "Panel_jx_icon_"..i):addChild(cell)
		ccui.Helper:seekWidgetByName(root, "Text_jx_cost_"..(i-1)*2+1):setString(getPropAllCountByMouldId(v[2]))
		ccui.Helper:seekWidgetByName(root, "Text_jx_cost_"..(i-1)*2+2):setString("/"..v[3])
    end
end

function FightSpiritCell2:updateXilian(fightSpirit)
	self.xilianLockStates = {false, false, false, false}
	function splitAttr(attrs)
		local retAttrs = {}
		local attrList = zstring.split(attrs, "|")
        for _,attrItem in ipairs(attrList) do
            local attrItem = zstring.split(attrItem, ",", function (value) return tonumber(value) end)
            table.insert(retAttrs, attrItem)
        end
        return retAttrs
	end
	
	local root = self.roots[1]

	local icon1 = ccui.Helper:seekWidgetByName(root, "Panel_13")
	icon1:removeAllChildren()
	local cell = ResourcesIconCell:createCell()
	cell:init(73,nil,nil,nil,nil,nil,true,nil,{fightSpirit=fightSpirit})
	icon1:addChild(cell)

	local attrs = splitAttr(fightSpirit.addProperty.random)
	for i = 1, 3 do
		local attr = attrs[i]
		if attr then
			ccui.Helper:seekWidgetByName(root, "Text_atk_"..i):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_shuxing_"..i):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_atkUp_"..i):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_shuxingUp_"..i):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Image_upup_"..i):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_sjsx_"..i+4):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Button_lock_"..i):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Button_unlock_"..i):setVisible(true)

			local name, value = getHardenPropertyNameAndValue(attr[1], attr[2])
			ccui.Helper:seekWidgetByName(root, "Text_atk_"..i):setString(name)
			ccui.Helper:seekWidgetByName(root, "Text_shuxing_"..i):setString(value)
			local name, value = getHardenPropertyNameAndValue(attr[1], attr[3])
			ccui.Helper:seekWidgetByName(root, "Text_shuxingUp_"..i):setString(value..")")
		else
			ccui.Helper:seekWidgetByName(root, "Text_atk_"..i):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_shuxing_"..i):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_atkUp_"..i):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_shuxingUp_"..i):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_upup_"..i):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_sjsx_"..i+4):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_lock_"..i):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_unlock_"..i):setVisible(false)

			self.xilianLockStates[i] = -1
		end
	end

	local skillNameId = dms.string(dms["talent_mould"], fightSpirit.addProperty.awake, talent_mould.talent_describe)
    local word_info = dms.element(dms["word_mould"], skillNameId)
    ccui.Helper:seekWidgetByName(root, "Text_atk_4"):setString(word_info[3])
    ccui.Helper:seekWidgetByName(root, "Text_shuxing_4"):setString("")

    if not fightSpirit.newProperty or fightSpirit.newProperty == -1 then
		ccui.Helper:seekWidgetByName(root, "Panel_xlxh"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_tihuan"):setVisible(false)
		self:updateXilianLockInfo()
	else
		self:updateXilianResult(fightSpirit)
	end
end

function FightSpiritCell2:updateXilianLockInfo()
	self.xilianCostInfo = {}
	local root = self.roots[1]
	local lockCount = 0
	for i = 1, 4 do
		if self.xilianLockStates[i] == -1 then
			ccui.Helper:seekWidgetByName(root, "Button_lock_"..i):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Button_unlock_"..i):setVisible(false)
		else
			ccui.Helper:seekWidgetByName(root, "Button_lock_"..i):setVisible(self.xilianLockStates[i])
			ccui.Helper:seekWidgetByName(root, "Button_unlock_"..i):setVisible(not self.xilianLockStates[i])
		end
		if self.xilianLockStates[i] then
			lockCount = lockCount + 1
			ccui.Helper:seekWidgetByName(root, "Text_sjsx_"..i+4):setString(tipStringInfo_fight_spirit[14])
		else
			ccui.Helper:seekWidgetByName(root, "Text_sjsx_"..i+4):setString(tipStringInfo_fight_spirit[13])
		end
	end

    local info = FightSpiritHandle.getFightSpiritAwakeInfoByQuaility(self.fightSpirit.quality)
    local extraCostNum = {}
    local extraCosts = zstring.split(dms.string(dms["play_config"], 234, pirates_config.param), "!")
    extraCosts = zstring.split(extraCosts[info.awakeIndex], "|")
    for i,v in ipairs(extraCosts) do
    	v = zstring.split(v, ",", function (value) return tonumber(value) end)
    	extraCostNum[v[2]] = v[3] * lockCount
    end

    local xilianCosts = zstring.split(dms.string(dms["play_config"], 233, pirates_config.param), "!")
    xilianCosts = zstring.split(xilianCosts[info.awakeIndex], "|")
    for i,v in ipairs(xilianCosts) do
    	v = zstring.split(v, ",", function (value) return tonumber(value) end)
    	local cell = ResourcesIconCell:createCell()
		cell:init(v[1],0,v[2],nil,nil,true,true,1,{callback = function ()
			state_machine.excute("fight_spirit_obtain_window_open", 0, {itemId = v[2]})
		end})
		ccui.Helper:seekWidgetByName(root, "Panel_xl_icon_"..i):addChild(cell)
		ccui.Helper:seekWidgetByName(root, "Text_cost_"..(i-1)*2+1):setString(getPropAllCountByMouldId(v[2]))
		ccui.Helper:seekWidgetByName(root, "Text_cost_"..(i-1)*2+2):setString("/"..v[3] + extraCostNum[v[2]])
		self.xilianCostInfo[i] = {id = v[2], num = v[3] + extraCostNum[v[2]]}
    end
end

function FightSpiritCell2:changeSelectShip(shipId)
	if self.curShipId ~= shipId or self.isPack then
		self.isPack = false
		self.curShipId = shipId
		self:updateItemList()
		self:setSelected(shipId)
	end
end

function FightSpiritCell2:setSelected(shipId, updatePos)
	if self.curCell then
		self.curCell:setSelected(false)
		self.curCell = nil
	end
	local index
	local height
	local listview = ccui.Helper:seekWidgetByName(self.roots[1],"ListView_2")
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

function FightSpiritCell2:updateXilianResult(fightSpirit)
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Panel_xlxh"):setVisible(false)
	ccui.Helper:seekWidgetByName(root, "Panel_tihuan"):setVisible(true)
	local attrs = splitAttr(fightSpirit.newProperty.random)
	for i = 1, 3 do
		local attr = attrs[i]
		if attr then
			ccui.Helper:seekWidgetByName(root, "Text_atk_"..i+4):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_shuxing_"..i+4):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_atkUp_"..i+4):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Text_shuxingUp_"..i+4):setVisible(true)

			local name, value = getHardenPropertyNameAndValue(attr[1], attr[2])
			ccui.Helper:seekWidgetByName(root, "Text_atk_"..i+4):setString(name)
			ccui.Helper:seekWidgetByName(root, "Text_shuxing_"..i+4):setString(value)
			local name, value = getHardenPropertyNameAndValue(attr[1], attr[3])
			ccui.Helper:seekWidgetByName(root, "Text_shuxingUp_"..i+4):setString(value..")")
		else
			ccui.Helper:seekWidgetByName(root, "Text_atk_"..i+4):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_shuxing_"..i+4):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_atkUp_"..i+4):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Text_shuxingUp_"..i+4):setVisible(false)
		end
	end

	for i = 1, 4 do
		ccui.Helper:seekWidgetByName(root, "Button_lock_"..i):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_unlock_"..i):setVisible(false)
	end

	local skillNameId = dms.string(dms["talent_mould"], fightSpirit.newProperty.awake, talent_mould.talent_describe)
    local word_info = dms.element(dms["word_mould"], skillNameId)
    ccui.Helper:seekWidgetByName(root, "Text_atk_8"):setString(word_info[3])
    ccui.Helper:seekWidgetByName(root, "Text_shuxing_8"):setString("")
end

function FightSpiritCell2:onExit()
	-- 释放FightSpiritCell2Window界面资源.
	state_machine.remove("fight_spirit_awake_show")
	state_machine.remove("fight_spirit_awake_hide")
	state_machine.remove("fight_spirit_awake_click_avatar")
	state_machine.remove("fight_spirit_awake_update")
	state_machine.remove("fight_spirit_awake_click_awake_button")
	state_machine.remove("fight_spirit_awake_click_lock_button")
	state_machine.remove("fight_spirit_awake_click_xilian_button")
	state_machine.remove("fight_spirit_xilian_save")
end

function FightSpiritCell2:close()
	-- window event : close.
	
end

function FightSpiritCell2:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
