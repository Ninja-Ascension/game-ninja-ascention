-- ----------------------------------------------------------------------------------------------------
-- 说明：攻略
-- 创建时间	2015.5.4
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

Strategy = class("StrategyClass", Window)
    
function Strategy:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.home.strategy.StrategyList")
    local function init_strategy_terminal()
		
		local strategy_close_terminal = {
            _name = "strategy_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
				if fwin:find("StrategyChildClass") ~= nil then
					fwin:close(fwin:find("StrategyChildClass"))
				end
				state_machine.excute("menu_back_home_page", 0, "") 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(strategy_close_terminal)
        state_machine.init()
    end
    
    init_strategy_terminal()
end

function Strategy.loading(texture)
	local myListView = Strategy.myListView
	if myListView ~= nil then
		local cell = StrategyList:createCell()
		cell:init(Strategy.asyncIndex)
		myListView:addChild(cell)
		Strategy.asyncIndex = Strategy.asyncIndex + 1
		myListView:requestRefreshView()
		Strategy.checkEmpty = true
	end
	
end

function Strategy:onUpdateDraw()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_103")
	-- for i,v in pairs(dms["strategy"]) do
		-- local cell = StrategyList:createCell()
		-- cell:init(i)
		-- listView:addChild(cell)
	-- end
	listView:requestRefreshView()
	
	Strategy.myListView = listView
	Strategy.sortEquip = dms["strategy"]
	Strategy.asyncIndex = 1
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	for i, v in pairs(dms["strategy"]) do
		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
	end
	
	if dms["strategy"][1] == nil then
		Strategy.checkEmpty = true
	end
end

function Strategy:onEnterTransitionFinish()
	local csbStrategy = csb.createNode("system/raiders.csb")
	self:addChild(csbStrategy)
	local root = csbStrategy:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_166"), nil, {terminal_name = "strategy_close", terminal_state = 0,isPressedActionEnabled = true}, nil, 2)
end


function Strategy:onExit()
	state_machine.remove("strategy_close")
end