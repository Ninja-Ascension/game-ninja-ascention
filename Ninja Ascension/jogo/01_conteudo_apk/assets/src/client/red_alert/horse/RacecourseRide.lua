-----------------------------
--马场乘骑
-----------------------------
RacecourseRide = class("RacecourseRideClass", Window)
--打开
local racecourse_ride_window_open_terminal = {
    _name = "racecourse_ride_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(87) == true then
            return
        end
        if tonumber(_ED.home_build["17"].level) == 1 then
            TipDlg.drawTextDailog(horse_string_info[13])
            return
        end
        state_machine.excute("home_select_action_window_close",0,"")
        local _RacecourseWindow = fwin:find("RacecourseRideClass")
        if nil == _RacecourseWindow then
            fwin:open(RacecourseRide:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local racecourse_ride_window_close_terminal = {
    _name = "racecourse_ride_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RacecourseRideClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(racecourse_ride_window_open_terminal)
state_machine.add(racecourse_ride_window_close_terminal)
state_machine.init()

function RacecourseRide:ctor()
    self.super:ctor()
    self.roots = {}
    self.user_ships = {}
    self.ship = nil

    --英雄icon列表
    self.listview = nil 
    --列表x轴
    self.listview_pox = nil

    -- load lua file
    app.load("client.red_alert.forging.Refining")
    app.load("client.red_alert.horse.RacecourseHorseSoul")
    app.load("client.red_alert.horse.RacecoursePack")
    app.load("client.red_alert.horse.RacecoursePackScrollview")
    app.load("client.red_alert.horse.RacecourseSoulExchange")
    app.load("client.red_alert.horse.RacecourseAttribute")
    app.load("client.red_alert.horse.RacecourseStrength")
    app.load("client.red_alert.cells.hero.hero_icon_cell")
    app.load("client.red_alert.cells.horse.racecourse_ride_skill_cell")

    -- Initialize racecourse_ride state machine.
    local function init_racecourse_ride_terminal()
        local racecourse_ride_give_up_terminal = {
            _name = "racecourse_ride_give_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("racecourse_ride_change_ship",0,nil)
                    end
                end
                protocol_command.rider_horse.param_list = "0\r\n"..instance.ship.ship_id
                NetworkManager:register(protocol_command.rider_horse.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开战马包裹
        local racecourse_ride_open_packs_terminal = {
            _name = "racecourse_ride_open_packs",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("racecourse_pack_window_open", 0, {1,2,nil,nil,instance.ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 打开马魂包裹
        local racecourse_ride_open_horse_soul_terminal = {
            _name = "racecourse_ride_open_horse_soul",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("racecourse_pack_window_open", 0, {2,1,nil})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 改变英雄
        local racecourse_ride_change_ship_terminal = {
            _name = "racecourse_ride_change_ship",
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

        -- 前往装备界面
        local racecourse_goto_equipment_terminal = {
            _name = "racecourse_goto_equipment",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("racecourse_ride_window_close",0,"")   
                if fwin:find("RacecourseClass") ~= nil then
                    state_machine.excute("racecourse_window_close",0,"")  
                end
                state_machine.excute("equipment_window_open",0,"") 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 前往捕获珍兽界面界面
        local racecourse_ride_goto_racecourse_terminal = {
            _name = "racecourse_ride_goto_racecourse",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("racecourse_window_open",0,"")  
                state_machine.excute("racecourse_ride_window_close",0,"") 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local racecourse_ride_update_draw_terminal = {
            _name = "racecourse_ride_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = nil
                if params ~= nil and params ~= "" then
                    index = params[1]
                end
                instance:updateInfo(index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(racecourse_ride_give_up_terminal)
        state_machine.add(racecourse_ride_change_ship_terminal)
        state_machine.add(racecourse_ride_open_packs_terminal)
        state_machine.add(racecourse_ride_open_horse_soul_terminal)
        state_machine.add(racecourse_goto_equipment_terminal)
        state_machine.add(racecourse_ride_goto_racecourse_terminal)
        state_machine.add(racecourse_ride_update_draw_terminal)
    end
    init_racecourse_ride_terminal()
end

function RacecourseRide:updateInfo(index)
    local root = self.roots[1]
    local horse = _ED.horses[""..self.ship.rider_horse_id]

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

    -- 神兽碎片进度条
    local LoadingBar_1 = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")   
    local Text_shuliang = ccui.Helper:seekWidgetByName(root, "Text_shuliang")   
    local max_count = dms.int(dms["horse_config"], 4, horse_config.param)   --所需碎片
    Text_shuliang:setString(_ED.user_info.dragon_horse_patch.."/"..max_count)
    LoadingBar_1:setPercent((_ED.user_info.dragon_horse_patch/max_count)*100)
    -- 橙色兽魂碎片进度条
    local LoadingBar_2 = ccui.Helper:seekWidgetByName(root, "LoadingBar_2")    
    local Text_shuliang_2 = ccui.Helper:seekWidgetByName(root, "Text_shuliang_2")  
    Text_shuliang_2:setString(_ED.user_info.horse_spirits_patch.."/"..50)
    LoadingBar_2:setPercent((_ED.user_info.horse_spirits_patch/50)*100)

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
            Panel_skill:addChild(state_machine.excute("racecource_ride_skill_create_cell", 0, {i, horse, self.ship}))
            if index ~= nil then
                if index == i then
                    -- 兽魂觉醒动画资源加载
                    for i, v in pairs(config_res.sprites_cached["soul_up"]) do
                        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
                    end
                    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_soul_up/effect_soul_up.ExportJson")
                    local effice = ccs.Armature:create("effect_soul_up")
                    effice:getAnimation():playWithIndex(0)
                    effice:setPosition(cc.p(Panel_skill:getContentSize().width/2, Panel_skill:getContentSize().height/2))
                    Panel_skill:addChild(effice)
                end
            end
        end

        local baseName = "sprite/spirte_" .. body_icon
        local skeletonNode = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
        skeletonNode:registerSpineEventHandler(function (event)
        end, sp.EventType.ANIMATION_COMPLETE)
        skeletonNode:setAnimation(0, "animation", true)
        Panel_horse_picture:addChild(skeletonNode)

        -- Panel_horse_picture:setBackGroundImage(string.format("images/ui/big_treasure/big_treasure_%d.png", body_icon))
        Text_2:setString(name)
        Text_2:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
        draw.addHeroStar(Panel_star, star, quality)

        ccui.Helper:seekWidgetByName(root, "Button_decomposition_1"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_choose"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_choose_before"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root, "Button_decomposition_1"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Panel_choose"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Panel_choose_before"):setVisible(true)
    end
    self:onUpdateAttributes()
end

function RacecourseRide:onUpdateDraw( ... )
    local root = self.roots[1]
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root, "ListView_hreo_icon")
    ListView_hero_icon:removeAllItems()
    local index = 1
    for i, ship in pairs(self.user_ships) do
        local cell = state_machine.excute("hero_icon_create_cell", 0, {ship, 8, index})
        index = index + 1
        ListView_hero_icon:addChild(cell)
    end
    ListView_hero_icon:requestRefreshView()
    self.listview = ListView_hero_icon
    self.listview_pox = ListView_hero_icon:getInnerContainer():getPositionX()

    self:setHeroCellSelected(self.ship)
    self:updateInfo()
end

--设置英雄icon选择
function RacecourseRide:setHeroCellSelected(ship)
    for i, v in pairs(self.listview:getItems()) do 
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

function RacecourseRide:getSortForFight()
    local result = {}
    for i,v in pairs(_ED.user_ship) do
        table.insert(result,v)
    end
    local all_result = {}
    local in_formation = {}
    local in_raleship = {}
    local gold_ship = {} -- 6
    local red_ship = {}  -- 5
    local orange_ship = {} -- 4
    local purple_ship = {} -- 3
    local blue_ship = {} -- 2 
    local green_ship = {} -- 1
    local white_ship = {} -- 0
    local function sortShipFight( a, b )
        return tonumber(a.hero_fight) > tonumber(b.hero_fight)
    end
    table.sort(result, sortShipFight)

    for i,ship in pairs(result) do
        if zstring.tonumber(ship.formation_index) > 0 then
            -- table.insert(in_formation, ship)
        elseif zstring.tonumber(ship.little_partner_formation_index) > 0 then
        --     table.insert(in_raleship, ship)
        elseif zstring.tonumber(ship.ship_type) == 6 then
            table.insert(gold_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 5 then
            table.insert(red_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 4 then
            table.insert(orange_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 3 then
            table.insert(purple_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 2 then
            table.insert(blue_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 1 then
            table.insert(green_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 0 then
            table.insert(white_ship, ship)
        end
    end
    self.ship_numbers = 0
    -- for i,v in pairs(in_formation) do
    --    table.insert(all_result,v)
    -- end
    local formation_temp = {}
    local position_str = dms.string(dms["formation_mould"],tonumber(_ED.formetion[1]),formation_mould.position)
    position_str = zstring.split(position_str,",")
    for i,v in pairs(position_str) do
        if zstring.tonumber(_ED.formetion[i+1]) ~= 0 then
            table.insert(formation_temp,_ED.user_ship["".._ED.formetion[i+1]])
        end
    end

    local formation_temp_change_index = {}
    for i,v in pairs(formation_temp) do
        table.insert(formation_temp_change_index,formation_temp[#formation_temp-i+1])
    end

    for i,v in pairs(formation_temp_change_index) do
       table.insert(all_result,v)
    end
    
    for i,v in pairs(in_raleship) do
       table.insert(all_result,v)
    end

    for i,v in pairs(gold_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(red_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(orange_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(purple_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(green_ship) do
        table.insert(all_result,v)
    end  
    for i,v in pairs(blue_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(white_ship) do
       table.insert(all_result,v)
    end
    return all_result
end

--更新坐标
function RacecourseRide:onUpdate(dt)
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


function RacecourseRide:onUpdateAttributes()
    local root = self.roots[1]
    local ListView_infor = ccui.Helper:seekWidgetByName(root, "ListView_infor")
    ListView_infor:removeAllItems()
    local Panel_infor = ccui.Helper:seekWidgetByName(root, "Panel_infor")
    Panel_infor:setVisible(false)
    if tonumber(self.ship.rider_horse_id) == 0 then
        return
    end
    Panel_infor:setVisible(true)
    local horse = _ED.horses[""..self.ship.rider_horse_id]
    local csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_1)
    local root1 = csbItem:getChildByName("root")
    root1:removeFromParent(false)
    ListView_infor:addChild(root1)
    ccui.Helper:seekWidgetByName(root1, "Text_title_1"):setVisible(true)
    ccui.Helper:seekWidgetByName(root1, "Text_title_2"):setVisible(false)
    
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

    local isAddTitle = false
    for k,v in pairs(horse.horse_spirits) do
        if tonumber(v) > 0 then
            local mould_id = _ED.horse_spirits[""..v].mould_id
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

function RacecourseRide:onInit( )
    local csbItem = csb.createNode(config_csb.horse.treasure_ride)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local Image_point = ccui.Helper:seekWidgetByName(root, "Image_point")
    local x = Image_point:getPositionX()
    local y = Image_point:getPositionY()
    self._pos_x = x
    self._pos_y = y
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "racecourse_ride_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --卸下
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_decomposition_1"), nil, 
    {
        terminal_name = "racecourse_ride_give_up",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)     

    --分解
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_decomposition_2"), nil, 
    {
        terminal_name = "refining_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        page_index = 3,
    }, nil, 0)   

    --附魔包裹
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_decomposition_3"), nil, 
    {
        terminal_name = "racecourse_ride_open_horse_soul",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_horse_soul",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_decomposition_3"),
        _invoke = nil,
        _interval = 0.5,})  

    --马场包裹
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_decomposition_3_0"), nil, 
    {
        terminal_name = "racecourse_ride_open_packs",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --穿戴马场
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_chick_ride"), nil, 
    {
        terminal_name = "racecourse_ride_open_packs",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 前往装备界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
    {
        terminal_name = "racecourse_goto_equipment",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 前往捕获珍兽界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_decomposition_3_1"), nil, 
    {
        terminal_name = "racecourse_ride_goto_racecourse",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 兽魂兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legend_soul"), nil, 
    {
        terminal_name = "racecourse_soul_exchange_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_horse_spilits_combing",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_legend_soul"),
        _invoke = nil,
        _interval = 0.5,}) 

    -- 神兽合成
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_legend_treasure"), nil, 
    {
        terminal_name = "racecourse_dragon_horse_make_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_horse_combing",
        _widget = ccui.Helper:seekWidgetByName(root,"Button_legend_treasure"),
        _invoke = nil,
        _interval = 0.5,}) 

    self:onUpdateDraw()
end

function RacecourseRide:close()
    local root = self.roots[1]
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root, "ListView_hreo_icon")
    ListView_hero_icon:removeAllItems()
end

function RacecourseRide:init(ship)
    self.user_ships = self:getSortForFight()
    self.ship = ship or self.user_ships[1]
    self:onInit()
    return self
end

function RacecourseRide:onExit()
    state_machine.remove("racecourse_ride_give_up")
    state_machine.remove("racecourse_ride_change_ship")
    state_machine.remove("racecourse_ride_open_packs")
    state_machine.remove("racecourse_ride_open_horse_soul")
    state_machine.remove("racecourse_goto_equipment")
    state_machine.remove("racecourse_ride_goto_racecourse")
    state_machine.remove("racecourse_ride_update_draw")
end