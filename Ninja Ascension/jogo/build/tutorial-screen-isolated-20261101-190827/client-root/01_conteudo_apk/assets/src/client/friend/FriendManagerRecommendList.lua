-- ----------------------------------------------------------------------------------------------------
-- 说明：好友推荐界面cell
-- 创建时间	2015-04-16
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

FriendManagerRecommendList = class("FriendManagerRecommendListClass", Window)
    
function FriendManagerRecommendList:ctor()
    self.super:ctor()
	self.roots = {}
	self.person = nil
	app.load("client.chat.ChatFriendInfo")
    -- Initialize FriendManager page state machine.
    local function init_friend_manager_recommend_cell_terminal()
		
		--关闭
		local friend_manager_recommend_cell_add_terminal = {
            _name = "friend_manager_recommend_cell_add",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local id = params._datas._id
            	local cell = params._datas.cell
				local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node._datas ~= nil then
							local ids = response.node._datas._id
							local name = response.node._datas._name
							if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
								state_machine.excute("friend_manager_recommend_cell_update", 0, cell)
							else
								state_machine.excute("friend_manager_recommend_del", 0, ids)
							end
							TipDlg.drawTextDailog(_string_piece_info[259] .. name .._string_piece_info[260])
						end
					end
				end
				
				protocol_command.friend_request.param_list = id .."\r\n".."1"
				NetworkManager:register(protocol_command.friend_request.code, nil, nil, nil, params, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local friend_manager_recommend_cell_click_head_terminal = {
            _name = "friend_manager_recommend_cell_click_head",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if fwin:find("ChatFriendInfoClass") ~= nil then
            		return
            	end

            	local function responseShowUserInfoCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
			            	local curCell = params._datas._cell 
							local cell = ChatFriendInfo:createCell()
							cell:init(params._datas._id, 1 , curCell)
							fwin:open(cell, fwin._windows)
						end
					end
				end
				protocol_command.see_user_info.param_list = params._datas._id
				NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, self, responseShowUserInfoCallBack, false, nil)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local friend_manager_recommend_cell_update_terminal = {
            _name = "friend_manager_recommend_cell_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params
            	if cell ~= nil then
					local Button_106_6 = ccui.Helper:seekWidgetByName(cell.roots[1], "Button_106_6")
					local Image_applied = ccui.Helper:seekWidgetByName(cell.roots[1], "Image_applied")
					Button_106_6:setVisible(false)
					Image_applied:setVisible(true)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(friend_manager_recommend_cell_click_head_terminal)
		state_machine.add(friend_manager_recommend_cell_add_terminal)
		state_machine.add(friend_manager_recommend_cell_click_head_terminal)
		state_machine.add(friend_manager_recommend_cell_update_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_friend_manager_recommend_cell_terminal()
end

function FriendManagerRecommendList:onHeadDraw()
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
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local pic = nil
		if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			if self.person.fashion_pic ~= nil and zstring.tonumber(self.person.fashion_pic) > 0 then
				pic = zstring.tonumber(self.person.fashion_pic)
			end
		end
		local quality_path = nil 
		local big_icon_path = nil 

		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--big_icon_path = string.format("images/ui/home/head_%s.png", self.person.lead_mould_id)
			local picIndex = self.person.lead_mould_id
		    if tonumber(picIndex) < 9 then
		        big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(picIndex))
		    else
		        big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(picIndex))
		    end
			if tonumber(self.person.vip_grade) > 0 then
				quality_path = "images/ui/quality/icon_enemy_5.png"
			else
				quality_path = "images/ui/quality/icon_enemy_1.png"
			end
		else
			pic = dms.int(dms["ship_mould"], self.person.lead_mould_id, ship_mould.head_icon)
			big_icon_path = string.format("images/ui/props/props_%s.png", pic)
			local quality = dms.int(dms["ship_mould"], self.person.lead_mould_id, ship_mould.ship_type)
			quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality)+1)
			if tonumber(self.person.vip_grade) > 0 then
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
		
		Panel_head:setSwallowTouches(false)
		local function fourOpenTouchEvent(sender, eventType)
			local __spoint = sender:getTouchBeganPosition()
			local __mpoint = sender:getTouchMovePosition()
			local __epoint = sender:getTouchEndPosition()
			if eventType == ccui.TouchEventType.began then
	    		-- sender.isMoving = false
			elseif eventType == ccui.TouchEventType.moved then
				-- sender.isMoving = true
	        elseif eventType == ccui.TouchEventType.ended then 
	        	if math.abs(__epoint.y - __spoint.y) <= 8 then
	                -- sender:runAction(cc.Sequence:create(
	                --     cc.ScaleTo:create(0.03, 1.05),
	                --     cc.ScaleTo:create(0.02, 1)
	                -- ))
	        		state_machine.excute("friend_manager_recommend_cell_click_head",0,{ _datas = { _id = self.person.user_id, _cell = self,}})
	            end
	        end
		end
		Panel_head:addTouchEventListener(fourOpenTouchEvent)
	else
		local quality = dms.int(dms["ship_mould"], self.person.lead_mould_id, ship_mould.ship_type)
		local pic = dms.int(dms["ship_mould"], self.person.lead_mould_id, ship_mould.head_icon)
		if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			if self.person.fashion_pic ~= nil and zstring.tonumber(self.person.fashion_pic) > 0 then
				pic = zstring.tonumber(self.person.fashion_pic)
			end
		end
		local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality)+1)
		local big_icon_path = string.format("images/ui/props/props_%s.png", pic)
		Panel_kuang:setBackGroundImage(quality_path)
		Panel_head:setBackGroundImage(big_icon_path)
		if tonumber(self.person.vip_grade) > 0 then
			ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(true)
		end
		fwin:addTouchEventListener(Panel_head, nil, 
		{
			terminal_name = "friend_manager_recommend_cell_click_head", 	
			_id = self.person.user_id,
			terminal_state = 0,
		}, 
		nil, 0)
	end
	return roots
end

function FriendManagerRecommendList:onUpdateDraw()
	local root = self.roots[1]
	local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_13_4")
	local textGrade = ccui.Helper:seekWidgetByName(root, "Text_11_2")
	local textName = ccui.Helper:seekWidgetByName(root, "Text_4")
	local textLeaveTime = ccui.Helper:seekWidgetByName(root, "Text_13_6")
	local textFighting = ccui.Helper:seekWidgetByName(root, "Text_16_12")
	local textArmy = ccui.Helper:seekWidgetByName(root, "Text_3_14")
	panelHead:removeAllChildren(true)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		textName:setString("")
		textName:removeAllChildren(true)
		local _richText = ccui.RichText:create()
	    _richText:ignoreContentAdaptWithSize(false)

	    local color1 = cc.c3b(255, 255, 255)
	    local color2 = cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3])
	    if __lua_project_id == __lua_project_l_naruto then
	    	color1 = cc.c3b(_naruto_tips_color[1][1],_naruto_tips_color[1][2],_naruto_tips_color[1][3])
	    	color2 = cc.c3b(_naruto_tips_color[2][1],_naruto_tips_color[2][2],_naruto_tips_color[2][3])
	    end

	    local fontName = textName:getFontName()
	    local fontSize = textName:getFontSize()
	    local re0 = ccui.RichElementText:create(1, color1, 255, self.person.name.."  ", fontName, fontSize)
	    local re1 = nil
	    if tonumber(self.person.vip_grade) > 0 then
	    	re1 = ccui.RichElementText:create(1, color2, 255, string.format(_new_interface_text[46],tonumber(self.person.vip_grade)), fontName, fontSize)
	    end
	    local re2 = ccui.RichElementText:create(1, color1, 255, "  "..string.format(red_alert_all_str[117], self.person.grade), fontName, fontSize)

	    _richText:pushBackElement(re0)
	    if re1 ~= nil then
	    	_richText:pushBackElement(re1)
	    end
	    _richText:pushBackElement(re2)

	    _richText:setContentSize(textName:getContentSize())
	    _richText:setAnchorPoint(cc.p(0, 0))
	    if _ED.is_can_use_formatTextExt == false then
	    	_richText:setPosition( cc.p(-_richText:getContentSize().width / 2 , -_richText:getContentSize().height / 2))
	    else
	    	_richText:formatTextExt()
	    	_richText:setPosition(cc.p(0, 0))
	    end
	    local bsize = textName:getContentSize()
	    textName:addChild(_richText)
	else
		if verifySupportLanguage(_lua_release_language_en) == true then
			textGrade:setString(_string_piece_info[6]..self.person.grade)
		else
			textGrade:setString(self.person.grade .. _string_piece_info[6])
		end
		local quality = dms.int(dms["ship_mould"], self.person.lead_mould_id, ship_mould.ship_type)
		textName:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))
		textName:setString(self.person.name)
	end
	panelHead:setTouchEnabled(false)
	panelHead:addChild(self:onHeadDraw())
	local recommendFight = tonumber(self.person.fighting)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		if recommendFight >= 10000 then
			recommendFight = math.floor(recommendFight / 10000).._string_piece_info[150]
		end
	end
	textFighting:setString(recommendFight)
	
	-- if self.person.army ~= nil then
		-- textArmy:setString(self.person.army)
	-- else
		textArmy:setString(_string_piece_info[310])
	-- end
	
	local times = self.person.leave_time
	-- if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
	-- 	or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
	-- 	times = zstring.tonumber(self.person.leave_time) /1000
	-- end
	local str = ""
	local hour = math.floor(tonumber(times)/3600)
	local mins = math.floor((tonumber(times)%3600)/60)
	local day = ""
	-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	-- 	local onlineTime = _ED.system_time + (os.time() - _ED.native_time) - times
	-- 	if tonumber(times) == 0 or (mins < 1 and hour == 0) then
	-- 		str = _string_piece_info[268]
	-- 	elseif hour < 24 then
	-- 		local currNowHours = tonumber(os.date("%H",getBaseGTM8Time(os.time() + _ED.time_add_or_sub)))
	-- 		local currLeaveHours = tonumber(os.date("%H",getBaseGTM8Time(onlineTime)))
	-- 		local currStr = ""
	-- 		if currLeaveHours > currNowHours then
	-- 			currStr = _new_interface_text[50]
	-- 		else
	-- 			currStr = _new_interface_text[47]
	-- 		end
	-- 		str = currStr..os.date("%H"..":".."%M",getBaseGTM8Time(onlineTime))
	-- 	elseif hour > 24 then
	-- 		str = string.format(_new_interface_text[48] , math.floor(hour / 24))
	-- 	end
	-- else
		if tonumber(times) == 0 or (mins < 1 and hour == 0) then
			str = _string_piece_info[268]
		elseif hour < 1 then
			str = _string_piece_info[269] .. mins .. _string_piece_info[270]
		elseif hour >= 1 and hour < 24 then
			str = _string_piece_info[269] .. hour .._string_piece_info[271]
		elseif hour >= 24 and hour < 168 then
			day = math.ceil(hour / 24)
			str = _string_piece_info[269] .. day .._string_piece_info[231]
		elseif hour >= 168 then
			str = _string_piece_info[269] .. 1 .._string_piece_info[272]
		end
	-- end
	self.leave_time_str = str
	textLeaveTime:setString(str)
	
end

function FriendManagerRecommendList:onEnterTransitionFinish()
	local csbFriendManagerRecommend = csb.createNode("friend/friend_tuijian_list.csb")
	self:addChild(csbFriendManagerRecommend)
	local root = csbFriendManagerRecommend:getChildByName("root")
	table.insert(self.roots, root)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local MySize = root:getContentSize()
		self:setContentSize(MySize)
		root:setTouchEnabled(true)
		root:setSwallowTouches(false)

		local function fourOpenTouchEvent(sender, eventType)
			local __spoint = sender:getTouchBeganPosition()
			local __mpoint = sender:getTouchMovePosition()
			local __epoint = sender:getTouchEndPosition()
			if eventType == ccui.TouchEventType.began then
	    		-- sender.isMoving = false
			elseif eventType == ccui.TouchEventType.moved then
				-- sender.isMoving = true
	        elseif eventType == ccui.TouchEventType.ended then 
	        	if math.abs(__epoint.y - __spoint.y) <= 8 then
	                -- sender:runAction(cc.Sequence:create(
	                --     cc.ScaleTo:create(0.03, 1.05),
	                --     cc.ScaleTo:create(0.02, 1)
	                -- ))
	        		state_machine.excute("friend_manager_recommend_cell_click_head",0,{ _datas = { _id = self.person.user_id, _cell = self,}})
	            end
	        end
		end
		root:addTouchEventListener(fourOpenTouchEvent)
	else
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_11_5")
		local MySize = panel:getContentSize()
		self:setContentSize(MySize)
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_106_6"), nil, 
	{
		terminal_name = "friend_manager_recommend_cell_add", 
		_id = self.person.user_id,
		_name = self.person.name,
		terminal_state = 0, 
		isPressedActionEnabled = true,
		cell = self,
	}, nil, 0)
	
	self:onUpdateDraw()
end

function FriendManagerRecommendList:clearUIInfo( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[2]
		if root._x ~= nil then
			root:setPositionX(root._x)
		end
		if root._y ~= nil then
			root:setPositionY(root._y)
		end
	    local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
	    local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
	    local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
	    local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
	    local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
	    local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
	    local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
	    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
	    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
	    local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
	    local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
	    local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
	    local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
	    local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
	    local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
	    local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
	    local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
	    local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
	    local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
	    local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
	    local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
	    local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
		if Image_double ~= nil then
			Image_double:setVisible(false)
		end
	    if Image_xuanzhong ~= nil then
	    	Image_xuanzhong:setVisible(false)
	    end
        if Image_3 ~= nil then
        	Image_3:setVisible(false)
        end
	    if Label_l_order_level ~= nil then 
	    	Label_l_order_level:setVisible(true)
	    	if Label_l_order_level._x then
		    	Label_l_order_level:setPositionX(Label_l_order_level._x)
			end
	        Label_l_order_level:setString("")
	    end
	    if Label_name ~= nil then
	        Label_name:setString("")
	        Label_name:setVisible(true)
	        Label_name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
	    end
	    if Label_quantity ~= nil then
	        Label_quantity:setString("")
	    end
	    if Label_shuxin ~= nil then
	        Label_shuxin:setString("")
	    end
	    if Panel_prop ~= nil then
	        Panel_prop:removeAllChildren(true)
	        Panel_prop:removeBackGroundImage()
	    end
	    if Panel_kuang ~= nil then
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
	    if Panel_ditu ~= nil then
	    	Panel_ditu:setVisible(true)
	        Panel_ditu:removeAllChildren(true)
	        Panel_ditu:removeBackGroundImage()
	    end
	    if Panel_star ~= nil then
	        Panel_star:removeAllChildren(true)
	        Panel_star:removeBackGroundImage()
	    end
	    if Panel_props_right_icon ~= nil then
	        Panel_props_right_icon:removeAllChildren(true)
	        Panel_props_right_icon:removeBackGroundImage()
	    end
	    if Panel_props_left_icon ~= nil then
	        Panel_props_left_icon:removeAllChildren(true)
	        Panel_props_left_icon:removeBackGroundImage()
	    end
	    if Panel_num ~= nil then
	        Panel_num:removeAllChildren(true)
	        Panel_num:removeBackGroundImage()
	    end
	    if Panel_4 ~= nil then
	        Panel_4:removeAllChildren(true)
	        Panel_4:removeBackGroundImage()
	    end
	    if Text_1 ~= nil then
	        Text_1:setString("")
	    end
	end
end

function FriendManagerRecommendList:onExit()
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", self.roots[2])
	-- state_machine.remove("friend_manager_recommend_cell_add")
	-- state_machine.remove("friend_manager_recommend_cell_click_head")
end


function FriendManagerRecommendList:init(person)
	self.person = person
end

function FriendManagerRecommendList:createCell()
	local cell = FriendManagerRecommendList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end