--------------------------------------------------------------------------------------------------------------
--  说明：军团排行榜
--------------------------------------------------------------------------------------------------------------
UnionRank = class("UnionRankClass", Window)

--打开界面
local union_rank_open_terminal = {
	_name = "union_rank_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local UnionRankWindow = fwin:find("UnionRankClass")
        if UnionRankWindow ~= nil and UnionRankWindow:isVisible() == true then
            return true
        end
       
		fwin:open(UnionRank:new():init(params),fwin._view)
     
		
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local union_rank_close_terminal = {
	_name = "union_rank_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		
		fwin:close(fwin:find("UnionRankClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(union_rank_open_terminal)
state_machine.add(union_rank_close_terminal)
state_machine.init()

function UnionRank:ctor()
	self.super:ctor()
	self.roots = {}
	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = 0
	self.myrank = 0
	self.enum_type = {
	}
	app.load("client.l_digital.cells.union.union_join_list_cell")
	app.load("client.l_digital.cells.union.union_rank_list_cell")
	 -- Initialize union rank machine.
    local function init_union_rank_terminal()
		-- 隐藏界面
        local union_rank_hide_event_terminal = {
            _name = "union_rank_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local union_rank_show_event_terminal = {
            _name = "union_rank_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
				instance:setHighlighted(1)
				instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 切换排行列表
		local union_rank_switch_button_terminal = {
            _name = "union_rank_switch_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 副本排行
		local union_rank_duplicate_terminal = {
            _name = "union_rank_duplicate",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	TipDlg.drawTextDailog(_function_unopened_tip_string)
            	-- if true == funOpenDrawTip(52) then
             --        return false
             --    end 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 等级排行
		local union_rank_grade_terminal = {
            _name = "union_rank_grade",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:setHighlighted(1)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新信息
		local union_rank_refresh_terminal = {
            _name = "union_rank_refresh",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_rank_hide_event_terminal)
		state_machine.add(union_rank_show_event_terminal)
		state_machine.add(union_rank_switch_button_terminal)
		state_machine.add(union_rank_duplicate_terminal)
		state_machine.add(union_rank_grade_terminal)
		state_machine.add(union_rank_refresh_terminal)
        state_machine.init()
    end
    
    -- call func init union rank  machine.
    init_union_rank_terminal()

end

function UnionRank:onHide()
	-- for i, v in pairs(self.group) do
	-- 	if v ~= nil then
	-- 		v:setVisible(false)
	-- 	end
	-- end
	self:setVisible(false)
end

function UnionRank:onShow()
	-- for i, v in pairs(self.group) do
	-- 	if v ~= nil then
	-- 		v:setVisible(true)
	-- 	end
	-- end
	self:setVisible(true)
end

function UnionRank:setHighlighted(index)
	if self.gradeTxt ~= nil then
		self.gradeTxt:setVisible(false)
	end
	if self.gradeBtn ~= nil then
		self.gradeBtn:setHighlighted(false)
	end
	if self.duplicateTxt ~= nil then
		self.duplicateTxt:setVisible(false)
	end
	if self.duplicateBtn ~= nil then
		self.duplicateBtn:setHighlighted(false)
	end
	
	
	
	if index == 1 then 
		if self.gradeTxt ~= nil then
			self.gradeTxt:setVisible(true)
		end
		if self.gradeBtn ~= nil then
			self.gradeBtn:setHighlighted(true)
		end
		
	elseif index == 2 then 
		if self.duplicateTxt ~= nil then
			self.duplicateTxt:setVisible(true)
		end
		if self.duplicateBtn ~= nil then
			self.duplicateBtn:setHighlighted(true)
		end
	end

end


function UnionRank:updateDraw()
	local root = self.roots[1]
	UnionRank.list = {
		self.gradListView,
		self.duplicateListView,
	} 
	
	self.drawIndex_1 = 1
	self.drawIndex_2 = 1
	
	self.gradListView = ccui.Helper:seekWidgetByName(root, "ListView_38") 
	self.gradListView:removeAllItems()
	self.duplicateListView =  ccui.Helper:seekWidgetByName(root, "ListView_38_0") 
	self.gradListView:setVisible(true)
	if self.duplicateListView ~= nil then
		self.duplicateListView:setVisible(false)
	end
	
	self.cacheListView = self.gradListView
	self.currentListView = self.cacheListView
	self.currentInnerContainer = self.cacheListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	local arry = _ED.union.rank_union_list_info--_ED.union.union_list_info
	-- self.listcount = #arry
	local ifself = false
	for i, v in pairs(arry) do
		-- local cell = Unionjoinlistcell:createCell()
		-- if _ED.union.union_info == nil then
		-- 	return
		-- end
		if tonumber(v.union_id) == _ED.union.union_info.union_id then
			self.myrank = tonumber(v.union_rank)
			ifself = true
		end
		local cell = UnionRankListCell:createCell()
		cell:init(arry[self.drawIndex_1],self.drawIndex_1,ifself)
		self.cacheListView:addChild(cell)
		self.cacheListView:requestRefreshView()
		self.drawIndex_1 = self.drawIndex_1 + 1
	
	end
	if ccui.Helper:seekWidgetByName(root, "Text_63_0") ~= nil then
		if self.myrank > 0 then
			ccui.Helper:seekWidgetByName(root, "Text_63_0"):setString(self.myrank)
		else
			ccui.Helper:seekWidgetByName(root, "Text_63_0"):setString(tipStringInfo_union_str[35])
		end
	end
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)

	

end

function UnionRank:onInit()

	
	local csbUnionRank = csb.createNode("legion/legion_rank.csb")
    local root = csbUnionRank:getChildByName("root")

    table.insert(self.roots, root)
    self:addChild(csbUnionRank)
   	
	local action = csb.createTimeline("legion/legion_rank.csb") 
	-- table.insert(self.actions, action )
	csbUnionRank:runAction(action)
	action:play("window_open", false)

	self.gradeTxt = ccui.Helper:seekWidgetByName(root, "Image_42") 
	self.gradeBtn = ccui.Helper:seekWidgetByName(root, "Button_61") 
	self.duplicateTxt = ccui.Helper:seekWidgetByName(root, "Image_42_0") 
	self.duplicateBtn = ccui.Helper:seekWidgetByName(root, "Button_62") 
	self:setHighlighted(1)
	self:updateDraw()
	
	 fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_20"), nil, 
    {
        terminal_name = "union_rank_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	  fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5"), nil, 
    {
        terminal_name = "union_rank_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	  fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_61"), nil, 
    {
        terminal_name = "union_rank_grade", 
		cell = self,
        terminal_state = 0,
		but_image = "Image_42",
		pagetype = 1,
        isPressedActionEnabled = false
    }, 
    nil, 0)
	 fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_62"), nil, 
    {
        terminal_name = "union_rank_duplicate", 
		cell = self,
        terminal_state = 0,
		but_image = "Image_42_0",
		pagetype = 2,
        isPressedActionEnabled = false
    }, 
    nil, 0)

end

function UnionRank:onUpdate(dt)

	if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
		local size = self.currentListView:getContentSize()
		local posY = self.currentInnerContainer:getPositionY()
		if self.currentInnerContainerPosY == posY then
			return
		end
		self.currentInnerContainerPosY = posY
		local items = self.currentListView:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
				v:unload()
			else
				v:reload()
			end
		end
	end
end

function UnionRank:onEnterTransitionFinish()
end

function UnionRank:init(params)
	local rootWindow = params[1] 
    self._rootWindows = rootWindow   
	self:onInit()
	return self
end

function UnionRank:onExit()
	state_machine.remove("union_rank_hide_event")
	state_machine.remove("union_rank_show_event")
	state_machine.remove("union_rank_switch_button")
	state_machine.remove("union_rank_duplicate")
	state_machine.remove("union_rank_grade")
	state_machine.remove("union_rank_refresh")
end