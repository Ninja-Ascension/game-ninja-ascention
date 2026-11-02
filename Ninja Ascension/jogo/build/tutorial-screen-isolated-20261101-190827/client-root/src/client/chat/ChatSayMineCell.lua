----------------------------------------------------------------------------------------------------
-- 说明：聊天主界面cell
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ChatSayMineCell = class("ChatSayMineCellClass", Window)
ChatSayMineCell.__size = nil

function ChatSayMineCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.personId = nil
	self.info = nil
	self.isVip = nil
	self.name = nil
	self.quality = nil
	self.pic = nil
	self.myPic = nil
	self.str = nil
	self.picNum = 0
	self.str2 = nil
	self.message = nil
	self.notificationId = 0
	self.jumpParams = nil
    -- Initialize ChatStorage page state machine.
    local function init_chat_say_mine_cell_terminal()
		--返回home界面
		local chat_say_mine_cell_click_head_terminal = {
            _name = "chat_say_mine_cell_click_head",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				TipDlg.drawTextDailog(_string_piece_info[258])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 加入试炼队伍
       	local chat_say_mine_cell_join_purify_team_terminal = {
            _name = "chat_say_mine_cell_join_purify_team",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
            	if true == funOpenDrawTip(93) then
                    return false
                end
                --如果没有对应的净化武将
                local shipId = tonumber(cell.message.team_ship_mould)
                if fundShipWidthTemplateId(shipId) == nil then
                	TipDlg.drawTextDailog(_new_interface_text[123])
                	return
                end
                -- 是否已加入队伍
                if _ED.digital_purify_info ~= nil 
			    	and _ED.digital_purify_info._team_info ~= nil 
			    	and _ED.digital_purify_info._team_info.team_type ~= nil
			    	and _ED.digital_purify_info._team_info.team_type >= 0 
			    	then
			    	TipDlg.drawTextDailog(_new_interface_text[124])
                	return
	            end

                local function responseDigitalPurifyTeamJoinCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	app.load("client.l_digital.explore.ExploreWindow")
                    	state_machine.excute("chat_return_home_page",0,false)
                    	state_machine.excute("explore_window_open", 0, "3")
                    	-- state_machine.excute("explore_window_open_fun_window", 0, { _datas = {page_index = 3} })
                    end
                end
                protocol_command.ship_purify_team_manager.param_list = "1\r\n" .. cell.message.team_type .. "\r\n".. cell.message.team_key .. "\r\n"
                NetworkManager:register(protocol_command.ship_purify_team_manager.code, nil, nil, nil, cell, responseDigitalPurifyTeamJoinCallback, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local chat_say_mine_cell_jump_terminal = {
            _name = "chat_say_mine_cell_jump",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
            	if zstring.tonumber(cell.notificationId) > 0 then
        			local jump_type = dms.int(dms["message_notification_param"], cell.notificationId, message_notification_param.jump_type)
					if jump_type > 0 then
						if cell.jumpParams ~= nil then
						else	
	                		state_machine.excute("short_cut_go_to_other_window", 0, {jump_type})
						end
					end
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(chat_say_mine_cell_join_purify_team_terminal)
		state_machine.add(chat_say_mine_cell_click_head_terminal)
		state_machine.add(chat_say_mine_cell_jump_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_chat_say_mine_cell_terminal()
end

function ChatSayMineCell:onHeadDraw()
	-- local csbItem = csb.createNode("icon/item.csb")
	-- local roots = csbItem:getChildByName("root")
	local roots = cacher.createUIRef("icon/item.csb", "root")
	table.insert(self.roots, roots)
	roots:removeFromParent(true)
	if roots._x == nil then
		roots._x = 0
	end
	if roots._y == nil then
		roots._x = 0
	end
	local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
	local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if Panel_head ~= nil then
	        Panel_head:removeAllChildren(true)
	        Panel_head:removeBackGroundImage()
	    end
	    if Panel_kuang ~= nil then
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
    end
	local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(self.quality)+1)
	local big_icon_path = string.format("images/ui/props/props_%s.png", self.pic)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if tonumber(self.isVip) > 0 then
			quality_path = "images/ui/quality/icon_enemy_5.png"
		else
			quality_path = "images/ui/quality/icon_enemy_1.png"
		end
		--big_icon_path = string.format("images/ui/home/head_%s.png", self.pic)
		if tonumber(self.pic) < 9 then
	        big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(self.pic))
	    else
	        big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(self.pic))
	    end
	else
		if tonumber(self.isVip) > 0 then
			ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(true)
		end
	end
	fwin:addTouchEventListener(Panel_head, nil, 
	{
		terminal_name = "chat_say_mine_cell_click_head", 	
		_id = self.personId,
		terminal_state = 0,
	}, 
	nil, 0)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		Panel_kuang:setBackGroundImage(big_icon_path)
		Panel_head:setBackGroundImage(quality_path)
	else
		Panel_kuang:setBackGroundImage(quality_path)
		Panel_head:setBackGroundImage(big_icon_path)
	end
	return roots
end

function ChatSayMineCell:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = _ED.user_info.head_frame.curHeadFrameID,
        headFrameStage = _ED.user_info.head_frame.curHeadFrameStage,
        headID = _ED.user_info.user_head,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function ChatSayMineCell:drawHead()
    local root = self.roots[1]
    --头像
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_3_4")
    Panel_player_icon:removeBackGroundImage()
    Panel_player_icon:removeAllChildren(true)

	-- 新增头像框
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
	if fun_is_open == true then
		local headIcon = self:getNewHeadIcon()
		if headIcon ~= nil then
			Panel_player_icon:addChild(headIcon)
		end
	else
		local quality_path = ""
		if tonumber(self.isVip) > 0 then
			quality_path = "images/ui/quality/player_1.png"
		else
			quality_path = "images/ui/quality/player_2.png"
		end
		local SpritKuang = cc.Sprite:create(quality_path)
		SpritKuang:setAnchorPoint(cc.p(0.5,0.5))
		SpritKuang:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
		Panel_player_icon:addChild(SpritKuang,0)
	
		local big_icon_path = ""
		local pic = tonumber(_ED.user_info.user_head)
		if tonumber(pic) >= 9 then
			big_icon_path = string.format("images/ui/props/props_%d.png", pic)
		else
			big_icon_path = string.format("images/ui/home/head_%d.png", pic)
		end
		local sprit = cc.Sprite:create(big_icon_path)
		sprit:setAnchorPoint(cc.p(0.5,0.5))
		sprit:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
		Panel_player_icon:addChild(sprit,0)
	end
end

function ChatSayMineCell:onUpdateDrawSm()
	local root = self.roots[1]
	local Text_103_0_4 = ccui.Helper:seekWidgetByName(root, "Text_103_0_4")
	local Panel_chat_2_5 = ccui.Helper:seekWidgetByName(root, "Panel_chat_2_5")
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_103_name_2")
	local imageOne = ccui.Helper:seekWidgetByName(root, "Image_135_0_4")
	local imageTwo = ccui.Helper:seekWidgetByName(root, "Image_135_2")
	-- local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_3_4")
	local Panel_chat_channel = ccui.Helper:seekWidgetByName(root, "Panel_chat_channel")
	local Panel_16 = ccui.Helper:seekWidgetByName(root, "Panel_16")
	local Image_chat_vip_icon = ccui.Helper:seekWidgetByName(root, "Image_chat_vip_icon")
	local AtlasLabel_chat_vip_n = ccui.Helper:seekWidgetByName(root, "AtlasLabel_chat_vip_n")
	local Text_103_sent = ccui.Helper:seekWidgetByName(root, "Text_103_sent")
	nameText.__positionX = nameText:getPositionX()
	AtlasLabel_chat_vip_n.__positionX = AtlasLabel_chat_vip_n:getPositionX()
	Image_chat_vip_icon.__positionX = Image_chat_vip_icon:getPositionX()
	imageOne.__contentSize = imageOne:getContentSize()
	nameText:setString(self.name)
	nameText:removeAllChildren(true)
	-- panelHead:removeAllChildren(true)
	Text_103_sent:setVisible(false)
	-- nameText:setPositionX(nameText:getPositionX() - 3)

	-- En el susurro propio la cabecera pinta el nombre del DESTINATARIO
	-- (mas abajo), asi que el VIP que va a su lado tiene que ser el suyo:
	-- `receiver_vip_level` del S2C 14000 (ProtocolParserCopyExx.lua:9773),
	-- no `vip_level`, que es el del que escribe.
	local isVip = self.isVip
	if self.message ~= nil and tonumber(self.message.information_type) == 4
		and self.message.receiver_vip_level ~= nil then
		isVip = self.message.receiver_vip_level
	end
	if zstring.tonumber(isVip) > 0 then
		AtlasLabel_chat_vip_n:setString(tostring(isVip))
		-- AtlasLabel_chat_vip_n:setPositionX(nameText:getPositionX() - nameText:getContentSize().width - AtlasLabel_chat_vip_n:getContentSize().width - 3)
		AtlasLabel_chat_vip_n:setPositionX(Panel_chat_channel:getPositionX() - AtlasLabel_chat_vip_n:getContentSize().width - 3)
		Image_chat_vip_icon:setPositionX(AtlasLabel_chat_vip_n:getPositionX() - Image_chat_vip_icon:getContentSize().width/2 )
	else
		Image_chat_vip_icon:setVisible(false)
		AtlasLabel_chat_vip_n:setVisible(false)
	end
	if self.message.information_type == 4 then
		nameText:setString(self.message.receiver_nickname)
		nameText:setPositionX(Image_chat_vip_icon:getPositionX() - 15)
		Text_103_sent:setVisible(true)
		Text_103_sent:setPositionX(nameText:getPositionX() - nameText:getContentSize().width - 10)
	else
		nameText:setPositionX(Image_chat_vip_icon:getPositionX() - 15)
	end

	local Panel_title_view = ccui.Helper:seekWidgetByName(root, "Panel_title_view")
	if nil ~= Panel_title_view then
		local titleIndex = tonumber(self.message.send_information_rank_title_name)
		if nil ~= titleIndex and titleIndex > 0 then
			Panel_title_view:setVisible(true)
			Panel_title_view:setBackGroundImage(string.format("images/ui/text/title/title_%s.png", dms.string(dms["title_param"], titleIndex, title_param.pic_index)))
			Panel_title_view:setPositionX((nameText:getPositionX() - nameText:getContentSize().width * nameText:getAnchorPoint().x) - (Panel_title_view:getContentSize().width * Panel_title_view:getScaleX() * Panel_title_view:getAnchorPoint().x))

			Text_103_sent:setPositionX(Panel_title_view:getPositionX() - (Panel_title_view:getContentSize().width * Panel_title_view:getScaleX() * Panel_title_view:getAnchorPoint().x) - 10)
		else
			Panel_title_view:setVisible(false)
		end
	end

	-- panelHead:addChild(self:onHeadDraw())
	self:drawHead()
	imageOne:setVisible(true)
	imageTwo:setVisible(false)
	local _chat_image_type = tonumber(self.infor_type)
	if _chat_image_type == 5 then
		_chat_image_type = 1
	elseif _chat_image_type == 6 then
		_chat_image_type = 2
	end
	Panel_chat_channel:setBackGroundImage(string.format("images/ui/text/chat/chat_channel_%d.png", tonumber(_chat_image_type)))

	-- if tonumber(self.infor_type) == 3 then
	-- 	AtlasLabel_chat_vip_n:setVisible(false)
	-- 	Image_chat_vip_icon:setVisible(false)
	-- 	nameText:setString("待添加")
	-- 	Text_103_sent:setVisible(true)
	-- 	Text_103_sent:setPositionX(nameText:getPositionX() - nameText:getContentSize().width - 3)
	-- else
		-- Text_103_sent:setVisible(false)
	--end

	local index = 0
	local _richText2 = ccui.RichText:create()
	_richText2:ignoreContentAdaptWithSize(false)
	if tonumber(self.infor_type) == 5 or tonumber(self.infor_type) == 6 then

		local richTextWidth = Panel_16:getContentSize().width
        if richTextWidth == 0 then
	        richTextWidth = Text_103_0_4:getFontSize() * 6
	    end

		_richText2:setContentSize(cc.size(richTextWidth, 0))
	else
		_richText2:setContentSize(cc.size(Panel_16:getContentSize().width+Text_103_0_4:getFontSize()*5, 0))
	end
	_richText2:setAnchorPoint(cc.p(0, 0))
	local char_str = self.info

	local max_width = 0
    if _ED.is_can_use_formatTextExt == false then
        Text_103_0_4:setString(char_str)
        max_width = Text_103_0_4:getAutoRenderSize().width
    end
    Text_103_0_4:setString("")
    if tonumber(self.infor_type) == 5 or tonumber(self.infor_type) == 6 then
	    char_str = smWidthSingle(char_str,Text_103_0_4:getFontSize()/2,Panel_16:getContentSize().width)
	else
		char_str = smWidthSingle(char_str,Text_103_0_4:getFontSize()/2,Panel_16:getContentSize().width+Text_103_0_4:getFontSize()*5)
	end

   	if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    	color_Type_1 = cc.c3b(255, 255, 255)
    	color_Type_2 = cc.c3b(255, 255, 255)
    elseif __lua_project_id == __lua_project_l_digital then 
		-- DSC重塑
		color_Type_1 = Text_103_0_4:getColor()
		color_Type_2 = Text_103_0_4:getColor()
	else
    	color_Type_1 = cc.c3b(189, 206, 224)
    	color_Type_2 = cc.c3b(189, 206, 224)
    end

	local rt, count, text = draw.richTextCollectionMethod(_richText2, 
	char_str, 
	color_Type_1,
	color_Type_2,
	0, 
	0, 
	"", 
	Text_103_0_4:getFontSize(),
	chat_rich_text_color)
	if _ED.is_can_use_formatTextExt == false then
		_richText2:setPositionX(_richText2:getPositionX() - _richText2:getContentSize().width / 2)
    else
        _richText2:formatTextExt()
    end
	local rsize = _richText2:getContentSize()
	_richText2:setPositionY(Text_103_0_4:getPositionY() - Panel_16:getContentSize().height + 7)
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		_richText2:setPositionX(_richText2:getPositionX() - rsize.width + 25- Text_103_0_4:getFontSize())
	else
		_richText2:setPositionX(_richText2:getPositionX() - rsize.width + 10-Text_103_0_4:getFontSize())
	end
	Text_103_0_4:addChild(_richText2)
	index = index + rsize.height
	imageOne:setContentSize(cc.size(rsize.width + 20+Text_103_0_4:getFontSize(), rsize.height+Text_103_0_4:getFontSize()/2))
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		Panel_chat_2_5.__positionY = Panel_chat_2_5:getPositionY()
		root.__positionY = root:getPositionY()
		local addNum = imageOne:getContentSize().height - imageOne.__contentSize.height > 0 and imageOne:getContentSize().height - imageOne.__contentSize.height or 0
		root:setContentSize(cc.size(root:getContentSize().width,root:getContentSize().height + addNum ))
		Panel_chat_2_5:setPositionY(Panel_chat_2_5:getPositionY()+addNum)
		root:setPositionY(root:getPositionY()+addNum)
		self:setContentSize(root:getContentSize())
	else
		self:setContentSize(Panel_chat_2_5:getContentSize())
	end

	if ChatSayMineCell.__size == nil then
        ChatSayMineCell.__size = self:getContentSize()
    end
	--如果formatTextExt不能用 重新计算高度和位置
    if _ED.is_can_use_formatTextExt == false then
        local heightN = math.ceil( max_width / tonumber(_richText2:getContentSize().width))
        local height = heightN * 21
        imageOne:setContentSize(cc.size(imageOne:getContentSize().width , height))
        if max_width < tonumber(_richText2:getContentSize().width) then
        	_richText2:setPositionX(_richText2:getPositionX() + _richText2:getContentSize().width - max_width)
        	imageOne:setContentSize(cc.size(imageOne:getContentSize().width - _richText2:getContentSize().width + max_width, height))
        end
    end
	-- DSC背景图片大小
	if __lua_project_id == __lua_project_l_digital then
		local imageMaxWidth = 453
		if imageOne:getContentSize().width >=imageMaxWidth then
			imageOne:setContentSize(cc.size(imageMaxWidth,imageOne:getContentSize().height))
		end
	end
    local Button_chat_team_join = ccui.Helper:seekWidgetByName(root, "Button_chat_team_join") --队伍申请
	Button_chat_team_join:setVisible(false)
	--local Button_chat_legion_join = ccui.Helper:seekWidgetByName(root, "Button_chat_legion_join") --公会申请
	--Button_chat_legion_join:setVisible(false)
	if tonumber(self.infor_type) == 5 or tonumber(self.infor_type) == 6 then
		Button_chat_team_join:setVisible(true)
	end
end

function ChatSayMineCell:onUpdateDraw()
	local root = self.roots[1]
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_103_name_2")
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_16")
	local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_3_4")
	local yuandian = ccui.Helper:seekWidgetByName(root, "Text_103_0_4")
	local panel_chat_2 = ccui.Helper:seekWidgetByName(root, "Panel_chat_2_5")
	local infoText = ccui.Helper:seekWidgetByName(root, "Text_103_0_4_0")
	local imageOne = ccui.Helper:seekWidgetByName(root, "Image_135_2")
	local imageTwo = ccui.Helper:seekWidgetByName(root, "Image_135_0_4")
	if tonumber(self.isVip) > 0 then 
		imageOne:setVisible(true)
	else
		imageTwo:setVisible(true)
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then 
	else
		nameText:setColor(cc.c3b(color_Type[tonumber(self.quality)+1][1],color_Type[tonumber(self.quality)+1][2],color_Type[tonumber(self.quality)+1][3]))
	end
	nameText:setString(self.name)
	panelHead:addChild(self:onHeadDraw())
	
	local infoWidth = infoText:getPositionX()
	local yuandianWidth = yuandian:getPositionX()
	local width = infoText:getContentSize().width
	local infoHeight = infoText:getPositionY()
	local shiPartnerHigh = panel:getPositionY()
	local shiPartnerWidth = panel:getPositionX()
	local imageOneX = imageOne:getPositionX()
	local imageOneY = imageOne:getPositionY()
	local imageTwoX = imageTwo:getPositionX()
	local imageTwoY = imageTwo:getPositionY()
	local allSize = imageOne:getContentSize().height
	label_UI = nil
	if ___is_open_leadname == true then
		label_UI = csb.createNode("utils/version_length_0.csb")
	else
		label_UI = csb.createNode("utils/version_length.csb")
	end
	local label_root = label_UI:getChildByName("root")
	local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
	
	local tipHeight = 0
	local _richText = ccui.RichText:create()
	_richText:ignoreContentAdaptWithSize(false)
	_richText:setContentSize(cc.size(width, 0))
	local num = 0
	self.picNum = 0
	local heightNum = 1
	local length = 0
	local first = {}
	local forNum = 1
	local l = string.len(self.info)
	while l >= 1 do
		local f,e = string.find(self.info, "/%d+|")
		if f == nil then
			self.str = self.info
			local re1 = nil
			if tonumber(getDefaultLanguage()) ~= nil and tonumber(getDefaultLanguage()) == 0 then
				re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
				255, self.str, lableCell:getFontName(), lableCell:getFontSize())
			else
				re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
				255, self.str, "", lableCell:getFontSize())
			end
			_richText:pushBackElement(re1)
			num = num + string.utf8len(self.str)
			length = length + string.utf8len(self.str) *20
			while length > 340 do
				length = length - 340
				heightNum = heightNum + 1
				if first[forNum] ~= false then
					first[forNum] = true
				end
				forNum = forNum + 1
			end
			if length> 0 and self.str ~= nil and self.str ~= "" then
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
			local info = string.sub(self.info, 1, f-1)
			num = num + string.utf8len(info)
			local re1 = nil
			if tonumber(getDefaultLanguage()) ~= nil and tonumber(getDefaultLanguage()) == 0 then
				re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
				255, info, lableCell:getFontName(), lableCell:getFontSize())
			else
				re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
				255, info, "", lableCell:getFontSize())
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
		self.picNum = self.picNum + 1
		first[forNum] = false
		if 60 + length >= 320 then
			heightNum = heightNum + 1
			length = length + 60 - 320
			forNum = forNum + 1
			first[forNum] = false
		else
			length = length + 60
		end
		
		local pic = string.sub(self.info, f+1, e-1)
		
		
		if tonumber(pic) ~= nil then
			
			local img = tonumber(pic) - 100
			if img > 0 and  img < 28 then
				local path = string.format("images/ui/biaoqing/%d.png", img)
				local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, path)
				_richText:pushBackElement(reimg)
			
			else
				local info = string.sub(self.info, f, e)
				num = num + string.utf8len(info)
				local re1 = nil
				if tonumber(getDefaultLanguage()) ~= nil and tonumber(getDefaultLanguage()) == 0 then
					re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
					255, info, lableCell:getFontName(), lableCell:getFontSize())
				else
					re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
					255, info, "", lableCell:getFontSize())
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
		self.info = string.sub(self.info, e+1, l)
		l = string.len(self.info)
		-- local reimg = ccui.RichElementImage:create(2, cc.c3b(255, 255, 255), 255, string.format("images/ui/biaoqing/%d.png", tonumber(pic)-100))
		-- _richText:pushBackElement(reimg)
		-- self.info = string.sub(self.info, e+1, l)
		-- l = string.len(self.info)
    end

	panel:addChild(_richText)
	_richText:setAnchorPoint(CCPoint(0, 1))
	if heightNum == 1 then
		if first[heightNum] == true or self.picNum == 0 then
			imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ num*20-150+self.picNum*60,imageOne:getContentSize().height))
			imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ num*20-150+self.picNum*60,imageTwo:getContentSize().height))
			tipHeight = tipHeight + 20
			_richText:setPosition(cc.p(- num*20-self.picNum*60+150, -1 * tipHeight-6))
		else
			imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ num*20-150+self.picNum*60,60))
			imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ num*20-150+self.picNum*60,60))
			tipHeight = tipHeight + 60
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				_richText:setPosition(cc.p(- num*20-self.picNum*60+150+10, -1 * tipHeight+5))
			elseif __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_warship_girl_b 
				then 
				local _x = - num*20-self.picNum*60+150 + 10
				local _y = -1 * tipHeight+5
				_richText:setPosition(cc.p(_x,_y ))
				imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ num*20-150+self.picNum*60,80))
				imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ num*20-150+self.picNum*60,80))
			else
				_richText:setPosition(cc.p(- num*20-self.picNum*60+150, -1 * tipHeight+5))
			end
		end
	end
	local statuse = false
	if heightNum > 1 then
		for i=1, heightNum do
			if first[i] == true or self.picNum == 0 or first[i] == nil then
				if i > 2 then
					imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ 340-150,imageOne:getContentSize().height+18))
					imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ 340-150,imageTwo:getContentSize().height+18))
					tipHeight = tipHeight + 20
				else
					if statuse == true then
						imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ 340-150,imageOne:getContentSize().height+18))
						imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ 340-150,imageTwo:getContentSize().height+18))
						tipHeight = tipHeight + 20
					else
						imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ 340-150,imageOne:getContentSize().height))
						imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ 340-150,imageTwo:getContentSize().height))
					end
				end
			else
				if i > 1 then
					imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ 340-150,imageOne:getContentSize().height+70))
					imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ 340-150,imageTwo:getContentSize().height+70))
					tipHeight = tipHeight + 60
				else
					imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ 340-150,imageOne:getContentSize().height))
					imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ 340-150,imageTwo:getContentSize().height))
				end
				statuse = true
			end
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		_richText:setPosition(cc.p(- 340+150+10, -1 * tipHeight+5))
		else
		_richText:setPosition(cc.p(- 340+150, -1 * tipHeight+5))
		end

		
	end
	if imageOne:getContentSize().width >=350 and imageTwo:getContentSize().width>=350 then
		imageOne:setContentSize(cc.size(350,imageOne:getContentSize().height))
		imageTwo:setContentSize(cc.size(350,imageOne:getContentSize().height))
	end
	
	if imageOne:getContentSize().width <=40 and imageTwo:getContentSize().width<=40 then
		imageOne:setContentSize(cc.size(40,imageOne:getContentSize().height))
		imageTwo:setContentSize(cc.size(40,imageOne:getContentSize().height))
	end
	
	panel_chat_2:setPosition(cc.p(panel_chat_2:getPositionX(), panel_chat_2:getPositionY()+imageOne:getContentSize().height-allSize))
	panel_chat_2:setContentSize(cc.size(panel_chat_2:getContentSize().width,panel_chat_2:getContentSize().height+imageOne:getContentSize().height-allSize))
	self:setContentSize(panel_chat_2:getContentSize())
	panel:setPosition(shiPartnerWidth,shiPartnerHigh+tipHeight+50)
	if ChatSayMineCell.__size == nil then
        ChatSayMineCell.__size = self:getContentSize()
    end
end

function ChatSayMineCell:onEnterTransitionFinish()
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		root = cacher.createUIRef("Chat/chat_list_2.csb", "root")
	else
	    local csbChatStorage = csb.createNode("Chat/chat_list_2.csb")
		root = csbChatStorage:getChildByName("root")
	end
	table.insert(self.roots, root)
	root:removeFromParent(false)	
	self:addChild(root)
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then 
		root.__contentSize = root:getContentSize()
		self:setContentSize(root.__contentSize)
	end

	self.__contentSize = self:getContentSize()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self:onUpdateDrawSm()

	else
		self:onUpdateDraw()
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_team_join"), nil, 
    {
        terminal_name = "chat_say_mine_cell_join_purify_team", 
        terminal_state = 0,
        _cell = self,
        isPressedActionEnabled = true,
    })
end

function ChatSayMineCell:clearUIInfo( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
	    local root = self.roots[1]
    	local panel = ccui.Helper:seekWidgetByName(root, "Panel_16")
		local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_3_4")
		local Text_103_0_4 = ccui.Helper:seekWidgetByName(root, "Text_103_0_4")
		local nameText = ccui.Helper:seekWidgetByName(root, "Text_103_name_2")
		local AtlasLabel_chat_vip_n = ccui.Helper:seekWidgetByName(root, "AtlasLabel_chat_vip_n")
		local imageOne = ccui.Helper:seekWidgetByName(root, "Image_135_0_4")
		local Image_chat_vip_icon = ccui.Helper:seekWidgetByName(root, "Image_chat_vip_icon")
		local Panel_chat_channel = ccui.Helper:seekWidgetByName(root, "Panel_chat_channel")
		-- DSC重塑
		local Panel_chat_2_5 = ccui.Helper:seekWidgetByName(root, "Panel_chat_2_5")
		if root.__positionY and root.__contentSize then 
			root:setPositionY(root.__positionY)
			root:setContentSize(root.__contentSize)
		end
		if Panel_chat_2_5 and Panel_chat_2_5.__positionY then 
			Panel_chat_2_5:setPositionY(Panel_chat_2_5.__positionY) 
		end
		
		if panel ~= nil then
			panel:removeAllChildren(true)
		end
		if panelHead ~= nil then
			panelHead:removeAllChildren(true)
		end
		if Text_103_0_4 ~= nil then
			Text_103_0_4:removeAllChildren(true)
		end
		if nameText ~= nil and nameText.__positionX ~= nil then
			nameText:setPositionX(nameText.__positionX)
		end
		if AtlasLabel_chat_vip_n ~= nil and AtlasLabel_chat_vip_n.__positionX ~= nil then
			AtlasLabel_chat_vip_n:setPositionX(AtlasLabel_chat_vip_n.__positionX)
		end
		if Image_chat_vip_icon ~= nil and Image_chat_vip_icon.__positionX ~= nil then
			Image_chat_vip_icon:setPositionX(Image_chat_vip_icon.__positionX)
		end
		if imageOne ~= nil and imageOne.__contentSize ~= nil then
			imageOne:setContentSize(imageOne.__contentSize)
		end
		if Panel_chat_channel ~= nil then
			Panel_chat_channel:removeBackGroundImage()
		end
		if self.__contentSize ~= nil then
			self:setContentSize(self.__contentSize)
		end
		if ChatSayMineCell.__size == nil then
	        ChatSayMineCell.__size = self:getContentSize()
	    end
		self.notificationId = 0
		self.jumpParams = nil
	end
end

function ChatSayMineCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("Chat/chat_list_2.csb", self.roots[1])
	state_machine.remove("chat_say_mine_cell_click_head")
	state_machine.remove("chat_say_mine_cell_join_purify_team")
end

function ChatSayMineCell:init(personId, name, info, isVip ,quality, pic, infor_type , message)
	self.personId = personId
	self.name = name
	self.info = info
	
	self.isVip = isVip				-- 0 不是VIP   1 是VIP
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		self.isVip = message.vip_level
	end
	self.quality = quality			
	self.pic = pic
	self.infor_type = infor_type
	self.message = message or nil
	if self.message ~= nil and self.message.system_info_id ~= nil then
		self.notificationId = self.message.system_info_id
		self.jumpParams = nil
	end
	if ChatSayMineCell.__size ~= nil then
        self:setContentSize(ChatSayMineCell.__size)
    end
    
end

function ChatSayMineCell:createCell()
	local cell = ChatSayMineCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end