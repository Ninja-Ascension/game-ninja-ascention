--------------------------------------------------------------------------------------------------------------
--  说明：将领信息
--------------------------------------------------------------------------------------------------------------
LeaderInfo = class("LeaderInfoClass", Window)

--打开界面
local leader_info_window_open_terminal = {
	_name = "leader_info_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("LeaderInfoClass") == nil then
            fwin:open(LeaderInfo:new():init(params), fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local leader_info_window_close_terminal = {
	_name = "leader_info_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LeaderInfoClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(leader_info_window_open_terminal)
state_machine.add(leader_info_window_close_terminal)
state_machine.init()

function LeaderInfo:ctor()
	self.super:ctor()
	self.roots = {}

    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

    self._ship_id = nil
    self._ship_info = nil
    self._ship_mould_id = nil

    self._is_max_level = false      -- 是否满级
    self._is_max_star = false       -- 是否满星

    local function init_leader_info_terminal()
        local leader_info_update_terminal = {
            _name = "leader_info_update",
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

        local leader_info_attribute_terminal = {
            _name = "leader_info_attribute",
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

        local leader_info_level_up_terminal = {
            _name = "leader_info_level_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._is_max_level == true then
                    TipDlg.drawTextDailog(red_alert_time_str[76])
                else
                    state_machine.excute("leader_leader_up_window_open", 0,{_datas = {ship_id = instance._ship_id}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local leader_info_star_up_terminal = {
            _name = "leader_info_star_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance._is_max_star == true then
                    TipDlg.drawTextDailog(red_alert_time_str[79])
                else
                    state_machine.excute("leader_star_up_window_open", 0,{_datas = {ship_id = instance._ship_id}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--打开分享
		local leader_info_open_share_terminal = {
            _name = "leader_info_open_share",
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
		local leader_info_close_share_terminal = {
            _name = "leader_info_close_share",
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
		local leader_info_share_chats_terminal = {
            _name = "leader_info_share_chats",
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
                        state_machine.excute("leader_info_close_share", 0, 0)           
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("leader_info_close_share", 0, 0)           
                    return
                end 
				local function responseSendMessageCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("leader_info_close_share", 0,0)
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
                local paramsInfo = "6-1-"..instance._ship_mould_id..","..mine_info
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

        state_machine.add(leader_info_update_terminal)
        state_machine.add(leader_info_attribute_terminal)
        state_machine.add(leader_info_level_up_terminal)
        state_machine.add(leader_info_star_up_terminal)
        state_machine.add(leader_info_open_share_terminal)
        state_machine.add(leader_info_close_share_terminal)
        state_machine.add(leader_info_share_chats_terminal)
        state_machine.init()
    end
    init_leader_info_terminal()
end

function LeaderInfo:updateDraw( ... )
    local root = self.roots[1]
    local Panel_leader_icon = ccui.Helper:seekWidgetByName(root, "Panel_leader_icon")
    local Text_leader_name = ccui.Helper:seekWidgetByName(root, "Text_leader_name")
    local ListView_leader_skills = ccui.Helper:seekWidgetByName(root, "ListView_leader_skills")
    ListView_leader_skills:jumpToTop()
    ListView_leader_skills:removeAllItems()
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

    local Button_leader_up_lv = ccui.Helper:seekWidgetByName(root, "Button_leader_up_lv")
    local Button_leader_up_star = ccui.Helper:seekWidgetByName(root, "Button_leader_up_star")
    if current_level < max_level then
        self._is_max_level = false
        Button_leader_up_lv:setBright(true)
    else
        self._is_max_level = true
        Button_leader_up_lv:setBright(false)
    end
    local star_up_id = dms.int(dms["ship_mould"], self._ship_mould_id, ship_mould.grow_target_id)
    if star_up_id > 0 then
        self._is_max_star = false
        Button_leader_up_star:setBright(true)
    else
        self._is_max_star = true
        Button_leader_up_star:setBright(false)
    end

    -- 出征状态
    local Text_leader_go_to_war = ccui.Helper:seekWidgetByName(root, "Text_leader_go_to_war")
    if tonumber(self._ship_info.current_count)== 0 then
        Text_leader_go_to_war:setVisible(true)
    else
        Text_leader_go_to_war:setVisible(false)
    end

    self:updateAttribute()
    self:updateSkill()
end

function LeaderInfo:updateAttribute()
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
end

function LeaderInfo:updateSkill()
    local root = self.roots[1]
    local ListView_leader_skills = ccui.Helper:seekWidgetByName(root, "ListView_leader_skills")
    ListView_leader_skills:jumpToTop()
    ListView_leader_skills:removeAllItems()

    local skill_info = zstring.split(dms.string(dms["ship_mould"], self._ship_mould_id, ship_mould.talent_id), "|")
    for k, v in pairs(self._ship_info.talents) do
        local info = zstring.split(skill_info[k], ",")
        local talent_current_level = tonumber(v.is_activited)
        local talent_max_level = tonumber(info[2])
        local talent_id = tonumber(v.talent_id)
        local cell = nil
        if talent_current_level == 0 then
            cell = state_machine.excute("leader_infor_cell_out_cretae", 0, {k, talent_id, true, 1, talent_max_level, self._ship_info})
        else
            cell = state_machine.excute("leader_infor_cell_out_cretae", 0, {k, talent_id, false, talent_current_level, talent_max_level, self._ship_info})
        end
        ListView_leader_skills:addChild(cell)
    end

    ListView_leader_skills:requestRefreshView()
    self.listview = ListView_leader_skills
    self.listview_poy = ListView_leader_skills:getInnerContainer():getPositionY()
    self.listview_height = ListView_leader_skills:getInnerContainer():getPositionY()
end

function LeaderInfo:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_arrow_down:setVisible(true)
        else
            self._Image_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_arrow_up:setVisible(true)
        else
            self._Image_arrow_up:setVisible(false)
        end
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

function LeaderInfo:onInit(params)
    local csbItem = csb.createNode(config_csb.leader.leader_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_infor_close"), nil, 
    {
        terminal_name = "leader_info_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    -- 升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_up_lv"), nil, 
    {
        terminal_name = "leader_info_level_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        ship_id = self._ship_id,
    }, nil, 1)

    -- 升星
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_up_star"), nil, 
    {
        terminal_name = "leader_info_star_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        ship_id = self._ship_id,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_leader_infor"), nil, 
    {
        terminal_name = "leader_info_attribute", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

	--分享
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"), nil, 
    {
        terminal_name = "leader_info_open_share", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    }, nil, 1)
	
	ccui.Helper:seekWidgetByName(root,"Panel_share_close"):setSwallowTouches(false)
	--分享关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_share_close"), nil, 
    {
        terminal_name = "leader_info_close_share", 
        terminal_state = 0, 
    }, nil, 1)
	
	--分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_legion_chat"), nil, 
    {
        terminal_name = "leader_info_share_chats", 
        terminal_state = 0, 
        touch_black = true,
		chat_type = 14,
    }, nil, 1)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_world_chat"), nil, 
    {
        terminal_name = "leader_info_share_chats", 
        terminal_state = 0, 
        touch_black = true,
		chat_type = 13,
    }, nil, 1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_leader_infor_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_leader_infor_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_arrow_down:stopAllActions()
    self._Image_arrow_up:stopAllActions()
    playActions(self._Image_arrow_down)
    playActions(self._Image_arrow_up)
    self._Image_arrow_down:setVisible(false)
    self._Image_arrow_up:setVisible(false)


    self:updateDraw()
end

function LeaderInfo:onEnterTransitionFinish()

end

function LeaderInfo:init(params)
    self._ship_id = params[1]
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function LeaderInfo:onExit()
    state_machine.remove("leader_info_update")
    state_machine.remove("leader_info_attribute")
    state_machine.remove("leader_info_level_up")
    state_machine.remove("leader_info_star_up")
end