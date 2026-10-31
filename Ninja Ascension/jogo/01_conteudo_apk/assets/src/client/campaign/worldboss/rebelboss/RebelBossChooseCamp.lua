-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军BOOS进入阵营选择
-------------------------------------------------------------------------------------------------------

RebelBossChooseCamp = class("RebelBossChooseCampClass", Window)
   
local rebel_boss_choose_camp_window_open_terminal = {
    _name = "rebel_boss_choose_camp_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RebelBossChooseCampClass") then
        	local helpWindow = RebelBossChooseCamp:new()
			helpWindow:init()
			fwin:open(helpWindow, fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local rebel_boss_choose_camp_window_close_terminal = {
    _name = "rebel_boss_choose_camp_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RebelBossChooseCampClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rebel_boss_choose_camp_window_open_terminal)
state_machine.add(rebel_boss_choose_camp_window_close_terminal)
state_machine.init()
  
function RebelBossChooseCamp:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
    -- Initialize Home page state machine.
    local function init_rebel_boss_choose_camp_terminal()
        local rebel_boss_choose_camp_select_terminal = {
            _name = "rebel_boss_choose_camp_select",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local selectIndex = params._datas._selectIndex
                local function requestSelect(instance,n)
                        if n == 0 then
                            state_machine.excute("rebel_boss_choose_camp_select_request",0,selectIndex)
                        end
                    end
                    app.load("client.utils.ConfirmPrompted")
                    local tip = ConfirmPrompted:new()
                    tip:init(self, requestSelect, _pet_tipString_info[34])
                    fwin:open(tip,fwin._dialog)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --请求选择的阵营
        local rebel_boss_choose_camp_select_request_terminal = {
            _name = "rebel_boss_choose_camp_select_request",
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
        state_machine.add(rebel_boss_choose_camp_select_terminal)
        state_machine.add(rebel_boss_choose_camp_select_request_terminal)
        
        state_machine.add()
        
        state_machine.init()
    end
    
    init_rebel_boss_choose_camp_terminal()
end

function RebelBossChooseCamp:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
    
end

function RebelBossChooseCamp:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("campaign/WorldBoss/worldBoss_zyxz.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)
	self:onUpdateDraw()
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_269"), nil, 
	{
		terminal_name = "rebel_boss_choose_camp_window_close",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)

    for i=1,4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zy_".. i), nil, 
        {
            terminal_name = "rebel_boss_choose_camp_select",
            terminal_state = 0, 
            isPressedActionEnabled = true,
            _selectIndex = i,
            _self = self,
        },
        nil,0)
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_269"), nil, 
    {
        terminal_name = "rebel_boss_choose_camp_window_close",
        terminal_state = 0, 
        isPressedActionEnabled = true,
        _self = self,
    },
    nil,0)
end

function RebelBossChooseCamp:onExit()
    state_machine.remove("rebel_boss_choose_camp_select")
end

function RebelBossChooseCamp:init()
	
end
