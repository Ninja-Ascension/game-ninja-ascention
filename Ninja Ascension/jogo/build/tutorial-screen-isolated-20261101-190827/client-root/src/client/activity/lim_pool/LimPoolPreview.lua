--[[ ----------------------------------------------------------------------------
-- 奖励预览
--]] ----------------------------------------------------------------------------
LimPoolPreview = class("LimPoolPreviewClass", Window)

-- 打开窗口
local lim_pool_preview_window_open_terminal = {
	_name = "lim_pool_preview_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("LimPoolPreviewClass") then
			fwin:open(LimPoolPreview:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local lim_pool_preview_window_close_terminal = {
	_name = "lim_pool_preview_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("LimPoolPreviewClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(lim_pool_preview_window_open_terminal)
state_machine.add(lim_pool_preview_window_close_terminal)
state_machine.init()

-- 构造器
function LimPoolPreview:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	self._activityType = 0					-- 当前活动类型

	-- var
	self.currentScrollView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0

	-- load lua files.
	app.load("client.cells.prop.sm_packs_cell")
	app.load("client.cells.utils.resources_icon_cell")

	-- Initialize lim pool preview page state machine.
	local function init_lim_pool_preview_terminal()
		-- 打开角色创建窗口
		local lim_pool_preview_open_terminal = {
			_name = "lim_pool_preview_open",
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
		local lim_pool_preview_close_terminal = {
			_name = "lim_pool_preview_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("lim_pool_preview_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local lim_pool_preview_show_terminal = {
			_name = "lim_pool_preview_show",
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
		local lim_pool_preview_hide_terminal = {
			_name = "lim_pool_preview_hide",
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

		state_machine.add(lim_pool_preview_open_terminal)
		state_machine.add(lim_pool_preview_close_terminal)
		state_machine.add(lim_pool_preview_show_terminal)
		state_machine.add(lim_pool_preview_hide_terminal)
		state_machine.init()
	end
	-- call func init lim pool preview state machine.
	init_lim_pool_preview_terminal()
end

-- 对象初始化
function LimPoolPreview:init(params)
	self._activityType = params[1]
	self._info = _ED.active_activity[self._activityType].info
	return self
end

function LimPoolPreview:getOtherRewards()
	local tempStr = self._info.normalRewards
	local otherRewards = zstring.splits(tempStr, "|", ",")
	return otherRewards
end

function LimPoolPreview:getSpecialRewards()
	local tempStr = self._info.specialRewards
	local specialRewards = zstring.splits(tempStr, "|", ",")
	return specialRewards
end

function LimPoolPreview:updateSpecialList()
	local ListView_preview = self.ListView_preview
	ListView_preview:removeAllItems()

	local tSortedHeroes = self:getSpecialRewards()
	for _, v in pairs(tSortedHeroes) do
		local cell = self:addResourcesIconCell(v)
		ListView_preview:addChild(cell)
	end

	ListView_preview:jumpToLeft()
	ListView_preview:requestRefreshView()
end

function LimPoolPreview:updateNormalScrollView()
	local tSortedHeroes = self:getOtherRewards()

	local m_ScrollView = self.ScrollView_preview
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
	local number = #tSortedHeroes
	local m_number = math.ceil(number/5)

	cellHeight = m_number*(m_ScrollView:getContentSize().width/5)

	sHeight = math.max(sHeight, cellHeight)
	panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
	local first = nil
	for j, v in pairs(tSortedHeroes) do
		local cell = self:addResourcesIconCell(v)
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
		if j <= 5 then
			tHeight = sHeight - wPosition
		end
		cell:setPosition(cc.p(tWidth,tHeight))
	end
	m_ScrollView:jumpToTop()

	self.currentScrollView = m_ScrollView
	self.currentInnerContainer = self.currentScrollView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function LimPoolPreview:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end

function LimPoolPreview:onUpdateDraw()
	local root = self.roots[1]

	-- 特别奖励列表
	self.ListView_preview = ccui.Helper:seekWidgetByName(root, "ListView_preview")

	-- 全部奖励容器（每排6个，间距参照背包）
	self.ScrollView_preview = ccui.Helper:seekWidgetByName(root, "ScrollView_preview")


	self:updateSpecialList()
	self:updateNormalScrollView()
end

function LimPoolPreview:onUpdate(dt)
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

function LimPoolPreview:onEnterTransitionFinish()
	-- 加载LimPoolPreviewWindow界面资源.
	-- res.activity.lim_pool.lim_pool_preview = res/activity/lim_pool/lim_pool_preview.csb
	local csbNode = csb.createNode("activity/lim_pool/lim_pool_preview.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "lim_pool_preview_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function LimPoolPreview:onExit()
	-- 释放LimPoolPreviewWindow界面资源.
	state_machine.remove("lim_pool_preview_open")
	state_machine.remove("lim_pool_preview_close")
	state_machine.remove("lim_pool_preview_show")
	state_machine.remove("lim_pool_preview_hide")
end

function LimPoolPreview:close()
	-- window event : close.
	
end

function LimPoolPreview:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
