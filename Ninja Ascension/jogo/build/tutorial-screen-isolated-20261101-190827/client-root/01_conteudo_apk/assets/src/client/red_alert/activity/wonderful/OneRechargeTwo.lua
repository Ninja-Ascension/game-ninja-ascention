-----------------------------
--单笔充值2(活动类型41)
-----------------------------
OneRechargeTwo = class("OneRechargeTwoClass", Window)

local one_recharge_two_window_open_terminal = {
    _name = "one_recharge_two_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("OneRechargeTwoClass") then
            local panel = OneRechargeTwo:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(one_recharge_two_window_open_terminal)
state_machine.init()

function OneRechargeTwo:ctor()
    self.super:ctor()
    self.roots = {}

    self._height = 0
    --load lua file

    -- Initialize one_recharge_two state machine.
    local function init_one_recharge_two_terminal()
	
		--刷新
        local one_recharge_two_set_positiony_terminal = {
            _name = "one_recharge_two_set_positiony",
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

		state_machine.add(one_recharge_two_set_positiony_terminal)
        state_machine.init()
    end
    
    -- call func init up_level state machine.
    init_one_recharge_two_terminal()
end

function OneRechargeTwo:onUpdateDraw()
    local root = self.roots[1]
    local Text_topup_reward1 = ccui.Helper:seekWidgetByName(root, "Text_topup_reward1")
    Text_topup_reward1:setString(_ED.activity_info["41"].activity_dec)
    local ListView_topup_reward = ccui.Helper:seekWidgetByName(root, "ListView_topup_reward") 
    ListView_topup_reward:removeAllItems()
    local activity_add_state = zstring.split(_ED.activity_info["41"].activity_add_state,",")
    local result1 = {}
    local result2 = {}
    local result3 = {}
    for k,v in pairs(_ED.activity_info["41"].activity_data[1]) do
        if tonumber(v.achieve_state) == 1 then
            table.insert(result1, v)
        elseif tonumber(v.achieve_state) == 0 then
            local achieve_complete_count = zstring.split(v.achieve_complete_count,"/")
            if tonumber(achieve_complete_count[1]) > tonumber(activity_add_state[v.achieve_index]) then
                table.insert(result1, v)
            else
                table.insert(result2, v)
            end
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
    
    for i, v in pairs(result1) do
        local cell = state_machine.excute("famous_general_create_cell",0,{v,"41",i,1})
        ListView_topup_reward:addChild(cell)
        self._height = cell:getContentSize().height + self._height
    end
    ListView_topup_reward:requestRefreshView()
    self._list_view = ListView_topup_reward
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function OneRechargeTwo:onUpdate(dt)
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

function OneRechargeTwo:onEnterTransitionFinish()

end

function OneRechargeTwo:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.one_recharge)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)
	self:onUpdateDraw()
end

function OneRechargeTwo:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function OneRechargeTwo:onExit()
    state_machine.remove("one_recharge_two_set_positiony")  
end
