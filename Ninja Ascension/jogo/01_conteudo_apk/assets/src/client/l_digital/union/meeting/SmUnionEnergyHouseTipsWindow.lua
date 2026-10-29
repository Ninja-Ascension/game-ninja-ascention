-- ----------------------------------------------------------------------------------------------------
-- 说明：公会训练位提示界面
-------------------------------------------------------------------------------------------------------
SmUnionEnergyHouseTipsWindow = class("SmUnionEnergyHouseTipsWindowClass", Window)

local sm_union_energy_house_tips_window_open_terminal = {
    _name = "sm_union_energy_house_tips_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionEnergyHouseTipsWindowClass")
        if nil == _homeWindow then
            local panel = SmUnionEnergyHouseTipsWindow:new():init(params)
            fwin:open(panel,fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_energy_house_tips_window_close_terminal = {
    _name = "sm_union_energy_house_tips_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionEnergyHouseTipsWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionEnergyHouseTipsWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_energy_house_tips_window_open_terminal)
state_machine.add(sm_union_energy_house_tips_window_close_terminal)
state_machine.init()
    
function SmUnionEnergyHouseTipsWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    local function init_sm_union_energy_house_tips_window_terminal()
        -- 显示界面
        local sm_union_energy_house_tips_window_display_terminal = {
            _name = "sm_union_energy_house_tips_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionEnergyHouseTipsWindowWindow = fwin:find("SmUnionEnergyHouseTipsWindowClass")
                if SmUnionEnergyHouseTipsWindowWindow ~= nil then
                    SmUnionEnergyHouseTipsWindowWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_energy_house_tips_window_hide_terminal = {
            _name = "sm_union_energy_house_tips_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionEnergyHouseTipsWindowWindow = fwin:find("SmUnionEnergyHouseTipsWindowClass")
                if SmUnionEnergyHouseTipsWindowWindow ~= nil then
                    SmUnionEnergyHouseTipsWindowWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 确认
        local sm_union_energy_house_tips_window_confirm_terminal = {
            _name = "sm_union_energy_house_tips_window_confirm",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseUnionCreateCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("sm_union_my_campsite_update_draw_cell", 0, instance.m_object.index)
                        state_machine.excute("sm_union_energy_house_tips_window_close", 0, "")
                    end
                end
                local shipData = zstring.split(instance.m_object.training_info,",")
                protocol_command.union_ship_train_place_buy.param_list = instance.m_object.index
                NetworkManager:register(protocol_command.union_ship_train_place_buy.code, nil, nil, nil, instance, responseUnionCreateCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_energy_house_tips_window_display_terminal)
        state_machine.add(sm_union_energy_house_tips_window_hide_terminal)
        state_machine.add(sm_union_energy_house_tips_window_confirm_terminal)
        state_machine.init()
    end
    init_sm_union_energy_house_tips_window_terminal()
end

function SmUnionEnergyHouseTipsWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
	
	local Text_zs_n = ccui.Helper:seekWidgetByName(root,"Text_zs_n")
    local param = zstring.split(dms.string(dms["union_config"], 24, union_config.param) ,"|")
    local openData = zstring.split(param[self.m_object.index],",")
    Text_zs_n:setString(openData[2])
end

function SmUnionEnergyHouseTipsWindow:init(params)
    self.m_object = params
    self:onInit()
    return self
end

function SmUnionEnergyHouseTipsWindow:onInit()
    local csbSmUnionEnergyHouseTipsWindow = csb.createNode("legion/sm_legion_energy_house_tips_window.csb")
    local root = csbSmUnionEnergyHouseTipsWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionEnergyHouseTipsWindow)
    local action = csb.createTimeline("legion/sm_legion_energy_house_tips_window.csb")
    table.insert(self.actions, action)
    csbSmUnionEnergyHouseTipsWindow:runAction(action)
    action:play("window_open", false)

    self:onUpdateDraw()

    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "sm_union_energy_house_tips_window_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    --确认
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ok"), nil, 
    {
        terminal_name = "sm_union_energy_house_tips_window_confirm",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)
end

function SmUnionEnergyHouseTipsWindow:onExit()
    state_machine.remove("sm_union_energy_house_tips_window_display")
    state_machine.remove("sm_union_energy_house_tips_window_hide")
end