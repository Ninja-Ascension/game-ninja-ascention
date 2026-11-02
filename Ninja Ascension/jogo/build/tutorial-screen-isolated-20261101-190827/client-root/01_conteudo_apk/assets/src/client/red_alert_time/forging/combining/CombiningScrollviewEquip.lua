-----------------------------
--分解滚动层 -装备
-----------------------------
CombiningScrollviewEquip = class("CombiningScrollviewEquipClass", Window)

local combining_scrollview_equip_window_open_terminal = {
    _name = "combining_scrollview_equip_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("CombiningScrollviewEquipClass")
        if nil == _Window then
            fwin:open(CombiningScrollviewEquip:new():init(params))
        end  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(combining_scrollview_equip_window_open_terminal)
state_machine.init()

function CombiningScrollviewEquip:ctor()
    self.super:ctor()
    self.roots = {}
    self.prop_numbers = 0
    self.user_equip_ships = {}
    self.scroll_view = nil
    self.scroll_view_poy = nil

    self._cells = {}
    -- Initialize combining_scrollview_equip state machine.
    local function init_combining_scrollview_equip_terminal()
        --显示界面
        local combining_scrollview_equip_window_show_terminal = {
            _name = "combining_scrollview_equip_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --隐藏界面
        local combining_scrollview_equip_window_hide_terminal = {
            _name = "combining_scrollview_equip_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --取消所有选中
        local combining_scrollview_equip_un_set_selected_terminal = {
            _name = "combining_scrollview_equip_un_set_selected",
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

        -- 刷新所有 或者单个
        local combining_scrollview_equip_update_all_terminal = {
            _name = "combining_scrollview_equip_update_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateAll()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(combining_scrollview_equip_window_show_terminal)    
        state_machine.add(combining_scrollview_equip_window_hide_terminal)
        state_machine.add(combining_scrollview_equip_un_set_selected_terminal)
        state_machine.add(combining_scrollview_equip_update_all_terminal)
        state_machine.init()
    end
    
    -- call func init combining_scrollview_equip state machine.
    init_combining_scrollview_equip_terminal()
end

function CombiningScrollviewEquip:onHide( ... )
    self:setVisible(false)
end

function CombiningScrollviewEquip:onShow( ... )
    self:setVisible(true)
end

function CombiningScrollviewEquip:onUpdateAll( )
    local root = self.roots[1]
    self.user_equip_ships = self:getAllData()
    self:onUpdateDraw()
end

function CombiningScrollviewEquip:setUnSelecet()
    local root = self.roots[1]
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    for i,v in pairs(ScrollView_packs:getChildren()) do
        if v.selected == true then
            v.selected = false
            v:setSelected()
        end
    end
end

function CombiningScrollviewEquip:onUpdateDraw()
    local root = self.roots[1]
    local all_row = 0
    local all_col = 0
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    ScrollView_packs:removeAllChildren(true)
    self._cells = {}
    local width = ScrollView_packs:getContentSize().width
    local height = ScrollView_packs:getContentSize().height
    local scroll_height = 0
    local index = 0
    local cell_temp = state_machine.excute("packs_icon_bg_create_cell",0,"")
    local cell_height = cell_temp:getContentSize().height
    for i = 1,10000 do
        local v = self.user_equip_ships[i]
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
        local v = self.user_equip_ships[i]
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
            cell = state_machine.excute("all_resource_create_cell",0,{3,v.prop_data,v.prop,4,height_n,true,true,1})
        end
        cell:setAnchorPoint(cc.p(0,1))
        -- print("============",wight_n,height_n,(wight_n-1)*(width/4),height - (height_n-1)*92)
        cell:setPosition(cc.p((wight_n-1)*(width/4),height - (height_n-1)*cell_height))
        ScrollView_packs:addChild(cell)
        table.insert(self._cells,cell)
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end


    ScrollView_packs.getItems = function(scrollview)
        return self._cells
    end
    ScrollView_packs:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_packs:jumpToTop()  
    self.scroll_view = ScrollView_packs
    self.scroll_view_poy = ScrollView_packs:getInnerContainer():getPositionY()
end

function CombiningScrollviewEquip:onUpdate(dt) 
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

function CombiningScrollviewEquip:getAllData( ... )
    self.prop_numbers = 0
    local all_user_props = _ED.user_prop
    local all_prop_of_equip = {}
    local sort_result = {}

    for i,v in pairs(all_user_props) do
        local equip_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.user_prop_template), prop_mould.change_of_equipment))
        if equip_mould_id > 0 then
            local data = 
            {
                prop_data = 
                {
                    item_value = v.prop_number,
                    prop_type = 6,
                    prop_item = v.user_prop_template,
                },
                prop = v,
                quality = dms.int(dms["equipment_mould"],equip_mould_id,equipment_mould.grow_level),   
                equip_type = dms.int(dms["equipment_mould"],equip_mould_id,equipment_mould.equipment_type),
            }
            table.insert(all_prop_of_equip,data)
        end
    end

    local function sortEquipType( a, b ) -- 按装备位排序
        return tonumber(a.equip_type) < tonumber(b.equip_type)
    end
    table.sort(all_prop_of_equip, sortEquipType)

    local red_equip = {}
    local orange_equip = {}
    local purple_equip = {}
    local blue_equip = {}
    local green_equip = {}
    for i,v in pairs(all_prop_of_equip) do
        if v.quality == 1 then
            table.insert(green_equip,v)
        elseif v.quality == 2 then
            table.insert(blue_equip,v)
        elseif v.quality == 3 then
            table.insert(purple_equip,v)
        elseif v.quality == 4 then
            table.insert(orange_equip,v)
        elseif v.quality == 5 then
            table.insert(red_equip,v)
        end
    end

    for i,v in pairs(red_equip) do
        self.prop_numbers = self.prop_numbers + 1
        table.insert(sort_result,v)    
    end

    for i,v in pairs(orange_equip) do
        self.prop_numbers = self.prop_numbers + 1
        table.insert(sort_result,v)    
    end

    for i,v in pairs(purple_equip) do
        self.prop_numbers = self.prop_numbers + 1
        table.insert(sort_result,v)    
    end

    for i,v in pairs(blue_equip) do
        self.prop_numbers = self.prop_numbers + 1
        table.insert(sort_result,v)    
    end

    for i,v in pairs(green_equip) do
        self.prop_numbers = self.prop_numbers + 1 
        table.insert(sort_result,v)    
    end
    -- 可合成的排在前面
    local function sortEquipCombining( a, b )         
        if tonumber(a.prop.prop_number) >= tonumber(a.prop.coming_need_number) then
            a.can_compound = 1
        else
            a.can_compound = 0
        end
        if tonumber(b.prop.prop_number) >= tonumber(b.prop.coming_need_number) then
            b.can_compound = 1
        else
            b.can_compound = 0
        end
        return tonumber(a.can_compound) > tonumber(b.can_compound)
    end
    table.sort(sort_result, sortEquipCombining)
    
    return sort_result
end

function CombiningScrollviewEquip:onEnterTransitionFinish()

end

function CombiningScrollviewEquip:onInit( )
    local csbItem = csb.createNode(config_csb.packs.packs_scrollview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw() 
end

function CombiningScrollviewEquip:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.user_equip_ships = self:getAllData()
    self:onInit()
    return self
end

function CombiningScrollviewEquip:onExit()
    state_machine.remove("combining_scrollview_equip_window_show")    
    state_machine.remove("combining_scrollview_equip_window_hide")
    state_machine.remove("combining_scrollview_equip_un_set_selected")
    state_machine.remove("combining_scrollview_equip_update_all")
end
