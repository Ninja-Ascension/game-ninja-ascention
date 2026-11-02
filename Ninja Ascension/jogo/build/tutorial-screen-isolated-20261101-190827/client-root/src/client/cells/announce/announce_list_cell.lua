----------------------------------------------------------------------------------------------------
-- 说明：公告列表控件
-------------------------------------------------------------------------------------------------------
AnnounceListCell = class("AnnounceListCellClass", Window)

function AnnounceListCell:ctor()
    self.super:ctor()

	self.roots = {}

	self.title_ui = nil
	self.content_ui = nil
	
	self.isNew = nil
	self.title = nil
	self.content = nil
	local function init_AnnounceListCell_terminal()
		-- 展开
		local announce_list_cell_on_terminal = {
            _name = "announce_list_cell_on",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas._cell
				cell:showContent()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(announce_list_cell_on_terminal)
        state_machine.init()
    end
	
	init_AnnounceListCell_terminal()
end

-- 展开
function AnnounceListCell:showContent()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		
	else
	
		if self.content_ui:isVisible() == false then
			local root = self.roots[1]
			state_machine.excute("announce_page_list_all_cell_off", 0, "")
			self.content_ui:setVisible(true)
			self:setContentSize(cc.size(self.title_ui:getContentSize().width, 
								self.title_ui:getContentSize().height + self.content_ui:getContentSize().height))
			self.title_ui:setPositionY(self.content_ui:getContentSize().height)					
			
			-- 绘制标签
			if self.isNew == "1" then
				ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(false)
			elseif self.isNew == "2" then	
				ccui.Helper:seekWidgetByName(root, "Image_4"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Image_5"):setVisible(false)
			end
			
			state_machine.excute("announce_page_list_refresh", 0, { target = self})
		else
			-- 收回
			self:hideContent()
		end	
	end
end

-- 收回
function AnnounceListCell:hideContent()

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		
		
	else
		local root = self.roots[1]
		self.content_ui:setVisible(false)
		self:setContentSize(self.title_ui:getContentSize())
		self.title_ui:setPositionY(0)
		state_machine.excute("announce_page_list_refresh", 0, nil)
		
		-- 绘制标签
		if self.isNew == "1" then
			ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
		elseif self.isNew == "2" then	
			ccui.Helper:seekWidgetByName(root, "Image_4"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_5"):setVisible(true)
		end
	end
end

function AnnounceListCell:onUpdateDraw()
	local root = self.roots[1]
	-- 绘制标题
	-- 根据公告new hot 来决定红色处理 self.isNew   (0 无，1 new，2 hot)
	
	
	local title_text = ccui.Helper:seekWidgetByName(root, "Text_9")
	title_text:setString(self.title)
	if self.isNew == "0" then
		title_text:setColor(cc.c3b(0, 0, 0))
	end	
	
	-- 绘制标签
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else	
		if self.isNew == "1" then
			ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
			if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
				title_text:setColor(cc.c3b(255, 0, 0))		
			end
		elseif self.isNew == "2" then
			ccui.Helper:seekWidgetByName(root, "Image_5"):setVisible(true)
			if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
				title_text:setColor(cc.c3b(255, 0, 0))		
			end
		end
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		self.content_ui:setVisible(false)
		self:setContentSize(self.title_ui:getContentSize())
		self.title_ui:setPositionY(0)
		state_machine.excute("announce_page_list_refresh", 0, nil)
		
		-- 绘制标签
		if self.isNew == "1" then
			ccui.Helper:seekWidgetByName(root, "Image_1"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_3"):setVisible(true)
		elseif self.isNew == "2" then	
			ccui.Helper:seekWidgetByName(root, "Image_4"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Image_5"):setVisible(true)
		end
	end
	
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		-- 绘制内容,处理内容数据
		local content_text = ccui.Helper:seekWidgetByName(root, "Text_1")
		local heightAndContent = zstring.split(self.content, "///")
		
		local content_ui_height = tonumber(heightAndContent[1])
		self.content_ui:setContentSize(cc.size(self.content_ui:getContentSize().width, content_ui_height))
		content_text:setAnchorPoint(cc.p(0, 0))
		content_text:setPosition(cc.p(0, content_ui_height - 20))
		
		local origin_content = heightAndContent[2]
			
		local each_content = zstring.split(heightAndContent[2], "//")
		for i, str in ipairs(each_content) do
			local splitStrForColor = zstring.split(str, "|")
			local splitStrForContent = zstring.split(splitStrForColor[3], "%%/!")
			local splitStrForPosition = zstring.split(splitStrForContent[2], ",")
			
			local temp_string = splitStrForContent[1]
			local temp_color = tonumber(splitStrForColor[2])
			local temp_position = cc.p(tonumber(splitStrForPosition[1]), tonumber(splitStrForPosition[2]))
			
			local temp_image_position = cc.p(tonumber(splitStrForPosition[3]), tonumber(splitStrForPosition[4]))
			local temp_image_path = splitStrForPosition[5]
			if temp_image_path ~= nil and temp_image_path ~= "" then
				local contentImage = cc.Sprite:create(temp_image_path)
				if contentImage ~= nil then
					contentImage:setPosition(cc.p(
								content_text:getPositionX() + temp_image_position.x,
								content_text:getPositionY() + temp_image_position.y))
					contentImage:setAnchorPoint(0.5, 0.5)			
					self.content_ui:addChild(contentImage)
				end	
			end
			
			local _richText = ccui.RichText:create()
			_richText:ignoreContentAdaptWithSize(false)
			_richText:setContentSize(cc.size(self.content_ui:getContentSize().width - 90, 0))
			
			local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[temp_color][1],color_Type[temp_color][2],color_Type[temp_color][3]), 
				255, temp_string, content_text:getFontName(), content_text:getFontSize())
			_richText:pushBackElement(re1)
			_richText:setAnchorPoint(cc.p(0.22, 0.5))
			_richText:setPosition(temp_position)
			content_text:addChild(_richText)
		end
	end
end

function AnnounceListCell:onEnterTransitionFinish()
	local filePath = nil
	filePath = "game_announcement/game_announcement_list_1.csb"
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self.title_ui = ccui.Helper:seekWidgetByName(root, "Panel_gonggao")
	self.content_ui = ccui.Helper:seekWidgetByName(root, "Image_17")
	self.content_ui:setAnchorPoint(cc.p(0.5, 1))
	
	self:hideContent()
	
	self:onUpdateDraw()
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_6"), nil, 
		{
			terminal_name = "announce_page_open_new",
			current_button_name = "Button_6",  
			terminal_state = 0,
			isNew = self.isNew,
			title = self.title,
			content = self.content,
		}, nil, 0)
		
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_6"), nil, 
		{
			terminal_name = "announce_list_cell_on",
			terminal_state = 0,
			_cell = self
		}, nil, 0)
	end

end

function AnnounceListCell:onExit()

end

function AnnounceListCell:init(_isNew, _title, _content)
	self.isNew = _isNew
	self.title = _title
	self.content = _content
end

function AnnounceListCell:createCell()
	local cell = AnnounceListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end