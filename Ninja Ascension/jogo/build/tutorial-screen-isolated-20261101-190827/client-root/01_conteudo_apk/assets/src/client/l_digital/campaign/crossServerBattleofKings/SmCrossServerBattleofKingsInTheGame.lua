-----------------------------
--王者之战比赛中界面
-----------------------------
SmCrossServerBattleofKingsInTheGame = class("SmCrossServerBattleofKingsInTheGameClass", Window)
SmCrossServerBattleofKingsInTheGame.__size = nil

local sm_cross_server_battleof_kings_in_the_game_window_open_terminal = {
    _name = "sm_cross_server_battleof_kings_in_the_game_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmCrossServerBattleofKingsInTheGame:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cross_server_battleof_kings_in_the_game_window_open_terminal)
state_machine.init()

function SmCrossServerBattleofKingsInTheGame:ctor()
    self.super:ctor()
    self.roots = {}

    self.prop_list = {}
    self.m_times = 0
    self.m_updateTime = 60
    self.m_listTime = 60
    self.isShow = true
    self.add_list = {}
    self.list_number = 0
    app.load("client.l_digital.cells.campaign.crossServerBattleofKings.sm_cross_server_battle_of_war_report_list_cell")

    local function init_sm_cross_server_battleof_kings_in_the_game_terminal()
		--显示界面
		local sm_cross_server_battleof_kings_in_the_game_show_terminal = {
            _name = "sm_cross_server_battleof_kings_in_the_game_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                self.isShow = true
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local sm_cross_server_battleof_kings_in_the_game_hide_terminal = {
            _name = "sm_cross_server_battleof_kings_in_the_game_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                self.isShow = false
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        local sm_cross_server_battleof_kings_in_the_game_update_draw_terminal = {
            _name = "sm_cross_server_battleof_kings_in_the_game_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addListDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_cross_server_battleof_kings_in_the_game_show_terminal)	
		state_machine.add(sm_cross_server_battleof_kings_in_the_game_hide_terminal)
        state_machine.add(sm_cross_server_battleof_kings_in_the_game_update_draw_terminal)

        state_machine.init()
    end
    init_sm_cross_server_battleof_kings_in_the_game_terminal()
end

function SmCrossServerBattleofKingsInTheGame:onHide()
    self:setVisible(false)
end

function SmCrossServerBattleofKingsInTheGame:onShow()
    self:setVisible(true)
end

function SmCrossServerBattleofKingsInTheGame:getTimeDesByInterval( timeInt )
    if timeInt <= 0 then
        timeInt = 0
    end
    local result = ""
    local oh     = math.floor(timeInt/3600)
    local om     = math.floor((timeInt - oh*3600)/60)
    local os     = math.floor(timeInt - oh*3600 - om*60)
    local hour = oh
    local day  = 0
    if(oh>=24) then
        day  = math.floor(hour/24)
        hour = oh - day*24
    end
    if(hour ~= 0) then
    end
    if(om ~= 0) then
        if(hour ~= 0) then
            om = om + hour*60
        end
        if om < 10 then
            om = "0"..om
        end
        result = result .. om .. ":"
    else
        if(hour ~= 0) then
            om = om + hour*60
            if om < 10 then
                om = "0"..om
            end
        else
            om = "00"
        end
        result = result .. om .. ":"     
    end
    if(os ~= 0) then
        if os < 10 then
            os = "0"..os
        end
        result = result .. os
    else
        result = result .. "00"
    end
    return result
end

function SmCrossServerBattleofKingsInTheGame:addListDraw(m_listTime)
    local root = self.roots[1]
    if zstring.tonumber(_ED.cross_server_kings_battle.war_report_number) ~= 0 then 
        local ListView_zk = ccui.Helper:seekWidgetByName(root, "ListView_zk")
        local m_index = 1
        local stopTime = m_listTime/((#_ED.cross_server_kings_battle.war_report_info-self.list_number)/2)
        for i = #self.add_list, 1, -1 do
            root:runAction(cc.Sequence:create({cc.DelayTime:create(stopTime*m_index), cc.CallFunc:create(function ( sender )
                self.oldInfex = tonumber(self.oldInfex) + 1
                local cell = state_machine.excute("sm_cross_server_battle_of_war_report_list_cell", 0, {self.oldInfex,self.add_list[i]})
                if self.oldInfex == 1 then
                    ListView_zk:addChild(cell)
                else
                    ListView_zk:insertCustomItem(cell, 0)
                end
                ListView_zk:requestRefreshView()
            end)}))
            m_index = m_index + 1
            if i == 1 then
                self.list_number = #_ED.cross_server_kings_battle.war_report_info
            end
        end
    end
end

function SmCrossServerBattleofKingsInTheGame:addUpdateDraw()
    local root = self.roots[1]
    local number = 1
    if _ED.cross_server_kings_battle.war_report_info[1] then
        number = _ED.cross_server_kings_battle.war_report_info[1].battleRound
    end
    
    if zstring.tonumber(_ED.cross_server_kings_battle.war_report_number) ~= 0 then 

        self:addListDraw(self.m_listTime)

        local Text_tips = ccui.Helper:seekWidgetByName(root, "Text_tips")

        if number >= 10 then
            number = 10
        end
        Text_tips:setString(string.format(_new_interface_text[222],number))

        local Panel_cc = ccui.Helper:seekWidgetByName(root, "Panel_cc")
        Panel_cc:removeBackGroundImage()
        Panel_cc:setBackGroundImage(string.format("images/ui/text/SMZB_res/turn_%d.png", number))
    end
end

function SmCrossServerBattleofKingsInTheGame:onUpdateDraw()
    local root = self.roots[1]
    local ListView_zk = ccui.Helper:seekWidgetByName(root, "ListView_zk")
    self.oldInfex = 0
    local function idCapacity(a,b)
        local al = zstring.tonumber(a.battleRound)
        local bl = zstring.tonumber(b.battleRound)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end
    
    local number = zstring.tonumber(_ED.cross_server_kings_battle.war_report_number)
    if _ED.cross_server_kings_battle.war_report_info ~= nil then
        local war_report_info = {}
        for i,v in pairs(_ED.cross_server_kings_battle.war_report_info) do
            table.insert(war_report_info, v)
            -- local isTheSame = false
            -- -- for j,w in pairs(war_report_info) do
            -- --     -- local combat_data_v =  json.decode(v.winner)
            -- --     -- local combat_data_w
            -- --     if tonumber(json.decode(v.winner).combatForce) == tonumber(json.decode(w.winner).combatForce) then
            -- --         isTheSame = true
            -- --     end
            -- -- end
            -- if isTheSame == false then
            --     table.insert(war_report_info, v)
            -- end
        end
        table.sort(war_report_info, idCapacity)
        _ED.cross_server_kings_battle.war_report_info = war_report_info
        self.add_list = {}
        for i,v in pairs(_ED.cross_server_kings_battle.war_report_info) do
            
            if i <= (#_ED.cross_server_kings_battle.war_report_info-self.list_number)/2 then
                self.oldInfex = self.oldInfex + 1
                local cell = state_machine.excute("sm_cross_server_battle_of_war_report_list_cell", 0, {self.oldInfex,v})
                if self.oldInfex == 1 then
                    ListView_zk:addChild(cell)
                else
                    ListView_zk:insertCustomItem(cell, 0)
                end
                ListView_zk:requestRefreshView()
            else
                table.insert(self.add_list, v)
            end
        end
    end

    local Text_tips = ccui.Helper:seekWidgetByName(root, "Text_tips")

    if number >= 9 then
        number = 9
    end

    Text_tips:setString(string.format(_new_interface_text[222],number+1))

    local Panel_cc = ccui.Helper:seekWidgetByName(root, "Panel_cc")
    Panel_cc:removeBackGroundImage()

    Panel_cc:setBackGroundImage(string.format("images/ui/text/SMZB_res/turn_%d.png", number+1))

    self.m_times = tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_next_time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))+0.5

    local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
    Text_time:setString(self:getTimeDesByInterval(self.m_times))

    --总时间 = 240*10
    --总时间-剩余时间 = 花了的时间
    --240-花了的时间%240 = 下次刷新时间
    self.m_updateTime = 240-(240*10-self.m_times)%240
    self.m_listTime = self.m_updateTime
    self:addUpdateDraw()
end

function SmCrossServerBattleofKingsInTheGame:onUpdate(dt)
    if self.m_times > 0 and self.isShow == true then
        self.m_times = self.m_times - dt
        ccui.Helper:seekWidgetByName(self.roots[1], "Text_time"):setString(self:getTimeDesByInterval(self.m_times))
    end
    if self.m_updateTime > 0 and self.isShow == true then
        self.m_updateTime = self.m_updateTime - dt
        if self.m_updateTime <= 0 then
            local function requesrDefendCheck(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    self.add_list = {}
                    local number = (#_ED.cross_server_kings_battle.war_report_info - self.list_number)/2
                    for i,v in pairs(_ED.cross_server_kings_battle.war_report_info) do
                        if i > self.list_number + number then
                            table.insert(self.add_list, v)
                        end
                    end
                    self:addUpdateDraw()
                end
                self.m_updateTime = 240-(240*10-self.m_times)%240
                self.m_listTime = self.m_updateTime
            end
            protocol_command.the_kings_battle_cross_base_get_battle_report.param_list = "0"
            NetworkManager:register(protocol_command.the_kings_battle_cross_base_get_battle_report.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  
        end
    end
end

function SmCrossServerBattleofKingsInTheGame:onEnterTransitionFinish()

end

function SmCrossServerBattleofKingsInTheGame:onInit( )
    local csbItem = csb.createNode("campaign/BattleofKingsX/battle_of_kings_x_tab_1_2.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    if SmCrossServerBattleofKingsInTheGame.__size == nil then
        SmCrossServerBattleofKingsInTheGame.__size = root:getContentSize()
    end
    self:setContentSize(SmCrossServerBattleofKingsInTheGame.__size)
    ccui.Helper:seekWidgetByName(root, "ListView_zk"):removeAllItems()
    ccui.Helper:seekWidgetByName(root, "Text_tips"):setString("")
    local function requesrDefendCheck(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            self:onUpdateDraw()
        else
            self:onUpdateDraw()
        end
    end
    protocol_command.the_kings_battle_cross_base_get_battle_report.param_list = "0"
    NetworkManager:register(protocol_command.the_kings_battle_cross_base_get_battle_report.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  
end

function SmCrossServerBattleofKingsInTheGame:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmCrossServerBattleofKingsInTheGame:onExit()
    state_machine.remove("sm_cross_server_battleof_kings_in_the_game_show")    
    state_machine.remove("sm_cross_server_battleof_kings_in_the_game_hide")
    state_machine.remove("sm_cross_server_battleof_kings_in_the_game_update_draw")
end
