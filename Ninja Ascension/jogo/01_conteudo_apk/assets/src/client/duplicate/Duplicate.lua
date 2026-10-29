-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏副本界面
-------------------------------------------------------------------------------------------------------
Duplicate = class("DuplicateClass", Window)

function Duplicate:ctor()
    self.super:ctor()
	self.roots = {}
    
	app.load("client.duplicate.DuplicateList")
	app.load("client.duplicate.activity.GameActivity")

    -- Initialize Duplicate page state machine.
    local function init_duplicate_terminal()
		local duplicate_manager_terminal = {
            _name = "duplicate_manager",
            _init = function (terminal) 
                app.load("client.player.UserInformationForDuplicate")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if terminal.page_name ~= params._datas.but_image then
            		local but_bgImage = nil
            		if terminal.page_name ~= nil then
            			but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
            			if but_bgImage ~= nil then
            				but_bgImage:setVisible(false)
            			end
            		end
            		terminal.page_name = params._datas.but_image
            		but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
            		if but_bgImage ~= nil then
            			but_bgImage:setVisible(true)
            		end

            		fwin:cleanView(fwin._background)
            		state_machine.excute(params._datas.next_terminal_name, 0, params)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 名将副本的管理器
		local general_copy_terminal = {
            _name = "general_copy",
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

        -- 主线副本的管理器
		local plot_copy_terminal = {
            _name = "plot_copy",
            _init = function (terminal) 
                app.load("client.duplicate.plot.PlotCopyWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local plotCopyWindow = PlotCopyWindow:new()
				plotCopyWindow:init()
            	fwin:open(plotCopyWindow, fwin._background)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 日常副本的管理器
		local daily_copy_terminal = {
            _name = "daily_copy",
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

		state_machine.add(duplicate_manager_terminal)
		state_machine.add(general_copy_terminal)
		state_machine.add(plot_copy_terminal)
		state_machine.add(daily_copy_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_duplicate_terminal()
end

function Duplicate:onEnterTransitionFinish()
    local csbDuplicate = csb.createNode("duplicate/pve_button.csb")
    local root = csbDuplicate:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbDuplicate)

    -- 设置UI的事件响应
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2535"), nil, {terminal_name = "duplicate_manager", 	next_terminal_name = "general_copy", 	but_image = "general", 		terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2536"), nil, {terminal_name = "duplicate_manager", 	next_terminal_name = "plot_copy", 		but_image = "plot", 		terminal_state = 0, isPressedActionEnabled = true}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2537"), nil, {terminal_name = "duplicate_manager", 	next_terminal_name = "daily_copy", 		but_image = "daily", 		terminal_state = 0, isPressedActionEnabled = true}, nil, 0)

    if __lua_project_id ~= __lua_project_red_alert_time then
    	-- 绘制用户的基础信息
    	fwin:open(UserInformationForDuplicate:new(), fwin._ui)
    end
end

function Duplicate:onExit()
	state_machine.remove("duplicate_manager")
	state_machine.remove("general_copy")
	state_machine.remove("plot_copy")
	state_machine.remove("daily_copy")
end
