--------------------------------------------------------------------------------------------------------------
--  说明：单个活动标签
--------------------------------------------------------------------------------------------------------------
RedAlertTimeActiveLeftCell = class("RedAlertTimeActiveLeftCellClass", Window)
RedAlertTimeActiveLeftCell.__size = nil

--创建cell
local red_alert_time_active_left_create_cell_terminal = {
    _name = "red_alert_time_active_left_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activity_type = params[1]
        local index = params[2]
        local cell = RedAlertTimeActiveLeftCell:new()
        cell:init(activity_type,index)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_active_left_create_cell_terminal)
state_machine.init()

function RedAlertTimeActiveLeftCell:ctor()
	self.super:ctor()
	self.roots = {}

    -- var 
    --活动类型
    self._activity_type = nil
    --是否选中
    self._select = false

    --推送刷新
    self._last_time = os.time()

    --活动推送
    self._push_activity = nil

    self._Image_new = nil

    self.m_times = -100
	 -- Initialize red_alert_time_active_left_cell state machine.
    local function init_red_alert_time_active_left_cell_terminal()
		
  		--选中活动标签
  		local red_alert_time_active_left_cell_click_terminal = {
            _name = "red_alert_time_active_left_cell_click",
            _init = function (terminal)
                  
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
                local cell = params._datas.cell
				if cell._select == true then
					cell:setSelect()
					return
				end
                
                -- if activity ~= nil then 
                    -- activity._new_activity = false
                    -- cell._new_activity:setVisible(false)
                    -- cc.UserDefault:getInstance():setStringForKey(getKey("push_new_activity"..activity.activity_type), activity.activity_id)
                -- end
                if tonumber(cell._activity_type) ~= 16 
                	and nil ~= _ED.system_time
                	then
	                local activity = _ED.activity_info[""..cell._activity_type]
	                if nil ~= activity then
						local server_time_month = os.date("%m", zstring.exchangeFrom(_ED.system_time + (os.time() - _ED.native_time)))
						local server_time_day = os.date("%d", zstring.exchangeFrom(_ED.system_time + (os.time() - _ED.native_time)))
						if tonumber(activity.activity_type) == 4 		-- 扫荡关卡
						or tonumber(activity.activity_type) == 8  	  	
						or tonumber(activity.activity_type) == 17  	
						or tonumber(activity.activity_type) == 54 
						or tonumber(activity.activity_type) == 55
                        or tonumber(activity.activity_type) == 108
                        or tonumber(activity.activity_type) == 109
						or tonumber(activity.activity_type) == 56 
						or tonumber(activity.activity_type) == 60
						or tonumber(activity.activity_type) == 61 
						or tonumber(activity.activity_type) == 62 		-- 竞技胜利
						or tonumber(activity.activity_type) == 63 		-- 全服冲V
						or tonumber(activity.activity_type) == 64 
						or tonumber(activity.activity_type) == 65 
						or tonumber(activity.activity_type) == 68 	
						or tonumber(activity.activity_type) == 69 		-- 军团发展
						or tonumber(activity.activity_type) == 70 
						or tonumber(activity.activity_type) == 72 		-- 采集福利
						or tonumber(activity.activity_type) == 76 
						or tonumber(activity.activity_type) == 77 
                        or tonumber(activity.activity_type) == 106 
                        or tonumber(activity.activity_type) == 107
						or tonumber(activity.activity_type) == 79 		-- 7天充值
						or tonumber(activity.activity_type) == 41 		-- 首冲返利
                        or tonumber(activity.activity_type) == 80       -- 充值福利
                        or tonumber(activity.activity_type) == 32          --- 每日单笔
                        or tonumber(activity.activity_type) == 12          --- 累计充值
                        or tonumber(activity.activity_type) == 84       -- 全民狂欢
                        or tonumber(activity.activity_type) == 85       -- 科技飙升
                        or tonumber(activity.activity_type) == 87       -- 疯狂矿工
                        or tonumber(activity.activity_type) == 88       -- 活动达人
                        or tonumber(activity.activity_type) == 89       -- 连续小充
                        or tonumber(activity.activity_type) == 91       -- 火线支援
                        or tonumber(activity.activity_type) == 94       -- 将领进化
                        or tonumber(activity.activity_type) == 110     -- 加速礼包
                        or tonumber(activity.activity_type) == 111       -- 坦克兑换
                        or tonumber(activity.activity_type) == 112       -- 开服礼包
                        or tonumber(activity.activity_type) == 113
                        or tonumber(activity.activity_type) == 114
                        or tonumber(activity.activity_type) == 115
                        or tonumber(activity.activity_type) == 116
                        or tonumber(activity.activity_type) == 120      -- 充值排行
                        or tonumber(activity.activity_type) == 121           -- 英雄招募
                        or tonumber(activity.activity_type) == 122           -- 幸运抽奖
                        or tonumber(activity.activity_type) == 123      -- 消费排行
                        or tonumber(activity.activity_type) == 124
						then
							local saveActiveTime_month = os.date("%m", zstring.exchangeFrom(zstring.tonumber(cc.UserDefault:getInstance():getStringForKey(getKey("activity_id_"..activity.activity_type)))))
							local saveActiveTime_day = os.date("%d", zstring.exchangeFrom(zstring.tonumber(cc.UserDefault:getInstance():getStringForKey(getKey("activity_id_"..activity.activity_type)))))
							if tonumber(server_time_month) > tonumber(saveActiveTime_month) or tonumber(server_time_day) > tonumber(saveActiveTime_day) then
								cc.UserDefault:getInstance():setStringForKey(getKey("activity_id_"..activity.activity_type), _ED.system_time + (os.time() - _ED.native_time))
								cc.UserDefault:getInstance():flush()
								cell._push_activity:setVisible(false)
							end
						end
					end
				end
                state_machine.excute("wonderful_set_un_select",0,"")
                cell._select = true
                local activity_type = tonumber(cell._activity_type)
                state_machine.excute("wonderful_show_activity_by_type",0,{activity_type})
                state_machine.excute("wonderful_update_by",0,{activity_type})
				cell:setSelect(activity_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
          }

          --选中活动标签
        local red_alert_time_active_left_cell_update_draw_terminal = {
            _name = "red_alert_time_active_left_cell_update_draw",
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

          --
        local red_alert_time_active_left_cell_remove_terminal = {
            _name = "red_alert_time_active_left_cell_remove",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params[1]
                cell:runAction(cc.Sequence:create(
					cc.DelayTime:create(cell.m_times),
					cc.CallFunc:create(function ( sender )
						fwin:addService({
			                callback = function ( params )
			                	cell.m_times = 0
								state_machine.excute("red_alert_time_wonderful_update_first",0,cell._activity_type)
			                end,
			                delay = 0.1,
			                params = nil
			            })
					end)
				))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_active_left_cell_update_push_terminal = {
            _name = "red_alert_time_active_left_cell_update_push",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	params:pushNotificationActivity()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_active_left_cell_update_draw_terminal)
  		state_machine.add(red_alert_time_active_left_cell_click_terminal)
  		state_machine.add(red_alert_time_active_left_cell_remove_terminal)
  		state_machine.add(red_alert_time_active_left_cell_update_push_terminal)

        state_machine.init()
    end 
    -- call func red_alert_time_active_left_cell create state machine.
    init_red_alert_time_active_left_cell_terminal()

end

function RedAlertTimeActiveLeftCell:setSelect(activity_type)
    local root = self.roots[1]
    local Button_activity_tab = ccui.Helper:seekWidgetByName(root,"Button_activity_tab")
	if Button_activity_tab == nil then
		return
	end
	Button_activity_tab:setHighlighted(false)
    -- local Text_active_name = ccui.Helper:seekWidgetByName(root,"Text_active_name")
    -- if Image_light ~= nil then
        if self._select == true then
            -- Text_active_name:setColor(cc.c3b(255,234,198))
			Button_activity_tab:setHighlighted(true)
        else
            -- Text_active_name:setColor(cc.c3b(144,101,65))
			Button_activity_tab:setHighlighted(false)
        end
        -- Image_light:setVisible(self._select)
    -- end
end

function RedAlertTimeActiveLeftCell:updateDraw(index)
    if index ~= nil then
        self._activity_type = index
    end
    local root = self.roots[1]
	local Button_activity_tab = ccui.Helper:seekWidgetByName(root,"Button_activity_tab")
    local buttonText = ""
    if _ED.activity_info[""..self._activity_type] ~= nil then
        buttonText = _ED.activity_info[""..self._activity_type].activity_title
    else
        buttonText = dms.string(dms["activity_param"],tonumber(self._activity_type),activity_param.name)
    end
	local Text_activity_tab = ccui.Helper:seekWidgetByName(root,"Text_activity_tab")
	if Text_activity_tab ~= nil then
		Text_activity_tab:setString(zstring.exchangeFrom(buttonText))
	else
		Button_activity_tab:setTitleText(zstring.exchangeFrom(buttonText))
	end
	if _ED.activity_info[""..self._activity_type]~= nil and tonumber(_ED.activity_info[""..self._activity_type].activity_add_state) ~= -1 then
		local timesData = zstring.split(_ED.activity_info[""..self._activity_type].activity_add_state, ",")
		if tonumber(self._activity_type) >= 112
            and tonumber(self._activity_type) <= 116
            then
            self.m_times = ((tonumber(timesData[1])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
            state_machine.excute("red_alert_time_active_left_cell_remove",0,{self})
        else
            self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
    		state_machine.excute("red_alert_time_active_left_cell_remove",0,{self})
        end
	end
end

function RedAlertTimeActiveLeftCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.activity_tab_button_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeActiveLeftCell.__size == nil then
        RedAlertTimeActiveLeftCell.__size = root:getContentSize()
    end
	
    --选择当前活动页
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_activity_tab"), nil, 
    {
        terminal_name = "red_alert_time_active_left_cell_click", 
        terminal_state = 0, 
        cell = self, 
    }, nil, 3)    
	
	self._push_activity = ccui.Helper:seekWidgetByName(root, "Image_act_push")
    self._Image_new = ccui.Helper:seekWidgetByName(root, "Image_new")
	
	self:updateDraw()
	self:pushNotificationActivity()
end

function RedAlertTimeActiveLeftCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function RedAlertTimeActiveLeftCell:pushNotificationActivity()
	self._push_activity:setVisible(false)
    if self._Image_new ~= nil then
        self._Image_new:setVisible(false)
        if tonumber(self._activity_type) ~= 45          --- 充值红包
            and tonumber(self._activity_type) ~= 47          --- 在线奖励
            then
            if _ED.activity_info[self._activity_type] ~= nil then
                local currentTime = _ED.system_time + (os.time() - _ED.native_time)
                local addStateInfo = zstring.split(_ED.activity_info[self._activity_type].activity_add_state, ",")
                local start_time = 0
                if tonumber(self._activity_type) == 8 then
                    start_time = zstring.tonumber(addStateInfo[2])/1000
                else
                    start_time = zstring.tonumber(addStateInfo[1])/1000
                end
                if currentTime - start_time <= 24 * 3600 then
                    self._Image_new:setVisible(true) 
                end
            end
        end
    end

    if getPushActivityType(self._activity_type) == true then
        self._push_activity:setVisible(true)
    end
end

-- function RedAlertTimeActiveLeftCell:onUpdate()
--     if self._push_activity == nil then
--        return
--     end
--     local now_time = os.time()
--     if now_time - zstring.tonumber(self._last_time) >= 1 then
--         self:pushNotificationActivity()
--         self._last_time = now_time
--     end
-- end

function RedAlertTimeActiveLeftCell:clearUIInfo()
	local root = self.roots[1]
	local Button_activity_tab = ccui.Helper:seekWidgetByName(root,"Button_activity_tab")
	local Image_act_push = ccui.Helper:seekWidgetByName(root, "Image_act_push")
	if Button_activity_tab~= nil then
		Button_activity_tab:setTitleText("")
		Image_act_push:setVisible(false)
	end
    self._select = false
    self.m_times = -100
end

function RedAlertTimeActiveLeftCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function RedAlertTimeActiveLeftCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.activity_tab_button_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeActiveLeftCell:init(activity_type,index)
    self._activity_type = activity_type
    -- if index ~= nil and index < 8 then
	   self:onInit()
    -- end
    self:setContentSize(RedAlertTimeActiveLeftCell.__size)
    return self
end

function RedAlertTimeActiveLeftCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.activity_tab_button_cell, self.roots[1])
end