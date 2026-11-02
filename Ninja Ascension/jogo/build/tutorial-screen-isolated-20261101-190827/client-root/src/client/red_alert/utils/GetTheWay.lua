-----------------------------
--获取跳转
-----------------------------
GetTheWay = class("GetTheWayClass", Window)

local get_the_way_window_open_terminal = {
    _name = "get_the_way_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(100) == true then
            return
        end 
        state_machine.excute("get_the_way_window_close",0,"")
        local prop_type = nil 
        local prop_item = nil
        local prop_number = nil
        local prop = nil
        if params[1] ~= nil then
            prop_type = params[1]
            prop_item = params[2]
            prop_number = params[3]
            prop = params[4]
        else
            prop_type = params._datas.prop_type
            prop_item = params._datas.prop_item
            prop_number = params._datas.prop_number
            prop = params._datas.prop
        end
        
        if nil == fwin:find("GetTheWayClass") then
            fwin:open(GetTheWay:new():init(prop_type,prop_item,prop_number,prop), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local get_the_way_window_close_terminal = {
    _name = "get_the_way_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GetTheWayClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(get_the_way_window_open_terminal)
state_machine.add(get_the_way_window_close_terminal)
state_machine.init()

function GetTheWay:ctor()
    self.super:ctor()
    self.roots = {}
    self.prop_type = nil
    self.prop_item = nil
    self.prop_number = nil
    self.prop = nil
    app.load("client.red_alert.cells.utils.get_the_way_cell")
    
end

function GetTheWay:onEnterTransitionFinish()

end

function GetTheWay:onUpdateDraw()
    local root = self.roots[1]
    local Text_get_the_way_number = ccui.Helper:seekWidgetByName(root,"Text_get_the_way_number")
    local ListView_get = ccui.Helper:seekWidgetByName(root,"ListView_get")
    ListView_get:removeAllItems()
    local Panel_get_the_way_icon_1 = ccui.Helper:seekWidgetByName(root,"Panel_get_the_way_icon_1")
    Panel_get_the_way_icon_1:removeAllChildren(true)
    local Text_get_the_way_name = ccui.Helper:seekWidgetByName(root,"Text_get_the_way_name")
    if self.prop_type == 5 then
        Text_get_the_way_number:setString(_ED.user_info.jade)
        Text_get_the_way_name:setString(reward_prop_list[self.prop_type])
        Text_get_the_way_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[5][1],tipStringInfo_quality_color_Type[5][2],tipStringInfo_quality_color_Type[5][3]))
        local data = {
            prop_type = 5,
            prop_item = -1,
            item_value = _ED.user_info.jade
        }

        local icon_cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
        Panel_get_the_way_icon_1:addChild(icon_cell)
        local get_ways = ""
        for i=1,dms.count(dms["resource_short_cut"]) do
            local prop_type = dms.int(dms["resource_short_cut"],i,resource_short_cut.prop_type)
            if prop_type == 5 then
                get_ways = dms.string(dms["resource_short_cut"],i,resource_short_cut.get_ways)
            end
        end

        get_ways = zstring.split(get_ways,",")
        -- debug.print_r(get_ways)
        for i,v in pairs(get_ways) do
            local cell = state_machine.excute("get_the_way_cell_create_cell",0,{v})
            ListView_get:addChild(cell)
        end

        ListView_get:requestRefreshView()
    elseif self.prop_type == 6 then
        local name = dms.string(dms["prop_mould"],self.prop_item,prop_mould.prop_name)
        local prop_quality = dms.int(dms["prop_mould"],self.prop_item,prop_mould.prop_quality)       --品质
        Text_get_the_way_number:setString(self.prop_number)
        Text_get_the_way_name:setString(name)
        Text_get_the_way_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[prop_quality+1][1],tipStringInfo_quality_color_Type[prop_quality+1][2],tipStringInfo_quality_color_Type[prop_quality+1][3]))
        local data = {
            prop_type = 6,
            prop_item = self.prop_item,
            item_value = self.prop_number
        }

        if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(self.prop_item), prop_mould.change_of_equipment))> 0 
            or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(self.prop_item), prop_mould.use_of_ship)) > 0  then
            cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,1,0,false,true})
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,1,0,false,true})
        end 
        Panel_get_the_way_icon_1:addChild(cell)


        local get_ways = ""
        local trace_address_str = dms.string(dms["prop_mould"],self.prop_item,prop_mould.trace_address)
        if trace_address_str ~= "-1" then
            trace_address_str = zstring.split(trace_address_str,"|")
            get_ways = zstring.split(trace_address_str[2],",")
        end

        -- debug.print_r(get_ways)
        for i,v in pairs(get_ways) do
            local cell = state_machine.excute("get_the_way_cell_create_cell",0,{v})
            ListView_get:addChild(cell)
        end

        ListView_get:requestRefreshView()
    elseif self.prop_type == 13 then
        local name = dms.string(dms["ship_mould"],self.prop_item,ship_mould.captain_name)
        local ship_type = dms.int(dms["ship_mould"],self.prop_item,ship_mould.ship_type)       --品质
        local base_mould_id = dms.int(dms["ship_mould"],self.prop_item,ship_mould.base_mould)
        local have_number = 0 
        if self.prop ~= nil then
            have_number = findTheSameBaseShipMouldBy(self.prop)
        else
            have_number = findTheSameBaseShipMouldByBaseMould(base_mould_id)
        end
        Text_get_the_way_number:setString(have_number)
        Text_get_the_way_name:setString(name)
        Text_get_the_way_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type+1][1],tipStringInfo_quality_color_Type[ship_type+1][2],tipStringInfo_quality_color_Type[ship_type+1][3]))
        local data = {
            prop_type = 13,
            prop_item = self.prop_item,
            item_value = have_number
        }

        local cell = state_machine.excute("all_resource_create_cell",0,{7,data,self.prop,3,0,false,true})
        Panel_get_the_way_icon_1:addChild(cell)

        local get_ways = {}
        local trace_address_str = dms.string(dms["ship_mould"],self.prop_item,ship_mould.trace_address)
    
        if trace_address_str ~= "-1" then
            trace_address_str = zstring.split(trace_address_str,",")
            get_ways = trace_address_str
        end

        -- debug.print_r(get_ways)
        for i,v in pairs(get_ways) do
            local cell = state_machine.excute("get_the_way_cell_create_cell",0,{v})
            ListView_get:addChild(cell)
        end

        ListView_get:requestRefreshView()
    end

end

function GetTheWay:init(prop_type,prop_item,prop_number,prop)
    self.prop_type = tonumber(prop_type)
    self.prop_item = prop_item
    self.prop_number = prop_number
    self.prop = prop
	self:onInit()
    return self
end

function GetTheWay:onInit()
    local csbItem = csb.createNode(config_csb.utils.get_the_way)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_get_the_way_back") , nil, 
    {
        terminal_name = "get_the_way_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)    

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_get_the_way_1") , nil, 
    {
        terminal_name = "get_the_way_window_close", 
        terminal_state = 0, 
    }, nil, 0)    
    
    self:onUpdateDraw() 
end

function GetTheWay:onExit()

end
