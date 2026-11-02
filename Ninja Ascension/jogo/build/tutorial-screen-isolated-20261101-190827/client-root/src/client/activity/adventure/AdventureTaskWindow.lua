-- ----------------------------------------------------------------------------------------------------
-- 说明：大冒险任务
-------------------------------------------------------------------------------------------------------
AdventureTaskWindow = class("AdventureTaskWindowClass", Window)

local adventure_task_window_open_terminal = {
    _name = "adventure_task_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("AdventureTaskWindowClass") == nil then
            fwin:open(AdventureTaskWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local adventure_task_window_close_terminal = {
    _name = "adventure_task_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("AdventureTaskWindowClass") then
            fwin:close(fwin:find("AdventureTaskWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_task_window_open_terminal)
state_machine.add(adventure_task_window_close_terminal)
state_machine.init()

function AdventureTaskWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self._Text_32 = nil

    self._end_time = 0
    app.load("client.activity.adventure.AdventureTaskCell")

    local function init_AdventureTaskWindow_terminal()
    
        local adventure_task_window_onUpdate_data_terminal = {
            _name = "adventure_task_window_onUpdate_data",
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
        
        state_machine.add(adventure_task_window_onUpdate_data_terminal)
        state_machine.init()
    end
    
    init_AdventureTaskWindow_terminal()
end

function AdventureTaskWindow:init(params)
    return self
end

function AdventureTaskWindow:onUpdate(dt)
    if self._Text_32 == nil then
        return
    end
    local surplus_time = self._end_time - (os.time() + _ED.time_add_or_sub)
    self._Text_32:setString(surplus_time < 0 and _string_piece_info[305] or getRedAlertTimeActivityFormat(surplus_time).._new_interface_text[245])
    
end

function AdventureTaskWindow:onUpdateDraw()
    local root = self.roots[1]
    local activity = _ED.active_activity[153]
    if not activity then
        TipDlg.drawTextDailog(_new_interface_text[113])
        return
    end
    self._Text_32 = ccui.Helper:seekWidgetByName(root, "Text_gem_n")
    local Text_consume_power = ccui.Helper:seekWidgetByName(root, "Text_consume_power")
    Text_consume_power:setVisible(false)
    self._end_time = tonumber(activity.end_time) / 1000
    local rewardListView = ccui.Helper:seekWidgetByName(root, "ListView_buy_01") 
    rewardListView:removeAllItems()
    self.cacheListView = rewardListView
    local item_group = {}
    for i, v in pairs(activity.activity_Info) do
        local cell = AdventureTaskCell:createCell()
        cell:init(activity.activity_Info[i], i, 153)
        table.insert(item_group, cell)
    end
    item_group = self:sortListItems(item_group)
    for k, cell in pairs(item_group) do
        self.cacheListView:addChild(cell)
    end
    self.cacheListView:requestRefreshView()
end

function AdventureTaskWindow:sortListItems(items)
    local result = {}
    local closeItems = {}       -- 已完成
    local drawItems = {}            -- 可领取
    local uncompItems = {}      -- 未完成
    for k, v in pairs(items) do
        if tonumber(v.rewardState) == 0 then
            table.insert(uncompItems, v)
        elseif tonumber(v.rewardState) == 1 then
            table.insert(drawItems, v)
        else
            table.insert(closeItems, v)
        end
    end
    for k, v in pairs(drawItems) do
        table.insert(result, v)
    end
    for k, v in pairs(uncompItems) do
        table.insert(result, v)
    end
    for k, v in pairs(closeItems) do
        table.insert(result, v)
    end
    return result
end


function AdventureTaskWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/adventure/adv_task_buy.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil, 
    {
        terminal_name = "adventure_task_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function AdventureTaskWindow:onExit()

end
