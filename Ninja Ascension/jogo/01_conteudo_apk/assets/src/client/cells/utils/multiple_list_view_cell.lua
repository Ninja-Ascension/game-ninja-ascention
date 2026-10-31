----------------------------------------------------------------------------------------------------
-- 说明：用于多列的ListView的列表项管理
-------------------------------------------------------------------------------------------------------
MultipleListViewCell = class("MultipleListViewCellClass", Window)

function MultipleListViewCell:ctor()
    self.super:ctor()
	self.roots = {}

	self.prev = nil
	self.next = nil
	self.child1 = nil
	self.child2 = nil
	self.listView = nil
	self.childSize = nil

	local function init_multiple_list_view_cell_terminal()
		local multiple_list_view_cell_manager_terminal = {
            _name = "multiple_list_view_cell_manager",
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
		
		state_machine.add(multiple_list_view_cell_manager_terminal)	
        state_machine.init()
	end
	init_multiple_list_view_cell_terminal()
end

function MultipleListViewCell:onEnterTransitionFinish()

end

function MultipleListViewCell:onExit()
	if self.child1 ~= nil then
		self.child1:unload()
	end
	if self.child2 ~= nil then
		self.child2:unload()
	end
	self:removeAllChildren(true)
end

function MultipleListViewCell:checkCell()
	if self.child1 == nil and self.child2 == nil then
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

function MultipleListViewCell:unlockChild()
	local cell = self.next
	while cell ~= nil do
		if cell.child1 ~= nil then
			local child = cell.child1
			child:retain()
			child:removeFromParent(false)
			cell.child1 = nil
			return child
		end
		if cell.child2 ~= nil then
			local child = cell.child2
			child:retain()
			child:removeFromParent(false)
			cell.child2 = nil
			return child
		end
		cell = cell.next
	end
end

function MultipleListViewCell:updateCell()
	if self:checkCell() == true then
		if self.child1 == nil then
			if self.child2 ~= nil then
				self.child1 = self.child2
				self.child1:setPositionX(0)
				self.child2 = nil
			else
				local child = self:unlockChild()
				if child ~= nil then
					self:addNode(child)
					child:release()
				end
			end
		end
		if self.child2 == nil then
			local child = self:unlockChild()
			if child ~= nil then
				self:addNode(child)
				child:release()
			end
		end
	end
end

function MultipleListViewCell:addNode(child)
	self:addChild(child)
	if self.child1 == nil then
		self.child1 = child
		child:setPositionX(0)
	elseif self.child2 == nil then
		self.child2 = child
		child:setPositionX(self.listView:getContentSize().width / 2)
	end
end

function MultipleListViewCell:onInit()
	
end

function MultipleListViewCell:init(listView, size)
	self.listView = listView
	self.childSize = size
	self:setContentSize(cc.size(listView:getContentSize().width, size.height))
	self:onInit()	
end

function MultipleListViewCell:reload()
	if self.child1 ~= nil then
		self.child1:reload()
	end
	if self.child2 ~= nil then
		self.child2:reload()
	end
end

function MultipleListViewCell:unload()
	if self.child1 ~= nil then
		self.child1:unload()
	end
	if self.child2 ~= nil then
		self.child2:unload()
	end
end

function MultipleListViewCell:createCell()
	local cell = MultipleListViewCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

