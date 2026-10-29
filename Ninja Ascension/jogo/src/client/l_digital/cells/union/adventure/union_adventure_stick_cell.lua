-- ----------------------------------------------------------------------------------------------------
-- 说明：工会大冒险棍子的控件
-------------------------------------------------------------------------------------------------------

UnionAdventureStickCell = class("UnionAdventureStickCellClass", Window)
UnionAdventureStickCell.__size = nil

local union_adventure_stick_cell_creat_terminal = {
    _name = "union_adventure_stick_cell_creat",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = UnionAdventureStickCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_adventure_stick_cell_creat_terminal)
state_machine.init()

    
function UnionAdventureStickCell:ctor()
    self.super:ctor()
    self.roots = {}
	self._index = 0
	self.reward_type = 0
	self.rise_and_fall = true
    local function init_union_adventure_stick_cell_terminal()
	
		local union_adventure_stick_cell_updata_terminal = {
            _name = "union_adventure_stick_cell_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local cell = params[1]
				local index = tonumber(params[2])
				local increase = dms.int(dms["union_adventure_reward"], index, union_adventure_reward.increase)
				ccui.Helper:seekWidgetByName(cell.roots[1], "Image_stick"):setVisible(true)
				if ccui.Helper:seekWidgetByName(cell.roots[1], "Image_stick"):getContentSize().height >= 520 then
					cell.rise_and_fall = true
				elseif ccui.Helper:seekWidgetByName(cell.roots[1], "Image_stick"):getContentSize().height <= 10 then
					cell.rise_and_fall = false
				end
				if cell.rise_and_fall == true then
					ccui.Helper:seekWidgetByName(cell.roots[1], "Image_stick"):setContentSize(cc.size(ccui.Helper:seekWidgetByName(cell.roots[1], "Image_stick"):getContentSize().width,ccui.Helper:seekWidgetByName(cell.roots[1], "Image_stick"):getContentSize().height-increase))
				else
					ccui.Helper:seekWidgetByName(cell.roots[1], "Image_stick"):setContentSize(cc.size(ccui.Helper:seekWidgetByName(cell.roots[1], "Image_stick"):getContentSize().width,ccui.Helper:seekWidgetByName(cell.roots[1], "Image_stick"):getContentSize().height+increase))
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(union_adventure_stick_cell_updata_terminal)
        state_machine.init()
    end

    init_union_adventure_stick_cell_terminal()
end


function UnionAdventureStickCell:onUpdateDraw()
	local root = self.roots[1]
	
end

function UnionAdventureStickCell:onEnterTransitionFinish()

end

function UnionAdventureStickCell:onInit()
	local root = cacher.createUIRef("legion/sm_legion_adventure_stick.csb", "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
	if UnionAdventureStickCell.__size == nil then
		UnionAdventureStickCell.__size = root:getContentSize()
	end
	
	local Image_stick = ccui.Helper:seekWidgetByName(root, "Image_stick")
    if Image_stick._h == nil then
        Image_stick._h = Image_stick:getContentSize().height
    end
    Image_stick:setContentSize(cc.size(Image_stick:getContentSize().width,Image_stick._h))
    
    if Image_stick.rotation == nil then
    	Image_stick.rotation = 0
    end
    Image_stick:setRotation(Image_stick.rotation)

	--领取
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_reward_bg"), nil, 
 --    {
 --        terminal_name = "union_adventure_stick_cell_reward_request", 
 --        terminal_state = 0, 
 --        cells = self,
 --    }, nil, 1)
	
	self:onUpdateDraw()
end

function UnionAdventureStickCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
	cacher.freeRef("legion/sm_legion_adventure_stick.csb", root)
end

function UnionAdventureStickCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionAdventureStickCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    self:clearUIInfo()
	cacher.freeRef("legion/sm_legion_adventure_stick.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function UnionAdventureStickCell:clearUIInfo( ... )
    local root = self.roots[1]
    
end

function UnionAdventureStickCell:init(params)
	self:onInit()
	self:setContentSize(UnionAdventureStickCell.__size)
    return self
end
