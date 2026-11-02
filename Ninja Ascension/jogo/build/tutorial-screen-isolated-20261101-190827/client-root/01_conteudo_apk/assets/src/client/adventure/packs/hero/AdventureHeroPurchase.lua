-- ----------------------------------------------------------------------------------------------------
-- 说明：武将重新招募
-------------------------------------------------------------------------------------------------------
AdventureHeroPurchase = class("AdventureHeroPurchaseClass", Window)

function AdventureHeroPurchase:ctor()
    self.super:ctor()
    self.roots = {}

    self.hero = nil
    self.soul_stone_id = nil
    app.load("client.adventure.cells.prop.adventure_new_prop_activity_icon_cell")
    -- Initialize adventure hero purchase state machine.
    local function init_adventure_hero_purchase_terminal()
        -- 通过战船模板ID来招募
        local adventure_hero_purchase_recruit_with_ship_id_terminal = {
            _name = "adventure_hero_purchase_recruit_with_ship_id",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseShipPurchaseCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then

                            state_machine.excute("adventure_mercenary_hero_handbook_date_update", 0, {shipId = instance.hero.ship_template_id})
                            state_machine.excute("adventure_hero_information_update_soul_stone", 0, {shipId = instance.hero.ship_template_id})
                            response.node.selectCell:updateDraw()
                            _ED.hero_handbook["" .. response.node.hero.ship_template_id].is_new = true
                            app.load("client.adventure.shop.recruit.AdventureRecruitSuccess")
                            fwin:open(AdventureRecruitSuccess:new():init(), fwin._ui)
                            fwin:close(fwin:find("AdventureHeroPurchaseClass"))
                        end
                    end
                end

                protocol_command.ship_purchase.param_list = "" .. instance.hero.ship_template_id
                NetworkManager:register(protocol_command.ship_purchase.code, nil, nil, nil, instance, responseShipPurchaseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_hero_purchase_combining_with_prop_id_terminal = {
            _name = "adventure_hero_purchase_combining_with_prop_id",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseSouleStoneCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("adventure_mercenary_hero_handbook_date_update", 0, {shipId = instance.hero.ship_template_id})
                            state_machine.excute("adventure_hero_information_update_soul_stone", 0, {shipId = instance.hero.ship_template_id})
                            response.node:onUpdateStates(2)
                            TipDlg.drawTextDailog(_string_piece_info[436])


                        end
                    end
                end

                protocol_command.cast_soul_stone.param_list = "" .. instance.soul_stone_id
                NetworkManager:register(protocol_command.cast_soul_stone.code, nil, nil, nil, instance, responseSouleStoneCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新标签页
        local adventure_hero_purchase_manager_terminal = {
            _name = "adventure_hero_purchase_manager",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setColor(cc.c3b(130, 130, 130))
                    terminal.select_button:setHighlighted(false)
                    terminal.select_button:setTouchEnabled(true)
                end
                if params._datas.current_button_name ~= nil or params._datas.current_button_name ~= "" then
                    terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
                end
                if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                    terminal.select_button:setColor(cc.c3b(255, 255, 255))
                    terminal.select_button:setHighlighted(true)
                    terminal.select_button:setTouchEnabled(false)
                end
                instance:onUpdateStates(tonumber(params._datas.current_button_type))
               
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(adventure_hero_purchase_manager_terminal)
        state_machine.add(adventure_hero_purchase_recruit_with_ship_id_terminal)
        state_machine.add(adventure_hero_purchase_combining_with_prop_id_terminal)
        
        state_machine.init()
    end
    
    -- call func init adventure hero purchase state machine.
    init_adventure_hero_purchase_terminal()
end

function AdventureHeroPurchase:init(hero, selectCell)
    self.hero = hero
    self.mould_data = hero.mould_data or dms.element(dms["ship_mould"], self.hero.ship_template_id)
    self.selectCell = selectCell
    return self
end

function AdventureHeroPurchase:onUpdateStates(pageIndex)
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local Panel_hecheng = ccui.Helper:seekWidgetByName(root, "Panel_hecheng")
    if pageIndex == 1 then 
        --重新召唤

        -- 绘制武将图标
        local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
        Panel_role:removeAllChildren(true)
        local cell = AdventureHeroIconCell:createCell()
        local handbook = _ED.hero_handbook["" .. self.hero.ship_template_id]
        cell:init(0, {ship_template_id = self.hero.ship_template_id}, 1, 0, nil, nil, nil, nil, 1)
        Panel_role:addChild(cell)
        local prop_id = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.way_of_gain)
        local need_soul_count = dms.int(dms["soul_stone_call_param"], prop_id, soul_stone_call_param.need_soul_count) --碎片数量
        local need_stone_count = dms.int(dms["soul_stone_call_param"], prop_id, soul_stone_call_param.need_prop_num) --需要灵魂石
        local need_props_id = dms.int(dms["soul_stone_call_param"], prop_id, soul_stone_call_param.need_prop_mould)
        local is_can_zhaohun = true
        -- 绘制武将的名称
        local props_name = dms.string(dms["prop_mould"], need_props_id, prop_mould.prop_name) 
        local heroName =dms.string(dms["ship_mould"], self.hero.ship_template_id, ship_mould.captain_name)
        local soule_num_text = ccui.Helper:seekWidgetByName(root, "Text_22")
        ccui.Helper:seekWidgetByName(root, "Text_linghun_name"):setString(heroName)
   
        local prop_soul_id = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.refine_get_jade)
        local current_soul_num = _ED.user_prop_soul_stone["".. prop_soul_id]

        if current_soul_num ~= nil then 
            --有灵魂石
            if zstring.tonumber(current_soul_num) >= zstring.tonumber(need_stone_count) then 
                --有足够的灵魂石
                soule_num_text:setColor(cc.c3b(255, 255, 255))
            else
                soule_num_text:setColor(cc.c3b(255, 37, 37))
                is_can_zhaohun = false
            end
        else
            --没有灵魂石
            current_soul_num = 0
            is_can_zhaohun = false
        end
        local is_can_soul = true
        if zstring.tonumber(_ED.user_info.soul) >= zstring.tonumber(need_soul_count)  then 
            is_can_soul = true
        else
            is_can_soul = false
        end

        --soule_num_text:setString("".. _ED.user_info.soul .. "/" .. need_stone_count)
        soule_num_text:setString("".. current_soul_num .. "/" .. need_stone_count)
        -- 将魂
        ccui.Helper:seekWidgetByName(root, "Text_suipian"):setString("" .. need_soul_count)
        Panel_hecheng:setVisible(false)
        local zhaohuan_Button = ccui.Helper:seekWidgetByName(root, "Button_17")
        if is_can_zhaohun == true and is_can_soul == true then 
            -- 可以合成
            zhaohuan_Button:setTitleText(_string_piece_info[439])
            zhaohuan_Button:setColor(cc.c3b(255, 255, 255))
            zhaohuan_Button:setTouchEnabled(true)
        else    
            zhaohuan_Button:setTitleText(tipStringInfo_hero_agreement_states[5])
            zhaohuan_Button:setColor(cc.c3b(130, 130, 130))
            zhaohuan_Button:setTouchEnabled(false)
        end
    else
        --灵魂石合成
        local prop_id = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.refine_get_jade)
        local soul_id = dms.int(dms["prop_mould"], prop_id, prop_mould.use_of_ship)   
        local hecheng_Button = ccui.Helper:seekWidgetByName(root, "Button_suipian")
        hecheng_Button:setColor(cc.c3b(255, 255, 255))
        hecheng_Button:setTouchEnabled(true)
        if prop_id == -1 or soul_id == -1 then 

            Panel_hecheng:setVisible(true)
            return
        end


        -- local Panel_role = ccui.Helper:seekWidgetByName(root, "Panel_role_0")
        -- Panel_role:removeAllChildren(true)
        -- local cell = adventureNewSmallPropIconCell:createCell()
        -- cell:init(5, {mould_id = tonumber(prop_id)} ,nil,0,0)
        local button_text = ccui.Helper:seekWidgetByName(root,"Text_suip")
        
        -- Panel_role:addChild(cell)
        Panel_hecheng:setVisible(true)
        -- ship_mould ---第58个字段 prop_mould 
        
        local handbook = _ED.user_prop_soul_stone["" .. prop_id]
        if handbook ~= nil then 
            ccui.Helper:seekWidgetByName(root, "Text_yongyou_num"):setString(string.format(_string_piece_info[438],"" .. handbook))
        else
            ccui.Helper:seekWidgetByName(root, "Text_yongyou_num"):setString(string.format(_string_piece_info[438],"0"))
        end
        
        local heroName =dms.string(dms["ship_mould"], self.hero.ship_template_id, ship_mould.captain_name)
        ccui.Helper:seekWidgetByName(root, "Text_role_name_1"):setString(string.format(_string_piece_info[437],heroName))
        local handbook1 = _ED.hero_handbook["" .. self.hero.ship_template_id]
        if handbook1 == nil then 
            --没有开启过这个英雄
            ccui.Helper:seekWidgetByName(root, "Panel_21"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Text_huode_no"):setVisible(true)
            button_text:setString(tipStringInfo_hero_agreement_states[5])
            hecheng_Button:setColor(cc.c3b(130, 130, 130))
            hecheng_Button:setTouchEnabled(false)
            return
        end
        ccui.Helper:seekWidgetByName(root, "Panel_21"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_huode_no"):setVisible(false)
        self.soul_stone_id = soul_id
        local need_prop_id = 
        {
            tonumber(dms.int(dms["soul_stone_synthesis_param"], soul_id, soul_stone_synthesis_param.need_prop_mould1)),
            tonumber(dms.int(dms["soul_stone_synthesis_param"], soul_id, soul_stone_synthesis_param.need_prop_mould2)),
            tonumber(dms.int(dms["soul_stone_synthesis_param"], soul_id, soul_stone_synthesis_param.need_prop_mould3)),
            tonumber(dms.int(dms["soul_stone_synthesis_param"], soul_id, soul_stone_synthesis_param.need_prop_mould4)),
            tonumber(dms.int(dms["soul_stone_synthesis_param"], soul_id, soul_stone_synthesis_param.need_prop_mould5)),
        }

        local need_prop_num = 
        {
            tonumber(dms.int(dms["soul_stone_synthesis_param"], soul_id, soul_stone_synthesis_param.need_prop_num1)),
            tonumber(dms.int(dms["soul_stone_synthesis_param"], soul_id, soul_stone_synthesis_param.need_prop_num2)),
            tonumber(dms.int(dms["soul_stone_synthesis_param"], soul_id, soul_stone_synthesis_param.need_prop_num3)),
            tonumber(dms.int(dms["soul_stone_synthesis_param"], soul_id, soul_stone_synthesis_param.need_prop_num4)),
            tonumber(dms.int(dms["soul_stone_synthesis_param"], soul_id, soul_stone_synthesis_param.need_prop_num5)),
        }
        local iscan_hecheng = true
        for i=1,5 do
            local panelName = "Panel_prop" .. i 
            local Panel_prop = ccui.Helper:seekWidgetByName(root,panelName)
            Panel_prop:setVisible(false)
            Panel_prop:removeAllChildren()
            if i <= #need_prop_id  then 
                Panel_prop:setVisible(true)
                local cell = adventureNewSmallPropIconCell:createCell()
                if zstring.tonumber(need_prop_num[i]) > get_prop_amount(need_prop_id[i]) then
                    iscan_hecheng = false
                end
                cell:init(0, {mould_id = need_prop_id[i]} ,"" .. getResourceValueToStringForAdventure(need_prop_num[i]), nil, 0, 0, nil, {show_quantity = true})
                Panel_prop:addChild(cell)
            end
        end
        local jinb_panel = ccui.Helper:seekWidgetByName(root,"Panel_prop6")
        jinb_panel:removeAllChildren()  
        local cell = adventureNewSmallPropIconCell:createCell()
        local jinbi = dms.int(dms["soul_stone_synthesis_param"], soul_id, soul_stone_synthesis_param.need_silver)
        cell:init(0, {resource_type = 1} , "" .. getResourceValueToStringForAdventure(jinbi), nil, 0, 0)
        jinb_panel:addChild(cell)   
        if jinbi > zstring.tonumber(_ED.user_info.user_silver) then 
            iscan_hecheng = false
        end

        local rysp_panel = ccui.Helper:seekWidgetByName(root,"Panel_prop7")
        rysp_panel:removeAllChildren()
        local cell = adventureNewSmallPropIconCell:createCell()
        local ryspNum = dms.int(dms["soul_stone_synthesis_param"], soul_id, soul_stone_synthesis_param.need_soul_count)
        if ryspNum > zstring.tonumber(_ED.user_info.soul) then 
            iscan_hecheng = false
        end
        cell:init(0, {resource_type = 4} , "" .. getResourceValueToStringForAdventure(ryspNum), nil, 0, 0)
        rysp_panel:addChild(cell)

        if iscan_hecheng == true then 
            --可以合成
            button_text:setString(tipStringInfo_hero_agreement_states[18])
            hecheng_Button:setColor(cc.c3b(255, 255, 255))
            hecheng_Button:setTouchEnabled(true)
        else
            button_text:setString(tipStringInfo_hero_agreement_states[5])
            hecheng_Button:setColor(cc.c3b(130, 130, 130))
            hecheng_Button:setTouchEnabled(false)
        end
    end       
end

function AdventureHeroPurchase:onEnterTransitionFinish()
    local csbAdventureHeroPurchase = csb.createNode("packs/Mercenary/hero_recall.csb")
    local root = csbAdventureHeroPurchase:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureHeroPurchase)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureHeroPurchaseClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 重新招募
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_17"),       nil, 
    {
        terminal_name = "adventure_hero_purchase_recruit_with_ship_id",    
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 开始合成
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_suipian"),       nil, 
    {
        terminal_name = "adventure_hero_purchase_combining_with_prop_id",    
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    --重新召唤
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhaohuan"),       nil, 
    {
        terminal_name = "adventure_hero_purchase_manager",     
        current_button_name = "Button_zhaohuan",  
        current_button_type = 1 ,      
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)

    local hechengButton = ccui.Helper:seekWidgetByName(root, "Button_linghunshi")
    hechengButton:setColor(cc.c3b(130, 130, 130))
    hechengButton:setHighlighted(false)
    hechengButton:setTouchEnabled(true)
    --灵魂石合成
    fwin:addTouchEventListener(hechengButton,       nil, 
    {
        terminal_name = "adventure_hero_purchase_manager",     
        current_button_name = "Button_linghunshi",  
        current_button_type = 2 ,      
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)
    state_machine.excute("adventure_hero_purchase_manager", 0, 
        {_datas ={
            current_button_name = "Button_zhaohuan",        
            current_button_type = 1 ,      
            terminal_state = 0, 
            isPressedActionEnabled = true
        }}
        )

end

function AdventureHeroPurchase:onExit()
    state_machine.remove("adventure_hero_purchase_recruit_with_ship_id")
    state_machine.remove("adventure_hero_purchase_manager")
    state_machine.remove("adventure_hero_purchase_combining_with_prop_id")
end
