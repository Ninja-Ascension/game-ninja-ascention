-----------------------------
-- 累积消费(活动类型20)
-----------------------------
AccumlateConsumption = class("AccumlateConsumptionClass", Window)
-- 打开
local accumlate_consumption_window_open_terminal = {
    _name = "accumlate_consumption_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("AccumlateConsumptionClass") then
            local panel = AccumlateConsumption:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(accumlate_consumption_window_open_terminal)
state_machine.init()

function AccumlateConsumption:ctor()
    self.super:ctor()
    self.roots = {}

    self._height = 0
    -- 设置 Y轴
    local function init_accumlate_consumption_terminal()
		local accumlate_consumption_set_positiony_terminal = {
            _name = "accumlate_consumption_set_positiony",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                local height = instance._list_view:getContentSize().height
                if instance._height > height then
                    instance._list_view:getInnerContainer():setPositionY(height - instance._height)
                else
                    instance._list_view:getInnerContainer():setPositionY(0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(accumlate_consumption_set_positiony_terminal)	
        state_machine.init()
    end
    
    init_accumlate_consumption_terminal()
end

function AccumlateConsumption:onUpdateDraw()
    local root = self.roots[1]
    -- 活动时间
    local Text_topup_reward1 = ccui.Helper:seekWidgetByName(root, "Text_topup_reward1")
    Text_topup_reward1:setString(_ED.activity_info["20"].activity_dec)
    -- 任务列表
    local ListView_topup_reward = ccui.Helper:seekWidgetByName(root, "ListView_topup_reward") 
    ListView_topup_reward:removeAllItems()

    local result1 = {}
    local result2 = {}
    local result3 = {}
    -- 按完成状态排序，完成>未完成>已领取
    for k,v in pairs(_ED.activity_info["20"].activity_data[1]) do
        if tonumber(v.achieve_state) == 1 then
            table.insert(result1, v)
        elseif tonumber(v.achieve_state) == 0 then
            table.insert(result2, v)
        elseif tonumber(v.achieve_state) == 2 then
            table.insert(result3, v)
        end
    end
    for k,v in pairs(result2) do
        table.insert(result1, v)
    end
    for k,v in pairs(result3) do
        table.insert(result1, v)
    end
    -- 排序后创建cell
    for i, v in pairs(result1) do
        local cell = state_machine.excute("famous_general_create_cell",0,{v,"20",i,1})
        ListView_topup_reward:addChild(cell)
        self._height = cell:getContentSize().height + self._height
    end
    ListView_topup_reward:requestRefreshView()
    self._list_view = ListView_topup_reward
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function AccumlateConsumption:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
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

function AccumlateConsumption:onEnterTransitionFinish()

end

function AccumlateConsumption:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.accumlate_consumption)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

	self:onUpdateDraw()
end

function AccumlateConsumption:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function AccumlateConsumption:onExit()
    state_machine.remove("accumlate_consumption_set_positiony")
end
