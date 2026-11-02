-----------------------------
--分解滚动层 -装备
-----------------------------
RefiningScrollviewEquip = class("RefiningScrollviewEquipClass", Window)

local refining_scrollview_equip_window_open_terminal = {
    _name = "refining_scrollview_equip_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("RefiningScrollviewEquipClass")
        if nil == _Window then
            fwin:open(RefiningScrollviewEquip:new():init(params))
        end  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(refining_scrollview_equip_window_open_terminal)
state_machine.init()

function RefiningScrollviewEquip:ctor()
    self.super:ctor()
    self.roots = {}
    self.prop_numbers = 0
    self.user_equips = {}
    self.scroll_view = nil
    self.scroll_view_poy = nil
    -- Initialize refining_scrollview_equip state machine.
    local function init_refining_scrollview_equip_terminal()
        --显示界面
        local refining_scrollview_equip_window_show_terminal = {
            _name = "refining_scrollview_equip_window_show",
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
        local refining_scrollview_equip_window_hide_terminal = {
            _name = "refining_scrollview_equip_window_hide",
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
        local refining_scrollview_equip_un_set_selected_terminal = {
            _name = "refining_scrollview_equip_un_set_selected",
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
        -- 批量添加
        local refining_scrollview_equip_add_batch_terminal = {
            _name = "refining_scrollview_equip_add_batch",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("refining_scrollview_equip_un_set_selected",0,"")
                instance:addBatch(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local refining_scrollview_equip_update_all_terminal = {
            _name = "refining_scrollview_equip_update_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                
                instance.user_equips = instance:getAllData() 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(refining_scrollview_equip_window_show_terminal)    
        state_machine.add(refining_scrollview_equip_window_hide_terminal)
        state_machine.add(refining_scrollview_equip_un_set_selected_terminal)
        state_machine.add(refining_scrollview_equip_add_batch_terminal)
        state_machine.add(refining_scrollview_equip_update_all_terminal)
        state_machine.init()
    end
    
    -- call func init refining_scrollview_equip state machine.
    init_refining_scrollview_equip_terminal()
end

function RefiningScrollviewEquip:onHide( ... )
    self:setVisible(false)
end

function RefiningScrollviewEquip:onShow( ... )
    self:setVisible(true)
end

function RefiningScrollviewEquip:addBatch(select_index_table)
    local select_table = {}
    for i,equip in pairs(self.user_equips) do 
        local equip_grow_up = dms.int(dms["equipment_mould"],equip.prop.user_equiment_template,equipment_mould.grow_level)
        for j,k in pairs(select_index_table) do
            if equip_grow_up == k then
                table.insert(select_table,equip.prop.user_equiment_id)
            end
        end
    end
    self:setAllSelecet(select_table)
    state_machine.excute("refining_add_batch_item",0,select_table)
end

function RefiningScrollviewEquip:setAllSelecet(select_table)
    local root = self.roots[1]
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    for i,v in pairs(ScrollView_packs:getChildren()) do
        for j,k in pairs(select_table) do
            if v.prop ~= nil then
                if tonumber(v.prop.user_equiment_id) == tonumber(k) then
                    v.selected = true
                    v:setSelected()
                end
            end
        end
    end
end

function RefiningScrollviewEquip:setUnSelecet()
    local root = self.roots[1]
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    for i,v in pairs(ScrollView_packs:getChildren()) do
        if v.selected == true and v.setSelected then
            v.selected = false
            v:setSelected()
        end
    end
end

function RefiningScrollviewEquip:onUpdate(dt) 
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

function RefiningScrollviewEquip:onUpdateDraw()
    local root = self.roots[1]
    -- 排序
    local function sortEquipmentSuit( a, b )
        return tonumber(a.prop.suit_id) > tonumber(b.prop.suit_id)
    end
    table.sort(self.user_equips, sortEquipmentSuit)
    local all_row = 0
    local all_col = 0
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    ScrollView_packs:removeAllChildren(true)
    local width = ScrollView_packs:getContentSize().width
    local height = ScrollView_packs:getContentSize().height
    local scroll_height = 0
    local index = 0
    local cell_temp = state_machine.excute("packs_icon_bg_create_cell",0,"")
    local cell_height = cell_temp:getContentSize().height
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
            cell = state_machine.excute("all_resource_create_cell",0,{7,v.prop_data,v.prop,3,height_n})
        end
        cell:setAnchorPoint(cc.p(0,1))
        -- print("============",wight_n,height_n,(wight_n-1)*(width/4),height - (height_n-1)*92)
        cell:setPosition(cc.p((wight_n-1)*(width/4),height - (height_n-1)*cell_height))
        ScrollView_packs:addChild(cell)
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end

    ScrollView_packs:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_packs:jumpToTop()  

    self.scroll_view = ScrollView_packs
    self.scroll_view_poy = ScrollView_packs:getInnerContainer():getPositionY()      
end

function RefiningScrollviewEquip:getAllData( ... )
    local result = {}
    self.prop_numbers = 0
    for i,equip in pairs(_ED.user_equiment) do
        if zstring.tonumber(equip.ship_id) > 0 or zstring.tonumber(equip.rela_state) > 0 then
        elseif dms.string(dms["equipment_mould"],equip.user_equiment_template,equipment_mould.refining_items) == "-1" then
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

function RefiningScrollviewEquip:onEnterTransitionFinish()

end

function RefiningScrollviewEquip:onInit( )
    local csbItem = csb.createNode(config_csb.forging.forging_scrollview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw() 
end

function RefiningScrollviewEquip:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.user_equips = self:getAllData()
    self:onInit()
    return self
end

function RefiningScrollviewEquip:onExit()
    state_machine.remove("refining_scrollview_equip_window_show")    
    state_machine.remove("refining_scrollview_equip_window_hide")
    state_machine.remove("refining_scrollview_equip_un_set_selected")
    state_machine.remove("refining_scrollview_equip_add_batch")
    state_machine.remove("refining_scrollview_equip_update_all")
end
