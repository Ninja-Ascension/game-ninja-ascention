-----------------------------
-- 秘籍属性修炼
-----------------------------
WeaponBookAttributeUp = class("WeaponBookAttributeUpClass", Window)
--打开
local weapon_book_attribute_up_window_open_terminal = {
    _name = "weapon_book_attribute_up_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _WeaponBookStrengthWindow = fwin:find("WeaponBookStrengthClass")
        if nil == _WeaponBookStrengthWindow then
            fwin:open(WeaponBookAttributeUp:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local weapon_book_attribute_up_window_close_terminal = {
    _name = "weapon_book_attribute_up_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WeaponBookAttributeUpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(weapon_book_attribute_up_window_open_terminal)
state_machine.add(weapon_book_attribute_up_window_close_terminal)
state_machine.init()

function WeaponBookAttributeUp:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._weapon_book = nil
    self._index = 0

    local function init_weapon_book_attribute_up_terminal()
        -- 关闭
        local weapon_book_attribute_up_close_terminal = {
            _name = "weapon_book_attribute_up_close",
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

        -- 精炼
        local weapon_book_attribute_up_skill_up_terminal = {
            _name = "weapon_book_attribute_up_skill_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local id = instance._weapon_book.user_equiment_id
                _ED.weapon_book[""..id].weapon_book_levels[instance._index] = _ED.weapon_book[""..id].weapon_book_levels[instance._index] + 1
                instance:onUpdateDraw()
                state_machine.excute("weapon_book_main_update_skill", 0, "")
                -- local function responseCallback( response )
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                --             response.node:onUpdateDraw()
                --         end
                --         state_machine.excute("weapon_book_main_update_skill", 0, "")   
                --     end
                -- end
                -- protocol_command.rider_horse.param_list = ""
                -- NetworkManager:register(protocol_command.rider_horse.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 一键精炼
        local weapon_book_attribute_up_fast_skill_up_terminal = {
            _name = "weapon_book_attribute_up_fast_skill_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- print("fast skill up")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新属性
        local weapon_book_attribute_up_update_draw_terminal = {
            _name = "weapon_book_attribute_up_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(weapon_book_attribute_up_close_terminal)
        state_machine.add(weapon_book_attribute_up_skill_up_terminal)
        state_machine.add(weapon_book_attribute_up_fast_skill_up_terminal)
        state_machine.add(weapon_book_attribute_up_update_draw_terminal)
        state_machine.init()
    end
    init_weapon_book_attribute_up_terminal()
end 

function WeaponBookAttributeUp:onUpdateDraw( ... )
    local root = self.roots[1]
    local Panel_hero_star_activation_icon = ccui.Helper:seekWidgetByName(root, "Panel_hero_star_activation_icon")   --兵符技能图像
    local Text_hero_star_activation_name = ccui.Helper:seekWidgetByName(root, "Text_hero_star_activation_name")     --兵符技能名称
    local Text_current_att = ccui.Helper:seekWidgetByName(root, "Text_current_att")                                 --当前属性名
    local Text_current_att_n = ccui.Helper:seekWidgetByName(root, "Text_current_att_n")                             --当前属性值
    local Text_sub_effice = ccui.Helper:seekWidgetByName(root, "Text_sub_effice")                                   --下一级效果
    local Text_sub_effice_t = ccui.Helper:seekWidgetByName(root, "Text_sub_effice_t")                               --下一级属性名
    local Text_sub_effice_t_0 = ccui.Helper:seekWidgetByName(root, "Text_sub_effice_t_0")                           --下一级属性值
    local Panel_hero_star_material = ccui.Helper:seekWidgetByName(root, "Panel_hero_star_material")                 --升级需要材料图像
    local Text_hero_star_material_number = ccui.Helper:seekWidgetByName(root, "Text_hero_star_material_number")     --升级需要材料数量
    local Text_hero_star_gold_have = ccui.Helper:seekWidgetByName(root, "Text_hero_star_gold_have")                 --当前拥有的材料数量
    local Text_hero_star_activation_no = ccui.Helper:seekWidgetByName(root, "Text_hero_star_activation_no")         --升级提示信息
    local Button_hero_star_activation_back_0 = ccui.Helper:seekWidgetByName(root, "Button_hero_star_activation_back_0")    --精炼
    local Button_hero_star_activation_back = ccui.Helper:seekWidgetByName(root, "Button_hero_star_activation_back")    --一键精炼

    Panel_hero_star_activation_icon:removeBackGroundImage()
    Text_hero_star_activation_name:setString("")
    Text_current_att:setString("")
    Text_current_att_n:setString("")
    Text_sub_effice_t:setString("")
    Text_sub_effice_t_0:setString("")
    Panel_hero_star_material:removeBackGroundImage()
    Text_hero_star_material_number:setString("")
    Text_hero_star_gold_have:setString("")
    Text_hero_star_activation_no:setVisible(false)
    Button_hero_star_activation_back_0:setVisible(false)
    Button_hero_star_activation_back:setVisible(false)

    local grow_level = self._weapon_book.quality   -- 对应兵符品质

    local mould_id = self._weapon_book.attr_ids[self._index]                          -- 兵符技能id
    local skill_data = dms.element(dms["lead_mould"], mould_id)

    local name = dms.atos(skill_data, lead_mould.name)            -- 秘籍名
    local distribute = dms.atos(skill_data, lead_mould.distribute)            -- 属性名
    local icon = dms.atoi(skill_data, lead_mould.icon)                  -- 图标
    local current_level = dms.atoi(skill_data, lead_mould.current_level)-- 初始等级
    local upgrade_cost = dms.atos(skill_data, lead_mould.upgrade_cost)  -- 升级花费
    local current_att = dms.atos(skill_data, lead_mould.current_att)    -- 当前属性
    local grow_att = dms.atos(skill_data, lead_mould.grow_att)          -- 每级增加属性
    local max_level = dms.atoi(skill_data, lead_mould.max_level)        -- 最大等级
    local is_opend = dms.atoi(skill_data, lead_mould.is_opend)         -- 是否激活

    local level = self._weapon_book.weapon_book_levels[self._index]     -- 实际等级

    -- 兵符技能名称
    Text_hero_star_activation_name:setString(name)
    Text_hero_star_activation_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[grow_level+1][1],tipStringInfo_quality_color_Type[grow_level+1][2],tipStringInfo_quality_color_Type[grow_level+1][3]))
    -- 兵符技能图像
    Panel_hero_star_activation_icon:setBackGroundImage(string.format("images/ui/weapon_book/weapon_book_icon_%d.png", icon))
    -- 升级花费
    local infos = zstring.split(upgrade_cost, ",")
    local data = {
        item_value = tonumber(infos[3]),
        prop_type = tonumber(infos[2]),
        prop_item = tonumber(infos[1]),
    }
    if data.prop_type == 33 then -- 拥有银两数
        Panel_hero_star_material:setBackGroundImage("images/ui/props/props_4019.png")
        local info = _ED.user_info.user_iron
        if tonumber(_ED.user_info.user_iron) >= 100000 then
            info = math.floor(tonumber(_ED.user_info.user_iron)/10000)
            info = string.format(red_alert_all_str[122],info)
        end
        Text_hero_star_gold_have:setString(string.format(red_alert_all_str[18], info))
    end

    Text_hero_star_material_number:setString("x"..data.item_value)
    -- 属性
    local current_att_value = zstring.tonumber(zstring.split(current_att, ",")[2])
    local grow_att_value = zstring.tonumber(zstring.split(grow_att, ",")[2])
    Text_current_att:setString(distribute)
    Text_sub_effice_t:setString(distribute)

    if is_opend > 0 then
        local attr_value = current_att_value + (level - current_level) * grow_att_value
        Text_current_att_n:setString("+"..attr_value)
        -- -- 下一级属性
        if level < max_level then
            local next_attr_value = attr_value + grow_att_value
            Text_sub_effice_t_0:setString("+"..next_attr_value)
        else
            Text_sub_effice_t:setVisible(false)
            Text_sub_effice_t_0:setVisible(false)
            Text_sub_effice:setVisible(false)
        end
    else
        Text_current_att_n:setString("+"..current_att_value)
        Text_sub_effice_t_0:setString("+"..(current_att_value + grow_att_value))
    end


    -- 判断升级条件
    if is_opend == 0 then               -- 未激活
        Text_hero_star_activation_no:setVisible(true)
        Text_hero_star_activation_no:setString(string.format(red_alert_all_str[250], self._index - 1))
    elseif level >= max_level then          -- 已升至最大级
        if self._weapon_book.rank_level < 5 then                -- 需要升星开启
            Text_hero_star_activation_no:setVisible(true)
            Text_hero_star_activation_no:setString(string.format(red_alert_all_str[250], self._weapon_book.rank_level + 1))
        else
            Text_hero_star_activation_no:setVisible(true)
            Text_hero_star_activation_no:setString(tipStringInfo_union_str[70])
        end
    else
        Button_hero_star_activation_back_0:setVisible(true)
        Button_hero_star_activation_back:setVisible(true)
    end
end

function WeaponBookAttributeUp:onWindowClose( )
    local root = self.roots[1]
    local action = self.actions[1]
    action:play("window_close", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_close_over" then
            state_machine.excute("weapon_book_attribute_up_window_close", 0, "")
        end
    end)
end

function WeaponBookAttributeUp:onInit( )
    local csbItem = csb.createNode(config_csb.weapon_book.weapon_book_attribute_up)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.weapon_book.weapon_book_attribute_up)
    table.insert(self.actions, action)
    action:play("window_open", false)
    csbItem:runAction(action)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_star_activation_close"), nil, 
    {
        terminal_name = "weapon_book_attribute_up_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --精炼
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hero_star_activation_back_0"), nil, 
    {
        terminal_name = "weapon_book_attribute_up_skill_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --一键精炼
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hero_star_activation_back"), nil, 
    {
        terminal_name = "weapon_book_attribute_up_fast_skill_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw()
end

function WeaponBookAttributeUp:init(params)
    self._weapon_book = params[1]
    self._index = params[2]
    self:onInit()
    return self
end

function WeaponBookAttributeUp:onExit()
    state_machine.remove("weapon_book_attribute_up_skill_up")
    state_machine.remove("weapon_book_attribute_up_fast_skill_up")
    state_machine.remove("weapon_book_attribute_up_update_draw")
    state_machine.remove("weapon_book_attribute_up_close")
end