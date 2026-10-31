-- ----------------------------------------------------------------------------------------------------
-- 说明：节日红包主界面
-------------------------------------------------------------------------------------------------------
RedPacketWindow = class("RedPacketWindowClass", Window)

local red_packet_window_open_terminal = {
    _name = "red_packet_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("RedPacketWindowClass") == nil then           
            fwin:open(RedPacketWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_packet_window_close_terminal = {
    _name = "red_packet_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("RedPacketWindowClass") then
            fwin:close(fwin:find("RedPacketWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_packet_window_open_terminal)
state_machine.add(red_packet_window_close_terminal)
state_machine.init()

function RedPacketWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.starting_point = 1
    self.end_point = 10
    self.ranktype = 1   --1为发红包排行榜 
    app.load("client.cells.activity.red_packet_send_list_cell")
    app.load("client.cells.activity.red_packet_small_list_cell")
    app.load("client.activity.redpacket.RedPacketSpecial")
    app.load("client.activity.redpacket.RedPacketRule")
    app.load("client.reward.DrawRareReward")
    local function init_RedPacketWindow_terminal()
        --
        local red_packet_enter_terminal = {
            _name = "red_packet_first_enter",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        instance:onUpdateRgDraw()
                        instance:onUpdateRaDraw(instance.ranktype)
                    end
                end
                protocol_command.activity_red_packet_init.param_list = instance.starting_point.."\r\n"..instance.end_point
                NetworkManager:register(protocol_command.activity_red_packet_init.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         

          --刷新
       local red_packet_update_rank_terminal = {
            _name = "red_packet_update_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            instance.starting_point = instance.starting_point+10
                            instance.end_point = instance.end_point+10
                            instance:addnewlistCell()
                        end
                    end
                end
               
                if _ED.red_packet_ranking_size >= 10 then
                    protocol_command.activity_red_packet_init.param_list = (instance.starting_point+10).."\r\n"..(instance.end_point+10)
                    NetworkManager:register(protocol_command.activity_red_packet_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
      

        --发红包
        local send_red_packet_terminal = {
            _name = "send_red_packet",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                      _ED.red_packet_enter_info = {}
                      instance.starting_point = 1
                      instance.end_point = 10
                      state_machine.excute("red_packet_first_enter", 0, nil) 
                      instance:upDataDraw()
                    end
                end
                protocol_command.activity_send_red_packet.param_list = params._datas.m_type
                NetworkManager:register(protocol_command.activity_send_red_packet.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --更新状态
         local update_red_packet_state_terminal = {
            _name = "update_red_packet_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED.red_packet_enter_info = {}
                instance.starting_point = 1
                instance.end_point = 10
                local Panel_red_open_effect = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_red_open_effect")
                Panel_red_open_effect:setVisible(true)
                local function changeActionCallback( armatureBack ) 
                    local getRewardWnd = DrawRareReward:new()
                    getRewardWnd:init(7)
                    fwin:open(getRewardWnd, fwin._ui)
                    armatureBack:removeFromParent(true)
                    Panel_red_open_effect:setVisible(false)
                    state_machine.excute("red_packet_first_enter", 0, nil) 
                    instance:onUpdateRgDraw()
                end
                local jsonFile = "sprite/sprite_kaihongbao.json"
                local atlasFile = "sprite/sprite_kaihongbao.atlas"
                local names = "open_red_packet_2"

                local animation = sp.spine(jsonFile, atlasFile, 1, 0, names, true, nil)
                animation.animationNameList = {names}
                sp.initArmature(animation, false)
                animation._invoke = changeActionCallback
                animation:setPosition(cc.p(Panel_red_open_effect:getContentSize().width/2-220,instance.roots[1]:getContentSize().height/2))
                instance.roots[1]:addChild(animation)
                animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                csb.animationChangeToAction(animation, 0, 0, false)
                instance:upDataDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --切换小排行榜
         local change_red_packet_ranking_terminal = {
            _name = "change_red_packet_ranking",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
              instance:onUpdateRaDraw(params._datas.m_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        
        state_machine.add(red_packet_enter_terminal)
        state_machine.add(send_red_packet_terminal)
        state_machine.add(update_red_packet_state_terminal)
        state_machine.add(red_packet_update_rank_terminal)
        state_machine.add(change_red_packet_ranking_terminal)
        state_machine.init()
    end

    init_RedPacketWindow_terminal()
end

function RedPacketWindow:init()

    return self
end

function RedPacketWindow:onMeRanking()
    
end

function RedPacketWindow:onUpdate(dt)
    if not _ED.red_packet_enter_info then
        return
    end
    local ListView_red_packet_list = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_red_packet_list")
    if ListView_red_packet_list ~= nil then
        local size = ListView_red_packet_list:getContentSize()
        local posY = ListView_red_packet_list:getInnerContainer():getPositionY()
        if ListView_red_packet_list_posy == posY then
            return
        end
        ListView_red_packet_list_posy = posY
        local items =ListView_red_packet_list:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height/2 < 0 or tempY > size.height + itemSize.height /2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end


function RedPacketWindow:onUpdateRgDraw()    --更新排行榜
    local ListView_red_packet_list = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_red_packet_list")
    ListView_red_packet_list:removeAllItems()
    if type(_ED.red_packet_enter_info[1]) ==  type(1) then
        return
    end
    local info = _ED.red_packet_enter_info
    for i, v in ipairs(info) do 
        local cell = state_machine.excute("red_packet_send_list_cell_create",0,{v})
        ListView_red_packet_list:addChild(cell)
    end
    ListView_red_packet_list:requestRefreshView()
end

function RedPacketWindow:onUpdateRaDraw(rankingtype)     --更新2个小排行榜
    if not _ED.red_packet_rank_info then
        return
    end
    local ListView_red_packet_rank = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_red_packet_rank")
    ListView_red_packet_rank:removeAllItems()
    local Button_red_packet_rank_send = ccui.Helper:seekWidgetByName(self.roots[1], "Button_red_packet_rank_send")
    local Button_red_packet_rank_rec = ccui.Helper:seekWidgetByName(self.roots[1], "Button_red_packet_rank_rec")
    
    local Image_title_name_bar = ccui.Helper:seekWidgetByName(self.roots[1], "Image_title_name_bar")
    local Image_title_name_bar_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Image_title_name_bar_1") --抢红包排行
    local info = {}
    if rankingtype == 1 then
        info = _ED.red_packet_rank_info.sendrank
        Button_red_packet_rank_send:setHighlighted(true)
        Button_red_packet_rank_rec:setHighlighted(false)
        Image_title_name_bar:setVisible(true)
        Image_title_name_bar_1:setVisible(false)
    else
        info = _ED.red_packet_rank_info.getrank
        Button_red_packet_rank_send:setHighlighted(false)
        Button_red_packet_rank_rec:setHighlighted(true)
        Image_title_name_bar:setVisible(false)
        Image_title_name_bar_1:setVisible(true)
    end
    for i, v in ipairs(info) do 
        local cell = state_machine.excute("red_packet_small_list_cell_create",0,{v,i,rankingtype})
        ListView_red_packet_rank:addChild(cell)
    end
end



function RedPacketWindow:upDataDraw()
    local parms = json.decode(_ED.active_activity[155].activity_params)
    local Text_red_packet_time_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_red_packet_time_0")
    Text_red_packet_time_0:setString(parms.specailSendCount)
    local Text_red_packet_time = ccui.Helper:seekWidgetByName(self.roots[1], "Text_red_packet_time")
    Text_red_packet_time:setString(parms.freeDrawCount.."/"..(zstring.split(_ED.active_activity[155].need_recharge_count,":")[3]))

    local Button_red_packet_free_send = ccui.Helper:seekWidgetByName(self.roots[1], "Button_red_packet_free_send")
    local Button_red_packet_send = ccui.Helper:seekWidgetByName(self.roots[1], "Button_red_packet_send")
    if parms.freeSendCount == 0 then
       Button_red_packet_free_send:setVisible(false)
       Button_red_packet_send:setVisible(true)
    else
       Button_red_packet_free_send:setVisible(true)
       Button_red_packet_send:setVisible(false)
    end
end

function RedPacketWindow:addnewlistCell()  --给排行榜添加
    local ListView_red_packet_list = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_red_packet_list")
    for i= self.starting_point,self.end_point do   
        if _ED.red_packet_enter_info[i] ~= nil then
            local temp = {}
            temp =_ED.red_packet_enter_info[i]
            local cell = state_machine.excute("red_packet_send_list_cell_create",0,{temp})
            ListView_red_packet_list:addChild(cell)
        else
           -- self.isRgOver = true
        end
    end
    ListView_red_packet_list:requestRefreshView()
end

function RedPacketWindow:onEnterTransitionFinish()
  
    local csbNode = csb.createNode("activity/wonderful/red_packet.csb")
    local root = csbNode:getChildByName("root")                         
    table.insert(self.roots, root)
    self:addChild(csbNode)
    state_machine.excute("red_packet_first_enter", 0,nil) 
     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_red_packet_close"), nil, 
    {
        terminal_name = "red_packet_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_red_packet_free_send"), nil,   --免费发红包
    {
        terminal_name = "send_red_packet", 
        isPressedActionEnabled = true,
        m_type = 1
    },
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_red_packet_send"), nil,      --特殊红包
    {
        terminal_name = "red_packet_special_open", 
        isPressedActionEnabled = true
    },
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_red_packet_rule"), nil,      --规则
    {
        terminal_name = "red_packet_rule_window_open", 
        isPressedActionEnabled = true
    },
    nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_red_packet_rank_send"), nil,      --发红包排行榜
    {
        terminal_name = "change_red_packet_ranking", 
        isPressedActionEnabled = true,
        m_type = 1,
    },
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_red_packet_rank_rec"), nil,      --抢红包排行榜
    {
        terminal_name = "change_red_packet_ranking", 
        isPressedActionEnabled = true,
        m_type = 2,
    },
    nil, 0)

    local ListView_red_packet_list = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_red_packet_list")
    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.bounceBottom then--6
            --滑到头
           state_machine.excute("red_packet_update_rank", 0,nil)
        end
    end
    ListView_red_packet_list:addScrollViewEventListener(scrollViewEvent)
    self:registerOnNoteUpdate(self, 1)
    self:upDataDraw()
end

function RedPacketWindow:onExit()
   _ED.red_packet_enter_info = {}
end 
