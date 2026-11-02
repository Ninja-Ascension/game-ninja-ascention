-----------------------------
--神兵主界面
-----------------------------
GodWeaponry = class("GodWeaponryClass", Window)

local god_weaponry_window_open_terminal = {
    _name = "god_weaponry_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local list = getGodWeaponrySortForFight()
        if table.nums(list) == 0 then
            TipDlg.drawTextDailog(tipStringInfo_god_weaponry_info[3])
            return
        end
        local _Window = fwin:find("GodWeaponryClass")
        if nil == _Window then
            fwin:open(GodWeaponry:new():init(params), fwin._ui)
        end
        state_machine.excute("home_select_action_window_close", 0, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local god_weaponry_window_close_terminal = {
    _name = "god_weaponry_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GodWeaponryClass"))
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(god_weaponry_window_open_terminal)
state_machine.add(god_weaponry_window_close_terminal)
state_machine.init()

function GodWeaponry:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.listview = nil
    self.listview_pox = 0
    self._choose_ship = nil

    -- load lua file
    app.load("client.red_alert_time.cells.hero.hero_icon_cell")
    app.load("client.red_alert_time.god_weaponry.GodWeaponrySkillAtt")

    local function init_god_weaponry_terminal()
		local god_weaponry_breakthrough_terminal = {
            _name = "god_weaponry_breakthrough",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local nType = params._datas.nType
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:onUpdateDraw()
                            response.node:playAniSuccess(nType)
                            state_machine.excute("hero_main_update_draw",0,"")
                            state_machine.excute("hero_main_update_hero_info",0,"")
                        end
                    end
                end
                protocol_command.super_equipment_grow_up.param_list = instance._choose_ship.ship_id
                NetworkManager:register(protocol_command.super_equipment_grow_up.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local god_weaponry_storage_terminal = {
            _name = "god_weaponry_storage",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local nType = params._datas.nType
                local ship_mould_id = instance._choose_ship.ship_template_id
                local advanced_ship_open_tasks = zstring.split(dms.string(dms["ship_mould"], ship_mould_id, ship_mould.advanced_ship_open_tasks), ",")
                local task_info = nil
                for k,v in pairs(advanced_ship_open_tasks) do
                    if _ED.user_task_infos["6"] ~= nil then
                        for index, task in pairs(_ED.user_task_infos["6"]) do
                            if tonumber(v) == tonumber(task.task_mould_id) 
                                and tonumber(instance._choose_ship.god_weaponry_task_id) == tonumber(task.task_id)
                                then
                                task_info = task
                            end
                        end
                    end
                end
                if task_info ~= nil then
                    local animation_type = 1
                    if tonumber(task_info.achievement_finish_type) == 85 then
                        animation_type = 4
                    end
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                -- response.node:onUpdateDraw()
                                response.node:updateDrawHeroIcon()
                                response.node:playAniSuccess(animation_type)
                                state_machine.excute("hero_main_update_draw",0,"")
                                state_machine.excute("hero_main_god_hero_update_task", 0, nil)
                                state_machine.excute("hero_main_update_hero_info",0,"")
                            end
                        end
                    end
                    protocol_command.get_task_reward.param_list = task_info.task_id .. "\r\n" .. task_info.task_mould_id.."\r\n"..instance._choose_ship.ship_id
                    NetworkManager:register(protocol_command.get_task_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local god_weaponry_change_ship_terminal = {
            _name = "god_weaponry_change_ship",
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

        local god_weaponry_change_to_heroMain_terminal = {
            _name = "god_weaponry_change_to_heroMain",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if fwin:find("HeroMainClass") == nil then
                    state_machine.excute("hero_main_window_open",0,"") 
                else
                    state_machine.excute("hero_main_window_show", 0, nil)
                end
                state_machine.excute("hero_main_change_ship", 0, instance._choose_ship)
                state_machine.excute("hero_main_maneger", 0, {
                    _datas = 
                    {
                        next_terminal_name = "hero_main_change_to_god_hero", 
                        current_button_name = "Button_god_hero",
                        fun_open_id = 91,
                    }
                    })
                state_machine.excute("god_weaponry_window_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(god_weaponry_breakthrough_terminal)
        state_machine.add(god_weaponry_storage_terminal)
        state_machine.add(god_weaponry_change_ship_terminal)
        state_machine.add(god_weaponry_change_to_heroMain_terminal)
        state_machine.init()
    end
    
    init_god_weaponry_terminal()
end

function GodWeaponry:setHeroCellSelected(ship)
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

function GodWeaponry:playAniSuccess( ntype )
    local root = self.roots[1]
    local Panel_genral_icon_up = ccui.Helper:seekWidgetByName(root, "Panel_genral_icon_up")
    Panel_genral_icon_up:removeAllChildren(true)
    local baseName = "images/ui/effice/effect_shenbingshengji2/effect_shenbingshengji2"
    local skeletonNode = sp.spine(baseName..".json", baseName..".atlas", 1, 0, nil, false, nil)
    skeletonNode:registerSpineEventHandler(function (event)
        event.skeletonAnimation:removeFromParent(true)
    end, sp.EventType.ANIMATION_COMPLETE)
    skeletonNode:setAnimation(0, "animation", true)
    skeletonNode:setPosition(cc.p(Panel_genral_icon_up:getContentSize().width/2, 0))
    Panel_genral_icon_up:addChild(skeletonNode)

    local Panel_effice_text_up = ccui.Helper:seekWidgetByName(root, "Panel_effice_text_up")
    Panel_effice_text_up:removeAllChildren(true)
    baseName = "images/ui/effice/effect_shenbingshengji1/effect_shenbingshengji1"
    local skeletonNode1 = sp.spine(baseName..".json", baseName..".atlas", 1, 0, nil, false, nil)
    skeletonNode1:registerSpineEventHandler(function (event)
        event.skeletonAnimation:removeFromParent(true)
    end, sp.EventType.ANIMATION_COMPLETE)
    skeletonNode1:setAnimation(0, "animation"..ntype, true)
    skeletonNode1:setPosition(cc.p(Panel_effice_text_up:getContentSize().width/2, 0))
    Panel_effice_text_up:addChild(skeletonNode1)

    if ntype == 3 then
        local Panel_genral_icon_up = ccui.Helper:seekWidgetByName(root, "Panel_genral_icon_up")
        Panel_genral_icon_up:removeAllChildren(true)
        baseName = "images/ui/effice/effect_shenbingshengji3/effect_shenbingshengji3"
        local skeletonNode2 = sp.spine(baseName..".json", baseName..".atlas", 1, 0, nil, false, nil)
        -- skeletonNode2:registerSpineEventHandler(function (event)
            -- event.skeletonAnimation:removeFromParent(true)
        -- end, sp.EventType.ANIMATION_COMPLETE)
        skeletonNode2:setAnimation(0, "animation", true)
        skeletonNode2:setPosition(cc.p(Panel_genral_icon_up:getContentSize().width/2, 0))
        Panel_genral_icon_up:addChild(skeletonNode2)

        local group_id = self:getSuccessAniPos()
        local pos_info = {200, 130, 70, 0, -60}
        local pos_left_skill = {350, 280, 210, 140, 70}
        local Panel_left_skill = ccui.Helper:seekWidgetByName(root, "Panel_left_skill")
        local posX = -350
        local posY = pos_info[group_id]
        local pos_skillY = pos_left_skill[group_id]
        if group_id > 5 then
            group_id = group_id - 5
            posY = pos_info[group_id] - 15
            pos_skillY = pos_left_skill[group_id] - 15
        end
        skeletonNode2:runAction(cc.Sequence:create(
            {cc.MoveTo:create(0.45, cc.p(posX, posY)), 
            cc.CallFunc:create(function(sender)
                sender:removeFromParent(true)
                -- Panel_left_skill:removeAllChildren(true)
                baseName = "images/ui/effice/effect_shenbingshengji4/effect_shenbingshengji4"
                local skeletonNode3 = sp.spine(baseName..".json", baseName..".atlas", 1, 0, nil, false, nil)
                skeletonNode3:registerSpineEventHandler(function (event)
                    event.skeletonAnimation:removeFromParent(true)
                end, sp.EventType.ANIMATION_COMPLETE)
                skeletonNode3:setAnimation(0, "animation", true)
                skeletonNode3:setPosition(cc.p(45, pos_skillY))
                Panel_left_skill:addChild(skeletonNode3)
            end)}))
    end
end

function GodWeaponry:getSuccessAniPos( ... )
    local ship_mould_id = self._choose_ship.ship_template_id
    local god_info = nil
    local god_weaponry_id = 0
    if tonumber(self._choose_ship.god_weaponry) <= 0 then
        god_weaponry_id = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.super_equipment_mould_group_id)
    else
        god_weaponry_id = tonumber(self._choose_ship.god_weaponry)
    end
    god_info = _ED.god_weaponry_info[""..god_weaponry_id]

    local root = self.roots[1]
    -- ccui.Helper:seekWidgetByName(root, "ListView_skill_infor"):getInnerContainer():setPosition(cc.p(0, 140))
    local level_group = god_info.level_group_id
    if level_group > 5 then
        ccui.Helper:seekWidgetByName(root, "ListView_skill_infor"):jumpToBottom()
    else
        ccui.Helper:seekWidgetByName(root, "ListView_skill_infor"):jumpToTop()
    end
    
    return level_group
end

function GodWeaponry:onUpdateDraw()
    local root = self.roots[1]
    local Panel_genral_icon = ccui.Helper:seekWidgetByName(root, "Panel_genral_icon")
    local Panel_genral_icon_light = ccui.Helper:seekWidgetByName(root, "Panel_genral_icon_light")
    local Panel_god_weaponry_name = ccui.Helper:seekWidgetByName(root, "Panel_god_weaponry_name")
    local Text_attribute_introduce = ccui.Helper:seekWidgetByName(root, "Text_attribute_introduce")
    local Text_skill_lv = ccui.Helper:seekWidgetByName(root, "Text_skill_lv")
    for i=1,4 do
        ccui.Helper:seekWidgetByName(root, "Text_attribute_"..i):setString("")
        ccui.Helper:seekWidgetByName(root, "Text_attribute_v_"..i):setString("")
        ccui.Helper:seekWidgetByName(root, "Panel_material_box_"..i):removeAllChildren(true)
    end
    Text_attribute_introduce:setString("")
    Text_skill_lv:setString("")
    Panel_genral_icon_light:removeAllChildren(true)
    Panel_genral_icon:removeBackGroundImage()
    Panel_god_weaponry_name:removeBackGroundImage()

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

    Text_skill_lv:setString(god_info.level)
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
    local talent_describe = dms.atos(talentMould, talent_mould.talent_describe)
    local base_additional = dms.atos(talentMould, talent_mould.base_additional)

    Text_attribute_introduce:setString(talent_describe)

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

    local Button_go = ccui.Helper:seekWidgetByName(root, "Button_go")
    local Button_breakthrough = ccui.Helper:seekWidgetByName(root, "Button_breakthrough")
    local Text_breakthrough = ccui.Helper:seekWidgetByName(root, "Text_breakthrough")
    local Text_breakthrough_full = ccui.Helper:seekWidgetByName(root, "Text_breakthrough_full")
    local Button_refining = ccui.Helper:seekWidgetByName(root, "Button_refining")
    local Button_storage = ccui.Helper:seekWidgetByName(root, "Button_storage")
    local Panel_material = ccui.Helper:seekWidgetByName(root, "Panel_material")
    local Text_no_task_info = ccui.Helper:seekWidgetByName(root, "Text_no_task_info")
    local Text_stroage = ccui.Helper:seekWidgetByName(root, "Text_stroage")
    local Text_stroage_role = ccui.Helper:seekWidgetByName(root, "Text_stroage_role")

    Button_go:setVisible(false)
    Panel_material:setVisible(true)
    Button_breakthrough:setVisible(false)
    Text_breakthrough:setVisible(false)
    Text_breakthrough_full:setVisible(false)
    Button_refining:setVisible(false)
    Button_storage:setVisible(false)
    Text_no_task_info:setVisible(false)
    Text_stroage:setVisible(false)
    Text_stroage_role:setVisible(false)

    local cost_info = {}
    if tonumber(self._choose_ship.god_weaponry) <= 0 then
        display:gray(Panel_genral_icon:getChildByName("Sprite_icon"))
        local ship_mould_id = self._choose_ship.ship_template_id
        local advanced_ship_open_tasks = zstring.split(dms.string(dms["ship_mould"], ship_mould_id, ship_mould.advanced_ship_open_tasks), ",")
        local task_info = nil
        for k,v in pairs(advanced_ship_open_tasks) do
            if _ED.user_task_infos["6"] ~= nil then
                for index, task in pairs(_ED.user_task_infos["6"]) do
                    if tonumber(v) == tonumber(task.task_mould_id) 
                        and tonumber(self._choose_ship.god_weaponry_task_id) == tonumber(task.task_id) 
                        then
                        task_info = task
                    end
                end
            end
        end
        if task_info ~= nil then
            if tonumber(task_info.achievement_finish_type) == 84 then
                Button_storage:setVisible(true)
                Text_stroage:setVisible(true)
            elseif tonumber(task_info.achievement_finish_type) == 85 then
                Button_storage:setVisible(true)
                Text_stroage_role:setVisible(true)
            else
                Panel_material:setVisible(false)
                Text_no_task_info:setVisible(true)
                Button_go:setVisible(true)
            end
            local task_mould_id = task_info.task_mould_id
            local achievement_mould_id = dms.int(dms["task_mould"],task_mould_id,task_mould.achieve_mould_id)
            local achievement_reward = dms.string(dms["achievement_mould"],achievement_mould_id,achievement_mould.achievement_reward)
            if tonumber(achievement_reward) ~= -1 then
                cost_info = zstring.split(achievement_reward, "|")
            end
        end
    else
        display:ungray(Panel_genral_icon:getChildByName("Sprite_icon"))
        if tonumber(god_info.grow_up_need_param) ~= -1 then
            cost_info = zstring.split(god_info.grow_up_need_param, "|")
        end
        if god_info.grow_up_id == -1 then
            Text_breakthrough_full:setVisible(true)
        else
            if god_info.level == _ED.god_weaponry_info[""..god_info.grow_up_id].level then
                Button_breakthrough:setVisible(true)
                Text_breakthrough:setVisible(true)
            else
                Button_refining:setVisible(true)
            end
        end
    end
    for k,v in pairs(cost_info) do
        local itemInfo = zstring.split(v, ",")
        local data = 
        {
            item_value = tonumber(itemInfo[3]),
            prop_type = tonumber(itemInfo[2]),
            prop_item = tonumber(itemInfo[1]),
        }
        local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,2,0,true,true})
        ccui.Helper:seekWidgetByName(root, "Panel_material_box_"..k):addChild(cell)
        local count = 0
        if data.prop_type == 1 then
            count = tonumber(_ED.user_info.user_silver)
        elseif data.prop_type == 5 then
            count = tonumber(_ED.user_info.jade)
        elseif data.prop_type == 6 then
            local prop = fundPropWidthId(data.prop_item)
            if prop ~= nil then
                count = tonumber(prop.prop_number)
            end
        elseif data.prop_type == 13 then
            for i, v in pairs(_ED.user_ship) do
                if zstring.tonumber(v.ship_base_template_id) == zstring.tonumber(data.prop_item)
                    and zstring.tonumber(v.ship_id) ~= zstring.tonumber(self._choose_ship.ship_id)
                    and zstring.tonumber(v.ship_template_id) == zstring.tonumber(v.ship_base_template_id)
                    and zstring.tonumber(v.formation_index) == 0
                    and zstring.tonumber(v.little_partner_formation_index) == 0
                    and zstring.tonumber(v.skill_grow_up_level) <= 0
                    then
                    local nv = true
                    for e, m in pairs(v.equipment) do
                        if zstring.tonumber(m.user_equiment_id) > 0 then
                            nv = false
                        end
                    end
                    for j,k in pairs(v.stars_state) do
                        if tonumber(k.state) == 1 then
                            nv = false
                        end
                    end
                    if true == nv then
                        count = count + 1
                    end
                end
            end
            ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_number"):setString(data.item_value)
        end
        data.pack_nums = count
        if count < tonumber(data.item_value) then
            ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_number"):setColor(cc.c3b(tipStringInfo_quality_color_Type[6][1],tipStringInfo_quality_color_Type[6][2],tipStringInfo_quality_color_Type[6][3]))
        end
    end
    for i=1,10 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_skill_"..i), nil, 
        {
            terminal_name = "god_weaponry_skill_att_window_open", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i,
            choose_ship = self._choose_ship,
        }, nil, 0)
    end
end

function GodWeaponry:updateDrawHeroIcon( ... )
    local root = self.roots[1]
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root, "ListView_hero_icon")
    ListView_hero_icon:removeAllItems()
    local result = {}
    local result = getGodWeaponrySortForFight()
    for k,v in pairs(result) do
        local cell = state_machine.excute("hero_icon_create_cell",0,{v,11,k})
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

function GodWeaponry:onUpdate(dt)
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

function GodWeaponry:onEnterTransitionFinish()
    
end

function GodWeaponry:onInit( )
    local csbItem = csb.createNode(config_csb.god_weaponry.god_weaponry)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.god_weaponry.god_weaponry)
    action:setTimeSpeed(app.getTimeSpeed())
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("animation_icon", true)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_breakthrough"), nil, 
    {
        terminal_name = "god_weaponry_breakthrough", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        nType = 3,
    }, nil, 0)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refining"), nil, 
    {
        terminal_name = "god_weaponry_breakthrough", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        nType = 2,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_storage"), nil, 
    {
        terminal_name = "god_weaponry_storage", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        nType = 1,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil, 
    {
        terminal_name = "god_weaponry_change_to_heroMain", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "god_weaponry_window_close", 
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

function GodWeaponry:init(params)
    if params ~= nil and params ~= "" then
        self._choose_ship = params
    end
	self:onInit()
    return self
end

function GodWeaponry:onExit()
    state_machine.remove("god_weaponry_breakthrough")
    state_machine.remove("god_weaponry_storage")
end

function getGodWeaponrySortForFight()
    local result = {}
    for i,v in pairs(_ED.user_ship) do
        local initial_rank_level = dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.initial_rank_level)
        local ship_type = dms.int(dms["ship_mould"], v.ship_template_id, ship_mould.ship_type)
        if initial_rank_level >= 6 and ship_type >= 4 then
            table.insert(result, v)
        end
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
            table.insert(in_formation, ship)
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
    for i,v in pairs(in_formation) do
       table.insert(all_result,v)
    end
    -- local formation_temp = {}
    -- local position_str = dms.string(dms["formation_mould"],tonumber(_ED.formetion[1]),formation_mould.position)
    -- position_str = zstring.split(position_str,",")
    -- for i,v in pairs(position_str) do
    --     if zstring.tonumber(_ED.formetion[i+1]) ~= 0 then
    --         table.insert(formation_temp,_ED.user_ship["".._ED.formetion[i+1]])
    --     end
    -- end

    -- local formation_temp_change_index = {}
    -- for i,v in pairs(formation_temp) do
    --     table.insert(formation_temp_change_index,formation_temp[#formation_temp-i+1])
    -- end

    -- for i,v in pairs(formation_temp_change_index) do
    --    table.insert(all_result,v)
    -- end
    
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
    for i,v in pairs(blue_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(green_ship) do
        table.insert(all_result,v)
    end  
    for i,v in pairs(white_ship) do
       table.insert(all_result,v)
    end
    return all_result
end
