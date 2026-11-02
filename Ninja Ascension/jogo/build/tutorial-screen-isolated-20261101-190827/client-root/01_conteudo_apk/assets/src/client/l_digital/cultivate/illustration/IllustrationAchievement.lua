--[[ ----------------------------------------------------------------------------
-- 卡册评分成就窗口
--]] ----------------------------------------------------------------------------
IllustrationAchievement = class("IllustrationAchievementClass", Window)

-- 打开窗口
local illustration_achievement_window_open_terminal = {
	_name = "illustration_achievement_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("IllustrationAchievementClass") then
			fwin:open(IllustrationAchievement:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local illustration_achievement_window_close_terminal = {
	_name = "illustration_achievement_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("IllustrationAchievementClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_achievement_window_open_terminal)
state_machine.add(illustration_achievement_window_close_terminal)
state_machine.init()

-- 构造器
function IllustrationAchievement:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.l_digital.cells.cultivate.illustration.illustration_achievement_list")
	-- Initialize illustration achievement page state machine.
	local function init_illustration_achievement_terminal()
		-- 打开角色创建窗口
		local illustration_achievement_open_terminal = {
			_name = "illustration_achievement_open",
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
		local illustration_achievement_close_terminal = {
			_name = "illustration_achievement_close",
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

		-- 显示窗口
		local illustration_achievement_show_terminal = {
			_name = "illustration_achievement_show",
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
		local illustration_achievement_hide_terminal = {
			_name = "illustration_achievement_hide",
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

		state_machine.add(illustration_achievement_open_terminal)
		state_machine.add(illustration_achievement_close_terminal)
		state_machine.add(illustration_achievement_show_terminal)
		state_machine.add(illustration_achievement_hide_terminal)
		state_machine.init()
	end
	-- call func init illustration achievement state machine.
	init_illustration_achievement_terminal()
end

-- 对象初始化
function IllustrationAchievement:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function IllustrationAchievement:onUpdateDraw()
	local root = self.roots[1]

	-- 卡册评分成就列表
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
	self.ListView_1:removeAllItems()
	local normalAdd,totalScore,totalAdd = IllustrationHandle.getAchieveByServer()
	local achieveData = IllustrationHandle.getAllAchieveAdd()
	local curindex = 2
	local height = nil

	for i, v in ipairs(achieveData) do
		local haveAim = false
		if v.markData <= totalScore then
			curindex = curindex + 1
			haveAim = true
		end
		local cell = state_machine.excute("illustration_achievement_list_create", 0, {data = v, haveAim = haveAim, index = i})
		if nil == height then
			height = cell:getContentSize().height
		end
		self.ListView_1:addChild(cell)
	end
	
	
	self.currentInnerContainer = self.ListView_1:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	
	self:runAction(cc.Sequence:create({cc.DelayTime:create(0.01), cc.CallFunc:create(function ( sender )
		self.currentInnerContainer:setPositionY(-height * (#achieveData - curindex) - (height / 2) + 8)
		self.ListView_1:requestRefreshView()
	end)}))

	self.ListView_1_poy = self.currentInnerContainerPosY
	self.ListView_1:requestRefreshView()
end

function IllustrationAchievement:onEnterTransitionFinish()
	-- 加载IllustrationAchievementWindow界面资源.
	-- res.cultivate.illustration.illustration_achievement = res/cultivate/illustration/illustration_achievement.csb
	local csbNode = csb.createNode("cultivate/illustration/illustration_achievement.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "illustration_achievement_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

-- @onUpdate(dt)
function IllustrationAchievement:onUpdate(dt)
	if self.ListView_1 ~= nil then
		local size = self.ListView_1:getContentSize()
		local posY = self.ListView_1:getInnerContainer():getPositionY()
		if self.ListView_1_poy == posY then
			return
		end
		self.ListView_1_poy = posY
		local items = self.ListView_1:getItems()
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

function IllustrationAchievement:onExit()
	-- 释放IllustrationAchievementWindow界面资源.
	state_machine.remove("illustration_achievement_open")
	state_machine.remove("illustration_achievement_close")
	state_machine.remove("illustration_achievement_show")
	state_machine.remove("illustration_achievement_hide")
end

function IllustrationAchievement:close()
	-- window event : close.
	
end

function IllustrationAchievement:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
