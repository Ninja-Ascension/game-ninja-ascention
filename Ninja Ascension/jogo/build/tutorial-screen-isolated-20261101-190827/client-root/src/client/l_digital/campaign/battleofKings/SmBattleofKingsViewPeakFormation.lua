-----------------------------
-- 王者之战查看巅峰阵型
-----------------------------
SmBattleofKingsViewPeakFormation = class("SmBattleofKingsViewPeakFormationClass", Window)

--打开界面
local sm_battleof_kings_view_peak_formation_open_terminal = {
    _name = "sm_battleof_kings_view_peak_formation_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SmBattleofKingsViewPeakFormationClass") == nil then
            if ni ~= params and nil ~= params[1] then
                fwin:open(SmBattleofKingsViewPeakFormation:new():init(params), fwin._ui)    
            end 
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local sm_battleof_kings_view_peak_formation_close_terminal = {
    _name = "sm_battleof_kings_view_peak_formation_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmBattleofKingsViewPeakFormationClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_battleof_kings_view_peak_formation_open_terminal)
state_machine.add(sm_battleof_kings_view_peak_formation_close_terminal)
state_machine.init()

function SmBattleofKingsViewPeakFormation:ctor()
    self.super:ctor()
    self.roots = {}

    self.m_object = nil
    self.list_object = nil

    local function init_sm_battleof_kings_view_peak_formation_terminal()
        -- local sm_battleof_kings_view_peak_formation_change_page_terminal = {
            -- _name = "sm_battleof_kings_view_peak_formation_change_page",
            -- _init = function (terminal)
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
                -- instance:changeSelectPage(params._datas._page)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }

        -- state_machine.add(sm_battleof_kings_view_peak_formation_change_page_terminal)
        state_machine.init()
    end
    init_sm_battleof_kings_view_peak_formation_terminal()
end

function SmBattleofKingsViewPeakFormation:onUpdate(dt)
    if self.roots == nil or self.roots[1] == nil or self.cd_time == nil then
        return
    end
    self.cd_time = self.cd_time - dt
    if self.cd_time <= 60 then
        local function requesrDefendCheck(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                self:onUpdateDraw()
            else
                self:onUpdateDraw()    
            end
            self.cd_time = nil
        end
        protocol_command.the_kings_battle_manager.param_list = "5"
        NetworkManager:register(protocol_command.the_kings_battle_manager.code, nil, nil, nil, self, requesrDefendCheck, false, nil)
        -- self.cd_time = nil
    end
end

function SmBattleofKingsViewPeakFormation:onUpdateDraw()
    local root = self.roots[1]
    self.list_object = {}

    if self.isFomation then
        print("111111111111")
        self.m_object = _ED.kings_battle.peak_list[self.m_object.id] 
    end
    local speed_list = {}
    --模块ID:等级:进化状态:星级:品阶:战力:实例ID!下一个武将
    local formation_info = zstring.split(self.m_object.formation, "!")
    for i=1, #formation_info do
        local Panel_digimon_icon = ccui.Helper:seekWidgetByName(root,"Panel_digimon_icon_"..i)
        if formation_info[i] ~= nil then
            local datas = zstring.split(formation_info[i],":")
            local cell = ShipIconCell:createCell()
            local ships = {}
            ships.ship_template_id = datas[1]
            ships.evolution_status = datas[3]
            ships.Order = datas[5]
            ships.ship_grade = datas[2]
            ships.StarRating = datas[4]
            ships.skin_id = datas[11]
            cell:init(ships,12)
            Panel_digimon_icon:addChild(cell)
            --战力
            local BitmapFontLabel_fighting = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_fighting_"..i)
            BitmapFontLabel_fighting:setString(datas[6])
            table.insert(self.list_object, tonumber(datas[8]))
        end
    end
    for i=1,3 do
        local Text_sudu = ccui.Helper:seekWidgetByName(root,"Text_sudu_"..i)
        local speed = 0
        if i==1 then
            speed = tonumber(self.list_object[1]) + tonumber(self.list_object[2]) + tonumber(self.list_object[3])
        elseif i == 2 then
            speed = tonumber(self.list_object[4]) + tonumber(self.list_object[5]) + tonumber(self.list_object[6])
        elseif i == 3 then
            speed = tonumber(self.list_object[7]) + tonumber(self.list_object[8]) + tonumber(self.list_object[9])
        end
        Text_sudu:setString(speed)
    end
    local Text_player_name = ccui.Helper:seekWidgetByName(root,"Text_player_name")
    Text_player_name:setString(self.m_object.name)  

    local Text_zk_n = ccui.Helper:seekWidgetByName(root,"Text_zk_n")
    local result_info = zstring.split(self.m_object.result, "|")
    local win_number = 0
    local lose_number = 0
    for i,v in pairs(result_info) do
        local dataInfo = zstring.split(v, ",")
        if tonumber(dataInfo[1]) == 0 then
            lose_number = lose_number + 1
        elseif tonumber(dataInfo[1]) == 1 then
            win_number = win_number + 1
        end
    end
    local strs = string.format(_new_interface_text[201],zstring.tonumber(win_number),zstring.tonumber(lose_number))
    Text_zk_n:setString(strs)

    local Text_online = ccui.Helper:seekWidgetByName(root,"Text_online")
    if zstring.tonumber(self.m_object.is_offline) == 0 then
        Text_online:setString(_string_piece_info[268])
    else
        Text_online:setString(_string_piece_info[269])
    end

    local battle_result = zstring.split(self.m_object.result, "|")
    for i=11, #battle_result do
        local win = ccui.Helper:seekWidgetByName(root,"Image_win_"..(i-10))
        local lose = ccui.Helper:seekWidgetByName(root,"Image_lose_"..(i-10))
        if tonumber(zstring.split(battle_result[i], ",")[1]) == 1 then
            --胜利
            win:setVisible(true)
            lose:setVisible(false)
        elseif tonumber(zstring.split(battle_result[i], ",")[1]) == 0 then
            --失败
            win:setVisible(false)
            lose:setVisible(true)
        else
            win:setVisible(false)
            lose:setVisible(false)
        end
    end

    self.cd_time = tonumber(_ED.kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
end

function SmBattleofKingsViewPeakFormation:init(params)
    self.m_object = params[1]
    self.isFomation = params[2]
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function SmBattleofKingsViewPeakFormation:onInit()
    local csbItem = csb.createNode("campaign/BattleofKings/battle_of_kings_lineup_info_2.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_wzzz_back"), nil, 
    {
        terminal_name = "sm_battleof_kings_view_peak_formation_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    
    self:onUpdateDraw()
end

function SmBattleofKingsViewPeakFormation:onEnterTransitionFinish()
    
end


function SmBattleofKingsViewPeakFormation:onExit()
    state_machine.remove("sm_battleof_kings_view_peak_formation_change_page")
end

