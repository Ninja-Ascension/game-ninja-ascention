--------------------------------------------------------------------------------------------------------------
--  说明：龙虎门军团主界面
--------------------------------------------------------------------------------------------------------------
if __lua_project_id == __lua_project_gragon_tiger_gate
or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
then

UnionTigerGate = class("UnionTigerGateClass", Window)

--打开界面
local union_open_terminal = {
    _name = "Union_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local UnionWindow = fwin:find("UnionTigerGateClass")
        if UnionWindow ~= nil and UnionWindow:isVisible() == true then
            return true
        end
        state_machine.excute("union_create_close", 0, "")
        state_machine.excute("union_join_close", 0, "")
        fwin:open(UnionTigerGate:new():init(params),fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭界面
local union_close_terminal = {
    _name = "Union_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local UnionWindow = fwin:find("UnionTigerGateClass")
        if UnionWindow ~= nil then
            fwin:close(UnionWindow)
        end
        fwin:cleanView(fwin._view)
        if fwin:find("MenuClass") == nil then
            fwin:open(Menu:new(), fwin._taskbar)
        end
        if fwin:find("HomeClass") == nil then
            state_machine.excute("menu_manager", 0, 
                {
                    _datas = {
                        terminal_name = "menu_manager",     
                        next_terminal_name = "menu_show_home_page", 
                        current_button_name = "Button_home",
                        but_image = "Image_home",       
                        terminal_state = 0, 
                        isPressedActionEnabled = true
                    }
                }
            )
        end
        state_machine.excute("menu_back_home_page", 0, "")
        state_machine.excute("menu_clean_page_state", 0, "")
        if fwin:find("smUnionUserTopInfoClass") ~= nil then
            fwin:close(fwin:find("smUnionUserTopInfoClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--退出或者被踢出清空数据
local union_the_meeting_place_clean_all_data_terminal = {
    _name = "union_the_meeting_place_clean_all_data",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        _ED.union.union_examine_list_sum = 0
        _ED.union.union_examine_list_info = {}
        _ED.union.union_find_list_sum = 0                  
        _ED.union.union_find_list_info = {}
        _ED.union.user_union_info = {}
        _ED.union.union_member_list_sum = 0
        _ED.union.union_member_list_info = {}
        _ED.union.union_info = {}
        _ED.union.union_message_number = nil
        _ED.union.union_message_info_list = {}
        local UnionWindow = fwin:find("UnionTigerGateClass")
        if UnionWindow ~= nil then
            state_machine.excute("Union_close", 0, nil)
        end 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_open_terminal)
state_machine.add(union_close_terminal)
state_machine.add(union_the_meeting_place_clean_all_data_terminal)
state_machine.init()

function UnionTigerGate:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions={}
    self.tickTime = 0
    app.load("client.l_digital.union.meeting.UnionTheMeetingPlace")
    app.load("client.l_digital.union.meeting.SmUnionHallNoticeWindow")
    app.load("client.l_digital.union.meeting.SmUnionResearchInstitute")
    app.load("client.l_digital.union.meeting.SmUnionEnergyHouse")
    app.load("client.l_digital.union.luck.SmUnionSlotMachine")
    app.load("client.l_digital.union.duplicate.SmUnionDuplicate")
    app.load("client.l_digital.union.redEnvelopes.SmUnionRedEnvelopes")
    app.load("client.l_digital.union.player.smUnionUserTopInfo")
    app.load("client.l_digital.union.unionFighting.UnionFightingMain")
    app.load("client.l_digital.union.legionAssistance.LegionAssistance")
    local function init_Union_terminal()
        --查看帮助信息
        local union_look_help_information_terminal = {
            _name = "union_look_help_information",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.refinery.TreasureInfo")
                local cell = TreasureInfo:new()
                cell:init(5)
                fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新界面信息
        local union_refresh_info_terminal = {
            _name = "union_refresh_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --返回主页
        local union_return_home_terminal = {
            _name = "union_return_home",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("Union_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --点击军团商店
        local union_go_to_shop_terminal = {
            _name = "union_go_to_shop",
            _init = function (terminal)
                app.load("client.l_digital.shop.SmShopPropBuyListView")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_lock_state_machine", 0, nil)
                local server_time = _ED.system_time + (os.time() - _ED.native_time) - _ED.GTM_Time
                if _ED.union.user_union_info.union_last_enter_time - server_time > 0 then
                    TipDlg.drawTextDailog(_new_interface_text[195])
                    state_machine.excute("union_unlock_state_machine", 0, nil)
                    return
                end

                -- state_machine.excute("menu_manager","0",{_datas = {
                --         next_terminal_name = "menu_show_shop", 
                --         current_button_name = "Button_shop_0",
                --         but_image = "Image_shop",   
                --         terminal_state = 0,
                --         shop_type = "shop",
                --         shop_page = 5,
                --     }}
                -- )

                state_machine.excute("menu_show_shop", 0, {_datas = {shop_type = "shop", shop_page = 5}})

                -- local UnionWindow = fwin:find("UnionTigerGateClass")
                -- if UnionWindow ~= nil then
                --     fwin:close(UnionWindow)
                -- end

                -- local cell = ShopPropBuyListView:new()
                -- cell:init(5)
                -- fwin:open(cell, fwin._ui)
                -- TipDlg.drawTextDailog(_function_unopened_tip_string)
                -- state_machine.excute("union_shop_open", 0, 
                --  {
                --      _datas = {
                --          terminal_name = "union_shop_select_page",   
                --          next_terminal_name = "union_shop_to_prop_page",         
                --          current_button_name = "Button_32",      
                --          but_image = "Button_32",    
                --          terminal_state = 0, 
                --          isPressedActionEnabled = true
                --      }
                --  }
                -- )
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --点击封坛祭天
        local union_go_to_heaven_terminal = {
            _name = "union_go_to_heaven",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    app.load("client.l_digital.union.heaven.UnionHeaven")
                else
                    app.load("client.union.heaven.UnionHeaven")
                end
                state_machine.excute("union_heaven_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --点击军团副本
        local union_go_to_duplicate_terminal = {
            _name = "union_go_to_duplicate",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_lock_state_machine", 0, nil)
                -- local function responseCallback( response )
                -- end
                -- if _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
                --     protocol_command.unino_map_refush.param_list = _ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number.."\r\n0"
                --     NetworkManager:register(protocol_command.unino_map_refush.code, _ED.union_fight_url, nil, nil, nil, responseCallback, false, nil)
                -- end
                local server_time = _ED.system_time + (os.time() - _ED.native_time) - _ED.GTM_Time
                if _ED.union.user_union_info.union_last_enter_time - server_time > 0 then
                    TipDlg.drawTextDailog(_new_interface_text[195])
                    state_machine.excute("union_unlock_state_machine", 0, nil)
                    return
                end
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("sm_union_duplicate_open", 0, nil)
                        end 
                    end
                end
                NetworkManager:register(protocol_command.union_copy_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                -- if tonumber(_ED.union_fight_state) == 3 and _ED.union_fight_is_join == true then
                --     app.load("client.l_digital.union.unionFighting.UnionFightingMain")
                --     state_machine.excute("union_fighting_main_open", 0, nil)
                -- else
                --     app.load("client.l_digital.union.unionFighting.UnionFightJoin")
                --     state_machine.excute("union_fighting_join_open", 0, nil)
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --点击军团排行
        local union_go_to_rank_terminal = {
            _name = "union_go_to_rank",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_lock_state_machine", 0, nil)
                app.load("client.l_digital.system.SmRankingMainInterface")

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("sm_ranking_main_interface_open", 0, 5)
                        end
                    end
                end

                -- 只查找1个数据
                local m_type = 7
                protocol_command.order_get_info.param_list = m_type.."\r\n".."1".."\r\n".."1"
                NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --切换主界面列表容器状态
        local union_change_right_list_view_state_terminal = {
            _name = "union_change_right_list_view_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- local root = instance.roots[1]
                -- if root ~= nil then
                --     ccui.Helper:seekWidgetByName(root, "ListView_city"):setVisible(params)
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --公会大厅
        local union_change_right_hall_state_terminal = {
            _name = "union_change_right_hall_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_lock_state_machine", 0, nil)
                state_machine.excute("union_the_meeting_place_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击修改军团宣言
        local union_change_meeting_place_information_change_declaration_terminal = {
            _name = "union_change_meeting_place_information_change_declaration",
            _init = function (terminal)
                app.load("client.l_digital.cells.union.union_the_meeting_place_notice_cell")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- state_machine.lock("union_go_to_shop")
                -- state_machine.lock("union_go_to_rank")
                -- state_machine.lock("sm_union_research_institute_open")
                -- state_machine.lock("union_change_update_open_energy_house")
                -- state_machine.lock("sm_union_slot_machine_open")
                -- state_machine.lock("sm_union_red_envelopes_open")
                -- state_machine.lock("union_change_open_adventure")
                -- state_machine.lock("union_go_to_duplicate")
                -- state_machine.lock("union_change_open_guild_warfare")
                -- state_machine.lock("union_change_right_hall_state")
                -- state_machine.lock("union_change_meeting_place_information_change_declaration")
                if tonumber(_ED.union.user_union_info.union_post) == 1 then
                    state_machine.excute("union_the_meeting_place_notice_open", 0, 1)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 修改军团宣言刷新
        local union_change_update_watchword_draw_home_terminal = {
            _name = "union_change_update_watchword_draw_home",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Text_notice = ccui.Helper:seekWidgetByName(instance.roots[1], "Text_notice")
                Text_notice:setString(_ED.union.union_info.watchword)
                Text_notice:removeAllChildren(true)
                local _richText2 = ccui.RichText:create()
                _richText2:ignoreContentAdaptWithSize(false)

                local richTextWidth = Text_notice:getContentSize().width-Text_notice:getFontSize()
                if richTextWidth == 0 then
                    richTextWidth = Text_notice:getFontSize() * 6
                end

                _richText2:setContentSize(cc.size(richTextWidth, 0))
                _richText2:setAnchorPoint(cc.p(0, 0))
                local strs = zstring.exchangeFrom(smWidthSingle(_ED.union.union_info.watchword,Text_notice:getFontSize(),Text_notice:getContentSize().width))
                local corles = cc.c3b(0, 0, 0)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    corles = cc.c3b(0, 0, 0)
                else
                    corles = cc.c3b(255, 255, 255)
                end
                local rt, count, text = draw.richTextCollectionMethod(_richText2, 
                strs, 
                corles,
                corles,
                0, 
                0, 
                Text_notice:getFontName(), 
                Text_notice:getFontSize(),
                chat_rich_text_color)

                _richText2:formatTextExt()
                local rsize = _richText2:getContentSize()
                _richText2:setPositionY(Text_notice:getContentSize().height-(Text_notice:getContentSize().height-rsize.height)/2)
                _richText2:setPositionX(0)
                Text_notice:addChild(_richText2)
                Text_notice:setString("")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 修改军团宣言刷新
        local union_change_update_open_energy_house_terminal = {
            _name = "union_change_update_open_energy_house",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_lock_state_machine", 0, nil)
                local server_time = _ED.system_time + (os.time() - _ED.native_time) - _ED.GTM_Time
                if _ED.union.user_union_info.union_last_enter_time - server_time > 0 then
                    state_machine.excute("union_unlock_state_machine", 0, nil)
                    TipDlg.drawTextDailog(_new_interface_text[195])
                    return
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("sm_union_energy_house_open", 0, 1)
                        end
                    end
                end
                NetworkManager:register(protocol_command.union_ship_train_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        

        -- 工会大冒险
        local union_change_open_adventure_terminal = {
            _name = "union_change_open_adventure",
            _init = function (terminal)
                app.load("client.l_digital.union.adventure.SmUnionAdventure")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_lock_state_machine", 0, nil)
                local server_time = _ED.system_time + (os.time() - _ED.native_time) - _ED.GTM_Time
                if _ED.union.user_union_info.union_last_enter_time - server_time > 0 then
                    state_machine.excute("union_unlock_state_machine", 0, nil)
                    TipDlg.drawTextDailog(_new_interface_text[195])
                    return
                end
                if fwin:find("SmUnionAdventureClass") ~= nil then
                    state_machine.excute("sm_union_adventure_close", 0, 1)
                end
                state_machine.excute("sm_union_adventure_open", 0, 1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 工会战
        local union_change_open_guild_warfare_terminal = {
            _name = "union_change_open_guild_warfare",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_lock_state_machine", 0, nil)
                state_machine.excute("union_fighting_main_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 工会援助
        local union_member_help_terminal = {
            _name = "union_member_help",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("union_lock_state_machine", 0, nil)
                -- state_machine.excute("legion_assistance_window_open", 0, nil)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            -- open ui
                            state_machine.excute("legion_assistance_window_open", 0, nil)
                        else
                            state_machine.excute("union_unlock_state_machine", 0, nil)
                        end
                    else
                        state_machine.excute("union_unlock_state_machine", 0, nil)
                    end
                end
                NetworkManager:register(protocol_command.union_assistance_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 锁住公会状态机
        local union_lock_state_machine_terminal = {
            _name = "union_lock_state_machine",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- print("锁住公会状态机")
                state_machine.lock("union_go_to_shop")
                state_machine.lock("union_go_to_rank")
                state_machine.lock("sm_union_research_institute_open")
                state_machine.lock("union_change_update_open_energy_house")
                state_machine.lock("sm_union_slot_machine_open")
                state_machine.lock("sm_union_red_envelopes_open")
                state_machine.lock("union_change_open_adventure")
                state_machine.lock("union_go_to_duplicate")
                state_machine.lock("union_change_open_guild_warfare")
                state_machine.lock("union_change_right_hall_state")
                state_machine.lock("union_change_meeting_place_information_change_declaration")
                state_machine.lock("union_member_help")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 解锁公会状态机
        local union_unlock_state_machine_terminal = {
            _name = "union_unlock_state_machine",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- print("解锁公会状态机")
                state_machine.unlock("union_go_to_shop")
                state_machine.unlock("union_go_to_rank")
                state_machine.unlock("sm_union_research_institute_open")
                state_machine.unlock("union_change_update_open_energy_house")
                state_machine.unlock("sm_union_slot_machine_open")
                state_machine.unlock("sm_union_red_envelopes_open")
                state_machine.unlock("union_change_open_adventure")
                state_machine.unlock("union_go_to_duplicate")
                state_machine.unlock("union_change_open_guild_warfare")
                state_machine.unlock("union_change_right_hall_state")
                state_machine.unlock("union_change_meeting_place_information_change_declaration")
                state_machine.unlock("union_member_help")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_look_help_information_terminal)
        state_machine.add(union_refresh_info_terminal)
        state_machine.add(union_return_home_terminal)
        state_machine.add(union_go_to_shop_terminal)
        state_machine.add(union_go_to_heaven_terminal)
        state_machine.add(union_go_to_duplicate_terminal)
        state_machine.add(union_go_to_rank_terminal)
        state_machine.add(union_change_right_list_view_state_terminal)
        state_machine.add(union_change_right_hall_state_terminal)
        state_machine.add(union_change_meeting_place_information_change_declaration_terminal)
        state_machine.add(union_change_update_watchword_draw_home_terminal)
        state_machine.add(union_change_update_open_energy_house_terminal)
        state_machine.add(union_change_open_adventure_terminal)
        state_machine.add(union_change_open_guild_warfare_terminal)
        state_machine.add(union_member_help_terminal)

        state_machine.add(union_lock_state_machine_terminal)
        state_machine.add(union_unlock_state_machine_terminal)

        state_machine.init()
    end
    
    init_Union_terminal()
end

-- function UnionTigerGate:onUpdate( dt )
--     if self.roots == nil or self.tickTime == nil then 
--         return
--     end
--     self.tickTime = self.tickTime - dt
--     if self.tickTime <= 0 then
--         self.tickTime = 2
--         local function responseCallback( response )
--         end
--         NetworkManager:register(protocol_command.refush_cache_message.code, nil, nil, nil, nil, responseCallback, false, nil)
--     end
-- end

--[[比较两个时间，返回相差多少时间]]
function timediff(long_time,short_time)
    local n_short_time,n_long_time,carry,diff = os.date('*t',short_time),os.date('*t',long_time),false,{}
    local colMax = {60,60,24,os.date('*t',os.time{year=n_short_time.year,month=n_short_time.month+1,day=0}).day,12,0}
    n_long_time.hour = n_long_time.hour - (n_long_time.isdst and 1 or 0) + (n_short_time.isdst and 1 or 0) -- handle dst
    for i,v in ipairs({'sec','min','hour','day','month','year'}) do
        diff[v] = n_long_time[v] - n_short_time[v] + (carry and -1 or 0)
        carry = diff[v] < 0
        if carry then
            diff[v] = diff[v] + colMax[i]
        end
    end
    return diff
end

function UnionTigerGate:updateDraw()
    local root = self.roots[1]
    if root == nil then
        return
    end
    -- debug.print_r(_ED.union)
    -- 空的状态机
    state_machine.excute("union_the_meeting_place_refresh", 0, nil)

    local Text_notice = ccui.Helper:seekWidgetByName(root, "Text_notice")
    Text_notice:setString(_ED.union.union_info.watchword)
    Text_notice:removeAllChildren(true)
    local _richText2 = ccui.RichText:create()
    _richText2:ignoreContentAdaptWithSize(false)

    local richTextWidth = Text_notice:getContentSize().width-Text_notice:getFontSize()
    if richTextWidth == 0 then
        richTextWidth = Text_notice:getFontSize() * 6
    end
                
    _richText2:setContentSize(cc.size(richTextWidth, 0))
    _richText2:setAnchorPoint(cc.p(0, 0))
    local strs = zstring.exchangeFrom(smWidthSingle(_ED.union.union_info.watchword,Text_notice:getFontSize(),Text_notice:getContentSize().width))
    local corles = cc.c3b(0, 0, 0)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        corles = cc.c3b(0, 0, 0)
    else
        corles = cc.c3b(255, 255, 255)
    end
    local rt, count, text = draw.richTextCollectionMethod(_richText2, 
    strs, 
    corles,
    corles,
    0, 
    0, 
    Text_notice:getFontName(), 
    Text_notice:getFontSize(),
    chat_rich_text_color)

    _richText2:formatTextExt()
    local rsize = _richText2:getContentSize()
    _richText2:setPositionY(Text_notice:getContentSize().height-(Text_notice:getContentSize().height-rsize.height)/2)
    _richText2:setPositionX(0)
    Text_notice:addChild(_richText2)
    Text_notice:setString("")

    local current = _ED.system_time + (os.time() - _ED.native_time)
    local union_open_announcement_tip = cc.UserDefault:getInstance():getStringForKey(getKey("union_open_announcement_tip"))
    if union_open_announcement_tip == nil or union_open_announcement_tip == "" then
        self:runAction(cc.Sequence:create({cc.DelayTime:create(0.2), cc.CallFunc:create(function ( sender )
            state_machine.excute("sm_union_hall_notice_window_open", 0, nil)
        end)}))
        cc.UserDefault:getInstance():setStringForKey(getKey("union_open_announcement_tip"), ""..current)
    else
        local isOpen = false
        local earlyMorning = timediff(current,union_open_announcement_tip)
        
        if zstring.tonumber(earlyMorning.year) > 0 or zstring.tonumber(earlyMorning.month) > 0 or zstring.tonumber(earlyMorning.day) > 0 then
            --如果超过1天
            isOpen = true 
        else
            --不超过1天
            local nodeTime = zstring.split(dms.string(dms["union_config"], 65, union_config.param), ":")
            local temp = os.date("*t", zstring.tonumber(union_open_announcement_tip))
            local m_hour    = tonumber(string.format("%02d", temp.hour))
            local m_min     = tonumber(string.format("%02d", temp.min))
            local m_sec     = tonumber(string.format("%02d", temp.sec))

            local newTemp = os.date("*t", zstring.tonumber(current))
            local n_hour    = tonumber(string.format("%02d", newTemp.hour))
            local n_min     = tonumber(string.format("%02d", newTemp.min))
            local n_sec     = tonumber(string.format("%02d", newTemp.sec))

            if m_hour > zstring.tonumber(nodeTime[1]) 
                or (m_hour == zstring.tonumber(nodeTime[1]) and m_min > zstring.tonumber(nodeTime[2]))
                or (m_hour == zstring.tonumber(nodeTime[1]) and m_min == zstring.tonumber(nodeTime[2]) and m_sec > zstring.tonumber(nodeTime[3]))
                then
                --如果记录时间大于节点时间就说明都不做
            else
                if n_hour > zstring.tonumber(nodeTime[1]) 
                    or (n_hour == zstring.tonumber(nodeTime[1]) and n_min > zstring.tonumber(nodeTime[2]))
                    or (n_hour == zstring.tonumber(nodeTime[1]) and n_min == zstring.tonumber(nodeTime[2]) and n_sec > zstring.tonumber(nodeTime[3]))
                    then
                    isOpen = true 
                end
            end
        end
        if isOpen == true then
            self:runAction(cc.Sequence:create({cc.DelayTime:create(0.2), cc.CallFunc:create(function ( sender )
                state_machine.excute("sm_union_hall_notice_window_open", 0, nil)
            end)}))
            cc.UserDefault:getInstance():setStringForKey(getKey("union_open_announcement_tip"), ""..current)
        end
        -- --判断凌晨的差距时间
        -- local earlyMorning = 23*3600+59*60+59
        -- local temp = os.date("*t", zstring.tonumber(union_open_announcement_tip))
        -- local m_hour    = tonumber(string.format("%02d", temp.hour))
        -- local m_min     = tonumber(string.format("%02d", temp.min))
        -- local m_sec     = tonumber(string.format("%02d", temp.sec))
        -- earlyMorning = earlyMorning - (m_hour*3600+m_min*60+m_sec)
        -- if earlyMorning <= 0 then
        --     self:runAction(cc.Sequence:create({cc.DelayTime:create(0.2), cc.CallFunc:create(function ( sender )
        --         state_machine.excute("sm_union_hall_notice_window_open", 0, nil)
        --     end)}))
        --     cc.UserDefault:getInstance():setStringForKey(getKey("union_open_announcement_tip"), ""..current)
        -- end
    end
    cc.UserDefault:getInstance():flush()
    
    local Panel_dh_1 = ccui.Helper:seekWidgetByName(root, "Panel_dh_1")
    if Panel_dh_1 ~= nil then
        Panel_dh_1:removeAllChildren(true)
        self:runAction(cc.Sequence:create({cc.DelayTime:create(2.2), cc.CallFunc:create(function ( sender )
            local jsonFile = "sprite/sprite_yanjiuyuan.json"
            local atlasFile = "sprite/sprite_yanjiuyuan.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            animation.animationNameList = {"animation"}
            sp.initArmature(animation, false)
            animation:playWithIndex(1)
            Panel_dh_1:addChild(animation)
        end)}))
    end

    local Panel_dh_2 = ccui.Helper:seekWidgetByName(root, "Panel_dh_2")
    if Panel_dh_2 ~= nil then
        Panel_dh_2:removeAllChildren(true)
        self:runAction(cc.Sequence:create({cc.DelayTime:create(0.6), cc.CallFunc:create(function ( sender )
            local jsonFile2 = "sprite/sprite_niudanji.json"
            local atlasFile2 = "sprite/sprite_niudanji.atlas"
            local animation2 = sp.spine(jsonFile2, atlasFile2, 1, 0, "animation", true, nil)
            animation2.animationNameList = {"animation"}
            sp.initArmature(animation2, false)
            animation2:playWithIndex(1)
            Panel_dh_2:addChild(animation2)
        end)}))
    end

    local Panel_dh_3 = ccui.Helper:seekWidgetByName(root, "Panel_dh_3")
    if Panel_dh_3 ~= nil then
        Panel_dh_3:removeAllChildren(true)
        self:runAction(cc.Sequence:create({cc.DelayTime:create(0.4), cc.CallFunc:create(function ( sender )
            local jsonFile3 = "sprite/sprite_gonghuifb.json"
            local atlasFile3 = "sprite/sprite_gonghuifb.atlas"
            local animation3 = sp.spine(jsonFile3, atlasFile3, 1, 0, nil, true, nil)
            animation3.animationNameList = {"animation"}
            sp.initArmature(animation3, false)
            animation3:playWithIndex(0)
            Panel_dh_3:addChild(animation3)
        end)}))
    end

    local Panel_dh_4 = ccui.Helper:seekWidgetByName(root, "Panel_dh_4")
    if Panel_dh_4 ~= nil then
        Panel_dh_4:removeAllChildren(true)
        self:runAction(cc.Sequence:create({cc.DelayTime:create(0.2), cc.CallFunc:create(function ( sender )
            local jsonFile4 = "sprite/sprite_gonghuizhan.json"
            local atlasFile4 = "sprite/sprite_gonghuizhan.atlas"
            local animation4 = sp.spine(jsonFile4, atlasFile4, 1, 0, nil, true, nil)
            animation4.animationNameList = {"animation"}
            sp.initArmature(animation4, false)
            animation4:playWithIndex(0)
            Panel_dh_4:addChild(animation4)
        end)}))
    end

    local Panel_dh_5 = ccui.Helper:seekWidgetByName(root, "Panel_dh_5")
    if Panel_dh_5 ~= nil then
        Panel_dh_5:removeAllChildren(true)
        self:runAction(cc.Sequence:create({cc.DelayTime:create(0.8), cc.CallFunc:create(function ( sender )
            local jsonFile5 = "sprite/sprite_damaoxian.json"
            local atlasFile5 = "sprite/sprite_damaoxian.atlas"
            local animation5 = sp.spine(jsonFile5, atlasFile5, 1, 0, nil, true, nil)
            animation5.animationNameList = {"animation"}
            sp.initArmature(animation5, false)
            animation5:playWithIndex(0)
            Panel_dh_5:addChild(animation5)
        end)}))
    end

    local Panel_dh_6 = ccui.Helper:seekWidgetByName(root, "Panel_dh_6")
    if Panel_dh_6 ~= nil then
        Panel_dh_6:removeAllChildren(true)
        self:runAction(cc.Sequence:create({cc.DelayTime:create(1), cc.CallFunc:create(function ( sender )
            local jsonFile6 = "sprite/spirte_103902.json"
            local atlasFile6 = "sprite/spirte_103902.atlas"
            local animation6 = sp.spine(jsonFile6, atlasFile6, 1, 0, nil, true, nil)
            animation6.animationNameList = spineAnimations
            if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                animation6.animationNameList = {"animation"}
            end
            sp.initArmature(animation6, false)
            animation6:playWithIndex(0)
            Panel_dh_6:addChild(animation6)
        end)}))
    end

    local Panel_dh_7 = ccui.Helper:seekWidgetByName(root, "Panel_dh_7")
    if Panel_dh_7 ~= nil then
        Panel_dh_7:removeAllChildren(true)
        self:runAction(cc.Sequence:create({cc.DelayTime:create(1.2), cc.CallFunc:create(function ( sender )
            local jsonFile7 = "sprite/sprite_gonghuihongbao.json"
            local atlasFile7 = "sprite/sprite_gonghuihongbao.atlas"
            local animation7 = sp.spine(jsonFile7, atlasFile7, 1, 0, nil, true, nil)
            animation7.animationNameList = {"animation"}
            sp.initArmature(animation7, false)
            animation7:playWithIndex(0)
            Panel_dh_7:addChild(animation7)
        end)}))
    end

    local Panel_dh_8 = ccui.Helper:seekWidgetByName(root, "Panel_dh_8")
    if Panel_dh_8 ~= nil then
        Panel_dh_8:removeAllChildren(true)
        self:runAction(cc.Sequence:create({cc.DelayTime:create(1.8), cc.CallFunc:create(function ( sender )
            local jsonFile8 = "sprite/sprite_gonghuishop.json"
            local atlasFile8 = "sprite/sprite_gonghuishop.atlas"
            local animation8 = sp.spine(jsonFile8, atlasFile8, 1, 0, nil, true, nil)
            animation8.animationNameList = {"animation"}
            sp.initArmature(animation8, false)
            animation8:playWithIndex(0)
            Panel_dh_8:addChild(animation8)
        end)}))
    end

    local Panel_dh_9 = ccui.Helper:seekWidgetByName(root, "Panel_dh_9")
    if Panel_dh_9 ~= nil then
        Panel_dh_9:removeAllChildren(true)
        self:runAction(cc.Sequence:create({cc.DelayTime:create(1.6), cc.CallFunc:create(function ( sender )
            local jsonFile9 = "sprite/sprite_gonggaoban.json"
            local atlasFile9 = "sprite/sprite_gonggaoban.atlas"
            local animation9 = sp.spine(jsonFile9, atlasFile9, 1, 0, nil, true, nil)
            animation9.animationNameList = {"animation"}
            sp.initArmature(animation9, false)
            animation9:playWithIndex(0)
            Panel_dh_9:addChild(animation9)
        end)}))
    end

        local Panel_dh_10 = ccui.Helper:seekWidgetByName(root, "Panel_dh_10")
        if Panel_dh_10 ~= nil then
            Panel_dh_10:removeAllChildren(true)
            self:runAction(cc.Sequence:create({cc.DelayTime:create(2), cc.CallFunc:create(function ( sender )
            local jsonFile10 = "sprite/sprite_nengliangwu.json"
            local atlasFile10 = "sprite/sprite_nengliangwu.atlas"
            local animation10 = sp.spine(jsonFile10, atlasFile10, 1, 0, nil, true, nil)
            animation10.animationNameList = {"animation"}
            sp.initArmature(animation10, false)
            animation10:playWithIndex(0)
            Panel_dh_10:addChild(animation10)
        end)}))
    end

    local Panel_dh_11 = ccui.Helper:seekWidgetByName(root, "Panel_dh_11")
    if Panel_dh_11 ~= nil then
        Panel_dh_11:removeAllChildren(true)
        self:runAction(cc.Sequence:create({cc.DelayTime:create(1.4), cc.CallFunc:create(function ( sender )
            local jsonFile11 = "sprite/sprite_gonghuidating.json"
            local atlasFile11 = "sprite/sprite_gonghuidating.atlas"
            local animation11 = sp.spine(jsonFile11, atlasFile11, 1, 0, nil, true, nil)
            animation11.animationNameList = {"animation"}
            sp.initArmature(animation11, false)
            animation11:playWithIndex(0)
            Panel_dh_11:addChild(animation11)
        end)}))
    end

    local Panel_dh_12 = ccui.Helper:seekWidgetByName(root, "Panel_dh_12")
    if Panel_dh_12 ~= nil then
        Panel_dh_12:removeAllChildren(true)
        self:runAction(cc.Sequence:create({cc.DelayTime:create(1.4), cc.CallFunc:create(function ( sender )
            local jsonFile12 = "sprite/sprite_gonghuiyz.json"
            local atlasFile12 = "sprite/sprite_gonghuiyz.atlas"
            local animation12 = sp.spine(jsonFile12, atlasFile12, 1, 0, nil, true, nil)
            animation12.animationNameList = {"animation"}
            sp.initArmature(animation12, false)
            animation12:playWithIndex(0)
            Panel_dh_12:addChild(animation12)
        end)}))
    end

        --公会副本开启判断
    if dms.int(dms["fun_open_condition"], 148, fun_open_condition.union_level) <= tonumber(_ED.union.union_info.union_grade) then
        ccui.Helper:seekWidgetByName(root, "Image_lock_1"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_pve"):setTouchEnabled(true)
    else
        ccui.Helper:seekWidgetByName(root, "Image_lock_1"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_pve"):setTouchEnabled(false)
    end
    --公会战开启判断
    if dms.int(dms["fun_open_condition"], 149, fun_open_condition.union_level) <= tonumber(_ED.union.union_info.union_grade) then
        ccui.Helper:seekWidgetByName(root, "Image_lock_2"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_battle"):setTouchEnabled(true)
    else
        ccui.Helper:seekWidgetByName(root, "Image_lock_2"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_battle"):setTouchEnabled(false)
    end

    --大冒险开启判断
    if dms.int(dms["fun_open_condition"], 144, fun_open_condition.union_level) <= tonumber(_ED.union.union_info.union_grade) then
        ccui.Helper:seekWidgetByName(root, "Image_lock_3"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_adv"):setTouchEnabled(true)
    else
        ccui.Helper:seekWidgetByName(root, "Image_lock_3"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_adv"):setTouchEnabled(false)
    end

    --工会红包开启判断
    if dms.int(dms["fun_open_condition"], 145, fun_open_condition.union_level) <= tonumber(_ED.union.union_info.union_grade) then
        ccui.Helper:seekWidgetByName(root, "Image_lock_4"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_red"):setTouchEnabled(true)
    else
        ccui.Helper:seekWidgetByName(root, "Image_lock_4"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_red"):setTouchEnabled(false)
    end

    --能量屋开启判断
    if dms.int(dms["fun_open_condition"], 147, fun_open_condition.union_level) <= tonumber(_ED.union.union_info.union_grade) then
        ccui.Helper:seekWidgetByName(root, "Image_lock_5"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Button_power"):setTouchEnabled(true)
    else
        ccui.Helper:seekWidgetByName(root, "Image_lock_5"):setVisible(true)
        ccui.Helper:seekWidgetByName(root,"Button_power"):setTouchEnabled(false)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_03"), nil, 
    {
        terminal_name = "union_return_home", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    -- --商店
 --    local Button_24 = ccui.Helper:seekWidgetByName(root, "Button_shop")
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shop"), nil, 
    {
        terminal_name = "union_go_to_shop", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    -- --帮助
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_21"), nil, 
 --    {
 --        terminal_name = "union_look_help_information", 
 --        terminal_state = 0,
 --        isPressedActionEnabled = true
 --    }, 
 --    nil, 0)
    --  排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rank"), nil, 
    {
        terminal_name = "union_go_to_rank", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --  研究院
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_research"), nil, 
    {
        terminal_name = "sm_union_research_institute_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_main_window_research_institute",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_research"),
        _invoke = nil,
        _interval = 0.5,})

    -- 能量屋
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_power"), nil, 
    {
        terminal_name = "union_change_update_open_energy_house", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_main_window_power_house",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_power"),
        _invoke = nil,
        _interval = 0.5,})

    -- 老虎机
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_extract"), nil, 
    {
        terminal_name = "sm_union_slot_machine_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_main_window_slot_machine",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_extract"),
        _invoke = nil,
        _interval = 0.5,}) 

    -- 红包
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_red"), nil, 
    {
        terminal_name = "sm_union_red_envelopes_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_main_window_red_envelopes",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_red"),
        _invoke = nil,
        _interval = 0.5,}) 

    -- 大冒险
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_adv"), nil, 
    {
        terminal_name = "union_change_open_adventure", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_main_window_adventure",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_adv"),
        _invoke = nil,
        _interval = 0.5,}) 

 --    local Button_25 = ccui.Helper:seekWidgetByName(root, "Button_25")
 --    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_25"), nil, 
 --    {
 --        terminal_name = "union_go_to_heaven", 
 --        terminal_state = 0,
 --        isPressedActionEnabled = true
 --    }, 
 --    nil, 0)

    local Button_pve = ccui.Helper:seekWidgetByName(root, "Button_pve")
    fwin:addTouchEventListener(Button_pve, nil, 
    {
        terminal_name = "union_go_to_duplicate", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_main_window_duplicate",
        _widget = Button_pve,
        _invoke = nil,
        _interval = 0.5,}) 

    --工会战
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_main_window_union_battle",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_battle"),
        _invoke = nil,
        _interval = 0.5,})

    local Button_battle = ccui.Helper:seekWidgetByName(root, "Button_battle") 
    fwin:addTouchEventListener(Button_battle, nil, 
    {
        terminal_name = "union_change_open_guild_warfare", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)


    local Button_notice = ccui.Helper:seekWidgetByName(root, "Button_notice") 
    fwin:addTouchEventListener(Button_notice, nil, 
    {
        terminal_name = "union_change_meeting_place_information_change_declaration", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    if tonumber(_ED.union.user_union_info.union_post) == 1 then
        Button_notice:setTouchEnabled(true)
    else
        Button_notice:setTouchEnabled(false)
    end
    ccui.Helper:seekWidgetByName(root, "Text_notice"):setString("")
    --打开工会大厅
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hall"), nil, 
    {
        terminal_name = "union_change_right_hall_state", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_main_window_union_hall",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_hall"),
        _invoke = nil,
        _interval = 0.5,})


    -- 工会援助
    local Button_assistance = ccui.Helper:seekWidgetByName(root, "Button_assistance") 
    fwin:addTouchEventListener(Button_assistance, nil, 
    {
        terminal_name = "union_member_help", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

 --    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_fighting",
 --    _widget = Button_29,
 --    _invoke = nil,
 --    _interval = 0.5,})

 --    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_shop_reward",
 --    _widget = Button_24,
 --    _invoke = nil,
 --    _interval = 0.5,})

 --    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_build",
 --    _widget = Button_25,
 --    _invoke = nil,
 --    _interval = 0.5,})

    -- 每次打开及时同步工会成员数据 by-tongwensen
    -- local function responseCallback( response )
    -- end
    -- if tonumber(_ED.union.union_member_list_sum) == nil then
    --     NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, nil, responseCallback, false, nil)
    -- end

    -- if _ED.union ~= nil and _ED.union.union_info ~= nil and _ED.union.union_info.union_id ~= nil and _ED.union_fight_url ~= nil and _ED.union_fight_url ~= "" then
    --     protocol_command.unino_fight_init.param_list = _ED.union.union_info.union_id.."\r\n".._ED.user_current_server_number
    --     NetworkManager:register(protocol_command.unino_fight_init.code, _ED.union_fight_url, nil, nil, self, responseUnionFightCallback, false, nil)
    -- end

    -- local cell = UnionTheMeetingPlace:createCell()
    -- self:addChild(cell)
end

function UnionTigerGate:onInit()
    local csbUnion = csb.createNode("legion/legion.csb")
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

    -- 彩蛋事件添加
    showEasterEggEvent(5,-1,root)

    local function responseUnionInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:updateDraw()
            end
            NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, nil, responseCallback1, false, nil)
        end
    end
    NetworkManager:register(protocol_command.union_init.code, nil, nil, nil, self, responseUnionInitCallback, false, nil)
end

function UnionTigerGate:onEnterTransitionFinish()
    state_machine.excute("sm_union_user_topinfo_open",0,self)
end

function UnionTigerGate:init()
    self:onInit()
    return self
end

function UnionTigerGate:close( ... )
    for i=1,11 do
        local Panel_dh = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_dh_"..i)
        if Panel_dh ~= nil then
            Panel_dh:removeAllChildren(true)
        end
    end
end

function UnionTigerGate:onExit()
    state_machine.remove("union_look_help_information")
    state_machine.remove("union_refresh_info")
    state_machine.remove("union_return_home")
    state_machine.remove("union_go_to_shop")
    state_machine.remove("union_go_to_heaven")
    state_machine.remove("union_go_to_duplicate")
    state_machine.remove("union_go_to_learn_skill")
    state_machine.remove("union_go_to_rank")
    state_machine.remove("union_change_right_list_view_state")
    state_machine.remove("union_member_help")

    state_machine.remove("union_lock_state_machine")
    state_machine.remove("union_unlock_state_machine")
end

function UnionTigerGate:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end

end