--[[ ----------------------------------------------------------------------------
-- 贡献展示
--]] ----------------------------------------------------------------------------
CommandWorldCell10 = class("CommandWorldCell10Class", Window)
CommandWorldCell10.__size = nil

-- 创建Cell实例
local command_world_cell10_create_terminal = {
	_name = "command_world_cell10_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CommandWorldCell10 then
			local cell = CommandWorldCell10:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_cell10_create_terminal)
state_machine.init()

-- 构造器
function CommandWorldCell10:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize command world cell10 page state machine.
	local function init_command_world_cell10_terminal()
		
	end
	-- call func init command world cell10 state machine.
	init_command_world_cell10_terminal()
end

-- 对象初始化
function CommandWorldCell10:init(params)
	self._index = params.index
	self._isCrossServer = params.isCrossServer
	self._data = params.data

	-- if self._index < 9 then
		self:onInit(params)
	-- end
	self:setContentSize(CommandWorldCell10.__size)
	return self
end

function CommandWorldCell10:updateUI()
	local serverNumber = GetServerNameByServerNumber(self._data.serverNumber)

	local guildName = self._isCrossServer and ("(" .. serverNumber .. ")") or self._data.unionName
	self.Text_guild:setString(guildName)

	self.Text_name:setString(self._data.nickName)
	
	local donatePropStr = zstring.splits(self._data.noticeContent, "|", ",")
	local donatePropId = tonumber(donatePropStr[1][2])
	local donatePropCount = tonumber(donatePropStr[1][3])

	local name = setThePropsIcon(donatePropId)[2]
	self.Text_daoju:setString(name .. "*" .. donatePropCount)
end

function CommandWorldCell10:onUpdateDraw()
	local root = self.roots[1]

	self.Text_guild = ccui.Helper:seekWidgetByName(root, "Text_guild")

	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")

	self.Text_daoju = ccui.Helper:seekWidgetByName(root, "Text_daoju")

	self:updateUI()
end

function CommandWorldCell10:onEnterTransitionFinish()
	
end

function CommandWorldCell10:onInit(params)
	-- 加载CommandWorldCell10Window界面资源.
	-- res.activity.command_world.command_world_cell_1_0 = res/activity/command_world/command_world_cell_1_0.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/command_world/command_world_cell_1_0.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/command_world/command_world_cell_1_0.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CommandWorldCell10.__size == nil then
		CommandWorldCell10.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function CommandWorldCell10:onExit()
	-- 释放CommandWorldCell10Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/command_world/command_world_cell_1_0.csb", root)
	-- ]]
end

function CommandWorldCell10:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CommandWorldCell10:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/command_world/command_world_cell_1_0.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
