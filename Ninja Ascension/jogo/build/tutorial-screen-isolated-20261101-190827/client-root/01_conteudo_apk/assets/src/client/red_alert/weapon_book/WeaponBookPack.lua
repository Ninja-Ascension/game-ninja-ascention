-----------------------------
-- 秘籍包裹
-----------------------------
WeaponBookPack = class("WeaponBookPackClass", Window)
--打开
local weapon_book_pack_window_open_terminal = {
    _name = "weapon_book_pack_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _WeaponBookPackWindow = fwin:find("WeaponBookPackClass")
        if nil == _WeaponBookPackWindow then
            fwin:open(WeaponBookPack:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local weapon_book_pack_window_close_terminal = {
    _name = "weapon_book_pack_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WeaponBookPackClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(weapon_book_pack_window_open_terminal)
state_machine.add(weapon_book_pack_window_close_terminal)
state_machine.init()

function WeaponBookPack:ctor()
    self.super:ctor()
    self.roots = {}

    self._select_ship = nil
    self._choose_weapon_book = nil
    --1：查看， 2穿戴
    self._open_type = 0

    local function init_weapon_book_pack_terminal()
        local weapon_book_pack_left_prop_draw_terminal = {
            _name = "weapon_book_pack_left_prop_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local weapon_book = params[1]
                instance._choose_weapon_book = weapon_book
                instance:onUpdateDrawLeftProp(weapon_book)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local weapon_book_pack_wear_terminal = {
            _name = "weapon_book_pack_wear",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._select_ship.weapon_book_id = instance._choose_weapon_book.user_equiment_id
                instance._choose_weapon_book.ship_id = instance._select_ship.ship_id
                state_machine.excute("weapon_book_pack_window_close",0,nil)
                state_machine.excute("weapon_book_main_update_draw",0,"")
                -- local function responseCallback( response )
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         state_machine.excute("weapon_book_pack_window_close",0,nil)
                --         state_machine.excute("weapon_book_main_change_ship",0,"")
                --     end
                -- end
                -- protocol_command.rider_horse.param_list = instance._choose_horse.id.."\r\n"..instance._select_ship.ship_id
                -- NetworkManager:register(protocol_command.rider_horse.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(weapon_book_pack_left_prop_draw_terminal)
        state_machine.add(weapon_book_pack_wear_terminal)
        state_machine.init()
    end
    init_weapon_book_pack_terminal()
end

function WeaponBookPack:onUpdateDrawLeftProp( weapon_book )
    local root = self.roots[1]
    local Panel_horse_picture = ccui.Helper:seekWidgetByName(root, "Panel_horse_picture")       -- 兵符图片
    local Panel_quality = ccui.Helper:seekWidgetByName(root, "Panel_quality")                   -- 品质框
    local Text_horse_name = ccui.Helper:seekWidgetByName(root, "Text_horse_name")
    local Panel_stars = ccui.Helper:seekWidgetByName(root, "Panel_stars")

    Panel_horse_picture:removeBackGroundImage()
    Panel_quality:removeBackGroundImage()
    Text_horse_name:setString("")
    Panel_stars:removeAllChildren(true)

    local ListView_infor = ccui.Helper:seekWidgetByName(root, "ListView_infor")
    ListView_infor:removeAllItems()

    local csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_1)
    local root1 = csbItem:getChildByName("root")
    root1:removeFromParent(false)
    ListView_infor:addChild(root1)
    ccui.Helper:seekWidgetByName(root1, "Text_title_1"):setVisible(true)
    ccui.Helper:seekWidgetByName(root1, "Text_title_2"):setVisible(false)
    
    local Text_infor_name_1 = nil
    local Text_infor_add_1  = nil
    local Text_infor_name_2 = nil
    local Text_infor_add_2  = nil

    local weapon_data = dms.element(dms["equipment_mould"], weapon_book.user_equiment_template)
    local quality = weapon_book.quality
    local talent_mould_id = dms.atoi(weapon_data, equipment_mould.equipment_talent_ids)
    local initial_value = dms.atos(weapon_data, equipment_mould.initial_value)
    local initial_value_info = zstring.split(initial_value, "|")

    Panel_horse_picture:setBackGroundImage(string.format("images/ui/equip/equip_%d.png", weapon_book.icon))
    Panel_quality:setBackGroundImage(string.format("images/ui/quality/equipment_box_%d.png", quality))
    Text_horse_name:setString(weapon_book.user_equiment_name)
    Text_horse_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    draw.addWeaponBookStar(Panel_stars, weapon_book.rank_level, 0)

    for k, attr in pairs(initial_value_info) do
        local attr_info = zstring.split(attr, ",")
        if (k % 2) ~= 0 then
            csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_2)
            root1 = csbItem:getChildByName("root")
            root1:removeFromParent(false)
            ListView_infor:addChild(root1)
            Text_infor_name_1 = ccui.Helper:seekWidgetByName(root1, "Text_infor_name_1")
            Text_infor_add_1 = ccui.Helper:seekWidgetByName(root1, "Text_infor_add_1")
            Text_infor_name_2 = ccui.Helper:seekWidgetByName(root1, "Text_infor_name_2")
            Text_infor_add_2 = ccui.Helper:seekWidgetByName(root1, "Text_infor_add_2")
            Text_infor_name_1:setString(attribute[zstring.tonumber(attr_info[1]) + 1])
            Text_infor_add_1:setString("+"..attr_info[2])
            Text_infor_name_2:setString("")
            Text_infor_add_2:setString("")
        else
            Text_infor_name_2:setString(attribute[zstring.tonumber(attr_info[1]) + 1])
            Text_infor_add_2:setString("+"..attr_info[2])
        end
    end

    if talent_mould_id > 0 then
        csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_3)
        root1 = csbItem:getChildByName("root")
        root1:removeFromParent(false)
        ListView_infor:addChild(root1)
        local skill_name = dms.string(dms["talent_mould"], talent_mould_id, talent_mould.skill_name)
        local skill_desc = dms.string(dms["talent_mould"], talent_mould_id, talent_mould.talent_describe)
        ccui.Helper:seekWidgetByName(root1, "Text_skills_name"):setString(skill_name)

        csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_4)
        root1 = csbItem:getChildByName("root")
        root1:removeFromParent(false)
        ListView_infor:addChild(root1)
        ccui.Helper:seekWidgetByName(root1, "Text_skills_infor"):setString(skill_desc)
    end

    local isAddTitle = false
    for k,mould_id in pairs(weapon_book.attr_ids) do
        local skill_data = dms.element(dms["lead_mould"], mould_id)
        local skill_name = dms.atos(skill_data, lead_mould.name)            -- 秘籍名
        local distribute = dms.atos(skill_data, lead_mould.distribute)            -- 属性名
        local icon = dms.atoi(skill_data, lead_mould.icon)                  -- 图标
        local current_level = dms.atoi(skill_data, lead_mould.current_level)-- 初始等级
        local current_att = dms.atos(skill_data, lead_mould.current_att)    -- 当前属性
        local grow_att = dms.atos(skill_data, lead_mould.grow_att)          -- 每级增加属性
        local is_opend = dms.atoi(skill_data, lead_mould.is_opend)         -- 是否激活
        local level = weapon_book.weapon_book_levels[k]     -- 实际等级

        local current_att_value = zstring.tonumber(zstring.split(current_att, ",")[2])
        local grow_att_value = zstring.tonumber(zstring.split(grow_att, ",")[2])
        local attr_value = current_att_value + (level - current_level) * grow_att_value     -- 实际属性

        if is_opend > 0 then
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

            ccui.Helper:seekWidgetByName(root1, "Text_enchant_name"):setString(skill_name)
            ccui.Helper:seekWidgetByName(root1, "Text_enchant_add"):setString(distribute.."+"..attr_value)
            ccui.Helper:seekWidgetByName(root1, "Panel_icon"):setBackGroundImage(string.format("images/ui/weapon_book/weapon_book_icon_%d.png", icon))
        end
    end
    ListView_infor:requestRefreshView()
end

function WeaponBookPack:onUpdateDraw()
    local root = self.roots[1]
    local Panel_left = ccui.Helper:seekWidgetByName(root,"Panel_left")
    local Panel_horse_soul_left = ccui.Helper:seekWidgetByName(root,"Panel_horse_soul_left")
    Panel_left:setVisible(true)
    Panel_horse_soul_left:setVisible(false)
    self.panel:removeAllChildren(true)
    state_machine.excute("weapon_book_scrollview_window_open", 0, {self.panel, self._open_type})

    if self._open_type == 1 then
        ccui.Helper:seekWidgetByName(root, "Button_wear"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root, "Button_wear"):setVisible(true)
    end
end

function WeaponBookPack:onInit( )
    local csbItem = csb.createNode(config_csb.weapon_book.weapon_book_packs)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local Panel_packs = ccui.Helper:seekWidgetByName(root,"Panel_packs")
    Panel_packs:removeAllChildren(true)
    self.panel = Panel_packs
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "weapon_book_pack_window_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    -- 穿戴
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wear"), nil, 
    {
        terminal_name = "weapon_book_pack_wear",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    self:onUpdateDraw()
end

function WeaponBookPack:init(params)
    self._open_type = params[1]
    self._select_ship = params[2]
    self:onInit()
    return self
end

function WeaponBookPack:onExit()
    state_machine.remove("weapon_book_pack_left_prop_draw")
    state_machine.remove("weapon_book_pack_wear")
end