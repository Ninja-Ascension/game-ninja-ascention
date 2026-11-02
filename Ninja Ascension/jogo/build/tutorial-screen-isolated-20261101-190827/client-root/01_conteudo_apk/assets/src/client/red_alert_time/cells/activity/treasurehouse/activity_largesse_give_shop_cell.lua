----------------------------------------------------------------------------------------------------
-- 说明：排行奖励cell
-------------------------------------------------------------------------------------------------------
ActivityLargesseGiveShopCell = class("ActivityLargesseGiveShopCellClass", Window)
ActivityLargesseGiveShopCell.__size = nil

local activity_largesse_give_shop_create_cell_terminal = {
    _name = "activity_largesse_give_shop_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ActivityLargesseGiveShopCell:new():init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_largesse_give_shop_create_cell_terminal)
state_machine.init()

function ActivityLargesseGiveShopCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._index = nil
    self._activity_info = {}
    self._activity_type = nil
    local function init_activity_largesse_give_shop_cell_terminal()
        --更新数据
        local activity_largesse_give_shop_cell_update_terminal = {
            _name = "activity_largesse_give_shop_cell_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                cell:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(activity_largesse_give_shop_cell_update_terminal)        
        state_machine.init()
    end
    init_activity_largesse_give_shop_cell_terminal() 
end

function ActivityLargesseGiveShopCell:updateDraw()
    local root = self.roots[1]
    --名次
    local Text_seek_treasure_reward_tit = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_reward_tit")    
    Text_seek_treasure_reward_tit:setString(self._activity_info.achieve_mould_name)
    --图片容器
    local ListView_seek_treasure_reward = ccui.Helper:seekWidgetByName(root,"ListView_seek_treasure_reward")      
    local prop_data = {}
    local prop_info = zstring.split(self._activity_info.achieve_reward, "|")
    ListView_seek_treasure_reward:removeAllItems()
    for i=1,3 do
        local _prop_info = zstring.split(prop_info[i], ",")
        prop_data.prop_item = tonumber(_prop_info[1])
        prop_data.prop_type = tonumber(_prop_info[2])
        prop_data.item_value = tonumber(_prop_info[3])
        local cell = createPropIconCell(prop_data, true, true, true)
        ListView_seek_treasure_reward:addChild(cell)
    end 
    ListView_seek_treasure_reward:requestRefreshView() 
end

function ActivityLargesseGiveShopCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.seek_treasure_reward_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ActivityLargesseGiveShopCell.__size == nil then
        ActivityLargesseGiveShopCell.__size = root:getContentSize()
    end
    self:updateDraw()
end

function ActivityLargesseGiveShopCell:init(params)
    self._index = params[1]
    self._activity_info = params[2]
    self._activity_type = params[3]
    self:onInit()
    self:setContentSize(ActivityLargesseGiveShopCell.__size)
    return self
end

function ActivityLargesseGiveShopCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ActivityLargesseGiveShopCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.seek_treasure_reward_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ActivityLargesseGiveShopCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_seek_treasure_reward_tit = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_reward_tit")    
    local ListView_seek_treasure_reward = ccui.Helper:seekWidgetByName(root,"ListView_seek_treasure_reward")
    if ListView_seek_treasure_reward ~= nil then
        Text_seek_treasure_reward_tit:setString("")
        ListView_seek_treasure_reward:removeAllItems()
    end
end

function ActivityLargesseGiveShopCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.seek_treasure_reward_cell, root)
end