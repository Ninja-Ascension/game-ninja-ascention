
UnionFightRewardCell = class("UnionFightRewardCellClass", Window)
UnionFightRewardCell.__size = nil

local union_fight_reward_cell_create_terminal = {
    _name = "union_fight_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local info = params[1]
        local index = params[2]
        local cell = UnionFightRewardCell:new()
        cell:init(info, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fight_reward_cell_create_terminal)
state_machine.init()

function UnionFightRewardCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._info = nil

    local function init_union_fight_reward_cell_terminal()
        local union_fight_reward_cell_click_terminal = {
            _name = "union_fight_reward_cell_click",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        state_machine.excute("reward_obtain_window_open", 0, {80})
                    end
                end
                protocol_command.draw_union_stronghold_reward.param_list = _ED.union.union_info.union_id.."\r\n"..cell._info.city_id
                NetworkManager:register(protocol_command.draw_union_stronghold_reward.code, nil, nil, nil, cell, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fight_reward_cell_click_terminal)
        state_machine.init()
    end
    init_union_fight_reward_cell_terminal()
end

function UnionFightRewardCell:updateDraw()
    local root = self.roots[1]
    local Panel_build_icon = ccui.Helper:seekWidgetByName(root, "Panel_build_icon")
    local Text_build_name = ccui.Helper:seekWidgetByName(root, "Text_build_name")
    local ListView_rew = ccui.Helper:seekWidgetByName(root, "ListView_rew")
    local Button_rev_rew = ccui.Helper:seekWidgetByName(root, "Button_rev_rew")
    local Image_rev = ccui.Helper:seekWidgetByName(root, "Image_rev")
    Panel_build_icon:setBackGroundImage("images/ui/play/big_map/big_map_build_1.png")
    Text_build_name:setString("")
    ListView_rew:removeAllItems()
    Button_rev_rew:setVisible(false)
    Image_rev:setVisible(false)

    local reward_state = false
    if _ED.union.user_union_info.union_city_reward_info ~= nil 
        and _ED.union.user_union_info.union_city_reward_info ~= ""
        and _ED.union.user_union_info.union_city_reward_info ~= "-1" then
        local info = zstring.split(_ED.union.user_union_info.union_city_reward_info, ",")
        for k,v in pairs(info) do
            if tonumber(self._info.city_id) == tonumber(v) then
                reward_state = true
            end
        end
    end
    
    if reward_state == false then
        Button_rev_rew:setVisible(true)
    else
        Image_rev:setVisible(true)
    end
    local pic_index = dms.int(dms[config_res.campaign.nationalwar.warfare_map_mould], self._info.city_id, warfare_map_mould.city_pic)
    Text_build_name:setString(dms.string(dms[config_res.campaign.nationalwar.warfare_map_mould], self._info.city_id, warfare_map_mould.city_name))
    local reward_items_show = dms.string(dms["scene_reward"], self._info.reward_id, scene_reward.reward_items)
    local reward = zstring.split(reward_items_show, "|")
    local prop_data = {}
    for k,v in pairs(reward) do
        local data_str = v
        if data_str ~= "" then
            data_str = zstring.split(data_str,",")
            local data = {
                prop_item   = tonumber(data_str[1]),    -- 物品1模板ID(没有则为-1)
                prop_type   = tonumber(data_str[2]),    -- 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:武将) 
                item_value  = tonumber(data_str[3])     -- 物品1数量
            }
            table.insert(prop_data, data)
        end
    end
    for i,v in pairs(prop_data) do
        if tonumber(v.prop_type) == 6 then
            if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.change_of_equipment))> 0 
                or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.use_of_ship)) > 0  then
                cell = state_machine.excute("all_resource_create_cell",0,{3,v,v,1,0,true,true})
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,true,true})
            end  
        elseif tonumber(v.prop_type) == 34 then    
            cell = state_machine.excute("all_resource_create_cell",0,{5,v,v,1,0,true,true})   
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,true,true})
        end
        ListView_rew:addChild(cell)
    end
end

function UnionFightRewardCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.big_map.map_legion_build_reward_cell, "root")
    self:addChild(root)
    table.insert(self.roots, root)

    if UnionFightRewardCell.__size == nil then
        UnionFightRewardCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rev_rew"), nil, 
    {
        terminal_name = "union_fight_reward_cell_click", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        _cell = self,
    }, 
    nil, 0)

    self:updateDraw()
end

function UnionFightRewardCell:onEnterTransitionFinish()

end

function UnionFightRewardCell:init(info, index)
    self._info = info
    self.index = index
    if index < 5 then
        self:onInit()
    end
    self:setContentSize(UnionFightRewardCell.__size)
    return self
end

function UnionFightRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function UnionFightRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    ccui.Helper:seekWidgetByName(root, "ListView_rew"):removeAllItems()
    cacher.freeRef(config_csb.cells.big_map.map_legion_build_reward_cell, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function UnionFightRewardCell:onExit()
    local ListView_rew = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_rew")
    if ListView_rew ~= nil then
        ListView_rew:removeAllItems()
    end
    cacher.freeRef(config_csb.cells.big_map.map_legion_build_reward_cell, self.roots[1])
end
