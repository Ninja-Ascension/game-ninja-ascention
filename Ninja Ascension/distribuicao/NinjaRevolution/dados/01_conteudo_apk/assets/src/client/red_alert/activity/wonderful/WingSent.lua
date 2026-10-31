-----------------------------
--元宝大放送(活动类型5)
-----------------------------
WingSent = class("WingSentClass", Window)

local wing_sent_window_open_terminal = {
    _name = "wing_sent_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("WingSentClass") then
            local panel = WingSent:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(wing_sent_window_open_terminal)
state_machine.init()

function WingSent:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    self._height = 0
    -- Initialize wing_sent state machine.
    local function init_wing_sent_terminal()
	
		--刷新
		local wing_sent_set_positiony_terminal = {
            _name = "wing_sent_set_positiony",
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

		state_machine.add(wing_sent_set_positiony_terminal)	
        state_machine.init()
    end
    
    -- call func init wing_sent state machine.
    init_wing_sent_terminal()
end

function WingSent:onUpdateDraw()
    local root = self.roots[1]
    
    local Text_wing_sent_time = ccui.Helper:seekWidgetByName(root, "Text_wing_sent_time")
    Text_wing_sent_time:setString(_ED.activity_info["5"].activity_dec)
    local ListView_wing_sent = ccui.Helper:seekWidgetByName(root, "ListView_wing_sent") 
    ListView_wing_sent:removeAllItems()
    local now_day = tonumber(_ED.activity_info["5"].activity_add_state) + 1

    local result1 = {}
    local result2 = {}
    local result3 = {}
    for k,v in pairs(_ED.activity_info["5"].activity_data[now_day]) do
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
    
    for i, v in pairs(result1) do
        local cell = state_machine.excute("famous_general_create_cell",0,{v,"5",i,now_day})
        ListView_wing_sent:addChild(cell)
        self._height = cell:getContentSize().height + self._height
    end
    ListView_wing_sent:requestRefreshView()
    self._list_view = ListView_wing_sent
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function WingSent:onUpdate(dt)
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

function WingSent:onEnterTransitionFinish()

end

function WingSent:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.wing_sent)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    -- --关闭
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_wonderful_close"), nil, 
    -- {
    --     terminal_name = "wonderful_window_close", 
    --     terminal_state = 0, 
    --     touch_scale = true,
    --     touch_scale_xy = 0.95, 
    -- }, nil, 0)

	self:onUpdateDraw()
    -- debug.print_r(_ED.activity_info["5"])
end

function WingSent:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function WingSent:onExit()
    state_machine.remove("wing_sent_set_positiony")
end
