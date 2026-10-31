-- ----------------------------------------------------------------------------------------------------
-- 说明：公会副本规则2
-------------------------------------------------------------------------------------------------------

UnionDuplicateRuleTwoCell = class("UnionDuplicateRuleTwoCellClass", Window)
UnionDuplicateRuleTwoCell.__size = nil
function UnionDuplicateRuleTwoCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_index = 0
	app.load("client.cells.utils.resources_icon_cell")
    -- Initialize UnionDuplicateRuleTwoCell page state machine.
    local function init_union_duplicate_rule_two_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_union_duplicate_rule_two_cell_terminal()
end

function UnionDuplicateRuleTwoCell:initDraw()
	local root = self.roots[1]

	local getReworld = zstring.split(dms.string(dms["union_pve_reward"], self.m_index, union_pve_reward.reworld) ,"|")

	for i=1, 3 do
		ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_"..i):setVisible(false)
	end

	for i=1,#getReworld do
		local Panel_reward_icon =  ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_"..i)
		Panel_reward_icon:setVisible(true)
		Panel_reward_icon:removeAllChildren(true)
		local reworldData = zstring.split(getReworld[i],",")
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{reworldData[1],reworldData[2],reworldData[3]},false,true,false,true})
        Panel_reward_icon:addChild(cell)
        -- if tonumber(reworldData[1]) == 1 then
        --     --钱
        --     local cell = ResourcesIconCell:createCell()
        --     cell:init(reworldData[1], tonumber(reworldData[3]),-1,nil,nil,true,true)
        --     Panel_reward_icon:addChild(cell)
        -- end
        -- if tonumber(reworldData[1]) == 28 then
        --     --工会币
        --     local cell = ResourcesIconCell:createCell()
        --     cell:init(reworldData[1], tonumber(reworldData[3]),-1,nil,nil,true,true)
        --     Panel_reward_icon:addChild(cell)
        -- end
        -- if tonumber(reworldData[1]) == 6 then
        --     --道具
        --     local cell = ResourcesIconCell:createCell()
        --     cell:init(reworldData[1], tonumber(reworldData[3]), reworldData[2],nil,nil,true,true)
        --     Panel_reward_icon:addChild(cell)
        -- end
	end

	local Text_reward_rank = ccui.Helper:seekWidgetByName(root, "Text_reward_rank")
	-- DSC重塑
	if __lua_project_id == __lua_project_l_digital then
		for i = 1, 3 do
			ccui.Helper:seekWidgetByName(root, "Image_ranking_"..i):setVisible(i == self.m_index)
		end

		Text_reward_rank:setString(zstring.tonumber(self.m_index))
		ccui.Helper:seekWidgetByName(root, "Image_more"):setVisible(tonumber(self.m_index) >= 23)
	else
		if tonumber(self.m_index) < 23 then
			Text_reward_rank:setString(string.format(_new_interface_text[43],zstring.tonumber(tonumber(self.m_index))))
		else
			Text_reward_rank:setString(string.format(_new_interface_text[71],zstring.tonumber(tonumber(self.m_index))))
		end
	end
end

function UnionDuplicateRuleTwoCell:onEnterTransitionFinish()
	
end

function UnionDuplicateRuleTwoCell:onInit()
	local root = cacher.createUIRef("legion/sm_legion_pve_window_rule_list_2.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if UnionDuplicateRuleTwoCell.__size == nil then
	 	local Panel_list_2 = ccui.Helper:seekWidgetByName(root, "Panel_list_2")
		local MySize = Panel_list_2:getContentSize()

	 	UnionDuplicateRuleTwoCell.__size = MySize
	end
	self:initDraw()
end

function UnionDuplicateRuleTwoCell:clearUIInfo( ... )
	local root = self.roots[1]
	for i=1, 3 do
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_"..i)
		if panel ~= nil then
			panel:removeAllChildren(true)
		end
	end
end

function UnionDuplicateRuleTwoCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionDuplicateRuleTwoCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("legion/sm_legion_pve_window_rule_list_2.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function UnionDuplicateRuleTwoCell:init(index)
	self.m_index = index
	self:onInit()
	self:setContentSize(UnionDuplicateRuleTwoCell.__size)
	return self
end

function UnionDuplicateRuleTwoCell:createCell()
	local cell = UnionDuplicateRuleTwoCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function UnionDuplicateRuleTwoCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("legion/sm_legion_pve_window_rule_list_2.csb", self.roots[1])
end
