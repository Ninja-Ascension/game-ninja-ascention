-- ----------------------------------------------------------------------------------------------------
-- 说明：武将战斗阵型
-------------------------------------------------------------------------------------------------------
AdventureBattleFormation = class("AdventureBattleFormationClass", Window)
AdventureBattleFormation.__down_index = 0
function AdventureBattleFormation:ctor()
    self.super:ctor()
    self.roots = {}

	self.indexs = 0
	self.heroList = {}
    self.heroCellList = {}
    self.maxHeroList = 0 
    self.selectedHero = nil
    self.selcetIndex = -1
	self.choiceIndex = 1
    self.selcetCell = nil
	self.currentScrollView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    -- 显示数据标签
    self.textAttack = nil	 -- 攻击
    self.textDefense = nil	 -- 防御
    self.textDodge = nil 	 -- 闪避
    self.textKing = nil 	 -- 王者
    self.Panel_tip = nil

	
	app.load("client.adventure.cells.hero.adventure_hero_formation_icon_cell")
	app.load("client.adventure.cells.hero.adventure_hero_checkpoint_cell")
	app.load("client.adventure.cells.skill.adventure_skill_icon_cell")
	app.load("client.adventure.mercenary.formation.AdventureMercenaryheroInfo")
    -- Initialize adventure battle formation state machine.
    local function init_adventure_battle_formation_terminal()
        --点击更换
        local adventure_battle_formation_change_terminal = {
            _name = "adventure_battle_formation_change",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                state_machine.excute("adventure_battle_formation_change_open_hero_list", 0, self.selcetCell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --选中英雄后,赋值
        local adventure_battle_formation_select_hero_terminal = {
            _name = "adventure_battle_formation_select_hero",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local heroIndex = zstring.tonumber(params._datas.cell.drawIndex)
                self.selcetCell = params
                self.selcetIndex = heroIndex
                if self.heroList[heroIndex] ~= nil then 
                    instance.selectedHero = self.heroList[heroIndex]
                else
                    instance.selectedHero = nil
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --购买阵型4
        local adventure_battle_formation_open_lock_four_fomation_terminal = {
            _name = "adventure_battle_formation_open_lock_four_fomation",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params == 1 then 
                    --需要购买
                    app.load("client.adventure.campaign.arena.warcraft.AdventureArenaWarcraftRefreshRival")
                    fwin:open(AdventureArenaWarcraftRefreshRival:new():init(3), fwin._windows)
                else
                    --购买成功 刷新
                    ccui.Helper:seekWidgetByName(instance.roots[1], "Image_lock_4"):setVisible(false)
                    
                    state_machine.excute("adventure_battle_formation_change_mananger", 0, 
                        {_datas ={
                            current_button_name = "Button_zr_4",      
                            current_button_type = 4 ,      
                            terminal_state = 0, 
                            isPressedActionEnabled = true
                    }}
                    )
                end
                 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		


        --切换阵容
        local adventure_battle_formation_change_mananger_terminal = {
            _name = "adventure_battle_formation_change_mananger",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params._datas.current_button_type == 2 then 
                    if funOpenConditionJudge(64) == false then
                        TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 64, fun_open_condition.tip_info))
                        return
                    end
                end
                if params._datas.current_button_type == 3 then 
                    if funOpenConditionJudge(65) == false then
                        TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 65, fun_open_condition.tip_info))
                        return
                    end
                end
                if params._datas.current_button_type == 4 then 
                    if _ED.formation_four_open_states == 0 then  
                        --没有购买
                        state_machine.excute("adventure_battle_formation_open_lock_four_fomation",0,1)
                        return
                    end
                end
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
                
                state_machine.excute("adventure_battle_formation_confirm_formation", 0, params._datas.current_button_type)  
                
                return true
            end,
            _terminal = nil,
            _terminals = nil,
        }

		-- 更换佣兵 打开上阵列表
        local adventure_battle_formation_change_open_hero_list_terminal = {
            _name = "adventure_battle_formation_change_open_hero_list",
            _init = function (terminal)
                app.load("client.adventure.mercenary.formation.AdventureMercenaryHeroBattle")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureMercenaryHeroBattle:new():init(
                    self.indexs,params._datas.cell.drawIndex,params._datas.cell.isEmpty), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 刷新
        local adventure_battle_formation_update_draw_terminal = {
            _name = "adventure_battle_formation_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDrawFromation(instance.indexs)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 打开四维属性面板
        local adventure_battle_formation_open_siwei_dialog_terminal = {
            _name = "adventure_battle_formation_open_siwei_dialog",
            _init = function (terminal)
                app.load("client.adventure.mercenary.formation.AdventureMercenarySiweiDialog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:open(AdventureMercenarySiweiDialog:new():init(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 刷新技能属性
        local adventure_battle_formation_update_draw_skill_terminal = {
            _name = "adventure_battle_formation_update_draw_skill",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				self.choiceIndex = params._datas.cell.drawIndex
				state_machine.excute("adventure_mercenary_package_sort_update_attribute_info", 0, self.heroList[self.choiceIndex])	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --确定出战阵型
        local adventure_battle_formation_confirm_formation_terminal = {
            _name = "adventure_battle_formation_confirm_formation",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if zstring.tonumber(instance.indexs) == params then 
                    return
                end
                local function responseChangeFormationIndexCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        instance:onUpdateDrawFromation(zstring.tonumber(_ED.formetion_index))
                        TipDlg.drawTextDailog( string.format(_string_piece_info[466], zstring.tonumber(_ED.formetion_index)))
                        state_machine.excute("adventure_mercenary_update_empty", 0, "adventure_mercenary_update_empty.")
                    end
                end
        
                protocol_command.switch_formation.param_list = params
                NetworkManager:register(protocol_command.switch_formation.code, nil, nil, nil, nil, responseChangeFormationIndexCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --下阵
        local adventure_battle_formation_change_the_battle_terminal = {
            _name = "adventure_battle_formation_change_the_battle",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                AdventureBattleFormation.__down_index = 0
                if self.selectedHero == nil then 
                    
                    return
                end
                local function responseChoiceHeroBattleCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then                        
                        -- _ED.formetion_list[self.formIndex][indexs+1] = "0"
                        --!!!!这个地方要注意了.下阵的时候需要特殊处理,现在阵型显示全部用_ED.formation 显示
                        table.remove(_ED.formetion_list[self.indexs],AdventureBattleFormation.__down_index+1)
                        table.insert(_ED.formetion_list[self.indexs], self.maxHeroList +1,"0")
                        -- table.remove(_ED.formetion,AdventureBattleFormation.__down_index+1)
                        -- table.insert(_ED.formetion,self.maxHeroList +1,"0")

                        instance:onUpdateDrawFromation(instance.indexs)

                        --state_machine.excute("adventure_battle_formation_update_draw", 0, nil)
                        state_machine.excute("adventure_mercenary_update_empty", 0, "adventure_mercenary_update_empty.")
                    end
                end
                
                for j ,v in pairs(self.heroList) do
                    if zstring.tonumber(v.ship_id) == zstring.tonumber(self.selectedHero.ship_id) then
                        AdventureBattleFormation.__down_index = j
                        break
                    end
                end
                
                local str = ""
                str = str..AdventureBattleFormation.__down_index.."\r\n"   --放入阵型位置 (1 ~ 21)
                str = str.."-1\r\n" --战船ID
                str = str..self.indexs.."\r\n"  --阵型ID
                str = str.."1"
                protocol_command.formation_change.param_list = str
                NetworkManager:register(protocol_command.formation_change.code, nil, nil, nil, nil, responseChoiceHeroBattleCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(adventure_battle_formation_open_siwei_dialog_terminal)
        state_machine.add(adventure_battle_formation_change_terminal)
        state_machine.add(adventure_battle_formation_change_open_hero_list_terminal)
        state_machine.add(adventure_battle_formation_update_draw_terminal)
        state_machine.add(adventure_battle_formation_update_draw_skill_terminal)
        state_machine.add(adventure_battle_formation_change_mananger_terminal)
        state_machine.add(adventure_battle_formation_change_the_battle_terminal)
        state_machine.add(adventure_battle_formation_select_hero_terminal)
        state_machine.add(adventure_battle_formation_confirm_formation_terminal)
        state_machine.add(adventure_battle_formation_open_lock_four_fomation_terminal)
        state_machine.init()
    end
    
    -- call func init adventure battle formation state machine.
    init_adventure_battle_formation_terminal()
end

function AdventureBattleFormation:init()
    return self
end

function AdventureBattleFormation:onUpdate(dt)
	if self.currentScrollView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentScrollView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentScrollView:getChildren()
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



function AdventureBattleFormation:onUpdateDrawFromation(show_index)
    local root = self.roots[1]

    local lockMoveHero = false
    local began_pos = nil
    local isChangeFormation = false
    local began_hero_position = nil
    local began_hero_ZOrder = nil
    local began_heroSprite = nil
    local began_heroCell = nil
    local end_pos = nil
    local changedHero = nil
    local beganHero = nil

    self.heroList = {}
    self.heroCellList = {}
    self.maxHeroList = 0
    local isEmpty = true
    self.indexs = show_index

    if _ED.formetion_list[self.indexs] ~= nil then 
        for i,w in pairs(_ED.formetion) do
            if i>1 then
                for z, r in pairs(_ED.user_ship) do
                    if zstring.tonumber(w) == zstring.tonumber(r.ship_id) then
                        table.insert(self.heroList, r)
                        self.maxHeroList = self.maxHeroList + 1
                    end
                end
                if zstring.tonumber(w) == 0 then
                    table.insert(self.heroList, {ship_template_id = 0})
                    isEmpty = true
                end
                if zstring.tonumber(w) == -1 and isEmpty == true then
                    isEmpty = false
                    table.insert(self.heroList, {ship_template_id = 0})
                end
            end
        end
    end
    
    ----------------拖动-----------------------------------------------------------------------------------------------

    local function executeMoveHeroOverFunc()
        lockMoveHero = false
        isChangeFormation = false
        began_pos = nil
    end
    
    local function formationChangeTouchListener(sender, eventType)
        if isChangeFormation == true or lockMoveHero == true then
            return
        end

        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        
        if eventType == ccui.TouchEventType.began then
            local AdventureBattle = fwin:find("AdventureBattleFormationClass")
            if nil == AdventureBattle then
                return
            end
            local items = self.heroCellList
            for pos, heroCard in pairs(items) do
                local bPosition = heroCard:convertToNodeSpace(cc.p(__spoint.x, __spoint.y))
                if ( bPosition.x >0 and bPosition.x <  heroCard:getContentSize().width and bPosition.y > 0 and bPosition.y < heroCard:getContentSize().height ) then
                    began_pos = pos
                    began_heroSprite = heroCard
                    local tempX, tempY  = heroCard:getPosition()
                    began_hero_position = cc.p(tempX, tempY)
                    began_hero_ZOrder = heroCard:getLocalZOrder()
                    local parent_node = began_heroSprite:getParent()
                    beganHero = parent_node 
                    parent_node:reorderChild(began_heroSprite, 100)
                    parent_node:getParent():reorderChild(parent_node, 100)
                end
            end
        elseif eventType == ccui.TouchEventType.moved then
            if began_pos == nil then
                return
            end
            if nil ~= began_heroSprite then
                began_heroSprite:setPosition(cc.p( (__mpoint.x - __spoint.x) / app.scaleFactor + began_hero_position.x , (__mpoint.y - __spoint.y) / app.scaleFactor + began_hero_position.y))
            end
            
        elseif eventType == ccui.TouchEventType.ended
            or eventType == ccui.TouchEventType.canceled then
            if began_pos == nil then
                return
            end
            -- if nil ~= began_heroSprite then
                -- began_heroSprite:setPosition(cc.p(began_hero_position.x , began_hero_position.y))
            -- end
            local isChanged = false
            local isSame = false
            local items = self.heroCellList
            local temp = cc.p(began_heroSprite:getContentSize().width/2, began_heroSprite:getContentSize().height/2)
            local e_position =  began_heroSprite:convertToWorldSpaceAR(cc.p(temp.x,temp.y))
            --if eventType == ccui.TouchEventType.ended then
            --changedHero = nil
            for pos, card_hero in pairs(items) do
                --if zstring.tonumber(card_hero.hero.ship_id) ~= zstring.tonumber(began_heroSprite.hero.ship_id) and zstring.tonumber(card_hero.hero.ship_id)~=0 then
                local bPosition = card_hero:convertToNodeSpaceAR(e_position)
            
                if ( bPosition.x >0 and bPosition.x <=  card_hero:getContentSize().width and 
                    bPosition.y > 0 and bPosition.y <= card_hero:getContentSize().height ) and
                   zstring.tonumber(card_hero.hero.ship_id) ~= zstring.tonumber(began_heroSprite.hero.ship_id) then
            
                    changedHero = card_hero
                    
                    -- end_pos =  pos
                    for j ,v in pairs(self.heroList) do
                        if zstring.tonumber(v.ship_id) == zstring.tonumber(changedHero.hero.ship_id)  and   
                            zstring.tonumber(card_hero.hero.ship_id)~=0  and zstring.tonumber(card_hero.hero.ship_id) ~= zstring.tonumber(began_heroSprite.hero.ship_id)
                            then
                
                            end_pos = j
                            isChanged = true
                            
                            break
                        end
                    end
                    -- change_heroSprite = items[end_pos]
                    --break
                end
                --else
                  
                --end
            end
            --end
            if changedHero ~= nil and zstring.tonumber(changedHero.hero.ship_id) == zstring.tonumber(began_heroSprite.hero.ship_id) then 
                isSame = true
            end
            if isChanged == false then
                if changedHero == nil and isSame == false then 
                    --找不到层叠的容器 判断完全不在拖动范围,自动下阵
                    --state_machine.excute("adventure_battle_formation_change_the_battle",0,0)
                end
                began_hero_position = cc.p(began_hero_position.x , began_hero_position.y)
                    -- began_heroSprite:runAction(cc.MoveTo:create(0.3, began_hero_position))
                    lockMoveHero = true
                    began_heroSprite:runAction(cc.Sequence:create(
                        cc.MoveTo:create(0.3, began_hero_position),
                        cc.DelayTime:create(0.2),
                        cc.CallFunc:create(executeMoveHeroOverFunc)
                    ))
                    local parent_node = began_heroSprite:getParent() 
                    parent_node:reorderChild(began_heroSprite, began_hero_ZOrder)
   
            elseif changedHero ~= nil then--zstring.tonumber(_ED.formetion[began_pos + 1]) > 0 then
                if isChanged == true then 
                    requestChangeFormation()
                end
                
            end
        end
    end
    
    local function responseChangeFormation(response)
        lockMoveHero = true
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            --self:onUpdateDraw()
            self:onUpdateDrawFromation(self.indexs)
            state_machine.excute("adventure_battle_formation_update_draw", 0, nil)
        else    
            began_hero_position = cc.p(began_hero_position.x , began_hero_position.y)
            -- began_heroSprite:runAction(cc.MoveTo:create(0.2, began_hero_position))
            began_heroSprite:runAction(cc.Sequence:create(
                cc.MoveTo:create(0.2, began_hero_position),
                cc.DelayTime:create(0.2),
                cc.CallFunc:create(executeMoveHeroOverFunc)
            ))
            -- 修改 Z轴
            local parent_node = began_heroSprite:getParent() 
            parent_node:reorderChild(began_heroSprite, began_hero_ZOrder)
        end
    end
    
    requestChangeFormation = function ()        
        local indexOne = 0
        local indexTwo = 0
        for j ,v in pairs(self.heroList) do
            if zstring.tonumber(v.ship_id) == zstring.tonumber(began_heroSprite.hero.ship_id) then
                indexOne = j
                break
            end
        end
        for j ,v in pairs(self.heroList) do
            if zstring.tonumber(v.ship_id) == zstring.tonumber(changedHero.hero.ship_id) then
                indexTwo = j
                break
            end
        end
                
        local str = ""
        local str = str..self.indexs.."\r\n"
        local str = str..indexOne.."\r\n"
        local str = str..indexTwo
        protocol_command.formation_exchange.param_list = str
        NetworkManager:register(protocol_command.formation_exchange.code, nil, nil, nil, nil, responseChangeFormation, false, nil)
        isChangeFormation = true
    end
    
    ------------------------拖动---------------------------------------------------------------------------------------

    local first = nil
    local shipid = ""
    local panle_role = ccui.Helper:seekWidgetByName(root, "Panel_role")
    for i=1,25 do
        local cellChild1 = panle_role:getChildByName("cell_".. i)
        local cellChild2 = panle_role:getChildByName("checkPoint_".. i)
        
        if cellChild1 ~= nil then 
            panle_role:removeChildByName("cell_".. i)
        end
        if cellChild2 ~= nil then 
            panle_role:removeChildByName("checkPoint_".. i)
        end
        local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_role_".. i)
        rolePanel:removeAllChildren(true)
        rolePanel:removeBackGroundImage()
    end

    ---计算上次选中操作的英雄索引
    if self.selcetIndex ~= -1 then
        if self.selcetIndex >= self.maxHeroList then 
            self.selcetIndex = self.maxHeroList
        end
    end
    for j ,v in pairs(self.heroList) do
        local childrolePanel = ccui.Helper:seekWidgetByName(root, "Panel_role_".. j)
        if childrolePanel == nil then 
            break
        end
        childrolePanel:setSwallowTouches(false)

        local cell = AdventureHeroFormationIconCell:createCell()
        cell:setName("cell_".. j)
        --print("----缩放:",childrolePanel:getScale())
        local checkpointcell = AdventureHeroCheckpointCell:createCell()
        checkpointcell:setName("checkPoint_".. j)
        if zstring.tonumber(v.ship_template_id) == 0 then
            if j == #self.heroList then
                cell:init(0, {ship_template_id = 1}, 99, 0, nil, nil, nil, nil, j)
                
                checkpointcell:init(j,3)
            else
                local shadow = cc.Sprite:create("images/ui/bg/shadow.png")
                shadow:setScale(0.5)
                
                childrolePanel:addChild(shadow, -1)
                shadow:setPosition(cc.p(childrolePanel:getContentSize().width /2,0 ))
                
                cell:init(3, {ship_template_id = 1}, 0, 0, nil, nil, nil, nil, j)
                checkpointcell:init(j,2)
            end
        else
            cell:init(5, v, 1, 0, nil, nil, v.ship_grade, nil, j)
            
            checkpointcell:init(j,1)
            cell.roots[1]:addTouchEventListener(formationChangeTouchListener)
            shipid = v.ship_id .. "," .. shipid
            local shadow = cc.Sprite:create("images/ui/bg/shadow.png")
            shadow:setScale(0.5)
            
            childrolePanel:addChild(shadow, -1)
            shadow:setPosition(cc.p(childrolePanel:getContentSize().width /2,0 ))

        end
        table.insert(self.heroCellList, cell)
        cell:setScale(childrolePanel:getScale())
        panle_role:addChild(cell,0)
        --cell:reorderChild(cell,50)
        panle_role:addChild(checkpointcell,10)
        checkpointcell:setPosition(cc.p(childrolePanel:getPositionX(),childrolePanel:getPositionY()))
        cell:setPosition(cc.p(childrolePanel:getPositionX(),childrolePanel:getPositionY()))
        
        if j == 1 and self.selcetIndex == -1 then
            first = cell
            self.choiceIndex = j
        else
            if self.selcetIndex == j  then 
                first = cell
                self.choiceIndex = j
            end
        end
    end
    shipid = string.sub(shipid,0,#shipid-1)
    local suminfo = recalcFormationBaseProperty(shipid)
    self.textAttack:setString(suminfo.speed)
    self.textDefense:setString(suminfo.defence)
    self.textDodge:setString(suminfo.avd)
    self.textKing:setString(suminfo.authority)
   
    if first ~= nil then
        AdventureHeroFormationIconCell.__ware_house_choose_cell = nil
        state_machine.excute("adventure_hero_icon_cell_show_hero_warehouse_larger_formation", 0, {_datas={cell = first}})
        state_machine.excute("adventure_battle_formation_select_hero", 0, {_datas={cell = first}})
    end                        
    local heros = self.heroList[self.choiceIndex]

    state_machine.excute("adventure_mercenary_package_sort_update_attribute_info", 0, heros)
end

function AdventureBattleFormation:onEnterTransitionFinish()
    local csbAdventureBattleFormation = csb.createNode("packs/Mercenary/yongbing_chuzhan.csb")
    local root = csbAdventureBattleFormation:getChildByName("root")
    table.insert(self.roots, root)
    -- 获取数值显示标签
    self.textAttack = ccui.Helper:seekWidgetByName(root, "Text_xiangong_1")
    self.textDefense = ccui.Helper:seekWidgetByName(root, "Text_fangyu_1")
    self.textDodge = ccui.Helper:seekWidgetByName(root, "Text_shanbi_1")
    self.textKing = ccui.Helper:seekWidgetByName(root, "Text_wangzhe_1")
    self:addChild(csbAdventureBattleFormation)
	fwin:open(AdventureMercenaryheroInfo:new():init(), fwin._windows)
	-- local pageView = ccui.Helper:seekWidgetByName(root, "PageView_role_1")
	
	-- local function pageViewEvent(sender, eventType)
	-- 	if eventType == ccui.PageViewEventType.turning then
	-- 		local pageView = sender
 --            local currentPageIndex = pageView:getCurPageIndex() + 1
	-- 		if self.indexs ~= currentPageIndex then
	-- 			self.indexs = currentPageIndex
	-- 			self.choiceIndex = 1
	-- 			self:onUpdateDraw()
	-- 		end
	-- 	end
	-- end
	-- pageView:addEventListener(pageViewEvent)
	self.choiceIndex = 1

    self:onUpdateDrawFromation(zstring.tonumber(_ED.formetion_index))
	
   self.Panel_tip = ccui.Helper:seekWidgetByName(root, "Panel_tip")
   self.Panel_tip:getParent():reorderChild(self.Panel_tip,150)

    local function formationTouchListener(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            self.Panel_tip:setVisible(true)
        elseif eventType == ccui.TouchEventType.moved then 
            
        elseif eventType == ccui.TouchEventType.ended then 
            self.Panel_tip:setVisible(false)
        else 
            self.Panel_tip:setVisible(false)
        end
    end
    local item2 = ccui.Helper:seekWidgetByName(root, "Image_3")
    
    item2:setTouchEnabled(true)
    item2:addTouchEventListener(formationTouchListener)

    if funOpenConditionJudge(64) == false then
        ccui.Helper:seekWidgetByName(root, "Image_lock_2"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Image_lock_2"):setVisible(false)
    end
    if funOpenConditionJudge(65) == false then
        ccui.Helper:seekWidgetByName(root, "Image_lock_3"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Image_lock_3"):setVisible(false)
    end

    if _ED.formation_four_open_states == 0 then
        ccui.Helper:seekWidgetByName(root, "Image_lock_4"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Image_lock_4"):setVisible(false)
    end

        
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureBattleFormationClass")) fwin:close(fwin:find("AdventureMercenaryheroInfoClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    --打开四维属性
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_75"),       nil, 
    {
        terminal_name = "adventure_battle_formation_open_siwei_dialog",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
    local current_formation = zstring.tonumber(_ED.formetion_index)
    for i=1,4 do

        local formationButton =  ccui.Helper:seekWidgetByName(root, "Button_zr_" .. i)
        if current_formation == i then 
            formationButton:setColor(cc.c3b(255, 255, 255))
            formationButton:setHighlighted(true)
            formationButton:setTouchEnabled(false)   
        else
            formationButton:setColor(cc.c3b(130, 130, 130))
            formationButton:setHighlighted(false)
            formationButton:setTouchEnabled(true)   
        end
        
        fwin:addTouchEventListener(formationButton,       nil, 
        {
            terminal_name = "adventure_battle_formation_change_mananger",
            current_button_name = "Button_zr_".. i,  
            current_button_type = i ,      
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 2) 
    end
    state_machine.excute("adventure_battle_formation_change_mananger", 0, 
        {_datas ={
            current_button_name = "Button_zr_" ..current_formation,        
            current_button_type = current_formation ,      
            terminal_state = 0, 
            isPressedActionEnabled = true
        }}
        )
    

    -- 阵型排列
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zxpl"),       nil, 
    {
        terminal_name = "adventure_battle_formation_change",
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

     -- 下阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_xiazhen"),       nil, 
    {
        terminal_name = "adventure_battle_formation_change_the_battle",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change"),       nil, 
    {
        terminal_name = "adventure_battle_formation_change",     
        terminal_state = 0, 
        cell = self.selcetCell,
        isPressedActionEnabled = true
    }, 
    nil, 0)
end

function AdventureBattleFormation:onExit()
    state_machine.remove("adventure_battle_formation_change")
	state_machine.remove("adventure_battle_formation_open_battle_list")
	state_machine.remove("adventure_battle_formation_update_draw")
	state_machine.remove("adventure_battle_formation_update_draw_skill")
    state_machine.remove("adventure_battle_formation_open_siwei_dialog")
    state_machine.remove("adventure_battle_formation_change_mananger") 
end

--已经用不到了
function AdventureBattleFormation:onUpdateDraw()
    local a = 1
    if a == 1 then 
        return
    end
--    local root = self.roots[1]
--     local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_role_"..self.indexs)
--     m_ScrollView:removeAllChildren(true)
--     local panel = m_ScrollView:getInnerContainer()
--     panel:setContentSize(m_ScrollView:getContentSize())
--     panel:setPosition(cc.p(0,0))
--     panel:removeAllChildren(true)
--     local sSize = panel:getContentSize()
--     local sHeight = sSize.height
--     local sWidth = sSize.width
--     local controlSize = m_ScrollView:getInnerContainerSize()
--     local nextY = sSize.height
--     local nextX = sSize.width
--     local tHeight = 0
--     local cellHeight = 0
--     local tWidth = 0
--     local wPosition = sWidth/5
--     local Hlindex = 0
--     local showInde = 0
--     local hero_info = {}
    
-- --  cellHeight = (zstring.tonumber(_ED.user_ship_number)/5+1)*(m_ScrollView:getContentSize().width/5)
--     --sHeight = math.max(sHeight, cellHeight)
--     --panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)

--     local first = nil
--     self.heroList = {}
--     self.heroCellList = {}
--     local isEmpty = true
--     for i,w in pairs(_ED.formetion_list[self.indexs]) do
--         if i>1 then
--             for z, r in pairs(_ED.user_ship) do
--                 if zstring.tonumber(w) == zstring.tonumber(r.ship_id) then
--                     table.insert(self.heroList, r)
--                 end
--             end
--             if zstring.tonumber(w) == 0 then
--                 table.insert(self.heroList, {ship_template_id = 0})
--                 isEmpty = true
--             end
--             if zstring.tonumber(w) == -1 and isEmpty == true then
--                 isEmpty = false
--                 table.insert(self.heroList, {ship_template_id = 0})
--             end
--         end
--     end
--     local shipid = ""

--     cellHeight = (zstring.tonumber(#self.heroList)/5+1)*(m_ScrollView:getContentSize().width/5)
--     sHeight = math.max(sHeight, cellHeight)
--     panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
--     for j ,v in pairs(self.heroList) do
--         local cell = AdventureHeroIconCell:createCell()
--         if zstring.tonumber(v.ship_template_id) == 0 then
--             if j == #self.heroList then
--                 cell:init(0, {ship_template_id = 1}, 99, 0, nil, nil, nil, nil, j)
--                 local checkpointcell = AdventureHeroCheckpointCell:createCell()
--                 checkpointcell:init()
--                 cell:addChild(checkpointcell)
--             else
--                 cell:init(3, {ship_template_id = 1}, 99, 0, nil, nil, nil, nil, j)
--             end
--         else

--             cell:init(5, v, 1, 0, nil, nil, v.ship_grade, nil, j)

--             shipid = v.ship_id .. "," .. shipid
--         end
--         panel:addChild(cell)
        
--         if j == 1 then
--             first = cell
--         end
--         tWidth = tWidth + wPosition
--         if (j-1)%5 ==0 then
--             Hlindex = Hlindex+1
--             tWidth = 0
--             tHeight = sHeight - wPosition*Hlindex  
--         end
--         if j<= 5 then
--             tHeight = sHeight - wPosition
--         end
--         cell:setPosition(cc.p(tWidth,tHeight))
--         showInde = j
--     end
--     shipid = string.sub(shipid,0,#shipid-1)
--     local suminfo = recalcFormationBaseProperty(shipid)
--     self.textAttack:setString(suminfo.speed)
--     self.textDefense:setString(suminfo.defence)
--     self.textDodge:setString(suminfo.avd)
--     self.textKing:setString(suminfo.authority)
    
--     m_ScrollView:jumpToTop()
--     if first ~= nil then
--         state_machine.excute("adventure_hero_icon_cell_show_hero_warehouse_larger_formation", 0, {_datas={cell = first}})
--         state_machine.excute("adventure_battle_formation_select_hero", 0, {_datas={cell = first}})
--     end
--     state_machine.excute("adventure_mercenary_package_sort_update_attribute_info", 0, self.heroList[self.choiceIndex])

    
--     self.currentScrollView = m_ScrollView
--     self.currentInnerContainer = self.currentScrollView:getInnerContainer()
--     self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end