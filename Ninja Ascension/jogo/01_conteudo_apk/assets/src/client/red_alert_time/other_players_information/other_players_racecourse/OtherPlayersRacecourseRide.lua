-----------------------------
--装备珍兽
-----------------------------
OtherPlayersRacecourseRide = class("OtherPlayersRacecourseRideClass", Window)
--打开
local other_players_racecourse_ride_window_open_terminal = {
    _name = "other_players_racecourse_ride_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(87) == true then
            return
        end
        state_machine.excute("home_select_action_window_close",0,"")
        state_machine.excute("user_info_window_hide",0,"")
        local _RacecourseWindow = fwin:find("OtherPlayersRacecourseRideClass")
        if nil == _RacecourseWindow then
            fwin:open(OtherPlayersRacecourseRide:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local other_players_racecourse_ride_window_close_terminal = {
    _name = "other_players_racecourse_ride_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("OtherPlayersRacecourseRideClass"))
        state_machine.excute("user_info_window_show",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(other_players_racecourse_ride_window_open_terminal)
state_machine.add(other_players_racecourse_ride_window_close_terminal)
state_machine.init()

function OtherPlayersRacecourseRide:ctor()
    self.super:ctor()
    self.roots = {}

    -- 用户阵上侠客信息
    self._user_ships = {}
    -- 当前侠客信息
    self.ship = nil
    --英雄icon列表
    self._listview = nil 
    --列表x轴
    self._listview_pox = nil

    -- load lua file
    app.load("client.red_alert_time.other_players_information.other_players_racecourse.OtherPlayersRacecourseAttribute")
    app.load("client.red_alert_time.other_players_information.other_players_racecourse.other_players_racecourse_ride_skill_cell")
    app.load("client.red_alert_time.cells.hero.hero_icon_cell")

    -- Initialize other_players_racecourse_ride state machine.
    local function init_other_players_racecourse_ride_terminal()
        -- 改变英雄
        local other_players_racecourse_ride_change_ship_terminal = {
            _name = "other_players_racecourse_ride_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= "" and params ~= nil then
                    instance.ship = params 
                end
                instance:setHeroCellSelected(instance.ship)
                instance:updateInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(other_players_racecourse_ride_change_ship_terminal)
    end
    init_other_players_racecourse_ride_terminal()
end

function OtherPlayersRacecourseRide:updateInfo()
    local root = self.roots[1]
    local horse = _ED.other_horses[""..self.ship.rider_horse_id]

    local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
    Text_2:setString("")
    local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
    Panel_star:removeAllChildren(true)
    local Panel_horse_picture = ccui.Helper:seekWidgetByName(root, "Panel_horse_picture")
    Panel_horse_picture:removeAllChildren(true)
    local Image_point = ccui.Helper:seekWidgetByName(root, "Image_point")
    local actions = cc.RepeatForever:create(cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(self._pos_x, self._pos_y+30)),cc.MoveTo:create(0.3, cc.p(self._pos_x, self._pos_y))))
    Image_point:stopAllActions()
    Image_point:runAction(actions)

    for i=3,6 do
        for j=1,6 do
            local Panel_skill = ccui.Helper:seekWidgetByName(root, "Panel_skill_"..i.."_"..j)
            if Panel_skill ~= nil then
                Panel_skill:removeAllChildren(true)
            end
        end
        ccui.Helper:seekWidgetByName(root, "Panel_choose_soul_"..i):setVisible(false)
    end
    if horse ~= nil then
        local name = dms.string(dms["horse_mould"], horse.mould_id, horse_mould.horse_name)
        local body_icon = dms.int(dms["horse_mould"], horse.mould_id, horse_mould.body_icon)
        local star = dms.int(dms["horse_mould"], horse.mould_id, horse_mould.star)
        local quality = dms.int(dms["horse_mould"], horse.mould_id, horse_mould.quality)
        local max_horse_spirit = dms.int(dms["horse_mould"], horse.mould_id, horse_mould.max_horse_spirit)
        ccui.Helper:seekWidgetByName(root, "Panel_choose_soul_"..max_horse_spirit):setVisible(true)
        for i=1,max_horse_spirit do
            local Panel_skill = ccui.Helper:seekWidgetByName(root, "Panel_skill_"..max_horse_spirit.."_"..i)
            Panel_skill:removeAllChildren(true)
            Panel_skill:addChild(state_machine.excute("other_players_racecource_ride_skill_create_cell", 0, {i, horse, self.ship}))
        end

        local baseName = "sprite/spirte_" .. body_icon
        local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
        skeletonNode:registerSpineEventHandler(function (event)
        end, sp.EventType.ANIMATION_COMPLETE)
        skeletonNode:setAnimation(0, "animation", true)
        Panel_horse_picture:addChild(skeletonNode)

        Text_2:setString(name)
        Text_2:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
        draw.addHeroStar(Panel_star, star, quality)

        ccui.Helper:seekWidgetByName(root, "Panel_choose"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_choose_before"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root, "Panel_choose"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Panel_choose_before"):setVisible(false)
    end
    self:onUpdateAttributes()
end

function OtherPlayersRacecourseRide:onUpdateDraw()
    local root = self.roots[1]
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root, "ListView_hreo_icon")
    ListView_hero_icon:removeAllItems()
    local index = 1
    for i, ship in pairs(self._user_ships) do
        local cell = state_machine.excute("hero_icon_create_cell", 0, {ship, 6, index})
        index = index + 1
        ListView_hero_icon:addChild(cell)
    end
    ListView_hero_icon:requestRefreshView()
    self._listview = ListView_hero_icon
    self._listview_pox = ListView_hero_icon:getInnerContainer():getPositionX()

    self:setHeroCellSelected(self.ship)
    self:updateInfo()
end

--设置英雄icon选择
function OtherPlayersRacecourseRide:setHeroCellSelected(ship)
    for i, v in pairs(self._listview:getItems()) do 
        if v.ship == ship then
            v.isSelecet = true
            state_machine.excute("hero_icon_cell_set_seleceted", 0, v)
        else
            if v.isSelecet == true then
                v.isSelecet = false
                state_machine.excute("hero_icon_cell_set_seleceted", 0, v)
            end
        end
    end
end
-- 获取侠客信息
function OtherPlayersRacecourseRide:getSortForFight()
    local result = {}
    for i,v in pairs(_ED.other_user_ship) do
        if tonumber(v.little_partner_formation_index) <= 0 then
            table.insert(result,v)
        end
    end
    return result
end

--更新坐标
function OtherPlayersRacecourseRide:onUpdate(dt)
    if self._listview ~= nil then
        local size = self._listview:getContentSize()
        local posx = self._listview:getInnerContainer():getPositionX()
        if self._listview_pox == posx then
            return
        end
        self._listview_pox = posx
        local items = self._listview:getItems()
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


function OtherPlayersRacecourseRide:onUpdateAttributes()
    local root = self.roots[1]
    local ListView_infor = ccui.Helper:seekWidgetByName(root, "ListView_infor")
    ListView_infor:removeAllItems()
    local Panel_infor = ccui.Helper:seekWidgetByName(root, "Panel_infor")
    Panel_infor:setVisible(false)
    if tonumber(self.ship.rider_horse_id) == 0 then
        return
    end
    Panel_infor:setVisible(true)
    local horse = _ED.other_horses[""..self.ship.rider_horse_id]
    local csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_1)
    local root1 = csbItem:getChildByName("root")
    root1:removeFromParent(false)
    ListView_infor:addChild(root1)
    ccui.Helper:seekWidgetByName(root1, "Text_title_1"):setVisible(true)
    ccui.Helper:seekWidgetByName(root1, "Text_title_2"):setVisible(false)
    -- 珍兽属性
    local infos = zstring.split(horse.attribute, "|")
    local Text_infor_name_1 = nil
    local Text_infor_add_1  = nil
    local Text_infor_name_2 = nil
    local Text_infor_add_2  = nil
    for k,v in pairs(infos) do
        local spirit_info = zstring.split(v, ",")
        if (k % 2) ~= 0 then
            csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_2)
            root1 = csbItem:getChildByName("root")
            root1:removeFromParent(false)
            ListView_infor:addChild(root1)
            Text_infor_name_1 = ccui.Helper:seekWidgetByName(root1, "Text_infor_name_1")
            Text_infor_add_1 = ccui.Helper:seekWidgetByName(root1, "Text_infor_add_1")
            Text_infor_name_2 = ccui.Helper:seekWidgetByName(root1, "Text_infor_name_2")
            Text_infor_add_2 = ccui.Helper:seekWidgetByName(root1, "Text_infor_add_2")
            Text_infor_name_1:setString(attribute[tonumber(spirit_info[1]) + 1])
            Text_infor_add_1:setString("+"..spirit_info[2].."%")
            Text_infor_name_2:setString("")
            Text_infor_add_2:setString("")
        else
            Text_infor_name_2:setString(attribute[tonumber(spirit_info[1]) + 1])
            Text_infor_add_2:setString("+"..spirit_info[2].."%")
        end
    end
    -- 珍兽技能
    local skill = dms.int(dms["horse_mould"], horse.mould_id, horse_mould.skill)
    if skill > 0 then
        csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_3)
        root1 = csbItem:getChildByName("root")
        root1:removeFromParent(false)
        ListView_infor:addChild(root1)
        local skill_name = dms.string(dms["horse_mould"], horse.mould_id, horse_mould.skill_name)
        local skill_desc = dms.string(dms["horse_mould"], horse.mould_id, horse_mould.skill_desc)
        ccui.Helper:seekWidgetByName(root1, "Text_skills_name"):setString(skill_name)

        csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_4)
        root1 = csbItem:getChildByName("root")
        root1:removeFromParent(false)
        ListView_infor:addChild(root1)
        ccui.Helper:seekWidgetByName(root1, "Text_skills_infor"):setString(skill_desc)
    end
    -- 镶嵌兽魂属性
    local isAddTitle = false
    for k,v in pairs(horse.horse_spirits) do
        if tonumber(v) > 0 then
            local mould_id = _ED.other_horse_spirits[""..v].mould_id
            if isAddTitle == false then
                isAddTitle = true
                csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_1)
                root1 = csbItem:getChildByName("root")
                root1:removeFromParent(false)
                ListView_infor:addChild(root1)
                local Text_title_1 = ccui.Helper:seekWidgetByName(root1, "Text_title_1"):setVisible(false)
                local Text_title_2 = ccui.Helper:seekWidgetByName(root1, "Text_title_2"):setVisible(true)
            end
            csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_5)
            root1 = csbItem:getChildByName("root")
            root1:removeFromParent(false)
            ListView_infor:addChild(root1)
            local name = dms.string(dms["horse_spirit_mould"], mould_id, horse_spirit_mould.horse_spirit_name)
            local desc = dms.string(dms["horse_spirit_mould"], mould_id, horse_spirit_mould.desc)
            local attributes = zstring.split(dms.string(dms["horse_spirit_mould"], mould_id, horse_spirit_mould.attributes), ",")
            local picIndex = dms.int(dms["horse_spirit_mould"], mould_id, horse_spirit_mould.icon)
            ccui.Helper:seekWidgetByName(root1, "Text_enchant_name"):setString(name)
            local is_handred = false
            for i,v in pairs(attribute_hundred) do
                if tonumber(attributes[1]) == v then
                    is_handred = true
                end
            end
            if is_handred == true then
                ccui.Helper:seekWidgetByName(root1, "Text_enchant_add"):setString(attribute[tonumber(attributes[1]) + 1].."+"..attributes[2].."%")
            else
                ccui.Helper:seekWidgetByName(root1, "Text_enchant_add"):setString(attribute[tonumber(attributes[1]) + 1].."+"..attributes[2])
            end
            ccui.Helper:seekWidgetByName(root1, "Panel_icon"):setBackGroundImage(string.format("images/ui/enchant/enchant_%d.png", picIndex))
        end
    end
    ListView_infor:requestRefreshView()
end

function OtherPlayersRacecourseRide:onInit( )
    local csbItem = csb.createNode(config_csb.horse.treasure_ride)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local Image_point = ccui.Helper:seekWidgetByName(root, "Image_point")
    local x = Image_point:getPositionX()
    local y = Image_point:getPositionY()
    self._pos_x = x
    self._pos_y = y

    -- 卸下
    local Button_decomposition_1 = ccui.Helper:seekWidgetByName(root,"Button_decomposition_1")
    Button_decomposition_1:setVisible(false)
    -- 分解
    local Button_decomposition_2 = ccui.Helper:seekWidgetByName(root,"Button_decomposition_2")
    Button_decomposition_2:setVisible(false)
    -- 附魔包裹
    local Button_decomposition_3 = ccui.Helper:seekWidgetByName(root,"Button_decomposition_3")
    Button_decomposition_3:setVisible(false)
    -- 马场包裹
    local Button_decomposition_3_0 = ccui.Helper:seekWidgetByName(root,"Button_decomposition_3_0")
    Button_decomposition_3_0:setVisible(false)
    -- 前往装备界面
    local Button_1 = ccui.Helper:seekWidgetByName(root,"Button_1")
    Button_1:setVisible(false)
    -- 前往捕获珍兽界面
    local Button_decomposition_3_1 = ccui.Helper:seekWidgetByName(root,"Button_decomposition_3_1")
    Button_decomposition_3_1:setVisible(false)
    -- 神兽合成
    local Button_legend_treasure = ccui.Helper:seekWidgetByName(root,"Button_legend_treasure")
    Button_legend_treasure:setVisible(false)
    -- 兽魂兑换
    local Button_legend_soul = ccui.Helper:seekWidgetByName(root,"Button_legend_soul")
    Button_legend_soul:setVisible(false)


    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "other_players_racecourse_ride_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0) 
    self:onUpdateDraw()
end

function OtherPlayersRacecourseRide:close()
    local root = self.roots[1]
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root, "ListView_hreo_icon")
    ListView_hero_icon:removeAllItems()
end

function OtherPlayersRacecourseRide:init(ship)
    self._user_ships = self:getSortForFight()
    self.ship = ship or self._user_ships[1]
    self:onInit()
    return self
end

function OtherPlayersRacecourseRide:onExit()
    state_machine.remove("other_players_racecourse_ride_change_ship")
end