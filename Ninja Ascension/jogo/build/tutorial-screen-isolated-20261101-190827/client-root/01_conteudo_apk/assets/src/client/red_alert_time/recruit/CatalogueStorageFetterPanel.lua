-----------------------------
--英雄缘分界面
-----------------------------
CatalogueStorageFetterPanel = class("CatalogueStorageFetterPanelClass", Window)

local catalogue_storage_fetter_panel_window_open_terminal = {
    _name = "catalogue_storage_fetter_panel_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("CatalogueStorageFetterPanelClass") then
            fwin:open(CatalogueStorageFetterPanel:new():init(params))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(catalogue_storage_fetter_panel_window_open_terminal)
state_machine.init()

function CatalogueStorageFetterPanel:ctor()
    self.super:ctor()
    self.roots = {}
    self.select_rela_index = 1

    -- load lua file
    app.load("client.red_alert_time.recruit.CatalogueFettersCell")
      
     -- Initialize catalogue_fetters state machine.
    local function init_catalogue_fetters_panel_terminal()
        
       ----刷新羁绊信息
        local catalogue_fetters_update_rela_terminal = {
            _name = "catalogue_fetters_update_rela",
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

          ----取消选中
        local catalogue_fetters_unsetselect_terminal = {
            _name = "catalogue_fetters_unsetselect",
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
        state_machine.add(catalogue_fetters_update_rela_terminal)
        state_machine.add(catalogue_fetters_unsetselect_terminal)
        state_machine.init()
    end
    
    -- call func hero_fetters_cell_click create state machine.
    init_catalogue_fetters_panel_terminal()
end


function CatalogueStorageFetterPanel:setUnSelected()
    local root = self.roots[1]
    local ListView_feetters_effect = ccui.Helper:seekWidgetByName(root,"ListView_feetters_effect")
    for i,cell in pairs(ListView_feetters_effect:getItems()) do
        cell.isSelecet = false
        cell:setSeclected()
    end
end

function CatalogueStorageFetterPanel:onHide()
    self:setVisible(false)
end

function CatalogueStorageFetterPanel:onShow()
    self:setVisible(true)
end


function CatalogueStorageFetterPanel:onUpdateDrawRela()
    local root = self.roots[1]
    local relationship_id_str = dms.string(dms["ship_mould"],self.ship_mould_id,ship_mould.relationship_id)
    relationship_id_str = zstring.split(relationship_id_str,",")
    local relationship_id = tonumber(relationship_id_str[self.select_rela_index])
    local rela_numbers = 0

    local rela_table = {}
    local need1 = dms.int(dms["fate_relationship_mould"],relationship_id,fate_relationship_mould.relation_need1)
    local need2 = dms.int(dms["fate_relationship_mould"],relationship_id,fate_relationship_mould.relation_need2)
    local need3 = dms.int(dms["fate_relationship_mould"],relationship_id,fate_relationship_mould.relation_need3)
    local need4 = dms.int(dms["fate_relationship_mould"],relationship_id,fate_relationship_mould.relation_need4)
    local need5 = dms.int(dms["fate_relationship_mould"],relationship_id,fate_relationship_mould.relation_need5)
    local need6 = dms.int(dms["fate_relationship_mould"],relationship_id,fate_relationship_mould.relation_need6)
    local need_type = 0
    if need1 > 0 then
        rela_numbers = rela_numbers + 1
        local need_data = {
            rale_need_id = need1,
            need_type = dms.int(dms["fate_relationship_mould"],relationship_id,fate_relationship_mould.relation_need1_type)
        }
        table.insert(rela_table,need_data)
    end

    if need2 > 0 then
        rela_numbers = rela_numbers + 1
        local need_data = {
            rale_need_id = need2,
            need_type = dms.int(dms["fate_relationship_mould"],relationship_id,fate_relationship_mould.relation_need2_type)
        }
        table.insert(rela_table,need_data)
    end

    if need3 > 0 then
        rela_numbers = rela_numbers + 1
        local need_data = {
            rale_need_id = need3,
            need_type = dms.int(dms["fate_relationship_mould"],relationship_id,fate_relationship_mould.relation_need3_type)
        }
        table.insert(rela_table,need_data)
    end

    if need4 > 0 then
        rela_numbers = rela_numbers + 1
                local need_data = {
            rale_need_id = need4,
            need_type = dms.int(dms["fate_relationship_mould"],relationship_id,fate_relationship_mould.relation_need4_type)
        }
        table.insert(rela_table,need_data)
    end

    if need5 > 0 then
        rela_numbers = rela_numbers + 1
        local need_data = {
            rale_need_id = need5,
            need_type = dms.int(dms["fate_relationship_mould"],relationship_id,fate_relationship_mould.relation_need5_type)
        }
        table.insert(rela_table,need_data)
    end

    if need6 > 0 then
        rela_numbers = rela_numbers + 1
        local need_data = {
            rale_need_id = need6,
            need_type = dms.int(dms["fate_relationship_mould"],relationship_id,fate_relationship_mould.relation_need6_type)
        }
        table.insert(rela_table,need_data)
    end

    -- print("=====rela_numbers=====",rela_numbers)
    for i= 1, 4 do 
        local Panel_fetters = ccui.Helper:seekWidgetByName(root,"Panel_fetters_"..i)
        if Panel_fetters ~= nil then
            Panel_fetters:setVisible(false)
        end
    end
    local Panel_fetters = ccui.Helper:seekWidgetByName(root,"Panel_fetters_"..rela_numbers)
    Panel_fetters:setVisible(true)
    
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
        }
        table.insert(add_numbers,data_temp)
    end
    if attack_addition > 0 then         --攻击力增加
        local data_temp = {
            dec =  red_alert_all_str[9],
            add_num = attack_addition.."%",
        }
        table.insert(add_numbers,data_temp)
    end
    if physic_defence_addition > 0 then     --物防增加
        local data_temp = {
            dec =  red_alert_all_str[11],
            add_num = physic_defence_addition.."%",
        }
        table.insert(add_numbers,data_temp)
    end

    if magic_defence_addition > 0 then      --魔防增加
        local data_temp = {
            dec =  red_alert_all_str[12],
            add_num = magic_defence_addition.."%",
        }
        table.insert(add_numbers,data_temp)
    end 
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
    for i,v in pairs(rela_table) do
        local Panel_lighted = Panel_fetters:getChildByName("Panel_lighted_"..i)
        local Text_name = Panel_fetters:getChildByName("Text_name_"..i)
        local Panel_icon = Panel_fetters:getChildByName("Panel_icon_"..i)      
        local Button_re = Panel_fetters:getChildByName("Button_re_"..i)
        local Button_un = Panel_lighted:getChildByName("Button_un_"..i)
        local Text_dec = Panel_lighted:getChildByName("Text_dec_"..i)
        local Image_dec = Panel_lighted:getChildByName("Image_dec_"..i)
        Panel_lighted:setVisible(true)
        Button_re:setVisible(false)
        Button_un:setVisible(false)
        Text_dec:setVisible(false)
        Image_dec:setVisible(false)
        Panel_icon:removeBackGroundImage()
        local relation_need_id = v.rale_need_id
        local relation_need_type = v.need_type
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

function CatalogueStorageFetterPanel:onUpdateDraw()
    local root = self.roots[1]
    self.select_rela_index = 1
    local relationship_id = dms.string(dms["ship_mould"],self.ship_mould_id,ship_mould.relationship_id)
    relationship_id = zstring.split(relationship_id,",")
    local ListView_feetters_effect = ccui.Helper:seekWidgetByName(root,"ListView_feetters_effect")
    ListView_feetters_effect:removeAllItems()
    for i,v in pairs(relationship_id) do
        local _cell = state_machine.excute("catalogue_fetters_create_cell",0,{v,1,i})
        ListView_feetters_effect:addChild(_cell)
        if i == self.select_rela_index then
            state_machine.excute("catalogue_fetters_cell_click",0,{_datas = {cell = _cell}})
        end
    end

    local Panel_role_fet_me = ccui.Helper:seekWidgetByName(root,"Panel_role_fet_me")
    Panel_role_fet_me:removeAllChildren(true)
    local cell = state_machine.excute("hero_icon_create_cell",0,{self.ship_mould_id,4,0})
    Panel_role_fet_me:addChild(cell)
end

function CatalogueStorageFetterPanel:onEnterTransitionFinish()

end

function CatalogueStorageFetterPanel:onInit( )
    local csbItem = csb.createNode(config_csb.hero.hero_fetters)
    local root = csbItem:getChildByName("root")
    root = ccui.Helper:seekWidgetByName(root, "Panel_fetter_window")
    root:removeFromParent(false)
    
    self:addChild(root)

    table.insert(self.roots, root)

    self:onUpdateDraw()
end

function CatalogueStorageFetterPanel:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow  
    self.ship_mould_id = params[2]
    self:onInit()
    return self
end

function CatalogueStorageFetterPanel:onExit()
    state_machine.remove("catalogue_fetters_update_rela",0,"")
    state_machine.remove("catalogue_fetters_unsetselect",0,"")
end
