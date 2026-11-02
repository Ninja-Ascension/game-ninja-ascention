----------------------------------------------------------------------------------------------------
-- 说明：挖矿公告列表控件
-------------------------------------------------------------------------------------------------------
AdventureAnnounceListCell = class("AdventureAnnounceListCellClass", Window)

function AdventureAnnounceListCell:ctor()
    self.super:ctor()

	self.roots = {}

	self.title_ui = nil
	self.content_ui = nil
	
	self.isNew = nil
	self.title = nil
	self.content = nil
	self.rootSize = nil
	local function init_AdventureAnnounceListCell_terminal()
        state_machine.init()
    end
	
	init_AdventureAnnounceListCell_terminal()
end

-- 展开
function AdventureAnnounceListCell:showContent()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		
	else
	
		-- if self.content_ui:isVisible() == false then
		-- 	local root = self.roots[1]
		-- 	state_machine.excute("announce_page_list_all_cell_off", 0, "")
		-- 	self.content_ui:setVisible(true)
		-- 	self:setContentSize(cc.size(self.title_ui:getContentSize().width, 
		-- 						self.title_ui:getContentSize().height + self.content_ui:getContentSize().height))
		-- 	self.title_ui:setPositionY(self.content_ui:getContentSize().height)						
	end
end

-- 收回
function AdventureAnnounceListCell:hideContent()

end

function AdventureAnnounceListCell:onUpdateDraw()
	local root = self.roots[1]
	-- 绘制标题
	-- 根据公告new hot 来决定红色处理 self.isNew   (0 无，1 new，2 hot)
	
	local title_text = ccui.Helper:seekWidgetByName(root, "Text_9")
	title_text:setVisible(true)
	title_text:setString(self.title)
	local titleHeight = title_text:getContentSize().height

	if self.isNew == "0" then
		title_text:setColor(cc.c3b(0, 0, 0))
	end	

		-- 绘制内容,处理内容数据
	local content_text = ccui.Helper:seekWidgetByName(root, "Text_1")
	content_text:setVisible(true)
	local heightAndContent = zstring.split(self.content, "///")
	
	local content_ui_height = tonumber(heightAndContent[1])
	self.content_ui:setContentSize(cc.size(self.content_ui:getContentSize().width, content_ui_height))
	content_text:setAnchorPoint(cc.p(0, 0))
	content_text:setPosition(cc.p(0, content_ui_height - 20-60))
	
	content_text:ignoreContentAdaptWithSize(false)
	content_text:setContentSize(cc.size(320,0))
	
	local origin_content = heightAndContent[2]
		
	local each_content = zstring.split(heightAndContent[2], "//")
	local _t_label_height = 0 
	for i, str in ipairs(each_content) do
		local splitStrForColor = zstring.split(str, "|")
		local splitStrForContent = zstring.split(splitStrForColor[3], "%%/!")
		local splitStrForPosition = zstring.split(splitStrForContent[2], ",")
		
		local temp_string = splitStrForContent[1]
		
		temp_string = zstring.replace(temp_string, "\\", "//")
		local temp_color = tonumber(splitStrForColor[2])
		local temp_position = cc.p(tonumber(splitStrForPosition[1]), tonumber(splitStrForPosition[2]))
		
		local _richText = ccui.RichText:create()
		_richText:ignoreContentAdaptWithSize(false)
		_richText:setContentSize(cc.size(self.content_ui:getContentSize().width, 0))
		local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[temp_color][1],color_Type[temp_color][2],color_Type[temp_color][3]), 
			255, temp_string, content_text:getFontName(), content_text:getFontSize())
		_richText:pushBackElement(re1)
		-- 这里的计算坐标不用传过了的,自己计算
		_richText:setAnchorPoint(cc.p(0.20, 0.5))
		_richText:setPosition(cc.p(-40,-_t_label_height))--temp_position.y))
		content_text:addChild(_richText)
		
		--　自动换行计算
		local  _t_label = cc.Label:createWithTTF(temp_string,content_text:getFontName(),content_text:getFontSize())
		_t_label:setHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
        _t_label:setVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
        _t_label:setDimensions(content_text:getContentSize().width,0)
		
		-- 每次都加刚创建的组件高度 最后获得总高度
  		_t_label_height = _t_label_height + _t_label:getContentSize().height
    
	end
	-- 总高度要额外加一些,以免裁切
	local totalHeight = _t_label_height + titleHeight + 15
	-- 重置标题,以及内容坐标 最后设置单元格夫容器的大小
	content_text:setPosition(cc.p(0,_t_label_height))
	title_text:setPosition(cc.p(title_text:getPositionX(),_t_label_height + titleHeight / 2 ))
	self:setContentSize(cc.size(self.rootSize.width,totalHeight))
end

function AdventureAnnounceListCell:onEnterTransitionFinish()
	local filePath = nil
	filePath = "game_announcement/game_announcement_list_1.csb"
	local csbItem = csb.createNode("game_announcement/game_announcement_list_1.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	self.title_ui = ccui.Helper:seekWidgetByName(root, "Panel_gonggao")
	self.content_ui = ccui.Helper:seekWidgetByName(root, "Image_17")
	--self.content_ui:setAnchorPoint(cc.p(0.5, 1))
	self.rootSize = root:getContentSize()
	self:setContentSize(self.rootSize)

	self:onUpdateDraw()
end

function AdventureAnnounceListCell:onExit()

end

function AdventureAnnounceListCell:init(_isNew, _title, _content)
	self.isNew = _isNew
	self.title = _title
	self.content = _content
end

function AdventureAnnounceListCell:createCell()
	local cell = AdventureAnnounceListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end