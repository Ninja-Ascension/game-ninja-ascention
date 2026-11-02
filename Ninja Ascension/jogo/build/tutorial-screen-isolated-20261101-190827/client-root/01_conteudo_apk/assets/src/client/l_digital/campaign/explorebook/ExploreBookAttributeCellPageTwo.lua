----------------------------------------------------------------------------------------------------
-- 说明：文件岛圣物右侧列表cell
----------------------------------------------------------------------------------------------------
ExploreBookAttributeCellPageTwo = class("ExploreBookAttributeCellPageTwo_Class", Window)
ExploreBookAttributeCellPageTwo.__size = nil

function ExploreBookAttributeCellPageTwo:ctor()
    self.super:ctor()
	self.roots = {}

	app.load("client.l_digital.campaign.explorebook.ExploreBookAttributeCellPageThree")

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
        	instance:playCellAnimation(params)
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

function ExploreBookAttributeCellPageTwo:playCellAnimation( params )
	local nodeTotal = {}
	local book_talent_level = 1
    for i, v in pairs(_ED.explore_book_data.telent.information) do
        if v.id ~= nil then
        	if params then       
	            if v.id == tonumber(params[2]) then 
	                book_talent_level = v.level
	            end
	        end
        else
            book_talent_level = 1
        end
    end
	for i = 1, #self.cellDataId do
		local node = nil

		-- 单数行，从左向右排
		if params[3] % 2 ~= 0 then
			node = _ED.allIcons[params[3]][i]
		-- 偶数行，从右向左排
		else
			node = _ED.allIcons[params[3]][5 - i]
		end

		if node then
			local cellData = self.cellDataId[4*(params[3] - 1) + i]
			local curCell = node:getChildByName("ExploreBookAttributeCellPageThree_Cell" .. cellData.idx)
			if params then
				if tonumber(cellData.idx) == tonumber(params[2]) and curCell then
					local Panel_holy_lock_effect = ccui.Helper:seekWidgetByName(curCell.roots[1], "Panel_holy_lock_effect")
				    Panel_holy_lock_effect:setVisible(false)

				    local Text_holy_right_icon_n = ccui.Helper:seekWidgetByName(curCell.roots[1], "Text_holy_right_icon_n")
				   	Text_holy_right_icon_n:setString(book_talent_level)

					local Panel_holy_up_effect = ccui.Helper:seekWidgetByName(curCell.roots[1], "Panel_holy_up_effect")
					local jsonFile = "images/ui/effice/effect_liuguang/effect_liuguang.json"
		            local atlasFile = "images/ui/effice/effect_liuguang/effect_liuguang.atlas" 
		            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", false, nil)
		            animation.animationNameList = {"animation"}
		            sp.initArmature(animation, false)

		            local function changeActionCallback(armatureBack)
		                if armatureBack then
		                	armatureBack:removeFromParent(true)
		                end
		            end
		            Panel_holy_up_effect:setVisible(true)
		            animation._invoke = changeActionCallback
		            Panel_holy_up_effect:addChild(animation)
		            animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		            csb.animationChangeToAction(animation, 0, 0, false)
				end
			end
		end
	end
end

function ExploreBookAttributeCellPageTwo:onUpdateDraw()
	local root = self.roots[1]
	
	for i = 1, #self.taskData do
		local node = nil

		-- 单数行，从左向右排
		if self.index % 2 ~= 0 then
			node = _ED.allIcons[self.index][i]
		-- 偶数行，从右向左排
		else
			node = _ED.allIcons[self.index][5 - i]
		end

		node:removeAllChildren(true)

		local cellData = self.taskData[i]
		local cell = ExploreBookAttributeCellPageThree:createCell()
		cell:init(cellData, i, self)
		local cellDataId = self.cellDataId[i]
		cell:setName("ExploreBookAttributeCellPageThree_Cell" .. cellData.idx)
		node:addChild(cell)
	end
end

function ExploreBookAttributeCellPageTwo:onInit()
    local root = cacher.createUIRef("campaign/exploration/exploration_book_add_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	_ED.allIcons[self.index] = {}
	for i = 1, 4 do
		table.insert(_ED.allIcons[self.index], ccui.Helper:seekWidgetByName(root, "Panel_explore_holy_icon_" .. i))
	end

	self.nodeTotal = {}
	for i = 1, #self.cellDataId do
		local node = nil

		-- 单数行，从左向右排
		if self.index % 2 ~= 0 then
			node = _ED.allIcons[self.index][i]
			table.insert(self.nodeTotal,node)
		-- 偶数行，从右向左排
		else
			node = _ED.allIcons[self.index][5 - i]
			table.insert(self.nodeTotal,node)
		end
	end

	local panel_size = root:getContentSize()

	self:onUpdateDraw()

	self:setContentSize(panel_size)
	if ExploreBookAttributeCellPageTwo.__size == nil then
		ExploreBookAttributeCellPageTwo.__size = panel_size
	end

end

function ExploreBookAttributeCellPageTwo:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:onInit()
end

function ExploreBookAttributeCellPageTwo:unload()
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

function ExploreBookAttributeCellPageTwo:clearUIInfo()
    local root = self.roots[1]
    
    -- if _ED.allIcons[self.index] then
    -- 	for i = 1, #_ED.allIcons[self.index] do
    -- 		local node = _ED.allIcons[self.index][i]
    -- 		if node then
    -- 			node:removeAllChildren(true)
    -- 		end
    -- 	end
    -- end

end

function ExploreBookAttributeCellPageTwo:onExit()
	self:clearUIInfo()

    cacher.freeRef("campaign/exploration/exploration_book_add_cell.csb", self.roots[1])
end

function ExploreBookAttributeCellPageTwo:init(params, index, page, cellDataId)
	self.taskData = params or {}
	self.taskDataTotal = {}
	table.insert(self.taskDataTotal,self.taskData)
	-- 列表所在的类
	self.index = index
	self.page = page
	_ED.allIcons[self.index] = {}

	self.cellDataId = cellDataId

	self:onInit()

	if ExploreBookAttributeCellPageTwo.__size then
		self:setContentSize(ExploreBookAttributeCellPageTwo.__size)
	end
end

function ExploreBookAttributeCellPageTwo:createCell()
	local cell = ExploreBookAttributeCellPageTwo:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


