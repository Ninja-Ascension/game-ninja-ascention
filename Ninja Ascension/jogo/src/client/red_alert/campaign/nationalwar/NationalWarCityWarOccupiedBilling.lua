-----------------------------
--国战城市战争城池结算
-----------------------------
NationalWarCityWarOccupiedBilling = class("NationalWarCityWarOccupiedBillingClass", Window)

local national_war_city_war_occupied_billing_window_open_terminal = {
    _name = "national_war_city_war_occupied_billing_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        if fwin:find("NationalWarCityWarOccupiedBillingClass") == nil then
            fwin:open(NationalWarCityWarOccupiedBilling:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_city_war_occupied_billing_window_close_terminal = {
    _name = "national_war_city_war_occupied_billing_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarCityWarOccupiedBillingClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_city_war_occupied_billing_window_open_terminal)
state_machine.add(national_war_city_war_occupied_billing_window_close_terminal)
state_machine.init()

function NationalWarCityWarOccupiedBilling:ctor()
    self.super:ctor()
    self.roots = {}
	self.city_id = nil
	-- app.load("client.red_alert.campaign.nationalwar.NationalRank")
    -- Initialize NationalWarMap state machine.
    local function init_national_war_war_city_war_occupied_billing_terminal()
		--确定按钮
        local national_war_city_war_city_war_occupied_confirm_terminal = {
            _name = "national_war_city_war_city_war_occupied_confirm",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--如果胜利
				if zstring.tonumber(_ED.war_in_city_info.now_city_camp) == zstring.tonumber(_ED.user_info.user_force) then
					state_machine.excute("national_war_city_war_occupied_refresh",0,"")
					state_machine.excute("national_war_city_war_occupied_billing_window_close",0,"")
				else --否则结束
					state_machine.excute("national_war_city_war_map_ui_close",0,"")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		state_machine.add(national_war_city_war_city_war_occupied_confirm_terminal)  
        state_machine.init()
    end
    
    -- call func init rebirth state machine.
    init_national_war_war_city_war_occupied_billing_terminal()
end

function NationalWarCityWarOccupiedBilling:onInit()
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_occupied_billing)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
	--关闭 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_occupied_sure"), nil, 
    {
        terminal_name = "national_war_city_war_city_war_occupied_confirm", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
	
	
	self:updateDraw()
end


function NationalWarCityWarOccupiedBilling:updateDraw()
	local root = self.roots[1]
	local Panel_occupied_billing_camp = ccui.Helper:seekWidgetByName(root,"Panel_occupied_billing_camp")
	Panel_occupied_billing_camp:setBackGroundImage(string.format("images/ui/quality/camp_%d.png", zstring.tonumber(_ED.warfareCityInfo[zstring.tonumber(self.city_id)].camp)))
	local Text_occupied_billing = ccui.Helper:seekWidgetByName(root,"Text_occupied_billing")
	local city_data_table = dms.element(dms[config_res.campaign.nationalwar.warfare_map_mould],self.city_id)
    local name = dms.atos(city_data_table,warfare_map_mould.city_name)
	Text_occupied_billing:setString(red_alert_hero_camp[zstring.tonumber(_ED.warfareCityInfo[zstring.tonumber(self.city_id)].camp)].."占领了"..name)
end

function NationalWarCityWarOccupiedBilling:onUpdate(dt)
	
end

function NationalWarCityWarOccupiedBilling:init(params)
	self.city_id = params[1]
    self:onInit()
    return self
end

function NationalWarCityWarOccupiedBilling:onExit()
    state_machine.remove("national_war_city_war_city_war_occupied_confirm")
end
