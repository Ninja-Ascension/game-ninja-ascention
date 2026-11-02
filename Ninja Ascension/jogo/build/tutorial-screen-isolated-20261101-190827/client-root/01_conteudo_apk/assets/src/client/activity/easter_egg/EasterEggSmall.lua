--[[ ----------------------------------------------------------------------------
-- 小游戏结算迪路兽气泡框界面
--]] ----------------------------------------------------------------------------
EasterEggSmall = class("EasterEggSmallClass", Window)

-- 打开窗口
local easter_egg_small_window_open_terminal = {
	_name = "easter_egg_small_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("EasterEggSmallClass") then
			fwin:open(EasterEggSmall:new():init(params), fwin._notification)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local easter_egg_small_window_close_terminal = {
	_name = "easter_egg_small_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("EasterEggSmallClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(easter_egg_small_window_open_terminal)
state_machine.add(easter_egg_small_window_close_terminal)
state_machine.init()

-- 构造器
function EasterEggSmall:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._egg_info = nil -- 当前彩蛋模版信息
	-- load lua files.

	-- Initialize easter egg small page state machine.
	local function init_easter_egg_small_terminal()
		-- 打开角色创建窗口
		local easter_egg_small_open_terminal = {
			_name = "easter_egg_small_open",
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
		local easter_egg_small_close_terminal = {
			_name = "easter_egg_small_close",
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
		local easter_egg_small_show_terminal = {
			_name = "easter_egg_small_show",
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
		local easter_egg_small_hide_terminal = {
			_name = "easter_egg_small_hide",
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

		state_machine.add(easter_egg_small_open_terminal)
		state_machine.add(easter_egg_small_close_terminal)
		state_machine.add(easter_egg_small_show_terminal)
		state_machine.add(easter_egg_small_hide_terminal)
		state_machine.init()
	end
	-- call func init easter egg small state machine.
	init_easter_egg_small_terminal()
end

-- 对象初始化
function EasterEggSmall:init(params)
	self._egg_info = params.eggInfo
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function EasterEggSmall:onUpdateDraw()
	local root = self.roots[1]

	-- 气泡文本控件
	local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
	local descripId = self._egg_info[easter_egg_mould.pop]
	if tonumber(descripId) ~= -1 then 
		local popTxt = dms.element(dms["word_mould"], descripId)[3]
		Text_2:setString(popTxt)
	end

	self:onAppear()
	local seq =
            cc.Sequence:create(
            cc.DelayTime:create(2),
            cc.CallFunc:create(
                function(sender)
                    self:onDisappear()
                end
            )
        )
    self:runAction(seq)
end

-- 迪路兽出现动画
function EasterEggSmall:onAppear()
    local root = self.roots[1]
	local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
	Panel_effect:setVisible(false)
    -- 迪路兽动画挂载控件
    local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
    Panel_role:removeAllChildren(true)
    local jsonFile = "images/ui/effice/effice_zhuchengcaidan1/effice_zhuchengcaidan1.json"
    local atlasFile = "images/ui/effice/effice_zhuchengcaidan1/effice_zhuchengcaidan1.atlas"
    self._role_sp = sp.spine(jsonFile, atlasFile, 1, 0, "animation1", false, nil)
    self._role_sp:setAnimation(0, "animation1", false)
    Panel_role:addChild(self._role_sp)
    self._role_sp:registerSpineEventHandler(
		function(event)
			-- 切换待机
			self.actions[1]:play("open", false)
			self._role_sp:setAnimation(0, "animation3", false)
			Panel_effect:setVisible(true)
        end,
        sp.EventType.ANIMATION_COMPLETE
    )
end

-- 迪路兽消失动画
function EasterEggSmall:onDisappear()
    self._role_sp:setToSetupPose()
    self._role_sp:setAnimation(0, "animation2", false)
    self._role_sp:registerSpineEventHandler(
        function(event)
			self._role_sp:removeFromParent(true)
			state_machine.excute("easter_egg_small_window_close",0,"")
        end,
        sp.EventType.ANIMATION_COMPLETE
    )
end

function EasterEggSmall:onInit()
	-- 加载EasterEggSmallWindow界面资源.
	-- easter_egg/easter_egg_small = easter_egg/easter_egg_small.csb
	local csbNode = csb.createNode("activity/easter_egg/easter_egg_small.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	local action = csb.createTimeline("activity/easter_egg/easter_egg_small.csb")
    table.insert(self.actions, action)
    csbNode:runAction(action)

	self:onUpdateDraw()
end

function EasterEggSmall:onExit()
	-- 释放EasterEggSmallWindow界面资源.
	state_machine.remove("easter_egg_small_open")
	state_machine.remove("easter_egg_small_close")
	state_machine.remove("easter_egg_small_show")
	state_machine.remove("easter_egg_small_hide")
end

function EasterEggSmall:close()
	-- window event : close.
	
end

function EasterEggSmall:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
