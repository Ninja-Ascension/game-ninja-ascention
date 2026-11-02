-- ----------------------------------------------------------------------------------------------------
-- 说明：签订契约界面
-------------------------------------------------------------------------------------------------------
AdventureMercenaryAgreementContract = class("AdventureMercenaryAgreementContractClass", Window)
    
function AdventureMercenaryAgreementContract:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.hero = nil
    self.touches = {}
    self.touchBeganPos = nil
    self.chooseType = 1 --1显示上面 2 显示下面
    self.alreadyAgreementAnimation = nil -- 已经签约动画
    self.agreementSuccessAnimation = nil -- 签约成功动画

    --app.load("client.loader.formula")
    app.load("client.adventure.mercenary.agreement.AdventureAgreementContractConfirm")

    -- Initialize adventure hero awaken state machine.
    local function init_adventure_mercenary_agreement_terminal()
        -- --弹出选择佣兵列表
        local adventure_mercenary_agreetment_confirm_open_terminal = {
            _name = "adventure_mercenary_agreetment_confirm_open",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)    
                
                local isCan = instance:checkContract()
                if isCan == false then
                    return
                end
                fwin:open(AdventureAgreementContractConfirm:new():init(instance.hero,instance.chooseType), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --签订成功后播放动画
        local adventure_mercenary_agreetment_confirm_ok_update_terminal = {
            _name = "adventure_mercenary_agreetment_confirm_ok_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)                
                instance:playAgreementAction()
                instance:updateDraw()
                instance:onUpdateAgreementStates(1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_mercenary_agreetment_confirm_open_terminal)
        state_machine.add(adventure_mercenary_agreetment_confirm_ok_update_terminal)
        
        state_machine.init()
    end
    
    -- call func init adventure hero awaken state machine.
    init_adventure_mercenary_agreement_terminal()
end

function AdventureMercenaryAgreementContract:onUpdate(dt)
end

--播放签订成功后动画
function AdventureMercenaryAgreementContract:playAgreementAction()
    csb.animationChangeToAction(self.agreementSuccessAnimation, 0, 0, false)
    self.agreementSuccessAnimation._invoke = self.agreementSuccessAnimation._invoke_w
    self.agreementSuccessAnimation:setVisible(true)
end

function AdventureMercenaryAgreementContract:checkContract()
    local isCan = false
    local agreementStates = zstring.tonumber(self.hero.agreementStates)
    if agreementStates == 0 and self.chooseType == 2 then 
        return false
    end
    if agreementStates == 1 and self.chooseType == 1 then 
        return false
    end
    if agreementStates == 2 and self.chooseType == 2 then 
        return false
    end
    local twoagreement =dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.need_honor)
    if self.chooseType == 2 and twoagreement == -1 then 
        return false
    end

    return true
end

function AdventureMercenaryAgreementContract:init(hero)
    self.hero = hero
    -- self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
    return self
end

function AdventureMercenaryAgreementContract:updateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    --debug.print_r(self.hero.ship_template_id
    local oneagreement =dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.price)
    local twoagreement =dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.need_honor)
    local agreementStates = zstring.tonumber(self.hero.agreementStates)
    local Text_one = ccui.Helper:seekWidgetByName(root, "Text_yijie")
    local Text_two = ccui.Helper:seekWidgetByName(root, "Text_erjie")
    if agreementStates == 0 then 
        --未签约
        Text_one:setString(tipStringInfo_hero_agreement_states[1])
        if twoagreement == -1 then 
            --未开放一阶
            Text_two:setString(tipStringInfo_hero_agreement_states[11])
        else
            Text_two:setString(tipStringInfo_hero_agreement_states[1])
        end
    elseif agreementStates == 1 then 
        --签约一阶
        Text_one:setString(tipStringInfo_hero_agreement_states[4])
        if twoagreement == -1 then 
            Text_two:setString(tipStringInfo_hero_agreement_states[11])
        else
            Text_two:setString(tipStringInfo_hero_agreement_states[1])
        end
        self.alreadyAgreementAnimation:setVisible(true)
    elseif agreementStates == 2 then 
        --签约二阶段
        Text_one:setString(tipStringInfo_hero_agreement_states[4])
        if twoagreement == -1 then 
            Text_two:setString(tipStringInfo_hero_agreement_states[11])
        else
            Text_two:setString(tipStringInfo_hero_agreement_states[4])
        end
    end
    
    if oneagreement == -1 then 
        return
    end
    local add_speed =dms.int(dms["contract_mould"], oneagreement, contract_mould.add_speed)
    local add_denfence =dms.int(dms["contract_mould"], oneagreement, contract_mould.add_denfence)
    local add_adv =dms.int(dms["contract_mould"], oneagreement, contract_mould.add_adv)
    local add_authority =dms.int(dms["contract_mould"], oneagreement, contract_mould.add_authority)

    local showOne_data = {}
    if add_speed > 0 then 
       table.insert(showOne_data,{add_type = 1,add_value = add_speed})
    end
    if add_denfence > 0 then
        table.insert(showOne_data,{add_type = 2,add_value = add_denfence})
    end
    if add_adv > 0 then 
        table.insert(showOne_data,{add_type = 3,add_value = add_adv})
    end
    if add_authority > 0 then 
        table.insert(showOne_data,{add_type = 4,add_value = add_authority})
    end
    local panel_role_1 = ccui.Helper:seekWidgetByName(root, "Panel_34")
    panel_role_1:removeAllChildren(true)
    panel_role_1:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", zstring.tonumber(_ED.user_info.user_head) + 500))
        
    local picIndex =dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.head_icon)
    local panel_role_2 = ccui.Helper:seekWidgetByName(root, "Panel_34_0")
     
    panel_role_2:removeAllChildren(true)
    panel_role_2:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex))
    --ccui.Helper:seekWidgetByName(root, "Text_32"):setString(_ED.user_info.user_name)
    ccui.Helper:seekWidgetByName(root, "Text_huobanname"):setString(dms.string(dms["ship_mould"], self.hero.ship_template_id, ship_mould.captain_name))

    --一阶刷新
    if oneagreement ~= -1 then 
        for i=1,4 do
            local Panel_one = ccui.Helper:seekWidgetByName(root, "Panel_20_" .. i)
            if i <= #showOne_data then 
                Panel_one:setVisible(true)
                local one_data = showOne_data[i]
                local Panel_yijie_icon = ccui.Helper:seekWidgetByName(root, "Panel_yijie_" .. i)
                local shuxing_type = zstring.tonumber(one_data.add_type)
                local yijie_icon = string.format("images/ui/icon/icon_shuxin_%d.png", "" .. shuxing_type)
                Panel_yijie_icon:setBackGroundImage(yijie_icon)
                ccui.Helper:seekWidgetByName(root, "Text_yijie_" .. i):setString(_hide_siwei_property[shuxing_type])
                ccui.Helper:seekWidgetByName(root, "Text_yijie_" .. i .. "_0"):setString("+" .. one_data.add_value)
            else
                Panel_one:setVisible(false)
            end
        end
    end
    --二阶刷新

    if twoagreement ~= -1 then
        local add_exp_2 =dms.int(dms["contract_mould"], twoagreement, contract_mould.add_contract_exp)
        local add_multiple_2 =dms.int(dms["contract_mould"], twoagreement, contract_mould.add_hero_attr_multiple)

        local add_speed_2 =dms.int(dms["contract_mould"], twoagreement, contract_mould.add_speed)
        local add_denfence_2 =dms.int(dms["contract_mould"], twoagreement, contract_mould.add_denfence)
        local add_adv_2 =dms.int(dms["contract_mould"], twoagreement, contract_mould.add_adv)
        local add_authority_2 =dms.int(dms["contract_mould"], twoagreement, contract_mould.add_authority)
        local showTwo_data = {}
        if add_exp_2 > 0 then 
            table.insert(showTwo_data,{add_type = 5,add_value = add_exp_2})
        end 
        if add_multiple_2 > 0 then 
            table.insert(showTwo_data,{add_type = 6,add_value = add_multiple_2})
        end 
        if add_speed_2 > 0 then 
           table.insert(showTwo_data,{add_type = 1,add_value = add_speed_2})
        end
        if add_denfence_2 > 0 then
            table.insert(showTwo_data,{add_type = 2,add_value = add_denfence_2})
        end
        if add_adv_2 > 0 then 
            table.insert(showTwo_data,{add_type = 3,add_value = add_adv_2})
        end
        if add_authority_2 > 0 then 
            table.insert(showTwo_data,{add_type = 4,add_value = add_authority_2})
        end
        for i=1,6 do
            local Panel_two = ccui.Helper:seekWidgetByName(root, "Panel_21_" .. i)
            if i <= #showTwo_data then 
                Panel_one:setVisible(true)
                local two_data = showTwo_data[i]
                local Panel_erjie_icon = ccui.Helper:seekWidgetByName(root, "Panel_erjie_" .. i)
                local shuxing_type = zstring.tonumber(two_data.add_type)
                local yijie_icon = string.format("images/ui/icon/icon_shuxin_%d.png", "" .. shuxing_type)
                Panel_erjie_icon:setBackGroundImage(yijie_icon)
                ccui.Helper:seekWidgetByName(root, "Panel_erjie_" .. i):setString(_hide_siwei_property[shuxing_type])
                ccui.Helper:seekWidgetByName(root, "Panel_erjie_" .. i .. "_0"):setString("+" .. two_data.add_value)
            else
                Panel_two:setVisible(false)
            end
        end
        ccui.Helper:seekWidgetByName(root, "Text_erjie"):setVisible(false)
    else
        for i=1,6 do
            local Panel_two = ccui.Helper:seekWidgetByName(root, "Panel_21_" .. i)
            Panel_two:setVisible(false)
        end
        ccui.Helper:seekWidgetByName(root, "Text_erjie"):setVisible(true)
    end
end

function AdventureMercenaryAgreementContract:onUpdateAgreementStates(showType)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    if showType == 1 then 
        contract_id =dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.price)
    else
        contract_id =dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.need_honor)
    end
    local tip_Text = ccui.Helper:seekWidgetByName(root, "Text_32_0")

    local qianyue_button = ccui.Helper:seekWidgetByName(root, "Button_1")    
    qianyue_button:setColor(cc.c3b(255, 255, 255))
    qianyue_button:setTouchEnabled(true)
    if showType == 1 then 
        ccui.Helper:seekWidgetByName(root, "Panel_erjie_close"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Panel_erjie_open"):setVisible(false)
    end
    if contract_id == -1 and showType == 2 then 
        --二阶未开启
        ccui.Helper:seekWidgetByName(root, "Panel_erjie_close"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_erjie_open"):setVisible(false)
        qianyue_button:setColor(cc.c3b(130, 130, 130))
        qianyue_button:setTouchEnabled(false)
        tip_Text:setString(tipStringInfo_hero_agreement_states[11])

        return
    end
    if contract_id ~= -1 and showType == 2 then 
        --二阶开启
        ccui.Helper:seekWidgetByName(root, "Panel_erjie_close"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Panel_erjie_open"):setVisible(true)

    end
    local agreementStates = zstring.tonumber(self.hero.agreementStates)
    
    if agreementStates == 0 then 
        --一阶未签约
        tip_Text:setString(tipStringInfo_hero_agreement_states[1])
              --判断材料是否足够
            
            local is_can_qianyue = true
            
            local prop_item_num1 =dms.int(dms["contract_mould"], contract_id, contract_mould.need_prop_num1)
            local prop_item_num2 =dms.int(dms["contract_mould"], contract_id, contract_mould.need_prop_num2)
            local prop_item_num3 =dms.int(dms["contract_mould"], contract_id, contract_mould.need_prop_num3)

            local contract_data = {}
            if prop_item_num1 > 0 then 
               table.insert(contract_data,{consume_id = dms.int(dms["contract_mould"], contract_id, contract_mould.need_prop_mould1),
                consume_value = prop_item_num1})
            end
            if prop_item_num2 > 0 then
                table.insert(contract_data,{consume_id = dms.int(dms["contract_mould"], contract_id, contract_mould.need_prop_mould2),
                consume_value = prop_item_num2})
            end
            if prop_item_num3 > 0 then 
               table.insert(contract_data,{consume_id = dms.int(dms["contract_mould"], contract_id, contract_mould.need_prop_mould3),
                consume_value = prop_item_num3})
            end
            --首先判断道具是否满足
            for i=1,3 do
                if i <= #contract_data then 
                    local one_data = contract_data[i]
                    local mould_data = dms.element(dms["prop_mould"], one_data.consume_id)
                    if mould_data~= nil then 
                        if zstring.tonumber(get_prop_amount(one_data.consume_id)) < one_data.consume_value then 
                            is_can_qianyue = false
                            break
                        end
                    end               
                end
            end
            --判断荣誉碎片,契约石是否满足
            local prop_item_resoure_type_5 =dms.int(dms["contract_mould"], contract_id, contract_mould.need_soul_count)
            if prop_item_resoure_type_5 > 0 then
                if zstring.tonumber(_ED.user_info.soul) < zstring.tonumber(prop_item_resoure_type_5)  then                 
                    is_can_qianyue = false
                end
            end
    
            local prop_item_resoure_type_6 =dms.int(dms["contract_mould"], contract_id, contract_mould.need_contract_stone_num)
            if prop_item_resoure_type_6 > 0 then 
                if zstring.tonumber(get_prop_amount(351)) < zstring.tonumber(prop_item_resoure_type_6) then 
                    is_can_qianyue = false
                end
            end
            if is_can_qianyue == false then 
                tip_Text:setString(tipStringInfo_hero_agreement_states[5])
                qianyue_button:setColor(cc.c3b(130, 130, 130))
            else
            end
    end
    if agreementStates == 1 and showType == 1 then 
        tip_Text:setString(tipStringInfo_hero_agreement_states[9])
        qianyue_button:setColor(cc.c3b(130, 130, 130))
        qianyue_button:setTouchEnabled(false)

    end
    if agreementStates == 2 and showType == 2 then 
        tip_Text:setString(tipStringInfo_hero_agreement_states[4]) 
    end
    
    local prop_item_num1 =dms.int(dms["contract_mould"], contract_id, contract_mould.need_prop_num1)
    local prop_item_num2 =dms.int(dms["contract_mould"], contract_id, contract_mould.need_prop_num2)
    local prop_item_num3 =dms.int(dms["contract_mould"], contract_id, contract_mould.need_prop_num3)
end

function AdventureMercenaryAgreementContract:onEnterTransitionFinish()
    self.roots = {}
    self.actions ={}
    local csbAdventureHeroAwaken = csb.createNode("packs/Mercenary/yongbing_qiyue_qianding.csb")
    local root = csbAdventureHeroAwaken:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureHeroAwaken)
    root:setTouchEnabled(false)
    local panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1_1")
    --local panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_1_1")
    self.alreadyAgreementAnimation = panel_1:getChildByName("ArmatureNode_yijie_open") -- 
    draw.initArmature(self.alreadyAgreementAnimation, nil, -1, 0, 1)
    csb.animationChangeToAction(self.alreadyAgreementAnimation, 0, 0, false)
    
    self.agreementSuccessAnimation = panel_1:getChildByName("ArmatureNode_yijie") -- 
    draw.initArmature(self.agreementSuccessAnimation, nil, -1, 0, 1)
    csb.animationChangeToAction(self.agreementSuccessAnimation, 0, 0, false)

    self:updateDraw()
    local action = csb.createTimeline("packs/Mercenary/yongbing_qiyue_qianding.csb")
    table.insert(self.actions, action)
    root:runAction(action)
    self.actions[1]:play("animation_fall",false)
    local layer = ccui.Helper:seekWidgetByName(root, "Panel_ybing_bg")
    self:onUpdateAgreementStates(1)

    self.agreementSuccessAnimation._invoke_w = function(armatureBack)
        if armatureBack:isVisible() == true then
            armatureBack:setVisible(false)
        end
    end   
    local function formationTouchListener(sender, eventType)
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
       
        if eventType == ccui.TouchEventType.began then
            self.touchBeganPos = sender:getTouchBeganPosition()
        elseif eventType == ccui.TouchEventType.moved then 
      
        else 
            local off = sender:getTouchEndPosition()

            if off.y - self.touchBeganPos.y > 10 then 
                if self.chooseType == 1 then 
                    self.actions[1]:stop()    
                    self.actions[1]:play("animation_up",false)
                    self.chooseType = 2
                    self:onUpdateAgreementStates(2)
                end
            end
            if self.touchBeganPos.y - off.y > 10 then
                
                if self.chooseType == 2 then 
                    self.actions[1]:stop()    
                    self.actions[1]:play("animation_down",false)
                    self.chooseType = 1
                    self:onUpdateAgreementStates(1)
                end
          end
        end
    end
 
    layer:setTouchEnabled(true)
    layer:addTouchEventListener(formationTouchListener)
 --local listener = cc.EventListenerTouchAllAtOnce:create()
    -- layer:setTouchEnabled(true)
    -- --layer:setSwallowTouches(false)
    -- listener:registerScriptHandler(function(touches, event)
    --     print("began")
    --     for i, v in pairs(touches) do
    --         table.insert(self.touches, v)
    --         v:retain()
    --     end

    -- end, cc.Handler.EVENT_TOUCHES_BEGAN)

    -- listener:registerScriptHandler(function(touches, event)
    --     print("---mvoe")
    --     local winSize = self:getContentSize() --cc.Director:getInstance():getWinSize();
    --     if #self.touches == 2 then-- 多点进行缩放
    --         -- 得到当前两触摸点
    --         local point1 = self.touches[1]:getLocation();
    --         local point2 = self.touches[2]:getLocation();

    --         -- 计算两点之间得距离
    --         local currDistance = cc.pGetDistance(point1, point2) -- point1.distance(point2);

    --         -- debug.print_r(self.currentInnerContainerOrigin)
    --     elseif #self.touches == 1 then-- 单点进行移动
    --         -- 单点时，touches中只有一个Touch对象，所以通过touches[0]就可以得到触摸对象
    --         local touch = self.touches[1]

    --         -- 计算滑动过程中的滑动增量
    --         local diff = touch:getDelta()
    --         debug.print_r(diff)
           
    --     end

   
    -- end, cc.Handler.EVENT_TOUCHES_MOVED)

    -- listener:registerScriptHandler(function(touches, event)
    --     print("---dend")
    --     for m, n in pairs(self.touches) do
    --         n:release()
    --     end
    --    self.touches = {}
      
    -- end, cc.Handler.EVENT_TOUCHES_ENDED)

    -- local eventDispatcher = layer:getEventDispatcher()
    -- eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    
    -- 点击选择
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        terminal_name = "adventure_mercenary_agreement_choose_open",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --弹出签订确认界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),       nil, 
    {
        terminal_name = "adventure_mercenary_agreetment_confirm_open",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- self:registerOnNoteUpdate(self, 0)
    -- self:registerOnNodeEvent(self)
    
end

function AdventureMercenaryAgreementContract:onExit()
    state_machine.remove("adventure_mercenary_agreement_choose_open")
    state_machine.remove("adventure_mercenary_agreetment_confirm_open")
    state_machine.remove("adventure_mercenary_agreetment_confirm_ok_update") 
end
