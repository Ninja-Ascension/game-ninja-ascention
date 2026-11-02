-----------------------------
--浮动详细信息
-----------------------------
EquipmentInformation = class("EquipmentInformationClass", Window)

local equipment_information_window_open_terminal = {
    _name = "equipment_information_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("PropsInformationClass")
        if nil == _Window then
            local prop_show_type = params[1]
            local prop_data = params[2]
            local prop = params[3]
            local prop_from_type = params[4]
            local index = params[5]
            local show_name = params[6]
            local show_numbers = params[7]
            local pos = params[8]
            local other_player = params[9]
            fwin:open(EquipmentInformation:new():init(prop_show_type,prop_data,prop,prop_from_type,index,show_name,show_numbers,pos,other_player), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local equipment_information_window_close_terminal = {
    _name = "equipment_information_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentInformationClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_information_window_open_terminal)
state_machine.add(equipment_information_window_close_terminal)
state_machine.init()

function EquipmentInformation:ctor()
    self.super:ctor()
    self.roots = {}
    self.prop_show_type = nil
    self.prop_data = nil
    self.prop = nil
    self.prop_from_type = nil

    self.prop_type = nil
    self.prop_numbers = nil
    self.prop_id = nil
    self.prop_name = ""
    self.__size = nil
    --其他玩家信息
    self._other_player = nil

    app.load("client.red_alert.packs.EquipStrengthSmallCell")
    app.load("client.red_alert.packs.EquipGemsSmallCell")

    -- Initialize props_information state machine.
    local function init_props_information_terminal()

        state_machine.init()
    end
    
    -- call func init props_information machine.
    init_props_information_terminal()
end

function EquipmentInformation:drawEquipListInfoByMouldID(equipment_mould_id)
    local root = self.roots[1]
    local ListView_equ = ccui.Helper:seekWidgetByName(root,"ListView_equ")
    ListView_equ:removeAllItems()
    local heigth_n = 0
    local init_pow_number = dms.string(dms["equipment_mould"],equipment_mould_id,equipment_mould.initial_value)
    local additive_attribute = dms.string(dms["equipment_mould"],equipment_mould_id,equipment_mould.additive_attribute)
    local equip_grow_type = 0 -- 成长类型
    init_pow_number = zstring.split(init_pow_number,",")
    equip_grow_type = tonumber(init_pow_number[1])
    init_pow_number = tonumber(init_pow_number[2]) 
    local now_grade = 1
    local add_str = attribute[tonumber(equip_grow_type)+1]

    local other_add_str = ""
    local other_add_number = 0

    if additive_attribute ~= "-1" then
        additive_attribute = zstring.split(additive_attribute,",")
        other_add_str = tonumber(additive_attribute[1])
        other_add_number = tonumber(additive_attribute[2])
    end

    local dec_text_tab = {
        {
            dec_name = red_alert_all_str[95],
            dec =  (now_grade-1).."/".._ED.user_info.user_grade
        },
        {
            dec_name = red_alert_all_str[19]..add_str,
            dec =  init_pow_number
        },
        {
            dec_name = attribute[other_add_str],
            dec =  other_add_number
        },
    }

    for i,v in pairs(dec_text_tab) do
        if v.dec ~= 0 then
            local equip_strength_cell = state_machine.excute("equip_strength_small_create_cell",0,{v})
            ListView_equ:addChild(equip_strength_cell)
            heigth_n = heigth_n + 1
        end
    end
    local equip_gems_cell = state_machine.excute("equip_gems_small_create_cell",0,{nil,3})
    ListView_equ:addChild(equip_gems_cell)
    heigth_n = heigth_n + 1
    local gem_numbers = dms.int(dms["equipment_mould"],self.prop_id,equipment_mould.equipment_gem_numbers)
    for i = 1,gem_numbers do
        local gems_cell = state_machine.excute("equip_gems_small_create_cell",0,{nil,4})
        ListView_equ:addChild(gems_cell)
        heigth_n = heigth_n + 1
    end
    return heigth_n
end

function EquipmentInformation:drawEquipListInfo(equip)
    local root = self.roots[1]
    local ListView_equ = ccui.Helper:seekWidgetByName(root,"ListView_equ")
    ListView_equ:removeAllItems()

    local heigth_n = 0

    local init_pow_number = dms.string(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.initial_value)
    local additive_attribute = dms.string(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.additive_attribute)
    local equip_grow_type = 0 -- 成长类型
    init_pow_number = zstring.split(init_pow_number,",")
    equip_grow_type = tonumber(init_pow_number[1])
    init_pow_number = tonumber(init_pow_number[2]) 
    local pow_table = zstring.split(equip.user_equiment_ability,",")
    local now_pow_number = tonumber(pow_table[2])
    local now_grade = tonumber(equip.user_equiment_grade)
    local add_str = attribute[tonumber(equip_grow_type)+1]
    local add_pow_number = now_pow_number - init_pow_number


    local other_add_str = ""
    local other_add_number = 0

    if additive_attribute ~= "-1" then
        additive_attribute = zstring.split(additive_attribute,",")
        other_add_str = tonumber(additive_attribute[1])
        other_add_number = tonumber(additive_attribute[2])
    end

    local dec_text_tab = {
        {
            dec_name = red_alert_all_str[95],
            dec =  (now_grade-1).."/".._ED.user_info.user_grade
        },
        {
            dec_name = red_alert_all_str[19]..add_str,
            dec =  init_pow_number
        },
        {
            dec_name = red_alert_all_str[20]..add_str,
            dec =  add_pow_number
        },
        {
            dec_name = attribute[other_add_str],
            dec =  other_add_number
        },
    }

    for i,v in pairs(dec_text_tab) do
        if v.dec ~= 0 then
            local equip_strength_cell = state_machine.excute("equip_strength_small_create_cell",0,{v})
            ListView_equ:addChild(equip_strength_cell)
            heigth_n = heigth_n + 1
        end
    end
    local equip_gems_cell = state_machine.excute("equip_gems_small_create_cell",0,{nil,3})
    ListView_equ:addChild(equip_gems_cell)
    heigth_n = heigth_n + 1
    local gem_numbers = dms.int(dms["equipment_mould"],self.prop_id,equipment_mould.equipment_gem_numbers)
    for i = 1,gem_numbers do
        if tonumber(equip.jewelrys[i]) > 0 then
            local gems_id = equip.jewelrys[i]
            local gems_cell = nil 
            if self._other_player ~= nil then
                gems_cell = state_machine.excute("equip_gems_small_create_cell",0,{_ED.other_user_gems[""..gems_id]})
            else
                gems_cell = state_machine.excute("equip_gems_small_create_cell",0,{_ED.user_gems[""..gems_id]})
            end
            ListView_equ:addChild(gems_cell)
            heigth_n = heigth_n + 1
        else
            local gems_cell = state_machine.excute("equip_gems_small_create_cell",0,{nil,4})
            ListView_equ:addChild(gems_cell)
            heigth_n = heigth_n + 1
        end
    end
    return heigth_n
end

function EquipmentInformation:onUpdateDraw()
    local root = self.roots[1]
    local prop_id = self.prop_id
    local rank_level = dms.int(dms["equipment_mould"],prop_id,equipment_mould.rank_level) -- 套装品质
    local quality = dms.int(dms["equipment_mould"],prop_id,equipment_mould.grow_level) -- 品质
    local name = dms.string(dms["equipment_mould"],prop_id,equipment_mould.equipment_name) -- 名字
    local fight_number = self.prop.equip_fight or getEquipmentFightByMouldId(prop_id) -- 有实力的直接取战力 没有的通过普通模板取


    local Panel_3 = ccui.Helper:seekWidgetByName(root,"Panel_3") -- 父层
    local Panel_equ_infor_icon = ccui.Helper:seekWidgetByName(root,"Panel_equ_infor_icon") -- 图标
    local Text_equ_infor_name = ccui.Helper:seekWidgetByName(root,"Text_equ_infor_name")   -- 名字
    local Text_equ_infor_fight = ccui.Helper:seekWidgetByName(root,"Text_equ_infor_fight") -- 战力
    local Text_props_infor_number_grade = ccui.Helper:seekWidgetByName(root,"Text_props_infor_number_grade") -- 品级

    --背景色
    local Image_equ_infor_bg_1 = ccui.Helper:seekWidgetByName(root,"Image_equ_infor_bg_1")
    local Image_equ_infor_bg_2 = ccui.Helper:seekWidgetByName(root,"Image_equ_infor_bg_2")
    local Image_equ_infor_bg_3 = ccui.Helper:seekWidgetByName(root,"Image_equ_infor_bg_3")
    local Image_equ_infor_bg_4 = ccui.Helper:seekWidgetByName(root,"Image_equ_infor_bg_4")
    local Image_equ_infor_bg_5 = ccui.Helper:seekWidgetByName(root,"Image_equ_infor_bg_5")

    local Image_equ_infor_bg = ccui.Helper:seekWidgetByName(root,"Image_equ_infor_bg_"..quality)

    local height_max = 7 
    local heigth_n = 0
    local one_height = 22

    if self.prop.equip_fight == nil then
        heigth_n = self:drawEquipListInfoByMouldID(prop_id) -- 模板id
    else
        heigth_n = self:drawEquipListInfo(self.prop) -- 有实例的属性绘制
    end
    Image_equ_infor_bg:setContentSize(cc.size(Image_equ_infor_bg:getContentSize().width,Image_equ_infor_bg:getContentSize().height + (math.max(heigth_n - height_max,0)) * one_height))
    root:setContentSize(cc.size(root:getContentSize().width,root:getContentSize().height + (math.max(heigth_n - height_max,0)) * one_height))
    Panel_3:setPositionY(Panel_3:getPositionY() + (math.max(heigth_n - height_max,0)) * one_height )
    local cell = state_machine.excute("all_resource_create_cell",0,{self.prop_show_type,self.prop_data,self.prop,8,0,false,false})
    Panel_equ_infor_icon:addChild(cell)
   
    Text_equ_infor_name:setString(name)
    Text_equ_infor_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    Text_equ_infor_fight:setString(fight_number)
    Text_props_infor_number_grade:setString(rank_level)
    Image_equ_infor_bg_1:setVisible(false)
    Image_equ_infor_bg_2:setVisible(false)
    Image_equ_infor_bg_3:setVisible(false)
    Image_equ_infor_bg_4:setVisible(false)
    Image_equ_infor_bg_5:setVisible(false)

    if quality + 1 == 2 then
        Image_equ_infor_bg_1:setVisible(true)
    elseif quality + 1 == 3 then
        Image_equ_infor_bg_2:setVisible(true)
    elseif quality + 1 == 4 then
        Image_equ_infor_bg_3:setVisible(true)
    elseif quality + 1 == 5 then
        Image_equ_infor_bg_4:setVisible(true)
    elseif quality + 1 == 6 then
        Image_equ_infor_bg_5:setVisible(true)
    end

end

function EquipmentInformation:drawSuitInfo()
    local root = self.roots[1]
    local prop_id = self.prop_id
    local Text_equ_infor_set_name = ccui.Helper:seekWidgetByName(root,"Text_equ_infor_set_name")
    local Text_equ_infor_set_1 = ccui.Helper:seekWidgetByName(root,"Text_equ_infor_set_1")
    local Text_equ_infor_set_2 = ccui.Helper:seekWidgetByName(root,"Text_equ_infor_set_2")
    local Text_equ_infor_set_3 = ccui.Helper:seekWidgetByName(root,"Text_equ_infor_set_3")
    local Text_equ_infor_set_4 = ccui.Helper:seekWidgetByName(root,"Text_equ_infor_set_4")
    local Text_equ_infor_set_5 = ccui.Helper:seekWidgetByName(root,"Text_equ_infor_set_5")
    local Text_equ_infor_set_6 = ccui.Helper:seekWidgetByName(root,"Text_equ_infor_set_6") 

    local Text_equ_infor_set_add_1 = ccui.Helper:seekWidgetByName(root,"Text_equ_infor_set_add_1")
    local Text_equ_infor_set_add_2 = ccui.Helper:seekWidgetByName(root,"Text_equ_infor_set_add_2")
    local Text_equ_infor_set_add_3 = ccui.Helper:seekWidgetByName(root,"Text_equ_infor_set_add_3")

    local suit_id = dms.int(dms["equipment_mould"],prop_id,equipment_mould.suit_id)
    local name = dms.string(dms["suit_param"],suit_id,suit_param.suit_name)
    local activate_property1 = dms.string(dms["suit_param"],suit_id,suit_param.activate_property1)
    activate_property1 = zstring.split(activate_property1,"|")
    local activate_property2 = dms.string(dms["suit_param"],suit_id,suit_param.activate_property2)
    activate_property2 = zstring.split(activate_property2,"|")
    local activate_property3 = dms.string(dms["suit_param"],suit_id,suit_param.activate_property3)
    activate_property3 = zstring.split(activate_property3,"|")

    Text_equ_infor_set_name:setString(name)
    local str2 = red_alert_all_str[98]
    local str4 = red_alert_all_str[99]
    local str6 = red_alert_all_str[100]
    for i,v in pairs(activate_property1) do
        local activate_property = zstring.split(v,",")
        local text_title = tonumber(activate_property[1]) + 1
        text_title = attribute[text_title]
        local text_str = tonumber(activate_property[2])
        text_str = "+" .. text_str
        if i == 1 then 
            str2 = str2 ..":" .. text_title .. text_str .. " "
        else
            str2 = str2 .. text_title .. text_str .. " "
        end
    end

    for i,v in pairs(activate_property2) do
        local activate_property = zstring.split(v,",")
        local text_title = tonumber(activate_property[1]) + 1
        text_title = attribute[text_title]
        local text_str = tonumber(activate_property[2])
        text_str = "+" .. text_str
        if i == 1 then 
            str4 = str4 ..":" .. text_title .. text_str .. " "
        else
            str4 = str4 .. text_title .. text_str .. " "
        end
    end

    for i,v in pairs(activate_property3) do
        local activate_property = zstring.split(v,",")
        local text_title = tonumber(activate_property[1]) + 1
        text_title = attribute[text_title]
        local text_str = tonumber(activate_property[2])
        text_str = "+" .. text_str
        if i == 1 then 
            str6 = str6 ..":" .. text_title .. text_str .. " "
        else
            str6 = str6 .. text_title .. text_str .. " "
        end
    end

    local suit_other_mould = {}
    local index = 0
    for i = 1, dms.count(dms["equipment_mould"]) do
        local suit_id_temp = dms.int(dms["equipment_mould"],i,equipment_mould.suit_id)
        if suit_id_temp == suit_id then
            table.insert(suit_other_mould,i)
            index = index + 1
        end 
    end

    Text_equ_infor_set_1:setString(dms.string(dms["equipment_mould"],suit_other_mould[1],equipment_mould.equipment_name))
    Text_equ_infor_set_2:setString(dms.string(dms["equipment_mould"],suit_other_mould[2],equipment_mould.equipment_name))
    Text_equ_infor_set_3:setString(dms.string(dms["equipment_mould"],suit_other_mould[3],equipment_mould.equipment_name))
    Text_equ_infor_set_4:setString(dms.string(dms["equipment_mould"],suit_other_mould[4],equipment_mould.equipment_name))
    Text_equ_infor_set_5:setString(dms.string(dms["equipment_mould"],suit_other_mould[5],equipment_mould.equipment_name))
    Text_equ_infor_set_6:setString(dms.string(dms["equipment_mould"],suit_other_mould[6],equipment_mould.equipment_name))

    Text_equ_infor_set_add_1:setString(str2)
    Text_equ_infor_set_add_2:setString(str4)
    Text_equ_infor_set_add_3:setString(str6)

    --点亮
    if self.prop.equip_fight ~= nil then
        local ship_id = self.prop.ship_id
        if tonumber(ship_id) > 0 then
            local ship = _ED.user_ship[""..ship_id]
            if ship == nil then
                ship = _ED.other_user_ship[""..ship_id]
            end
            local have_equip_numbers = 0
            local now_equip_moulds = {}
            for i,v in pairs(ship.equipment) do
                if tonumber(v.user_equiment_id) > 0 then
                    local equip_temp = _ED.user_equiment[""..v.user_equiment_id]
                    if equip_temp == nil then
                        equip_temp = _ED.other_user_equiment[""..v.user_equiment_id]
                    end
                    table.insert(now_equip_moulds,equip_temp.user_equiment_template)
                end
            end

            for i,v in pairs(suit_other_mould) do
                for j,k in pairs(now_equip_moulds) do
                    if tonumber(v) == tonumber(k) then
                        local Text_equ_infor_set = ccui.Helper:seekWidgetByName(root,"Text_equ_infor_set_"..i)
                        Text_equ_infor_set:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
                        have_equip_numbers = have_equip_numbers + 1
                        break
                    end
                end
            end
            if have_equip_numbers >= 6 then
                Text_equ_infor_set_add_1:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
                Text_equ_infor_set_add_2:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
                Text_equ_infor_set_add_3:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
            elseif have_equip_numbers >= 4 then
                Text_equ_infor_set_add_1:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
                Text_equ_infor_set_add_2:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
            elseif have_equip_numbers >= 2 then
                Text_equ_infor_set_add_1:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
            end
        end
    end
end

function EquipmentInformation:onEnterTransitionFinish()

end

function EquipmentInformation:onInit( )
    local csbItem = csb.createNode(config_csb.packs.equipstorage.equipment_information)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_equ_infor"), nil, 
    {
        terminal_name = "equipment_information_window_close", 
        terminal_state = 0, 
    }, nil, 0)
    self:onUpdateDraw() 
    self:drawSuitInfo()

    self.__size = root:getContentSize()
    
end

function EquipmentInformation:init(prop_show_type,prop_data,prop,prop_from_type,index,show_name,show_numbers,pos,other_player)
    self.prop_show_type = prop_show_type
    self.prop_data = prop_data
    self.prop = prop
    self.prop_from_type = prop_from_type

    self.prop_type = prop_data.prop_type
    self.prop_numbers = prop_data.item_value
    self.prop_id = prop_data.prop_item
    self.prop_name = ""
    self._other_player = other_player
    self:onInit()
    self:setContentSize(self.__size)
    local x = math.max(pos.x/ app.scaleFactor,0)
    x = math.min(x,(fwin._width - self.__size.width))
    local y = math.max(0,pos.y/ app.scaleFactor)
    y = math.min(y,(fwin._height - self.__size.height))
    -- print("=============height=======",fwin._height,EquipmentInformation.__size.height)
    self:setPosition(cc.p(x,y))
    return self
end

function EquipmentInformation:onExit()

end
