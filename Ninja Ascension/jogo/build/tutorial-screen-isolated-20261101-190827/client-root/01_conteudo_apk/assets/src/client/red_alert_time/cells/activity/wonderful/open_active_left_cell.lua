--------------------------------------------------------------------------------------------------------------
--  说明：单个活动标签
--------------------------------------------------------------------------------------------------------------
OpenActiveLeftCell = class("OpenActiveLeftCellClass", Window)
OpenActiveLeftCell.__size = nil

--创建cell
local open_active_left_create_cell_terminal = {
    _name = "open_active_left_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activity_type = params[1]
        local index = params[2]
        local cell = OpenActiveLeftCell:new()
        cell:init(activity_type,index)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(open_active_left_create_cell_terminal)
state_machine.init()

function OpenActiveLeftCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    -- var 
    --活动类型
    self._activity_type = nil
    --是否选中
    self._select = false

    --推送刷新
    self._last_time = nil

    --活动推送
    self._push_activity = nil
	-- Initialize open_active_left_cell state machine.
    local function init_open_active_left_cell_terminal()
  		--选中活动标签
  		local open_active_left_cell_click_terminal = {
            _name = "open_active_left_cell_click",
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
                state_machine.excute("wonderful_open_set_un_select",0,"")
                cell._select = true
                local activity_type = tonumber(cell._activity_type)
                cell:setSelect(activity_type)
                state_machine.excute("wonderful_open_show_activity_by_type",0,{activity_type})
                state_machine.excute("wonderful_open_update_by",0,{activity_type})

                return true
            end,
            _terminal = nil,
            _terminals = nil
          }
  		state_machine.add(open_active_left_cell_click_terminal)
        state_machine.init()
    end
    
    -- call func open_active_left_cell create state machine.
    init_open_active_left_cell_terminal()

end

function OpenActiveLeftCell:setSelect(activity_type)
    local root = self.roots[1]
    local Image_light = ccui.Helper:seekWidgetByName(root,"Image_light")
    local Text_active_name = ccui.Helper:seekWidgetByName(root,"Text_active_name")
    local Panel_off = ccui.Helper:seekWidgetByName(root,"Panel_off")  -- 98礼包选中显示状态
    local Panel_on = ccui.Helper:seekWidgetByName(root,"Panel_on")  -- 98礼包未选中显示状态
    if Image_light ~= nil then
        Panel_on:setVisible(false)
        Panel_off:setVisible(false)
        if self._select == true then
            Text_active_name:setColor(cc.c3b(255,234,198))
            if tonumber(self._activity_type) == 19 then
                Panel_off:setVisible(true)
            end
        else
            Text_active_name:setColor(cc.c3b(144,101,65))
            if tonumber(self._activity_type) == 19 then
                Panel_on:setVisible(true)
            end
        end
        Image_light:setVisible(self._select)
    end
end

function OpenActiveLeftCell:updateDraw()
    local root = self.roots[1]
    -- local Panel_picture = ccui.Helper:seekWidgetByName(root,"Panel_picture")
    -- Panel_picture:removeBackGroundImage()
    -- Panel_picture:setBackGroundImage("images/ui/wonderful/activity_icon/activity_icon_"..self._activity_type .. ".png")
    -- 月卡
    self._drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)

    local Text_active_name = ccui.Helper:seekWidgetByName(root,"Text_active_name")
    local Panel_98_time = ccui.Helper:seekWidgetByName(root,"Panel_98_time")  -- 98礼包倒计时
    Panel_98_time:setVisible(false)
    local Panel_off = ccui.Helper:seekWidgetByName(root,"Panel_off")  -- 98礼包选中显示状态
    Panel_off:setVisible(false)
    local Panel_on = ccui.Helper:seekWidgetByName(root,"Panel_on")  -- 98礼包未选中显示状态
    Panel_on:setVisible(false)
    local Image_first = ccui.Helper:seekWidgetByName(root,"Image_first")
    Image_first:setVisible(false)
    local Image_day_7 = ccui.Helper:seekWidgetByName(root,"Image_day_7")  -- 送郭靖气泡
    Image_day_7:setVisible(false)
    local Image_day_14 = ccui.Helper:seekWidgetByName(root,"Image_day_14")  -- 送小龙女气泡
    Image_day_14:setVisible(false)
    if tonumber(self._activity_type) == 15 then
        local month = tonumber(os.date("%m",zstring.exchangeFrom(os.time())))
        Text_active_name:setString(string.format(wonderful_all_str[tonumber(self._activity_type)],month))
    elseif tonumber(self._activity_type) == 19 then
        Text_active_name:setString(wonderful_all_str[tonumber(self._activity_type)])
        Panel_98_time:setVisible(true)
    elseif tonumber(self._activity_type) == 7 then
        Text_active_name:setString(wonderful_all_str[tonumber(self._activity_type)])
        Image_day_14:setVisible(true)
    elseif tonumber(self._activity_type) == 27 then
        Text_active_name:setString(wonderful_all_str[tonumber(self._activity_type)])
        Image_day_7:setVisible(true)
    else
        Text_active_name:setString(wonderful_all_str[tonumber(self._activity_type)])
    end

    local Image_light = ccui.Helper:seekWidgetByName(root,"Image_light")
    Image_light:setVisible(self._select)
    if self._select == true then
        Text_active_name:setColor(cc.c3b(255,234,198))
        if tonumber(self._activity_type) == 19 then
            Panel_off:setVisible(true)
        end
    else
        Text_active_name:setColor(cc.c3b(144,101,65))
        if tonumber(self._activity_type) == 19 then
            Panel_on:setVisible(true)
        end
    end
    self._new_activity:setVisible(false)
    self:pushNotificationActivity()

    if _ED.activity_info[""..self._activity_type] ~= nil then 
        if _ED.activity_info[""..self._activity_type]._new_activity == true then 
            self._new_activity:setVisible(true)
        end
    end
end

function OpenActiveLeftCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.wonderful.active_left_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)
    local action = csb.createTimeline(config_csb.cells.activity.wonderful.active_left_cell)
    table.insert(self.actions, action)
    root:runAction(action)
    action:play("animation_sent_1", true)
    
    if OpenActiveLeftCell.__size == nil then
        OpenActiveLeftCell.__size = root:getContentSize()
    end
    local Image_push = ccui.Helper:seekWidgetByName(root,"Image_push")
    self._push_activity = Image_push
    local Image_new = ccui.Helper:seekWidgetByName(root,"Image_new")
    self._new_activity = Image_new
    
    local Image_exp_vip_1 = ccui.Helper:seekWidgetByName(root,"Image_exp_vip_1")
    local Image_exp_vip_2 = ccui.Helper:seekWidgetByName(root,"Image_exp_vip_2")
    local Image_exp_vip_3 = ccui.Helper:seekWidgetByName(root,"Image_exp_vip_3")
    Image_exp_vip_1:setVisible(false)
    Image_exp_vip_2:setVisible(false)
    Image_exp_vip_3:setVisible(false)
    if tonumber(self._activity_type) == 9 then 
        Image_exp_vip_1:setVisible(true)
    elseif tonumber(self._activity_type) == 24 then 
        Image_exp_vip_2:setVisible(true)
    elseif tonumber(self._activity_type) == 25 then 
        Image_exp_vip_3:setVisible(true)
    end
    --选择当前活动页
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_bg"), nil, 
    {
        terminal_name = "open_active_left_cell_click", 
        terminal_state = 0, 
        cell = self, 
    }, nil, 1)    

	self:updateDraw()

end

function OpenActiveLeftCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function OpenActiveLeftCell:pushNotificationActivity()
    if _ED.activity_info == nil or (_ED.activity_info[""..self._activity_type] == nil and tonumber(self._activity_type) ~= 1)then
       self._push_activity:setVisible(false)
       return
    end
    if tonumber(self._activity_type) == 19 then      --98五倍返
        self._push_activity:setVisible(true)
        return
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

function OpenActiveLeftCell:onUpdate( dt )
    local BitmapFontLabel_1 = ccui.Helper:seekWidgetByName(self.roots[1],"BitmapFontLabel_1")
    if _ED.activity_info["19"] ~= nil then 
        local time = tonumber(_ED.activity_info["19"].activity_add_state)
        time = time/1000 - os.time()
        if time <= 0 then
            self:unregisterOnNoteUpdate(self)
            -- state_machine.excute("activity_pop_recharge_window_close", 0, nil)
            state_machine.excute("wonderful_open_remove_page", 0, {19})
        end
        local time = math.modf(time)
        local hour = math.floor(time/ (60 * 60))
        time = time - (hour * 60 * 60)
        local minute = math.floor(time / 60)
        time = time - minute * 60
        local second = time % 60
        if BitmapFontLabel_1 ~= nil then
            BitmapFontLabel_1:setString(string.format("%02d:%02d:%02d", hour, minute, second))
        end
    end
    if self._push_activity == nil then
       return
    end
    local now_time = os.time()
    if now_time - zstring.tonumber(self._last_time) >= 1 then
        self:pushNotificationActivity()
        self._last_time = now_time
    end
end

function OpenActiveLeftCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function OpenActiveLeftCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.activity.wonderful.active_left_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
    self._select = false
    self._last_time = nil
    self._push_activity = nil
end

function OpenActiveLeftCell:init(activity_type,index)
    self._activity_type = activity_type
    if index ~= nil and index < 8 then
	   self:onInit()
    end
    self:setContentSize(OpenActiveLeftCell.__size)
    return self
end

function OpenActiveLeftCell:onExit()
    self._select = false
    self._last_time = nil
    self._push_activity = nil
    cacher.freeRef(config_csb.cells.activity.wonderful.active_left_cell, self.roots[1])
end