--------------------------------------------------------------------------------------------------------------
--  皇城出站界面
--------------------------------------------------------------------------------------------------------------
TourneyfieldOfficer = class("TourneyfieldOfficerClass", Window)

--打开界面
local tourneyfield_officer_window_open_terminal = {
	_name = "tourneyfield_officer_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)  

        local arena_id = 0
        if params ~= nil and params._datas ~= nil then
            arena_id = params._datas.arena_id 
            terminal.arena_id = arena_id -- 记录数据
        else
            arena_id = terminal.arena_id
        end
        -- print("=========",arena_id)
        -- if _ED.arena_info.user_info ~= nil then
        --     if fwin:find("TourneyfieldOfficerClass") == nil then
        --         fwin:open(TourneyfieldOfficer:new():init(arena_id),fwin._ui)
        --     end
        --     return
        -- end
        local function responseCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("TourneyfieldOfficerClass") == nil then
                    fwin:open(TourneyfieldOfficer:new():init(arena_id),fwin._ui)
                end
            end
        end
        protocol_command.arena_lounch_refresh.param_list = "0" .. "\r\n" .. arena_id
        NetworkManager:register(protocol_command.arena_lounch_refresh.code, nil, nil, nil, nil, responseCallback, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local tourneyfield_officer_window_close_terminal = {
	_name = "tourneyfield_officer_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TourneyfieldOfficerClass"))     
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(tourneyfield_officer_window_open_terminal)
state_machine.add(tourneyfield_officer_window_close_terminal)
state_machine.init()

function TourneyfieldOfficer:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    --var 
    self._arena_id = nil
    self._panel_infor = nil
    -- load lua file
    app.load("client.red_alert.cells.campaign.tourneyfield.tourneyfield_officer_cell")
    app.load("client.red_alert.campaign.tourneyfield.ChallengePlayerMasseage")
    
	 -- Initialize tourneyfield_officer state machine.
    local function init_tourneyfield_officer_terminal()
        --换一批
        local tourneyfield_officer_change_terminal = {
            _name = "tourneyfield_officer_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --请求换一批 
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.onUpdateDrawHeros ~= nil then
                            response.node:onUpdateDrawHeros()
                        end
                    end
                end
                protocol_command.arena_lounch_refresh.param_list = "0" .. "\r\n" .. self._arena_id
                NetworkManager:register(protocol_command.arena_lounch_refresh.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --选择npc播放光效
        local tourneyfield_officer_play_npc_action_terminal = {
            _name = "tourneyfield_officer_play_npc_action",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.number
                local arena_id = params._datas.arena_id
                if index == 5 then 
                    user_data = _ED.arena_info.user_info[1]
                else
                    user_data = _ED.arena_info.user_info[index]
                end
                for i = 1,5 do
                    local Panel_player = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_player_"..i)
                    local cell = Panel_player:getChildByName("cells")
                    if cell ~= nil then
                        cell._pk_action = false
                        state_machine.excute("tourneyfield_officer_cell_play_npc_action",0,{cell})
                    end
                end

                local Panel_player = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_player_"..index)
                local cell = Panel_player:getChildByName("cells")
                if cell ~= nil then
                    cell._pk_action = true
                    state_machine.excute("tourneyfield_officer_cell_play_npc_action",0,{cell})
                end
                state_machine.excute("challenge_player_masseage_window_open",0,{user_data,arena_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        state_machine.add(tourneyfield_officer_change_terminal)
        state_machine.add(tourneyfield_officer_play_npc_action_terminal)
        state_machine.init()
    end
    
    -- call func tourneyfield_officer create state machine.
    init_tourneyfield_officer_terminal()

end

function TourneyfieldOfficer:onUpdateDraw()
    local root = self.roots[1]
    local arena_official = dms.int(dms["arena_reward_param"],self._arena_id,arena_reward_param.arena_official)
    local arena_salary = dms.string(dms["arena_reward_param"],self._arena_id,arena_reward_param.arena_salary)
    local arena_name = dms.string(dms["arena_reward_param"],self._arena_id,arena_reward_param.arena_name)
    arena_name = zstring.split(arena_name,",")
    arena_name = arena_name[tonumber(_ED.user_info.user_force)]
    arena_salary = zstring.split(arena_salary,",")
    arena_salary = tonumber(arena_salary[3])
    local arena_salary = arena_salary -- 俸禄
    local now_hour_time = tonumber(os.date("%H",zstring.exchangeFrom(os.time())))
    local pass_hour = 0
    pass_hour = now_hour_time - 3 
    if pass_hour < 0 then
        pass_hour = 24 - pass_hour
    end
    local arena_get_all_salary = pass_hour*arena_salary--收益

    local Text_office_lv = ccui.Helper:seekWidgetByName(root,"Text_office_lv")

    local Panel_header = ccui.Helper:seekWidgetByName(root,"Panel_header")
    local Text_salary_number = ccui.Helper:seekWidgetByName(root,"Text_salary_number")
    local Text_reward_number_1 = ccui.Helper:seekWidgetByName(root,"Text_reward_number_1")
    local Text_reward_number_2 = ccui.Helper:seekWidgetByName(root,"Text_reward_number_2")
    local Text_reward_number_3 = ccui.Helper:seekWidgetByName(root,"Text_reward_number_3")
    local Text_office_grade = ccui.Helper:seekWidgetByName(root,"Text_office_grade")
    local arena_every_reward = dms.string(dms["arena_reward_param"],self._arena_id,arena_reward_param.arena_every_reward)
    local color_table = red_alert_officer_color[arena_official]
    arena_every_reward = zstring.split(arena_every_reward,"|")
    Panel_header:setBackGroundImage("images/ui/play/tourneyfield/grade_"..arena_official..".png")
    Text_office_lv:setString(arena_name)
    Text_office_lv:setColor(cc.c3b(color_table[1],color_table[2],color_table[3]))
    Text_salary_number:setString(string.format(red_alert_all_str[146],arena_salary))
    Text_office_grade:setString(red_alert_officer[arena_official])
    Text_office_grade:setColor(cc.c3b(color_table[1],color_table[2],color_table[3]))
    for i,v in pairs(arena_every_reward) do
        local reward_data = zstring.split(v,",")
        if tonumber(reward_data[2]) == 1 then
            Text_reward_number_2:setString("x"..reward_data[3])
        elseif tonumber(reward_data[2]) == 2 then
            Text_reward_number_1:setString("x"..reward_data[3])
        elseif tonumber(reward_data[2]) == 3 then
            Text_reward_number_3:setString("x"..reward_data[3])
        end
    end


    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    Text_name:setColor(cc.c3b(color_table[1],color_table[2],color_table[3]))
    local Text_infor = ccui.Helper:seekWidgetByName(root,"Text_infor")
    Text_name:setString(red_alert_officer[arena_official]..arena_name)
    local dec_str_tab = dms.string(dms["arena_reward_param"],self._arena_id,arena_reward_param.arena_official_dec)
    dec_str_tab = zstring.split(dec_str_tab,",")
    local dec_str = ""
    for i,v in ipairs(dec_str_tab) do
        if i == 1 then
            dec_str = dec_str .. v
        else
            dec_str = dec_str .. "\r\n" .. v
        end
    end
    Text_infor:setString(dec_str)

    local Text_prompt = ccui.Helper:seekWidgetByName(root,"Text_prompt")
    Text_prompt:setString("")

    local my_arena_official = dms.int(dms["arena_reward_param"],_ED.arena_info.arena_id,arena_reward_param.arena_official)
    if my_arena_official - arena_official > 1 then
        Text_prompt:setString(string.format(red_alert_all_str[150],red_alert_officer[arena_official+1]))
    end
end

--初始化界面
function TourneyfieldOfficer:onInit()
    local csbItem = csb.createNode(config_csb.campaign.tourneyfield.tourneyfield_officer)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "tourneyfield_officer_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)     
    
    -- 换一批
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change"), nil, 
    {
        terminal_name = "tourneyfield_officer_change", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)   
    
    --选中人物
    for i = 1,5 do
        local Panel_player = ccui.Helper:seekWidgetByName(root,"Panel_player_"..i)
        Panel_player:setVisible(false)
    end
    if self._arena_id <= 5 then
        local Panel_player = ccui.Helper:seekWidgetByName(root,"Panel_player_5")
        Panel_player:setVisible(true)
        fwin:addTouchEventListener(Panel_player, nil, 
        {
            terminal_name = "tourneyfield_officer_play_npc_action", 
            terminal_state = 0,
            number = 5 ,
            user_data = _ED.arena_info.user_info[1], 
            arena_id = self._arena_id
        }, nil, 0) 
    else
        for i = 1,4 do
            local Panel_player = ccui.Helper:seekWidgetByName(root,"Panel_player_"..i)
            Panel_player:setVisible(true)
            fwin:addTouchEventListener(Panel_player, nil, 
            {
                terminal_name = "tourneyfield_officer_play_npc_action", 
                terminal_state = 0,
                number = i ,
                user_data = _ED.arena_info.user_info[i], 
                arena_id = self._arena_id
            }, nil, 0) 

        end
    end

    local Panel_infor = ccui.Helper:seekWidgetByName(root, "Panel_infor")
    self._panel_infor = Panel_infor  
    self:onUpdateDraw()
    local arena_official = dms.int(dms["arena_reward_param"],self._arena_id,arena_reward_param.arena_official)
    local Button_privilege = ccui.Helper:seekWidgetByName(root,"Button_privilege")
    if tonumber(arena_official) >= 8 then
        Button_privilege:setVisible(false)
    else
        Button_privilege:setVisible(true)
    end
    local function buttonTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        if ccui.TouchEventType.began == evenType then
            self._panel_infor:setVisible(true)
        elseif ccui.TouchEventType.moved == evenType then

        elseif ccui.TouchEventType.canceled == evenType then
            self._panel_infor:setVisible(false)
        elseif ccui.TouchEventType.ended == evenType then
            self._panel_infor:setVisible(false)
        end
    end
    fwin:addTouchEventListener(Button_privilege, buttonTouchEvent, {
        terminal_name = "",
        arena_id = self.arena_id,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0) 
    self:onUpdateDrawHeros()
end

function TourneyfieldOfficer:onUpdateDrawHeros()
    local root = self.roots[1]

    if self._arena_id <= 5 then
        local cell = state_machine.excute("tourneyfield_officer_create_cell",0,{_ED.arena_info.user_info[1]})
        local Panel_player = ccui.Helper:seekWidgetByName(root,"Panel_player_5")
        Panel_player:removeAllChildren(true)
        cell:setName("cells")
        Panel_player:addChild(cell)
        if tonumber(_ED.all_rank.my_info[self._arena_id].user_id) ~= tonumber(_ED.arena_info.user_info[1].user_id) then
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    state_machine.excute("tourneyfield_update_draw",0,"")  
                end
            end
            protocol_command.arena_init.param_list = "0"
            NetworkManager:register(protocol_command.arena_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        end
        return
    end

    for i,v in pairs(_ED.arena_info.user_info) do
        local cell = state_machine.excute("tourneyfield_officer_create_cell",0,{v})
        cell:setName("cells")
        local Panel_player = ccui.Helper:seekWidgetByName(root,"Panel_player_"..i)
        Panel_player:removeAllChildren(true)
        Panel_player:addChild(cell)

    end
end

function TourneyfieldOfficer:onEnterTransitionFinish()

end

function TourneyfieldOfficer:close()

end

--初始化
function TourneyfieldOfficer:init(arena_id)
    self._arena_id = arena_id
	self:onInit()
    return self
end

--移除状态机
function TourneyfieldOfficer:onExit()
    state_machine.remove("tourneyfield_officer_change",0,"")
    state_machine.remove("tourneyfield_officer_play_npc_action_terminal",0,"")
end