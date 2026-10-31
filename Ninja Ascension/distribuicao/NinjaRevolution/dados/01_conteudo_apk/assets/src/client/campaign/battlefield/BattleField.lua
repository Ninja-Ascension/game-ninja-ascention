-- ----------------------------------------------------------------------------------------------------
-- 说明：皇骑战场主界面
-------------------------------------------------------------------------------------------------------

BattleField = class("BattleFieldClass", Window)

local battle_field_window_open_terminal = {
    _name = "battle_field_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("BattleFieldClass") then
        	local battlemWindow = BattleField:new()
			battlemWindow:init()
			fwin:open(battlemWindow, fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_field_window_close_terminal = {
    _name = "battle_field_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:open(Campaign:new(), fwin._view)
        fwin:close(fwin:find("BattleFieldClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_field_window_open_terminal)
state_machine.add(battle_field_window_close_terminal)
state_machine.init()

function BattleField:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}

    self._restButton = nil -- 重置按钮
    self._nextButton = nil -- 下一关按钮
    self._mapPage = nil -- 地图层
	app.load("client.campaign.battlefield.BattleFieldMap")
    -- Initialize BattleField page state machine.
    local function init_battle_field_terminal()
		--打开帮助
		local battle_field_open_help_terminal = {
            _name = "battle_field_open_help",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	app.load("client.campaign.battlefield.BattleFieldHelp")
            	state_machine.excute("battle_field_help_window_open",0,"")	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--打开排行榜
        local battle_field_open_rank_terminal = {
            _name = "battle_field_open_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseBattleFieldRankCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.campaign.battlefield.BattleFieldRankWindow")
                        state_machine.excute("battle_field_rank_window_open",0,"")  
                    end
                end
                protocol_command.search_order_list.param_list = "16"
                NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responseBattleFieldRankCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--打开商店
		local battle_field_open_shop_terminal = {
            _name = "battle_field_open_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local openLevel = dms.int(dms["fun_open_condition"], 55, fun_open_condition.level)
                local userlevel = tonumber(_ED.user_info.user_grade)
                if userlevel >= openLevel then 
                    app.load("client.packs.pet.PetShop")                
                    local cell = PetShop:new()
                    cell:init(1)
                    fwin:open(cell, fwin._view)  
                else
                    TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 55, fun_open_condition.tip_info))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --重置
        local battle_field_reset_terminal = {
            _name = "battle_field_reset",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if _ED._pet_battle_filed_info.remain_free_rest_times > 0 then 
                    --有重置次数
                    local function requestReset(instance,n)
                        if n == 0 then 
                            state_machine.excute("battle_field_reset_request",0,0)
                        end
                    end
                    app.load("client.utils.ConfirmPrompted")
                    local tip = ConfirmPrompted:new()
                    tip:init(self, requestReset, _pet_tipString_info[34])
                    fwin:open(tip,fwin._ui)
                    
                else
                    TipDlg.drawTextDailog(_pet_tipString_info[36])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --重置回调函数
        local battle_field_reset_request_terminal = {
            _name = "battle_field_reset_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseResetCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                        end
                    end
                end
                NetworkManager:register(protocol_command.pet_counterpart_reset.code, nil, nil, nil, instance, responseResetCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --下一关
        local battle_field_next_floor_terminal = {
            _name = "battle_field_next_floor",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if _ED._pet_battle_filed_info.box_open_free_times > 0 then 
                    --需要开启宝箱才可以进入下一关
                    local function popRewardDialog(instance,n)
                        if n == 0 then 
                            state_machine.excute("battle_field_map_pop_reward",0,0)
                        end
                    end
                    app.load("client.utils.ConfirmPrompted")
                    local tip = ConfirmPrompted:new()
                    tip:init(self, popRewardDialog, _pet_tipString_info[37])
                    fwin:open(tip,fwin._ui)
                else
                    --请求
                    local _self = params._datas._self
                    local function responseNextFloorCallBack(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                response.node:onUpdateDraw()
                            end
                        end
                    end
                    NetworkManager:register(protocol_command.pet_counterpart_go_next.code, nil, nil, nil, _self, responseNextFloorCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

 		--刷新驯兽魂数量显示
        local battle_field_update_soul_terminal = {
            _name = "battle_field_update_soul",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                ccui.Helper:seekWidgetByName(instance.roots[1], "Text_xsh_1"):setString("".._ED.user_info.pet_soul)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(battle_field_open_help_terminal)
		state_machine.add(battle_field_open_shop_terminal)
        state_machine.add(battle_field_open_rank_terminal)
        state_machine.add(battle_field_reset_terminal)
        state_machine.add(battle_field_next_floor_terminal)
        state_machine.add(battle_field_reset_request_terminal)
        state_machine.add(battle_field_update_soul_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_battle_field_terminal()
end

function BattleField:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local current_floor = zstring.tonumber(_ED._pet_battle_filed_info.current_floor)
    for i=1,4 do
        local floorPanel = ccui.Helper:seekWidgetByName(root, "Panel_floor_number_"..i)
        if i <= current_floor then 
            floorPanel:setVisible(true)
        else
            floorPanel:setVisible(false)
        end
    end
    ccui.Helper:seekWidgetByName(root, "Text_czcs_1"):setString("".._ED._pet_battle_filed_info.remain_free_rest_times)
    ccui.Helper:seekWidgetByName(root, "Text_tzcs_1"):setString("".._ED._pet_battle_filed_info.remain_attact_times)
    ccui.Helper:seekWidgetByName(root, "Text_xsh_1"):setString("".._ED.user_info.pet_soul)
    self._mapPage:onUpdateDraw()
    local maxIndex = 1
    for i=1,12 do
        -- 0未激活 1激活 2击杀
        local attact_state = _ED._pet_battle_filed_info.players[i]._player_attact_state
        if attact_state == 2 then
           maxIndex = i
        end
    end
    local per = 120 - math.floor(tonumber(maxIndex)/3) * 30
    if per >= 120 then 
        per = 100
    end
    self._mapPanel:jumpToPercentVertical(per)

    local can_get_reward = self._mapPage._can_get_reward
     
     if current_floor == 4 then
        --第四关是最后一关，没有下一关
        self._restButton:setVisible(true)
        self._nextButton:setVisible(false)
    else
        self._restButton:setVisible(can_get_reward == false)
        self._nextButton:setVisible(can_get_reward)
    end
end

function BattleField:onEnterTransitionFinish()
	local csbBattleField = csb.createNode("campaign/BattleField/BattleField.csb")
	local root = csbBattleField:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbBattleField)
	--缓存ScrollView_1
	self._mapPanel = ccui.Helper:seekWidgetByName(root, "ScrollView_map")
	local mapCell = BattleFieldMap:new()
	mapCell:init()
	self._mapPanel:addChild(mapCell)
    self._mapPage = mapCell

    app.load("client.player.UserInformationHeroStorage")
    fwin:open(UserInformationHeroStorage:new(), fwin._ui)
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1_backBtn"), 	nil, 
	{
		terminal_name = "battle_field_window_close", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)

	--帮助
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1_help"), 	nil, 
	{
		terminal_name = "battle_field_open_help", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
    --排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1_phb"),     nil, 
    {
        terminal_name = "battle_field_open_rank",   
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

	--商店
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1_xssd"), 	nil, 
	{
		terminal_name = "battle_field_open_shop", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)

    self._restButton = ccui.Helper:seekWidgetByName(root, "Button_cz") -- 重置按钮
    self._nextButton = ccui.Helper:seekWidgetByName(root, "Button_next") -- 下一关按钮
    --重置次数
    fwin:addTouchEventListener(self._restButton,     nil, 
    {
        terminal_name = "battle_field_reset",   
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    --下一关
    fwin:addTouchEventListener(self._nextButton,     nil, 
    {
        terminal_name = "battle_field_next_floor",   
        terminal_state = 0, 
        isPressedActionEnabled = true,
        _self = self,
    }, 
    nil, 2)

    self:onUpdateDraw()
end

function BattleField:init(changeStates, isRefreshed)

end

function BattleField:close()
    fwin:close(fwin:find("UserInformationHeroStorageClass"))
end

function BattleField:onExit()
	state_machine.remove("battle_field_close_window")
	state_machine.remove("battle_field_open_help")
	state_machine.remove("battle_field_open_shop")
    state_machine.remove("battle_field_open_rank")
    state_machine.remove("battle_field_reset")
    state_machine.remove("battle_field_next_floor")
    state_machine.remove("battle_field_reset_request")
    state_machine.remove("battle_field_update_soul")
end
