-----------------------------
--系统设置
-----------------------------
SetWindow = class("SetWindowClass", Window)

local set_window_open_terminal = {
    _name = "set_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("SetWindowClass") then
            fwin:open(SetWindow:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local set_window_close_terminal = {
    _name = "set_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SetWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(set_window_open_terminal)
state_machine.add(set_window_close_terminal)
state_machine.init()

function SetWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.music_state = nil
    self.sound_state = nil
    -- Initialize SetWindow state machine.
    local function init_set_window_terminal()

        --音效
        local set_window_change_sound_terminal = {
            _name = "set_window_change_sound",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.sound_state == true then
                    instance.sound_state = false
                    muteSoundEffect()
                else
                    instance.sound_state = true
                    openSoundEffect()
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --音乐
        local set_window_change_music_terminal = {
            _name = "set_window_change_music",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.music_state == true then
                    muteBgm()
                    instance.music_state = false
                else
                    openBgm()
                    instance.music_state = true
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        --良辰及时
        local set_window_time_propelling_terminal = {
            _name = "set_window_time_propelling",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                TipDlg.drawTextDailog(_function_unopened_tip_string)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        --商店刷新
        local set_window_shop_propelling_terminal = {
            _name = "set_window_shop_propelling",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                TipDlg.drawTextDailog(_function_unopened_tip_string)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        --体力
        local set_window_power_propelling_terminal = {
            _name = "set_window_power_propelling",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                TipDlg.drawTextDailog(_function_unopened_tip_string)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        state_machine.add(set_window_change_sound_terminal)
        state_machine.add(set_window_change_music_terminal)
        state_machine.add(set_window_time_propelling_terminal)
        state_machine.add(set_window_shop_propelling_terminal)
        state_machine.add(set_window_power_propelling_terminal)
        state_machine.init()
    end
    
    -- call func init set_window state machine.
    init_set_window_terminal()
end

function SetWindow:onEnterTransitionFinish()

end

function SetWindow:onUpdateDraw()
    local root = self.roots[1]
    local music_btn = ccui.Helper:seekWidgetByName(root,"Button_set_music")
    local sound_btn = ccui.Helper:seekWidgetByName(root,"Button_set_effect")
    local _sound = iscurrentBgm()
    local _music = isBgmOpen()
    
    if _music == true then
        music_btn:setHighlighted(false)
    else
        music_btn:setHighlighted(true)
    end
    if _sound == true then
        sound_btn:setHighlighted(false)
    else
        sound_btn:setHighlighted(true)
    end
end

function SetWindow:init()
    self:initDatas()
	self:onInit()
    return self
end

function SetWindow:onInit( )
    local csbItem = csb.createNode(config_csb.utils.set_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_set_window_1") , nil, 
    {
        terminal_name = "set_window_close", 
        terminal_state = 0, 
    }, nil, 0)    
    -- 音效
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_set_effect") , nil, 
    {
        terminal_name = "set_window_change_sound", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    -- 音乐
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_set_music") , nil, 
    {
        terminal_name = "set_window_change_music", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 良辰及时
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_time_propelling") , nil, 
    {
        terminal_name = "set_window_time_propelling", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 商店刷新
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_shop_propelling") , nil, 
    {
        terminal_name = "set_window_shop_propelling", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    
    -- 体力领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_power_propelling") , nil, 
    {
        terminal_name = "set_window_power_propelling", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    

    self:onUpdateDraw() 
end

function SetWindow:initDatas()
    self.music_state = iscurrentBgm()
    self.sound_state = isBgmOpen()
end

function SetWindow:onExit()
    state_machine.remove("set_window_change_sound")
    state_machine.remove("set_window_change_music")
    state_machine.remove("set_window_time_propelling")
    state_machine.remove("set_window_shop_propelling")
    state_machine.remove("set_window_power_propelling")
end
