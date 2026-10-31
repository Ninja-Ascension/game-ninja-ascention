-- ----------------------------------------------------------------------------------------------------
-- 说明：每日充值宝箱查看
-------------------------------------------------------------------------------------------------------
SmActivityRechargeEverydayBox = class("SmActivityRechargeEverydayBoxClass", Window)

local sm_activity_recharge_everyday_box_open_terminal = {
    _name = "sm_activity_recharge_everyday_box_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SmActivityRechargeEverydayBoxClass") ~= nil then 
            return
        end
        local _window = SmActivityRechargeEverydayBox:createCell()
        _window:init(params)
        fwin:open(_window , fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
local sm_activity_recharge_everyday_box_close_terminal = {
    _name = "sm_activity_recharge_everyday_box_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmActivityRechargeEverydayBoxClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_activity_recharge_everyday_box_open_terminal)
state_machine.add(sm_activity_recharge_everyday_box_close_terminal)
state_machine.init()
 
function SmActivityRechargeEverydayBox:ctor()
    self.super:ctor()
    self.roots = {}
end

function SmActivityRechargeEverydayBox:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local rewardNumber = 0
    for i , v in pairs(self.data.activityInfo_prop_info) do
        if i < 3 then
            rewardNumber = rewardNumber + 1
            local Panel_recharge_everyday_gift_icon = ccui.Helper:seekWidgetByName(root,"Panel_recharge_everyday_gift_icon_"..i)
            Panel_recharge_everyday_gift_icon:removeAllChildren(true)
            local cell = ResourcesIconCell:createCell()
            cell:init(6, v.propMouldCount, v.propMould,nil,nil,nil,true)
            Panel_recharge_everyday_gift_icon:addChild(cell)
        end
    end
     for i , v in pairs(self.data.activityInfo_equip_info) do
        if rewardNumber < 3 then
            rewardNumber = rewardNumber + 1
            local Panel_recharge_everyday_gift_icon = ccui.Helper:seekWidgetByName(root,"Panel_recharge_everyday_gift_icon_"..rewardNumber)
            Panel_recharge_everyday_gift_icon:removeAllChildren(true)
            local cell = ResourcesIconCell:createCell()
            cell:init(7, tonumber(v.equipMouldCount), v.equipMould,nil,nil,true,true)
            Panel_recharge_everyday_gift_icon:addChild(cell)
        end
    end
    if rewardNumber < 3 then
        if tonumber(self.data.activityInfo_silver) > 0 then
            local Panel_recharge_everyday_gift_icon = ccui.Helper:seekWidgetByName(root,"Panel_recharge_everyday_gift_icon_3")
            Panel_recharge_everyday_gift_icon:removeAllChildren(true)
            local cell = ResourcesIconCell:createCell()
            cell:init(1, self.data.activityInfo_silver, -1,nil,nil,nil,true)
            Panel_recharge_everyday_gift_icon:addChild(cell)
        end
    end
end


function SmActivityRechargeEverydayBox:init(params)
    self.data = params
    self:onInit()
end

function SmActivityRechargeEverydayBox:onInit()
    local csbSmActivityRechargeEverydayBox = csb.createNode("activity/wonderful/recharge_everyday_gift_infor.csb")
    local root = csbSmActivityRechargeEverydayBox:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmActivityRechargeEverydayBox)

	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_everyday_gift_close"), nil, 
    {
        terminal_name = "sm_activity_recharge_everyday_box_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

    self:onUpdateDraw()

end

function SmActivityRechargeEverydayBox:onExit()
   
end

function SmActivityRechargeEverydayBox:createCell()
    local cell = SmActivityRechargeEverydayBox:new()
    cell:registerOnNodeEvent(cell)
    return cell
end