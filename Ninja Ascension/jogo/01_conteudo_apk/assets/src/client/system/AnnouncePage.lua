-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏开启里面的系统公告
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
AnnouncePage = class("AnnouncePageClass", Window)
	
function AnnouncePage:ctor()
    self.super:ctor()
    
	self.roots = {}
	self.ttfFontName = nil
	self.ttfFontSize = nil
	self.textX = nil
	self.textY = nil
	self.scrollConX = nil
	self.scrollConY = nil
	self.lastHeight = 0
	self.Lastbutton = nil

	self._richTextAnchor = cc.p(0.22, 0)

	app.load("client.cells.announce.announce_image_cell")
	app.load("client.cells.announce.announce_list_cell")
	
    -- Initialize AnnouncePage page state machine.
    local function init_AnnouncePage_terminal()
		-- 关闭
		local announce_page_close_terminal = {
            _name = "announce_page_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
				state_machine.excute("login_ui_control", 0, true)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 切换page
		local announce_page_open_new_terminal = {
            _name = "announce_page_open_new",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				terminal._current_select_button = params	
				if instance.Lastbutton ~=nil and terminal._current_select_button ~= instance.Lastbutton then
					instance.Lastbutton:setHighlighted(false)
					instance.Lastbutton=nil
				end
				if instance.Lastbutton ==nil or terminal._current_select_button == instance.Lastbutton then
					terminal._current_select_button:setHighlighted(true)
					instance.Lastbutton=params
				end
				instance:updateDraw(params._datas.isNew,params._datas.title,params._datas.content)
				
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		

		-- 刷新列表大小
        local announce_page_list_refresh_terminal = {
            _name = "announce_page_list_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				local target = nil
				if nil ~= params  then
					target = params.target
				end
				
				local root = self.roots[1]
				local listview = ccui.Helper:seekWidgetByName(root, "ListView_2")
				listview:refreshView()
				
				if nil ~= target  then
					-- 检查 目标定位是否在屏幕中
					instance:checkupLocation(target)
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 收回所有列表项
		local announce_page_list_all_cell_off_terminal = {
            _name = "announce_page_list_all_cell_off",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local root = instance.roots[1]
				local listview = ccui.Helper:seekWidgetByName(root, "ListView_2")
				for i, v in pairs(listview:getItems()) do
					if v.hideContent ~= nil then
						v:hideContent()
					end
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(announce_page_open_new_terminal)
        state_machine.add(announce_page_close_terminal)
        state_machine.add(announce_page_list_refresh_terminal)
        state_machine.add(announce_page_list_all_cell_off_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_AnnouncePage_terminal()
end



function AnnouncePage:checkupLocation(target)
	local root = self.roots[1]
	local lv = ccui.Helper:seekWidgetByName(root, "ListView_2")
	local index = -1
	for i, v in ipairs(lv:getItems()) do
		if v == target then
			index = i
			break
		end
	end
	
	local lvHeight = lv:getContentSize().height
	local lvInnerContainer = lv:getInnerContainer()
	local lvInnerContainerHeight = lvInnerContainer:getContentSize().height
	local lvInnerContainerY = lvInnerContainer:getPositionY()
	
	local tY = target:getPositionY()
	local tHeight = target:getContentSize().height
	lvInnerContainer:setPositionY(lvHeight - lvInnerContainerHeight + target.title_ui:getContentSize().height* (index-1))

end

function AnnouncePage:onUpdateDraw()
	local root = self.roots[1]
	
	-- _ED.system_notice = "title1\r\n|1\r\n|1\r\n|images/ui/play/system_menu/game_list_1.png\r\n|1600///%|2|活动信息活动112344565234543645765756234235436409%/!0,-200,0,-500,images/ui/play/system_menu/game_list_1.png//%|2|活动信息活动2%/!0,0,0,-600,images/ui/play/system_menu/game_list_1.png\r\n|"
					  -- .."title2\r\n|1\r\n|1\r\n|images/ui/play/system_menu/game_list_2.png\r\n|1600///%|2|活动信息活动1%/!0,-200,0,-300,images/ui/play/system_menu/game_list_1.png//%|2|活动信息活动2%/!0,0,0,-600,images/ui/play/system_menu/game_list_1.png\r\n|"
					  -- .."title3\r\n|1\r\n|1\r\n|images/ui/play/system_menu/game_list_3.png\r\n|1600///%|2|活动信息活动1%/!0,-200,0,-300,images/ui/play/system_menu/game_list_1.png//%|2|活动信息活动2%/!0,0,0,-600,images/ui/play/system_menu/game_list_1.png\r\n|"
					  -- .."title4\r\n|1\r\n|2\r\n|\r\n|1600///%|2|活动信息活动1%/!0,-200,0,-300,images/ui/play/system_menu/game_list_1.png//%|2|活动信息活动2%/!0,0,0,-600,images/ui/play/system_menu/game_list_1.png\r\n|"
					  -- .."title5\r\n|1\r\n|2\r\n|\r\n|1600///%|2|活动信息活动1%/!0,-200,0,-300,images/ui/play/system_menu/game_list_1.png//%|2|活动信息活动2%/!0,0,0,-600,images/ui/play/system_menu/game_list_1.png"
	
	if _ED.system_notice_ex == nil or _ED.system_notice_ex == "" then
		return
	end
	local systemNotice = zstring.split(_ED.system_notice_ex,"\\r\\n|") --格式化的内容
	
	local nCount = 10000
	local nIndex = 1
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_2")
	local first_one = nil 
	
	while true do
		nCount = nCount - 1
		if nCount < 0 then
			break
		end
		
		local title = systemNotice[nIndex]
		local isNew = systemNotice[nIndex + 1]
		local nType = systemNotice[nIndex + 2] -- 判断是否为图片
		local titleImage = systemNotice[nIndex + 3]
		local content = systemNotice[nIndex + 4]
		
		if title == nil or isNew == nil or nType == nil or titleImage == nil or content == nil then
			break
		end
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			then
			if nIndex == 1 then
				self:updateDraw(isNew, title, content)
			end
		end
		nIndex = nIndex + 5
		
		if nType == "1" then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				then
			else
			-- 绘制大图
				local big_image = AnnounceImageCell:createCell()
				big_image:init(titleImage)
				listView:addChild(big_image)
			end
			local list_item = AnnounceListCell:createCell()
			list_item:init(isNew, title, content)
			listView:addChild(list_item)
			
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
				then
				local Panel_gg_menu=ccui.Helper:seekWidgetByName(list_item, "Panel_gg_menu")
				Panel_gg_menu:setBackGroundImage(titleImage)
			end
			

			
			if first_one == nil then
				first_one = list_item
			end	
		end
		if nType == "2" then
			-- 绘制列表项
			local list_item = AnnounceListCell:createCell()
			list_item:init(isNew, title, content)
			listView:addChild(list_item)
			
			if first_one == nil then
				first_one = list_item
			end	
			
		end
		listView:requestRefreshView()
	end
	
	if first_one ~= nil then
	
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			then
			self.Lastbutton = ccui.Helper:seekWidgetByName(first_one, "Button_6")
			ccui.Helper:seekWidgetByName(first_one, "Button_6"):setHighlighted(true)
		end
		-- 公告打开时显示第一个公告扩展信息
		-- state_machine.excute("announce_list_cell_on", 0, {_datas = {_cell = first_one}})
	end	
end

-- function AnnouncePage:onUpdate(dt)
	-- if fwin:find("TuitionControllerClass") ~= nil and fwin:find("TuitionControllerClass"):isVisible() == true then
		-- fwin:find("TuitionControllerClass"):setVisible(false)
	-- end
	-- if fwin:find("WindowLockClass") ~= nil and fwin:find("WindowLockClass"):isVisible() == true then
		-- fwin:find("WindowLockClass"):setVisible(false)
	-- end
-- end

function AnnouncePage:updateDraw(isNew,title,content)
-- print("isNew:",isNew)
-- print("title:",title)
--print("content:",content)
	local root = self.roots[1]
	local ScrollView_156 = ccui.Helper:seekWidgetByName(root, "ScrollView_156")
	--print("----",ScrollView_156:getInnerContainer():getPositionY())
	local Panel_12_ui=ccui.Helper:seekWidgetByName(root, "Panel_12")
	Panel_12_ui:removeAllChildren(true)
	local title_text = ccui.Helper:seekWidgetByName(root, "Text_423")
	title_text:setString(title)
	local heightAndContent = zstring.split(content, "///")	
	local content_ui_height = tonumber(heightAndContent[1])+ 166
	Panel_12_ui:setContentSize(cc.size(Panel_12_ui:getContentSize().width, content_ui_height))
	local origin_content = heightAndContent[2]
	ScrollView_156:getInnerContainer():setContentSize(self.scrollConX,content_ui_height)
	ScrollView_156:getInnerContainer():setPositionY(-214-content_ui_height+self.scrollConY)
	--print("self.lastHeight,",content_ui_height,self.scrollConY)
	local each_content = zstring.split(heightAndContent[2], "//")
	local fontmovedownY = 0
	for i, str in ipairs(each_content) do
		local splitStrForColor = zstring.split(str, "|")
		local splitStrForContent = zstring.split(splitStrForColor[3], "%%/!")
		local splitStrForPosition = zstring.split(splitStrForContent[2], ",")
		
		local temp_string = splitStrForContent[1]
		local temp_color = tonumber(splitStrForColor[2])
		local temp_position = cc.p(tonumber(splitStrForPosition[1]), tonumber(splitStrForPosition[2]))	
		local temp_image_position = cc.p(tonumber(splitStrForPosition[3]), tonumber(splitStrForPosition[4]))	
		local temp_image_path = splitStrForPosition[5]	
		local contentImage=nil
		if temp_image_path ~= nil and temp_image_path ~= "" then
			contentImage = cc.Sprite:create(temp_image_path)
			--原先位置不对的原因，是因为panel层高度变了，所以设置panel内的精灵，位置要考虑panel的高度变化
			if contentImage ~= nil then
				contentImage:setPosition(cc.p(
							self.textX + temp_image_position.x-200,
							self.textY + content_ui_height-self.scrollConY))
				contentImage:setAnchorPoint(0.5, 1)			
				Panel_12_ui:addChild(contentImage)
				fontmovedownY=contentImage:getContentSize().height
			end	
		end
		
		local _richText = ccui.RichText:create()
		_richText:ignoreContentAdaptWithSize(false)
		_richText:setContentSize(cc.size(Panel_12_ui:getContentSize().width - 90, 0))
		
		local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[temp_color][1],color_Type[temp_color][2],color_Type[temp_color][3]), 
			255, temp_string, self.ttfFontName, self.ttfFontSize)
		_richText:pushBackElement(re1)
		_richText:setAnchorPoint(self._richTextAnchor)
		_richText:setPosition(cc.p(temp_position.x,temp_position.y+400-30-  fontmovedownY + content_ui_height-self.scrollConY))
		Panel_12_ui:addChild(_richText)
	end

end

function AnnouncePage:onEnterTransitionFinish()
	local csbAnnouncePage = csb.createNode("game_announcement/game_announcement.csb")
	self:addChild(csbAnnouncePage)
	local root = csbAnnouncePage:getChildByName("root")
	table.insert(self.roots, root)	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		then
		local content_text = ccui.Helper:seekWidgetByName(root, "Text_1")
		local ScrollView_156 = ccui.Helper:seekWidgetByName(root, "ScrollView_156")
		
		self.ttfFontName = content_text:getFontName()
		self.ttfFontSize = content_text:getFontSize()
		self.textX = content_text:getPositionX()
		self.textY = content_text:getPositionY()		
		self.scrollConX = ScrollView_156:getInnerContainer():getContentSize().width
		self.scrollConY = ScrollView_156:getInnerContainer():getContentSize().height
		-- print("self.scrollConX",self.scrollConX)
		-- print("self.scrollConY",self.scrollConY)

		if content_text.dispatchFocusEvent ~= nil then
			self._richTextAnchor.x = 0
		end
	end
   
	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "announce_page_close",
		terminal_state = 0,
		_cell = self,
		isPressedActionEnabled = true
	}, nil, 0)
end

function AnnouncePage:onExit()
	state_machine.remove("announce_page_close")
	state_machine.remove("announce_page_list_refresh")
	state_machine.remove("announce_page_list_all_cell_off")
	state_machine.remove("announce_page_open_new")
	
	-- -- 还原教学
	-- if fwin:find("TuitionControllerClass") ~= nil then
		-- fwin:find("TuitionControllerClass"):setVisible(true)
	-- end
	-- if fwin:find("WindowLockClass") ~= nil then
		-- fwin:find("WindowLockClass"):setVisible(true)
	-- end
end