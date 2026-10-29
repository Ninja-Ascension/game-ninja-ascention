-----------------------------
--侠客行奖励(活动类型26)
-----------------------------
WonderfulTrialtower = class("WonderfulTrialtowerClass", Window)

local wonderful_trialtower_window_open_terminal = {
    _name = "wonderful_trialtower_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("WonderfulTrialtowerClass") then
            local panel = WonderfulTrialtower:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(wonderful_trialtower_window_open_terminal)
state_machine.init()

function WonderfulTrialtower:ctor()
    self.super:ctor()
    self.roots = {}

    self._height = 0
    --load lua file

    -- Initialize wonderful_trialtower state machine.
    local function init_wonderful_trialtower_terminal()
	
		--刷新
		local wonderful_trialtower_set_positiony_terminal = {
            _name = "wonderful_trialtower_set_positiony",
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

		state_machine.add(wonderful_trialtower_set_positiony_terminal)	
        state_machine.init()
    end
    
    -- call func init wonderful_trialtower state machine.
    init_wonderful_trialtower_terminal()
end

function WonderfulTrialtower:onUpdateDraw()
    local root = self.roots[1]
    local Text_topup_reward1 = ccui.Helper:seekWidgetByName(root, "Text_topup_reward1")
    Text_topup_reward1:setString(_ED.activity_info["26"].activity_dec)
    local ListView_confirm = ccui.Helper:seekWidgetByName(root, "ListView_confirm") 
    ListView_confirm:removeAllItems()

    local result1 = {}
    local result2 = {}
    local result3 = {}
    for k,v in pairs(_ED.activity_info["26"].activity_data[1]) do
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
        local cell = state_machine.excute("famous_general_create_cell",0,{v,"26",i,1})
        ListView_confirm:addChild(cell)
        self._height = cell:getContentSize().height + self._height
    end
    ListView_confirm:requestRefreshView()
    self._list_view = ListView_confirm
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function WonderfulTrialtower:onUpdate(dt)
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

function WonderfulTrialtower:onEnterTransitionFinish()

end

function WonderfulTrialtower:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.wonderful_trialtower)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

	self:onUpdateDraw()
end

function WonderfulTrialtower:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function WonderfulTrialtower:onExit()
    state_machine.remove("wonderful_trialtower_set_positiony")
end
