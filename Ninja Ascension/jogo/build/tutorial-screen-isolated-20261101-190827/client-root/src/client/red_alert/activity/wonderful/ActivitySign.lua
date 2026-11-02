-----------------------------
--签到(活动类型15)
-----------------------------
ActivitySign = class("ActivitySignClass", Window)

local activity_sign_window_open_terminal = {
    _name = "activity_sign_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("ActivitySignClass") then
            local panel = ActivitySign:new():init(params)
            fwin:open(panel)
            return panel
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_sign_window_open_terminal)
state_machine.init()

function ActivitySign:ctor()
    self.super:ctor()
    self.roots = {}

    self._height = 0
    -- load lua file

    app.load("client.red_alert.activity.sign_in.sign_in_cell_left")
    app.load("client.red_alert.activity.sign_in.sign_in_cell_right")
    app.load("client.red_alert.activity.sign_in.sign_in_receive")
    app.load("client.red_alert.activity.sign_in.sign_in_receive_two")
    -- Initialize activity_sign state machine.
    local function init_activity_sign_terminal()
	
		--刷新
        local sign_in_update_state_terminal = {
            _name = "sign_in_update_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawState()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sign_in_update_state_terminal)    
        state_machine.init()
    end
    
    -- call func init up_level state machine.
    init_activity_sign_terminal()
end

function ActivitySign:onUpdateDraw()
    local root = self.roots[1]
    local BitmapFontLabel_sign = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_sign")
    BitmapFontLabel_sign:setString(tonumber(os.date("%m",zstring.exchangeFrom(os.time()))))
end

function ActivitySign:onUpdate(dt)
    if self.scroll_view ~= nil then
        local size = self.scroll_view:getContentSize()
        local posY = self.scroll_view:getInnerContainer():getPositionY()
        if self.scroll_view_poy == posY then
            return
        end
        self.scroll_view_poy = posY
        local items = self.scroll_view:getChildren()
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

function ActivitySign:onUpdateDrawState()
    local root = self.roots[1]
    local ScrollView_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_topup_reward")

    for i,cell in pairs(ScrollView_1:getChildren()) do
        if cell ~= nil and cell.updateDraw ~= nil then 
            cell:updateDraw()
        end
    end
end

function ActivitySign:onUpdateDrawRight()
    local root = self.roots[1]

    local ScrollView_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_topup_reward")
    ScrollView_1:removeAllChildren(true)

    local csbItem = csb.createNode(config_csb.activity.sign_in.sign_in_cell_right)
    local root_temp = csbItem:getChildByName("root")
    local height_temp = root_temp:getContentSize().height
    local width = ScrollView_1:getContentSize().width
    local height = ScrollView_1:getContentSize().height
    local scroll_height = 0
    local numbers = #_ED.activity_info["15"].activity_data[2]
    if numbers % 7 == 0 then
        scroll_height = numbers / 7
    else
        scroll_height = math.floor(numbers / 7) + 1
    end

    if scroll_height*height_temp > height then
        height = scroll_height*height_temp
    end

    local index = 1
    for i,v in pairs(_ED.activity_info["15"].activity_data[2]) do
        local wight_n = 1
        local height_n = 1
        if i % 7 == 0 then
            wight_n = 7
        else
            wight_n = i % 7
        end

        if i % 7 == 0 then
            height_n = i / 7
        else
            height_n = math.floor(i / 7) + 1
        end

        local cell = state_machine.excute("sign_in_cell_right_create_cell",0,{v,height_n,index})
        cell:setAnchorPoint(cc.p(0,1))
        cell:setPosition(cc.p((wight_n-1)*(width/7),height - (height_n-1)*height_temp))
        ScrollView_1:addChild(cell)
        index = index + 1
    end

    ScrollView_1:getInnerContainer():setContentSize(cc.size(width,height))
    ScrollView_1:jumpToTop()

    self.scroll_view = ScrollView_1
    self.scroll_view_poy = ScrollView_1:getInnerContainer():getPositionY()   
end

function ActivitySign:onEnterTransitionFinish()

end

function ActivitySign:onInit( )
    local csbItem = csb.createNode(config_csb.activity.wonderful.wonderful_sign)
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    self:onUpdateDraw() 
    self:onUpdateDrawRight()
end

function ActivitySign:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function ActivitySign:onExit()
    state_machine.remove("sign_in_update_state")
end
