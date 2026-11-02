-----------------------------
--包裹
-----------------------------
Packs = class("PacksClass", Window)

--打开包裹
local packs_window_open_terminal = {
    _name = "packs_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        
        if funOpenDrawTip(69) == true then
            return
        end      
        local _Window = fwin:find("PacksClass")
        if nil == _Window then
            fwin:open(Packs:new():init(), fwin._view)
        end
        state_machine.excute("main_window_hide", 0, "")
        state_machine.excute("player_resource_window_show", 0, "")     
        state_machine.excute("home_button_for_action_window_hide",0,"")
        state_machine.excute("chat_view_window_hide",0,"")
        state_machine.excute("duplicate_title_window_hide",0,"")   
        state_machine.excute("packs_window_show",0,"")
        state_machine.excute("duplicate_map_window_hide",0,"")
        state_machine.excute("duplicate_manager_window_hide",0,"")
        state_machine.excute("seven_star_map_ui_window_hide",0,"")
        
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭包裹
local packs_window_close_terminal = {
    _name = "packs_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PacksClass"))
        if fwin:find("NationalWarMapClass") ~= nil then
            -- state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
        elseif fwin:find("DuplicateManagerClass") ~= nil then
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("player_resource_window_hide", 0, "")
            state_machine.excute("duplicate_title_window_show",0,"")
            state_machine.excute("duplicate_map_window_show",0,"")
            state_machine.excute("duplicate_manager_window_show",0,"")
        elseif fwin:find("SevenStarClass") ~= nil then
            state_machine.excute("seven_star_map_ui_window_show",0,"")
            state_machine.excute("duplicate_map_window_show",0,"")
            state_machine.excute("player_resource_window_hide",0,"")
            state_machine.excute("home_button_for_action_window_show",0,"")
        elseif fwin:find("DuplicateManagerClass") == nil and fwin:find("DuplicateMapClass") ~= nil then
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
        state_machine.excute("national_city_hide_game_resource_info", 0, nil)
        
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(packs_window_open_terminal)
state_machine.add(packs_window_close_terminal)
state_machine.init()

function Packs:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    --load lua file
    app.load("client.red_alert.packs.PacksScrollviewAll")
    app.load("client.red_alert.packs.PacksScrollviewHero")
    app.load("client.red_alert.packs.PacksScrollviewEquip")
    app.load("client.red_alert.packs.PacksScrollviewJewelry")
    app.load("client.red_alert.packs.PacksScrollviewUse")
    app.load("client.red_alert.forging.Refining")   
    app.load("client.red_alert.packs.EquipStrengthCell")
    app.load("client.red_alert.packs.EquipGemsCell")
    app.load("client.red_alert.packs.PacksSell")
    app.load("client.red_alert.campaign.gemduplicate.GemDuplicate")
    app.load("client.red_alert.campaign.weaponry.Weaponry")
    app.load("client.utils.ConfirmTip")
    app.load("client.red_alert.activity.wonderful.ActivitySelectAward")

    -- var 
    --列表添加层
    self.panel = nil
    --出售道具实例
    self._sell_prop = nil
    --使用道具实例
    self._use_prop = nil

    self._page_index = 0

    -- Initialize DuplicateTitle state machine.
    local function init_packs_terminal()
        --管理
        local packs_window_manager_terminal = {
        _name = "packs_window_manager",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)

            if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                -- hide child window
                terminal.last_terminal_name = params._datas.next_terminal_name
                state_machine.excute(params._datas.next_terminal_name, 0, params)
            end 
            -- set select ui button is highlighted
           
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(false)
                terminal.select_button:setTouchEnabled(true)
            end
            terminal.page_name = params._datas.but_image
            if terminal.select_button == nil and params._datas.current_button_name ~= nil then
                terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
            else
                terminal.select_button = params
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

		--显示界面
		local packs_window_show_terminal = {
            _name = "packs_window_show",
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
		local packs_window_hide_terminal = {
            _name = "packs_window_hide",
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

        --显示全部
        local packs_show_packs_scrollview_all_terminal = {
            _name = "packs_show_packs_scrollview_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._page_index = params._datas.index
                state_machine.excute("packs_scrollview_all_window_open",0,{instance.panel})
                state_machine.excute("packs_scrollview_all_window_show",0,"")

                state_machine.excute("packs_scrollview_equip_window_hide",0,"")
                state_machine.excute("packs_scrollview_hero_window_hide",0,"")
                state_machine.excute("packs_scrollview_jewelry_window_hide",0,"")
                state_machine.excute("packs_scrollview_use_window_hide",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --显示装备
        local packs_show_packs_scrollview_equip_terminal = {
            _name = "packs_show_packs_scrollview_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._page_index = params._datas.index
                state_machine.excute("packs_scrollview_equip_window_open",0,{instance.panel})
                state_machine.excute("packs_scrollview_equip_window_show",0,"")

                state_machine.excute("packs_scrollview_all_window_hide",0,"")
                state_machine.excute("packs_scrollview_hero_window_hide",0,"")
                state_machine.excute("packs_scrollview_jewelry_window_hide",0,"")
                state_machine.excute("packs_scrollview_use_window_hide",0,"")                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --显示英雄
        local packs_show_packs_scrollview_hero_terminal = {
            _name = "packs_show_packs_scrollview_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._page_index = params._datas.index
                state_machine.excute("packs_scrollview_hero_window_open",0,{instance.panel})
                state_machine.excute("packs_scrollview_hero_window_show",0,"")

                state_machine.excute("packs_scrollview_all_window_hide",0,"")
                state_machine.excute("packs_scrollview_equip_window_hide",0,"")
                state_machine.excute("packs_scrollview_jewelry_window_hide",0,"")
                state_machine.excute("packs_scrollview_use_window_hide",0,"")                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
            --显示宝石
        local packs_show_packs_scrollview_jewelry_terminal = {
            _name = "packs_show_packs_scrollview_jewelry",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._page_index = params._datas.index
                state_machine.excute("packs_scrollview_jewelry_window_open",0,{instance.panel})
                state_machine.excute("packs_scrollview_jewelry_window_show",0,"")

                state_machine.excute("packs_scrollview_all_window_hide",0,"")
                state_machine.excute("packs_scrollview_equip_window_hide",0,"")
                state_machine.excute("packs_scrollview_hero_window_hide",0,"")
                state_machine.excute("packs_scrollview_use_window_hide",0,"")                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
            --显示消耗品
        local packs_show_packs_scrollview_use_terminal = {
            _name = "packs_show_packs_scrollview_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._page_index = params._datas.index
                state_machine.excute("packs_scrollview_use_window_open",0,{instance.panel})
                state_machine.excute("packs_scrollview_use_window_show",0,"")  

                state_machine.excute("packs_scrollview_all_window_hide",0,"")
                state_machine.excute("packs_scrollview_equip_window_hide",0,"")
                state_machine.excute("packs_scrollview_hero_window_hide",0,"")
                state_machine.excute("packs_scrollview_jewelry_window_hide",0,"")                    
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

            --左侧道具绘制
        local packs_left_prop_draw_terminal = {
            _name = "packs_left_prop_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawLeftProp(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 合成
        local packs_goto_combing_terminal = {
            _name = "packs_goto_combing",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local prop = params._datas._prop 
                local prop_id = prop.user_prop_template
                
                local combining_type = 0

                local equipment_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], prop_id, prop_mould.change_of_equipment))
                local ship_mould_id = zstring.tonumber(dms.int(dms["prop_mould"],prop_id, prop_mould.use_of_ship))
                if equipment_mould_id > 0 then
                    combining_type = 0
                elseif ship_mould_id > 0 then
                    combining_type = 1
                end

                --print("============",instance.combining_id.."\r\n"..(instance.page_index - 1).."\r\n")
                local function responseCombiningCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.openRewardWindow ~= nil then
                            response.node:openRewardWindow(combining_type,prop_id)
                            state_machine.excute("packs_scrollview_all_update_draw",0,"")
                            state_machine.excute("packs_scrollview_equip_onupdate_all_equip",0,"")
                            state_machine.excute("packs_scrollview_hero_on_update_all",0,"")
                            state_machine.excute("packs_update_page",0,"")
                        end
                    end
                end
                protocol_command.prop_compound.param_list = prop.user_prop_id.."\r\n"..combining_type.."\r\n".."1"
                NetworkManager:register(protocol_command.prop_compound.code, nil, nil, nil, instance, responseCombiningCallback, false, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --跳转
        local packs_go_to_short_cut_terminal = {
            _name = "packs_go_to_short_cut",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local prop = params._datas._prop
                state_machine.excute("get_the_way_window_open",0,{6,prop.user_prop_template,prop.prop_number})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 跳转至镶嵌
        local packs_goto_inlay_terminal = {
            _name = "packs_goto_inlay",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(68) == true then
                    return false
                end 
                state_machine.excute("packs_window_hide",0,"")
                state_machine.excute("equipment_window_open",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 跳转至黑石山
        local packs_goto_weaponry_terminal = {
            _name = "packs_goto_weaponry",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(111) == true then
                    return false
                end 
                state_machine.excute("weaponry_window_open",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 跳转至宝石矿洞
        local packs_goto_gem_terminal = {
            _name = "packs_goto_gem",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(112) == true then
                    return false
                end 
                state_machine.excute("gem_duplicate_window_open",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 使用型的道具跳转
        local packs_use_go_to_short_cut_terminal = {
            _name = "packs_use_go_to_short_cut",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local prop = params._datas._prop
                local trace_address_str = dms.string(dms["prop_mould"],prop.user_prop_template,prop_mould.trace_address)
                if trace_address_str ~= "-1" then
                    trace_address_str = zstring.split(trace_address_str,"|")
                    local get_way_id = tonumber(trace_address_str[2])
                    state_machine.excute("short_cut_go_to_other_window",0,{get_way_id})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 道具出售
        local packs_prop_sell_terminal = {
            _name = "packs_prop_sell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local prop = params._datas._prop
                instance._sell_prop = prop
                if tonumber(prop.prop_number) == 1 then
                    if prop.quality >= 3 then
                        local tip = ConfirmTip:new()
                        tip:init(instance, instance.sureSell, red_alert_all_str[133])
                        fwin:open(tip,fwin._windows)
                    else
                        instance:sureSell(0)
                    end 
                else
                    state_machine.excute("packs_sell_window_open",0,{prop,1})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 道具使用
        local packs_prop_use_terminal = {
            _name = "packs_prop_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local prop = params._datas._prop
                instance._use_prop = prop
                if tonumber(prop.prop_number) == 1 then
                    instance:sureUse()
                else
                    state_machine.excute("packs_sell_window_open",0,{prop,2})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 多选一道具使用
        local packs_prop_select_reward_use_terminal = {
            _name = "packs_prop_select_reward_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local prop = params._datas._prop
                local reward_list = params._datas._reward_list
                state_machine.excute("activity_select_award_open", 0, {prop, reward_list})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 重置信息
        local packs_prop_reset_ui_terminal = {
            _name = "packs_prop_reset_ui",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:resetUIInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新当前选择的页面
        local packs_update_page_terminal = {
            _name = "packs_update_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updatePage()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(packs_window_manager_terminal)
		state_machine.add(packs_window_show_terminal)	
		state_machine.add(packs_window_hide_terminal)
        state_machine.add(packs_show_packs_scrollview_all_terminal)
        state_machine.add(packs_show_packs_scrollview_equip_terminal)
        state_machine.add(packs_show_packs_scrollview_hero_terminal)
        state_machine.add(packs_show_packs_scrollview_jewelry_terminal)
        state_machine.add(packs_show_packs_scrollview_use_terminal)
        state_machine.add(packs_left_prop_draw_terminal)
        state_machine.add(packs_goto_combing_terminal)
        state_machine.add(packs_go_to_short_cut_terminal)
        state_machine.add(packs_goto_inlay_terminal)
        state_machine.add(packs_use_go_to_short_cut_terminal)
        state_machine.add(packs_prop_sell_terminal)
        state_machine.add(packs_prop_use_terminal)
        state_machine.add(packs_prop_reset_ui_terminal)
        state_machine.add(packs_goto_weaponry_terminal)
        state_machine.add(packs_goto_gem_terminal)
        state_machine.add(packs_prop_select_reward_use_terminal)
        state_machine.add(packs_update_page_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_packs_terminal()
end

function Packs:sureSell(sure_numbers)
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("reward_obtain_window_open",0,{66})
            state_machine.excute("packs_scrollview_all_update_draw",0,"")
            state_machine.excute("packs_scrollview_on_update_all",0,"")
            state_machine.excute("packs_update_page",0,"")
        end
    end

    if sure_numbers == 0 then
        protocol_command.prop_sell.param_list = self._sell_prop.user_prop_id.."\r\n".."1"
        NetworkManager:register(protocol_command.prop_sell.code, nil, nil, nil, nil, responseCallback, false, nil) 
    end
end

--确定使用
function Packs:sureUse()
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("reward_obtain_window_open",0,{4})
            state_machine.excute("packs_scrollview_all_update_draw",0,"")
            state_machine.excute("packs_scrollview_on_update_all",0,"")
            state_machine.excute("packs_scrollview_equip_onupdate_all_equip",0,"")
            state_machine.excute("packs_scrollview_hero_on_update_all",0,"")
            state_machine.excute("packs_scrollview_jewelry_onupdate_all_jewelry",0,"")
            state_machine.excute("packs_update_page",0,"")
        end
    end
    
    protocol_command.prop_use.param_list = self._use_prop.user_prop_id.."\r\n".."1"
    NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, nil, responseCallback, false, nil)     
end

function Packs:resetUIInfo( ... )
    local root = self.roots[1]
    local Panel_packs_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_packs_props_icon")  --左侧道具icon
    Panel_packs_props_icon:removeAllChildren(true)
    local Text_packs_props_name = ccui.Helper:seekWidgetByName(root,"Text_packs_props_name")    --左侧道具名字
    Text_packs_props_name:setString("")
    local Button_packs_use = ccui.Helper:seekWidgetByName(root,"Button_packs_use")  --使用按钮
    local Panel_packs_use = ccui.Helper:seekWidgetByName(root,"Panel_packs_use")    --使用面板
    local Panel_packs_sell = ccui.Helper:seekWidgetByName(root,"Panel_packs_sell")
    local Panel_packs_resolve = ccui.Helper:seekWidgetByName(root,"Panel_packs_resolve")--获取分解
    local Panel_packs_combining = ccui.Helper:seekWidgetByName(root,"Panel_packs_combining")
    local Panel_packs_inlay = ccui.Helper:seekWidgetByName(root,"Panel_packs_inlay") --获取镶嵌
    local Panel_packs_get = ccui.Helper:seekWidgetByName(root,"Panel_packs_get")
    Button_packs_use:setVisible(true)
    Panel_packs_use:setVisible(false)
    Panel_packs_sell:setVisible(false)
    Panel_packs_resolve:setVisible(false)
    Panel_packs_combining:setVisible(false)
    Panel_packs_inlay:setVisible(false)
    Panel_packs_get:setVisible(false)
end

--打开合成奖励
function Packs:openRewardWindow(combining_type,prop_mould_id)
    if combining_type == 0 then     --装备
        local equipment_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], prop_mould_id, prop_mould.change_of_equipment))
        local data = 
        {
            item_value = 1,
            prop_type = 7,
            prop_item = equipment_mould_id,
        }
        --print("===========",equipment_mould_id)
        state_machine.excute("reward_obtain_window_open",0,{nil, 
            {
                show_reward_list = 
                {
                    data
                }
            }
            })
    elseif combining_type == 1 then     --武将
        local ship_mould_id = zstring.tonumber(dms.int(dms["prop_mould"],prop_mould_id, prop_mould.use_of_ship)) 
        local data = 
        {
            item_value = 1,
            prop_type = 13,
            prop_item = ship_mould_id, 
        }   
        --print("===========",ship_mould_id)      
        state_machine.excute("reward_obtain_window_open",0,{nil,
            {
                show_reward_list = 
                {
                    data
                }
            }
            })
    elseif self.page_index == 3 then 

    end  
end

--隐藏包裹
function Packs:onHide( ... )
    self:setVisible(false)
end

--显示包裹
function Packs:onShow( ... )
    self:setVisible(true)
end

--装备信息列表
function Packs:drawEquipListInfo(equip)
    local root = self.roots[1]
    local ListView_packs_resolve = ccui.Helper:seekWidgetByName(root,"ListView_packs_resolve")
    ListView_packs_resolve:removeAllItems()

    local init_pow_number = dms.string(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.initial_value)           --初始附加值
    local additive_attribute = dms.string(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.additive_attribute)   --装备附加属性
    local equip_grow_type = 0 -- 成长类型
    init_pow_number = zstring.split(init_pow_number,",")
    equip_grow_type = tonumber(init_pow_number[1])
    init_pow_number = tonumber(init_pow_number[2]) 
    local pow_table = zstring.split(equip.user_equiment_ability,",")
    local now_pow_number = tonumber(pow_table[2])
    local now_grade = tonumber(equip.user_equiment_grade)
    local add_str = attribute[tonumber(equip_grow_type)+1]
    local add_pow_number = now_pow_number - init_pow_number


    local other_add_str = ""
    local other_add_number = 0

    if additive_attribute ~= "-1" then
        additive_attribute = zstring.split(additive_attribute,",")
        other_add_str = tonumber(additive_attribute[1])
        other_add_number = tonumber(additive_attribute[2])
    end

    local dec_text_tab = {
        {
            dec_name = red_alert_all_str[95],
            dec =  (now_grade-1).."/".._ED.user_info.user_grade
        },
        {
            dec_name = red_alert_all_str[19]..add_str,
            dec =  init_pow_number
        },
        {
            dec_name = red_alert_all_str[20]..add_str,
            dec =  add_pow_number
        },
        {
            dec_name = attribute[other_add_str],
            dec =  other_add_number
        },
    }

    local equip_strength_cell = state_machine.excute("equip_strength_create_cell",0,{nil})
    ListView_packs_resolve:addChild(equip_strength_cell)
    for i,v in pairs(dec_text_tab) do
        if v.dec ~= 0 then
            local equip_strength_cell = state_machine.excute("equip_strength_create_cell",0,{v})
            ListView_packs_resolve:addChild(equip_strength_cell)
        end
    end
    local equip_gems_cell = state_machine.excute("equip_gems_create_cell",0,{nil,1})
    ListView_packs_resolve:addChild(equip_gems_cell)
    local have_gems = false
    for i,v in pairs(equip.jewelrys) do
        if tonumber(v) ~= 0 then
            local gems_id = v
            local gems_cell = state_machine.excute("equip_gems_create_cell",0,{_ED.user_gems[""..gems_id]})
            ListView_packs_resolve:addChild(gems_cell)
            have_gems = true
        end
    end
    if have_gems == false then
        local gems_cell = state_machine.excute("equip_gems_create_cell",0,{nil,2})
        ListView_packs_resolve:addChild(gems_cell)
    end
end

--左侧道具绘制
function Packs:onUpdateDrawLeftProp(data)
    local  root = self.roots[1]    
    local prop_show_type = data[1]
    local prop_data = data[2]
    local prop = data[3]
    local prop_from_type = data[4]
    -- debug.print_r(prop)
    local Panel_packs_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_packs_props_icon")  --左侧道具icon
    Panel_packs_props_icon:removeAllChildren(true)
    local cell = state_machine.excute("all_resource_create_cell",0,{prop_show_type,prop_data,prop,9,0,true,true})
    Panel_packs_props_icon:addChild(cell)
    local Text_packs_props_name = ccui.Helper:seekWidgetByName(root,"Text_packs_props_name")    --左侧道具名字
    local name = prop.prop_name or prop.user_equiment_name or dms.string(dms["gems_mould"],prop.mould_id,gems_mould.name)
    Text_packs_props_name:setString(name)
    local Button_packs_use = ccui.Helper:seekWidgetByName(root,"Button_packs_use")  --使用按钮
    local Panel_packs_use = ccui.Helper:seekWidgetByName(root,"Panel_packs_use")    --使用面板
    local Panel_packs_sell = ccui.Helper:seekWidgetByName(root,"Panel_packs_sell")
    local Panel_packs_resolve = ccui.Helper:seekWidgetByName(root,"Panel_packs_resolve")--获取分解
    local Panel_packs_combining = ccui.Helper:seekWidgetByName(root,"Panel_packs_combining")
    local Panel_packs_inlay = ccui.Helper:seekWidgetByName(root,"Panel_packs_inlay") --获取镶嵌
    local Panel_packs_get = ccui.Helper:seekWidgetByName(root,"Panel_packs_get")
    Button_packs_use:setVisible(true)
    Panel_packs_use:setVisible(false)
    Panel_packs_sell:setVisible(false)
    Panel_packs_resolve:setVisible(false)
    Panel_packs_combining:setVisible(false)
    Panel_packs_inlay:setVisible(false)
    Panel_packs_get:setVisible(false)

    if tonumber(prop_data.prop_type) == 6 then
        local quatily = dms.int(dms["prop_mould"],prop_data.prop_item,prop_mould.prop_quality)
        Text_packs_props_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quatily+1][1],tipStringInfo_quality_color_Type[quatily+1][2],tipStringInfo_quality_color_Type[quatily+1][3]))
    elseif tonumber(prop_data.prop_type) == 7 then
        local quatily = dms.int(dms["equipment_mould"],prop.user_equiment_template,equipment_mould.grow_level)
        Text_packs_props_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quatily+1][1],tipStringInfo_quality_color_Type[quatily+1][2],tipStringInfo_quality_color_Type[quatily+1][3]))
    elseif tonumber(prop_data.prop_type) == 34 then
        local quatily = dms.int(dms["gems_mould"],prop.mould_id,gems_mould.quality)
        Text_packs_props_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quatily+1][1],tipStringInfo_quality_color_Type[quatily+1][2],tipStringInfo_quality_color_Type[quatily+1][3]))
    end
    local trace_address_type = -1
    if tonumber(prop_data.prop_type) == 6 then
        local trace_address_str = dms.string(dms["prop_mould"],prop_data.prop_item,prop_mould.trace_address)
        if trace_address_str ~= "-1" then
            trace_address_str = zstring.split(trace_address_str,"|")
            trace_address_type = tonumber(trace_address_str[1])
        end
    end
-- 1 获取、出售
-- 2 获取、合成 
-- 3 获取 
-- 4 使用（得到物品）   
-- 5 使用（跳转）
-- 6 无按钮 
    if tonumber(prop_data.prop_type) == 7 then -- 装备 获取分解
        Panel_packs_resolve:setVisible(true)
        local Text_packs_resolve_fight = ccui.Helper:seekWidgetByName(root,"Text_packs_resolve_fight")
        local Text_packs_quatily = ccui.Helper:seekWidgetByName(root,"Text_packs_quatily")
        local quatily = dms.int(dms["equipment_mould"],prop.user_equiment_template,equipment_mould.suit_id)
        Text_packs_resolve_fight:setString(prop.equip_fight)
        Text_packs_quatily:setString(quatily)      
        -- 装备获取
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_resolve_get"), nil, 
        {
            -- func_string = [[funOpenDrawTip(64)]], 
            terminal_name = "packs_goto_weaponry", 
            terminal_state = 0, 
            _prop = prop,
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)  
        -- 装备分解跳转
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_resolve"), nil, 
        {
            terminal_name = "refining_window_open", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            page_index = 2,
        }, nil, 0)   
        -- debug.print_r(prop)
        self:drawEquipListInfo(prop)
    elseif tonumber(prop_data.prop_type) == 6 and prop_show_type == 3 then  -- 获取 合成  装备碎片 武将碎片
        local Text_packs_combining_have = ccui.Helper:seekWidgetByName(root,"Text_packs_combining_have")
        local Text_packs_combining_information = ccui.Helper:seekWidgetByName(root,"Text_packs_combining_information")           
        Panel_packs_combining:setVisible(true)
        Text_packs_combining_have:setString(string.format(red_alert_all_str[18],prop_data.item_value))
        Text_packs_combining_information:setString(prop.prop_function_remark)

        local equipment_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], prop_data.prop_item, prop_mould.change_of_equipment))
        local ship_mould_id = zstring.tonumber(dms.int(dms["prop_mould"],prop_data.prop_item, prop_mould.use_of_ship))
        if equipment_mould_id > 0 then
            --获取
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_combining_get"), nil, 
            {
                terminal_name = "packs_goto_weaponry", 
                terminal_state = 0, 
                _prop = prop,
                touch_scale = true,
                touch_scale_xy = 0.95, 
            }, nil, 0)
        elseif ship_mould_id > 0 then
            --获取
            local Button_packs_combining_get = ccui.Helper:seekWidgetByName(root,"Button_packs_combining_get")
                Button_packs_combining_get:setBright(true)
                Button_packs_combining_get:setTouchEnabled(true)
            if trace_address_type == -1 then    -- 没有获取途径的时候获取按钮不可点击
                Button_packs_combining_get:setBright(false)
                Button_packs_combining_get:setTouchEnabled(false)
            end
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_combining_get"), nil, 
            {
                -- func_string = [[funOpenDrawTip(64)]], 
                terminal_name = "packs_go_to_short_cut", 
                terminal_state = 0, 
                _prop = prop,
                touch_scale = true,
                touch_scale_xy = 0.95, 
            }, nil, 0) 
        end
        --合成
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_combining"), nil, 
        {
            terminal_name = "packs_goto_combing", 
            terminal_state = 0, 
            _prop = prop,
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0) 
    elseif tonumber(prop_data.prop_type) == 6 and trace_address_type == 1 then -- 获取、出售
        Panel_packs_sell:setVisible(true)
        local Text_packs_have = ccui.Helper:seekWidgetByName(root,"Text_packs_have")
        local Text_packs_information = ccui.Helper:seekWidgetByName(root,"Text_packs_information")
        local Text_packs_sell_number = ccui.Helper:seekWidgetByName(root,"Text_packs_sell_number")
        Text_packs_have:setString(string.format(red_alert_all_str[18],prop_data.item_value))
        Text_packs_information:setString(prop.prop_function_remark)
        Text_packs_sell_number:setString(prop.sell_system_price)
    
        --获取
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_get_sell"), nil, 
        {
            terminal_name = "packs_go_to_short_cut", 
            terminal_state = 0, 
            _prop = prop,
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0) 


        --出售
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_sell"), nil, 
        {
            terminal_name = "packs_prop_sell", 
            terminal_state = 0, 
            _prop = prop,
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)          
    elseif tonumber(prop_data.prop_type) == 6 and trace_address_type == 3 then -- 获取
        Panel_packs_get:setVisible(true)
        local Text_packs_have_get = ccui.Helper:seekWidgetByName(root,"Text_packs_have_get")
        local Text_packs_information_get = ccui.Helper:seekWidgetByName(root,"Text_packs_information_get")
        Text_packs_have_get:setString(string.format(red_alert_all_str[18],prop_data.item_value))
        Text_packs_information_get:setString(prop.prop_function_remark)
       
        --单个的获取 道具
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_get"), nil, 
        {
            terminal_name = "packs_go_to_short_cut", 
            terminal_state = 0, 
            _prop = prop,
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0) 
    elseif  tonumber(prop_data.prop_type) == 34 then
        Panel_packs_inlay:setVisible(true)

        local gem_data = dms.element(dms["gems_mould"],prop.mould_id)       --宝石模板
        local next_mould_id = dms.atoi(gem_data,gems_mould.next_mould_id)   --进阶后模板id
        local up_need_exp = dms.atoi(gem_data,gems_mould.up_need_exp)       --升级需要经验
        local add_attribute  = dms.atos(gem_data,gems_mould.add_attribute)  --增加属性
        add_attribute = zstring.split(add_attribute,",")

        local text_title = tonumber(add_attribute[1]) + 1
        text_title = attribute[text_title]
        local text_str = tonumber(add_attribute[2])
        text_str = "  +" .. text_str

        local LoadingBar_inlay_1 = ccui.Helper:seekWidgetByName(root,"LoadingBar_inlay_1")
        local Text_packs_inlay_schedule = ccui.Helper:seekWidgetByName(root,"Text_packs_inlay_schedule")
        local persent = math.floor(tonumber(prop.exp) / up_need_exp * 100)
        LoadingBar_inlay_1:setPercent(persent)
        Text_packs_inlay_schedule:setString(tonumber(prop.exp) .. "/" .. up_need_exp)
        local Text_packs_inlay_4 = ccui.Helper:seekWidgetByName(root,"Text_packs_inlay_4")
        local Text_packs_inlay_5 = ccui.Helper:seekWidgetByName(root,"Text_packs_inlay_5")
        Text_packs_inlay_4:setString(text_title)
        Text_packs_inlay_5:setString(text_title)

        local Text_packs_inlay_troops_1 = ccui.Helper:seekWidgetByName(root,"Text_packs_inlay_troops_1")
        local Text_packs_inlay_troops_2 = ccui.Helper:seekWidgetByName(root,"Text_packs_inlay_troops_2")
        local Text_packs_combining_effect = ccui.Helper:seekWidgetByName(root,"Text_packs_combining_effect")
        Text_packs_combining_effect:setVisible(true)
        Text_packs_inlay_troops_1:setString(text_str)
        if next_mould_id ~= -1 then
            local add_attribute_next = dms.string(dms["gems_mould"],next_mould_id,gems_mould.add_attribute)
            add_attribute_next = zstring.split(add_attribute_next,",")
            Text_packs_inlay_troops_2:setString("  +"..add_attribute_next[2])
        else
            Text_packs_inlay_schedule:setString(tipStringInfo_union_str[70])
            Text_packs_combining_effect:setVisible(false)
            Text_packs_inlay_troops_2:setString("")
            Text_packs_inlay_5:setString("")
        end

        --镶嵌
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_inlay"), nil, 
        {
            terminal_name = "packs_goto_inlay", 
            terminal_state = 0, 
            _prop = prop,
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)    

        --获取
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_inlay_get"), nil, 
        {
            -- func_string = [[funOpenDrawTip(64)]], 
            terminal_name = "packs_goto_gem", 
            terminal_state = 0, 
            _prop = prop,
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)
    elseif tonumber(prop_data.prop_type) == 6 and trace_address_type == 4 then -- 使用得到物品
        local Text_packs_have_uses = ccui.Helper:seekWidgetByName(root,"Text_packs_have_uses")
        local Text_packs_information_use = ccui.Helper:seekWidgetByName(root,"Text_packs_information_use")
        Panel_packs_use:setVisible(true)
        Text_packs_have_uses:setString(string.format(red_alert_all_str[18],prop_data.item_value))
        Text_packs_information_use:setString(prop.prop_function_remark)

        --使用
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_use"), nil, 
        {
            terminal_name = "packs_prop_use", 
            terminal_state = 0, 
            _prop = prop,
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)
    elseif tonumber(prop_data.prop_type) == 6 and trace_address_type == 7 then -- 使用多选一宝箱得到物品
        local Text_packs_have_uses = ccui.Helper:seekWidgetByName(root,"Text_packs_have_uses")
        local Text_packs_information_use = ccui.Helper:seekWidgetByName(root,"Text_packs_information_use")
        Panel_packs_use:setVisible(true)
        Text_packs_have_uses:setString(string.format(red_alert_all_str[18],prop_data.item_value))
        Text_packs_information_use:setString(prop.prop_function_remark)

        local reward_id = dms.int(dms["prop_mould"], prop_data.prop_item, prop_mould.addition_group_index)
        local reward_info = dms.string(dms["scene_reward"], reward_id, scene_reward.reward_items)
        local reward_list = zstring.split(reward_info, "|")             -- 可选择道具

        --使用
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_use"), nil, 
        {
            terminal_name = "packs_prop_select_reward_use", 
            terminal_state = 0, 
            _prop = prop,
            _reward_list = reward_list,
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)
    elseif tonumber(prop_data.prop_type) == 6 and trace_address_type == 5 then -- 使用获取
        local Text_packs_have_uses = ccui.Helper:seekWidgetByName(root,"Text_packs_have_uses")
        local Text_packs_information_use = ccui.Helper:seekWidgetByName(root,"Text_packs_information_use")
        Panel_packs_use:setVisible(true)
        Text_packs_have_uses:setString(string.format(red_alert_all_str[18],prop_data.item_value))
        Text_packs_information_use:setString(prop.prop_function_remark)

        --使用
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_use"), nil, 
        {
            terminal_name = "packs_use_go_to_short_cut", 
            terminal_state = 0, 
            _prop = prop,
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 0)
    elseif trace_address_type == -1 then
        Panel_packs_use:setVisible(true)
        Button_packs_use:setVisible(false)
        local Text_packs_have_uses = ccui.Helper:seekWidgetByName(root,"Text_packs_have_uses")
        local Text_packs_information_use = ccui.Helper:seekWidgetByName(root,"Text_packs_information_use")
        Text_packs_have_uses:setString(string.format(red_alert_all_str[18],prop_data.item_value))
        Text_packs_information_use:setString(prop.prop_function_remark)
    elseif tonumber(prop_data.prop_type) == 6 and trace_address_type == 6 then -- 无按钮
        Panel_packs_use:setVisible(true)
        Button_packs_use:setVisible(false)
        local Text_packs_have_uses = ccui.Helper:seekWidgetByName(root,"Text_packs_have_uses")
        local Text_packs_information_use = ccui.Helper:seekWidgetByName(root,"Text_packs_information_use")
        Text_packs_have_uses:setString(string.format(red_alert_all_str[18],prop_data.item_value))
        Text_packs_information_use:setString(prop.prop_function_remark)
    end

end

--刷新包裹
function Packs:onUpdateDraw()
    local root = self.roots[1]
    state_machine.excute("packs_window_manager",0,
        {
            _datas = {
                terminal_name = "packs_window_manager",     
                next_terminal_name = "packs_show_packs_scrollview_all", 
                current_button_name = "Button_packs_complete",   
                but_image = "",     
                terminal_state = 0, 
                touch_scale = true,
                touch_scale_xy = 0.95, 
                index = 1,
            }
        }
    )
end   

function Packs:updatePage()
    if self._page_index == 1 then
        state_machine.excute("packs_scrollview_all_window_show",0,"")
    elseif self._page_index == 2 then
        state_machine.excute("packs_scrollview_equip_window_show",0,"")
    elseif self._page_index == 3 then
        state_machine.excute("packs_scrollview_hero_window_show",0,"")
    elseif self._page_index == 4 then
        state_machine.excute("packs_scrollview_jewelry_window_show",0,"")
    elseif self._page_index == 5 then
        state_machine.excute("packs_scrollview_use_window_show",0,"")
    end
end

function Packs:onEnterTransitionFinish()

end

--初始化包裹
function Packs:onInit( )
    local csbItem = csb.createNode(config_csb.packs.packs)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")
    
    local action = csb.createTimeline(config_csb.packs.packs)
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_open", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        if frame == "window_open_over" then
            
        end
    end)

    local Panel_packs_props = ccui.Helper:seekWidgetByName(root,"Panel_packs_props")
    self.panel = Panel_packs_props
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_back"), nil, 
    {
        terminal_name = "packs_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 全部
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_complete"), nil, 
    {
        terminal_name = "packs_window_manager",     
        next_terminal_name = "packs_show_packs_scrollview_all", 
        current_button_name = "Button_packs_complete",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        index = 1,
    }, nil, 3)

    -- 装备
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_equipment"), nil, 
    {
        terminal_name = "packs_window_manager",     
        next_terminal_name = "packs_show_packs_scrollview_equip", 
        current_button_name = "Button_packs_equipment",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        index = 2,
    }, nil, 3)

    -- 英雄
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_hero"), nil, 
    {
        terminal_name = "packs_window_manager",     
        next_terminal_name = "packs_show_packs_scrollview_hero", 
        current_button_name = "Button_packs_hero",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        index = 3,
    }, nil, 3)

    -- 宝石
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_stone"), nil, 
    {
        terminal_name = "packs_window_manager",     
        next_terminal_name = "packs_show_packs_scrollview_jewelry", 
        current_button_name = "Button_packs_stone",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        index = 4,
    }, nil, 3)

    -- 消耗品
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_packs_consumables"), nil, 
    {
        terminal_name = "packs_window_manager",     
        next_terminal_name = "packs_show_packs_scrollview_use", 
        current_button_name = "Button_packs_consumables",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        index = 5,
    }, nil, 3)

	self:onUpdateDraw()	
end

function Packs:init()
	self:onInit()
    return self
end

--移除状态机
function Packs:onExit()
    state_machine.remove("packs_window_manager")    
    state_machine.remove("packs_window_show")   
    state_machine.remove("packs_window_hide")
    state_machine.remove("packs_show_packs_scrollview_all")
    state_machine.remove("packs_show_packs_scrollview_equip")
    state_machine.remove("packs_show_packs_scrollview_hero")
    state_machine.remove("packs_show_packs_scrollview_jewelry")
    state_machine.remove("packs_show_packs_scrollview_use")
    state_machine.remove("packs_left_prop_draw")
    state_machine.remove("packs_goto_combing")
    state_machine.remove("packs_go_to_short_cut")
    state_machine.remove("packs_goto_inlay")
    state_machine.remove("packs_use_go_to_short_cut")
    state_machine.remove("packs_prop_sell")
    state_machine.remove("packs_prop_use")
    state_machine.remove("packs_prop_reset_ui")
    state_machine.remove("packs_goto_weaponry")
    state_machine.remove("packs_goto_gem")
    state_machine.remove("packs_prop_select_reward_use")
    state_machine.remove("packs_update_page")
end
