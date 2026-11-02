-----------------------------
--杂货店(活动类型17)
-----------------------------
ChangeProps = class("ChangePropsClass", Window)

local change_props_window_open_terminal = {
    _name = "change_props_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("ChangePropsClass") then
            local panel = ChangeProps:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(change_props_window_open_terminal)
state_machine.init()

function ChangeProps:ctor()
    self.super:ctor()
    self.roots = {}

    self._list_view = nil
    self._list_view_poy = 0

    self._height = 0
    local function init_change_props_terminal()
		local change_props_set_positiony_terminal = {
            _name = "change_props_set_positiony",
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

		state_machine.add(change_props_set_positiony_terminal)	
        state_machine.init()
    end
    
    init_change_props_terminal()
end

function ChangeProps:onUpdateDraw()
    local root = self.roots[1]
    
    local Text_active_reward1 = ccui.Helper:seekWidgetByName(root, "Text_active_reward1")
    Text_active_reward1:setString(_ED.activity_info["17"].activity_dec)
    local ListView_active_reward = ccui.Helper:seekWidgetByName(root, "ListView_active_reward") 
    ListView_active_reward:removeAllItems()
    local result1 = {}
    local result2 = {}
    local result3 = {}
    for k,v in pairs(_ED.activity_info["17"].activity_data[1]) do
        local achieve_complete_count = zstring.split(v.achieve_complete_count,"/")
        if tonumber(achieve_complete_count[1]) > 0 then
            table.insert(result1, v)
        else
            table.insert(result2, v)
        end
    end
    for k,v in pairs(result2) do
        table.insert(result1, v)
    end
    
    for i, v in pairs(result1) do
        local cell = state_machine.excute("change_props_create_cell",0,{v,"17",i})
        ListView_active_reward:addChild(cell)
        self._height = cell:getContentSize().height + self._height
    end
    ListView_active_reward:requestRefreshView()
    self._list_view = ListView_active_reward
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function ChangeProps:onUpdate(dt)
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

function ChangeProps:onEnterTransitionFinish()

end

function ChangeProps:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.change_props)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

	self:onUpdateDraw()
end

function ChangeProps:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function ChangeProps:onExit()
    state_machine.remove("change_props_set_positiony")
end
