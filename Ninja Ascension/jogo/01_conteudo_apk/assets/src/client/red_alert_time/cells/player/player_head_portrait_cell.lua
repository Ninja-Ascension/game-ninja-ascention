----------------------------------------------------------------------------------------------------
-- 说明：玩家头像列表框
-------------------------------------------------------------------------------------------------------
PlayerHeadPortraitCell = class("PlayerHeadPortraitCellClass", Window)
PlayerHeadPortraitCell.__size = nil

local player_head_portrait_cell_terminal = {
    _name = "player_head_portrait_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PlayerHeadPortraitCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(player_head_portrait_cell_terminal)
state_machine.init()

function PlayerHeadPortraitCell:ctor()
    self.super:ctor()
	self.roots = {}		

    self._info = nil
	self._sort = 0
	self._paging = 0

	
	app.load("client.red_alert_time.cells.worldMap.player_head_icon")
	app.load("client.red_alert_time.cells.player.player_head_change_icon_cell")
	app.load("client.red_alert_time.cells.player.player_ornaments_change_icon_cell")
	
 	local function init_player_skill_upgrade_cell_terminal()

        state_machine.init()
    end
	init_player_skill_upgrade_cell_terminal()        	
end


function PlayerHeadPortraitCell:onUpdateDraw()
	local root = self.roots[1]
	local Text_head_type = ccui.Helper:seekWidgetByName(root,"Text_head_type")
	Text_head_type:setString(avatar_use_text[self._sort])
	local Image_head_type_list_box = ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box")
	local Image_head_typetitle_bg = ccui.Helper:seekWidgetByName(root,"Image_head_typetitle_bg")
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_head_icon")

	m_ScrollView:removeAllChildren(true)
	local panel = ccui.Layout:create()
	panel:setContentSize(m_ScrollView:getContentSize())
	panel:setName("cellPanel")
	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)
	m_ScrollView:addChild(panel)
	local height = m_ScrollView:getContentSize().height + 20
	local avatarMonth = dms.searchs(dms["avatar_head"], avatar_head.sort, self._sort-1)
	local number = #avatarMonth
	if number/4 > 0 then
		height = math.ceil(number/4)*height
	else
		height = height
	end
	local upHeight = 0 
	panel:setContentSize(cc.size(m_ScrollView:getContentSize().width, height))
	if height > m_ScrollView:getContentSize().height then
		upHeight = height - m_ScrollView:getContentSize().height
		Image_head_type_list_box:setContentSize(cc.size(Image_head_type_list_box:getContentSize().width, Image_head_type_list_box:getContentSize().height+upHeight))
		-- PlayerHeadPortraitCell.__size = Image_head_type_list_box:getContentSize()
		self:setContentSize(PlayerHeadPortraitCell.__size.width, PlayerHeadPortraitCell.__size.height + upHeight)
		Image_head_type_list_box:setPositionY(Image_head_type_list_box:getPositionY()+upHeight)
		Image_head_typetitle_bg:setPositionY(Image_head_typetitle_bg:getPositionY()+upHeight)
		Text_head_type:setPositionY(Text_head_type:getPositionY()+upHeight)
		m_ScrollView:setContentSize(panel:getContentSize())
		m_ScrollView:setPositionY(m_ScrollView:getPositionY()+upHeight)
	-- else
		-- Image_head_type_list_box:setContentSize(cc.size(Image_head_type_list_box:getContentSize().width, Image_head_type_list_box:getContentSize().height))
		-- PlayerHeadPortraitCell.__size = Image_head_type_list_box:getContentSize()
		-- Image_head_type_list_box:setPositionY(Image_head_type_list_box:getPositionY())
		-- Image_head_typetitle_bg:setPositionY(Image_head_typetitle_bg:getPositionY())
		-- Text_head_type:setPositionY(Text_head_type:getPositionY())
		-- m_ScrollView:setContentSize(panel:getContentSize())
		-- m_ScrollView:setPositionY(m_ScrollView:getPositionY())
	end
	
	local sSize = panel:getContentSize()
	local controlSize = m_ScrollView:getContentSize()
	local cellWidth = sSize.width / 4
	
	for i = 1, #avatarMonth do
		local cell = nil
		if tonumber(self._paging) == 0 then
			cell = state_machine.excute("player_head_change_icon_cell",0,avatarMonth[i])
		elseif tonumber(self._paging) == 1 then
			cell = state_machine.excute("player_ornaments_change_icon_cell",0,avatarMonth[i])
		end
		-- cell:init(avatarMonth[i])
		cell:setTag(avatarMonth[i][1])

		local cellHeight = cell:getContentSize().height + 20
		local row = math.floor((i - 1) / 4 + 1)
		local col = math.floor((i - 1) % 4)
		local controlHeight = row * cellHeight
		if controlHeight < sSize.height then
			controlSize.height = sSize.height
		else
			controlSize.height = controlHeight
		end
		m_ScrollView:setContentSize(cc.size(controlSize.width, controlSize.height))
		local pos = cc.p(cellWidth * col + (cellWidth - cell:getContentSize().width)/2,sSize.height - cellHeight * row + 10)
		cell:setPosition(pos)
		cell.panel = panel
		panel:addChild(cell)
	end
	-- m_ScrollView:setEnabled(false)
	m_ScrollView:setInnerContainerSize(m_ScrollView:getContentSize())
end

function PlayerHeadPortraitCell:onEnterTransitionFinish()

end

function PlayerHeadPortraitCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.player.player_head_change_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if PlayerHeadPortraitCell.__size == nil then
		PlayerHeadPortraitCell.__size = root:getContentSize()
	end
	self:setContentSize(PlayerHeadPortraitCell.__size)
	
	if ccui.Helper:seekWidgetByName(root,"Text_head_type")._size == nil then
		ccui.Helper:seekWidgetByName(root,"Text_head_type")._size = ccui.Helper:seekWidgetByName(root,"Text_head_type"):getContentSize()
	end
	if ccui.Helper:seekWidgetByName(root,"Text_head_type")._y == nil then
		ccui.Helper:seekWidgetByName(root,"Text_head_type")._y = ccui.Helper:seekWidgetByName(root,"Text_head_type"):getPositionY()
	end
	if ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box")._size == nil then
		ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box")._size = ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box"):getContentSize()
	end
	if ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box")._y == nil then
		ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box")._y = ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box"):getPositionY()
	end
	if ccui.Helper:seekWidgetByName(root,"Image_head_typetitle_bg")._size == nil then
		ccui.Helper:seekWidgetByName(root,"Image_head_typetitle_bg")._size = ccui.Helper:seekWidgetByName(root,"Image_head_typetitle_bg"):getContentSize()
	end
	if ccui.Helper:seekWidgetByName(root,"Image_head_typetitle_bg")._y == nil then
		ccui.Helper:seekWidgetByName(root,"Image_head_typetitle_bg")._y = ccui.Helper:seekWidgetByName(root,"Image_head_typetitle_bg"):getPositionY()
	end
	if ccui.Helper:seekWidgetByName(root, "ScrollView_head_icon")._size == nil then
		ccui.Helper:seekWidgetByName(root, "ScrollView_head_icon")._size = ccui.Helper:seekWidgetByName(root, "ScrollView_head_icon"):getContentSize()
	end
	if ccui.Helper:seekWidgetByName(root, "ScrollView_head_icon")._y == nil then
		ccui.Helper:seekWidgetByName(root, "ScrollView_head_icon")._y = ccui.Helper:seekWidgetByName(root, "ScrollView_head_icon"):getPositionY()
	end
	
	ccui.Helper:seekWidgetByName(root,"Text_head_type"):setContentSize(ccui.Helper:seekWidgetByName(root,"Text_head_type")._size)
	ccui.Helper:seekWidgetByName(root,"Text_head_type"):setPositionY(ccui.Helper:seekWidgetByName(root,"Text_head_type")._y)
	ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box"):setContentSize(ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box")._size)
	ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box"):setPositionY(ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box")._y)
	-- PlayerHeadPortraitCell.__size = ccui.Helper:seekWidgetByName(root,"Image_head_type_list_box"):getContentSize()
	-- root:setContentSize(PlayerHeadPortraitCell.__size)
	ccui.Helper:seekWidgetByName(root,"Image_head_typetitle_bg"):setContentSize(ccui.Helper:seekWidgetByName(root,"Image_head_typetitle_bg")._size)
	ccui.Helper:seekWidgetByName(root,"Image_head_typetitle_bg"):setPositionY(ccui.Helper:seekWidgetByName(root,"Image_head_typetitle_bg")._y)
	ccui.Helper:seekWidgetByName(root, "ScrollView_head_icon"):setContentSize(ccui.Helper:seekWidgetByName(root, "ScrollView_head_icon")._size)
	ccui.Helper:seekWidgetByName(root, "ScrollView_head_icon"):setPositionY(ccui.Helper:seekWidgetByName(root, "ScrollView_head_icon")._y)
	
	-- if _ED.play_head_port == nil or _ED.play_head_port == "" then
		-- _ED.play_head_port = {}
		-- _ED.play_head_port.Text_size = Text_head_type:getContentSize()
		-- _ED.play_head_port.Text_point_x,_ED.play_head_port.Text_point_y = Text_head_type:getPosition()
		-- _ED.play_head_port.root_size = root:getContentSize()
		-- _ED.play_head_port.Image_box_size = Image_head_type_list_box:getContentSize()
		-- _ED.play_head_port.Image_box_point_x,_ED.play_head_port.Image_box_point_y = Image_head_type_list_box:getPosition()
		-- _ED.play_head_port.Image_bg_size = Image_head_typetitle_bg:getContentSize()
		-- _ED.play_head_port.Image_bg_point_x,_ED.play_head_port.Image_bg_point_y = Image_head_typetitle_bg:getPosition()
		-- _ED.play_head_port.scroll_size = m_ScrollView:getContentSize()
		-- _ED.play_head_port.scroll_point_x, _ED.play_head_port.scroll_point_y= m_ScrollView:getPosition()
	-- else
		-- Text_head_type:setContentSize(_ED.play_head_port.Text_size)
		-- Text_head_type:setPosition(cc.p(_ED.play_head_port.Text_point_x,_ED.play_head_port.Text_point_y))
		-- Image_head_type_list_box:setContentSize(_ED.play_head_port.Image_box_size)
		-- Image_head_type_list_box:setPosition(cc.p(_ED.play_head_port.Image_box_point_x,_ED.play_head_port.Image_box_point_y))
		-- Image_head_typetitle_bg:setContentSize(_ED.play_head_port.Image_bg_size)
		-- Image_head_typetitle_bg:setPosition(cc.p(_ED.play_head_port.Image_bg_point_x,_ED.play_head_port.Image_bg_point_y))
		-- m_ScrollView:setContentSize(_ED.play_head_port.scroll_size)
		-- m_ScrollView:setPosition(cc.p(_ED.play_head_port.scroll_point_x,_ED.play_head_port.scroll_point_y))
	-- end

	self:onUpdateDraw()
end

function PlayerHeadPortraitCell:onExit()
    local root = self.roots[1]
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_head_icon")
	if m_ScrollView ~= nil then
		m_ScrollView:removeAllChildren(true)
	end
	cacher.freeRef(config_csb.cells.player.player_head_change_cell, root)
end

function PlayerHeadPortraitCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function PlayerHeadPortraitCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef(config_csb.cells.player.player_head_change_cell, root)
	root:removeFromParent(false)
	self.roots = {}
end

function PlayerHeadPortraitCell:init(params)
	self._sort = tonumber(params[1])
	self._paging = tonumber(params[2])
	self:unload()
    self:onInit()
	-- self:setContentSize(PlayerHeadPortraitCell.__size)
end

