-- ----------------------------------------------------------------------------------------------------
-- 说明：攻略
-- 创建时间	2015.5.4
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

StrategyChild= class("StrategyChildClass", Window)
    
function StrategyChild:ctor()
    self.super:ctor()
    self.roots = {}
	self.id = nil
	self.title = nil
    local function init_strategy_child_terminal()
		local strategy_child_close_terminal = {
            _name = "strategy_child_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
				if fwin:find("StrategyClass") ~= nil then
					fwin:find("StrategyClass"):setVisible(true)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(strategy_child_close_terminal)
        state_machine.init()
    end
    
    init_strategy_child_terminal()
end

function StrategyChild.loading(texture)
	local myListView = StrategyChild.myListView
	if myListView ~= nil then
		local cell = StrategyListChild:createCell()
		cell:init(StrategyChild.sortEquip[StrategyChild.asyncIndex])
		myListView:addChild(cell)
		StrategyChild.asyncIndex = StrategyChild.asyncIndex + 1
		myListView:requestRefreshView()
		StrategyChild.checkEmpty = true
	end
	
end

function StrategyChild:onUpdateDraw()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Text_301"):setString(self.title)
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_132")
	local id = zstring.split(self.id, ",")
	-- for i, v in pairs(id) do
		-- local cell = StrategyListChild:createCell()
		-- cell:init(v)
		-- listView:addChild(cell)
	-- end
	listView:requestRefreshView()
	
	StrategyChild.myListView = listView
	StrategyChild.sortEquip = id
	StrategyChild.asyncIndex = 1
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	for i, v in pairs(id) do
		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
	end
	
	if id[1] == nil then
		StrategyChild.checkEmpty = true
	end
end

function StrategyChild:onEnterTransitionFinish()
	local csbStrategy = csb.createNode("system/raiders_detailed.csb")
	self:addChild(csbStrategy)
	local root = csbStrategy:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_133"), nil, {terminal_name = "strategy_child_close", terminal_state = 0,isPressedActionEnabled = true}, nil, 2)
end


function StrategyChild:init(id,title)
	self.id = id
	self.title = title
end

function StrategyChild:onExit()
	state_machine.remove("strategy_child_close")
end