----------------------------------------------------------------------------------------------------
-- 说明：用于多列的ListView的列表项管理
-------------------------------------------------------------------------------------------------------
illustrationListManage = class("illustrationListManageClass", Window)

function illustrationListManage:ctor()
    self.super:ctor()
	self.roots = {}

	self.prev = nil
	self.next = nil
	self.child1 = nil
	self.listView = nil
	self.childSize = nil

	local function init_illustration_list_view_cell_terminal()
		local illustration_list_view_cell_manager_terminal = {
            _name = "illustration_list_view_cell_manager",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params
            	if cell ~= nil and cell.updateCell ~= nil then
            		cell:updateCell()
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(illustration_list_view_cell_manager_terminal)	
        state_machine.init()
	end
	init_illustration_list_view_cell_terminal()
end

function illustrationListManage:onEnterTransitionFinish()

end

function illustrationListManage:onExit()
	if self.child1 ~= nil then
		self.child1:unload()
	end
	
	self:removeAllChildren(true)
end

function illustrationListManage:checkCell()
	if self.child1 == nil then
		if self.prev ~= nil then
			self.prev.next = self.next
			if self.next ~= nil then
				self.next.prev = self.prev
			end
		end
		local itemIndex = self.listView:getIndex(self)
		self.listView:removeItem(itemIndex)
		return false
	end
	return true
end

function illustrationListManage:unlockChild()
	local cell = self.next
	while cell ~= nil do
		if cell.child1 ~= nil then
			local child = cell.child1
			child:retain()
			child:removeFromParent(false)
			cell.child1 = nil
			return child
		end
		cell = cell.next
	end
end

function illustrationListManage:updateCell()
	if self:checkCell() == true then
		if self.child1 == nil then
            local child = self:unlockChild()
            if child ~= nil then
                self:addNode(child)
                child:release()
            end
		end
	end
end

function illustrationListManage:addNode(child)
	self:addChild(child)
	if self.child1 == nil then
		self.child1 = child
		child:setPositionY(0)
	end
end

function illustrationListManage:onInit()
	
end

function illustrationListManage:init(listView, size)
	self.listView = listView
	self.childSize = size
	self:setContentSize(cc.size(size.width, listView:getContentSize().height))
	self:onInit()	
end

function illustrationListManage:reload()
	if self.child1 ~= nil then
		self.child1:reload()
	end
end

function illustrationListManage:unload()
	if self.child1 ~= nil then
		self.child1:unload()
	end
end

function illustrationListManage:createCell()
	local cell = illustrationListManage:new()
	cell:registerOnNodeEvent(cell)
	return cell
end