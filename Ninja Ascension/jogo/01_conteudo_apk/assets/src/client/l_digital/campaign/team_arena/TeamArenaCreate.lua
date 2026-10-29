--[[ ----------------------------------------------------------------------------
-- 创建队伍
--]] ----------------------------------------------------------------------------
TeamArenaCreate = class("TeamArenaCreateClass", Window)

-- 打开窗口
local team_arena_create_window_open_terminal = {
	_name = "team_arena_create_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("TeamArenaCreateClass") then
			fwin:open(TeamArenaCreate:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local team_arena_create_window_close_terminal = {
	_name = "team_arena_create_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TeamArenaCreateClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(team_arena_create_window_open_terminal)
state_machine.add(team_arena_create_window_close_terminal)
state_machine.init()

-- 构造器
function TeamArenaCreate:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize team arena create page state machine.
	local function init_team_arena_create_terminal()
		-- 打开角色创建窗口
		local team_arena_create_open_terminal = {
			_name = "team_arena_create_open",
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
		local team_arena_create_close_terminal = {
			_name = "team_arena_create_close",
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
		local team_arena_create_show_terminal = {
			_name = "team_arena_create_show",
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
		local team_arena_create_hide_terminal = {
			_name = "team_arena_create_hide",
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

		-- 创建队伍
		local team_arena_create_team_terminal = {
			_name = "team_arena_create_team",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then

					local teamName = instance.TextField_1:getString()
					local teamCombat = instance.TextField_2:getString()
					teamName = string.gsub(teamName, " ", "")
					if teamName and teamName ~= "" and teamCombat and teamCombat ~= "" then
						local function team_arena_create_teamCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								state_machine.excute("team_arena_team2_window_open",0,"")
								state_machine.excute("team_arena_team1_window_close",0,"")
								state_machine.excute("team_arena_create_window_close",0,"")
							end
						end
						protocol_command.team_arena_create_team.param_list = teamName.."\r\n"..teamCombat
						NetworkManager:register(protocol_command.team_arena_create_team.code, nil, nil, nil, self, team_arena_create_teamCallback, false, nil)
					else
						TipDlg.drawTextDailog(tipStringInfo_team_arena[7])
					end

					
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(team_arena_create_team_terminal)
		state_machine.add(team_arena_create_open_terminal)
		state_machine.add(team_arena_create_close_terminal)
		state_machine.add(team_arena_create_show_terminal)
		state_machine.add(team_arena_create_hide_terminal)
		state_machine.init()
	end
	-- call func init team arena create state machine.
	init_team_arena_create_terminal()
end

-- 对象初始化
function TeamArenaCreate:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function TeamArenaCreate:onUpdateDraw()
	local root = self.roots[1]

	-- 填写队伍名字
	self.TextField_1 = ccui.Helper:seekWidgetByName(root, "TextField_1")
	local needData2 = zstring.split(dms.string(dms["gvg_config"], 44, gvg_config.param), ",")

	-- 填写战力要求
	self.TextField_2 = ccui.Helper:seekWidgetByName(root, "TextField_2")
	local combatInput = tonumber(needData2[1])
	self.TextField_2:setString(combatInput)
	local function textFieldNumEvent(sender, eventType)
		if eventType == ccui.TextFiledEventType.attach_with_ime then
		elseif eventType == ccui.TextFiledEventType.detach_with_ime then
		elseif eventType == ccui.TextFiledEventType.insert_text then
			local num = tonumber(sender:getString())

			if num == nil or string.find(sender:getString(),'.',1,true) ~= nil then
				sender:setString(combatInput)
			elseif num<tonumber(needData2[1]) then
				combatInput = tonumber(needData2[1])
				sender:setString(combatInput)
			elseif num>tonumber(needData2[2]) then
				combatInput = tonumber(needData2[2])
				sender:setString(combatInput)
			else
				combatInput = num
			end
			
		elseif eventType == ccui.TextFiledEventType.delete_backward then
			local num = tonumber(sender:getString())
			if num == nil then
				sender:setString(needData2[1])
			end
		end
	end
	self.TextField_2:addEventListener(textFieldNumEvent)

	self.Text_tips = ccui.Helper:seekWidgetByName(root, "Text_tips")
	
	self.Text_tips:setString(string.format(tipStringInfo_team_arena[8], needData2[1],needData2[2]))

end

function TeamArenaCreate:onEnterTransitionFinish()
	-- 加载TeamArenaCreateWindow界面资源.
	-- res.legion.legion_assistance_window_1 = res/legion/legion_assistance_window_1.csb
	local csbNode = csb.createNode("campaign/team_arena/team_arena_create.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 创建队伍
	self.Button_create = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_create"), nil,
	{
		terminal_name = "team_arena_create_team",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "team_arena_create_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function TeamArenaCreate:onExit()
	-- 释放TeamArenaCreateWindow界面资源.
	state_machine.remove("team_arena_create_open")
	state_machine.remove("team_arena_create_close")
	state_machine.remove("team_arena_create_show")
	state_machine.remove("team_arena_create_hide")
	state_machine.remove("team_arena_create_team")
	
end

function TeamArenaCreate:close()
	-- window event : close.
	
end

function TeamArenaCreate:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
