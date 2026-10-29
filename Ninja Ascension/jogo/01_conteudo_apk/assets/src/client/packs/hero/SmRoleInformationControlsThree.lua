-- ----------------------------------------------------------------------------------------------------
-- 说明：角色信息界面控件3
-------------------------------------------------------------------------------------------------------
SmRoleInformationControlsThree = class("SmRoleInformationControlsThreeClass", Window)
SmRoleInformationControlsThree.__size = nil

local sm_role_information_controls_three_open_terminal = {
    _name = "sm_role_information_controls_three_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local cell = SmRoleInformationControlsThree:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_information_controls_three_close_terminal = {
    _name = "sm_role_information_controls_three_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleInformationControlsThreeClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleInformationControlsThreeClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_information_controls_three_open_terminal)
state_machine.add(sm_role_information_controls_three_close_terminal)
state_machine.init()
    
function SmRoleInformationControlsThree:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0
    app.load("client.shop.recruit.SmGeneralsCard")
    local function init_sm_role_information_controls_three_terminal()
        -- 显示界面
        local sm_role_information_controls_three_display_terminal = {
            _name = "sm_role_information_controls_three_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationControlsThreeWindow = fwin:find("SmRoleInformationControlsThreeClass")
                if SmRoleInformationControlsThreeWindow ~= nil then
                    SmRoleInformationControlsThreeWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_information_controls_three_hide_terminal = {
            _name = "sm_role_information_controls_three_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleInformationControlsThreeWindow = fwin:find("SmRoleInformationControlsThreeClass")
                if SmRoleInformationControlsThreeWindow ~= nil then
                    SmRoleInformationControlsThreeWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_information_controls_three_display_terminal)
        state_machine.add(sm_role_information_controls_three_hide_terminal)
        state_machine.init()
    end
    init_sm_role_information_controls_three_terminal()
end

function SmRoleInformationControlsThree:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local ship_id = nil
    if zstring.tonumber(self.m_type) == -1 then
        ship_id = self.ship_id.ship_template_id
    else
        ship_id = self.ship_id
    end
    local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], ship_id, ship_mould.relationship_id), ",")
    local Text_fighting_0 = ccui.Helper:seekWidgetByName(root, "Text_fighting_0")
    local m_height = 0 
    local n_width = 0
    for i, v in pairs(myRelatioInfo) do
        local name = dms.string(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_name)
        local name_datas = dms.element(dms["word_mould"], zstring.tonumber(name))
        name = name_datas[3]
        Text_fighting_0:setString(name..":")
        if n_width < Text_fighting_0:getAutoRenderSize().width then
            n_width = Text_fighting_0:getAutoRenderSize().width
        end
        Text_fighting_0:setString("")
    end

    for i, v in pairs(myRelatioInfo) do
        local name = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_name)
        local name_datas = dms.element(dms["word_mould"], zstring.tonumber(name))
        name = name_datas[3]
        local describe = dms.string(dms["fate_relationship_mould"], v, fate_relationship_mould.relation_describe)
        local strs = zstring.split(describe, "|")
        describe = ""
        if #strs > 1 then
            for j, v in pairs(strs) do
                if zstring.tonumber(v) ~= nil then
                    local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
                    describe = describe .. word_info[3]
                else
                    describe = describe .. v
                end
            end
        else
            if zstring.tonumber(strs[1]) ~= nil then
                local word_info = dms.element(dms["word_mould"], zstring.tonumber(strs[1]))
                describe = word_info[3] 
            else
                describe = strs[1]
            end
        end
        local numbers = 0
        local ship_list = {}
        local activation_list = {}
        local addition = 0
        for j=1, 6 do
            local needId = dms.int(dms["fate_relationship_mould"], v, j+4+(j-1)*2-j)
            if needId > 0 then
                local needType = dms.int(dms["fate_relationship_mould"], v, j+4+(j-1)*2-j+1)
                numbers = numbers + 1
                local needName = ""
                if needType == 0 then
                    --数码兽
                    local evo_image = dms.string(dms["ship_mould"], needId, ship_mould.fitSkillTwo)
                    local evo_info = zstring.split(evo_image, ",")
                    local needShip = fundShipWidthTemplateId(needId)
                    if zstring.tonumber(self.m_type) == -1 then
                        local isHaveSame = false
                        for k,v in pairs(self.ship_id.ship_list) do
                            if tonumber(v) == tonumber(needId) then
                                isHaveSame = true
                            end
                        end
                        local evo_mould_id = 0
                        local my_ship_data = nil
                        for i, v in pairs(_ED.user_ship) do
                            if tonumber(v.ship_template_id) == tonumber(needId) then
                                my_ship_data = v
                                break
                            end
                        end
                        if my_ship_data then
                            local ship_evo = zstring.split(my_ship_data.evolution_status, "|")
                            evo_mould_id = evo_info[tonumber(ship_evo[1])]
                        else
                            evo_mould_id = evo_info[dms.int(dms["ship_mould"], needId, ship_mould.captain_name)]
                            if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                                evo_mould_id = evo_info[dms.int(dms["ship_mould"], ship_id, ship_mould.captain_name)]
                            end  
                        end

                        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
                        local word_info = dms.element(dms["word_mould"], name_mould_id)
                        if isHaveSame == true then
                            table.insert(ship_list, "%|3|"..word_info[3].."%")
                            table.insert(activation_list, 1)
                        else
                            table.insert(ship_list, "%|2|"..word_info[3].."%")
                        end
                    elseif needShip ~= nil then
                        --进化模板id
                        local ship_evo = zstring.split(needShip.evolution_status, "|")
                        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
                        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
                        local word_info = dms.element(dms["word_mould"], name_mould_id)
                        table.insert(ship_list, "%|3|"..word_info[3].."%")
                        table.insert(activation_list, 1)
                    else
                        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], needId, ship_mould.captain_name)]
                        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
                        local word_info = dms.element(dms["word_mould"], name_mould_id)
                        table.insert(ship_list, "%|2|"..word_info[3].."%")
                    end
                elseif needType == 1 then
                    --装备
                    local nameindex = dms.int(dms["equipment_mould"], needId, equipment_mould.equipment_name)
                    local word_info = dms.element(dms["word_mould"], nameindex)
                    local ship = fundShipWidthTemplateId(ship_id)
                    if zstring.tonumber(self.m_type) == -1 then
                        ship = self.ship_id
                        -- table.insert(ship_list, "%|2|"..word_info[3].."%")
                    end
                    local isSame = false
                    if ship == nil then
                        isSame = false
                    else
                        --武将装备数据(等级|品质|经验|星级|模板)
                        local shipEquip = zstring.split(ship.equipInfo, "|")
                        --初始装备
                        local equipAll = dms.string(dms["ship_mould"], ship.ship_template_id, ship_mould.treasureSkill)
                        local equipData = zstring.split(shipEquip[5], ",")
                        local equipStar = zstring.split(shipEquip[4], ",")
                        
                        for x=1, 6 do
                            local equipMouldId = equipData[x]
                            --装备模板id
                            local equipMid = 0
                            if tonumber(equipStar[x]) == 0 then
                                local equipMouldData = zstring.split(equipAll, ",")
                                equipMid = tonumber(equipMouldData[x])
                            else
                                equipMid = tonumber(equipMouldId)
                            end
                            if needId == equipMid then
                                isSame = true
                                break
                            end
                        end
                    end
                    if isSame == true then
                        table.insert(ship_list, "%|3|"..word_info[3].."%")
                        table.insert(activation_list, 1)
                    else
                        table.insert(ship_list, "%|2|"..word_info[3].."%")
                    end
                elseif needType == 2 then  
                    --皮肤
                end 
            end
        end
        for j=1,2 do
            if dms.int(dms["fate_relationship_mould"], v, 15+j) > 0 then
                numbers = numbers + 1
                addition = dms.int(dms["fate_relationship_mould"], v, 15+j)
                table.insert(ship_list, addition.."%")
                table.insert(activation_list, 1)
            end
        end
        if #ship_list == 1 then
            describe = string.format(describe, ship_list[1])
        elseif #ship_list == 2 then
            describe = string.format(describe, ship_list[1],ship_list[2])
        elseif #ship_list == 3 then
            describe = string.format(describe, ship_list[1],ship_list[2],ship_list[3])
        elseif #ship_list == 4 then
            describe = string.format(describe, ship_list[1],ship_list[2],ship_list[3],ship_list[4])
        elseif #ship_list == 5 then
            describe = string.format(describe, ship_list[1],ship_list[2],ship_list[3],ship_list[4],ship_list[5])
        elseif #ship_list == 6 then
            describe = string.format(describe, ship_list[1],ship_list[2],ship_list[3],ship_list[4],ship_list[5],ship_list[6])
        elseif #ship_list == 7 then
            describe = string.format(describe, ship_list[1],ship_list[2],ship_list[3],ship_list[4],ship_list[5],ship_list[6],ship_list[7])
        end

        local _richText1 = ccui.RichText:create()
        _richText1:ignoreContentAdaptWithSize(false)
        local colors = nil
        if #ship_list == 0 then
            colors = the_color_of_the_fetters[3]
        else
            if #ship_list == #activation_list then
                colors = the_color_of_the_fetters[4]
            else
                colors = the_color_of_the_fetters[3]
            end
        end
        local re1 =ccui.RichElementText:create(1, colors,255, name..":",Text_fighting_0:getFontName(), Text_fighting_0:getFontSize())
        _richText1:pushBackElement(re1)
        _richText1:setContentSize(cc.size(n_width,Text_fighting_0:getContentSize().height))
        _richText1:setAnchorPoint(0,0.5)
        Text_fighting_0:addChild(_richText1)
        _richText1:setPosition(cc.p(0-n_width/2,Text_fighting_0:getContentSize().height/2-m_height))
        

        local _richText2 = ccui.RichText:create()
        _richText2:ignoreContentAdaptWithSize(false)

        local richTextWidth = Text_fighting_0:getContentSize().width-n_width
        if richTextWidth == 0 then
            richTextWidth = Text_fighting_0:getFontSize() * 6
        end
                
        _richText2:setAnchorPoint(cc.p(0, 0))
        -- DSC羁绊描述为上下分布，富文本宽度为Text的宽度
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_naruto then
            _richText2:setContentSize(cc.size(Text_fighting_0:getContentSize().width, Text_fighting_0:getContentSize().height))
        else
            _richText2:setContentSize(cc.size(richTextWidth, Text_fighting_0:getContentSize().height))
        end

        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            color_Type_1 = cc.c3b(71,71,71)
            color_Type_2 = cc.c3b(71,71,71)
        else
            color_Type_1 = cc.c3b(255,255,255)
            color_Type_2 = cc.c3b(255,255,255)
        end

        local char_str = describe
        local rt, count, text = draw.richTextCollectionMethod(_richText2, 
            char_str, 
            color_Type_1,
            color_Type_2,
            0, 
            0, 
            Text_fighting_0:getFontName(), 
            Text_fighting_0:getFontSize(),
            the_color_of_the_fetters)
        _richText2:formatTextExt()
        local rsize = _richText2:getContentSize()
        Text_fighting_0:addChild(_richText2)

        local newHeight = 0
        
        -- DSC羁绊描述为上下分布
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_naruto then
            local tempHeight1 = _richText1:getContentSize().height
            _richText2:setPosition(cc.p(0, 0 - m_height - tempHeight1))
            
            newHeight = tempHeight1 + _richText2:getContentSize().height + Text_fighting_0:getFontSize() * 3 / 2

        else
            _richText2:setPosition(cc.p(n_width, 0 - m_height))

            newHeight = _richText2:getContentSize().height + Text_fighting_0:getFontSize() * 3 / 2
        end

        if newHeight <= Text_fighting_0:getContentSize().height then
            newHeight = Text_fighting_0:getContentSize().height
        end

        m_height = m_height + newHeight
    end

    local up = m_height - Text_fighting_0:getContentSize().height
    root:setContentSize(cc.size(root:getContentSize().width,root:getContentSize().height + up))
    local Panel_jichuxinxi = ccui.Helper:seekWidgetByName(root, "Panel_jichuxinxi")
    Panel_jichuxinxi:setPositionY(Panel_jichuxinxi:getPositionY()+up)

end

function SmRoleInformationControlsThree:init(params)
    --模板id
    self.ship_id = params[1]
    self.isMould = params[2]
    self.m_type = params[3] or nil
    self:onInit()
    return self
end

function SmRoleInformationControlsThree:onInit()
    local csbSmRoleInformationControlsThree = csb.createNode("packs/HeroStorage/sm_generals_information_3.csb")
    local root = csbSmRoleInformationControlsThree:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleInformationControlsThree)
	if SmRoleInformationControlsThree.__size == nil then
        SmRoleInformationControlsThree.__size = root:getContentSize()
    end
    self:onUpdateDraw()
end

function SmRoleInformationControlsThree:onExit()
    state_machine.remove("sm_role_information_controls_three_display")
    state_machine.remove("sm_role_information_controls_three_hide")
end