--[[ ----------------------------------------------------------------------------
-- 历史记录列表项
--]] ----------------------------------------------------------------------------
RichmanRewardRecordList = class("RichmanRewardRecordListClass", Window)
RichmanRewardRecordList.__size = nil

-- 创建Cell实例
local richman_reward_record_list_create_terminal = {
	_name = "richman_reward_record_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RichmanRewardRecordList then
			local cell = RichmanRewardRecordList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}


state_machine.add(richman_reward_record_list_create_terminal)
state_machine.init()

-- 构造器
function RichmanRewardRecordList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.recordInfo = nil

	-- load lua files.

	-- Initialize RichmanRewardRecordList page state machine.
	local function init_richman_reward_record_list_terminal()
		
	end
	-- call func init RichmanRewardRecordList state machine.
	init_richman_reward_record_list_terminal()
end

function RichmanRewardRecordList:updateDrawContent()
    self.Panel_icon:removeAllChildren(true)

    local curRewardInfo = zstring.split(self.recordInfo.rewardInfo, ",", function ( value ) return tonumber(value) end)
    
    local rewardCell = DrawHandle.drawIcon(curRewardInfo)
    local propInfo = getItemNameAndQuality(curRewardInfo)
	local propText = propInfo[1]
    local timeString = (self.recordInfo.getRewardTime1.." "..self.recordInfo.getRewardTime2)

    self.Panel_icon:addChild(rewardCell)
    self.Text_1:setString(propText)
    self.Text_2:setString(timeString)
end

function RichmanRewardRecordList:onUpdateDraw()
	local root = self.roots[1]

	-- 道具容器
	self.Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
	-- 道具名称
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	-- 获奖日期
	self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")

	self:updateDrawContent()
end

-- 对象初始化
function RichmanRewardRecordList:init(params)
	self.recordInfo = params[1]
	self:onInit(params)
	self:setContentSize(RichmanRewardRecordList.__size)
	return self
end

function RichmanRewardRecordList:onEnterTransitionFinish()
	
end

function RichmanRewardRecordList:onInit(params)
	-- 加载Richmanreward_recordList界面资源.
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/dafuweng/dafuweng_jilv_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/dafuweng/dafuweng_jilv_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RichmanRewardRecordList.__size == nil then
		RichmanRewardRecordList.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function RichmanRewardRecordList:onExit()
	-- 释放Richmanreward_recordList界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/dafuweng/dafuweng_jilv_list.csb", root)
	-- ]]
end

function RichmanRewardRecordList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RichmanRewardRecordList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/dafuweng/dafuweng_jilv_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
