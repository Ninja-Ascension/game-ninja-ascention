--[[ ----------------------------------------------------------------------------
-- 排名展示
--]] ----------------------------------------------------------------------------
CommandWorldCell2 = class("CommandWorldCell2Class", Window)
CommandWorldCell2.__size = nil

-- 创建Cell实例
local command_world_cell2_create_terminal = {
	_name = "command_world_cell2_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CommandWorldCell2 then
			local cell = CommandWorldCell2:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_cell2_create_terminal)
state_machine.init()

-- 构造器
function CommandWorldCell2:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize command world cell2 page state machine.
	local function init_command_world_cell2_terminal()
		
	end
	-- call func init command world cell2 state machine.
	init_command_world_cell2_terminal()
end

-- 对象初始化
function CommandWorldCell2:init(params)
	self._index = params.index
	self._isCrossServer = params.isCrossServer
	self._data = params.data

	if self._index < 9 then
		self:onInit(params)
	end
	self:setContentSize(CommandWorldCell2.__size)
	return self
end

function CommandWorldCell2:updateUI()
	self.Text_rank:setString(self._data.rankNumber)

	local rankInfo = self._data.rankInfo
	local serverNumber = GetServerNameByServerNumber(rankInfo.serverNumber)

	local guildName = self._isCrossServer and ("(" .. serverNumber .. ")") or rankInfo.unionName
	self.Text_server:setString(guildName)

	self.Text_name:setString(rankInfo.nickName)
	
	self.Text_point:setString(rankInfo.score)
end

function CommandWorldCell2:onUpdateDraw()
	local root = self.roots[1]

	self.Text_rank = ccui.Helper:seekWidgetByName(root, "Text_rank")

	self.Text_server = ccui.Helper:seekWidgetByName(root, "Text_server")

	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")

	self.Text_point = ccui.Helper:seekWidgetByName(root, "Text_point")

	self:updateUI()
end

function CommandWorldCell2:onEnterTransitionFinish()
	
end

function CommandWorldCell2:onInit(params)
	-- 加载CommandWorldCell2Window界面资源.
	-- res.activity.command_world.command_world_cell_2 = res/activity/command_world/command_world_cell_2.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("activity/command_world/command_world_cell_2.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/command_world/command_world_cell_2.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CommandWorldCell2.__size == nil then
		CommandWorldCell2.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function CommandWorldCell2:onExit()
	-- 释放CommandWorldCell2Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/command_world/command_world_cell_2.csb", root)
	-- ]]
end

function CommandWorldCell2:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CommandWorldCell2:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/command_world/command_world_cell_2.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
