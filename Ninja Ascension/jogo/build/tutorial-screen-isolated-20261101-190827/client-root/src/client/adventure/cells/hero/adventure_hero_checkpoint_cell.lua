----------------------------------------------------------------------------------------------------
-- 说明：武将图标绘制
----------------------------------------------------------------------------------------------------
AdventureHeroCheckpointCell = class("AdventureHeroCheckpointCellClass", Window)
AdventureHeroCheckpointCell.__size = nil

function AdventureHeroCheckpointCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.current_type = 0
	self.drawIndex = 0 
	self.enum_type = {
		_TYPE_NORMAL = 0,					-- 静态的UI显示
		_TYPE_ADD = 1,					-- 可以添加
		_TYPE_CHECK_POINT = 3,					-- 攻克关卡

	}
	-- Initialize adventure hero icon cell state machine.
	local function init_adventure_hero_icon_cell_terminal()

        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_adventure_hero_icon_cell_terminal()
end

function AdventureHeroCheckpointCell:onInit()
	local root = cacher.createUIRef("icon/yongbing_di.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
 	--root:setScale(0.5)
 	local Text_num_guan = ccui.Helper:seekWidgetByName(root, "Text_num_guan")
 	local Image_num = ccui.Helper:seekWidgetByName(root, "Image_number_21")
 	local Text_index = ccui.Helper:seekWidgetByName(root, "Text_number_21")
 	local Panel_gongke = ccui.Helper:seekWidgetByName(root, "Panel_di")
 	Text_num_guan:setVisible(false)
 	Image_num:setVisible(false)
 	Panel_gongke:setVisible(false)
 	if self.current_type == self.enum_type._TYPE_CHECK_POINT then 
 		Panel_gongke:setVisible(true)
 		Text_num_guan:setVisible(true)
		local openNumber = 0
		local openNpcNumber = 0
		for j ,v in pairs(_ED.scene_current_state) do
			if zstring.tonumber(v) < 0 then
				openNumber = j
				openNpcNumber = zstring.tonumber(_ED.scene_current_state[openNumber-1])
				break
			end
		end
		openNumber = openNumber - 1
		local config = zstring.split(dms.string(dms["pirates_config"], 296, pirates_config.param), "|")
		for i,w in pairs(config) do
			local sceneInfo = zstring.split(w, ",")
			local sceneindex = zstring.split(sceneInfo[1], "-")	
			if zstring.tonumber(sceneindex[1]) >openNumber then
				Text_num_guan:setString(sceneInfo[1])
				break
			elseif zstring.tonumber(sceneindex[1]) >= openNumber and zstring.tonumber(sceneindex[2]) > openNpcNumber then
				Text_num_guan:setString(sceneInfo[1])
				break
			end
		end
	
	else
		Image_num:setVisible(true)
		Text_index:setString(""..self.drawIndex)
		-- Image_num:setVisible(true)
		-- Text_index:setString(""..self.drawIndex)
 	end
	
	
	-- Get size for root node.
	if AdventureHeroCheckpointCell.__size == nil then
		local size = root:getContentSize()
		AdventureHeroCheckpointCell.__size = size
	end
end

function AdventureHeroCheckpointCell:onExit()
	cacher.freeRef("icon/yongbing_di.csb", self.roots[1])
end

-- /**
-- * interfaceType	逻辑类型
-- */
function AdventureHeroCheckpointCell:init(drawIndex,show_type)
	self.drawIndex = drawIndex
	self.current_type = show_type
	self:onInit()
	
	self:setContentSize(AdventureHeroCheckpointCell.__size)
	return self
end

function AdventureHeroCheckpointCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureHeroCheckpointCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("icon/yongbing_di.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureHeroCheckpointCell:createCell()
	local cell = AdventureHeroCheckpointCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

