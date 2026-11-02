--[[ ----------------------------------------------------------------------------
-- 奖励列表页面
--]] ----------------------------------------------------------------------------
FortuneBagRewardList1 = class("FortuneBagRewardList1Class", Window)
FortuneBagRewardList1.__size = nil

-- 创建Cell实例
local fortune_bag_reward_list1_create_terminal = {
	_name = "fortune_bag_reward_list1_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FortuneBagRewardList1 then
			local cell = FortuneBagRewardList1:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
        	cell:registerOnNoteUpdate(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fortune_bag_reward_list1_create_terminal)
state_machine.init()

-- 构造器
function FortuneBagRewardList1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._match_datas = nil
	-- load lua files.
	app.load("client.activity.fortune_bag.fortunebagrewardlist3")	
	-- Initialize fortune bag reward list1 page state machine.
	local function init_fortune_bag_reward_list1_terminal()
		
	end
	-- call func init fortune bag reward list1 state machine.
	init_fortune_bag_reward_list1_terminal()
end

-- 对象初始化
function FortuneBagRewardList1:init(params)
	self:onInit(params)
	self:setContentSize(FortuneBagRewardList1.__size)
	return self
end

function FortuneBagRewardList1:onUpdateDraw()
	local root = self.roots[1]
	local Panel_list_2 = ccui.Helper:seekWidgetByName(root, "Panel_list_2")
	Panel_list_2:removeAllChildren(true)
	
	local horizontalNumber = 1
	local panelSize = Panel_list_2:getContentSize()
	local cellSize = state_machine.excute("fortune_bag_reward_list3_create",0,"").class.__size
	local lines = 0
	for k,v in pairs(self._match_datas) do
		lines = lines +1
	end

	Panel_list_2:setContentSize(cc.size(panelSize.width,cellSize.height * lines ))
	Panel_list_2:setAnchorPoint(cc.p(0,0))
	Panel_list_2:setPosition(cc.p(0,0))
	FortuneBagRewardList1.__size = Panel_list_2:getContentSize()
	local tWidth = 0
	local tHeight = 0

	local sHeight = Panel_list_2:getContentSize().height
	local cellHeight = cellSize.height
	
	local index = 1
	for k,v in pairs(self._match_datas) do
		local cell = state_machine.excute("fortune_bag_reward_list3_create",0,{v})
		cell:setAnchorPoint(cc.p(0,0))
		tHeight = sHeight - (cellHeight)*index
		index = index + 1
		cell:setPosition(cc.p(tWidth, tHeight))
		Panel_list_2:addChild(cell)
	end
	local ss = Panel_list_2:getContentSize()

end

function FortuneBagRewardList1:onEnterTransitionFinish()
	
end

function FortuneBagRewardList1:onInit(params)
	self._match_datas = params[1]
	-- 加载FortuneBagRewardList1Window界面资源.
	-- res.activity.fortune_bag.fortune_bag_reward_list_1 = res/activity/fortune_bag/fortune_bag_reward_list_1.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/fortune_bag/fortune_bag_reward_list_1.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/fortune_bag/fortune_bag_reward_list_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	self:clearUIInfo()
	if FortuneBagRewardList1.__size == nil then
		FortuneBagRewardList1.__size = ccui.Helper:seekWidgetByName(root, "Panel_list_2"):getContentSize()
	end

	self:onUpdateDraw()
end

function FortuneBagRewardList1:onExit()
	-- 释放FortuneBagRewardList1Window界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/fortune_bag/fortune_bag_reward_list_1.csb", root)
	-- ]]
end

function FortuneBagRewardList1:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:registerOnNoteUpdate(self)
	self:onInit()
end

function FortuneBagRewardList1:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/fortune_bag/fortune_bag_reward_list_1.csb", root)
	
	self.roots = {}
end

function FortuneBagRewardList1:clearUIInfo()
	local root = self.roots[1]
	if root == nil then
        return
    end
	if root._x ~= nil then
        root:setPositionX(root._x)
    end
    if root._y ~= nil then
        root:setPositionY(root._y)
    end
	local Panel_list_2 = ccui.Helper:seekWidgetByName(root, "Panel_list_2")
	Panel_list_2:removeAllChildren()

end

-- ~END
-- ----------------------------------------------------------------------------
