-----------------------------
--装备界面
-----------------------------
Equipment = class("EquipmentClass", Window)

local equipment_window_open_terminal = {
    _name = "equipment_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(68) == true then
            return
        end      
        local _Window = fwin:find("EquipmentClass")
        if nil == _Window then
            local user_ships = params[1]
            local show_type = params[2]
            fwin:open(Equipment:new():init(user_ships,show_type), fwin._view)
        end

        state_machine.excute("main_window_hide", 0, "")
        state_machine.excute("player_resource_window_hide", 0, "")     
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")  
        state_machine.excute("duplicate_title_window_hide",0,"")    
        state_machine.excute("seven_star_map_ui_window_hide",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local equipment_window_close_terminal = {
    _name = "equipment_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentClass"))
        if fwin:find("NationalWarMapClass") ~= nil then
            -- state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
        elseif fwin:find("DuplicateManagerClass") == nil then
            if fwin:find("CampaignClass") ~= nil then
                state_machine.excute("campaign_window_show",0,"")
                state_machine.excute("home_button_for_action_window_hide",0,"") 
                state_machine.excute("chat_view_window_hide",0,"")
            elseif fwin:find("UnionClass") ~= nil then
            elseif fwin:find("SevenStarClass") ~= nil then
                state_machine.excute("seven_star_map_ui_window_show",0,"")
                state_machine.excute("duplicate_map_window_show",0,"")
                state_machine.excute("player_resource_window_hide",0,"")
                state_machine.excute("home_button_for_action_window_show",0,"")
            elseif fwin:find("DuplicateMapClass") ~= nil then
                state_machine.excute("duplicate_map_window_show", 0, nil)
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")
                state_machine.excute("duplicate_title_window_show",0,"")
            else
                state_machine.excute("main_window_open",0,"")
                state_machine.excute("player_resource_window_show",0,"")   
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")
                state_machine.excute("duplicate_title_window_show",0,"")
            end
        else
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
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
        -- if fwin:find("PacksClass") ~= nil then
        --     state_machine.excute("packs_window_open",0,"") 
        -- end
        -- if fwin:find("TaskClass") ~= nil then
        --     state_machine.excute("task_window_show",0,"") 
        --     state_machine.excute("player_resource_window_hide",0,"") 
        --     state_machine.excute("home_button_for_action_window_hide",0,"") 
        --     state_machine.excute("chat_view_window_hide",0,"")
        -- end
        state_machine.excute("national_city_hide_game_resource_info", 0, nil)
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_window_open_terminal)
state_machine.add(equipment_window_close_terminal)
state_machine.init()

function Equipment:ctor()
    self.super:ctor()
    self.roots = {}

    self.table_panel_index = nil
    self.user_ships = nil
    self.show_type = 1 --1 自己 2 查看别的玩家
    self.ship = nil
    self.select_equip_icon = 1
    self.change_type = 1
    self.listview = nil
    self.listview_pox = nil
    self._need_silver = nil
    --推送红点
    self._push_notification = nil 
    
    -- load lua file
    app.load("client.red_alert_time.cells.hero.hero_icon_cell")
    app.load("client.red_alert_time.packs.equipstorage.EquipmentWear")
    app.load("client.red_alert_time.packs.equipstorage.EquipmentGemInput")
    app.load("client.red_alert_time.packs.equipstorage.EquipmentGemFuse")
    app.load("client.red_alert_time.cells.packs.equipstorage.equipment_gem_input_cell")
    app.load("client.red_alert_time.packs.equipstorage.EquipmentGemAttribute")
    app.load("client.red_alert_time.packs.equipstorage.EquipmentAwaken")
    app.load("client.red_alert_time.horse.RacecourseRide")
    app.load("client.red_alert_time.hero.HeroAttributes")
    app.load("client.red_alert_time.packs.equipstorage.EquipmentClear")
    app.load("client.red_alert_time.forging.EquipmentClearRefining")
    
    -- Initialize init_equipment_terminal state machine.
    local function init_equipment_terminal()
    
        --显示界面
        local equipment_window_show_terminal = {
            _name = "equipment_window_show",
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
        local equipment_window_hide_terminal = {
            _name = "equipment_window_hide",
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

        -- 改变英雄
        local equipment_change_ship_terminal = {
            _name = "equipment_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local ship = params
				if zstring.tonumber(ship.ship_id) == zstring.tonumber(instance.ship.ship_id) then
					return
				end
                instance.ship = ship
                instance:setHeroCellSelected(ship)
                instance:setHeroIcon()
                instance:setEquipMent()
                instance:setEquipInfo()
                instance:setEquipStreng()
                local change_type = 1
                if zstring.tonumber(instance.ship.equipment[instance.select_equip_icon].user_equiment_id) == 0 then
                else
                    change_type = instance.change_type
                end
                state_machine.excute("equipment_change_page_type",0,{
                    _datas = 
                    {
                        terminal_name = "equipment_change_page_type", 
                        terminal_state = 0, 
                        change_type = change_type,
                        touch_scale = true,
                        touch_scale_xy = 0.95, 
                    }
                    })
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --切换至1 装备信息面板，2 强化面板，3 洗练面板
        local equipment_change_page_type_terminal = {
            _name = "equipment_change_page_type",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local change_type = params._datas.change_type
                instance.change_type = change_type
                instance:changeEquipStrengOrInfo()
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --切换已穿戴装备类型
        local equipment_change_equip_type_terminal = {
            _name = "equipment_change_equip_type",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.select_equip_icon = params._datas.index
                instance:setIconSelected()
                instance:changeEquipStrengOrInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --切换已穿戴装备类型 打开穿戴界面
        local equipment_change_equip_type_and_open_wear_terminal = {
            _name = "equipment_change_equip_type_and_open_wear",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.select_equip_icon = params._datas.index
                instance.change_type = 1
                instance:setIconSelected()
                instance:changeEquipStrengOrInfo()
                local equip_type = instance.table_panel_index[instance.select_equip_icon]
                state_machine.excute("equipment_wear_window_open",0,{equip_type,instance.ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --没有可穿戴的
        local equipment_show_no_wear_terminal = {
            _name = "equipment_show_no_wear",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                TipDlg.drawTextDailog(red_alert_all_str[33])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }        
        
        --穿戴成功
        local equipment_show_wear_success_terminal = {
            _name = "equipment_show_wear_success",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setEquipMent()
                instance:changeEquipStrengOrInfo()
                state_machine.excute("packs_scrollview_equip_onupdate_all_equip",0,"")
                state_machine.excute("packs_scrollview_all_update_draw",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }        
        --卸下成功
        local equipment_show_unload_equip_terminal = {
            _name = "equipment_show_unload_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseWearEquipCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:setEquipMent()
                            response.node:changeEquipStrengOrInfo()
                        end
                        state_machine.excute("packs_scrollview_equip_onupdate_all_equip",0,"")
                        state_machine.excute("packs_scrollview_all_update_draw",0,"")
                        pushEffect(formatMusicFile("effect", 10008))
                    end
                end    
                local equip_id = zstring.tonumber(instance.ship.equipment[instance.select_equip_icon].user_equiment_id)
                local equip = _ED.user_equiment[""..equip_id]
                if equip == nil then
                    return
                end
                local equip_type = equip.equipment_type
                local str = ""      
                str = str..instance.ship.ship_id.."\r\n"--佩戴船只ID
                str = str..equip_id.."\r\n"--装备ID
                str = str..equip_type.."\r\n"--装备位标识
                str = str.."0"
                protocol_command.equipment_adorn.param_list = str
                NetworkManager:register(protocol_command.equipment_adorn.code, nil, nil, nil, instance, responseWearEquipCallback, false, nil)                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }            
        --更换
        local equipment_show_change_equip_terminal = {
            _name = "equipment_show_change_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local number = 0
                local equip_type = instance.table_panel_index[instance.select_equip_icon] 
                for i,v in pairs(_ED.user_equiment) do
                    if tonumber(v.ship_id) > 0 or tonumber(v.rela_state) > 0 then
                    else
                        if equip_type == tonumber(v.equipment_type) then
                            number = number + 1
                        end
                    end
                end
                if number == 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[34])
                    return
                end              
                state_machine.excute("equipment_wear_window_open",0,{equip_type,instance.ship})          
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        --强化一次
        local equipment_streng_one_terminal = {
            _name = "equipment_streng_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("equipment_streng_one")
                local equip_id = zstring.tonumber(instance.ship.equipment[instance.select_equip_icon].user_equiment_id)
                -- debug.print_r(_ED.user_equiment[""..equip_id])
                if _ED.user_equiment[""..equip_id] == nil then
                    return
                end
                local user_equiment_ability = _ED.user_equiment[""..equip_id].user_equiment_ability
                local user_equiment_grade = _ED.user_equiment[""..equip_id].user_equiment_grade
                if tonumber(_ED.user_info.user_grade) < tonumber(user_equiment_grade) then
                    TipDlg.drawTextDailog(red_alert_all_str[183])
                    state_machine.unlock("equipment_streng_one")
                    return
                end
                if tonumber(instance._need_silver) > tonumber(_ED.user_info.user_silver) then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[71])
                    state_machine.unlock("equipment_streng_one")
                    return
                end
                local function responseEquipmentEscalateCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:changeEquipStrengOrInfo()
                            response.node:onUpdateDrawSelectIcon()
                            response.node:playOneStrengthActions(user_equiment_ability,equip_id)
                            pushEffect(formatMusicFile("effect", 10009))
                        end
                        state_machine.unlock("equipment_streng_one")
                    end
                end
                protocol_command.equipment_escalate.param_list = equip_id .. "\r\n" .. "0"  .."\r\n" .."1".. "\r\n"
                NetworkManager:register(protocol_command.equipment_escalate.code, nil, nil, nil, instance, responseEquipmentEscalateCallback,false)      
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        --强化十次 --  
        local equipment_streng_ten_terminal = {
            _name = "equipment_streng_ten",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("equipment_streng_ten")
                local equip_id = zstring.tonumber(instance.ship.equipment[instance.select_equip_icon].user_equiment_id)
                local user_equiment_ability = _ED.user_equiment[""..equip_id].user_equiment_ability
                local user_equiment_grade = _ED.user_equiment[""..equip_id].user_equiment_grade
                if tonumber(_ED.user_info.user_grade) < tonumber(user_equiment_grade) then
                    TipDlg.drawTextDailog(red_alert_all_str[183])
                    state_machine.unlock("equipment_streng_ten")
                    return
                end
                if tonumber(instance._need_silver) > tonumber(_ED.user_info.user_silver) then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[71])
                    state_machine.unlock("equipment_streng_ten")
                    return
                end
                local function responseEquipmentEscalateCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            instance:changeEquipStrengOrInfo()
                            instance:onUpdateDrawSelectIcon()
                            instance:playTenStrengthActions(user_equiment_ability,equip_id)
                        end
                        pushEffect(formatMusicFile("effect", 10010))
                        state_machine.unlock("equipment_streng_ten")
                    end
                end
                protocol_command.equipment_escalate.param_list = equip_id .. "\r\n" .. "0"  .."\r\n" .."10".. "\r\n"
                NetworkManager:register(protocol_command.equipment_escalate.code, nil, nil, nil, instance, responseEquipmentEscalateCallback,false)    
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --镶嵌宝石刷新
        local equipment_inlay_gems_terminal = {
            _name = "equipment_inlay_gems",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    instance:DrawGems()
                end
                state_machine.excute("equipment_update_fight_number",0,"")
                state_machine.excute("packs_scrollview_jewelry_onupdate_all_jewelry",0,"")
                state_machine.excute("packs_scrollview_all_update_draw",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        --进入觉醒界面
        local equipment_open_awaken_terminal = {
            _name = "equipment_open_awaken",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local equip_id = instance.ship.equipment[instance.select_equip_icon].user_equiment_id
                local equip = _ED.user_equiment[""..equip_id]
                state_machine.excute("equipment_awaken_window_open",0,{equip})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
     
             --觉醒后刷新所有
        local equipment_update_after_awaken_terminal = {
            _name = "equipment_update_after_awaken",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setEquipMent()
                instance:changeEquipStrengOrInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        --刷新战力
        local equipment_update_fight_number_terminal = {
            _name = "equipment_update_fight_number",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateFightNumber()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 前往装备珍兽
        local equipment_goto_racecourse_terminal = {
            _name = "equipment_goto_racecourse",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("racecourse_ride_window_open",0,"")   
                state_machine.excute("equipment_window_close",0,"")   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 进入洗炼界面
        local equipment_open_clear_terminal = {
            _name = "equipment_open_clear",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local equip_id = instance.ship.equipment[instance.select_equip_icon].user_equiment_id
                local equip = _ED.user_equiment[""..equip_id]
                state_machine.excute("equipment_clear_window_open",0,{equip})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 煅火
        local equipment_equ_make_terminal = {
            _name = "equipment_equ_make",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local param = zstring.split(dms.string(dms["equipment_config"],4,equipment_config.param), ",")
                if tonumber(_ED.user_info.user_iron) < tonumber(param[1]) then
                    TipDlg.drawTextDailog(red_alert_all_str[81])
                    return 
                end
                local tip = ConfirmTip:new()
                local info = string.format(red_alert_all_str[268], param[1])
                tip:init(instance, instance.openEquipmentClear, info)
                fwin:open(tip,fwin._windows)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(equipment_window_show_terminal)   
        state_machine.add(equipment_window_hide_terminal)
        state_machine.add(equipment_change_ship_terminal)
        state_machine.add(equipment_change_page_type_terminal)
        state_machine.add(equipment_change_equip_type_terminal)
        state_machine.add(equipment_change_equip_type_and_open_wear_terminal)
        state_machine.add(equipment_show_no_wear_terminal)
        state_machine.add(equipment_show_wear_success_terminal)
        state_machine.add(equipment_show_unload_equip_terminal)
        state_machine.add(equipment_show_change_equip_terminal)
        state_machine.add(equipment_streng_one_terminal)
        state_machine.add(equipment_streng_ten_terminal)
        state_machine.add(equipment_inlay_gems_terminal)
        state_machine.add(equipment_open_awaken_terminal)
        state_machine.add(equipment_update_after_awaken_terminal)
        state_machine.add(equipment_update_fight_number_terminal)
        state_machine.add(equipment_goto_racecourse_terminal)
        state_machine.add(equipment_open_clear_terminal)
        state_machine.add(equipment_equ_make_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_equipment_terminal()
end

-- 开启洗炼
function Equipment:openEquipmentClear(sure_number)
    local equip_id = self.ship.equipment[self.select_equip_icon].user_equiment_id
    local equip = _ED.user_equiment[""..equip_id]
    local function responseEquipmentEscalateCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:setEquipMent()
                response.node:changeEquipStrengOrInfo()
                response.node:playActions()
            end
        end
    end
    if sure_number == 0 then
        protocol_command.equipment_refine.param_list = equip.user_equiment_id .. "\r\n-1"
        NetworkManager:register(protocol_command.equipment_refine.code, nil, nil, nil, self, responseEquipmentEscalateCallback,false)  
    end
end

function Equipment:playOneStrengthActions(old_pro,equip_id)
    local root = self.roots[1]
    local Panel_effice = ccui.Helper:seekWidgetByName(root,"Panel_effice")
    Panel_effice:removeAllChildren(true)
    local function ActionCallback( armatureBack )
        armatureBack:removeFromParent(true)
        self:calAddPro(old_pro,equip_id)
    end
    local jsonPath = "images/ui/effice/effice_equi_strengthen_one/effice_equi_strengthen_one.json"
    local atlasPath = "images/ui/effice/effice_equi_strengthen_one/effice_equi_strengthen_one.atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_event", true, nil)
    animation:setPosition(cc.p(Panel_effice:getContentSize().width/2,Panel_effice:getContentSize().height/2))
    sp.initArmature(animation, false)
    animation._invoke = ActionCallback
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_effice:addChild(animation)
end

function Equipment:playTenStrengthActions(old_pro,equip_id)
    local root = self.roots[1]
    local Panel_effice = ccui.Helper:seekWidgetByName(root,"Panel_effice")
    Panel_effice:removeAllChildren(true)
    local function ActionCallback( armatureBack )
        armatureBack:removeFromParent(true)
        self:calAddPro(old_pro,equip_id)
    end
    local jsonPath = "images/ui/effice/effice_equi_strengthen_one/effice_equi_strengthen_one.json"
    local atlasPath = "images/ui/effice/effice_equi_strengthen_one/effice_equi_strengthen_one.atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_event", true, nil)
    animation:setPosition(cc.p(Panel_effice:getContentSize().width/2,Panel_effice:getContentSize().height/2))
    sp.initArmature(animation, false)
    animation._invoke = ActionCallback
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_effice:addChild(animation)
end

function Equipment:playActions()
    local root = self.roots[1]
    local Panel_effice = ccui.Helper:seekWidgetByName(root,"Panel_effice")
    Panel_effice:removeAllChildren(true)
    local function ActionCallback( armatureBack )
        armatureBack:removeFromParent(true)
    end
    local jsonPath = "images/ui/effice/effice_equi_strengthen_ten/effice_equi_strengthen_ten.json"
    local atlasPath = "images/ui/effice/effice_equi_strengthen_ten/effice_equi_strengthen_ten.atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_event", true, nil)
    animation:setPosition(cc.p(Panel_effice:getContentSize().width/2,Panel_effice:getContentSize().height/2))
    sp.initArmature(animation, false)
    animation._invoke = ActionCallback
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_effice:addChild(animation)
end

function Equipment:calAddPro(old_pro,equip_id)
    local new_pro = _ED.user_equiment[""..equip_id].user_equiment_ability
    local old_table = zstring.split(old_pro,",")
    local new_table = zstring.split(new_pro,",")
    local add_type = tonumber(old_table[1]) + 1
    local add_number = tonumber(new_table[2]) - tonumber(old_table[2])
    local text_table = {
        attribute[add_type].."+"..add_number
    }

    state_machine.excute("add_number_window_open",0,{15,text_table})
end

function Equipment:onHide()
    self:setVisible(false)
end

function Equipment:onShow()
    self:setVisible(true)
end

function Equipment:updateFightNumber()
    local root = self.roots[1]
    local Text_equipment_fighting = ccui.Helper:seekWidgetByName(root,"Text_equipment_fighting") -- 战力
    local Text_equipment_fighting_0 = ccui.Helper:seekWidgetByName(root,"Text_equipment_fighting_0") -- 战力
    local equip_id = self.ship.equipment[self.select_equip_icon].user_equiment_id
    if tonumber(equip_id) > 0 then
        local equip = _ED.user_equiment[""..equip_id]
        local equip_fight = getEquipmentFight(equip,0)
        Text_equipment_fighting:setString(equip_fight)
        Text_equipment_fighting_0:setString(equip_fight)
    end 
end

function Equipment:onUpdateDrawSelectIcon()
    local root = self.roots[1]
    for i,v in pairs(self.table_panel_index) do
        if i == self.select_equip_icon then
             local Panel_equipment_props = ccui.Helper:seekWidgetByName(root,"Panel_equipment_props_"..v)
             for j,cell in pairs(Panel_equipment_props:getChildren()) do
                 state_machine.excute("all_resource_update_draw",0,cell)
             end
        end
    end
    
end

function Equipment:setIconSelected()
    local root = self.roots[1]
    
    for i,v in pairs(self.table_panel_index) do
        local Image_equipment_select = ccui.Helper:seekWidgetByName(root,"Image_equipment_select_"..v)
        Image_equipment_select:setVisible(false)
        if i == self.select_equip_icon then
            Image_equipment_select:setVisible(true)
        end
    end
end

function Equipment:DrawGems()
    local root = self.roots[1]
    local Panel_equipment_gem = ccui.Helper:seekWidgetByName(root,"Panel_equipment_gem")
    Panel_equipment_gem:removeAllChildren(true)
    local width = Panel_equipment_gem:getContentSize().width
    local height = Panel_equipment_gem:getContentSize().height
    if zstring.tonumber(self.ship.equipment[self.select_equip_icon].user_equiment_id) == 0 then
        return
    end

    local equip_id = zstring.tonumber(self.ship.equipment[self.select_equip_icon].user_equiment_id)
    local equip = _ED.user_equiment[""..equip_id]
    -- debug.print_r(equip)
    local can_add_gems = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.equipment_gem_numbers)
    -- print("========",can_add_gems)
    for i = 1 , 6 do
        local Panel_gem_icon = ccui.Helper:seekWidgetByName(root,"Panel_gem_icon_"..i)
        Panel_gem_icon:removeAllChildren(true)      
    end

    for i = 1,can_add_gems do
        local gem_id = equip.jewelrys[i]
        local Panel_gem_icon = ccui.Helper:seekWidgetByName(root,"Panel_gem_icon_"..i)
        local cell = state_machine.excute("equipment_gem_input_create_cell",0,{i,gem_id,equip})
        Panel_gem_icon:addChild(cell)
    end
end
--检测装备是否可以觉醒
function Equipment:checkEquipCanAwaken()
    -- local root = self.roots[1]
    -- local Button_red_equipment = ccui.Helper:seekWidgetByName(root,"Button_red_equipment")
    -- local equip_id = zstring.tonumber(self.ship.equipment[self.select_equip_icon].user_equiment_id)

    -- if equip_id == 0 or self.change_type == 2 then
    --     Button_red_equipment:setVisible(false)
    --     return
    -- end
    -- local equip = _ED.user_equiment[""..equip_id]
    -- local equipment_mould_id = equip.user_equiment_template

    -- local awaken_equipment_id = dms.int(dms["equipment_mould"],equipment_mould_id,equipment_mould.awaken_equipment_id)
    -- local additive_attribute = dms.string(dms["equipment_mould"],equipment_mould_id,equipment_mould.additive_attribute)
    -- if awaken_equipment_id > 0 then
    --     Button_red_equipment:setVisible(true)
    -- else
    --     Button_red_equipment:setVisible(false)
    -- end
end

function Equipment:changeEquipStrengOrInfo()
    local root = self.roots[1]
    self:checkEquipCanAwaken()
    local Panel_equipment_right = ccui.Helper:seekWidgetByName(root,"Panel_equipment_right")
    -- 装备
    local Button_equipment = ccui.Helper:seekWidgetByName(root,"Button_equipment")                          
    local Panel_equipment_infor = ccui.Helper:seekWidgetByName(root,"Panel_equipment_infor")                
    -- 强化
    local Button_equipment_strengthen = ccui.Helper:seekWidgetByName(root,"Button_equipment_strengthen")    
    local Panel_equipment_strengthen = ccui.Helper:seekWidgetByName(root,"Panel_equipment_strengthen")      
    -- 洗练
    local Button_equipment_clear = ccui.Helper:seekWidgetByName(root,"Button_equipment_clear")              
    local Panel_equipment_clear = ccui.Helper:seekWidgetByName(root,"Panel_equipment_clear")                
    local Panel_equipment_big_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_equipment_big_icon_1")
    local Image_equip_bg = ccui.Helper:seekWidgetByName(root,"Image_equip_bg")
    Image_equip_bg:setVisible(true)
    if zstring.tonumber(self.ship.equipment[self.select_equip_icon].user_equiment_id) == 0 
        and (self.change_type == 2 or self.change_type == 3) then
        TipDlg.drawTextDailog(red_alert_all_str[35])
        return
    end
    if zstring.tonumber(self.ship.equipment[self.select_equip_icon].user_equiment_id) == 0 then
        Panel_equipment_right:setVisible(false)
        Button_equipment:setTouchEnabled(false)
        Button_equipment:setHighlighted(true) 
        Button_equipment_strengthen:setTouchEnabled(true)
        Button_equipment_strengthen:setHighlighted(false)  
        Button_equipment_clear:setTouchEnabled(true)
        Button_equipment_clear:setHighlighted(false)       
        return
    end

    self:DrawGems()
    Panel_equipment_right:setVisible(true)
    if self.change_type == 1 then   -- 装备信息
        Panel_equipment_infor:setVisible(true)
        Panel_equipment_strengthen:setVisible(false)
        Panel_equipment_clear:setVisible(false)

        Button_equipment:setTouchEnabled(false)
        Button_equipment:setHighlighted(true) 
        Button_equipment_strengthen:setTouchEnabled(true)
        Button_equipment_strengthen:setHighlighted(false) 
        Button_equipment_clear:setTouchEnabled(true)
        Button_equipment_clear:setHighlighted(false)  
        Image_equip_bg:setVisible(true)
    elseif self.change_type == 2 then   -- 强化信息
        Panel_equipment_infor:setVisible(false)
        Panel_equipment_strengthen:setVisible(true)
        Panel_equipment_clear:setVisible(false)

        Button_equipment_strengthen:setTouchEnabled(false)
        Button_equipment_strengthen:setHighlighted(true)         
        Button_equipment:setTouchEnabled(true)
        Button_equipment:setHighlighted(false)
        Button_equipment_clear:setTouchEnabled(true)
        Button_equipment_clear:setHighlighted(false)  
        Image_equip_bg:setVisible(false)
    elseif self.change_type == 3 then   -- 洗练信息
        Panel_equipment_infor:setVisible(false)
        Panel_equipment_strengthen:setVisible(false)
        Panel_equipment_clear:setVisible(true)

        Button_equipment:setTouchEnabled(true)
        Button_equipment:setHighlighted(false)        
        Button_equipment_strengthen:setTouchEnabled(true)
        Button_equipment_strengthen:setHighlighted(false) 
        Button_equipment_clear:setTouchEnabled(false)
        Button_equipment_clear:setHighlighted(true)
        Image_equip_bg:setVisible(false)
    end

    local equip_id = self.ship.equipment[self.select_equip_icon].user_equiment_id
    local equip = _ED.user_equiment[""..equip_id]
    local Text_equipment_fighting = ccui.Helper:seekWidgetByName(root,"Text_equipment_fighting") -- 战力
    local Text_equipment_grade = ccui.Helper:seekWidgetByName(root,"Text_equipment_grade")
    local Panel_equipment_big_icon = ccui.Helper:seekWidgetByName(root,"Panel_equipment_big_icon")
    local Text_equipment_name = ccui.Helper:seekWidgetByName(root,"Text_equipment_name")
    local Text_equipment_strengthen_lv = ccui.Helper:seekWidgetByName(root,"Text_equipment_strengthen_lv")
    local Text_equipment_name_1 = ccui.Helper:seekWidgetByName(root,"Text_equipment_name_1")
    local quality = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.grow_level)
    local all_icon = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.All_icon)
    local equip_name = dms.string(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.equipment_name)
    local init_pow_number = dms.string(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.initial_value)
    local suit_id = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.suit_id)
    init_pow_number = zstring.split(init_pow_number,",")
    init_pow_number = tonumber(init_pow_number[2])
    -- debug.print_r(equip)

    Panel_equipment_big_icon:removeBackGroundImage()
    Panel_equipment_big_icon:setBackGroundImage(string.format(config_res.images.ui.big_props.big_props, all_icon))
    Panel_equipment_big_icon_1:removeBackGroundImage()
    Panel_equipment_big_icon_1:setBackGroundImage(string.format(config_res.images.ui.big_props.big_props, all_icon))
    Text_equipment_name:setString(equip_name)
    Text_equipment_name_1:setString(equip_name)
    Text_equipment_name_1:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    Text_equipment_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    local growup_value_table = zstring.split(equip.growup_value,"|")
    local now_grade = tonumber(equip.user_equiment_grade)

    local equip_grow_type = 0 -- 成长类型
    local grou_up_number = 0
    for i,v in pairs(growup_value_table) do
        local equipment_streng_data = zstring.split(v,",")
        local min_level = tonumber(equipment_streng_data[1])
        local max_level = tonumber(equipment_streng_data[2])
        if now_grade+1 >= min_level and now_grade+1 <= max_level then
            equip_grow_type = tonumber(equipment_streng_data[3])
            grou_up_number = math.floor(tonumber(equipment_streng_data[4]))
        end
    end

    -- local every_grade_add_number = tonumber(growup_value_table[2])
    local pow_table = zstring.split(equip.user_equiment_ability,",")
    local now_pow_number = tonumber(pow_table[2])
    local add_str = attribute[tonumber(equip_grow_type)+1]
    
    local add_pow_number = now_pow_number - init_pow_number
    
    Text_equipment_fighting:setString(equip.equip_fight)
    -- Text_equipment_fighting:setColor(cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]))

    Text_equipment_grade:setString(quality)
    Text_equipment_strengthen_lv:setString((now_grade-1).."/".._ED.user_info.user_grade)

    local Text_equipment_11 = ccui.Helper:seekWidgetByName(root,"Text_equipment_11")
    local Text_equipment_12 = ccui.Helper:seekWidgetByName(root,"Text_equipment_12")
    local Text_equipment_13 = ccui.Helper:seekWidgetByName(root,"Text_equipment_13")
    local Text_equipment_14 = ccui.Helper:seekWidgetByName(root,"Text_equipment_14")

    Text_equipment_11:setVisible(true)
    Text_equipment_12:setVisible(true)
    Text_equipment_13:setVisible(true)
    Text_equipment_14:setVisible(true)

    Text_equipment_11:setString(red_alert_all_str[94])
    Text_equipment_12:setString(red_alert_all_str[19]..add_str)
    Text_equipment_13:setString(red_alert_all_str[95])
    Text_equipment_14:setString(red_alert_all_str[20]..add_str)
    local Text_equipment_basic_attack = ccui.Helper:seekWidgetByName(root,"Text_equipment_basic_attack")
    local Text_equipment_streng_attack = ccui.Helper:seekWidgetByName(root,"Text_equipment_streng_attack")
    local Text_equipment_before_lv = ccui.Helper:seekWidgetByName(root,"Text_equipment_before_lv")
    local Text_equipment_after_lv = ccui.Helper:seekWidgetByName(root,"Text_equipment_after_lv")

    Text_equipment_basic_attack:setVisible(true)
    Text_equipment_streng_attack:setVisible(true)
    Text_equipment_before_lv:setVisible(true)
    Text_equipment_after_lv:setVisible(true)

    Text_equipment_basic_attack:setString(init_pow_number)
    Text_equipment_streng_attack:setString(add_pow_number)
    Text_equipment_before_lv:setString(now_grade-1)
    Text_equipment_after_lv:setString(now_grade)

    local Text_equipment_before_attack = ccui.Helper:seekWidgetByName(root,"Text_equipment_before_attack")
    Text_equipment_before_attack:setString("+"..add_pow_number)
    local Text_equipment_after_attack = ccui.Helper:seekWidgetByName(root,"Text_equipment_after_attack")
    Text_equipment_after_attack:setString("+"..add_pow_number+grou_up_number)

    local Text_equipment_23 = ccui.Helper:seekWidgetByName(root,"Text_equipment_23")
    Text_equipment_23:setString(add_str)
    local Text_equipment_27 = ccui.Helper:seekWidgetByName(root,"Text_equipment_27")
    Text_equipment_27:setString(add_str)

    local need_silver = dms.int(dms["equipment_level_requirement"], now_grade, equipment_level_requirement.silver_amount)
    
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
        local suit_id_temp = tonumber(temp_data[1])
        if suit_id == suit_id_temp then
            local tempx = tonumber(temp_data[2]) -- 计算系数1 
            need_silver = need_silver *tempx
        end
    end

    for i,v in pairs(equip_type_table) do
        local temp_data = zstring.split(v,",")
        local equip_type = tonumber(temp_data[1])
        if tonumber(equip.equipment_type) == equip_type then
            local tempx = tonumber(temp_data[2]) -- 计算系数2
            need_silver = need_silver *tempx
        end
    end

    local Text_equipment_consume = ccui.Helper:seekWidgetByName(root,"Text_equipment_consume")
    Text_equipment_consume:setString(math.floor(need_silver))
    self._need_silver = need_silver
    local awaken_equipment_id = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.awaken_equipment_id)
    local additive_attribute = dms.string(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.additive_attribute)

    if additive_attribute ~= "-1" then
        additive_attribute = zstring.split(additive_attribute,",")
        local add_type = tonumber(additive_attribute[1])
        local add_number = tonumber(additive_attribute[2])
        Text_equipment_11:setString(red_alert_all_str[19]..add_str)
        Text_equipment_13:setString(red_alert_all_str[20]..add_str)
        Text_equipment_12:setString(attribute[add_type+1])
        Text_equipment_14:setVisible(false)

        Text_equipment_grade:setString(init_pow_number)
        Text_equipment_strengthen_lv:setString(add_pow_number)
        Text_equipment_basic_attack:setString(add_number)
        Text_equipment_streng_attack:setVisible(false)
    end
    -- 洗练装备icon
    local Panel_equipment_big_icon_2 = ccui.Helper:seekWidgetByName(root,"Panel_equipment_big_icon_2")
    Panel_equipment_big_icon_2:removeBackGroundImage()
    Panel_equipment_big_icon_2:setBackGroundImage(string.format(config_res.images.ui.big_props.big_props, all_icon))
    -- 洗练装备名称
    local Text_equipment_name_2 = ccui.Helper:seekWidgetByName(root,"Text_equipment_name_2")
    Text_equipment_name_2:setString(equip_name)
    Text_equipment_name_2:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    -- 洗练装备战力
    local Text_equipment_fighting_0 = ccui.Helper:seekWidgetByName(root,"Text_equipment_fighting_0")
    Text_equipment_fighting_0:setString(equip.equip_fight)

    -- 洗炼状态(如果没有煅火过显示煅火，煅火过显示洗炼)
    local Button_equ_clear = ccui.Helper:seekWidgetByName(root,"Button_equ_clear")  -- 洗炼
    local Panel_clear_infor = ccui.Helper:seekWidgetByName(root,"Panel_clear_infor")
    local Button_equ_make = ccui.Helper:seekWidgetByName(root,"Button_equ_make")    -- 锻火
    local Panel_open_clear = ccui.Helper:seekWidgetByName(root,"Panel_open_clear")
    local Text_equ_make_x = ccui.Helper:seekWidgetByName(root,"Text_equ_make_x")
    Button_equ_clear:setVisible(false)
    Panel_clear_infor:setVisible(false)
    Button_equ_make:setVisible(false)
    Panel_open_clear:setVisible(false)
    Text_equ_make_x:setVisible(true)
    local open_clear_ask = dms.int(dms["equipment_config"],6,equipment_config.param)
    if quality >= open_clear_ask and _ED.user_equiment_clear_info ~= nil and _ED.user_equiment_clear_info[""..equip.user_equiment_id] ~= nil then
        local equiment_clear_info = _ED.user_equiment_clear_info[""..equip.user_equiment_id]
        if #equiment_clear_info.first_clear_attr <= 0 then
            Button_equ_make:setVisible(true)
            Panel_open_clear:setVisible(true)
        else
            Button_equ_clear:setVisible(true)
            Panel_clear_infor:setVisible(true)
            Text_equ_make_x:setVisible(false)
            -- 洗炼属性加成
            for i=1,4 do
                local Panel_clear_attribute = ccui.Helper:seekWidgetByName(root,"Panel_clear_attribute_".. i)
                Panel_clear_attribute:setVisible(false)
                local Panel_equ_clear = ccui.Helper:seekWidgetByName(root,"Panel_equ_clear_".. i)
                Panel_equ_clear:removeBackGroundImage()
            end
            for i,v in pairs(equiment_clear_info.first_clear_attr) do
                local Panel_clear_attribute = ccui.Helper:seekWidgetByName(root,"Panel_clear_attribute_".. i)
                Panel_clear_attribute:setVisible(true)
                -- 属性icon
                local Panel_attr_icon = ccui.Helper:seekWidgetByName(root,"Panel_attr_icon_".. i)
                Panel_attr_icon:removeBackGroundImage()
                local property_type = dms.int(dms["equipment_refine_param"], v, equipment_refine_param.property_type)
                Panel_attr_icon:setBackGroundImage(string.format(config_res.images.ui.equip_attribute.equip_attribute, property_type))
                -- 属性名
                local Text_attr_t = ccui.Helper:seekWidgetByName(root,"Text_attr_t_".. i)
                local quality = dms.int(dms["equipment_refine_param"], v, equipment_refine_param.quality)
                Text_attr_t:setString(attribute[tonumber(property_type) + 1])
                Text_attr_t:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
                -- 属性值
                local Text_attr_n = ccui.Helper:seekWidgetByName(root,"Text_attr_n_".. i)
                local property_value = dms.int(dms["equipment_refine_param"], v, equipment_refine_param.property_value)
                local is_handred = false
                for i,v in pairs(attribute_hundred) do
                    if tonumber(property_type) == v then
                        is_handred = true
                    end
                end
                if is_handred == true then
                    Text_attr_n:setString("+"..property_value.."%")
                else
                    Text_attr_n:setString("+"..property_value)
                end
                Text_attr_n:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
                local max_random_value = dms.int(dms["equipment_refine_param"], v, equipment_refine_param.max_random_value)
                local Panel_equ_clear = ccui.Helper:seekWidgetByName(root,"Panel_equ_clear_".. i)
                if max_random_value == 10000 then
                    Panel_equ_clear:setBackGroundImage(config_res.images.ui.text.text_man)
                end
            end
        end
    end
end

function Equipment:setHeroCellSelected(ship)
    for i ,v in pairs(self.listview:getItems()) do 
        if v.ship == ship then
            v.isSelecet = true
            state_machine.excute("hero_icon_cell_set_seleceted",0,v)
        else
            if v.isSelecet == true then
                v.isSelecet = false
                state_machine.excute("hero_icon_cell_set_seleceted",0,v)
            end
        end
    end
end

function Equipment:close()
    local root = self.roots[1]
    local ListView_equipment_icon = ccui.Helper:seekWidgetByName(root, "ListView_equipment_icon")
    ListView_equipment_icon:removeAllItems()
    self:stopAllActions()
end

-- 延迟加载侠客cell
function Equipment:onUpdateHeroIcon()
    local root = self.roots[1]
    local ListView_equipment_icon = ccui.Helper:seekWidgetByName(root,"ListView_equipment_icon")
    local index = 1
    for i,ship in pairs(self.user_ships) do
        if i > 7 then 
            local cell = state_machine.excute("hero_icon_create_cell",0,{ship,3,i})
            ListView_equipment_icon:addChild(cell)
        end
    end
    ListView_equipment_icon:requestRefreshView()
    self.listview = ListView_equipment_icon
    self.listview_pox = ListView_equipment_icon:getInnerContainer():getPositionX()
end

function Equipment:onUpdateDraw()
    local root = self.roots[1]
    local ListView_equipment_icon = ccui.Helper:seekWidgetByName(root,"ListView_equipment_icon")
    ListView_equipment_icon:removeAllItems()
    for i,ship in pairs(self.user_ships) do
        if i <= 7 then 
            local cell = state_machine.excute("hero_icon_create_cell",0,{ship,3,i})
            ListView_equipment_icon:addChild(cell)
        else
            break
        end
    end
    ListView_equipment_icon:requestRefreshView()
    self.listview = ListView_equipment_icon
    self.listview_pox = ListView_equipment_icon:getInnerContainer():getPositionX()    
    self:setHeroCellSelected(self.ship)
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
    	local run_action  = cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(self.onUpdateHeroIcon))
    	self:runAction(run_action)
    else
    	self:onUpdateHeroIcon()
    end
end

function Equipment:onUpdateListView()
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posx = self.listview:getInnerContainer():getPositionX()
        if self.listview_pox == posx then
            return
        end
        self.listview_pox = posx
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempx = v:getPositionX() + posx
            if tempx + itemSize.width * 2 < 0 or tempx > size.width + itemSize.width * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function Equipment:onEnterTransitionFinish()

end

function Equipment:setHeroIcon()
    local root = self.roots[1]
    local Panel_equipment_hero = ccui.Helper:seekWidgetByName(root,"Panel_equipment_hero")
    Panel_equipment_hero:removeAllChildren(true)
    local ship = self.ship
    local ship_mould_id = ship.ship_template_id
    app.load("client.battle.fight.FightEnum")
    local temp_bust_index = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.bust_index)
    temp_bust_index = 10000 + temp_bust_index
    local armature = sp.spine_sprite(Panel_equipment_hero, temp_bust_index, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_10+1], true, nil, nil, cc.p(0.5, 0))
    armature:setPosition(cc.p(Panel_equipment_hero:getContentSize().width/2, 0))    

    local Text_equ_role_name = ccui.Helper:seekWidgetByName(root,"Text_equ_role_name")
    local quality = ship.ship_type
    Text_equ_role_name:setString(ship.captain_name)
    Text_equ_role_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
end

function Equipment:setEquipMent( ... )
    local root = self.roots[1]
    -- debug.print_r(self.ship)
    -- debug.print_r(_ED.user_equiment)
    for i, equip_type in pairs(self.table_panel_index) do
        local Panel_equipment_props = ccui.Helper:seekWidgetByName(root,"Panel_equipment_props_"..equip_type)
        local Panel_equipment_icon = ccui.Helper:seekWidgetByName(root,"Panel_equipment_icon_"..equip_type)
        local Panel_wearable = ccui.Helper:seekWidgetByName(root,"Panel_wearable_"..equip_type)
        Panel_equipment_icon:stopAllActions()
        Panel_equipment_props:removeAllChildren(true)
        Panel_wearable:setVisible(false)
        -- debug.print_r(self.ship.equipment)
        local equipment_id = zstring.tonumber(self.ship.equipment[i].user_equiment_id)
        if equipment_id > 0 then     
            local equip = _ED.user_equiment[""..equipment_id]
            local prop_data = {
                item_value = 1,
                prop_type = 7,
                prop_item = equip.user_equiment_template
            }
            local function onUpdateEquipmentIcon()
                local cell = state_machine.excute("all_resource_create_cell",0,{5,prop_data,equip,8,0,true,true,2})  
                Panel_equipment_props:addChild(cell)
            end
			if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
				local run_action  = cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(onUpdateEquipmentIcon))
				self:runAction(run_action)
			else
				onUpdateEquipmentIcon()
			end

            local function buttonTouchEvent(sender, evenType)
                local __spoint = sender:getTouchBeganPosition()
                if ccui.TouchEventType.began == evenType then
                    local function openOtherWindow( ... )
                        if self.open_window == false then
                            state_machine.excute("equipment_information_window_open",0,{
                                5,prop_data,equip,8,0,true,true,cc.p(__spoint.x,__spoint.y)
                                })
                            self.open_window = true
                        else
                            state_machine.excute("equipment_information_window_close", 0, 0)
                        end
                    end 
                    self.open_window = false        
                    local action = cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(openOtherWindow))  
                    self:stopAllActions()
                    self:runAction(action)    
                elseif ccui.TouchEventType.moved == evenType then

                elseif ccui.TouchEventType.canceled == evenType then
                    self:stopAllActions()
                    state_machine.excute("equipment_information_window_close", 0, 0)
                elseif ccui.TouchEventType.ended == evenType then
                    self:stopAllActions()
                    state_machine.excute("equipment_information_window_close", 0, 0)
                    if self.open_window == true then
                        return
                    end
                    state_machine.excute("equipment_change_equip_type",0,{_datas = {index = i,}})
                end
            end

            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_equipment_icon_"..equip_type), buttonTouchEvent, 
            {
                -- terminal_name = "equipment_change_equip_type", 
                terminal_state = 0, 
                index = i,
                touch_scale = true,
                touch_scale_xy = 0.95, 
            }, nil, 0)
        else
            
            local actions = cc.RepeatForever:create(cc.Sequence:create(cc.ScaleTo:create(0.5,1.05),cc.ScaleTo:create(0.5,1)))
            
            if self:getHaveEquipCanWear(equip_type) == true then
                Panel_wearable:setVisible(true)
                Panel_equipment_icon:runAction(actions)
                fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_equipment_icon_"..equip_type), nil, 
                {
                    terminal_name = "equipment_change_equip_type_and_open_wear", 
                    terminal_state = 0, 
                    index = i,
                    touch_scale = true,
                    touch_scale_xy = 0.95, 
                }, nil, 0)
            else
                Panel_wearable:setVisible(false)
                fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_equipment_icon_"..equip_type), nil, 
                {
                    terminal_name = "equipment_show_no_wear", 
                    terminal_state = 0, 
                    index = i,
                    touch_scale = true,
                    touch_scale_xy = 0.95, 
                }, nil, 0)                   
            end
        end  
    end
end

function Equipment:getHaveEquipCanWear(equip_type)
    for i,equip in pairs(_ED.user_equiment) do
        -- print("==============",tonumber(equip.ship_id)  , tonumber(equip.equipment_type) , get_type(equip_type))
        -- local _equip_type = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.equipment_type)
        if tonumber(equip.ship_id) == 0 and tonumber(equip.rela_state) == 0 and tonumber(equip.equipment_type) == equip_type then 
            return true
        end
    end
    return false
end

function Equipment:setEquipInfo()
    local root = self.roots[1]
end

function Equipment:setEquipStreng()
     local root = self.roots[1]
end

--装备可更换推送(更换按钮)
function Equipment:onUpdate()
    self:onUpdateListView()
    if self._push_notification == nil then
        return
    else 
        self._push_notification:setVisible(false)
    end
    
    local equipment = _ED.user_equiment[""..self.ship.equipment[self.select_equip_icon].user_equiment_id]
    if equipment == nil then 
        return
    end

    
    
    for i,v in pairs(_ED.user_equiment) do
        if tonumber(v.ship_id) == 0 and tonumber(v.rela_state) == 0 then
            if equipment.equipment_type == v.equipment_type and equipment.rank_level < v.rank_level then
                self._push_notification:setVisible(true)
            end
        end
    end
    
    
end

function Equipment:onInit( )
    local csbItem = csb.createNode(config_csb.packs.equipstorage.equipment)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")
    local Image_push = ccui.Helper:seekWidgetByName(root,"Image_push")
    self._push_notification = Image_push
    self._push_notification:setVisible(false)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment_back"), nil, 
    {
        terminal_name = "equipment_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --装备信息
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment"), nil, 
    {
        terminal_name = "equipment_change_page_type", 
        terminal_state = 0, 
        change_type = 1,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    --强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment_strengthen"), nil, 
    {
        terminal_name = "equipment_change_page_type", 
        terminal_state = 0,
        change_type = 2 , 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    local Button_equipment_clear = ccui.Helper:seekWidgetByName(root,"Button_equipment_clear")
    Button_equipment_clear:setVisible(false)
    if funOpenDrawTip(140,false) == false then 
        Button_equipment_clear:setVisible(true)
    end
    -- 洗练信息
    fwin:addTouchEventListener(Button_equipment_clear, nil, 
    {
        terminal_name = "equipment_change_page_type", 
        terminal_state = 0,
        change_type = 3 , 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 卸下
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment_unload"), nil, 
    {
        terminal_name = "equipment_show_unload_equip", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    
    
    -- 更换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment_change"), nil, 
    {
        terminal_name = "equipment_show_change_equip", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    --强化一次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment_strengthen_one"), nil, 
    {
        terminal_name = "equipment_streng_one", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)     
    
    --强化十次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment_strengthen_ten"), nil, 
    {
        terminal_name = "equipment_streng_ten", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    

    --觉醒
    ccui.Helper:seekWidgetByName(root,"Button_red_equipment"):setVisible(false)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_red_equipment"), nil, 
    {
        terminal_name = "equipment_open_awaken", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)  

    -- 前往装备珍兽
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_go_racecourse"), nil, 
    {
        terminal_name = "equipment_goto_racecourse", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)  

    -- 查看属性
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_attriute"), nil, 
    {
        terminal_name = "hero_attributes_window_open", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 

    -- 洗炼
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equ_clear"), nil, 
    {
        terminal_name = "equipment_open_clear", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2) 

    -- 煅火
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equ_make"), nil, 
    {
        terminal_name = "equipment_equ_make", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1) 

    -- 装备回炉
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equip_back"), nil, 
    {
        terminal_name = "equipment_clear_refining_window_open", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 2) 

    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
    	local function changePageTypeUpdate()
			state_machine.excute("equipment_change_page_type",0,{
			_datas = 
			{
				terminal_name = "equipment_change_page_type", 
				terminal_state = 0, 
				change_type = 1,
				touch_scale = true,
				touch_scale_xy = 0.95, 
			}
			})
		end	
		local run_action1  = cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(self.onUpdateDraw))
		self:runAction(run_action1)
		local run_action11  = cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(self.setHeroIcon))
		self:runAction(run_action11)
		local run_action2  = cc.Sequence:create(cc.DelayTime:create(0.3),cc.CallFunc:create(self.setEquipMent))
		self:runAction(run_action2)
		local run_action3  = cc.Sequence:create(cc.DelayTime:create(0.4),cc.CallFunc:create(self.setEquipInfo))
		self:runAction(run_action3)	
		local run_action4  = cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create(self.setEquipStreng))
		self:runAction(run_action4)
		local run_action5  = cc.Sequence:create(cc.DelayTime:create(0.6),cc.CallFunc:create(self.setIconSelected))
		self:runAction(run_action5)
		local run_action6  = cc.Sequence:create(cc.DelayTime:create(0.7),cc.CallFunc:create(changePageTypeUpdate))
    	self:runAction(run_action6)
    else
		self:onUpdateDraw() 
		self:setHeroIcon()
		self:setEquipMent()
		self:setEquipInfo()
		self:setEquipStreng()
		self:setIconSelected()
		state_machine.excute("equipment_change_page_type",0,{
			_datas = 
			{
				terminal_name = "equipment_change_page_type", 
				terminal_state = 0, 
				change_type = 1,
				touch_scale = true,
				touch_scale_xy = 0.95, 
			}
			})
    end
end

function Equipment:getSortForFight()
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
        -- debug.print_r(ship)
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
    for i,v in pairs(blue_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(green_ship) do
        table.insert(all_result,v)
    end  
    for i,v in pairs(white_ship) do
       table.insert(all_result,v)
    end
    return all_result
end

function Equipment:init(user_ships,show_type)
    self.user_ships = user_ships or self:getSortForFight()
    self.show_type = show_type or 1
    self.ship = self.user_ships[1]    
    self.table_panel_index = {0,1,2,3,9,10}
    self.select_equip_icon = 1
    self:onInit()
    return self
end

function Equipment:destroy()
    if fwin:find("NationalWarMapClass") == nil then
        cc.SpriteFrameCache:getInstance():removeSpriteFrames() 
        cc.Director:getInstance():getTextureCache():removeUnusedTextures()
    end
end

function Equipment:onExit()
    state_machine.remove("equipment_window_show")   
    state_machine.remove("equipment_window_hide")
    state_machine.remove("equipment_change_ship")
    state_machine.remove("equipment_change_page_type")
    state_machine.remove("equipment_change_equip_type")
    state_machine.remove("equipment_change_equip_type_and_open_wear")
    state_machine.remove("equipment_show_no_wear")
    state_machine.remove("equipment_show_wear_success")
    state_machine.remove("equipment_show_unload_equip")   
    state_machine.remove("equipment_show_change_equip") 
    state_machine.remove("equipment_streng_one")
    state_machine.remove("equipment_streng_ten")
    state_machine.remove("equipment_inlay_gems")
    state_machine.remove("equipment_open_awaken")
    state_machine.remove("equipment_update_after_awaken")
    state_machine.remove("equipment_update_fight_number")
    state_machine.remove("equipment_goto_racecourse")
    state_machine.remove("equipment_open_clear")
    state_machine.remove("equipment_equ_make")
end
