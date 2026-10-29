-- ---------------------------
-- 装备回炉
-- ---------------------------
EquipmentClearRefining = class("EquipmentClearRefiningClass", Window)
--打开
local equipment_clear_refining_window_open_terminal = {
    _name = "equipment_clear_refining_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _EquipmentClearRefiningWindow = fwin:find("EquipmentClearRefiningClass")
        if nil == _EquipmentClearRefiningWindow then
            fwin:open(EquipmentClearRefining:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local equipment_clear_refining_window_close_terminal = {
    _name = "equipment_clear_refining_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentClearRefiningClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equipment_clear_refining_window_open_terminal)
state_machine.add(equipment_clear_refining_window_close_terminal)
state_machine.init()

function EquipmentClearRefining:ctor()
    self.super:ctor()
    self.roots = {}
	-- 列表容器
    self.scroll_view = nil
    -- 需要分解的装备
    self._refining_tables = {}

    local function init_equipment_clear_refining_terminal()
        -- 回炉
        local equipment_clear_refining_break_down_terminal = {
            _name = "equipment_clear_refining_break_down",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local reward_data = instance:getEquipRefinningReward()
                local function responseGetPreviewCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:showEquipRefinningReward(reward_data)
                            response.node._refining_tables = {}
                        end
                        state_machine.excute("equipment_clear_refining_on_update_all",0,"")
                        state_machine.excute("equipment_clear_refining_update_draw_left",0,"")
                    end
                end
                local str = ""
                for i, v in pairs(instance._refining_tables) do
                    if v ~= nil then
                        str = str .. v .. ","
                    end 
                end
                if str == nil or str == "" then 
                    TipDlg.drawTextDailog(red_alert_all_str[187]..refining_batch[2])
                    instance:unLockAll()
                    return
                end                     
                protocol_command.equipment_return.param_list = str
                NetworkManager:register(protocol_command.equipment_return.code, nil, nil, nil, instance, responseGetPreviewCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 取消选中
        local equipment_clear_refining_un_set_selected_terminal = {
            _name = "equipment_clear_refining_un_set_selected",
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

        -- 添加分解项
        local equipment_clear_refining_add_item_terminal = {
            _name = "equipment_clear_refining_add_item",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i,v in pairs(params) do
                    table.insert(instance._refining_tables,v)
                end
                state_machine.excute("equipment_clear_refining_update_draw_left",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 移除分解项
        local equipment_clear_refining_remove_item_terminal = {
            _name = "equipment_clear_refining_remove_item",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                for i,v in pairs(params) do
                    for j,k in pairs(instance._refining_tables) do
                        if params[i] == k then
                            table.remove(instance._refining_tables,j)
                        end
                    end
                end
                state_machine.excute("equipment_clear_refining_update_draw_left",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 更新左侧
        local equipment_clear_refining_update_draw_left_terminal = {
            _name = "equipment_clear_refining_update_draw_left",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawLeftProp()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 刷新列表
        local equipment_clear_refining_on_update_all_terminal = {
            _name = "equipment_clear_refining_on_update_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.user_equips = instance:getAllData()
                instance:onUpdateProp()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equipment_clear_refining_break_down_terminal)
        state_machine.add(equipment_clear_refining_un_set_selected_terminal)
        state_machine.add(equipment_clear_refining_add_item_terminal)
        state_machine.add(equipment_clear_refining_remove_item_terminal)
        state_machine.add(equipment_clear_refining_update_draw_left_terminal)
        state_machine.add(equipment_clear_refining_on_update_all_terminal)
        state_machine.init()
    end
    init_equipment_clear_refining_terminal()
end

function EquipmentClearRefining:onUpdateDrawLeftProp()
    local root = self.roots[1]
    -- 装备icon
    local Panel_hero_header = ccui.Helper:seekWidgetByName(root,"Panel_hero_header")
    Panel_hero_header:removeAllChildren(true)
    -- 装备名称
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    local table_len = #self._refining_tables
    -- 回炉数量
    local Image_refining_icon_number = ccui.Helper:seekWidgetByName(root,"Image_refining_icon_number")
    local Text_refining_icon_number = ccui.Helper:seekWidgetByName(root,"Text_refining_icon_number")
    if table_len == 0 then
        Image_refining_icon_number:setVisible(false)
        Text_refining_icon_number:setString("")
        Text_name:setString("")
        return
    end
    Image_refining_icon_number:setVisible(true)
    Text_refining_icon_number:setString(table_len) 
    -- 装备信息
    local equip_id = ""..self._refining_tables[table_len]
    local equip = _ED.user_equiment[equip_id]
    local data = 
    {
        prop_data = {
            item_value = 1,
            prop_type = 7,
            prop_item = equip.user_equiment_template,
        },
        prop = equip,
    }
    local name = equip.user_equiment_name
    local quality = equip.quality
    local cell = state_machine.excute("all_resource_create_cell",0,{7,data.prop_data,data.prop,8,0})
    Panel_hero_header:addChild(cell)
    Text_name:setString(name)
    Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
end

-- 装备回炉信息描述
function EquipmentClearRefining:onUpdateDraw()
    local root = self.roots[1]
    local Text_title = ccui.Helper:seekWidgetByName(root,"Text_title")
    Text_title:setString(tipStringInfo_equipment_clear[1])
    local Text_rebirth_9 = ccui.Helper:seekWidgetByName(root,"Text_rebirth_9")
    Text_rebirth_9:setString(tipStringInfo_equipment_clear[2])
    local Text_chongsheng = ccui.Helper:seekWidgetByName(root,"Text_chongsheng")
    Text_chongsheng:setString(tipStringInfo_equipment_clear[3])
    self:onUpdateProp()
end

--显示装备回炉奖励
function EquipmentClearRefining:showEquipRefinningReward(reward_data)
    state_machine.excute("reward_obtain_window_open",0,{nil,reward_data})
end

--获得装备回炉奖励
function EquipmentClearRefining:getEquipRefinningReward()
    local all_reward_datas = {}
    all_reward_datas.show_reward_list = {}
    local back_silvers = 0
    for j,equip_id in pairs(self._refining_tables) do
        local equip = _ED.user_equiment[""..equip_id]
        local equip_mould_id = equip.user_equiment_template
        for i = 1 , (tonumber(equip.user_equiment_grade) - 1) do 
            local lostSilver = self:getNeedSilver(equip,i)
            back_silvers = back_silvers + lostSilver
        end     
        if back_silvers ~= 0 then
            local data = 
            {
                item_value = back_silvers,
                prop_type = 1,
                prop_item = -1,
            }
            table.insert(all_reward_datas.show_reward_list,data)
        end 
        local refining_get_of_stone = dms.string(dms["equipment_mould"],equip_mould_id,equipment_mould.refining_get_of_stone)     --分解获得物品和数量 
        if refining_get_of_stone ~= "-1" then
            local data = 
            {
                item_value = refining_get_of_stone,
                prop_type = 33,
                prop_item = -1,
            }
            table.insert(all_reward_datas.show_reward_list,data)
        end
    end
    for j,equip_id in pairs(self._refining_tables) do
        local equip = _ED.user_equiment[""..equip_id]
        for i,v in pairs(equip.jewelrys) do
            if tonumber(v) > 0 then
                if _ED.user_gems[""..v] ~= nil then
                    local data = 
                    {
                        item_value = 1,
                        prop_type = 34,
                        prop_item = _ED.user_gems[""..v].mould_id,
                    }
                    table.insert(all_reward_datas.show_reward_list,data)
                end
            end
        end
    end
    return all_reward_datas
end

--得到装备升级需要的金币数量
function EquipmentClearRefining:getNeedSilver(equip,level)
    local suit_id = dms.int(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.suit_id)                --装备ID
    local need_silver = dms.int(dms["equipment_level_requirement"], level, equipment_level_requirement.silver_amount)   --银币数量
    if need_silver == nil then
        return 0 
    end
    --不同装备套装对应强化系数（套装ID,计算参数|...）
    -- 不同装备部位对应强化系数（装备部位,计算参数|...)
    local equip_suit_id_table = dms.string(dms["equipment_config"],1,equipment_config.param)
    equip_suit_id_table = zstring.split(equip_suit_id_table,"|")
    local equip_type_table = dms.string(dms["equipment_config"],2,equipment_config.param)
    equip_type_table = zstring.split(equip_type_table,"|")
    for i,v in pairs(equip_suit_id_table) do
        local temp_data = zstring.split(v,",")
        local suit_id_temp = tonumber(temp_data[1])
        if suit_id == suit_id_temp then
            local tempx = tonumber(temp_data[2]) -- 计算系数1 
            need_silver = need_silver *tempx
        end
    end
    for i,v in pairs(equip_type_table) do
        local temp_data = zstring.split(v,",")
        local equip_type = tonumber(temp_data[1])
        if tonumber(equip.equipment_type) == equip_type then
            local tempx = tonumber(temp_data[2]) -- 计算系数2
            need_silver = need_silver *tempx
        end
    end
    return need_silver
end

-- 设置选中
function EquipmentClearRefining:setUnSelecet()
    local root = self.roots[1]
    local ScrollView_rebirth = ccui.Helper:seekWidgetByName(root,"ScrollView_rebirth")
    for i,v in pairs(ScrollView_rebirth:getChildren()) do
        if v.selected == true and v.setSelected then
            v.selected = false
            v:setSelected()
        end
    end
end
-- 获得装备信息
function EquipmentClearRefining:getAllData()
    local result = {}
    self.prop_numbers = 0
    for i,equip in pairs(_ED.user_equiment) do
        if zstring.tonumber(equip.ship_id) > 0 or zstring.tonumber(equip.rela_state) > 0 then
        elseif dms.string(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.refining_get_of_stone) == "-1" then
        else
            local data = 
            {
                prop_data = {
                    item_value = 1,
                    prop_type = 7,
                    prop_item = equip.user_equiment_template,
                },
                prop = equip,
            }
            self.prop_numbers = self.prop_numbers + 1
            table.insert(result,data)
        end
    end
    return result
end

-- 右侧列表信息
function EquipmentClearRefining:onUpdateProp()
    local root = self.roots[1]
    -- 排序
    local function sortEquipmentSuit( a, b )
        return tonumber(a.prop.suit_id) > tonumber(b.prop.suit_id)
    end
    table.sort(self.user_equips, sortEquipmentSuit)
    local all_row = 0
    local all_col = 0
    local ScrollView_rebirth = ccui.Helper:seekWidgetByName(root, "ScrollView_rebirth")
    ScrollView_rebirth:removeAllChildren(true)
    local cell_temp = state_machine.excute("packs_icon_bg_create_cell",0,"")
    local cell_height = cell_temp:getContentSize().height
    local width = ScrollView_rebirth:getContentSize().width
    local height = ScrollView_rebirth:getContentSize().height
    local scroll_height = 0
    local index = 0
    for i = 1,10000 do
        local v = self.user_equips[i]
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

    if scroll_height*cell_height > height then
        height = scroll_height*cell_height
    end

    for i = 1,10000 do
        local v = self.user_equips[i]
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
            cell = state_machine.excute("all_resource_create_cell",0,{7,v.prop_data,v.prop,18,height_n})
        end
        cell:setAnchorPoint(cc.p(0,1))
        cell:setPosition(cc.p((wight_n-1)*(width/4),height - (height_n-1)*cell_height))
        ScrollView_rebirth:addChild(cell)
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end
    ScrollView_rebirth:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_rebirth:jumpToTop()  
    self.scroll_view = ScrollView_rebirth
    self.scroll_view_poy = ScrollView_rebirth:getInnerContainer():getPositionY()       
end

function EquipmentClearRefining:onUpdate(dt) 
    if self.scroll_view ~= nil then
        local size = self.scroll_view:getContentSize()
        local posY = self.scroll_view:getInnerContainer():getPositionY()
        if self.scroll_view_poy == posY then
            return
        end
        self.scroll_view_poy = posY
        local items = self.scroll_view:getChildren()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function EquipmentClearRefining:onInit( )
    local csbItem = csb.createNode(config_csb.weapon_book.weapon_book_rebirth)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rebirth_close"), nil, 
    {
        terminal_name = "equipment_clear_refining_window_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 2)

    -- 回炉
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rebirth"), nil, 
    {
        terminal_name = "equipment_clear_refining_break_down",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self:onUpdateDraw()
end

function EquipmentClearRefining:init()
    self.user_equips = self:getAllData()
    self:onInit()
    return self
end

function EquipmentClearRefining:onExit()
    state_machine.remove("equipment_clear_refining_break_down")
    state_machine.remove("equipment_clear_refining_un_set_selected")
    state_machine.remove("equipment_clear_refining_add_item")
    state_machine.remove("equipment_clear_refining_remove_item")
    state_machine.remove("equipment_clear_refining_update_draw_left")
    state_machine.remove("equipment_clear_refining_on_update_all")
end