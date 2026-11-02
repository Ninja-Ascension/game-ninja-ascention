-----HeroRecruitPreview.lua-----------------------------------------------------------------------------------------------------------
-- 说明：招募预览界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
-- require "src/client/loader/LocalDatas"

HeroRecruitPreviewTwo = class("HeroRecruitPreviewTwoClass", Window)
    
function HeroRecruitPreviewTwo:ctor()
    self.super:ctor()
	self.roots = {}
	self.types  = nil
end


function HeroRecruitPreviewTwo:onHeadDraw(id)
	local csbItem = nil 
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		csbItem = csb.createNode("icon/item_recruit.csb")
	else
		csbItem = csb.createNode("icon/item.csb")
	end
	local roots = csbItem:getChildByName("root")
	roots:removeFromParent(true)
	local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
	local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if Panel_head ~= nil then
	        Panel_head:removeAllChildren(true)
	        Panel_head:removeBackGroundImage()
	    end
	    if Panel_kuang ~= nil then
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
    end
	local name = ccui.Helper:seekWidgetByName(roots, "Label_name")
	local quality = dms.int(dms["ship_mould"], id, ship_mould.ship_type)
	local pic = dms.int(dms["ship_mould"], id, ship_mould.head_icon)
	
	local big_icon_path = string.format("images/ui/props/props_%s.png", pic)
	local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality)+1)
	
	Panel_kuang:setBackGroundImage(quality_path)
	Panel_head:setBackGroundImage(big_icon_path)
	name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		-- local ship_evo = zstring.split(fundShipWidthId(""..shipID).evolution_status, "|")
		local evo_mould_id = evo_info[dms.int(dms["ship_mould"], id, ship_mould.captain_name)]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
    	local nameString = word_info[3]
		name:setString(nameString)
	else
		name:setString(dms.string(dms["ship_mould"], id, ship_mould.captain_name))
	end
	fwin:addTouchEventListener(Panel_head, nil, 
	{
		terminal_name = "hero_recruit_preview_show_info", 	
		_id = id,
		terminal_state = 0,
	}, 
	nil, 0)
	
	return roots
end

function HeroRecruitPreviewTwo:onUpdateDraw()
	local root = self.roots[1]
	local green = {}
	local blue = {}
	local purple = {}
	local orange = {}
	local all = {}
	local last = {}
	local lastAll = {}
	local arr1 = dms.searchs(dms["bounty_hero_param"], bounty_hero_param.bounty_group, 5)
	local arr2 = dms.searchs(dms["bounty_hero_param"], bounty_hero_param.bounty_group, 6)
	local arr3 = dms.searchs(dms["bounty_hero_param"], bounty_hero_param.bounty_group, 7)
	local arr4 = dms.searchs(dms["bounty_hero_param"], bounty_hero_param.bounty_group, 8)
	for i = 1 , table.getn(arr1) do
		local id = arr1[i][3]
		local quality = dms.int(dms["ship_mould"], id, ship_mould.ship_type)
		if quality == 1 then
			table.insert(green, id)
		elseif quality == 2 then
			table.insert(blue, id)
		elseif quality == 3 then
			table.insert(purple, id)
		elseif quality == 4 then
			table.insert(orange, id)
		end
	end
	for i = 1 , table.getn(arr2) do
		local id = arr2[i][3]
		local quality = dms.int(dms["ship_mould"], id, ship_mould.ship_type)
		if quality == 1 then
			table.insert(green, id)
		elseif quality == 2 then
			table.insert(blue, id)
		elseif quality == 3 then
			table.insert(purple, id)
		elseif quality == 4 then
			table.insert(orange, id)
		end
	end
	for i = 1 , table.getn(arr3) do
		local id = arr3[i][3]
		local quality = dms.int(dms["ship_mould"], id, ship_mould.ship_type)
		if quality == 1 then
			table.insert(green, id)
		elseif quality == 2 then
			table.insert(blue, id)
		elseif quality == 3 then
			table.insert(purple, id)
		elseif quality == 4 then
			table.insert(orange, id)
		end
	end
	for i = 1 , table.getn(arr4) do
		local id = arr4[i][3]
		local quality = dms.int(dms["ship_mould"], id, ship_mould.ship_type)
		if quality == 1 then
			table.insert(green, id)
		elseif quality == 2 then
			table.insert(blue, id)
		elseif quality == 3 then
			table.insert(purple, id)
		elseif quality == 4 then
			table.insert(orange, id)
		end
	end
	if self.types == 2 then
		for i, v in ipairs(orange) do
			table.insert(all, v)
		end
	end
	for i, v in ipairs(purple) do
		table.insert(all, v)
	end
	for i, v in ipairs(blue) do
		table.insert(all, v)
	end
	for i, v in ipairs(green) do
		table.insert(all, v)
	end
	local num = 1
	for i , v in pairs(all) do
		local status = true
		for j,k in pairs(lastAll) do
			if k == v then
				status = false
			end
		end
		if status == true then
			num = num + 1
			table.insert(lastAll,v)
		end
	end

	-- [[绘制滚动层
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_diguo_1")
	local panel = ccui.Layout:create()
	panel:setContentSize(m_ScrollView:getContentSize())
	
	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)
	m_ScrollView:addChild(panel)
	local sSize = panel:getContentSize()
	local controlSize = m_ScrollView:getInnerContainerSize()
	local cellWidth = sSize.width / 4
	local function addRewardScrollView(_index,id)
		local tempCell = self:onHeadDraw(id)
		local cellHeight = tempCell:getContentSize().height+20

		local row = math.floor((_index - 1) / 4 + 1)
		local col = math.floor((_index - 1) % 4)
		
		local controlHeight = row * cellHeight
		
		if controlHeight < sSize.height then
			controlSize.height = sSize.height
		else
			controlSize.height = controlHeight + cellHeight
		end
		local pos = nil
		if num > 16 then
			m_ScrollView:setInnerContainerSize(cc.size(controlSize.width, controlSize.height - cellHeight))
			
			pos = cc.p(cellWidth * col + (cellWidth - tempCell:getContentSize().width)/2,
				sSize.height - cellHeight * row-cellHeight+20)
		else
			m_ScrollView:setInnerContainerSize(cc.size(controlSize.width, controlSize.height))
			
			pos = cc.p(cellWidth * col + (cellWidth - tempCell:getContentSize().width)/2,
				sSize.height - cellHeight * row)
		end
		tempCell:setPosition(pos)
		panel:addChild(tempCell)
		panel:setPositionY(controlSize.height - sSize.height)
		return tempCell
	end
	for i , v in pairs(lastAll) do
		addRewardScrollView(i,v)
	end
	
end

function HeroRecruitPreviewTwo:onEnterTransitionFinish()
	-- [[-------------------------------------
	-- add map for trial tower
    local csbHeroRecruitPreview = csb.createNode("shop/merchants_will_preview_diguo.csb")
	local root = csbHeroRecruitPreview:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbHeroRecruitPreview)
	self:onUpdateDraw()
	self:setContentSize(ccui.Helper:seekWidgetByName(root, "ScrollView_diguo_1"):getContentSize())
end

function HeroRecruitPreviewTwo:init(types)
	self.types = types
end

function HeroRecruitPreviewTwo:onExit()
end
function HeroRecruitPreviewTwo:createCell()
	local cell = HeroRecruitPreviewTwo:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
