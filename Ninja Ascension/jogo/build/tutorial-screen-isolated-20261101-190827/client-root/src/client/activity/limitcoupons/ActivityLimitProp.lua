----------------------------------------------------------------------------------------------------
-- 说明：折扣道具
-------------------------------------------------------------------------------------------------------

ActivityLimitProp = class("ActivityLimitPropClass", Window)
    
function ActivityLimitProp:ctor()
    self.super:ctor()
    self.roots = {}
    self._drawGold = 0
    self.interval = 0
    self.needUpdateRefreshCd = false
    self._Text_sx1 = nil

    app.load("client.cells.activity.activity_limit_recharge_icon_cell")
     app.load("client.utils.TimeUtil")
    -- Initialize all server fund activity page state machine.
    local function init_activity_limit_prop_terminal()
        local activity_limit_prop_update_draw_terminal = {
            _name = "activity_limit_prop_update_draw",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.onUpdateDraw ~= nil then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(activity_limit_prop_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init all server fund activity state machine.
    init_activity_limit_prop_terminal()
end

function ActivityLimitProp:onUpdate(dt)
	-- 绘制用户的领取信息
    local root = self.roots[1]
    if _ED.limit_recharege_info.os_time ~= nil then
        local interval = _ED.limit_recharege_info.os_time + _ED.limit_recharege_info.limit_count_down - os.time()
        if self.interval >= 0 then 
            self.interval = interval
        end
        self:updateRefreshCd()
    end
end 

function ActivityLimitProp:updateRefreshCd()
    if self.needUpdateRefreshCd == false then
        return
    end
    if self._Text_sx1 == nil then
        return
    end
    local root = self.roots[1]
    local interval = self.interval
    if interval <= 0 then
        self._Text_sx1:setString("0"..tipStringInfo_time_info[5].."00"..tipStringInfo_time_info[6] .. "00"..tipStringInfo_time_info[7])
        self:onUpdateSendRequestInit()
    else
        self.interval = math.max(0, self.interval)

        local timeTabel = formatTime(self.interval)
        local str = timeTabel.hour ..tipStringInfo_time_info[5]
        str = str .. string.format("%02d"..tipStringInfo_time_info[6], timeTabel.minute)
        str = str .. string.format("%02d"..tipStringInfo_time_info[7], timeTabel.second)

        self._Text_sx1:setString(str)
    end
end

function ActivityLimitProp:onUpdateSendRequestInit()
   self.needUpdateRefreshCd = false
   local function responseLimitInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                response.node.needUpdateRefreshCd = true
                state_machine.excute("activity_limit_prop_update_draw", 0, 0)
                state_machine.excute("activity_people_weal_update_draw", 0, 0)
            end
        end
    end
    NetworkManager:register(protocol_command.limited_recharge_init.code, nil, nil, nil, self, responseLimitInitCallback, false, nil)
end

function ActivityLimitProp:onUpdateDraw()
    self.interval = _ED.limit_recharege_info.os_time + _ED.limit_recharege_info.limit_count_down - os.time()
    local root = self.roots[1]
    self._Text_sx1 = ccui.Helper:seekWidgetByName(root, "Text_sx1")
    local propPanels = {}
    for i=1,6 do
        local prop = ccui.Helper:seekWidgetByName(root, "Panel_prop_"..i)
        prop:removeAllChildren(true)
        table.insert(propPanels,prop)
    end
    for k,v in pairs(_ED.limit_recharege_info.props) do
        local propCell = ActivityLimitRechargeIconCell:createCell()
        propCell:init(zstring.tonumber(k))
        local propPanel = propPanels[k]
        if propPanel ~= nil then 
            propPanel:addChild(propCell)
        end
    end
end

function ActivityLimitProp:onEnterTransitionFinish()
    local csbActivityLimitProp = csb.createNode("activity/wonderful/limited_time_discount_1.csb")
    self:addChild(csbActivityLimitProp)
    local root = csbActivityLimitProp:getChildByName("root")
    table.insert(self.roots, root)
    self.interval = _ED.limit_recharege_info.os_time + _ED.limit_recharege_info.limit_count_down - os.time()
    -- self:initActivityListView()
    self:onUpdateDraw()
    self.needUpdateRefreshCd = true
end

function ActivityLimitProp:onExit()
    state_machine.remove("activity_limit_prop_update_draw")
end

function ActivityLimitProp:init()
end

function ActivityLimitProp:createCell()
    local cell = ActivityLimitProp:new()
    cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 1)
    return cell
end