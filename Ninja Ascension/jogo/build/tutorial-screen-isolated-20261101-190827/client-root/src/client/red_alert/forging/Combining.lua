-----------------------------
--合成
-----------------------------
Combining = class("CombiningClass", Window)

--打开合成界面
local combining_window_open_terminal = {
    _name = "combining_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(96) == true then
            return
        end 
        local _Window = fwin:find("CombiningClass")
        if nil == _Window then
            fwin:open(Combining:new():init(), fwin._ui)
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

--关闭合成界面
local combining_window_close_terminal = {
    _name = "combining_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CombiningClass"))

        state_machine.excute("main_window_open",0,"")
        state_machine.excute("player_resource_window_show",0,"")   
        state_machine.excute("home_button_for_action_window_show",0,"")  
        state_machine.excute("chat_view_window_show",0,"")
        state_machine.excute("duplicate_title_window_show",0,"") 
        
        -- clear cacher
        cacher.clearWindowCacher()       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(combining_window_open_terminal)
state_machine.add(combining_window_close_terminal)
state_machine.init()

function Combining:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    app.load("client.red_alert.forging.combining.CombiningScrollviewEquip")
    app.load("client.red_alert.forging.combining.CombiningScrollviewHero")
    app.load("client.red_alert.forging.combining.CombiningScrollviewTally") 
    app.load("client.red_alert.notification.push_notification_combining")

    --var
    self.page_index = 1 -- 1 英雄 2 装备 3 兵符
    --右侧列表
    self.scroll_panel = nil
    --合成的类型
    self.combining_id = nil
    --拥有碎片数量
    self.have_number = nil
    --合成需要数量
    self.need_number = nil

    -- Initialize combining state machine.
    local function init_combining_terminal()
        --管理
        local combining_manager_terminal = {
            _name = "combining_manager",
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
        -- 装备
        local combining_change_to_equip_terminal = {
            _name = "combining_change_to_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.page_index = 1
                instance.combining_id = nil
                state_machine.excute("combining_update_draw_left",0,"")
                state_machine.excute("combining_scrollview_equip_un_set_selected",0,"")
                state_machine.excute("combining_scrollview_hero_un_set_selected",0,"")
                state_machine.excute("combining_scrollview_tally_un_set_selected",0,"")                 
                state_machine.excute("combining_scrollview_equip_window_open",0,{instance.scroll_panel})
                state_machine.excute("combining_scrollview_equip_window_show",0,"")
                state_machine.excute("combining_scrollview_hero_window_hide",0,"")
                state_machine.excute("combining_scrollview_tally_window_hide",0,"")                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }         
        -- 英雄
        local combining_change_to_hero_terminal = {
            _name = "combining_change_to_hero",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.page_index = 2
                instance.combining_id = nil
                state_machine.excute("combining_update_draw_left",0,"")
                state_machine.excute("combining_scrollview_equip_un_set_selected",0,"")
                state_machine.excute("combining_scrollview_hero_un_set_selected",0,"")
                state_machine.excute("combining_scrollview_tally_un_set_selected",0,"")                 
                state_machine.excute("combining_scrollview_hero_window_open",0,{instance.scroll_panel})
                state_machine.excute("combining_scrollview_equip_window_hide",0,"")
                state_machine.excute("combining_scrollview_hero_window_show",0,"")
                state_machine.excute("combining_scrollview_tally_window_hide",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 兵符
        local combining_change_to_tally_terminal = {
            _name = "combining_change_to_tally",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.page_index = 3
                instance.combining_id = nil
                state_machine.excute("combining_update_draw_left",0,"")
                state_machine.excute("combining_scrollview_equip_un_set_selected",0,"")
                state_machine.excute("combining_scrollview_hero_un_set_selected",0,"")
                state_machine.excute("combining_scrollview_tally_un_set_selected",0,"")                
                state_machine.excute("combining_scrollview_tally_window_open",0,{instance.scroll_panel})
                state_machine.excute("combining_scrollview_equip_window_hide",0,"")
                state_machine.excute("combining_scrollview_hero_window_hide",0,"")
                state_machine.excute("combining_scrollview_tally_window_show",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 确认合成
        local combining_sure_combining_terminal = {
            _name = "combining_sure_combining",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                --print("===============合成的类型，id",instance.page_index,instance.combining_id)
                state_machine.lock("combining_sure_combining")
                if instance.combining_id == nil then
                    TipDlg.drawTextDailog(red_alert_all_str[7])
                    state_machine.unlock("combining_sure_combining")
                    return
                end
                if instance.have_number < instance.need_number then
                    TipDlg.drawTextDailog(red_alert_all_str[26])
                    state_machine.unlock("combining_sure_combining")
                    return
                end
                local prop = _ED.user_prop[""..instance.combining_id]
                local prop_mould_id = prop.user_prop_template
                local function responseCombiningCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        playEffect(formatMusicFile("effect", 9994))
                        state_machine.excute("combining_open_get_combining_ok",0,prop_mould_id)
                        state_machine.excute("combining_update_all",0,"")
                        state_machine.unlock("combining_sure_combining")
                    else
                        state_machine.unlock("combining_sure_combining")
                    end
                end
                --print("============",instance.combining_id.."\r\n"..(instance.page_index - 1).."\r\n")
                protocol_command.prop_compound.param_list = instance.combining_id.."\r\n"..(instance.page_index - 1).."\r\n".."1"
                NetworkManager:register(protocol_command.prop_compound.code, nil, nil, nil, instance, responseCombiningCallback, false, nil) 

                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 更新左侧
        local combining_update_draw_left_terminal = {
            _name = "combining_update_draw_left",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params == nil or params == "" then
                    instance.combining_id = nil
                else
                    instance.combining_id = params.user_prop_id
                end
                instance:onUpdateLeft(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新 所有 或者 单个数量
        local combining_update_all_terminal = {
            _name = "combining_update_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("combining_update_draw_left",0,"")
                if instance.page_index == 1 then
                    state_machine.excute("combining_scrollview_equip_update_all",0,"")
                elseif instance.page_index == 2 then
                    state_machine.excute("combining_scrollview_hero_update_all",0,"")
                elseif instance.page_index == 3 then
                    state_machine.excute("combining_scrollview_tally_update_all",0,"")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开获得界面
        local combining_open_get_combining_ok_terminal = {
            _name = "combining_open_get_combining_ok",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:openRewardWindow(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(combining_manager_terminal)    
        state_machine.add(combining_change_to_equip_terminal)
        state_machine.add(combining_change_to_hero_terminal)
        state_machine.add(combining_change_to_tally_terminal) 
        state_machine.add(combining_sure_combining_terminal)
        state_machine.add(combining_update_draw_left_terminal)
        state_machine.add(combining_update_all_terminal)
        state_machine.add(combining_open_get_combining_ok_terminal)
        state_machine.init()
    end
    
    -- call func init combining state machine.
    init_combining_terminal()
end

--打开奖励获得界面
function Combining:openRewardWindow(prop_mould_id)
    if self.page_index == 1 then
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
    elseif self.page_index == 2 then
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

--第一次打开显示装备列表
function Combining:onUpdateDraw()
    local root = self.roots[1]
    state_machine.excute("combining_manager",0,{
        _datas = 
            {
                terminal_name = "combining_manager",     
                next_terminal_name = "combining_change_to_equip", 
                current_button_name = "Button_equipment_synthesis",   
                but_image = "",     
                terminal_state = 0, 
                touch_scale = true,
                touch_scale_xy = 0.95, 
            }
        })
end

--刷新
function Combining:onUpdateLeft(_prop)
    local root = self.roots[1]
    local Text_description = ccui.Helper:seekWidgetByName(root,"Text_description")
    Text_description:setVisible(false)
    local Panel_synthesis_information = ccui.Helper:seekWidgetByName(root,"Panel_synthesis_information")
    Panel_synthesis_information:setVisible(false)

    local Panel_synthesis_icon = ccui.Helper:seekWidgetByName(root,"Panel_synthesis_icon") -- 合成后的icon
    Panel_synthesis_icon:removeAllChildren(true)
    local Panel_synthesis_icon_name = ccui.Helper:seekWidgetByName(root,"Panel_synthesis_icon_name")--名字
    local Text_synthesis_number = ccui.Helper:seekWidgetByName(root,"Text_synthesis_number")--所需数量
    local Text_synthesis_number_h = ccui.Helper:seekWidgetByName(root,"Text_synthesis_number_h")--所拥有数量
    local Panel_synthesis_fragment_icon = ccui.Helper:seekWidgetByName(root,"Panel_synthesis_fragment_icon")-- 碎片icon
    Panel_synthesis_fragment_icon:removeAllChildren(true)

    if self.combining_id == nil then
        Text_description:setVisible(true)
        Text_description:setString(red_alert_all_str[6]..combining_str[self.page_index])
    else
        Panel_synthesis_information:setVisible(true)
        --碎片
        local data = 
        {
            prop_data = 
            {
               item_value = _prop.prop_number,
               prop_type = 6,
               prop_item = _prop.user_prop_template,
            },
            prop = _prop
        }
        local cell = state_machine.excute("all_resource_create_cell",0,{3,data.prop_data,data.prop,8,0})
        Panel_synthesis_fragment_icon:addChild(cell)

        local prop_mould_id = _prop.user_prop_template
        local equipment_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], prop_mould_id, prop_mould.change_of_equipment))  --合成后所出现的装备
        local ship_mould_id = zstring.tonumber(dms.int(dms["prop_mould"],prop_mould_id, prop_mould.use_of_ship))                --合成后所出现的英雄
        local prop_quality = zstring.tonumber(dms.int(dms["prop_mould"],prop_mould_id, prop_mould.prop_quality))                --品质     
        local name = ""
        local need_number = 0

        --合成后
        local _data = {}
        if equipment_mould_id > 0 then
            name = dms.string(dms["equipment_mould"],equipment_mould_id,equipment_mould.equipment_name) --装备名称
            need_number = dms.int(dms["prop_mould"],prop_mould_id,prop_mould.split_or_merge_count)      --需要数量
            _data = 
            {
               item_value = 1,
               prop_type = 7,
               prop_item = equipment_mould_id,
            }
        elseif ship_mould_id > 0 then
            name = dms.string(dms["ship_mould"],ship_mould_id,ship_mould.captain_name)                  --英雄名称
            need_number = dms.int(dms["prop_mould"],prop_mould_id,prop_mould.split_or_merge_count)      --需要数量
            _data = 
            {
               item_value = 1,
               prop_type = 13,
               prop_item = ship_mould_id,
            }            
        end
        self.have_number = tonumber(_prop.prop_number)
        self.need_number = need_number        
        Panel_synthesis_icon_name:setString(name)
        Panel_synthesis_icon_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[prop_quality+1][1],tipStringInfo_quality_color_Type[prop_quality+1][2],tipStringInfo_quality_color_Type[prop_quality+1][3]))
        Text_synthesis_number:setString("/ "..need_number)
        Text_synthesis_number_h:setString(_prop.prop_number)
        if tonumber(_prop.prop_number) >= tonumber(need_number) then 
            Text_synthesis_number_h:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
        else
            Text_synthesis_number_h:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
        end
        local _cell = state_machine.excute("all_resource_create_cell",0,{6,_data,_data,8,0})
        Panel_synthesis_icon:addChild(_cell)
        -- print("===========================",name,need_number)
        -- debug.print_r(_prop)
    end
end

--播放动画
function Combining:playActions()
    local root = self.roots[1]
    local Panel_effice = ccui.Helper:seekWidgetByName(root,"Panel_effice")
    Panel_effice:removeAllChildren(true)
    local jsonPath = "images/ui/effice/effice_forging/effice_forging.json"
    local atlasPath = "images/ui/effice/effice_forging/effice_forging.atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_event", true, nil)
    animation:setPosition(cc.p(Panel_effice:getContentSize().width/2,Panel_effice:getContentSize().height/2))
    Panel_effice:addChild(animation)
end

--初始化界面
function Combining:onInit( )
    local csbItem = csb.createNode(config_csb.forging.combining)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    --阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")

    -- 一键合成
    local Button_synthesis_one_step = ccui.Helper:seekWidgetByName(root,"Button_synthesis_one_step")
    if Button_synthesis_one_step ~= nil then
        Button_synthesis_one_step:setVisible(false)
    end
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_synthesis_back"), nil, 
    {
        terminal_name = "combining_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --英雄
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_synthesis"), nil, 
    {
        terminal_name = "combining_manager",     
        next_terminal_name = "combining_change_to_hero", 
        current_button_name = "Button_hero_synthesis",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3) 
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_combining_hero",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_hero_synthesis"),
        _invoke = nil,
        _interval = 0.5,})   
    
    --装备
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_equipment_synthesis"), nil, 
    {
        terminal_name = "combining_manager",     
        next_terminal_name = "combining_change_to_equip", 
        current_button_name = "Button_equipment_synthesis",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3) 
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_combining_equipment",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_equipment_synthesis"),
        _invoke = nil,
        _interval = 0.5,})   

    --兵符
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_easily_synthesis"), nil, 
    {
        terminal_name = "combining_manager",     
        next_terminal_name = "combining_change_to_tally", 
        current_button_name = "Button_easily_synthesis",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3) 

    -- 合成
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_synthesis"), nil, 
    {
        terminal_name = "combining_sure_combining",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    local Panel_synthesis = ccui.Helper:seekWidgetByName(root,"Panel_synthesis")
    self.scroll_panel = Panel_synthesis
    self:onUpdateDraw() 
end

function Combining:init()
    self:onInit()
    self:playActions()
    return self
end

--移除状态机
function Combining:onExit()
    state_machine.remove("combining_manager")  
    state_machine.remove("combining_change_to_equip")  
    state_machine.remove("combining_change_to_hero")
    state_machine.remove("combining_change_to_tally")
    state_machine.remove("combining_sure_combining")
    state_machine.remove("combining_update_draw_left") 
    state_machine.remove("combining_update_all")
    state_machine.remove("combining_open_get_combining_ok")   
end
