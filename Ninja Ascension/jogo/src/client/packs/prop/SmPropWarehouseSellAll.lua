-----------------------------
-- 仓库出售所有可以出售的
-----------------------------
SmPropWarehouseSellAll = class("SmPropWarehouseSellAllClass", Window)

--打开界面
local prop_warehouse_sell_all_open_terminal = {
	_name = "prop_warehouse_sell_all_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmPropWarehouseSellAllClass") == nil then
			fwin:open(SmPropWarehouseSellAll:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local prop_warehouse_sell_all_close_terminal = {
	_name = "prop_warehouse_sell_all_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmPropWarehouseSellAllClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(prop_warehouse_sell_all_open_terminal)
state_machine.add(prop_warehouse_sell_all_close_terminal)
state_machine.init()

function SmPropWarehouseSellAll:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.cells.prop.sm_packs_sell_cell")
    app.load("client.cells.utils.multiple_list_view_cell")

    local function init_prop_warehouse_sell_all_terminal()
        local prop_warehouse_all_sell_terminal = {
            _name = "prop_warehouse_all_sell",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseSellMagicCardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
                        if response.node == nil or response.node.roots == nil then 
                            return
                        end
                        TipDlg.drawTextDailog(_new_interface_text[11])
                        state_machine.excute("prop_warehouse_update_draw_page",0,"")
                        state_machine.excute("prop_warehouse_sell_all_close",0,"")
                    end
                end
                local strs = ""
                for i=1, #instance.prop_list do
                    if i == #instance.prop_list then
                        strs = strs..instance.prop_list[i].user_prop_id.."\r\n"..instance.prop_list[i].prop_number
                    else
                        strs = strs ..instance.prop_list[i].user_prop_id.."\r\n"..instance.prop_list[i].prop_number.."\r\n"
                    end
                end

                protocol_command.prop_sell.param_list = strs
                NetworkManager:register(protocol_command.prop_sell.code, nil, nil, nil, self, responseSellMagicCardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(prop_warehouse_all_sell_terminal)
        state_machine.init()
    end
    init_prop_warehouse_sell_all_terminal()
end

function SmPropWarehouseSellAll:updateDraw()
    local root = self.roots[1]
    if root == nil then
        return
    end
    --列表
    local ListView_sell_props = ccui.Helper:seekWidgetByName(root,"ListView_sell_props")
    ListView_sell_props:removeAllItems()

    --卖的钱
    local money = 0
    ListView_sell_props:setDirection(ccui.ListViewDirection.vertical)
    local contSize = ListView_sell_props:getContentSize()
    ListView_sell_props:setAnchorPoint(cc.p(0.5, 1))
    ListView_sell_props:setContentSize(cc.size(contSize.width , contSize.height * 2))
    ListView_sell_props:setPositionY(SmPropWarehouseSellAll.lisvViewY + ListView_sell_props:getContentSize().height / 4)
    local Text_packs_sell_price_n = ccui.Helper:seekWidgetByName(root,"Text_packs_sell_price_n")

    local preMultipleCell = nil
    local MylistViewCell = nil
    for i=1, #self.prop_list do
        money = money + dms.int(dms["prop_mould"], self.prop_list[i].user_prop_template, prop_mould.silver_price)*self.prop_list[i].prop_number
        --添加控件
        local cell = state_machine.excute("sm_packs_sell_cell",0,{self.prop_list[i]})

        if MylistViewCell == nil then
            MylistViewCell = MultipleListViewCell:createCell()
            MylistViewCell:init(ListView_sell_props,cell:getContentSize())
            ListView_sell_props:addChild(MylistViewCell)
            MylistViewCell.prev = preMultipleCell
            if preMultipleCell ~= nil then
                preMultipleCell.next = MylistViewCell
            end
        end
        MylistViewCell:addNode(cell)
        if MylistViewCell.child2 ~= nil then
            preMultipleCell = MylistViewCell
            MylistViewCell = nil
        end
    end
    ListView_sell_props:requestRefreshView()
    Text_packs_sell_price_n:setString(money)
end


function SmPropWarehouseSellAll:init(params)
    self.prop_list = params
	self:onInit()
    return self
end

function SmPropWarehouseSellAll:onInit()
    local csbItem = csb.createNode("packs/sm_warehouse_sell.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    Animations_PlayOpenMainUI({ccui.Helper:seekWidgetByName(root, "Panel_3")}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_CENTER_IN)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "prop_warehouse_sell_all_close", 
        terminal_state = 0, 
        touch_black = true,         
        isPressedActionEnabled = true
    }, nil, 3)

    --出售
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sell"), nil, 
    {
        terminal_name = "prop_warehouse_all_sell", 
        terminal_state = 0, 
        touch_black = true,         
        isPressedActionEnabled = true
    }, nil, 0)
    
    if SmPropWarehouseSellAll.lisvViewY == nil then
        SmPropWarehouseSellAll.lisvViewY = ccui.Helper:seekWidgetByName(root,"ListView_sell_props"):getPositionY()
    end

    self:updateDraw()
   
end

function SmPropWarehouseSellAll:onEnterTransitionFinish()
    
end

function SmPropWarehouseSellAll:onExit()
    state_machine.remove("prop_warehouse_all_sell", 0, 0)
end

