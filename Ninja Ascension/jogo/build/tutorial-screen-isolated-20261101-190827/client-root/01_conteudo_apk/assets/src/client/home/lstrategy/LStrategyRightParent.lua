
LStrategyRightParent = class("LStrategyRightParentClass", Window)
LStrategyRightParent.__BaseSize = nil
    
function LStrategyRightParent:ctor()
    self.super:ctor()
    self.roots = {}
    self.index = 0
	self.strategyId = 0
	self.isSelected = false
	
    local function init_strategy_right_parent_terminal()
		local lstrategy_right_parent_selected_terminal = {
            _name = "lstrategy_right_parent_selected",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
            	cell.isSelected = not cell.isSelected
            	cell:updateSelectState()
				state_machine.excute("lstrategy_select_right_once", 0, cell.index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(lstrategy_right_parent_selected_terminal)
        state_machine.init()
    end
    init_strategy_right_parent_terminal()
end

function LStrategyRightParent:onUpdateDraw()
	local root = self.roots[1]
    local title = dms.string(dms["strategy"], self.strategyId, strategy.title)
    local dialogue = dms.string(dms["strategy"], self.strategyId, strategy.dialogue)
    local pic = dms.int(dms["strategy"], self.strategyId, strategy.pic)
    local iconPath = string.format("images/ui/props/props_%d.png", pic)
	ccui.Helper:seekWidgetByName(root, "Panel_hei_icon"):setBackGroundImage(iconPath)
	ccui.Helper:seekWidgetByName(root, "Text_title_name"):setString(title)
	ccui.Helper:seekWidgetByName(root, "Text_miaoshu"):setString(dialogue)
	self:updateSelectState()
end

function LStrategyRightParent:updateSelectState( ... )
	self.more_panel:removeAllChildren(true)
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Image_zhankai"):setVisible(not self.isSelected)
	ccui.Helper:seekWidgetByName(root, "Image_shouqi_0"):setVisible(self.isSelected)
	if self.isSelected == true then
		local strategyData = dms.element(dms["strategy"], self.strategyId)
		local function_points = zstring.split(dms.atos(strategyData, strategy.function_point), ",")
		local totalCount = #function_points
		local totalHeight = 0
		for i=1,totalCount do
			local index = totalCount + 1 - i
			local functionId = function_points[index]
			local genre = dms.int(dms["function_param"], functionId, function_param.genre)
			if genre == 99 then
				local cell = LStrategyRightFormation:createCell()
				cell:init(i, functionId)
				self.more_panel:addChild(cell)
				cell:setPosition(cc.p(0, totalHeight))
				totalHeight = totalHeight + cell:getContentSize().height
			else
				local cell = LStrategyRightChild:createCell()
				cell:init(i, functionId)
				self.more_panel:addChild(cell)
				cell:setPosition(cc.p(0, totalHeight))
				totalHeight = totalHeight + cell:getContentSize().height
			end
		end
		self.more_panel:setContentSize(LStrategyRightParent.__BaseSize.width, totalHeight)
		ccui.Helper:seekWidgetByName(root, "Panel_28"):setPosition(cc.p(0, totalHeight))
		self.more_panel:setPosition(cc.p(0, 0))
		self:setContentSize(LStrategyRightParent.__BaseSize.width,
			LStrategyRightParent.__BaseSize.height + totalHeight)
	else
		self.more_panel:setContentSize(LStrategyRightParent.__BaseSize)
		self:setContentSize(LStrategyRightParent.__BaseSize)
		ccui.Helper:seekWidgetByName(root, "Panel_28"):setPosition(cc.p(0, 0))
	end
end

function LStrategyRightParent:onEnterTransitionFinish()
	local root = cacher.createUIRef("system/raiders_xzs_right.csb", "root")
	self:addChild(root)
	-- local csbStrategyParent = csb.createNode("system/raiders_xzs_right.csb")
	-- self:addChild(csbStrategyParent)
	-- local root = csbStrategyParent:getChildByName("root")
	table.insert(self.roots, root)
	self:setContentSize(root:getContentSize())
	if LStrategyRightParent.__BaseSize == nil then
		LStrategyRightParent.__BaseSize = self:getContentSize()
	end
	self.more_panel = ccui.Helper:seekWidgetByName(root, "Panel_list_xia")
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hong"), nil, 
	{
		terminal_name = "lstrategy_right_parent_selected", 
		terminal_state = 0,
		_cell = self,
		strategyId = self.strategyId,
		isPressedActionEnabled = true
	}, nil, 0)
	self:onUpdateDraw()
end

function LStrategyRightParent:onExit( ... )
	cacher.freeRef("system/raiders_xzs_right.csb", self.roots[1])
end

function LStrategyRightParent:init(index, strategyId)
	self.index = index
	self.strategyId = strategyId
end

function LStrategyRightParent:createCell()
	local cell = LStrategyRightParent:new()
	cell:registerOnNodeEvent(cell)
	return cell
end