-----------------------------
--英雄缘分界面
-----------------------------
OtherPlayersHeroFetters = class("OtherPlayersHeroFettersClass", Window)

local other_players_hero_fetters_window_open_terminal = {
    _name = "other_players_hero_fetters_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("OtherPlayersHeroFettersClass")
        if nil == _Window then
            fwin:open(OtherPlayersHeroFetters:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(other_players_hero_fetters_window_open_terminal)
state_machine.init()

function OtherPlayersHeroFetters:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship = nil
    self.select_rela_index = 1

    -- load lua file
    app.load("client.red_alert_time.hero.HeroFetterChosee")
    app.load("client.red_alert_time.cells.hero.hero_fetters_cell")
    app.load("client.red_alert_time.cells.hero.hero_fetter_chosee_cell")  
      
    -- Initialize other_players_hero_fetters state machine.
    local function init_other_players_hero_fetters_terminal()
    
        --显示界面
        local other_players_hero_fetters_window_show_terminal = {
            _name = "other_players_hero_fetters_window_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if fwin:find("OtherPlayersHeroFettersClass") ~= nil then
                    instance:onShow()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --隐藏界面
        local other_players_hero_fetters_window_hide_terminal = {
            _name = "other_players_hero_fetters_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if fwin:find("OtherPlayersHeroFettersClass") ~= nil then
                    instance:onHide()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --改变英雄
        local other_players_hero_fetters_change_ship_terminal = {
            _name = "other_players_hero_fetters_change_ship",
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
       --取消选中
        local other_players_hero_fetters_unsetselect_terminal = {
            _name = "other_players_hero_fetters_unsetselect",
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

       --刷新羁绊信息
        local other_players_hero_fetters_update_rela_terminal = {
            _name = "other_players_hero_fetters_update_rela",
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

        state_machine.add(other_players_hero_fetters_window_show_terminal)   
        state_machine.add(other_players_hero_fetters_window_hide_terminal)
        state_machine.add(other_players_hero_fetters_change_ship_terminal)
        state_machine.add(other_players_hero_fetters_unsetselect_terminal)
        state_machine.add(other_players_hero_fetters_update_rela_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_other_players_hero_fetters_terminal()
end

function OtherPlayersHeroFetters:onHide()
    self:setVisible(false)
end

function OtherPlayersHeroFetters:onShow()
    self:setVisible(true)
end

function OtherPlayersHeroFetters:onUpdateDrawRela()
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
        local Image_dec = Panel_lighted:getChildByName("Image_dec_"..i)
        Button_re:setVisible(false)
        if tonumber(v) == -1 then
            Panel_lighted:setVisible(false)
            Panel_icon:setColor(cc.c3b(gray_color[1],gray_color[2],gray_color[3])) 
        else
            Panel_lighted:setVisible(true)
            Image_dec:setVisible(false)
            Panel_icon:setColor(cc.c3b(un_gray_color[1],un_gray_color[2],un_gray_color[3]))         
            if tonumber(v) == 0 then
                Text_dec:setVisible(false)
                Button_un:setVisible(false)
            else
                Text_dec:setVisible(false)
                Button_un:setVisible(false)
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

    end
end

function OtherPlayersHeroFetters:onUpdateDraw()
    local root = self.roots[1]
    self.select_rela_index = 1
    local ListView_feetters_effect = ccui.Helper:seekWidgetByName(root,"ListView_feetters_effect")
    ListView_feetters_effect:removeAllItems()
    for i,v in pairs(self.ship.relationship) do
        if v.is_activited == nil then
            break
        end
        local _cell = state_machine.excute("hero_fetters_create_cell",0,{v.relationship_id,v.is_activited,i, false})
        ListView_feetters_effect:addChild(_cell)
        if i == self.select_rela_index then
            state_machine.excute("hero_fetters_cell_click",0,{_datas = {cell = _cell}})
        end
    end
    local Panel_role_fet_me = ccui.Helper:seekWidgetByName(root,"Panel_role_fet_me")
    Panel_role_fet_me:removeAllChildren(true)
    local cell = state_machine.excute("hero_icon_create_cell",0,{self.ship,4,0})
    Panel_role_fet_me:addChild(cell)
end

function OtherPlayersHeroFetters:setUnSelected()
    local root = self.roots[1]
    local ListView_feetters_effect = ccui.Helper:seekWidgetByName(root,"ListView_feetters_effect")
    for i,cell in pairs(ListView_feetters_effect:getItems()) do
        cell.isSelecet = false
        cell:setSeclected()
    end
end

function OtherPlayersHeroFetters:onEnterTransitionFinish()

end

function OtherPlayersHeroFetters:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_fetters)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw()
end

function OtherPlayersHeroFetters:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.ship = params[2]
    self:onInit()
    return self
end

function OtherPlayersHeroFetters:onExit()
    state_machine.remove("other_players_hero_fetters_window_show")  
    state_machine.remove("other_players_hero_fetters_window_hide")
    state_machine.remove("other_players_hero_fetters_change_ship")
    state_machine.remove("other_players_hero_fetters_unsetselect")
    state_machine.remove("other_players_hero_fetters_update_rela")
end
