-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险事件 --宝箱事件
-------------------------------------------------------------------------------------------------------
AdventureDuplicateEventBoxDlg = class("AdventureDuplicateEventBoxDlgClass", Window)
    
function AdventureDuplicateEventBoxDlg:ctor()
    self.super:ctor()
    self.roots = {}
    self.mould_date = nil
    self.ArmatureNode_xipai = nil
    self.Panel_card1 = nil
    self.Panel_card2 = nil
    self.Panel_card3 = nil
    self.Panel_card4 = nil
    self.Panel_card5 = nil
    self.Button_choujiang = nil
    self.Button_receive = nli 
    self.isCan_fanPai = false
    self.card_cells = {}
    self.card_panels = {}
    self._selectIndex = 0
    self._card_datas = {}
    self.boxTimes = 0  --选择了几次抽牌
    self.Text_firstTime = nil
    self.Text_huode = nil 
    self.Text_pay_xuanze = nil
    self.Array_xuezhan = nil
    self.last_click_panel = nil 
    self.current_click_index = 0
    self.is_first_click = false
    self.already_click = {} --已经选择了的
    self.need_show_data_index = 1 -- 需要显示的索引
    app.load("client.adventure.cells.duplicate.adventure_duplicate_rand_event_card_cell")
    -- Initialize adventure prop storage state machine.
    local function init_adventure_event_box_terminal()
        --抽奖
        local adventure_event_box_lottery_draw_terminal = {
            _name = "adventure_event_box_lottery_draw",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            
                local function responseOnceCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local reward = getSceneReward(51)
                        instance:onUpdateDraw()
                        instance:onPlayingCardAnimation(true,false)
                    else 
                        NetworkManager:register(protocol_command.random_event_close.code, nil, nil, nil, self, nil, false, nil)
                        fwin:close(fwin:find("AdventureDuplicateEventBoxDlgClass"))
                end
                
                end
                protocol_command.random_event_launch.param_list = "".. 0 .."\r\n"
                NetworkManager:register(protocol_command.random_event_launch.code, nil, nil, nil, self, responseOnceCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
		
		--领取奖励
        local adventure_event_box_receive_terminal = {
            _name = "adventure_event_box_receive",
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

        --点击翻牌后处理
        local adventure_event_box_rolling_card_update_terminal = {
            _name = "adventure_event_box_rolling_card_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onTurnOver()
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

        local adventure_event_box_close_terminal = {
            _name = "adventure_event_box_close",

            _init = function (terminal)
    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                local function responseOnceCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                      
                    end
                end
                NetworkManager:register(protocol_command.random_event_close.code, nil, nil, nil, self, responseOnceCallback, false, nil)
                fwin:close(fwin:find("AdventureDuplicateEventBoxDlgClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }
        state_machine.add(adventure_event_box_lottery_draw_terminal)
        state_machine.add(adventure_event_box_receive_terminal)
        state_machine.add(adventure_event_box_rolling_card_update_terminal)
        state_machine.add(adventure_event_box_close_terminal)
        state_machine.init()
    end
    
    -- call func init adventure prop storage state machine.
    init_adventure_event_box_terminal()
end

function AdventureDuplicateEventBoxDlg:init()
    return self
end

function AdventureDuplicateEventBoxDlg:updateOnInfo()
	local root = self.roots[1]
	
end

function AdventureDuplicateEventBoxDlg:onUpdate(dt)

end

-- 非第一次抽牌
function AdventureDuplicateEventBoxDlg:onTurnOthenCard(index)
    self.current_click_index = index
    local function responseOnceCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                local reward = getSceneReward(51)
                self:onUpdateDraw()
                self:onClick(self.current_click_index)
            else
                NetworkManager:register(protocol_command.random_event_close.code, nil, nil, nil, self, nil, false, nil)
                fwin:close(fwin:find("AdventureDuplicateEventBoxDlgClass"))
        end
    end
    protocol_command.random_event_launch.param_list = "".. 0 .."\r\n"
    NetworkManager:register(protocol_command.random_event_launch.code, nil, nil, nil, self, responseOnceCallback, false, nil)
end

--重新抽奖
function AdventureDuplicateEventBoxDlg:onTakeCardAgain()
    
    self.Button_choujiang:setVisible(self.boxTimes < 5)
        
    self.Button_choujiang:setVisible(true)
    self.Button_receive:setVisible(false)
    self:onPlayingCardAnimation(false,false)
    
    self.Text_firstTime:setVisible(self.boxTimes == 0)
    self.Text_huode:setVisible(false)
    self.Text_pay_xuanze:setVisible(self.boxTimes > 0)
    if self.boxTimes < 5 then 
        local tipString = string.format(_string_piece_info[402], self.boxTimes + 1,self.Array_xuezhan[self.boxTimes + 1])
        self.Text_pay_xuanze:setString(tipString)
    else
        self.Text_pay_xuanze:setVisible(false)
    end
    
end

function AdventureDuplicateEventBoxDlg:onUpdateDraw()
	local root = self.roots[1]
    if _ED.random_event ~= nil and tonumber( _ED.random_event.event_id) > 0 then 
        --print("------刷新数据")
        --debug.print_r(_ED.random_event.event_data)
        self.mould_date = dms.element(dms["spirite_palace_event_library"], tonumber(_ED.random_event.event_id))

        local  random_event_id = dms.atoi(self.mould_date, spirite_palace_event_library.event_id)   --
        local  random_event_type = dms.atoi(self.mould_date, spirite_palace_event_library.group_type)   -- 5

        local  Panel_item = nil
        local  item_data  = dms.string(dms["spirite_palace_event_param"], tonumber(random_event_id), spirite_palace_event_param.event_param)
        self.Array_xuezhan = zstring.split(item_data, ",")
        local box_datas = zstring.split(_ED.random_event.event_data, ",")
        self._card_datas = {}
        self.boxTimes = 0
        for i, box_data in pairs(box_datas) do
            local box_id = zstring.split(box_data, ":")[1]
            local box_opened = zstring.split(box_data, ":")[2]
            local box_detail = dms.element(dms["random_event_box"], tonumber(box_id))
            
            local prop_type = dms.atoi(box_detail,random_event_box.prop_type)
            local prop_id   = dms.atoi(box_detail,random_event_box.prop_id)
            local prop_amount = dms.atoi(box_detail,random_event_box.prop_amount)
            local cell = {_pro_type = prop_type,_prop_id = prop_id,_prop_amount = prop_amount,_box_id = box_id ,_box_opend = box_opened }

            if tonumber(box_opened) == 1 then
                local isFind = false
                self.boxTimes = self.boxTimes + 1
                for k,v in pairs(self.already_click) do
                    if v == i  then 
                        isFind = true
                        break
                    end
                end 
                if isFind == false then 
                    table.insert(self.already_click,i)
                end
            end
             
            table.insert(self._card_datas,cell)
        end
        
        if self.boxTimes == 0  then 
            --一次都没有抽过,初始化需要全部显示
            self.Button_choujiang:setVisible(true)
            self.is_first_click = true
            for i=1,5 do
                self.card_cells[i]:init(self._card_datas[i]._pro_type,self._card_datas[i]._prop_id,self._card_datas[i]._prop_amount)
                self.card_cells[i]:showGoods()
            end
        else
            self.Button_choujiang:setVisible(false)
        end

        if self.boxTimes >= 5 then 
            self.Button_receive:setVisible(true)
        else 
            self.Button_receive:setVisible(false)
        end
        self.Text_firstTime:setVisible(self.boxTimes == 0 )
    end
end

-- 播放牌的动画
-- show 是否显示动画 注false时 原牌需要隐藏
-- shake 是否持续抖动
function AdventureDuplicateEventBoxDlg:onPlayingCardAnimation(show,shake)
    self.Panel_card1:setVisible(show == false)
    self.Panel_card2:setVisible(show == false)
    self.Panel_card3:setVisible(show == false)
    self.Panel_card4:setVisible(show == false)
    self.Panel_card5:setVisible(show == false)
    self.isCan_fanPai = false
    if show == true then 
        csb.animationChangeToAction(self.ArmatureNode_xipai, 0, 0, false)
        self.ArmatureNode_xipai._invoke = self.ArmatureNode_xipai._invoke_w
        self.ArmatureNode_xipai:setVisible(true)
        self.Button_choujiang:setVisible(false)
    end
end

function AdventureDuplicateEventBoxDlg:getSelectItemName()
    local index = 1
    if #self.already_click > 0 then 
        index = tonumber(self.already_click[#self.already_click])
    else 
        index = 1
    end

    local cell = self._card_datas[index]

    if cell ~= nil then 
        local obj_date = {}
       -- local cell = {_pro_type = prop_type,_prop_id = prop_id,_prop_amount = prop_amount,_box_id = box_id ,_box_opend = box_opened }
         if zstring.tonumber(cell._pro_type) == 6 then          -- 目前用propIcon代表类型（道具或者货币）
            obj_date = {mould_id = cell._prop_id}
       
        else
            obj_date = {resource_type = cell._pro_type}
        
        end
        local mould_data = obj_date.mould_data or dms.element(dms["prop_mould"], obj_date.mould_id)
        if  mould_data == nil then 
            local  name  =  ""
            if tonumber(obj_date.resource_type) == 2 then  -- 血钻
                name = _All_tip_string_info._crystalName
    
            elseif tonumber(obj_date.resource_type) == 4  then -- 将魂
                name = _All_tip_string_info._soulName

            elseif tonumber(obj_date.resource_type) == 1 then  --金币,
                name = _All_tip_string_info._fundName

            elseif tonumber(obj_date.resource_type) == 3 then  --王者之章
                name = _All_tip_string_info._glories

            elseif tonumber(obj_date.resource_type) == 8 then  --经验
                name = _All_tip_string_info._expName
            end
            
            name = name .. "X" .. cell._prop_amount
            return name
        else
            name = dms.atos(mould_data, prop_mould.prop_name) .. "X" .. cell._prop_amount
            return name
        end
    end
    return ""
end
-- 点击翻牌结束后自动翻开其他牌
function AdventureDuplicateEventBoxDlg:onPlayingCardAnimationOver()
    --显示文本
    for i=1,5 do
        self.card_panels[i]:setTouchEnabled(true)
        self.card_cells[i]:playShake()
    end
    self.isCan_fanPai = true
    ccui.Helper:seekWidgetByName(self.roots[1], "Text_dianji"):setVisible(true)
    self.Text_pay_xuanze:setVisible(false)
    self.Text_firstTime:setVisible(false)

end

--牌了一张牌后,动画结束处理
function AdventureDuplicateEventBoxDlg:onTurnOver()
   
    self.card_cells[self._selectIndex]:stopPlayShake()
 
    self.isCan_fanPai = true
    ccui.Helper:seekWidgetByName(self.roots[1], "Text_dianji"):setVisible(false)
    self.Text_huode:setVisible(true)
    local tipString = string.format(_string_piece_info[401], self:getSelectItemName())
    self.Text_huode:setString(tipString)
    self.Button_choujiang:setVisible(false)
    
    self.Text_pay_xuanze:setVisible(self.boxTimes > 0)
    if self.boxTimes < 5 then 
        local tipString = string.format(_string_piece_info[402], self.boxTimes + 1,self.Array_xuezhan[self.boxTimes + 1])
        self.Text_pay_xuanze:setString(tipString)
        self.Text_pay_xuanze:setVisible(true)
    else 
        self.Text_pay_xuanze:setVisible(false)
    end

    if self.boxTimes >= 5 then 
        self.Button_receive:setVisible(true)
    else 
        self.Button_receive:setVisible(false)
     end

end

function AdventureDuplicateEventBoxDlg:onClick(index)
    self.current_click_index = index
    self.card_panels[index]:setTouchEnabled(false)
    if self.last_click_panel == nil then
        self.last_click_panel = self.card_cells[index]
    else
        self.last_click_panel:playTurnLight(false)
        self.last_click_panel = self.card_cells[index]
    end
    self._selectIndex = index
    
    if #self.already_click > 0 then 
        local showIndex = tonumber(self.already_click[#self.already_click])
        self.card_cells[index]:init(self._card_datas[showIndex]._pro_type,self._card_datas[showIndex]._prop_id,self._card_datas[showIndex]._prop_amount)
    else 
        self.card_cells[index]:init(self._card_datas[1]._pro_type,self._card_datas[1]._prop_id,self._card_datas[1]._prop_amount)
    end

    self.card_cells[index]:playTurn(true)    
end

function AdventureDuplicateEventBoxDlg:onEnterTransitionFinish()
    local csbEnvetBoss = csb.createNode("duplicate/maoxian_shijian_box.csb")
    local root = csbEnvetBoss:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbEnvetBoss)

    local armature_panel = ccui.Helper:seekWidgetByName(root, "Panel_mxsj_2")
    self.Button_choujiang = ccui.Helper:seekWidgetByName(root, "Button_choujiang")
    self.Button_receive = ccui.Helper:seekWidgetByName(root, "Button_receive")       
    self.Text_firstTime = ccui.Helper:seekWidgetByName(root, "Text_once_free")       
    self.Text_huode = ccui.Helper:seekWidgetByName(root, "Text_huode")       
    self.Text_pay_xuanze = ccui.Helper:seekWidgetByName(root, "Text_pay_xuezuan")       
    self.Button_choujiang:setVisible(true)
    
    ccui.Helper:seekWidgetByName(root, "Text_dianji"):setVisible(false)
    
    self.ArmatureNode_xipai = armature_panel:getChildByName("ArmatureNode_3")
    draw.initArmature(self.ArmatureNode_xipai, nil, -1, 0, 1)
    self.ArmatureNode_xipai:setVisible(false)
    csb.animationChangeToAction(self.ArmatureNode_xipai, 0, 0, false)
    self.last_click_panel = nil
    self.ArmatureNode_xipai._invoke_w = function(armatureBack)
        if armatureBack:isVisible() == true then
            --print("播放完了")
            self:onPlayingCardAnimation(false,true)
            self:onPlayingCardAnimationOver()
            armatureBack:setVisible(false)
        end
    end   
    self.Button_receive:setVisible(false)
    self.card_cells = {}
    self.card_panels = {}
    self.already_click = {}
    -----需要优化代码----- for循环写
    self.Panel_card1 = ccui.Helper:seekWidgetByName(root, "Panel_cq_b_1")
    self.Panel_card2 = ccui.Helper:seekWidgetByName(root, "Panel_cq_b_2")
    self.Panel_card3 = ccui.Helper:seekWidgetByName(root, "Panel_cq_b_3")
    self.Panel_card4 = ccui.Helper:seekWidgetByName(root, "Panel_cq_b_4")
    self.Panel_card5 = ccui.Helper:seekWidgetByName(root, "Panel_cq_b_5")
    local cell1 = self:createCardCell()
    local cell2 = self:createCardCell()
    local cell3 = self:createCardCell()
    local cell4 = self:createCardCell()
    local cell5 = self:createCardCell()

    self.Panel_card1:addChild(cell1)
    self.Panel_card2:addChild(cell2)
    self.Panel_card3:addChild(cell3)
    self.Panel_card4:addChild(cell4)
    self.Panel_card5:addChild(cell5)

   
    self.Panel_card1._index = 1
    self.Panel_card2._index = 2
    self.Panel_card3._index = 3
    self.Panel_card4._index = 4
    self.Panel_card5._index = 5
    self:onPlayingCardAnimation(false,false)
    table.insert(self.card_panels, self.Panel_card1)
    table.insert(self.card_panels, self.Panel_card2)
    table.insert(self.card_panels, self.Panel_card3)
    table.insert(self.card_panels, self.Panel_card4)
    table.insert(self.card_panels, self.Panel_card5)

    table.insert(self.card_cells,cell1)
    table.insert(self.card_cells,cell2)
    table.insert(self.card_cells,cell3)
    table.insert(self.card_cells,cell4)
    table.insert(self.card_cells,cell5)

    local function openCardHander(sender, eventType)    
        if eventType == ccui.TouchEventType.ended then
            if self.isCan_fanPai ==  true then 
               -- print("翻了第几个牌:",sender._index)
                self.isCan_fanPai = false

                if self.is_first_click  == true then
                    ----第二次点击
                    self:onClick(sender._index)
                    self.is_first_click = false
                else
                    self:onTurnOthenCard(sender._index)
                end
    
            end 
        elseif eventType == ccui.TouchEventType.began then
            
        end
    end
    
    self.Panel_card1:addTouchEventListener(openCardHander)
    self.Panel_card2:addTouchEventListener(openCardHander)
    self.Panel_card3:addTouchEventListener(openCardHander)
    self.Panel_card4:addTouchEventListener(openCardHander)
    self.Panel_card5:addTouchEventListener(openCardHander)

	self:onUpdateDraw()
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        terminal_name = "adventure_event_box_close",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_choujiang"),       nil, 
    {
        terminal_name = "adventure_event_box_lottery_draw",    
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    
    
    fwin:addTouchEventListener(self.Button_receive,       nil, 
    {
        terminal_name = "adventure_event_box_close",    
        cell = self,     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureDuplicateEventBoxDlg:createCardCell()
    local cell = AdventureDuplicateRandEventCardCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function AdventureDuplicateEventBoxDlg:onExit()
    state_machine.remove("adventure_event_box_lottery_draw")
    state_machine.remove("adventure_event_box_receive")
    state_machine.remove("adventure_event_box_close")
end
