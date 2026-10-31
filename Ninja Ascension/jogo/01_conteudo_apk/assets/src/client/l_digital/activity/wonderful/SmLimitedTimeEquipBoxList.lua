--[[ ----------------------------------------------------------------------------
-- 奖励列表项
--]] ----------------------------------------------------------------------------
SmLimitedTimeEquipBoxList = class("SmLimitedTimeEquipBoxListClass", Window)
SmLimitedTimeEquipBoxList.__size = nil

-- 创建Cell实例
local sm_limited_time_equip_box_list_create_terminal = {
	_name = "sm_limited_time_equip_box_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if SmLimitedTimeEquipBoxList then
			local cell = SmLimitedTimeEquipBoxList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_limited_time_equip_box_list_create_terminal)
state_machine.init()

-- 构造器
function SmLimitedTimeEquipBoxList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	local function init_sm_limited_time_equip_box_list_terminal()

	end
	init_sm_limited_time_equip_box_list_terminal()
end

-- 对象初始化
function SmLimitedTimeEquipBoxList:init(params)
    self.rewardInfo = params.rewardInfo
    self.rankGear = params.rankGear
    self.needPointNum = params.needPointNum
	if nil ~= self.onInit then
		self:onInit(params)
	end
	self:setContentSize(SmLimitedTimeEquipBoxList.__size)
	return self
end

function SmLimitedTimeEquipBoxList:initDrawUI()
    -- 排名挡位
    local gearString = nil
    local gearStringInfo = zstring.split(self.rankGear, '-')
    if gearStringInfo[1] == gearStringInfo[2] then
        gearString = gearStringInfo[1]
    else
        gearString = self.rankGear
    end
    self.Text_1:setString(_string_piece_info[2] .. gearString)

    self.Text_2:setString(self.needPointNum)

    for i, v in ipairs(self.rewardInfo) do
        local cell = DrawHandle.drawIcon(v)
        self.ListView_1:addChild(cell)
    end

    self.ListView_1:requestRefreshView()
    self.ListView_1:jumpToLeft()
end

function SmLimitedTimeEquipBoxList:onUpdateDraw()
	local root = self.roots[1]
    -- 排名挡位
    self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    -- 最小达到积分数
    self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
    -- 奖励ICON容器
    self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
end

function SmLimitedTimeEquipBoxList:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end
    -- 排名挡位
    local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    Text_1:setString("")
    -- 最小达到积分数
    local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
    Text_2:setString("")
    -- 奖励ICON容器
    local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    ListView_1:removeAllItems()
end

function SmLimitedTimeEquipBoxList:onEnterTransitionFinish()
	
end

function SmLimitedTimeEquipBoxList:onInit(params)
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/wonderful/sm_limited_time_equip_box_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/wonderful/sm_limited_time_equip_box_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if SmLimitedTimeEquipBoxList.__size == nil then
		SmLimitedTimeEquipBoxList.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
    self:initDrawUI()
end

function SmLimitedTimeEquipBoxList:onExit()
	-- 释放SmLimitedTimeEquipBoxList界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/wonderful/sm_limited_time_equip_box_list.csb", root)
	-- ]]
end

function SmLimitedTimeEquipBoxList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmLimitedTimeEquipBoxList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/wonderful/sm_limited_time_equip_box_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
