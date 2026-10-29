--------------------------------------------------------------------------------------------------------------
--  说明：单个活动标签
--------------------------------------------------------------------------------------------------------------
ActiveLeftCell = class("ActiveLeftCellClass", Window)
ActiveLeftCell.__size = nil

--创建cell
local active_left_create_cell_terminal = {
    _name = "active_left_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activity_type = params[1]
        local index = params[2]
        local cell = ActiveLeftCell:new()
        cell:init(activity_type,index)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(active_left_create_cell_terminal)
state_machine.init()

function ActiveLeftCell:ctor()
	self.super:ctor()
	self.roots = {}

    -- var 
    --活动类型
    self._activity_type = nil
    --是否选中
    self._select = false

    --推送刷新
    self._last_time = nil

    --活动推送
    self._push_activity = nil
	 -- Initialize active_left_cell state machine.
    local function init_active_left_cell_terminal()
		
  		--选中活动标签
  		local active_left_cell_click_terminal = {
            _name = "active_left_cell_click",
            _init = function (terminal)
                  
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params._datas.cell
                local activity = _ED.activity_info[""..cell._activity_type]
                if activity ~= nil then 
                    activity._new_activity = false
                    cell._new_activity:setVisible(false)
                    cc.UserDefault:getInstance():setStringForKey(getKey("push_new_activity"..activity.activity_type), activity.activity_id)
                end
                state_machine.excute("wonderful_set_un_select",0,"")
                cell._select = true
                local activity_type = tonumber(cell._activity_type)
                cell:setSelect(activity_type)
                state_machine.excute("wonderful_show_activity_by_type",0,{activity_type})
                state_machine.excute("wonderful_update_by",0,{activity_type})

                return true
            end,
            _terminal = nil,
            _terminals = nil
          }

          --选中活动标签
        local active_left_cell_update_draw_terminal = {
            _name = "active_left_cell_update_draw",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                params:updateDraw(tonumber(params))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(active_left_cell_update_draw_terminal)
  		state_machine.add(active_left_cell_click_terminal)
        state_machine.init()
    end 
    -- call func active_left_cell create state machine.
    init_active_left_cell_terminal()

end

function ActiveLeftCell:setSelect(activity_type)
    local root = self.roots[1]
    local Image_light = ccui.Helper:seekWidgetByName(root,"Image_light")
    local Text_active_name = ccui.Helper:seekWidgetByName(root,"Text_active_name")
    if Image_light ~= nil then
        if self._select == true then
            Text_active_name:setColor(cc.c3b(255,234,198))
        else
            Text_active_name:setColor(cc.c3b(144,101,65))
        end
        Image_light:setVisible(self._select)
    end
end

function ActiveLeftCell:updateDraw(index)
    if index ~= nil then
        self._activity_type = index
    end
    local root = self.roots[1]
    -- local Panel_picture = ccui.Helper:seekWidgetByName(root,"Panel_picture")
    -- Panel_picture:removeBackGroundImage()
    -- Panel_picture:setBackGroundImage("images/ui/wonderful/activity_icon/activity_icon_"..self._activity_type .. ".png")
    -- 月卡
    self._drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
    local Text_active_name = ccui.Helper:seekWidgetByName(root,"Text_active_name")
    local Image_first = ccui.Helper:seekWidgetByName(root,"Image_first")
    Image_first:setVisible(false)
    local Panel_98_time = ccui.Helper:seekWidgetByName(root,"Panel_98_time")-- 98礼包倒计时
    Panel_98_time:setVisible(false)
    local Image_day_7 = ccui.Helper:seekWidgetByName(root,"Image_day_7")-- 送郭靖气泡
    Image_day_7:setVisible(false)
    local Image_day_14 = ccui.Helper:seekWidgetByName(root,"Image_day_14")-- 送小龙女气泡
    Image_day_14:setVisible(false)
    -- VIP基金
    local Image_exp_vip_1 = ccui.Helper:seekWidgetByName(root,"Image_exp_vip_1")
    local Image_exp_vip_2 = ccui.Helper:seekWidgetByName(root,"Image_exp_vip_2")
    local Image_exp_vip_3 = ccui.Helper:seekWidgetByName(root,"Image_exp_vip_3")
    local Panel_on = ccui.Helper:seekWidgetByName(root,"Panel_on")
    local Panel_off = ccui.Helper:seekWidgetByName(root,"Panel_off")
    Image_exp_vip_1:setVisible(false)
    Image_exp_vip_2:setVisible(false)
    Image_exp_vip_3:setVisible(false)
    Panel_on:setVisible(false)
    Panel_off:setVisible(false)
    if tonumber(self._activity_type) == 9 then 
        Image_exp_vip_1:setVisible(true)
        Text_active_name:setString(wonderful_all_str[tonumber(self._activity_type)])
        if tonumber(_ED.activity_info["9"].activity_data[1][1].achieve_state) < 2 and tonumber(_ED.vip_grade) >= 2 then
            Panel_on:setVisible(true)
        end
    elseif tonumber(self._activity_type) == 24 then 
        Image_exp_vip_2:setVisible(true)
        Text_active_name:setString(wonderful_all_str[tonumber(self._activity_type)])
        if tonumber(_ED.activity_info["24"].activity_data[1][1].achieve_state) < 2 and tonumber(_ED.vip_grade) >= 3 then
            Panel_on:setVisible(true)
        end
    elseif tonumber(self._activity_type) == 25 then 
        Image_exp_vip_3:setVisible(true)
        Text_active_name:setString(wonderful_all_str[tonumber(self._activity_type)])
        if tonumber(_ED.activity_info["25"].activity_data[1][1].achieve_state) < 2 and tonumber(_ED.vip_grade) >= 4 then
            Panel_on:setVisible(true)
        end
    elseif tonumber(self._activity_type) == 15 then
        local month = tonumber(os.date("%m",zstring.exchangeFrom(os.time())))
        Text_active_name:setString(string.format(wonderful_all_str[tonumber(self._activity_type)],month))
    elseif tonumber(self._activity_type) == 2 then
        if tonumber(_ED.activity_info["2"].activity_data[1][1].achieve_state) < 2 then
            Text_active_name:setString(wonderful_first_str[1])
        elseif tonumber(_ED.activity_info["2"].activity_data[1][2].achieve_state) < 2 then
            Image_first:setVisible(true)
            Text_active_name:setString(wonderful_first_str[2])
        elseif tonumber(_ED.activity_info["2"].activity_data[1][3].achieve_state) < 2 then
            Image_first:setVisible(true)
            Text_active_name:setString(wonderful_first_str[3])
        end
    elseif tonumber(self._activity_type) == 39 then
        local name = zstring.split(_ED.activity_info["39"].activity_add_state, ",")[2]
        local disc = wonderful_operator_activity_str[1][2]
        for k,v in pairs(wonderful_operator_activity_str) do
            if v[1] == name then
                disc = v[2]
            end
        end
        Text_active_name:setString(disc)
    elseif tonumber(self._activity_type) == 1001 then
        Text_active_name:setString(wonderful_other_str[1])
    else
        Text_active_name:setString(wonderful_all_str[tonumber(self._activity_type)])
    end
    Text_active_name:setColor(cc.c3b(144,101,65))

    local Image_light = ccui.Helper:seekWidgetByName(root,"Image_light")
    Image_light:setVisible(self._select)
    if self._select == true then
        Text_active_name:setColor(cc.c3b(255,234,198))
    else
        Text_active_name:setColor(cc.c3b(144,101,65))
    end
    self._new_activity:setVisible(false)
    self:pushNotificationActivity()

    if _ED.activity_info[""..self._activity_type] ~= nil then 
        if _ED.activity_info[""..self._activity_type]._new_activity == true then 
          self._new_activity:setVisible(true)
        end
    end
end

function ActiveLeftCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.wonderful.active_left_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ActiveLeftCell.__size == nil then
        ActiveLeftCell.__size = root:getContentSize()
    end
    local Image_push = ccui.Helper:seekWidgetByName(root,"Image_push")
    self._push_activity = Image_push
    local Image_new = ccui.Helper:seekWidgetByName(root,"Image_new")
    self._new_activity = Image_new
    --选择当前活动页
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_bg"), nil, 
    {
        terminal_name = "active_left_cell_click", 
        terminal_state = 0, 
        cell = self, 
    }, nil, 1)    

	self:updateDraw()

end

function ActiveLeftCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function ActiveLeftCell:pushNotificationActivity()
    if _ED.activity_info == nil or (_ED.activity_info[""..self._activity_type] == nil and tonumber(self._activity_type) ~= 1)then
        self._push_activity:setVisible(false)
        return
    end
    if tonumber(self._activity_type) == 21 then      --三签
        local infos = zstring.split(_ED.activity_info["21"].activity_add_state, "|")
        local server_time = _ED.system_time + (os.time() - _ED.native_time)

        if tonumber(infos[5]) == 2 then
            self._push_activity:setVisible(false)
            return 
        end

        if tonumber(infos[5]) < 0 
            or (tonumber(infos[5]) ~= 1 and server_time >= tonumber(infos[6]))
            or (tonumber(infos[5]) ~= 2 and server_time >= tonumber(infos[6])) then 
            self._push_activity:setVisible(true)
            return 
        end
    elseif tonumber(self._activity_type) == 5 then
        local now_day = tonumber(_ED.activity_info["5"].activity_add_state) + 1
        for i, activity_data in pairs(_ED.activity_info["5"].activity_data[now_day]) do
            if tonumber(activity_data.achieve_state) == 1 then
                self._push_activity:setVisible(true)
                return
            end
        end
    elseif tonumber(self._activity_type) == 17 then   -- 超值兑换
        local activity_type = _ED.activity_info["17"].activity_data[1]
        local counts = 0
        for i,v in pairs(activity_type) do
            local complete_count = zstring.split(v.achieve_complete_count, "/")
            if tonumber(complete_count[1]) == 0 then
                counts = counts + 1
            end
        end
        if counts ~= #activity_type then
            self._push_activity:setVisible(true)
            return
        end
    elseif tonumber(self._activity_type) == 1 then
        if _ED.month_card ~= nil and _ED.month_card ~= "" and _ED.month_card[self._drawMonth[1][1]] ~= nil and _ED.month_card[self._drawMonth[1][1]] ~= "" then
            if zstring.tonumber(_ED.month_card[self._drawMonth[1][1]].draw_month_card_state) == 0 then 
                self._push_activity:setVisible(true)
                return
            end
        end
        if _ED.month_card ~= nil and _ED.month_card ~= "" and _ED.month_card[self._drawMonth[2][1]] ~= nil and _ED.month_card[self._drawMonth[2][1]] ~= "" then
            if zstring.tonumber(_ED.month_card[self._drawMonth[2][1]].draw_month_card_state) == 0 then 
                self._push_activity:setVisible(true)
                return
            end
        end
    elseif tonumber(self._activity_type) == 9 or tonumber(self._activity_type) == 24 or tonumber(self._activity_type) == 25 then
        local activity_type = _ED.activity_info[""..self._activity_type].activity_data
        for j,k in pairs(activity_type[1]) do
            if tonumber(k.achieve_state) == 2 then
                for i,v in pairs(activity_type) do
                    for m,activity_data in pairs(v) do
                        if tonumber(activity_data.achieve_state) == 1 then
                            self._push_activity:setVisible(true)
                            return
                        end
                    end
                end 
            end
        end
    elseif tonumber(self._activity_type) == 15 then
        local activity_add_state = zstring.split(_ED.activity_info["15"].activity_add_state,",")
        if nil ~= activity_add_state 
            and #activity_add_state > 1 
            and tonumber(activity_add_state[1]) < tonumber(activity_add_state[2]) 
            then
            self._push_activity:setVisible(true)
            return
        end    
    elseif tonumber(self._activity_type) == 38 then   -- 十连抽送碎片
        local propRecruitCount_ten = 0      
        if fundPropWidthId(258) ~= nil then 
            local token = fundPropWidthId(258)  -- 十连书
            propRecruitCount_ten = token.prop_number
        end
        if tonumber(propRecruitCount_ten) > 0 or _ED.send_pieces_activity_tip == 1 then
            self._push_activity:setVisible(true)
            return
        end
    elseif tonumber(self._activity_type) == 41 then   -- 单笔充值2
        local activity_add_state = zstring.split(_ED.activity_info[""..self._activity_type].activity_add_state,",")
        for i,v in pairs(_ED.activity_info[""..self._activity_type].activity_data) do
            for m,activity_data in pairs(v) do
                local achieve_complete_count = zstring.split(activity_data.achieve_complete_count,"/")
                if tonumber(achieve_complete_count[1]) > tonumber(activity_add_state[activity_data.achieve_index]) then
                    self._push_activity:setVisible(true)
                    return
                end
            end
        end
    else
        for i,v in pairs(_ED.activity_info[""..self._activity_type].activity_data) do
            for m,activity_data in pairs(v) do
                if tonumber(activity_data.achieve_state) == 1 then
                    self._push_activity:setVisible(true)
                    return
                end
            end
        end 
    end
    self._push_activity:setVisible(false)
end

function ActiveLeftCell:onUpdate()
    if self._push_activity == nil then
       return
    end
    local now_time = os.time()
    if now_time - zstring.tonumber(self._last_time) >= 1 then
        self:pushNotificationActivity()
        self._last_time = now_time
    end
end

function ActiveLeftCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function ActiveLeftCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.activity.wonderful.active_left_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function ActiveLeftCell:init(activity_type,index)
    self._activity_type = activity_type
    if index ~= nil and index < 8 then
	   self:onInit()
    end
    self:setContentSize(ActiveLeftCell.__size)
    return self
end

function ActiveLeftCell:onExit()
    cacher.freeRef(config_csb.cells.activity.wonderful.active_left_cell, self.roots[1])
end