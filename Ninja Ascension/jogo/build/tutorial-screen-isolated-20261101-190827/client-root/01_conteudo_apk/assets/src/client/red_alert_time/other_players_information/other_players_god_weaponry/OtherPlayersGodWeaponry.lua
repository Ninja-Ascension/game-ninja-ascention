-----------------------------
--神兵主界面
-----------------------------
OtherPlayersGodWeaponry = class("OtherPlayersGodWeaponryClass", Window)
-- 打开
local other_players_god_weaponry_window_open_terminal = {
    _name = "other_players_god_weaponry_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list = getOtherPlayersGodWeaponrySortForFight()
        if table.nums(list) == 0 then
            TipDlg.drawTextDailog(tipStringInfo_god_weaponry_info[5])
            return
        end
        local _Window = fwin:find("OtherPlayersGodWeaponryClass")
        if nil == _Window then
            fwin:open(OtherPlayersGodWeaponry:new():init(params), fwin._ui)
        end
        state_machine.excute("home_select_action_window_close", 0, nil)
        state_machine.excute("user_info_window_hide",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
-- 关闭
local other_players_god_weaponry_window_close_terminal = {
    _name = "other_players_god_weaponry_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("OtherPlayersGodWeaponryClass"))
        state_machine.excute("user_info_window_show",0,"")
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(other_players_god_weaponry_window_open_terminal)
state_machine.add(other_players_god_weaponry_window_close_terminal)
state_machine.init()

function OtherPlayersGodWeaponry:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.listview = nil
    self.listview_pox = 0
    --侠客信息
    self._choose_ship = nil

    -- load lua file
    app.load("client.red_alert_time.cells.hero.hero_icon_cell")
    app.load("client.red_alert_time.other_players_information.other_players_god_weaponry.OtherPlayersGodWeaponrySkillAtt")

    local function init_other_players_god_weaponry_terminal()
        -- 切换侠客
        local other_players_god_weaponry_change_ship_terminal = {
            _name = "other_players_god_weaponry_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= "" and params ~= nil then
                    instance._choose_ship = params 
                end
                instance:onUpdateDraw()
                instance:setHeroCellSelected(instance._choose_ship)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(other_players_god_weaponry_change_ship_terminal)
        state_machine.init()
    end
    
    init_other_players_god_weaponry_terminal()
end
-- 切换侠客
function OtherPlayersGodWeaponry:setHeroCellSelected(ship)
    for i,v in pairs(self.listview:getItems()) do 
        if v.ship == ship then
            v.isSelecet = true
            self._choose_ship = ship
            state_machine.excute("hero_icon_cell_set_seleceted",0,v)
        else
            if v.isSelecet == true then
                v.isSelecet = false
                state_machine.excute("hero_icon_cell_set_seleceted",0,v)
            end
        end
    end
end

function OtherPlayersGodWeaponry:onUpdateDraw()
    local root = self.roots[1]
    local Panel_genral_icon = ccui.Helper:seekWidgetByName(root, "Panel_genral_icon")   -- 神兵Image
    Panel_genral_icon:removeBackGroundImage()
    Panel_genral_icon:setVisible(false)
    local Panel_genral_icon_light = ccui.Helper:seekWidgetByName(root, "Panel_genral_icon_light")-- 神兵光效层
    Panel_genral_icon_light:removeAllChildren(true)
    local Panel_god_weaponry_name = ccui.Helper:seekWidgetByName(root, "Panel_god_weaponry_name")-- 神兵名字
    Panel_god_weaponry_name:removeBackGroundImage()
    local Panel_left_skill = ccui.Helper:seekWidgetByName(root, "Panel_left_skill")     -- 左侧技能面板
    Panel_left_skill:setVisible(false)
    local Panel_right_skill = ccui.Helper:seekWidgetByName(root, "Panel_right_skill")   -- 右侧属性面板
    Panel_right_skill:setVisible(false)
    local Panel_material = ccui.Helper:seekWidgetByName(root, "Panel_material")         -- 所需材料面板
    Panel_material:setVisible(false)
    local Text_no_task_info = ccui.Helper:seekWidgetByName(root, "Text_no_task_info")
    Text_no_task_info:setVisible(false)
    -- 神兵属性
    for i=1,4 do
        ccui.Helper:seekWidgetByName(root, "Text_attribute_"..i):setString("")
        ccui.Helper:seekWidgetByName(root, "Text_attribute_v_"..i):setString("")
    end

    if self._choose_ship == nil then
        return
    end
    local ship_mould_id = self._choose_ship.ship_template_id
    local god_info = nil
    local god_weaponry_id = 0
    if tonumber(self._choose_ship.god_weaponry) <= 0 then
        god_weaponry_id = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.super_equipment_mould_group_id)
    else
        god_weaponry_id = tonumber(self._choose_ship.god_weaponry)
    end
    god_info = _ED.god_weaponry_info[""..god_weaponry_id]
    if god_info == nil then
        return
    end
    Panel_left_skill:setVisible(true)
    Panel_right_skill:setVisible(true)
    Panel_genral_icon:setVisible(true)
    for i=1,10 do
        local Panel_skill_infor = ccui.Helper:seekWidgetByName(root, "Panel_skill_infor_"..i)
        if god_info.level_group_id > i then
            display:ungray(Panel_skill_infor:getChildByName("Sprite_skill_picture_"..i))
        elseif god_info.level_group_id == i then
            if god_info.id > 1
                and (god_info.grow_up_id == -1 
                or _ED.god_weaponry_info[""..(god_info.id - 1)].level == god_info.level) then
                display:ungray(Panel_skill_infor:getChildByName("Sprite_skill_picture_"..i))
            else
                display:gray(Panel_skill_infor:getChildByName("Sprite_skill_picture_"..i))
            end
        else
            display:gray(Panel_skill_infor:getChildByName("Sprite_skill_picture_"..i))
        end
    end
    -- 神兵等级
    local Text_skill_lv = ccui.Helper:seekWidgetByName(root, "Text_skill_lv")  
    Text_skill_lv:setString(god_info.level)
    -- 神兵光效动画
    local baseName = "images/ui/effice/effect_shenbing/effect_shenbing"
    local quality_sp = sp.spine(baseName..".json", baseName..".atlas", 1, 0, nil, false, nil)
    local animationName = "animation"..god_info.level_group_id
    if god_info.level_group_id == 11 then
        animationName = "animation10"
    end
    if tonumber(self._choose_ship.god_weaponry) <= 0 then
        animationName = "animation0"
    end
    quality_sp:setAnimation(0, animationName, true)
    quality_sp:setPosition(cc.p(Panel_genral_icon_light:getContentSize().width/2, 0))
    Panel_genral_icon_light:addChild(quality_sp)
    Panel_genral_icon:getChildByName("Sprite_icon"):setTexture(string.format("images/ui/god_weaponry_icon/god_icon_%d.png", god_info.spx))
    
    Panel_god_weaponry_name:setBackGroundImage(string.format("images/ui/god_weaponry_icon/god_weaponry_name_%d.png", god_info.spx))
    
    local talent_id = god_info.talent_id
    local last_god_weaponry = nil
    for k,v in pairs(_ED.god_weaponry_info) do
        if tonumber(v.group_id) == tonumber(god_info.group_id) 
            and tonumber(v.level_group_id) == tonumber(god_info.level_group_id)
            then
            if last_god_weaponry == nil then
                last_god_weaponry = v
            end
            if last_god_weaponry.grow_up_id < v.grow_up_id then
                last_god_weaponry = v
            end
        end
    end
    if tonumber(last_god_weaponry.id) == tonumber(god_info.id) then
        talent_id = _ED.god_weaponry_info[""..last_god_weaponry.grow_up_id].talent_id
    end

    local talentMould = dms.element(dms["talent_mould"], talent_id)
    -- 神兵技能描述
    local Text_attribute_introduce = ccui.Helper:seekWidgetByName(root, "Text_attribute_introduce")
    local talent_describe = dms.atos(talentMould, talent_mould.talent_describe)
    Text_attribute_introduce:setString(talent_describe)
    -- 神兵属性
    local base_additional = dms.atos(talentMould, talent_mould.base_additional)
    if base_additional ~= "-1" then
        base_additional = zstring.split(base_additional, "|")
        for i,v in ipairs(base_additional) do
            if i > 4 then
                break
            end
            local data = zstring.split(v,",")
            local types = tonumber(data[1]) + 1
            local adds = data[2]
            ccui.Helper:seekWidgetByName(root, "Text_attribute_"..i):setString(attribute[types])
            ccui.Helper:seekWidgetByName(root, "Text_attribute_v_"..i):setString(adds)
        end
    end
    -- 神兵激活设置高亮
    if tonumber(self._choose_ship.god_weaponry) <= 0 then
        display:gray(Panel_genral_icon:getChildByName("Sprite_icon"))

    else
        display:ungray(Panel_genral_icon:getChildByName("Sprite_icon"))
    end
    -- 打开神兵技能详情
    for i=1,10 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_skill_"..i), nil, 
        {
            terminal_name = "other_players_god_weaponry_skill_att_window_open", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i,
            choose_ship = self._choose_ship,
        }, nil, 0)
    end
end

function OtherPlayersGodWeaponry:updateDrawHeroIcon()
    local root = self.roots[1]
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root, "ListView_hero_icon")
    ListView_hero_icon:removeAllItems()
    local result = {}
    local result = getOtherPlayersGodWeaponrySortForFight()
    for k,v in pairs(result) do
        local cell = state_machine.excute("hero_icon_create_cell",0,{v,12,k})
        ListView_hero_icon:addChild(cell)
        if self._choose_ship == nil then
            self._choose_ship = v
        end
    end

    ListView_hero_icon:requestRefreshView()
    self.listview = ListView_hero_icon
    self.listview_pox = ListView_hero_icon:getInnerContainer():getPositionX()
    ListView_hero_icon:getInnerContainer():setPositionX(0)

    self:onUpdateDraw()
    if self._choose_ship ~= nil then
        self:setHeroCellSelected(self._choose_ship)
    end
end

function OtherPlayersGodWeaponry:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posx = self.listview:getInnerContainer():getPositionX()
        if self.listview_pox == posx then
            return
        end
        self.listview_pox = posx
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempx = v:getPositionX() + posx
            if tempx + itemSize.width * 2 < 0 or tempx > size.width + itemSize.width * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function OtherPlayersGodWeaponry:onEnterTransitionFinish()
    
end

function OtherPlayersGodWeaponry:onInit( )
    local csbItem = csb.createNode(config_csb.god_weaponry.god_weaponry)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.god_weaponry.god_weaponry)
    action:setTimeSpeed(app.getTimeSpeed())
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("animation_icon", true)

    -- 前往
    local Button_go = ccui.Helper:seekWidgetByName(root, "Button_go")
    Button_go:setVisible(false)
    -- 打造神兵
    local Button_storage = ccui.Helper:seekWidgetByName(root, "Button_storage")
    Button_storage:setVisible(false)
    --锻造
    local Button_refining = ccui.Helper:seekWidgetByName(root, "Button_refining")
    Button_refining:setVisible(false)
    -- 进阶
    local Button_breakthrough = ccui.Helper:seekWidgetByName(root, "Button_breakthrough")
    Button_breakthrough:setVisible(false)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "other_players_god_weaponry_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 解析神兵技能
    if _ED.god_weaponry_info == nil or table.nums(_ED.god_weaponry_info) == 0 then
        initAllGodWeaponryData()
    end
    self:updateDrawHeroIcon()
end

function OtherPlayersGodWeaponry:init(params)
    if params ~= nil and params ~= "" then
        self._choose_ship = params
    end
	self:onInit()
    return self
end

function OtherPlayersGodWeaponry:onExit()
end

function getOtherPlayersGodWeaponrySortForFight()
    local result = {}
    for i,v in pairs(_ED.other_user_ship) do
        if tonumber(v.little_partner_formation_index) <= 0 then
            local initial_rank_level = dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.initial_rank_level)
            local ship_type = dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.ship_type)
            if initial_rank_level >= 6 and ship_type >= 4 then
                table.insert(result, v)
            end
        end
    end
    return result
end
