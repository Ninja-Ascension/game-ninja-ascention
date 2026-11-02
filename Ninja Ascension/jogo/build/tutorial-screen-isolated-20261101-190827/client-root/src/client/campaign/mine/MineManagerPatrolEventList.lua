----------------------------------------------------------------------------------------------------
-- 说明：武将巡逻时的发生事件
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
MineManagerPatrolEventList = class("MineManagerPatrolEventListClass", Window)
    
function MineManagerPatrolEventList:ctor()
    self.super:ctor()
    self.roots = {}
end


function MineManagerPatrolEventList:onEnterTransitionFinish()
	local csbHeroChooseForRebornCell = csb.createNode("campaign/MineManager/attack_territory_patrol_infoma.csb")
	local root = csbHeroChooseForRebornCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	self.eventPanel = ccui.Helper:seekWidgetByName(root, "Panel_2012")
	self.eventTime = ccui.Helper:seekWidgetByName(root, "Text_1058")
	self.eventTextPanel = ccui.Helper:seekWidgetByName(root, "Panel_3045")
	
	local size = self.eventPanel:getContentSize()

	
	
	self.timePanel = ccui.Helper:seekWidgetByName(root, "Panel_2012_0")
	self.timeTitle = ccui.Helper:seekWidgetByName(root, "Text_10_2")
	self.timeText = ccui.Helper:seekWidgetByName(root, "Text_10_2_0")
	
	
	self.strPanel = ccui.Helper:seekWidgetByName(root, "Panel_2012_0_0")
	self.strText = ccui.Helper:seekWidgetByName(root, "Text_10_2_2")
	
	
	if 1 == self.etype then
		self:initType()
		self:setContentSize(cc.size(560,100))
		self.eventTextPanel:setContentSize(cc.size(560,90))
	elseif 2 == self.etype then
		self:updateCountdown()
		self:setContentSize(size)
	elseif 3 == self.etype then
		self:initString()
		self:setContentSize(size)
	end
end

function MineManagerPatrolEventList:getQualityColor(i)
	return cc.c3b(color_Type[i][1],
		color_Type[i][2],
		color_Type[i][3])
end

function MineManagerPatrolEventList:getGoodsInfo(mouldId, gtype)
	-- 按171奖励类型解析
	app.load("client.cells.prop.model_prop_icon_cell")
	local info = ModelPropIconCell.getGoodInfo(mouldId, gtype)
	local name 	= info.name
	local quality = info.quality
	return name, self:getQualityColor(quality)
end
function MineManagerPatrolEventList:getHeroInfo(mouldId)
	local name 	= dms.string(dms["ship_mould"], mouldId, ship_mould.captain_name)
	local quality = dms.int(dms["ship_mould"], mouldId, ship_mould.ship_type)+1
	

	return name, self:getQualityColor(quality)
end

-- 1430952989901 0 吹雪 1,1,1 2  
-- 0 类型事件用的 2 3 事件
function MineManagerPatrolEventList:cutStringMain(str, width, heroName, heroColor,  goodsName, goodsCount,  goodsColor, textColor)
	local mRoot = ccui.RichText:create()
	local fontSize = 20
	mRoot:ignoreContentAdaptWithSize(false)
	
	-- 名字之前可能有文字也可能没有
	-- 末尾可能是物品结尾,也可能其他结尾
	
	local textColor = textColor or cc.c3b(tipStringInfo_mine_patrol_color[2][1], tipStringInfo_mine_patrol_color[2][2], tipStringInfo_mine_patrol_color[2][3])
	
	local strNum = 0
	

	-- 一段段分解字符串
	local startIndex,endIndex = string.find(str, "|x|")
	
	if startIndex > 1 then
		--  名字前的一段话
		local tempStr = string.sub(str, 1, startIndex-1)
		local re = ccui.RichElementText:create(1, textColor, 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
		mRoot:pushBackElement(re)
		strNum = strNum + string.len(tempStr)
	
	end
	
	-- 名字
	local tempStr = "["..heroName.."]"
	local re = ccui.RichElementText:create(1, heroColor, 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
	mRoot:pushBackElement(re)
	strNum = strNum + string.len(tempStr)

	-- 名字后的一段话,到物品之前
	local tempStr = string.sub(str, endIndex+1)
	local startIndex,endIndex = string.find(tempStr, "|y|")
	local tempStr = string.sub(tempStr, 1,startIndex-1)
	local re = ccui.RichElementText:create(1, textColor, 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
	mRoot:pushBackElement(re)
	strNum = strNum + string.len(tempStr)

	-- 物品名和数量
	local tempStr = goodsName.."x"..goodsCount
	local re = ccui.RichElementText:create(1, goodsColor, 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
	mRoot:pushBackElement(re)
	strNum = strNum + string.len(tempStr)

	-- 物品名之后的
	local startIndex,endIndex = string.find(str, "|y|")

	if string.len(string.sub(str,endIndex+1)) > 0 then

		local tempStr = string.sub(str,endIndex+1)
		local re = ccui.RichElementText:create(1, textColor, 255, tempStr, "fonts/FZYiHei-M20S.ttf", fontSize)
		mRoot:pushBackElement(re)
		strNum = strNum + string.len(tempStr)

	end

	local n = math.ceil(width / fontSize)

	local m = math.ceil(strNum*.5 / n)

	local height = m*fontSize
	
	
	mRoot:setContentSize(cc.size(width, height))

	return mRoot, height
end

function MineManagerPatrolEventList:initType()
	-- self.data 是 事件索引
	local i = tonumber(self.data)
	local item = _ED.manor_patrol_info_describe[i]
	local goods = zstring.split(item[4], ",")
	local goodsName, goodsColor = self:getGoodsInfo(goods[1],goods[2])
	local goodsCount = goods[3]
	local dateStr = os.date("%X",math.floor(tonumber(item[1])/1000))
	local eIndex = tonumber(item[5])
	local eType = tonumber(item[2])
	
	self.eventTime:setString(string.format(tipStringInfo_mine_info[24], dateStr))
	
	local gwidth = self.eventTextPanel:getContentSize().width
	local gheight = self.eventTextPanel:getContentSize().height

	local heroName, heroColor = self:getHeroInfo(tonumber(_ED.manor_patrol_hero_id))
	
	local str =""
	local _richText = nil
	local textColor = nil
	local _richTextHeight = 0
	
	if eType == 0 then -- 普通
	
		-- str = dms.string(dms["patrol_reward"], eIndex, patrol_reward.event)
		-- _richText = self:cutStringMain(dateStr, str ,gwidth, heroName, heroColor, goodsName, goodsCount,  goodsColor)
	
	elseif eType == 1 then -- 暴动
		-- str = dms.string(dms["patrol_reward"], eIndex, patrol_reward.event)
		-- _richText = self:cutStringRiot(dateStr, str, gwidth)
		
	elseif eType == 2 then -- 镇压
		
		-- heroName  = item[3]
		-- heroColor = cc.c3b(tipStringInfo_mine_patrol_color[4][1], tipStringInfo_mine_patrol_color[4][2], tipStringInfo_mine_patrol_color[4][3])
		-- textColor = cc.c3b(tipStringInfo_mine_patrol_color[4][1], tipStringInfo_mine_patrol_color[4][2], tipStringInfo_mine_patrol_color[4][3])
	
		-- str = tipStringInfo_mine_info[14]
		-- _richText = self:cutStringMain(dateStr, str ,gwidth, heroName, heroColor, goodsName, goodsCount,  goodsColor,textColor)
		
	elseif eType == 3 then -- 结束
		
		-- 第一条起始时间 和 末尾的结束时间 的 差值
		textColor = cc.c3b(tipStringInfo_mine_patrol_color[5][1], tipStringInfo_mine_patrol_color[5][2], tipStringInfo_mine_patrol_color[5][3])
		timeLen = math.floor((item[1] - _ED.manor_patrol_info_describe[1][1])/1000) / 3600
		timeLen = math.floor(timeLen)+1
		str = string.format(tipStringInfo_mine_info[15],timeLen)..tipStringInfo_mine_info[16]
		_richText,_richTextHeight = self:cutStringMain(str ,gwidth, heroName, heroColor, goodsName, goodsCount,  goodsColor,textColor)
	
	end
	
	if nil ~= _richText then
		_richTextHeight = 100
	
		local rtxSize = _richText:getContentSize()
		local tpSize = self.eventTextPanel:getContentSize()
		local size = self:getContentSize()
		
		self.eventTextPanel:addChild(_richText)
		self.eventTextPanel:setContentSize(cc.size(tpSize.width, _richTextHeight))
		--self.roots[1]:setContentSize(cc.size(size.width, _richTextHeight))
		--self:setContentSize(cc.size(size.width, _richTextHeight))
		
		--self:setContentSize(cc.size(560,100))
		
		_richText:setPosition(cc.p(50,50))
	end
	
	
end


function MineManagerPatrolEventList:initString()
	local str = tostring(self.data)
	
	self.strText:setString(str)
end

function MineManagerPatrolEventList:initCountdown()
	self.timeTitle:setString(tipStringInfo_mine_info[13])
	self.timeText:setString("--:--:--")
end

function MineManagerPatrolEventList:updateCountdown(str)
	self.timeText:setString(str)
end

function MineManagerPatrolEventList:onExit()
	
end

-- 显示类型(1 事件/ 2 倒计时/ 3 文本), 数据
function MineManagerPatrolEventList:init(etype, data)
	self.etype = etype
	self.data = data
end

function MineManagerPatrolEventList:createCell()
	local cell = MineManagerPatrolEventList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end