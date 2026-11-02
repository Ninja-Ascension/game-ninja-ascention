-----------------------------
--马魂兑换
-----------------------------
RacecourseSoulExchange = class("RacecourseSoulExchangeClass", Window)
--打开
local racecourse_soul_exchange_window_open_terminal = {
    _name = "racecourse_soul_exchange_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _RacecourseWindow = fwin:find("RacecourseSoulExchangeClass")
        if nil == _RacecourseWindow then
            fwin:open(RacecourseSoulExchange:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local racecourse_soul_exchange_window_close_terminal = {
    _name = "racecourse_soul_exchange_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RacecourseSoulExchangeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(racecourse_soul_exchange_window_open_terminal)
state_machine.add(racecourse_soul_exchange_window_close_terminal)
state_machine.init()

function RacecourseSoulExchange:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    app.load("client.red_alert_time.forging.Refining")
    app.load("client.red_alert_time.cells.horse.racecourse_soul_exchange_cell")

    local function init_racecourse_soul_exchange_terminal()
        --刷新碎片数量
        local racecource_soul_exchange_refreash_terminal = {
            _name = "racecource_soul_exchange_refreash",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:onfreash()
                end
               return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(racecource_soul_exchange_refreash_terminal)
        state_machine.init()
    end
    init_racecourse_soul_exchange_terminal()
end 

--刷新碎片数量
function RacecourseSoulExchange:onfreash()
    local root = self.roots[1]
    local Text_soul_number = ccui.Helper:seekWidgetByName(root, "Text_soul_number")
    Text_soul_number:setString("".._ED.user_info.horse_spirits_patch)
end

--初始化
function RacecourseSoulExchange:onUpdateDraw()
    local root = self.roots[1]
    local Text_soul_number = ccui.Helper:seekWidgetByName(root,"Text_soul_number")
    local ScrollView_exchange_list = ccui.Helper:seekWidgetByName(root,"ScrollView_exchange_list")
    local ListView_exchange_list = ccui.Helper:seekWidgetByName(root,"ListView_exchange_list")
    local ListView_exchange_list_2 = ccui.Helper:seekWidgetByName(root,"ListView_exchange_list_2")
    ListView_exchange_list:removeAllItems()
    ListView_exchange_list_2:removeAllItems()
    --遍历橙色附魔
    local width = 0
    for i = 1, dms.count( dms["horse_change"] ) do
        local recharge_id = dms.int(dms["horse_change"], i, horse_change.id)
        local horse_recharge_id = dms.int(dms["horse_change"], i, horse_change.horse_recharge_id)
        local recharge_infos = dms.string(dms["horse_change"], i, horse_change.recharge_infos)
        local cell = state_machine.excute("racecource_soul_exchange_create_cell", 0, {i, recharge_id, horse_recharge_id, recharge_infos})
        if i <= 7 then
            ListView_exchange_list_2:addChild(cell)
        else
            ListView_exchange_list:addChild(cell)
        end
        width = cell:getContentSize().width
    end
    
    Text_soul_number:setString("".._ED.user_info.horse_spirits_patch)
    ScrollView_exchange_list:getInnerContainer():setContentSize(cc.size(width * 7, ScrollView_exchange_list:getContentSize().height))
    ListView_exchange_list:requestRefreshView()
    ListView_exchange_list_2:requestRefreshView()
end

function RacecourseSoulExchange:onInit( )
    local csbItem = csb.createNode(config_csb.horse.treasure_soul_exchange)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "racecourse_soul_exchange_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    
    --分解(进入珍兽分解)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_obtain"), nil, 
    {
        terminal_name = "refining_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        page_index = 3,
    }, nil, 0)   

    self:onUpdateDraw()
end


function RacecourseSoulExchange:init()
	self:onInit()
    return self
end

function RacecourseSoulExchange:onExit()
    state_machine.remove("racecource_soul_exchange_refreash")
end