-----------------------------
--神兵技能属性
-----------------------------
OtherPlayersGodWeaponrySkillAtt = class("OtherPlayersGodWeaponrySkillAttClass", Window)
-- 打开
local other_players_god_weaponry_skill_att_window_open_terminal = {
    _name = "other_players_god_weaponry_skill_att_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if params._datas.index > 6 then
            TipDlg.drawTextDailog(_function_unopened_tip_string)
            return
        end
        local _Window = fwin:find("OtherPlayersGodWeaponrySkillAttClass")
        if nil == _Window then
            if params._datas.choose_ship ~= nil then
                fwin:open(OtherPlayersGodWeaponrySkillAtt:new():init(params._datas.index, params._datas.choose_ship), fwin._ui)
            end
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
-- 关闭
local other_players_god_weaponry_skill_att_window_close_terminal = {
    _name = "other_players_god_weaponry_skill_att_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("OtherPlayersGodWeaponrySkillAttClass"))
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(other_players_god_weaponry_skill_att_window_open_terminal)
state_machine.add(other_players_god_weaponry_skill_att_window_close_terminal)
state_machine.init()

function OtherPlayersGodWeaponrySkillAtt:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    -- 技能阶数
    self._choose_index = 0
    -- 侠客信息
    self._choose_ship = nil

    local function init_other_players_god_weaponry_skill_att_terminal()
    end
    
    init_other_players_god_weaponry_skill_att_terminal()
end

function OtherPlayersGodWeaponrySkillAtt:onUpdateDraw()
    local root = self.roots[1]
    -- 技能icon
    local Panel_skill_picture = ccui.Helper:seekWidgetByName(root, "Panel_skill_picture")
    Panel_skill_picture:setBackGroundImage(string.format("images/ui/god_weaponry_icon/god_weaponry_icon_%d.png", self._choose_index))
    -- 技能名称
    local Text_skill_name = ccui.Helper:seekWidgetByName(root, "Text_skill_name")
    Text_skill_name:setString(tipStringInfo_god_weaponry_level[self._choose_index])
    -- 锻造阶数
    local Text_skill_lv_v = ccui.Helper:seekWidgetByName(root, "Text_skill_lv_v")
    Text_skill_lv_v:setString(self._choose_index)
    -- 开放条件
    local Text_wait_lv = ccui.Helper:seekWidgetByName(root, "Text_wait_lv")
    Text_wait_lv:setString(string.format(tipStringInfo_god_weaponry_info[1], self._choose_index*10))
    for i=1,4 do
        ccui.Helper:seekWidgetByName(root, "Text_skill_attribute_"..i):setString("")
        ccui.Helper:seekWidgetByName(root, "Text_skill_attribute_v_"..i):setString("")
    end

    local ship_mould_id = self._choose_ship.ship_template_id
    local god_weaponry_id = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.super_equipment_mould_group_id)
    local god_info = _ED.god_weaponry_info[""..god_weaponry_id]
    local last_god_weaponry = nil
    for k,v in pairs(_ED.god_weaponry_info) do
        if tonumber(v.group_id) == tonumber(god_info.group_id) 
            and v.level_group_id == self._choose_index 
            then
            if last_god_weaponry == nil then
                last_god_weaponry = v
            end
            if v.grow_up_id == -1 then
                last_god_weaponry = v
                break
            elseif last_god_weaponry.grow_up_id < v.grow_up_id then
                last_god_weaponry = v
            end
        end
    end
    god_info = last_god_weaponry
    local talentMould = dms.element(dms["talent_mould"], god_info.talent_id)
    -- 技能描述
    local Text_god_introduce = ccui.Helper:seekWidgetByName(root, "Text_god_introduce")
    local talent_star_dec = dms.atos(talentMould, talent_mould.talent_star_dec)
    Text_god_introduce:setString(talent_star_dec)
    -- 属性
    local base_additional = dms.atos(talentMould, talent_mould.base_additional)
    if base_additional ~= "-1" then
        base_additional = zstring.split(base_additional, "|")
        for i,v in ipairs(base_additional) do
            if i > 4 then
                break
            end
            local data = zstring.split(v, ",")
            local types = tonumber(data[1]) + 1
            local adds = data[2]
            ccui.Helper:seekWidgetByName(root, "Text_skill_attribute_"..i):setString(attribute[types])
            ccui.Helper:seekWidgetByName(root, "Text_skill_attribute_v_"..i):setString(adds)
        end
    end
end

function OtherPlayersGodWeaponrySkillAtt:onEnterTransitionFinish()
    
end

function OtherPlayersGodWeaponrySkillAtt:onInit( )
    local csbItem = csb.createNode(config_csb.god_weaponry.god_weaponry_skill_attribute)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_skill_atribute"), nil, 
    {
        terminal_name = "other_players_god_weaponry_skill_att_window_close", 
        terminal_state = 0, 
    }, nil, 0)

    self:onUpdateDraw()
end

function OtherPlayersGodWeaponrySkillAtt:init(index, ship)
    self._choose_index = index
    self._choose_ship = ship
    self:onInit()
    return self
end

function OtherPlayersGodWeaponrySkillAtt:onExit()
    
end
