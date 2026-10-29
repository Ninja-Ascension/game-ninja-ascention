--------------------------------------------------------------------------------------------------------------
SmRoleFashionCard = class("SmRoleFashionCardClass", Window)
SmRoleFashionCard.__size = nil

local sm_role_fashion_card_cell_terminal = {
    _name = "sm_role_fashion_card_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmRoleFashionCard:new():init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_fashion_card_cell_terminal)
state_machine.init()

function SmRoleFashionCard:ctor()
    self.super:ctor()
    self.roots = {}

    self._chooseShip = nil
    self._index = 0
    self._isChoose = false

    local function init_sm_role_fashion_card_cell_terminal()
        local sm_role_fashion_card_cell_choose_terminal = {
            _name = "sm_role_fashion_card_cell_choose",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell._isChoose == true then
                    return
                end
                state_machine.excute("sm_role_fashion_choose_fashion", 0, cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_role_fashion_card_cell_choose_terminal)
        state_machine.init()
    end 
    init_sm_role_fashion_card_cell_terminal()
end

function SmRoleFashionCard:updateChooseState(isChoose)
    local root = self.roots[1]
    local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
    Image_xuanzhong:setVisible(isChoose)
end

function SmRoleFashionCard:updateDraw()
    local root = self.roots[1]
    local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head")
    local Panel_jqqd = ccui.Helper:seekWidgetByName(root, "Panel_jqqd")
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    local Text_shuxing_1 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_1")
    local Text_shuxing_2 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_2")
    local Text_tips = ccui.Helper:seekWidgetByName(root, "Text_tips")
    local Image_5 = ccui.Helper:seekWidgetByName(root, "Image_5")
    local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
    local Image_suo = ccui.Helper:seekWidgetByName(root, "Image_lock")
    local Text_shuxing_3 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_3")
    local Text_shuxing_0 = ccui.Helper:seekWidgetByName(root, "Text_shuxing_0")
    self.is_unlock = false
    Panel_head:removeAllChildren(true)
    Text_name:setString("")
    Text_shuxing_1:setString("")
    Text_shuxing_2:setString("")
    Text_tips:setString("")
    Text_tips:setVisible(false)
    Image_suo:setVisible(false)
    Image_3:setVisible(false)
    Panel_jqqd:setVisible(false)
    Image_5:setVisible(false)
    if Text_shuxing_3 ~= nil then
        Text_shuxing_3:setVisible(false)
    end
    if Text_shuxing_0 ~= nil then
        Text_shuxing_0:setString("")
    end

    --添加形象
    if self.ship_evo_id ~= -1 then
        draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_head, nil, nil, cc.p(0.5, 0))
        local picIndex_pic = dms.int(dms["ship_evo_mould"], self.ship_evo_id, ship_evo_mould.form_id)
        if animationMode == 1 then
            app.load("client.battle.fight.FightEnum")
            local shipSpine = sp.spine_sprite(Panel_head, picIndex_pic, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                shipSpine:setScaleX(-1)
            end
        else
            draw.createEffect("spirte_" .. picIndex_pic, "sprite/spirte_" .. picIndex_pic .. ".ExportJson", Panel_head, -1, nil, nil, cc.p(0.5, 0))
        end

        local name_index = dms.int(dms["ship_evo_mould"], self.ship_evo_id, ship_evo_mould.name_index)
        local name  = dms.element(dms["word_mould"], name_index)[3]
        Text_name:setString(name)


        local default_des = tipStringInfo_evolution_status_tips[3]
        local default_des_1 = ""
        local default_des_all = ""
        local pos_y = Text_shuxing_1:getPositionY() - 20
        if self.ship_skin_id ~= 0 then
            local evolution_status = dms.int(dms["ship_skin_mould"], self.ship_skin_id, ship_skin_mould.unlock_condition)
            local evolution_status_initial = dms.int(dms["ship_skin_mould"], self.ship_skin_id, ship_skin_mould.evolution_status_initial)
            local evolution_status_index = evolution_status + (evolution_status_initial - 1)
            local tips = evolution_status == -1 and tipStringInfo_evolution_status_tips[2] or string.format(tipStringInfo_evolution_status_tips[1], tipStringInfo_evolution_status[evolution_status_index])
            Text_tips:setString(tips)

            self.is_unlock = self.default_evolution_status >=  evolution_status 
            Image_3:setVisible(not self.is_unlock and self._index ~= 1)
            Text_tips:setVisible(not self.is_unlock and self._index ~= 1)
            Image_suo:setVisible(not self.is_unlock and self._index ~= 1)

            local unlock_condition = dms.int(dms["ship_skin_mould"], self.ship_skin_id, ship_skin_mould.unlock_condition)
            local additional_property = dms.string(dms["ship_skin_mould"], self.ship_skin_id, ship_skin_mould.additional)
            local add_percent = dms.string(dms["ship_skin_mould"], self.ship_skin_id, ship_skin_mould.add_percent)
            local additionals = zstring.splits(additional_property, "|", ",")
            local add = zstring.split(add_percent, "|")

            -- 获取所有属性加成文本
            if Text_shuxing_0 ~= nil then
                local tempPerNum = 0
                for i, v in ipairs(additionals) do
                    tempPerNum = tonumber(add[i]) == 1 and 100 or 1
                    local attributeInfo  = tipStringInfo_trialTower_attribute_info[zstring.tonumber(v[1] + 1)]
                    local tempStr = string.format(attributeInfo[2], tonumber(v[2])*tempPerNum)
                    local tempData = zstring.split(tempStr, "+")

                    if attributeInfo[3] then
                        default_des_all = default_des_all .. attributeInfo[1] .. ":" .. tempData[2] .. attributeInfo[3]
                    else
                        default_des_all = default_des_all .. attributeInfo[1] .. ":" .. tempData[2]
                    end

                    default_des_all = default_des_all .. "\r\n"
                end
            else
                local per_num = tonumber(add[1]) == 1 and 100 or 1
                pos_y = Text_shuxing_1:getPositionY()
                local vStr = string.format(tipStringInfo_trialTower_attribute_info[zstring.tonumber(additionals[1][1]) + 1][2], tonumber(additionals[1][2])*per_num )
                local data = zstring.split(vStr, "+")
                if tipStringInfo_trialTower_attribute_info[zstring.tonumber(additionals[1][1]) + 1][3] then
                    default_des = tipStringInfo_trialTower_attribute_info[zstring.tonumber(additionals[1][1]) + 1][1] .. ":" .. tonumber(data[2])..tipStringInfo_trialTower_attribute_info[zstring.tonumber(additionals[1][1]) + 1][3]
                else
                    default_des = tipStringInfo_trialTower_attribute_info[zstring.tonumber(additionals[1][1]) + 1][1] .. ":" .. data[2]
                end
                
                per_num = tonumber(add[2]) == 1 and 100 or 1
                local vStr_1 = string.format(tipStringInfo_trialTower_attribute_info[zstring.tonumber(additionals[2][1]) + 1][2], tonumber(additionals[2][2])*per_num)
                local data_1 = zstring.split(vStr_1, "+")
                if tipStringInfo_trialTower_attribute_info[zstring.tonumber(additionals[2][1]) + 1][3] then
                    default_des_1 = tipStringInfo_trialTower_attribute_info[zstring.tonumber(additionals[2][1]) + 1][1] .. ":" .. data_1[2]..tipStringInfo_trialTower_attribute_info[zstring.tonumber(additionals[2][1]) + 1][3]
                else
                    default_des_1 = tipStringInfo_trialTower_attribute_info[zstring.tonumber(additionals[2][1]) + 1][1] .. ":" .. data_1[2]
                end
            end

            -- 皮肤属性单体or群体加成
            if Text_shuxing_3 ~= nil then
                Text_shuxing_3:setVisible(true)
                local skinAdditionRangeType = dms.int(dms["ship_skin_mould"], self.ship_skin_id, ship_skin_mould.addition_range)
                local textAdditionRange = nil
                if skinAdditionRangeType == 1 then
                    textAdditionRange = tipStringInfo_evolution_status_tips[11]
                elseif skinAdditionRangeType == 2 then
                    textAdditionRange = tipStringInfo_evolution_status_tips[12]
                end
                Text_shuxing_3:setString(textAdditionRange)
            end
            if evolution_status == -1 then
                --if self.current_skin_id == tonumber(self.ship_skin_id) then
                if self.skin_exchange_id ~= 0 then
                    local is_have = false
                    if self.ship_skin_info and self.ship_skin_info ~= "" then
                        local skin_info = zstring.split(self.ship_skin_info, "|")
                        for i,v in ipairs(zstring.split(skin_info[2], ",")) do
                            local have_id = zstring.split(v, ":")[1]
                            if zstring.tonumber(have_id) == zstring.tonumber(ship_skin_id) then
                                is_have = true
                                limit_time_index = zstring.split(v, ":")[2]
                            end
                        end
                    end

                    Image_suo:setVisible(skin_is_unlock and not is_have)
                    Text_tips:setVisible(skin_is_unlock and not is_have)
                    Image_3:setVisible(skin_is_unlock and not is_have)
                    if skin_is_unlock == true and is_have == false then
                        Text_tips:setString(tipStringInfo_evolution_status_tips[9])
                    end
                else
                    local out_of_time = false
                    local limit_time_index = -1
                    if self.ship_skin_info and self.ship_skin_info ~= "" then
                        local skin_info = zstring.split(self.ship_skin_info, "|")
                        for i,v in ipairs(zstring.split(skin_info[2], ",")) do
                            local have_id = zstring.split(v, ":")[1]
                            if zstring.tonumber(have_id) == zstring.tonumber(self.ship_skin_id) then
                                limit_time_index = tonumber(zstring.split(v, ":")[2])
                            end
                        end
                    end

                    local activity_time = zstring.tonumber(limit_time_index )/ 1000 - (_ED.system_time + (os.time() - _ED.native_time))
                    local dayTime = math.ceil((activity_time ) / 86400)
                    if limit_time_index ~= -1 and dayTime <= 0 then
                        out_of_time = true
                    end
                    Image_suo:setVisible(not self.have_id or out_of_time)
                    Text_tips:setVisible(not self.have_id or out_of_time)
                    Image_3:setVisible(not self.have_id or out_of_time)
                    if not self.have_id then
                        Text_tips:setString(tipStringInfo_evolution_status_tips[9])
                    end
                end
            end

        end

        if Text_shuxing_0 ~= nil then
            default_des_all = default_des_all == "" and tipStringInfo_evolution_status_tips[3] or default_des_all
            Text_shuxing_0:setString(default_des_all)
        else
            Text_shuxing_1:setString(default_des)
            Text_shuxing_1:setVisible(true)
            Text_shuxing_1:setPositionY(pos_y)

            if default_des_1 ~= "" then
                Text_shuxing_2:setString(default_des_1)
                Text_shuxing_2:setVisible(true)
            end
        end
        
        Image_5:setVisible(self.current_skin_id == tonumber(self.ship_skin_id))
        
        Panel_jqqd:setVisible(false)
    else
        Text_tips:setVisible(false)
        Image_suo:setVisible(false)
        Image_3:setVisible(false)
        Panel_jqqd:setVisible(true)
        Text_shuxing_1:setVisible(false)
        Text_shuxing_2:setVisible(false)
    end
end

function SmRoleFashionCard:onInit()
    local csbItem = csb.createNode("packs/HeroStorage/generals_fashion_role.csb")
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbItem)

    if SmRoleFashionCard.__size == nil then
        SmRoleFashionCard.__size = root:getContentSize()
    end

    local Panel_20 = ccui.Helper:seekWidgetByName(root, "Panel_20")
    Panel_20:setTouchEnabled(self.ship_evo_id ~= -1)
    Panel_20:setSwallowTouches(false)
    fwin:addTouchEventListener(Panel_20, nil, {
            terminal_name = "sm_role_fashion_card_cell_choose", 
            terminal_state = 0, 
            cell = self,
            isPressedActionEnabled = true
        },
        nil,0)

    self:updateChooseState(self._index == 1)
    self:updateDraw()
end

function SmRoleFashionCard:onEnterTransitionFinish()
end

function SmRoleFashionCard:init(params)
    self._index = params[1]
    self.skin_evo_id = params[2]
    self.ship_skin_id = tonumber(self.skin_evo_id.skin_mould_id)
    self.ship_evo_id = self.skin_evo_id.evo_mould_id
    self.default_evolution_status = params[3]
    self.current_skin_id = params[4]
    self.skin_exchange_id = params[5]
    self.skin_is_unlock = params[6]
    if params[7] and params[7] ~= "" then
        self.ship_skin_info = params[7]
    end
    local have_ids = params[8]
    self.have_id = have_ids[tonumber(self.ship_evo_id)]
    self:onInit()
    self:setContentSize(SmRoleFashionCard.__size)
    return self
end

function SmRoleFashionCard:onExit()
end