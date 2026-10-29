--------------------------------------------------------------------------------------------------------------
--  说明：VIP特权福利
--------------------------------------------------------------------------------------------------------------
RedAlertTimeVipGift = class("RedAlertTimeVipGiftClass", Window)

--打开界面
local red_alert_time_vip_gift_open_terminal = {
    _name = "red_alert_time_vip_gift_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("RedAlertTimeVipGiftClass") == nil then
            local panel = RedAlertTimeVipGift:new():init(params)
            fwin:open(panel)
            return panel
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local red_alert_time_vip_gift_close_terminal = {
    _name = "red_alert_time_vip_gift_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RedAlertTimeVipGiftClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_vip_gift_open_terminal)
state_machine.add(red_alert_time_vip_gift_close_terminal)
state_machine.init()

function RedAlertTimeVipGift:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    self._Image_vip_package_arrow_down = nil
    self._Image_vip_package_arrow_up = nil

    self._activity_type = 131

    app.load("client.red_alert_time.cells.activity.wonderful.red_alert_time_vip_gift_cell")
    local function init_red_alert_time_vip_gift_terminal()
        local red_alert_time_vip_gift_show_terminal = {
            _name = "red_alert_time_vip_gift_show",
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

        local red_alert_time_vip_gift_hide_terminal = {
            _name = "red_alert_time_vip_gift_hide",
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

        local red_alert_time_vip_gift_update_draw_terminal = {
            _name = "red_alert_time_vip_gift_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local posY = instance._list_view_poy
                instance:updateDraw()
                if math.abs(posY) > math.abs(instance._list_view_height) then
                    posY = instance._list_view_height
                end
                instance._list_view:getInnerContainer():setPositionY(posY)  
                instance._list_view_poy = posY + 1
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_vip_gift_show_terminal)
        state_machine.add(red_alert_time_vip_gift_hide_terminal)
        state_machine.add(red_alert_time_vip_gift_update_draw_terminal)
        state_machine.init()
    end
    
    init_red_alert_time_vip_gift_terminal()
end

function RedAlertTimeVipGift:fixedListPostion()
    if self._list_view == nil then
        return
    end

    local items = self._list_view:getItems()
    local index = 0
    local cell_size = nil
    for k, v in pairs(items) do
        if cell_size == nil then
            cell_size = v:getContentSize()
        end
        if tonumber(v._info.achieve_state) == 1 then
            index = k
            break
        end
    end

    if index > 0 then
        local posY = (index - 1) * cell_size.height
        self._list_view:getInnerContainer():setPositionY(posY)
    end
end

function RedAlertTimeVipGift:updateDraw()
    local root = self.roots[1]
    if _ED.activity_info == nil or _ED.activity_info[""..self._activity_type] == nil then
        return
    end

    local activity_info = _ED.activity_info[""..self._activity_type]

    local ListView_vip_package = ccui.Helper:seekWidgetByName(root, "ListView_vip_package")
    ListView_vip_package:jumpToTop()

    local result = activity_info.activity_data[1]

    local items = ListView_vip_package:getItems()
    for k,v in pairs(items) do
        state_machine.excute("red_alert_time_vip_gift_cell_update_info", 0, {cell = v, info = result[k], index = k, group = 1})
    end

    if #items > #result then
        local index = 0
        for i=#result + 1, #items do
            ListView_vip_package:removeItem(#items - index - 1)
            index = index + 1
        end
    elseif #items < #result then
        for i=#items + 1, #result do
            local cell = state_machine.excute("red_alert_time_vip_gift_cell_create", 0, {i, result[i], self._activity_type, 1})
            ListView_vip_package:addChild(cell)
        end
    end

    ListView_vip_package:requestRefreshView()
    self._list_view = ListView_vip_package
    self._list_view_poy = ListView_vip_package:getInnerContainer():getPositionY()
    self._list_view_height = ListView_vip_package:getInnerContainer():getPositionY()
end


function RedAlertTimeVipGift:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_vip_package_arrow_down:setVisible(true)
        else
            self._Image_vip_package_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_vip_package_arrow_up:setVisible(true)
        else
            self._Image_vip_package_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
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
function RedAlertTimeVipGift:onInit()
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
    self:fixedListPostion()
end

function RedAlertTimeVipGift:onEnterTransitionFinish()

end

function RedAlertTimeVipGift:init(param)
    self._rootWindows = param[1]
    self:onInit()
    return self
end

function RedAlertTimeVipGift:onExit()
    state_machine.remove("red_alert_time_vip_gift_show")
    state_machine.remove("red_alert_time_vip_gift_hide")
    state_machine.remove("red_alert_time_vip_gift_update_draw")
end