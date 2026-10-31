-----------------------------
--冲级奖励(特殊渠道)(活动类型39)
-----------------------------
UpLevelTwo = class("UpLevelTwoClass", Window)

local up_level_two_window_open_terminal = {
    _name = "up_level_two_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("UpLevelTwoClass") then
            local panel = UpLevelTwo:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(up_level_two_window_open_terminal)
state_machine.init()

function UpLevelTwo:ctor()
    self.super:ctor()
    self.roots = {}

    self._height = 0

    local function init_up_level_two_terminal()
		local up_level_two_set_positiony_terminal = {
            _name = "up_level_two_set_positiony",
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

		state_machine.add(up_level_two_set_positiony_terminal)	
        state_machine.init()
    end
    init_up_level_two_terminal()
end

function UpLevelTwo:onUpdateDraw()
    local root = self.roots[1]
    local Text_topup_reward1 = ccui.Helper:seekWidgetByName(root, "Text_topup_reward1")
    Text_topup_reward1:setString(_ED.activity_info["39"].activity_dec)
    local ListView_topup_reward = ccui.Helper:seekWidgetByName(root, "ListView_topup_reward") 
    ListView_topup_reward:removeAllItems()

    local Panel_banner = ccui.Helper:seekWidgetByName(root, "Panel_banner")
    Panel_banner:removeBackGroundImage()
    local name = zstring.split(_ED.activity_info["39"].activity_add_state, ",")[2]
    local image_name = "images/ui/wonderful/banner_acti_road_"..name..".png"
    if cc.FileUtils:getInstance():isFileExist(image_name) == false then
        image_name = "images/ui/wonderful/banner_acti_road_"..wonderful_operator_activity_str[1][1]..".png"
    end
    Panel_banner:setBackGroundImage(image_name)

    local result1 = {}
    local result2 = {}
    local result3 = {}
    local page = tonumber(zstring.split(_ED.activity_info["39"].activity_add_state, ",")[1]) + 1
    for k,v in pairs(_ED.activity_info["39"].activity_data[page]) do
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
        local cell = state_machine.excute("famous_general_create_cell",0,{v,"39",i,page})
        ListView_topup_reward:addChild(cell)
        self._height = cell:getContentSize().height + self._height
    end
    ListView_topup_reward:requestRefreshView()
    self._list_view = ListView_topup_reward
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
end

function UpLevelTwo:onUpdate(dt)
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

function UpLevelTwo:onEnterTransitionFinish()

end

function UpLevelTwo:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.up_level)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

	self:onUpdateDraw()
end

function UpLevelTwo:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function UpLevelTwo:onExit()
    state_machine.remove("up_level_two_set_positiony")
end
