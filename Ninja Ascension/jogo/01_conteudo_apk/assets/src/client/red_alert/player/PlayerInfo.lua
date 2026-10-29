--------------------------------------------------------------------------------------------------------------
--  说明：主页面角色信息
--------------------------------------------------------------------------------------------------------------
PlayerInfo = class("PlayerInfoClass", Window)

--打开界面
local player_info_window_open_terminal = {
	_name = "player_info_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local _wind = PlayerInfo:new()
		_wind:init()
		fwin:open(_wind,fwin._frameview)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_info_window_close_terminal = {
	_name = "player_info_window_close",
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
state_machine.add(player_info_window_open_terminal)
state_machine.add(player_info_window_close_terminal)
state_machine.init()

function PlayerInfo:ctor()
	self.super:ctor()
	self.roots = {}
	self.vip_text = nil
    self.lv_text = nil

    app.load("client.red_alert.player.PlayerInforWindow")
	 -- Initialize alert_home state machine.
    local function init_play_info_terminal()

		--显示所有
		local player_info_window_show_terminal = {
            _name = "player_info_window_show",
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
		-- 隐藏所有
        local player_info_window_hide_terminal = {
            _name = "player_info_window_hide",
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
		-- 刷新角色头像信息等级
        local player_info_update_draw_terminal = {
            _name = "player_info_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(player_info_window_show_terminal)
		state_machine.add(player_info_window_hide_terminal)	
		state_machine.add(player_info_update_draw_terminal)		
        state_machine.init()
    end
    
    -- call func alert_home create state machine.
    init_play_info_terminal()

end


function PlayerInfo:updateDraw()
    local root = self.roots[1]
    local Panel_leading_head = ccui.Helper:seekWidgetByName(root,"Panel_leading_head")
    if tonumber(_ED.user_info.user_gender) == 1 then
        Panel_leading_head:setBackGroundImage("images/ui/home/home_head_bg_man.png")
    else
        Panel_leading_head:setBackGroundImage("images/ui/home/home_head_bg_women.png")
    end
    local BitmapFontLabel_vip = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_vip")
    local Text_lv = ccui.Helper:seekWidgetByName(root,"Text_lv")
    local Text_faction = ccui.Helper:seekWidgetByName(root,"Text_faction")
    local num = tonumber(_ED.user_info.user_force)
    BitmapFontLabel_vip:setString("V".._ED.vip_grade)
    Text_lv:setString(_ED.user_info.user_grade)
    Text_faction:setString("".._ED.user_info.fighter_capacity)--red_alert_hero_camp[num]
    self.vip_text = BitmapFontLabel_vip
    self.lv_text = Text_lv    
end

function PlayerInfo:onUpdate(dt)
    if self.vip_text == nil or self.lv_text == nil then
        return
    end
    self.vip_text:setString("V".._ED.vip_grade)
    self.lv_text:setString(_ED.user_info.user_grade)
end

function PlayerInfo:onInit()
    local csbItem = csb.createNode(config_csb.player.player_info)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
	self:updateDraw()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_leading_head"), nil, 
    {
        terminal_name = "player_infor_window_window_open", 
        terminal_state = 0, 
    }, nil, 0)      
    
end

function PlayerInfo:onEnterTransitionFinish()

end

function PlayerInfo:init()
	self:onInit()
end

function PlayerInfo:onExit()
    state_machine.remove("player_info_window_show")
    state_machine.remove("player_info_window_hide")
    state_machine.remove("player_info_update_draw")
end