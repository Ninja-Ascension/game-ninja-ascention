----------------------------------------------------------------------------------------------------
-- 说明：阵容需要高亮的控件
-------------------------------------------------------------------------------------------------------
SelectedCursor = class("SelectedCursorClass", Window)

function SelectedCursor:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.current_type = 0

	-- local function init_add_action_cell_terminal()
		
        -- state_machine.init()
	-- end
	-- init_add_action_cell_terminal()
end

function SelectedCursor:onUpdateDraw()
	local root = self.roots[1]
	
end

function SelectedCursor:onEnterTransitionFinish()
	local filePath = nil
	filePath = "icon/icon_pitch_on.csb"
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
end

function SelectedCursor:onExit()
	-- state_machine.remove("add_action_cell_ship_for_ship")
end

function SelectedCursor:init()

end

function SelectedCursor:createCell()
	local cell = SelectedCursor:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

