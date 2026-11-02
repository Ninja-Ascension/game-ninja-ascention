----------------------------------------------------------------------------------------------------
-- 说明：聊天主界面cell
-------------------------------------------------------------------------------------------------------

AdventureChatSayMineCell = class("AdventureChatSayMineCellClass", Window)
    
function AdventureChatSayMineCell:ctor()
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
	app.load("client.adventure.utils.AdventureSprite")
    -- Initialize ChatStorage page state machine.
    local function init_adventure_chat_say_mine_cell_terminal()
		--返回home界面
		local adventure_chat_say_mine_cell_click_head_terminal = {
            _name = "adventure_chat_say_mine_cell_click_head",
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

		
		state_machine.add(adventure_chat_say_mine_cell_click_head_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_adventure_chat_say_mine_cell_terminal()
end

function AdventureChatSayMineCell:onUpdateDraw()
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
	nameText:setColor(cc.c3b(color_Type[tonumber(self.quality)+1][1],color_Type[tonumber(self.quality)+1][2],color_Type[tonumber(self.quality)+1][3]))
	nameText:setString(self.name)
	panelHead:removeAllChildren(true)	
	
	local armature1 = AdventureSpriteRole:create(zstring.tonumber(self.pic))
    armature1:setPosition(cc.p(panelHead:getContentSize().width/2,-panelHead:getContentSize().height/2))
    panelHead:addChild(armature1)
	
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

	label_UI = csb.createNode("utils/version_length_0.csb")

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
			local re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
				255, self.str, lableCell:getFontName(), lableCell:getFontSize())
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
			local re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
				255, info, lableCell:getFontName(), lableCell:getFontSize())
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
				local re1 = ccui.RichElementText:create(1, cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]), 
					255, info, lableCell:getFontName(), lableCell:getFontSize())
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
			local _x = - num*20-self.picNum*60+150 + 15
			local _y = -1 * tipHeight-6
			_richText:setPosition(cc.p(_x, _y))
		else
			imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ num*20-150+self.picNum*60,60))
			imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ num*20-150+self.picNum*60,60))
			tipHeight = tipHeight + 60
			local _x = - num*20-self.picNum*60+150 + 20
			local _y = -1 * tipHeight+5
			_richText:setPosition(cc.p(_x,_y ))
			
		end
	end
	local statuse = false
	if heightNum > 1 then
		for i=1, heightNum do
			if first[i] == true or self.picNum == 0 or first[i] == nil then
				if i > 2 then
					imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ 340-150,imageOne:getContentSize().height+18))
					imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ 340-150,imageTwo:getContentSize().height+18))
					tipHeight = tipHeight + 40
					
				else
					if statuse == true then
						imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ 340-150,imageOne:getContentSize().height+18))
						imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ 340-150,imageTwo:getContentSize().height+18))
						tipHeight = tipHeight + 40
					
					else
						imageOne:setContentSize(cc.size(imageOne:getContentSize().width+ 340-150,imageOne:getContentSize().height+20))
						imageTwo:setContentSize(cc.size(imageTwo:getContentSize().width+ 340-150,imageTwo:getContentSize().height+20))
					
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
		
		_richText:setPosition(cc.p(- 340+150 + 20, -1 * tipHeight+5))
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

function AdventureChatSayMineCell:onEnterTransitionFinish()
    local csbChatStorage = csb.createNode("Chat/chat_list_2.csb")
	local root = csbChatStorage:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)	
	self:addChild(root)
	
	self:onUpdateDraw()
end


function AdventureChatSayMineCell:onExit()
	state_machine.remove("adventure_chat_say_mine_cell_click_head")
end

function AdventureChatSayMineCell:init(personId, name, info, isVip ,quality, pic)
	self.personId = personId
	self.name = name
	self.info = info
	
	self.isVip = isVip				-- 0 不是VIP   1 是VIP
	self.quality = quality			
	self.pic = pic			
end

function AdventureChatSayMineCell:createCell()
	local cell = AdventureChatSayMineCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


-- function AdventureChatSayMineCell:onHeadDraw()
-- 	local csbItem = csb.createNode("icon/item.csb")
-- 	local roots = csbItem:getChildByName("root")
-- 	roots:removeFromParent(true)
-- 	local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
-- 	local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
-- 	local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(self.quality)+1)
-- 	local big_icon_path = string.format("images/ui/props/props_%s.png", self.pic)
-- 	Panel_kuang:setBackGroundImage(quality_path)
-- 	Panel_head:setBackGroundImage(big_icon_path)
-- 	if tonumber(self.isVip) > 0 then
-- 		ccui.Helper:seekWidgetByName(roots, "Image_item_vip"):setVisible(true)
-- 	end
-- 	fwin:addTouchEventListener(Panel_head, nil, 
-- 	{
-- 		terminal_name = "adventure_chat_say_mine_cell_click_head", 	
-- 		_id = self.personId,
-- 		terminal_state = 0,
-- 	}, 
-- 	nil, 0)
	
-- 	return roots
-- end