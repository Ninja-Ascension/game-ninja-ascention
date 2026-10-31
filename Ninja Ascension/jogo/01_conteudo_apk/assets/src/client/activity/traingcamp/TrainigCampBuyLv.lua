--大师训练营购买等级
TrainigCampBuyLv = class("TrainigCampBuyLvClass", Window)

local training_camp_buy_lv_open_terminal = {
	_name = "training_camp_buy_lv_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("TrainigCampBuyLvClass") == nil then
			fwin:open(TrainigCampBuyLv:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local training_camp_buy_lv_close_terminal = {
	_name = "training_camp_buy_lv_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TrainigCampBuyLvClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(training_camp_buy_lv_open_terminal)
state_machine.add(training_camp_buy_lv_close_terminal)
state_machine.init()

function TrainigCampBuyLv:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.cells.activity.training_camp_buy_lv_list_cell")
    app.load("client.utils.ConfirmTip")
    app.load("client.utils.BuyConfirmTip")
    local function init_training_camp_buy_lv_terminal()
        local training_camp_buy_lv_terminal = {
            _name = "training_camp_buy_lv_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local exp = dms.int(dms["activity_config"], 37, activity_config.param)
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local tip = ConfirmTip:new()
                        tip:init(instance, instance.onEnterTransitionFinish, string.format(tipStringInfo_training_camp_name[13],exp*params._datas.lv))
                        fwin:open(tip,fwin._windows)
                    end
                end
                protocol_command.activity_pokemon_master_buy_level.param_list = params._datas.grade
                NetworkManager:register(protocol_command.activity_pokemon_master_buy_level.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local training_camp_buy_confirm_tip_terminal = {
            _name = "training_camp_buy_confirm_tip",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            local _price =  params._datas.donation
            local callback = "training_camp_buy_lv_button"
            local info = json.decode(_ED.active_activity[157].activity_params)
            local lvbest = dms.int(dms["activity_config"], 38, activity_config.param)
            if tonumber(info.userActivityInfo.level) >= lvbest   then
                TipDlg.drawTextDailog(tipStringInfo_training_camp_name[21])
            else
               state_machine.excute("buy_confirm_tip_open", 0, {1, _price, tipStringInfo_training_camp_name[20], callback, params._datas, tipStringInfo_training_camp_name[20]})
            end
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(training_camp_buy_lv_terminal)
        state_machine.add(training_camp_buy_confirm_tip_terminal)
        state_machine.init()
    end
    init_training_camp_buy_lv_terminal()
end

function TrainigCampBuyLv:onUpdateDraw()
    local ListView_camp_buy_lv = ccui.Helper:seekWidgetByName(self.roots[1],"ListView_camp_buy_lv")
    ListView_camp_buy_lv:removeAllItems()
    
    local Text_season_end_time_t = ccui.Helper:seekWidgetByName(self.roots[1],"Text_season_end_time_t")
    Text_season_end_time_t:setString(string.format(tipStringInfo_training_camp_name[18],_ED.training_camp_reward_info.season))
    
    local end_time = os.date("%m"..".".."%d".."  ".."%H"..":".."%M", getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(_ED.training_camp_reward_info.closeTime)/1000)))
    
    local Text_season_end_time = ccui.Helper:seekWidgetByName(self.roots[1],"Text_season_end_time")
    Text_season_end_time:setString(end_time)

   
    local info = zstring.splits(dms.string(dms["activity_config"], 40, activity_config.param),"|",",")
    local count = 0
    for i, v in pairs(info) do
    	count = count +1
        local cell = state_machine.excute("training_camp_buy_lv_list_cell_create",0,{v,count})
        ListView_camp_buy_lv:addChild(cell)
    end
    ListView_camp_buy_lv:requestRefreshView()

end


function TrainigCampBuyLv:onUpdate(dt)
  
end

function TrainigCampBuyLv:init(params)
    self._rootWindows = params[1]
	self:onInit()
    return self
end

function TrainigCampBuyLv:onInit()
    local csbItem = csb.createNode("activity/wonderful/training_camp_buy_lv.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    self:onUpdateDraw()
    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_camp_buy_lv_closed"), nil,   --关闭
    {
        terminal_name = "training_camp_buy_lv_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
end

function TrainigCampBuyLv:onEnterTransitionFinish()
end

function TrainigCampBuyLv:onExit()
	-- state_machine.remove("egg_machine_window_update_draw")
	-- state_machine.remove("egg_machine_window_recruiting")
end

