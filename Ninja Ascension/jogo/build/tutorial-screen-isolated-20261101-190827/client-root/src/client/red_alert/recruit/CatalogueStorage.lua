-- ----------------------------------------------------------------------------------------------------
-- 说明将星录
-------------------------------------------------------------------------------------------------------
CatalogueStorage = class("CatalogueStorageClass", Window)

--打开将星录
local catalogue_storage_window_open_terminal = {
    _name = "catalogue_storage_window_open",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(104) == true then
            return
        end
        if nil == fwin:find("CatalogueStorageClass") then
            fwin:open(CatalogueStorage:new():init(), fwin._view)
        else
            state_machine.excute("catalogue_storage_window_show", 0, "")
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local catalogue_storage_window_close_terminal = {
    _name = "catalogue_storage_window_close",
    _init = function (terminal)

    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CatalogueStorageClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(catalogue_storage_window_open_terminal)
state_machine.add(catalogue_storage_window_close_terminal)
state_machine.init()
function CatalogueStorage:ctor()
    self.super:ctor()
    self.roots = {}
    self.action = nil
    
    self._list_view = nil
    self._list_view_posY = 0

    app.load("client.red_alert.cells.hero.hero_icon_cell")
    app.load("client.red_alert.cells.recruit.catalogue_storage_cell")
    app.load("client.red_alert.cells.recruit.catalogue_storage_title_cell")

    app.load("client.red_alert.other_players_information.other_players_hero.OtherPlayersHeroMain")
    app.load("client.red_alert.other_players_information.other_players_hero.OtherPlayersHeroAttributes")
    app.load("client.red_alert.other_players_information.other_players_hero.OtherPlayersHeroFetters")
    app.load("client.red_alert.other_players_information.other_players_hero.OtherPlayersHeroMainGrowUp")
    app.load("client.red_alert.other_players_information.other_players_hero.OtherPlayersHeroMainSkillsUp")
    app.load("client.red_alert.other_players_information.other_players_hero.OtherPlayersHeroMainStarUp")

    local function init_catalogue_storage_terminal()
        local catalogue_storage_choose_on_ship_terminal = {
            _name = "catalogue_storage_choose_on_ship",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if fwin:find("CatalogueStorageClass") ~= nil then
                    local result = instance:parseOneShip(params)
                    state_machine.excute("other_players_hero_main_window_open", 0, result)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --显示所有
        local catalogue_storage_window_show_terminal = {
            _name = "catalogue_storage_window_show",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 隐藏所有
        local catalogue_storage_window_hide_terminal = {
            _name = "catalogue_storage_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(catalogue_storage_choose_on_ship_terminal)
        state_machine.add(catalogue_storage_window_show_terminal)
        state_machine.add(catalogue_storage_window_hide_terminal)
        state_machine.init()
    end
    
    init_catalogue_storage_terminal()
end

function CatalogueStorage:onShow()
   self:setVisible(true)
end

function CatalogueStorage:onHide()
   self:setVisible(false)
end
function CatalogueStorage:parseOneShip( ship_mould_id )
    local usership = {}
    local ship_data = dms.element(dms["ship_mould"], ship_mould_id)
    usership.ship_id=ship_mould_id
    usership.ship_template_id=ship_mould_id
    usership.ship_base_template_id = dms.atos(ship_data, ship_mould.base_mould)
    usership.hero_fight = dms.atos(ship_data, ship_mould.initial_courage)    --英雄战斗力
    usership.ship_health= dms.atos(ship_data, ship_mould.initial_power)      --战船体力值 
    usership.key_ship_health = dms.atos(ship_data, ship_mould.initial_courage)
    usership.ship_courage= dms.atos(ship_data, ship_mould.initial_courage)  --战船勇气值
    usership.attack_speed = dms.atos(ship_data, ship_mould.speed)             --攻速
    usership.gas_gather = dms.atos(ship_data, ship_mould.have_deadly)       --聚气
    usership.key_gas_gather = 0
    usership.ship_quick = dms.atos(ship_data, ship_mould.initial_intellect)        --物防
    usership.ship_intellect = dms.atos(ship_data, ship_mould.initial_nimable)     --法防
    usership.hit = dms.atos(ship_data, ship_mould.initial_accuracy)                --命中
    usership.dodge = dms.atos(ship_data, ship_mould.initial_jink)              --闪躲
    usership.crit = dms.atos(ship_data, ship_mould.initial_critical)               --暴击
    usership.toughness = dms.atos(ship_data, ship_mould.initial_critical_resist)    --韧性
    usership.block = dms.atos(ship_data, ship_mould.initial_retain)             --格挡
    usership.wreck = dms.atos(ship_data, ship_mould.initial_retain_break)      --破击
    usership.add_damage = 0                                                 --加伤
    usership.lessen_damage = 0                                               --减伤
    usership.deadly_strike_persent = 0       --必杀百分比
    usership.strong_persent = 0              --强韧百分比
    usership.by_cure_persent = 0             --疗效百分比
    usership.damage_add_persent = 0          --加伤百分比
    usership.damage_sub_persent = 0          --减伤百分比
    usership.final_damage_add_persent = 0    --伤害增加百分比
    usership.final_damage_sub_persent = 0    --伤害减少百分比

    usership.equipment = 
        {
            {user_equiment_id = 0},
            {user_equiment_id = 0},
            {user_equiment_id = 0},
            {user_equiment_id = 0},
            {user_equiment_id = 0},
            {user_equiment_id = 0},
        }
    usership.talent_state = "0"                     --天赋激活状态
    usership.fetters_state = "0"                         --羁绊激活状态
    local star_id_str = dms.string(dms["ship_mould"],usership.ship_template_id,ship_mould.star_id_tab)
    local star_id_tab = zstring.split(star_id_str,",")
    usership.stars_state = {                        --当前星格点亮状态
        {star_id = star_id_tab[1], state = 0},
        {star_id = star_id_tab[2], state = 0},
        {star_id = star_id_tab[3], state = 0},
        {star_id = star_id_tab[4], state = 0},
        {star_id = star_id_tab[5], state = 0},
        {star_id = star_id_tab[6], state = 0},
    }
    usership.little_partner_formation_index = 0
    usership.rider_horse_id = 0 --骑乘战马id
    usership.ship_level = 0    --英雄等级
    usership.skill_grow_up_states = {"0"}--zstring.split(npos(list),",")--英雄技能突破等级
    usership.skill_grow_up_level = 0
    for i, v in pairs(usership.skill_grow_up_states) do
        if v == "1" then
            usership.skill_grow_up_level = i
        end
    end
    usership.talents = {}
    usership.relationship = {}
    usership.camp_preference = 0
    usership.capacity = 0
    usership.talent_count = 0
    local captain_name = dms.atos(ship_data, ship_mould.captain_name)
    local ship_type = dms.atoi(ship_data, ship_mould.ship_type)
    local camp_preference = dms.atoi(ship_data, ship_mould.camp_preference)
    local capacity = dms.atoi(ship_data, ship_mould.capacity)
    local talent_str = dms.atos(ship_data, ship_mould.talent_id)
    local talent_tab = zstring.split(talent_str, "|")
    local talent_state_tab = zstring.split(usership.talent_state, ",")
    for i,v in pairs(talent_tab) do
        local talent_id_tab = zstring.split(v, ",")
        local talent_id_t = talent_id_tab[3]    
        usership.talents[i] = 
        {
            talent_id = talent_id_t,
            is_activited = "-1"--talent_state_tab[i]
        }
    end

    usership.talent_count = #talent_tab
    local relationship_id_str = dms.atos(ship_data, ship_mould.relationship_id)
    local relationship_id_tab = zstring.split(relationship_id_str,",")
    local relationship_state_tab = zstring.split(usership.fetters_state,"|")
    for j,k in pairs(relationship_id_tab) do
        usership.relationship[j] =  usership.relationship[j] or {}
        usership.relationship[j].is_activited = {}
        usership.relationship[j].relationship_id = k
        local fateRelationshipMould = dms.element(dms["fate_relationship_mould"], k)
        for i=1,4 do
            local need = dms.atoi(fateRelationshipMould, fate_relationship_mould.relation_need1 + (i - 1) * 2)
            if need > 0 then
                table.insert(usership.relationship[j].is_activited, "-1")
            end
        end
    end
    usership.relationship_count = #relationship_id_tab
    usership.captain_name = captain_name
    usership.ship_type = ship_type
    usership.camp_preference = camp_preference
    usership.capacity = capacity
    return usership
end

function CatalogueStorage:onEnterTransitionFinish()

end

function CatalogueStorage:onUpdateDraw()
    if _ED.catalogue_storage_datas == nil or table.nums(_ED.catalogue_storage_datas) == 0 then
        initCatalogueStorageDatas()
    end
    local root = self.roots[1]
    self._list_view = ccui.Helper:seekWidgetByName(root,"ScrollView_catalogue_storage")
    self._list_view:removeAllChildren(true)

    local line_max_count = 5
    local max_line = 0
    if _ED.catalogue_storage_total_count % line_max_count == 0 then
        max_line = _ED.catalogue_storage_total_count / line_max_count
    else
        max_line = math.floor(_ED.catalogue_storage_total_count / line_max_count) + 1
    end
    local panel_cell = state_machine.excute("catalogue_storage_cell_create", 0, nil)
    local title_cell = state_machine.excute("catalogue_storage_title_cell_create", 0, nil)
    local total_height = panel_cell:getContentSize().height * max_line + _ED.catalogue_storage_total_line * title_cell:getContentSize().height
    local current_height = total_height
    local cacher_index = 0
    for i,list in pairs(_ED.catalogue_storage_datas) do
        local title = state_machine.excute("catalogue_storage_title_cell_create", 0, {i, cacher_index})
        self._list_view:addChild(title)
        current_height = current_height - title:getContentSize().height
        title:setPosition(cc.p(0, current_height))
        local index = 0
        for j,shipData in pairs(list) do
            if index == 5 then
                index = 0
            end
            if index == 0 then
                local result = {list[j], list[j+1], list[j+2], list[j+3], list[j+4]}
                local panel = state_machine.excute("catalogue_storage_cell_create", 0, {result, cacher_index})
                self._list_view:addChild(panel)
                panel:setPosition(cc.p(0, current_height))
                current_height = current_height - panel:getContentSize().height
                cacher_index = cacher_index + 1
            end
            index = index + 1
        end
    end

    self._list_view:getInnerContainer():setContentSize(cc.size(
        self._list_view:getContentSize().width, total_height))
    self._list_view:jumpToTop()

    self._list_view_posY = self._list_view:getInnerContainer():getPositionY()
end

function CatalogueStorage:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self.list_view_posY == posY then
            return
        end
        self.list_view_posY = posY
        local items = self._list_view:getChildren()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + 150 * 2 < 0 or tempY > 150 + 150 * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function CatalogueStorage:onInit()
    local csbItem = csb.createNode(config_csb.recruit.catalogue_storage)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "catalogue_storage_window_close",        
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw()
end

function CatalogueStorage:init()
    self:onInit()
    return self
end

function CatalogueStorage:onExit()
    state_machine.remove("catalogue_storage_choose_on_ship")
    state_machine.remove("catalogue_storage_window_show")
    state_machine.remove("catalogue_storage_window_hide")
end