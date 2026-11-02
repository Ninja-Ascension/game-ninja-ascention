-- ----------------------------------------------------------------------------------------------------
-- 说明：选择骰子点数界面
-------------------------------------------------------------------------------------------------------
RichmanChooseDiceNumber = class("RichmanChooseDiceNumberClass", Window)

local richman_choose_dice_number_window_open_terminal = {
    _name = "richman_choose_dice_number_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RichmanChooseDiceNumberClass") then
			fwin:open(RichmanChooseDiceNumber:new():init(params), fwin._view)
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local richman_choose_dice_number_window_close_terminal = {
    _name = "richman_choose_dice_number_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("RichmanChooseDiceNumberClass") then
            fwin:close(fwin:find("RichmanChooseDiceNumberClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(richman_choose_dice_number_window_open_terminal)
state_machine.add(richman_choose_dice_number_window_close_terminal)
state_machine.init()

function RichmanChooseDiceNumber:ctor()
    self.super:ctor()

    self.roots = {}
    

    local function init_richman_choose_dice_number_terminal()
		-- 打开角色创建窗口
		local richman_choose_dice_number_open_terminal = {
			_name = "richman_choose_dice_number_open",
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
		local richman_choose_dice_number_close_terminal = {
			_name = "richman_choose_dice_number_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("richman_choose_dice_number_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local richman_choose_dice_number_show_terminal = {
			_name = "richman_choose_dice_number_show",
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
		local richman_choose_dice_number_hide_terminal = {
			_name = "richman_choose_dice_number_hide",
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

		-- 确认选择骰子数量
		local richman_choose_dice_number_confirm_terminal = {
			_name = "richman_choose_dice_number_confirm",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local _datas = {}
					_datas.diceType = params._datas.diceType
					_datas.dicePosIdxNum = params._datas.dicePosIdxNum
					state_machine.excute("richman_main_roll_dice", 0, {_datas = _datas})
					state_machine.excute("richman_choose_dice_number_window_close", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(richman_choose_dice_number_open_terminal)
		state_machine.add(richman_choose_dice_number_close_terminal)
		state_machine.add(richman_choose_dice_number_show_terminal)
		state_machine.add(richman_choose_dice_number_hide_terminal)
		state_machine.add(richman_choose_dice_number_confirm_terminal)
		state_machine.init()
	end
	-- call func init richman_reward record state machine.
	init_richman_choose_dice_number_terminal()
end

function RichmanChooseDiceNumber:onUpdateDraw()

end

-- 对象初始化
function RichmanChooseDiceNumber:init(params)
	if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function RichmanChooseDiceNumber:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/dafuweng/dafuweng_dianshu.csb")
	local root = csbNode:getChildByName("root")
    self:addChild(csbNode)
	table.insert(self.roots, root)

	local buttonChooseList = {"Button_2", "Button_2_0", "Button_2_1", "Button_2_2", "Button_2_3", "Button_2_4"}

	for i, v in ipairs(buttonChooseList) do
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,v), nil, 
		{
			terminal_name = "richman_choose_dice_number_confirm", 
			terminal_state = 0,
			isPressedActionEnabled = true,
			diceType = 1,
			dicePosIdxNum = i,
		}, nil, 0)
	end
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
    {
        terminal_name = "richman_choose_dice_number_window_close", 
        terminal_state = 0,
		isPressedActionEnabled = true,
    },
    nil, 0)

    self:onUpdateDraw()
end

function RichmanChooseDiceNumber:onExit()
    state_machine.remove("richman_choose_dice_number_open")
	state_machine.remove("richman_choose_dice_number_close")
	state_machine.remove("richman_choose_dice_number_show")
	state_machine.remove("richman_choose_dice_number_hide")
	state_machine.remove("richman_choose_dice_number_confirm")
	
end


function RichmanChooseDiceNumber:close()
	-- window event : close.
	
end

function RichmanChooseDiceNumber:destroy(window)
	-- window event : destroy.
	
end
