--[[ ----------------------------------------------------------------------------
-- 类型按钮
--]] ----------------------------------------------------------------------------
CommonOrderTypeTabList = class("CommonOrderTypeTabListClass", Window)
CommonOrderTypeTabList.__size = nil

-- 创建Cell实例
local common_order_type_tab_list_create_terminal = {
	_name = "common_order_type_tab_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CommonOrderTypeTabList then
			local cell = CommonOrderTypeTabList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(common_order_type_tab_list_create_terminal)
state_machine.init()

-- 构造器
function CommonOrderTypeTabList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._typeInfo = {}
    self.curType = 0
    self.curStageNums = 0

	-- load lua files.

	-- Initialize lim pool record list page state machine.
	local function init_common_order_type_tab_list_terminal()
		
	end
	-- call func init lim pool record list state machine.
	init_common_order_type_tab_list_terminal()
end

function CommonOrderTypeTabList:onUpdateDraw()
    self.curType = self._typeInfo.curType
    self.curStageNums = self._typeInfo.stageNums
    local typeString = ""
    if self.curType == 1 then
        typeString = war_order_str[1]
    elseif self.curType == 2 then
        typeString = war_order_str[2]
    elseif self.curType == 3 then
        typeString = war_order_str[3]
    elseif self.curType == 4 then
        typeString = war_order_str[4]
    end
    self.Text_type_1:setString(typeString)
    self.Text_type_2:setString(typeString)
end

-- 对象初始化
function CommonOrderTypeTabList:init(params)
	self._typeInfo = params
    if nil ~= self.onInit then
	    self:onInit(params)
    end
	self:setContentSize(CommonOrderTypeTabList.__size)
	return self
end

function CommonOrderTypeTabList:onInit(params)

	-- [[ 使用缓存创建
	local root = cacher.createUIRef("utils/common_paging_1_tab.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CommonOrderTypeTabList.__size == nil then
		CommonOrderTypeTabList.__size = root:getContentSize()
	end

    self.Text_type_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    self.Text_type_2 = ccui.Helper:seekWidgetByName(root, "Text_2")

    self:onUpdateDraw()
end

function CommonOrderTypeTabList:onExit()
	-- 释放LimPoolRecordListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("utils/common_paging_1_tab.csb", root)
	-- ]]
end

function CommonOrderTypeTabList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CommonOrderTypeTabList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("utils/common_paging_1_tab.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
