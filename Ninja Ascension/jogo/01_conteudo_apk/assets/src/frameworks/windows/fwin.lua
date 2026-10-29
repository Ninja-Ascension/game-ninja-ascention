fwin = fwin or {
		_instance=0,
		_x = 0,
		_y = 0,
		_width = app.designSize.width, 
		_height = app.designSize.height,
		_scale = app.scaleFactor,
		_scene = nil,
		_framewindow = nil,
		_layer = nil,
		_list = {},
		_frameview = {_layer = nil, _z = 0},
		_background = {_layer = nil, _z = 5000},
		_view = {_layer = nil, _z = 10000},
		_dview = {_layer = nil, _z = 15000},
		_viewdialog = {_layer = nil, _z = 20000},
		_taskbar = {_layer = nil, _z = 30000},
		_ui = {_layer = nil, _z = 50000},
		_windows = {_layer = nil, _z = 60000},
		_dialog = {_layer = nil, _z = 70000},
		_notification = {_layer = nil, _z = 80000},
		_screen = {_layer = nil, _z = 90000},
		_system = {_layer = nil, _z = 100000},
		_display_log = {_layer = nil, _z = 110000},
		_border = {_layer = nil, _z = 1000000},
		_events = {}, -- {_name = "", _window = nil, _view = nil, _state = 0}
		_services = {},
		_asyncImg = "",
		_lock_touch = false,
		_lock_touch_count = 0,
		_close_touch_end_event = false,
		_touching = false,
		_bg_music_index = 1,
		_touch_wait_time = 0,
		_stop_music = false,
		_bg_music_indexs = {}
	}

function fwin:graphics(_mode)
	if fwin._scene ~= nil then
		fwin._scene:removeAllChildren(true)
	end
	local scene = cc.Scene:create()
	fwin._scene = scene
	
	if cc.Director:getInstance():getRunningScene() then
		cc.Director:getInstance():replaceScene(scene)
	else
		cc.Director:getInstance():runWithScene(scene)
	end

	fwin._framewindow:addChild(fwin._layer)
	if fwin._border._layer:getParent() ~= nil then
		fwin._border._layer:removeFromParent(false)
	end
	fwin._layer:addChild(fwin._border._layer, fwin._border._z)
	
	scene:addChild(fwin._framewindow)

	-- -- 设置屏幕的裁剪区域
	-- local screen = ccui.Layout:create()
	-- local scaleFactor = app.scaleFactor
	-- local screenSize = app.screenSize
	-- local winSize = app.winSize
	-- local designSize = app.designSize
	-- screen:setContentSize(cc.size(designSize.width / scaleFactor, designSize.height / scaleFactor))
	-- screen:setPositionX(fwin._x)
	-- screen:setClippingEnabled(true)
	-- scene:addChild(screen)

	if app.debug._isOpen == true then
		if debug.view ~= nil and debug.view.getParent ~= nil then
			if debug.view:getParent() ~= nil then
				debug.view:removeFromParent(true)
			end
			scene:addChild(debug.view)
		end
	end

	if NetworkManager ~= nil and NetworkManager.updateRequestQueue ~= nil then
		fwin._framewindow:scheduleUpdateWithPriorityLua(NetworkManager.updateRequestQueue, 1)
	end
	if app.notification_center ~= nil and app.notification_center.updateNotificationCenter ~= nil then
		-- fwin._layer:scheduleUpdateWithPriorityLua(app.notification_center.updateNotificationCenter, 1)
		fwin._layer:scheduleUpdateWithPriorityLua(fwin.updateLua, 1)
	end
end

function fwin:restartSchedules()
	if NetworkManager ~= nil and NetworkManager.updateRequestQueue ~= nil then
		fwin._framewindow:scheduleUpdateWithPriorityLua(NetworkManager.updateRequestQueue, 1)
	end
	if app.notification_center ~= nil and app.notification_center.updateNotificationCenter ~= nil then
		-- fwin._layer:scheduleUpdateWithPriorityLua(app.notification_center.updateNotificationCenter, 1)
		fwin._layer:scheduleUpdateWithPriorityLua(fwin.updateLua, 1)
	end
end

function fwin:resetTouchLock()
	fwin._lock_touch = false
	fwin._lock_touch_count = 0
end

function fwin.updateLua(dt)
	if fwin._lock_touch == true then
		fwin._lock_touch_count = fwin._lock_touch_count + dt
		if fwin._lock_touch_count > 0.013 then
			fwin._lock_touch = false
			fwin._lock_touch_count = 0
		end
	end
	
	if app.notification_center ~= nil 
		and app.notification_center.running == true 
		and app.notification_center.updateNotificationCenter ~= nil 
		then
		app.notification_center.updateNotificationCenter(dt)
		app.notification_center.running = false
	end

	if false == fwin._stop_music then
		if fwin._current_music ~= nil and fwin._last_music ~= fwin._current_music then
			playBgm(formatMusicFile("background", fwin._current_music))
			table.insert(fwin._bg_music_indexs, fwin._current_music)
			fwin._last_music = fwin._current_music
			fwin._current_music = nil
		end
	end

	local nCount = 0
	while #fwin._services > nCount do
		local service = fwin._services[nCount + 1] -- table.remove(fwin._services, nCount + 1)
		if nil ~= service then
			if service.delay == nil or service.delay <= 0 then
				table.remove(fwin._services, nCount + 1)
				service.callback(service.params, service)
			else
				service.delay = service.delay - dt
				nCount = nCount + 1
			end
		else
			break
		end
	end

  --   if fwin._printLeaks == true then
		-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
		-- cc.Ref:printLeaks()
		-- fwin._printLeaks = false
  --   end

  --   if fwin._free_cache == true then
  --   	fwin._free_cache = false
  --   	fwin.freeMemeryPool()
  --   end

	-- print("----------------------------------------------------------------------------------")
	-- local cachedTextureInfo = cc.Director:getInstance():getTextureCache():getCachedTextureInfo()
	-- local cachedTextureInfos = zstring.split(cachedTextureInfo, "\n")
	-- for i, v in pairs(cachedTextureInfos) do
	-- 	print(v)
	-- end
	-- print("----------------------------------------------------------------------------------")
	fwin._touch_wait_time = fwin._touch_wait_time + dt

	-- if fwin._touch_selecter ~= nil then
	-- 	local sender = fwin._touch_selecter
	-- 	fwin._touch_selecter = nil
	-- 	if sender._datas ~= nil then
	-- 		if sender._datas.func_string ~= nil then
	-- 			local func = assert(loadstring(sender._datas.func_string))
	-- 			func()
	-- 		end
	-- 		if sender._datas.terminal_name ~= nil then
	-- 			state_machine.excute(sender._datas.terminal_name, sender._datas.terminal_state or 0, sender)
	-- 		end
	-- 	end
	-- 	if sender._touch ~= nil then
	-- 		if sender._touch == fwin.close then
	-- 			fwin:close(sender._windows)
	-- 		else
	-- 			sender._touch(sender, ccui.TouchEventType.ended)
	-- 		end
	-- 	end
	-- 	sender._call = nil
	-- end
end

function fwin:init()
	fwin._list = {}
	if fwin._framewindow ~= nil then
		fwin._framewindow:removeFromParent(true)
	end
	fwin._framewindow = ccui.Layout:create()
	fwin._layer = ccui.Layout:create()
	-- fwin._layer:setClippingEnabled(true)
	
	if fwin._border._layer == nil then
		fwin._border._layer = cc.Layer:create()
		fwin._border._layer:retain()
	end
	
	local scaleFactor = app.scaleFactor
	local screenSize = app.screenSize
	local winSize = app.winSize
	local designSize = app.designSize
	fwin._width = designSize.width
	fwin._height = designSize.height
	-- fwin._layer:setContentSize(cc.size(designSize.width / scaleFactor, designSize.height / scaleFactor))
	fwin._framewindow:setContentSize(cc.size(designSize.width / scaleFactor, designSize.height / scaleFactor))
	fwin._layer:setContentSize(cc.size(designSize.width, designSize.height))
	fwin._framewindow:setAnchorPoint(cc.p(0, 0))
	fwin._layer:setAnchorPoint(cc.p(0, 0))
	-- fwin._framewindow:setScale(app.scaleFactor)
	fwin._layer:setScale(app.scaleFactor)
	if app.ResolutionPolicy == "SHOW_ALL" then
	elseif app.ResolutionPolicy == "EXACT_FIT" then
		fwin._x = (screenSize.width - winSize.width) / 2 / scaleFactor
		fwin._y = (screenSize.height - winSize.height) / 2 / scaleFactor
		fwin._layer:setPosition(cc.p(fwin._x, fwin._y))
		-- fwin._framewindow:setScale(app.scaleFactor)
		win._layer:setScale(app.scaleFactor)
	else
		if fwin._width > fwin._height then
			fwin._y = (screenSize.height - winSize.height) / 2 / scaleFactor
			fwin._layer:setPositionY(fwin._y * scaleFactor)
		else
			fwin._x = (screenSize.width - winSize.width) / 2 / scaleFactor
			fwin._layer:setPositionX(fwin._x * scaleFactor)
		end
		-- fwin._y = (screenSize.height - winSize.height) / 2 / scaleFactor
		-- fwin._layer:setPosition(cc.p(fwin._x, fwin._y))
	end
	
	fwin._list = {}
	fwin:createContainer(fwin._frameview, designSize)
	fwin:createContainer(fwin._background, designSize)
	fwin:createContainer(fwin._view, designSize)
	fwin:createContainer(fwin._dview, designSize)
	fwin:createContainer(fwin._viewdialog, designSize)
	fwin:createContainer(fwin._taskbar, designSize)
	fwin:createContainer(fwin._ui, designSize)
	fwin:createContainer(fwin._windows, designSize)
	fwin:createContainer(fwin._dialog, designSize)
	fwin:createContainer(fwin._notification, designSize)
	fwin:createContainer(fwin._screen, designSize)
	fwin:createContainer(fwin._system, designSize)
	fwin:createContainer(fwin._display_log, designSize)

	if app.debug._isOpen == true then
		if debug.view ~= nil and debug.view.getParent ~= nil and debug.view:getParent() == nil then
			-- fwin:open(debug.view, fwin._display_log)
		end

		fwin._x = (screenSize.width - winSize.width) / scaleFactor
		fwin._y = (screenSize.height - winSize.height) / 2 / scaleFactor
		--fwin._layer:setPosition(cc.p(fwin._x, fwin._y))
		fwin._layer:setPosition(cc.p(0, fwin._y))
		if debug.view ~= nil then
		   	debug.view:setPosition(cc.p(winSize.width, fwin._y))
		end
	end
end

function fwin:create()
	fwin._framewindow = nil
	fwin._scene = nil
	fwin:init()
end

function fwin:__show(_view)
	if _view ~= nil and _view._layer ~= nil then
		_view._layer:setVisible(true)
		_view._layer:resume()
	end
end

function fwin:__hide(_view)
	if _view ~= nil and _view._layer ~= nil then
		_view._layer:setVisible(false)
		_view._layer:pause()
	end
end

function fwin:convertToWorldSpace(node, position)
	local scaleFactor = app.scaleFactor
	position.x = position.x - fwin._x
	local pos = node:convertToWorldSpace(position)
	-- pos.x = pos.x / scaleFactor  - fwin._x * scaleFactor
	-- pos.y = pos.y / scaleFactor - fwin._y * scaleFactor
	return pos
end

function fwin:convertToWorldSpaceAR(node, position)
	local scaleFactor = app.scaleFactor
	position.x = position.x - fwin._x
	local pos = node:convertToWorldSpaceAR(position)
	-- pos.x = pos.x / scaleFactor  - fwin._x * scaleFactor
	-- pos.y = pos.y / scaleFactor - fwin._y * scaleFactor
	return pos
end

function fwin:createContainer(_windows, _screenSize)
	_windows._layer = ccui.Layout:create()
	if nil ~= _screenSize then
		_windows._layer:setContentSize(_screenSize)
	end
	
	fwin._layer:addChild(_windows._layer, _windows._z)
end

function fwin:reset(_mode, state_name, callfunc)
	fwin:removeAll()

	fwin:freeAllMemeryPool()
	
	-- audioUtilUncacheAll()
	
	-- if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
	-- 	-- code
	-- else
	-- 	-- -- fwin:destroy(fwin._framewindow)
	-- 	fwin:init()
	-- 	fwin:graphics(_mode)
	-- end

 --	-- cc.Ref:printLeaks()
	-- -- fwin._printLeaks = true
	
	if cc.Director:getInstance().restartDirectorExt ~= nil and (state_name ~= nil or callfunc ~= nil) then
		fwin._isRestartDirector = true
		fwin._state_name = state_name
		fwin._callfunc = callfunc
		cc.Director:getInstance():restartDirectorExt(function(target)
			fwin._isRestartDirector = false
			fwin:restartSchedules()
	  --	   for k, v in pairs(fwin._list) do
			-- 	if v ~=nil and v.getParent ~= nil and v.onNoteUpdate ~= nil then
	  --	   		v:scheduleUpdateWithPriorityLua(v.onNoteUpdate, 0)
			-- 	end
			-- end
			if fwin._state_name ~= nil then
				local __state_name = fwin._state_name
				fwin._state_name = nil
				state_machine.excute(__state_name)
			end
			if fwin._callfunc ~= nil then
				local __callfunc = fwin._callfunc
				fwin._callfunc = nil
				__callfunc()
			end
		end)
	else
		if state_name ~= nil then
			fwin._state_name = nil
			state_machine.excute(state_name)
		end
		if callfunc ~= nil then
			fwin._callfunc = nil
			callfunc()
		end
	end
	fwin._bg_music_indexs = {}
	fwin._last_music = -1
	fwin._current_music = nil
end

function fwin:addBorder(_borderLayer)
	if _borderLayer ~= nil then
		fwin._border._layer:addChild(_borderLayer)
	end
	-- if app.ResolutionPolicy == "SHOW_ALL" then
 --	elseif app.ResolutionPolicy == "EXACT_FIT" then
	--	 if fwin._border._layer == nil then
	--		 fwin._border._layer = cc.Layer:create()
	--		 fwin._border._layer:retain()
	--	 end
	--	 if _borderLayer == nil then
	--		 local halfHeight = (app.screenSize.height - app.winSize.height) / 2 / app.scaleFactor
	--		 local borderSize = cc.size(app.designSize.width, halfHeight)
	--		 local topLayer = cc.LayerGradient:create(cc.c4b(255,0,0,255), cc.c4b(0,255,0,255), cc.p(0.9, 0.9))
	--		 topLayer:setContentSize(cc.size(borderSize.width, borderSize.height))
	--		 topLayer:setPosition(cc.p(0, app.designSize.height + halfHeight))
			
	--		 local bottomLayer = cc.LayerGradient:create(cc.c4b(0,255,0,255), cc.c4b(255,0,0,255), cc.p(0.9, 0.9))
	--		 bottomLayer:setContentSize(cc.size(borderSize.width, borderSize.height))
			
	--		 fwin._border._layer:addChild(topLayer)
	--		 fwin._border._layer:addChild(bottomLayer)
	--		 return
	--	 else
	--		 fwin._border._layer:addChild(_borderLayer)
	--	 end
 --	end
end

function fwin:addContainer(_layer, _zorder)
	if fwin._scene ~= nil and _layer ~= nil and _layer:getParent() == nil then
		if _zorder ~= nil then
			fwin._scene:addChild(_layer, _zorder)
		else
			fwin._scene:addChild(_layer)
		end
	end
end

function fwin:open(_windows, _layer)
	if _windows ~= nil then
		fwin:push(_windows, _windows._view or _layer)
		return _windows
	end
end

function fwin:update(_windows)
	for k, v in pairs(fwin._list) do
		if v ~= nil and (_windows == nil or v == _windows) then
			if v.back ~= nil then
				v:back()
			end
		end
	end
end

function fwin:back(_windows)
	fwin:update(_windows)
end

function fwin:resetMusic()
	local _windows = nil
	for k, v in pairs(fwin._list) do
		if v ~= nil and v.__cmusic ~= nil and v:isVisible() == true then
			_windows = v
		end
	end
	if _windows ~= nil then
		-- playBgm(formatMusicFile("background", _windows.__cmusic))
		fwin._current_music = _windows.__cmusic
	end
end

function fwin:close(_windows)
	if _windows ~= nil and _windows._view ~= nil then
		fwin:remove(_windows)
		fwin:back(nil)

		-- _windows = nil
		-- for k, v in pairs(fwin._list) do
		-- 	if v ~= nil and v.__cmusic ~= nil and v:isVisible() == true then
		-- 		_windows = v
		-- 	end
		-- end
		-- if _windows ~= nil then
		-- 	-- playBgm(formatMusicFile("background", _windows.__cmusic))
		-- 	fwin._current_music = _windows.__cmusic
		-- end
		fwin:resetMusic()
	end
end

function fwin:cleanMusic()
	for k, v in pairs(fwin._list) do
		if v ~= nil then
			v.__cmusic = nil
		end
	end
end

function fwin:hide(_windows)
	if _windows ~= nil and _windows._view ~= nil 
		and _windows._cover == true then
		for k, v in pairs(fwin._list) do
			if v ~= nil and (v ~= _windows 
				and v._instanceId ~= _windows._instanceId) 
				and v._view._z <= _windows._view._z then
				if v.hide ~= nil then
					v:hide(_windows)
				end
			end
		end
	end
end

function fwin:cover(_windows, _view, _enabled)
	if _enabled == true then
		_windows._covers = _windows._covers or {}
		for k, v in pairs(fwin._list) do
			if v ~= nil and (v ~= _windows 
				and v._instanceId ~= _windows._instanceId) 
				and ((_windows._view == nil or v._view._z <= _windows._view._z) 
				or (_view ~= nil and v._view._z <= _view._z))then
				if v:isVisible() then
					v:setVisible(false)
					v:pause()
					v._is_pause = true
					_windows._covers[v.__cname] = v
					-- table.insert(_windows._covers, v)

					if nil ~= v.onPause then
						v:onPause()
					end
				end
			end
		end
	else
		for k, v in pairs(_windows._covers) do
			if v ~= nil then
				v:setVisible(true)
			end
		end
		if _windows._covers ~= nil and table.getn(_windows._covers) < 1 then
			_windows._covers = nil
		end
	end
end

function fwin:uncover(_windows, _ccnames)
	if _windows._covers ~= nil then
		for k, v in pairs(_ccnames) do
			if v ~= nil then
				local tempWindows = fwin:find(v)
				if tempWindows ~= nil and _windows._covers[tempWindows.__cname] ~= nil then
					tempWindows:setVisible(true)
					tempWindows:resume()
					tempWindows._is_pause = false
					_windows._covers[tempWindows.__cname] = nil
					if nil ~= v.onResume then
						v:onResume()
					end
				end
			end
		end
		local isclean = true
		for k, v in pairs(_windows._covers) do
			if v ~= nil then
				isclean = false
				break
			end
		end
		if isclean == true then
			_windows._covers = nil
		end
	end
end

function fwin:covers(_view)
	for k, v in pairs(fwin._list) do
		if v ~= nil and v._view ~= nil and (_view == nil or v._view._z <= _view._z) then
			v.__cevents = v.__cevents or {}
			table.insert(v.__cevents, {_name="hide", _value = v:isVisible()})
			v:setVisible(false)
			v:pause()
			v._is_pause = true

			if nil ~= v.onPause then
				v:onPause()
			end
		end
	end
end

function fwin:uncovers(_view)
	for k, v in pairs(fwin._list) do
		if v ~= nil and v._view ~= nil and (_view == nil or v._view._z <= _view._z) then
			v.__cevents = v.__cevents or {}
			local event = table.remove(v.__cevents, 1, 1)
			if event ~= nil and event._name == "hide" then
				v:setVisible(event._value)
				v:resume()
				v._is_pause = false
				if nil ~= v.onResume then
					v:onResume()
				end
			end
		end
	end
end

function fwin:allCovers(viewList, cleanup)
	viewList = viewList or fwin._list
	for k, v in pairs(viewList) do
		if v ~= nil and v._view ~= nil then
			if true == cleanup then
				v.__cevents = nil
			end
			v.__cevents = v.__cevents or {}
			table.insert(v.__cevents, {_name="hide", _value = v:isVisible()})
			v:setVisible(false)
			v:pause()
			v._is_pause = true

			if nil ~= v.onPause then
				v:onPause()
			end
		end
	end
end

function fwin:checkCovers(viewList, window)
	viewList = viewList or fwin._list
	for k, v in pairs(viewList) do
		if v == window then
			return
		end
		if v ~= nil and v._view ~= nil 
			and v._view._z <= window._view._z 
			and v._instanceId < window._instanceId
			then
			v.__cevents = v.__cevents or {}
			local visible = v:isVisible()
			local len = #v.__cevents
			if len > 0 then
				local tevent = v.__cevents[len]
				visible = tevent._value
			end
			table.insert(v.__cevents, {_name="hide", _selecter = window, _value = visible})
			v:setVisible(false)
			v:pause()
			v._is_pause = true

			if nil ~= v.onPause then
				v:onPause()
			end
		end
	end
end

function fwin:unAllCovers(viewList, cleanup, window)
	viewList = viewList or fwin._list
	for k, v in pairs(viewList) do
		if v ~= nil and v._view ~= nil then
			v.__cevents = v.__cevents or {}
			local nCount = #v.__cevents
			local event = nil
			for m = 1, nCount do
				-- local event = table.remove(v.__cevents, #v.__cevents, 1)
				local pos = nCount - m + 1
				local tevent = v.__cevents[pos]
				if tevent._selecter == window then
					event = table.remove(v.__cevents, pos, 1)
					break
				end
			end

			if event ~= nil and (true == cleanup or #v.__cevents == 0) and event._name == "hide" then
				v.__cevents = nil
				if true == cleanup then
					v:setVisible(true)
					-- if nil ~= v.__cmusic and v.__cmusic > 0 then
					-- 	fwin._current_music = v.__cmusic
					-- end
				else
					v:setVisible(event._value)
					-- v:setVisible(true)
					-- if true == event._value and nil ~= v.__cmusic and v.__cmusic > 0 then
					-- 	fwin._current_music = v.__cmusic
					-- end
				end
				v:resume()
				v._is_pause = false
				if nil ~= v.onResume then
					v:onResume()
				end
			end
		end
	end
end

function fwin:registerNodeEvent(_windows)
	_windows.onNodeEvent = function (event)
		if event == "enter" then
			if _windows.enter ~= nil then
				_windows:enter()
			end
		elseif event == "enterTransitionFinish" then
			if _windows.enterTransitionFinish ~= nil then
				_windows:enterTransitionFinish()
			end
		elseif event == "exitTransitionStart" then
			if _windows.exitTransitionStart ~= nil then
				_windows:exitTransitionStart()
			end
		elseif event == "exit" then
			_windows:unscheduleUpdate()
			if _windows.exitLua ~= nil then
				_windows:exitLua()	
			end

			if nil ~= _windows.__cmusic then
				for i, v in pairs(fwin._bg_music_indexs) do
					if v == self.__cmusic then
						table.remove(fwin._bg_music_indexs, i, 1)
						break
					end
				end
				local len = #fwin._bg_music_indexs
				if len > 0 then
					fwin._current_music = fwin._bg_music_indexs[len]
				end
			end
		elseif event == "cleanup" then
			if _windows.cleanupLua ~= nil then
				_windows:cleanupLua()
				_windows._isDeathed = true
			end
		end
	end
	
	_windows:registerScriptHandler(_windows.onNodeEvent)
	
	_windows.onNoteUpdate = function (dt)
		-- if _windows.timerLua ~= nil then
		-- 	_windows:timerLua(dt)			
		-- end

		-- if _windows.updateLua ~= nil then
		-- 	_windows:updateLua(dt)			
		-- end

		-- local c = os.clock()

		if _windows.onUpdate ~= nil
			-- and _windows._is_pause ~= true 
			then
			-- Fury (V3): dt real bajo la velocidad de juego VIP (FuryGameSpeed.lua)
			_windows:onUpdate(fury_game_speed ~= nil and fury_game_speed.real_dt(dt) or dt)
		end
		
		-- local ct = os.clock() - c
		-- if nil == _windows.__ct or _windows.__ct < ct then
		-- 	_windows.__ct = ct
		-- end
		-- print("fwin:", _windows.__cname, _windows._is_pause, _windows.__ct)
	end
	if fwin._isRestartDirector == true then

	else
		if _windows.onUpdate ~= nil then
			if _windows.__cdt ~= nil then
				_windows:runAction(cc.RepeatForever:create(
					cc.Sequence:create(
						cc.DelayTime:create(_windows.__cdt), 
						-- cc.CallFunc:create(_windows.onNoteUpdate))
						-- cc.CallFunc:create(_windows.onUpdate))
						cc.CallFunc:create(function ( sender )
							-- local c = os.clock()
							
							-- if sender._is_pause ~= true then
								sender:onUpdate(fury_game_speed ~= nil and fury_game_speed.real_dt(sender.__cdt) or sender.__cdt)
							-- end

							-- local ct = os.clock() - c
							-- if nil == sender.__ct or sender.__ct < ct then
							-- 	sender.__ct = ct
							-- end
							-- print("CallFunc(fwin):", _windows.__cname, sender._is_pause, _windows.__ct)
						end))
					)
				)
			else
				_windows:scheduleUpdateWithPriorityLua(_windows.onNoteUpdate, 0)
			end
		end
	end
end

function fwin:initAsyncImg(_filePath)
	fwin._asyncImg = _filePath
end

-- Fury (30-sep-2026): encoge el rotulo de un boton si no cabe en el boton (los botones
-- btn_1 de las ventanas nuevas: «Subir rango», «Tienda Premium»... se salian en es).
function fwin:fitButtonTitle(button, margin)
	local label = button ~= nil and button:getTitleRenderer() or nil
	if label == nil then
		return
	end
	-- Se baja el tamaño de letra (no la escala: el boton devuelve el rotulo a escala 1 al
	-- cambiar de estado y el recorte volvia).
	local room = button:getContentSize().width - (margin or 30)
	local w = label:getContentSize().width
	-- Dos palabras que no caben: en dos lineas antes de encoger («Desbloquear Premio» salia
	-- cortado por los lados, 30-sep).
	local str = button:getTitleText()
	if w > room and string.find(str, " ") ~= nil and string.find(str, "\n") == nil then
		local best, gap = nil, nil
		for i = 1, #str do
			if string.sub(str, i, i) == " " and (gap == nil or math.abs(i - #str / 2) < gap) then
				best, gap = i, math.abs(i - #str / 2)
			end
		end
		button:setTitleText(string.sub(str, 1, best - 1) .. "\n" .. string.sub(str, best + 1))
		label:setAlignment(cc.TEXT_ALIGNMENT_CENTER)
		-- Dos lineas tienen que caber en el alto del boton.
		local h = button:getContentSize().height
		button:setTitleFontSize(math.max(10, math.min(button:getTitleFontSize() - 2, math.floor((h - 10) / 2.4))))
		w = label:getContentSize().width
	end
	if w > room and w > 0 then
		button:setTitleFontSize(math.max(10, math.floor(button:getTitleFontSize() * room / w)))
	end
end

-- Fury (30-sep-2026): el rotulo de los iconos NUEVOS de la ciudad (Suscripciones, Codigos,
-- Monedas Premium, Estandarte SR, Invasion de Freezer, Cronicas) con el aspecto de los rotulos
-- originales: amarillo con contorno oscuro y sin la franja azul (quitada de sus zc_icon_fury_*.png).
function fwin:furyCityIconLabel(label)
	if label == nil then
		return
	end
	-- 30-sep, 2.ª vuelta (Victor: «las letras se ven delgadas»): como los rotulos quemados de los
	-- originales («Aventura en la nube», «Dragon Treasure»): letra mas grande, contorno GRUESO casi
	-- negro y sombra. Se llama DESPUES del ajuste de ancho de cada icono y hace el suyo.
	label:setScale(1)
	label:setFontSize(19)
	label:setTextColor(cc.c4b(255, 238, 110, 255))
	label:enableOutline(cc.c4b(35, 12, 0, 255), 3)
	label:enableShadow(cc.c4b(0, 0, 0, 200), cc.size(2, -2), 0)
	-- Si no cabe en el ancho del dibujo, en dos lineas partiendo por el espacio mas centrado.
	local room = 78
	-- Posicion original (una linea): con dos lineas el bloque crece hacia ARRIBA, sobre el
	-- dibujo, como en «Aventura en la nube»; hacia abajo pisaba los nombres de los heroes.
	if label._fury_y == nil then
		label._fury_y = label:getPositionY()
	end
	label:setPositionY(label._fury_y)
	local str = string.gsub(label:getString(), "\n", " ")
	label:setString(str)
	if label:getVirtualRendererSize().width > room and string.find(str, " ") ~= nil then
		local best, gap = nil, nil
		for i = 1, #str do
			if string.sub(str, i, i) == " " and (gap == nil or math.abs(i - #str / 2) < gap) then
				best, gap = i, math.abs(i - #str / 2)
			end
		end
		label:setString(string.sub(str, 1, best - 1) .. "\n" .. string.sub(str, best + 1))
		label:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
	end
	local size = label:getVirtualRendererSize()
	local scale = 1
	if size.width > room then
		scale = room / size.width
		label:setScale(scale)
	end
	if string.find(label:getString(), "\n") ~= nil then
		label:setPositionY(label._fury_y + size.height * scale / 4)
	end
end

function fwin:furyCityIconCaption(root)
	-- Naruto/Pokemon (prueba en pantalla 1-oct): su activity_shizishou.csb es un clon de un icono de la
	-- ciudad con el rotulo QUEMADO y no trae el «Text_login_gift_p_0» de Fury, asi que los iconos nuevos
	-- salian SIN NOMBRE. Si la maqueta no lo trae, se crea igual (hijo del boton, centrado abajo).
	local label = ccui.Helper:seekWidgetByName(root, "Text_login_gift_p_0")
	if label ~= nil then
		return label
	end
	local button = ccui.Helper:seekWidgetByName(root, "Button_act_but")
	if button == nil then
		return nil
	end
	label = ccui.Text:create("", "fonts/FZYiHei-M20S.ttf", 19)
	label:setName("Text_login_gift_p_0")
	label:setAnchorPoint(cc.p(0.5, 0.5))
	label:setPosition(cc.p(button:getContentSize().width / 2, button:getContentSize().height / 4))
	button:addChild(label)
	return label
end

function fwin:furyRowRewardList(root)
	-- La lista de premios de la fila sm_limited_time_equip_box_help_list_2.csb. En Fury nace con ancla
	-- (0, 0) en y = 0; en Naruto con ancla (0.5, 0.5) en y = 60, y los premios tapaban el nombre y el
	-- precio (prueba en pantalla 1-oct). Se deja como en Fury: las ventanas solo ponen la X.
	local list = ccui.Helper:seekWidgetByName(root, "ListView_ranking_reward_2")
	if list ~= nil then
		list:setAnchorPoint(cc.p(0, 0))
		list:setPositionY(0)
	end
	return list
end

function fwin:furyRowStatus(root)
	-- El texto de estado/precio de la misma fila. En Fury el fondo de la fila es oscuro; en Naruto es
	-- papel claro y el precio amarillo no se leia (prueba en pantalla 1-oct): contorno oscuro.
	local status = ccui.Helper:seekWidgetByName(root, "Text_kehuode")
	if status ~= nil then
		status:enableOutline(cc.c4b(60, 30, 0, 255), 2)
	end
	return status
end

function fwin:addService(service)
	table.insert(fwin._services, service)
end

function fwin:addEvent(_event)
	table.insert(fwin._events, _event)
	fwin:execute()
end

function fwin.async( ... )
	local _event = fwin._events[1]
	if _event._name == "swap" then
		fwin:swap(_event._window, _event._view)
		_event._window:release()
	end
	table.remove(fwin._events, "1")

	local curr = fwin._events[1]
	if curr ~= nil then
		fwin:execute()
	end
end

function fwin:execute()
	if fwin._asyncImg == "" or fwin._asyncImg == nil then
		fwin.async()
		return
	end
	local curr = fwin._events[1]
	if curr ~= nil and curr._state == 0 then
		curr._state = 1
		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, fwin.async)
	end
end

function fwin:swap(_windows, _view)
	if _windows ~= nil and _view ~= nil then
		if _windows.__cmulti == false then
			print("swap:::", _windows.__cmulti, _windows.__cname)
			return
		end
		if _windows.__cmoroon == true then
			fwin._lock_touch = false
		else
			fwin._lock_touch = true
		end
		fwin._lock_touch_count = 0
		_windows:retain()
		fwin:remove(_windows)
		table.insert(fwin._list, _windows)
		_windows._view = _view
		-- fwin._instance = fwin._instance + 1
		-- _windows._instanceId = fwin._instance
		fwin:hide(_windows)
		fwin:registerNodeEvent(_windows)  
		if _windows:getParent() == nil then
			if _windows._rootWindows ~= nil then
				if _windows._zorder ~= nil then
					_windows._rootWindows:addChild(_windows, _windows._zorder)
				else
					_windows._rootWindows:addChild(_windows)
				end
			else
				if _windows._zorder ~= nil then
					_view._layer:addChild(_windows, _windows._zorder)
				else
					_view._layer:addChild(_windows)
				end
			end
		end
		if _windows.open ~= nil then
			_windows:open()
		end
		_windows:release()
		fwin:clean()
		
		-- if _view._z > fwin._taskbar._z then
		-- 	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
		-- end
		-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
		if sound_effect_param ~= nil then
			local windowMusicParams = dms.searchs(dms["sound_effect_param"], sound_effect_param.class_name, _windows.__cname)
			if windowMusicParams ~= nil and windowMusicParams[1] ~= nil then
				local soundEffects = zstring.split(dms.atos(windowMusicParams[1], sound_effect_param.sound_effect), ",")
				local specialEffect = dms.atoi(windowMusicParams[1], sound_effect_param.special_effect)
				local sound = soundEffects[1]
				if fwin._bg_music_index ~= nil and #soundEffects > tonumber(fwin._bg_music_index) then
					sound = soundEffects[fwin._bg_music_index]
				end
				fwin.soundEffect = tonumber(sound)
				fwin.specialEffect = specialEffect
				if fwin.soundEffect > 0 then
					-- playBgm(formatMusicFile("background", fwin.soundEffect))
					_windows.__cmusic = fwin.soundEffect
					fwin._current_music = _windows.__cmusic
				end
				
				if specialEffect > 0 then
					pushEffect(formatMusicFile("effect", specialEffect))
				end

			 --	local function imageLoaded(texture)
				-- 	if fwin.soundEffect > 0 then
				-- 		playBgm(formatMusicFile("background", fwin.soundEffect))
				-- 	end
					
				-- 	if fwin.specialEffect > 0 then
				-- 		playEffect(formatMusicFile("effect", fwin.specialEffect))
				-- 	end
				-- 	cc.Director:getInstance():getTextureCache():removeUnusedTextures()
			 --	end

				-- cc.Director:getInstance():getTextureCache():addImageAsync("images/ui/bar/bar_1.png", imageLoaded)

				-- -- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
				-- function fwin.sleep(n)
				--	os.execute("sleep " .. n)
				-- end

				-- fwin.co = fwin.co or coroutine.create(function ()
				--	 while true do
				--   --   	-- fwin.sleep(1)
				--   --   	if fwin.soundEffect > 0 then
				-- 		-- 	playBgm(formatMusicFile("background", fwin.soundEffect))
				-- 		-- end
						
				-- 		-- if fwin.specialEffect > 0 then
				-- 		-- 	playEffect(formatMusicFile("effect", fwin.specialEffect))
				-- 		-- end
				--   --   	-- fwin.sleep(3)
				--		 -- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
				--		 coroutine.yield()
				--	 end
				-- end)
			 --	if fwin.co ~= nil then
			 --		coroutine.resume(fwin.co)
			 --	end
			end
		end
		return true
	end
	return false
end

function fwin:push(_windows, _layer)
	-- if _layer == nil then
	-- 	fwin:swap(_windows, fwin._view)
	-- else
	-- 	fwin:swap(_windows, _layer)
	-- end

	_layer = _layer or fwin._view
	fwin:swap(_windows, _layer)
	
	-- _windows:retain()
	-- fwin:addEvent({_name = "swap", _window = _windows, _view = _layer, _state = 0})
end

function fwin:removeChildren(_windows)
	if _windows ~= nil and _windows._view ~= nil then
		for k, v in pairs(fwin._list) do
			if v._rootWindows == _windows then
				fwin:remove(v)
			end
		end
	end
end

function fwin:remove(_windows)
	if _windows ~= nil and _windows._view ~= nil then
		for k, v in pairs(fwin._list) do
			if v == _windows then
				if _windows.__cmoroon == true then
					fwin._lock_touch = false
				else
					fwin._lock_touch = true
				end
				table.remove(fwin._list, k)
				fwin:removeChildren(_windows)
				if _windows.close ~= nil then
					_windows:close(window)
				end
				fwin:destroy(_windows) -- destroy window
				return
			end
		end
	end
end

function fwin:removeAll()
	local length = table.getn(fwin._list)
	while length > 0 do
		local window = fwin._list[length]
		if window ~= nil then
			fwin:close(window)
		end
		table.remove(fwin._list, length)
		length = table.getn(fwin._list)
		-- for k, v in pairs(fwin._list) do
		-- 	if v ~= nil then
		-- 		fwin:remove(v)
		-- 		break
		-- 	else
		-- 		table.remove(fwin._list, k)
		-- 		break
		-- 	end
		-- end
	end

	fwin._list = {}
	fwin:cleanView(fwin._frameview)
	fwin:cleanView(fwin._background)
	fwin:cleanView(fwin._view)
	fwin:cleanView(fwin._dview)
	fwin:cleanView(fwin._viewdialog)
	fwin:cleanView(fwin._taskbar)
	fwin:cleanView(fwin._ui)
	fwin:cleanView(fwin._dialog)
	fwin:cleanView(fwin._notification)
	fwin:cleanView(fwin._screen)
	fwin:cleanView(fwin._system)
	-- fwin:cleanView(fwin._display_log)
	--[[fwin._frameview._layer:removeAllChildren(true)
	fwin._background._layer:removeAllChildren(true)
	fwin._view._layer:removeAllChildren(true)
	fwin._dview._layer:removeAllChildren(true)
	fwin._viewdialog._layer:removeAllChildren(true)
	fwin._taskbar._layer:removeAllChildren(true)
	fwin._ui._layer:removeAllChildren(true)
	fwin._windows._layer:removeAllChildren(true)
	fwin._dialog._layer:removeAllChildren(true)
	fwin._notification._layer:removeAllChildren(true)
	fwin._screen._layer:removeAllChildren(true)
	fwin._system._layer:removeAllChildren(true)]]
	-- fwin._display_log._layer:removeAllChildren()


	-- -- cc.Director:getInstance():setActionManager(cc.ActionManager:new())
	-- cc.Director:getInstance():getActionManager():removeAllActions()
	-- cc.SpriteFrameCache:destroyInstance()
	-- -- cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
	-- ccs.ArmatureDataManager:destroyInstance()
	-- ccs.ActionManagerEx:destroyInstance()
	-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	-- ccs.GUIReader:destroyInstance()
	-- ccs.DataReaderHelper:purge()
	-- cc.Profiler:getInstance():releaseAllTimers()
	-- ccs.CSLoader:destroyInstance()
	-- ccs.ActionTimelineCache:destroyInstance()
	-- cc.Director:getInstance():purgeCachedData()
	-- cc.AnimationCache:destroyInstance()


	-- ccs.ActionTimelineCache:destroyInstance()
	-- -- cc.Director:getInstance():setActionManager(cc.ActionManager:new())
	-- cc.Director:getInstance():getActionManager():removeAllActions()
	-- -- cc.SpriteFrameCache:getInstance():removeSpriteFrames() --:destroyInstance()
	-- -- cc.SpriteFrameCache:getInstance():removeUnusedSpriteFrames()
	-- ccs.ArmatureDataManager:destroyInstance()
	-- ccs.ActionManagerEx:destroyInstance()
	-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	-- ccs.GUIReader:destroyInstance()
	-- -- ccs.DataReaderHelper:purge()
	-- -- cc.Profiler:getInstance():releaseAllTimers()
	-- cc.CSLoader:destroyInstance()
	-- cc.Director:getInstance():purgeCachedData()
	-- cc.AnimationCache:destroyInstance()
	-- cc.SpriteFrameCache:getInstance():removeSpriteFrames() 
	-- cc.Director:getInstance():getTextureCache():removeAllTextures()


	-- ccs.ObjectFactory:destroyInstance()
	-- cc.CSLoader:destroyInstance()
	-- ccs.GUIReader:destroyInstance()

	-- -- cc.Director:getInstance():getActionManager():removeAllActions()
	-- -- ccs.ActionTimelineCache:destroyInstance()
	-- -- ccs.ActionManagerEx:destroyInstance()
	-- -- cc.AnimationCache:destroyInstance()
	-- -- ccs.ArmatureDataManager:destroyInstance()
	-- -- cc.SpriteFrameCache:getInstance():removeSpriteFrames() 
	-- -- cc.Director:getInstance():getTextureCache():removeAllTextures()

	-- ccs.GUIReader:destroyInstance()
	-- ccs.ActionManagerEx:destroyInstance()
	-- ccs.ActionTimelineCache:destroyInstance()
	-- ccs.ArmatureDataManager:destroyInstance()
	-- -- ccs.DictionaryHelper:destroyInstance()
	-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()

	-- -- ccs.ObjectFactory:destroyInstance()
	-- -- ccs.GUIReader:destroyInstance()
	-- -- ccs.ActionManagerEx:destroyInstance()
	-- -- ccs.ActionTimelineCache:destroyInstance()
	-- -- ccs.ArmatureDataManager:destroyInstance()
	-- -- ccs.DictionaryHelper:destroyInstance()
	-- ccs.ArmatureDataManager:destroyInstance()
	-- cc.SpriteFrameCache:getInstance():removeSpriteFrames() 
	-- -- cc.Director:getInstance():getTextureCache():removeUnusedTextures()

	-- -- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	-- ccs.ObjectFactory:destroyInstance()
	-- ccs.GUIReader:destroyInstance()
	-- ccs.ActionManagerEx:destroyInstance()
	-- ccs.ActionTimelineCache:destroyInstance()
	-- -- ccs.ArmatureDataManager:destroyInstance()
	-- cc.Director:getInstance():getActionManager():removeAllActions()
	-- cc.Director:getInstance():getEventDispatcher():removeAllEventListeners()
	-- ccs.ArmatureDataManager:destroyInstance()
	-- cc.SpriteFrameCache:getInstance():removeSpriteFrames() 
	-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()

	-- fwin:freeAllMemeryPool()
end



function fwin:freeAllView()
	local length = table.getn(fwin._list)
	while length > 0 do
		local window = fwin._list[length]
		if window ~= nil then
			fwin:close(window)
		end
		table.remove(fwin._list, length)
		length = table.getn(fwin._list)
		-- for k, v in pairs(fwin._list) do
		-- 	if v ~= nil then
		-- 		fwin:remove(v)
		-- 		break
		-- 	else
		-- 		table.remove(fwin._list, k)
		-- 		break
		-- 	end
		-- end
	end

	fwin._list = {}
	-- fwin:cleanView(fwin._frameview)
	fwin:cleanView(fwin._background)
	fwin:cleanView(fwin._view)
	-- fwin:cleanView(fwin._dview)
	fwin:cleanView(fwin._viewdialog)
	fwin:cleanView(fwin._taskbar)
	fwin:cleanView(fwin._ui)
	fwin:cleanView(fwin._dialog)
	fwin:cleanView(fwin._notification)
	fwin:cleanView(fwin._screen)
	fwin:cleanView(fwin._system)
end

function fwin:freeCache()
	-- fwin._free_cache = true
end

function fwin:freeAllCache()
	-- fwin._free_all_cache = true
end

function fwin:freeMemeryPool()
	-- -- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	-- ccs.ObjectFactory:destroyInstance()
	-- ccs.GUIReader:destroyInstance()
	-- ccs.ActionManagerEx:destroyInstance()
	-- ccs.ActionTimelineCache:destroyInstance()
	-- -- ccs.ArmatureDataManager:destroyInstance()
	-- cc.Director:getInstance():getActionManager():removeAllActions()
	-- cc.Director:getInstance():getEventDispatcher():removeAllEventListeners()
	-- ccs.ArmatureDataManager:destroyInstance()
	-- cc.SpriteFrameCache:getInstance():removeSpriteFrames() 
	-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
end

function fwin:freeAllMemeryPool()
	-- -- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	-- ccs.ObjectFactory:destroyInstance()
	-- ccs.GUIReader:destroyInstance()
	-- ccs.ActionManagerEx:destroyInstance()
	-- ccs.ActionTimelineCache:destroyInstance()
	-- -- ccs.ArmatureDataManager:destroyInstance()
	-- cc.Director:getInstance():getActionManager():removeAllActions()
	-- -- cc.Director:getInstance():getEventDispatcher():removeAllEventListeners()
	-- ccs.ArmatureDataManager:destroyInstance()
	-- cc.SpriteFrameCache:getInstance():removeSpriteFrames() 
	-- cc.Director:getInstance():getTextureCache():removeUnusedTextures()
	-- cc.Director:getInstance():purgeCachedData()
	-- cc.GLProgramCache:destroyInstance()

	cacher.destorySystemCacher()
end

function fwin:cleanView(_view)
	if _view ~= nil then
		local _needClose = true
		while _needClose do
			_needClose = false
			for k, v in pairs(fwin._list) do
				if v._view == _view then
					fwin:close(v)
					_needClose = true
					break
				end
			end
		end
		_view._layer:removeAllChildren(true)
	end	
end

function fwin:cleanViews(_views)
	if _views ~= nil then
		for i, v in pairs(_views) do
			fwin:cleanView(v)
		end
	end	
	fwin:resetMusic()
	fwin._bg_music_indexs = {}
	fwin._last_music = -1
	fwin._current_music = nil
end

function fwin:find(_name)
	if _name ~= nil and _name ~= "" then
		for k, v in pairs(fwin._list) do
			if v.__cname == _name then
				return v
			end
		end
	end
	return nil
end

function fwin:clean(_view)
	-- CCTextureCache:sharedTextureCache():removeUnusedTextures()
	-- handlePlatformRequest(0, CC_CALL_SYSTEM_GC_COLLECT, "")
end

function fwin:destroy(_windows)
	local win = _windows;
	if win ~= nil then
		win:retain()
		if win.getParent ~= nil then
			if win:getParent() ~= nil then
				if win.removeFromParent ~= nil then
					win:removeFromParent(true)
				end
			else
				win:release()
			end
		end
		if _windows.clean ~= nil then
			_windows:clean()
		else
			_windows._widget = nil
		end
		
		if _windows.destroy ~= nil then
			_windows:destroy(_windows)
		end
		
		if _windows.quit ~= nil then
			_windows:quit()
			if _windows ~= nil and _windows.__file ~= nil and _windows.__reload == true then
				package.loaded[_windows.__file] = nil
				print("unload lua is file:", _windows.__file)
			end
		end
		win:release()
	end
	fwin:clean()
end

function fwin.untouch(sender, eventType)

end

-- Toque corto sobre un icono cuya descripcion solo salia manteniendo pulsado:
-- abre la descripcion y la deja abierta hasta tocar fuera (o la propia ficha).
-- Se decide un instante despues: si ese mismo toque abrio o cerro otra ventana
-- (comprar, reclamar, elegir...), no se muestra nada y esa accion queda igual.
function fwin:showIconInfoOnTap(sender, show)
	local count = #fwin._list
	local top = fwin._list[count]
	sender:runAction(cc.Sequence:create(cc.DelayTime:create(0.05), cc.CallFunc:create(function()
		if #fwin._list ~= count or fwin._list[count] ~= top then
			return
		end
		show()
		local win = fwin._list[#fwin._list]
		if win == nil or win == top then
			return
		end
		local size = cc.Director:getInstance():getWinSize()
		local shield = ccui.Layout:create()
		shield:setContentSize(cc.size(size.width * 4, size.height * 4))
		shield:setAnchorPoint(cc.p(0.5, 0.5))
		shield:setTouchEnabled(true)
		shield:setSwallowTouches(true)
		shield:addTouchEventListener(function(_, eventType)
			if eventType == ccui.TouchEventType.ended then
				for _, v in pairs(fwin._list) do
					if v == win then
						fwin:close(win)
						return
					end
				end
			end
		end)
		win:addChild(shield, -1)
	end)))
end

function fwin.touch(sender, eventType)
	-- if eventType == ccui.TouchEventType.began then
	--	 self._displayValueLabel:setString("Touch Down")
	-- elseif eventType == ccui.TouchEventType.moved then
	--	 self._displayValueLabel:setString("Touch Move")
	-- elseif eventType == ccui.TouchEventType.ended then
	--	 self._displayValueLabel:setString("Touch Up")
	-- elseif eventType == ccui.TouchEventType.canceled then
	--	 self._displayValueLabel:setString("Touch Cancelled")
	-- end
	
	fwin._touch_wait_time = 0

	if eventType == ccui.TouchEventType.began then
		fwin._touching = true
		if sender._bmusic == nil or sender._bmusic == 0 then
			sender._bmusic = 1
		-- elseif 	sender._bmusic == 1 then
			-- sender._bmusic = 2
		end
		pushEffect(formatMusicFile("button", sender._bmusic))
		if sender._datas ~= nil and sender._datas.action == nil and sender._datas.touch_scale == true
			-- and sender._datas.action:IsAnimationInfoExists(sender:getName() .. "_touch") == false 
			and sender.playButtonTouchAction ~= true
			then
			sender.playButtonTouchAction = true
			-- sender:stopAllActions()
			if sender._datas.touch_scale_xy ~= nil then
				sender:runAction(cc.ScaleTo:create(0.05, sender._originScale * sender._datas.touch_scale_xy))
			else		
				sender:runAction(cc.ScaleTo:create(0.05, sender._originScale * 1.08))
			end

		end
		if sender._datas ~= nil and sender._datas.touch_black == true then
			sender:setColor(cc.c3b(150, 150, 150))
		end
	elseif eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended then
		fwin._touching = false
	end

	if sender.playButtonTouchAction == true and sender._datas ~= nil and sender._datas.touch_scale == true
	and (eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended) 
	then
		-- sender:stopAllActions()
		sender:runAction(cc.ScaleTo:create(0.05, sender._originScale))
		sender.playButtonTouchAction = false
		if sender._datas.touch_black == true then
			sender:setColor(cc.c3b(250, 250, 250))
		end
	end
	
	if -- sender._uncanceled == true and 
		eventType == ccui.TouchEventType.canceled 
		then
		local __bpoint = sender:getTouchBeganPosition()
		local __spoint = sender:getTouchEndPosition()
		local __mbpoint = sender:convertToNodeSpace(__bpoint)
		local __mpoint = sender:convertToNodeSpace(__spoint)
		local __size = sender:getContentSize()
		-- -- debug.print_r(__bpoint)
		-- -- debug.print_r(__spoint)
		-- debug.print_r(__mbpoint)
		-- debug.print_r(__mpoint)
		-- debug.print_r(__size)
		if __mbpoint.x >= 0 and __mbpoint.y >= 0 and __mbpoint.x <= __size.width and __mbpoint.y <= __size.height 
			and __mpoint.x >= 0 and __mpoint.y >= 0 and __mpoint.x <= __size.width and __mpoint.y <= __size.height 
			then
			eventType = ccui.TouchEventType.ended
		else
			if sender._datas ~= nil and sender._datas.touch_black == true then
				sender:setColor(cc.c3b(250, 250, 250))
			end
		end
	end
	-- print(sender:getName(), sender._locked, eventType, fwin._lock_touch, fwin._close_touch_end_event, sender._btime, sender.__isTouchEnabled, sender._call)
	if -- sender._eventType ~= nil or 
		eventType == ccui.TouchEventType.ended 
		then
		if sender._datas ~= nil and sender._datas.touch_black == true then
			sender:setColor(cc.c3b(250, 250, 250))
		end

		-- 为了不影响进游戏后的整体touch流程，这里做一个特殊处理，让可以响应进游戏后的手动自动切换按钮
		-- if sender._locked == true or fwin._lock_touch == true or fwin._close_touch_end_event == true then
		if sender._locked == true or fwin._lock_touch == true or (fwin._close_touch_end_event == true and sender:getName() ~= "Button_zidong_2" and sender:getName() ~= "Button_zidong") then
			-- touch locked
		else
			if sender._btime == nil then
				sender._btime = 0
			end
			local currentTime = os.time()
			local interval = currentTime + 0.1 - sender._btime + 0.1

			if sender.__isTouchEnabled == false then
				if interval > 3 then
					sender.__isTouchEnabled = true
				else
					-- return
				end
			end
			sender.__isTouchEnabled = true
			interval = 3
			if sender.__isTouchEnabled ~= false 
				and (--sender._eventType ~= nil or 
					interval > 0.13) 
				then
				sender._btime = os.time()
				if sender._call ~= true then
					sender._call = true
					-- -- if sender.setTouchEnabledExt == nil then
					-- -- 	sender.setTouchEnabledExt = sender.setTouchEnabled
					-- -- end
					-- -- sender:setTouchEnabledExt(false)
					-- -- sender.__isTouchEnabled = true
					-- -- sender.setTouchEnabled = function (_self, var)
					-- -- 	_self:setTouchEnabledExt(var)
					-- -- 	_self.__isTouchEnabled = var
					-- -- end
					sender._one_called = true
					-- sender.__isTouchEnabled = false
					-- if sender.isTouchEnabled ~= nil then
					-- 	local isTouched = sender:isTouchEnabled()
					-- 	if isTouched == true then
					-- 		sender:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(function(target) 
					-- 			target.__isTouchEnabled = true
					-- 		end)))
					-- 	end
					-- end

					-- fwin._touch_selecter = sender
					if sender._datas ~= nil then
						if sender._datas.func_string ~= nil then
							local func = assert(loadstring(sender._datas.func_string))
							func()
						end
						if sender._datas.terminal_name ~= nil then
							state_machine.excute(sender._datas.terminal_name, sender._datas.terminal_state or 0, sender)
						end
					end
					if sender._touch ~= nil then
						if sender._touch == fwin.close then
							fwin:close(sender._windows)
						else
							sender._touch(sender, eventType)
						end
					end
					sender._call = nil
				end
			end
		end
	else
		if sender._touch ~= nil then
			sender._touch(sender, eventType)
		end
	end
end

function fwin:addTouchEventListener(_sender, _callFunc, _datas, _eventType, _music)
	if _sender ~= nil and (_callFunc ~= nil or _datas ~= nil) then
		if _sender.addTouchEventListener ~= nil then
			_sender._btime = 0 --os.time()
			_sender.__isTouchEnabled = nil
			_sender._touch = _callFunc
			_sender._datas = _datas
			_sender._eventType = _eventType
			_sender._bmusic = _music
			_sender._originScale = _sender:getScaleX()
			_sender:addTouchEventListener(fwin.touch)
			if _datas ~= nil and _datas.isPressedActionEnabled == true then
				if _sender.setPressedActionEnabled ~= nil then
					_sender:setPressedActionEnabled(true)
				end
			else
				if _datas ~= nil and _datas.touch_scale == true then
					-- _sender._originScale = _sender:getScale()
					if _sender.playButtonTouchAction == false then
						_sender._originScale = _sender:getScaleX()
					end
				end
			end
			return _sender
		end
	end
end

function fwin:removeTouchEventListener(_sender)
	if _sender ~= nil then
		if _sender.addTouchEventListener ~= nil then
			_sender._btime = 0 --os.time()
			_sender.__isTouchEnabled = nil
			_sender._touch = nil
			_sender._datas = nil
			_sender._eventType = nil
			_sender._bmusic = nil
			_sender._originScale = nil
			_sender:addTouchEventListener(fwin.untouch)
			return _sender
		end
	end
end

function fwin:addCloseEventListener(_windows, _sender, _datas, _music)
	if _windows ~= nil and _sender ~= nil and (_callFunc ~= nil or _datas ~= nil) then
		if _sender.addTouchEventListener ~= nil then
			_sender._btime = 0 -- os.time()
			_sender.__isTouchEnabled = nil
			_sender._touch = fwin.close
			if _music == nil then
				_music = 2
			end
			_sender._bmusic = _music
			_sender._windows = _windows
			_sender._datas = _datas
			_sender:addTouchEventListener(fwin.touch)
			return _sender
		end
	end
end

fwin:create()