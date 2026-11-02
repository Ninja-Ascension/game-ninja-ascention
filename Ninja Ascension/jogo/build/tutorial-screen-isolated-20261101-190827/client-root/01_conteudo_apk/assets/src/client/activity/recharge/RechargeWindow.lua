-- ----------------------------------------------------------------------------------------------------
-- 说明：跨服排行活动
-------------------------------------------------------------------------------------------------------
RechargeWindow = class("RechargeWindowClass", Window)

local recharge_window_open_terminal = {
    _name = "recharge_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("RechargeWindowClass") == nil then           
            fwin:open(RechargeWindow:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local recharge_window_close_terminal = {
    _name = "recharge_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("RechargeWindowClass") then
            fwin:close(fwin:find("RechargeWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(recharge_window_open_terminal)
state_machine.add(recharge_window_close_terminal)
state_machine.init()

function RechargeWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self._current_page = 1
    self._combat_power = nil
    self.lightList = {}

    self.isPlayOne = true
    self.isPlayTen = true
    self.allScore = 0

    self._curTime = 0

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.activity.recharge.Recharge_ranking_information_cell")
    app.load("client.activity.recharge.Recharge_ranking_cell")

    local function treasure_window_terminal()
      --切换排行榜
        local sm_ranking_main_interface_open_rank_terminal = {
            _name = "sm_ranking_main_interface_open_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local page = tonumber(params._datas._page)
                local m_type = params._datas.m_type
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            instance:changeSelectPage(page)
                        end
                    end
                end
                _ED.recharge_ranking = {}
                 protocol_command.activity_time_limit_rank_order.param_list = (instance.starting_point).."\r\n"..(instance.end_point)
                 NetworkManager:register(protocol_command.activity_time_limit_rank_order.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
       --刷新
       local sm_ranking_main_interface_update_rank_terminal = {
            _name = "sm_ranking_main_interface_update_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local page = tonumber(params._datas._page)
                local m_type = params._datas.m_type
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            instance.starting_point = instance.starting_point+10
                            instance.end_point = instance.end_point+10
                            instance:addnewlistCell()
                        end
                    end
                end
                if tonumber(_ED.recharge_ranking_size) >= 10 then
                    protocol_command.activity_time_limit_rank_order.param_list = (instance.starting_point+10).."\r\n"..(instance.end_point+10)
                    NetworkManager:register(protocol_command.activity_time_limit_rank_order.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
      


        --排行榜奖励
        local recharge_first_enter_terminal = {
            _name = "recharge_first_enter",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            --   print("f发送消息")
              --  local _type = params._datas._type
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node.surplus_time = (_ED.recharge_ranking_reward.timeData.topUpTime - _ED.recharge_ranking_reward.csTime)
                            response.node:changeSelectPage(1)
                            response.node:onUpdateRaDraw()
                        end
                    --   print("发送成功")
                    end
                end
                _ED.recharge_ranking = {}
                instance.starting_point = 1 
                instance.end_point =10
                NetworkManager:register(protocol_command.activity_time_limit_rank_init.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        --规则
        local recharge_rule_open_terminal = {
            _name = "recharge_rule_open",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                app.load("client.activity.recharge.RechargeRuleWindow")
                local RechargeRuleWindow = RechargeRuleWindow:new()
                RechargeRuleWindow:init()
                fwin:open(RechargeRuleWindow, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(sm_ranking_main_interface_open_rank_terminal)
        state_machine.add(recharge_first_enter_terminal)
        state_machine.add(recharge_rule_open_terminal)
        state_machine.add( sm_ranking_main_interface_update_rank_terminal)
       
      
        state_machine.init()
    end

    treasure_window_terminal()
end

function RechargeWindow:init()
    self.pages = 1
   -- self:setTouchEnabled(true)
   -- self:onInit()
    return self
end

function RechargeWindow:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.ceil((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .._string_piece_info[231]
    end
    if _hourTime > 0 then
        if _hourTime < 10 then
            timeString = timeString .. "0".._hourTime ..":"
        else
            timeString = timeString .. _hourTime ..":"
        end
    end
    if _minutesTime > 0 then
        if _minutesTime < 10 then
            timeString = timeString .. "0".._minutesTime ..":"
        else
            timeString = timeString .. _minutesTime ..":"
        end
    end
    if _secondsTime > 0 then
        if _secondsTime < 10 then
            timeString = timeString .. "0".._secondsTime 
        else
            timeString = timeString .. _secondsTime 
        end
    end
    return timeString
end

function RechargeWindow:onUpdate(dt)
    if self.Text_time_2 and self._curTime > 0 then
        self._curTime = self._curTime + dt
        self.Text_time_2:setString(os.date("%H"..":".."%M"..":%S", getBaseGTM8Time(self._curTime)))
    end


    if self.Text_rare_time == nil or not _ED.recharge_ranking_reward or not self.surplus_time then
        return
    end
    self.surplus_time = self.surplus_time - dt*1000
    self.Text_rare_time:setString(self.surplus_time < 0 and _string_piece_info[305] or self:drawTime(self.surplus_time))
    if self._current_page == 1 then
        if self.Rank_reward_listview ~= nil then
            local size = self.Rank_reward_listview:getContentSize()
            local posY = self.Rank_reward_listview:getInnerContainer():getPositionY()
            if self.Ra_list_view_posy == posY then
                return
            end
            self.Ra_list_view_posy = posY
            local items = self.Rank_reward_listview:getItems()
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
    else
        if self.Ranking_listview ~= nil then
            local size = self.Ranking_listview:getContentSize()
            local posY = self.Ranking_listview:getInnerContainer():getPositionY()
            if self.Ra_list_view_posy == posY then
                return
            end
            self.Ra_list_view_posy = posY
            local items = self.Ranking_listview:getItems()
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
end



function RechargeWindow:addnewlistCell()  --给排行榜添加
    debug.print_r(_ED.recharge_ranking)
    --print("11111",self.starting_point,self.end_point)
    for i= self.starting_point,self.end_point do   
        if _ED.recharge_ranking[i] ~= nil then
            local temp = {}
            temp =_ED.recharge_ranking[i]
            local cell = state_machine.excute("sm_activity_recharge_cell",0,{temp,i,1})
            self.Ranking_listview:addChild(cell)
        else
            self.isRgOver = true
        end
    end
    self.Ranking_listview:requestRefreshView()
end




function RechargeWindow:changeSelectPage( page )
    local root = self.roots[1]

    local Button_rank_tab_1 = ccui.Helper:seekWidgetByName(root, "Button_recharge_ranking_tab_1")
    local Button_rank_tab_2 = ccui.Helper:seekWidgetByName(root, "Button_recharge_ranking_tab_2")

    local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
    local Image_13_0 = ccui.Helper:seekWidgetByName(root, "Image_13_0")
    
   
    if page == self._current_page then
        if page == 1 then
            Button_rank_tab_1:setHighlighted(true)
        elseif page == 2 then
            Button_rank_tab_2:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_rank_tab_1:setHighlighted(false)
    Button_rank_tab_2:setHighlighted(false)
   
    
    if page == 1 then
        Button_rank_tab_1:setHighlighted(true)
       self.Rank_reward_listview:setVisible(true)
       self.Ranking_listview:setVisible(false)
       Image_13:setVisible(true)
       Image_13_0:setVisible(false)
       self.Panel_lock_on_list:setVisible(false)
       self:onUpdateRaDraw()
    elseif page == 2 then
        Button_rank_tab_2:setHighlighted(true)
       self.Rank_reward_listview:setVisible(false)
       self.Ranking_listview:setVisible(true)
       Image_13:setVisible(false)
       Image_13_0:setVisible(true)
       self.Panel_lock_on_list:setVisible(true)
       self:onUpdateRgDraw()
    end
end

function RechargeWindow:onUpdateRaDraw()    --更新排行榜奖励
   -- self.ranking_reward = zstring.split(_ED.recharge_ranking_reward[rewards][][reward],"|") 
    self.Rank_reward_listview:removeAllItems()
    for i, v in ipairs(_ED.recharge_ranking_reward.rewards) do 
         local cell = state_machine.excute("sm_activity_recharge_reward_cell",0,{v,i})
         self.Rank_reward_listview :addChild(cell)
    end
    self.Rank_reward_listview:requestRefreshView()
    self.Ra_list_view_posy = self.Rank_reward_listview:getInnerContainer():getPositionY()
end


function RechargeWindow:onUpdateRgDraw()    --更新排行榜
   -- self.ranking_reward = zstring.split(_ED.recharge_ranking_reward[rewards][][reward],"|") 
  
    self.Ranking_listview:removeAllItems()
    

    if not _ED.recharge_ranking then
        return
    end

    for i, v in ipairs(_ED.recharge_ranking) do 
         local cell = state_machine.excute("sm_activity_recharge_cell",0,{v,i,0})
         self.Ranking_listview :addChild(cell)
    end
    self.Ranking_listview :requestRefreshView()

    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.bounceBottom then--6
            --滑到头
           local params = {_datas ={_page=2}} 
           state_machine.excute("sm_ranking_main_interface_update_rank", 0, params)
        end
    end
    self.Ranking_listview:addScrollViewEventListener(scrollViewEvent)

    local Text_loke_on_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_loke_on_0")
    local Text_loke_on_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_loke_on_1")
    
    if _ED.recharge_ranking_my then
      if _ED.recharge_ranking_my.rank <200 then
        Text_loke_on_0:setString(_ED.recharge_ranking_my.rank)
      else
        Text_loke_on_0:setString(tipStringInfo_pokemon_recharge_rank_tips[5])
      end
      Text_loke_on_1:setString(_ED.recharge_ranking_my.info.score)
    else
      Text_loke_on_0:setString(tipStringInfo_pokemon_recharge_rank_tips[5])
      Text_loke_on_1:setString(0)
    end
end

function RechargeWindow:updateCurTime()
    self._curTime = os.time() - _ED.native_time + _ED.system_time
end

function RechargeWindow:onEnterTransitionFinish()
  
    local csbNode = csb.createNode("activity/wonderful/recharge_ranking.csb")
    local root = csbNode:getChildByName("root")                         
    self.Rank_reward_listview = ccui.Helper:seekWidgetByName(root, "ListView_recharge_ranking_tab")
    self.Ranking_listview = ccui.Helper:seekWidgetByName(root, "ListView_recharge_ranking_list")
    self.Panel_lock_on_list = ccui.Helper:seekWidgetByName(root, "Panel_lock_on_list")
    self.Ranking_listview:setVisible(false)
    table.insert(self.roots, root)
    self:addChild(csbNode)
    self.Text_rare_time = ccui.Helper:seekWidgetByName(root, "Text_recharge_ranking_time_n")

    -- 服务器时间
    self.Text_time_2 = ccui.Helper:seekWidgetByName(root, "Text_time_2")
    self:updateCurTime()

    self.starting_point = 1
    self.end_point = 10
    self.isRgOver = false
    self.isover = false
    state_machine.excute("recharge_first_enter", 0, nil) 
     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge_ranking_close"), nil, 
    {
        terminal_name = "recharge_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

     --排行奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_ranking_tab_1"), nil, 
    {
        terminal_name = "recharge_first_enter", 
        terminal_state = 0, 
        _page = 1,
        m_type = 0,
    }, nil, 0)
    
    --排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_recharge_ranking_tab_2"), nil, 
    {
        terminal_name = "sm_ranking_main_interface_open_rank", 
        terminal_state = 0, 
        _page = 2,
        m_type = 1,
    }, nil, 0)

       -- 规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5"), nil, 
    {
        terminal_name = "recharge_rule_open", 
        isPressedActionEnabled = true,
    },
    nil, 0)
    
    self:registerOnNoteUpdate(self, 1)
 --   self:drawAllReward(false)
  --  self:drawRareRewards()
end

function RechargeWindow:onExit()
   self.Ranking_listview:removeAllItems()
   self.Rank_reward_listview:removeAllItems()
   _ED.recharge_ranking = nil
   _ED.recharge_ranking_my = nil
   _ED.recharge_ranking_size =nil
end
