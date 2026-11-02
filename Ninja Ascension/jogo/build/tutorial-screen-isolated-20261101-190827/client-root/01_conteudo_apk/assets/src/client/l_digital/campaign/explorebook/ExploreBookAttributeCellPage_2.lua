----------------------------------------------------------------------------------------------------
-- 说明：文件岛圣物右侧列表cell
----------------------------------------------------------------------------------------------------
ExploreBookAttributeCellPage_2 = class("ExploreBookAttributeCellPage_2_Class", Window)
ExploreBookAttributeCellPage_2.__size = nil

function ExploreBookAttributeCellPage_2:ctor()
    self.super:ctor()
	self.roots = {}

	app.load("client.l_digital.campaign.explorebook.ExploreBookAttributeCellPage_3")

	local function init_explore_book_attribute_cell_page_2_terminal()
     --升级动画
    local explore_book_attribute_cell_page_icon_uplvani_terminal = {
        _name = "explore_book_attribute_cell_page_icon_uplvani",
        _init = function (terminal) 
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)
        	--instance:choseparm(params[2])
        	instance:onUpdateDraw(params)
            return true
        end,
        _terminal = nil,
        _terminals = nil
    } 
        state_machine.add(explore_book_attribute_cell_page_icon_uplvani_terminal)
    	state_machine.init()
	end

	init_explore_book_attribute_cell_page_2_terminal()
end

function ExploreBookAttributeCellPage_2:onUpdateDraw(params)
	local root = self.roots[1]
	

	for i = 1, #self.taskData do
		local node = nil

		-- 单数行，从左向右排
		if self.index % 2 ~= 0 then
			node = self.iconTable[i]
		-- 偶数行，从右向左排
		else
			node = self.iconTable[5 - i]
		end

		node:removeAllChildren(true)

		local cellData = self.taskData[i]
		local cell = ExploreBookAttributeCellPage_3:createCell()
		if params then
			cell:init(cellData, i, self,tonumber(params[2]))
		else
			cell:init(cellData, i, self,nil)
		end
		node:addChild(cell)
		--table.insert(_Ed_ExploreBooPage_2_data,cell)
	end
end

function ExploreBookAttributeCellPage_2:islockani()
    for i,v in pairs(_ED.explore_book_data.telent.information) do
       if v.level and  _Ed_ExploreBooPage_2_data[i] then
       	  _Ed_ExploreBooPage_2_data[i].Panel_holy_lock_effect:removeAllChildren(true)   
       end
    end
end

function ExploreBookAttributeCellPage_2:choseparm(parms)
	 for i = 1, #_Ed_ExploreBooPage_2_data do
 	    if i == parms then
 	    	_Ed_ExploreBooPage_2_data[i]:playani()
 	    end
	 end
end


function ExploreBookAttributeCellPage_2:onInit()
    local root = cacher.createUIRef("campaign/exploration/exploration_book_add_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	self.iconTable = {}
	for i = 1, 4 do
		table.insert(self.iconTable, ccui.Helper:seekWidgetByName(root, "Panel_explore_holy_icon_" .. i))
	end

	local panel_size = root:getContentSize()

	self:onUpdateDraw()

	self:setContentSize(panel_size)
	if ExploreBookAttributeCellPage_2.__size == nil then
		ExploreBookAttributeCellPage_2.__size = panel_size
	end

end

function ExploreBookAttributeCellPage_2:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:onInit()
end

function ExploreBookAttributeCellPage_2:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()

    cacher.freeRef("campaign/exploration/exploration_book_add_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function ExploreBookAttributeCellPage_2:clearUIInfo()
    local root = self.roots[1]
    
    if self.iconTable then
    	for i = 1, #self.iconTable do
    		local node = self.iconTable[i]
    		if node then
    			node:removeAllChildren(true)
    		end
    	end
    end

end

function ExploreBookAttributeCellPage_2:onExit()
	self:clearUIInfo()

    cacher.freeRef("campaign/exploration/exploration_book_add_cell.csb", self.roots[1])
end

function ExploreBookAttributeCellPage_2:init(params, index, holy, page)
	self.taskData = params or {}
	-- 列表所在的类
	self.fileIslandHolyThing = holy
	self.index = index
	self.page = page

	self:onInit()

	if ExploreBookAttributeCellPage_2.__size then
		self:setContentSize(ExploreBookAttributeCellPage_2.__size)
	end
	self:islockani()
end

function ExploreBookAttributeCellPage_2:createCell()
	local cell = ExploreBookAttributeCellPage_2:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


