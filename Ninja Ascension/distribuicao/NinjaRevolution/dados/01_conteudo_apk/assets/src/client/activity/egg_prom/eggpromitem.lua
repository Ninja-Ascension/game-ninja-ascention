--[[ ----------------------------------------------------------------------------
-- 彩蛋奖励预览控件
--]] ----------------------------------------------------------------------------
EggPromItem = class("EggPromItemClass", Window)
EggPromItem.__size = nil

-- 创建Cell实例
local egg_prom_item_create_terminal = {
	_name = "egg_prom_item_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if EggPromItem then
			local cell = EggPromItem:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(egg_prom_item_create_terminal)
state_machine.init()

-- 构造器
function EggPromItem:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._data = nil
	self._odds = 0

	-- load lua files.

	-- Initialize egg prom task list page state machine.
	local function init_egg_prom_item_terminal()

	end
	-- call func init egg prom task list state machine.
	init_egg_prom_item_terminal()
end

-- 对象初始化
function EggPromItem:init(params)
	self._data = params.rewardData
	self._odds = tonumber(params.odds)

	self:onInit(params)
	self:setContentSize(EggPromItem.__size)
	return self
end

function EggPromItem:updateUI()
	local Panel_prop = self.Panel_prop
	Panel_prop:removeAllChildren(true)
	Panel_prop:setVisible(true)

	local cell = self:addResourcesIconCell(self._data)
	Panel_prop:addChild(cell)

	self.Label_1:setString(string.format("%0.2f", (self._odds * 100)) .. "%")
end

function EggPromItem:addResourcesIconCell(propData)
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

function EggPromItem:onUpdateDraw()
	local root = self.roots[1]

	-- 成就任务名称
	self.Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")

	-- 概率
	self.Label_1 = ccui.Helper:seekWidgetByName(root, "Label_1")

	self:updateUI()
end

function EggPromItem:onEnterTransitionFinish()
	
end

function EggPromItem:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	self.Panel_prop:removeAllChildren(true)

	self.Label_1 = ccui.Helper:seekWidgetByName(root, "Label_1")
	self.Label_1:setString("")
end

function EggPromItem:onInit(params)
	-- 加载EggPromItemWindow界面资源.
	-- res.activity.egg_prom.egg_prom_item = res/activity/egg_prom/egg_prom_item.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/egg_prom/egg_prom_item.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/egg_prom/egg_prom_item.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if EggPromItem.__size == nil then
		EggPromItem.__size = root:getContentSize()
	end

	self:clearUIInfo()
	self:onUpdateDraw()
end

function EggPromItem:onExit()
	-- 释放EggPromItemWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/egg_prom/egg_prom_item.csb", root)
	-- ]]
end

function EggPromItem:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function EggPromItem:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/egg_prom/egg_prom_item.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
