-----------------------------
--英雄缘分界面
-----------------------------
HeroFetters = class("HeroFettersClass", Window)

--打开
local hero_fetters_window_open_terminal = {
    _name = "hero_fetters_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("HeroFettersClass")
        if nil == _Window then
            fwin:open(HeroFetters:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_fetters_window_open_terminal)
state_machine.init()

function HeroFetters:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship = nil
    self.select_rela_index = 1

    --英雄当前羁绊状态
    self._is_activited_table = {}
    --羁绊模板
    self._relationship_data = nil

    self._add_numbers = {}
    app.load("client.red_alert.hero.HeroFetterChosee")
    app.load("client.red_alert.cells.hero.hero_fetters_cell")
    app.load("client.red_alert.cells.hero.hero_fetter_chosee_cell")  
      
    -- Initialize hero_fetters state machine.
    local function init_hero_fetters_terminal()
    
        --显示界面
        local hero_fetters_window_show_terminal = {
            _name = "hero_fetters_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if fwin:find("HeroFettersClass") ~= nil then
                    instance:onShow()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --隐藏界面
        local hero_fetters_window_hide_terminal = {
            _name = "hero_fetters_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if fwin:find("HeroFettersClass") ~= nil then
                    instance:onHide()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        ----改变英雄
        local hero_fetters_change_ship_terminal = {
            _name = "hero_fetters_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if params ~= "" and params ~= nil then
                    instance.ship = params 
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
       ----取消选中
        local hero_fetters_unsetselect_terminal = {
            _name = "hero_fetters_unsetselect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setUnSelected()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

       ----刷新羁绊信息
        local hero_fetters_update_rela_terminal = {
            _name = "hero_fetters_update_rela",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if params[1] ~= nil then
                    instance.select_rela_index = params[1]
                end
                instance:onUpdateDrawRela()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --请求打开激活羁绊选择界面
        local hero_fetters_open_rela_select_terminal = {
            _name = "hero_fetters_open_rela_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local mould_id = params._datas.rele_mould_id
                local rele_type = params._datas.rele_type
                local rele_id = params._datas.rele_id
                local ship = params._datas.ship
                local data_tables = {}
                local numbers = 0
                local select_rela_index = params._datas.select_rela_index
                if rele_type == 0 then
                    for i,ship in pairs(_ED.user_ship) do
                        if tonumber(ship.ship_base_template_id) == tonumber(mould_id) and 
                            ship.ship_id ~= instance.ship.ship_id and 
                            zstring.tonumber(ship.formation_index) == 0 and
                            zstring.tonumber(ship.little_partner_formation_index) == 0
                            then
                            table.insert(data_tables,ship)
                            numbers = numbers + 1
                        end
                    end
                else
                    for i,equip in pairs(_ED.user_equiment) do
                        --print("=======11=========",equip.user_equiment_template,mould_id,equip.ship_id,equip.rela_state,equip.user_equiment_name)
                        if tonumber(equip.user_equiment_template) == tonumber(mould_id) and 
                            zstring.tonumber(equip.ship_id) == 0 and
                            zstring.tonumber(equip.rela_state) == 0 
                         then
                            table.insert(data_tables,equip)
                            numbers = numbers + 1
                        end
                    end
                end

                if numbers == 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[27])
                    return
                end
                state_machine.excute("hero_fetter_chosee_window_open",0,{instance.ship.ship_id,rele_id,rele_type,data_tables,ship,select_rela_index})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --取消羁绊
        local hero_fetters_to_unlight_rela_terminal = {
            _name = "hero_fetters_to_unlight_rela",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local rele_ship_or_equip_id = params._datas.rele_ship_or_equip_id
                local rele_id = params._datas.rele_id
                local rele_type = params._datas.rele_type
                local ship = params._datas.ship
                local select_rela_index = params._datas.select_rela_index
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if rele_type == 0 then
                            state_machine.excute("hero_main_add_list_item",0,_ED.user_ship[rele_ship_or_equip_id])
                        end
                        state_machine.excute("hero_fetters_update_cell",0,rele_id)
                        state_machine.excute("hero_fetters_update_rela",0,"")
                        state_machine.excute("hero_main_update_hero_info",0,"")
                        local sound_index = mainShipSound(ship.ship_template_id)
                        playEffectOld(formatMusicFile("effect", sound_index))
                        playEffect(formatMusicFile("effect", 10000))
                        instance:playUnlightRelaActions()
                        local index = 0 
                        for i,v in pairs(ship.relationship[select_rela_index].is_activited) do
                            if tonumber(v) >= 0 then
                                index = index + 1
                            end
                        end
                        if index == #ship.relationship[select_rela_index].is_activited - 1 then 
                            state_machine.excute("hero_fetters_update_numbers",0,{2})
                        end
                    end
                end
                protocol_command.remove_fetter.param_list = instance.ship.ship_id.."\r\n"..rele_id.."\r\n"..rele_type.."\r\n"..rele_ship_or_equip_id
                NetworkManager:register(protocol_command.remove_fetter.code, nil, nil, nil, nil, responseCallback, false, nil)                  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新列表羁绊激活活取消
        local hero_fetters_update_cell_terminal = {
            _name = "hero_fetters_update_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateCell(params)              
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }       
        --羁绊激活
        local hero_fetters_play_lighted_action_terminal = {
            _name = "hero_fetters_play_lighted_action",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:playActions()              
                instance:playRelaActions()  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }     
        --羁绊成功飘字
        local hero_fetters_update_numbers_terminal = {
            _name = "hero_fetters_update_numbers",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params[1]
                instance:onUpdateDrawNumbers(index)              
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }    
        state_machine.add(hero_fetters_window_show_terminal)   
        state_machine.add(hero_fetters_window_hide_terminal)
        state_machine.add(hero_fetters_change_ship_terminal)
        state_machine.add(hero_fetters_unsetselect_terminal)
        state_machine.add(hero_fetters_update_rela_terminal)
        state_machine.add(hero_fetters_open_rela_select_terminal)
        state_machine.add(hero_fetters_to_unlight_rela_terminal)
        state_machine.add(hero_fetters_update_cell_terminal)
        state_machine.add(hero_fetters_play_lighted_action_terminal)
        state_machine.add(hero_fetters_update_numbers_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_hero_fetters_terminal()
end

function HeroFetters:onHide()
    self:setVisible(false)
end

function HeroFetters:onShow()
    self:setVisible(true)
end

function HeroFetters:playActions()
    local root = self.roots[1]
    local Panel_effice = ccui.Helper:seekWidgetByName(root,"Panel_effice")
    Panel_effice:removeAllChildren(true)
    local function ActionCallback( armatureBack )
        armatureBack:removeFromParent(true)
    end
    local jsonPath = "images/ui/effice/effice_hero_fetters/effice_hero_fetters.json"
    local atlasPath = "images/ui/effice/effice_hero_fetters/effice_hero_fetters.atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation_event", true, nil)
    animation:setPosition(cc.p(Panel_effice:getContentSize().width/2,Panel_effice:getContentSize().height/2))
    sp.initArmature(animation, false)
    animation._invoke = ActionCallback
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    Panel_effice:addChild(animation)
end

--解除当前角色羁绊,还在羁绊中的角色播放光效
function HeroFetters:playUnlightRelaActions()
    local root = self.roots[1]
    local rela_numbers = #self.ship.relationship[self.select_rela_index].is_activited
    for i= 1, 4 do 
        local Panel_fetters = ccui.Helper:seekWidgetByName(root,"Panel_fetters_"..i)
        if Panel_fetters ~= nil then
            Panel_fetters:setVisible(false)
        end
    end
    local Panel_fetters = ccui.Helper:seekWidgetByName(root,"Panel_fetters_"..rela_numbers)
    Panel_fetters:setVisible(true)
    for i,v in pairs(self.ship.relationship[self.select_rela_index].is_activited) do
        local Panel_icon = Panel_fetters:getChildByName("Panel_icon_"..i)
        Panel_icon:removeAllChildren(true)
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_reward/effice_reward.ExportJson")
        local effice = ccs.Armature:create("effice_reward")
        effice:setPosition(cc.p(Panel_icon:getContentSize().width/2, Panel_icon:getContentSize().height/2))
        effice:setVisible(false)
        Panel_icon:addChild(effice)
        if tonumber(v) ~= -1 then
            effice:setVisible(true)
            effice:getAnimation():playWithIndex(0,0,0)
        end
    end
    self:onUpdateDrawActivited()
end

--当前羁绊英雄播放光效
function HeroFetters:playRelaActions()
    local root = self.roots[1]
    local rela_numbers = #self.ship.relationship[self.select_rela_index].is_activited
    for i= 1, 4 do 
        local Panel_fetters = ccui.Helper:seekWidgetByName(root,"Panel_fetters_"..i)
        if Panel_fetters ~= nil then
            Panel_fetters:setVisible(false)
        end
    end
    local Panel_fetters = ccui.Helper:seekWidgetByName(root,"Panel_fetters_"..rela_numbers)
    Panel_fetters:setVisible(true)
    for i,v in pairs(self.ship.relationship[self.select_rela_index].is_activited) do
        local Panel_icon = Panel_fetters:getChildByName("Panel_icon_"..i)
        Panel_icon:removeAllChildren(true)
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_reward/effice_reward.ExportJson")
        local effice = ccs.Armature:create("effice_reward")
        effice:setPosition(cc.p(Panel_icon:getContentSize().width/2, Panel_icon:getContentSize().height/2))
        effice:setVisible(false)
        Panel_icon:addChild(effice)
        if tonumber(v) ~= -1 and tonumber(self._is_activited_table[self.select_rela_index][i]) ~= tonumber(v) then
            effice:setVisible(true)
            effice:getAnimation():playWithIndex(0,0,0)
            self._is_activited_table[self.select_rela_index][i] = v
        end
    end
    self:onUpdateDrawActivited()
end

function HeroFetters:onUpdateCell(relationship_id)
    local root = self.roots[1]
    local ListView_feetters_effect = ccui.Helper:seekWidgetByName(root,"ListView_feetters_effect")
    for i,cell in pairs(ListView_feetters_effect:getItems()) do
        if tonumber(relationship_id) == tonumber(cell.id) then
            cell.states = self.ship.relationship[self.select_rela_index].is_activited
            cell:updateDraw()
        end
    end
end

function HeroFetters:onUpdateDrawRela()
    local root = self.roots[1]
    local rela_numbers = #self.ship.relationship[self.select_rela_index].is_activited
    -- print("=====rela_numbers=====",rela_numbers)
    for i= 1, 4 do 
        local Panel_fetters = ccui.Helper:seekWidgetByName(root,"Panel_fetters_"..i)
        if Panel_fetters ~= nil then
            Panel_fetters:setVisible(false)
        end
    end
    local Panel_fetters = ccui.Helper:seekWidgetByName(root,"Panel_fetters_"..rela_numbers)
    Panel_fetters:setVisible(true)
    local relationship_id = self.ship.relationship[self.select_rela_index].relationship_id
    local relationship_data = dms.element(dms["fate_relationship_mould"],relationship_id)
    self._relationship_data = relationship_data
    local life_addition = dms.atoi(relationship_data,fate_relationship_mould.life_addition)
    local attack_addition = dms.atoi(relationship_data,fate_relationship_mould.attack_addition)
    local physic_defence_addition = dms.atoi(relationship_data,fate_relationship_mould.physic_defence_addition)
    local magic_defence_addition = dms.atoi(relationship_data,fate_relationship_mould.magic_defence_addition)
    local Text_fetters_effect_t = ccui.Helper:seekWidgetByName(root,"Text_fetters_effect_t")
    local Text_fetters_effect_tX = Text_fetters_effect_t:getPositionX() 
    local Text_fetters_effect_t_width = Text_fetters_effect_t:getContentSize().width

    local Text_fetters_effect_infor = ccui.Helper:seekWidgetByName(root,"Text_fetters_effect_infor")
    Text_fetters_effect_infor:removeAllChildren(true)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)      
    local add_numbers = {}
    if life_addition > 0 then       --生命增加
        local data_temp = {
            dec =  red_alert_all_str[10],
            add_num = life_addition.."%",
            dec_type = _fetters_string[2],
        }
        table.insert(add_numbers,data_temp)
    end
    if attack_addition > 0 then         --攻击力增加
        local data_temp = {
            dec =  red_alert_all_str[9],
            add_num = attack_addition.."%",
            dec_type = _fetters_string[1],
        }
        table.insert(add_numbers,data_temp)
    end
    if physic_defence_addition > 0 then     --物防增加
        local data_temp = {
            dec =  red_alert_all_str[11],
            add_num = physic_defence_addition.."%",
            dec_type = _fetters_string[3],
        }
        table.insert(add_numbers,data_temp)
    end

    if magic_defence_addition > 0 then      --魔防增加
        local data_temp = {
            dec =  red_alert_all_str[12],
            add_num = magic_defence_addition.."%",
            dec_type = _fetters_string[4],
        }
        table.insert(add_numbers,data_temp)
    end 
    self._add_numbers = add_numbers
    for i,v in pairs(add_numbers) do
        local re1 = nil 
        local re2 = nil
        re1 =ccui.RichElementText:create(1, cc.c3b(color_Type[25][1],color_Type[25][2],color_Type[25][3]),255, v.dec, "fonts/simhei.ttf",20)
        _richText:pushBackElement(re1)  
        if i == #add_numbers then
            re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[26][1],color_Type[26][2],color_Type[26][3]),255,v.add_num,"fonts/simhei.ttf",20)
            _richText:pushBackElement(re2)
        else
            re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[26][1],color_Type[26][2],color_Type[26][3]),255,v.add_num..",","fonts/simhei.ttf",20)
            _richText:pushBackElement(re2)
        end
    end
    _richText:setContentSize(cc.size(250,20))
    _richText:setAnchorPoint(cc.p(0,0.5))
    _richText:setPositionX(Text_fetters_effect_tX - 160)
    Text_fetters_effect_infor:addChild(_richText)
    -- debug.print_r(self.ship)
    for i,v in pairs(self.ship.relationship[self.select_rela_index].is_activited) do
        local Panel_lighted = Panel_fetters:getChildByName("Panel_lighted_"..i)
        local Text_name = Panel_fetters:getChildByName("Text_name_"..i)
        local Panel_icon = Panel_fetters:getChildByName("Panel_icon_"..i)      
        local Button_re = Panel_fetters:getChildByName("Button_re_"..i)
        local Button_un = Panel_lighted:getChildByName("Button_un_"..i)
        local Text_dec = Panel_lighted:getChildByName("Text_dec_"..i)
        if tonumber(v) == -1 then
            Panel_lighted:setVisible(false)
            Panel_icon:setColor(cc.c3b(gray_color[1],gray_color[2],gray_color[3])) 
            Button_re:setVisible(true)
        else
            Panel_lighted:setVisible(true)
            Panel_icon:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3]))       
            if tonumber(v) == 0 then
                Text_dec:setVisible(true)
                Button_un:setVisible(false)
                Button_re:setVisible(false)
            else
                Text_dec:setVisible(false)
                Button_un:setVisible(true)
            end
        end

        Panel_icon:removeBackGroundImage()

        local relation_need_id = dms.atoi(relationship_data,fate_relationship_mould.relation_need1+(i-1)*2)
        local relation_need_type = dms.atoi(relationship_data,fate_relationship_mould.relation_need1_type+(i-1)*2)
        local name = ""
        local quality = 0
        if relation_need_type == 0 then
            local pic_index = dms.int(dms["ship_mould"],relation_need_id,ship_mould.head_icon) + 10000
            quality  = dms.int(dms["ship_mould"],relation_need_id,ship_mould.ship_type)              
            name = dms.string(dms["ship_mould"],relation_need_id,ship_mould.captain_name)
            Panel_icon:setBackGroundImage("images/ui/props/props_"..pic_index..".png")
            Text_dec:setString(red_alert_all_str[16])
        else
            local pic_index =  dms.int(dms["equipment_mould"],relation_need_id,equipment_mould.pic_index)
            quality = dms.int(dms["equipment_mould"],relation_need_id,equipment_mould.grow_level)
            name = dms.string(dms["equipment_mould"],relation_need_id,equipment_mould.equipment_name)
            Panel_icon:setBackGroundImage("images/ui/equip/equip_"..pic_index..".png")    
            Text_dec:setString(red_alert_all_str[17])
        end
        -- print("==========",relation_need_id)
        -- print("==========",name)
        Text_name:setString(name)
        Text_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))



        fwin:addTouchEventListener(Button_re, nil, 
        {
            terminal_name = "hero_fetters_open_rela_select", 
            terminal_state = 0, 
            rele_id = relationship_id,
            rele_type = relation_need_type,
            rele_mould_id = relation_need_id,
            rele_ship_or_equip_id = v,
            touch_scale = true,
            touch_scale_xy = 0.95, 
            ship = self.ship,
            select_rela_index = self.select_rela_index,
        }, nil, 0)

        if tonumber(v) > 0 then -- 激活了，不是穿戴型的激活
            fwin:addTouchEventListener(Button_un, nil, 
            {
                terminal_name = "hero_fetters_to_unlight_rela", 
                terminal_state = 0, 
                rele_id = relationship_id,
                rele_type = relation_need_type,
                rele_mould_id = relation_need_id,
                rele_ship_or_equip_id = v,
                touch_scale = true,
                touch_scale_xy = 0.95, 
                ship = self.ship,
                select_rela_index = self.select_rela_index,
            }, nil, 0)        
        end
    end
end

function HeroFetters:onUpdateDrawNumbers(index)
    local data = nil 
    local text_table = {}
    if index == 1 then 
        for i,v in pairs(self._add_numbers) do
            data = _fetters_string[5]..v.dec_type.."+" .. v.add_num
            table.insert(text_table,data)
        end
    elseif index == 2 then 
        for i,v in pairs(self._add_numbers) do
            data =v.dec_type.."-" .. v.add_num
            table.insert(text_table,data)
        end
    end
    state_machine.excute("add_number_window_open",0,{28,text_table})
end
function HeroFetters:onUpdateDraw()
    local root = self.roots[1]
    self.select_rela_index = 1
    local ListView_feetters_effect = ccui.Helper:seekWidgetByName(root,"ListView_feetters_effect")
    
    local feetters_effect_1 = ListView_feetters_effect:setContentSize(ListView_feetters_effect:getContentSize())
    local feetters_effect_2 = ListView_feetters_effect:getInnerContainer():setContentSize(ListView_feetters_effect:getContentSize())
    ListView_feetters_effect:setContentSize(ListView_feetters_effect:getContentSize())
    ListView_feetters_effect:getInnerContainer():setContentSize(ListView_feetters_effect:getContentSize())
    ListView_feetters_effect:removeAllItems()
    for i,v in pairs(self.ship.relationship) do
        if v.is_activited == nil then
            break
        end
        local _cell = state_machine.excute("hero_fetters_create_cell",0,{v.relationship_id,v.is_activited,i, true})
        ListView_feetters_effect:addChild(_cell)
        if i == self.select_rela_index then
            state_machine.excute("hero_fetters_cell_click",0,{_datas = {cell = _cell}})
        end
    end
    local Panel_role_fet_me = ccui.Helper:seekWidgetByName(root,"Panel_role_fet_me")
    Panel_role_fet_me:removeAllChildren(true)
    local cell = state_machine.excute("hero_icon_create_cell",0,{self.ship,4,0})
    Panel_role_fet_me:addChild(cell)
    self:onUpdateDrawActivited()
end

--刷新羁绊信息
function HeroFetters:onUpdateDrawActivited()
    self._is_activited_table = {}
    for i,v in pairs(self.ship.relationship) do
        if v.is_activited == nil then
            break
        end
        table.insert(self._is_activited_table, v.is_activited)
    end
end
function HeroFetters:setUnSelected()
    local root = self.roots[1]
    local ListView_feetters_effect = ccui.Helper:seekWidgetByName(root,"ListView_feetters_effect")
    for i,cell in pairs(ListView_feetters_effect:getItems()) do
        cell.isSelecet = false
        cell:setSeclected()
    end
end

function HeroFetters:onEnterTransitionFinish()

end
--推送
function HeroFetters:onUpdate()
    local root = self.roots[1]
    local is_activited = self.ship.relationship[self.select_rela_index].is_activited
    local rela_numbers = #is_activited
    local Panel_fetters = ccui.Helper:seekWidgetByName(root,"Panel_fetters_"..rela_numbers)
    for i,v in pairs(is_activited) do
        local Image_point = Panel_fetters:getChildByName("Image_point_"..i)
        Image_point:setVisible(false)
        local mould_id = dms.atoi(self._relationship_data,fate_relationship_mould.relation_need1+(i-1)*2)
        local rele_type = dms.atoi(self._relationship_data,fate_relationship_mould.relation_need1_type+(i-1)*2)
        local numbers = 0
        if rele_type == 0 then
            for i,ship in pairs(_ED.user_ship) do
                if tonumber(ship.ship_base_template_id) == tonumber(mould_id) and 
                    ship.ship_id ~= self.ship.ship_id and 
                    zstring.tonumber(ship.formation_index) == 0 and
                    zstring.tonumber(ship.little_partner_formation_index) == 0
                    then
                    numbers = numbers + 1
                end
            end
        else
            for i,equip in pairs(_ED.user_equiment) do
                if tonumber(equip.user_equiment_template) == tonumber(mould_id) and 
                    zstring.tonumber(equip.ship_id) == 0 and
                    zstring.tonumber(equip.rela_state) == 0 
                 then
                    numbers = numbers + 1
                end
            end
        end
        if numbers > 0 and tonumber(v) == -1 then
            Image_point:setVisible(true)
        end
    end
end

function HeroFetters:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_fetters)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw()
end

function HeroFetters:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.ship = params[2]
    self:onInit()
    return self
end

function HeroFetters:onExit()
    state_machine.remove("hero_fetters_window_show")  
    state_machine.remove("hero_fetters_window_hide")
    state_machine.remove("hero_fetters_change_ship")
    state_machine.remove("hero_fetters_unsetselect")
    state_machine.remove("hero_fetters_update_rela")
    state_machine.remove("hero_fetters_open_rela_select")
    state_machine.remove("hero_fetters_to_unlight_rela")  
    state_machine.remove("hero_fetters_update_cell")  
    state_machine.remove("hero_fetters_play_lighted_action")
    state_machine.remove("hero_fetters_update_numbers")
end
