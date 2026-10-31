-----------------------------
--分解
-----------------------------
Refining = class("RefiningClass", Window)

--打开分解界面
local refining_window_open_terminal = {
    _name = "refining_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(95) == true then
            return false
        end
        if nil == fwin:find("RefiningClass") then
            fwin:open(Refining:new():init(params), fwin._ui)
        end
        state_machine.excute("home_select_action_window_close",0,"")        
        state_machine.excute("main_window_hide", 0, "")
        state_machine.excute("player_resource_window_hide", 0, "")     
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")  
        state_machine.excute("duplicate_title_window_hide",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭分解界面
local refining_window_close_terminal = {
    _name = "refining_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RefiningClass"))

        if fwin:find("HeroMainClass") ~= nil then
            
        else
            state_machine.excute("main_window_open",0,"")
            state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("duplicate_title_window_show",0,"") 
            if fwin:find("PacksClass") ~= nil then
                state_machine.excute("packs_window_open",0,"") 
            end
            if fwin:find("RacecourseClass") ~= nil then
                state_machine.excute("home_button_for_action_window_hide",0,"")
                state_machine.excute("player_resource_window_hide", 0, "")   
            end
        end
        
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(refining_window_open_terminal)
state_machine.add(refining_window_close_terminal)
state_machine.init()

function Refining:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    app.load("client.red_alert_time.forging.refiningfile.RefiningScrollviewHero")
    app.load("client.red_alert_time.forging.refiningfile.RefiningScrollviewEquip")
    app.load("client.red_alert_time.forging.refiningfile.RefiningScrollviewHorse")
    app.load("client.red_alert_time.forging.refiningfile.RefiningScrollviewTally")
    app.load("client.red_alert_time.forging.RefiningBatch")   

    --var
    self.page_index = 1 -- 1 英雄 2 装备 3 战马 4 兵符
    --分解类型表
    self.refining_tables = {}

    -- Initialize refining state machine.
    local function init_refining_terminal()
	    --管理
		local refining_manager_terminal = {
            _name = "refining_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                    terminal.last_terminal_name = params._datas.next_terminal_name
                    state_machine.excute(params._datas.next_terminal_name, 0, params)
                end 
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if terminal.select_button == nil and params._datas.current_button_name ~= nil then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                else
                    terminal.select_button = params
                end

                if terminal.select_button.setHighlighted == nil and params._datas.current_button_name ~= nil then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 英雄
        local refining_change_to_hero_terminal = {
            _name = "refining_change_to_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.page_index = 1
                instance.refining_tables = {}
                state_machine.excute("refining_update_draw_left",0,"")
                state_machine.excute("refining_scrollview_hero_window_open",0,{instance.panel_scroll})
                state_machine.excute("refining_scrollview_hero_window_show",0,"")
                state_machine.excute("refining_scrollview_equip_window_hide",0,"")
                state_machine.excute("refining_scrollview_horse_window_hide",0,"")
                state_machine.excute("refining_scrollview_tally_window_hide",0,"")

                state_machine.excute("refining_scrollview_hero_un_set_selected",0,"") 
                state_machine.excute("refining_scrollview_equip_un_set_selected",0,"") 
                state_machine.excute("refining_scrollview_horse_un_set_selected",0,"") 
                state_machine.excute("refining_scrollview_tally_un_set_selected",0,"") 
                                             
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        -- 装备
        local refining_change_to_equip_terminal = {
            _name = "refining_change_to_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.page_index = 2
                instance.refining_tables = {}
                state_machine.excute("refining_update_draw_left",0,"")
                state_machine.excute("refining_scrollview_equip_window_open",0,{instance.panel_scroll})
                state_machine.excute("refining_scrollview_hero_window_hide",0,"")
                state_machine.excute("refining_scrollview_equip_window_show",0,"")
                state_machine.excute("refining_scrollview_horse_window_hide",0,"")
                state_machine.excute("refining_scrollview_tally_window_hide",0,"")                

                state_machine.excute("refining_scrollview_hero_un_set_selected",0,"") 
                state_machine.excute("refining_scrollview_equip_un_set_selected",0,"") 
                state_machine.excute("refining_scrollview_horse_un_set_selected",0,"") 
                state_machine.excute("refining_scrollview_tally_un_set_selected",0,"") 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 战马
        local refining_change_to_horse_terminal = {
            _name = "refining_change_to_horse",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.page_index = 3
                instance.refining_tables = {}
                state_machine.excute("refining_update_draw_left",0,"")
                state_machine.excute("refining_scrollview_horse_window_open",0,{instance.panel_scroll})
                state_machine.excute("refining_scrollview_hero_window_hide",0,"")
                state_machine.excute("refining_scrollview_equip_window_hide",0,"")
                state_machine.excute("refining_scrollview_horse_window_show",0,"")
                state_machine.excute("refining_scrollview_tally_window_hide",0,"")
                
                state_machine.excute("refining_scrollview_hero_un_set_selected",0,"") 
                state_machine.excute("refining_scrollview_equip_un_set_selected",0,"") 
                state_machine.excute("refining_scrollview_horse_un_set_selected",0,"") 
                state_machine.excute("refining_scrollview_tally_un_set_selected",0,"")                 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        -- 兵符
        local refining_change_to_tally_terminal = {
            _name = "refining_change_to_tally",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.page_index = 4
                instance.refining_tables = {}
                state_machine.excute("refining_update_draw_left",0,"")
                state_machine.excute("refining_scrollview_tally_window_open",0,{instance.panel_scroll})
                state_machine.excute("refining_scrollview_hero_window_hide",0,"")
                state_machine.excute("refining_scrollview_equip_window_hide",0,"")
                state_machine.excute("refining_scrollview_horse_window_hide",0,"")
                state_machine.excute("refining_scrollview_tally_window_show",0,"")                
                
                state_machine.excute("refining_scrollview_hero_un_set_selected",0,"") 
                state_machine.excute("refining_scrollview_equip_un_set_selected",0,"") 
                state_machine.excute("refining_scrollview_horse_un_set_selected",0,"") 
                state_machine.excute("refining_scrollview_tally_un_set_selected",0,"")                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 确认分解
        local refining_sure_refining_terminal = {
            _name = "refining_sure_refining",
            _init = function (terminal) 
                app.load("client.utils.ConfirmTip")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:lockAll()           
                if instance.page_index == 1 then
                    local reward_data_table = {}
                    local str = ""
                    for i, v in pairs(instance.refining_tables) do
                        if v ~= nil then
                            str = str .. v .. ","
                            for j,k in pairs(_ED.user_ship[""..v].equipment) do
                                if tonumber(k.user_equiment_id) > 0 then
                                    local show_reward_list = {
                                        item_value = 1,
                                        prop_type = 7,
                                        prop_item = _ED.user_equiment[""..k.user_equiment_id].user_equiment_template,
                                    }
                                    table.insert(reward_data_table,show_reward_list)
                                end
                            end
                        end 
                    end
                    
                    local function responseGetPreviewCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                response.node.refining_tables = {}
                            end
                            local reward_data = getSceneReward(9)
                            for i , v in pairs(reward_data_table) do
                                table.insert(reward_data.show_reward_list,v)
                            end
                            state_machine.excute("reward_obtain_window_open",0,{nil,reward_data})
                            state_machine.excute("refining_scrollview_hero_updatedraw_all",0,"")
                            state_machine.excute("refining_update_draw_left",0,"")
                            state_machine.excute("hero_main_update_draw", 0, 0)
                            
                            state_machine.unlock("refining_sure_refining")
                            state_machine.unlock("refining_add_item")
                            state_machine.unlock("refining_remove_item")
                            state_machine.unlock("refining_add_batch_item")
                        else
                            state_machine.unlock("refining_sure_refining")
                            state_machine.unlock("refining_add_item")
                            state_machine.unlock("refining_remove_item")
                            state_machine.unlock("refining_add_batch_item")
                        end
                    end
                    local str = ""
                    local num = 0
                    local isNeedConfrim = false
                    for i, v in pairs(instance.refining_tables) do
                        local ship = _ED.user_ship[""..v]
                        if zstring.tonumber(ship.ship_type) >= 3 then
                            isNeedConfrim = true
                        end
                        -- for k, j in pairs(ship.relationship) do
                        --     for m, n in pairs(j.is_activited) do
                        --         if tonumber(n) > 0 then 
                        --             TipDlg.drawTextDailog(red_alert_all_str[164])
                        --             return
                        --         end
                        --     end
                        -- end
                        if v ~= nil then
                            str = str .. v .. ","
                            num = num + 1
                        end 
                    end
                    if str == nil or str == "" then 
                        TipDlg.drawTextDailog(red_alert_all_str[187]..refining_batch[1])
                        instance:unLockAll()
                        return
                    end
                    if isNeedConfrim == true then
                        local tip = ConfirmTip:new()
                        instance.request_info = num.."\r\n"..str
                        tip:init(instance, instance.sureToSell, red_alert_all_str[182])
                        fwin:open(tip, fwin._ui)
                    else
                        protocol_command.ship_refining.param_list = num.."\r\n"..str
                        NetworkManager:register(protocol_command.ship_refining.code, nil, nil, nil, instance, responseGetPreviewCallback, false, nil)                   
                    end
                elseif instance.page_index == 2 then
                    local reward_data = instance:getEquipRefinningReward()

                    local function responseGetPreviewCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                response.node:showEquipRefinningReward(reward_data)
                                response.node.refining_tables = {}
                            end
                            state_machine.excute("refining_scrollview_equip_update_all",0,"")
                            state_machine.excute("packs_scrollview_equip_onupdate_all_equip",0,"")
                            state_machine.excute("packs_scrollview_all_update_draw",0,"")
                            state_machine.excute("refining_update_draw_left",0,"")
                            
                            state_machine.unlock("refining_sure_refining")
                            state_machine.unlock("refining_add_item")
                            state_machine.unlock("refining_remove_item")
                            state_machine.unlock("refining_add_batch_item")
                        else
                            state_machine.unlock("refining_sure_refining")
                            state_machine.unlock("refining_add_item")
                            state_machine.unlock("refining_remove_item")
                            state_machine.unlock("refining_add_batch_item")
                        end
                    end
                    local str = ""
                    for i, v in pairs(instance.refining_tables) do
                        if v ~= nil then
                            str = str .. v .. ","
                        end 
                    end
                    if str == nil or str == "" then 
                        TipDlg.drawTextDailog(red_alert_all_str[187]..refining_batch[2])
                        instance:unLockAll()
                        return
                    end                     
                    protocol_command.refining_equipment.param_list = str
                    NetworkManager:register(protocol_command.refining_equipment.code, nil, nil, nil, instance, responseGetPreviewCallback, false, nil)                   
                elseif instance.page_index == 3 then
                    local reward_data_table = {}
                    local str = ""
                    for i, v in pairs(instance.refining_tables) do
                        if v ~= nil then
                            str = str .. v .. ","
                            for j,k in pairs(_ED.horses[""..v].horse_spirits) do
                                if tonumber(k) > 0 then
                                    local show_reward_list = {
                                        item_value = 1,
                                        prop_type = 36,
                                        prop_item = _ED.horse_spirits[""..k].mould_id,
                                    }
                                    table.insert(reward_data_table,show_reward_list)
                                end
                            end
                        end 
                    end
                    local function responseGetPreviewCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                response.node.refining_tables = {}
                            end
                            local reward_data = getSceneReward(75)
                            for i , v in pairs(reward_data_table) do
                                table.insert(reward_data.show_reward_list,v)
                            end
                            state_machine.excute("refining_scrollview_horse_updatedraw_all",0,"")
                            state_machine.excute("refining_update_draw_left",0,"")
                            state_machine.excute("reward_obtain_window_open",0,{nil,reward_data})
                            state_machine.excute("racecourse_update_draw", 0, nil)
                            state_machine.excute("racecourse_ride_update_draw", 0, nil)
                            state_machine.excute("racecource_soul_exchange_refreash", 0, nil)

                            state_machine.unlock("refining_sure_refining")
                            state_machine.unlock("refining_add_item")
                            state_machine.unlock("refining_remove_item")
                            state_machine.unlock("refining_add_batch_item")
                        else
                            state_machine.unlock("refining_sure_refining")
                            state_machine.unlock("refining_add_item")
                            state_machine.unlock("refining_remove_item")
                            state_machine.unlock("refining_add_batch_item")
                        end
                    end

                    if str == nil or str == "" then 
                        TipDlg.drawTextDailog(red_alert_all_str[187]..refining_batch[3])
                        instance:unLockAll()
                        return
                    end                     
                    protocol_command.refining_horse.param_list = str
                    NetworkManager:register(protocol_command.refining_horse.code, nil, nil, nil, instance, responseGetPreviewCallback, false, nil)                   
                elseif instance.page_index == 4 then
                    local reward_data_table = {}
                    local str = ""
                    for i, v in pairs(instance.refining_tables) do
                        if v ~= nil then
                            str = str .. v .. ","
                            for j,k in pairs(_ED.horses[""..v].horse_spirits) do
                                if tonumber(k) > 0 then
                                    local show_reward_list = {
                                        item_value = 1,
                                        prop_type = 36,
                                        prop_item = _ED.horse_spirits[""..k].mould_id,
                                    }
                                    table.insert(reward_data_table,show_reward_list)
                                end
                            end
                        end 
                    end
                    local function responseGetPreviewCallback( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                response.node.refining_tables = {}
                            end
                            local reward_data = getSceneReward(75)
                            for i , v in pairs(reward_data_table) do
                                table.insert(reward_data.show_reward_list,v)
                            end
                            state_machine.excute("refining_scrollview_horse_updatedraw_all",0,"")
                            state_machine.excute("refining_update_draw_left",0,"")
                            state_machine.excute("reward_obtain_window_open",0,{nil,reward_data})
                            state_machine.excute("racecourse_update_draw", 0, nil)
                            state_machine.excute("racecourse_ride_update_draw", 0, nil)
                            state_machine.excute("racecource_soul_exchange_refreash", 0, nil)

                            state_machine.unlock("refining_sure_refining")
                            state_machine.unlock("refining_add_item")
                            state_machine.unlock("refining_remove_item")
                            state_machine.unlock("refining_add_batch_item")
                        else
                            state_machine.unlock("refining_sure_refining")
                            state_machine.unlock("refining_add_item")
                            state_machine.unlock("refining_remove_item")
                            state_machine.unlock("refining_add_batch_item")
                        end
                    end

                    if str == nil or str == "" then 
                        TipDlg.drawTextDailog(red_alert_all_str[187]..refining_batch[3])
                        instance:unLockAll()
                        return
                    end                     
                    -- protocol_command.refining_horse.param_list = str
                    -- NetworkManager:register(protocol_command.refining_horse.code, nil, nil, nil, instance, responseGetPreviewCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 更新左侧
        local refining_update_draw_left_terminal = {
            _name = "refining_update_draw_left",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateLeft()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 添加分解项
        local refining_add_item_terminal = {
            _name = "refining_add_item",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i,v in pairs(params) do
                    table.insert(instance.refining_tables,v)
                end
                state_machine.excute("refining_update_draw_left",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 移除分解项
        local refining_remove_item_terminal = {
            _name = "refining_remove_item",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                for i,v in pairs(params) do
                    for j,k in pairs(instance.refining_tables) do
                        if params[i] == k then
                            table.remove(instance.refining_tables,j)
                        end
                    end
                end
                state_machine.excute("refining_update_draw_left",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 批量添加分解项
        local refining_add_batch_item_terminal = {
            _name = "refining_add_batch_item",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.refining_tables = {}
                for i,v in pairs(params) do
                    table.insert(instance.refining_tables,v)
                end
                state_machine.excute("refining_update_draw_left",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(refining_manager_terminal)	
        state_machine.add(refining_change_to_hero_terminal)
        state_machine.add(refining_change_to_equip_terminal)
        state_machine.add(refining_change_to_horse_terminal)
        state_machine.add(refining_change_to_tally_terminal) 
        state_machine.add(refining_sure_refining_terminal)
        state_machine.add(refining_update_draw_left_terminal)
        state_machine.add(refining_add_item_terminal)
        state_machine.add(refining_remove_item_terminal)
        state_machine.add(refining_add_batch_item_terminal)
        state_machine.init()
    end
    
    -- call func init refining state machine.
    init_refining_terminal()
end

function Refining:lockAll()
    state_machine.lock("refining_sure_refining")
    state_machine.lock("refining_add_item")
    state_machine.lock("refining_remove_item")
    state_machine.lock("refining_add_batch_item")
end

function Refining:unLockAll()
    state_machine.unlock("refining_sure_refining")
    state_machine.unlock("refining_add_item")
    state_machine.unlock("refining_remove_item")
    state_machine.unlock("refining_add_batch_item")
end

function Refining:sureToSell( n )
    local function unlock( ... )
        state_machine.unlock("refining_sure_refining")
        state_machine.unlock("refining_add_item")
        state_machine.unlock("refining_remove_item")
        state_machine.unlock("refining_add_batch_item")
    end
    if n ~= 0 then
        unlock()
        return 
    end 
    if self.roots == nil or self.roots[1] == nil then
        unlock()
        return
    end
    local function responseGetPreviewCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                response.node.refining_tables = {}
            end
            state_machine.excute("reward_obtain_window_open",0,{9})
            state_machine.excute("refining_scrollview_hero_updatedraw_all",0,"")
            state_machine.excute("refining_update_draw_left",0,"")
            state_machine.excute("hero_main_update_draw", 0, 0)
            unlock()
        else
            unlock()
        end
    end
    protocol_command.ship_refining.param_list = self.request_info
    NetworkManager:register(protocol_command.ship_refining.code, nil, nil, nil, self, responseGetPreviewCallback, false, nil)
end

--显示装备分解奖励
function Refining:showEquipRefinningReward(reward_data)
    state_machine.excute("reward_obtain_window_open",0,{nil,reward_data})
end

--获得装备分解奖励
function Refining:getEquipRefinningReward()
    local all_reward_datas = {}
    all_reward_datas.show_reward_list = {}

    local back_silvers = 0
    for j,equip_id in pairs(self.refining_tables) do
        local equip = _ED.user_equiment[""..equip_id]
        local equip_mould_id = equip.user_equiment_template
        
        for i = 1 , (tonumber(equip.user_equiment_grade) - 1) do 
            local lostSilver = self:getNeedSilver(equip,i)
            back_silvers = back_silvers + lostSilver
        end     

        if back_silvers ~= 0 then
            local data = 
            {
                item_value = back_silvers,
                prop_type = 1,
                prop_item = -1,
            }
            table.insert(all_reward_datas.show_reward_list,data)
        end 

        local refining_items = dms.string(dms["equipment_mould"],equip_mould_id,equipment_mould.refining_items)     --分解获得物品和数量 
        if refining_items ~= "-1" then
            refining_items = zstring.split(refining_items,",")
            local data = 
            {
                item_value = refining_items[3],
                prop_type = refining_items[2],
                prop_item = refining_items[1],
            }
            table.insert(all_reward_datas.show_reward_list,data)
        end

    end

    for j,equip_id in pairs(self.refining_tables) do
        local equip = _ED.user_equiment[""..equip_id]
        for i,v in pairs(equip.jewelrys) do
            if tonumber(v) > 0 then
                if _ED.user_gems[""..v] ~= nil then
                    local data = 
                    {
                        item_value = 1,
                        prop_type = 34,
                        prop_item = _ED.user_gems[""..v].mould_id,
                    }
                    table.insert(all_reward_datas.show_reward_list,data)
                end
            end
        end
    end
    -- print("======back_silvers======",back_silvers)
    -- to do 装备上的宝石  返还的金钱 

    return all_reward_datas
end

--得到装备升级需要的金币数量
function Refining:getNeedSilver(equip,level)
    local suit_id = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.suit_id)                --装备ID
    local need_silver = dms.int(dms["equipment_level_requirement"], level, equipment_level_requirement.silver_amount)   --银币数量
    -- print("==========y",need_silver)
    if need_silver == nil then
        return 0 
    end
    --不同装备套装对应强化系数（套装ID,计算参数|...）
    -- 不同装备部位对应强化系数（装备部位,计算参数|...)
    local equip_suit_id_table = dms.string(dms["equipment_config"],1,equipment_config.param)
    equip_suit_id_table = zstring.split(equip_suit_id_table,"|")
    -- debug.print_r(equip_suit_id_table)
    local equip_type_table = dms.string(dms["equipment_config"],2,equipment_config.param)
    equip_type_table = zstring.split(equip_type_table,"|")
    -- debug.print_r(equip_type_table)
    for i,v in pairs(equip_suit_id_table) do
        local temp_data = zstring.split(v,",")
        -- print("=====================1=====================",v)
        local suit_id_temp = tonumber(temp_data[1])
        if suit_id == suit_id_temp then
            local tempx = tonumber(temp_data[2]) -- 计算系数1 
            -- print("==========x",tempx,temp_data[2])
            need_silver = need_silver *tempx
        end
    end

    for i,v in pairs(equip_type_table) do
        local temp_data = zstring.split(v,",")
        -- print("=====================2=====================",v)
        local equip_type = tonumber(temp_data[1])
        if tonumber(equip.equipment_type) == equip_type then
            local tempx = tonumber(temp_data[2]) -- 计算系数2
            -- print("==========y",tempx,temp_data[2])
            need_silver = need_silver *tempx
        end
    end

    return need_silver
end

--第一次打开显示英雄列表
function Refining:onUpdateDraw()
    local root = self.roots[1]
    local state_machineName = ""
    local but_image_name = ""
    if self.page_index == 1 then
        state_machineName = "refining_change_to_hero"
        but_image_name = "Button_break_down_hero"
    elseif self.page_index == 2 then
        state_machineName = "refining_change_to_equip"
        but_image_name = "Button_break_down_equipment"
    elseif self.page_index == 3 then
        state_machineName = "refining_change_to_horse"
        but_image_name = "Button_break_down_horses"
    elseif self.page_index == 4 then
        state_machineName = "refining_change_to_tally"
        but_image_name = "Button_break_down_easily_intimidated"
    end

    state_machine.excute("refining_manager",0,{
        _datas = 
            {
                terminal_name = "refining_manager",     
                next_terminal_name = state_machineName, 
                current_button_name = but_image_name,   
                but_image = "",     
                terminal_state = 0, 
                touch_scale = true,
                touch_scale_xy = 0.95, 
            }
        })
end

-- 更新左侧
function Refining:onUpdateLeft()
    local root = self.roots[1]
    local Text_refining_des = ccui.Helper:seekWidgetByName(root,"Text_refining_des")
    local Panel_break_down_information = ccui.Helper:seekWidgetByName(root,"Panel_break_down_information")
    Text_refining_des:setString(red_alert_all_str[self.page_index])

    if #self.refining_tables ~= 0 and self.page_index == 1 then
        Text_refining_des:setVisible(false) 
        Panel_break_down_information:setVisible(true)
    else
        Text_refining_des:setVisible(true) 
        Panel_break_down_information:setVisible(false)
    end
    local Panel_break_down_icon = ccui.Helper:seekWidgetByName(root,"Panel_break_down_icon")
    Panel_break_down_icon:removeAllChildren(true)
    local Text_fenjie = ccui.Helper:seekWidgetByName(root,"Text_fenjie")
    Text_fenjie:setString(red_alert_all_str[204 + self.page_index])
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")

    local Image_refining_icon_number = ccui.Helper:seekWidgetByName(root,"Image_refining_icon_number")
    local Text_refining_icon_number = ccui.Helper:seekWidgetByName(root,"Text_refining_icon_number")
    local table_len = #self.refining_tables
    if table_len == 0 then
        Image_refining_icon_number:setVisible(false)
        Text_refining_icon_number:setString("")
        Text_name:setString("")
        return
    end
    Image_refining_icon_number:setVisible(true)
    Text_refining_icon_number:setString(table_len)    
    if table_len == 1 then
        Image_refining_icon_number:setVisible(false)
        Text_refining_icon_number:setString("")        
    end    
    local cell = nil
    local name = ""
    local quality = 0 
    if self.page_index == 1 then
        local Text_break_down_number = ccui.Helper:seekWidgetByName(root,"Text_break_down_number")
        Text_break_down_number:setString("x"..self:getSouls())
        local ship_id = ""..self.refining_tables[table_len]
        local ship = _ED.user_ship[ship_id]
        local data = 
        {
            prop_data = {
                item_value = 1,
                prop_type = 13,
                prop_item = ship.ship_template_id,
            },
            prop = ship,
        }
        name = ship.captain_name
        quality = ship.ship_type
        cell = state_machine.excute("all_resource_create_cell",0,{7,data.prop_data,data.prop,8,0})
    elseif self.page_index == 2 then
        local equip_id = ""..self.refining_tables[table_len]
        local equip = _ED.user_equiment[equip_id]
        local data = 
        {
            prop_data = {
                item_value = 1,
                prop_type = 7,
                prop_item = equip.user_equiment_template,
            },
            prop = equip,
        }
        name = equip.user_equiment_name
        quality = equip.quality
        cell = state_machine.excute("all_resource_create_cell",0,{7,data.prop_data,data.prop,8,0})
    elseif self.page_index == 3 then
        local id = ""..self.refining_tables[table_len]
        local horses = _ED.horses[id]
        local data = 
        {
            prop_data = {
                item_value = 1,
                prop_type = 35,
                prop_item = horses.mould_id,
            },
            prop = horses,
        }
        name = dms.string(dms["horse_mould"],data.prop_data.prop_item,horse_mould.horse_name)
        quality  = dms.int(dms["horse_mould"],data.prop_data.prop_item,horse_mould.quality)
        cell = state_machine.excute("all_resource_create_cell",0,{7,data.prop_data,data.prop,8,0})
    elseif self.page_index == 4 then
        local id = ""..self.refining_tables[table_len]
        -- local weapon_book = _ED.weapon_book[id]
        -- local data = 
        -- {
        --     prop_data = {
        --         item_value = 1,
        --         prop_type = 7,
        --         prop_item = weapon_book.user_equiment_template,
        --     },
        --     prop = horses,
        -- }
        -- name = weapon_book.user_equiment_name
        -- quality  = weapon_book.quality
        -- cell = state_machine.excute("all_resource_create_cell",0,{7,data.prop_data,data.prop,8,0})
    end
    if cell == nil then
        return
    end
    Panel_break_down_icon:addChild(cell)
    Text_name:setString(name)
    Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
end

--播放动画
function Refining:playActions()
    local root = self.roots[1]
    local Panel_effice = ccui.Helper:seekWidgetByName(root,"Panel_effice")
    Panel_effice:removeAllChildren(true)
    local jsonPath = "images/ui/effice/effice_forging/effice_forging.json"
    local atlasPath = "images/ui/effice/effice_forging/effice_forging.atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_event", true, nil)
    animation:setPosition(cc.p(Panel_effice:getContentSize().width/2,Panel_effice:getContentSize().height/2))
    Panel_effice:addChild(animation)
end

--可以获得英魂数量
function Refining:getSouls( ... )
    local numbers = 0
    for i,v in pairs(self.refining_tables) do
        local ship_id = ""..v
        local ship = _ED.user_ship[ship_id]
        local ship_mould_id = ship.ship_template_id
        local refine_get_jade = dms.int(dms["ship_mould"],ship_mould_id,ship_mould.refine_get_jade)
        --print("==========分解可获得",refine_get_jade,ship.captain_name)
        numbers = numbers + refine_get_jade
    end
    return numbers
end

--初始化界面
function Refining:onInit( )

    local csbItem = csb.createNode(config_csb.forging.refining)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_break_down_back"), nil, 
    {
        terminal_name = "refining_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --英雄
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_break_down_hero"), nil, 
    {
        terminal_name = "refining_manager",     
        next_terminal_name = "refining_change_to_hero", 
        current_button_name = "Button_break_down_hero",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3) 
    --装备
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_break_down_equipment"), nil, 
    {
        terminal_name = "refining_manager",     
        next_terminal_name = "refining_change_to_equip", 
        current_button_name = "Button_break_down_equipment",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3) 

    --战马
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_break_down_horses"), nil, 
    {
        terminal_name = "refining_manager",     
        next_terminal_name = "refining_change_to_horse", 
        current_button_name = "Button_break_down_horses",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3) 

    --兵符
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_break_down_easily_intimidated"), nil, 
    {
        terminal_name = "refining_manager",     
        next_terminal_name = "refining_change_to_tally", 
        current_button_name = "Button_break_down_easily_intimidated",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3) 

    --批量选择
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_break_batch_selection"), nil, 
    {
        terminal_name = "refining_batch_window_open",
        terminal_state = 0,
        cell = self,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 分解
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_break_down"), nil, 
    {
        terminal_name = "refining_sure_refining",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    local Panel_break_down = ccui.Helper:seekWidgetByName(root,"Panel_break_down")
    self.panel_scroll = Panel_break_down
    self:onUpdateDraw() 
end

function Refining:init(params)
    if params ~= nil and params._datas ~= nil then
        self.page_index = params._datas.page_index
    end
	self:onInit()
    self:playActions()
    return self
end

--移除状态机
function Refining:onExit()
    state_machine.remove("refining_manager")    
    state_machine.remove("refining_change_to_hero")
    state_machine.remove("refining_change_to_equip")
    state_machine.remove("refining_change_to_horse")
    state_machine.remove("refining_change_to_tally")
    state_machine.remove("refining_sure_refining")
    state_machine.remove("refining_update_draw_left")  
    state_machine.remove("refining_add_item")
    state_machine.remove("refining_remove_item")  
    state_machine.remove("refining_add_batch_item")
end
