-----------------------------
--包裹滚动层 -全部
-----------------------------
PacksScrollviewAll = class("PacksScrollviewAllClass", Window)

local packs_scrollview_all_window_open_terminal = {
    _name = "packs_scrollview_all_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("PacksScrollviewAllClass")
        if nil == _Window then
            fwin:open(PacksScrollviewAll:new():init(params))
        end  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(packs_scrollview_all_window_open_terminal)
state_machine.init()

function PacksScrollviewAll:ctor()
    self.super:ctor()
    self.roots = {}
    self.prop_numbers = 0
    self.prop = nil
    self.all_props = {}
    self.scroll_view = nil
    self.scroll_view_poy = nil
    -- Initialize packs_scrollview_all state machine.
    local function init_packs_scrollview_all_terminal()
	
		--显示界面
		local packs_scrollview_all_window_show_terminal = {
            _name = "packs_scrollview_all_window_show",
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
		local packs_scrollview_all_window_hide_terminal = {
            _name = "packs_scrollview_all_window_hide",
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
        local packs_scrollview_all_un_set_selected_terminal = {
            _name = "packs_scrollview_all_un_set_selected",
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
        local packs_scrollview_all_update_draw_terminal = {
            _name = "packs_scrollview_all_update_draw",
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
		state_machine.add(packs_scrollview_all_window_show_terminal)	
		state_machine.add(packs_scrollview_all_window_hide_terminal)
        state_machine.add(packs_scrollview_all_un_set_selected_terminal)
        state_machine.add(packs_scrollview_all_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init packs_scrollview_all state machine.
    init_packs_scrollview_all_terminal()
end

function PacksScrollviewAll:setUnSelecet()
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

function PacksScrollviewAll:onHide( ... )
    self:setVisible(false)
end

function PacksScrollviewAll:onShow( ... )
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

function PacksScrollviewAll:onUpdateDraw()
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
		local function showCell()
			local cell = nil
			if v == nil then
				cell = state_machine.excute("packs_icon_bg_create_cell",0,"")
			else
				if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop.user_prop_template), prop_mould.change_of_equipment))> 0 
					or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop.user_prop_template), prop_mould.use_of_ship)) > 0  then
					cell = state_machine.excute("all_resource_create_cell",0,{3,v.prop_data,v.prop,2,height_n,true,true,1})
				elseif zstring.tonumber(v.prop_data.prop_type) == 7 then
					cell = state_machine.excute("all_resource_create_cell",0,{5,v.prop_data,v.prop,2,height_n})
				elseif zstring.tonumber(v.prop_data.prop_type) == 34 then
					cell = state_machine.excute("all_resource_create_cell",0,{5,v.prop_data,v.prop,2,height_n})
				else
					cell = state_machine.excute("all_resource_create_cell",0,{4,v.prop_data,v.prop,2,height_n,true,true,5})
				end  
				if i == 1 then
					state_machine.excute("all_resource_set_selected",0,{_datas = {_cell = cell }})
				end
			end
			cell:setAnchorPoint(cc.p(0,1))
			cell:setPosition(cc.p((wight_n-1)*(width/4),height - (height_n-1)*cell_height))
			ScrollView_packs:addChild(cell)
		end
		if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
			local run_action1  = cc.Sequence:create(cc.DelayTime:create(0.01*i),cc.CallFunc:create(showCell))
			self:runAction(run_action1)
		else
			showCell()
		end
        if wight_n == 4 and v == nil and i >= 5*4 then
            break
        end
    end

    ScrollView_packs:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_packs:jumpToTop()

    self.scroll_view = ScrollView_packs
    self.scroll_view_poy = ScrollView_packs:getInnerContainer():getPositionY()      
end


function PacksScrollviewAll:onUpdate(dt) 
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

function PacksScrollviewAll:getAllData()
    local result = {}
    self.prop_numbers = 0
    --消耗品(宝箱)
    local result_prop = {}
    --消耗品(非宝箱，非碎片)
    local result_prop_two = {}
    --消耗品(英雄碎片)
    local result_ship = {}
    --消耗品(装备碎片)
    local result_equip = {}
    for i,v in pairs(_ED.user_prop) do
        local change_of_equipment = zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.user_prop_template), prop_mould.change_of_equipment))
        local use_of_ship = zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.user_prop_template), prop_mould.use_of_ship))
        local use_of_prop_type = zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.user_prop_template), prop_mould.prop_type))
        if change_of_equipment <= 0 and use_of_ship <= 0 and use_of_prop_type == 0 then
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
            table.insert(result_prop, data)
        elseif change_of_equipment <= 0 and use_of_ship <= 0 and use_of_prop_type ~= 0 then
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
            table.insert(result_prop_two, data)
        elseif use_of_ship > 0 then 
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
            table.insert(result_ship, data)
        elseif change_of_equipment > 0 then 
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
     -- 消耗品(宝箱,非碎片)排序,添加到result
    local function sortUseQuality( a, b )
        return tonumber(a.prop.quality) > tonumber(b.prop.quality)
    end
    table.sort(result_prop, sortUseQuality)
    for k,v in pairs(result_prop) do
        table.insert(result, v)
    end
     -- 消耗品(非碎片)排序,添加到result
    local function sortUseQuality( a, b )
        return tonumber(a.prop.quality) > tonumber(b.prop.quality)
    end
    table.sort(result_prop_two, sortUseQuality)
    for k,v in pairs(result_prop_two) do
        table.insert(result, v)
    end
    -- 消耗品(英雄碎片)排序,添加到result
    local function sortShipQuality( a, b )
        return tonumber(a.prop.quality) > tonumber(b.prop.quality)
    end
    table.sort(result_ship, sortShipQuality)
    for k,v in pairs(result_ship) do
        table.insert(result, v)
    end
    -- 消耗品(装备碎片)排序,添加到result
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
    -- 排序后添加
    for k,v in pairs(result_equipment) do
        table.insert(result, v)
    end

    --宝石
    local result_gems = {}
    for i,v in pairs(_ED.user_gems) do
        if tonumber(v.equip_id) > 0 then
        else
            local data = 
            {
                prop_data = 
                {
                    item_value = 1,
                    prop_type = 34,
                    prop_item = v.mould_id,
                },
                prop = v ,
            }
            self.prop_numbers = self.prop_numbers + 1
            table.insert(result_gems, data)
        end
    end
    -- 排序
    local function sortGemsLevel( a, b )
        return tonumber(a.prop.level) > tonumber(b.prop.level)
    end
    table.sort(result_gems, sortGemsLevel)
    -- 排序后添加
    for k,v in pairs(result_gems) do
        table.insert(result, v)
    end
    return result  
end

function PacksScrollviewAll:onEnterTransitionFinish()

end

function PacksScrollviewAll:onInit( )
    local csbItem = csb.createNode(config_csb.packs.packs_scrollview)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdateDraw()	
end

function PacksScrollviewAll:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.all_props = self:getAllData()
	self:onInit()
    return self
end

function PacksScrollviewAll:onExit()
    state_machine.remove("packs_scrollview_all_window_show")    
    state_machine.remove("packs_scrollview_all_window_hide")
    state_machine.remove("packs_scrollview_all_un_set_selected")
    state_machine.remove("packs_scrollview_all_update_draw")
end
