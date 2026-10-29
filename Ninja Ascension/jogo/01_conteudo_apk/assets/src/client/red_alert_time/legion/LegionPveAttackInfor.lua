--------------------------------------------------------------------------------------------------------------
--  军团副本出击界面
--------------------------------------------------------------------------------------------------------------
LegionPveAttackInfor = class("LegionPveAttackInforClass", Window)

--打开界面
local legion_pve_attack_infor_open_terminal = {
    _name = "legion_pve_attack_infor_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("LegionPveAttackInforClass") == nil then
            fwin:open(LegionPveAttackInfor:new():init(params), fwin._ui)  
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_pve_attack_infor_close_terminal = {
    _name = "legion_pve_attack_infor_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionPveAttackInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_pve_attack_infor_open_terminal)
state_machine.add(legion_pve_attack_infor_close_terminal)
state_machine.init()

function LegionPveAttackInfor:ctor()
    self.super:ctor()
    self.roots = {}
    
    -- npc id
    self._npc_id = 0
    -- 场景id
    self._scene_id = 0

    self._index = 0

    self._decompose_1 = false 
    self._decompose_2 = false  

    self._seat_info = {}

    self._union_pve_info = nil 

    self._isNeedChangeOneState = nil
    self._isNeedChangeTwoState = nil

    -- Initialize legion_pve_attack_infor state machine.
    local function init_legion_pve_attack_infor_terminal()
        -- 攻击
        local legion_pve_attack_infor_begin_fight_terminal = {
            _name = "legion_pve_attack_infor_begin_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local attack_times = dms.int(dms["base_consume"], 95, base_consume.vip_0_value + tonumber(_ED.vip_grade))   -- 总攻击次数
                local leave_times = attack_times - _ED.union_pve_attack_times  -- 剩余攻击次数
                if leave_times <= 0 then
                    TipDlg.drawTextDailog(tipString_legion_info[40])
                    state_machine.excute("legion_pve_attack_infor_close", 0, 0)
                    return
                end
                local prop_ids = zstring.split(dms.string(dms["prop_config"], 32, prop_config.param), ",")
                local prop_id_1 = 0 
                local prop_id_2 = 0 
                -- if instance._decompose_1:isSelected() == true then
                --     prop_id_1 = prop_ids[1]
                -- end
                -- if instance._decompose_2:isSelected() == true then
                --     prop_id_2 = prop_ids[2]
                -- end

                _ED._battle_init_type = battle_enum._fight_type._fight_type_107
                _ED._current_scene_id = instance._scene_id
                _ED._scene_npc_id = instance._npc_id
                _ED._npc_difficulty_index = self._index - 1
                _ED._npc_formation_info = instance._seat_info
                _ED._npc_use_props = prop_id_1..","..prop_id_2
                state_machine.excute("formation_window_open",0,{_datas = {form_type = 6}})
                state_machine.excute("legion_pve_attack_infor_close", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_pve_attack_infor_begin_fight_terminal)
        state_machine.init()
    end
    
    -- call func legion_pve_attack_infor create state machine.
    init_legion_pve_attack_infor_terminal()

end

function LegionPveAttackInfor:onUpdate( dt )
    if self._isNeedChangeOneState == true then
        self._isNeedChangeOneState = false
        self._decompose_1:setSelected(false)
    end
    if self._isNeedChangeTwoState == true then
        self._isNeedChangeTwoState = false
        self._decompose_2:setSelected(false)
    end
end

function LegionPveAttackInfor:updateCheckBoxState( index )
    local prop_ids = zstring.split(dms.string(dms["prop_config"], 32, prop_config.param), ",")
    for k,v in pairs(prop_ids) do
        if k == index then
            local prop_count = 0 
            if fundPropWidthId(v) ~= nil then 
                local token = fundPropWidthId(v)
                prop_count = zstring.tonumber(token.prop_number)
            end
            if zstring.tonumber(prop_count) <= 0 then
                TipDlg.drawTextDailog(tipString_legion_info[50])
                if index == 1 then
                    self._isNeedChangeOneState = true
                else
                    self._isNeedChangeTwoState = true
                end
            end
        end
    end
end

function LegionPveAttackInfor:updateDraw()
    local root = self.roots[1]
    local ListView_pve_attack = ccui.Helper:seekWidgetByName(root, "ListView_pve_attack")
    self._list_view = ListView_pve_attack
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    local Text_attack_time_n = ccui.Helper:seekWidgetByName(root, "Text_attack_time_n")
    local attack_times = dms.int(dms["base_consume"], 95, base_consume.vip_0_value + tonumber(_ED.vip_grade))   -- 总攻击次数
    local leave_times = attack_times - _ED.union_pve_attack_times  -- 剩余攻击次数
    Text_attack_time_n:setString(leave_times.."/"..attack_times)

    local Text_legion_pve_npc = ccui.Helper:seekWidgetByName(root, "Text_legion_pve_npc")
    local npc_name = dms.string(dms["npc"], self._npc_id, npc.npc_name)
    Text_legion_pve_npc:setString(npc_name)

    self:addEnemyTroops()
    self:addBeatReward()
    -- self:addLegionProps()

    self._list_view:requestRefreshView()
end

-- 添加兵种基本信息
function LegionPveAttackInfor:addEnemyTroops()
    local csbItem = csb.createNode(string.format(config_csb.cells.legion.legion_pve_attack_infor_cell, 1))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)
    table.insert(self.roots, root)
    
    local formation_info = dms.element(dms["environment_formation"], self._npc_id)
    local seat_one = dms.atoi(formation_info, environment_formation.seat_one)
    local seat_two = dms.atoi(formation_info, environment_formation.seat_two)
    local seat_three = dms.atoi(formation_info, environment_formation.seat_three)
    local seat_four = dms.atoi(formation_info, environment_formation.seat_four)
    local seat_five = dms.atoi(formation_info, environment_formation.seat_five)
    local seat_six = dms.atoi(formation_info, environment_formation.seat_six)
    local seat_info = {seat_one,seat_two,seat_three,seat_four,seat_five,seat_six}
    self._seat_info = seat_one..","..seat_two..","..seat_three..","..seat_four..","..seat_five..","..seat_six
    for i=1,6 do
        local Panel_formation_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_formation_tank_icon_"..i)
        local Panel_formation_position = ccui.Helper:seekWidgetByName(root, "Panel_formation_position_"..i)
        Panel_formation_tank_icon:removeBackGroundImage()
        Panel_formation_position:removeBackGroundImage()
        local Text_formation_tank_n = ccui.Helper:seekWidgetByName(root, "Text_formation_tank_n_"..i)
        local Text_formation_tank_name = ccui.Helper:seekWidgetByName(root, "Text_formation_tank_name_"..i)
        local LoadingBar_boold_bar = ccui.Helper:seekWidgetByName(root, "LoadingBar_boold_bar_"..i)
        
        local ship_data = dms.element(dms["environment_ship"], seat_info[i])
        local ship_name = dms.atos(ship_data, environment_ship.ship_name)
        local pic_index = dms.atoi(ship_data, environment_ship.pic_index)
        local quality = dms.atoi(ship_data, environment_ship.ship_type)
        local level = dms.atoi(ship_data, environment_ship.level)
        local camp_preference = dms.atoi(ship_data, environment_ship.camp_preference)
        local progress = 100
        local have_times = level
        if tonumber(self._union_pve_info.formation_info) == nil then
            local formation_seat_info = zstring.split(self._union_pve_info.formation_info, "|")
            local npc_info = zstring.split(formation_seat_info[i], ",")
            progress = npc_info[3] / level * 100
            have_times = npc_info[3]
        end

        Text_formation_tank_name:setString(ship_name)
        Text_formation_tank_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
        Panel_formation_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, pic_index))
        Panel_formation_position:setBackGroundImage(string.format(config_res.images.ui.icon.icon, camp_preference + 114))
        Text_formation_tank_n:setString(have_times)
        LoadingBar_boold_bar:setPercent(progress)
    end
end

-- 击败奖励
function LegionPveAttackInfor:addBeatReward()
    local csbItem = csb.createNode(string.format(config_csb.cells.legion.legion_pve_attack_infor_cell, 2))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)
    table.insert(self.roots, root)
    local Text_attack_reward_infor = ccui.Helper:seekWidgetByName(root,"Text_attack_reward_infor")
    local drop_library = dms.int(dms["npc"], self._npc_id, npc.drop_library)
    local str = ""
    if drop_library > 0 then
        reward_items = dms.string(dms["scene_reward"], drop_library, scene_reward.reward_items)
        reward_items = zstring.split(reward_items,"|")
        for i,reward in pairs(reward_items) do
            local reward_tab = zstring.split(reward,",")
            local prop_item = tonumber(reward_tab[1])
            if prop_item == -1 then
                prop_item = resource_prop_id[tonumber(reward_tab[2])]
            end
            local prop_name = dms.string(dms["prop_mould"], prop_item, prop_mould.prop_name)
            if i == #reward_items then
                if tonumber(reward_tab[3]) > 0 then
                    str = str .. prop_name .."+"..reward_tab[3]
                else
                    str = str .. prop_name
                end
            else
                if tonumber(reward_tab[3]) > 0 then
                    str = str .. prop_name .."+"..reward_tab[3].."、"
                else
                    str = str .. prop_name .."、"
                end
            end
        end
    end
    Text_attack_reward_infor:setString(tipString_legion_info[38]..str)
end

-- 军团道具
function LegionPveAttackInfor:addLegionProps()
    local csbItem = csb.createNode(string.format(config_csb.cells.legion.legion_pve_attack_infor_cell, 3))
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self._list_view:addChild(root)
    table.insert(self.roots, root)

    local prop_ids = zstring.split(dms.string(dms["prop_config"], 32, prop_config.param), ",")
    for i=1,2 do
        local CheckBox_legion_props = ccui.Helper:seekWidgetByName(root, "CheckBox_legion_props_"..i)
        CheckBox_legion_props:setSelected(false)
        local function onOpenTouchEvent(sender, eventType)
            if eventType == ccui.TouchEventType.ended then
                self:updateCheckBoxState(i)
            end
        end
        CheckBox_legion_props:addTouchEventListener(onOpenTouchEvent)
        if i == 1 then
            self._decompose_1 = CheckBox_legion_props
        else
            self._decompose_2 = CheckBox_legion_props
        end

        local prop_id = prop_ids[i]
        local Panel_legion_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_legion_props_icon_"..i)
        Panel_legion_props_icon:removeAllChildren(true)
        local cell = state_machine.excute("props_icon_create_cell",0,{1,1,prop_id,1})
        Panel_legion_props_icon:addChild(cell) 

        local Text_legion_props_infor = ccui.Helper:seekWidgetByName(root,"Text_legion_props_infor_"..i)
        local remarks = dms.string(dms["prop_mould"], prop_id, prop_mould.remarks)
        Text_legion_props_infor:setString(remarks)

        local Text_legion_props_have_n = ccui.Helper:seekWidgetByName(root,"Text_legion_props_have_n_"..i)
        local prop_count = 0 
        if fundPropWidthId(prop_id) ~= nil then 
            local token = fundPropWidthId(prop_id)
            prop_count = zstring.tonumber(token.prop_number)
        end
        Text_legion_props_have_n:setString(prop_count)
    end
end

function LegionPveAttackInfor:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_pve_attack_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_pve_attack_close"), nil, 
    {
        terminal_name = "legion_pve_attack_infor_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)

    -- 攻击
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_pve_attack"), nil, 
    {
        terminal_name = "legion_pve_attack_infor_begin_fight",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    self:updateDraw()
end

function LegionPveAttackInfor:onEnterTransitionFinish()
    
end

function LegionPveAttackInfor:init(params)
    self._npc_id = params[1]
    self._scene_id = params[2]
    self._index = params[3]
    self._union_pve_info = params[4]
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function LegionPveAttackInfor:onExit()
    state_machine.remove("legion_pve_attack_infor_begin_fight")
end