--------------------------------------------------------------------------------------------------------------
--  说明：繁荣度购买
--------------------------------------------------------------------------------------------------------------
PlayerInfoBoomUp = class("PlayerInfoBoomUpClass", Window)

--打开界面
local player_info_boom_up_open_terminal = {
	_name = "player_info_boom_up_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("PlayerInfoBoomUpClass") == nil then
    		fwin:open(PlayerInfoBoomUp:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_info_boom_up_close_terminal = {
	_name = "player_info_boom_up_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerInfoBoomUpClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_info_boom_up_open_terminal)
state_machine.add(player_info_boom_up_close_terminal)
state_machine.init()

function PlayerInfoBoomUp:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    local function init_player_info_boom_up_terminal()
        local player_info_boom_up_buy_terminal = {
            _name = "player_info_boom_up_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cost = dms.int(dms["major_city_config"], 15, major_city_config.param)
                local lose = zstring.tonumber(_ED.user_info.forage) - zstring.tonumber(_ED.user_info.booming)
                local info = {zstring.tonumber(_ED.user_info.forage) * 0.1, zstring.tonumber(_ED.user_info.forage) * 0.5, lose}
                local reward = math.ceil(info[params._datas.index] / cost)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(red_alert_time_str[107])
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:updateDraw()
                        end
                        state_machine.excute("player_infor_boom_window_update_draw", 0, nil)
                        state_machine.excute("player_infomation_update_info", 0, nil)
                        _ED.show_reward_list_group = {}
                        state_machine.excute("main_window_update_boom_info", 0, nil)
                        state_machine.excute("red_alert_time_mine_back_to_base_update", 0, nil)
                    end
                end
                protocol_command.boom_buy.param_list = params._datas.index
                NetworkManager:register(protocol_command.boom_buy.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_info_boom_up_buy_terminal) 
        state_machine.init()
    end
    
    init_player_info_boom_up_terminal()
end

function PlayerInfoBoomUp:updateDraw()
    local root = self.roots[1]
    local cost = dms.int(dms["major_city_config"], 15, major_city_config.param)
    local lose = zstring.tonumber(_ED.user_info.forage) - zstring.tonumber(_ED.user_info.booming)
    local info = {zstring.tonumber(_ED.user_info.forage) * 0.1, zstring.tonumber(_ED.user_info.forage) * 0.5, lose}
    for i=1,3 do
        local Button_boom_sure = ccui.Helper:seekWidgetByName(root, "Button_boom_sure_"..i)
        local Text_up_boom_spend = ccui.Helper:seekWidgetByName(root, "Text_up_boom_spend_"..i)
        if lose > 0 and lose >= info[i] then
            Button_boom_sure:setBright(true)
            Button_boom_sure:setTouchEnabled(true)
        else
            Button_boom_sure:setBright(false)
            Button_boom_sure:setTouchEnabled(false)
        end
        if __lua_project_id == __lua_project_pacific_rim then
            Text_up_boom_spend:setString(math.ceil(info[i]/cost))
        else
            Text_up_boom_spend:setString(string.format(red_alert_all_str[293], math.ceil(info[i]/cost)))
        end
    end
end

--初始化
function PlayerInfoBoomUp:onInit()
    local csbItem = csb.createNode(config_csb.player.player_infor_boom_up_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN, 0.1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boom_up_close"), nil, 
    {
        terminal_name = "player_info_boom_up_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "player_info_boom_up_close", 
        terminal_state = 0, 
    }, nil, 3)

    for i=1,3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_boom_sure_"..i), nil, 
        {
            terminal_name = "player_info_boom_up_buy", 
            terminal_state = 0, 
            touch_black = true,
            index = i,
        }, nil, 1)
    end

    self:updateDraw()
end

function PlayerInfoBoomUp:onEnterTransitionFinish()

end

function PlayerInfoBoomUp:init(param)
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function PlayerInfoBoomUp:onExit()
    state_machine.remove("player_info_boom_up_buy")
end