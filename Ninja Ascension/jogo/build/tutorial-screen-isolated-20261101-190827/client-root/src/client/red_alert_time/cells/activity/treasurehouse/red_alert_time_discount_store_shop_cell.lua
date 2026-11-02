--------------------------------------------------------------------------------------------------------------
--  说明：折扣卖场界面3cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeDiscountStoreShopCell = class("RedAlertTimeDiscountStoreShopCellClass", Window)
RedAlertTimeDiscountStoreShopCell.__size = nil

--创建cell
local red_alert_time_discount_store_shop_cell_create_terminal = {
    _name = "red_alert_time_discount_store_shop_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeDiscountStoreShopCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_discount_store_shop_cell_create_terminal)
state_machine.init()

function RedAlertTimeDiscountStoreShopCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._activity_data = nil
    self.need_gold = 0
    self.goods_name = ""
    self.quality = 0
    self.remain_number = 0
    self._prop_id = 0
    self.cost_gold = 0
    self.prop_name = ""
    self.prop_type = 0
    app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_discount_label")
    local function init_red_alert_time_discount_store_shop_cell_terminal()
        local red_alert_time_discount_store_shop_cell_update_info_terminal = {
            _name = "red_alert_time_discount_store_shop_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params
                if cell.roots ~= nil and cell.roots[1] ~= nil then
                    cell:drawLastCount(cell)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_discount_store_shop_cell_buy_terminal = {
            _name = "red_alert_time_discount_store_shop_cell_buy",
            _init = function (terminal) 
                app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell.remain_number <= 0 then
                    TipDlg.drawTextDailog(activity_str_tip[139])
                    return
                end
                cell._base_avatar_shop_info = { cost_gold = cell.cost_gold, cell = cell , fromType = 1, max_select_num = cell.remain_number ,prop_type = cell.prop_type}
                --state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {cell, cell._index, 3}, m_type = 29}}) 
                state_machine.excute("props_batch_buy_window_open", 0, {cell._prop_id, cell._base_avatar_shop_info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_discount_store_shop_cell_update_info_terminal)   
        state_machine.add(red_alert_time_discount_store_shop_cell_buy_terminal)     
        state_machine.init()
    end 
    init_red_alert_time_discount_store_shop_cell_terminal()
end
function RedAlertTimeDiscountStoreShopCell:drawLastCount( cell )
    local root = cell.roots[1]
    --可购买次数
    local price_info = zstring.split(self._activity_data.achieve_other_info , ",")
    local Button_discount_shop_buy = ccui.Helper:seekWidgetByName(root, "Button_discount_shop_buy")
    local Text_discount_store_can_buy_n = ccui.Helper:seekWidgetByName(root, "Text_discount_store_can_buy_n")
    local discount_store_info = _ED.treasure_discount_store_info[2]
    local remain_number = tonumber(discount_store_info.reward[self._index].remain_number)
    self.remain_number = remain_number
    Text_discount_store_can_buy_n:setString(remain_number.."/"..price_info[7])
    local Button_discount_shop_buy = ccui.Helper:seekWidgetByName(root, "Button_discount_shop_buy")
    if self.remain_number <= 0 then
        Button_discount_shop_buy:setTouchEnabled(false)
        Button_discount_shop_buy:setBright(false)
    else
        Button_discount_shop_buy:setTouchEnabled(true)
        Button_discount_shop_buy:setBright(true)
    end
end

function RedAlertTimeDiscountStoreShopCell:updateDraw()
    local root = self.roots[1]
    --图标
    --local all_reward_data = _ED.activity_info["103"].activity_data[3]
    --local reward_data = all_reward_data[self._activity_data]
    local reward_data = self._activity_data
    local price_info = zstring.split(reward_data.achieve_other_info , ",")

    local Panel_discount_store_shop_icon = ccui.Helper:seekWidgetByName(root, "Panel_discount_store_shop_icon")
    Panel_discount_store_shop_icon:removeAllChildren(true)
    local quality = 0
    local datas = zstring.split(reward_data.achieve_reward, ",")
    if tonumber(datas[1]) == -1 then
        datas[1] = resource_prop_id[tonumber(datas[2])]
        datas[2] = 1
        quality = 4
    end
    local prop_type = tonumber(datas[2])
    self.prop_type = prop_type
    local show_type = 9
    local prop_from_type = 3
    if tonumber(datas[2]) == 13 then --坦克
        prop_type = 3
        prop_from_type = 10
        quality = dms.int(dms["ship_mould"], tonumber(datas[1]), ship_mould.ship_type)
    elseif tonumber(datas[2]) == 6 then --道具    
        prop_type = 1
        prop_from_type = 1
        local pic_index = dms.string(dms["prop_mould"], tonumber(datas[1]), prop_mould.pic_index)
        pic_index = zstring.split(pic_index, ",")
        local prop_name = dms.string(dms["prop_mould"], tonumber(datas[1]), prop_mould.prop_name)
        if tonumber(pic_index[3]) == nil then
            show_type = 6
        end
        quality = dms.int(dms["prop_mould"], tonumber(datas[1]), prop_mould.prop_quality)
    elseif tonumber(datas[2]) == 7 then --配件    
        prop_type = 7
        quality = dms.int(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.grow_level)
        prop_from_type = 4
    else
        prop_type = 1
        prop_from_type = 1
    end
    local cell = nil
    if prop_type == 7 then
        local equip_datas = {}
        equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.equipment_name)
        equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(datas[1]), equipment_mould.pic_index)
        cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3])})
    else
        cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(datas[1]), tonumber(prop_type), tonumber(datas[3])})
    end
    self._prop_id = tonumber(datas[1])
    local curr_name = ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):getString()
    ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):setString("")
    if tonumber(datas[3]) > 1 then
        self.prop_name = curr_name.."*"..datas[3]
    else
        self.prop_name = curr_name
    end
    self.quality = quality  
    Panel_discount_store_shop_icon:addChild(cell)

    --名称
    local Text_discount_store_name = ccui.Helper:seekWidgetByName(root, "Text_discount_store_name")
    Text_discount_store_name:removeAllChildren(true)
    Text_discount_store_name:setString("")
    local font_size = Text_discount_store_name:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[8][1],color_Type[8][2],color_Type[8][3]),255, curr_name, config_res.font.font_name,font_size)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "*"..datas[3], config_res.font.font_name,font_size)
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(Text_discount_store_name:getContentSize().width/2,Text_discount_store_name:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_discount_store_name:getContentSize().width,font_size))
    Text_discount_store_name:addChild(_richText)

    local price_info = zstring.split(reward_data.achieve_other_info , ",")
    --现价
    local Text_discount_shop_buy_n = ccui.Helper:seekWidgetByName(root, "Text_discount_shop_buy_n")
    Text_discount_shop_buy_n:setString(price_info[3])
    self.need_gold = tonumber(price_info[3])
    self.cost_gold = tonumber(price_info[3])
    --原价
    local Text_discount_shop_buy_old_n = ccui.Helper:seekWidgetByName(root, "Text_discount_shop_buy_old_n")
    Text_discount_shop_buy_old_n:setString(price_info[4])
    self:drawLastCount(self)
    --折扣
    local discountCell = state_machine.excute("red_alert_time_discount_label_cell",0,{price_info[5]})
    Panel_discount_store_shop_icon:addChild(discountCell)
end

function RedAlertTimeDiscountStoreShopCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.discount_store_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeDiscountStoreShopCell.__size == nil then
        RedAlertTimeDiscountStoreShopCell.__size = root:getContentSize()
    end

    self:setContentSize(RedAlertTimeDiscountStoreShopCell.__size)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_discount_shop_buy"), nil, 
    {
        terminal_name = "red_alert_time_discount_store_shop_cell_buy", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeDiscountStoreShopCell:onEnterTransitionFinish()

end

function RedAlertTimeDiscountStoreShopCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeDiscountStoreShopCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.discount_store_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeDiscountStoreShopCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_discount_store_shop_icon = ccui.Helper:seekWidgetByName(root, "Panel_discount_store_shop_icon")
    local Text_discount_store_can_buy_n = ccui.Helper:seekWidgetByName(root, "Text_discount_store_can_buy_n")
    local Text_discount_store_name = ccui.Helper:seekWidgetByName(root, "Text_discount_store_name")
    local Text_discount_shop_buy_old_n = ccui.Helper:seekWidgetByName(root, "Text_discount_shop_buy_old_n")
    local Text_discount_shop_buy_n = ccui.Helper:seekWidgetByName(root, "Text_discount_shop_buy_n")
    if Panel_discount_store_shop_icon ~= nil then
        Panel_discount_store_shop_icon:removeAllChildren(true)
        Text_discount_store_can_buy_n:setString("")
        Text_discount_store_name:removeAllChildren(true)
        Text_discount_shop_buy_old_n:setString("")
        Text_discount_shop_buy_n:setString("")
        Text_discount_store_name:setString("")
    end
end

function RedAlertTimeDiscountStoreShopCell:init(params)
    self._index = params[1]
    self._activity_data = params[2]
    if self._index ~= nil and self._index <= 9 then
        self:onInit()
    end
    
    return self
end

function RedAlertTimeDiscountStoreShopCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.discount_store_cell, self.roots[1])
end