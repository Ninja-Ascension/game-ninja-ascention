-----------------------------
--连斩数
-----------------------------
NationalWarKillMax = class("NationalWarKillMaxClass", Window)

local national_war_kill_max_window_open_terminal = {
    _name = "national_war_kill_max_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("NationalWarKillMaxClass") == nil then
            fwin:open(NationalWarKillMax:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_kill_max_window_close_terminal = {
    _name = "national_war_kill_max_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarKillMaxClass"))  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_kill_max_window_open_terminal)
state_machine.add(national_war_kill_max_window_close_terminal)
state_machine.init()

function NationalWarKillMax:ctor()
    self.super:ctor()
    self.roots = {}
    self.city_id = nil
    -- -- Initialize national_war_decree machine.
    local function init_national_war_kill_max_terminal()
        local national_war_kill_max_update_kill_numbers_terminal = {
            _name = "national_war_kill_max_update_kill_numbers",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.onUpdateDraw ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(national_war_kill_max_update_kill_numbers_terminal)
        state_machine.init()
    end
    
    -- call func init national_war_decree machine.
    init_national_war_kill_max_terminal()
end

function NationalWarKillMax:onUpdateDraw()
    if _ED.war_user_dead == true then
        self.panel_kill_max:setVisible(false)
        return
    end
    if zstring.tonumber(_ED.war_fight_fail_info.kill_max) > 0 then
        self.panel_kill_max:setVisible(true)
        self.text_kill_max:setString(zstring.tonumber(_ED.war_fight_fail_info.kill_max))
    else
        self.panel_kill_max:setVisible(false)
    end
end

function NationalWarKillMax:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.natinalwar_kill_max)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self.panel_kill_max = ccui.Helper:seekWidgetByName(root,"Panel_attac_right")
    self.text_kill_max = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_att_r")
    self:onUpdateDraw() 
end

function NationalWarKillMax:init()
    self:onInit()
    return self
end

function NationalWarKillMax:onExit()
    state_machine.remove("national_war_kill_max_update_kill_numbers")
end
