----------------------------------------------------------------------------------------------------
-- 说明：武将图标绘制
----------------------------------------------------------------------------------------------------
AdventureHeroSelectedCell = class("AdventureHeroSelectedCellClass", Window)
AdventureHeroSelectedCell.__size = nil

function AdventureHeroSelectedCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.current_type = 0
	self.enum_type = {
		_TYPE_NORMAL = 0,					-- 静态的UI显示

	}

	self.index = 0
	self.capadility = nil
	
	-- Initialize adventure hero icon cell state machine.
	local function init_adventure_hero_icon_cell_terminal()

		-- local adventure_hero_icon_cell_transform_fire_choice_terminal = {
            -- _name = "adventure_hero_icon_cell_transform_fire_choice",
            -- _init = function (terminal)
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
            	-- local cell = params._datas.cell
				-- state_machine.excute("adventure_hero_icon_cell_hero_fire_larger", 0, params)
				-- state_machine.excute("adventure_mercenary_hero_fire_info_update", 0, params)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }

		-- state_machine.add(adventure_hero_icon_cell_hero_fire_larger_terminal)
        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_adventure_hero_icon_cell_terminal()
end

function AdventureHeroSelectedCell:onInit()
	local root = cacher.createUIRef("icon/jiegu_choose_role.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	-- Get size for root node.
	if AdventureHeroSelectedCell.__size == nil then
		local size = root:getContentSize()
		AdventureHeroSelectedCell.__size = size
	end
end

function AdventureHeroSelectedCell:onExit()
	cacher.freeRef("icon/jiegu_choose_role.csb", self.roots[1])
end

-- /**
-- * interfaceType	逻辑类型
-- */
function AdventureHeroSelectedCell:init(interfaceType,indexs)
	self.current_type = interfaceType
	self.index = indexs
	self:onInit()
	
	self:setContentSize(AdventureHeroSelectedCell.__size)
	return self
end

function AdventureHeroSelectedCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventureHeroSelectedCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("icon/jiegu_choose_role.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventureHeroSelectedCell:createCell()
	local cell = AdventureHeroSelectedCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

