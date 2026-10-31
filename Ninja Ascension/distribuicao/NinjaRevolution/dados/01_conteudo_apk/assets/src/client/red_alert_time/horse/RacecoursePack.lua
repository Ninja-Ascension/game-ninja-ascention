-----------------------------
--马场包裹
-----------------------------
RacecoursePack = class("RacecoursePackClass", Window)
--打开
local racecourse_pack_window_open_terminal = {
    _name = "racecourse_pack_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("home_select_action_window_close",0,"")
        local _RacecourseWindow = fwin:find("RacecoursePackClass")
        if nil == _RacecourseWindow then
            fwin:open(RacecoursePack:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
--关闭
local racecourse_pack_window_close_terminal = {
    _name = "racecourse_pack_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RacecoursePackClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(racecourse_pack_window_open_terminal)
state_machine.add(racecourse_pack_window_close_terminal)
state_machine.init()

function RacecoursePack:ctor()
    self.super:ctor()
    self.roots = {}

    self._select_ship = nil
    --宝物属性
    self._choose_horse = nil
    -- 打开类型：1、珍兽  2、兽魂
    self._open_type = 0
    --  兽魂属性
    self._horse_soul = nil
    -- Initialize racecourse_pack state machine.
    local function init_racecourse_pack_terminal()

        --管理
        local racecourse_pack_window_manager_terminal = {
        _name = "racecourse_pack_window_manager",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)

            if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                -- hide child window
                terminal.last_terminal_name = params._datas.next_terminal_name
                state_machine.excute(params._datas.next_terminal_name, 0, params)
            end 
            -- set select ui button is highlighted
           
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(false)
                terminal.select_button:setTouchEnabled(true)
            end
            terminal.page_name = params._datas.but_image
            if terminal.select_button == nil and params._datas.current_button_name ~= nil then
                terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
            else
                terminal.select_button = params
            end
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(true)
                terminal.select_button:setTouchEnabled(false)
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
        }

        -- 显示珍兽
        local racecourse_pack_show_racecourse_terminal = {
            _name = "racecourse_pack_show_racecourse",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local root = self.roots[1]
                local Panel_left = ccui.Helper:seekWidgetByName(root,"Panel_left")
                local Panel_horse_soul_left = ccui.Helper:seekWidgetByName(root,"Panel_horse_soul_left")
                Panel_left:setVisible(true)
                Panel_horse_soul_left:setVisible(false)
                instance.panel:removeAllChildren(true)
                state_machine.excute("racecourse_scrollview_window_open", 0, {instance.panel, 1, instance._select_ship == nil})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 显示兽魂
        local racecourse_pack_show_horse_soul_terminal = {
            _name = "racecourse_pack_show_horse_soul",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = self.roots[1]
                local Panel_left = ccui.Helper:seekWidgetByName(root,"Panel_left")
                local Panel_horse_soul_left = ccui.Helper:seekWidgetByName(root,"Panel_horse_soul_left")
                Panel_left:setVisible(false)
                Panel_horse_soul_left:setVisible(true)
                instance.panel:removeAllChildren(true)
                local isShowSui = instance._horse_soul == nil
                state_machine.excute("racecourse_scrollview_window_open", 0, {instance.panel, 2, isShowSui, instance._horse_soul})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 刷新左侧
        local racecourse_pack_left_prop_draw_terminal = {
            _name = "racecourse_pack_left_prop_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local horse = params[1]
                local index = params[2]
                instance:onUpdateDrawLeftProp(horse,index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 穿戴
        local racecourse_pack_wear_terminal = {
            _name = "racecourse_pack_wear",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("racecourse_pack_window_close",0,nil)
                        state_machine.excute("racecourse_ride_change_ship",0,"")
                    end
                end
                protocol_command.rider_horse.param_list = instance._choose_horse.id.."\r\n"..instance._select_ship.ship_id
                NetworkManager:register(protocol_command.rider_horse.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --镶嵌
        local racecourse_pack_recharge_terminal = {
            _name = "racecourse_pack_recharge",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("racecourse_pack_window_close", 0, nil)
                        state_machine.excute("racecourse_ride_change_ship", 0, nil)
                    end
                end
                protocol_command.inlay_horse_spirit.param_list = instance._chooseHorseSpirit.id.."\r\n"..instance._horse_soul.id.."\r\n"..instance._chooseIndex
                NetworkManager:register(protocol_command.inlay_horse_spirit.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --强化
        local racecourse_pack_strength_terminal = {
            _name = "racecourse_pack_strength",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("racecourse_horse_strength_window_open", 0, {instance._chooseHorseSpirit})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(racecourse_pack_window_manager_terminal)
        state_machine.add(racecourse_pack_show_racecourse_terminal)
        state_machine.add(racecourse_pack_show_horse_soul_terminal)
        state_machine.add(racecourse_pack_left_prop_draw_terminal)
        state_machine.add(racecourse_pack_wear_terminal)
        state_machine.add(racecourse_pack_recharge_terminal)
        state_machine.add(racecourse_pack_strength_terminal)
    end
    init_racecourse_pack_terminal()
end

function RacecoursePack:onUpdateAttributes( horse )
    local root = self.roots[1]
    local ListView_infor = ccui.Helper:seekWidgetByName(root, "ListView_infor")
    ListView_infor:removeAllItems()

    local csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_1)
    local root1 = csbItem:getChildByName("root")
    root1:removeFromParent(false)
    ListView_infor:addChild(root1)
    ccui.Helper:seekWidgetByName(root1, "Text_title_1"):setVisible(true)
    ccui.Helper:seekWidgetByName(root1, "Text_title_2"):setVisible(false)
    
    local infos = zstring.split(horse.attribute, "|")
    local Text_infor_name_1 = nil
    local Text_infor_add_1  = nil
    local Text_infor_name_2 = nil
    local Text_infor_add_2  = nil
    for k,v in pairs(infos) do
        local spirit_info = zstring.split(v, ",")
        if (k % 2) ~= 0 then
            csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_2)
            root1 = csbItem:getChildByName("root")
            root1:removeFromParent(false)
            ListView_infor:addChild(root1)
            Text_infor_name_1 = ccui.Helper:seekWidgetByName(root1, "Text_infor_name_1")
            Text_infor_add_1 = ccui.Helper:seekWidgetByName(root1, "Text_infor_add_1")
            Text_infor_name_2 = ccui.Helper:seekWidgetByName(root1, "Text_infor_name_2")
            Text_infor_add_2 = ccui.Helper:seekWidgetByName(root1, "Text_infor_add_2")
            Text_infor_name_1:setString(attribute[tonumber(spirit_info[1]) + 1])
            Text_infor_add_1:setString("+"..spirit_info[2].."%")
            Text_infor_name_2:setString("")
            Text_infor_add_2:setString("")
        else
            Text_infor_name_2:setString(attribute[tonumber(spirit_info[1]) + 1])
            Text_infor_add_2:setString("+"..spirit_info[2].."%")
        end
    end

    local skill = dms.int(dms["horse_mould"], self._choose_horse.mould_id, horse_mould.skill)
    if skill > 0 then
        csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_3)
        root1 = csbItem:getChildByName("root")
        root1:removeFromParent(false)
        ListView_infor:addChild(root1)
        local skill_name = dms.string(dms["horse_mould"], self._choose_horse.mould_id, horse_mould.skill_name)
        local skill_desc = dms.string(dms["horse_mould"], self._choose_horse.mould_id, horse_mould.skill_desc)
        ccui.Helper:seekWidgetByName(root1, "Text_skills_name"):setString(skill_name)

        csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_4)
        root1 = csbItem:getChildByName("root")
        root1:removeFromParent(false)
        ListView_infor:addChild(root1)
        ccui.Helper:seekWidgetByName(root1, "Text_skills_infor"):setString(skill_desc)
    end

    local isAddTitle = false
    for k,v in pairs(self._choose_horse.horse_spirits) do
        if tonumber(v) > 0 then
            local mould_id = _ED.horse_spirits[""..v].mould_id
            if isAddTitle == false then
                isAddTitle = true
                csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_1)
                root1 = csbItem:getChildByName("root")
                root1:removeFromParent(false)
                ListView_infor:addChild(root1)
                local Text_title_1 = ccui.Helper:seekWidgetByName(root1, "Text_title_1"):setVisible(false)
                local Text_title_2 = ccui.Helper:seekWidgetByName(root1, "Text_title_2"):setVisible(true)
            end
            csbItem = csb.createNode(config_csb.cells.racecourse.treasure_pack_cell_5)
            root1 = csbItem:getChildByName("root")
            root1:removeFromParent(false)
            ListView_infor:addChild(root1)
            local name = dms.string(dms["horse_spirit_mould"], mould_id, horse_spirit_mould.horse_spirit_name)
            local attributes = zstring.split(dms.string(dms["horse_spirit_mould"], mould_id, horse_spirit_mould.attributes), ",")
            local picIndex = dms.int(dms["horse_spirit_mould"], mould_id, horse_spirit_mould.icon)
            ccui.Helper:seekWidgetByName(root1, "Text_enchant_name"):setString(name)
            local is_handred = false
            for i,v in pairs(attribute_hundred) do
                if tonumber(attributes[1]) == v then
                    is_handred = true
                end
            end
            if is_handred == true then
                ccui.Helper:seekWidgetByName(root1, "Text_enchant_add"):setString(attribute[tonumber(attributes[1]) + 1].."+"..attributes[2].."%")
            else
                ccui.Helper:seekWidgetByName(root1, "Text_enchant_add"):setString(attribute[tonumber(attributes[1]) + 1].."+"..attributes[2])
            end
            ccui.Helper:seekWidgetByName(root1, "Panel_icon"):setBackGroundImage(string.format("images/ui/enchant/enchant_%d.png", picIndex))
        end
    end
    ListView_infor:requestRefreshView()
end

--刷新按钮状态
function RacecoursePack:onUpdateButtonState( horse_spirit_type, isFullLevel )
    local root = self.roots[1]
    local Button_change = ccui.Helper:seekWidgetByName(root, "Button_change")               --兑换
    local Button_composition = ccui.Helper:seekWidgetByName(root, "Button_composition")     --合成
    local Button_strength = ccui.Helper:seekWidgetByName(root, "Button_strength")           --强化
    local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
    Image_2:setVisible(true)
    Button_change:setVisible(false)
    Button_composition:setVisible(false)
    Button_strength:setVisible(false)
    if self._horse_soul ~= nil then
        Button_change:setVisible(true)
    else
        if horse_spirit_type == 3 then
            Button_composition:setVisible(true)
        elseif horse_spirit_type == 1 then
            if isFullLevel == false then
                Button_strength:setVisible(true)
            end
        end
    end
end

function RacecoursePack:onUpdateDrawLeftProp( horse ,index)
    local root = self.roots[1]
    local Panel_left = ccui.Helper:seekWidgetByName(root,"Panel_left")
    local Panel_horse_soul_left = ccui.Helper:seekWidgetByName(root,"Panel_horse_soul_left")
    Panel_left:setVisible(false)
    Panel_horse_soul_left:setVisible(false)
    if index == 1 then
        Panel_left:setVisible(true)
        self._choose_horse = horse
        local name = dms.string(dms["horse_mould"], horse.mould_id, horse_mould.horse_name)
        local body_icon = dms.int(dms["horse_mould"], horse.mould_id, horse_mould.body_icon)
        local star = dms.int(dms["horse_mould"], horse.mould_id, horse_mould.star)
        local quality = dms.int(dms["horse_mould"], horse.mould_id, horse_mould.quality)

        local Panel_horse_picture = ccui.Helper:seekWidgetByName(root,"Panel_horse_picture")
        Panel_horse_picture:setBackGroundImage(string.format("images/ui/big_treasure/big_treasure_%d.png", body_icon))
        local Text_horse_name = ccui.Helper:seekWidgetByName(root, "Text_horse_name")
        Text_horse_name:setString(name)
        Text_horse_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
        local Panel_stars = ccui.Helper:seekWidgetByName(root, "Panel_stars")
        Panel_stars:removeAllChildren(true)
        draw.addHeroStar(Panel_stars, star, quality)

        self:onUpdateAttributes(horse)
    else
        Panel_horse_soul_left:setVisible(true)
        self._chooseHorseSpirit = horse
        local root = self.roots[1]
        --附魔图像
        local Panel_soul_piece = ccui.Helper:seekWidgetByName(root,"Panel_soul_piece")
        Panel_soul_piece:removeBackGroundImage()
        --附魔名称
        local Text_soul_piece = ccui.Helper:seekWidgetByName(root, "Text_soul_piece")
        Text_soul_piece:setString("")
        local Text_now_effice_v = ccui.Helper:seekWidgetByName(root, "Text_now_effice_v")               --当前属性值
        local Text_now_effice = ccui.Helper:seekWidgetByName(root, "Text_now_effice")                   --当前属性名
        local Text_now_effice_v_0 = ccui.Helper:seekWidgetByName(root, "Text_now_effice_v_0")           --下一级属性值
        local Text_next_effice = ccui.Helper:seekWidgetByName(root, "Text_next_effice")                 --下一级属性名
        local Text_experience_pragress = ccui.Helper:seekWidgetByName(root, "Text_experience_pragress") --附魔经验值
        local LoadingBar_experience = ccui.Helper:seekWidgetByName(root, "LoadingBar_experience")       --附魔经验百分比
        Text_now_effice:setString("")
        Text_now_effice_v:setString("")
        Text_next_effice:setString("")
        Text_now_effice_v_0:setString("")
        Text_experience_pragress:setString("")
        LoadingBar_experience:setPercent(0)
        --橙色碎片描述
        local Text_explian = ccui.Helper:seekWidgetByName(root, "Text_explian")
        Text_explian:setVisible(false)
        if self._chooseHorseSpirit == nil then
            Text_soul_piece:setString(_my_gane_name[15])
            Text_soul_piece:setColor(cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]))
            Panel_soul_piece:setBackGroundImage("images/ui/props/props_4021.png")
            Text_explian:setVisible(true)
            Text_explian:setString(_All_tip_string_info_description._horseSoulDescription)
            ccui.Helper:seekWidgetByName(root, "Panel_soul"):setVisible(false)
            self:onUpdateButtonState(3, false)
            return
        end
        --附魔名称(根据品质设置颜色)
        local name = dms.string(dms["horse_spirit_mould"], horse.mould_id, horse_spirit_mould.horse_spirit_name)
        local quality = dms.int(dms["horse_spirit_mould"], horse.mould_id, horse_spirit_mould.quality)
        Text_soul_piece:setString(name)
        Text_soul_piece:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
        --附魔图像
        local picIndex = dms.int(dms["horse_spirit_mould"], horse.mould_id, horse_spirit_mould.icon)
        Panel_soul_piece:setBackGroundImage(string.format("images/ui/enchant/enchant_%d.png", picIndex))
        --附魔类型
        local horse_spirit_type = dms.int(dms["horse_spirit_mould"], horse.mould_id, horse_spirit_mould.horse_spirit_type)
        --描述
        local desc = dms.string(dms["horse_spirit_mould"], horse.mould_id, horse_spirit_mould.desc)
        --升级消耗经验
        local maxExp = dms.int(dms["horse_spirit_mould"], horse.mould_id, horse_spirit_mould.upgrade_cost_exp)
        --属性
        local attributes = dms.string(dms["horse_spirit_mould"], horse.mould_id, horse_spirit_mould.attributes)
        --下一级id
        local next_level_id = dms.int(dms["horse_spirit_mould"], horse.mould_id, horse_spirit_mould.next_level_id)
        local isFullLevel = false
        if horse_spirit_type == 1 then
            --当前经验/升级所需经验
            Text_experience_pragress:setString(horse.now_exp.."/"..maxExp)
            LoadingBar_experience:setPercent(tonumber(horse.now_exp)/maxExp * 100)

            ccui.Helper:seekWidgetByName(root, "Text_next_lv"):setVisible(true)
            ccui.Helper:seekWidgetByName(root, "Panel_soul"):setVisible(true)
            --当前属性效果
            local attributes_info = zstring.split(attributes, ",")
            Text_now_effice:setString(attribute[tonumber(attributes_info[1]) + 1])
            local is_handred = false
            for i,v in pairs(attribute_hundred) do
                if tonumber(attributes_info[1]) == v then
                    is_handred = true
                end
            end
            if is_handred == true then
                Text_now_effice_v:setString("+"..attributes_info[2].."%")
            else
                Text_now_effice_v:setString("+"..attributes_info[2])
            end
            --如果当前附魔不是最大级显示下一级效果
            if next_level_id > 0 then
                local next_attributes = dms.string(dms["horse_spirit_mould"], next_level_id, horse_spirit_mould.attributes)
                local next_attributes_info = zstring.split(next_attributes, ",")
                Text_next_effice:setString(attribute[tonumber(next_attributes_info[1]) + 1])
                if is_handred == true then
                    Text_now_effice_v_0:setString("+"..next_attributes_info[2].."%")
                else
                    Text_now_effice_v_0:setString("+"..next_attributes_info[2])
                end
            else    --如果当前附魔是最大级显示已满级
                isFullLevel = true
                Text_experience_pragress:setString(tipStringInfo_union_str[70])
                ccui.Helper:seekWidgetByName(root, "Text_next_lv"):setVisible(false)
            end
        else
            Text_explian:setVisible(true)
            Text_explian:setString(desc)
            ccui.Helper:seekWidgetByName(root, "Panel_soul"):setVisible(false)
        end
        self:onUpdateButtonState(horse_spirit_type, isFullLevel)
    end
end

function RacecoursePack:onUpdateDraw()
    local root = self.roots[1]
    local state_machineName = ""
    local but_image_name = ""
    if self._open_type == 1 then
        state_machineName = "racecourse_pack_show_racecourse"
        but_image_name = "Button_horse"
    elseif self._open_type == 2 then
        state_machineName = "racecourse_pack_show_horse_soul"
        but_image_name = "Button_soul"
    end
    state_machine.excute("racecourse_pack_window_manager",0,
        {
            _datas = {
                terminal_name = "racecourse_pack_window_manager",     
                next_terminal_name = state_machineName, 
                current_button_name = but_image_name,   
                but_image = "",     
                terminal_state = 0, 
                touch_scale = true,
                touch_scale_xy = 0.95, 
            }
        }
    )
    if self._select_ship ~= nil and self._choose_horse ~= nil and self._index == 2 then
        ccui.Helper:seekWidgetByName(root, "Button_wear"):setVisible(true)
    else
        ccui.Helper:seekWidgetByName(root, "Button_wear"):setVisible(false)
    end
end

function RacecoursePack:onInit( )
    local csbItem = csb.createNode(config_csb.horse.treasure_pack)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local Panel_packs = ccui.Helper:seekWidgetByName(root,"Panel_packs")
    Panel_packs:removeAllChildren(true)
    self.panel = Panel_packs
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "racecourse_pack_window_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    -- 珍兽
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_horse"), nil, 
    {
        terminal_name = "racecourse_pack_window_manager",     
        next_terminal_name = "racecourse_pack_show_racecourse", 
        current_button_name = "Button_horse",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)

    -- 兽魂
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_soul"), nil, 
    {
        terminal_name = "racecourse_pack_window_manager",     
        next_terminal_name = "racecourse_pack_show_horse_soul", 
        current_button_name = "Button_soul",   
        but_image = "",     
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 3)

    -- 穿戴
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wear"), nil, 
    {
        terminal_name = "racecourse_pack_wear",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    -- 镶嵌
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_change"), nil, 
    {
        terminal_name = "racecourse_pack_recharge", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_composition"), nil, 
    {
        terminal_name = "racecourse_soul_exchange_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_strength"), nil, 
    {
        terminal_name = "racecourse_pack_strength", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    self:onUpdateDraw()
end

function RacecoursePack:getSortForFight()
    local result = {}
    for i,v in pairs(_ED.user_ship) do
        table.insert(result,v)
    end
    local all_result = {}
    local in_formation = {}
    local in_raleship = {}
    local gold_ship = {} -- 6
    local red_ship = {}  -- 5
    local orange_ship = {} -- 4
    local purple_ship = {} -- 3
    local blue_ship = {} -- 2 
    local green_ship = {} -- 1
    local white_ship = {} -- 0
    local function sortShipFight( a, b )
        return tonumber(a.hero_fight) > tonumber(b.hero_fight)
    end
    table.sort(result, sortShipFight)

    for i,ship in pairs(result) do
        if zstring.tonumber(ship.formation_index) > 0 then
        elseif zstring.tonumber(ship.little_partner_formation_index) > 0 then
        elseif zstring.tonumber(ship.ship_type) == 6 then
            table.insert(gold_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 5 then
            table.insert(red_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 4 then
            table.insert(orange_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 3 then
            table.insert(purple_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 2 then
            table.insert(blue_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 1 then
            table.insert(green_ship, ship)
        elseif zstring.tonumber(ship.ship_type) == 0 then
            table.insert(white_ship, ship)
        end
    end
    self.ship_numbers = 0
    local formation_temp = {}
    local position_str = dms.string(dms["formation_mould"],tonumber(_ED.formetion[1]),formation_mould.position)
    position_str = zstring.split(position_str,",")
    for i,v in pairs(position_str) do
        if zstring.tonumber(_ED.formetion[i+1]) ~= 0 then
            table.insert(formation_temp,_ED.user_ship["".._ED.formetion[i+1]])
        end
    end

    local formation_temp_change_index = {}
    for i,v in pairs(formation_temp) do
        table.insert(formation_temp_change_index,formation_temp[#formation_temp-i+1])
    end

    for i,v in pairs(formation_temp_change_index) do
       table.insert(all_result,v)
    end
    
    for i,v in pairs(in_raleship) do
       table.insert(all_result,v)
    end

    for i,v in pairs(gold_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(red_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(orange_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(purple_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(green_ship) do
        table.insert(all_result,v)
    end  
    for i,v in pairs(blue_ship) do
       table.insert(all_result,v)
    end
    for i,v in pairs(white_ship) do
       table.insert(all_result,v)
    end
    return all_result
end

function RacecoursePack:init(params)
    self.user_ships = self:getSortForFight()
    if params[5] ~= nil then
        self._select_ship = params[5]
    else
        self._select_ship = self.user_ships[1]
    end
    self._open_type = params[1]
    self._index = params[2]
    self._horse_soul = params[3]
    if params[4] ~= nil then
        self._chooseIndex = params[4]
    end
    self:onInit()
    return self
end

function RacecoursePack:onExit()
    state_machine.remove("racecourse_pack_window_manager")
    state_machine.remove("racecourse_pack_show_racecourse")
    state_machine.remove("racecourse_pack_show_horse_soul")
    state_machine.remove("racecourse_pack_left_prop_draw")
    state_machine.remove("racecourse_pack_wear")
    state_machine.remove("racecourse_pack_recharge")
    state_machine.remove("racecourse_pack_strength")
end