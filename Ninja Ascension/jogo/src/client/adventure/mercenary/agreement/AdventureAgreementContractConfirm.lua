-- ----------------------------------------------------------------------------------------------------
-- 说明：确定签订契约界面
-------------------------------------------------------------------------------------------------------
AdventureAgreementContractConfirm = class("AdventureAgreementContractConfirmClass", Window)
    
function AdventureAgreementContractConfirm:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.hero = nil
    self.agreementType = 0 --1显示一阶2 显示二阶
    self.list_huode = nil
    self.is_enough_stuff = true
    --app.load("client.loader.formula")

    -- Initialize adventure hero awaken state machine.
    local function init_adventure_mercenary_agreement_terminal()
        -- 确定签约
        local adventure_mercenary_agreedment_confirm_ok_terminal = {
            _name = "adventure_mercenary_agreedment_confirm_ok",
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
                local function responseMakeContractCallBack(response) 
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            -- instance:updateDraw()
                            -- instance:onUpdateAgreementStates(self.agreementType)
                            fwin:close(fwin:find("AdventureAgreementContractConfirmClass"))
                            state_machine.excute("adventure_mercenary_agreetment_confirm_ok_update",0,0)
                        end
                    end
                end            

                protocol_command.make_contract.param_list = "" .. instance.hero.ship_id .."\r\n".. instance.agreementType 
                NetworkManager:register(protocol_command.make_contract.code, nil, nil, nil, instance, responseMakeContractCallBack, false, nil)
            return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_mercenary_agreedment_confirm_ok_terminal)
        state_machine.init()
    end
    
    -- call func init adventure hero awaken state machine.
    init_adventure_mercenary_agreement_terminal()
end

function AdventureAgreementContractConfirm:init(hero,agreementType)
    self.hero = hero
    self.agreementType = agreementType
    return self
end

function AdventureAgreementContractConfirm:checkContract()
    local isCan = false
    local agreementStates = zstring.tonumber(self.hero.agreementStates)
    if agreementStates == 0 and self.agreementType == 2 then 
        return false
    end

    return true
end

function AdventureAgreementContractConfirm:onUpdateAgreementStates(showType)
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local tilte_text = ccui.Helper:seekWidgetByName(root, "Text_anniu")
    if showType == 1 then 
        contract_id =dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.price)
    else
        contract_id =dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.need_honor)
    end
    local tip_Text = ccui.Helper:seekWidgetByName(root, "Text_anniu")
    if contract_id == -1 and showType == 2 then 
        tip_Text:setString(tipStringInfo_hero_agreement_states[11])
        return
    end
    local agreementStates = zstring.tonumber(self.hero.agreementStates)
    
    if agreementStates == 0 then 
        --一阶未签约
        tip_Text:setString(tipStringInfo_hero_agreement_states[1])
        if self.is_enough_stuff == false then 
            tip_Text:setString(tipStringInfo_hero_agreement_states[5])
        end
    end
    if agreementStates == 1 and showType == 1 then 
        tip_Text:setString(tipStringInfo_hero_agreement_states[9])
    end
    if agreementStates == 2 and showType == 2 then 
        tip_Text:setString(tipStringInfo_hero_agreement_states[4]) 
    end
  
end

function AdventureAgreementContractConfirm:updateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local contract_id = 0
    local Text_tile = ccui.Helper:seekWidgetByName(root, "Text_paixu")
    if self.agreementType == 1 then 
        contract_id =dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.price)
        Text_tile:setString(tipStringInfo_hero_agreement_states[6])
    else
        contract_id =dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.need_honor)
        Text_tile:setString(tipStringInfo_hero_agreement_states[7])
    end
    if contract_id == -1 then 
        --不能签约
        return
    end
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

    local is_can_qianyue = true
    for i=1,3 do
        local Panel = ccui.Helper:seekWidgetByName(root, "Panel_38_" .. i)
        local name_text = ccui.Helper:seekWidgetByName(Panel, "Text_name")
        local prop_Panel = ccui.Helper:seekWidgetByName(Panel, "Panel_39")
        local num_text = ccui.Helper:seekWidgetByName(Panel, "Text_shuliang")
        prop_Panel:removeAllChildren(true)
        if i <= #contract_data then 
            local one_data = contract_data[i]
            local mould_data = dms.element(dms["prop_mould"], one_data.consume_id)
            if mould_data~= nil then 
                local picIndex = dms.atos(mould_data, prop_mould.pic_index)
                prop_Panel:setBackGroundImage(string.format("images/ui/props/porps_%d.png", zstring.tonumber(picIndex)))
                name_text:setString(dms.atos(mould_data, prop_mould.prop_name))
                num_text:setString("" .. get_prop_amount(one_data.consume_id) .. "/" .. one_data.consume_value)
                if zstring.tonumber(one_data.consume_value) > zstring.tonumber(get_prop_amount(one_data.consume_id)) then 
                    self.is_enough_stuff = false
                end
            end                
        else
           name_text:setString("")
           num_text:setString("")
        end
    end
    local _width = 0
    local _nCount = 0
    
    local rewardItems = {}
    self.list_huode:removeAllItems()
    
    local prop_item_resoure_type_5 =dms.int(dms["contract_mould"], contract_id, contract_mould.need_soul_count)
    if prop_item_resoure_type_5 > 0 then
        local cell = adventureNewSmallPropIconCell:createCell()
        cell:init(0, {resource_type = 4} , "" .. getResourceValueToStringForAdventure(prop_item_resoure_type_5), nil, 0, 0)
        
        self.list_huode:addChild(cell)
        _nCount = _nCount + 1
        if zstring.tonumber(_ED.user_info.soul) < zstring.tonumber(prop_item_resoure_type_5)  then                 
            self.is_enough_stuff = false
        end
    end
    
    local prop_item_resoure_type_6 =dms.int(dms["contract_mould"], contract_id, contract_mould.need_contract_stone_num)
    if prop_item_resoure_type_6 > 0 then 
       local cell = adventureNewSmallPropIconCell:createCell()
        
        cell:init(0, {mould_id = "351"} , "" .. getResourceValueToStringForAdventure(prop_item_resoure_type_6), nil, 0, 0)
        self.list_huode:addChild(cell)
        _nCount = _nCount + 1 
        if zstring.tonumber(get_prop_amount(351)) < zstring.tonumber(prop_item_resoure_type_6) then 
            self.is_enough_stuff = false
        end
    end

    if self.list_huode._x == nil then
        self.list_huode._x = self.list_huode:getPositionX()
    end
    self.list_huode:setPositionX(self.list_huode._x - (80 + self.list_huode:getItemsMargin()) * (_nCount - 1) / 2)
    
    self.list_huode:requestRefreshView()      
end

function AdventureAgreementContractConfirm:onEnterTransitionFinish()
    local csbAdventureHeroAwaken = csb.createNode("packs/Mercenary/yongbing_qiyue_qiandingqueren.csb")
    local root = csbAdventureHeroAwaken:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureHeroAwaken)
    self.list_huode = ccui.Helper:seekWidgetByName(root, "ListView_1")
    self.is_enough_stuff = true
    self:updateDraw()
    self:onUpdateAgreementStates(self.agreementType)
    -- 点击选择
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pingzhi"),       nil, 
    {
        terminal_name = "adventure_mercenary_agreedment_confirm_ok",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureAgreementContractConfirmClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

end

function AdventureMercenaryAgreementContract:onExit()
    state_machine.remove("adventure_mercenary_agreedment_confirm_ok")
end
