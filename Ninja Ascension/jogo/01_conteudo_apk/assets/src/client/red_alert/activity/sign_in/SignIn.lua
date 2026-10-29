-----------------------------
--签到
-----------------------------
SignIn = class("SignInClass", Window)

local sign_in_window_open_terminal = {
    _name = "sign_in_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(57) == true then
            return
        end
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if nil == fwin:find("SignInClass") then
                    fwin:open(SignIn:new():init(), fwin._ui)
                end

                state_machine.excute("main_window_hide", 0, "")
                state_machine.excute("player_resource_window_hide", 0, "")     
                state_machine.excute("home_button_for_action_window_hide",0,"")
                state_machine.excute("chat_view_window_hide",0,"")  
                state_machine.excute("duplicate_title_window_hide",0,"")         
            end
        end

        if _ED.activity_info == nil or _ED.activity_info["15"] == nil then
            NetworkManager:register(protocol_command.activity_init.code, nil, nil, nil, nil, responseCallback, false, nil)  
        else
            responseCallback({RESPONSE_SUCCESS = true ,PROTOCOL_STATUS = 1})
        end
       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sign_in_window_close_terminal = {
    _name = "sign_in_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SignInClass"))

        state_machine.excute("main_window_open",0,"")
        state_machine.excute("player_resource_window_show",0,"")   
        state_machine.excute("home_button_for_action_window_show",0,"")  
        state_machine.excute("chat_view_window_show",0,"")
        state_machine.excute("duplicate_title_window_show",0,"")
      
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sign_in_window_open_terminal)
state_machine.add(sign_in_window_close_terminal)
state_machine.init()

function SignIn:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    app.load("client.red_alert.activity.sign_in.sign_in_cell_left")
    app.load("client.red_alert.activity.sign_in.sign_in_cell_right")
    app.load("client.red_alert.activity.sign_in.sign_in_receive")
    app.load("client.red_alert.activity.sign_in.sign_in_receive_two")

    -- Initialize sign_in state machine.
    local function init_sign_in_terminal()
	
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
    
    -- call func init sign_in state machine.
    init_sign_in_terminal()
end

function SignIn:onUpdateDrawState()
    local root = self.roots[1]
    local ScrollView_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_1")
    local Text_sigin_in_days = ccui.Helper:seekWidgetByName(root,"Text_sigin_in_days")
    Text_sigin_in_days:setString(self:getReadySignInDay())

    for i,cell in pairs(ScrollView_1:getChildren()) do
        if cell ~= nil and cell.updateDraw ~= nil then 
            cell:updateDraw()
        end
    end
end

function SignIn:onUpdateDraw()
    local root = self.roots[1]
    local Text_sigin_in_days = ccui.Helper:seekWidgetByName(root,"Text_sigin_in_days")
    Text_sigin_in_days:setString(self:getReadySignInDay())
    local Text_sigin_in_month = ccui.Helper:seekWidgetByName(root,"Text_sigin_in_month")
    Text_sigin_in_month:setString(tonumber(os.date("%m",zstring.exchangeFrom(os.time()))))
end

function SignIn:onUpdateDrawRight()
    local root = self.roots[1]

    local ScrollView_1 = ccui.Helper:seekWidgetByName(root,"ScrollView_1")
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

function SignIn:getReadySignInDay()
    local numbers = 0
    for i,v in pairs(_ED.activity_info["15"].activity_data[2]) do
        if tonumber(v.achieve_state) == 2 then
            numbers = numbers + 1
        end
    end 
    return numbers
end

function SignIn:onUpdateDrawLeft()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    for i,v in pairs(_ED.activity_info["15"].activity_data[1]) do
        local cell = state_machine.excute("sign_in_cell_left_create_cell",0,{v,i})
        ListView_1:addChild(cell)
    end  
end

function SignIn:onUpdate(dt) 
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



function SignIn:onEnterTransitionFinish()

end

function SignIn:onInit( )
    local csbItem = csb.createNode(config_csb.activity.sign_in.sign_in)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.activity.sign_in.sign_in)
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_open", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "window_open_over" then
        end
    end)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sigin_in_close"), nil, 
    {
        terminal_name = "sign_in_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()	
    self:onUpdateDrawLeft()
    self:onUpdateDrawRight()
end


function SignIn:init()
    -- debug.print_r(_ED.activity_info["15"])
    _ED._push_Sign_in = 0 
    self:getReadySignInDay()
	self:onInit()
    return self
end

function SignIn:close()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    ListView_1:removeAllItems()
    self.scroll_view:removeAllChildren(true)
end

function SignIn:onExit()
    state_machine.remove("sign_in_update_state")
end
