---------------------------------
---说明：阵容里面的武将羁绊信息
---------------------------------

ShipPartnerInfoCell = class("ShipPartnerInfoCellClass", Window)
   
function ShipPartnerInfoCell:ctor()
    self.super:ctor()
	self.user_formetion_status = {"1770","0","0","0","0","0"} --上阵的实例ID
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
end

function ShipPartnerInfoCell:onUpdateDraw()
	local root = self.roots[1]
	local frameAddCount = 0
	local fontSize = 20
	local describe = 0
	for i = 1,6 do
		if tonumber(self.user_formetion_status[i]) ~= 0 then
		
			local ship = fundShipWidthId(self.user_formetion_status[i])
			local title = ccui.Helper:seekWidgetByName(root, "Panel_41")
			local title1 = ccui.Helper:seekWidgetByName(root, "Text_29")
			local Count = ccui.Helper:seekWidgetByName(root, "Text_30")
			frameAddCount = frameAddCount + title:getContentSize().height
			local xx, yy = title:getPosition()
			title:setPosition(cc.p(xx, yy - frameAddCount))
			for i=1 ,tonumber(ship.relationship_count) do
				local relationMould = ship.relationship[i]
				local relationInfo = dms.string(dms["fate_relationship_mould"],tonumber(relationMould.relationship_id),fate_relationship_mould.relation_name)
				--> print("")
				--名称
				local relationName = ccui.TextField:create()
				relationName:setString(relationInfo)
				if m_tReleaseLanguage >= 3 then
					relationName:setTextAreaSize(cc.size(fontSize*8, 0))
				end	
				relationName:setFontName("fonts/FZYiHei-M20S.ttf")-->设置字体名字
				relationName:setFontSize(fontSize)-->设置字体大小
				relationName:setAnchorPoint(CCPoint(0, 0))-->设置锚点
				local skewingY = 0-(i-1)*fontSize-10
				relationName:setPosition(cc.p(0, -1 * frameAddCount))
				if m_tReleaseLanguage >= 3 then
					describe = relationName:getContentSize().width
				end
				--描述
				local relationDescribe = ccui.TextField:create()
				if m_tReleaseLanguage >= 3 then
					relationDescribe:setTextAreaSize(cc.size(220-describe+fontSize*2, 0))
				else
					relationDescribe:setTextAreaSize(cc.size(220, 0))
				end
				local relationInfoCount = dms.string(dms["fate_relationship_mould"],tonumber(relationMould.relationship_id),fate_relationship_mould.relation_describe)
				relationDescribe:setString(relationInfoCount)
				relationDescribe:setFontName("fonts/FZYiHei-M20S.ttf")-->设置字体名字
				relationDescribe:setFontSize(fontSize)-->设置字体大小
				relationDescribe:setAnchorPoint(CCPoint(0, 0))-->设置锚点
				relationDescribe:setPosition(cc.p(0+relationName:getContentSize().width + 10, -1 * frameAddCount))
				title:addChild(relationName)
				title:addChild(relationDescribe)
				
				if m_tReleaseLanguage >= 3 then	
					if relationName:getContentSize().height > relationDescribe:getContentSize().height then
						frameAddCount = frameAddCount + relationName:getContentSize().height
					else
						frameAddCount = frameAddCount + relationDescribe:getContentSize().height
					end
				else
					frameAddCount = frameAddCount + relationDescribe:getContentSize().height
				end
			end
		end
	end
end


function ShipPartnerInfoCell:onEnterTransitionFinish()
    local csbLineUpJiBan = csb.createNode("formation/line_up_jiban.csb")
	local root = csbLineUpJiBan:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbLineUpJiBan)
	
	self:onUpdateDraw()
end


function ShipPartnerInfoCell:onExit()
	
end
function ShipPartnerInfoCell:createCell()
	local cell = ShipPartnerInfoCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
