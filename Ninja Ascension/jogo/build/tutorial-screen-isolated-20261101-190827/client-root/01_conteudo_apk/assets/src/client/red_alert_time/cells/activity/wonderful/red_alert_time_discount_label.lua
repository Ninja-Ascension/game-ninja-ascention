--------------------------------------------------------------------------------------------------------------
--  说明：折扣标签
--------------------------------------------------------------------------------------------------------------
RedAlertTimeDiscountLabel = class("RedAlertTimeDiscountLabelClass", Window)
RedAlertTimeDiscountLabel.__size = nil

--创建cell
local red_alert_time_discount_label_cell_terminal = {
    _name = "red_alert_time_discount_label_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeDiscountLabel:new()
		local discount = params[1]
		local a_type = tonumber(params[2]) or 0
        cell:init(discount,a_type)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_discount_label_cell_terminal)
state_machine.init()

function RedAlertTimeDiscountLabel:ctor()
	self.super:ctor()
	self.roots = {}
	self.discount = nil
	self.a_type = nil
	 -- Initialize red_alert_time_center_cell state machine.

end

function RedAlertTimeDiscountLabel:updateDraw()
    local root = self.roots[1]
	local Text_props_discount_n = ccui.Helper:seekWidgetByName(root,"Text_props_discount_n")
	--local discounts = string.gsub(activity_str_tip[22], "x", self.discount)
    local curr_discount = self.discount
    if verifySupportLanguage(_lua_release_language_en) == true then
        curr_discount = (10 - self.discount) * 10
    end
    local discounts = string.format(activity_str_tip[22], ""..curr_discount)
	if tonumber(self.a_type) > 0 then
		discounts = "v"..self.discount
	end
	Text_props_discount_n:setString(discounts)
end



function RedAlertTimeDiscountLabel:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.act_props_discount_icon_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeDiscountLabel.__size == nil then
        RedAlertTimeDiscountLabel.__size = root:getContentSize()
    end

	self:updateDraw()

end

function RedAlertTimeDiscountLabel:onEnterTransitionFinish()
    local root = self.roots[1]
end

function RedAlertTimeDiscountLabel:clearUIInfo( ... )
    local root = self.roots[1]
	local Text_props_discount_n = ccui.Helper:seekWidgetByName(root,"Text_props_discount_n")
	if Text_props_discount_n~= nil then
		Text_props_discount_n:setString("")
	end
end

function RedAlertTimeDiscountLabel:onUpdate()
    if self._push_activity == nil then
       return
    end
    local now_time = os.time()
    if now_time - zstring.tonumber(self._last_time) >= 1 then
        -- self:pushNotificationActivity()
        self._last_time = now_time
    end
end

function RedAlertTimeDiscountLabel:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function RedAlertTimeDiscountLabel:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.act_props_discount_icon_cell, root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeDiscountLabel:init(discount,a_type)
    self.discount = tonumber(discount)
    self.a_type = a_type
    self:onInit()

    self:setContentSize(RedAlertTimeDiscountLabel.__size)
    return self
end

function RedAlertTimeDiscountLabel:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.act_props_discount_icon_cell, self.roots[1])
end