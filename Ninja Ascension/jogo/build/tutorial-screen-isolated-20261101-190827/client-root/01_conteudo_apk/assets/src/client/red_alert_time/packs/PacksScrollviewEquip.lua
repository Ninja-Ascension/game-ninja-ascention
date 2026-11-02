-----------------------------
--包裹滚动层 -装备
-----------------------------
PacksScrollviewEquip = class("PacksScrollviewEquipClass", Window)

local packs_scrollview_equip_window_open_terminal = {
    _name = "packs_scrollview_equip_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("PacksScrollviewEquipClass")
        if nil == _Window then
            fwin:open(PacksScrollviewEquip:new():init(params))
        end  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(packs_scrollview_equip_window_open_terminal)
state_machine.init()

function PacksScrollviewEquip:ctor()
    self.super:ctor()
    self.roots = {}
    self.prop_numbers = 0
    self.all_props = {}
    self.scroll_view = nil
    self.scroll_view_poy = nil    
    -- Initialize packs_scrollview_equip state machine.
    local function init_packs_scrollview_equip_terminal()
	
		--显示界面
		local packs_scrollview_equip_window_show_terminal = {
            _name = "packs_scrollview_equip_window_show",
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
		local packs_scrollview_equip_window_hide_terminal = {
            _name = "packs_scrollview_equip_window_hide",
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
        --取消选中
        local packs_scrollview_equip_un_set_selected_terminal = {
            _name = "packs_scrollview_equip_un_set_selected",
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
        --刷新
        local packs_scrollview_equip_onupdate_all_equip_terminal = {
            _name = "packs_scrollview_equip_onupdate_all_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.all_props = instance:getAllData()
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

		state_machine.add(packs_scrollview_equip_window_show_terminal)	
		state_machine.add(packs_scrollview_equip_window_hide_terminal)
        state_machine.add(packs_scrollview_equip_un_set_selected_terminal)
        state_machine.add(packs_scrollview_equip_onupdate_all_equip_terminal)
        state_machine.init()
    end
    
    -- call func init packs_scrollview_all state machine.
    init_packs_scrollview_equip_terminal()
end

function PacksScrollviewEquip:setUnSelecet()
    local root = self.roots[1]
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    for i,v in pairs(ScrollView_packs:getChildren()) do
        if v.selected == true then
            v.selected = false
            v:setSelected()
            return
        end
    end
end

function PacksScrollviewEquip:onHide( ... )
    self:setVisible(false)
end

function PacksScrollviewEquip:onShow( ... )
    self:setVisible(true)
    local ScrollView_packs = ccui.Helper:seekWidgetByName(self.roots[1],"ScrollView_packs")
    for i,v in pairs(ScrollView_packs:getChildren()) do
        if v.selected == true then
            v.selected = false
            v:setSelected()
        end
        if i == 1 then
            if v.setSelected ~= nil then
                state_machine.excute("all_resource_set_selected",0,{_datas = {_cell = v }})
            else
                state_machine.excute("packs_prop_reset_ui", 0, nil)
            end
        end
    end
end

function PacksScrollviewEquip:onUpdateDraw()
    local root = self.roots[1]
    local ScrollView_packs = ccui.Helper:seekWidgetByName(root,"ScrollView_packs")
    ScrollView_packs:removeAllChildren(true)
    local width = ScrollView_packs:getContentSize().width
    local height = ScrollView_packs:getContentSize().height
    local scroll_height = 0
    local index = 0
    local cell_temp = state_machine.excute("packs_icon_bg_create_cell",0,"")
    local cell_height = cell_temp:getContentSize().height
    for i = 1,10000 do
        local v = self.all_props[i]
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
        local v = self.all_props[i]
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
            if tonumber(v.prop_data.prop_type) == 6 then
               cell = state_machine.excute("all_resource_create_cell",0,{3,v.prop_data,v.prop,2,height_n,true,true,1})
            elseif tonumber(v.prop_data.prop_type) == 7 then
               cell = state_machine.excute("all_resource_create_cell",0,{5,v.prop_data,v.prop,2,height_n})
            end
            if i == 1 then
                state_machine.excute("all_resource_set_selected",0,{_datas = {_cell = cell }})
            end
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


function PacksScrollviewEquip:onUpdate(dt) 
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

function PacksScrollviewEquip:getAllData( ... )
    local result = {}
    self.prop_numbers = 0
    --装备碎片
    local result_equip = {}
    for i,v in pairs(_ED.user_prop) do
        if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.user_prop_template), prop_mould.change_of_equipment)) > 0 then
            local data = 
            {
                prop_data = 
                {
                    item_value = v.prop_number,
                    prop_type = 6,
                    prop_item = v.user_prop_template,
                },
                prop = v ,
            }
            self.prop_numbers = self.prop_numbers + 1
            table.insert(result_equip, data)
        end
    end
    -- 排序
    local function sortEquipQuality( a, b )
        return tonumber(a.prop.quality) > tonumber(b.prop.quality)
    end
    table.sort(result_equip, sortEquipQuality)
    for k,v in pairs(result_equip) do
        table.insert(result, v)
    end
    --装备
    local result_equipment = {}
    for i,v in pairs(_ED.user_equiment) do
        if tonumber(v.ship_id) > 0 or tonumber(v.rela_state) > 0 then
        else
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
            self.prop_numbers = self.prop_numbers + 1
            table.insert(result_equipment, data)
        end
    end
    -- 排序
    local function sortEquipmentSuit( a, b )
        return tonumber(a.prop.suit_id) > tonumber(b.prop.suit_id)
    end
    table.sort(result_equipment, sortEquipmentSuit)
    for k,v in pairs(result_equipment) do
        table.insert(result, v)
    end
    return result 
end

function PacksScrollviewEquip:onEnterTransitionFinish()

end

function PacksScrollviewEquip:onInit( )
    local csbItem = csb.createNode(config_csb.packs.packs_scrollview)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdateDraw()	
end

function PacksScrollviewEquip:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.all_props = self:getAllData()
	self:onInit()
    return self
end

function PacksScrollviewEquip:onExit()
    state_machine.remove("packs_scrollview_equip_window_show")    
    state_machine.remove("packs_scrollview_equip_window_hide")
    state_machine.remove("packs_scrollview_equip_un_set_selected")
    state_machine.remove("packs_scrollview_equip_onupdate_all_equip")
end
