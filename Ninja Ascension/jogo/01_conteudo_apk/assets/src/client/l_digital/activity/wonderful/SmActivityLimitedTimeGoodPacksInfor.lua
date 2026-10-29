-- ----------------------------------------------------------------------------------------------------
-- 说明：破冰活动宝箱查看
-------------------------------------------------------------------------------------------------------
SmActivityLimitedTimeGoodPacksInfor = class("SmActivityLimitedTimeGoodPacksInforClass", Window)

local sm_activity_limited_time_good_packs_infor_open_terminal = {
    _name = "sm_activity_limited_time_good_packs_infor_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SmActivityLimitedTimeGoodPacksInforClass") ~= nil then 
            return
        end
        local _window = SmActivityLimitedTimeGoodPacksInfor:createCell()
        _window:init(params)
        fwin:open(_window , fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
local sm_activity_limited_time_good_packs_infor_close_terminal = {
    _name = "sm_activity_limited_time_good_packs_infor_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmActivityLimitedTimeGoodPacksInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_activity_limited_time_good_packs_infor_open_terminal)
state_machine.add(sm_activity_limited_time_good_packs_infor_close_terminal)
state_machine.init()
 
function SmActivityLimitedTimeGoodPacksInfor:ctor()
    self.super:ctor()
    self.roots = {}
end

function SmActivityLimitedTimeGoodPacksInfor:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local otherRewards = zstring.splits(self.data[1].activity_Info[1].activityInfo_reward_select, "|", ",")
    for i, reward in pairs(otherRewards) do
        local Panel_prpos_x = ccui.Helper:seekWidgetByName(root, "Panel_limited_time_good_packs_icon_" .. i)
        if Panel_prpos_x ~= nil then
            local cell = ResourcesIconCell:createCell()
            local rewardType = tonumber(reward[1])
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]), nil,nil,true,true)
            if rewardType == 6 
                and (dms.int(dms["prop_mould"], tonumber(reward[2]), prop_mould.use_of_ship) > 0 and dms.int(dms["prop_mould"], tonumber(reward[2]), prop_mould.storage_page_index) == 18) 
                then
                local jsonFile = "sprite/sprite_wzkp.json"
                local atlasFile = "sprite/sprite_wzkp.atlas"
                local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                animation:setPosition(cc.p(cell:getContentSize().width/2,cell:getContentSize().height/2))
                cell:addChild(animation)
            end
            Panel_prpos_x:addChild(cell)
        end
    end

end


function SmActivityLimitedTimeGoodPacksInfor:init(params)
    self.data = params
    self:onInit()
end

function SmActivityLimitedTimeGoodPacksInfor:onInit()
    local csbSmActivityLimitedTimeGoodPacksInfor = csb.createNode("activity/wonderful/limited_time_good_packs_infor.csb")
    local root = csbSmActivityLimitedTimeGoodPacksInfor:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmActivityLimitedTimeGoodPacksInfor)

	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_limited_time_good_packs_close"), nil, 
    {
        terminal_name = "sm_activity_limited_time_good_packs_infor_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

    self:onUpdateDraw()

end

function SmActivityLimitedTimeGoodPacksInfor:onExit()
   
end

function SmActivityLimitedTimeGoodPacksInfor:createCell()
    local cell = SmActivityLimitedTimeGoodPacksInfor:new()
    cell:registerOnNodeEvent(cell)
    return cell
end