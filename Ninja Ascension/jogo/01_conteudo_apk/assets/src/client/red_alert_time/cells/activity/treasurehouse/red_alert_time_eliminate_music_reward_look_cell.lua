-- ------------------------------------------------------------------------------------------------------------
--  说明：消消乐任务单个列表
-- ------------------------------------------------------------------------------------------------------------
RedAlertTimeEliminateMusicRewardLookCell = class("RedAlertTimeEliminateMusicRewardLookCellClass", Window)
RedAlertTimeEliminateMusicRewardLookCell.__size = nil

--创建cell
local red_alert_time_eliminate_music_reward_look_cell_create_terminal = {
    _name = "red_alert_time_eliminate_music_reward_look_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeEliminateMusicRewardLookCell:new()
        local activity_data = params[1]
        local title = params[2]
        cell:init(activity_data , title)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_eliminate_music_reward_look_cell_create_terminal)
state_machine.init()

function RedAlertTimeEliminateMusicRewardLookCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.title = ""
    self._activity_data = nil
    -- local function init_red_alert_time_eliminate_music_reward_look_cell_terminal()
    --     local red_alert_time_eliminate_music_reward_look_receive_terminal = {
    --         _name = "red_alert_time_eliminate_music_reward_look_receive",
    --         _init = function (terminal)
    --         end,
    --         _inited = false,
    --         _instance = self,
    --         _state = 0,
    --         _invoke = function(terminal, instance, params)
  
    --             return true
    --         end,
    --         _terminal = nil,
    --         _terminals = nil
    --     }
        
    --     state_machine.add(red_alert_time_eliminate_music_reward_look_receive_terminal)
    -- end
    -- init_red_alert_time_eliminate_music_reward_look_cell_terminal()
end

function RedAlertTimeEliminateMusicRewardLookCell:updateDraw()
    local root = self.roots[1]
    local Text_reward_tit = ccui.Helper:seekWidgetByName(root, "Text_reward_tit")
    Text_reward_tit:setString(self.title)

    local Image_reward_bar = ccui.Helper:seekWidgetByName(root, "Image_reward_bar")
    local ScrollView_reward_box = ccui.Helper:seekWidgetByName(root,"ScrollView_reward_box")
    ScrollView_reward_box:removeAllChildren(true)
    local currScale = ScrollView_reward_box:getScale()
    local width = ScrollView_reward_box:getContentSize().width 
    local height = ScrollView_reward_box:getContentSize().height 
    local cell_height = 0
    local cell_width = 0
    local tocalHeight = 0
    local iconGroup = {}
    for i,v in pairs(self._activity_data) do
        local temp_tab = zstring.split(v, ",")
        local reward_data = {
            item_value = temp_tab[3],
            prop_type = temp_tab[2],
            prop_item = temp_tab[1],
        }

        local prop_type = tonumber(reward_data.prop_type)
        local show_type = 9
        local prop_from_type = 3
        if tonumber(reward_data.prop_type) == 13 then --坦克
            prop_type = 3
            prop_from_type = 10
        elseif tonumber(reward_data.prop_type) == 6 then --道具    
            prop_type = 1
            prop_from_type = 1
        elseif tonumber(reward_data.prop_type) == 7 then --配件    
            prop_type = 7
            prop_from_type = 4
        else
            prop_type = 1
            prop_from_type = 1
        end
        local cell = nil
        if prop_type == 7 then
            local equip_datas = {}
            equip_datas.equipment_name = dms.string(dms["equipment_mould"], tonumber(reward_data.prop_item), equipment_mould.equipment_name)
            equip_datas.pic_index = dms.string(dms["equipment_mould"], tonumber(reward_data.prop_item), equipment_mould.pic_index)
            cell = state_machine.excute("props_icon_create_cell",0,{show_type, 3, equip_datas, tonumber(prop_type), tonumber(reward_data.item_value)})
        elseif prop_type == 3 
            and dms.int(dms["ship_mould"], tonumber(reward_data.prop_item), ship_mould.captain_type) == 3 then --英雄
            cell = state_machine.excute("props_icon_create_cell", 0, {2, 9, tonumber(reward_data.prop_item), 3, 1,true})
        else    
            cell = state_machine.excute("props_icon_create_cell",0,{show_type, prop_from_type, tonumber(reward_data.prop_item), tonumber(prop_type), tonumber(reward_data.item_value),nil,tonumber(reward_data.prop_item)})
        end
        if cell_height == 0 then
            cell_height = (cell:getContentSize().height + 35) 
        end
        if cell_width == 0 then
            cell_width = cell:getContentSize().width 
        end

        table.insert(iconGroup, cell)
        ScrollView_reward_box:addChild(cell)
    end
    tocalHeight = cell_height * (math.ceil( #self._activity_data / 4 ))
    tocalHeight = math.max(tocalHeight , height)
    ScrollView_reward_box:setInnerContainerSize(cc.size(width, tocalHeight))
    for i, v in pairs(iconGroup) do
        local wight_n = 1
        local height_n = 1
        if i % 4 == 0 then
            wight_n = 4
        else
            wight_n = i % 4
        end
        local interval = (width - 4 * cell_width) / 3
        if i % 4 == 0 then
            height_n = i / 4
        else
            height_n = math.floor(i / 4) + 1
        end
        v:setPosition(cc.p((wight_n - 1) * ( interval + cell_width ), tocalHeight - cell_height * height_n + 35 ))
    end
end

function RedAlertTimeEliminateMusicRewardLookCell:onInit()
    local csbItem = csb.createNode(config_csb.cells.activity.treasurehouse.eliminate_music_reward_look_cell)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    self:setContentSize(cc.size(root:getContentSize().width , root:getContentSize().height))
    self:updateDraw()
end

function RedAlertTimeEliminateMusicRewardLookCell:onEnterTransitionFinish()

end

function RedAlertTimeEliminateMusicRewardLookCell:init(activity_data , title)
    self._activity_data = activity_data
    self.title = title
    self:onInit()
    return self
end

function RedAlertTimeEliminateMusicRewardLookCell:onExit()
   
end
