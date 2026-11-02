----------------------------------------------------------------------------------------------------
-- 说明：慷慨排行cell
-------------------------------------------------------------------------------------------------------
ActivityLargesseGiveBuyCell = class("ActivityLargesseGiveBuyCellClass", Window)
ActivityLargesseGiveBuyCell.__size = nil

local activity_largesse_give_buy_create_cell_terminal = {
    _name = "activity_largesse_give_buy_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = ActivityLargesseGiveBuyCell:new():init(params)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_largesse_give_buy_create_cell_terminal)
state_machine.init()

function ActivityLargesseGiveBuyCell:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_activity_largesse_give_buy_cell_terminal()
        --更新数据
        local activity_largesse_give_buy_cell_update_terminal = {
            _name = "activity_largesse_give_buy_cell_update",
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
        
        state_machine.add(activity_largesse_give_buy_cell_update_terminal)        
        state_machine.init()
    end
    init_activity_largesse_give_buy_cell_terminal() 
end

function ActivityLargesseGiveBuyCell:updateDraw()
    local root = self.roots[1]
    local Text_seek_treasure_rank_n_1 = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_rank_n_1")    --排名文本
    local Panel_seek_treasure_rank_top = ccui.Helper:seekWidgetByName(root,"Panel_seek_treasure_rank_top")    --排名容器
    local Text_seek_treasure_rank_n_2 = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_rank_n_2")    --昵称
    local Text_seek_treasure_rank_n_3 = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_rank_n_3")    --慷慨值 
       
    Text_seek_treasure_rank_n_1:setString(1)
    Text_seek_treasure_rank_n_2:setString("a")
    Text_seek_treasure_rank_n_3:setString(1)
end

function ActivityLargesseGiveBuyCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.seek_treasure_rank_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ActivityLargesseGiveBuyCell.__size == nil then
        ActivityLargesseGiveBuyCell.__size = root:getContentSize()
    end
    self:updateDraw()
end

function ActivityLargesseGiveBuyCell:init(params)
    self:onInit()
    self:setContentSize(ActivityLargesseGiveBuyCell.__size)
    return self
end

function ActivityLargesseGiveBuyCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ActivityLargesseGiveBuyCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.seek_treasure_rank_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function ActivityLargesseGiveBuyCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_seek_treasure_rank_n_1 = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_rank_n_1")        
    local Text_seek_treasure_rank_n_2 = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_rank_n_2")    
    local Text_seek_treasure_rank_n_3 = ccui.Helper:seekWidgetByName(root,"Text_seek_treasure_rank_n_3") 
    if Text_seek_treasure_rank_n_2 ~= nil then 
        Text_seek_treasure_rank_n_1:setString("")
        Text_seek_treasure_rank_n_2:setString("")
        Text_seek_treasure_rank_n_3:setString("")
    end
end

function ActivityLargesseGiveBuyCell:onExit()
    local root = self.roots[1]
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.seek_treasure_rank_cell, root)
end