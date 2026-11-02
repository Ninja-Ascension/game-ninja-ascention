-- ----------------------------------------------------------------------------------------------------
-- 说明：攻略cell
-- 创建时间	2015.5.4
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

StrategyList = class("StrategyListClass", Window)
    
function StrategyList:ctor()
    self.super:ctor()
    self.roots = {}
	self.data = nil
	self.id = nil
	self.des = nil
	app.load("client.home.strategy.StrategyListChild")
	app.load("client.home.strategy.StrategyChild")
    local function init_strategy_list_terminal()
		
		local strategy_list_in_terminal = {
            _name = "strategy_list_in",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local id = params._datas._cell
				local title = params._datas._cell2
				if fwin:find("StrategyClass") ~= nil then
					fwin:find("StrategyClass"):setVisible(false)
				end
				local cell = StrategyChild:new()
				cell:init(id,title)
				fwin:open(cell, fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(strategy_list_in_terminal)
        state_machine.init()
    end
    
    init_strategy_list_terminal()
end

function StrategyList:onUpdateDraw()
	local root = self.roots[1]
	local data = dms.searchs(dms["strategy"], strategy.id, self.data)
	ccui.Helper:seekWidgetByName(root, "Text_132"):setString(data[1][2])
	ccui.Helper:seekWidgetByName(root, "Panel_3"):setBackGroundImage(string.format("images/ui/function_icon/raiders_%d.png", tonumber(data[1][4])))
	self.id = data[1][5]
	self.des = data[1][3]
end

function StrategyList:onEnterTransitionFinish()
	local csbStrategyList = csb.createNode("system/raiders_list.csb")
	self:addChild(csbStrategyList)
	local action = csb.createTimeline("system/raiders_list.csb")
    csbStrategyList:runAction(action)
	action:play("list_view_cell_open", false)
	local root = csbStrategyList:getChildByName("root")
	table.insert(self.roots, root)
	self:setContentSize(ccui.Helper:seekWidgetByName(root, "Panel_203"):getContentSize())
	self:onUpdateDraw()
	ccui.Helper:seekWidgetByName(root, "Panel_4"):setSwallowTouches(false)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "strategy_list_in", 
		terminal_state = 0,
		_cell = self.id,
		_cell2 = self.des,
		isPressedActionEnabled = true
	}, nil, 0)
	
	local function headLayerTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if ccui.TouchEventType.began == evenType then
			
		elseif evenType == ccui.TouchEventType.moved then
			
		elseif ccui.TouchEventType.ended == evenType or
			ccui.TouchEventType.canceled == evenType then
			if math.abs( __epoint.y - __spoint.y) < 8 then
				state_machine.excute("strategy_list_in", 0, {_datas = {_cell = self.id, _cell2 = self.des}})
			end
		end
	end
	ccui.Helper:seekWidgetByName(root, "Panel_4"):addTouchEventListener(headLayerTouchEvent)
	
end


function StrategyList:init(data)
	self.data = data
end

function StrategyList:onExit()
	state_machine.remove("strategy_list_in")
end

function StrategyList:createCell()
	local cell = StrategyList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end