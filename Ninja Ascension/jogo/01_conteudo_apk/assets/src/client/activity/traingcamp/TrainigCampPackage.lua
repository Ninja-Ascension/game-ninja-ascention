--大师训练营进阶战营
TrainigCampPackage = class("TrainigCampPackageClass", Window)

local training_camp_package_open_terminal = {
	_name = "training_camp_package_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("TrainigCampPackageClass") == nil then
			fwin:open(TrainigCampPackage:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local training_camp_package_close_terminal = {
	_name = "training_camp_package_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TrainigCampPackageClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(training_camp_package_open_terminal)
state_machine.add(training_camp_package_close_terminal)
state_machine.init()

function TrainigCampPackage:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.cells.activity.training_camp_task_list_cell")
    app.load("client.utils.BuyConfirmTip")
    local function init_training_camp_package_terminal()
        local training_camp_package_terminal = {
            _name = "training_camp_package_buy_pack",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                    local paynum = dms.int(dms["activity_config"], 45, activity_config.param)
                    local info = json.decode(_ED.active_activity[157].activity_params)
                    if tonumber(info.userActivityInfo.rechageNum) < paynum then
                         TipDlg.drawTextDailog(tipStringInfo_training_camp_name[15])  
                    else 
                        local function callBack( response )
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                if  params._datas.buytype == 1  then
                                    TipDlg.drawTextDailog(tipStringInfo_prop_buy_tip[2])  
                                else
                                    local getRewardWnd = DrawRareReward:new()
                                    getRewardWnd:init(7)
                                    fwin:open(getRewardWnd, fwin._ui)
                                    TipDlg.drawTextDailog(tipStringInfo_training_camp_name[24])  
                                end
                            end
                        end
                        protocol_command.activity_pokemon_master_buy_master.param_list = params._datas.buytype
                        NetworkManager:register(protocol_command.activity_pokemon_master_buy_master.code, nil, nil, nil, instance, callBack, false, nil)
                    end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local training_camp_package_confirm_tip_terminal = {
            _name = "training_camp_package_confirm_tip",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            local paynum = dms.int(dms["activity_config"], 45, activity_config.param)
            local info = json.decode(_ED.active_activity[157].activity_params)
            local callback = "training_camp_package_buy_pack"
            local donations = zstring.split(dms.string(dms["activity_config"], 44, activity_config.param),",") 
            local _price =  0

            local txt = ""
            if tonumber(params._datas.buytype) ==  1 then
                txt = tipStringInfo_training_camp_name[22]
                _price = donations[1]
            else
                txt = tipStringInfo_training_camp_name[23]
                _price = donations[2]
            end

            if tonumber(info.userActivityInfo.rechageNum) < paynum then
                TipDlg.drawTextDailog(tipStringInfo_training_camp_name[15]) 
            else
                state_machine.excute("buy_confirm_tip_open", 0, {1, _price, txt, callback, params._datas,txt})
            end 
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(training_camp_package_terminal)
        state_machine.add(training_camp_package_confirm_tip_terminal)
        state_machine.init()
    end
    init_training_camp_package_terminal()
end

function TrainigCampPackage:onUpdateDraw()
    local rewardlvinfo =  zstring.split(dms.string(dms["activity_config"], 41, activity_config.param), ",")
    
    local paynum = dms.int(dms["activity_config"], 45, activity_config.param)

    local info = json.decode(_ED.active_activity[157].activity_params)
  
    local LoadingBar_training_charge =  ccui.Helper:seekWidgetByName(self.roots[1],"LoadingBar_training_charge")  --进度条
    LoadingBar_training_charge:setPercent(info.userActivityInfo.rechageNum/paynum*100)
    
    local Text_camp_lv_reward_t_2_0 = ccui.Helper:seekWidgetByName(self.roots[1],"Text_camp_lv_reward_t_2_0")
    Text_camp_lv_reward_t_2_0:setString(info.userActivityInfo.rechageNum.."/"..paynum)
    
    local Text_camp_lv_reward_t_2 = ccui.Helper:seekWidgetByName(self.roots[1],"Text_camp_lv_reward_t_2")
    Text_camp_lv_reward_t_2:setString(string.format(tipStringInfo_training_camp_name[14],paynum))

    local  donations = zstring.split(dms.string(dms["activity_config"], 44, activity_config.param),",") 

    local Text_camp_lv_reward_t_0_1 =  ccui.Helper:seekWidgetByName(self.roots[1],"Text_camp_lv_reward_t_0_1")  --礼包1钻石
    Text_camp_lv_reward_t_0_1:setString(donations[1])

    local Text_camp_lv_reward_t_0_1_0 =  ccui.Helper:seekWidgetByName(self.roots[1],"Text_camp_lv_reward_t_0_1_0")  --礼包2钻石 
    Text_camp_lv_reward_t_0_1_0:setString(donations[2])

    for i=1,3 do
        local rewardinfo = _ED.training_camp_reward_info.masterReward[tonumber(rewardlvinfo[i])]
        rewardinfo = zstring.splits(rewardinfo, "|", ",")
        local name = ""
        if tonumber(rewardinfo[1][1]) == 6 then
            name = setThePropsIcon(rewardinfo[1][2])[2]
        elseif tonumber(rewardinfo[1][1]) == 7 then
            name = smEquipWordlFundByIndex(rewardinfo[1][2] , 1)
        end
        local Text_camp_lv_reward_infor_0_ = ccui.Helper:seekWidgetByName(self.roots[1],"Text_camp_lv_reward_infor_0_"..i)
        Text_camp_lv_reward_infor_0_:setString(name)
       
        local Text_camp_lv_reward_infor_ = ccui.Helper:seekWidgetByName(self.roots[1],"Text_camp_lv_reward_infor_"..i)
        Text_camp_lv_reward_infor_:setString(name)

        if i == 3 then
            Text_camp_lv_reward_infor_0_:setString(name..tipStringInfo_training_camp_name[17])
            Text_camp_lv_reward_infor_:setString(name..tipStringInfo_training_camp_name[17])
        end
    end
end


function TrainigCampPackage:onUpdate(dt)
  
end

function TrainigCampPackage:init(params)
    self._rootWindows = params[1]
	self:onInit()
    return self
end

function TrainigCampPackage:onInit()
    local csbItem = csb.createNode("activity/wonderful/training_camp_package.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    self:onUpdateDraw()

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil,   --关闭
    {
        terminal_name = "training_camp_package_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_reward_package_buy"), nil,   --普通进阶
    {
        terminal_name = "training_camp_package_confirm_tip", 
        terminal_state = 0, 
        touch_black = true,
        buytype = 1,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_reward_package_buy_b"), nil,   --豪华进阶
    {
        terminal_name = "training_camp_package_confirm_tip", 
        terminal_state = 0, 
        touch_black = true,
        buytype = 2,
    }, nil, 3)
end

function TrainigCampPackage:onEnterTransitionFinish()
end

function TrainigCampPackage:onExit()
	-- state_machine.remove("egg_machine_window_update_draw")
	-- state_machine.remove("egg_machine_window_recruiting")
end

