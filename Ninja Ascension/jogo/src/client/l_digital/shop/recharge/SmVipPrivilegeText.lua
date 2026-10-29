-- ----------------------------------------------------------------------------------------------------
-- 说明：smVIP介绍文字
-------------------------------------------------------------------------------------------------------
SmVipPrivilegeText = class("SmVipPrivilegeTextClass", Window)
function SmVipPrivilegeText:ctor()
    self.super:ctor()
    self.roots = {}
    self.text = ""
end

function SmVipPrivilegeText:onUpdateDraw()
	local root = self.roots[1]
	local Text_vip_text = ccui.Helper:seekWidgetByName(root, "Text_vip_text")
	local str = zstring.replace(self.text , "%%|%d+|","")
	str = zstring.replace(str , "%%","")
	Text_vip_text:setString(str)
	local max_width = Text_vip_text:getAutoRenderSize().width
	Text_vip_text:setString("")
	local _richText2 = ccui.RichText:create()
	_richText2:ignoreContentAdaptWithSize(false)

	local richTextWidth = root:getContentSize().width - 50
    if richTextWidth == 0 then
        richTextWidth = Text_vip_text:getFontSize() * 6
    end
			    
	_richText2:setContentSize(cc.size(richTextWidth, 0))
	_richText2:setAnchorPoint(cc.p(0, 0))

	if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        color_Type_1 = cc.c3b(0, 0, 0)
        color_Type_2 = cc.c3b(0, 0, 0)
	elseif __lua_project_id == __lua_project_l_digital then
		-- DSC重塑
		color_Type_1 = Text_vip_text:getColor()
		color_Type_2 = Text_vip_text:getColor()
	else
        color_Type_1 = cc.c3b(189, 206, 224)
        color_Type_2 = cc.c3b(189, 206, 224)
    end

	local rt, count, text = draw.richTextCollectionMethod(_richText2, 
	self.text, 
	color_Type_1,
	color_Type_2,
	0, 
	0, 
	Text_vip_text:getFontName(), 
	Text_vip_text:getFontSize(),
	chat_rich_text_color)
	_richText2:setPositionX(- _richText2:getContentSize().width / 2)
    _richText2:setPositionY(Text_vip_text:getFontSize() / 2)
	Text_vip_text:addChild(_richText2)

	local heightN = math.ceil( max_width / tonumber(root:getContentSize().width))
	local height = heightN * (Text_vip_text:getFontSize() + 8)
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		local Image_zs = ccui.Helper:seekWidgetByName(root, "Image_zs")
		local pixHeight = height - root:getContentSize().height
		Image_zs.__orginY = Image_zs:getPositionY()
		Text_vip_text.__orginY = Text_vip_text:getPositionY()
		if pixHeight > 0 then 
			Text_vip_text:setPositionY( Text_vip_text:getPositionY() + pixHeight)
			Image_zs:setPositionY( Image_zs:getPositionY() + pixHeight)
		end
		root.__orginY = root:getPositionY()
		root.__orginSize = root:getContentSize()
		root:setPositionY(root:getPositionY() + pixHeight)
		root:setContentSize(root:getContentSize().width , height)
		
		self:setContentSize(cc.size(root:getContentSize().width , height))
	else
		if height > root:getContentSize().height then
			root:setPositionY( height - root:getContentSize().height)
		end
		self:setContentSize(cc.size(root:getContentSize().width , height))
	end
end

function SmVipPrivilegeText:onInit()
	local root = cacher.createUIRef("player/vip_privileges_text.csb", "root")
	root:removeFromParent(false)
    table.insert(self.roots, root)
 	self:addChild(root)
	self:onUpdateDraw()
end

function SmVipPrivilegeText:init(text )
	self.text = text
	self:onInit()
end

function SmVipPrivilegeText:createCell()
	local cell = SmVipPrivilegeText:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function SmVipPrivilegeText:clearUIInfo( ... )
	local root = self.roots[1]
	local Text_vip_text = ccui.Helper:seekWidgetByName(root, "Text_vip_text")
	if Text_vip_text ~= nil then
		Text_vip_text:setString("")
		Text_vip_text:removeAllChildren(true)
	end
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		local Image_zs = ccui.Helper:seekWidgetByName(root, "Image_zs")
		if Image_zs.__orginY then 
			Image_zs:setPositionY(Image_zs.__orginY)
		end
		if Text_vip_text.__orginY then 
			Text_vip_text:setPositionY(Text_vip_text.__orginY)
		end
		if root.__orginY then 
			root:setPositionY(root.__orginY)
		end
		if root.__orginSize then 
			root:setContentSize(root.__orginSize)
		end
	end

end

function SmVipPrivilegeText:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef("player/vip_privileges_text.csb", root)
end
