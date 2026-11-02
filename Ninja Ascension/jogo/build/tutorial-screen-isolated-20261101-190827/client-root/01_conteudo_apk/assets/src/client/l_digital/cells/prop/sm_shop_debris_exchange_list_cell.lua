----------------------------------------------------------------------------------------------------
-- 说明：sm商城道具兑换单元项
----------------------------------------------------------------------------------------------------
SmShopDebrisExchangeListCell = class("SmShopDebrisExchangeListCellClass", Window)
SmShopDebrisExchangeListCell.__size = nil

local sm_shop_debris_exchange_list_cell_create_terminal = {
    _name = "sm_shop_debris_exchange_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmShopDebrisExchangeListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_shop_debris_exchange_list_cell_create_terminal)
state_machine.init()

function SmShopDebrisExchangeListCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.actions = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.l_digital.shop.SmShopBuy")
	app.load("client.l_digital.shop.SmShopSuipianDuihuanWindow")
	
	-- 初始化道具小图标事件响应需要使用的状态机
	local function init_sm_shop_debris_exchange_list_cell_terminal()
	--使用按钮的点击
		local sm_shop_debris_exchange_list_cell_buy_terminal = {
            _name = "sm_shop_debris_exchange_list_cell_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params[1]
            	local root = cell.roots[1]
            	local Image_sell_out = ccui.Helper:seekWidgetByName(root, "Image_sell_out")
            	if Image_sell_out:isVisible() == true then
            	else
            		state_machine.excute("sm_shop_suipian_duihuan_window_open",0,{cell.prop, cell.index})
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新列表
		local sm_shop_debris_exchange_list_cell_refush_terminal = {
            _name = "sm_shop_debris_exchange_list_cell_refush",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local root = params.roots[1]
            	local Image_sell_out = ccui.Helper:seekWidgetByName(root, "Image_sell_out")
            	Image_sell_out:setVisible(true)
            	Image_sell_out:setScale(2)
            	Image_sell_out:runAction(cc.ScaleTo:create(0.1, 1))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(sm_shop_debris_exchange_list_cell_buy_terminal)
		state_machine.add(sm_shop_debris_exchange_list_cell_refush_terminal)
        state_machine.init()
	end
	init_sm_shop_debris_exchange_list_cell_terminal()
end

function SmShopDebrisExchangeListCell:onUpdateDraw()
	local root = self.roots[1]

	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	Text_name:setString(self.prop.mould_name.."x"..self.prop.number)
	local quality = tonumber(self.prop.prop_quality)
	Text_name:setColor(cc.c3b(color_Type[quality+1][1], color_Type[quality+1][2], color_Type[quality+1][3]))
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
	Text_5:setString(self.prop.sale_percentage)
	local Image_sell_out = ccui.Helper:seekWidgetByName(root, "Image_sell_out")
	Image_sell_out:setVisible(false)

	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	Panel_6:removeAllChildren(true)
	local cell = ResourcesIconCell:createCell()
	if tonumber(self.prop.type) == 7 then
		cell:init(tonumber(self.prop.type),0,tonumber(self.prop.mould_id),nil,nil,nil,nil,nil,{equipQuality = quality})
	else
		cell:init(tonumber(self.prop.type),0,tonumber(self.prop.mould_id))
	end
	
	Panel_6:addChild(cell)
	local panel = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop")
	panel:setTouchEnabled(false)

	-- 限时商品标签
	local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
	if Image_1 ~= nil then
		if self.prop.max_buy_times > 0 then
			Image_1:setVisible(true)
		else
			Image_1:setVisible(false)
		end
	end

	local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
	if Panel_icon ~= nil then
		Panel_icon:setBackGroundImage("images/ui/text/shop/sp.png")
	end
end

function SmShopDebrisExchangeListCell:onInit()
	local root = cacher.createUIRef("list/list_daoju.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

	if SmShopDebrisExchangeListCell.__size == nil then
		SmShopDebrisExchangeListCell.__size = root:getContentSize()
	end

 	local function PanelTouchEvent(sender, evenType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        if ccui.TouchEventType.began == evenType then
        elseif ccui.TouchEventType.moved == evenType then
        elseif ccui.TouchEventType.canceled == evenType then
        elseif ccui.TouchEventType.ended == evenType then
            if math.abs(__epoint.x - __spoint.x) <= 3 
            	and math.abs(__epoint.y - __spoint.y) <= 3 then
                state_machine.excute("sm_shop_debris_exchange_list_cell_buy",0,{sender._self})
            end
        end
    end
 	local Image_purchase = ccui.Helper:seekWidgetByName(root, "Image_purchase")
 	Image_purchase._self = self
 	Image_purchase:addTouchEventListener(PanelTouchEvent)
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_purchase"), nil, 
	-- {
	-- 	terminal_name = "sm_shop_debris_exchange_list_cell_buy", 
	-- 	terminal_state = 0, 
	-- 	_cell = self,
	-- }, 
	-- nil, 0)

	self:onUpdateDraw()
end

function SmShopDebrisExchangeListCell:clearUIInfo()
	local root = self.roots[1]
	local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")
	local Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")
	local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
	if Text_name ~= nil then
		Text_name:setString("")
		Text_5:setString("")
		Panel_6:removeAllChildren(true)
		Panel_icon:removeBackGroundImage()
	end
    local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
	if Image_1 ~= nil then
		Image_1:setVisible(false)
	end
end

function SmShopDebrisExchangeListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SmShopDebrisExchangeListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("list/list_daoju.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function SmShopDebrisExchangeListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("list/list_daoju.csb", self.roots[1])
end

function SmShopDebrisExchangeListCell:init(params)
	self.prop = params[1]
	self.index = params[2]
	if self.index <= 4 then
		self:onInit()
	end
	self:setContentSize(SmShopDebrisExchangeListCell.__size)
end



