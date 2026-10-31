----------------------------------------------------------------------------------------------------
-- 说明：聊天主界面cell
-- 创建时间
-- 作者：李潮
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

ChatSayOtherCellNew = class("ChatSayOtherCellNewClass", Window)
    
function ChatSayOtherCellNew:ctor()
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
	self.sendTime = 0
	app.load("client.chat.ChatFriendInfo")
    -- Initialize ChatStorage page state machine.
    local function init_chat_say_other_cell_new_terminal()
		--返回home界面
		local chat_say_other_cell_new_click_head_terminal = {
            _name = "chat_say_other_cell_new_click_head",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local cell = ChatFriendInfo:createCell()
				cell:init(params._datas._id,1)
				fwin:open(cell, fwin._windows)
			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		
		state_machine.add(chat_say_other_cell_new_click_head_terminal)

        state_machine.init()
    end
    
    init_chat_say_other_cell_new_terminal()
end

function ChatSayOtherCellNew:onHeadDraw()
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
	Panel_kuang:setBackGroundImage(quality_path)
	Panel_head:setBackGroundImage(big_icon_path)
	if tonumber(self.isVip) > 0 then
		ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(true)
	end
	fwin:addTouchEventListener(Panel_head, nil, 
	{
		terminal_name = "chat_say_other_cell_new_click_head", 	
		_id = self.personId,
		terminal_state = 0,
	}, 
	nil, 0)
	
	return roots
end

function ChatSayOtherCellNew:onUpdateDraw()
	local root = self.roots[1]
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_103_name")
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_5")
	local panelHead = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local panel_chat_2 = ccui.Helper:seekWidgetByName(root, "Panel_chat_2")
	local infoText = ccui.Helper:seekWidgetByName(root, "Text_103_0_0")
	local imageOne = ccui.Helper:seekWidgetByName(root, "Image_135")
	local timeText = ccui.Helper:seekWidgetByName(root, "Text_time1")
	
	panelHead:removeAllChildren(true)
	panel:removeAllChildren(true)

	local send_time = os.date("%H"..":".."%M"..":%S", zstring.exchangeFrom(zstring.tonumber(self.sendTime)/1000))
	timeText:setString(send_time)

	nameText:setColor(cc.c3b(color_Type[tonumber(self.quality)+1][1],color_Type[tonumber(self.quality)+1][2],color_Type[tonumber(self.quality)+1][3]))
	nameText:setString(self.name)
	panelHead:addChild(self:onHeadDraw())


	local titlePositionX = 0
	local Panel_title_view = ccui.Helper:seekWidgetByName(root, "Panel_title_view")
	if nil ~= Panel_title_view then
		local titleIndex = tonumber(self.message.send_information_rank_title_name)
		if nil ~= titleIndex and titleIndex > 0 then
			Panel_title_view:setVisible(true)
			Panel_title_view:setBackGroundImage(string.format("images/ui/text/title/title_%s.png", dms.string(dms["title_param"], titleIndex, title_param.pic_index)))
			titlePositionX = Panel_title_view:getContentSize().width * Panel_title_view:getScaleX()
			nameText:setPositionX(titlePositionX + nameText:getPositionX())
		else
			Panel_title_view:setVisible(false)
		end
	end
	
	local infoWidth = infoText:getPositionX()
	local width = infoText:getContentSize().width
	local infoHeight = infoText:getPositionY()
	local shiPartnerHigh = panel:getPositionY()
	local shiPartnerWidth = panel:getPositionX()
	local imageOneX = imageOne:getPositionX()
	local imageOneY = imageOne:getPositionY()
	
	local allSize = imageOne:getContentSize().height
	label_UI = nil
 	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
 		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
 		or __lua_project_id == __lua_project_yugioh 
 		or __lua_project_id == __lua_project_warship_girl_b 
 		then 
 		label_UI = csb.createNode("utils/version_length_liaotian.csb")
 	else
 		label_UI = csb.createNode("utils/version_length.csb")
 	end

	local label_root = label_UI:getChildByName("root")
	local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
	local tipHeight = 0
	
	local _richText = ccui.RichText:create()
	_richText:ignoreContentAdaptWithSize(false)
	_richText:setContentSize(cc.size(width-5, 0))
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
			local color = nil
			if __lua_project_id == __lua_project_yugioh then
				color = lableCell:getColor()
			else
				color = cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3])
			end
			if tonumber(getDefaultLanguage()) ~= nil and tonumber(getDefaultLanguage()) == 0 then
				re1 = ccui.RichElementText:create(1, color, 255, self.str, lableCell:getFontName(), lableCell:getFontSize())
			else
				re1 = ccui.RichElementText:create(1, color, 255, self.str, "", lableCell:getFontSize())
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
			end
			break
		end
		if f > 1 then
			local info = string.sub(self.info, 1, f-1)
			num = num + string.utf8len(info)
			local re1 = nil
			local color = nil
			if __lua_project_id == __lua_project_yugioh then 
				color = lableCell:getColor()
			else
				color = cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3])
			end
			if tonumber(getDefaultLanguage()) ~= nil and tonumber(getDefaultLanguage()) == 0 then
				re1 = ccui.RichElementText:create(1, color, 255, info, lableCell:getFontName(), lableCell:getFontSize())
			else
				re1 = ccui.RichElementText:create(1, color, 255, info, "", lableCell:getFontSize())
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
				local color = nil
				if __lua_project_id == __lua_project_yugioh then 
					color = lableCell:getColor()
				else
					color = cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3])
				end
				if tonumber(getDefaultLanguage()) ~= nil and tonumber(getDefaultLanguage()) == 0 then
					re1 = ccui.RichElementText:create(1, color, 255, info, lableCell:getFontName(), lableCell:getFontSize())
				else
					re1 = ccui.RichElementText:create(1, color, 255, info, "", lableCell:getFontSize())
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
	
	local posX = -190
	if __lua_project_id == __lua_project_warship_girl_b then
		posX = -170
	end
	if heightNum == 1 then
		if first[heightNum] == true or self.picNum == 0 then
			
			tipHeight = tipHeight + 20
			_richText:setPosition(cc.p(posX, -1 * tipHeight-6))
		else
			tipHeight = tipHeight + 60
			_richText:setPosition(cc.p(posX, -1 * tipHeight + 20))
		end
	end
	local statuse = false
	if heightNum > 1 then
		for i=1, heightNum do
			if first[i] == true or self.picNum == 0 or first[i] == nil then
				if i > 2 then
					tipHeight = tipHeight + 20
				else
					if statuse == true then	
						tipHeight = tipHeight + 20
					else
						
					end
				end
			else
				if i > 1 then
					tipHeight = tipHeight + 60
				else
					
				end
				statuse = true
			end
		end
		_richText:setPosition(cc.p(posX, -1 * tipHeight+5))
	end
	panel_chat_2:setPosition(cc.p(panel_chat_2:getPositionX(), panel_chat_2:getPositionY()+imageOne:getContentSize().height-allSize))
	panel_chat_2:setContentSize(cc.size(panel_chat_2:getContentSize().width,panel_chat_2:getContentSize().height+imageOne:getContentSize().height-allSize))
	self:setContentSize(panel_chat_2:getContentSize())
	panel:setPosition(shiPartnerWidth,shiPartnerHigh+tipHeight+50)
end

function ChatSayOtherCellNew:onEnterTransitionFinish()
    local csbChatStorage = csb.createNode("Chat/chat_list_1.csb")
	local root = csbChatStorage:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	self:onUpdateDraw()
end

function ChatSayOtherCellNew:clearUIInfo( ... )
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

function ChatSayOtherCellNew:onExit()
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", self.roots[2])
	state_machine.remove("chat_say_other_cell_new_click_head")
end

function ChatSayOtherCellNew:init(personId, name, info, isVip ,quality, pic,sendTime, message)
	self.personId = personId
	self.name = name or ""
	self.info = info or ""
	self.isVip = isVip or 0				-- 0 不是VIP   1 是VIP
	self.quality = zstring.tonumber(quality)	
	self.pic = pic or 1508		
	self.sendTime = sendTime
	self.message = message
end

function ChatSayOtherCellNew:createCell()
	local cell = ChatSayOtherCellNew:new()
	cell:registerOnNodeEvent(cell)
	return cell
end