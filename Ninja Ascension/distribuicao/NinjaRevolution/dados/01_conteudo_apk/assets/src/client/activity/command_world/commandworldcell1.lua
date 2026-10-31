--[[ ----------------------------------------------------------------------------
-- 展开区域
--]] ----------------------------------------------------------------------------
CommandWorldCell1 = class("CommandWorldCell1Class", Window)
CommandWorldCell1.__size = nil

-- 创建Cell实例
local command_world_cell1_create_terminal = {
	_name = "command_world_cell1_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CommandWorldCell1 then
			local cell = CommandWorldCell1:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_cell1_create_terminal)
state_machine.init()

-- 构造器
function CommandWorldCell1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize command world cell1 page state machine.
	local function init_command_world_cell1_terminal()
		-- 上推
		local command_world_cell1_up_terminal = {
			_name = "command_world_cell1_up",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:upList()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 下推
		local command_world_cell1_down_terminal = {
			_name = "command_world_cell1_down",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:downList()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(command_world_cell1_up_terminal)
		state_machine.add(command_world_cell1_down_terminal)
	end
	-- call func init command world cell1 state machine.
	init_command_world_cell1_terminal()
end

-- 对象初始化
function CommandWorldCell1:init(params)
	self._isCrossServer = params.isCrossServer

	self:onInit(params)
	self:setContentSize(CommandWorldCell1.__size)
	return self
end

function CommandWorldCell1:updateUI()
	self.Button_2:setVisible(false)
	self.Panel_2:setVisible(false)

	self.Button_1:setVisible(true)
	self.Panel_1:setVisible(true)

	self:updateRunHorseList()
end

function CommandWorldCell1:downList()
	local instance = self

	local action = self.actions[1]
	action:play("animation_con_1", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "exit_1" then
        	self.Button_2:setVisible(true)
			self.Panel_2:setVisible(true)

			self.Button_1:setVisible(false)
			self.Panel_1:setVisible(false)
            instance:updateRankList()
        end
    end)
end

function CommandWorldCell1:upList()
	local instance = self

	local action = self.actions[1]
	action:play("animation_con_2", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "exit_2" then
        	self.Button_2:setVisible(false)
			self.Panel_2:setVisible(false)

			self.Button_1:setVisible(true)
			self.Panel_1:setVisible(true)
            instance:updateRunHorseList()
        end
    end)
end

-- 绘制跑马灯列表
function CommandWorldCell1:updateRunHorseList()
	local isCrossServer = self._isCrossServer
	-- 默认捐献跑马灯（不分本服跨服，服务器实时推送）
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	local ListView_2 = self.ListView_2
	ListView_2:removeAllItems()

	self.Panel_1:setScaleY(1)

	local horseInfo = CommandWorldHandle.getCommandWorldRunHorseInfo()
	for i, v in ipairs(horseInfo) do
		local cell = state_machine.excute("command_world_cell10_create", 0, {index = i, isCrossServer = isCrossServer, data = v})
		ListView_1:addChild(cell)
	end

	self.ListView_1_poy = self.ListView_1:getInnerContainer():getPositionY()
	ListView_1:jumpToTop()
	ListView_1:requestRefreshView()
end

-- 绘制排行榜列表
function CommandWorldCell1:updateRankList()
	local isCrossServer = self._isCrossServer

	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	local ListView_2 = self.ListView_2
	ListView_2:removeAllItems()

	self.Panel_2:setScaleY(1)

	local rankInfo = CommandWorldHandle.getCommandWorldAllRankInfo()
	for i, v in ipairs(rankInfo) do
		local cell = state_machine.excute("command_world_cell2_create", 0, {index = i, isCrossServer = isCrossServer, data = v})
		ListView_2:addChild(cell)
	end

	self.ListView_2_poy = self.ListView_2:getInnerContainer():getPositionY()
	ListView_2:jumpToTop()
	ListView_2:requestRefreshView()
end

function CommandWorldCell1:onUpdateDraw()
	local root = self.roots[1]

	-- 捐献记录
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	-- 排行榜
	self.ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")

	self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
	self.Panel_1:setTouchEnabled(false)

	self.Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
	self.Panel_2:setTouchEnabled(false)

	-- 展开排名（下推）
	self.Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "command_world_cell1_down",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 收起排名（上推）
	self.Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
	{
		terminal_name = "command_world_cell1_up",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:updateUI()
end

-- @onUpdate(dt)
function CommandWorldCell1:onUpdate(dt)
	-- if self.ListView_1 ~= nil then
	-- 	local size = self.ListView_1:getContentSize()
	-- 	local posY = self.ListView_1:getInnerContainer():getPositionY()
	-- 	if self.ListView_1_poy == posY then
	-- 		return
	-- 	end
	-- 	self.ListView_1_poy = posY
	-- 	local items = self.ListView_1:getItems()
	-- 	if items[1] == nil then
	-- 		return
	-- 	end
	-- 	local itemSize = items[1]:getContentSize()
	-- 	for i, v in pairs(items) do
	-- 		local tempY = v:getPositionY() + posY
	-- 		if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then	
	-- 			v:unload()
	-- 		else	
	-- 			v:reload()				
	-- 		end
	-- 	end
	-- end

	-- if self.ListView_2 ~= nil then
	-- 	local size = self.ListView_2:getContentSize()
	-- 	local posY = self.ListView_2:getInnerContainer():getPositionY()
	-- 	if self.ListView_2_poy == posY then
	-- 		return
	-- 	end
	-- 	self.ListView_2_poy = posY
	-- 	local items = self.ListView_2:getItems()
	-- 	if items[1] == nil then
	-- 		return
	-- 	end
	-- 	local itemSize = items[1]:getContentSize()
	-- 	for i, v in pairs(items) do
	-- 		local tempY = v:getPositionY() + posY
	-- 		if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then	
	-- 			v:unload()
	-- 		else	
	-- 			v:reload()				
	-- 		end
	-- 	end
	-- end
end


function CommandWorldCell1:onEnterTransitionFinish()
	
end

function CommandWorldCell1:onInit(params)
	-- 加载CommandWorldCell1Window界面资源.
	-- res.activity.command_world.command_world_cell_1 = res/activity/command_world/command_world_cell_1.csb
 	-- 不使用缓存创建
	local csbNode = csb.createNode("activity/command_world/command_world_cell_1.csb")
	local root = csbNode:getChildByName("root")
	
	-- [[ 使用缓存创建
	-- local root = cacher.createUIRef("activity/command_world/command_world_cell_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if CommandWorldCell1.__size == nil then
		CommandWorldCell1.__size = root:getContentSize()
	end

	local action = csb.createTimeline("activity/command_world/command_world_cell_1.csb")
    table.insert(self.actions, action)
    root:runAction(action)

	self:onUpdateDraw()
end

function CommandWorldCell1:onExit()
	-- 释放CommandWorldCell1Window界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	-- cacher.freeRef("activity/command_world/command_world_cell_1.csb", root)
	-- ]]
end

function CommandWorldCell1:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function CommandWorldCell1:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	-- cacher.freeRef("activity/command_world/command_world_cell_1.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
