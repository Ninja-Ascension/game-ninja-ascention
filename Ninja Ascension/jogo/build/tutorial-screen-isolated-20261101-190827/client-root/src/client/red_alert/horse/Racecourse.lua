-----------------------------
--伯乐相马
-----------------------------
Racecourse = class("RacecourseClass", Window)
--打开
local racecourse_window_open_terminal = {
    _name = "racecourse_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(87) == true then
            return
        end
        if tonumber(_ED.home_build["17"].level) == 1 then
            TipDlg.drawTextDailog(horse_string_info[13])
            return
        end
        state_machine.excute("home_select_action_window_close",0,"")
        local _RacecourseWindow = fwin:find("RacecourseClass")
        if nil == _RacecourseWindow then
            fwin:open(Racecourse:new():init(), fwin._view)
        end
        state_machine.excute("player_resource_window_hide", 0, "")
        state_machine.excute("racecourse_window_show",0,"")
        state_machine.excute("main_window_hide", 0, "")   
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")
        state_machine.excute("duplicate_title_window_hide",0,"")
        if fwin:find("StrategyClass")  ~= nil then
            state_machine.excute("strategy_window_hide", 0, "")
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local racecourse_window_close_terminal = {
    _name = "racecourse_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RacecourseClass"))
        if fwin:find("RacecourseClass") == nil then
            state_machine.excute("main_window_open",0,"")
            state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("duplicate_title_window_show",0,"")
        else
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("player_resource_window_hide", 0, "")
            state_machine.excute("duplicate_title_window_show",0,"")
        end
        if fwin:find("TaskClass") ~= nil then
            state_machine.excute("task_window_show",0,"") 
            state_machine.excute("player_resource_window_hide",0,"") 
            state_machine.excute("home_button_for_action_window_hide",0,"") 
            state_machine.excute("chat_view_window_hide",0,"")
            state_machine.excute("duplicate_title_window_hide",0,"")  
            state_machine.excute("duplicate_map_window_hide",0,"")   
            state_machine.excute("duplicate_manager_window_hide",0,"")   
            state_machine.excute("seven_star_map_ui_window_hide",0,"")
        end
        if fwin:find("StrategyClass")  ~= nil then
            state_machine.excute("strategy_window_show", 0, "")
        end
        
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(racecourse_window_open_terminal)
state_machine.add(racecourse_window_close_terminal)
state_machine.init()

function Racecourse:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._tick_time = 0
    self.armature = nil
    self._last_horse_count = 0

    -- load lua file
    app.load("client.red_alert.horse.RacecourseDragonHorseMake")
    app.load("client.red_alert.horse.RacecoursePack")
    app.load("client.red_alert.horse.RacecourseRide")
    app.load("client.red_alert.horse.RacecoursePackScrollview")
    app.load("client.red_alert.horse.RacecourseRecruit")
    app.load("client.utils.ConfirmTip")
    app.load("client.red_alert.horse.RacecourseSoulExchange")
    app.load("client.red_alert.horse.RacecourseStrength")
    app.load("client.red_alert.horse.TreasurePrompt")

    -- Initialize racecourse state machine.
    local function init_racecourse_terminal()
        --显示界面
        local racecourse_window_show_terminal = {
            _name = "racecourse_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        
        --隐藏界面
        local racecourse_window_hide_terminal = {
            _name = "racecourse_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --跳转至乘骑
        local racecourse_goto_ride_terminal = {
            _name = "racecourse_goto_ride",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("racecourse_window_hide",0,"")
                state_machine.excute("racecourse_ride_window_open",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --相马
        local horse_recruit_choose_terminal = {
            _name = "horse_recruit_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local chooseType = params[1]
                local function recruitCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                            response.node:playAnimation(chooseType)
                        end
                    end
                end
                protocol_command.recuit_horse.param_list = ""..chooseType
                NetworkManager:register(protocol_command.recuit_horse.code, nil, nil, nil, instance, recruitCallBack, false, nil)           
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 宝物购买
        local racecourse_count_buy_terminal = {
            _name = "racecourse_count_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local buy_count = params._datas.buy_count
                local buy_type = params._datas.buy_type
                local chooseType = params._datas.chooseType
                if chooseType == 0 then
                    if tonumber(_ED.horse_normal_number) > 0 then
                        maxCount = _ED.horse_normal_number
                        state_machine.excute("horse_recruit_choose", 0, {1})
                        return
                    end
                    local normal_costs = zstring.split(dms.string(dms["horse_config"], 1, horse_config.param), ",")
                    local begin_count = math.max(1, tonumber(_ED.normal_recuit_times))
                    local costs_amount = tonumber(normal_costs[begin_count])
                    if tonumber(_ED.normal_recuit_times) >= table.nums(normal_costs) then 
                        costs_amount = tonumber(normal_costs[table.nums(normal_costs)])
                    end
                    if costs_amount > tonumber(_ED.user_info.user_silver) then
                        TipDlg.drawTextDailog(horse_string_info[6])
                        return
                    end
                elseif chooseType == 1 then
                    local maxCount, cost = instance:getMaxCountAndCost()
                    if tonumber(_ED.horse_normal_number) > 0 then
                        if tonumber(_ED.horse_normal_number) >= 10 then
                            maxCount = 10
                        else
                            maxCount = _ED.horse_normal_number
                        end
                        cost = 0
                    else
                        if cost > tonumber(_ED.user_info.user_silver) then
                            TipDlg.drawTextDailog(horse_string_info[6])
                            return
                        end
                    end
                    state_machine.excute("treasure_prompt_window_open", 0, {buy_type,cost,maxCount})
                    return
                elseif chooseType == 2 then
                    local specil_costs = zstring.split(dms.string(dms["horse_config"], 2, horse_config.param), ",")
                    if tonumber(_ED.specil_recuit_free_times) <= 0 then
                        local begin_count = math.max(1, tonumber(_ED.specil_recuit_times))
                        local costs_amount = tonumber(specil_costs[begin_count])
                        if tonumber(_ED.specil_recuit_times) >= table.nums(specil_costs) then 
                            costs_amount = tonumber(specil_costs[table.nums(specil_costs)])
                        end
                        if costs_amount > tonumber(_ED.user_info.user_gold) then
                            TipDlg.drawTextDailog(red_alert_all_str[79])
                            return
                        end
                    end
                elseif chooseType == 3 then
                    local maxCount, cost = instance:getHighMaxCountAndCost()
                    if tonumber(_ED.specil_recuit_free_times) > 0 then
                        if tonumber(_ED.specil_recuit_free_times) >= 10 then
                            maxCount = 10
                        else
                            maxCount = _ED.specil_recuit_free_times
                        end
                        cost = 0
                    else
                        if cost > tonumber(_ED.user_info.user_gold) then
                            TipDlg.drawTextDailog(red_alert_all_str[79])
                            return
                        end
                    end
                    state_machine.excute("treasure_prompt_window_open", 0, {buy_type,cost,maxCount})
                    return
                end
                local function recruitCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            -- response.node:onUpdateDraw()
                            state_machine.excute("horse_recruit_choose", 0, {buy_count})
                        end
                    end
                end
                protocol_command.find_horse.param_list = buy_type .."\r\n" .. buy_count
                NetworkManager:register(protocol_command.find_horse.code, nil, nil, nil, instance, recruitCallBack, false, nil)           
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开包裹
        local racecourse_open_packs_terminal = {
            _name = "racecourse_open_packs",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("racecourse_pack_window_open", 0, {1,1})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --显示蛋动画
        local racecourse_show_panel_treasure_terminal = {
            _name = "racecourse_show_panel_treasure",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShowPanelTreasure()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 刷新
        local racecourse_update_draw_terminal = {
            _name = "racecourse_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(racecourse_window_show_terminal)
        state_machine.add(racecourse_window_hide_terminal)
        state_machine.add(racecourse_goto_ride_terminal)
        state_machine.add(horse_recruit_choose_terminal)
        state_machine.add(racecourse_count_buy_terminal)
        state_machine.add(racecourse_open_packs_terminal)
        state_machine.add(racecourse_show_panel_treasure_terminal)
        state_machine.add(racecourse_update_draw_terminal)
        state_machine.init()
    end

    init_racecourse_terminal()
end 

function Racecourse:timeOverGet( ... )
    local function recruitCallBack( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                response.node:onUpdateDraw()
            end
        end
    end
    NetworkManager:register(protocol_command.get_recuit_horse_info.code, nil, nil, nil, self, recruitCallBack, false, nil)         
end

--刷新时间
function Racecourse:onUpdate( dt )
    if self._tick_time <= 0 then
        self._tick_time = 0
        self:unregisterOnNoteUpdate(self)
        self:timeOverGet()
    else
        self._tick_time = self._tick_time - dt
    end
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Text_time"):setString(self:formatTimeString(self._tick_time))
end

--时间转换时分秒
function Racecourse:formatTimeString(_time)
    local timeString = ""
    local now_time = math.max(tonumber(_time),0)
    timeString = timeString .. string.format("%02d", math.floor(now_time/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))
    return timeString
end

--获得最大购买次数和所需金币
function Racecourse:getMaxCountAndCost()
    local cost = 0
    local normal_costs = zstring.split(dms.string(dms["horse_config"], 1, horse_config.param), ",")
    local begin_count = math.max(1, tonumber(_ED.normal_recuit_times))
    for i = begin_count + 1, begin_count + 10 do
        local costs_amount = tonumber(normal_costs[i])
        if i >= table.nums(normal_costs) then 
            costs_amount = tonumber(normal_costs[table.nums(normal_costs)])
        end
        cost = cost + costs_amount
    end
    return 10, cost
end

--获得最大高级购买次数和所需元宝
function Racecourse:getHighMaxCountAndCost()
    local cost = 0
    local specil_costs = zstring.split(dms.string(dms["horse_config"], 2, horse_config.param), ",")
    local begin_count = math.max(1, tonumber(_ED.specil_recuit_times))
    for i = begin_count + 1, begin_count + 10 do
        local costs_amount = tonumber(specil_costs[i])
        if i >= table.nums(specil_costs) then 
            costs_amount = tonumber(specil_costs[table.nums(specil_costs)])
        end
        cost = cost + costs_amount
    end
    return 10, cost
end

function Racecourse:onUpdateDraw( ... )
    local root = self.roots[1]
    local Text_level = ccui.Helper:seekWidgetByName(root, "Text_level")                                 --集市等级
    local Text_treasure_number1 = ccui.Helper:seekWidgetByName(root, "Text_treasure_number1")           --宝物数量
    local Panel_get_treasure_time = ccui.Helper:seekWidgetByName(root, "Panel_get_treasure_time")       --宝物未满层
    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")                                   --获得宝物倒计时
    local Panel_get_treasure_full = ccui.Helper:seekWidgetByName(root, "Panel_get_treasure_full")       --宝物已满层
    local Text_annoucement = ccui.Helper:seekWidgetByName(root, "Text_annoucement")                     --获得免费高级购买还需鉴定次数
    local Text_normal_spend = ccui.Helper:seekWidgetByName(root, "Text_normal_spend")                   --普通购买所需金币数
    local Image_normal_spend = ccui.Helper:seekWidgetByName(root, "Image_normal_spend")                 --金币icon
    local Panel_normal_spent_full = ccui.Helper:seekWidgetByName(root, "Panel_normal_spent_full")       --普通购买次数已满层
    local Text_high_spend = ccui.Helper:seekWidgetByName(root, "Text_high_spend")                       --高级购买所需钻石数
    local Panel_buy_one_time = ccui.Helper:seekWidgetByName(root, "Panel_buy_one_time")                 --免费高级购买层
    local Text_buy_one_time = ccui.Helper:seekWidgetByName(root, "Text_buy_one_time")                   --免费高级购买次数
    local Panel_high_spent_full = ccui.Helper:seekWidgetByName(root, "Panel_high_spent_full")           --高级购买次数已满层
    local Panel_treasure_n = ccui.Helper:seekWidgetByName(root, "Panel_treasure_n")                     --珍兽蛋
    Panel_treasure_n:setVisible(true)
    local max_times = dms.int(dms["base_consume"],68,base_consume.vip_0_value + tonumber(_ED.vip_grade))--最大高级购买次数

    -- 神兽碎片进度条
    local LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")   
    local Text_shuliang = ccui.Helper:seekWidgetByName(root, "Text_shuliang")   
    local max_count = dms.int(dms["horse_config"], 4, horse_config.param)   --所需碎片
    Text_shuliang:setString(_ED.user_info.dragon_horse_patch.."/"..max_count)
    LoadingBar_1:setPercent((_ED.user_info.dragon_horse_patch/max_count)*100)
    -- 橙色兽魂碎片进度条
    local LoadingBar_2 = ccui.Helper:seekWidgetByName(root, "LoadingBar_2")    
    local Text_shuliang_2 = ccui.Helper:seekWidgetByName(root, "Text_shuliang_2")  
    Text_shuliang_2:setString(_ED.user_info.horse_spirits_patch.."/"..50)
    LoadingBar_2:setPercent((_ED.user_info.horse_spirits_patch/50)*100)

    Panel_buy_one_time:setVisible(false)
    Panel_high_spent_full:setVisible(false)
    Text_buy_one_time:setString("")
    Image_normal_spend:setVisible(true)
    Panel_normal_spent_full:setVisible(false)
    local level = 0
    if _ED.home_build["17"] ~= nil then
        level = _ED.home_build["17"].level
    else
        level = 1
    end
    local update_id = dms.int(dms["build_mould"], 17, build_mould.update_id)
    --集市等级
    Text_level:setString(string.format(red_alert_all_str[117], ""..(level - 1)))
    --拥有宝物数量
    local current = tonumber(_ED.horse_normal_number)
    --生产最大容量
    local max = _ED.build_escalate_info[""..update_id][""..level].max_volumn
    Text_treasure_number1:setString(current.."/"..max)
    --获得宝物倒计时
    local output_time = _ED.build_escalate_info[""..update_id][""..level].output_time
    self._tick_time = tonumber(_ED.last_out_put_horse_time) - 
        os.time() + tonumber(output_time)
    --拥有宝物数大于或等于生产最大容量显示宝物已满
    if tonumber(current) >= tonumber(max) then
        Panel_get_treasure_time:setVisible(false)
        Panel_get_treasure_full:setVisible(true)
        self._tick_time = 0
    else  --否则显示获得宝物倒计时
        Panel_get_treasure_time:setVisible(true)
        Panel_get_treasure_full:setVisible(false)
    end

    --购买宝物所需金币
    local normal_costs = zstring.split(dms.string(dms["horse_config"], 1, horse_config.param), ",")
    local current_cost = 0
    if tonumber(_ED.horse_normal_number) > 0 then
        current_cost = 0
    else
        if tonumber(_ED.normal_recuit_times) >= table.nums(normal_costs) then
            current_cost = normal_costs[table.nums(normal_costs)]
        else
            current_cost = normal_costs[tonumber(_ED.normal_recuit_times) + 1]
        end
    end
    Text_normal_spend:setString(""..current_cost)

    --如果有免费高级购买次数显示次数
    if tonumber(_ED.specil_recuit_free_times) > 0 then
        ccui.Helper:seekWidgetByName(root, "Panel_high_spent"):setVisible(false)
        Panel_buy_one_time:setVisible(true)
        Text_buy_one_time:setString("".._ED.specil_recuit_free_times)
    else  --如果没有免费高级购买次数
        ccui.Helper:seekWidgetByName(root, "Panel_high_spent"):setVisible(true)
        local specil_costs = zstring.split(dms.string(dms["horse_config"], 2, horse_config.param), ",")
        local specil_cost = 0
        --如果高级购买次数小于配置次数显示下一次所需消耗钻石数
        if tonumber(_ED.specil_recuit_times) >= table.nums(specil_costs) then
            specil_cost = specil_costs[table.nums(specil_costs)]
        else
            specil_cost = specil_costs[tonumber(_ED.specil_recuit_times) + 1]
        end
        Text_high_spend:setString(""..specil_cost)
        --如果高级购买次数等于当前VIP可购买最大次数显示次数已满
        -- if tonumber(_ED.specil_recuit_times) >= max_times then 
        --     ccui.Helper:seekWidgetByName(root, "Panel_high_spent"):setVisible(false)
        --     Panel_high_spent_full:setVisible(true)
        -- end
    end

    --获得一次高级购买所需鉴定累计次数
    local free_specil_total_count = dms.int(dms["horse_config"], 8, horse_config.param)
    Text_annoucement:setString(string.format(horse_string_info[2], ""..(free_specil_total_count - tonumber(_ED.specil_recuit_value))))

    if self._tick_time > 0 then
        self:registerOnNoteUpdate(self, 0.5)
    end

    if self._last_horse_count == 0 and current > 0 then
        self.actions[1]:play("buy_treasure", false)
    end
    self._last_horse_count = current
end

--播放驯化珍兽动画
function Racecourse:playAnimation( chooseType )
    local root = self.roots[1]
    local Panel_treasure_n = ccui.Helper:seekWidgetByName(root, "Panel_treasure_n") 
    Panel_treasure_n:setVisible(false)
    local Panel_treasure_open = ccui.Helper:seekWidgetByName(root, "Panel_treasure_open")
    Panel_treasure_open:setVisible(true)
    self.armature = Panel_treasure_open:getChildByName("ArmatureNode_treasure_open")
    draw.initArmature(self.armature, nil, -1, 0, 1)
    local function changeActionCallback(armatureBack)
        Panel_treasure_open:setVisible(false)
        if chooseType == 1 then 
            local reward_data = getSceneReward(75)
            state_machine.excute("racecourse_recruit_window_open",0,{reward_data})
        else
            state_machine.excute("reward_obtain_window_open",0,{75})
        end
    end
    self.armature._invoke = changeActionCallback
    self.armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(self.armature, 0, 0, false)
end

--显示蛋动画
function Racecourse:onShowPanelTreasure()
    local root = self.roots[1]
    local Panel_treasure_n = ccui.Helper:seekWidgetByName(root, "Panel_treasure_n") 
    Panel_treasure_n:setVisible(true)
end

function Racecourse:onHide( )
    self:setVisible(false)
end

function Racecourse:onShow( )
    self:setVisible(true)
end

function Racecourse:getSortForFight()
    local result = {}
    for i,v in pairs(_ED.user_ship) do
        table.insert(result,v)
    end
    local all_result = {}
    local in_formation = {}
    local in_raleship = {}
    local gold_ship = {} -- 6
    local red_ship = {}  -- 5
    local orange_ship = {} -- 4
    local purple_ship = {} -- 3
    local blue_ship = {} -- 2 
    local green_ship = {} -- 1
    local white_ship = {} -- 0
    local function sortShipFight( a, b )
        return tonumber(a.hero_fight) > tonumber(b.hero_fight)
    end
    table.sort(result, sortShipFight)

    for i,ship in pairs(result) do
        if zstring.tonumber(ship.formation_index) > 0 then
            -- table.insert(in_formation, ship)
        elseif zstring.tonumber(ship.little_partner_formation_index) > 0 then
        --     table.insert(in_raleship, ship)
        elseif zstring.tonumber(ship.ship_type) == 6 then
            table.insert(gold_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 5 then
            table.insert(red_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 4 then
            table.insert(orange_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 3 then
            table.insert(purple_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 2 then
            table.insert(blue_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 1 then
            table.insert(green_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 0 then
            table.insert(white_ship, ship)
        end
    end
    self.ship_numbers = 0
    -- for i,v in pairs(in_formation) do
    --    table.insert(all_result,v)
    -- end
    local formation_temp = {}
    local position_str = dms.string(dms["formation_mould"],tonumber(_ED.formetion[1]),formation_mould.position)
    position_str = zstring.split(position_str,",")
    for i,v in pairs(position_str) do
        if zstring.tonumber(_ED.formetion[i+1]) ~= 0 then
            table.insert(formation_temp,_ED.user_ship["".._ED.formetion[i+1]])
        end
    end

    local formation_temp_change_index = {}
    for i,v in pairs(formation_temp) do
        table.insert(formation_temp_change_index,formation_temp[#formation_temp-i+1])
    end

    for i,v in pairs(formation_temp_change_index) do
       table.insert(all_result,v)
    end
    
    for i,v in pairs(in_raleship) do
       table.insert(all_result,v)
    end

    for i,v in pairs(gold_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(red_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(orange_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(purple_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(green_ship) do
        table.insert(all_result,v)
    end  
    for i,v in pairs(blue_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(white_ship) do
       table.insert(all_result,v)
    end
    return all_result
end

function Racecourse:onInit( )
    local csbItem = csb.createNode(config_csb.horse.treasure)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.horse.treasure)
    table.insert(self.actions, action)
    csbItem:runAction(action)

    local Panel_treasure_open = ccui.Helper:seekWidgetByName(root, "Panel_treasure_open")
    self.armature = Panel_treasure_open:getChildByName("ArmatureNode_treasure_open")
    draw.initArmature(self.armature, nil, -1, 0, 1)
    local function changeActionCallback(armatureBack)
        Panel_treasure_open:setVisible(false)
    end
    draw.initArmature(self.armature, nil, -1, 0, 1)
    self.armature._invoke = changeActionCallback
    csb.animationChangeToAction(self.armature, 0, 0, false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "racecourse_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 马场包裹
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pack"), nil, 
    {
        terminal_name = "racecourse_open_packs",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    -- 马场乘骑
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment"), nil, 
    {
        terminal_name = "racecourse_ride_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_horse_all_info",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_equipment"),
        _invoke = nil,
        _interval = 0.5,})

    -- 马场合成
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legend_treasure"), nil, 
    {
        terminal_name = "racecourse_dragon_horse_make_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_horse_combing",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_legend_treasure"),
        _invoke = nil,
        _interval = 0.5,})   

    -- 普通召唤
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_normal_buy"), nil, 
    {
        terminal_name = "racecourse_count_buy", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        buy_count = 1, 
        buy_type = 0,
        chooseType = 0,
    },
    nil,0)
    -- 普通召唤最大
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_max"), nil, 
    {
        terminal_name = "racecourse_count_buy", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        buy_count = 0,
        buy_type = 0,
        chooseType = 1,
    },
    nil,0)
    
    -- 高级召唤
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_normal_buy_0"), nil, 
    {
        terminal_name = "racecourse_count_buy", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        buy_count = 1,
        buy_type = 1,
        chooseType = 2,
    },
    nil,0)

    -- 高级召唤最大
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_max_2"), nil, 
    {
        terminal_name = "racecourse_count_buy", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
        buy_count = 0,
        buy_type = 1,
        chooseType = 3,
    },
    nil,0)

    -- 兽魂兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legend_soul"), nil, 
    {
        terminal_name = "racecourse_soul_exchange_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_horse_spilits_combing",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_legend_soul"),
        _invoke = nil,
        _interval = 0.5,}) 

    --分解
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_decomposition_2"), nil, 
    {
        terminal_name = "refining_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        page_index = 3,
    }, nil, 0)  
    
    self:onUpdateDraw()
end

function Racecourse:init(ship)
    self.user_ships = self:getSortForFight()
    self.ship = ship or self.user_ships[1]
	self:onInit()
    return self
end

function Racecourse:onExit()
    state_machine.remove("racecourse_window_show")   
    state_machine.remove("racecourse_window_hide")
    state_machine.remove("racecourse_goto_ride")
    state_machine.remove("horse_recruit_choose")   
    state_machine.remove("racecourse_count_buy")
    state_machine.remove("racecourse_open_packs")
    state_machine.remove("racecourse_show_panel_treasure")
    state_machine.remove("racecourse_update_draw")
end