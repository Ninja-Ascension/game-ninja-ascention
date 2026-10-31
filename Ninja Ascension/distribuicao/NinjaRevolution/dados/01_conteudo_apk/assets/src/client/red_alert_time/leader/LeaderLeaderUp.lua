--------------------------------------------------------------------------------------------------------------
--  说明：将领升级
--------------------------------------------------------------------------------------------------------------
LeaderLeaderUp = class("LeaderLeaderUpClass", Window)

--打开界面
local leader_leader_up_window_open_terminal = {
    _name = "leader_leader_up_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("LeaderLeaderUpClass") == nil then
            local ship_id = params._datas.ship_id
            fwin:open(LeaderLeaderUp:new():init(ship_id), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local leader_leader_up_window_close_terminal = {
    _name = "leader_leader_up_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LeaderLeaderUpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(leader_leader_up_window_open_terminal)
state_machine.add(leader_leader_up_window_close_terminal)
state_machine.init()

function LeaderLeaderUp:ctor()
    self.super:ctor()
    self.roots = {}

    self.listview = nil
    self.listview_poy = 0

    self._ship_id = nil
    self._ship_info = nil
    self._ship_mould_id = nil

    self._last_level = 0

    local function init_leader_leader_up_terminal()
        local leader_leader_up_update_draw_terminal = {
            _name = "leader_leader_up_update_draw",
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

        local leader_leader_up_attribute_terminal = {
            _name = "leader_leader_up_attribute",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("leader_synopsis_window_window_open",0,{instance._ship_mould_id,instance._ship_info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --打开分享
        local leader_leader_up_open_share_terminal = {
            _name = "leader_leader_up_open_share",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(true)
                Panel_share_close:setVisible(true)
                Animations_PlayOpenMainUI({Panel_share}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_SLIDE_DOWN, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --关闭分享
        local leader_leader_up_close_share_terminal = {
            _name = "leader_leader_up_close_share",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(false)
                Panel_share_close:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --分享到聊天
        local leader_leader_up_share_chats_terminal = {
            _name = "leader_leader_up_share_chats",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(params._datas.chat_type) == 14 then
                    if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                        state_machine.excute("leader_leader_up_close_share", 0, 0)           
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("leader_leader_up_close_share", 0, 0) 
                    return
                end 
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("leader_leader_up_close_share", 0,0)
                        TipDlg.drawTextDailog(game_share_tip_text[1])
                    end
                end
                local datas = dms.string(dms["message_share"], 4, message_share.content)
                local ship_data = dms.element(dms["ship_mould"], instance._ship_mould_id)
                local name = dms.string(dms["ship_mould"], instance._ship_mould_id, ship_mould.captain_name)
                local quality = dms.int(dms["ship_mould"], instance._ship_mould_id, ship_mould.ship_type)
                local mine_info = "|"..quality.."|"..name
                local data1 =  string.gsub(datas, "!x@", mine_info)
                -- local paramsInfo = mine_info
                local paramsInfo = "7-1-"..instance._ship_mould_id..","..mine_info
                datas = ""--data1
                local str =datas..chat_section[1].."3".."|"..instance._ship_mould_id..","..instance._ship_info.ship_id..","..instance._ship_info.ship_level..","..instance._ship_info.hit
                    ..","..instance._ship_info.dodge..","..instance._ship_info.crit..","..instance._ship_info.toughness..","..instance._ship_info.pierce_through..","..instance._ship_info.protect
                    .."!"..instance._ship_info.talents[1].talent_id..","..instance._ship_info.talents[1].is_activited..","..instance._ship_info.talents[2].talent_id..","..instance._ship_info.talents[2].is_activited
                    ..","..instance._ship_info.talents[3].talent_id..","..instance._ship_info.talents[3].is_activited..","..instance._ship_info.talents[4].talent_id..","..instance._ship_info.talents[4].is_activited
                str = zstring.exchangeTo(str)
                protocol_command.send_message.param_list = str.."\r\n"..params._datas.chat_type.. "\r\n0\r\n4\r\n" .. paramsInfo
                -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, instance, responseSendMessageCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=instance, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新技能书
        local leader_leader_up_update_prop_use_terminal = {
            _name = "leader_leader_up_update_prop_use",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updatePropUse()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(leader_leader_up_update_draw_terminal)
        state_machine.add(leader_leader_up_attribute_terminal)
        state_machine.add(leader_leader_up_open_share_terminal)
        state_machine.add(leader_leader_up_close_share_terminal)
        state_machine.add(leader_leader_up_share_chats_terminal)
        state_machine.add(leader_leader_up_update_prop_use_terminal)
        state_machine.init()
    end
    init_leader_leader_up_terminal()
end

function LeaderLeaderUp:updateDraw( ... )
    local root = self.roots[1]
    local Panel_leader_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_icon")
    local Text_leader_name = ccui.Helper:seekWidgetByName(root, "Text_leader_name")
    Panel_leader_icon:removeAllChildren(true)

    self._ship_info = _ED.user_ship[""..self._ship_id]
    self._ship_mould_id = self._ship_info.ship_template_id
    local ship_data = dms.element(dms["ship_mould"], self._ship_mould_id)

    -- 图标名称
    local icon_cell = state_machine.excute("props_icon_create_cell", 0, {2, 9, self._ship_mould_id, 3, -1, false, self._ship_info})
    Panel_leader_icon:addChild(icon_cell)
    local ship_name = self._ship_info.captain_name
    local quality = self._ship_info.ship_type
    Text_leader_name:setString(ship_name)
    Text_leader_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))

    -- 魂魄
    local Text_leader_soul_n = ccui.Helper:seekWidgetByName(root, "Text_leader_soul_n")
    local prop_info = zstring.split(dms.atos(ship_data, ship_mould.screen_attack_effect), ",")
    local prop_id = tonumber(prop_info[1])
    local prop_count = 0
    if fundPropWidthId(prop_id) ~= nil then 
        local token = fundPropWidthId(prop_id)
        prop_count = zstring.tonumber(token.prop_number)
    end
    Text_leader_soul_n:setString(prop_count)

    -- 等级
    local Text_leader_lv = ccui.Helper:seekWidgetByName(root, "Text_leader_lv")
    local current_level = tonumber(self._ship_info.ship_level)
    local max_level = dms.atoi(ship_data, ship_mould.ship_star)
    Text_leader_lv:setString(string.format(red_alert_time_str[60], current_level, max_level))
    if self._last_level ~= nil and self._last_level < current_level then
        checkPlayEffect(22)
    end
    self._last_level = current_level

    -- 特点
    local Text_leader_point_n = ccui.Helper:seekWidgetByName(root, "Text_leader_point_n")
    local skill_describe = dms.atos(ship_data, ship_mould.skill_describe)
    Text_leader_point_n:setString(skill_describe)

    -- 经验值
    local LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
    local Text_leader_exp = ccui.Helper:seekWidgetByName(root, "Text_leader_exp")

    local current_exp = self._ship_info.experience
    local max_need_exp = dms.int(dms["ship_experience_param"], current_level + 1, ship_experience_param.needs_experience_white + quality)
    local percent = (current_exp / max_need_exp) * 100
    LoadingBar_1:setPercent(percent)
    Text_leader_exp:setString(""..current_exp.."/"..max_need_exp)

    -- 出征状态
    local Text_leader_go_to_war = ccui.Helper:seekWidgetByName(root, "Text_leader_go_to_war")
    if tonumber(self._ship_info.current_count)== 0 then
        Text_leader_go_to_war:setVisible(true)
    else
        Text_leader_go_to_war:setVisible(false)
    end

    self:updateAttribute()
end

function LeaderLeaderUp:updateAttribute()
    local root = self.roots[1]
    local Text_hit_n = ccui.Helper:seekWidgetByName(root, "Text_hit_n")                         -- 命中
    local Text_dodge_n = ccui.Helper:seekWidgetByName(root, "Text_dodge_n")                     -- 闪避
    local Text_crit_n = ccui.Helper:seekWidgetByName(root, "Text_crit_n")                       -- 暴击
    local Text_uprising_n = ccui.Helper:seekWidgetByName(root, "Text_uprising_n")               -- 抗暴
    local Text_pierce_through_n = ccui.Helper:seekWidgetByName(root, "Text_pierce_through_n")   -- 指挥
    local Text_protect_n = ccui.Helper:seekWidgetByName(root, "Text_protect_n")                 -- 坚守

    Text_hit_n:setString(self._ship_info.hit .. "%")
    Text_dodge_n:setString(self._ship_info.dodge .. "%")
    Text_crit_n:setString(self._ship_info.crit .. "%")
    Text_uprising_n:setString(self._ship_info.toughness .. "%")
    Text_pierce_through_n:setString(self._ship_info.pierce_through .. "%")   
    Text_protect_n:setString(self._ship_info.protect .. "%")            

    -- 升级后属性
    local Text_hit_n_up = ccui.Helper:seekWidgetByName(root, "Text_hit_n_up")                         -- 命中
    local Text_hit_n_up_0 = ccui.Helper:seekWidgetByName(root, "Text_hit_n_up_0")                     -- 闪避
    local Text_crit_n_up = ccui.Helper:seekWidgetByName(root, "Text_crit_n_up")                       -- 暴击
    local Text_uprising_n_up = ccui.Helper:seekWidgetByName(root, "Text_uprising_n_up")               -- 抗暴
    local Text_pierce_through_n_up = ccui.Helper:seekWidgetByName(root, "Text_pierce_through_n_up")   -- 指挥
    local Text_protect_n_up = ccui.Helper:seekWidgetByName(root, "Text_protect_n_up")                 -- 坚守

    local add_attr_info = zstring.split(dms.string(dms["ship_mould"], self._ship_mould_id, ship_mould.skill_grow_up_param), "|")
    local add_attr = {["49"] = 0, ["50"] = 0, ["51"] = 0, ["52"] = 0, ["71"] = 0, ["72"] = 0}
    for k, v in pairs(add_attr_info) do
        local info = zstring.split(v, ",")
        add_attr[""..info[1]] = add_attr[""..info[1]] + tonumber(info[2])
    end

    Text_hit_n_up:setString((self._ship_info.hit + add_attr["51"]) .. "%")
    Text_hit_n_up_0:setString((self._ship_info.dodge + add_attr["52"]) .. "%")
    Text_crit_n_up:setString((self._ship_info.crit + add_attr["49"]) .. "%")
    Text_uprising_n_up:setString((self._ship_info.toughness + add_attr["50"]) .. "%")
    Text_pierce_through_n_up:setString((self._ship_info.pierce_through + add_attr["71"]) .. "%") 
    Text_protect_n_up:setString((self._ship_info.protect + add_attr["72"]) .. "%")        

    Text_hit_n_up:setVisible(true)
    Text_hit_n_up_0:setVisible(true)
    Text_crit_n_up:setVisible(true)
    Text_uprising_n_up:setVisible(true)
    Text_pierce_through_n_up:setVisible(true)
    Text_protect_n_up:setVisible(true)

    local Image_hit_n_up = ccui.Helper:seekWidgetByName(root, "Image_hit_n_up")
    local Image_hit_n_up_0 = ccui.Helper:seekWidgetByName(root, "Image_hit_n_up_0")
    local Image_crit_n_up = ccui.Helper:seekWidgetByName(root, "Image_crit_n_up")
    local Image_uprising_n_up = ccui.Helper:seekWidgetByName(root, "Image_uprising_n_up")
    local Image_pierce_through_n_up = ccui.Helper:seekWidgetByName(root, "Image_pierce_through_n_up")
    local Image_protect_n_up = ccui.Helper:seekWidgetByName(root, "Image_protect_n_up")
    Image_hit_n_up:setVisible(true)
    Image_hit_n_up_0:setVisible(true)
    Image_crit_n_up:setVisible(true)
    Image_uprising_n_up:setVisible(true)
    Image_pierce_through_n_up:setVisible(true)
    Image_protect_n_up:setVisible(true)
end

function LeaderLeaderUp:updatePropUse()
    local root = self.roots[1]
    local ListView_leader_skills = ccui.Helper:seekWidgetByName(root, "ListView_leader_skills")
    ListView_leader_skills:jumpToTop()
    ListView_leader_skills:removeAllItems()

    local prop_ids = zstring.split(dms.string(dms["prop_config"], 17, prop_config.param), ",")

    for k, v in pairs(prop_ids) do
        local cell = state_machine.excute("leader_prop_use_cell_cretae", 0, {k, tonumber(v), self._ship_info})
        ListView_leader_skills:addChild(cell)
    end

    ListView_leader_skills:requestRefreshView()
    self.listview = ListView_leader_skills
    self.listview_poy = ListView_leader_skills:getInnerContainer():getPositionY()
end

function LeaderLeaderUp:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function LeaderLeaderUp:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_leader_up)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_infor_close"), nil, 
    {
        terminal_name = "leader_leader_up_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_infor"), nil, 
    {
        terminal_name = "leader_leader_up_attribute", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    --分享
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"), nil, 
    {
        terminal_name = "leader_leader_up_open_share", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)
    
    ccui.Helper:seekWidgetByName(root,"Panel_share_close"):setSwallowTouches(false)
    --分享关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_share_close"), nil, 
    {
        terminal_name = "leader_leader_up_close_share", 
        terminal_state = 0, 
    }, nil, 1)
    
    --分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_legion_chat"), nil, 
    {
        terminal_name = "leader_leader_up_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 14,
    }, nil, 1)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_world_chat"), nil, 
    {
        terminal_name = "leader_leader_up_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 13,
    }, nil, 1)

    self:updateDraw()
    self:updatePropUse()
end

function LeaderLeaderUp:onEnterTransitionFinish()

end

function LeaderLeaderUp:init(ship_id)
    self._ship_id = ship_id
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function LeaderLeaderUp:onExit()
    state_machine.remove("leader_leader_up_update_draw")
    state_machine.remove("leader_leader_up_attribute")
    state_machine.remove("leader_leader_up_open_share")
    state_machine.remove("leader_leader_up_close_share")
    state_machine.remove("leader_leader_up_share_chats")
    state_machine.remove("leader_leader_up_update_prop_use")
end