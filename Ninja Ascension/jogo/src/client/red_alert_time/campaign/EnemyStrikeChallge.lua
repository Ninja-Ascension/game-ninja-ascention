--------------------------------------------------------------------------------------------------------------
--  说明：敌军来袭-挑战
--------------------------------------------------------------------------------------------------------------
EnemyStrikeChallge = class("EnemyStrikeChallgeClass", Window)

--打开界面
local enemy_strike_challge_open_terminal = {
	_name = "enemy_strike_challge_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = EnemyStrikeChallge:new():init(params)
		fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(enemy_strike_challge_open_terminal)
state_machine.init()

function EnemyStrikeChallge:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._isAddComing = false
    self._tick_time = 0
    self._Text_limit_dekarona_begin_time = nil
    self._move_panel = {}
    self._pos_info = {{1018, 710}, {-418, -218}}

    self._is_text_show = true
    self._text_moves = {}

    self._reconnect_count = 0
    self._reconnect_time = 0

    local function init_enemy_strike_challge_terminal()
        local enemy_strike_challge_show_terminal = {
            _name = "enemy_strike_challge_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_challge_hide_terminal = {
            _name = "enemy_strike_challge_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_challge_update_terminal = {
            _name = "enemy_strike_challge_update",
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

        local enemy_strike_challge_open_rule_terminal = {
            _name = "enemy_strike_challge_open_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("expedition_rule_infor_window_open",0,4)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local enemy_strike_challge_send_message_terminal = {
            _name = "enemy_strike_challge_send_message",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local Panel_chat_view = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_chat_view")
                local posX = Panel_chat_view:getContentSize().width
                local posY = math.random(50,Panel_chat_view:getContentSize().height - 50)
                local color_index = math.floor(math.random(1, 6))
                local message = params.send_information_name..":"..params.information_content
                local fontSize = 24
                local label = cc.Label:createWithTTF(message, config_res.font.font_name, fontSize)
                if isContentZh_TW() == true then
                    local ttfConfig = {}
                    ttfConfig.fontFilePath = ""
                    label:setTTFConfig(ttfConfig)
                    label:setSystemFontSize(24)
                end
                label:setAnchorPoint(cc.p(0, 0.5))
                label:setPosition(cc.p(posX, posY))
                label:setColor(chat_rich_text_color[color_index])
                label:enableOutline(cc.c4b(0, 0, 0, 255), 1)
                Panel_chat_view:addChild(label)

                table.insert(instance._text_moves, label)
                label:setVisible(instance._is_text_show)

                local width = label:getContentSize().width

                local function callback(sender)
                    for i, v in pairs(instance._text_moves) do
                        if v == sender then
                            table.remove(instance._text_moves, i)
                            break
                        end
                    end
                    sender:removeFromParent(true)
                end

                local end_posX = 0 - width
                label:runAction(cc.Sequence:create(cc.MoveTo:create(5, cc.p(end_posX, posY)),
                    cc.CallFunc:create(callback)
                    ))

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 开关弹幕
        local enemy_strike_challge_switch_show_text_terminal = {
            _name = "enemy_strike_challge_switch_show_text",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._is_text_show = params
                for k, v in pairs(self._text_moves) do
                    v:setVisible(instance._is_text_show)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --分享打开
        local enemy_strike_challge_share_open_terminal = {
            _name = "enemy_strike_challge_share_open",
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
        
        --分享关闭
        local enemy_strike_challge_share_close_terminal = {
            _name = "enemy_strike_challge_share_close",
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
        local enemy_strike_challge_share_chats_terminal = {
            _name = "enemy_strike_challge_share_chats",
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
                        state_machine.excute("enemy_strike_challge_share_close", 0, 0)         
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("enemy_strike_challge_share_close", 0, 0)         
                    return
                end 
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("enemy_strike_challge_share_close", 0, "")
                        TipDlg.drawTextDailog(game_share_tip_text[1])
                    end
                end

                local title = dms.string(dms["message_share"], 76, message_share.title)
                if tonumber(title) ~= nil and tonumber(title) < 0 then
                    title = ""
                else
                    title = title.."\r\n"
                end
                local datas = dms.string(dms["message_share"], 76, message_share.content)
                local data1 =  string.gsub(datas, "!x@", _ED.user_enemy_strike_info.hurt_rank)
                local data2 =  string.gsub(data1, "!y@", _ED.user_enemy_strike_info.join_rank)
                local data3 =  string.gsub(data2, "!z@", _ED.user_enemy_strike_info.break_count)
                datas = data3
                -- local paramsInfo = _ED.user_enemy_strike_info.hurt_rank..",".._ED.user_enemy_strike_info.join_rank..",".._ED.user_enemy_strike_info.break_count
                local paramsInfo = "0-0,".._ED.user_enemy_strike_info.hurt_rank..",".._ED.user_enemy_strike_info.join_rank..",".._ED.user_enemy_strike_info.break_count
                local str = ""--title..datas
                if dms.int(dms["message_share"], 76, message_share.jump_type) ~= -1 then
                    str = str..chat_section[1]..dms.int(dms["message_share"], 76, message_share.jump_type)
                end
                str = zstring.exchangeTo(str)
                protocol_command.send_message.param_list = str.."\r\n"..params._datas.chat_type.. "\r\n0\r\n76\r\n"..paramsInfo
                -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(enemy_strike_challge_show_terminal)
        state_machine.add(enemy_strike_challge_hide_terminal)
        state_machine.add(enemy_strike_challge_update_terminal)
        state_machine.add(enemy_strike_challge_open_rule_terminal)
        state_machine.add(enemy_strike_challge_send_message_terminal)
        state_machine.add(enemy_strike_challge_switch_show_text_terminal)
        state_machine.add(enemy_strike_challge_share_open_terminal)    
        state_machine.add(enemy_strike_challge_share_close_terminal)    
        state_machine.add(enemy_strike_challge_share_chats_terminal)   
        state_machine.init()
    end
    
    init_enemy_strike_challge_terminal()
end

function EnemyStrikeChallge:showComing( is_show )
    local root = self.roots[1]
    local Panel_boss_comeing = ccui.Helper:seekWidgetByName(root, "Panel_boss_comeing")
    Panel_boss_comeing:removeAllChildren(true)

    if is_show == true then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_boss_coming)
        local armature = ccs.Armature:create("effect_boss_coming")
        armature:getAnimation():playWithIndex(0)
        armature:setPosition(cc.p(Panel_boss_comeing:getContentSize().width/2, Panel_boss_comeing:getContentSize().height/2))
        Panel_boss_comeing:addChild(armature)
    end
end

-- function EnemyStrikeChallge:showMapEffect( ... )
--     local root = self.roots[1]
--     local Panel_boss_tank_effect = ccui.Helper:seekWidgetByName(root, "Panel_boss_tank_effect")
--     Panel_boss_tank_effect:removeAllChildren(true)

--     ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_boss)
--     local armature = ccs.Armature:create("effect_boss")
--     armature:getAnimation():playWithIndex(0)
--     armature:setPosition(cc.p(Panel_boss_tank_effect:getContentSize().width/2, Panel_boss_tank_effect:getContentSize().height/2))
--     Panel_boss_tank_effect:addChild(armature)
-- end

function EnemyStrikeChallge:updateDraw()
    local root = self.roots[1]
    -- self._move_panel = {ccui.Helper:seekWidgetByName(root, "Panel_boss_map_effect"),
    --     ccui.Helper:seekWidgetByName(root, "Panel_boss_map_effect_0")}
    self._Text_limit_dekarona_begin_time = ccui.Helper:seekWidgetByName(root, "Text_limit_dekarona_begin_time")
    local Text_enemy_strike_att_infor_2 = ccui.Helper:seekWidgetByName(root, "Text_enemy_strike_att_infor_2")
    local Text_enemy_last_hurt_rank_n = ccui.Helper:seekWidgetByName(root, "Text_enemy_last_hurt_rank_n")
    local Text_enemy_last_join_rank_n = ccui.Helper:seekWidgetByName(root, "Text_enemy_last_join_rank_n")
    local Panel_boss_effect = ccui.Helper:seekWidgetByName(root, "Panel_boss_effect")
    Text_enemy_last_hurt_rank_n:setString(_ED.user_enemy_strike_info.hurt_rank)
    Text_enemy_last_join_rank_n:setString(_ED.user_enemy_strike_info.join_rank)

    local npc_info = zstring.split(dms.string(dms["enemy_boss_config"], 6, enemy_boss_config.param), ",")
    local ship_info = zstring.split(dms.string(dms["enemy_boss_config"], 12, enemy_boss_config.param), ",")
    local index = 1
    for k,v in pairs(npc_info) do
        if tonumber(v) == _ED.user_enemy_strike_boss_info.npc_id then
            index = k
        end
    end
    local ship_mould_id = ship_info[index]
    local ship_mould_info = dms.element(dms["ship_mould"], ship_mould_id)
    local dis_info = ""
    dis_info = dms.atos(ship_mould_info, ship_mould.skill_name)
    dis_info = dis_info.."\r\n"..dms.atos(ship_mould_info, ship_mould.skill_describe)
    dis_info = dis_info.."\r\n"..dms.atos(ship_mould_info, ship_mould.introduce)
    Text_enemy_strike_att_infor_2:setString(dis_info)

    if Panel_boss_effect ~= nil then
        local light_info = zstring.split(dms.atos(ship_mould_info, ship_mould.star_id_tab), ",")
        for i=1,6 do
            local Sprite_boss_part = Panel_boss_effect:getChildByName("Sprite_boss_part_"..i)
            local isLight = false
            for k,v in pairs(light_info) do
                if i == tonumber(v) then
                    isLight = true
                    break
                end
            end
            if isLight == true then
                display:ungray(Sprite_boss_part)
            else
                display:gray(Sprite_boss_part)
            end
        end
    end
    
    -- self._tick_time = 0
    -- local time_info = zstring.split(dms.string(dms["enemy_boss_config"], 1, enemy_boss_config.param), ":")
    -- local server_time = _ED.system_time + (os.time() - _ED.native_time)
    -- server_time = os.date("*t", zstring.tonumber(server_time))
    
    -- self._tick_time = (tonumber(time_info[1]) - server_time.hour) * 3600
    --     + (tonumber(time_info[2]) - server_time.min) * 60 + (tonumber(time_info[3]) - server_time.sec)

    -- if self._tick_time <= 0 and _ED.user_enemy_strike_boss_info.state == 0 then
    --     self._tick_time = 24 * 3600 + (tonumber(time_info[1]) - server_time.hour) * 3600
    --      + (tonumber(time_info[2]) - server_time.min) * 60 + (tonumber(time_info[3]) - server_time.sec)
    -- end
    self._tick_time = 0
    local push_info = _ED.mould_function_push_info["4"]
    if push_info ~= nil then
        self._end_time = tonumber(push_info.params) / 1000 + push_info.start_time
        self._tick_time = self._end_time - (os.time() + _ED.time_add_or_sub)
    end
    self._Text_limit_dekarona_begin_time:setString(exChangeNumTimeString(self._tick_time))

    self._reconnect_count = 0
    self._reconnect_time = 0
end

function EnemyStrikeChallge:onUpdate( dt )
    -- for k,v in pairs(self._move_panel) do
    --     if v:getPositionX() >= self._pos_info[1][1] and v:getPositionY() >= self._pos_info[1][2] then
    --         v:setPosition(cc.p(self._pos_info[2][1], self._pos_info[2][2]))
    --     end
    --     v:setPosition(cc.p(v:getPositionX() + 1.436 * 4, v:getPositionY() + 0.928 * 4))
    -- end
    -- self._tick_time = self._tick_time - dt
    self._tick_time = self._end_time - (os.time() + _ED.time_add_or_sub)
    if self._tick_time <= 0 then
        local push_info = _ED.mould_function_push_info["4"]
        if push_info ~= nil then
            self._end_time = tonumber(push_info.params) / 1000 + push_info.start_time
            self._tick_time = self._end_time - (os.time() + _ED.time_add_or_sub)
        end
    end
    if self._Text_limit_dekarona_begin_time ~= nil then
        self._Text_limit_dekarona_begin_time:setString(exChangeNumTimeString(self._tick_time))
        if self._tick_time <= 10 and self._isAddComing == false then
            self._isAddComing = true
            self:showComing(true)
        elseif self._tick_time > 10 and self._isAddComing == true then
            self._isAddComing = false
            self:showComing(false)
        end
        if self._tick_time <= 0 then
            state_machine.excute("enemy_strike_update_state_info", 0, nil)
            state_machine.excute("enemy_strike_world_box_update_state_info", 0, nil)
        end
    end

    -- 倒计时结束未刷新状态请求初始化
    if self._tick_time <= -1 then
        if self._reconnect_count <= 2 then
            self._reconnect_time = self._reconnect_time - dt
            if self._reconnect_time <= 0 then
                self._reconnect_count = self._reconnect_count + 1
                self._reconnect_time = 3
                state_machine.excute("enemy_strike_world_box_request_init", 0, "")
            end
        end
    end
end

--初始化
function EnemyStrikeChallge:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.enemy_strike_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_enemy_strike_infor"), nil, 
    {
        terminal_name = "enemy_strike_challge_open_rule", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    -- 分享打开
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_enemy_strike_share"), nil, 
    {
        terminal_name = "enemy_strike_challge_share_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  
    
    ccui.Helper:seekWidgetByName(root,"Panel_share_close"):setSwallowTouches(false)
    -- 分享关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_share_close"), nil, 
    {
        terminal_name = "enemy_strike_challge_share_close", 
        terminal_state = 0, 
    }, nil, 1)  
    
    -- 分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_legion_chat"), nil, 
    {
        terminal_name = "enemy_strike_challge_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 14,
    }, nil, 1)  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_world_chat"), nil, 
    {
        terminal_name = "enemy_strike_challge_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 13,
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_enemy_set_formation"), nil, 
    {
        terminal_name = "enemy_strike_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _page = 3,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_enemy_hurt_rank"), nil, 
    {
        terminal_name = "enemy_strike_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _page = 4,
    }, nil, 1)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_enemy_attack_time"), nil, 
    {
        terminal_name = "enemy_strike_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        _page = 6,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "enemy_strike_world_box_close", 
        terminal_state = 0, 
    }, nil, 3)

    self:updateDraw()
end

function EnemyStrikeChallge:onEnterTransitionFinish()

end

function EnemyStrikeChallge:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function EnemyStrikeChallge:onExit()
    state_machine.remove("enemy_strike_challge_show")
    state_machine.remove("enemy_strike_challge_hide")
    state_machine.remove("enemy_strike_challge_update")
    state_machine.remove("enemy_strike_challge_open_rule")
    state_machine.remove("enemy_strike_challge_send_message")
    state_machine.remove("enemy_strike_challge_switch_show_text")
    state_machine.remove("enemy_strike_challge_share_open")
    state_machine.remove("enemy_strike_challge_share_close")
    state_machine.remove("enemy_strike_challge_share_chats")
end