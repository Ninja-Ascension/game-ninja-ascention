--------------------------------------------------------------------------------------------------------------
--  说明：王者之战兑换
--------------------------------------------------------------------------------------------------------------
SmBattleOfKingsExchangeListCell = class("SmBattleOfKingsExchangeListCellClass", Window)
SmBattleOfKingsExchangeListCell.__size = nil

--创建cell
local sm_battle_of_kings_exchange_list_cell_create_terminal = {
    _name = "sm_battle_of_kings_exchange_list_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmBattleOfKingsExchangeListCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        -- cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(sm_battle_of_kings_exchange_list_cell_create_terminal)
state_machine.init()

function SmBattleOfKingsExchangeListCell:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")
    -- var
    self._element = nil

	 -- Initialize sm_battle_of_kings_exchange_list_cell state machine.
    local function init_sm_battle_of_kings_exchange_list_cell_terminal()

        local sm_battle_of_kings_exchange_list_cell_exchange_terminal = {
            _name = "sm_battle_of_kings_exchange_list_cell_exchange",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if ccui.Helper:seekWidgetByName(cell.roots[1],"Button_dh")._tips == true then
                    TipDlg.drawTextDailog(_new_interface_text[193])
                    return
                end
                if true then  --添加项目控制
                    local prop = {}
                    local reworld_prop = zstring.split(cell._element[3], ",")
                    local need_prop = zstring.split(cell._element[4], ",")
                    local had_num = tonumber(getPropAllCountByMouldId(need_prop[2]))
                    local need_num =  tonumber(need_prop[3])
                    local may_num = math.floor(had_num / need_num )
                    prop.prop_number = may_num
                    prop.mould_id = tonumber(reworld_prop[2])
                    prop.type = tonumber(reworld_prop[1])
                    if prop.type == 6 then
                        local prop_info = dms.element(dms["prop_mould"], prop.mould_id)
                        if prop.mould_name == nil then
                            prop.mould_name = dms.atos(prop_info, prop_mould.prop_name)
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                                prop.mould_name = setThePropsIcon(prop.mould_id)[2]
                            end
                        end
                        if prop.prop_quality == nil then
                            prop.prop_quality = dms.atoi(prop_info, prop_mould.prop_quality)
                        end
                        prop.mould_remarks = dms.atos(prop_info, prop_mould.remarks)
                        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                            prop.mould_remarks = drawPropsDescription(prop.mould_id)
                        end
                        -- 武器
                    elseif prop.type == 7 then
                        local prop_info = dms.element(dms["equipment_mould"], prop.mould_id)
                        if prop.mould_name == nil then
                            prop.mould_name = smEquipWordlFundByIndex(prop.mould_id , 1)
                        end
                        prop.prop_quality = dms.atoi(prop_info, equipment_mould.trace_npc_index)
                        if prop.prop_quality == 0 then
                            prop.prop_quality = 3
                        end
                        prop.mould_remarks = smEquipWordlFundByIndex(prop.mould_id , 2)--描述
                    elseif prop.type == 13 then
                        if prop.prop_quality == nil then
                            prop.prop_quality = dms.int(dms["ship_mould"], prop.mould_id, ship_mould.ship_type)+1
                        end

                        if prop.mould_name == nil then
                            local evo_image = dms.string(dms["ship_mould"], prop.mould_id, ship_mould.fitSkillTwo)
                            local evo_info = zstring.split(evo_image, ",")
                            local evo_mould_id = evo_info[dms.int(dms["ship_mould"], prop.mould_id, ship_mould.captain_name)]
                            local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
                            local word_info = dms.element(dms["word_mould"], name_mould_id)
                            prop.mould_name = word_info[3]
                        end
                    else
                        if prop.prop_quality == nil then
                            prop.prop_quality = 0
                        end
                        if prop.mould_name == nil then
                            prop.mould_name = _All_tip_string_info._fundName
                        end
                    end
                    prop.id = cell.index
                    cell.prop = prop
                    cell.form_cell = "sm_battle_of_kings_exchange_list_cell" --来自王者之战/公会战兑换cell

                    --这里添加兑换弹窗
                    app.load("client.packs.prop.ComExchange")
                    state_machine.excute("com_exchange_use_open",0,cell)
                    fwin:close(instance)
                else
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if nil ~= response.node and nil ~= response.node.roots then
                                cell:updateButtonDraw()
                                state_machine.excute("sm_battleof_kings_exchange_update_need_prop_number",0 ,"")
                                app.load("client.reward.DrawRareReward")
                                local getRewardWnd = DrawRareReward:new()
                                getRewardWnd:init(11)
                                fwin:open(getRewardWnd, fwin._ui)
                            end
                            state_machine.unlock("sm_battle_of_kings_exchange_list_cell_exchange", 0, "")
                        else
                            state_machine.unlock("sm_battle_of_kings_exchange_list_cell_exchange", 0, "")
                        end
                    end
                    state_machine.lock("sm_battle_of_kings_exchange_list_cell_exchange", 0, "")
                    protocol_command.shop_buy.param_list = cell._element[1].."\r\n".."1"
                    NetworkManager:register(protocol_command.shop_buy.code, nil, nil, nil, cell, responseCallback, false, nil)
                end

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_battle_of_kings_exchange_list_cell_exchange_terminal)
        state_machine.init()
    end 
    -- call func sm_battle_of_kings_exchange_list_cell create state machine.
    init_sm_battle_of_kings_exchange_list_cell_terminal()

end

function SmBattleOfKingsExchangeListCell:updateDraw()
    local root = self.roots[1]
    -- 需要的道具
    local Panel_props_1 = ccui.Helper:seekWidgetByName(root, "Panel_props_1")
    Panel_props_1:removeAllChildren(true)
    local need_prop = zstring.split(self._element[4], ",")
    -- local cell = ResourcesIconCell:createCell()
    -- cell:init(need_prop[1], tonumber(need_prop[3]), need_prop[2],nil,nil,true,true)
    -- Panel_props_1:addChild(cell)
    local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{need_prop[1],need_prop[2],need_prop[3]},false,true,false,true})
    Panel_props_1:addChild(cell)
    
    -- 兑换的奖励
    local Panel_props_2 = ccui.Helper:seekWidgetByName(root, "Panel_props_2")
    Panel_props_2:removeAllChildren(true)
    local reworld_prop = zstring.split(self._element[3], ",")

    -- local reworldcell = ResourcesIconCell:createCell()
    -- reworldcell:init(reworld_prop[1], tonumber(reworld_prop[3]), reworld_prop[2],nil,nil,true,true)
    -- Panel_props_2:addChild(reworldcell)
    local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{reworld_prop[1],reworld_prop[2],reworld_prop[3]},false,true,false,true})
    Panel_props_2:addChild(cell)
    self:updateButtonDraw()
end

function SmBattleOfKingsExchangeListCell:updateButtonDraw()
    local root = self.roots[1]
    local Button_dh = ccui.Helper:seekWidgetByName(root,"Button_dh")
    local Sprite_dh = Button_dh:getChildByName("Sprite_dh")
    local need_prop = zstring.split(self._element[4], ",")
    if tonumber(getPropAllCountByMouldId(need_prop[2])) >= tonumber(need_prop[3]) then
        Button_dh._tips = false
        Button_dh:setBright(true)
        -- Button_dh:setTouchEnabled(true)
        display:ungray(Sprite_dh)
    else
        Button_dh._tips = true
        Button_dh:setBright(false)
        -- Button_dh:setTouchEnabled(false)
        display:gray(Sprite_dh)
    end
end

function SmBattleOfKingsExchangeListCell:onUpdate(dt)

end

function SmBattleOfKingsExchangeListCell:onInit()
    local root = cacher.createUIRef("campaign/BattleofKings/battle_of_kings_exchange_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmBattleOfKingsExchangeListCell.__size == nil then
        SmBattleOfKingsExchangeListCell.__size = root:getContentSize()
    end

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_dh"), nil, 
    {
        terminal_name = "sm_battle_of_kings_exchange_list_cell_exchange", 
        terminal_state = 0, 
        touch_black = true,
        cell = self,
    }, nil, 3)

	self:updateDraw()
end

function SmBattleOfKingsExchangeListCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmBattleOfKingsExchangeListCell:clearUIInfo( ... )
    local root = self.roots[1]
    
    -- 需要的道具
    local Panel_props_1 = ccui.Helper:seekWidgetByName(root, "Panel_props_1")
    Panel_props_1:removeAllChildren(true)
    
    -- 兑换的奖励
    local Panel_props_2 = ccui.Helper:seekWidgetByName(root, "Panel_props_2")
    Panel_props_2:removeAllChildren(true)
end

function SmBattleOfKingsExchangeListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmBattleOfKingsExchangeListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/BattleofKings/battle_of_kings_exchange_list.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmBattleOfKingsExchangeListCell:init(params)
    self.index = params[1]
    self._element = params[2]
	self:onInit()

    self:setContentSize(SmBattleOfKingsExchangeListCell.__size)
    return self
end

function SmBattleOfKingsExchangeListCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/BattleofKings/battle_of_kings_exchange_list.csb", self.roots[1])
end