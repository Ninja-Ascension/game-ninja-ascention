-- ----------------------------------------------------------------------------------------------------
-- 说明：VIP权限list
-- 创建时间2015-05-05
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
VipPrivilegeListOne = class("VipPrivilegeListOneClass", Window)

function VipPrivilegeListOne:ctor()
    self.super:ctor()
    self.roots = {}
    self.textNum = nil
end

function VipPrivilegeListOne:onUpdateDraw()
	local root = self.roots[1]
	local one = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_1")
	local two = ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_2")
	one:setString(_string_piece_info[228] .. self.textNum)
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_16")
	local text = ccui.Helper:seekWidgetByName(root, "Text_20")
	local ListView_vip_text=nil
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
		or __lua_project_id == __lua_project_legendary_game 
		then
		ListView_vip_text=ccui.Helper:seekWidgetByName(panel, "ListView_vip_text")
	end
	
	local vip = {}
	vip[1] = _vip_privilege_info.privilege_one
	vip[2] = _vip_privilege_info.privilege_two
	vip[3] = _vip_privilege_info.privilege_three
	vip[4] = _vip_privilege_info.privilege_four
	vip[5] = _vip_privilege_info.privilege_five
	vip[6] = _vip_privilege_info.privilege_six
	vip[7] = _vip_privilege_info.privilege_seven
	vip[8] = _vip_privilege_info.privilege_eight
	vip[9] = _vip_privilege_info.privilege_nine
	vip[10] = _vip_privilege_info.privilege_ten
	vip[11] = _vip_privilege_info.privilege_eleven
	vip[12] = _vip_privilege_info.privilege_twelve
	vip[13] = _vip_privilege_info.privilege_thirteen
	vip[14] = _vip_privilege_info.privilege_fourteen
	vip[15] = _vip_privilege_info.privilege_fifteen
	local str = zstring.split(vip[tonumber(self.textNum)+1], "/r/n")
	local sizeX = panel:getContentSize().width
	local sizeY = panel:getContentSize().height
	local panel_high = panel:getPositionY()
	local panel_width = panel:getPositionX()
	local label_UI = csb.createNode("utils/version_length.csb")
	local label_root = label_UI:getChildByName("root")
	local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
	local lableBaseSize = lableCell:getContentSize()
	local tipHeight = 0
	
	local num = table.getn(str)
	for i = 1, table.getn(str) do
		local lableCell = cc.Label:createWithTTF(str[num - i+1], lableCell:getFontName(), 
			20, cc.size(lableBaseSize.width-35, 0), 
			cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		if __lua_project_id == __lua_project_warship_girl_a
			or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_yugioh
			then
			lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[12][1],tipStringInfo_quality_color_Type[12][2],tipStringInfo_quality_color_Type[12][3]))
		else
			lableCell:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][2]))
		end
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
			or __lua_project_id == __lua_project_legendary_game 
			then
			ListView_vip_text:addChild(lableCell)
		else
			panel:addChild(lableCell)
		end
		
		lableCell:setAnchorPoint(CCPoint(0, 1))-->设置锚点
		local lableSize = lableCell:getContentSize()
		
		tipHeight = tipHeight + lableSize.height
		lableCell:setPosition(cc.p(lableCell:getPositionX()+10,  tipHeight+30-8))
	end
	panel:setContentSize(cc.size(sizeX,tipHeight + sizeY))
	self:setContentSize(cc.size(sizeX,tipHeight +sizeY+30))
	panel:setPosition(panel_width,tipHeight +panel_high)
	one:setPosition(one:getPositionX(),one:getPositionY()+ tipHeight+30)
	two:setPosition(two:getPositionX(),two:getPositionY()+ tipHeight+30)
end

function VipPrivilegeListOne:onEnterTransitionFinish()
	local csbVipPrivilegeListOne = csb.createNode("player/vip_privileges_list_1.csb")
    self:addChild(csbVipPrivilegeListOne)
	
	local root = csbVipPrivilegeListOne:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end

function VipPrivilegeListOne:onExit()

end

function VipPrivilegeListOne:init(textNum)
	self.textNum = textNum
end

function VipPrivilegeListOne:createCell()
	local cell = VipPrivilegeListOne:new()
	cell:registerOnNodeEvent(cell)
	return cell
end