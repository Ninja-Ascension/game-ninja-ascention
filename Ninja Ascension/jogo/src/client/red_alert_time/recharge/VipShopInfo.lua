--------------------------------------------------------------------------------------------------------------
--  说明：VIP特权礼包
--------------------------------------------------------------------------------------------------------------
VipShopInfo = class("VipShopInfoClass", Window)

--打开界面
local vip_shop_info_open_terminal = {
	_name = "vip_shop_info_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("VipShopInfoClass") == nil then
            local panel = VipShopInfo:new():init(params)
    		fwin:open(panel)
            return panel
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local vip_shop_info_close_terminal = {
	_name = "vip_shop_info_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("VipShopInfoClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(vip_shop_info_open_terminal)
state_machine.add(vip_shop_info_close_terminal)
state_machine.init()

function VipShopInfo:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0

    self._Image_vip_package_arrow_down = nil
    self._Image_vip_package_arrow_up = nil

    app.load("client.red_alert_time.cells.shop.vip_privilege_package_cell")
    local function init_vip_shop_info_terminal()
        local vip_shop_info_show_terminal = {
            _name = "vip_shop_info_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local vip_shop_info_hide_terminal = {
            _name = "vip_shop_info_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local vip_shop_info_update_draw_terminal = {
            _name = "vip_shop_info_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(vip_shop_info_show_terminal)
        state_machine.add(vip_shop_info_hide_terminal)
        state_machine.add(vip_shop_info_update_draw_terminal)
        state_machine.init()
    end
    
    init_vip_shop_info_terminal()
end

function VipShopInfo:updateDraw()
    local root = self.roots[1]
    if _ED.activity_info == nil then
        return
    end
    if _ED.activity_info["49"] == nil then
        return
    end
    local ListView_vip_package = ccui.Helper:seekWidgetByName(root, "ListView_vip_package")
    ListView_vip_package:jumpToTop()
    ListView_vip_package:removeAllItems()

    local index = 1
    local activity_data = _ED.activity_info["49"].activity_data[1]
    for i=1, #activity_data do
        if tonumber(activity_data[i].achieve_state) ~= 2 then
            local cell = state_machine.excute("vip_privilege_package_create_cell",0,{activity_data[i],index,49,1})
            ListView_vip_package:addChild(cell)
            index = index + 1
        end
    end

    ListView_vip_package:requestRefreshView()
    self.listview = ListView_vip_package
    self.listview_poy = ListView_vip_package:getInnerContainer():getPositionY()
    self.listview_height = ListView_vip_package:getInnerContainer():getPositionY()
end


function VipShopInfo:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_vip_package_arrow_down:setVisible(true)
        else
            self._Image_vip_package_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_vip_package_arrow_up:setVisible(true)
        else
            self._Image_vip_package_arrow_up:setVisible(false)
        end
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
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

--初始化
function VipShopInfo:onInit()
    local csbItem = csb.createNode(config_csb.shop.vip_privilege_tab_2)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self._Image_vip_package_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_vip_package_arrow_down")
    self._Image_vip_package_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_vip_package_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_vip_package_arrow_down:stopAllActions()
    self._Image_vip_package_arrow_up:stopAllActions()
    playActions(self._Image_vip_package_arrow_down)
    playActions(self._Image_vip_package_arrow_up)
    self._Image_vip_package_arrow_down:setVisible(false)
    self._Image_vip_package_arrow_up:setVisible(false)

    self:updateDraw()
end

function VipShopInfo:onEnterTransitionFinish()

end

function VipShopInfo:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function VipShopInfo:onExit()
    state_machine.remove("vip_shop_info_show")
    state_machine.remove("vip_shop_info_hide")
    state_machine.remove("vip_shop_info_update_draw")
end