----------------------------------------------------------------------------------------------------
-- 说明：觉醒商店单元项
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
----------------------------------------------------------------------------------------------------
AwakenComposeBrowseListCell = class("AwakenComposeBrowseListCellClass", Window)

function AwakenComposeBrowseListCell:ctor()
    self.super:ctor()
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_icon_new_cell")
	self.current_type = 0
    -- 定义封装类中的变量
	self.roots = {}		
	self.propInfo = nil
	
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_awaken_compose_browse_list_cell_terminal()
	        
  
	end
	init_awaken_compose_browse_list_cell_terminal()
end

function AwakenComposeBrowseListCell:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local startId = self.propInfo[3]

	local start = math.floor(startId/10)
	local level = math.floor(startId%10)

	ccui.Helper:seekWidgetByName(root, "Text_28"):setString("" ..start.. _awaken_tipString_info[1].. ""..level .. _awaken_tipString_info[2])
	self:onUpdateDrawProps()
end

function AwakenComposeBrowseListCell:onUpdateDrawProps()
	-- body
	local root = self.roots[1]
	if root == nil then 
		return
	end
	for i=1,4 do
		local propPanel = ccui.Helper:seekWidgetByName(root, "Panel_wp_prop_".. i)	
		local propCountsText = ccui.Helper:seekWidgetByName(root, "Text_ms_count_".. i)	
		local msText = ccui.Helper:seekWidgetByName(root, "Text_ms_".. i)	
		propCountsText:setString("")
		propPanel:removeAllChildren(true)
		msText:setVisible(false)

		local propId = zstring.tonumber(self.propInfo[i+4])
		if propId > 0 then 
			local iconCell = nil
			if __lua_project_id == __lua_project_warship_girl_b then
				iconCell = PropIconCell:createCell()
				iconCell:init(37, propId)
			else
				iconCell = PropIconNewCell:createCell()
				iconCell:init(18, propId)
			end
			propPanel:addChild(iconCell)
			msText:setVisible(true)
			local propCounts = zstring.tonumber(getPropAllCountByMouldId(propId))
			if propCounts == 0 then 
				--没有这个道具
				iconCell.roots[1]:setColor(cc.c3b(50, 50, 50))
			else
			end
			propCountsText:setString(""..propCounts)
		end
	end
end

function AwakenComposeBrowseListCell:onEnterTransitionFinish()
	local csbItem = csb.createNode("packs/HeroStorage/generals_juexing_daojuyulan_1.csb")
	root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	local Panel16 = ccui.Helper:seekWidgetByName(root, "Panel_16")	
	self:setContentSize(Panel16:getContentSize())
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()
end

function AwakenComposeBrowseListCell:onInit()

end

function AwakenComposeBrowseListCell:onExit()
	self.roots = {}
end

function AwakenComposeBrowseListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AwakenComposeBrowseListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("packs/HeroStorage/generals_juexing_daojuyulan_1.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end
function AwakenComposeBrowseListCell:init(prop)
	self.propInfo = prop
end

function AwakenComposeBrowseListCell:createCell()
	local cell = AwakenComposeBrowseListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


