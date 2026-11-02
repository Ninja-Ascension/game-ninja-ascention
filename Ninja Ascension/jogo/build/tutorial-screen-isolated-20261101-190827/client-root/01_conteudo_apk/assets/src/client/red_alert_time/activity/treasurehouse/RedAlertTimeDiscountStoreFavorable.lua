--------------------------------------------------------------------------------------------------------------
--  说明：折扣卖场折扣道具界面
--------------------------------------------------------------------------------------------------------------
RedAlertTimeDiscountStoreFavorable = class("RedAlertTimeDiscountStoreFavorableClass", Window)
RedAlertTimeDiscountStoreFavorable.__size = nil

--打开界面
local red_alert_time_discount_store_favorable_open_terminal = {
	_name = "red_alert_time_discount_store_favorable_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local cell = RedAlertTimeDiscountStoreFavorable:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
	    return cell
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(red_alert_time_discount_store_favorable_open_terminal)
state_machine.init()

function RedAlertTimeDiscountStoreFavorable:ctor()
	self.super:ctor()
	self.roots = {}
    self.page = nil 
    self._activity_type = nil

    self.need_gold_arry = {}
    self.goods_name_arry = {}
    self.quality_arry = {}
    self.need_gold = 0
    self.goods_name = ""
    self.quality = 0
    self.remain_number = {}
    self.curr_dis = ""
	
    local function init_red_alert_time_discount_store_favorable_terminal()

        --购买
        local red_alert_time_discount_store_favorable_explore_terminal = {
            _name = "red_alert_time_discount_store_favorable_explore",
            _init = function (terminal) 
                app.load("client.red_alert_time.worldMap.redAlertTimeMineWarmTips")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                local index = params._datas._index
                if cell.remain_number[index] == 0 then
                    TipDlg.drawTextDailog(activity_str_tip[139])
                    return
                end
                cell.need_gold = cell.need_gold_arry[index]
                cell.goods_name = cell.goods_name_arry[index]
                cell.quality = cell.quality_arry[index]
                if cell.page == 2 then
                    local activity_type = _ED.activity_info["103"]
                    local activity_add_state = zstring.split(activity_type.activity_add_state,",")
                    cell.curr_dis = ""
                    if tonumber(activity_add_state[4]) < 1 then
                        local curr_discount = tonumber(activity_add_state[4]) * 10
                        if verifySupportLanguage(_lua_release_language_en) == true then
                            curr_discount = (10 - curr_discount) * 10
                        end
                        cell.curr_dis = string.format(activity_str_tip[143] , curr_discount)
                        cell.curr_dis = "%|1|("..cell.curr_dis..")%"
                        cell.need_gold = cell.need_gold * tonumber(activity_add_state[4])
                    end
                    if tonumber(activity_add_state[5]) > 0 then
                        cell.curr_dis = string.format(activity_str_tip[144] , tonumber(activity_add_state[5]))
                        cell.curr_dis = "%|1|("..cell.curr_dis..")%"
                        cell.need_gold = cell.need_gold - tonumber(activity_add_state[5])
                    end
                    if cell.need_gold < 0 then
                        cell.need_gold = 0
                    end
                end
                state_machine.excute("red_alert_time_mine_warm_tips_open", 0, {_datas = {cell = {cell, index, cell.page}, m_type = 29}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local red_alert_time_discount_store_favorable_update_terminal = {
            _name = "red_alert_time_discount_store_favorable_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= nil and params.roots ~= nil and params.roots[1] ~= nil then
                    params:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(red_alert_time_discount_store_favorable_update_terminal)
        state_machine.add(red_alert_time_discount_store_favorable_explore_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_discount_store_favorable_terminal()
end

function RedAlertTimeDiscountStoreFavorable:drawLastCount( cell )
    local root = cell.roots[1]
    local discount_store_info = _ED.treasure_discount_store_info[cell.page - 1]
    local all_reward_data = cell._activity_type.activity_data[cell.page]
    for i = 1 , 9 do
        local index = tonumber(discount_store_info.reward[i].index) + 1
        local reward_data =  all_reward_data[index]
        local remain_number = tonumber(discount_store_info.reward[i].remain_number)
        local Text_discount_props_n = ccui.Helper:seekWidgetByName(root,"Text_discount_props_n_"..i)
        local Text_discount_n = ccui.Helper:seekWidgetByName(root,"Text_discount_n_"..i) -- 现价
        Text_discount_props_n:setString("")
        Text_discount_props_n:removeAllChildren(true)
        local fontSize = Text_discount_props_n:getFontSize()
        cell.remain_number[i] = remain_number
        if remain_number >= 0 then
            local _richText = ccui.RichText:create()
            _richText:ignoreContentAdaptWithSize(false)
            _richText:setContentSize(cc.size(Text_discount_props_n:getContentSize().width, 0))
            _richText:setAnchorPoint(cc.p(0, 0))
            local char_str = zstring.replace(activity_str_tip[137] , "!x@" , remain_number)
            local rt, count, text = draw.richTextCollectionMethod(_richText, 
            char_str, 
            cc.c3b(189, 206, 224),
            cc.c3b(189, 206, 224),
            0, 
            0, 
            config_res.font.font_name, 
            fontSize,
            chat_rich_text_color)
            _richText:formatTextExt()
            _richText:setPositionY(Text_discount_props_n:getPositionY())
            Text_discount_props_n:addChild(_richText)
        end
        local price_info = zstring.split(reward_data.achieve_other_info , ",")
        Text_discount_n:setString(price_info[3])
        self.need_gold_arry[i] = tonumber(price_info[3])
        if self.page == 2 then
            local activity_add_state = zstring.split(_ED.activity_info["103"].activity_add_state,",")
            if tonumber(activity_add_state[4]) < 1 then
                Text_discount_n:setString(tonumber(price_info[3]) * tonumber(activity_add_state[4]))
            end
            if tonumber(activity_add_state[5]) > 0 then
                local need_gold = tonumber(price_info[3]) - tonumber(activity_add_state[5])
                if need_gold <= 0 then
                    need_gold = 0
                end
                Text_discount_n:setString(need_gold)
            end
        end
    end
end

function RedAlertTimeDiscountStoreFavorable:updateDraw()
    local root = self.roots[1]
    --信息
    local all_reward_data = self._activity_type.activity_data[self.page]
    local Text_discount_store_title = ccui.Helper:seekWidgetByName(root,"Text_discount_store_title")
    local activity_add_state_arry = zstring.split(self._activity_type.activity_add_state,"|")
    local activity_add_state = zstring.split(activity_add_state_arry[1],",")

    Text_discount_store_title:setString(string.format(activity_str_tip[140], tonumber(activity_add_state[9])))
    if self.page == 2 then
        Text_discount_store_title:setString("")
    end
    local discount_store_info = _ED.treasure_discount_store_info[self.page - 1]
    for i = 1 , 9 do
        local index = tonumber(discount_store_info.reward[i].index) + 1
        local reward_data =  all_reward_data[index]
        --道具
        local Panel_discount_icon = ccui.Helper:seekWidgetByName(root,"Panel_discount_icon_"..i)
        Panel_discount_icon:removeAllChildren(true)
        local datas = zstring.split(reward_data.achieve_reward, ",")
        local quality = 0
        if tonumber(datas[1]) == -1 then
            datas[1] = resource_prop_id[tonumber(datas[2])]
            datas[2] = 1
            quality = 4
        end
        local prop_type = tonumber(datas[2])
        local show_type = 9
        local prop_from_type = 3
        if tonumber(datas[2]) == 13 then --坦克
            prop_type = 3
            quality = dms.int(dms["ship_mould"], tonumber(datas[1]), ship_mould.ship_type)
        elseif tonumber(datas[2]) == 6 then --道具    
            prop_type = 1
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
        else
            prop_type = 1
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
        local curr_name = ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):getString()
        curr_name = curr_name.."*"..datas[3]
        ccui.Helper:seekWidgetByName(cell.roots[1], "Text_props_name"):setString("")
        self.goods_name_arry[i] = curr_name
        self.quality_arry[i] = quality

        Panel_discount_icon:addChild(cell)
        --价格
        local price_info = zstring.split(reward_data.achieve_other_info , ",")
        local Text_discount_old_n = ccui.Helper:seekWidgetByName(root,"Text_discount_old_n_"..i) -- 原价
        Text_discount_old_n:setString(price_info[4])
    end
    self:drawLastCount(self)
    
end

--初始化
function RedAlertTimeDiscountStoreFavorable:onInit()
    local root = cacher.createUIRef(config_csb.treasurehouse.discount_store_tab_4, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    for i = 1 , 9 do 
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_discount_icon_"..i), nil, 
        {
            terminal_name = "red_alert_time_discount_store_favorable_explore", 
            terminal_state = 0, 
            _index = i,
            _cell = self,
        }, nil, 1)
    end 
    if RedAlertTimeDiscountStoreFavorable.__size == nil then
        RedAlertTimeDiscountStoreFavorable.__size = root:getContentSize()
    end   
    self:updateDraw()
end

function RedAlertTimeDiscountStoreFavorable:onEnterTransitionFinish()

end

function RedAlertTimeDiscountStoreFavorable:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_discount_store_title = ccui.Helper:seekWidgetByName(root,"Text_discount_store_title")
    if Text_discount_store_title ~= nil then
        Text_discount_store_title:setString("")
        for i = 1 , 9 do
            local Panel_discount_icon = ccui.Helper:seekWidgetByName(root,"Panel_discount_icon_"..i)
            local Text_discount_n = ccui.Helper:seekWidgetByName(root,"Text_discount_n_"..i)
            local Text_discount_old_n = ccui.Helper:seekWidgetByName(root,"Text_discount_old_n_"..i)
            local Text_discount_props_n = ccui.Helper:seekWidgetByName(root,"Text_discount_props_n_"..i)
            Panel_discount_icon:removeAllChildren(true)
            Text_discount_n:setString("")
            Text_discount_old_n:setString("")
            Text_discount_props_n:setString("")
            Text_discount_props_n:removeAllChildren(true)
        end
    end
end

function RedAlertTimeDiscountStoreFavorable:init(params)
    self._activity_type = params[1]
    self.page = params[2]
	self:onInit()
    self:setContentSize(RedAlertTimeDiscountStoreFavorable.__size)
    return self
end

function RedAlertTimeDiscountStoreFavorable:onExit()
    state_machine.remove("red_alert_time_discount_store_favorable_explore")
    state_machine.remove("red_alert_time_discount_store_favorable_update")
    self:clearUIInfo()
    cacher.freeRef(config_csb.treasurehouse.discount_store_tab_4, self.roots[1])
end