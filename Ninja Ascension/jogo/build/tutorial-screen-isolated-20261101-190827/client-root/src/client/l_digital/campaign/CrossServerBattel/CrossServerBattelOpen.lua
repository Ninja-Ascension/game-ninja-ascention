-- ----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战开启界面
-------------------------------------------------------------------------------------------------------
CrossServerBattelOpen = class("CrossServerBattelOpenClass", Window)

local cross_server_battel_open_window_open_terminal = {
    _name = "cross_server_battel_open_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local function responseCrossServerBattelInitCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                fwin:open(CrossServerBattelOpen:new(params), fwin._view)
                local all_users = tonumber(_ED.cross_server_battel_map_info.rankListSize)
                if all_users > 10 then
                    state_machine.excute("cross_server_battel_map_window_update", 0, 1)
                else
                    state_machine.excute("cross_server_battel_map_window_update", 0, 2)
                end
            end
        end

        NetworkManager:register(protocol_command.cross_mine_init.code, nil, nil, nil, nil, responseCrossServerBattelInitCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local cross_server_battel_open_window_close_terminal = {
    _name = "cross_server_battel_open_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:close(fwin:find("CrossServerBattelOpenClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(cross_server_battel_open_window_open_terminal)
state_machine.add(cross_server_battel_open_window_close_terminal)
state_machine.init()


function CrossServerBattelOpen:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
	self._armature = nil
    self.current_type = 1
    self.left_time = nil

	-- load lua file
	app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelAddition")
    app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelFormation")
    app.load("client.l_digital.cells.campaign.CrossServerBattel.cross_service_rank_open_cell")
	
    -- Initialize Arena page state machine.
    local function init_cross_server_battel_open_terminal()
		local cross_server_battel_map_terminal = {
		    _name = "cross_server_battel_open",
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

        local cross_server_battel_swich_map_terminal = {
            _name = "cross_server_battel_swich_map",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.CrossServerBattel.CrossServerBattelMap")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local map_type = params._datas._type
                if instance.is_gaoji_only then
                    return
                end

                if instance.current_type == map_type then
                    instance:btnMoveAction(map_type)
                else
                    instance.current_type = map_type
                    instance:btnChangeUI(map_type)
                    state_machine.excute("cross_server_battel_map_window_update", 0, map_type)
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_mineral_num_update_terminal = {
            _name = "cross_server_battel_mineral_num_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local Text_cross_me_n = ccui.Helper:seekWidgetByName(root, "Text_cross_me_n")
                Text_cross_me_n:setString(_ED.cross_server_battel_mineral_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_loot_num_update_terminal = {
            _name = "cross_server_battel_loot_num_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local Text_cross_snatch_times_n = ccui.Helper:seekWidgetByName(root, "Text_cross_snatch_times_n")
                local Button_snatch_time_add = ccui.Helper:seekWidgetByName(root, "Button_snatch_time_add")
                local max_num = dms.int(dms["gvg_config"], 6, gvg_config.param)
                Text_cross_snatch_times_n:setString(_ED.cross_server_battel_map_rob_info.lootCount.freeTime .. "/" .. max_num)
                Button_snatch_time_add:setVisible(zstring.tonumber(_ED.cross_server_battel_map_rob_info.lootCount.freeTime) <= 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_map_refresh_terminal = {
            _name = "cross_server_battel_map_refresh",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]

                if tonumber(_ED.cross_server_battel_mineral_num) < tonumber(_ED.cross_server_battel_map_refresh.needMineNum) then
                    TipDlg.drawTextDailog(tipStringInfo_cross_server_battel_tips[7])
                    return
                end

                local function responseCrossServerBattelMapRefreshCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node and response.node.roots[1] then
                            local root = response.node.roots[1]
                            local Text_change_zuanshi_n = ccui.Helper:seekWidgetByName(root, "Text_change_zuanshi_n")
                            local des = tonumber(_ED.cross_server_battel_map_refresh.needMineNum) == 0 and tipStringInfo_cross_server_battel_tips[15] or _ED.cross_server_battel_map_refresh.needMineNum
    
                            Text_change_zuanshi_n:setString(des)
                            state_machine.excute("cross_server_battel_mineral_num_update", 0, "")
                            state_machine.excute("cross_server_battel_map_window_update", 0, 1)
                        end
                    end
                end
                NetworkManager:register(protocol_command.cross_mine_user_lounch_refresh.code, nil, nil, nil, instance, responseCrossServerBattelMapRefreshCallback, false, nil)
        
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_grab_num_add_terminal = {
            _name = "cross_server_battel_grab_num_add",
            _init = function (terminal)
                app.load("client.utils.BuyConfirmTip")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.cross_server_battel_map_rob_info.lootCount.freeTime) <= 0 then
                    local needData = zstring.split(dms.string(dms["gvg_config"], 7, gvg_config.param), ",")
                    local buy_times = zstring.tonumber(_ED.cross_server_battel_map_rob_info.lootCount.buyCount)
                    local _price = 0
                    if buy_times > #needData then
                        _price = tonumber(needData[#needData])
                    else
                        _price = needData[buy_times + 1]
                    end
                    local callback = "cross_server_battel_grab_num_add_buy_confirm"
                    state_machine.excute("buy_confirm_tip_open", 0, {1, _price, tipStringInfo_cross_server_battel_tips[19], callback, params._datas, tipStringInfo_cross_server_battel_tips[30]})
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local cross_server_battel_grab_num_add_buy_confirm_terminal = {
            _name = "cross_server_battel_grab_num_add_buy_confirm",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCrossServerBattelInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(_string_piece_info[76])
                        state_machine.excute("cross_server_battel_loot_num_update",0,"")
                    end
                end
                protocol_command.cross_mine_buy_loot_or_revenge.param_list = 1
                NetworkManager:register(protocol_command.cross_mine_buy_loot_or_revenge.code, nil, nil, nil, nil, responseCrossServerBattelInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(cross_server_battel_map_terminal)
		state_machine.add(cross_server_battel_swich_map_terminal)
        state_machine.add(cross_server_battel_mineral_num_update_terminal)
        state_machine.add(cross_server_battel_map_refresh_terminal)
        state_machine.add(cross_server_battel_loot_num_update_terminal)
        state_machine.add(cross_server_battel_grab_num_add_terminal)
        state_machine.add(cross_server_battel_grab_num_add_buy_confirm_terminal)
		state_machine.init()
	end

	init_cross_server_battel_open_terminal()
end

function CrossServerBattelOpen:onUpdate(dt)
    if nil ~= self.left_time then
        self.left_time = self.left_time - dt
        if self.left_time < -1 then
            self.left_time = nil
            local function callback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if self then
                        self:onUpdateDraw()
                        self.left_time = tonumber(_ED.cross_server_battel_rank_refresh_time)/1000 - (_ED.system_time + (os.time() - _ED.native_time))
                    end
                end
            end
            NetworkManager:register(protocol_command.cross_mine_ref_user_mine_and_server_info.code, nil, nil, nil, nil, callback, false, nil)
        end
    end
end

function CrossServerBattelOpen:onUpdateDraw()
    local root = self.roots[1]
    local Text_cross_me_n = ccui.Helper:seekWidgetByName(root, "Text_cross_me_n")
    local Button_cross_service_change = ccui.Helper:seekWidgetByName(root, "Button_cross_service_change")
    local Image_change_zuanshi = ccui.Helper:seekWidgetByName(root, "Image_change_zuanshi")
    local Text_change_zuanshi_n = ccui.Helper:seekWidgetByName(root, "Text_change_zuanshi_n")
    local btn_putong = ccui.Helper:seekWidgetByName(root, "Button_22")
    local btn_gaoji = ccui.Helper:seekWidgetByName(root, "Button_22_0")
    local img_putong = ccui.Helper:seekWidgetByName(root, "Image_34")
    local img_gaoji = ccui.Helper:seekWidgetByName(root, "Image_34_0")
    local Text_cross_snatch_times_n = ccui.Helper:seekWidgetByName(root, "Text_cross_snatch_times_n")
    local Button_snatch_time_add =ccui.Helper:seekWidgetByName(root, "Button_snatch_time_add") 

    if _ED.cross_server_battel_rank_info and table.nums(_ED.cross_server_battel_rank_info) ~= 0 then
        local ListView_open_rank = ccui.Helper:seekWidgetByName(root, "ListView_open_rank")
        if ListView_open_rank then 
            ListView_open_rank:removeAllItems()
            for i, v in ipairs(_ED.cross_server_battel_rank_info) do
                local cell = state_machine.excute("sm_cross_service_rank_open_cell_create",0,{rank_idx = i, rank_info = v})
                ListView_open_rank:addChild(cell)
            end
            ListView_open_rank:jumpToTop()
            ListView_open_rank:requestRefreshView()
        else
            for i=1,4 do
                local info_panel = ccui.Helper:seekWidgetByName(root, "Panel_cross_sver_rank_" .. i)
                local Text_cross_sver_name = ccui.Helper:seekWidgetByName(root, "Text_cross_sver_name_" .. i)
                local Text_sver_rank_integral = ccui.Helper:seekWidgetByName(root, "Text_sver_rank_integral_n_" .. i)
                local Text_sver_rank_reword = ccui.Helper:seekWidgetByName(root, "Text_sver_rank_reward_n_" .. i)
                local Image_rank_me = ccui.Helper:seekWidgetByName(root, "Image_rank_me_" .. i)
                local user_info = _ED.cross_server_battel_rank_info[i]
                if user_info then
                    local server_name = _ED.cross_server_battel_all_servers[user_info.serverId]
                    local getStr1 = string.match(server_name, "-")
                    local getStr2 = string.match(server_name, "_")
                    if getStr1 and getStr1 ~= "" then
                        server_name = zstring.split(server_name, "-")[1]
                    elseif getStr2 and getStr2 ~= "" then
                        server_name = zstring.split(server_name, "_")[1]
                    end
                    Text_cross_sver_name:setString(server_name)
                    Text_sver_rank_integral:setString(user_info.totalScore)
                    Text_sver_rank_reword:setString(user_info.reWard)
                    info_panel:setVisible(true)

                    if tonumber(user_info.serverId) == tonumber(_ED.all_servers[_ED.selected_server].server_number) then
                        Image_rank_me:setVisible(true)
                    else
                        Image_rank_me:setVisible(false)
                    end
                else
                    info_panel:setVisible(false)
                end
            end
        end
    end

    Text_cross_me_n:setString(_ED.cross_server_battel_mineral_num)
    local des = tonumber(_ED.cross_server_battel_map_refresh.needMineNum) == 0 and tipStringInfo_cross_server_battel_tips[15] or _ED.cross_server_battel_map_refresh.needMineNum
    Text_change_zuanshi_n:setString(des)

    --可抢夺次数
    local max_num = dms.int(dms["gvg_config"], 6, gvg_config.param)
    Text_cross_snatch_times_n:setString(_ED.cross_server_battel_map_rob_info.lootCount.freeTime .. "/" .. max_num)

    --增加抢夺次数按钮
    Button_snatch_time_add:setVisible(zstring.tonumber(_ED.cross_server_battel_map_rob_info.lootCount.freeTime) <= 0)
end

function CrossServerBattelOpen:btnChangeUI( map_type )
    local root = self.roots[1]
    if root then
        local btn1 = ccui.Helper:seekWidgetByName(root, "Button_22")
        local btn2 = ccui.Helper:seekWidgetByName(root, "Button_22_0")
        local img_putong = ccui.Helper:seekWidgetByName(root, "Image_34")
        local img_gaoji = ccui.Helper:seekWidgetByName(root, "Image_34_0")
        local Button_cross_service_change = ccui.Helper:seekWidgetByName(root, "Button_cross_service_change")
        local Image_change_zuanshi = ccui.Helper:seekWidgetByName(root, "Image_change_zuanshi")
        local Text_change_zuanshi_n = ccui.Helper:seekWidgetByName(root, "Text_change_zuanshi_n")

        btn1:setPosition(self.default_pos1)
        btn2:setPosition(self.default_pos1)

        if map_type == 1 then
            btn1:setLocalZOrder(1000)
            btn2:setLocalZOrder(self.default_zorlder2)
            img_putong:setLocalZOrder(1001)
            img_gaoji:setLocalZOrder(self.img2_zorlder)
        elseif map_type == 2 then
            btn1:setLocalZOrder(self.default_zorlder1)
            btn2:setLocalZOrder(1000)
            img_putong:setLocalZOrder(self.img1_zorlder)
            img_gaoji:setLocalZOrder(1001)
        end

        btn1:setVisible(map_type == 1)
        img_putong:setVisible(map_type == 1)
        btn2:setVisible(map_type == 2)
        img_gaoji:setVisible(map_type == 2 and not self.is_gaoji_only)
        Button_cross_service_change:setVisible(map_type == 1)
        Image_change_zuanshi:setVisible(map_type == 1)
        Text_change_zuanshi_n:setVisible(map_type == 1)
    end
end

function CrossServerBattelOpen:btnMoveAction( map_type )
    local root = self.roots[1]
    local btn1 = ccui.Helper:seekWidgetByName(root, "Button_22")
    local btn2 = ccui.Helper:seekWidgetByName(root, "Button_22_0")
    btn1:stopAllActions()
    btn2:stopAllActions()
    local x_pos1, y_pos1 = btn1:getPosition()
    local x_pos2, y_pos2 = btn2:getPosition()
    local move_sprit = map_type == 1 and btn2 or btn1
    btn1:setVisible(true)
    btn2:setVisible(true)
    if y_pos1 == y_pos2 then
        move_sprit:runAction(cc.MoveTo:create(0.3, cc.p(x_pos1, self.default_pos1.y -60)))
    else
        move_sprit:runAction(cc.MoveTo:create(0.3, cc.p(x_pos1, self.default_pos1.y)))
    end
end

function CrossServerBattelOpen:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/cross_service/cross_service_map_open_ui.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    local btn1 = ccui.Helper:seekWidgetByName(root, "Button_22")
    local btn2 = ccui.Helper:seekWidgetByName(root, "Button_22_0")
    local img_putong = ccui.Helper:seekWidgetByName(root, "Image_34")
    local img_gaoji = ccui.Helper:seekWidgetByName(root, "Image_34_0")
    self.default_pos1 = cc.p(btn1:getPosition())
    -- self.default_pos2 = cc.p(btn2:getPosition())
    self.default_zorlder1 = btn1:getLocalZOrder()
    self.default_zorlder2 = btn2:getLocalZOrder()
    self.img1_zorlder = img_putong:getLocalZOrder()
    self.img2_zorlder = img_gaoji:getLocalZOrder()

    local all_users = tonumber(_ED.cross_server_battel_map_info.rankListSize)
    self.is_gaoji_only = (all_users <= 10)
    self.current_type = (all_users <= 10) and 2 or 1
    self:btnChangeUI(self.current_type)
    self:onUpdateDraw()
    --鼓舞
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_inspire"), nil, 
    {
        terminal_name = "cross_server_battel_addition_open", 
        isPressedActionEnabled = true
    },
    nil,0)

    --布阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_fomation"), nil, 
    {
        terminal_name = "cross_server_battel_formation_open",
        _type = 1,  
        isPressedActionEnabled = true
    },
    nil,0)

    --普通矿区
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_22"), nil, 
    {
        terminal_name = "cross_server_battel_swich_map",
        _type = 1 ,
        isPressedActionEnabled = true
    },
    nil,0)

    --高级矿区
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_22_0"), nil, 
    {
        terminal_name = "cross_server_battel_swich_map", 
        _type = 2 ,
        isPressedActionEnabled = true
    },
    nil,0)

    --增加抢夺次数
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_snatch_time_add"), nil, 
    {
        terminal_name = "cross_server_battel_grab_num_add",
        isPressedActionEnabled = true
    },
    nil,0)

    --换一批
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_service_change"), nil, 
    {
        terminal_name = "cross_server_battel_map_refresh", 
        isPressedActionEnabled = true
    },
    nil,0)

    --收起排名
    local Button_cross_down = ccui.Helper:seekWidgetByName(root, "Button_cross_down")
    local Button_cross_up = ccui.Helper:seekWidgetByName(root, "Button_cross_up")
    local action = csb.createTimeline("campaign/cross_service/cross_service_map_open_ui.csb")
    table.insert(self.actions, action)
    csbNode:runAction(action)
    self.actions[1]:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "anim_btn_arrow_down_over" then
            Button_cross_down:setTouchEnabled(false)
            Button_cross_up:setTouchEnabled(true)
        elseif str == "anim_btn_arrow_up_over" then
            Button_cross_down:setTouchEnabled(true)
            Button_cross_up:setTouchEnabled(false)
        end
        
    end)

    local function showAnim( sender, eventType )
        if eventType == ccui.TouchEventType.ended then
            Button_cross_down:setTouchEnabled(false)
            Button_cross_up:setTouchEnabled(false)
            self.actions[1]:play(sender.action_name, false)
        end
    end
    Button_cross_down:addTouchEventListener(showAnim)
    Button_cross_up:addTouchEventListener(showAnim)
    Button_cross_down.action_name = "anim_btn_arrow_down"
    Button_cross_up.action_name = "anim_btn_arrow_up"

    self.left_time = tonumber(_ED.cross_server_battel_rank_refresh_time)/1000 - (_ED.system_time + (os.time() - _ED.native_time))
end

function CrossServerBattelOpen:init(params)
end

function CrossServerBattelOpen:onExit()
    state_machine.remove("cross_server_battel_swich_map")
    state_machine.remove("cross_server_battel_grab_num_add")
    state_machine.remove("cross_server_battel_map_refresh")
    state_machine.remove("cross_server_battel_mineral_num_update")
    state_machine.remove("cross_server_battel_loot_num_update")
    state_machine.remove("cross_server_battel_map_refresh")
    state_machine.remove("cross_server_battel_grab_num_add")
    state_machine.remove("cross_server_battel_grab_num_add_buy_confirm")
end