-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险事件 --偶遇事件
-------------------------------------------------------------------------------------------------------
AdventureDuplicateEventMeetDlg = class("AdventureDuplicateEventMeetDlgClass", Window)
    
function AdventureDuplicateEventMeetDlg:ctor()
    self.super:ctor()
    self.roots = {}
    self.mould_date = nil
    self.event_data_id = 0

    self.Panel_wenti = nil
    self.Panel_reward = nil
    self.Panel_error = nil
    self.current_stage = 0   --  1 提问 2,正确,3 错误
    self.Text_timu = nil
    self.chooseType = 0  --0 表示正确答案在上面 1 错误答案在上面
    self.selectType = 0  -- 自己选中的 0 选中的是上面 1 选中的是下面
    self.Panel_show1 = nil
    self.Panel_show2 = nil 

    -- Initialize adventure prop storage state machine.
    local function init_adventure_event_meet_terminal()
        --领取奖励
        local adventure_event_meet_receive_terminal = {
            _name = "adventure_event_meet_receive",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
		
		--错误按钮
        local adventure_event_meet_erro_terminal = {
            _name = "adventure_event_meet_erro",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        --确定
		local adventure_event_meet_sure_terminal = {
            _name = "adventure_event_meet_sure",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                local choose_type = 0 
                -- 这个地方先这样写,之后需求都要修改
                if self.selectType == -1 then 
                    TipDlg.drawTextDailog(_string_piece_info[405])
                    return 
                end
                
                local function responseOnceCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        
                        if instance.chooseType == instance.selectType then
                            --正确答案
                            instance.current_stage = 2
                        else 

                            instance.current_stage = 3
                        end
                        instance:updateOnInfo()
                    else
                        NetworkManager:register(protocol_command.random_event_close.code, nil, nil, nil, self, nil, false, nil)
                        fwin:close(fwin:find("AdventureDuplicateEventMeetDlgClass"))
                    end
                end
                
                protocol_command.random_event_launch.param_list = "".. self.selectType .."\r\n"
                NetworkManager:register(protocol_command.random_event_launch.code, nil, nil, nil, self, responseOnceCallback, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

         local adventure_event_meet_close_terminal = {
            _name = "adventure_event_meet_close",

            _init = function (terminal)
    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("AdventureDuplicateEventMeetDlgClass"))
                local function responseOnceCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    end
                end
                NetworkManager:register(protocol_command.random_event_close.code, nil, nil, nil, self, responseOnceCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
        state_machine.add(adventure_event_meet_receive_terminal)
        state_machine.add(adventure_event_meet_erro_terminal)
        state_machine.add(adventure_event_meet_sure_terminal)
        state_machine.add(adventure_event_meet_close_terminal)
        state_machine.init()
    end
    
    -- call func init adventure prop storage state machine.
    init_adventure_event_meet_terminal()
end

function AdventureDuplicateEventMeetDlg:init()
    return self
end


function AdventureDuplicateEventMeetDlg:updateOnInfo()
     app.load("client.reward.DrawRareReward") 
	local root = self.roots[1]
    if self.current_stage == 2 or  self.current_stage == 3 then
        local raward = getSceneReward(51)
        local _width = 0
        local _nCount = 0
        if self.current_stage == 2 then
            --正确文字
            self.Text_timu:setString(_string_piece_info[403])
            
        else
            --错误文字
            self.Text_timu:setString(_string_piece_info[404])
        end
        local ListView_huode = ccui.Helper:seekWidgetByName(root, "ListView_prop_reward")
        ListView_huode:removeAllItems()
        if raward == nil then 
            return
        end
        app.load("client.adventure.cells.prop.adventure_new_prop_small_icon_cell")
        for i, v in pairs(raward.show_reward_list) do
           
            local cell = adventureNewSmallPropIconCell:createCell()
            if zstring.tonumber(v.prop_type) == 1 then
                cell:init(0, {resource_type = 1} , "" .. getResourceValueToStringForAdventure(v.item_value), nil, 0, 0)
                ListView_huode:addChild(cell)
                _width = cell:getContentSize().width
                _nCount = _nCount + 1
            elseif zstring.tonumber(v.prop_type) == 2 then
                cell:init(0, {resource_type = 2} , "" .. getResourceValueToStringForAdventure(v.item_value), nil, 0, 0)
                ListView_huode:addChild(cell)
                _width = cell:getContentSize().width
                _nCount = _nCount + 1
            elseif zstring.tonumber(v.prop_type) == 3 then
                cell:init(0, {resource_type = 3} , "" .. getResourceValueToStringForAdventure(v.item_value), nil, 0, 0)
                ListView_huode:addChild(cell)
                _width = cell:getContentSize().width
                _nCount = _nCount + 1
            elseif zstring.tonumber(v.prop_type) == 4 then
                cell:init(0, {resource_type = 4} , "" .. getResourceValueToStringForAdventure(v.item_value), nil, 0, 0)
                ListView_huode:addChild(cell)
                _width = cell:getContentSize().width
                _nCount = _nCount + 1
            elseif zstring.tonumber(v.prop_type) == 6 then
                cell:init(0, {mould_id = v.prop_item} , "" .. getResourceValueToStringForAdventure(v.item_value), nil, 0, 0)
                ListView_huode:addChild(cell)
                _width = cell:getContentSize().width
                _nCount = _nCount + 1
            elseif zstring.tonumber(v.prop_type) == 8 then  
                cell:init(0, {resource_type = 8} , "" .. getResourceValueToStringForAdventure(v.item_value), nil, 0, 0)
                ListView_huode:addChild(cell)
                _width = cell:getContentSize().width
                _nCount = _nCount + 1
            
            end
            
        end
        raward = nil
        ListView_huode:requestRefreshView()     
        if ListView_huode._x == nil then
            ListView_huode._x = ListView_huode:getPositionX()
        end
        ListView_huode:setPositionX(ListView_huode._x - (_width + ListView_huode:getItemsMargin()) * (_nCount - 1) / 2)
            
            
    end
    self.Panel_wenti:setVisible(false)
    self.Panel_reward:setVisible(true)
    self.Panel_error:setVisible(false)
	
end

function AdventureDuplicateEventMeetDlg:onUpdateDraw()
	local root = self.roots[1]
    
    if _ED.random_event ~= nil and tonumber( _ED.random_event.event_id) > 0 then 
        self.event_data_id = _ED.random_event.event_data
        self.mould_date = dms.element(dms["spirite_palace_answer_param"], tonumber(self.event_data_id))
        
        if self.mould_date == nil then 
            return
        end
        self.Text_timu:setString(dms.atos(self.mould_date, spirite_palace_answer_param.question))
        if self.current_stage == 1 then
            self.chooseType = dms.atoi(self.mould_date, spirite_palace_answer_param.default_index)
            local text_daan1 = ccui.Helper:seekWidgetByName(root, "Text_shijian_daan_1")
            local text_daan2 = ccui.Helper:seekWidgetByName(root, "Text_shijian_daan_2")
            
            if self.chooseType == 0 then 
                --正确答案在上面
                text_daan1:setString(dms.atos(self.mould_date, spirite_palace_answer_param.right_answer))
                text_daan2:setString(dms.atos(self.mould_date, spirite_palace_answer_param.wrong_answer))
            else 
                text_daan1:setString(dms.atos(self.mould_date, spirite_palace_answer_param.wrong_answer))
                text_daan2:setString(dms.atos(self.mould_date, spirite_palace_answer_param.right_answer))
            end
       
        end   
        
        self.Panel_wenti:setVisible(self.current_stage == 1)
        self.Panel_reward:setVisible(self.current_stage == 2)
        self.Panel_error:setVisible(self.current_stage == 3)
    end
end

function AdventureDuplicateEventMeetDlg:onEnterTransitionFinish()
    local csbEnvetBoss = csb.createNode("duplicate/maoxian_shijian_ouyu.csb")
    local root = csbEnvetBoss:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbEnvetBoss)

    self.Panel_wenti = ccui.Helper:seekWidgetByName(root, "Panel_wenti")
    self.Panel_reward = ccui.Helper:seekWidgetByName(root, "Panel_reward")
    self.Panel_error = ccui.Helper:seekWidgetByName(root, "Panel_error")
    self.Text_timu = ccui.Helper:seekWidgetByName(root, "Text_shijian_timu")
    self.Panel_select1 = ccui.Helper:seekWidgetByName(root, "Panel_daan_1")
    self.Panel_select2 = ccui.Helper:seekWidgetByName(root, "Panel_daan_2")
    self.Panel_wenti = ccui.Helper:seekWidgetByName(root, "Panel_wenti")
    self.Panel_wenti:setVisible(true)
    self.Panel_show1 = ccui.Helper:seekWidgetByName(root, "Panel_daan_1_0")
    self.Panel_show2 = ccui.Helper:seekWidgetByName(root, "Panel_daan_2_0")
    self.Panel_show1:setVisible(false)
    self.Panel_show2:setVisible(false)

    self.current_stage = 1 
    self.selectType = -1
	self:onUpdateDraw()
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        terminal_name = "adventure_event_meet_close",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    local function selectedEvent1(sender,eventType)
       if eventType == ccui.TouchEventType.began then
          
        elseif eventType == ccui.TouchEventType.moved then 
            
        elseif eventType == ccui.TouchEventType.ended then 
            self.selectType = 0
            self.Panel_wenti:setVisible(false)
            self.Panel_show1:setVisible(true)
            self.Panel_show2:setVisible(false) 
            state_machine.excute("adventure_event_meet_sure",0,0)
        else  
            
        end
    end
    self.Panel_select1:addTouchEventListener(selectedEvent1)

    local function selectedEvent2(sender,eventType)
       if eventType == ccui.TouchEventType.began then
          
        elseif eventType == ccui.TouchEventType.moved then 
            
        elseif eventType == ccui.TouchEventType.ended then 
            self.selectType = 1
            self.Panel_wenti:setVisible(false)
            self.Panel_show1:setVisible(false)
            self.Panel_show2:setVisible(true)
            state_machine.excute("adventure_event_meet_sure",0,0)
        else 
            
        end
    end
    self.Panel_select2:addTouchEventListener(selectedEvent2)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reward"),       nil, 
    {
        terminal_name = "adventure_event_meet_close",
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
            
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_error"),       nil, 
    {
        terminal_name = "adventure_event_meet_erro",    
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sure_ouyu"),       nil, 
    {
        terminal_name = "adventure_event_meet_sure",    
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureDuplicateEventMeetDlg:onExit()
    state_machine.remove("adventure_event_meet_receive")
    state_machine.remove("adventure_event_meet_erro")
    state_machine.remove("adventure_event_meet_sure")
    state_machine.remove("adventure_event_meet_choose_box1")
    state_machine.remove("adventure_event_meet_choose_box2")
    state_machine.remove("adventure_event_meet_close") 
end
