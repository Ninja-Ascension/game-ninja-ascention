-- ----------------------------------------------------------------------------------------------------
-- 说明：
-------------------------------------------------------------------------------------------------------
PathGrowth = class("PathGrowthClass", Window)
    
function PathGrowth:ctor()
    self.super:ctor()
	app.load("client.l_digital.cells.activity.wonderful.sm_activity_path_growth_welfare_cell")
	app.load("client.l_digital.cells.activity.wonderful.sm_activity_path_growth_achieve_cell")
	app.load("client.l_digital.cells.activity.wonderful.sm_activity_path_growth_discount_cell")
	self.roots = {}
	self.loaded = false
	self.activityType = nil
	self._Text_32 = nil

	local function init_PathGrowth_terminal()

		local sm_activity_path_growt_open_terminal = {
		    _name = "sm_activity_path_growt_open",
		    _init = function (terminal) 
		        
		    end,
		    _inited = false,
		    _instance = self,
		    _state = 0,
		    _invoke = function(terminal, instance, params) 
		        -- local seven_day = SevenHappyManager:new()
		        -- seven_day:init()
		        -- fwin:open(seven_day, fwin._viewdialog)

		        --if nil == fwin:find("PathGrowthClass") then
		        --print("==========999999999999========")
		            fwin:open(PathGrowth:new():init(params), fwin._view)
		        --end 
		        return true
		    end,
		    _terminal = nil,
		    _terminals = nil
		}
	
		local sm_activity_path_growth_tab_terminal = {
            _name = "sm_activity_path_growth_tab",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:btnTabUpdate(params._datas._index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

       	local sm_activity_path_growth_closed_terminal = {
            _name = "sm_activity_path_growth_closed",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	fwin:close(fwin:find("PathGrowthClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local sm_activity_path_growth_change_level_terminal = {
            _name = "sm_activity_path_growth_change_level",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:onUpdateDraw(params._datas._level)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_activity_path_growth_tab_type_update_terminal = {
            _name = "sm_activity_path_growth_tab_type_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:updateTabBtnRedIcon(params[1], params[2])
            	instance:onUpdateDraw(params[1], params[2])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_activity_path_growth_update_terminal = {
            _name = "sm_activity_path_growth_update",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:updateLevelIcon(instance.level)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_activity_path_growth_tab_terminal)
        state_machine.add(sm_activity_path_growth_change_level_terminal)
        state_machine.add(sm_activity_path_growth_update_terminal)
        state_machine.add(sm_activity_path_growth_tab_type_update_terminal)
        state_machine.add(sm_activity_path_growt_open_terminal)
        state_machine.add(sm_activity_path_growth_closed_terminal)   
        state_machine.init()
    end
    
    init_PathGrowth_terminal()
end

function PathGrowth:onUpdate(dt)
    if self._Text_32 == nil or not self._end_time then
        return
    end

    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_l_digital then
	    local items = self.ListView_lv_lock:getItems()
	    local newitems = {}
		for i,v in pairs(items) do
			local Text_tm = ccui.Helper:seekWidgetByName(v, "Text_tm")
		 	local surplus_time = nil 
		 	if self._all_end_time[tonumber(v.level)] and self._all_end_time[tonumber(v.level)] ~= nil then
		 		surplus_time = self._all_end_time[tonumber(v.level)] - (os.time() + _ED.time_add_or_sub)
		 	end
		 	if Text_tm then
			 	if surplus_time ~= nil and surplus_time > 0 then
		    		Text_tm:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time))
			 	else
			 		Text_tm:setString("")
			 	end
			 end
		end
	end


    local surplus_time = self._end_time - (os.time() + _ED.time_add_or_sub)
    self._Text_32:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time))
    if surplus_time <= -1 then
    	local function callback( response )
    		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	    		self:updateLevelIcon()
	    	end
    	end
    	local req = {}
        req.actId = _ED.active_activity[142].activity_id
        req.actType = 142

        local reqStr = json.encode(req)
        protocol_command.activity_refresh.param_list = reqStr
        NetworkManager:register(protocol_command.activity_refresh.code, nil, nil, nil, cells, callback, false, nil)
        self._end_time = nil
    end
end

function PathGrowth:btnTabUpdate( index )
	local root = self.roots[1]
	for i = 1, 3 do
		local btn = ccui.Helper:seekWidgetByName(root, "Button_path_growth_tab_" .. i)
		btn:setLocalZOrder(4 - i)
		if index == i then
			btn:setHighlighted(true)
			btn:setLocalZOrder(4)
			self.panels[self.level][i]:setVisible(true)
		else
			btn:setHighlighted(false)
			self.panels[self.level][i]:setVisible(false)
		end
		self:updateTabBtnRedIcon(self.level, i)
	end
end

function PathGrowth:updateTabBtnRedIcon( level, _type )
	local function getActivityPathGrowthTabType(level, _type)
		local activity_info = _ED.active_activity[142]
		if activity_info == nil or tonumber(activity_info.activity_params.actStatus) == 0 then
			return false
		end

		local function isComplete( params )
			local isComplete = false
			for i,v in ipairs(params) do
				local _mType = dms.int(dms["activity_level_reward"], v.id, 2)
				if tonumber(v.st) == 1 and _mType == _type then
					isComplete = true
					break
				end
			end
			return isComplete
		end

	    for k, data in pairs(activity_info.activity_params.actData) do
	        if not data.st and tonumber(data.lev) == level and data.taskArr and isComplete(data.taskArr) then
	            return true
	        end
	    end
	    return false
	end
	local btn = ccui.Helper:seekWidgetByName(self.roots[1], "Button_path_growth_tab_" .. _type)

	if getActivityPathGrowthTabType(level, _type) == true then
		if btn._istips == nil or btn._istips == false then
			local ball = cc.Sprite:create("images/ui/bar/tips.png")
			ball:setAnchorPoint(cc.p(0.7, 0.7))
			ball:setPosition(cc.p(btn:getContentSize().width - 30, btn:getContentSize().height - 8))
			btn:addChild(ball)
			btn._nodeChild = ball
			btn._istips = true
		end
	else
		if btn._istips == true then
			btn:removeChild(btn._nodeChild, true)
			btn._nodeChild = nil
			btn._istips = false
		end
	end
end

function PathGrowth:onUpdateDraw(level, index)
	local root = self.roots[1]
	local activity = _ED.active_activity[self.activityType]
	self.level = level
	self.panels = {}

	self._end_time = self._all_end_time[level]

	for i, item in ipairs(self.ListView_lv_lock:getItems()) do
		local Button_growth_lv_n = ccui.Helper:seekWidgetByName(item, "Button_growth_lv_n")
		if Button_growth_lv_n then
			Button_growth_lv_n:setHighlighted(Button_growth_lv_n.level == level)
			if Button_growth_lv_n.canClick then
				Button_growth_lv_n:setTouchEnabled((Button_growth_lv_n.level ~= level))
			end
		end
	end
	if activity ~= nil then
		self._Text_32 = ccui.Helper:seekWidgetByName(root, "Text_path_growth_time_n")

		--成长福利
		local ListView_path_growth_tab = ccui.Helper:seekWidgetByName(root, "ListView_path_growth_tab")
		ListView_path_growth_tab:removeAllChildren(true)
		ListView_path_growth_tab:requestRefreshView()

		--成长任务
		local ListView_path_growth = ccui.Helper:seekWidgetByName(root, "ListView_path_growth")
		ListView_path_growth:removeAllChildren(true)
		ListView_path_growth:requestRefreshView()

		--成长折扣
		local ListView_path_discount_tab = ccui.Helper:seekWidgetByName(root, "ListView_path_discount_tab")
		ListView_path_discount_tab:removeAllChildren(true)
		ListView_path_discount_tab:requestRefreshView()

		local levelList = dms.searchs(dms["activity_level_reward"], activity_level_reward.level, tonumber(_ED.user_info.user_grade))
		
		for i,v in ipairs(self:sortRewordList(self.level)) do
			local _type = dms.int(dms["activity_level_reward"], v.id, 2)
			if _type == 1 then
				local cell = state_machine.excute("sm_activity_path_growth_welfare_cell", 0, {v, level})
				ListView_path_growth_tab:addChild(cell)
				ListView_path_growth_tab:setVisible(false)
			elseif _type == 2 then
				local cell = SmActivityPathGrowthAchieveCell:createCell()
 				cell:init({v, level})
 				ListView_path_growth:addChild(cell)
 				ListView_path_growth:setVisible(false)
			elseif _type == 3 then
				local cell = state_machine.excute("sm_activity_path_growth_discount_cell", 0, {v, level})
				ListView_path_discount_tab:addChild(cell)
				ListView_path_discount_tab:setVisible(false)
			end
		end
		self.panels[level] = {}
		table.insert(self.panels[level], ListView_path_growth_tab)
		table.insert(self.panels[level], ListView_path_growth)
		table.insert(self.panels[level], ListView_path_discount_tab)
	end

	self:btnTabUpdate(index or 1)
end

function PathGrowth:sortRewordList( level )
	local activity_params = _ED.active_activity[self.activityType].activity_params
	-- print("=======activity_params=========")
	-- debug.print_r(_ED.active_activity[142])
	local cur_arr = {}
	for k,v in pairs(activity_params.actData) do
		if tonumber(v.lev) == level and v.taskArr then
			table.add(cur_arr, v.taskArr)
		end
	end

	local sort_0 = {}
	local sort_1 = {}
	local sort_2 = {}
	for i,v in ipairs(cur_arr) do
		if tonumber(v.st) == 0 then
			table.insert(sort_0, v)
		elseif tonumber(v.st) == 1 then
			table.insert(sort_1, v)
		elseif tonumber(v.st) == 2 then
			table.insert(sort_2, v)
		end
	end
	local sort = {}
	table.add(sort, sort_1)
	table.add(sort, sort_0)
	table.add(sort, sort_2)
	return sort
end

function PathGrowth:updateLevelIcon(showLevel)
	local root = self.roots[1]
	local ListView_lv_lock = ccui.Helper:seekWidgetByName(root, "ListView_lv_lock")
	ListView_lv_lock:removeAllItems()
	local levels = zstring.split(dms.string(dms["activity_config"], 18, activity_config.param), ",")

	local csbNode1 = csb.createNode("activity/wonderful/path_growth_lv_cell_1.csb")
	local csbNode2 = csb.createNode("activity/wonderful/path_growth_lv_cell_2.csb")
	local csbNode3 = csb.createNode("activity/wonderful/path_growth_lv_cell_3.csb")
	local root1 = csbNode1:getChildByName("root")
	local root2 = csbNode2:getChildByName("root")
	local root3 = csbNode3:getChildByName("root")

	self.isShowActivity = false
	self._end_time = nil
	self.cur_arr = {}
	self.level = 10000
	self._all_end_time = {}

	ListView_lv_lock:removeAllChildren(true)
	ListView_lv_lock:addChild(root3:clone())

	local function isComplete( params )
		local isComplete = true
		for i,v in ipairs(params) do
			if tonumber(v.st) ~= 0 then
				isComplete = false
				break
			end
		end
		return isComplete
	end

	local function getArrData( level )
		local activity_params = _ED.active_activity[self.activityType].activity_params
		-- print("=======activity_params========")
		-- debug.print_r(activity_params)
		if activity_params.actData ~= nil then
			for k,v in pairs(activity_params.actData) do
				if tonumber(v.lev) == level then
					return v
				end
			end
		end
		return nil
	end
	
	-- El PRIMER escalon es el siguiente por defecto: el bucle solo fija
	-- `next_level` cuando el jugador YA tiene el nivel, asi que con un 0
	-- aqui el que aun no llega al 6 leia «lV0». `tonumber` porque
	-- `zstring.split` devuelve texto, y {""} si la fila 18 viene vacia.
	local next_level = tonumber(levels[1]) or 0
	local cur_index = 0
	local have_cur_index = nil
	local activity_over = false
	for i,v in ipairs(levels) do
		self.path_growth_lv_cell = root1:clone()
		if i%2 == 0 then
			self.path_growth_lv_cell = root2:clone()
		end
		self.path_growth_lv_cell.level = v
		local Text_growth_lv_n = ccui.Helper:seekWidgetByName(self.path_growth_lv_cell, "Text_growth_lv_n")
		local Image_growth_lv_br = ccui.Helper:seekWidgetByName(self.path_growth_lv_cell, "Image_growth_lv_br")
		local Image_growth_tm = ccui.Helper:seekWidgetByName(self.path_growth_lv_cell, "Image_growth_tm")
		local Text_br = ccui.Helper:seekWidgetByName(self.path_growth_lv_cell, "Text_br")
		local Text_tm = ccui.Helper:seekWidgetByName(self.path_growth_lv_cell, "Text_tm")
		local Image_ywc = ccui.Helper:seekWidgetByName(self.path_growth_lv_cell, "Image_ywc")
		local Image_ygq = ccui.Helper:seekWidgetByName(self.path_growth_lv_cell, "Image_ygq")
		local Image_red = ccui.Helper:seekWidgetByName(self.path_growth_lv_cell, "Image_red")

		local activity_params = _ED.active_activity[self.activityType].activity_params
		local arrData = getArrData(tonumber(v))
		local txt_time = dms.int(dms["activity_level_reward"], v, 4)
		-- Image_growth_lv_br:setVisible(true)
		-- Image_growth_tm:setVisible(true)

		-- 等级达到，未过期
		if arrData and not arrData.st and arrData.taskArr then
			self.isShowActivity = true
			local txt_intro = dms.searchs(dms["activity_level_reward"], activity_level_reward.level, v)
			self._all_end_time[tonumber(arrData.lev)] = tonumber(arrData.taskArr[1].et)
			--self._all_end_time[tonumber(arrData.lev)] = tonumber(txt_intro[1][4])
			self.cur_arr[tonumber(arrData.lev)] = arrData.taskArr
			if self.level > tonumber(arrData.lev) then
				self.level = tonumber(arrData.lev)
				have_cur_index = i
			end
		end

		--下一个开启等级
		if tonumber(_ED.user_info.user_grade) >= tonumber(v) then
			if levels[i + 1] then
				next_level = levels[i + 1]
				cur_index = i + 1
			else
				next_level = v
				cur_index = i
			end
		end

		--完成 过期
		local Button_growth_lv_n = ccui.Helper:seekWidgetByName(self.path_growth_lv_cell, "Button_growth_lv_n")
		Button_growth_lv_n.level = tonumber(v)
		if arrData and arrData.st and tonumber(arrData.st) == -1 then
			-- 已过期不显示当前界面
			if showLevel == tonumber(arrData.lev) then
				showLevel = nil
			end
			Image_ywc:setVisible(false)
			Image_ygq:setVisible(true)
			Image_red:setVisible(false)
			Button_growth_lv_n:setTouchEnabled(false)
			Button_growth_lv_n:setBright(true)
			Text_growth_lv_n:setVisible(false)
			Image_growth_tm:setVisible(false)
		elseif arrData and arrData.st and tonumber(arrData.st) == 1 then
			-- 已完成不显示当前界面
			if showLevel == tonumber(arrData.lev) then
				showLevel = nil
			end
			Image_ywc:setVisible(true)
			Image_ygq:setVisible(false)
			Button_growth_lv_n:setTouchEnabled(false)
			Button_growth_lv_n:setBright(true)
			Text_growth_lv_n:setVisible(false)
			Image_growth_tm:setVisible(false)
		elseif arrData and not arrData.st then
			Image_ywc:setVisible(false)
			Image_ygq:setVisible(false)
			Button_growth_lv_n:setTouchEnabled(true)
			Button_growth_lv_n:setBright(true)
			Text_growth_lv_n:setVisible(true)
			Image_red:setVisible(false)
			Image_growth_lv_br:setVisible(true)
			Image_growth_tm:setVisible(true)
			Button_growth_lv_n.canClick = true
			fwin:addTouchEventListener(Button_growth_lv_n, nil, 
			{
			    terminal_name = "sm_activity_path_growth_change_level", 
			    terminal_state = 0, 
			    _level = tonumber(arrData.lev),
			    _cell = self,          
			},
	    	nil,0)

	    	-- local function touchEventCallBack( sender, evenType )
	    	-- 	if evenType == ccui.TouchEventType.began then
	    	-- 		pushEffect(formatMusicFile("button", 1))
	    	-- 	elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
	    	-- 		local _datas = {}
	    	-- 		_datas._cell = self
	    	-- 		_datas._level = tonumber(arrData.lev)
	    	-- 		state_machine.excute("sm_activity_path_growth_change_level", 0, _datas)
	    	-- 	end
	    	-- end

	    	-- Button_growth_lv_n:addTouchEventListener(touchEventCallBack)

	    	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_path_growth_level_day_push",
	            _widget = Button_growth_lv_n,
	            _invoke = nil,
	            _level = tonumber(arrData.lev),
	            _interval = 0.5,})

			state_machine.excute("notification_center_update", 0, "push_notification_path_growth_level_day_push")
	    else
	    	Image_ywc:setVisible(false)
			Image_ygq:setVisible(false)
			Button_growth_lv_n:setTouchEnabled(false)
			Button_growth_lv_n:setBright(false)
			Image_red:setVisible(false)

		end

		if i == #levels then
			ccui.Helper:seekWidgetByName(self.path_growth_lv_cell, "Image_growth_lv_line"):setVisible(false)
			activity_over = (self.isShowActivity == false)
		end
		if ((__lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2) and app.configJson.ReleaseLanguage == "en") or __lua_project_id == __lua_project_l_naruto then
			Text_growth_lv_n:setString(_string_piece_info[6] .. v)
		else
			Text_growth_lv_n:setString(v .. _string_piece_info[6])
		end
		--local txt_intro = dms.int(dms["activity_level_reward"], v, 8)
		local txt_time = dms.int(dms["activity_level_reward"], v, 4)
		local txt_intro = dms.searchs(dms["activity_level_reward"], activity_level_reward.level, v)
		local word_info = dms.element(dms["word_mould"], tonumber(txt_intro[1][8]))
		local _dayTime = math.floor((txt_intro[1][4] / 1000) / 86400)
	    local _hourTime = math.floor((txt_intro[1][4] / 1000) % 86400 / 3600)
	    local _minutesTime = math.floor((txt_intro[1][4] / 1000) % 86400 % 3600 / 60)
	    local _secondsTime = math.ceil((txt_intro[1][4] / 1000) % 60)

		Text_br:setString(word_info[3])


		--Text_tm:setString(_hourTime..":".._minutesTime..":".._secondsTime)
		ListView_lv_lock:addChild(self.path_growth_lv_cell)
		self.ListView_lv_lock = ListView_lv_lock
	end

	local Panel_lock_no = ccui.Helper:seekWidgetByName(root, "Panel_lock_no")
	local Panel_tisi = ccui.Helper:seekWidgetByName(root, "Panel_tisi")
	local Text_lock_not_p = ccui.Helper:seekWidgetByName(root, "Text_lock_not_p")
	local Image_path_ts_1 = ccui.Helper:seekWidgetByName(root, "Image_path_ts_1")
	local Image_path_ts_2 = ccui.Helper:seekWidgetByName(root, "Image_path_ts_2")
	--当前等级是否有活动
	if self.isShowActivity then
		Panel_lock_no:setVisible(true)
		Panel_tisi:setVisible(false)
		Text_lock_not_p:setVisible(false)
		Image_path_ts_1:setVisible(false)
		Image_path_ts_2:setVisible(false)
		local level = showLevel or self.level
		self:onUpdateDraw(level)
	else
		Panel_lock_no:setVisible(false)
		Panel_tisi:setVisible(true)
		Image_path_ts_1:setVisible(true)
		Image_path_ts_2:setVisible(true)
		Text_lock_not_p:setVisible(true)
		Text_lock_not_p:setString(string.format(tipStringInfo_path_growth_tips[1], next_level))
		-- «Event End» SOLO cuando ya paso del ULTIMO escalon. Con las
		-- ventanas escalonadas del servidor, «ninguna viva» es el estado
		-- normal ENTRE escalon y escalon, y ahi el texto que toca es el
		-- de arriba («lV20»), que hasta ahora era inalcanzable porque
		-- `activity_over` es literalmente `self.isShowActivity == false`.
		if activity_over and tonumber(_ED.user_info.user_grade) >= (tonumber(next_level) or 0) then
			Image_path_ts_1:setVisible(false)
			Image_path_ts_2:setVisible(false)
			Text_lock_not_p:setVisible(true)
			Text_lock_not_p:setString(tipStringInfo_path_growth_tips[6])
		end
	end

	local index = have_cur_index or cur_index
	
	ListView_lv_lock:refreshView()
  	ListView_lv_lock:jumpToTop()

	listviewPositioningMoves(ListView_lv_lock, index, nil, false)

end

function PathGrowth:initDraw()
	local csbNode = csb.createNode("activity/wonderful/path_growth.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbNode)

	for i = 1, 3 do
		local btn = ccui.Helper:seekWidgetByName(root, "Button_path_growth_tab_" .. i)
		fwin:addTouchEventListener(btn, nil, 
		{
		    terminal_name = "sm_activity_path_growth_tab", 
		    terminal_state = 0, 
		    _index = i,
		    _cell = self
		},
    	nil,0)
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_three_close"), nil, 
    {
        terminal_name = "sm_activity_path_growth_closed", 
        terminal_state = 0, 
        cell = self,
    }, nil, 0)

	self:updateLevelIcon()
end

function PathGrowth:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
 	self:initDraw()
 	self:registerOnNoteUpdate(self, 1)
end

function PathGrowth:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	self.cacheListView = nil
	self._Text_32 = nil
	self:unregisterOnNoteUpdate(self)
end

function PathGrowth:onEnterTransitionFinish()
end

function PathGrowth:onExit()
	self.asyncIndex = 1
	self.cacheListView = nil
end

function PathGrowth:init( params )
	self.activityType = params
end

function PathGrowth:createCell()
	local cell = PathGrowth:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
	return cell
end