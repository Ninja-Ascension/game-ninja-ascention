-- ----------------------------------------------------------------------------------------------------
-- 说明：角色升星
-------------------------------------------------------------------------------------------------------
SmRoleStrengthenTabFightSpirit = class("SmRoleStrengthenTabFightSpiritClass", Window)

local sm_role_strengthen_tab_fight_spirit_open_terminal = {
    _name = "sm_role_strengthen_tab_fight_spirit_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("SmRoleStrengthenTabFightSpiritClass")
        if nil == _homeWindow then
            local panel = SmRoleStrengthenTabFightSpirit:new():init(params)
            fwin:open(panel)
        else
            fwin:close(fwin:find("SmRoleStrengthenTabFightSpiritClass"))
            local panel = SmRoleStrengthenTabFightSpirit:new():init(params)
            fwin:open(panel)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_strengthen_tab_fight_spirit_close_terminal = {
    _name = "sm_role_strengthen_tab_fight_spirit_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeWindow = fwin:find("SmRoleStrengthenTabFightSpiritClass")
        if nil ~= _homeWindow then
            fwin:close(fwin:find("SmRoleStrengthenTabFightSpiritClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_strengthen_tab_fight_spirit_open_terminal)
state_machine.add(sm_role_strengthen_tab_fight_spirit_close_terminal)
state_machine.init()
    
function SmRoleStrengthenTabFightSpirit:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    app.load("client.packs.FightSpirit.FightSpirit")
    app.load("client.packs.FightSpirit.FightSpiritCell1")
    app.load("client.packs.FightSpirit.FightSpiritCell2")
    app.load("client.packs.FightSpirit.FightSpiritCell4")
    app.load("client.packs.FightSpirit.FightSpiritHandle")
    app.load("client.packs.FightSpirit.fightspiritcell1zhlist")
    app.load("client.packs.FightSpirit.FightSpiritZhAtt")
    app.load("client.packs.FightSpirit.FightSpiritZhEquip")
    app.load("client.packs.FightSpirit.fightspiritcell2xllist")
    app.load("client.packs.FightSpirit.FightSpiritBreakDown")
    app.load("client.packs.FightSpirit.FightSpiritBreakDownConfirm")
    app.load("client.packs.FightSpirit.FightSpiritSkill")
    app.load("client.packs.FightSpirit.FightSpiritCell4Confirm")
    app.load("client.packs.FightSpirit.FightSpiritZhSkill")
    app.load("client.packs.FightSpirit.FightSpiritQianghua")
    app.load("client.packs.FightSpirit.FightSpiritQianghuaSx")
    app.load("client.packs.FightSpirit.FightSpiritJxAtt")
    app.load("client.packs.FightSpirit.FightSpiritSjAtt")

    local function init_sm_role_strengthen_tab_fight_spirit_terminal()
        -- 显示界面
        local sm_role_strengthen_tab_fight_spirit_display_terminal = {
            _name = "sm_role_strengthen_tab_fight_spirit_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabFightSpiritWindow = fwin:find("SmRoleStrengthenTabFightSpiritClass")
                if SmRoleStrengthenTabFightSpiritWindow ~= nil then
                    SmRoleStrengthenTabFightSpiritWindow:setVisible(true)
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_strengthen_tab_fight_spirit_hide_terminal = {
            _name = "sm_role_strengthen_tab_fight_spirit_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabFightSpiritWindow = fwin:find("SmRoleStrengthenTabFightSpiritClass")
                if SmRoleStrengthenTabFightSpiritWindow ~= nil then
                    SmRoleStrengthenTabFightSpiritWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local sm_role_strengthen_tab_fight_spirit_update_draw_terminal = {
            _name = "sm_role_strengthen_tab_fight_spirit_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 改变id
        local sm_role_strengthen_tab_fight_spirit_change_ship_terminal = {
            _name = "sm_role_strengthen_tab_fight_spirit_change_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.curShipId = tonumber(params)
                instance:onUpdateDraw()
                state_machine.excute("notification_center_update",0,"push_notification_center_hero_strength_up_grade_button")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 点击装备栏
        local sm_role_strengthen_tab_fight_spirit_click_icon_terminal = {
            _name = "sm_role_strengthen_tab_fight_spirit_click_icon",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local info = FightSpiritHandle.getShipFightSpiritInfoById(instance.curShipId)
                local fightSpiritId = info[params._datas.pos]
                if fightSpiritId and fightSpiritId > 0 then
                    local btnList = {"qianghua", "genghuan", "xiexia"}
                    if funOpenConditionJudge(202) then
                        local fightSpirit = FightSpiritHandle.getFightSpiritById(fightSpiritId)
                        local info = FightSpiritHandle.getFightSpiritAwakeInfoByQuaility(fightSpirit.quality)
                        if info then
                            if info.isAwaken then
                                btnList = {"qianghua", "xilian", "genghuan", "xiexia"}
                            else
                                btnList = {"qianghua", "juexing", "genghuan", "xiexia"}
                            end
                        end
                    end
                    state_machine.excute("fight_spirit_skill_window_open", 0, {_datas = {
                        fightSpirit1 = FightSpiritHandle.getFightSpiritById(fightSpiritId),
                        btnList = btnList,
                        shipId = instance.curShipId,
                        types = instance._types,
                    }})
                else
                    state_machine.excute("fight_spirit_window_open", 0, {curShipId = instance.curShipId, types = instance._types})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 属性详情
        local sm_role_strengthen_tab_fight_spirit_attr_detail_terminal = {
            _name = "sm_role_strengthen_tab_fight_spirit_attr_detail",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if not instance.noEquip then
                    state_machine.excute("fight_spirit_zh_att_window_open", 0, FightSpiritHandle:getShipFightSpiritAttributeById(instance.curShipId))   
                else
                    TipDlg.drawTextDailog(tipStringInfo_fight_spirit[30])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 技能详情
        local sm_role_strengthen_tab_fight_spirit_skill_detail_terminal = {
            _name = "sm_role_strengthen_tab_fight_spirit_skill_detail",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local info = FightSpiritHandle:getShipFightSpiritAttributeById(instance.curShipId)
                if info.suit4Id then
                    state_machine.excute("fight_spirit_zh_skill_window_open", 0, {shipId = instance.curShipId})
                else
                    TipDlg.drawTextDailog(tipStringInfo_fight_spirit[11])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_role_strengthen_tab_fight_spirit_display_terminal)
        state_machine.add(sm_role_strengthen_tab_fight_spirit_hide_terminal)
        state_machine.add(sm_role_strengthen_tab_fight_spirit_click_icon_terminal)
        state_machine.add(sm_role_strengthen_tab_fight_spirit_attr_detail_terminal)
        state_machine.add(sm_role_strengthen_tab_fight_spirit_skill_detail_terminal)
        state_machine.add(sm_role_strengthen_tab_fight_spirit_update_draw_terminal)
        state_machine.add(sm_role_strengthen_tab_fight_spirit_change_ship_terminal)
        
        state_machine.init()
    end
    init_sm_role_strengthen_tab_fight_spirit_terminal()
end

function SmRoleStrengthenTabFightSpirit:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow    
    self.curShipId = tonumber(params[2])
    self._types = params[3]
    self:onInit()
    return self
end

function SmRoleStrengthenTabFightSpirit:onInit()
    local csbSmRoleStrengthenTabFightSpirit = csb.createNode("packs/FightSpirit/FightSpirit_zh_tab.csb")
    local root = csbSmRoleStrengthenTabFightSpirit:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleStrengthenTabFightSpirit)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_install"), nil,
    {
        terminal_name = "sm_role_strengthen_tab_fight_spirit_click_icon",
        terminal_state = 0,
        isPressedActionEnabled = true,
        pos = -1,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_det_1"), nil,
    {
        terminal_name = "sm_role_strengthen_tab_fight_spirit_attr_detail",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_det_2"), nil,
    {
        terminal_name = "sm_role_strengthen_tab_fight_spirit_skill_detail",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    for i = 1, 4 do
        ccui.Helper:seekWidgetByName(root, "Button_stone_icon_"..i):setTouchEnabled(true)
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_stone_icon_"..i), nil, 
        {
            terminal_name = "sm_role_strengthen_tab_fight_spirit_click_icon", 
            terminal_state = 0, 
            pos = i,
            isPressedActionEnabled = true,
        }, nil, 0)
    end

    self:onUpdateDraw()
end

function SmRoleStrengthenTabFightSpirit:onUpdateDraw()
    local shipId = self.curShipId
    local info = FightSpiritHandle.getShipFightSpiritInfoById(shipId)
    local noEquip = true
    for i,fightSpiritId in ipairs(info) do
        self:updateFightSpiritIcon(fightSpiritId, i)
        if fightSpiritId > 0 then
            noEquip = false
        end
    end

    self.noEquip = noEquip
    
    local root = self.roots[1]
    
    ccui.Helper:seekWidgetByName(root, "Text_no_1"):setVisible(noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_atk"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_def"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_hp"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_atk_num"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_def_num"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_hp_num"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_two"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_two_info"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_four"):setVisible(not noEquip)
    ccui.Helper:seekWidgetByName(root, "Text_four_info"):setVisible(not noEquip)
    
    local Text_atk_num = ccui.Helper:seekWidgetByName(root, "Text_atk_num")
    local Text_def_num = ccui.Helper:seekWidgetByName(root, "Text_def_num")
    local Text_hp_num = ccui.Helper:seekWidgetByName(root, "Text_hp_num")
    local attrInfo = FightSpiritHandle:getShipFightSpiritAttributeById(shipId)

    Text_atk_num:setString(attrInfo.attrs[1] or 0)
    Text_def_num:setString(attrInfo.attrs[2] or 0)
    Text_hp_num:setString(attrInfo.attrs[0] or 0)
    ccui.Helper:seekWidgetByName(root, "Text_atk"):setString(tipStringInfo_rescue_silkbag[3])
    ccui.Helper:seekWidgetByName(root, "Text_def"):setString(tipStringInfo_rescue_silkbag[4])
    ccui.Helper:seekWidgetByName(root, "Text_hp"):setString(tipStringInfo_rescue_silkbag[2])

    local attrsStr = dms.string(dms["play_config"], 225, play_config.param)
    local attrs = zstring.split(attrsStr, "|")
    local attr2 = zstring.split(attrs[1], ",")
    local attr4 = zstring.split(attrs[2], ",")
    if attrInfo.suit2Active then
        local name, value = getHardenPropertyNameAndValue(attr2[1], attr2[2])
        ccui.Helper:seekWidgetByName(root, "Text_two_info"):setString(name..value..tipStringInfo_fight_spirit[25])
    else
        ccui.Helper:seekWidgetByName(root, "Text_two_info"):setString(tipStringInfo_fight_spirit.NONE)
    end

    if attrInfo.suit4Id then
        ccui.Helper:seekWidgetByName(root, "Text_skill"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_no_2"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Text_wb"):setVisible(true)

        local name, value = getHardenPropertyNameAndValue(attr4[1], attr4[2])
        ccui.Helper:seekWidgetByName(root, "Text_four_info"):setString(name .. value)

        local skillDesc = dms.string(dms["fight_spirit_suit_mould"], attrInfo.suit4Id, fight_spirit_suit_mould.skill)
        local desc = zstring.split(skillDesc, "|")
        local descIndex = attrInfo.suit4Quality
        local skillDesc = zstring.split(desc[descIndex], ",")
        local skillNameId = dms.string(dms["talent_mould"], skillDesc[2], talent_mould.talent_describe)
        local word_info = dms.element(dms["word_mould"], skillNameId)
        ccui.Helper:seekWidgetByName(root, "Text_skill"):setString(word_info[3])

        local nameId = dms.int(dms["fight_spirit_suit_mould"], attrInfo.suit4Id, fight_spirit_suit_mould.suit_name)
        ccui.Helper:seekWidgetByName(root, "Text_wb"):setString(dms.element(dms["word_mould"], nameId)[3])
    else
        ccui.Helper:seekWidgetByName(root, "Text_four_info"):setString(tipStringInfo_fight_spirit.NONE)
        ccui.Helper:seekWidgetByName(root, "Text_skill"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Text_no_2"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_wb"):setVisible(false)
    end
end

function SmRoleStrengthenTabFightSpirit:updateFightSpiritIcon(fightSpiritId, index)
    local icon = ccui.Helper:seekWidgetByName(self.roots[1], "Button_stone_icon_"..index)
    icon:removeAllChildren()

    local allFightSpirits = FightSpiritHandle.getAllFightSpirits()
    if fightSpiritId > 0 then
        local fightSpirit = allFightSpirits[fightSpiritId]
        local cell = ResourcesIconCell:createCell()
        cell:init(73,nil,nil,nil,nil,nil,nil,nil,{fightSpirit=fightSpirit, notShowBg = true})
        -- DSC重塑   
		if __lua_project_id == __lua_project_l_digital then 
			cell:setAnchorPoint(cc.p(0.5,0.5))
			cell:setPosition(cc.p(icon:getContentSize().width/2,icon:getContentSize().height/2))
		end
        icon:addChild(cell)
        ccui.Helper:seekWidgetByName(cell, "Panel_prop"):setTouchEnabled(false)
    end
end

function SmRoleStrengthenTabFightSpirit:onExit()
    state_machine.remove("sm_role_strengthen_tab_fight_spirit_display")
    state_machine.remove("sm_role_strengthen_tab_fight_spirit_hide")
    state_machine.remove("sm_role_strengthen_tab_fight_spirit_click_icon")
    state_machine.remove("sm_role_strengthen_tab_fight_spirit_attr_detail")
    state_machine.remove("sm_role_strengthen_tab_fight_spirit_skill_detail")
end