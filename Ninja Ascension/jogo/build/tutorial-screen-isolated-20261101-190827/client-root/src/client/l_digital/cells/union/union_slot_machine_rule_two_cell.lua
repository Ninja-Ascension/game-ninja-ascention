-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场规则3
-------------------------------------------------------------------------------------------------------

UnionSlotMachineRuleTwoCell = class("UnionSlotMachineRuleTwoCellClass", Window)
UnionSlotMachineRuleTwoCell.__size = nil
function UnionSlotMachineRuleTwoCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.m_index = 0
	app.load("client.cells.utils.resources_icon_cell")
    -- Initialize UnionSlotMachineRuleTwoCell page state machine.
    local function init_union_slot_machine_rule_two_cell_terminal()
	
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_union_slot_machine_rule_two_cell_terminal()
end

function UnionSlotMachineRuleTwoCell:initDraw()
	local root = self.roots[1]

	local getReworld = zstring.split(dms.string(dms["union_extract_reward"], self.m_index, union_extract_reward.reworld) ,"|")

	for i=1, 3 do
		ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_"..i):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_reward_n_"..i):setVisible(false)
	end

	for i=1,#getReworld do
		local Panel_reward_icon =  ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_"..i)
		Panel_reward_icon:setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_reward_n_"..i):setVisible(true)
		Panel_reward_icon:removeAllChildren(true)
		local reworldData = zstring.split(getReworld[i],",")
        if tonumber(reworldData[1]) == 1 or tonumber(reworldData[1]) == 2 then
            --钱
            local cell = ResourcesIconCell:createCell()
            cell:init(reworldData[1], 0,-1,nil,nil)
            Panel_reward_icon:addChild(cell)
        end
        if tonumber(reworldData[1]) == 28 then
            --工会币
            local cell = ResourcesIconCell:createCell()
            cell:init(reworldData[1], 0,-1)
            Panel_reward_icon:addChild(cell)
        end
        if tonumber(reworldData[1]) == 6 then
            --道具
            local cell = ResourcesIconCell:createCell()
            cell:init(reworldData[1], 0, reworldData[2],nil,nil)
            Panel_reward_icon:addChild(cell)
        end
        ccui.Helper:seekWidgetByName(root, "Text_reward_n_"..i):setString("x"..reworldData[3])
	end

	local Text_reward_name = ccui.Helper:seekWidgetByName(root, "Text_reward_name")
	Text_reward_name:setString(string.format(_new_interface_text[70],zstring.tonumber(7-tonumber(self.m_index))))
end

function UnionSlotMachineRuleTwoCell:onEnterTransitionFinish()
	
end

function UnionSlotMachineRuleTwoCell:onInit()
	local root = cacher.createUIRef("legion/sm_legion_luck_draw_rule_list_2.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if UnionSlotMachineRuleTwoCell.__size == nil then
	 	local Panel_list_2 = ccui.Helper:seekWidgetByName(root, "Panel_list_2")
		local MySize = Panel_list_2:getContentSize()

	 	UnionSlotMachineRuleTwoCell.__size = MySize
	end
	self:initDraw()
end

function UnionSlotMachineRuleTwoCell:clearUIInfo( ... )
	local root = self.roots[1]
	for i=1, 3 do
		local panel = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_"..i)
		if panel ~= nil then
			panel:removeAllChildren(true)
		end
	end
end

function UnionSlotMachineRuleTwoCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionSlotMachineRuleTwoCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("legion/sm_legion_luck_draw_rule_list_2.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function UnionSlotMachineRuleTwoCell:init(index)
	self.m_index = index
	self:onInit()
	self:setContentSize(UnionSlotMachineRuleTwoCell.__size)
	return self
end

function UnionSlotMachineRuleTwoCell:createCell()
	local cell = UnionSlotMachineRuleTwoCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function UnionSlotMachineRuleTwoCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("legion/sm_legion_luck_draw_rule_list_2.csb", self.roots[1])
end
