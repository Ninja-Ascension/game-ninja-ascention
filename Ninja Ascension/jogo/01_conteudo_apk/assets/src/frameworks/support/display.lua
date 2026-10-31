display = display or {}

local m_targetPlatform = cc.Application:getInstance():getTargetPlatform()

function display:gray(node)
	gray.setGray(node)
end

function display:ungray(node)
	gray.removeGray(node)
end

function display:shader(node, vsh, fsh)
	local verts, vertsLen = cc.dms_load(vsh)
	local pszs, pszsLen = cc.dms_load(fsh)
	
	local pProgram = cc.GLProgram:createWithByteArrays(verts, pszs)

	pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION)
	pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
	pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
	pProgram:link()
	pProgram:updateUniforms()
	node:setGLProgram(pProgram)
end

function display:unshader(node)
	local glProgram = cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")
    node:setGLProgram(glProgram)
    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION)
    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
    glProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_TEX_COORDS)
end



draw = draw or {}
draw.size = function()
    return cc.Director:getInstance():getWinSize()
end

draw.graphics = function(layer)
    fwin._scene:addChild(layer)
end

draw.label = function(_widget, _childName, _text)
    ccui.Helper:seekWidgetByName(_widget, _childName):setString(_text)
end



changeAction_animationEventCallFunc = function(armatureBack,movementType,movementID)
	local id = movementID
	if armatureBack._changing == nil then
		armatureBack._changing = true
		if armatureBack._nextAction ~= nil and armatureBack._actionIndex ~= armatureBack._nextAction then
			armatureBack._actionIndex = armatureBack._nextAction
			armatureBack._actionLoopCount = 0
			armatureBack:getAnimation():playWithIndex(armatureBack._nextAction)
		end
		if armatureBack._nextFunc ~= nil 
			and armatureBack._nextFunc ~= changeAction_animationEventCallFunc  then
			armatureBack:getAnimation():setMovementEventCallFunc(armatureBack._nextFunc)
		end 
		armatureBack._changing = nil
		
		if armatureBack._invoke ~= nil then
			armatureBack._invoke(armatureBack)
		end
	end
	if armatureBack._actionLoopCount ~= nil then
		armatureBack._actionLoopCount = armatureBack._actionLoopCount + 1
	end
end

-- 加载光效资源文件
loadEffect = function(fileName)
	-- local fileName = string.format("effect/effice_%d.ExportJson", fileIndex)
	-- CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo(fileName)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
	--local armatureName = string.format("effice_%d", fileIndex)
	return armatureName
end

deleteEffect = function(armatureBack)
	if armatureBack == nil then
		return
	end
	
	if armatureBack._LastsCountTurns > 0 then
		-- 删除光效
		armatureBack._LastsCountTurns = armatureBack._LastsCountTurns == nil and 0 or armatureBack._LastsCountTurns - 1
		if armatureBack._LastsCountTurns <= 0 then
			local fileName = armatureBack._fileName
			armatureBack:removeFromParent(true)
			-- 删除光效文件
			ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(fileName)
		end
	end
end

draw.deleteEffect = deleteEffect

-- createEffect = function(armatureName, armatureFile, armaturePad, loop, ZOrder, actionTimeSpeed)
	-- loadEffect(armatureFile)
	-- local armature = ccs.Armature:create(armatureName)
	-- armature._fileName = armatureFile
	-- armature._invoke = deleteEffect
	-- armature._actionIndex = 0
	-- armature._nextAction = 0
	-- if loop ~= nil and loop > 0 then
		-- armature._LastsCountTurns = loop
	-- else
		-- armature._LastsCountTurns = -1
	-- end
	
	-- if ZOrder ~= nil then
		-- armaturePad:addChild(armature, ZOrder)
	-- else
		-- armaturePad:addChild(armature)
	-- end
	-- if actionTimeSpeed ~= nil and actionTimeSpeed > 0 then
		-- armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
	-- end
	-- armature:setPosition(cc.p(armaturePad:getContentSize().width/2, armaturePad:getContentSize().height/2))
	-- armature:getAnimation():playWithIndex(0)
	-- armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)

	-- print("*********************", fileIndex)
	-- armature._duration = dms.int(dms["duration"], fileIndex, 1) / 60.0
	-- return armature
-- end

draw.createEffect = function(armatureName, armatureFile, armaturePad, loop, ZOrder, actionTimeSpeed, pAnchor)
	loadEffect(armatureFile)
	local armature = ccs.Armature:create(armatureName)
	armature._fileName = armatureFile
	armature._invoke = deleteEffect
	armature._actionIndex = 0
	armature._nextAction = 0
	if loop ~= nil and loop > 0 then
		armature._LastsCountTurns = loop
	else
		armature._LastsCountTurns = -1
	end

	if actionTimeSpeed ~= nil and actionTimeSpeed > 0 then
		armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
	end

	armature:getAnimation():playWithIndex(0)
	armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
	
	if armaturePad ~= nil then
		if ZOrder ~= nil then
			armaturePad:addChild(armature, ZOrder)
		else
			armaturePad:addChild(armature)
		end
		local size = armaturePad:getContentSize()
		if pAnchor ~= nil then
			armature:setPosition(cc.p(size.width * pAnchor.x, size.height * pAnchor.y))
		else
			armature:setPosition(cc.p(size.width / 2, size.height / 2))
		end
	end
	return armature
end

draw.initArmature = function(armature, armaturePad, loop, ZOrder, actionTimeSpeed)
	if armature ~= nil then
		armature._invoke = deleteEffect
		armature._actionIndex = 0
		armature._nextAction = 0
		if loop ~= nil and loop > 0 then
			armature._LastsCountTurns = loop
		else
			armature._LastsCountTurns = -1
		end
		
		if actionTimeSpeed ~= nil and actionTimeSpeed > 0 then
			armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
		end
		if armaturePad ~= nil then
			if ZOrder ~= nil then
				armaturePad:addChild(armature, ZOrder)
			else
				armaturePad:addChild(armature)
			end
			armature:setPosition(cc.p(armaturePad:getContentSize().width/2, armaturePad:getContentSize().height/2))
		end
		armature:getAnimation():playWithIndex(0)
		armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
	end
	return armature
end

draw.initArmatureTwo = function(armature, armaturePad, loop, ZOrder, actionTimeSpeed,index)
	if armature ~= nil then
		armature._invoke = deleteEffect
		armature._actionIndex = 0
		armature._nextAction = 0
		if loop ~= nil and loop > 0 then
			armature._LastsCountTurns = loop
		else
			armature._LastsCountTurns = -1
		end
		
		if actionTimeSpeed ~= nil and actionTimeSpeed > 0 then
			armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
		end
		if armaturePad ~= nil then
			if ZOrder ~= nil then
				armaturePad:addChild(armature, ZOrder)
			else
				armaturePad:addChild(armature)
			end
			armature:setPosition(cc.p(armaturePad:getContentSize().width/2, armaturePad:getContentSize().height/2))
		end
		armature:getAnimation():playWithIndex(index)
		armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
	end
	return armature
end

draw.share = function()

end

function sp.spine_effect(nameIndex, animationName, loop, ZOrder, actionTimeSpeed, pAnchor, scale, trackIndex, skinName, fileNameFormat)
	-- local animationName = "animation"--string.format("effice_%d", nameIndex)
	if nil == fileNameFormat then
		fileNameFormat = "effect/effice_"
	end
	local jsonFile = string.format(fileNameFormat .. "%s.json", nameIndex)
	local atlasFile = string.format(fileNameFormat .. "%s.atlas", nameIndex)
	-- print("create spine effect path = ", atlasFile)
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
	local skeletonNode = sp.spine(jsonFile, atlasFile, _scale, _trackIndex, animationName, _loop, skinName)
	-- skeletonNode.animationNameList = {}
	-- table.insert(skeletonNode.animationNameList, animationName)
	-- if actionTimeSpeed ~= nil and actionTimeSpeed > 0 then
	-- 	skeletonNode:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
	-- end

	-- if armaturePad ~= nil then
	-- 	if ZOrder ~= nil then
	-- 		armaturePad:addChild(skeletonNode, ZOrder)
	-- 	else
	-- 		armaturePad:addChild(skeletonNode)
	-- 	end
	-- 	local size = armaturePad:getContentSize()
	-- 	if pAnchor ~= nil then
	-- 		skeletonNode:setPosition(cc.p(size.width * pAnchor.x, size.height * pAnchor.y))
	-- 	else
	-- 		skeletonNode:setPosition(cc.p(size.width / 2, size.height / 2))
	-- 	end
	-- end

	return skeletonNode
end

function sp.spine_hetiSprite(nameIndex, animationName, loop, ZOrder, actionTimeSpeed, pAnchor, scale, trackIndex, skinName)
	local jsonFile = string.format("sprite/%s.json", nameIndex)
	local atlasFile = string.format("sprite/%s.atlas", nameIndex)
	-- print("create spine_hetiSprite path = ", atlasFile)
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
	local skeletonNode = sp.spine(jsonFile, atlasFile, _scale, _trackIndex, animationName, _loop, skinName)
	return skeletonNode
end

function sp.spine_sprite(armaturePad, nameIndex, actionName, loop, ZOrder, actionTimeSpeed, pAnchor, scale, trackIndex, skinName)
	local jsonFile = string.format("sprite/spirte_%s.json", nameIndex)
	local atlasFile = string.format("sprite/spirte_%s.atlas", nameIndex)
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
--[[
-- 创建动画
--@param skeletonDataFile json名称
--@param atlasFile 纹理名称
--@param scale 缩放 默认1正常比例
--@param trackIndex 从第几帧开始播放
--@param animationName 动作名称 默认"animation"
--@param loop 是否循环播放
--@param skinName 皮肤名称 默认nil
]]
function sp.spine(skeletonDataFile, atlasFile, scale, trackIndex, animationName, loop, skinName)
	if m_targetPlatform == cc.PLATFORM_OS_WINDOWS 
		or m_targetPlatform == cc.PLATFORM_OS_MAC
		then
		-- print("load spine - :", skeletonDataFile, atlasFile)
	end
	local skeletonNode = sp.SkeletonAnimation:create(skeletonDataFile, atlasFile, scale or 1)
	if trackIndex ~= nil and trackIndex >= 0 and animationName ~= nil and animationName ~= "" then
		skeletonNode:setAnimation(trackIndex or 0, animationName, loop or true)
	end
	if skinName ~= nil and skinName ~= "" then
		skeletonNode:setSkin(skinName)
	end
	return skeletonNode
end

function sp.initArmature(skeletonNode, loop)
	if loop == true then
		skeletonNode._LastsCountTurns = -1
	else
		skeletonNode._LastsCountTurns = 1
	end

	skeletonNode._invoke = deleteEffect
	skeletonNode._actionIndex = 0
	skeletonNode._nextAction = 0

	skeletonNode.getAnimation = function(_self)
		return _self
	end

	skeletonNode.getArmature = function(_self)
		return _self
	end

	skeletonNode.playWithIndex = function(_self, actionIndex)
		if nil ~= _self._lockActionIndex and _self._lockActionIndex > 0 then
			return
		end
		_self:setToSetupPose()
		_self:setAnimation(0, _self.animationNameList[actionIndex + 1], true)
		-- if _self._self ~= nil and _self._self.roleCamp == 1 and #_self.animationNameList > 5 then
		-- 	print(string.format("[playWithIndex] start: %s %s", 
  --                     _self._actionIndex,
  --                     _self._nextAction))
		-- end
		if _self.changeActionCallfunc ~= nil then
			_self.changeActionCallfunc(_self, nil, nil)
		end
	end

	skeletonNode.getAnimationDuration = function(_self, actionIndex)
		local actionName = _self.animationNameList[actionIndex + 1]
		return math.ceil(_self:getAnimationDurationEx(actionName) * 30)
	end

	skeletonNode.setSpeedScale = function(_self, _timeScale)
		_self:setTimeScale(_timeScale)
	end

	skeletonNode.getAnimationData = function(_self)
		return _self
	end

	skeletonNode.getMovementCount = function(_self)
		return _self:getMovementCountEx()
	end

	skeletonNode.setMovementEventCallFunc = function(_self, func)
		skeletonNode.changeActionCallfunc = func
		skeletonNode:registerSpineEventHandler(function (event)
			-- if event.skeletonAnimation._self ~= nil and event.skeletonAnimation._self.roleCamp == 1 and #event.skeletonAnimation.animationNameList > 5 then
			-- 	print(string.format("[=========spine] start: %s %s %s", 
	  --                     event.skeletonAnimation._actionIndex,
	  --                     event.skeletonAnimation._nextAction,
	  --                     event.animation))
			-- end
			event.skeletonAnimation.changeActionCallfunc(event.skeletonAnimation, nil, nil)
  		end, sp.EventType.ANIMATION_COMPLETE)
	end

	skeletonNode.setFrameEventCallFunc = function(_self, func)
		skeletonNode.frameCallFunc = func
		skeletonNode:registerSpineEventHandler(function (event)
			-- if event.skeletonAnimation._self ~= nil and #event.skeletonAnimation.animationNameList < 4 then
		 --    	print(string.format("[spine] event: %s, %d, %f, %s, %s, %s", 
		 --                            event.eventData.name,
		 --                            event.eventData.intValue,
		 --                            event.eventData.floatValue,
		 --                            event.eventData.stringValue,
		 --                            event.skeletonAnimation._self.roleCamp,
		 --                            event.skeletonAnimation._self._info._pos))
		 --    end
		    if event.eventData.stringValue ~= "" and event.eventData.stringValue ~= " " then
		    	event.skeletonAnimation.frameCallFunc(event.skeletonAnimation, event.eventData.stringValue, event.trackIndex, event.trackIndex)
		    end
		end, sp.EventType.ANIMATION_EVENT)
	end
	return skeletonNode
end

function draw.sprite(fileName, frameName, opacity, tRect, anchor, parnet, order, scale, pAnchor)
	local sprite = nil 
	if fileName ~= nil then
		sprite = cc.Sprite:create(fileName)
	elseif frameName ~= nil then
		sprite = cc.Sprite:createWithSpriteFrameName(frameName)
	end

	if scale ~= nil then
		sprite:setScale(scale)
	end

	if opacity ~= nil then
		sprite:setOpacity(opacity)
	end

	if tRect ~= nil then
		sprite:setTextureRect(tRect)
	end

	if anchor ~= nil then
		sprite:setAnchorPoint(anchor)
	end

	if parnet ~= nil then
		if order ~= nil then
			parnet:addChild(sprite, order)
		else
			parnet:addChild(sprite)
		end
		local size = parnet:getContentSize()
		if pAnchor ~= nil then
			sprite:setPosition(cc.p(size.width * pAnchor.x, size.height * pAnchor.y))
		else
			sprite:setPosition(cc.p(size.width / 2, size.height / 2))
		end
	end
	return sprite
end


ccaf = function(start_pos, pos)
	local len_y = pos.y - start_pos.y
	local len_x = pos.x - start_pos.x
	local tan_yx = math.abs(len_y)/math.abs(len_x)
	local angle = 0
	local M_PI = 3.14159265358979323846
	if(len_y > 0 and len_x < 0) then
		angle = math.atan(tan_yx)*180/M_PI - 90;
	elseif (len_y > 0 and len_x > 0) then
		angle = 90 - math.atan(tan_yx)*180/M_PI;
	elseif(len_y < 0 and len_x < 0) then
		angle = -math.atan(tan_yx)*180/M_PI - 90;
	elseif(len_y < 0 and len_x > 0) then
		angle = math.atan(tan_yx)*180/M_PI + 90;
	end
	return angle
end


-- ccaf = function(start_pos, pos)
-- 	local len_y = pos.y - start_pos.y
-- 	local len_x = pos.x - start_pos.x
-- 	local tan_yx = math.abs(len_y)/math.abs(len_x)
-- 	local angle = 0
-- 	local M_PI = 3.14159265358979323846
-- 	if(len_y > 0 and len_x < 0) then
-- 		angle = math.atan(tan_yx)*180/M_PI - 90;
-- 	elseif (len_y > 0 and len_x > 0) then
-- 		angle = 90 - math.atan(tan_yx)*180/M_PI;
-- 	elseif(len_y < 0 and len_x < 0) then
-- 		angle = -math.atan(tan_yx)*180/M_PI - 90;
-- 	elseif(len_y < 0 and len_x > 0) then
-- 		angle = math.atan(tan_yx)*180/M_PI + 90;
-- 	end
-- 	return angle
-- end




function draw:addEditBox(_TextField, titleName, bgImage, moveTargetObject, _MaxLength, _ReturnType, isChatWindow)
	local function textFieldEvent(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then
            local textField = sender
            local screenSize = cc.Director:getInstance():getWinSize()
            local scene = fwin._framewindow -- cc.Director:getInstance():getRunningScene()
            -- scene:runAction(cc.MoveTo:create(0.225, cc.p(0, (588) / 2 * app.scaleFactor)))
            -- textField:runAction(cc.MoveTo:create(0.225,cc.p(screenSize.width / 2.0, screenSize.height / 2.0 + textField:getContentSize().height / 2.0)))
            -- self._displayValueLabel:setString("attach with IME")
			textField.state = 1

			if isChatWindow then
				state_machine.excute("sm_chat_view_play_action", 0, 1)
			end
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            local textField = sender
            local screenSize = cc.Director:getInstance():getWinSize()
            local scene = fwin._framewindow -- cc.Director:getInstance():getRunningScene()
            scene:runAction(cc.MoveTo:create(0.225, cc.p(0, 0)))
            -- textField:runAction(cc.MoveTo:create(0.175, cc.p(screenSize.width / 2.0, screenSize.height / 2.0)))
            --self._displayValueLabel:setString("detach with IME")
			textField.state = 2

			if isChatWindow then
				state_machine.excute("sm_chat_view_play_action", 0, 2)
			end
        elseif eventType == ccui.TextFiledEventType.insert_text then
            --self._displayValueLabel:setString("insert words")
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            --self._displayValueLabel:setString("delete word")
        end
    end
    if cc.PLATFORM_OS_IPHONE == targetPlatform
		or cc.PLATFORM_OS_IPAD == targetPlatform
		then
		fwin._framewindow:setUserData(moveTargetObject)
    	_TextField:setUserData(fwin._framewindow)
	else
		fwin._framewindow:setUserObject(moveTargetObject)
    	_TextField:setUserObject(fwin._framewindow)
	end
    
	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	
	if cc.PLATFORM_OS_MAC == targetPlatform then
		return _TextField
	end

	if cc.PLATFORM_OS_IPHONE == targetPlatform
		-- or cc.PLATFORM_OS_ANDROID == targetPlatform
		or cc.PLATFORM_OS_IPAD == targetPlatform
		then
		_TextField:addEventListener(textFieldEvent)
	-- elseif cc.PLATFORM_OS_ANDROID == targetPlatform then
	-- 	self:addEditBox(roleName)
		_TextField.onNodeEvent = function (event)
	        if event == "exitTransitionStart" then
    			_TextField:didNotSelectSelf()
	        end
	    end
		_TextField:registerScriptHandler(_TextField.onNodeEvent)
		return
	end
	local editBoxSize = _TextField:getContentSize() -- cc.size(480, 60)
	local TTFShowEditReturn = _TextField
    local EditName = nil
    local EditPassword = nil
    local EditEmail = nil
	
	local function editBoxTextEventHandle(strEventName,pSender)
		local edit = pSender
		local strFmt 
		if strEventName == "began" then
			-- strFmt = string.format("editBox %p DidBegin !", edit)
			-- print(strFmt)
			-- print("editBox DidBegin !", edit)
			--state_machine.excute("chat_whisper_page_text_touch", 0, {edit, "begin"})
			if cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
				edit.TTFShowEditReturn:setString(edit.TTFShowEditReturn:getString())
			else
				-- print(edit.TTFShowEditReturn:getString())
			end

			if isChatWindow and cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
				state_machine.excute("sm_chat_view_play_action", 0, 1)
			end

			state_machine.excute("platform_handle_platform_request", 0, {0, 2601, "2601"})
		elseif strEventName == "ended" then
			-- strFmt = string.format("editBox %p DidEnd !", edit)
			-- print(strFmt)
			-- print("editBox DidEnd !", edit)
			--state_machine.excute("chat_whisper_page_text_touch", 0, {edit, "end"})
			
			if isChatWindow and cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
				state_machine.excute("sm_chat_view_play_action", 0, 2)
			end
		elseif strEventName == "return" then
			-- strFmt = string.format("editBox %p was returned !",edit)
			-- if edit == EditName then
			-- 	TTFShowEditReturn:setString("Name EditBox return !")
			-- elseif edit == EditPassword then
			-- 	TTFShowEditReturn:setString("Password EditBox return !")
			-- elseif edit == EditEmail then
			-- 	TTFShowEditReturn:setString("Email EditBox return !")
			-- end
			edit.TTFShowEditReturn:setString(edit:getText())
			-- print(strFmt)
			
			if isChatWindow and cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
				state_machine.excute("sm_chat_view_play_action", 0, 2)
			end
			
			-- print("editBox was returned !",edit)
			state_machine.excute("platform_handle_platform_request", 0, {0, 2600, "2600"})
		elseif strEventName == "changed" then
			-- strFmt = string.format("editBox %p TextChanged, text: %s ", edit, edit:getText())
			-- print(strFmt)
			-- print("editBox TextChanged, text:  ", edit, edit:getText())
		end
	end
    -- top
    EditName = ccui.EditBox:create(editBoxSize, bgImage)
    EditName:setPosition(cc.p(0, 0))
    EditName:setAnchorPoint(cc.p(0, 0))
    -- local targetPlatform = cc.Application:getInstance():getTargetPlatform()
 --    if kTargetIphone == targetPlatform or kTargetIpad == targetPlatform then
	--    EditName:setFontName("Paint Boy")
	-- else
	-- 	EditName:setFontName("fonts/Paint Boy.ttf")
	-- end
    EditName:setFontSize(1)
    EditName:setFontColor(cc.c3b(255,0,0))
	EditName:setFont(_TextField:getFontName(), _TextField:getFontSize())
    if kTargetIphone == targetPlatform or kTargetIpad == targetPlatform  or kTargetIpad == targetPlatform then
    	-- EditName:setPlaceHolder(" ")
	else
    	EditName:setPlaceHolder(titleName)
	end
    EditName:setPlaceholderFontColor(cc.c3b(255,255,255))

	EditName:setMaxLength(_MaxLength or 16)
    EditName:setReturnType(_ReturnType or cc.KEYBOARD_RETURNTYPE_DONE)
	--Handler
	EditName:registerScriptEditBoxHandler(editBoxTextEventHandle)
    _TextField:addChild(EditName)
    EditName:setName("editName")
    _TextField:setTouchEnabled(false)
    EditName:setTouchEnabled(true)
    EditName.TTFShowEditReturn = TTFShowEditReturn
    TTFShowEditReturn.editBox = EditName
	return EditName
end

__label_system_font_name = nil
function draw:addEditBoxEx(_TextField, titleName, bgImage, moveTargetObject, _MaxLength, _ReturnType, _editBoxSize, visible, _label, _offsetX, _offsetY, _inputFlag)
	local function textFieldEvent(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then
            local textField = sender
            local screenSize = cc.Director:getInstance():getWinSize()
            local scene = fwin._framewindow -- cc.Director:getInstance():getRunningScene()
            -- scene:runAction(cc.MoveTo:create(0.225, cc.p(0, (588) / 2 * app.scaleFactor)))
            -- textField:runAction(cc.MoveTo:create(0.225,cc.p(screenSize.width / 2.0, screenSize.height / 2.0 + textField:getContentSize().height / 2.0)))
            -- self._displayValueLabel:setString("attach with IME")
			textField.state = 1
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            local textField = sender
            local screenSize = cc.Director:getInstance():getWinSize()
            local scene = fwin._framewindow -- cc.Director:getInstance():getRunningScene()
            scene:runAction(cc.MoveTo:create(0.225, cc.p(0, 0)))
            -- textField:runAction(cc.MoveTo:create(0.175, cc.p(screenSize.width / 2.0, screenSize.height / 2.0)))
            --self._displayValueLabel:setString("detach with IME")
			textField.state = 2
        elseif eventType == ccui.TextFiledEventType.insert_text then
            --self._displayValueLabel:setString("insert words")
        elseif eventType == ccui.TextFiledEventType.delete_backward then
            --self._displayValueLabel:setString("delete word")
        end
    end

    fwin._framewindow:setUserObject(moveTargetObject)
    _TextField:setUserObject(fwin._framewindow)
	local targetPlatform = cc.Application:getInstance():getTargetPlatform()

	if cc.PLATFORM_OS_MAC == targetPlatform then
		return _TextField
	end
	-- if cc.PLATFORM_OS_IPHONE == targetPlatform
	-- 	-- or cc.PLATFORM_OS_ANDROID == targetPlatform
	-- 	or cc.PLATFORM_OS_IPAD == targetPlatform
	-- 	then
	-- 	_TextField:addEventListener(textFieldEvent)
	-- -- elseif cc.PLATFORM_OS_ANDROID == targetPlatform then
	-- -- 	self:addEditBox(roleName)
	-- 	_TextField.onNodeEvent = function (event)
	--         if event == "exitTransitionStart" then
 --    			_TextField:didNotSelectSelf()
	--         end
	--     end
	-- 	_TextField:registerScriptHandler(_TextField.onNodeEvent)
	-- 	return
	-- end
	-- local editBoxSize = _TextField:getContentSize() -- cc.size(480, 60)
	if nil == editBoxSize then
		editBoxSize = _TextField:getContentSize()
    	editBoxSize.height = _TextField:getFontSize() * app.scaleFactor
	end
	local TTFShowEditReturn = _TextField
    local EditName = nil
    local EditPassword = nil
    local EditEmail = nil
	
	local function editBoxTextEventHandle(strEventName,pSender)
		local edit = pSender
		local strFmt 
		if strEventName == "began" then
			-- strFmt = string.format("editBox %p DidBegin !", edit)
			-- print(strFmt)
			-- print("editBox DidBegin !", edit)
			--state_machine.excute("chat_whisper_page_text_touch", 0, {edit, "begin"})
			-- if cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
			-- 	edit.TTFShowEditReturn:setString(edit.TTFShowEditReturn:getString())
			-- else
			-- 	-- print(edit.TTFShowEditReturn:getString())
			-- end

			-- edit:setText(edit._label:getString())
			-- edit._label:setString("")
			if nil ~= edit._label then
				edit:setText(edit._label:getString())
				edit:setPosition(cc.p(edit._position.x + edit._offsetX + 10000, edit._position.y + edit._offsetY))
			else
				edit:setPosition(cc.p(edit._position.x + edit._offsetX, edit._position.y + edit._offsetY))
			end
			state_machine.excute("platform_handle_platform_request", 0, {0, 2601, "2601"})
		elseif strEventName == "ended" then
			-- strFmt = string.format("editBox %p DidEnd !", edit)
			-- print(strFmt)
			-- print("editBox DidEnd !", edit)
			--state_machine.excute("chat_whisper_page_text_touch", 0, {edit, "end"})
			edit:setPosition(edit._position)
		elseif strEventName == "return" then
			-- strFmt = string.format("editBox %p was returned !",edit)
			-- if edit == EditName then
			-- 	TTFShowEditReturn:setString("Name EditBox return !")
			-- elseif edit == EditPassword then
			-- 	TTFShowEditReturn:setString("Password EditBox return !")
			-- elseif edit == EditEmail then
			-- 	TTFShowEditReturn:setString("Email EditBox return !")
			-- end
			-- edit.TTFShowEditReturn:setString(edit:getText())
			-- print(strFmt)
			-- print("editBox was returned !",edit)
			-- edit:setFontSize(edit._fontSize)

			-- local str = edit:getText()
			-- if #str > 0 then
			-- 	edit:setText(" ")
			-- 	edit._label:setString(str)
			-- else
			-- 	edit._label:setString("")
			-- end
			-- print("return:", #str, str)
			if nil ~= edit._label then
				edit:setVisible(false)
				fwin:addService({
	                callback = function ( params )
	                	if nil ~= params and params.setVisible ~= nil then
							params:setVisible(true)
							params:setText(" ")
						end
	                end,
	                delay = 0.2,
	                params = edit
	            })
			end
			edit:setPosition(edit._position)
			state_machine.excute("platform_handle_platform_request", 0, {0, 2600, "2600"})
		elseif strEventName == "changed" then
			-- strFmt = string.format("editBox %p TextChanged, text: %s ", edit, edit:getText())
			-- print(strFmt)
			-- print("editBox TextChanged, text:  ", edit, edit:getText())

			-- local text = edit:getText()
			-- if string.len(text) <= EditName._MaxLength then
			-- 	edit._text = text
			-- else
			-- 	edit:setText(edit._text)
			-- end

			if nil ~= edit._label then
				edit._label:setString(edit:getText())
			end
		end
	end
    -- top
    local position = cc.p(_TextField:getPosition())
    -- EditName = ccui.EditBox:create(cc.size(editBoxSize.width * app.scaleFactor, editBoxSize.height * app.scaleFactor * 1.5), bgImage)
    EditName = ccui.EditBox:create(cc.size(editBoxSize.width * app.scaleFactor, editBoxSize.height * app.scaleFactor * 1.5), bgImage)
    EditName._text = ""
    EditName._anchor = _TextField:getAnchorPoint()
    EditName._offsetX = _offsetX or 0
    -- EditName._offsetY = _offsetY or (-1 * _TextField:getFontSize() * app.scaleFactor)
    EditName._offsetY = _offsetY or (-1 * _TextField:getFontSize() * app.scaleFactor / 2 - _TextField:getFontSize() / 2)
    EditName._MaxLength = _MaxLength or 16
    EditName._size = editBoxSize
    EditName._position = position
    EditName:setPosition(position)
    EditName:setAnchorPoint(EditName._anchor)
    -- EditName:setContentSize(cc.size(editBoxSize.width / app.scaleFactor, EditName:getContentSize().height))
    if nil == __label_system_font_name then
    	local __label = cc.Label:create()
    	__label_system_font_name = __label:getSystemFontName()
    end
    EditName:setFont(__label_system_font_name, _TextField:getFontSize())
    EditName:setPlaceholderFont(__label_system_font_name, _TextField:getFontSize())
    EditName._fontName = __label_system_font_name -- _TextField:getFontName()
    EditName._fontSize = _TextField:getFontSize()
    local color = _TextField:getColor()
    EditName:setFontColor(cc.c4b(color.r,color.g,color.b,255))

    titleName = titleName or _TextField:getString()
    if cc.PLATFORM_OS_IPHONE == targetPlatform
    	or cc.PLATFORM_OS_IPAD == targetPlatform
    	or cc.PLATFORM_OS_MAC == targetPlatform
    	or cc.PLATFORM_OS_WINDOWS == targetPlatform
    	or cc.PLATFORM_OS_ANDROID == targetPlatform
    	then
    	EditName:setPlaceHolder(zstring.split(titleName, "|")[1])
    else
    	EditName:setPlaceHolder(titleName)
	end
    EditName:setPlaceholderFontColor(cc.c4b(255,255,255, 255))
	EditName:setMaxLength(_MaxLength or 16)
	EditName:setInputFlag(_inputFlag or cc.EDITBOX_INPUT_MODE_SINGLELINE) -- cc.EDITBOX_INPUT_FLAG_PASSWORD cc. 
    EditName:setReturnType(_ReturnType or cc.KEYBOARD_RETURNTYPE_DONE)
    if nil == _label then
    	EditName:setName(_TextField:getName())
    	local uiparent = _TextField:getParent()
    	uiparent:setTouchEnabled(true)
    	uiparent:addTouchEventListener(function ( sender, eventType )
    		if eventType == ccui.TouchEventType.began then
	        elseif eventType == ccui.TouchEventType.moved then
	        elseif eventType == ccui.TouchEventType.canceled then
	        elseif eventType == ccui.TouchEventType.ended then
	            EditName:touchDownAction(EditName, eventType)
	        end
    	end)
    else
    	EditName:setPlaceHolder("")
    	EditName:setText("")
    	-- _TextField:setString("")
    	_TextField:setTouchEnabled(true)
    	_TextField:addTouchEventListener(function ( sender, eventType )
    		if eventType == ccui.TouchEventType.began then
	        elseif eventType == ccui.TouchEventType.moved then
	        elseif eventType == ccui.TouchEventType.canceled then
	        elseif eventType == ccui.TouchEventType.ended then
	            EditName:touchDownAction(EditName, eventType)
	        end
    	end)
    end

    -- EditName:setText("")
    EditName.setString = function (sender, text)
    	sender:setText(text)
    end
    EditName.getString = function (sender)
    	return sender:getText()
    end
    EditName.didNotSelectSelf = function ()
    	
    end

    EditName.setPlaceHolderColor = function ( ... )
    	
    end

    -- _TextField:setString("")

    _TextField:getParent():addChild(EditName)
    if _label ~= _TextField then
    	_TextField:removeFromParent(true)
    end

    -- _TextField:addChild(EditName)
    -- _TextField:setTouchEnabled(true)
    -- _TextField:setString("")
    -- -- _TextField:setVisible(false)
    -- _TextField:setName("---" .. _TextField:getName())
	
	--Handler
	EditName:registerScriptEditBoxHandler(editBoxTextEventHandle)
    -- EditName:setTouchEnabled(true)
    EditName:setTouchEnabled(false)
    EditName._label = _label
    
    -- EditName._fontSize = editBoxSize.height
	return EditName
end

--清除输入框文字
function cleanEditBoxString(_TextField)
	if _TextField == nil then 
		return
	end
	local editChild = _TextField:getChildByName("editName")
	if editChild ~= nil then 
		editChild:setText("")
	end
end


function draw.createChatRichText(info, fontName, fontSize)
	local tipHeight = 0
	local _richText = ccui.RichText:create()
	_richText:ignoreContentAdaptWithSize(false)
	_richText:setContentSize(cc.size(width, 0))
	local num = 0
	local picNum = 0 -- self.picNum = 0
	local heightNum = 1
	local length = 0
	local first = {}
	local forNum = 1
	local str = nil
	local l = string.len(info)
	while l >= 1 do
		local f,e = string.find(info, "/%d+|")
		if f == nil then
			str = info
			local re1 = nil
			if tonumber(getDefaultLanguage()) ~= nil and tonumber(getDefaultLanguage()) == 0 then
				re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
				255, str, fontName, fontSize)
			else
				re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
				255, str, "", fontSize)
			end
			_richText:pushBackElement(re1)
			num = num + string.utf8len(str)
			length = length + string.utf8len(str) *20
			while length > 340 do
				length = length - 340
				heightNum = heightNum + 1
				if first[forNum] ~= false then
					first[forNum] = true
				end
				forNum = forNum + 1
			end
			if length> 0 and str ~= nil and str ~= "" then
				if first[forNum] ~= false then
					first[forNum] = true
				end
				-- if heightNum > 1 then
					-- heightNum = heightNum + 1
				-- end
			end
			break
		end
		if f > 1 then
			local info = string.sub(info, 1, f-1)
			num = num + string.utf8len(info)
			local re1 = nil
			if tonumber(getDefaultLanguage()) ~= nil and tonumber(getDefaultLanguage()) == 0 then
				re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
				255, info, fontName, fontSize)
			else
				re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
				255, info, "", fontSize)
			end
			_richText:pushBackElement(re1)
			length = length + string.utf8len(info) *20
			
			while length > 340 do
				length = length - 340
				heightNum = heightNum + 1
				if first[forNum] ~= false then
					first[forNum] = true
				end
				forNum = forNum + 1
			end
		end
		picNum = picNum + 1
		first[forNum] = false
		if 60 + length >= 320 then
			heightNum = heightNum + 1
			length = length + 60 - 320
			forNum = forNum + 1
			first[forNum] = false
		else
			length = length + 60
		end
		
		local pic = string.sub(info, f+1, e-1)
		
		
			if tonumber(pic) ~= nil then
			
			local img = tonumber(pic) - 100
			if img > 0 and  img < 28 then
				local path = string.format("images/ui/biaoqing/%d.png", img)
				local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, path)
				_richText:pushBackElement(reimg)
			
			else
				local info = string.sub(info, f, e)
				num = num + string.utf8len(info)
				local re1 = nil
				if tonumber(getDefaultLanguage()) ~= nil and tonumber(getDefaultLanguage()) == 0 then
					re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
					255, info, fontName, fontSize)
				else
					re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
					255, info, "", fontSize)
				end
				_richText:pushBackElement(re1)
				length = length + string.utf8len(info) *20
				
				while length > 340 do
					length = length - 340
					heightNum = heightNum + 1
					if first[forNum] ~= false then
						first[forNum] = true
					end
					forNum = forNum + 1
				end
			
			end
			
		end
		info = string.sub(info, e+1, l)
		l = string.len(info)
		-- local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, string.format("images/ui/biaoqing/%d.png", tonumber(pic)-100))
		-- _richText:pushBackElement(reimg)
		-- info = string.sub(info, e+1, l)
		-- l = string.len(info)
    end
    return _richText, picNum
end

-- Naruto (punto 6, de One Piece O18): ccui.RichText parte la linea por LETRAS ("no|cturna"): corta el texto en
-- proporcion al hueco que queda. Aqui se parte por PALABRAS midiendo con un Label de la misma fuente y se une con
-- `sep`. Con "\n" (por defecto) solo si no hay colores (%|N|...%): un salto dentro de un elemento con color
-- descoloca la linea. Con otro separador (TuitionController usa "&#13;&#10;", cada trozo en su RichText) un color
-- abierto se cierra al final de la linea y se reabre en la siguiente. Texto sin espacios (chino) o sin ancho: igual.
function draw.partirPorPalabras(str, fontName, fontSize, width, sep)
	sep = sep or "\n"
	if type(str) ~= "string" or str == "" or width == nil or width <= 0 or string.find(str, " ", 1, true) == nil then
		return str
	end
	if sep == "\n" and (string.find(str, "%|", 1, true) ~= nil or string.find(str, "/&|", 1, true) ~= nil) then
		return str
	end
	local medidor = cc.Label:createWithTTF("", fontName, fontSize)
	if medidor == nil then
		return str
	end
	local function visible(t)
		t = string.gsub(t, "/&|", "")
		t = string.gsub(t, "/%d+|", "")
		t = string.gsub(t, "%%|%d+|", "")
		t = string.gsub(t, "%%", "")
		return t
	end
	local function ancho(t)
		medidor:setString(visible(t))
		return medidor:getContentSize().width
	end
	local salida = {}
	for _, parrafo in ipairs(zstring.split(str, sep)) do
		local linea = ""
		local lineas = {}
		for palabra in string.gmatch(parrafo, "[^ ]+") do
			local prueba = (linea == "") and palabra or (linea .. " " .. palabra)
			if linea ~= "" and ancho(prueba) > width * 0.98 then
				local abierto = nil
				for c in string.gmatch(linea, "%%|(%d+)|") do abierto = c end
				local _, signos = string.gsub(linea, "%%", "")          -- cada apertura y cada cierre llevan un %
				local _, aperturas = string.gsub(linea, "%%|%d+|", "")
				if abierto ~= nil and 2 * aperturas > signos then
					table.insert(lineas, linea .. "%")
					linea = "%|" .. abierto .. "|" .. palabra
				else
					table.insert(lineas, linea)
					linea = palabra
				end
			else
				linea = prueba
			end
		end
		table.insert(lineas, linea)
		table.insert(salida, table.concat(lineas, sep))
	end
	return table.concat(salida, sep)
end

-- Naruto (punto 6): la ccui.RichText de este motor (cocos2d-x 3.5, sin setWrapMode) parte la linea por LETRAS en
-- proporcion al hueco que queda («Técnica de R|esurrección», visto en LDPlayer en la ficha del heroe, 27-sep). Aqui se
-- lleva la cuenta del ancho ya ocupado en la linea (mismas medidas que RichText: un Label por elemento) y, si la
-- siguiente palabra no cabe, se mete un nodo vacio del ANCHO ENTERO: RichText lo manda a una fila propia de alto 0 y
-- la palabra empieza la siguiente. Un elemento "\r\n" (que RichText 3.5 pintaba como un label alto en la MISMA linea)
-- pasa a ser un salto de verdad. Sin ancho fijo (ignoreContentAdaptWithSize, marquesina) o sin espacios (chino): igual
-- que antes, solo se lleva la cuenta.
draw._rtOcupado = setmetatable({}, {__mode = "k"})

local function rt_ancho(rt, anchoNuevo)
	local ok, ignora = pcall(function() return rt:isIgnoreContentAdaptWithSize() end)
	if ok and ignora == true then
		return 0
	end
	local w = rt:getContentSize().width
	if (w == nil or w <= 0) and anchoNuevo ~= nil and anchoNuevo > 0 then
		w = anchoNuevo + 15    -- createMessageRichText sin root pone este ancho al final
	end
	return w or 0
end

local function rt_medir(texto, fontName, fontSize)
	local l = nil
	if cc.FileUtils:getInstance():isFileExist(fontName) then
		l = cc.Label:createWithTTF(texto, fontName, fontSize)
	else
		l = cc.Label:createWithSystemFont(texto, fontName, fontSize)
	end
	return (l ~= nil) and l:getContentSize().width or 0
end

function draw.rtAvanzar(rt, w)
	local W = rt_ancho(rt)
	local x = (draw._rtOcupado[rt] or 0) + (w or 0)
	if W > 0 and x > W then
		x = w or 0
	end
	draw._rtOcupado[rt] = x
end

function draw.rtEmpujarTexto(rt, elemento, color, texto, fontName, fontSize, anchoNuevo)
	local W = rt_ancho(rt, anchoNuevo)
	local x = draw._rtOcupado[rt] or 0
	local function salto()
		local nodo = cc.Node:create()
		nodo:setContentSize(cc.size(W, 0))
		rt:pushBackElement(ccui.RichElementCustomNode:create(1, cc.c3b(255, 255, 255), 255, nodo))
		x = 0
	end
	if W <= 0 or type(texto) ~= "string" then
		rt:pushBackElement(elemento)
		return
	end
	if texto == "\r\n" or texto == "\n" then
		salto()
		draw._rtOcupado[rt] = 0
		return
	end
	if string.find(texto, " ", 1, true) == nil or string.find(texto, "\n", 1, true) ~= nil then
		rt:pushBackElement(elemento)
		x = x + rt_medir(texto, fontName, fontSize)
		while x > W do x = x - W end
		draw._rtOcupado[rt] = x
		return
	end
	local acc = ""
	local partido = false
	for sp, palabra in string.gmatch(texto, "(%s*)(%S+)") do
		local cand = acc .. sp .. palabra
		if (x > 0 or acc ~= "") and x + rt_medir(cand, fontName, fontSize) > W - 0.5 then
			if acc ~= "" then
				rt:pushBackElement(ccui.RichElementText:create(1, color, 255, acc, fontName, fontSize))
			end
			salto()
			acc = palabra
			partido = true
		else
			acc = cand
		end
	end
	acc = acc .. (string.match(texto, "%s*$") or "")
	if not partido then
		rt:pushBackElement(elemento)
	elseif acc ~= "" then
		rt:pushBackElement(ccui.RichElementText:create(1, color, 255, acc, fontName, fontSize))
	end
	x = x + rt_medir(acc, fontName, fontSize)
	while x > W do x = x - W end
	draw._rtOcupado[rt] = x
end

--富文本集合方法兼容文字+彩色字+图片   --iswar是否跑马灯
function draw.richTextCollectionMethod(root, str, color1, color2, width, height, fontName, fontSize, color_Type,iswar)
	local strInfoS = {}
	local index = 0
	local w = 1
	if string.len(str) == w then
		strInfoS[1] = str
	else
		while (w<string.len(str)) do
			local f,e = string.find(str, "/&|/%d+|")
			index = index + 1
			if f~= nil and f >= 1 then
				-- local strNew = string.sub(str, w, f-1)
				if f ~= 1 then
					strInfoS[index] = string.sub(str, w, f-1)
					index = index + 1
				end
				
				strInfoS[index] = string.sub(str, f, e)
				str = string.sub(str, e+1, string.len(str))
			else
				local strNew = str
				strInfoS[index] = strNew
				w = string.len(str)
			end
		end
	end
	mRoot = nil
	count = 0
	text = ""
	for i, v in pairs(strInfoS) do
		local str_list = zstring.split(v, "\r\n")
		for k, info in pairs(str_list) do
			if k > 1 then
				mRoot, count, text = draw.createMessageRichText(root, "\r\n", color1, color2, width, height, fontName, fontSize, color_Type,iswar)
			end
			mRoot, count, text = draw.createMessageRichText(root, info, color1, color2, width, height, fontName, fontSize, color_Type,iswar)
		end
	end
	return mRoot, count, text
end

function draw.createMessageRichText(root, str, color1, color2, width, height, fontName, fontSize, color_Type,iswar)
	-- local str = "%|4|我的资源产量%&#13;&#10;铁矿:%|2|x%/小时,石油:%|2|y%/小时,铅矿:%|2|z%/小时,钛矿:%|2|s%/小时,宝石:%|2|a%/小时"
	local mRoot = root or ccui.RichText:create()
	fontSize = fontSize or 10
	local l = string.len(str)
	if root == nil then
		mRoot:ignoreContentAdaptWithSize(false)
	end
	local count = 0
	local text = ""
	while (l > 0) do
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			local f3,e3 = string.find(str, "/%d+|")
			if f3 == nil or e3 == nil then
			else
				local pic = string.sub(str, f3+1, e3-1)
				local path = string.format("images/ui/text/chat/chat_channel_%d.png", tonumber(pic))
				local pathSprite = cc.Sprite:create(path)
				pathSprite:setScale(0.7)
				pathSprite:setContentSize(cc.size(pathSprite:getContentSize().width*0.6,pathSprite:getContentSize().height*0.6))
				 
                if iswar then
                 pathSprite:setScale(1) 
                 pathSprite:setContentSize(cc.size(pathSprite:getContentSize().width,pathSprite:getContentSize().height)) 
                end

				local reimg = ccui.RichElementCustomNode:create(2, cc.c3b(255, 255, 255), 255, pathSprite)
				mRoot:pushBackElement(reimg)
				draw.rtAvanzar(mRoot, pathSprite:getContentSize().width)
				str = string.sub(str, e3 + 1, -1)
			end
		end
		local f,e = string.find(str, "%%%C-%%")
		if f == nil or e == nil then
			local re = nil
			-- if __lua_project_id == __lua_project_adventure then
			-- 	re = ccui.RichElementText:create(1, cc.c3b(199, 171, 120), 255, str, "fonts/chinese.ttf", fontSize)
			-- else
			-- 	re = ccui.RichElementText:create(1, cc.c3b(255, 255, 255), 255, str, "fonts/FZYiHei-M20S.ttf", fontSize)
			-- end
			
			local npinfo = zstring.split(str, "/&|")
			str = npinfo[1]
			re = ccui.RichElementText:create(1, color1, 255, str, fontName, fontSize)
			-- print("1:", text, str)
			text = text .. str
			
			draw.rtEmpujarTexto(mRoot, re, color1, str, fontName, fontSize, width)
			count = count + zstring.utfstrlen(str)
			if nil ~= npinfo[2] then
				local f,e = string.find(npinfo[2], "/%d+|")
				local pic = string.sub(npinfo[2], f+1, e-1)
				-- debug.print_r(f)
				-- print("---------------------")
				-- debug.print_r(e)
				-- local pic = zstring.tonumber(npinfo[2])
				local img = tonumber(pic) - 100
				if img > 0 and  img < 50 then
					local path = string.format("images/ui/chat/face_icon_%d.png", img)
					local pathSprite = cc.Sprite:create(path)
					pathSprite:setScale(0.6)
					pathSprite:setContentSize(cc.size(pathSprite:getContentSize().width*0.6,pathSprite:getContentSize().height*0.6))
					local reimg = ccui.RichElementCustomNode:create(2, cc.c3b(255, 255, 255), 255, pathSprite)
					mRoot:pushBackElement(reimg)
					draw.rtAvanzar(mRoot, pathSprite:getContentSize().width)
				end
			end
			break
		end
		if f > 1 then
			local strsub = string.sub(str, 1, f-1)
			count = count + zstring.utfstrlen(strsub)
			local re = nil
			-- if __lua_project_id == __lua_project_adventure then
			-- 	re = ccui.RichElementText:create(1, cc.c3b(255, 255, 255), 255, strsub, "fonts/chinese.ttf", fontSize)
			-- else
			-- 	re = ccui.RichElementText:create(1, cc.c3b(255, 255, 255), 255, strsub, "fonts/FZYiHei-M20S.ttf", fontSize)
			-- end
			re = ccui.RichElementText:create(1, color2, 255, strsub, fontName, fontSize)
			-- print("2:", text, strsub)
			text = text .. strsub
			
			draw.rtEmpujarTexto(mRoot, re, color2, strsub, fontName, fontSize, width)
		end
		local name = string.sub(str, f+1, e-1)
		local f1, e1 = string.find(name, "%d+")
		if name == nil or f1 == nil or e1 == nil then
			if root == nil then
				mRoot:removeAllChildrenWithCleanup(true)
			end
			break
		end
		local quality = string.sub(name, f1, e1)
		local color = tonumber(quality) + 1
		name = string.sub(name, e1+2, string.len(name))
		count = count + zstring.utfstrlen(name)
		if color == nil or color <= 0 or color > 11 then
			if root == nil then
				mRoot:removeAllChildrenWithCleanup(true)
			end
			break
		end
		local re1 = nil
		-- if __lua_project_id == __lua_project_adventure then
		-- 	re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[color][1],color_Type[color][2],color_Type[color][3]), 255, name, "fonts/chinese.ttf", fontSize)
		-- else
		-- 	re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[color][1],color_Type[color][2],color_Type[color][3]), 255, name, "fonts/FZYiHei-M20S.ttf", fontSize)
		-- end
		-- print("name == "..name)
		if __lua_project_id == __lua_project_red_alert_time then
			local npinfo = zstring.split(name, chat_section[1])
			name = npinfo[1]
			if nil ~= npinfo[2] then
				local pic = zstring.tonumber(npinfo[2])
				local img = tonumber(pic) - 100
				if img > 0 and  img < 50 then
					local path = string.format("images/ui/chat/face_icon_%d.png", img)

					local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, path)
					mRoot:pushBackElement(reimg)
				end
			end
		end
		
		local nameInfo = zstring.split(name, "<title>")
		name = nameInfo[1]
		if nil ~= nameInfo[2] and tonumber(nameInfo[2]) > 0 then
			-- local path = string.format("images/ui/text/title/title_%s.png", dms.string(dms["title_param"], nameInfo[2], title_param.pic_index))
			-- local titleImage = ccui.RichElementImage:create(3, cc.c3b(255, 255, 255), 255, path)
			-- mRoot:pushBackElement(titleImage)

			local path = string.format("images/ui/text/title/title_%s.png", dms.string(dms["title_param"], nameInfo[2], title_param.pic_index))
			local pathSprite = cc.Sprite:create(path)
			pathSprite:setScale(0.6)
			pathSprite:setContentSize(cc.size(pathSprite:getContentSize().width*0.6,pathSprite:getContentSize().height*0.6))
			local reimg = ccui.RichElementCustomNode:create(2, cc.c3b(255, 255, 255), 255, pathSprite)
			mRoot:pushBackElement(reimg)
			draw.rtAvanzar(mRoot, pathSprite:getContentSize().width)
		end
		if color_Type[color] ~= nil then
			if nil ~= color_Type then
				re1 = ccui.RichElementText:create(1, color_Type[color], 255, name, fontName, fontSize)
			else
				re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[color][1],color_Type[color][2],color_Type[color][3]), 255, name, fontName, fontSize)
			end
		else
			re1 = ccui.RichElementText:create(1, color_Type[1], 255, name, fontName, fontSize)
		end
		text = text .. name
		draw.rtEmpujarTexto(mRoot, re1, color_Type[color] or color_Type[1], name, fontName, fontSize, width)
		
		str = string.sub(str, e+1, l)
		l = string.len(str)
	end
	if root == nil then
		if width ~= nil and width > 0 then
			mRoot:setContentSize(cc.size(width+15, height+20))
		else
			mRoot:setContentSize(cc.size(fontSize*count+15, height+20))
		end
	end
	-- print(text)
	return mRoot, count, text
end


