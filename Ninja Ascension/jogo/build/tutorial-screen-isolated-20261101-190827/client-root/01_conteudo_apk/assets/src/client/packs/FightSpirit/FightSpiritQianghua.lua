--[[ ----------------------------------------------------------------------------
-- 战魂强化
--]] ----------------------------------------------------------------------------
FightSpiritQianghua = class("FightSpiritQianghuaClass", Window)

-- 打开窗口
local fight_spirit_qianghua_window_open_terminal = {
	_name = "fight_spirit_qianghua_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritQianghuaClass") then
			fwin:open(FightSpiritQianghua:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_qianghua_window_close_terminal = {
	_name = "fight_spirit_qianghua_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritQianghuaClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_qianghua_window_open_terminal)
state_machine.add(fight_spirit_qianghua_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritQianghua:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.cells = {}
	self.costCells = {}
	self.maxLevTag = false
	self.initLockState = {}
	self.selectedInfos = {}
	self.upMateriaInfo = {}

	-- load lua files.
	app.load("client.packs.FightSpirit.FightSpiritQianghuaSuccess")
	
	-- Initialize fight spirit qianghua page state machine.
	local function init_fight_spirit_qianghua_terminal()
		-- 打开角色创建窗口
		local fight_spirit_qianghua_open_terminal = {
			_name = "fight_spirit_qianghua_open",
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
		local fight_spirit_qianghua_close_terminal = {
			_name = "fight_spirit_qianghua_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("fight_spirit_qianghua_window_close", 0, {})
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local fight_spirit_qianghua_show_terminal = {
			_name = "fight_spirit_qianghua_show",
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
		local fight_spirit_qianghua_hide_terminal = {
			_name = "fight_spirit_qianghua_hide",
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

		-- 一键添加
		local fight_spirit_qianghua_one_key_add_terminal = {
			_name = "fight_spirit_qianghua_one_key_add",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:oneKeyAdd()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 强化
		local fight_spirit_qianghua_qianghua_terminal = {
			_name = "fight_spirit_qianghua_qianghua",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local oldFightSpirit = clone(FightSpiritHandle.getFightSpiritById(instance.fightSpiritId))
				local function responseCallback(response)
        			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            			
            			if instance.curLevel < instance.targetLevel then
	            			for i = instance.curLevel + 1, instance.targetLevel do
	            				if i % 3 == 0 then
									state_machine.excute("fight_spirit_qianghua_success_window_open", 0, {oldFightSpirit = oldFightSpirit})
									break
								end
							end
						end

						local num = #instance.selectedInfos
        				for i = num, 1, -1 do
        					instance:removeItem(i,instance.selectedInfos[i].cellIdx)
        				end
						state_machine.excute("sm_role_strengthen_tab_fight_spirit_update_draw", 0, {})
        				instance:onUpdateDraw()
        				state_machine.excute("fight_spirit_main_update_detail", 0, {})

						smFightingChange()
        			end
        		end
        		local str = ""
        		for i = 1, 5 do
        			local cell = instance.costCells[i]
        			str = str .. "\r\n"
        			if cell then
						local info = cell.info
						local num = cell.nums
        				if info[1] == 6 then
        					str = str .. "6," .. info[2] .. "," .. num
        				else
        					str = str .. info[2].id
        				end
        			else
        				str = str .. "-1"
        			end
        		end
				protocol_command.fight_spirit_ehance.param_list = ""..instance.fightSpiritId..str
    			NetworkManager:register(protocol_command.fight_spirit_ehance.code, nil, nil, nil, nil, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 筛选
		local fight_spirit_qianghua_filter_terminal = {
			_name = "fight_spirit_qianghua_filter",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance.filterParams = params.filterParams
				instance:updateItemList()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 上锁刷新
		local fight_spirit_qianghua_lock_refresh_terminal = {
			_name = "fight_spirit_qianghua_lock_refresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local num = #instance.selectedInfos
				for i = num, 1, -1 do
					instance:removeItem(i,instance.selectedInfos[i].cellIdx)
				end
				instance:onUpdateDraw()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(fight_spirit_qianghua_open_terminal)
		state_machine.add(fight_spirit_qianghua_close_terminal)
		state_machine.add(fight_spirit_qianghua_show_terminal)
		state_machine.add(fight_spirit_qianghua_hide_terminal)
		state_machine.add(fight_spirit_qianghua_one_key_add_terminal)
		state_machine.add(fight_spirit_qianghua_qianghua_terminal)
		state_machine.add(fight_spirit_qianghua_filter_terminal)
		state_machine.add(fight_spirit_qianghua_lock_refresh_terminal)
		state_machine.init()
	end
	-- call func init fight spirit qianghua state machine.
	init_fight_spirit_qianghua_terminal()
end

-- 对象初始化
function FightSpiritQianghua:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritQianghua:onInit(params)
	self.fightSpiritId = params.fightSpiritId
		--筛选高级魂石，中级魂石，低级魂石，红色，橙色，紫色，蓝色，绿色
	local filterParams = readKey("fight_spirit_sx_params")
	if filterParams == "" then
		self.filterParams = {1,1,1,1,1,1,1,1}
	else
		self.filterParams = zstring.split(filterParams, ",", function (value)
			return tonumber(value)
		end)
	end
end

function FightSpiritQianghua:onUpdateDraw()
	local fightSpirit = FightSpiritHandle.getFightSpiritById(self.fightSpiritId)
	self.Panel_zh:removeAllChildren()

	local cell = ResourcesIconCell:createCell()
	cell:init(73,nil,nil,nil,nil,nil,nil,nil,{fightSpirit=fightSpirit})
	self.Panel_zh:addChild(cell)

	local pos = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.pos)
	local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
	self.Text_name:setString(dms.element(dms["word_mould"], 
		dms.int(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.suit_name))[3].."."..chinese_num[pos])

	function splitAttr(attrs)
		local retAttrs = {}
		local attrList = zstring.split(attrs, "|")
        for _,attrItem in ipairs(attrList) do
            local attrItem = zstring.split(attrItem, ",", function (value) return tonumber(value) end)
            table.insert(retAttrs, attrItem)
        end
        return retAttrs
	end

    local attrs = splitAttr(fightSpirit.addProperty.main)
	for i = 1, 3 do
		if #attrs < i then
			self["Text_atk_"..i]:setVisible(false)
			self["Text_shuxing_"..i]:setVisible(false)
		else
			local attr = attrs[i]
			local name, value = getHardenPropertyNameAndValue(attr[1], attr[2]+attr[3])
			self["Text_atk_"..i]:setString(name)
			self["Text_shuxing_"..i]:setString(value)
		end
	end

	local attrs = splitAttr(fightSpirit.addProperty.random)
	for i = 1, 3 do
		if #attrs < i then
			self["Text_atk_"..i+3]:setVisible(false)
			self["Text_shuxing_"..i+3]:setVisible(false)
		else
			local attr = attrs[i]
			local name, value = getHardenPropertyNameAndValue(attr[1], attr[2]+attr[3])
			self["Text_atk_"..i+3]:setString(name)
			self["Text_shuxing_"..i+3]:setString(value)
		end
	end

	if FightSpiritHandle.canStrength(self.fightSpiritId) then
		local nextStrengthLev = (math.floor(fightSpirit.level / 3)+1) * 3
		self.Text_qhsj:setString(string.format(tipStringInfo_fight_spirit[9], nextStrengthLev))
	else
		self.Text_qhsj:setString(tipStringInfo_fight_spirit[28])
	end

	self.Text_level:setString(fightSpirit.level)

	self:updateItemList()
	self:updateUI()
end

function FightSpiritQianghua:updateItemList()
	self:initData()

	local listview = self.ListView_zh
	local originPosY = listview:getInnerContainer():getPositionY()

	listview:removeAllItems()
	self.cells = {}

	local totalItems = {}
	local fightStoneInfo = zstring.split(dms.string(dms["play_config"], 228, pirates_config.param), "|")
	for i = 1, #fightStoneInfo do
		if (self.filterParams[1] == 1 or i ~= 3)
			and (self.filterParams[2] == 1 or i ~= 2)
			and (self.filterParams[3] == 1 or i ~= 1) then
			local info = zstring.split(fightStoneInfo[i], ",")
			local id = tonumber(info[2])
			local num = tonumber(getPropAllCountByMouldId(id))
			if num > 0 then 
				table.insert(totalItems, {6, id,num})
			end
		end
	end

	for _,v in ipairs(self.fightSpirits) do
		table.insert(totalItems, {73, v})
	end
	local lineNum = 4
	local lines = math.ceil(#totalItems / lineNum)
	for i = 1, lines do
		local node = ccui.Layout:create()
		node:setContentSize(listview:getContentSize().width, 120)
		for j = 1, lineNum do
			local index = (i - 1) * lineNum + j
			if index > #totalItems then
				break
			end
			local info = totalItems[index]
			local cell = ResourcesIconCell:createCell()
			local function callback(nums)
				if nums then 
					local isRemove = false
					local selectTemp = {}
					table.add(selectTemp,self.selectedInfos)
					for i,v in ipairs(selectTemp) do
						if v.cellIdx == index then 
							isRemove = true
							self:removeItem(v.cellPos,index)
						end
					end

					if not isRemove then 
						local cutNums = 5 - #self.selectedInfos
						local cellNums = nums > cutNums and cutNums or nums
						if #self.selectedInfos == 5 then
							TipDlg.drawTextDailog(tipStringInfo_fight_spirit[10])
						elseif self.maxLevTag then
							TipDlg.drawTextDailog(tipStringInfo_fight_spirit[17])
						elseif info[1] ~= 6 and info[2].lockStatus ~= 0 then
							TipDlg.drawTextDailog(tipStringInfo_fight_spirit[23])
						else
							for i = 1 , cellNums do
								self:addItem(index,1)
							end
						end
					end
				else
					local isRemove = false
					local selectTemp = {}
					table.add(selectTemp,self.selectedInfos)
					for i,v in ipairs(selectTemp) do
						if v.cellIdx == index then 
							isRemove = true
							self:removeItem(v.cellPos,index)
						end
					end
					if not isRemove then 
						if #self.selectedInfos == 5 then
							TipDlg.drawTextDailog(tipStringInfo_fight_spirit[10])
						elseif self.maxLevTag then
							TipDlg.drawTextDailog(tipStringInfo_fight_spirit[17])
						elseif info[1] ~= 6 and info[2].lockStatus ~= 0 then
							TipDlg.drawTextDailog(tipStringInfo_fight_spirit[23])
						else
							self:addItem(index,1)
						end
					end
				end
			end
			if info[1] == 6 then
				cell:init(6,info[3],info[2],nil,nil,nil,true,nil,{callback = callback,lazy = true,cellNums = info[3]})
			else
				local fightSpirit = info[2]
				cell:init(73,nil,nil,nil,nil,nil,true,nil,{fightSpirit=fightSpirit,callback = callback,lazy = true})
			end
			cell.info = info
			cell:setPositionX((j-1) * 120)
			node:addChild(cell)
			table.insert(self.cells, cell)
		end
		listview:addChild(node)
	end
	listview:jumpToTop()
	listview:requestRefreshView()
	listview:forceDoLayout()
	-- listview:getInnerContainer():setPositionY(originPosY)

	self.currentScrollView = listview
    self.currentInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    --调用一次onUpdate
    self.currentInnerContainerPosY = self.currentInnerContainerPosY + 1
end

function FightSpiritQianghua:onUpdate(dt)
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

-- 获得战魂升级材料配置
function FightSpiritQianghua:setUpMaterialinfo()
	self.upMateriaInfo = {}
	local fightStoneInfo = zstring.split(dms.string(dms["play_config"], 228, pirates_config.param), "|")
	for i = 1,#fightStoneInfo do
		local info = zstring.split(fightStoneInfo[i], ",")
		local item = {}
		item.id = tonumber(info[2])
		item.exp = tonumber(zstring.split(info[3], ":")[2])
		self.upMateriaInfo[i] = item
	end
end

-- 获得战魂升级所需要经验
function FightSpiritQianghua:getExpInfo(quality, level)
	local row = dms.searchs(dms["fight_spirit_strengthen_mould"], fight_spirit_strengthen_mould.quality, quality, fight_spirit_strengthen_mould.cur_lev, level)[1]
	local nextLevExp = dms.atof(row,fight_spirit_strengthen_mould.next_lev_exp)
	local totalExp = dms.atof(row,fight_spirit_strengthen_mould.total_exp)
	return {totalExp, nextLevExp}
end

function FightSpiritQianghua:addItem(index,nums)
	
	local oldNum = #self.selectedInfos

	local cell = self.cells[index]
	local info = cell.info

	if ccui.Helper:seekWidgetByName(cell, "Image_xuanzhong") == nil then 
		return
	end

	if info[1] ~= 6 and info[2].lockStatus ~= 0 then
		return
	end
	
	
	ccui.Helper:seekWidgetByName(cell, "Image_xuanzhong"):setVisible(true)
	local selectSpiritInfo = {}
	selectSpiritInfo.cellPos = (oldNum + 1)
	selectSpiritInfo.cellIdx = index
	selectSpiritInfo.cellNum = nums

	table.insert(self.selectedInfos, selectSpiritInfo)

	local function callback(cellPos,cellIdx)
		self:removeItem(cellPos,cellIdx)
	end

	local newCell = ResourcesIconCell:createCell()
	newCell.info = info
	newCell.nums = nums
	if info[1] == 6 then
		newCell:init(6,selectSpiritInfo.cellNum,info[2],nil,nil,nil,true,nil,{callback = callback,selectSpiritInfo = selectSpiritInfo})
	else
		local fightSpirit = info[2]
		newCell:init(73,nil,nil,nil,nil,nil,true,nil,{callback = callback,selectSpiritInfo = selectSpiritInfo,fightSpirit=fightSpirit})
	end
	self.Panel_item:addChild(newCell)
	newCell:setPositionX(120 * (#self.selectedInfos - 1))
	table.insert(self.costCells, newCell)

	if oldNum == 0 and #self.selectedInfos > 0 then
		self.Panel_qh:setVisible(true)
		self.Button_yjtj:setVisible(false)
	end
	self:updateUI()
end

function FightSpiritQianghua:removeItem(pos,index)
	local oldNum = #self.selectedInfos

	local cell = self.cells[index]

	
	for i,v in ipairs(self.selectedInfos) do
		if v.cellPos == pos then
			for j = i + 1, #self.selectedInfos do
				local curCell = self.costCells[j]
				curCell:setPositionX(curCell:getPositionX()-120)
				self.selectedInfos[j].cellPos = self.selectedInfos[j].cellPos - 1
			end
			table.remove(self.selectedInfos, i)
			local removeCell = table.remove(self.costCells, i)
			removeCell:removeFromParent(true)
			break
		end
	end

	local showSelected = false
	for i,v in ipairs(self.selectedInfos) do
		if index == v.cellIdx then 
			showSelected = true
		end
	end
	ccui.Helper:seekWidgetByName(cell, "Image_xuanzhong"):setVisible(showSelected)

	if oldNum > 0 and #self.selectedInfos == 0 then
		self.Panel_qh:setVisible(false)
		self.Button_yjtj:setVisible(true)
	end
	self:updateUI()
end

function FightSpiritQianghua:initData()
	local unequipedFightSpirits = {}
	local allFightSpirits = FightSpiritHandle.getAllFightSpiritsList()
	for i,fightSpirit in ipairs(allFightSpirits) do
		if fightSpirit.shipId <= 0 and fightSpirit.id ~= self.fightSpiritId
			and (self.filterParams[4] == 1 or fightSpirit.quality < 5)
			and (self.filterParams[5] == 1 or fightSpirit.quality ~= 4)
			and (self.filterParams[6] == 1 or fightSpirit.quality ~= 3)
			and (self.filterParams[7] == 1 or fightSpirit.quality ~= 2)
			and (self.filterParams[8] == 1 or fightSpirit.quality ~= 1)
			then
			local awakeInfo = FightSpiritHandle.getFightSpiritAwakeInfoByQuaility(fightSpirit.quality)
			if not awakeInfo or not awakeInfo.isAwaken then
				if not self.initLockState[fightSpirit.id] then
					self.initLockState[fightSpirit.id] = fightSpirit.lockStatus
				end
				table.insert(unequipedFightSpirits, fightSpirit)
			end
		end
	end

	table.sort(unequipedFightSpirits, function (a, b)
		local aSuitId = dms.int(dms["fight_spirit_mould"], a.mouldId, fight_spirit_mould.suit_id)
		local bSuitId = dms.int(dms["fight_spirit_mould"], b.mouldId, fight_spirit_mould.suit_id)
		if self.initLockState[a.id] == 0 and self.initLockState[b.id] == 1 then
			return true
		elseif self.initLockState[a.id] == 1 and self.initLockState[b.id] == 0 then
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

	self.fightSpirits = unequipedFightSpirits
end

function FightSpiritQianghua:updateUI()
	local root = self.roots[1]

	local fightStoneExp = {}
	local fightStoneInfo = zstring.split(dms.string(dms["play_config"], 228, pirates_config.param), "|")
	for i = #fightStoneInfo ,1, -1 do
		local info = zstring.split(fightStoneInfo[i], ",")
		local id = tonumber(info[2])
		local exp = tonumber(zstring.split(info[3], ":")[2])
		fightStoneExp[id] = exp
	end

	local addExp = 0
	for i,v in ipairs(self.selectedInfos) do
		local cell = self.cells[v.cellIdx]
		local uNum = v.cellNum
		local info = cell.info
		if info[1] == 6 then
			addExp = addExp + (fightStoneExp[info[2]] * uNum)
		else
			local fightSpirit = info[2]
			addExp = addExp + fightSpirit.currentExp
			local exp = self:getExpInfo(fightSpirit.quality, fightSpirit.level)[1]
			addExp = addExp + exp
		end
	end

	local costSilver = zstring.split(dms.string(dms["play_config"], 229, pirates_config.param), ",")[3]
	ccui.Helper:seekWidgetByName(root, "Text_cost_1"):setString(addExp * tonumber(costSilver))

	local fightSpirit = FightSpiritHandle.getFightSpiritById(self.fightSpiritId)
	local exp = self:getExpInfo(fightSpirit.quality, fightSpirit.level)[1]
	local curTotalExp = fightSpirit.currentExp + exp
	local curLevel = fightSpirit.level
	local nextLevel
	local maxLevel
	local rows = dms.searchs(dms["fight_spirit_strengthen_mould"], fight_spirit_strengthen_mould.quality, fightSpirit.quality)
	for i,row in ipairs(rows) do
		maxLevel = dms.atof(row,fight_spirit_strengthen_mould.cur_lev)
		if not nextLevel and curTotalExp + addExp < dms.atof(row,fight_spirit_strengthen_mould.total_exp) then
			nextLevel = maxLevel
		end
	end

	local leftExp = 0
	local rightExp = 0

	if nextLevel then
		self.maxLevTag = false		
	else
		self.maxLevTag = true
		nextLevel = maxLevel + 1
	end

	local targetLevel = nextLevel - 1
	if targetLevel == curLevel then
		ccui.Helper:seekWidgetByName(root, "Image_up_111"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_level_up"):setVisible(false)
		for i = 1, 3 do
			ccui.Helper:seekWidgetByName(root, "Text_sx_"..i):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_upup_"..i):setVisible(false)
		end
	else
		ccui.Helper:seekWidgetByName(root, "Image_up_111"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_level_up"):setVisible(true)

		ccui.Helper:seekWidgetByName(root, "Text_level_up"):setString(targetLevel)

		local libId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.main_lib_id)
		local rows = dms.searchs(dms["fight_spirit_talent_mould"], fight_spirit_talent_mould.lib_type, 2,
			fight_spirit_talent_mould.lib_id, libId)
		local row = dms.searchs(rows, fight_spirit_talent_mould.quality, fightSpirit.quality)[1]
		local strengthAttrs = dms.atos(row, fight_spirit_talent_mould.strength_attr)
		strengthAttrs = zstring.split(strengthAttrs, "|")
		for i = 1, 3 do
			if strengthAttrs[i] then
				local attr = zstring.split(strengthAttrs[i], ":")
				local baseAttr = zstring.split(attr[1], ",")
				local strengthAttr = tonumber(attr[2])
				ccui.Helper:seekWidgetByName(root, "Text_sx_"..i):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Image_upup_"..i):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Text_sx_"..i):setString("+"..tonumber(baseAttr[2])+strengthAttr*(targetLevel-1))
			else
				ccui.Helper:seekWidgetByName(root, "Text_sx_"..i):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Image_upup_"..i):setVisible(false)
			end
		end
	end
	rightExp = self:getExpInfo(fightSpirit.quality, targetLevel)[2]
	leftExp = curTotalExp + addExp - self:getExpInfo(fightSpirit.quality, targetLevel)[1]

	if self.maxLevTag then
		ccui.Helper:seekWidgetByName(root, "Text_jdt"):setString(tipStringInfo_fight_spirit[16])
		ccui.Helper:seekWidgetByName(root, "LoadingBar_1"):setPercent(100)
	else 
		ccui.Helper:seekWidgetByName(root, "Text_jdt"):setString(leftExp .. "/" .. rightExp)
		ccui.Helper:seekWidgetByName(root, "LoadingBar_1"):setPercent(leftExp/rightExp*100)
	end

	self.targetLevel = targetLevel
	self.curLevel = curLevel
end

function FightSpiritQianghua:oneKeyAdd()
	if not FightSpiritHandle.canStrength(self.fightSpiritId) then
		TipDlg.drawTextDailog(tipStringInfo_fight_spirit[28])
		return
	end

	-- 是否有材料
	local materiaList = {}
	for i,v in ipairs(self.cells) do 
		local mType = v.info[1]
		if mType == 6 then 
			local propId = tonumber(v.info[2])
			for m,n in ipairs(self.upMateriaInfo) do
				if propId == n.id then 
					local item = {}
					item.index = i
					item.cell = v
					item.exp = n.exp
					table.insert( materiaList, item )
				end
			end
		end
	end
	
	if #materiaList > 0 then 
		local fightSpirit = FightSpiritHandle.getFightSpiritById(self.fightSpiritId)
		local expInfo = self:getExpInfo(fightSpirit.quality, fightSpirit.level)
		local totalExp = expInfo[1]
		local nextLevExp =  expInfo[2]

		local cutExp = tonumber(fightSpirit.currentExp)
		local needExp = nextLevExp - cutExp
		local curAddExp = 0
		local curSelectProp = {}
		local function addResultCallback(index,num)
			local item = {}
			item.index = index
			item.num = num
			table.insert( curSelectProp, item )
		end
		for i,v in ipairs(materiaList) do
			needExp = needExp - curAddExp
			local haveNum = tonumber(v.cell.info[3])
			local needNum = math.ceil(needExp / v.exp)
			if haveNum >= needNum then 
				-- 道具足够
				addResultCallback(v.index ,needNum)
				break
			else
				-- 道具不够
				if haveNum > 0 then 
					curAddExp = curAddExp + haveNum * v.exp
					addResultCallback(v.index,haveNum)
				end
			end
		end
		for i,v in ipairs(curSelectProp) do
			self:addItem(v.index,v.num)
		end
	else
		local idx = 1
		for i = 1, 5 do
			if self.maxLevTag then
				break
			elseif i <= #self.cells and idx <= 5 then
				local quality = self.cells[i].info[2].quality
				-- 品质1,2,3才一键添加
				if quality < 4 then 
					local nums = self.cells[i].info[3]
					if nums then 
						local cutNums = 5 - #self.selectedInfos
						local cellNums = nums > cutNums and cutNums or nums
						for j = 1,cellNums do
							self:addItem(i,1)
							idx = idx + 1
						end
					else
						if self.cells[i] then 
							self:addItem(i,1)
							idx = idx + 1
						end
					end
				end
			end
		end
	end
end

function FightSpiritQianghua:onEnterTransitionFinish()
	-- 加载FightSpiritQianghuaWindow界面资源.
	-- res.cocostudio.packs.FightSpirit_qianghua = res/packs/FightSpirit/FightSpirit_qianghua.csb
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_qianghua.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 强化等级
	self.Text_level = ccui.Helper:seekWidgetByName(root, "Text_level")

	-- 战魂名称
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")

	-- 战魂图标
	self.Panel_zh = ccui.Helper:seekWidgetByName(root, "Panel_zh")

	-- 强化进度
	self.LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")

	-- 属性加成数值1
	self.Text_shuxing_1 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_1")

	-- 属性加成数值2
	self.Text_shuxing_2 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_2")

	-- 属性加成数值3
	self.Text_shuxing_3 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_3")

	-- 属性加成数值4
	self.Text_shuxing_4 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_4")

	-- 属性加成数值5
	self.Text_shuxing_5 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_5")

	-- 属性加成数值6
	self.Text_shuxing_6 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_6")

	-- 加成属性1
	self.Text_atk_1 = ccui.Helper:seekWidgetByName(root, "Text_atk_1")

	-- 加成属性2
	self.Text_atk_2 = ccui.Helper:seekWidgetByName(root, "Text_atk_2")

	-- 加成属性3
	self.Text_atk_3 = ccui.Helper:seekWidgetByName(root, "Text_atk_3")

	-- 加成属性4
	self.Text_atk_4 = ccui.Helper:seekWidgetByName(root, "Text_atk_4")

	-- 加成属性5
	self.Text_atk_5 = ccui.Helper:seekWidgetByName(root, "Text_atk_5")

	-- 加成属性6
	self.Text_atk_6 = ccui.Helper:seekWidgetByName(root, "Text_atk_6")

	-- 强化数值提示
	self.Text_qhsj = ccui.Helper:seekWidgetByName(root, "Text_qhsj")

	-- 图标放置
	self.ListView_item = ccui.Helper:seekWidgetByName(root, "ListView_item")

	-- 战魂图标放置区
	self.ListView_zh = ccui.Helper:seekWidgetByName(root, "ListView_zh")

	-- 消耗容器
	self.Panel_item = ccui.Helper:seekWidgetByName(root, "Panel_item")
	for i = 1, 5 do
		local layout = ccui.Layout:create()
		layout:setAnchorPoint(cc.p(0, 0))
		layout:setContentSize(cc.size(120, 120))
		layout:setBackGroundImage("images/ui/quality/icon_enemy_0.png")
		layout:setPositionX(120 * (i - 1))
		self.Panel_item:addChild(layout)
	end

	-- 强化容器
	self.Panel_qh = ccui.Helper:seekWidgetByName(root, "Panel_qh")
	
	-- 一键添加按钮
	self.Button_yjtj = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yjtj"), nil,
	{
		terminal_name = "fight_spirit_qianghua_one_key_add",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 强化按钮
	self.Button_qh = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qh"), nil,
	{
		terminal_name = "fight_spirit_qianghua_qianghua",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 筛选按钮
	self.Button_sx = ccui.Helper:seekWidgetByName(root, "Button_sx")
	self.Button_sx:setPressedActionEnabled(true)
	self.Button_sx:addTouchEventListener(function (sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			state_machine.excute("fight_spirit_qianghua_sx_window_open", 0, {filterParams = self.filterParams})
		end
	end)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fight_spirit_qianghua_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	self:setUpMaterialinfo()
	self:onUpdateDraw()
end

function FightSpiritQianghua:onExit()
	-- 释放FightSpiritQianghuaWindow界面资源.
	state_machine.remove("fight_spirit_qianghua_open")
	state_machine.remove("fight_spirit_qianghua_close")
	state_machine.remove("fight_spirit_qianghua_show")
	state_machine.remove("fight_spirit_qianghua_hide")
	state_machine.remove("fight_spirit_qianghua_one_key_add")
	state_machine.remove("fight_spirit_qianghua_qianghua")
	state_machine.remove("fight_spirit_qianghua_filter")
	state_machine.remove("fight_spirit_qianghua_lock_refresh")
end

function FightSpiritQianghua:close()
	-- window event : close.
	
end

function FightSpiritQianghua:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
