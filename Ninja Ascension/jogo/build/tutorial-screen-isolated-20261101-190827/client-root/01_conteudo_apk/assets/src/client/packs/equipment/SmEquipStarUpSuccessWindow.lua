-- ----------------------------------------------------------------------------------------------------
-- 说明：装备升品升星成功
-------------------------------------------------------------------------------------------------------
SmEquipStarUpSuccessWindow = class("SmEquipStarUpSuccessWindowClass", Window)

local equip_star_up_success_window_open_terminal = {
    _name = "equip_star_up_success_window_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmEquipStarUpSuccessWindowClass")
        if nil == _homeWindow then
            local panel = SmEquipStarUpSuccessWindow:new():init(params)
            fwin:open(panel,fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local equip_star_up_success_window_close_terminal = {
    _name = "equip_star_up_success_window_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        smFightingChange()
        state_machine.unlock("equip_icon_cell_change_ship_equip")
        state_machine.unlock("sm_equipment_tab_awakening_treasure_upgrade")
		local _homeWindow = fwin:find("SmEquipStarUpSuccessWindowClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmEquipStarUpSuccessWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(equip_star_up_success_window_open_terminal)
state_machine.add(equip_star_up_success_window_close_terminal)
state_machine.init()
    
function SmEquipStarUpSuccessWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    app.load("client.cells.equip.equip_icon_cell")

    local function init_equip_star_up_success_window_terminal()
        -- 显示界面
        local equip_star_up_success_window_display_terminal = {
            _name = "equip_star_up_success_window_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local equip_star_up_success_window_hide_terminal = {
            _name = "equip_star_up_success_window_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equip_star_up_success_window_display_terminal)
        state_machine.add(equip_star_up_success_window_hide_terminal)
        
        state_machine.init()
    end
    init_equip_star_up_success_window_terminal()
end

function SmEquipStarUpSuccessWindow:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local animation_name = nil
    local continued_name = nil
    if tonumber(self.m_type) == 1 then
        animation_name = "jinjiechenggong"
        continued_name = "jinjiechenggong2"
    elseif tonumber(self.m_type) == 2 then
        animation_name = "shengxingchenggong"
        continued_name = "shengxingchenggong2"
    end

    local Panel_dh = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_dh")
    Panel_dh:removeAllChildren(true)
    
    local isOver = false
    local function onFrameEventBullet(bone,evt,originFrameIndex,currentFrameIndex)
        if evt ~= nil and #evt > 0 then
            if evt == "union_10010103" then
                local jsonFile2 = "sprite/effect_10010103.json"
                local atlasFile2 = "sprite/effect_10010103.atlas"
                local animation2 = sp.spine(jsonFile2, atlasFile2, 1, 0, "animation", true, nil)
                animation2:setTag(1205)
                Panel_dh:addChild(animation2)
            elseif evt == "union_10010104" then
                if Panel_dh:getChildByTag(1205) ~= nil then
                    Panel_dh:removeChildByTag(1205)
                end
                if isOver == false then
                    isOver = true
                    local jsonFile3 = "sprite/effect_10010104.json"
                    local atlasFile3 = "sprite/effect_10010104.atlas"
                    local animation3 = sp.spine(jsonFile3, atlasFile3, 1, 0, "animation", true, nil)
                    Panel_dh:addChild(animation3)
                end
            end
        end
    end
    local jsonFile = "sprite/sprite_sjsx.json"
    local atlasFile = "sprite/sprite_sjsx.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, animation_name, true, nil)
    animation.animationNameList = {animation_name,continued_name}
    sp.initArmature(animation, false)
    animation._invoke = changeActionCallback
    animation:getAnimation():setFrameEventCallFunc(onFrameEventBullet)
    animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    csb.animationChangeToAction(animation, 0, 1, false)
    Panel_dh:addChild(animation)

    --头像
    local Panel_digimon_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_1")
    local Panel_digimon_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_digimon_icon_2")

    --老装备
    local oldEquip = self.equip
    local new_template = self.equip.user_equiment_template
    oldEquip.user_equiment_template = oldEquip.old_template

    --武将装备数据（等级|品质|经验|星级|模板）
    local oldShipEquip = zstring.split(oldEquip.equipInfo, "|")
    local oldstarts = zstring.split(oldShipEquip[4], ",")
    local oldLevels = zstring.split(oldShipEquip[1], ",")
    local cell = self:createEquipHead(19,oldEquip)
    Panel_digimon_icon_1:addChild(cell)
    cell:setPosition(cell:getPositionX()-8,cell:getPositionY()-6)
    if tonumber(self.m_type) == 2 then
        neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_star"), tonumber(oldstarts[tonumber(self.equip.m_index)])-1)
    else
        neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_star"), tonumber(oldstarts[tonumber(self.equip.m_index)]))
    end

    --新装备
    local newEquip = self.equip
    newEquip.equipInfo = newEquip.quipInfo
    newEquip.user_equiment_template = new_template
    --武将装备数据（等级|品质|经验|星级|模板）
    local newShipEquip = zstring.split(newEquip.quipInfo, "|")
    local newstarts = zstring.split(newShipEquip[4], ",")
    local newLevels = zstring.split(newShipEquip[1], ",")
    local cell2 = self:createEquipHead(19,newEquip)
    Panel_digimon_icon_2:addChild(cell2)
    cell2:setPosition(cell2:getPositionX()-8,cell2:getPositionY()-6)
    neWshowShipStar(ccui.Helper:seekWidgetByName(cell2.roots[1], "Panel_star"), tonumber(newstarts[tonumber(self.equip.m_index)]))

    --名称
    local Text_name_1 = ccui.Helper:seekWidgetByName(root, "Text_name_1")
    local Text_name_2 = ccui.Helper:seekWidgetByName(root, "Text_name_2")
    --获取装备名称索引
    local nameindex = dms.int(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.equipment_name)
    --通过索引找到word_mould
    local word_info = dms.element(dms["word_mould"], nameindex)
    local name = word_info[3]
    local oldGrade = zstring.split(oldShipEquip[2], ",")
    local newGrade = zstring.split(newShipEquip[2], ",")
    local name1 = nil
    local name2 = nil
    local old_name = nil
    local temp_equip = nil
    if tonumber(self.m_type) == 2 then
        --初次觉醒名称
        local user_equiment_new_id = dms.int(dms["equipment_mould"], self.equip.old_template, equipment_mould.equipment_seat)
        local name_index = dms.int(dms["equipment_mould"], self.equip.old_template, equipment_mould.equipment_name)
        --通过索引找到word_mould
        old_name = dms.element(dms["word_mould"], name_index)[3]
    end
    old_name = old_name or name

    if getShipNameOrder(tonumber(oldGrade[tonumber(self.equip.m_index)])) > 0 then
        name1 = old_name.."+"..getShipNameOrder(tonumber(oldGrade[tonumber(self.equip.m_index)]))
    else
        name1 = old_name    
    end
    Text_name_1:setString(name1)

    

    if getShipNameOrder(tonumber(newGrade[tonumber(self.equip.m_index)])) > 0 then
        name2 = name.."+"..getShipNameOrder(tonumber(newGrade[tonumber(self.equip.m_index)]))
    else
        name2 = name  
    end
    Text_name_2:setString(name2)

    local quality1 = shipOrEquipSetColour(tonumber(oldGrade[tonumber(self.equip.m_index)]))
    local quality2 = shipOrEquipSetColour(tonumber(newGrade[tonumber(self.equip.m_index)]))
    Text_name_1:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality1][1], tipStringInfo_quality_color_Type[quality1][2], tipStringInfo_quality_color_Type[quality1][3]))
    Text_name_2:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality2][1], tipStringInfo_quality_color_Type[quality2][2], tipStringInfo_quality_color_Type[quality2][3]))


    -- --战力
    local Text_zdl = ccui.Helper:seekWidgetByName(root, "Text_zdl")
    
    local Text_fighting_n_1 = ccui.Helper:seekWidgetByName(root, "Text_fighting_n_1")
    local Text_fighting_n_2 = ccui.Helper:seekWidgetByName(root, "Text_fighting_n_2")
    local Image_arrow_2 = ccui.Helper:seekWidgetByName(root, "Image_arrow_2")
    local Text_sd = ccui.Helper:seekWidgetByName(root, "Text_sd")
    
    local Text_speed_n_1 = ccui.Helper:seekWidgetByName(root, "Text_speed_n_1")
    local Text_speed_n_2 = ccui.Helper:seekWidgetByName(root, "Text_speed_n_2")
    local Image_arrow_3 = ccui.Helper:seekWidgetByName(root, "Image_arrow_3")
    local Image_word_bg_2 = ccui.Helper:seekWidgetByName(root, "Image_word_bg_2")
    local Text_zdl_0 = nil
    local Text_sd_0 = nil
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
        Text_sd_0 = ccui.Helper:seekWidgetByName(root, "Text_sd_0")
        Text_zdl_0 = ccui.Helper:seekWidgetByName(root, "Text_zdl_0")
        Text_zdl_0:setVisible(false)
        Text_sd_0:setVisible(false)
    end
    Text_zdl:setVisible(false)
    Text_fighting_n_1:setVisible(false)
    Text_fighting_n_2:setVisible(false)
    Image_arrow_2:setVisible(false)
    Text_sd:setVisible(false)
    Text_speed_n_1:setVisible(false)
    Text_speed_n_2:setVisible(false)
    Image_arrow_3:setVisible(false)

    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital and Image_word_bg_2 then
        Image_word_bg_2:setVisible(false)
    end

    local baseValue = dms.string(dms["equipment_mould"], self.equip.user_equiment_template, equipment_mould.initial_value)
    local oldequipAttributes = nil
    if tonumber(self.m_type) == 2 then
        oldequipAttributes = equipmentPropertyCalculationFormula(oldEquip.old_template,tonumber(oldGrade[tonumber(self.equip.m_index)]),tonumber(oldstarts[tonumber(self.equip.m_index)])-1,tonumber(oldLevels[tonumber(self.equip.m_index)]))
    else
        oldequipAttributes = equipmentPropertyCalculationFormula(oldEquip.user_equiment_template,tonumber(oldGrade[tonumber(self.equip.m_index)]),tonumber(oldstarts[tonumber(self.equip.m_index)]),tonumber(oldLevels[tonumber(self.equip.m_index)]))
    end
    
    local newequipAttributes = equipmentPropertyCalculationFormula(self.equip.user_equiment_template,tonumber(newGrade[tonumber(self.equip.m_index)]),tonumber(newstarts[tonumber(self.equip.m_index)]),tonumber(newLevels[tonumber(self.equip.m_index)]))
    local valueList = zstring.split(baseValue, "|")
    local index = 0
    for i, v in pairs(valueList) do
        index = index + 1
        if index == 1 then
            Text_zdl:setVisible(true)
            if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece ) and Text_zdl_0 then
                Text_zdl_0:setVisible(true)
            end
            Text_fighting_n_1:setVisible(true)
            Text_fighting_n_2:setVisible(true)
            Image_arrow_2:setVisible(true)
        elseif index == 2 then
            Text_sd:setVisible(true)
            if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece ) and Text_sd_0 then
                Text_sd_0:setVisible(true)
            end
            Text_speed_n_1:setVisible(true)
            Text_speed_n_2:setVisible(true)
            Image_arrow_3:setVisible(true)
            -- DSC重塑
            if __lua_project_id == __lua_project_l_digital and Image_word_bg_2 then
                Image_word_bg_2:setVisible(true)
            end
        end

        local attributeList = zstring.split(v, ",")
        local typeIndex = tonumber(attributeList[1]) + 1
        --判断是否追加百分比符号---------------------------------------------------------------------------
        local addPercent = ""
        if typeIndex >= 5 and typeIndex <= 18 then
            addPercent = "%"
        elseif typeIndex >= 34 and typeIndex <= 35 then
            addPercent = "%"
        end
        if index == 1 then
            Text_zdl:setString(string_equiprety_name[typeIndex])
            if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece ) and Text_zdl_0 then
                Text_zdl_0:setString(string_equiprety_name[typeIndex])
            end
            -- Text_fighting_n_1:setString(attributeList[2])
            -- Text_fighting_n_2:setString(attributeList[2])
            Text_fighting_n_1:setString("+"..oldequipAttributes[index]..addPercent)
            Text_fighting_n_2:setString("+"..newequipAttributes[index]..addPercent)
        else
            Text_sd:setString(string_equiprety_name[typeIndex])
            if (__lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece ) and Text_sd_0 then
                Text_sd_0:setString(string_equiprety_name[typeIndex])
            end
            -- Text_speed_n_1:setString(attributeList[2])
            -- Text_speed_n_2:setString(attributeList[2])
            Text_speed_n_1:setString("+"..oldequipAttributes[index]..addPercent)
            Text_speed_n_2:setString("+"..newequipAttributes[index]..addPercent)
        end
        
    end

    local Text_zdl_1 = ccui.Helper:seekWidgetByName(root, "Text_zdl_1") 
    local Panel_skill_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon_1") 
    Panel_skill_icon_1:removeAllChildren(true)
    local Panel_jnjs = ccui.Helper:seekWidgetByName(root, "Panel_jnjs")  
    local Panel_queding = ccui.Helper:seekWidgetByName(root, "Panel_queding")  

    if tonumber(self.m_type) == 1 then
        Text_zdl_1:setVisible(false)
        Panel_jnjs:setVisible(false)
        Panel_queding:setVisible(true)
    elseif tonumber(self.m_type) == 2 then              --升星
        Text_zdl_1:setVisible(false)
        Panel_jnjs:setVisible(false)
        Panel_queding:setVisible(true)
    end
end

function SmEquipStarUpSuccessWindow:createEquipHead(objectType,ship)
    local cell = EquipIconCell:createCell()
    cell:init(objectType,ship)
    return cell
end

function SmEquipStarUpSuccessWindow:init(params)
    self.equip = params[1]
    self.m_type = params[2] --1是武将升品，2是武将升星
    self:onInit()
    return self
end

function SmEquipStarUpSuccessWindow:onInit()
    local csbSmEquipStarUpSuccessWindow = csb.createNode("packs/HeroStorage/generals_star_up_success_window.csb")
    local root = csbSmEquipStarUpSuccessWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmEquipStarUpSuccessWindow)
    local action = csb.createTimeline("packs/HeroStorage/generals_star_up_success_window.csb")
    table.insert(self.actions, action)
    csbSmEquipStarUpSuccessWindow:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("zhankai", false)

    playEffect(formatMusicFile("effect", 9981))

    self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Panel_bg"), nil, 
    -- {
    --     terminal_name = "equip_star_up_success_window_close", 
    --     terminal_state = 0,
    --     isPressedActionEnabled = true
    -- }, 
    -- nil, 3)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_ok"), nil, 
    {
        terminal_name = "equip_star_up_success_window_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 3)

	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    -- {
        -- terminal_name = "red_alert_time_mine_help_info_close",
        -- terminal_state = 0,
    -- },
    -- nil,3)
	
end

function SmEquipStarUpSuccessWindow:onExit()
    state_machine.remove("equip_star_up_success_window_hide")
    state_machine.remove("equip_star_up_success_window_display")

end