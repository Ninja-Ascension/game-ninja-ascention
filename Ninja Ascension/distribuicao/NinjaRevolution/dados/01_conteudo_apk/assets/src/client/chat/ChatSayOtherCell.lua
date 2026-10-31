----------------------------------------------------------------------------------------------------
-- 说明：聊天主界面cell
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ChatSayOtherCell = class("ChatSayOtherCellClass", Window)
    
function ChatSayOtherCell:ctor()
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
	self.message = nil
	self.notificationId = 0
	self.jumpParams = nil
	app.load("client.chat.ChatFriendInfo")

    -- Initialize ChatStorage page state machine.
    local function init_chat_say_other_cell_terminal()
		local chat_say_other_cell_click_head_terminal = {
            _name = "chat_say_other_cell_click_head",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            		app.load("client.l_digital.chat.SmChatOtherInfo")
            		if params._datas._id == 0 then
            			return
            		end

					local userID = params._datas._id

					-- DSC统一玩家详情界面
					if __lua_project_id == __lua_project_l_digital then
						if fwin:find("SmChatOtherInfoClass") == nil then
							OpenOtherUserInformation(userID, {}, fwin._windows)
						end
					else
						local function responseShowUserInfoCallBack(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								local cell = SmChatOtherInfo:createCell()
								cell:init(params._datas._id,1)
								fwin:open(cell, fwin._windows)
							end
						end
						if fwin:find("SmChatOtherInfoClass") == nil then
							protocol_command.see_user_info.param_list = userID
							NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, instance, responseShowUserInfoCallBack, false, nil)
						end
					end
            	else
					local cell = ChatFriendInfo:createCell()
					cell:init(params._datas._id,1)
					fwin:open(cell, fwin._windows)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
       	-- 加入试炼队伍
       	local chat_say_other_cell_join_purify_team_terminal = {
            _name = "chat_say_other_cell_join_purify_team",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell

            	-- 如果是文件岛好友任务里的邀请加入，加入好友任务，并跳转到文件岛
            	if zstring.tonumber(cell.notificationId) == 46 then
            		if true == funOpenDrawTip(94) then
	                    return false
	                end

	                local infos = zstring.split(cell.message.system_info_params, "|")
	                infos = zstring.split(infos[2], ",")

	                local req = {}
	            	req.finderUid = infos[1]
	            	req.taskId = infos[2]
	            	local str = json.encode(req)

            		local function responseFileIslandFriendsInitCallback(response)
	                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	                        if #_ED.fileIsland.taskInfo.mySingleTaskInfo ~= 0 
	                            or #_ED.fileIsland.taskInfo.myMultiTaskInfo ~= 0 
	                            or #_ED.fileIsland.taskInfo.myJoinTaskInfo ~= 0 
	                            or #_ED.fileIsland.taskInfo.friendMultiTaskInfo ~= 0
	                            then
	                            
	                            app.load("client.l_digital.campaign.fileIsland.FileIslandWindow")
								state_machine.excute("chat_return_home_page", 0, false)
			            		app.load("client.l_digital.campaign.fileIsland.FileIslandFriends")
			            		state_machine.excute("fileIsland_window_friends_open", 0, "2")

	                        else
	                            TipDlg.drawTextDailog(tipStringInfo_file_island_tips[10])
	                        end
	                    end
	                end
	                protocol_command.fileIslandTaskInfo.param_list = ""
	                NetworkManager:register(protocol_command.fileIslandTaskInfo.code, nil, nil, nil, nil, responseFileIslandFriendsInitCallback, false, nil)

	    --         	local function callback(response)
					-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
					-- 		app.load("client.l_digital.campaign.fileIsland.FileIslandWindow")
					-- 		state_machine.excute("chat_return_home_page", 0, false)
     --                		app.load("client.l_digital.campaign.fileIsland.FileIslandFriends")
     --                		state_machine.excute("fileIsland_window_friends_open", 0, 0)

					-- 	end
					-- end
					-- protocol_command.fileIslandFriendTaskJoin.param_list = str
					-- NetworkManager:register(protocol_command.fileIslandFriendTaskJoin.code, nil, nil, nil, nil, callback, false, nil)

            		return
            	end

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
                    	TipDlg.drawTextDailog(_new_interface_text[125])
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

        local chat_say_other_cell_join_union_terminal = {
            _name = "chat_say_other_cell_join_union",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
                if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
     --                local infos = zstring.split(cell.message.system_info_params, "|")
     --                protocol_command.union_apply.param_list = infos[3].."\r\n0"
	    --             NetworkManager:register(protocol_command.union_apply.code, nil, nil, nil, cell, nil, false, nil)
					-- TipDlg.drawTextDailog(_new_interface_text[165])
					state_machine.excute("chat_return_home_page", 0, nil)
					state_machine.excute("home_goto_click_union", 0, nil)
                else
                	TipDlg.drawTextDailog(_new_interface_text[164])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local chat_say_other_cell_jump_terminal = {
            _name = "chat_say_other_cell_jump",
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

		state_machine.add(chat_say_other_cell_click_head_terminal)
		state_machine.add(chat_say_other_cell_join_purify_team_terminal)
		state_machine.add(chat_say_other_cell_join_union_terminal)
		state_machine.add(chat_say_other_cell_jump_terminal)
        state_machine.init()
    end
    
    init_chat_say_other_cell_terminal()
end

function ChatSayOtherCell:onHeadDraw()
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

	self.item_order_level = ccui.Helper:seekWidgetByName(roots, "Label_l-order_level")--右下角等级
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
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
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		Panel_kuang:setBackGroundImage(big_icon_path)
		Panel_head:setBackGroundImage(quality_path)
	else
		Panel_kuang:setBackGroundImage(quality_path)
		Panel_head:setBackGroundImage(big_icon_path)
	end
	fwin:addTouchEventListener(Panel_head, nil, 
	{
		terminal_name = "chat_say_other_cell_click_head", 	
		_id = self.personId,
		terminal_state = 0,
	}, 
	nil, 0)
	
	return roots
end

function ChatSayOtherCell:getNewHeadIcon()
	local headIconInfo = {
        headFrameID = self.message.headFrameID,
        headFrameStage = self.message.headFrameStage,
        headID = self.pic,
    }
    local headIcon = CreateHeadIconCell(headIconInfo)
    
    return headIcon
end

function ChatSayOtherCell:drawHead()
    local root = self.roots[1]
    --头像
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_3")
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
		if tonumber(self.pic) >= 9 then
			big_icon_path = string.format("images/ui/props/props_%d.png", self.pic)
		else
			big_icon_path = string.format("images/ui/home/head_%d.png", self.pic)
		end
		local sprit = cc.Sprite:create(big_icon_path)
		sprit:setAnchorPoint(cc.p(0.5,0.5))
		sprit:setPosition(cc.p(Panel_player_icon:getContentSize().width / 2, Panel_player_icon:getContentSize().height / 2))
		Panel_player_icon:addChild(sprit,0)
	end
end

function ChatSayOtherCell:onUpdateDrawSm()
	local root = self.roots[1]
	local Text_103_0 = ccui.Helper:seekWidgetByName(root, "Text_103_0")
	local Panel_chat_2 = ccui.Helper:seekWidgetByName(root, "Panel_chat_2")
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_103_name")
	-- local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local imageOne = ccui.Helper:seekWidgetByName(root, "Image_135_0")
	local imageTwo = ccui.Helper:seekWidgetByName(root, "Image_135")
	local Panel_chat_channel = ccui.Helper:seekWidgetByName(root, "Panel_chat_channel")
	local Panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_5")
	local Image_chat_vip_icon = ccui.Helper:seekWidgetByName(root, "Image_chat_vip_icon")
	local AtlasLabel_chat_vip_n = ccui.Helper:seekWidgetByName(root, "AtlasLabel_chat_vip_n")
	nameText.__positionX = nameText:getPositionX()
	Image_chat_vip_icon.__positionX = Image_chat_vip_icon:getPositionX()
	AtlasLabel_chat_vip_n.__positionX = AtlasLabel_chat_vip_n:getPositionX()
	imageOne.__contentSize = imageOne:getContentSize()
	-- DSC重塑   
	if __lua_project_id == __lua_project_l_digital then 
	else
		nameText:setPositionX(Panel_chat_channel:getPositionX() + Panel_chat_channel:getContentSize().width + 3)
	end
	
	imageOne:setVisible(true)
	imageTwo:setVisible(false)
	-- panelHead:removeAllChildren(true)
	Panel_5:removeAllChildren(true)
	nameText:setString(self.name)
	-- panelHead:addChild(self:onHeadDraw())
	self:drawHead()

	local _chat_image_type = tonumber(self.infor_type)
	if _chat_image_type == 5 then
		_chat_image_type = 1
	elseif _chat_image_type == 6 then
		_chat_image_type = 2
	end
	Panel_chat_channel:setBackGroundImage(string.format("images/ui/text/chat/chat_channel_%d.png", tonumber(_chat_image_type)))

	local titlePositionX = 0
	local Panel_title_view = ccui.Helper:seekWidgetByName(root, "Panel_title_view")
	if nil ~= Panel_title_view then
		local titleIndex = tonumber(self.message.send_information_rank_title_name)
		if nil ~= titleIndex and titleIndex > 0 then
			Panel_title_view:setVisible(true)
			Panel_title_view:setBackGroundImage(string.format("images/ui/text/title/title_%s.png", dms.string(dms["title_param"], titleIndex, title_param.pic_index)))
			titlePositionX = Panel_title_view:getContentSize().width * Panel_title_view:getScaleX()
			
			-- DSC重塑   
			if __lua_project_id == __lua_project_l_digital then 
			else
				nameText:setPositionX(titlePositionX + nameText:getPositionX())
			end

			
		else
			Panel_title_view:setVisible(false)
		end
	end

	if tonumber(self.isVip) > 0 then
		-- DSC重塑   
	if __lua_project_id == __lua_project_l_digital then 
		Image_chat_vip_icon:setPositionX(Panel_chat_channel:getPositionX() + Panel_chat_channel:getContentSize().width + 10)
		AtlasLabel_chat_vip_n:setString(self.isVip)
		AtlasLabel_chat_vip_n:setPositionX(Image_chat_vip_icon:getPositionX() + Image_chat_vip_icon:getContentSize().width / 2)
		nameText:setPositionX(AtlasLabel_chat_vip_n:getPositionX() + AtlasLabel_chat_vip_n:getContentSize().width + 10)
	else
		Image_chat_vip_icon:setPositionX(nameText:getPositionX() + nameText:getContentSize().width + Image_chat_vip_icon:getContentSize().width / 2 + 3)
		AtlasLabel_chat_vip_n:setString(self.isVip)
		AtlasLabel_chat_vip_n:setPositionX(Image_chat_vip_icon:getPositionX() + Image_chat_vip_icon:getContentSize().width / 2)
	end
	else
		Image_chat_vip_icon:setVisible(false)
		AtlasLabel_chat_vip_n:setVisible(false)
	end
	index = 0
	local _richText2 = ccui.RichText:create()
	_richText2:ignoreContentAdaptWithSize(false)
	if zstring.tonumber(self.notificationId) == 45 or zstring.tonumber(self.notificationId) == 46 or zstring.tonumber(self.notificationId) == 47 then

		local richTextWidth = Panel_5:getContentSize().width
        if richTextWidth == 0 then
	        richTextWidth = Text_103_0:getFontSize() * 6
	    end
			    
		_richText2:setContentSize(cc.size(richTextWidth, 0))
	else
		_richText2:setContentSize(cc.size(Panel_5:getContentSize().width+Text_103_0:getFontSize()*5, 0))
	end
	_richText2:setAnchorPoint(cc.p(0, 0))
	local char_str = self.info
	local max_width = 0
    if _ED.is_can_use_formatTextExt == false then
        Text_103_0:setString(char_str)
        max_width = Text_103_0:getAutoRenderSize().width
    end
    Text_103_0:setString("")
    if zstring.tonumber(self.notificationId) == 45 or zstring.tonumber(self.notificationId) == 46 or zstring.tonumber(self.notificationId) == 47 then
		char_str = smWidthSingle(char_str,Text_103_0:getFontSize()/2,Panel_5:getContentSize().width)
	else
		char_str = smWidthSingle(char_str,Text_103_0:getFontSize()/2,Panel_5:getContentSize().width+Text_103_0:getFontSize()*5)
	end

	if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
    	color_Type_1 = cc.c3b(255, 255, 255)
    	color_Type_2 = cc.c3b(255, 255, 255)
	elseif __lua_project_id == __lua_project_l_digital then 
		-- DSC重塑
		color_Type_1 = Text_103_0:getColor()
		color_Type_2 = Text_103_0:getColor()
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
	Text_103_0:getFontSize(),
	chat_rich_text_color)
	if _ED.is_can_use_formatTextExt == false then
		_richText2:setPositionX(_richText2:getPositionX() - _richText2:getContentSize().width / 2)
    else
        _richText2:formatTextExt()
    end
	local rsize = _richText2:getContentSize()
	_richText2:setPositionY(Text_103_0:getPositionY() - Panel_5:getContentSize().height + 2)
	_richText2:setPositionX(_richText2:getPositionX() - 10+Text_103_0:getFontSize()/2)
	Text_103_0:addChild(_richText2)
	index = index + rsize.height
	if __lua_project_id == __lua_project_l_digital then
		imageOne:setContentSize(cc.size(rsize.width + 12+Text_103_0:getFontSize() , rsize.height+Text_103_0:getFontSize()))
	else
		imageOne:setContentSize(cc.size(rsize.width + 12+Text_103_0:getFontSize() , rsize.height+Text_103_0:getFontSize() / 2))
	end

	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		Panel_chat_2.__positionY = Panel_chat_2:getPositionY()
		root.__positionY = root:getPositionY()
		local addNum = imageOne:getContentSize().height - imageOne.__contentSize.height > 0 and imageOne:getContentSize().height - imageOne.__contentSize.height or 0
		root:setContentSize(cc.size(root:getContentSize().width,root:getContentSize().height + addNum ))
		Panel_chat_2:setPositionY(Panel_chat_2:getPositionY() + addNum)
		root:setPositionY(root:getPositionY()+addNum)
		self:setContentSize(root:getContentSize())
	else
		self:setContentSize(Panel_chat_2:getContentSize())
	end

	--如果formatTextExt不能用 重新计算高度和位置
    if _ED.is_can_use_formatTextExt == false then
        local heightN = math.ceil( max_width / tonumber(_richText2:getContentSize().width))
        local height = heightN * 21
        imageOne:setContentSize(cc.size(imageOne:getContentSize().width , height))
        if max_width < tonumber(_richText2:getContentSize().width) then
        	imageOne:setContentSize(cc.size(imageOne:getContentSize().width - _richText2:getContentSize().width + max_width, height))
        end
    end

	local Button_chat_team_join = ccui.Helper:seekWidgetByName(root, "Button_chat_team_join") --队伍申请
	Button_chat_team_join:setVisible(false)
	local Button_chat_legion_join = ccui.Helper:seekWidgetByName(root, "Button_chat_legion_join") --公会申请
	Button_chat_legion_join:setVisible(false)

	if zstring.tonumber(self.notificationId) == 45 then
		Button_chat_legion_join:setVisible(true)
	elseif zstring.tonumber(self.notificationId) == 46 then
		Button_chat_team_join:setVisible(true)
	elseif zstring.tonumber(self.notificationId) == 47 then
		Button_chat_team_join:setVisible(true)
	end

	-- DSC背景图片大小
	if __lua_project_id == __lua_project_l_digital then
		local imageMaxWidth = 455
		if imageOne:getContentSize().width >=imageMaxWidth then
			imageOne:setContentSize(cc.size(imageMaxWidth,imageOne:getContentSize().height))
		end
	end
	-- DSC重塑 称号
	if __lua_project_id == __lua_project_l_digital then 
		Panel_title_view:setPositionX((nameText:getPositionX() + nameText:getContentSize().width / 2) + (Panel_title_view:getContentSize().width * Panel_title_view:getScaleX() * Panel_title_view:getAnchorPoint().x))
	end

end

function ChatSayOtherCell:onUpdateDraw()
	local root = self.roots[1]
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_103_name")
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_5")
	local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local panel_chat_2 = ccui.Helper:seekWidgetByName(root, "Panel_chat_2")
	local infoText = ccui.Helper:seekWidgetByName(root, "Text_103_0_0")
	local imageOne = ccui.Helper:seekWidgetByName(root, "Image_135")
	local imageTwo = ccui.Helper:seekWidgetByName(root, "Image_135_0")
	if tonumber(self.isVip) > 0 then 
		imageOne:setVisible(true)
	else
		imageTwo:setVisible(true)
	end
	panelHead:removeAllChildren(true)
	panel:removeAllChildren(true)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then 
	else
		nameText:setColor(cc.c3b(color_Type[tonumber(self.quality)+1][1],color_Type[tonumber(self.quality)+1][2],color_Type[tonumber(self.quality)+1][3]))
	end
	nameText:setString(self.name)
	panelHead:addChild(self:onHeadDraw())
	
	local infoWidth = infoText:getPositionX()
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
    end

	panel:addChild(_richText)
	_richText:setAnchorPoint(CCPoint(0, 1))
	
	if heightNum == 1 then
		if first[heightNum] == true or self.picNum == 0 then
			imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ num*20-150+self.picNum*60,imageOne:getContentSize().height))
			imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ num*20-150+self.picNum*60,imageTwo:getContentSize().height))
			tipHeight = tipHeight + 20
			_richText:setPosition(cc.p(-170, -1 * tipHeight-6))
		else
			imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ num*20-150+self.picNum*60,60))
			imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ num*20-150+self.picNum*60,60))
			tipHeight = tipHeight + 60
			_richText:setPosition(cc.p(-170, -1 * tipHeight+10))
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh 
				or __lua_project_id == __lua_project_warship_girl_b 
				then 
				imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ num*20-150+self.picNum*60,80))
				imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ num*20-150+self.picNum*60,80))
				_richText:setPosition(cc.p(-170, -1 * tipHeight + 20))
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
		_richText:setPosition(cc.p(-170, -1 * tipHeight+5))
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
end

function ChatSayOtherCell:onEnterTransitionFinish()
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		root = cacher.createUIRef("Chat/chat_list_1.csb", "root")
	else
	    local csbChatStorage = csb.createNode("Chat/chat_list_1.csb")
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

	local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	Panel_3:setTouchEnabled(true)
	fwin:addTouchEventListener(Panel_3, nil, 
	{
		terminal_name = "chat_say_other_cell_click_head", 	
		_id = self.personId,
		terminal_state = 0,
	}, 
	nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_team_join"), nil, 
    {
        terminal_name = "chat_say_other_cell_join_purify_team", 
        terminal_state = 0,
        _cell = self,
        isPressedActionEnabled = true,
    })

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chat_legion_join"), nil, 
    {
        terminal_name = "chat_say_other_cell_join_union", 
        terminal_state = 0,
        _cell = self,
        isPressedActionEnabled = true,
    })
end

function ChatSayOtherCell:clearUIInfo( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
	    local Text_103_0 = ccui.Helper:seekWidgetByName(root, "Text_103_0")
		local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_3")
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_5")
		local nameText = ccui.Helper:seekWidgetByName(root, "Text_103_name")
		local Image_chat_vip_icon = ccui.Helper:seekWidgetByName(root, "Image_chat_vip_icon")
		local Panel_chat_channel = ccui.Helper:seekWidgetByName(root, "Panel_chat_channel")
		local AtlasLabel_chat_vip_n = ccui.Helper:seekWidgetByName(root, "AtlasLabel_chat_vip_n")
		local imageOne = ccui.Helper:seekWidgetByName(root, "Image_135_0")
		local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")
		-- DSC重塑
		local Panel_chat_2 = ccui.Helper:seekWidgetByName(root, "Panel_chat_2")
		if root.__positionY and root.__contentSize then 
			root:setPositionY(root.__positionY)
			root:setContentSize(root.__contentSize)
		end
		if Panel_chat_2 and Panel_chat_2.__positionY then 
			Panel_chat_2:setPositionY(Panel_chat_2.__positionY) 
		end

		if Label_l_order_level ~= nil then 
	    	Label_l_order_level:setVisible(true)
	    	if Label_l_order_level._x then
		    	Label_l_order_level:setPositionX(Label_l_order_level._x)
			end
	        Label_l_order_level:setString("")
	    end 
		if panelHead ~= nil then
			panelHead:removeAllChildren(true)
		end
		if Text_103_0 ~= nil then
			Text_103_0:removeAllChildren(true)
		end
		if panel ~= nil then
			panel:removeAllChildren(true)
		end
		if nameText ~= nil and nameText.__positionX ~= nil then
			nameText:setPositionX(nameText.__positionX)
		end
		if Image_chat_vip_icon ~= nil and Image_chat_vip_icon.__positionX ~= nil then
			Image_chat_vip_icon:setPositionX(Image_chat_vip_icon.__positionX)
		end
		if Panel_chat_channel ~= nil then
			Panel_chat_channel:removeBackGroundImage()
		end
		if AtlasLabel_chat_vip_n ~= nil and AtlasLabel_chat_vip_n.__positionX ~= nil then
			AtlasLabel_chat_vip_n:setPositionX(AtlasLabel_chat_vip_n.__positionX)
		end
		if imageOne ~= nil and imageOne.__contentSize ~= nil then
			imageOne:setContentSize(imageOne.__contentSize)
			
		end
		if self.__contentSize ~= nil then
			self:setContentSize(self.__contentSize)
		end
		self.notificationId = 0
		self.jumpParams = nil
	end
end

function ChatSayOtherCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("Chat/chat_list_1.csb", self.roots[1])
end

function ChatSayOtherCell:init(personId, name, info, isVip ,quality, pic , infor_type ,message)
	self.personId = personId
	self.name = name or ""
	self.info = info or ""
	self.isVip = isVip or 0				-- 0 不是VIP   1 是VIP
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		self.isVip = message.vip_level
	end
	self.quality = zstring.tonumber(quality)	
	self.pic = pic or 1508	
	self.infor_type = infor_type
	self.message = message or nil
	if self.message ~= nil and self.message.system_info_id ~= nil then
		self.notificationId = self.message.system_info_id
		self.jumpParams = nil
	end
end

function ChatSayOtherCell:createCell()
	local cell = ChatSayOtherCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end