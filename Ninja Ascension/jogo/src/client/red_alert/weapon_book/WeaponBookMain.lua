-----------------------------
-- 秘籍主界面
-----------------------------
WeaponBookMain = class("WeaponBookMainClass", Window)

local weapon_book_main_window_open_terminal = {
    _name = "weapon_book_main_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(35) == true then
            return
        end
        state_machine.excute("home_select_action_window_close",0,"")
        local _WeaponBookMainWindow = fwin:find("WeaponBookMainClass")
        if nil == _WeaponBookMainWindow then
            fwin:open(WeaponBookMain:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local weapon_book_main_window_close_terminal = {
    _name = "weapon_book_main_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WeaponBookMainClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(weapon_book_main_window_open_terminal)
state_machine.add(weapon_book_main_window_close_terminal)
state_machine.init()

function WeaponBookMain:ctor()
    self.super:ctor()
    self.roots = {}
    self.user_ships = {}
    self.ship = nil

    --英雄icon列表
    self.listview = nil 
    --列表x轴
    self.listview_pox = nil

    app.load("client.red_alert.forging.Refining")
    app.load("client.red_alert.cells.hero.hero_icon_cell")
    app.load("client.red_alert.weapon_book.WeaponBookPack")
    app.load("client.red_alert.weapon_book.WeaponBookPackScrollview")
    app.load("client.red_alert.weapon_book.WeaponBookAttributeUp")
    app.load("client.red_alert.weapon_book.WeaponBookUpSkill")
    app.load("client.red_alert.weapon_book.WeaponBookRebirth")

    local function init_weapon_book_main_terminal()
        local weapon_book_main_give_up_terminal = {
            _name = "weapon_book_main_give_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                _ED.weapon_book[""..instance.ship.weapon_book_id].ship_id = "0"
                instance.ship.weapon_book_id = "0"
                instance:updateInfo()
                -- local function responseCallback( response )
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         state_machine.excute("racecourse_ride_change_ship",0,nil)
                --     end
                -- end
                -- protocol_command.rider_horse.param_list = "0\r\n"..instance.ship.ship_id
                -- NetworkManager:register(protocol_command.rider_horse.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开包裹
        local weapon_book_main_open_packs_terminal = {
            _name = "weapon_book_main_open_packs",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("weapon_book_pack_window_open", 0, {params._datas.ntype, instance.ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 改变英雄
        local weapon_book_main_change_ship_terminal = {
            _name = "weapon_book_main_change_ship",
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

        -- 刷新
        local weapon_book_main_update_draw_terminal = {
            _name = "weapon_book_main_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新兵符技能
        local weapon_book_main_update_skill_terminal = {
            _name = "weapon_book_main_update_skill",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateSkill()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 技能精炼
        local weapon_book_main_skill_strength_terminal = {
            _name = "weapon_book_main_skill_strength",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local weapon_book = _ED.weapon_book[""..instance.ship.weapon_book_id]
                state_machine.excute("weapon_book_attribute_up_window_open", 0, {weapon_book, index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 兵符升星
        local weapon_book_main_rising_star_terminal = {
            _name = "weapon_book_main_rising_star",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local weapon_book = _ED.weapon_book[""..instance.ship.weapon_book_id]
                state_machine.excute("weapon_book_up_skill_window_open", 0, weapon_book)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(weapon_book_main_give_up_terminal)
        state_machine.add(weapon_book_main_change_ship_terminal)
        state_machine.add(weapon_book_main_open_packs_terminal)
        state_machine.add(weapon_book_main_open_horse_soul_terminal)
        state_machine.add(weapon_book_main_update_draw_terminal)
        state_machine.add(weapon_book_main_skill_strength_terminal)
        state_machine.add(weapon_book_main_rising_star_terminal)
        state_machine.add(weapon_book_main_update_skill_terminal)
        state_machine.init()
    end
    init_weapon_book_main_terminal()
end

function WeaponBookMain:updateInfo( ... )
    local root = self.roots[1]
    local weapon_book = nil 
    if self.ship.weapon_book_id ~= nil then
        weapon_book = _ED.weapon_book[""..self.ship.weapon_book_id]
    end
    -- local weapon_book = _ED.weapon_book["1"] -- _ED.weapon_book[""..self.ship.weapon_book_id]

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

    local Text_info_1 = ccui.Helper:seekWidgetByName(root, "Text_info_1")
    local Text_info_2 = ccui.Helper:seekWidgetByName(root, "Text_info_2")

    if weapon_book ~= nil then
        local weapon_data = dms.element(dms["equipment_mould"], weapon_book.user_equiment_template)
        local quality = weapon_book.quality
        local trace_remarks = dms.atos(weapon_data, equipment_mould.trace_remarks)             -- 兵符描述
        local equipment_talent_ids = dms.atoi(weapon_data, equipment_mould.equipment_talent_ids)      -- 兵符天赋

        self:onUpdateSkill()

        -- 兵符图片
        Panel_horse_picture:setBackGroundImage(string.format("images/ui/equip/equip_%d.png", weapon_book.icon))

        Text_2:setString(weapon_book.user_equiment_name)
        Text_2:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))

        Text_info_1:setString(trace_remarks)

        if equipment_talent_ids > 0 then
            talent_desc = dms.string(dms["talent_mould"], equipment_talent_ids, talent_mould.talent_describe)
            Text_info_2:setString(talent_desc)
        else
            Text_info_2:setString("")
        end

        -- 显示星数
        draw.addWeaponBookStar(Panel_star, weapon_book.rank_level, 1)

        ccui.Helper:seekWidgetByName(root, "Button_down"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_choose"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_choose_before"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Button_star_up"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Button_down"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Panel_choose"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Panel_choose_before"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Button_star_up"):setVisible(false)
    end
end

-- 刷新兵符技能
function WeaponBookMain:onUpdateSkill()
    local root = self.roots[1]
    local weapon_book = _ED.weapon_book[""..self.ship.weapon_book_id]

    for i = 1, 6 do
        local Panel_skill =  ccui.Helper:seekWidgetByName(root, "Panel_skill_6_"..i)
        local Text_name = ccui.Helper:seekWidgetByName(root, "Text_skill_name_"..i)                   -- 技能名
        local Text_skill = ccui.Helper:seekWidgetByName(root, "Text_skill_"..i)                   -- 增加属性
        local Text_level = ccui.Helper:seekWidgetByName(root, "Text_skill_lv_"..i)                 -- 等级
        local Sprite_skill = Panel_skill:getChildByName("Sprite_"..i)
        local Text_unlock_lv = ccui.Helper:seekWidgetByName(root, "Text_unlock_lv_"..i)                     --x星解锁
        local Panel_shuxing = ccui.Helper:seekWidgetByName(root, "Panel_shuxing_"..i)
        local LoadingBar_exp = ccui.Helper:seekWidgetByName(root, "LoadingBar_exp_"..i) 

        Panel_skill:setVisible(true)
        Text_name:setString("")
        Text_level:setString("")
        Text_unlock_lv:setVisible(false)
        Panel_shuxing:setVisible(false)

        if i <= weapon_book.gem_numbers then
            local mould_id = weapon_book.attr_ids[i]
            local skill_data = dms.element(dms["lead_mould"], mould_id)
            
            local skill_icon = dms.atoi(skill_data, lead_mould.icon)         -- 图标
            local skill_open = dms.atoi(skill_data, lead_mould.is_opend)         -- 是否激活

            local skill_level = weapon_book.weapon_book_levels[i]           -- 等级

            local icon_file = string.format("images/ui/weapon_book/weapon_book_icon_%d.png", skill_icon)
            Sprite_skill:setTexture(icon_file)

            if skill_open == 0 then      -- 未激活的技能
                Text_unlock_lv:setVisible(true)
            else
                local skill_name = dms.atos(skill_data, lead_mould.name)         -- 技能名
                local distribute = dms.atos(skill_data, lead_mould.distribute)            -- 属性名
                local current_level = dms.atoi(skill_data, lead_mould.current_level)-- 初始等级
                local current_att = dms.atos(skill_data, lead_mould.current_att)    -- 当前属性
                local grow_att = dms.atos(skill_data, lead_mould.grow_att)          -- 每级增加属性
                local skill_max_level = dms.atoi(skill_data, lead_mould.max_level)   -- 最大等级

                Panel_shuxing:setVisible(true)
                Text_name:setString(skill_name)
                Text_level:setString(string.format(red_alert_all_str[117], skill_level))

                LoadingBar_exp:setPercent(skill_level / skill_max_level * 100)

                local current_att_value = zstring.tonumber(zstring.split(current_att, ",")[2])
                local grow_att_value = zstring.tonumber(zstring.split(grow_att, ",")[2])
                local attr_value = current_att_value + (skill_level - current_level) * grow_att_value

                Text_skill:setString(distribute.."+"..attr_value)
            end
        else                -- 未开启
            Panel_skill:setVisible(false)
        end
    end
end

function WeaponBookMain:onUpdateDraw( ... )
    local root = self.roots[1]
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root, "ListView_hreo_icon")
    ListView_hero_icon:removeAllItems()
    local index = 1
    for i, ship in pairs(self.user_ships) do
        local cell = state_machine.excute("hero_icon_create_cell", 0, {ship, 13, index})
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
function WeaponBookMain:setHeroCellSelected(ship)
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

function WeaponBookMain:getSortForFight()
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
function WeaponBookMain:onUpdate(dt)
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

function WeaponBookMain:onInit( )
    local csbItem = csb.createNode(config_csb.weapon_book.weapon_book)
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
        terminal_name = "weapon_book_main_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --卸下
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_down"), nil, 
    {
        terminal_name = "weapon_book_main_give_up",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)     

    -- 拆解
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rebirth"), nil, 
    {
        terminal_name = "weapon_book_rebirth_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --分解
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_decomposition"), nil, 
    {
        terminal_name = "refining_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        page_index = 4,
    }, nil, 0)

    -- 兵符包裹
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pack"), nil, 
    {
        terminal_name = "weapon_book_main_open_packs",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 1,
    }, nil, 0)

    -- 穿戴兵符
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_chick_ride"), nil, 
    {
        terminal_name = "weapon_book_main_open_packs",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 2,
    }, nil, 0)

    -- 兵符升星
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_star_up"), nil, 
    {
        terminal_name = "weapon_book_main_rising_star",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 技能精炼
    for i = 1, 6 do 
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_skill_6_"..i), nil, 
        {
            terminal_name = "weapon_book_main_skill_strength",
            terminal_state = 0, 
            index = i,
        }, nil, 0)
    end

    self:onUpdateDraw()
end

function WeaponBookMain:close()
    local root = self.roots[1]
    local ListView_hero_icon = ccui.Helper:seekWidgetByName(root, "ListView_hreo_icon")
    ListView_hero_icon:removeAllItems()
end

function WeaponBookMain:init(ship)
    self.user_ships = self:getSortForFight()
    self.ship = ship or self.user_ships[1]
    self:onInit()
    return self
end

function WeaponBookMain:onExit()
    state_machine.remove("weapon_book_main_give_up")
    state_machine.remove("weapon_book_main_change_ship")
    state_machine.remove("weapon_book_main_open_packs")
    state_machine.remove("weapon_book_main_open_horse_soul")
    state_machine.remove("weapon_book_main_update_draw")
    state_machine.remove("weapon_book_main_skill_strength")
    state_machine.remove("weapon_book_main_rising_star")
    state_machine.remove("weapon_book_main_update_skill")
end