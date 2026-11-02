-----------------------------
-- 仓库单个出售提示
-----------------------------
SmPropWarehouseSellTip = class("SmPropWarehouseSellTipClass", Window)

--打开界面
local prop_warehouse_sell_tip_open_terminal = {
	_name = "prop_warehouse_sell_tip_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmPropWarehouseSellTipClass") == nil then
			fwin:open(SmPropWarehouseSellTip:new():init(params), fwin._background)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local prop_warehouse_sell_tip_close_terminal = {
	_name = "prop_warehouse_sell_tip_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmPropWarehouseSellTipClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(prop_warehouse_sell_tip_open_terminal)
state_machine.add(prop_warehouse_sell_tip_close_terminal)
state_machine.init()

function SmPropWarehouseSellTip:ctor()
	self.super:ctor()
	self.roots = {}

    local function init_prop_warehouse_sell_tip_terminal()
        local prop_warehouse_is_sell_terminal = {
            _name = "prop_warehouse_is_sell",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("prop_warehouse_sell_prop_update",0,"1")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(prop_warehouse_is_sell_terminal)
        state_machine.init()
    end
    init_prop_warehouse_sell_tip_terminal()
end


function SmPropWarehouseSellTip:init(params)
    self.prop = params
	self:onInit()
    return self
end

function SmPropWarehouseSellTip:onInit()
    local csbItem = csb.createNode("packs/sm_warehouse_sell_tip.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    --提示信息
    local Text_tips = ccui.Helper:seekWidgetByName(root,"Text_tips")
    --道具名称
    local name = dms.string(dms["prop_mould"], self.prop.user_prop_template, prop_mould.prop_name)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        name = setThePropsIcon(self.prop.user_prop_template)[2]
    end
    Text_tips:setString(string.format(_new_interface_text[10],name))

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "prop_warehouse_sell_tip_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --出售
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sell"), nil, 
    {
        terminal_name = "prop_warehouse_is_sell", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 0)
    
   
end

function SmPropWarehouseSellTip:onEnterTransitionFinish()
    
end

function SmPropWarehouseSellTip:onExit()
end

