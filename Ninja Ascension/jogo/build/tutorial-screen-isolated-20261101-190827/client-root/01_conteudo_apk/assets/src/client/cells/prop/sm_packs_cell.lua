--------------------------------------------------------------------------------------------------------------
--  说明：仓库的单个控件
--------------------------------------------------------------------------------------------------------------
SmPacksCell = class("SmPacksCellClass", Window)
SmPacksCell.__size = nil

--创建cell
local sm_packs_cell_terminal = {
    _name = "sm_packs_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmPacksCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_packs_cell_update_page_terminal = {
    _name = "sm_packs_cell_update_page",
    _init = function (terminal)       
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cells = params._datas.cells
        local isPanel = params._datas.isPanel
        local old_object = terminal.old_object
        if terminal.old_object ~= cells then
            if terminal.old_object ~= nil and terminal.old_object.roots ~= nil then
                terminal.old_object._isSelected = false
                if terminal.old_object.roots ~= nil and terminal.old_object.roots[1] ~= nil then
                    ccui.Helper:seekWidgetByName(terminal.old_object.roots[1], "Panel_star"):setVisible(false)
                end
            end
        end
        terminal.old_object = cells
        cells._isSelected = true
        ccui.Helper:seekWidgetByName(terminal.old_object.roots[1], "Panel_star"):setVisible(true)
        if zstring.tonumber(cells.use_type) == 1 then
            local is_max_exp = false
            if funOpenDrawTip(177,false) == false then
                is_max_exp = fwin:find("SmRoleStrengthenTabFightingSpiritStrengthenClass").is_max_exp
            else
                is_max_exp = fwin:find("SmRoleStrengthenTabFightingSpiritOldClass").is_max_exp
            end
            if is_max_exp == true then
                if terminal.old_object ~= old_object then
                    if terminal.old_object ~= nil and terminal.old_object.roots ~= nil then
                        terminal.old_object._isSelected = false
                        if terminal.old_object.roots ~= nil and terminal.old_object.roots[1] ~= nil then
                            ccui.Helper:seekWidgetByName(terminal.old_object.roots[1], "Panel_star"):setVisible(false)
                        end
                    end
                end
                terminal.old_object = old_object
                old_object._isSelected = true
                if terminal.old_object.roots ~= nil and terminal.old_object.roots[1] ~= nil then
                    ccui.Helper:seekWidgetByName(terminal.old_object.roots[1], "Panel_star"):setVisible(true)
                end
            else
                if tonumber(cells.prop.user_prop_template) == cells.selectObject then
                    if funOpenDrawTip(177,false) == false then
                        state_machine.excute("sm_role_strengthen_tab_fighting_spirit_strengthen_recording", 0, {cells.prop,1})
                    else
                        state_machine.excute("sm_role_strengthen_tab_fighting_spirit_old_recording", 0, {cells.prop,1})
                    end
                else
                    if funOpenDrawTip(177,false) == false then
                        state_machine.excute("sm_role_strengthen_tab_fighting_spirit_strengthen_recording", 0, {cells.prop, 0})
                    else
                        state_machine.excute("sm_role_strengthen_tab_fighting_spirit_old_recording", 0, {cells.prop, 0})
                    end
                    cells.selectObject = tonumber(cells.prop.user_prop_template)
                end
                if funOpenDrawTip(177,false) == false then
                    state_machine.excute("sm_role_strengthen_tab_fighting_spirit_strengthen_set_max_number", 0, "")
                else
                    state_machine.excute("sm_role_strengthen_tab_fighting_spirit_old_set_max_number", 0, "")
                end
            end
        elseif zstring.tonumber(cells.use_type) == 2 then
            local is_max_exp = false
            if funOpenDrawTip(177,false) == false then
                is_max_exp = fwin:find("SmRoleStrengthenTabFightingSpiritStrengthenClass").is_max_exp
            else
                is_max_exp = fwin:find("SmRoleStrengthenTabFightingSpiritOldClass").is_max_exp
            end
            if is_max_exp == true then
                if terminal.old_object ~= old_object then
                    if terminal.old_object ~= nil and terminal.old_object.roots ~= nil then
                        terminal.old_object._isSelected = false
                        if terminal.old_object.roots ~= nil and terminal.old_object.roots[1] ~= nil then
                            ccui.Helper:seekWidgetByName(terminal.old_object.roots[1], "Panel_star"):setVisible(false)
                        end
                    end
                end
                terminal.old_object = old_object
                old_object._isSelected = true
                if terminal.old_object.roots ~= nil and terminal.old_object.roots[1] ~= nil then
                    ccui.Helper:seekWidgetByName(terminal.old_object.roots[1], "Panel_star"):setVisible(true)
                end
            else
                if tonumber(cells.prop.user_prop_template) == cells.selectObject then
                        if funOpenDrawTip(177,false) == false then
                            state_machine.excute("sm_role_strengthen_tab_fighting_spirit_strengthen_recording", 0, {cells.prop,1,isPanel})
                        else
                            state_machine.excute("sm_role_strengthen_tab_fighting_spirit_old_recording", 0, {cells.prop,1,isPanel})
                        end
                else
                    if funOpenDrawTip(177,false) == false then
                        state_machine.excute("sm_role_strengthen_tab_fighting_spirit_strengthen_recording", 0, {cells.prop, 0})
                    else
                        state_machine.excute("sm_role_strengthen_tab_fighting_spirit_old_recording", 0, {cells.prop, 0})
                    end
                    cells.selectObject = tonumber(cells.prop.user_prop_template)
                end
                if funOpenDrawTip(177,false) == false then
                    state_machine.excute("sm_role_strengthen_tab_fighting_spirit_strengthen_set_max_number", 0, "")
                else
                    state_machine.excute("sm_role_strengthen_tab_fighting_spirit_old_set_max_number", 0, "")
                end
            end
        else
            state_machine.excute("prop_warehouse_update_data_info", 0, {cells.prop,cells.cell_type})
            -- 公会援助求助界面选中碎片
            state_machine.excute("legion_assistance_window1_update_select_debrisId", 0, {cells.prop})
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_packs_cell_update_delete_page_terminal = {
    _name = "sm_packs_cell_update_delete_page",
    _init = function (terminal)       
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cells = params._datas.cells
        state_machine.excute("sm_role_strengthen_tab_fighting_spirit_strengthen_recording", 0, {cells.prop,-1})
        state_machine.excute("sm_role_strengthen_tab_fighting_spirit_old_recording", 0, {cells.prop, -1})
        state_machine.excute("sm_role_strengthen_tab_fighting_spirit_strengthen_set_max_number", 0, "")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_packs_cell_update_selected_object_terminal = {
    _name = "sm_packs_cell_update_selected_object",
    _init = function (terminal)       
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cells = params[1]
        local number = zstring.tonumber(params[2])
        cells.prop.use_number = number
        -- local Button_jian = ccui.Helper:seekWidgetByName(cells.roots[1], "Button_jian")
        -- local Text_1 = ccui.Helper:seekWidgetByName(cells.roots[1], "Text_1")
        if number > 0 then
            if cells._Button_jian ~= nil then
                cells._Button_jian:setVisible(true)
            end
            if cells.cell_type == 7 or cells.cell_type == 71 or cells.cell_type == 74 then
            else
                if cells._Text_1 ~= nil then
                    if zstring.tonumber(cells.use_type) == 1 then
                        cells._Text_1:setString(number.."/"..cells.prop.prop_number)
                    end
                end
            end
        else
            if cells._Button_jian ~= nil then
                cells._Button_jian:setVisible(false)
            end
            if cells.cell_type == 7 or cells.cell_type == 71 or cells.cell_type == 74 then
            else
                if cells._Text_1 ~= nil then
                    if zstring.tonumber(cells.use_type) == 1 then
                        cells._Text_1:setString("0/"..cells.prop.prop_number)
                    end
                end
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_packs_cell_update_page_terminal)
state_machine.add(sm_packs_cell_terminal)
state_machine.add(sm_packs_cell_update_selected_object_terminal)
state_machine.add(sm_packs_cell_update_delete_page_terminal)

state_machine.init()

function SmPacksCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.selectObject = 0
    self.one = false
    self.two = false
    self._isSelected = false

    self._Button_jian = nil
    self._Text_1 = nil
	 -- Initialize sm_packs_cell state machine.
    local function init_sm_packs_cell_terminal()
        
        state_machine.init()
    end 
    -- call func sm_packs_cell create state machine.
    init_sm_packs_cell_terminal()

end

-- 检查该道具是否是显示运气提示的道具
function SmPacksCell:getLuckyIconIndex(propData)
    local index = nil
    local popTipPropAllList = zstring.split(dms.string(dms["activity_config"], 82, activity_config.param), "|")
    local popTipPropList = {}
    for i,v in ipairs(popTipPropAllList) do
        local tmp = zstring.split(v, "!")
        table.insert(popTipPropList, zstring.split(tmp[2], ","))
    end
    for i, v in pairs(popTipPropList) do
        if tonumber(v[1]) == tonumber(propData[1]) and tonumber(v[2]) == tonumber(propData[2]) then
            index = i
            break
        end
    end
    return index
end

function SmPacksCell:updateDrawEx()
    local root = self.roots[1]
    local prop_mould_id = 1
    if self.cell_type == 7 then
        prop_mould_id = self.prop.user_equiment_template
    elseif self.cell_type == 71 then
        prop_mould_id = self.prop.silkBagMouldId
    elseif self.cell_type == 74 then
        prop_mould_id = self.prop.vouchers_mould_id
    else
        prop_mould_id = self.prop.user_prop_template
    end

    -- 是否是号令忍界限时道具
    local Image_clock = ccui.Helper:seekWidgetByName(root, "Image_clock")
    if Image_clock ~= nil then
        Image_clock:setVisible(false)
    end
    if _ED.active_activity[174] ~= nil and Image_clock ~= nil then
        local time_info = _ED.active_activity[174].serverEndTime
        if time_info ~= nil then
            local _localEndTime = _ED.active_activity[174].serverEndTime.localEndTime
            local _crossServerEndTime = _ED.active_activity[174].serverEndTime.crossEndTime
            if _crossServerEndTime ~= nil and _localEndTime ~= nil then
                if difftime(_localEndTime) < 0 and difftime(_crossServerEndTime) < 43200000 then
                    local prop_arrs = zstring.splits(dms.string(dms["activity_config"], 80, activity_config.param), "|", ",")
                    local success = false
                    for i,v in ipairs(prop_arrs) do
                        if self.cell_type == tonumber(v[1]) and tonumber(v[2]) == tonumber(prop_mould_id) then
                            success = true
                            break
                        end
                    end
        
                    local Image_clock = ccui.Helper:seekWidgetByName(root, "Image_clock")
                    Image_clock:setVisible(success)
                end
            end
        end
    end
    
    local Image_luck_up = ccui.Helper:seekWidgetByName(root, "Image_luck_up")
    if Image_luck_up ~= nil then
        Image_luck_up:setVisible(false)

        local cell_type = self.cell_type and self.cell_type or 6
        local popLuckyIndex = self:getLuckyIconIndex({cell_type, prop_mould_id, 1})
        if popLuckyIndex ~= nil then
            local nowTime = os.time()
            local propPopTipEndTime = zstring.tonumber(readKey("propPopTipEndTime"..popLuckyIndex))
            if nowTime < propPopTipEndTime then
                Image_luck_up:setVisible(true)
            end
        end
    end

    --背景
    local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
    Panel_ditu:removeAllChildren(true)
    local quality = 0
    if self.cell_type == 7 then
        quality = dms.int(dms["equipment_mould"], tonumber(prop_mould_id), equipment_mould.trace_npc_index)+1
    elseif self.cell_type == 71 then
        quality = dms.int(dms["ship_silk_bag_mould"], prop_mould_id, ship_silk_bag_mould.quality_level) + 1
    elseif self.cell_type == 74 then
        quality = dms.int(dms["vouchers_mould"], prop_mould_id, warehouse_vouchers_mould.quality_level) + 1
    else
        quality = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.prop_quality)+1
    end
    local props_bg_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", quality))
    if props_bg_icon ~= nil then
        props_bg_icon:setPosition(cc.p(Panel_ditu:getContentSize().width/2,Panel_ditu:getContentSize().height/2))
        Panel_ditu:addChild(props_bg_icon)
    end

    --图标
    local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
    Panel_prop:removeAllChildren(true)
    local pic_index = nil
    if self.cell_type == 7 then
        pic_index = dms.int(dms["equipment_mould"], prop_mould_id, equipment_mould.pic_index)
    elseif self.cell_type == 71 then
        pic_index = dms.int(dms["ship_silk_bag_mould"], prop_mould_id, ship_silk_bag_mould.pic_index)
    elseif self.cell_type == 74 then
        pic_index = dms.int(dms["vouchers_mould"], prop_mould_id, warehouse_vouchers_mould.pic_index)
    else
        pic_index = setThePropsIcon(prop_mould_id)[1]
    end
    local props_icon = cc.Sprite:create(string.format("images/ui/props/props_%d.png", pic_index))
    if props_icon ~= nil then
        props_icon:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
        Panel_prop:addChild(props_icon)
    end
    --底框
    local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
    Panel_kuang:removeAllChildren(true)
    local index = 0
    if quality == 1 then
        index = 1
    elseif quality == 2 then
        index = 2
    elseif quality == 3 then
        index = 5
    elseif quality == 4 then
        index = 9
    elseif quality == 5 then
        index = 14
    elseif quality == 6 then
        index = 20
    end
    local props_quality_icon = cc.Sprite:create(string.format("images/ui/quality/quality_frame_%d.png", index))
    if props_quality_icon ~= nil then
        props_quality_icon:setPosition(cc.p(Panel_kuang:getContentSize().width/2,Panel_kuang:getContentSize().height/2))
        Panel_kuang:addChild(props_quality_icon)
    end

    --数量
    local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    if self.cell_type == 7 then
        local haveNumber = 0
        for i , v in pairs(_ED.user_equiment) do
            if tonumber(v.user_equiment_template) == tonumber(prop_mould_id) then
                haveNumber = haveNumber + 1
            end
        end
        Text_1:setString(haveNumber)
    elseif self.cell_type == 71 or self.cell_type == 74 then
        -- 不叠加为1
        Text_1:setString("1")
    else
        if zstring.tonumber(self.use_type) == 1 then
            Text_1:setString("0/"..self.prop.prop_number)
        else
            Text_1:setString(self.prop.prop_number)
        end
    end
    if tonumber(self.m_type) == 1 then
        Text_1:setString("")
    else
        if zstring.tonumber(self.number) ~= 0 then
            Text_1:setString(self.number)
        end
    end
    if self.cell_type == 7 or self.cell_type == 71 or self.cell_type == 74 then
    else
        local footerData = dms.string(dms["prop_mould"], prop_mould_id, prop_mould.trace_remarks)
        local footerInfo = zstring.split(footerData ,",")
        --碎片标识
        local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon")
        Panel_props_left_icon:removeAllChildren(true)
        if footerInfo[1] ~= nil and tonumber(footerInfo[1])~= -1 then
            local props_left_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[1])))
            if props_left_icon ~= nil then
                props_left_icon:setPosition(cc.p(Panel_props_left_icon:getContentSize().width/2,Panel_props_left_icon:getContentSize().height/2))
                Panel_props_left_icon:addChild(props_left_icon)
            end
        end

        --升级材料标识
        local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_right_icon")
        Panel_props_right_icon:removeAllChildren(true)
        if footerInfo[2] ~= nil and tonumber(footerInfo[2])~= -1 then
            local props_right_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[2])))
            if props_right_icon ~= nil then
                props_right_icon:setPosition(cc.p(Panel_props_right_icon:getContentSize().width/2,Panel_props_right_icon:getContentSize().height/2))
                Panel_props_right_icon:addChild(props_right_icon)
            end
        end
        if Panel_prop ~= nil then
            local sell_tag = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.sell_tag)
            if sell_tag == 3 then
                local effect_paths = string.format(config_res.images.ui.effice.effect_quality_box, 1, 1)
                if cc.FileUtils:getInstance():isFileExist(effect_paths) == true then
                    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
                    local armature = ccs.Armature:create("effect_quality_box_1")
                    draw.initArmature(armature, nil, -1, 0, 1)
                    armature:setPosition(cc.p(Panel_prop:getContentSize().width/2, Panel_prop:getContentSize().height/2))
                    Panel_prop:addChild(armature)
                end
            end
        end
        -- pmc武将碎片图标显示ssr
        if true then
            local storage_page_index = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.storage_page_index)
            local shipMouldId = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.use_of_ship)

            if storage_page_index == 18 and shipMouldId > 0 then
                local ability = dms.int(dms["ship_mould"], shipMouldId, ship_mould.ability)
                local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
                ssrIcon:setVisible(true)
                ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
            end
        end

		if __lua_project_id == __lua_project_l_digital then 
            -- 武将限定卡SP标签
			local storage_page_index = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.storage_page_index)
            local shipMouldId = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.use_of_ship)
			local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
            DisplaySpCardTag(shipMouldId, spIcon)
        else
            -- 武将限定卡显示
            local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
            if Panel_xianding then 
                Panel_xianding:setVisible(false)
                Panel_xianding:removeAllChildren(true)
                local storage_page_index = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.storage_page_index)
                local shipMouldId = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.use_of_ship)

                if storage_page_index == 18 and shipMouldId > 0 then
                    DisplayLimitCard(tonumber(shipMouldId)  ,Panel_xianding , 1)
                else
                    -- 限定神兽标签
                    DisplayLimitAnimal(nil, prop_mould_id, Panel_xianding, 1)
                end
            end
		end
    end
    local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
    local props_select_icon = cc.Sprite:create("images/ui/quality/props_light.png")
    if props_select_icon ~= nil then
        props_select_icon:setPosition(cc.p(Panel_star:getContentSize().width/2, Panel_star:getContentSize().height/2))
        Panel_star:addChild(props_select_icon)
    end
    if self._isSelected == true then
        Panel_star:setVisible(true)
    else
        Panel_star:setVisible(false)
    end
end

function SmPacksCell:updateDraw()
    local root = self.roots[1]
	local prop_mould_id = 1
    if self.cell_type == 7 then
        prop_mould_id = self.prop.user_equiment_template
    elseif self.cell_type == 71 then
        prop_mould_id = self.prop.silkBagMouldId
    else
        prop_mould_id = self.prop.user_prop_template
    end
    --背景
    local Panel_props_bg = ccui.Helper:seekWidgetByName(root, "Panel_props_bg")
    Panel_props_bg:removeAllChildren(true)
    local quality = 0
    if self.cell_type == 7 then
        quality = dms.int(dms["equipment_mould"], tonumber(prop_mould_id), equipment_mould.trace_npc_index)+1
    elseif self.cell_type == 71 then
        quality = dms.int(dms["ship_silk_bag_mould"], prop_mould_id, ship_silk_bag_mould.quality_level) + 1
    elseif self.cell_type == 74 then 
        quality = dms.int(dms["vouchers_mould"], prop_mould_id, warehouse_vouchers_mould.quality_level) + 1
    else
        quality = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.prop_quality)+1
    end
    local props_bg_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", quality))
    if props_bg_icon ~= nil then
        props_bg_icon:setPosition(cc.p(Panel_props_bg:getContentSize().width/2,Panel_props_bg:getContentSize().height/2))
        Panel_props_bg:addChild(props_bg_icon)
    end

    --图标
    local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    Panel_props_icon:removeAllChildren(true)
    local pic_index = nil
    if self.cell_type == 7 then
        pic_index = dms.int(dms["equipment_mould"], prop_mould_id, equipment_mould.pic_index)
    elseif self.cell_type == 71 then
        pic_index = dms.int(dms["ship_silk_bag_mould"], prop_mould_id, ship_silk_bag_mould.pic_index)
    elseif self.cell_type == 74 then    -- 代金券
        pic_index = dms.int(dms["vouchers_mould"], prop_mould_id, warehouse_vouchers_mould.pic_index)
    else
        pic_index = setThePropsIcon(prop_mould_id)[1]
    end
    local props_icon = cc.Sprite:create(string.format("images/ui/props/props_%d.png", pic_index))
    if props_icon ~= nil then
        props_icon:setPosition(cc.p(Panel_props_icon:getContentSize().width/2,Panel_props_icon:getContentSize().height/2))
        Panel_props_icon:addChild(props_icon)
    end
    --底框
    local Panel_props_quality = ccui.Helper:seekWidgetByName(root, "Panel_props_quality")
    Panel_props_quality:removeAllChildren(true)
    local index = 0
    if quality == 1 then
        index = 1
    elseif quality == 2 then
        index = 2
    elseif quality == 3 then
        index = 5
    elseif quality == 4 then
        index = 9
    elseif quality == 5 then
        index = 14
    elseif quality == 6 then
        index = 20
    end
    local props_quality_icon = cc.Sprite:create(string.format("images/ui/quality/quality_frame_%d.png", index))
    if props_quality_icon ~= nil then
        props_quality_icon:setPosition(cc.p(Panel_props_quality:getContentSize().width/2,Panel_props_quality:getContentSize().height/2))
        Panel_props_quality:addChild(props_quality_icon)
    end

    --数量
    local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
    if self.cell_type == 7 then
        local haveNumber = 0
        for i , v in pairs(_ED.user_equiment) do
            if tonumber(v.user_equiment_template) == tonumber(prop_mould_id) then
                haveNumber = haveNumber + 1
            end
        end
        Text_number:setString(haveNumber)
    elseif self.cell_type == 71 or self.cell_type == 74 then    --代金券
        Text_number:setString("1")
    else
        if zstring.tonumber(self.use_type) == 1 then
            Text_number:setString("0/"..self.prop.prop_number)
        else
            Text_number:setString(self.prop.prop_number)
        end
    end
    if tonumber(self.m_type) == 1 then
        Text_number:setString("")
    else
        if zstring.tonumber(self.number) ~= 0 then
            Text_number:setString(self.number)
        end
    end
    if self.cell_type == 7 or self.cell_type == 71 or self.cell_type == 74 then --代金券
    else
        local footerData = dms.string(dms["prop_mould"], prop_mould_id, prop_mould.trace_remarks)
        local footerInfo = zstring.split(footerData ,",")
        --碎片标识
        local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon")
        Panel_props_left_icon:removeAllChildren(true)
        if footerInfo[1] ~= nil and tonumber(footerInfo[1])~= -1 then
            local props_left_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[1])))
            if props_left_icon ~= nil then
                props_left_icon:setPosition(cc.p(Panel_props_left_icon:getContentSize().width/2,Panel_props_left_icon:getContentSize().height/2))
                Panel_props_left_icon:addChild(props_left_icon)
            end
        end

        --升级材料标识
        local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_right_icon")
        Panel_props_right_icon:removeAllChildren(true)
        if footerInfo[2] ~= nil and tonumber(footerInfo[2])~= -1 then
            local props_right_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[2])))
            if props_right_icon ~= nil then
                props_right_icon:setPosition(cc.p(Panel_props_right_icon:getContentSize().width/2,Panel_props_right_icon:getContentSize().height/2))
                Panel_props_right_icon:addChild(props_right_icon)
            end
        end
        if Panel_props_icon ~= nil then
            local sell_tag = dms.int(dms["prop_mould"], prop_mould_id, prop_mould.sell_tag)
            if sell_tag == 3 then
                local effect_paths = string.format(config_res.images.ui.effice.effect_quality_box, 1, 1)
                if cc.FileUtils:getInstance():isFileExist(effect_paths) == true then
                    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
                    local armature = ccs.Armature:create("effect_quality_box_1")
                    draw.initArmature(armature, nil, -1, 0, 1)
                    armature:setPosition(cc.p(Panel_props_icon:getContentSize().width/2, Panel_props_icon:getContentSize().height/2))
                    Panel_props_icon:addChild(armature)
                end
            end
        end
    end
end

function SmPacksCell:onInit()
    local root = cacher.createUIRef("icon/item.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
    if self.item_order_level._x == nil then
        self.item_order_level._x = self.item_order_level:getPositionX()
    end

    self:clearUIInfo()

    if SmPacksCell.__size == nil then
        SmPacksCell.__size = root:getContentSize()
    end

    self._Button_jian = ccui.Helper:seekWidgetByName(root, "Button_jian")
    self._Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")

    if tonumber(self.m_type) == 0 then
        local Button_jian = ccui.Helper:seekWidgetByName(root, "Button_jian")
        if zstring.tonumber(self.use_type) == 1 then
            local function consumptionOnTouchEvent(sender, evenType)
                local __spoint = sender:getTouchBeganPosition()
                local __mpoint = sender:getTouchMovePosition()
                local __epoint = sender:getTouchEndPosition()
                if ccui.TouchEventType.began == evenType then
                    if tonumber(sender.m_type) > 0 then 
                        sender._self.one = true
                    else
                        sender._self.two = true
                    end
                elseif ccui.TouchEventType.moved == evenType then
                    if __lua_project_id == __lua_project_gragon_tiger_gate
                        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                        or __lua_project_id == __lua_project_red_alert 
                        or __lua_project_id == __lua_project_digimon_adventure 
                        or __lua_project_id == __lua_project_yugioh
                        or __lua_project_id == __lua_project_warship_girl_b 
                        then
                        if __mpoint.x - __spoint.x > 80 
                            or __mpoint.x - __spoint.x < -80 
                            or __mpoint.y - __spoint.y > 3
                            or __mpoint.y - __spoint.y < -3 
                            then
                            if sender._self.one == true then
                                sender._self.one = false
                            end
                            if sender._self.two == true then
                                sender._self.two = false
                            end
                        end
                    end
                elseif ccui.TouchEventType.ended == evenType 
                    or ccui.TouchEventType.canceled == evenType then
                    sender._self.one = false
                    sender._self.two = false
                end
            end
            local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
            Panel_prop._self = self
            Panel_prop.m_type = 1
            Panel_prop:addTouchEventListener(consumptionOnTouchEvent)
            Panel_prop.callback = consumptionOnTouchEvent

            if Button_jian ~= nil then
                Button_jian._self = self
                Button_jian.m_type = -1
                Button_jian:addTouchEventListener(consumptionOnTouchEvent)
                Button_jian.callback = consumptionOnTouchEvent
            end
        else
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, 
            {
                terminal_name = "sm_packs_cell_update_page", 
                terminal_state = 0, 
                touch_black = true,
                isPanel = 1,
        		cells = self,
            }, nil, 1)

            if Button_jian ~= nil then
                fwin:addTouchEventListener(Button_jian, nil, 
                {
                    terminal_name = "sm_packs_cell_update_delete_page", 
                    terminal_state = 0, 
                    touch_black = true,
                    cells = self,
                }, nil, 1)
            end
        end
    end
    self:updateDrawEx()
    -- self:updateDraw()
end

function SmPacksCell:onUpdate(dt)
    if self.use_type ~= 2 then
        if self.one == true then
            state_machine.excute("sm_packs_cell_update_page", 0, {_datas = {cells = self}})
        end
        if self.two == true then
            state_machine.excute("sm_packs_cell_update_delete_page", 0, {_datas = {cells = self}})
        end
    end
end

function SmPacksCell:onEnterTransitionFinish()

end

function SmPacksCell:clearUIInfo( ... )
    if self.prop.use_number ~= nil then
        self.prop.use_number = 0
    end
    local root = self.roots[1]
    if root == nil then
        return
    end
    if root._x ~= nil then
        root:setPositionX(root._x)
    end
    if root._y ~= nil then
        root:setPositionY(root._y)
    end
    local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
    local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
    local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
    local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
    local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
    local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
    local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
    local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
    local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
    local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
    local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
    local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
    local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
    local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
    local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
    local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
    local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
    local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
    local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
    local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
    local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
    local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
    -- 号令忍界限时
    local Image_clock = ccui.Helper:seekWidgetByName(root, "Image_clock")
    if Image_clock ~= nil then
        Image_clock:setVisible(false)
    end

    -- 幸运道具
    local Image_luck_up = ccui.Helper:seekWidgetByName(root, "Image_luck_up")
    if Image_luck_up ~= nil then
        Image_luck_up:setVisible(false)
    end
    
    if Image_double ~= nil then
        Image_double:setVisible(false)
    end
    if Image_3 ~= nil then
        Image_3:setVisible(false)
    end
    if Label_l_order_level ~= nil then 
        Label_l_order_level:setVisible(true)
        if Label_l_order_level._x then
            Label_l_order_level:setPositionX(Label_l_order_level._x)
        end
        Label_l_order_level:setString("")
    end
    if Label_name ~= nil then
        Label_name:setString("")
        Label_name:setVisible(true)
    end
    if Label_quantity ~= nil then
        Label_quantity:setString("")
    end
    if Label_shuxin ~= nil then
        Label_shuxin:setString("")
    end
    if Panel_prop ~= nil then
        Panel_prop:removeAllChildren(true)
        Panel_prop:removeBackGroundImage()
        Panel_prop:setTouchEnabled(true)
        fwin:removeTouchEventListener(Panel_prop)
        Panel_prop.callback = nil
    end
    if Panel_kuang ~= nil then
        Panel_kuang:setVisible(true)
        Panel_kuang:removeAllChildren(true)
        Panel_kuang:removeBackGroundImage()
    end
    if Panel_ditu ~= nil then
        Panel_ditu:setVisible(true)
        Panel_ditu:removeAllChildren(true)
        Panel_ditu:removeBackGroundImage()
    end
    if Panel_star ~= nil then
        Panel_star:setVisible(true)
        Panel_star:removeAllChildren(true)
        Panel_star:removeBackGroundImage()
    end
    if Panel_props_right_icon ~= nil then
        Panel_props_right_icon:removeAllChildren(true)
        Panel_props_right_icon:removeBackGroundImage()
    end
    if Panel_props_left_icon ~= nil then
        Panel_props_left_icon:removeAllChildren(true)
        Panel_props_left_icon:removeBackGroundImage()
    end
    if Panel_num ~= nil then
        Panel_num:removeAllChildren(true)
        Panel_num:removeBackGroundImage()
    end
    if Panel_4 ~= nil then
        Panel_4:removeAllChildren(true)
        Panel_4:removeBackGroundImage()
    end
    if Text_1 ~= nil then
        Text_1:setString("")
    end
    if Image_xuanzhong ~= nil then
        Image_xuanzhong:setVisible(false)
    end
    if ssrIcon then
        ssrIcon:setVisible(false)
    end
    if Panel_xianding ~= nil then 
        Panel_xianding:removeAllChildren(true)
    end

    -- local Panel_props_bg = ccui.Helper:seekWidgetByName(root, "Panel_props_bg")
    -- if Panel_props_bg ~= nil then
    --     Panel_props_bg:removeAllChildren(true)
    -- end
    -- local Panel_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_icon")
    -- if Panel_props_icon ~= nil then
    --     Panel_props_icon:removeAllChildren(true)
    -- end
    -- local Panel_props_quality = ccui.Helper:seekWidgetByName(root, "Panel_props_quality")
    -- if Panel_props_quality ~= nil then
    --     Panel_props_quality:removeAllChildren(true)
    -- end
    -- local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
    -- if Text_number ~= nil then
    --     Text_number:setString("")
    -- end
    -- local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon")
    -- if Panel_props_left_icon ~= nil then
    --     Panel_props_left_icon:removeAllChildren(true)
    -- end
    -- local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_right_icon")
    -- if Panel_props_right_icon ~= nil then
    --     Panel_props_right_icon:removeAllChildren(true)
    -- end
    -- local Image_hook = ccui.Helper:seekWidgetByName(root, "Image_hook")
    -- if Image_hook ~= nil then
    --     Image_hook:setVisible(false)
    -- end
    local Button_jian = ccui.Helper:seekWidgetByName(root, "Button_jian")
    if Button_jian ~= nil then
        Button_jian:setVisible(false)
    end
    self._Button_jian = nil
    self._Text_1 = nil
end

function SmPacksCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmPacksCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("icon/item.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmPacksCell:init(params)
    self.prop = params[1]
    self.m_type = params[2]
    self.number = params[3] or nil
    self.cell_type = params[4] or nil --道具类型
    if self.cell_type == nil and self.prop.enum_type == 74 then 
        self.cell_type = 74
    end
    self.use_type = params[5] or nil --使用类型
    if zstring.tonumber(params[6]) <= 20 then
        self:onInit()
    end
    self:setContentSize(SmPacksCell.__size)
    return self
end

function SmPacksCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("icon/item.csb", self.roots[1])
end