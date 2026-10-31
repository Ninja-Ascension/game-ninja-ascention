-- ----------------------------------------------------------------------------------------------------
-- 说明：月卡推送（）
-------------------------------------------------------------------------------------------------------
ActivityMonthCardPush = class("ActivityMonthCardPushClass", Window)

local activity_month_card_window_open_terminal = {
    _name = "activity_month_card_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ActivityMonthCardPushClass") then
            if nil ~= params and true == params._battle_lost then
                
            else
                -- local sceneId = 4
                -- local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], sceneId, pve_scene.npcs), ",")
                -- local maxNpcId = tonumber(tempNpcIds[1])
                -- local npcState = tonumber(_ED.npc_state[zstring.tonumber(maxNpcId)])
                -- if npcState >= 0 then
                -- else
                --     return false
                -- end   
            end
            if nil == terminal._drawMonth then
                terminal._drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
            end
            local _drawMonth = terminal._drawMonth
            local one_month_data = _drawMonth[1]
            local month_card_time = 0
            local month_card_state = 0
            if nil ~= _ED.month_card and _ED.month_card[_drawMonth[1][1]] ~= nil then
                month_card_time = _ED.month_card[_drawMonth[1][1]].surplus_month_card_time
                -- month_card_state = _ED.month_card[one_month_data].draw_month_card_state
            end
            if zstring.tonumber(month_card_time) > 0 then
                return false
            end
            fwin:open(ActivityMonthCardPush:new():init(params), fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_month_card_window_close_terminal = {
    _name = "activity_month_card_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ActivityMonthCardPushClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_month_card_window_open_terminal)
state_machine.add(activity_month_card_window_close_terminal)
state_machine.init()

function ActivityMonthCardPush:ctor()
    self.super:ctor()
    self.roots = {}

    --load lua file

    -- var

    -- Initialize activity month card push state machine.
    local function init_activity_month_card_push_terminal()
      -- 充值界面跳转
        local activity_month_card_push_goto_recharge_list_terminal = {
            _name = "activity_month_card_push_goto_recharge_list",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("recharge_dialog_window_open",0,params._datas.ntype)
                state_machine.excute("activity_month_card_window_close", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_month_card_push_goto_recharge_list_terminal)
        state_machine.init()
    end
    
    -- call func init activity_month_card_push state machine.
    init_activity_month_card_push_terminal()
end

function ActivityMonthCardPush:onUpdateDraw()
    
end

function ActivityMonthCardPush:onInit(params)
    local csbFileName = config_csb.activity.wonderful.activity_on_card_push_44
    if zstring.tonumber(_ED.user_info.recharge_all_rmb) > 0 then
        csbFileName = config_csb.activity.wonderful.activity_on_card_push_45
    end
    local csbItem = csb.createNode(csbFileName)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --进入月卡购买界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_charge"), nil, 
    {
        terminal_name = "activity_month_card_push_goto_recharge_list", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 1,
    }, nil, 0)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "activity_month_card_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw()
    
end

function ActivityMonthCardPush:init(params)
    self:onInit(params)
    return self
end

function ActivityMonthCardPush:onEnterTransitionFinish()

end

function ActivityMonthCardPush:onExit()
    state_machine.remove("activity_month_card_push_goto_recharge_list")
end
