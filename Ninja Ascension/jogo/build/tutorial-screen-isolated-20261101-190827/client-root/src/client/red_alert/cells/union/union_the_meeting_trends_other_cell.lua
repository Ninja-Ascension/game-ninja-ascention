--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅动态
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingTrendsOtherCell = class("UnionTheMeetingTrendsOtherCellClass", Window)
UnionTheMeetingTrendsOtherCell.__size = nil
--创建cell
local union_the_meeting_trends_other_create_cell_terminal = {
    _name = "union_the_meeting_trends_other_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local infoData = params[1]
        local index = params[2]
        local cell = UnionTheMeetingTrendsOtherCell:new()
        cell:init(infoData, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_the_meeting_trends_other_create_cell_terminal)
state_machine.init()

function UnionTheMeetingTrendsOtherCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.infoData = nil
	
	 -- Initialize union the meeting  trends list cell state machine.
    local function init_union_the_meeting_trends_other_cell_terminal()
		
        state_machine.init()
    end
    -- call func init union the meeting  trends list cell state machine.
    init_union_the_meeting_trends_other_cell_terminal()
end

function UnionTheMeetingTrendsOtherCell:updateDraw()
	-- ntype = npos(list),		--类型  1普通 2高级 3会长 4副会长 5精英 6普通 7踢 8退 9批准
	-- name = npos(list),	    --名称
	-- time = npos(list),	    --时间  
	-- param = npos(list),		--参数 
	local root = self.roots[1]
	local Text_dt_xinxi = ccui.Helper:seekWidgetByName(root, "Text_dt_xinxi"):setString("")
	Text_dt_xinxi:removeAllChildren(true)
	if self.infoData == nil then
		return
	end
	local timeInfo = os.date("%m".."-".."%d".." ".."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(self.infoData.time)/1000))
    local info = ""
    local info1 = ""
    local info2 = ""
    local info3 = ""
    if tonumber(self.infoData.ntype) == 1 or tonumber(self.infoData.ntype) == 2 then
    	local infoCount = tonumber(self.infoData.ntype) + 13
    	info1 = "%|3|"..self.infoData.name.."%"
    	if tonumber(self.infoData.ntype) == 1 then
            info2 = "%|5|"..tipStringInfo_union_str[infoCount].."%"
        elseif tonumber(self.infoData.ntype) == 2 then
            info2 = "%|6|"..tipStringInfo_union_str[infoCount].."%"
        end
    	info3 = "%|4|"..self.infoData.param.."%"
    	info = string.format(tipStringInfo_union_str[4], info1, info2, info3)
	elseif tonumber(self.infoData.ntype) == 3 
		or tonumber(self.infoData.ntype) == 4
		or tonumber(self.infoData.ntype) == 5
		or tonumber(self.infoData.ntype) == 6
		or tonumber(self.infoData.ntype) == 7
		then
		info1 = "%|3|"..self.infoData.name.."%"
		info2 = "%|4|"..self.infoData.param.."%"
		info3 = "%|1|"..timeInfo.."%"
		info = string.format(tipStringInfo_union_str[tonumber(self.infoData.ntype) + 2], info1, info3, info2)
	elseif tonumber(self.infoData.ntype) == 8 then
		info1 = "%|3|"..self.infoData.name.."%"
		-- info2 = "%|4|"..self.infoData.param.."%"
		info3 = "%|1|"..timeInfo.."%"
		info = string.format(tipStringInfo_union_str[10], info1, info3) 
	elseif tonumber(self.infoData.ntype) == 9 then
		info1 = "%|3|"..self.infoData.name.."%"
		info2 = "%|4|"..self.infoData.param.."%"
		info3 = "%|1|"..timeInfo.."%"
		info = string.format(tipStringInfo_union_str[11], info1, info2, info3)
	end
	local _richText,l = self:cutStringMain(info, tonumber(Text_dt_xinxi:getContentSize().height),18, tonumber(Text_dt_xinxi:getContentSize().width))
	_richText:setAnchorPoint(cc.p(0, 0.5))
	_richText:setPosition(cc.p(-_richText:getContentSize().width/2 + 5, 0))
	Text_dt_xinxi:removeAllChildren(true)
	Text_dt_xinxi:addChild(_richText)
end

function UnionTheMeetingTrendsOtherCell:cutStringMain(str, height, fontSize, width)
	local mRoot = ccui.RichText:create()
	local l = string.len(str)
	mRoot:ignoreContentAdaptWithSize(false)
	local count = 0
	while (l > 0) do
		local f,e = string.find(str, "%%%C-%%")
		if f == nil or e == nil then
			local re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[2][1], tipStringInfo_union_color[2][2], tipStringInfo_union_color[2][3]), 255, str, "fonts/simhei.ttf", fontSize)
			mRoot:pushBackElement(re)
			count = count + zstring.utfstrlen(str)
			break
		end
		if f > 1 then
			local strsub = string.sub(str, 1, f-1)
			count = count + zstring.utfstrlen(strsub)
			local re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[2][1], tipStringInfo_union_color[2][2], tipStringInfo_union_color[2][3]), 255, strsub, "fonts/simhei.ttf", fontSize)
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
		local re1 = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[color][1],tipStringInfo_union_color[color][2],tipStringInfo_union_color[color][3]), 255, name, "fonts/simhei.ttf", fontSize)
		mRoot:pushBackElement(re1)
		str = string.sub(str, e+1, l)
		l = string.len(str)
	end
	mRoot:setContentSize(cc.size(width-10, height+20))
	return mRoot, count
end

function UnionTheMeetingTrendsOtherCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.legion.legion_pro_hall_dongtai_list, "root")
    self:addChild(root)
    table.insert(self.roots, root)

    self:setContentSize(root:getContentSize())
    if UnionTheMeetingTrendsOtherCell.__size == nil then
        UnionTheMeetingTrendsOtherCell.__size = root:getContentSize()
    end
	ccui.Helper:seekWidgetByName(root, "Panel_dongtai_xinxi"):setTouchEnabled(false)
    
	self:updateDraw()
end

function UnionTheMeetingTrendsOtherCell:onEnterTransitionFinish()

end

function UnionTheMeetingTrendsOtherCell:init(infoData, index)
	self.infoData = infoData
    if index ~= nil and index < 6 then
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
	ccui.Helper:seekWidgetByName(root, "Text_dt_xinxi"):removeAllChildren(true)
    cacher.freeRef(config_csb.cells.legion.legion_pro_hall_dongtai_list, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function UnionTheMeetingTrendsOtherCell:onExit()
	if self.roots[1] ~= nil then
		local Text_dt_xinxi = ccui.Helper:seekWidgetByName(self.roots[1], "Text_dt_xinxi")
		if Text_dt_xinxi ~= nil then
			Text_dt_xinxi:removeAllChildren(true)
		end
		cacher.freeRef(config_csb.cells.legion.legion_pro_hall_dongtai_list, self.roots[1])
	end
end

function UnionTheMeetingTrendsOtherCell:createCell()
	local cell = UnionTheMeetingTrendsOtherCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
