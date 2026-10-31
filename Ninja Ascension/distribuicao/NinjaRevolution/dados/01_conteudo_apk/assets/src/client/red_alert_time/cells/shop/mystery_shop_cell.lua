--------------------------------------------------------------------------------------------------------------
--  说明：神秘商店控件
--------------------------------------------------------------------------------------------------------------
MysteryShopCell = class("MysteryShopCellClass", Window)
MysteryShopCell.__size = nil
--创建cell
local mystery_shop_create_cell_terminal = {
    _name = "mystery_shop_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local data = params[1]
        local id = params[2]
        local shop_type = params[3]
        local cell = MysteryShopCell:new()
        cell:init(data, id, shop_type)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(mystery_shop_create_cell_terminal)
state_machine.init()

function MysteryShopCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.enum_shop_type = {
        mystery_shop_type = 1,
        tourney_shop_type = 2,
        union_shop_type = 3,
        union_shop_exploit_type = 4,
    }
    self.shop_type = 1
    self.data = nil
	self.id = nil
	 -- Initialize mystery_shop_cell state machine.
    local function init_mystery_shop_cell_terminal()
		local mystery_shop_cell_to_buy_window_terminal = {
            _name = "mystery_shop_cell_to_buy_window",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if tonumber(cell.data.remain_times) == 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[25])
                    return
                end
                state_machine.excute("mystery_shop_buy_window_open",0,{cell.id,cell.data,cell})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新
        local mystery_shop_cell_onupdate_draw_terminal = {
            _name = "mystery_shop_cell_onupdate_draw",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                local data = params[2]
                cell.data = data
                if cell.roots ~= nil and cell.roots[1] ~= nil then
                    cell:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(mystery_shop_cell_to_buy_window_terminal)
        state_machine.add(mystery_shop_cell_onupdate_draw_terminal)
        state_machine.init()
    end
    
    init_mystery_shop_cell_terminal()
end

function MysteryShopCell:updateDraw()
    local root = self.roots[1]
    local Panel_mystery_shop_celll_icon = ccui.Helper:seekWidgetByName(root,"Panel_mystery_shop_celll_icon")
    local Text_mystery_shop_celll_name = ccui.Helper:seekWidgetByName(root,"Text_mystery_shop_celll_name")
    local Image_mystery_shop_soul = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_soul")
    local Image_mystery_shop_gem = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_gem")
    local Text_mystery_shop_soul_number = ccui.Helper:seekWidgetByName(root,"Text_mystery_shop_soul_number")
    local Image_mystery_shop_celll_over = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_celll_over")
    local Image_mystery_shop_celll_9 = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_celll_9")
    
    local Image_mystery_shop_honor = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_honor")
    local Image_mystery_shop_gem_prestige_1 = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_gem_prestige_1")
    local Image_mystery_shop_gem_prestige_2 = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_gem_prestige_2")
    local Image_mystery_shop_gem_competitive = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_gem_competitive")
    local Image_mystery_shop_legion = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_legion")
    local Image_mystery_shop_legion_pk = ccui.Helper:seekWidgetByName(root,"Image_mystery_shop_legion_pk")
    local Panel_hg_refresh = ccui.Helper:seekWidgetByName(root,"Panel_hg_refresh")

    local remain_times = tonumber(self.data.remain_times)
    if remain_times == 0 then
        Image_mystery_shop_celll_over:setVisible(true)
    end

    Image_mystery_shop_soul:setVisible(false)
    Image_mystery_shop_gem:setVisible(false)
    Image_mystery_shop_honor:setVisible(false)
    Image_mystery_shop_gem_prestige_1:setVisible(false)
    Image_mystery_shop_gem_prestige_2:setVisible(false)
    Image_mystery_shop_gem_competitive:setVisible(false)
    Image_mystery_shop_legion:setVisible(false)
    Image_mystery_shop_legion_pk:setVisible(false)
    Image_mystery_shop_celll_9:setVisible(false)
    Panel_hg_refresh:setVisible(false)
    -- 九折标签
    if tonumber(self.data.recommend) == 1 then
        Image_mystery_shop_celll_9:setVisible(true)
    end
    -- 高级商品
    if tonumber(self.data.refresh_type) == 1 then
        Panel_hg_refresh:setVisible(true)
    end
    if tonumber(self.data.sell_type) == 0 then
        Image_mystery_shop_soul:setVisible(true)
    elseif tonumber(self.data.sell_type) == 1 then  -- 元宝购买
        Image_mystery_shop_gem:setVisible(true)
    elseif tonumber(self.data.sell_type) == 3 then
        Image_mystery_shop_honor:setVisible(true)
    elseif tonumber(self.data.sell_type) == 28 then
        Image_mystery_shop_legion:setVisible(true)
    elseif tonumber(self.data.sell_type) == 31 then
        Image_mystery_shop_legion_pk:setVisible(true)
    end    

    local name = ""
    local numbers = tonumber(self.data.sell_count)
    local _prop_type = tonumber(self.data.goods_type)
    local mould_id = self.data.goods_id
    local quality = 0
    local price = self.data.sell_price

    function change_type(prop_type)
        if _prop_type == 0 then
            return 6 
        elseif prop_type == 1 then
            return 13
        elseif prop_type == 2 then
            return 7
        elseif prop_type == 4 then
            return 34
        elseif prop_type == 5 then
            return 12
        elseif prop_type == -1 then
            return 1
        elseif prop_type == 6 then
            return 36
        elseif prop_type == 7 then
            return 38
        elseif prop_type == 8 then
            return 37
        end
    end

    local data = 
    {
         item_value = tonumber(self.data.sell_count),
         prop_type = change_type(_prop_type),
         prop_item = self.data.goods_id
    }
    local cell = nil

    if tonumber(self.data.goods_type) == 0 then--道具类型
        quality = tonumber(dms.string(dms["prop_mould"], mould_id, prop_mould.prop_quality))
        name = dms.string(dms["prop_mould"], mould_id, prop_mould.prop_name)
        local equipment_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], mould_id, prop_mould.change_of_equipment))
        local ship_mould_id = zstring.tonumber(dms.int(dms["prop_mould"],mould_id, prop_mould.use_of_ship))
        if equipment_mould_id > 0 or ship_mould_id > 0 then
            cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,8,0,false,false})
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
        end             
        
    elseif tonumber(self.data.goods_type) == 1 then--武将类型
        quality = tonumber(dms.string(dms["ship_mould"], mould_id , ship_mould.ship_type))
        local ship_mould_id = dms.int(dms["ship_mould"], mould_id , ship_mould.id)
        name = dms.string(dms["ship_mould"], self.data.goods_id, ship_mould.captain_name)
        cell = state_machine.excute("all_resource_create_cell",0,{6,data,data,8,0,false,false})
    elseif tonumber(self.data.goods_type) == 2 then--装备类型
        name = dms.string(dms["equipment_mould"], mould_id, equipment_mould.equipment_name)
        quality = dms.int(dms["equipment_mould"], mould_id, equipment_mould.grow_level)
        cell = state_machine.excute("all_resource_create_cell",0,{6,data,data,8,0,false,false}) 
    elseif tonumber(self.data.goods_type) == 4 then--宝石
        name = dms.string(dms["gems_mould"], mould_id, gems_mould.name)
        quality = dms.int(dms["gems_mould"], mould_id, gems_mould.quality)
        cell = state_machine.excute("all_resource_create_cell",0,{5,data,data,8,0,false,false})
    elseif tonumber(self.data.goods_type) == 5 then -- 体力
        name = _All_tip_string_info._energyName
        quality = 6
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false}) 
    elseif tonumber(self.data.goods_type) == -1 then -- 银币
        name = _All_tip_string_info._fundName
        quality = 6
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
    elseif tonumber(self.data.goods_type) == 6 then -- 马魂
        name = dms.string(dms["horse_spirit_mould"], mould_id, horse_spirit_mould.horse_spirit_name)
        quality = dms.int(dms["horse_spirit_mould"], mould_id, horse_spirit_mould.quality)
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
    elseif tonumber(self.data.goods_type) == 7 then -- 马魂碎片
        name = _All_tip_string_info._horse
        quality = 6
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
    elseif tonumber(self.data.goods_type) == 8 then -- 龙马碎片
        name = _All_tip_string_info._horse_spirit
        quality = 6
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
    else
        name = ""
        quality = 6
        cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false}) 
    end
    Panel_mystery_shop_celll_icon:addChild(cell)

    if numbers > 1 then
        Text_mystery_shop_celll_name:setString(name.. "x" .. numbers)
    else
        Text_mystery_shop_celll_name:setString(name)
    end

    Text_mystery_shop_soul_number:setString(price)
    Text_mystery_shop_celll_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))

end

function MysteryShopCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.shop.mystery_shop_cell)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 
    if MysteryShopCell.__size == nil then
        MysteryShopCell.__size = root:getContentSize()
    end

    local Button_mystery_shop_cell_1 = ccui.Helper:seekWidgetByName(root, "Button_mystery_shop_cell_1")
    if missionIsOver() == true then
        Button_mystery_shop_cell_1:setSwallowTouches(false)
        local function panelTouchListener( sender, eventType )
            local __spoint = sender:getTouchBeganPosition()
            local __mpoint = sender:getTouchMovePosition()
            local __epoint = sender:getTouchEndPosition()

            if eventType == ccui.TouchEventType.began then
            elseif eventType == ccui.TouchEventType.moved then
            elseif eventType == ccui.TouchEventType.canceled then
            elseif eventType == ccui.TouchEventType.ended then
                if math.abs(__spoint.x - __epoint.x) <= 10 and math.abs(__spoint.y - __epoint.y) <= 10 then
                    state_machine.excute("mystery_shop_cell_to_buy_window", 0, {_datas = {cell = self}})
                end
            end
        end
        Button_mystery_shop_cell_1:addTouchEventListener(panelTouchListener)
    else
        fwin:addTouchEventListener(Button_mystery_shop_cell_1, nil, 
        {
            terminal_name = "mystery_shop_cell_to_buy_window", 
            terminal_state = 0, 
            cell = self, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
        }, nil, 1) 
    end

	self:updateDraw()
end

function MysteryShopCell:onEnterTransitionFinish()

end

function MysteryShopCell:init(data, id, shop_type)
    self.data = data
    self.id = id
    self.shop_type = shop_type
	self:onInit()
    self:setContentSize(MysteryShopCell.__size)
end

function MysteryShopCell:onExit()
    state_machine.remove("mystery_shop_cell_to_buy_window")
end