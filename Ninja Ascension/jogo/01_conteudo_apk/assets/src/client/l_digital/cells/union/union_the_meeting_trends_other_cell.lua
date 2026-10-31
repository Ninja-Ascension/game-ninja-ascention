--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅动态
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingTrendsOtherCell = class("UnionTheMeetingTrendsOtherCellClass", Window)
UnionTheMeetingTrendsOtherCell.__size = nil

function UnionTheMeetingTrendsOtherCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.infoData = nil

	self.max = 8
    if __lua_project_id == __lua_project_l_digital then
        self.max = 10
    end
	
	 -- Initialize union the meeting  trends list cell state machine.
    local function init_union_the_meeting_trends_other_cell_terminal()
		
        state_machine.init()
    end
    -- call func init union the meeting  trends list cell state machine.
    init_union_the_meeting_trends_other_cell_terminal()

end

function UnionTheMeetingTrendsOtherCell:updateDraw()
-- 			ntype = npos(list),		--类型  0,1,2jianse   3 fuben  4 jiaru 5 tuichu  6tanhe  7 yijiao  8 tichu 
-- 			name = npos(list),	    --名称  
-- 			quality1 = npos(list),	--价值1 --建设才有 0 为暴击 1 暴击
-- 			quality2 = npos(list),	--价值2  -- 要显示的  
-- 			dateTime = npos(list),	--时间
	local root = self.roots[1]
	local Text_shijian_t = ccui.Helper:seekWidgetByName(root, "Text_shijian_t"):setString("")
	local Text_dt_xinxi = ccui.Helper:seekWidgetByName(root, "Text_dt_xinxi"):setString("")
	if self.infoData == nil then
		return
	end
	timeInfo = os.date("%m".."-".."%d".." ".."%H"..":".."%M", getBaseGTM8Time(zstring.exchangeFrom(zstring.tonumber(self.infoData.dateTime)/1000)))
    Text_shijian_t:setString("["..timeInfo.."]")
    Text_shijian_t:setColor(cc.c3b(tipStringInfo_union_dynamic_color[1][1], tipStringInfo_union_dynamic_color[1][2], tipStringInfo_union_dynamic_color[1][3]))
    local info = ""
    local info1 = ""
    local info2 = ""
    local info3 = ""
    local info4 = ""
    local info5 = ""
    if tonumber(self.infoData.ntype) == 0 or tonumber(self.infoData.ntype) == 1    
    	or tonumber(self.infoData.ntype) == 2 then  		-- 建设
    	local infoCount = tonumber(self.infoData.ntype) + 13
    	info1 = "%|3|"..self.infoData.name.."%"
    	-- info2 = "%|6|"..tipStringInfo_union_str[infoCount].."%"
    	if tonumber(self.infoData.ntype) == 0 then
            info2 = "%|6|"..tipStringInfo_union_str[infoCount].."%"
        elseif tonumber(self.infoData.ntype) == 1 then
            info2 = "%|7|"..tipStringInfo_union_str[infoCount].."%"
        elseif tonumber(self.infoData.ntype) == 2 then
            info2 = "%|8|"..tipStringInfo_union_str[infoCount].."%"
        end
    	info3 = "%|4|"..self.infoData.quality2.."%"
    	if tonumber(self.infoData.quality1) == 0 then
    		info = string.format(tipStringInfo_union_str[4], info1, info2, info3)
    	else
    		info = string.format(tipStringInfo_union_str[5], info1, info2, info3)
    	end
	elseif tonumber(self.infoData.ntype) == 3 then  --副本还未做
		info1 = "%|5|"..self.infoData.name.."%"
		info2 = "%|4|"..self.infoData.name.."%"
		info = string.format(tipStringInfo_union_str[10], info1, info2, self.infoData.quality2)
	elseif tonumber(self.infoData.ntype) == 4 then   -- 加入
		info1 = "%|3|"..self.infoData.name.."%"
		info = string.format(tipStringInfo_union_str[6], info1) 
	elseif tonumber(self.infoData.ntype) == 5 then   -- 退出
		info1 = "%|3|"..self.infoData.name.."%"
		info = string.format(tipStringInfo_union_str[12], info1)
	elseif tonumber(self.infoData.ntype) == 6 then   --弹劾
		info1 = "%|3|"..self.infoData.name.."%"
		info = string.format(tipStringInfo_union_str[8], "",info1,info1)
	elseif tonumber(self.infoData.ntype) == 7 then
		info1 = "%|3|"..self.infoData.name.."%"
		if tonumber(self.infoData.quality1) == 0 then  -- 移交舰长
			info = string.format(tipStringInfo_union_str[53],info1,info1)
		elseif tonumber(self.infoData.quality1) == 1 then -- 任命副会长
			info = string.format(tipStringInfo_union_str[54],info1)
		elseif tonumber(self.infoData.quality1) == 2 then  -- 罢免副会长
			info = string.format(tipStringInfo_union_str[55],info1)
		end
	elseif tonumber(self.infoData.ntype) == 8 then  --踢出
		info1 = "%|3|"..self.infoData.name.."%"
		info = string.format(tipStringInfo_union_str[7],info1)
	end
	local _richText,l = self:cutStringMain(info,tonumber(Text_dt_xinxi:getContentSize().height),24, tonumber(Text_dt_xinxi:getContentSize().width), Text_dt_xinxi:getFontName())
	_richText:setAnchorPoint(cc.p(0, 1))
	_richText:setPosition(cc.p(Text_dt_xinxi:getPositionX()- Text_dt_xinxi:getContentSize().width/2, Text_dt_xinxi:getPositionY()+Text_dt_xinxi:getContentSize().height-6))
	Text_dt_xinxi:removeAllChildren(true)
	Text_dt_xinxi:addChild(_richText)

end
function UnionTheMeetingTrendsOtherCell:cutStringMain(str, height, fontSize, width, fontName)
	local mRoot = ccui.RichText:create()
	fontSize = fontSize or 10
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		fontSize=20
	end
	local l = string.len(str)
	mRoot:ignoreContentAdaptWithSize(false)
	local count = 0
	while (l > 0) do
		local f,e = string.find(str, "%%%C-%%")
		if f == nil or e == nil then
			local re = nil
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				if verifySupportLanguage(_lua_release_language_en) == true then
					re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_dynamic_color[2][1], tipStringInfo_union_dynamic_color[2][2], tipStringInfo_union_dynamic_color[2][3]), 255, str, "", fontSize)
				else
					re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_dynamic_color[2][1], tipStringInfo_union_dynamic_color[2][2], tipStringInfo_union_dynamic_color[2][3]), 255, str, fontName, fontSize)
				end
			else
				re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_dynamic_color[2][1], tipStringInfo_union_dynamic_color[2][2], tipStringInfo_union_dynamic_color[2][3]), 255, str, fontName, fontSize)
			end
			mRoot:pushBackElement(re)
			count = count + zstring.utfstrlen(str)

			break
		end
		if f > 1 then
			local strsub = string.sub(str, 1, f-1)
			count = count + zstring.utfstrlen(strsub)
			local re = nil
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				if verifySupportLanguage(_lua_release_language_en) == true then
					re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_dynamic_color[2][1], tipStringInfo_union_dynamic_color[2][2], tipStringInfo_union_dynamic_color[2][3]), 255, strsub, "", fontSize)
				else
					re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_dynamic_color[2][1], tipStringInfo_union_dynamic_color[2][2], tipStringInfo_union_dynamic_color[2][3]), 255, strsub, fontName, fontSize)
				end
			else
				re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_dynamic_color[2][1], tipStringInfo_union_dynamic_color[2][2], tipStringInfo_union_dynamic_color[2][3]), 255, strsub, fontName, fontSize)
			end
			mRoot:pushBackElement(re)
		end
		local name = string.sub(str, f+1, e-1)
		local f1, e1 = string.find(name, "%d+")
		if name == nil or f1 == nil or e1 == nil then
			mRoot:removeAllChildrenWithCleanup(true)
			break
		end
		local quality = string.sub(name, f1, e1)
		local color = tonumber(quality)
		name = string.sub(name, e1+2, string.len(name))
		count = count + zstring.utfstrlen(name)
		if color == nil or color <= 0 or color > 11 then
			mRoot:removeAllChildrenWithCleanup(true)
			break
		end
		local re1 = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if verifySupportLanguage(_lua_release_language_en) == true then
				re1 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_dynamic_color[color][1],tipStringInfo_union_dynamic_color[color][2],tipStringInfo_union_dynamic_color[color][3]), 255, name, "", fontSize)
			else
				re1 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_dynamic_color[color][1],tipStringInfo_union_dynamic_color[color][2],tipStringInfo_union_dynamic_color[color][3]), 255, name, fontName, fontSize)
			end
		else
			re1 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_dynamic_color[color][1],tipStringInfo_union_dynamic_color[color][2],tipStringInfo_union_dynamic_color[color][3]), 255, name, fontName, fontSize)
		end
		mRoot:pushBackElement(re1)
		str = string.sub(str, e+1, l)
		l = string.len(str)
	end
	if width ~= nil and width > 0 then
		mRoot:setContentSize(cc.size(width-15, height+20))
	else
		mRoot:setContentSize(cc.size(fontSize*count+15, height+20))
	end
	
	return mRoot, count
end

function UnionTheMeetingTrendsOtherCell:onInit()
    local csbUnionTrendsCell = csb.createNode("legion/legion_pro_hall_dongtai_list.csb")
    local root = csbUnionTrendsCell:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionTrendsCell)

	-- local root = cacher.createUIRef("legion/legion_pro_hall_dongtai_list.csb", "root")
 --    table.insert(self.roots, root)
 --    self:addChild(root)
    self:setContentSize(root:getContentSize())

    if UnionTheMeetingTrendsOtherCell.__size == nil then
        UnionTheMeetingTrendsOtherCell.__size = root:getContentSize()
    end

	self:updateDraw()
end

function UnionTheMeetingTrendsOtherCell:onEnterTransitionFinish()

end

function UnionTheMeetingTrendsOtherCell:init(infoData, index)
	self.infoData = infoData
    if index ~= nil and index < self.max then
        self:onInit()
    end
	self:setContentSize(UnionTheMeetingTrendsOtherCell.__size)
	return self
end

function UnionTheMeetingTrendsOtherCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionTheMeetingTrendsOtherCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    cacher.freeRef("legion/legion_pro_hall_dongtai_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function UnionTheMeetingTrendsOtherCell:onExit()
	cacher.freeRef("legion/legion_pro_hall_dongtai_list.csb", self.roots[1])
end

function UnionTheMeetingTrendsOtherCell:createCell()
	local cell = UnionTheMeetingTrendsOtherCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
