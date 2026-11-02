-----------------------------
--国战城市战斗cd清除
-----------------------------
NationalWarCityWarCdRemoveTip = class("NationalWarCityWarCdRemoveTipClass", Window)

local national_war_city_war_cd_remove_window_open_terminal = {
    _name = "national_war_city_war_cd_remove_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        -- if fwin:find("NationalWarCityWarCdRemoveTipClass") == nil then
            fwin:open(NationalWarCityWarCdRemoveTip:new():init(params), fwin._view)
        -- end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_city_war_cd_remove_window_close_terminal = {
    _name = "national_war_city_war_cd_remove_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarCityWarCdRemoveTipClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_city_war_cd_remove_window_open_terminal)
state_machine.add(national_war_city_war_cd_remove_window_close_terminal)
state_machine.init()

function NationalWarCityWarCdRemoveTip:ctor()
    self.super:ctor()
    self.roots = {}
	self.city_id = nil
	self.remainTime = 0
	self.m_isBattle = false

    -- Initialize NationalWarMap state machine.
    local function init_national_war_war_city_cd_operating_terminal()
		
		--战斗CD清除
		local national_war_city_war_cd_remove_confirm_terminal = {
            _name = "national_war_city_war_cd_remove_confirm",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						
					end
				end
				protocol_command.clear_fight_cd.param_list = self.city_id
				NetworkManager:register(protocol_command.clear_fight_cd.code, nil, nil, nil,nil, responseCallback, false, nil)
				state_machine.excute("national_war_city_war_cd_remove_window_close",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(national_war_city_war_cd_remove_confirm_terminal)  
        state_machine.init()
    end
    
    -- call func init rebirth state machine.
    init_national_war_war_city_cd_operating_terminal()
end

function NationalWarCityWarCdRemoveTip:onInit( )
    local csbItem = csb.createNode(config_csb.utils.prompt_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
	--关闭 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_4_8"), nil, 
    {
        terminal_name = "national_war_city_war_cd_remove_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
	--确定
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_3_6"), nil, 
    {
        terminal_name = "national_war_city_war_cd_remove_confirm", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
	
	local Text_141 = ccui.Helper:seekWidgetByName(root,"Text_141")
	local consume = zstring.split(dms.string(dms["warfare_config"], 5, warfare_config.param), ",")
	Text_141:setString(string.format(red_alert_war_city_map_tip[3],zstring.tonumber(consume[3])))
end

function NationalWarCityWarCdRemoveTip:onUpdate(dt)
	
end

function NationalWarCityWarCdRemoveTip:init(params)
	self.city_id = params[1]
    self:onInit()
    return self
end

function NationalWarCityWarCdRemoveTip:onExit()
    state_machine.remove("national_war_city_war_cd_remove_confirm")  
end
