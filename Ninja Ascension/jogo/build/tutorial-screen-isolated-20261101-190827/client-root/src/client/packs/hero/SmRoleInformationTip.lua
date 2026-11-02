-- ----------------------------------------------------------------------------------------------------
-- 说明：角色信息界面帮助界面
-------------------------------------------------------------------------------------------------------
SmRoleInformationTip = class("SmRoleInformationTipClass", Window)

local sm_role_information_tip_open_terminal = {
    _name = "sm_role_information_tip_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleInformationTipClass")
        if nil == _homeWindow then
            local panel = SmRoleInformationTip:new():init()
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_information_tip_close_terminal = {
    _name = "sm_role_information_tip_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleInformationTipClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleInformationTipClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_information_tip_open_terminal)
state_machine.add(sm_role_information_tip_close_terminal)
state_machine.init()
    
function SmRoleInformationTip:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0
    self.action_number = 0
    local function init_sm_role_information_tip_terminal()
        -- 显示界面
        local sm_role_information_tip_display_terminal = {
            _name = "sm_role_information_tip_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationTipWindow = fwin:find("SmRoleInformationTipClass")
                if SmRoleInformationTipWindow ~= nil then
                    SmRoleInformationTipWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_information_tip_hide_terminal = {
            _name = "sm_role_information_tip_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationTipWindow = fwin:find("SmRoleInformationTipClass")
                if SmRoleInformationTipWindow ~= nil then
                    SmRoleInformationTipWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_information_tip_display_terminal)
        state_machine.add(sm_role_information_tip_hide_terminal)
        state_machine.init()
    end
    init_sm_role_information_tip_terminal()
end

function SmRoleInformationTip:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    
end

function SmRoleInformationTip:init()
    self:onInit()
    return self
end

function SmRoleInformationTip:onInit()
    local csbSmRoleInformationTip = csb.createNode("packs/HeroStorage/sm_generals_information_help.csb")
    local root = csbSmRoleInformationTip:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleInformationTip)
    local action = csb.createTimeline("packs/HeroStorage/sm_generals_information_help.csb")
    table.insert(self.actions, action)
    csbSmRoleInformationTip:runAction(action)
	action:play("animation0", false)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_role_information_tip_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
end

function SmRoleInformationTip:onExit()
    state_machine.remove("sm_role_information_tip_display")
    state_machine.remove("sm_role_information_tip_hide")
end