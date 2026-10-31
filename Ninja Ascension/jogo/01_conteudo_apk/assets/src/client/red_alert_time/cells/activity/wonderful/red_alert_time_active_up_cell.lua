--------------------------------------------------------------------------------------------------------------
--  说明：主页活动标签
--------------------------------------------------------------------------------------------------------------
RedAlertTimeActiveUpCell = class("RedAlertTimeActiveUpCellClass", Window)
RedAlertTimeActiveUpCell.__size = nil

--创建cell
local red_alert_time_active_up_create_cell_terminal = {
    _name = "red_alert_time_active_up_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activity_type = params[1]
        -- local index = params[2]
        local cell = RedAlertTimeActiveUpCell:new()
        cell:init(activity_type)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_active_up_create_cell_terminal)
state_machine.init()

function RedAlertTimeActiveUpCell:ctor()
	self.super:ctor()
	self.roots = {}

    self.__cdt = 1

    -- var 
    --活动类型
    self._activity_type = nil

    --推送刷新
    self._last_time = nil

    --活动推送
    self._push_activity = nil
	
	self.local_time = 0
    self._max_time = 0

    self._index = 0

    self.activity_time = 0

    self._have_reward = false
    self._have_legion = false
    self._start_time = 0
	
	app.load("client.red_alert_time.activity.wonderful.RedAlertTimeHeadquarters")
    app.load("client.red_alert_time.activity.wonderful.RedAlertTimeLegionOnlineReward")
	 -- Initialize red_alert_time_active_up_cell state machine.
    local function init_red_alert_time_active_up_cell_terminal()
		
  		--选中活动标签
  		local red_alert_time_active_up_cell_click_terminal = {
            _name = "red_alert_time_active_up_cell_click",
            _init = function (terminal)
                  
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)           
				local cell = params._datas.cell
				cell:openActiveInterface(tonumber(cell._activity_type))
                return true
            end,
            _terminal = nil,
            _terminals = nil
          }

          --选中活动标签
        local red_alert_time_active_up_cell_update_draw_terminal = {
            _name = "red_alert_time_active_up_cell_update_draw",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                params:updateDraw(tonumber(params._activity_type))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_active_up_cell_remove_terminal = {
            _name = "red_alert_time_active_up_cell_remove",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                cell:runAction(cc.Sequence:create(
                    cc.DelayTime:create(tonumber(params[2])),
                    cc.CallFunc:create(function ( sender )
                        fwin:addService({
                            callback = function ( params )
                                -- cell.m_times = 0
                                state_machine.excute("main_window_update_push",0,cell._activity_type)
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

        local red_alert_time_active_up_cell_update_push_terminal = {
            _name = "red_alert_time_active_up_cell_update_push",
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

        state_machine.add(red_alert_time_active_up_cell_update_draw_terminal)
        state_machine.add(red_alert_time_active_up_cell_click_terminal)
        state_machine.add(red_alert_time_active_up_cell_update_push_terminal)
  		state_machine.add(red_alert_time_active_up_cell_remove_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_active_up_cell create state machine.
    init_red_alert_time_active_up_cell_terminal()

end

function RedAlertTimeActiveUpCell:openActiveInterface(index)
	if index == 2 then
		state_machine.excute("wonderful_window_open", 0, index)
	elseif index == 48 then
		state_machine.excute("red_alert_time_headquarters_window_open", 0, nil)
    elseif index == 1000 then       -- 加入军团奖励
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            then
            state_machine.excute("legion_window_open", 0, nil)
        else
            state_machine.excute("legion_reward_window_window_open", 0, nil)
        end
    elseif index == 100 then      -- 七日狂欢   
        state_machine.excute("red_alert_time_seven_day_activity_window_open", 0, nil)
    elseif index == 47 then      
        state_machine.excute("wonderful_window_open", 0, index)
    elseif index == 128 then      -- 军团在线奖励
        state_machine.excute("red_alert_time_legion_online_reward_window_open", 0, {index})
	end
end
function RedAlertTimeActiveUpCell:updateDraw(params)
    if params ~= nil then
        self._activity_type = params
    end
    local root = self.roots[1]
	local Panel_home_act = ccui.Helper:seekWidgetByName(root,"Panel_home_act")
	Panel_home_act:removeAllChildren(true)
	local path = ""
	local name = ""
    self.local_time = 0
    self.activity_time = 0
    self._max_time = 0
    self._have_legion = false
	-- Button_home_act:removeBackGroundImage()
	if tonumber(self._activity_type) == 2 then
		path = "images/ui/effice/effect_home_button_4/effect_home_button_4.ExportJson"
		name = "effect_home_button_4"
	elseif tonumber(self._activity_type) == 48 then
		path = "images/ui/effice/effect_home_button_3/effect_home_button_3.ExportJson"
		name = "effect_home_button_3"
		self.local_time = (tonumber(_ED.activity_info["48"].activity_add_state)/1000)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time)))
    elseif tonumber(self._activity_type) == 1000 then       -- 加入军团奖励
		path = "images/ui/effice/effect_home_button_1/effect_home_button_1.ExportJson"
		name = "effect_home_button_1"
    elseif tonumber(self._activity_type) == 100 then       -- 七日狂欢
        path = "images/ui/effice/effect_home_button_5/effect_home_button_5.ExportJson"
        name = "effect_home_button_5"
	elseif tonumber(self._activity_type) == 47 then
		path = "images/ui/effice/effect_home_button_2/effect_home_button_2.ExportJson"
		name = "effect_home_button_2"
        local activity_info = _ED.activity_info["47"]
        local activity_data = activity_info.activity_data[1]
        local datas = zstring.split(activity_info.activity_add_state,",")
        self.activity_time = (tonumber(datas[3])/1000)+(os.time()-_ED.activity_info["47"].start_time)
        self._index = #activity_data
        for i=1, #activity_data do
            local count_data = zstring.split(activity_data[i].achieve_complete_count,"/")
            if self.activity_time/60 < tonumber(count_data[2]) then
                self._index = i
                self._have_reward = false
                break
            elseif self.activity_time/60 >= tonumber(count_data[2]) 
                and tonumber(activity_data[i].achieve_state) ~= 2 
                then
                self._have_reward = true
                break
            end
        end
        local count_data = zstring.split(activity_data[self._index].achieve_complete_count,"/")
        self.local_time = tonumber(count_data[2])*60 - self.activity_time
    elseif tonumber(self._activity_type) == 128 then    -- 军团在线奖励
        path = "images/ui/effice/effect_home_button_2/effect_home_button_2.ExportJson"
        name = "effect_home_button_2"
        local activity_info = _ED.activity_info[""..self._activity_type]
        local activity_add_state_arr = zstring.split(activity_info.activity_add_state, "|")
        local activity_add_state = zstring.split(activity_add_state_arr[1], ",")
        local reward_count = tonumber(activity_add_state[4])
        local reward_max_count = tonumber(activity_add_state[5])
        if reward_count < reward_max_count then
            local reward_info = nil
            for i = 2, #activity_add_state_arr do
                local info = zstring.split(activity_add_state_arr[i], ",")
                if tonumber(_ED.user_info.user_grade) >= tonumber(info[1]) and tonumber(_ED.user_info.user_grade) <= tonumber(info[2]) then
                    reward_info = info
                    break
                end
            end

            local last_online_time = 0
            if reward_count > 0 then
                last_online_time = tonumber(reward_info[2 + (reward_count - 1) * 2 + 1]) * 60
            end

            self._max_time = tonumber(reward_info[2 + reward_count * 2 + 1]) * 60
            self._max_time = self._max_time - last_online_time
            local have_legion = false
            if _ED.union.union_info == nil 
                or _ED.union.union_info == {} 
                or _ED.union.union_info.union_id == nil 
                or _ED.union.union_info.union_id == "" 
                or tonumber(_ED.union.union_info.union_id) == 0 
                then
                have_legion = false
            else
                have_legion = true
            end
            self._have_legion = have_legion

            self.activity_time = tonumber(activity_add_state[7]) / 1000
            self._start_time = tonumber(activity_add_state[6]) / 1000
            local online_time = self.activity_time
            if have_legion == true then
                online_time = online_time + os.time() + _ED.time_add_or_sub - self._start_time
            end
            self.local_time = self._max_time - online_time
        end
	end
	
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(path)
	local armature2 = ccs.Armature:create(name)
	armature2:getAnimation():playWithIndex(0)
	armature2:setPosition(Panel_home_act:getContentSize().width/2,Panel_home_act:getContentSize().height/2)
	Panel_home_act:addChild(armature2)
	local Text_home_act_time = ccui.Helper:seekWidgetByName(root,"Text_home_act_time") 
    local Image_home_act_time = ccui.Helper:seekWidgetByName(root,"Image_home_act_time")
	if self.local_time > 0 then
		Image_home_act_time:setVisible(true)
		Text_home_act_time:setString(getRedAlertTimeFormat(tonumber(self.local_time)))
	else
		Image_home_act_time:setVisible(false)
		Text_home_act_time:setString("")
	end
    self._text_time = Text_home_act_time
    self._image_time = Image_home_act_time
end

function RedAlertTimeActiveUpCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.wonderful.activity_home_button_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeActiveUpCell.__size == nil then
        RedAlertTimeActiveUpCell.__size = root:getContentSize()
    end
    -- local Image_push = ccui.Helper:seekWidgetByName(root,"Image_push")
    -- self._push_activity = Image_push
    -- local Image_new = ccui.Helper:seekWidgetByName(root,"Image_new")
    -- self._new_activity = Image_new
    --选择当前活动页
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_home_act"), nil, 
    {
        terminal_name = "red_alert_time_active_up_cell_click", 
        terminal_state = 0, 
        touch_black = true,
        cell = self, 
    }, nil, 1)

	self:updateDraw()
    self:pushNotificationActivity()
end

function RedAlertTimeActiveUpCell:pushNotificationActivity()
	local root = self.roots[1]
	local Panel_home_act = ccui.Helper:seekWidgetByName(root,"Panel_home_act")
	if tonumber(self._activity_type) == 48 then
		if self.local_time <= 0 then
			if Panel_home_act:getChildByTag(500) == nil then
				ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_can_receive/effect_can_receive.ExportJson")
				local armature = ccs.Armature:create("effect_can_receive")
				armature:getAnimation():playWithIndex(0)
				armature:setPosition(Panel_home_act:getContentSize().width/2,Panel_home_act:getContentSize().height/2)
				armature:setTag(500)
				Panel_home_act:addChild(armature,100)
			end
        else
            state_machine.excute("red_alert_time_active_up_cell_remove",0,{self,self.local_time})    
		end
	end
	if tonumber(self._activity_type) == 2 then
		if Panel_home_act:getChildByTag(500) == nil then
			local counts = zstring.split(_ED.activity_info[""..self._activity_type].activity_data[1][1].achieve_complete_count,"/")
			if tonumber(counts[1]) >= tonumber(counts[2]) and tonumber(_ED.activity_info[""..self._activity_type].activity_data[1][1].achieve_state)~= 2 then
				ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_can_receive/effect_can_receive.ExportJson")
				local armature = ccs.Armature:create("effect_can_receive")
				armature:getAnimation():playWithIndex(0)
				armature:setPosition(Panel_home_act:getContentSize().width/2,Panel_home_act:getContentSize().height/2)
				armature:setTag(500)
				Panel_home_act:addChild(armature,100)
			end
		end
	end
	if tonumber(self._activity_type) == 47 then 
		if Panel_home_act:getChildByTag(500) == nil then
			local datas = zstring.split(_ED.activity_info[""..self._activity_type].activity_add_state,",")
			local m_time = (tonumber(datas[3])/1000)+(os.time()-_ED.activity_info["47"].start_time)
            local isTimes = false
			if _ED.activity_info[""..self._activity_type].activity_data[1]~= nil then
				for j, w in pairs(_ED.activity_info[""..self._activity_type].activity_data[1]) do
					local m_datas = zstring.split(w.achieve_complete_count, "/")
                    if math.floor(m_time/60) < tonumber(m_datas[2]) and tonumber(w.achieve_state) <= 1 then
                        if isTimes == false then
                            state_machine.excute("red_alert_time_active_up_cell_remove",0,{self,tonumber(m_datas[2])*60-m_time})
                            isTimes = true
                        end
                    end
					if math.floor(m_time/60) >= tonumber(m_datas[2]) and tonumber(w.achieve_state) <= 1 then
						ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_can_receive/effect_can_receive.ExportJson")
						local armature = ccs.Armature:create("effect_can_receive")
						armature:getAnimation():playWithIndex(0)
						armature:setPosition(Panel_home_act:getContentSize().width/2,Panel_home_act:getContentSize().height/2)
						armature:setTag(500)
						Panel_home_act:addChild(armature,100)
						break
					end
				end
			end
		end
	end
    if tonumber(self._activity_type) == 1000 then
        if Panel_home_act:getChildByTag(500) == nil then
            if funOpenDrawTip(152, false) == false and _ED.union_first_join_reward == 0 then
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_can_receive/effect_can_receive.ExportJson")
                local armature = ccs.Armature:create("effect_can_receive")
                armature:getAnimation():playWithIndex(0)
                armature:setPosition(Panel_home_act:getContentSize().width/2,Panel_home_act:getContentSize().height/2)
                armature:setTag(500)
                Panel_home_act:addChild(armature,100)
            end
        end
    end
    if tonumber(self._activity_type) == 100 then
        if Panel_home_act:getChildByTag(500) == nil then
            if getSevenDayActivityTotalTip() == true then
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_can_receive/effect_can_receive.ExportJson")
                local armature = ccs.Armature:create("effect_can_receive")
                armature:getAnimation():playWithIndex(0)
                armature:setPosition(Panel_home_act:getContentSize().width/2,Panel_home_act:getContentSize().height/2)
                armature:setTag(500)
                Panel_home_act:addChild(armature,100)
            end
        end
    end
    if tonumber(self._activity_type) == 128 then 
        if Panel_home_act:getChildByTag(500) == nil then
            if self._have_legion == true and self.local_time <= 0 then
                ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_can_receive/effect_can_receive.ExportJson")
                local armature = ccs.Armature:create("effect_can_receive")
                armature:getAnimation():playWithIndex(0)
                armature:setPosition(Panel_home_act:getContentSize().width/2,Panel_home_act:getContentSize().height/2)
                armature:setTag(500)
                Panel_home_act:addChild(armature,100)
            end
        end
    end
end

function RedAlertTimeActiveUpCell:onUpdate(dt)
    if self._text_time ~= nil then
    	if tonumber(self._activity_type) == 48 or tonumber(self._activity_type) == 47 then
    		if self.local_time > 0 then
                self.activity_time = self.activity_time + dt
    			self.local_time = self.local_time - dt
    			self._text_time:setString(getRedAlertTimeFormat(tonumber(self.local_time)))
            else
                self._text_time:setString("")    
                self._image_time:setVisible(false)
    		end
            if tonumber(self._activity_type) == 47 then
                local activity_data = _ED.activity_info["47"].activity_data[1]
                if self._have_reward == true then
                    self._text_time:setString("")    
                    self._image_time:setVisible(false)   
                else
                    if self.local_time <= 0 and self._index <= #activity_data then
                        state_machine.excute("red_alert_time_active_up_cell_update_draw",0,self)
                        self._index = self._index + 1
                        if self._index > #activity_data then
                            self._index = #activity_data
                        end
                        local count_data = zstring.split(activity_data[self._index].achieve_complete_count,"/")
                        self.local_time = tonumber(count_data[2])*60 - self.activity_time
                    else
                        if self._index > #activity_data then
                            self._text_time:setString("")    
                            self._image_time:setVisible(false)   
                        end
                    end
                end
            end 
    	end
        if tonumber(self._activity_type) == 128 then
            if self._have_legion ~= true then
                return
            end
            if self.local_time > 0 then
                local activity_info = _ED.activity_info[""..self._activity_type]
                local online_time = self.activity_time + os.time() + _ED.time_add_or_sub - self._start_time
                self.local_time = self._max_time - online_time
                self._text_time:setString(getRedAlertTimeFormat(tonumber(self.local_time)))
                if self.local_time <= 0 then
                    self.local_time = 0
                    self:updateDraw()
                    self:pushNotificationActivity()
                end
            end
        end
    end
end

function RedAlertTimeActiveUpCell:clearUIInfo()
	 local root = self.roots[1]
	 local Panel_home_act = ccui.Helper:seekWidgetByName(root,"Panel_home_act")
	 local Text_home_act_time = ccui.Helper:seekWidgetByName(root,"Text_home_act_time") 
	 local Image_home_act_time = ccui.Helper:seekWidgetByName(root,"Image_home_act_time")
	 if Panel_home_act ~= nil then
		Panel_home_act:removeAllChildren(true)
		Text_home_act_time:setString("")
		Image_home_act_time:setVisible(false)
	 end
end

function RedAlertTimeActiveUpCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end


function RedAlertTimeActiveUpCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function RedAlertTimeActiveUpCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.wonderful.activity_home_button_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeActiveUpCell:init(activity_type)
    self._activity_type = activity_type
    -- if index ~= nil and index < 8 then
	   self:onInit()
    -- end
    self:setContentSize(RedAlertTimeActiveUpCell.__size)
    return self
end

function RedAlertTimeActiveUpCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.wonderful.activity_home_button_cell, self.roots[1])
end