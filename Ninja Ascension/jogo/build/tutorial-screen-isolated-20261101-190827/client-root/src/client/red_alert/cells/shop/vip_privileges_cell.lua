--------------------------------------------------------------------------------------------------------------
--  说明：vip权限
--------------------------------------------------------------------------------------------------------------
VipPrivilegesCell = class("VipPrivilegesCellClass", Window)
VipPrivilegesCell.__size = nil

local vip_privileges_create_cell_terminal = {
    _name = "vip_privileges_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = VipPrivilegesCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(vip_privileges_create_cell_terminal)
state_machine.init()

function VipPrivilegesCell:ctor()
	self.super:ctor()
	self.roots = {}
	self._index = 0
    self._isChoose = false

    local function init_vip_privileges_cell_terminal()
		local vip_privileges_cell_choose_terminal = {
            _name = "vip_privileges_cell_choose",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params._isChoose == true then
                    return
                end
                state_machine.excute("vip_privilege_red_alert_change_vip_title", 0, params._index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(vip_privileges_cell_choose_terminal)
        state_machine.init()
    end
    
    init_vip_privileges_cell_terminal()
end

function VipPrivilegesCell:setUnChooseState( ... )
    local root = self.roots[1]
    local Text_vip_infor = ccui.Helper:seekWidgetByName(root,"Text_vip_infor")
    if self._isChoose == true then
        ccui.Helper:seekWidgetByName(root,"Image_bg_2"):setVisible(true)
        Text_vip_infor:setColor(cc.c3b(255, 234, 198))
        -- if tonumber(self._index) == tonumber(_ED.vip_grade + 1) and 
        --     (tonumber(self._index) == 7 or tonumber(self._index) == 8 or tonumber(self._index) == 9) then
        --     ccui.Helper:seekWidgetByName(root,"Image_push"):setVisible(false)
        --     _ED._push_VIP = 0
        -- end
        -- cc.UserDefault:getInstance():setStringForKey(getKey("VIP_privileges_push_state"), "0")
        
    else
        ccui.Helper:seekWidgetByName(root,"Image_bg_2"):setVisible(false)
        Text_vip_infor:setColor(cc.c3b(144, 101, 65))
    end
end

function VipPrivilegesCell:updateDraw()
    local root = self.roots[1]
    local Text_vip_level = ccui.Helper:seekWidgetByName(root,"Text_vip_level")
    local Text_vip_infor = ccui.Helper:seekWidgetByName(root,"Text_vip_infor")
    Text_vip_level:setString(""..self._index)
    Text_vip_infor:setString(_vip_privilege_title_info[self._index])
    Text_vip_infor:setColor(cc.c3b(144, 101, 65))
end

-- 推送
function VipPrivilegesCell:onUpdate()
    if self.roots == nil or self.roots[1] == nil then
        return
    end
    local root = self.roots[1]
    local Image_push = ccui.Helper:seekWidgetByName(root,"Image_push")
    Image_push:setVisible(false)
    if tonumber(self._index) <= tonumber(_ED.vip_grade) then
        for i=1,tonumber(self._index) do
            local items = _ED.all_shop_info["2"]
            local item = items[i]
            if item ~= nil then 
                local openInfos = zstring.split(item.open_info, ",")
                if tonumber(_ED.vip_grade) >= tonumber(openInfos[2]) then
                    if tonumber(item.remain_times) ~= 0 then
                        Image_push:setVisible(true)
                    else
                        Image_push:setVisible(false)
                    end
                end
            end
        end
    else
        Image_push:setVisible(false)
    end
    -- if pushNotificationVIP() == true then
    --     if tonumber(self._index) == tonumber(_ED.vip_grade + 1) and 
    --         (tonumber(self._index) == 7 or tonumber(self._index) == 8 or tonumber(self._index) == 9) then
    --         Image_push:setVisible(true)
    --     end
    -- end
end

function VipPrivilegesCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.shop.vip_privileges_cell)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 
    if VipPrivilegesCell.__size == nil then
        VipPrivilegesCell.__size = root:getContentSize()
    end

    local Panel_vip_privileges_cell = ccui.Helper:seekWidgetByName(root, "Panel_vip_privileges_cell")
    Panel_vip_privileges_cell:setSwallowTouches(false)

    local function panelTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if math.abs(__spoint.x - __epoint.x) <= 3 and math.abs(__spoint.y - __epoint.y) <= 3 then
                state_machine.excute("vip_privileges_cell_choose", 0, self)
            end
        end
    end
    Panel_vip_privileges_cell:addTouchEventListener(panelTouchListener)
    
	self:updateDraw()
end

function VipPrivilegesCell:onEnterTransitionFinish()

end

function VipPrivilegesCell:init(index)
    self._index = index
	self:onInit()
    self:setContentSize(VipPrivilegesCell.__size)
end

function VipPrivilegesCell:onExit()
    state_machine.remove("vip_privileges_cell_choose")
end