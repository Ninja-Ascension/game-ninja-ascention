
UnionFightAttackRankCell = class("UnionFightAttackRankCellClass", Window)
UnionFightAttackRankCell.__size = nil

local union_fight_attack_rank_cell_create_terminal = {
    _name = "union_fight_attack_rank_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local info = params[1]
        local index = params[2]
        local cell = UnionFightAttackRankCell:new()
        cell:init(info, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fight_attack_rank_cell_create_terminal)
state_machine.init()

function UnionFightAttackRankCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._info = nil

    local function init_union_fight_attack_rank_cell_terminal()
        local union_fight_attack_rank_cell_click_terminal = {
            _name = "union_fight_attack_rank_cell_click",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                if tonumber(_ED.union.user_union_info.union_post) > 2 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[108])
                    return
                end
                if tonumber(_ED.union.union_info.union_id) == tonumber(cell._info.join_cost_union_id) 
                    and tonumber(cell._info.join_cost_union_id) ~= 0 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[105])
                    return
                end
                state_machine.excute("union_fighting_attack_cost_open", 0, cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local union_fight_attack_rank_cell_update_terminal = {
            _name = "union_fight_attack_rank_cell_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params.roots ~= nil then
                    for k,v in pairs(_ED.union_fight_city_attack_rank_list) do
                        if tonumber(v.city_id) == tonumber(params._info.city_id) then
                            params._info = v
                        end
                    end
                    params:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fight_attack_rank_cell_click_terminal)
        state_machine.add(union_fight_attack_rank_cell_update_terminal)
        state_machine.init()
    end
    init_union_fight_attack_rank_cell_terminal()
end

function UnionFightAttackRankCell:updateDraw()
    local root = self.roots[1]
    local Panel_build_icon = ccui.Helper:seekWidgetByName(root, "Panel_build_icon")
    local Text_15 = ccui.Helper:seekWidgetByName(root, "Text_15")
    local Panel_pk_attack_1 = ccui.Helper:seekWidgetByName(root, "Panel_pk_attack_1")
    local Text_rec_s_n_1 = ccui.Helper:seekWidgetByName(root, "Text_rec_s_n_1")
    local Text_pk_name_1 = ccui.Helper:seekWidgetByName(root, "Text_pk_name_1")
    local Text_legion_n_1 = ccui.Helper:seekWidgetByName(root, "Text_legion_n_1")
    local Panel_pk_attack_2 = ccui.Helper:seekWidgetByName(root, "Panel_pk_attack_2")
    local Text_rec_s_n_2 = ccui.Helper:seekWidgetByName(root, "Text_rec_s_n_2")
    local Text_pk_name_2 = ccui.Helper:seekWidgetByName(root, "Text_pk_name_2")
    local Text_legion_n_2 = ccui.Helper:seekWidgetByName(root, "Text_legion_n_2")
    local Text_pk_gem_n = ccui.Helper:seekWidgetByName(root, "Text_pk_gem_n")
    local Image_gem_pk_ing = ccui.Helper:seekWidgetByName(root, "Image_gem_pk_ing")

    local city_name = dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould], self._info.city_id, warfare_map_mould.city_name)
    local pic_index = dms.int(dms[config_res.campaign.nationalwar.warfare_map_mould], self._info.city_id, warfare_map_mould.city_pic)
    Panel_build_icon:setBackGroundImage("images/ui/play/big_map/big_map_build_1.png")
    Text_15:setString(city_name)

    if tonumber(self._info.defend_union_id) == 0 then
        Text_rec_s_n_1:setString("")
        Text_pk_name_1:setString(string_map_rattling_info[1])
        Text_legion_n_1:setString(string_map_rattling_info[1])
    else
        Text_rec_s_n_1:setString(self._info.defend_member_nums)
        Text_pk_name_1:setString(self._info.defend_union_name)
        Text_legion_n_1:setString(self._info.defend_leader_name)
    end
    if tonumber(self._info.attack_union_id) == 0 then
        Text_rec_s_n_2:setString("")
        Text_pk_name_2:setString(string_map_rattling_info[1])
        Text_legion_n_2:setString(string_map_rattling_info[1])
    else
        Text_rec_s_n_2:setString(self._info.attack_member_nums)
        Text_pk_name_2:setString(self._info.attack_union_name)
        Text_legion_n_2:setString(self._info.attack_leader_name)
    end
    Text_pk_gem_n:setString(self._info.cost)
    if tonumber(self._info.join_cost_union_id) == tonumber(_ED.union.union_info.union_id) then
        Image_gem_pk_ing:setVisible(true)
    else
        Image_gem_pk_ing:setVisible(false)
    end
end

function UnionFightAttackRankCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.big_map.map_legion_pk_attack_cell, "root")
    self:addChild(root)
    table.insert(self.roots, root)

    if UnionFightAttackRankCell.__size == nil then
        UnionFightAttackRankCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pk_gem"), nil, 
    {
        terminal_name = "union_fight_attack_rank_cell_click", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        _cell = self,
    }, 
    nil, 0)

    self:updateDraw()
end

function UnionFightAttackRankCell:onEnterTransitionFinish()

end

function UnionFightAttackRankCell:init(info, index)
    self._info = info
    self.index = index
    if index < 5 then
        self:onInit()
    end
    self:setContentSize(UnionFightAttackRankCell.__size)
    return self
end

function UnionFightAttackRankCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function UnionFightAttackRankCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.big_map.map_legion_pk_attack_cell, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function UnionFightAttackRankCell:onExit()
    cacher.freeRef(config_csb.cells.big_map.map_legion_pk_attack_cell, self.roots[1])
end
