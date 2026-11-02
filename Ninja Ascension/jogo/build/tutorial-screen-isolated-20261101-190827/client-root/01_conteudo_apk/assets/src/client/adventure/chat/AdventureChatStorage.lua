----------------------------------------------------------------------------------------------------
-- 说明：聊天主界面--
-------------------------------------------------------------------------------------------------------

AdventureChatStorage = class("AdventureChatStorageClass", Window)

function AdventureChatStorage.addEditBox(_TextField, titleName, bgImage, moveTargetObject, _MaxLength, _ReturnType)
	local function textFieldEvent(sender, eventType)
        if eventType == ccui.TextFiledEventType.attach_with_ime then
            local textField = sender
            local screenSize = cc.Director:getInstance():getWinSize()
            local scene = fwin._framewindow -- cc.Director:getInstance():getRunningScene()
       
			textField.state = 1
        elseif eventType == ccui.TextFiledEventType.detach_with_ime then
            local textField = sender
            local screenSize = cc.Director:getInstance():getWinSize()
            local scene = fwin._framewindow -- cc.Director:getInstance():getRunningScene()
            scene:runAction(cc.MoveTo:create(0.225, cc.p(0, 0)))
            
			textField.state = 2
        elseif eventType == ccui.TextFiledEventType.insert_text then
        elseif eventType == ccui.TextFiledEventType.delete_backward then
        end
    end

    fwin._framewindow:setUserObject(moveTargetObject)
    _TextField:setUserObject(fwin._framewindow)
	local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	if cc.PLATFORM_OS_IPHONE == targetPlatform
		-- or cc.PLATFORM_OS_ANDROID == targetPlatform
		or cc.PLATFORM_OS_IPAD == targetPlatform
		then
		_TextField:addEventListener(textFieldEvent)
	-- elseif cc.PLATFORM_OS_ANDROID == targetPlatform then
	-- 	self:addEditBox(roleName)
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
			if cc.PLATFORM_OS_WINDOWS ~= targetPlatform then
				edit.TTFShowEditReturn:setString(edit.TTFShowEditReturn:getString())
			else
			end
			state_machine.excute("platform_handle_platform_request", 0, {0, 2601, "2601"})
		elseif strEventName == "ended" then
		
		elseif strEventName == "return" then
			edit.TTFShowEditReturn:setString(edit:getText())
			state_machine.excute("platform_handle_platform_request", 0, {0, 2600, "2600"})
		elseif strEventName == "changed" then
		end
	end
    -- top
    EditName = ccui.EditBox:create(editBoxSize, bgImage)
    EditName:setPosition(cc.p(0, 0))
    EditName:setAnchorPoint(cc.p(0, 0))
    EditName:setFontSize(1)
    EditName:setFontColor(cc.c3b(255,0,0))
    if kTargetIphone == targetPlatform or kTargetIpad == targetPlatform  or kTargetIpad == targetPlatform then
    
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
	--return EditName
end

--清除输入框文字
function AdventureChatStorage.cleanEditBoxString(_TextField)
	if _TextField == nil then 
		return
	end
	local editChild = _TextField:getChildByName("editName")
	if editChild ~= nil then 
		editChild:setText("")
	end
end

function AdventureChatStorage:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.types = nil

	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
		and ___is_open_union == true
		 then
		app.load("client.chat.ChatUnionPage")
	end
	app.load("client.adventure.chat.AdventureChatWorldPage")
	app.load("client.adventure.chat.AdventureChatUnionPage")
	app.load("client.adventure.chat.AdventureChatWhisperPage")
				
    -- Initialize ChatStorage page state machine.
    local function init_adventure_chat_storage_terminal()
		--返回home界面
		local adventure_chat_return_home_page_terminal = {
            _name = "adventure_chat_return_home_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("adventure_chat_show_change_button", 0, "click chat_show_change_button.'")
				state_machine.excute("adventure_chat_world_page_close", 0, "click chat_world_page_close.'")
				state_machine.excute("adventure_chat_whisper_page_close", 0, "click chat_whisper_page_close.'")
				if (__lua_project_id == __lua_project_warship_girl_a 
					or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
					and ___is_open_union == true
	   				then
	   				state_machine.excute("adventure_union_world_page_close", 0, "click union_world_page_close.'")
	   			end
				local cell = params._datas.cell
				fwin:close(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--世界聊天界面
		local adventure_chat_show_chat_page_in_world_terminal = {
            _name = "adventure_chat_show_chat_page_in_world",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDrawOne()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--军团聊天界面
		local adventure_chat_show_chat_page_in_union_terminal = {
            _name = "adventure_chat_show_chat_page_in_union",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	            -- if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
					-- or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
	            -- 	and ___is_open_union == true
	            -- 	 then
	            -- 	if _ED.union.union_info == nil or _ED.union.union_info == {}  or  _ED.union.union_info.union_id == nil or _ED.union.union_info.union_id == "" then
	            -- 	else
		            	instance:onUpdateDrawTwo()
						-- ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0_0"):setVisible(false)
						-- ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_0"):setVisible(false)
						-- ccui.Helper:seekWidgetByName(instance.roots[1], "Image_2_2"):setVisible(true)
				-- 	end
				-- else
				-- 	print("----......")
				-- 	handlePlatformRequest(0, CC_OPEN_URL_LAYOUT, app.configJson.urlweb)
	   -- 			end
				-- instance:onUpdateDrawTwo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--私聊界面
		local adventure_chat_show_chat_page_in_another_terminal = {
            _name = "adventure_chat_show_chat_page_in_another",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDrawThree()
				_ED.findNewWhisper = 0
	
                 return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_chat_whisper_page_other_terminal = {
            _name = "adventure_chat_whisper_page_other",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- 更新信息
				local pageOne = fwin:find("AdventureChatWorldPageClass")
				local pageTwo = fwin:find("AdventureChatUnionPageClass")
				local pageThree = fwin:find("AdventureChatWhisperPageClass")
				
				if pageOne ~= nil then
					pageOne:setVisible(false)
				end
				
				if pageTwo ~= nil then
					pageTwo:setVisible(false)
				end
				
				if pageThree == nil then
					local cell = AdventureChatWhisperPage:new()
					cell:init(params)
					fwin:open(cell,fwin._windows)
					cell:byChild()
				else
					pageThree:setVisible(true)
					pageThree:init(params)
					pageThree:byChild()
				end
				local root = instance.roots[1]
				local button3 = ccui.Helper:seekWidgetByName(root, "Button_chat_3")
				local button1 = ccui.Helper:seekWidgetByName(root, "Button_chat_1")
				state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_whisper_chat",
				_widget = nil,
				_invoke = nil,
				_interval = 0.5,})
				local ball = button3:getChildByName("ball")
				if ball ~= nil then 
				ball:removeFromParent(true)
				end
				button3.__isWhisper = true
				button3:setTouchEnabled(false)
				button3:setHighlighted(true)
				button1:setTouchEnabled(true)
				button1:setHighlighted(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --GM
		local adventure_chat_show_chat_page_in_gm_terminal = {
            _name = "adventure_chat_show_chat_page_in_gm",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
				handlePlatformRequest(0, CC_OPEN_URL_LAYOUT, app.configJson.urlweb)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_chat_whisper_page_other_terminal)
		state_machine.add(adventure_chat_return_home_page_terminal)
		state_machine.add(adventure_chat_show_chat_page_in_world_terminal)
		state_machine.add(adventure_chat_show_chat_page_in_union_terminal)
		state_machine.add(adventure_chat_show_chat_page_in_another_terminal)
		state_machine.add(adventure_chat_show_chat_page_in_gm_terminal)
	

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_adventure_chat_storage_terminal()
end

--世界
function AdventureChatStorage:onUpdateDrawOne()
	local root = self.roots[1]
	local pageOne = fwin:find("AdventureChatWorldPageClass")
	local pageTwo = fwin:find("AdventureChatUnionPageClass")
	local pageThree = fwin:find("AdventureChatWhisperPageClass")
	
	if pageTwo ~= nil then
		pageTwo:setVisible(false)
	end
	
	if pageThree ~= nil then
		pageThree:setVisible(false)
	end
	
	if pageOne == nil then
		fwin:open(AdventureChatWorldPage:new(),fwin._windows)
	else
		pageOne:setVisible(true)
		pageOne:hideChatFace()
	end

	local button3 = ccui.Helper:seekWidgetByName(root, "Button_chat_3")
	local button1 = ccui.Helper:seekWidgetByName(root, "Button_chat_1")
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_whisper_chat",
	_widget = ccui.Helper:seekWidgetByName(root, "Button_chat_3"),
	_invoke = nil,
	_interval = 0.5,})
	button3.__isWhisper = false
	button3:setTouchEnabled(true)
	button3:setHighlighted(false)
	button1:setTouchEnabled(false)
	button1:setHighlighted(true)


end

function AdventureChatStorage:onUpdateDrawTwo()
	local root = self.roots[1]
	local pageOne = fwin:find("AdventureChatWorldPageClass")
	local pageTwo = fwin:find("AdventureChatUnionPageClass")
	local pageThree = fwin:find("AdventureChatWhisperPageClass")
	
	if pageOne ~= nil then
		pageOne:setVisible(false)
	end
	
	if pageThree ~= nil then
		pageThree:setVisible(false)
	end
	
	if pageTwo == nil then
		if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) 
			and ___is_open_union == true
			 then
			fwin:open(AdventureChatUnionPage:new(),fwin._windows)
		end
	else
		pageTwo:setVisible(true)
	end
end

--私聊
function AdventureChatStorage:onUpdateDrawThree()
	local root = self.roots[1]
	local pageOne = fwin:find("AdventureChatWorldPageClass")
	local pageTwo = fwin:find("AdventureChatUnionPageClass")
	local pageThree = fwin:find("AdventureChatWhisperPageClass")
	
	if pageOne ~= nil then
		pageOne:setVisible(false)
	end
	
	if pageTwo ~= nil then
		pageTwo:setVisible(false)
	end
	
	if pageThree == nil then
		fwin:open(AdventureChatWhisperPage:new(),fwin._windows)
	else
		pageThree:setVisible(true)
		pageThree:hideChatFace()
	end
	local button3 = ccui.Helper:seekWidgetByName(root, "Button_chat_3")
	local button1 = ccui.Helper:seekWidgetByName(root, "Button_chat_1")
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_whisper_chat",
	_widget = nil,
	_invoke = nil,
	_interval = 0.5,})
	local ball = button3:getChildByName("ball")
	if ball ~= nil then 
		ball:removeFromParent(true)
	end
	button3.__isWhisper = true
	button3:setTouchEnabled(false)
	button3:setHighlighted(true)
	button1:setTouchEnabled(true)
	button1:setHighlighted(false)
end

function AdventureChatStorage:updateSelect()
	local root = self.roots[1]
	local ImageGouxuan = ccui.Helper:seekWidgetByName(root, "Image_2")
	local isSelected = ImageGouxuan:isVisible()
	
	if isSelected == false then
		ImageGouxuan:setVisible(true)
		state_machine.excute("adventure_chat_show_self", 0, "click chat_show_self.'")
	else
		ImageGouxuan:setVisible(false)
		state_machine.excute("adventure_chat_hide_self", 0, "click chat_hide_self.'")
	end
end

function AdventureChatStorage:onEnterTransitionFinish()

    local csbChatStorage = csb.createNode("Chat/chat.csb")
    self:addChild(csbChatStorage)
	local root = csbChatStorage:getChildByName("root")
	table.insert(self.roots, root)
	local return_home = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_410"), nil, 
		{terminal_name = "adventure_chat_return_home_page", terminal_state = 0, isPressedActionEnabled = true, cell = self}, nil, 0)
	
	--聊天
	local setPressedActionEnabled = true
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		setPressedActionEnabled = false
	end
	local shijie  = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_1"), nil, {
		func_string = [[state_machine.excute("adventure_chat_show_chat_page_in_world", 0, "click chat_show_chat_page_in_world.'")]],
		isPressedActionEnabled = setPressedActionEnabled
		}, 
		nil, 0)
	local juntuan = nil
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_3"), nil, 
	{
		func_string = [[state_machine.excute("adventure_chat_show_chat_page_in_another", 0, "click chat_show_chat_page_in_another.'")]],
		isPressedActionEnabled = setPressedActionEnabled
	}, 
	nil, 0)
	ccui.Helper:seekWidgetByName(root, "Button_chat_2"):setVisible(false)
	fwin:addTouchEventListener(	ccui.Helper:seekWidgetByName(root, "Button_chat_2"), nil,
	{
		func_string = [[state_machine.excute("adventure_chat_show_chat_page_in_union", 0, "click chat_show_chat_page_in_union.'")]],
		isPressedActionEnabled = setPressedActionEnabled
	}, 
	nil, 0)
	

	-- if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	-- 	shijie:setHighlighted(true)
	-- end
	-- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_world_chat",
	-- _widget = ccui.Helper:seekWidgetByName(root, "Button_chat_1"),
	-- _invoke = nil,
	-- _interval = 0.5,})
	
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_whisper_chat",
	_widget = ccui.Helper:seekWidgetByName(root, "Button_chat_3"),
	_invoke = nil,
	_interval = 0.5,})

	-- if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		-- or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
	-- 	and ___is_open_union == true
	-- 	 then
	-- 	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_union_chat",
	-- 	_widget = ccui.Helper:seekWidgetByName(root, "Button_chat_4"),
	-- 	_invoke = nil,
	-- 	_interval = 0.5,})
	-- end

	
	state_machine.excute("adventure_chat_show_chat_page_in_world", 0, "click chat_show_chat_page_in_world.'")
	local status = false
	local chatWindow = fwin:find("AdventureChatHomeViewClass")
	if chatWindow == nil then
		status = false
		ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(false)
	else
		
		if chatWindow:isVisible() == false then 
			--隐藏
			status = false
			ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(false)
		else
			status = true
			ccui.Helper:seekWidgetByName(root, "Image_2"):setVisible(true)
			--显示中
		end
		
	end
	
	local function onOpenTouchEvent(sender, eventType)
		if eventType == ccui.TouchEventType.began then
		elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			self:updateSelect()
		end
	end
	ccui.Helper:seekWidgetByName(root, "Panel_gouxuan"):addTouchEventListener(onOpenTouchEvent)
	
end

function AdventureChatStorage:init(types)
	self.types = types
end

function AdventureChatStorage:onExit()
	
	state_machine.remove("adventure_chat_return_home_page")
	state_machine.remove("adventure_chat_show_chat_page_in_world")
	state_machine.remove("adventure_chat_show_chat_page_in_union")
	state_machine.remove("adventure_chat_show_chat_page_in_another")
	state_machine.remove("adventure_chat_whisper_page_other")
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
		and ___is_open_union == true
		 then
		state_machine.remove("adventure_chat_show_chat_page_in_gm")
	end
	
end
