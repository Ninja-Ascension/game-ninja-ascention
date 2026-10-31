--------------------------------------------------------------------------------------------------------------
--  说明：角色声望购买
--------------------------------------------------------------------------------------------------------------
PlayerInfoPrestige = class("PlayerInfoPrestigeClass", Window)

--打开界面
local player_info_prestige_open_terminal = {
	_name = "player_info_prestige_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("PlayerInfoPrestigeClass") == nil then
    		fwin:open(PlayerInfoPrestige:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_info_prestige_close_terminal = {
	_name = "player_info_prestige_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerInfoPrestigeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_info_prestige_open_terminal)
state_machine.add(player_info_prestige_close_terminal)
state_machine.init()

function PlayerInfoPrestige:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    local function init_player_info_prestige_terminal()
        local player_info_prestige_buy_terminal = {
            _name = "player_info_prestige_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local info = {20, 80, 400, 1000}
                local reward = info[params._datas.index]
                local consume_info = {0, 10, 40, 90}
                local consume_gold = consume_info[params._datas.index]
                _ED.last_prestige_level = _ED.user_info.credit_level
                if tonumber(_ED.user_info.credit_buy_state) == 1 then
                    TipDlg.drawTextDailog(red_alert_time_str[252])
                    return
                end
                if tonumber(_ED.user_info.user_gold) < tonumber(consume_gold) then
                    TipDlg.drawTextDailog(tipStringInfo_campaign_info[16])
                    return
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:updateDraw()
                            TipDlg.drawTextDailog(string.format(red_alert_all_str[284], reward))
                            state_machine.excute("player_infomation_update_info", 0, nil)
                            state_machine.excute("build_up_scientific_info_update_draw", 0, nil)
                            state_machine.excute("build_up_scientific_up_update_draw",0,"")
                            state_machine.excute("build_up_scientific_to_update_draw", 0, nil)
                            checkEffectLevelUp()
                            checkRewardObtainDraw()
                        end
                    end
                end
                protocol_command.buy_prestige.param_list = params._datas.index
                NetworkManager:register(protocol_command.buy_prestige.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_info_prestige_buy_terminal) 
        state_machine.init()
    end
    
    init_player_info_prestige_terminal()
end

function PlayerInfoPrestige:updateDraw()
    local root = self.roots[1]
    local Text_world_lv_tit = ccui.Helper:seekWidgetByName(root, "Text_world_lv_tit")
    Text_world_lv_tit:setString(red_alert_all_str[285].."  "..string.format(red_alert_all_str[13], "".._ED.user_info.credit_level))
    if tonumber(_ED.user_info.credit_buy_state) == 1 then
        for i=1,4 do
            ccui.Helper:seekWidgetByName(root, "Button_prestige_up_"..i):setBright(false)
        end
    else
        for i=1,4 do
            ccui.Helper:seekWidgetByName(root, "Button_prestige_up_"..i):setBright(true)
        end
    end
end

--初始化
function PlayerInfoPrestige:onInit()
    local csbItem = csb.createNode(config_csb.player.player_infor_prestige_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN, 0.1)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_world_lv_close"), nil, 
    {
        terminal_name = "player_info_prestige_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "player_info_prestige_close", 
        terminal_state = 0, 
    }, nil, 3)

    for i=1,4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_prestige_up_"..i), nil, 
        {
            terminal_name = "player_info_prestige_buy", 
            terminal_state = 0, 
            touch_black = true,
            index = i,
        }, nil, 1)
    end

    self:updateDraw()
end

function PlayerInfoPrestige:onEnterTransitionFinish()

end

function PlayerInfoPrestige:init(param)
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function PlayerInfoPrestige:onExit()
    state_machine.remove("player_info_prestige_buy")
end