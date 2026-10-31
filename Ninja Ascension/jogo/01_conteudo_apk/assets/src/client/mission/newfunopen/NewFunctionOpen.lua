-- ----------------------------------------------------------------------------------------------------
-- 说明：boss介绍
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
NewFunctionOpen = class("NewFunctionOpenClass", Window)

local new_function_open_terminal = {
		_name = "new_function_open",
		_init = function (terminal) 
			
		end,
		_inited = false,
		_instance = self,
		_state = 0,
		_invoke = function(terminal, instance, params)
			local funcid = params
			local _NewFunctionOpen = NewFunctionOpen:new()
			_NewFunctionOpen:init(funcid)
			fwin:open(_NewFunctionOpen,fwin._ui)
			fwin:close(fwin:find("WindowLockClass"))
			return true
		end,
		_terminal = nil,
		_terminals = nil
	}
local new_function_close_terminal = {
		_name = "new_function_close",
		_init = function (terminal) 
			
		end,
		_inited = false,
		_instance = self,
		_state = 0,
		_invoke = function(terminal, instance, params)
			if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
				-- if nil == fwin:find("TuitionControllerClass") then
				-- 	saveExecuteEvent(nil, true)
				-- end
				saveExecuteEventByOfScriptAfter()
			end
			fwin:close(fwin:find("NewFunctionOpenClass"))
			return true
		end,
		_terminal = nil,
		_terminals = nil
	}	
state_machine.add(new_function_open_terminal)
state_machine.add(new_function_close_terminal)
state_machine.init()
function NewFunctionOpen:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.funcid = nil

	self._params = nil

  --   -- Initialize PushInfo page state machine.
    local function init_new_function_terminal()
    	local new_function_goto_function_page_terminal = {
			_name = "new_function_goto_function_page",
			_init = function (terminal) 
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local funcid = instance.funcid

				-- fwin:close(instance)
				-- fwin:cleanView(fwin._frameview)
				-- fwin:cleanView(fwin._background)
				-- fwin:cleanView(fwin._view)
				-- fwin:cleanView(fwin._viewdialog)
				-- fwin:cleanView(fwin._taskbar)
				-- fwin:cleanView(fwin._ui)
				-- -- fwin:cleanView(fwin._dialog)
				-- fwin:cleanView(fwin._notification)
				-- fwin:cleanView(fwin._screen)
				-- fwin:cleanView(fwin._system)
				-- fwin:cleanView(fwin._display_log)
				-- cacher.destoryRefPools()
				-- -- fwin:reset(nil)
				-- cacher.cleanActionTimeline()
				-- cacher.removeAllTextures()

				-- app.load("client.home.Menu")
				-- if fwin:find("MenuClass") == nil then
				-- 	fwin:open(Menu:new(), fwin._taskbar)
				-- end
				-- app.load("client.home.Home")
				-- if fwin:find("HomeClass") == nil then
	   --          	state_machine.excute("menu_manager", 0, 
				-- 		{
				-- 			_datas = {
				-- 				terminal_name = "menu_manager", 	
				-- 				next_terminal_name = "menu_show_home_page", 
				-- 				current_button_name = "Button_home",
				-- 				but_image = "Image_home", 		
				-- 				terminal_state = 0, 
				-- 				isPressedActionEnabled = true
				-- 			}
				-- 		}
				-- 	)
	   --          end
	   --          state_machine.unlock("menu_manager_change_to_page", 0, "")
				-- state_machine.excute("menu_back_home_page", 0, "")
				-- state_machine.excute("menu_clean_page_state", 0, "") 

				-- state_machine.excute("shortcut_function_trace", 0, {trace_function_id = funcid, _datas = {}})

				fwin:close(instance)
				state_machine.excute("lduplicate_window_return", 0, 0)
				state_machine.excute("shortcut_function_trace", 0, {trace_function_id = funcid, _datas = {}})
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(new_function_goto_function_page_terminal)
        state_machine.init()
    end

    -- call func init hom state machine.
    init_new_function_terminal()
end

function NewFunctionOpen:onEnterTransitionFinish()
end

function NewFunctionOpen:onUpdateDraw()
	local root = self.roots[1]

	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		local tType = self._params[1]
		local pic = self._params[2]
		local strName = self._params[3]
		local strInfo = self._params[4]

		if tType == 0 then --建筑
			local Panel_build = ccui.Helper:seekWidgetByName(root, "Panel_build")
			if nil ~= Panel_build then
				Panel_build:setVisible(true)
			end
		else -- 功能
			local Panel_function = ccui.Helper:seekWidgetByName(root, "Panel_function")
			if nil ~= Panel_function then
				Panel_function:setVisible(true)
			end
		end

		local Panel_build_icon = ccui.Helper:seekWidgetByName(root, "Panel_build_icon")
		if nil ~= Panel_build_icon then
			Panel_build_icon:removeBackGroundImage()
			Panel_build_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", pic))
		end

		local Text_build_name = ccui.Helper:seekWidgetByName(root, "Text_build_name")
		if nil ~= Text_build_name then
			Text_build_name:setString(strName)
		end

		local Text_build_info = ccui.Helper:seekWidgetByName(root, "Text_build_info")
		if nil ~= Text_build_info then
			Text_build_info:setString(strInfo)
		end
	else
		local Text_gongneng_name = ccui.Helper:seekWidgetByName(root, "Text_gongneng_name")
		local open_function = dms.string(dms["function_param"],self.funcid,function_param.open_function)
		local name = dms.string(dms["function_param"],self.funcid,function_param.name)
		Text_gongneng_name:setString(name)
		local pic = dms.int(dms["function_param"], self.funcid, function_param.icon)
		local panel_image = ccui.Helper:seekWidgetByName(root, "Panel_function_icon")
		panel_image:setBackGroundImage(string.format("images/ui/function_icon/function_icon_%d.png", pic))
	end
end

function NewFunctionOpen:onInit()
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		local csbNewFunctionOpen = csb.createNode("utils/new_building_open.csb")
		local root = csbNewFunctionOpen:getChildByName("root")
	    table.insert(self.roots, root)
	    self:addChild(csbNewFunctionOpen)

	    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_window_box"),  nil, 
	    {
	        terminal_name = "new_function_close",     
	        terminal_state = 0, 
	        isPressedActionEnabled = true
	    }, 
	    nil, 0)
	else
		local csbNewFunctionOpen = csb.createNode("battle/features_open.csb")
		local root = csbNewFunctionOpen:getChildByName("root")
	    table.insert(self.roots, root)
	    self:addChild(csbNewFunctionOpen)
	    local action = csb.createTimeline("battle/features_open.csb")
	  	table.insert(self.actions, action)
	    csbNewFunctionOpen:runAction(action)

	    local Panel_gn_cs = ccui.Helper:seekWidgetByName(root, "Panel_gn_cs")
	    Panel_gn_cs:setVisible(false)
	    local Panel_gn_open = ccui.Helper:seekWidgetByName(root, "Panel_gn_open")
	    Panel_gn_open:setVisible(true)
	    action:play("window_open",false)

		local ArmatureNode_gn_open = Panel_gn_open:getChildByName("ArmatureNode_gn_open")
		local animation = ArmatureNode_gn_open:getAnimation()
	    animation:playWithIndex(0, 0, 0)

	    action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end

	        local str = frame:getEvent()
	        if str == "window_open_over" then
	            local Panel_gn_open = ccui.Helper:seekWidgetByName(root, "Panel_gn_open")
	            Panel_gn_open:setVisible(false)
	            local Panel_gn_cs = ccui.Helper:seekWidgetByName(root, "Panel_gn_cs")
	            Panel_gn_cs:setVisible(true)
	        end
	        
	    end)
	    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhidaole"),  nil, 
	    {
	        terminal_name = "new_function_close",     
	        terminal_state = 0, 
	        isPressedActionEnabled = true
	    }, 
	    nil, 0)
	    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qianwang"),  nil, 
	    {
	        terminal_name = "new_function_goto_function_page",     
	        terminal_state = 0, 
	        isPressedActionEnabled = true
	    }, 
	    nil, 0)
	end
	self:onUpdateDraw()
end
function NewFunctionOpen:init(_funcid)
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
		self._params = _funcid
	else
		self.funcid = _funcid
	end
	self:onInit()
end
function NewFunctionOpen:onExit()
	state_machine.remove("new_function_goto_function_page")
end