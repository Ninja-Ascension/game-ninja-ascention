--[[ ----------------------------------------------------------------------------
-- 大R推送界面
--]] ----------------------------------------------------------------------------
ActivityRVipPush = class("ActivityRVipPushClass", Window)

-- 打开窗口
local activity_r_vip_push_window_open_terminal = {
	_name = "activity_r_vip_push_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local type = tonumber(params.type or 2)
		if type == 1 then
			fwin:close(fwin:find("ActivityRVipPushClass"))
		end

		if nil == fwin:find("ActivityRVipPushClass") then
			local time = os.time()
			local firstTime = tonumber(cc.UserDefault:getInstance():getStringForKey(getKey("act_r_vip_pop"),0))
			
			if firstTime == 0 then
				firstTime = time
				cc.UserDefault:getInstance():setStringForKey(getKey("act_r_vip_pop"),firstTime)
			end
			local day = dms.int(dms["user_config"], 18, user_config.param)*24*60*60
			local vip = zstring.split(dms.string(dms["user_config"], 17 ,user_config.param),",")
			if tonumber(_ED.vip_grade) >= tonumber(vip[1]) and ( type == 1 or ( type ~= 1 and _ED.act_r_vip_pop == nil)) and ((time-firstTime)<=day) then
					_ED.act_r_vip_pop = 1
					if type == 1 then
						fwin:open(ActivityRVipPush:new():init(params), fwin._windows)
					
					else
						fwin:open(ActivityRVipPush:new():init(params), fwin._view)
					end
			end
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local activity_r_vip_push_window_close_terminal = {
	_name = "activity_r_vip_push_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivityRVipPushClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_r_vip_push_window_open_terminal)
state_machine.add(activity_r_vip_push_window_close_terminal)
state_machine.init()

-- 构造器
function ActivityRVipPush:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize activity r vip push page state machine.
	local function init_activity_r_vip_push_terminal()
		-- 打开角色创建窗口
		local activity_r_vip_push_open_terminal = {
			_name = "activity_r_vip_push_open",
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
		local activity_r_vip_push_close_terminal = {
			_name = "activity_r_vip_push_close",
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
		local activity_r_vip_push_show_terminal = {
			_name = "activity_r_vip_push_show",
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
		local activity_r_vip_push_hide_terminal = {
			_name = "activity_r_vip_push_hide",
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

		--web
		local activity_r_vip_push_open_web_terminal = {
            _name = "activity_r_vip_push_open_web",
            _init = function (terminal)
    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
				local vip = zstring.split(dms.string(dms["user_config"], 17 ,user_config.param),",")
                handlePlatformRequest(0, CC_OPEN_URL, vip[3])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(activity_r_vip_push_open_web_terminal)
		state_machine.add(activity_r_vip_push_open_terminal)
		state_machine.add(activity_r_vip_push_close_terminal)
		state_machine.add(activity_r_vip_push_show_terminal)
		state_machine.add(activity_r_vip_push_hide_terminal)
		state_machine.init()
	end
	-- call func init activity r vip push state machine.
	init_activity_r_vip_push_terminal()
end

-- 对象初始化
function ActivityRVipPush:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ActivityRVipPush:onUpdateDraw()
	local root = self.roots[1]

	-- vip等级
	self.Text_vip_lvl = ccui.Helper:seekWidgetByName(root, "Text_vip_lvl")

	-- 联系方式文本
	self.Text_contact = ccui.Helper:seekWidgetByName(root, "Text_contact")

	-- vip等级
	self.BitmapFontLabel_vip_lvl = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_vip_lvl")
	local vip = zstring.split(dms.string(dms["user_config"], 17 ,user_config.param),",")
	self.Text_vip_lvl:setString(vip[1])
	self.Text_contact:setString(vip[2])
	self.BitmapFontLabel_vip_lvl:setString(_ED.vip_grade)
end

function ActivityRVipPush:onEnterTransitionFinish()
	-- 加载ActivityRVipPushWindow界面资源.
	-- client.activity.wonderful.activity_r_vip_push = client/activity/wonderful/activity_r_vip_push.csb
	local csbNode = csb.createNode("activity/wonderful/activity_r_vip_push.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- local action = csb.createTimeline("activity/wonderful/activity_r_vip_push.csb") 
    -- table.insert(self.actions, action )
    -- csbNode:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "activity_r_vip_push_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	if __lua_project_id == __lua_project_onepiece then
		-- 打开web
		self.Button_qw = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qw"), nil,
		{
			terminal_name = "activity_r_vip_push_open_web",
			terminal_state = 0,
			isPressedActionEnabled = true,
		}, nil, 0)	
	end
	
	self:onUpdateDraw()
end

function ActivityRVipPush:onExit()
	-- 释放ActivityRVipPushWindow界面资源.
	state_machine.remove("activity_r_vip_push_open_web")
	state_machine.remove("activity_r_vip_push_open")
	state_machine.remove("activity_r_vip_push_close")
	state_machine.remove("activity_r_vip_push_show")
	state_machine.remove("activity_r_vip_push_hide")
end

function ActivityRVipPush:close()
	-- window event : close.
	
end

function ActivityRVipPush:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
