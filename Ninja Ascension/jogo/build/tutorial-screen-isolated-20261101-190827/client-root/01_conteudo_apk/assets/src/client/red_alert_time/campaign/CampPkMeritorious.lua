--------------------------------------------------------------------------------------------------------------
--  说明：阵营对决-功勋
--------------------------------------------------------------------------------------------------------------
CampPkMeritorious = class("CampPkMeritoriousClass", Window)

--打开界面
local camp_pk_meritorious_open_terminal = {
	_name = "camp_pk_meritorious_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = CampPkMeritorious:new():init(params)
		fwin:open(panel)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(camp_pk_meritorious_open_terminal)
state_machine.init()

function CampPkMeritorious:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = 0 
    self._list_view_height = 0
    self._Image_week_rank_arrow_down = nil
    self._Image_week_rank_arrow_up = nil

    self._last_state = 0

    local function init_camp_pk_meritorious_terminal()
        local camp_pk_meritorious_show_terminal = {
            _name = "camp_pk_meritorious_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                -- 开战中或结束时查看排行榜请求最新数据
                -- local current_state = 0
                -- if _ED.camp_pk_info ~= nil then
                --     current_state = zstring.tonumber(_ED.camp_pk_info.state)
                -- end
                -- if current_state == 3
                --     or (instance._last_state ~= current_state and current_state == 0)
                --     then
                    state_machine.excute("camp_pk_meritorious_request_update_draw", 0, "")
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_meritorious_hide_terminal = {
            _name = "camp_pk_meritorious_hide",
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

        local camp_pk_meritorious_open_share_terminal = {
            _name = "camp_pk_meritorious_open_share",
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

        local camp_pk_meritorious_close_share_terminal = {
            _name = "camp_pk_meritorious_close_share",
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

        local camp_pk_meritorious_share_chat_terminal = {
            _name = "camp_pk_meritorious_share_chat",
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
                        state_machine.excute("camp_pk_meritorious_close_share", 0, 0)          
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("camp_pk_meritorious_close_share", 0, 0)          
                    return
                end 
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("camp_pk_meritorious_close_share", 0, 0)                      
                        TipDlg.drawTextDailog(game_share_tip_text[1])
                    end
                end

                local camp_type = ""
                if _ED.camp_pk_user_info.camp_state < 0 then
                elseif _ED.camp_pk_user_info.camp_state == 0 then
                    camp_type = "%%|2|"..tipStringInfo_campaign_info[44].."%%"
                else
                    camp_type = "%%|5|"..tipStringInfo_campaign_info[45].."%%"
                end

                if camp_type == "" then
                    TipDlg.drawTextDailog(tipStringInfo_campaign_info[55])
                    state_machine.excute("camp_pk_meritorious_close_share", 0, 0)
                    return
                end

                local title = dms.string(dms["message_share"], 63, message_share.title)
                if tonumber(title) ~= nil and tonumber(title) < 0 then
                    title = ""
                else
                    title = title.."\r\n"
                end

                local datas = dms.string(dms["message_share"], 63, message_share.content)
                local data1 =  string.gsub(datas, "!x@", _ED.camp_pk_user_info.current_con)
                local data2 =  string.gsub(data1, "!y@", _ED.camp_pk_user_info.win_times)
                local data3 =  string.gsub(data2, "!z@", camp_type)
                -- local paramsInfo = _ED.camp_pk_user_info.current_con..",".._ED.camp_pk_user_info.win_times..","..camp_type
                local paramsInfo = "2-3-".._ED.camp_pk_user_info.camp_state..",".._ED.camp_pk_user_info.current_con..",".._ED.camp_pk_user_info.win_times..","..camp_type
                datas = data3
                local str = ""--title..datas
                if dms.int(dms["message_share"], 63, message_share.jump_type) ~= -1 then
                    str = str..chat_section[1]..dms.int(dms["message_share"], 63, message_share.jump_type)
                end
                str = zstring.exchangeTo(str)
                protocol_command.send_message.param_list = str.."\r\n"..params._datas.chat_type.."\r\n0\r\n63\r\n"..paramsInfo
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_meritorious_update_draw_terminal = {
            _name = "camp_pk_meritorious_update_draw",
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

        -- 请求最新的排行榜数据刷新
        local camp_pk_meritorious_request_update_draw_terminal = {
            _name = "camp_pk_meritorious_request_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("camp_pk_meritorious_update_draw", 0, "")
                        end
                    end
                end
                if _ED.camp_pk_info ~= nil then
                    instance._last_state = zstring.tonumber(_ED.camp_pk_info.state)
                end
                
                protocol_command.camp_duel_rank_list_get.param_list = "0"
                NetworkManager:register(protocol_command.camp_duel_rank_list_get.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(camp_pk_meritorious_show_terminal)
        state_machine.add(camp_pk_meritorious_hide_terminal)
        state_machine.add(camp_pk_meritorious_open_share_terminal)
        state_machine.add(camp_pk_meritorious_close_share_terminal)
        state_machine.add(camp_pk_meritorious_share_chat_terminal)
        state_machine.add(camp_pk_meritorious_update_draw_terminal)
        state_machine.add(camp_pk_meritorious_request_update_draw_terminal)
        state_machine.init()
    end
    
    init_camp_pk_meritorious_terminal()
end

function CampPkMeritorious:updateDraw()
    local root = self.roots[1]
    local Text_camp_pk_rank_me_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_rank_me_n")                 -- 我的排名
    local Text_camp_pk_meritorious_me_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_meritorious_me_n")   -- 功勋
    local Text_camp_pk_camp_me_n = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_camp_me_n")                 -- 阵营
    local Text_camp_pk_settlement_infor = ccui.Helper:seekWidgetByName(root, "Text_camp_pk_settlement_infor")
    Text_camp_pk_settlement_infor:setString("")
    Text_camp_pk_settlement_infor:removeAllChildren(true)
    -- local Panel_camp_pk_settlement_2 = ccui.Helper:seekWidgetByName(root, "Panel_camp_pk_settlement_2")

    Text_camp_pk_meritorious_me_n:setString(_ED.camp_pk_user_info.current_con)

    local quality = 1
    if _ED.camp_pk_user_info.camp_state < 0 then
        Text_camp_pk_camp_me_n:setString(tipStringInfo_campaign_info[43])
    elseif _ED.camp_pk_user_info.camp_state == 0 then
        Text_camp_pk_camp_me_n:setString(tipStringInfo_campaign_info[44])
        quality = 3
        camp_type = tipStringInfo_campaign_info[44]
    else
        Text_camp_pk_camp_me_n:setString(tipStringInfo_campaign_info[45])
        quality = 6
        camp_type = tipStringInfo_campaign_info[45]
    end
    Text_camp_pk_camp_me_n:setColor(cc.c3b(color_Type[quality][1], color_Type[quality][2], color_Type[quality][3]))

    local camp_type = ""
    local camp_quality = 1
    if _ED.camp_pk_info.win_info < 0 then
    elseif _ED.camp_pk_info.win_info == 0 then
        camp_quality = 3
        camp_type = tipStringInfo_campaign_info[44]
    else
        camp_quality = 6
        camp_type = tipStringInfo_campaign_info[45]
    end
    if _ED.camp_pk_info.state == 0 then
        local fontSize = Text_camp_pk_settlement_infor:getFontSize()
        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false) 
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, tipStringInfo_campaign_info[46], "fonts/simhei.ttf",fontSize)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[camp_quality][1],color_Type[camp_quality][2],color_Type[camp_quality][3]),255, camp_type, "fonts/simhei.ttf",fontSize)
        _richText:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, tipStringInfo_campaign_info[47], "fonts/simhei.ttf",fontSize)
        _richText:pushBackElement(re3)
        _richText:setPosition(cc.p(Text_camp_pk_settlement_infor:getContentSize().width/2,Text_camp_pk_settlement_infor:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_camp_pk_settlement_infor:getContentSize().width,fontSize))
        Text_camp_pk_settlement_infor:addChild(_richText)
    end

    local ListView_rebel_week_rank = ccui.Helper:seekWidgetByName(root, "ListView_rebel_week_rank")
    self._list_view = ListView_rebel_week_rank
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()
    local rank_me = 0
    if _ED.camp_pk_rank_info ~= nil 
        and _ED.camp_pk_rank_info["0"] ~= nil then
        for k, v in pairs(_ED.camp_pk_rank_info["0"]) do
            if v.user_id == tonumber(_ED.user_info.user_id) then
                rank_me = k
            end
            local cell = state_machine.excute("camp_pk_meritorious_cell_create", 0, {k, v ,0})
            self._list_view:addChild(cell)
        end
    end
    if rank_me == 0 then
        Text_camp_pk_rank_me_n:setString(tipStringInfo_campaign_info[4])
        Text_camp_pk_rank_me_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    else
        Text_camp_pk_rank_me_n:setString(rank_me)
        Text_camp_pk_rank_me_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end
    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function CampPkMeritorious:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_week_rank_arrow_down:setVisible(true)
        else
            self._Image_week_rank_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_week_rank_arrow_up:setVisible(true)
        else
            self._Image_week_rank_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
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

--初始化
function CampPkMeritorious:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.camp_pk_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_week_rank_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_week_rank_arrow_down")
    self._Image_week_rank_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_week_rank_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_week_rank_arrow_down:stopAllActions()
    self._Image_week_rank_arrow_up:stopAllActions()
    playActions(self._Image_week_rank_arrow_down)
    playActions(self._Image_week_rank_arrow_up)
    self._Image_week_rank_arrow_down:setVisible(false)
    self._Image_week_rank_arrow_up:setVisible(false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_camp_pk_share"), nil, 
    {
        terminal_name = "camp_pk_meritorious_open_share", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    --关闭分享
    ccui.Helper:seekWidgetByName(root,"Panel_share_close"):setSwallowTouches(false)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_share_close"), nil, 
    {
        terminal_name = "camp_pk_meritorious_close_share", 
        terminal_state = 0, 
    }, nil, 1)    
    
    --分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_legion_chat"), nil, 
    {
        terminal_name = "camp_pk_meritorious_share_chat", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 14,
    }, nil, 1)    
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_world_chat"), nil, 
    {
        terminal_name = "camp_pk_meritorious_share_chat", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 13,
    }, nil, 1)

    state_machine.excute("camp_pk_meritorious_request_update_draw", 0, "")
end

function CampPkMeritorious:onEnterTransitionFinish()

end

function CampPkMeritorious:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function CampPkMeritorious:onExit()
    state_machine.remove("camp_pk_meritorious_show")
    state_machine.remove("camp_pk_meritorious_hide")
    state_machine.remove("camp_pk_meritorious_open_share")
    state_machine.remove("camp_pk_meritorious_close_share")
    state_machine.remove("camp_pk_meritorious_share_chat")
    state_machine.remove("camp_pk_meritorious_update_draw")
    state_machine.remove("camp_pk_meritorious_request_update_draw")
end