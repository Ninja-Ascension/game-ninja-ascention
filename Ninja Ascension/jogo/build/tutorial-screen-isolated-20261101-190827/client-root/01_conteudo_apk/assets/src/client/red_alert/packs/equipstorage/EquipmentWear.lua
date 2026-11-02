-----------------------------
--装备穿戴界面
-----------------------------
EquipmentWear = class("EquipmentWearClass", Window)

local equipment_wear_window_open_terminal = {
    _name = "equipment_wear_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("EquipmentWearClass")
        if nil == _Window then
            local equip_type = params[1]
            local ship = params[2]
            fwin:open(EquipmentWear:new():init(equip_type,ship), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local equipment_wear_window_close_terminal = {
    _name = "equipment_wear_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentWearClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_wear_window_open_terminal)
state_machine.add(equipment_wear_window_close_terminal)
state_machine.init()

function EquipmentWear:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.equip_type = nil  
    self.ship = nil
    self.equip = nil
    self.all_equips = {}

    app.load("client.red_alert.packs.EquipStrengthCell")
    app.load("client.red_alert.packs.EquipGemsCell")
    -- Initialize DuplicateTitle state machine.
    local function init_equipment_wear_terminal()

        --穿戴
        local equipment_wear_to_wear_terminal = {
            _name = "equipment_wear_to_wear",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local str = ""
                str = str..instance.ship.ship_id.."\r\n"--佩戴船只ID
                str = str..instance.equip.user_equiment_id.."\r\n"--装备ID
                str = str..instance.equip_type.."\r\n"--装备位标识
                str = str.."1"

                local text_table = instance:calAllAddPro()
                local function responseWearEquipCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("equipment_show_wear_success",0,"")
                        state_machine.excute("equipment_wear_close",0,"")
                        state_machine.excute("add_number_window_open",0,{8,text_table})
                        pushEffect(formatMusicFile("effect", 10007))
                    end
                end
                protocol_command.equipment_adorn.param_list = str
                NetworkManager:register(protocol_command.equipment_adorn.code, nil, nil, nil, nil, responseWearEquipCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --更新左侧绘图
        local equipment_wear_update_left_draw_terminal = {
            _name = "equipment_wear_update_left_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawLeftProp(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --取消所有选中
        local equipment_wear_un_set_selected_terminal = {
            _name = "equipment_wear_un_set_selected",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setUnSelecet()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --关闭界面
        local equipment_wear_close_terminal = {
            _name = "equipment_wear_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onWindowClose()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(equipment_wear_to_wear_terminal)	
        state_machine.add(equipment_wear_update_left_draw_terminal)
        state_machine.add(equipment_wear_un_set_selected_terminal)
        state_machine.add(equipment_wear_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_equipment_wear_terminal()
end

function EquipmentWear:calAllAddPro()
    local text_table = {}
    local equip = self.equip

    local temp = equip.user_equiment_ability
    temp = zstring.split(temp,",")
    local add_type = tonumber(temp[1]) + 1
    local add_numbers = tonumber(temp[2])
    table.insert(text_table,attribute[add_type] .. "+" .. add_numbers)

    local equipment_mould_id = equip.user_equiment_template
    local additive_attribute = dms.string(dms["equipment_mould"],equipment_mould_id,equipment_mould.additive_attribute)

    if additive_attribute ~= "-1" then
        additive_attribute = zstring.split(additive_attribute,",")
        local add_pro_type = tonumber(additive_attribute[1]) + 1
        local add_pro_number = tonumber(additive_attribute[2])
        table.insert(text_table,attribute[add_pro_type] .. "+" .. add_pro_number)
    end

    for i,v in pairs(equip.jewelrys) do
        if tonumber(v) > 0 then
            local user_gem = _ED.user_gems[""..v]
            local user_gem_mould_id = user_gem.mould_id
            local add_str = dms.string(dms["gems_mould"],user_gem_mould_id,gems_mould.add_attribute)
            add_str = zstring.split(add_str,",")
            local gem_add_type = tonumber(add_str[1]) + 1
            local gem_add_numbers = tonumber(add_str[2])
            table.insert(text_table,attribute[gem_add_type] .. "+" .. gem_add_numbers)
        end
    end

    return text_table
end

function EquipmentWear:setUnSelecet()
    local root = self.roots[1]
    local ScrollView_dress = ccui.Helper:seekWidgetByName(root,"ScrollView_dress")
    for i,v in pairs(ScrollView_dress:getChildren()) do
        if v.selected == true then
            v.selected = false
            v:setSelected()
            return
        end
    end
end

function EquipmentWear:onUpdateDrawLeftProp(data)
    local  root = self.roots[1]    
    local prop_show_type = data[1]
    local prop_data = data[2]
    local prop = data[3]
    local prop_from_type = data[4]
    self.equip = prop    
    local Panel_dress_dress_props_icon = ccui.Helper:seekWidgetByName(root,"Panel_dress_dress_props_icon")
    Panel_dress_dress_props_icon:removeAllChildren(true)
    local cell = state_machine.excute("all_resource_create_cell",0,{prop_show_type,prop_data,prop,9,0})
    Panel_dress_dress_props_icon:addChild(cell)
    local Text_packs_resolve_fight = ccui.Helper:seekWidgetByName(root,"Text_packs_resolve_fight")
    Text_packs_resolve_fight:setString(prop.equip_fight)
    local quality = dms.int(dms["equipment_mould"],prop.user_equiment_template,equipment_mould.grow_level)
    local rank_level = dms.int(dms["equipment_mould"],prop.user_equiment_template,equipment_mould.rank_level)
    local Text_packs_quatily = ccui.Helper:seekWidgetByName(root,"Text_packs_quatily")
    Text_packs_quatily:setString(rank_level)

    local Text_dress_props_name = ccui.Helper:seekWidgetByName(root,"Text_dress_props_name")
    Text_dress_props_name:setString(prop.user_equiment_name)
    Text_dress_props_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))


    self:drawEquipListInfo(prop)
end

function EquipmentWear:drawEquipListInfo(equip)
    local root = self.roots[1]
    local ListView_dress = ccui.Helper:seekWidgetByName(root,"ListView_dress")
    ListView_dress:removeAllItems()


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

    -- debug.print_r(dec_text_tab)
    local equip_strength_cell = state_machine.excute("equip_strength_create_cell",0,{nil})
    ListView_dress:addChild(equip_strength_cell)
    for i,v in pairs(dec_text_tab) do
        if v.dec ~= 0 then
            local equip_strength_cell = state_machine.excute("equip_strength_create_cell",0,{v})
            ListView_dress:addChild(equip_strength_cell)
        end
    end
    local equip_gems_cell = state_machine.excute("equip_gems_create_cell",0,{nil,1})
    ListView_dress:addChild(equip_gems_cell)
    local have_gems = false
    for i,v in pairs(equip.jewelrys) do
        if tonumber(v) ~= 0 then
            local gems_id = v
            local gems_cell = state_machine.excute("equip_gems_create_cell",0,{_ED.user_gems[""..gems_id]})
            ListView_dress:addChild(gems_cell)
            have_gems = true
        end
    end
    if have_gems == false then
        local gems_cell = state_machine.excute("equip_gems_create_cell",0,{nil,2})
        ListView_dress:addChild(gems_cell)
    end
end

function EquipmentWear:onUpdateDraw()
    local root = self.roots[1]
    local all_row = 0
    local all_col = 0
    local ScrollView_dress = ccui.Helper:seekWidgetByName(root,"ScrollView_dress")
    local width = ScrollView_dress:getContentSize().width
    local height = ScrollView_dress:getContentSize().height

    local scroll_height = 0
    local index = 0
    for i = 1,10000 do
        local v = self.all_equips[i]
        index = index + 1
        local wight_n = 1
        local height_n = 1
        if i % 4 == 0 then
            wight_n = 4
        else
            wight_n = i % 4
        end
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end
    if index % 4 == 0 then
        scroll_height = index / 4
    else
        scroll_height = math.floor(index / 4) + 1
    end

    if scroll_height*92 > height then
        height = scroll_height*92
    end

    for i = 1,10000 do
        local v = self.all_equips[i]
        local wight_n = 1
        local height_n = 1
        if i % 4 == 0 then
            wight_n = 4
        else
            wight_n = i % 4
        end

        if i % 4 == 0 then
            height_n = i / 4
        else
            height_n = math.floor(i / 4) + 1
        end
        local cell = nil 
        if v == nil then
            cell = state_machine.excute("packs_icon_bg_create_cell",0,"")
        else
            cell = state_machine.excute("all_resource_create_cell",0,{5,v.prop_data,v.prop,7,0})
        end
        if i == 1 and v ~= nil then
            state_machine.excute("all_resource_set_selected",0,{_datas = {_cell = cell }})
        end
        cell:setAnchorPoint(cc.p(0,1))
        cell:setPosition(cc.p((wight_n-1)*(width/4),height - (height_n-1)*92))
        ScrollView_dress:addChild(cell)

        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end   
    ScrollView_dress:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_dress:jumpToTop()
end

function EquipmentWear:getAllData()
    local result = {}
    for i,v in pairs(_ED.user_equiment) do
        if tonumber(v.ship_id) > 0 or tonumber(v. rela_state) > 0 then
        else
            if tonumber(v.equipment_type) == self.equip_type then
                local data = 
                {
                    prop_data = 
                    {
                        item_value = 1,
                        prop_type = 7,
                        prop_item = v.user_equiment_template,
                    },
                    prop = v ,
                }
                table.insert(result,data)
            end
        end
    end    
    -- 排序
    local function sortEquipmentSuit( a, b )
        return tonumber(a.prop.suit_id) > tonumber(b.prop.suit_id) 
        or tonumber(a.prop.suit_id) == tonumber(b.prop.suit_id) and tonumber(a.prop.user_equiment_grade) > tonumber(b.prop.user_equiment_grade)
    end
    table.sort(result, sortEquipmentSuit)
    return result 
end

function EquipmentWear:onEnterTransitionFinish()

end

-- 关闭装备穿戴界面
function EquipmentWear:onWindowClose()
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("window_close", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("equipment_wear_window_close", 0, "")
        end
    end)
end

function EquipmentWear:onInit( )
    local csbItem = csb.createNode(config_csb.packs.equipstorage.equipment_wear)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.packs.equipstorage.equipment_wear)
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_opwn", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        if frame == "window_opwn_over" then
            
        end
    end)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_equipment_wear_close"), nil, 
    {
        terminal_name = "equipment_wear_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --穿戴
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_dress"), nil, 
    {
        terminal_name = "equipment_wear_to_wear", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()	
end


function EquipmentWear:init(equip_type , ship)
    self.equip_type = equip_type
    self.ship = ship
    self.all_equips = self:getAllData()
    -- debug.print_r(self.all_equips)
	self:onInit()
    return self
end

function EquipmentWear:onExit()
    state_machine.remove("equipment_wear_to_wear")
    state_machine.remove("equipment_wear_update_left_draw")
    state_machine.remove("equipment_wear_un_set_selected")
    state_machine.remove("equipment_wear_close")
end
