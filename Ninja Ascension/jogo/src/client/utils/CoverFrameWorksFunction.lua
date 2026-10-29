
fwin = fwin or {}

fwin._services = {}

function dms.count(element)
    if element == nil then
        debug.log(true, "dms moudle in function 「dms.element」: element ", element)
        return nil
    end
    return table.getn(element)
end

function sp.spine_sprite_path_match(armaturePad, jsonFile, atlasFile, actionName, loop, ZOrder, actionTimeSpeed, pAnchor, scale, trackIndex, skinName)
	-- print("create spine sprite path = ", atlasFile)
	-- if cc.FileUtils:getInstance():isFileExist(jsonFile) == false then
	-- 	nameIndex = 501
	-- 	jsonFile = string.format("sprite/spirte_%d.json", nameIndex)
	-- 	atlasFile = string.format("sprite/spirte_%d.atlas", nameIndex)
	-- end
	local _scale = 1
	local _trackIndex = 0
	local _loop = true
	if scale ~= nil then
		_scale = scale
	end
	if trackIndex ~= nil then
		_trackIndex = trackIndex
	end
	if loop ~= nil then
		_loop = loop
	end
	local skeletonNode = sp.spine(jsonFile, atlasFile, _scale, _trackIndex, actionName, _loop, skinName)
	-- if actionTimeSpeed ~= nil and actionTimeSpeed > 0 then
	-- 	skeletonNode:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
	-- end

	if armaturePad ~= nil then
		if ZOrder ~= nil then
			armaturePad:addChild(skeletonNode, ZOrder)
		else
			armaturePad:addChild(skeletonNode)
		end
		local size = armaturePad:getContentSize()
		if pAnchor ~= nil then
			skeletonNode:setPosition(cc.p(size.width * pAnchor.x, size.height * pAnchor.y))
		else
			skeletonNode:setPosition(cc.p(size.width / 2, size.height / 2))
		end
	end

	return skeletonNode
end

function fwin.updateLua(dt)
    if fwin._lock_touch == true then
		fwin._lock_touch_count = fwin._lock_touch_count + dt
		if fwin._lock_touch_count > 0.3 then
	    	fwin._lock_touch = false
	    	fwin._lock_touch_count = 0
		end
    end
	if app.notification_center ~= nil and app.notification_center.updateNotificationCenter ~= nil then
    	app.notification_center.updateNotificationCenter(dt)
    end

    if fwin._current_music ~= nil and fwin._last_music ~= fwin._current_music then
		playBgm(formatMusicFile("background", fwin._current_music))
		fwin._last_music = fwin._current_music
		fwin._current_music = nil
	end

	local nCount = 0
	while #fwin._services > nCount do
		local service = fwin._services[nCount + 1] -- table.remove(fwin._services, nCount + 1)
		if nil ~= service then
			if service.delay == nil or service.delay <= 0 then
				table.remove(fwin._services, nCount + 1)
				service.callback(service.params)
			else
				service.delay = service.delay - dt
				nCount = nCount + 1
			end
		else
			break
		end
	end
end

fwin.addService = function(self, service)
	table.insert(self._services, service)
end

fwin.destroy = function(self, _windows)
	local win = _windows
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
			_windows:destroy()
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
	self:clean()
end

fwin.remove = function(self, _windows)
	if _windows ~= nil and _windows._view ~= nil then
		for k, v in pairs(self._list) do
			if v == _windows then
				if _windows.__cmoroon == true then
					self._lock_touch = false
				else
					self._lock_touch = true
				end
				table.remove(self._list, k)
				self:removeChildren(_windows)
				if _windows.close ~= nil then
					_windows:close()
				end
				self:destroy(_windows) -- destroy window
				return
			end
		end
	end
end

function fwin.touch(sender, eventType)
	-- if eventType == ccui.TouchEventType.began then
	--     self._displayValueLabel:setString("Touch Down")
	-- elseif eventType == ccui.TouchEventType.moved then
	--     self._displayValueLabel:setString("Touch Move")
	-- elseif eventType == ccui.TouchEventType.ended then
	--     self._displayValueLabel:setString("Touch Up")
	-- elseif eventType == ccui.TouchEventType.canceled then
	--     self._displayValueLabel:setString("Touch Cancelled")
	-- end

	if sender._uncanceled == true and eventType == ccui.TouchEventType.canceled then
		-- local __spoint = sender:getTouchBeganPosition()
		local __spoint = sender:getTouchEndPosition()
		local __mpoint = sender:convertToNodeSpace(__spoint)
		local __size = sender:getContentSize()
		if __mpoint.x >= 0 and __mpoint.y >= 0 and __mpoint.x <= __size.width and __mpoint.y <= __size.height then
	    	eventType = ccui.TouchEventType.ended
		end
	end

	if -- sender._eventType ~= nil or 
		eventType == ccui.TouchEventType.ended 
		then
		if sender._locked == true or fwin._lock_touch == true or fwin._close_touch_end_event == true then
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
			if sender.__isTouchEnabled ~= false 
				and (--sender._eventType ~= nil or 
					interval > 0.13) 
				then
				sender._btime = os.time()
				if sender._call ~= true then
					sender._call = true
					-- if sender.setTouchEnabledExt == nil then
					-- 	sender.setTouchEnabledExt = sender.setTouchEnabled
					-- end
					-- sender:setTouchEnabledExt(false)
					-- sender.__isTouchEnabled = true
					-- sender.setTouchEnabled = function (_self, var)
					-- 	_self:setTouchEnabledExt(var)
					-- 	_self.__isTouchEnabled = var
					-- end
					sender.__isTouchEnabled = false
					if sender.isTouchEnabled ~= nil then
						local isTouched = sender:isTouchEnabled()
						if isTouched == true then
							sender:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(function(target) 
								target.__isTouchEnabled = true
							end)))
						end
					end
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
	elseif eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended then
		fwin._touching = false
	end

	if sender.playButtonTouchAction == true and sender._datas ~= nil and sender._datas.touch_scale == true
	and (eventType == ccui.TouchEventType.canceled or eventType == ccui.TouchEventType.ended) 
	then
		-- sender:stopAllActions()
		sender:runAction(cc.ScaleTo:create(0.05, sender._originScale))
		sender.playButtonTouchAction = false
	end
end