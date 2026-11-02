
CaptureResourceRank = class("CaptureResourceRankClass", Window)

local capture_resource_rank_open_terminal = {
    _name = "capture_resource_rank_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.lock("capture_resource_rank_open")
        state_machine.excute("capture_resource_reward_close",0,"")
        local page = params._datas.page
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                 local function responseCallbackLast(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local function responseCallbackScore(response)
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                state_machine.unlock("capture_resource_rank_open")
                                local win = CaptureResourceRank:new()
                                win:init(page)
                                fwin:open(win,fwin._ui)                 
                            else
                                state_machine.unlock("capture_resource_rank_open")
                            end
                        end
                        NetworkManager:register(protocol_command.hold_integral_init.code, nil, nil, nil, nil, responseCallbackScore, false, nil)
                    else
                        state_machine.unlock("capture_resource_rank_open")
                    end
                end

                protocol_command.search_order_list.param_list = "".."14"
                NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responseCallbackLast, false, nil)
            else
                state_machine.unlock("capture_resource_rank_open")
            end
        end
        protocol_command.search_order_list.param_list = "".."13"
        NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local capture_resource_rank_close_terminal = {
    _name = "capture_resource_rank_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local win = fwin:find("CaptureResourceRankClass")
        if win ~= nil then
            fwin:close(win)
        end 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(capture_resource_rank_open_terminal)
state_machine.add(capture_resource_rank_close_terminal)
state_machine.init()

function CaptureResourceRank:ctor()
    self.super:ctor()
    self.roots = {}
    self.list_view = nil
    self.list_view_posY = nil

    self.page = 1
    local function init_capture_resource_rank_terminal()
        local capture_resource_change_page_terminal = {
            _name = "capture_resource_change_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local page = params._datas._page
                instance.page = page
                instance:updateDrawBtn()
                instance:changePage()
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local capture_resource_get_reward_terminal = {
            _name = "capture_resource_get_reward",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("capture_resource_get_reward")
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.unlock("capture_resource_get_reward")
                        -- print("==========领取奖励")
                        app.load("client.reward.DrawRareReward")
                        _ED.capture.rank_reward_state = "1"
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(55)
                        fwin:open(getRewardWnd, fwin._ui)                        

                        response.node:updateDrawBtn()
                    else
                        state_machine.unlock("capture_resource_get_reward")
                    end
                end
                NetworkManager:register(protocol_command.draw_hold_integral_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(capture_resource_change_page_terminal)
        state_machine.add(capture_resource_get_reward_terminal)
        state_machine.init()
    end
    init_capture_resource_rank_terminal()
end
function CaptureResourceRank:updateDrawBtn()
    local root = self.roots[1]
    local Button_lingqu = ccui.Helper:seekWidgetByName(root, "Button_lingqu")
    local Image_yilingqu = ccui.Helper:seekWidgetByName(root, "Image_yilingqu")
    if self.page == 1 then
        Button_lingqu:setVisible(false)
        Image_yilingqu:setVisible(false)        
    elseif tonumber(_ED.capture.rank_reward_state) == 1 then
        Button_lingqu:setVisible(false)
        Image_yilingqu:setVisible(true)
    elseif zstring.tonumber(_ED.capture.last_my_score) == 0 then
        Image_yilingqu:setVisible(false)
        Button_lingqu:setVisible(false)
    elseif tonumber(_ED.capture.rank_reward_state) == 0 then
        Image_yilingqu:setVisible(false)
        Button_lingqu:setVisible(true) 
    end
end
function CaptureResourceRank:changePage()
    local root = self.roots[1]
    local btn_left = ccui.Helper:seekWidgetByName(root, "Button_benci")
    local btn_right = ccui.Helper:seekWidgetByName(root, "Button_xiaci")
    local Button_chakanjiangli = ccui.Helper:seekWidgetByName(root, "Button_chakanjiangli")
    local Panel_410 = ccui.Helper:seekWidgetByName(root, "Panel_410")
    local Panel_410_0 = ccui.Helper:seekWidgetByName(root, "Panel_410_0")
    btn_left:setHighlighted(false)
    btn_right:setHighlighted(false)
    btn_left:setTouchEnabled(true)
    btn_right:setTouchEnabled(true)

    if self.page == 1 then
        btn_left:setTouchEnabled(false)
        btn_left:setHighlighted(true)
        Button_chakanjiangli:setVisible(false)
        Panel_410:setVisible(true)
        Panel_410_0:setVisible(false)
    elseif self.page == 2 then
        btn_right:setTouchEnabled(false)
        btn_right:setHighlighted(true)
        Button_chakanjiangli:setVisible(true)
        Panel_410:setVisible(false)
        Panel_410_0:setVisible(true)
    end

end

function CaptureResourceRank:onUpdate( dt )
    if self.list_view ~= nil then
        local size = self.list_view:getContentSize()
        local posY = self.list_view:getInnerContainer():getPositionY()
        if self.list_view_posY == posY then
            return
        end
        self.list_view_posY = posY
        local items = self.list_view:getItems()
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

function CaptureResourceRank:updateDraw()
    local root = self.roots[1]
    app.load("client.cells.CaptureResource.capture_resource_rank_list_cell")
    local Text_2 = ccui.Helper:seekWidgetByName(root,"Text_2") --当前排名   
    local Text_jifen = ccui.Helper:seekWidgetByName(root,"Text_jifen") --当前积分 
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    local ListView_2 = ccui.Helper:seekWidgetByName(root,"ListView_2")
    -- print("============page",self.page)
    if self.page == 1 then   
        ListView_2:setVisible(false)
        ListView_1:setVisible(true)  
        -- print("========1=======",_ED.capture.my_rank,_ED.capture.my_score)
        if zstring.tonumber(_ED.capture.my_rank) == 0 then
            Text_2:setString(_string_piece_info[34]) 
        else
            Text_2:setString(_ED.capture.my_rank) 
        end
        Text_jifen:setString(_ED.capture.my_score)      
        if #ListView_1:getItems() > 0 then
            
        else
            ListView_1:removeAllItems()

            if _ED.charts.capture == "" or _ED.charts.capture == nil then
                return
            end            
            for i,v in pairs(_ED.charts.capture) do
                local cell = CaptureResourceRankListCell:createCell()
                cell:init(v,i)
                ListView_1:addChild(cell)
            end
            ListView_1:requestRefreshView()
        end

        self.list_view = ListView_1
        self.list_view_posY = self.list_view:getInnerContainer():getPositionY()
    elseif self.page == 2 then  
        ListView_1:setVisible(false)
        ListView_2:setVisible(true)
        if zstring.tonumber(_ED.capture.last_my_rank) == 0 then
            Text_2:setString(_string_piece_info[34]) 
        else
            Text_2:setString(_ED.capture.last_my_rank) 
        end
       
        Text_jifen:setString(_ED.capture.last_my_score)
        -- print("========2=======",_ED.capture.last_my_rank,_ED.capture.last_my_score)        
        if #ListView_2:getItems() > 0 then
            
        else
            ListView_2:removeAllItems()
            if _ED.charts.last_capture == "" or _ED.charts.last_capture == nil then
                return
            end
            for i,v in pairs(_ED.charts.last_capture) do
                local cell = CaptureResourceRankListCell:createCell()
                cell:init(v,i)
                ListView_2:addChild(cell)
            end
            ListView_2:requestRefreshView()
        end  
        self.list_view = ListView_2
        self.list_view_posY = self.list_view:getInnerContainer():getPositionY()        
    end
end

function CaptureResourceRank:onEnterTransitionFinish()

end
function CaptureResourceRank:onInit( )
    local csbSocietyInfo = csb.createNode("secret_society/secret_ranking.csb")
    local root = csbSocietyInfo:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSocietyInfo)

    local Button_lingqu = ccui.Helper:seekWidgetByName(root, "Button_lingqu")
    fwin:addTouchEventListener(Button_lingqu,nil, 
    {
        terminal_name = "capture_resource_get_reward", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        btn_cell = Button_lingqu
    }
    ,nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
    {
        terminal_name = "capture_resource_rank_close", 
        isPressedActionEnabled = true
    },
    nil, 1)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_benci"), nil, 
    {
        terminal_name = "capture_resource_change_page", 
        isPressedActionEnabled = false,
        _page = 1 ,
    },
    nil, 1) 

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xiaci"), nil, 
    {
        terminal_name = "capture_resource_change_page", 
        isPressedActionEnabled = false,
        _page = 2 ,
    },
    nil, 1) 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chakanjiangli"), nil, 
    {
        terminal_name = "capture_resource_reward_open", 
        isPressedActionEnabled = true,
    },
    nil, 1) 

    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_capture_get_reward",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_xiaci"),
    _invoke = nil,
    _interval = 0.5,})
    
    self:updateDrawBtn()
    self:changePage()
    self:updateDraw()
end
function CaptureResourceRank:init(page)
    self.page = page or 1
    self:onInit()
end

function CaptureResourceRank:onExit()
    state_machine.remove("capture_resource_get_reward")
    state_machine.remove("capture_resource_change_page")
end
