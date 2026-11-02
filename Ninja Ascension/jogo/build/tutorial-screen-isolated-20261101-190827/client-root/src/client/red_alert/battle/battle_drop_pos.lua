-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗道具掉落
-- ----------------------------------------------------------------------------------------------------
BattleDropPos = class("BattleDropPosClass", Window)

-- 新建战斗道具掉落
local battle_drop_pos_create_terminal = {
    _name = "battle_drop_pos_create",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _battleDropPosUI = BattleDropPos:new()
        fwin:open(_battleDropPosUI)
        return _battleDropPosUI
    end,
    _terminal = nil,
    _terminals = nil
}

-- 删除战斗道具掉落
local battle_drop_pos_window_close_terminal = {
    _name = "battle_drop_pos_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleDropPosClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_drop_pos_create_terminal)
state_machine.add(battle_drop_pos_window_close_terminal)
state_machine.init()

function BattleDropPos:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    --第几个掉落
    self.stateIndex = 0

    --道具icon
    self._cell = nil
    self._cell_1 = nil
    self._cell_2 = nil

    app.load("client.red_alert.cells.all_resources_cell")

    -- Initialize battle_drop_pos state machine.
    local function init_battle_drop_pos_terminal()
        --刷新掉落位置
        local battle_drop_pos_update_drop_terminal = {
            _name = "battle_drop_pos_update_drop",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local window = fwin:find("BattleDropPosClass")
                if window ~= nil then
                    window:updateDrop(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(battle_drop_pos_update_drop_terminal)
        state_machine.init()
    end
     -- call func init battle_drop_pos state machine.
    init_battle_drop_pos_terminal()
end

--删除
local function removeDrawAntNumberFuncN(sender)
    sender:removeFromParent(true)
    state_machine.excute("battle_drop_pos_window_close", 0, 0)
end

--获得掉落道具宝箱抖动
local function onBoxShake()
    state_machine.excute("battle_ui_box_shake",0,"")
    local index = 1
    state_machine.excute("battle_ui_drop_prop", 0, {index})
end

--道具掉落动画
function BattleDropPos:updateDrop(params)
    local parent = params.parent
    local zorder = params.zorder
    local dropItem = params.dropItem
    local pos = params.pos

    local posX = 0
    local posY = 0

    self.stateIndex = self.stateIndex + 1
    if self.stateIndex ~= 6 then 
        posX = math.floor(self.stateIndex/6) + 1
        posY = math.ceil(self.stateIndex%6) 
    elseif self.stateIndex == 6 then
        posX = math.floor(self.stateIndex/6)
        posY = 6
    elseif self.stateIndex == 12 then
        posX = math.floor(self.stateIndex/6)
        posY = 12
    end
    local csbItem = csb.createNode(config_csb.battle.battle_drop)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.battle.battle_drop)
    table.insert(self.actions,action)
    csbItem:runAction(action)
    local data = {
        item_value = dropItem.item_count,
        prop_type = dropItem.item_type,
        prop_item = dropItem.item_id
    }
    --添加道具 
    if data.prop_type == 6 then 
        if zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.change_of_equipment))> 0 
            or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(data.prop_item), prop_mould.use_of_ship)) > 0  then
            self._cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,8,0,false,false})
            self._cell_1 = state_machine.excute("all_resource_create_cell",0,{3,data,data,8,0,false,false})
            self._cell_2 = state_machine.excute("all_resource_create_cell",0,{3,data,data,8,0,false,false})
        else    
            self._cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
            self._cell_1 = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
            self._cell_2 = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
        end
    elseif data.prop_type == 10000 then
        self._cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
        self._cell_1 = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
        self._cell_2 = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
    else
        self._cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
        self._cell_1 = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
        self._cell_2 = state_machine.excute("all_resource_create_cell",0,{2,data,data,8,0,false,false})
    end 
    self._cell:setPosition(pos)
    local pos_x = self._cell:getPositionX()
    local pos_y = self._cell:getPositionY()
    self._cell:setScale(0.5)
    --添加重影
    self._cell_1:setPosition(cc.p(pos_x, pos.y))
    self._cell_1:setScale(0.5)
    self._cell_1.roots[1]:setOpacity(80)
    self._cell_2:setPosition(cc.p(pos.x, pos.y))
    self._cell_2:setScale(0.5) 
    self._cell_2.roots[1]:setOpacity(40)

    parent:addChild(self._cell)
    parent:addChild(self._cell_1)
    parent:addChild(self._cell_2) 
    local Panel_drop = ccui.Helper:seekWidgetByName(root, "Panel_drop_".. posX .."_".. posY )
    local move_pos_x = Panel_drop:getPositionX()
    local move_pos_y = Panel_drop:getPositionY()
    local bezier = {
                    cc.p(pos_x, pos_y),
                    cc.p(move_pos_x,pos_y+(move_pos_y-pos_y)*0.5),
                    cc.p(move_pos_x, move_pos_y)
                    }
    --播放动画
    self._cell:runAction(cc.Sequence:create(cc.BezierTo:create(0.5,bezier),
        cc.DelayTime:create(1),
        cc.MoveBy:create(0.3, cc.p(10, -10)),
        cc.MoveTo:create(0.3, cc.p(300, 580)),
        cc.CallFunc:create(onBoxShake),
        cc.CallFunc:create(removeDrawAntNumberFuncN)))

    self._cell_1:runAction(cc.Sequence:create(cc.BezierTo:create(0.52,bezier),
        cc.DelayTime:create(1),
        cc.MoveBy:create(0.3, cc.p(10, -10)),
        cc.MoveTo:create(0.3, cc.p(300, 580)),
        cc.CallFunc:create(removeDrawAntNumberFuncN)))

    self._cell_2:runAction(cc.Sequence:create(cc.BezierTo:create(0.54,bezier),
        cc.DelayTime:create(1),
        cc.MoveBy:create(0.3, cc.p(10, -10)),
        cc.MoveTo:create(0.3, cc.p(300, 580)),
        cc.CallFunc:create(removeDrawAntNumberFuncN)))

    return self
end

function BattleDropPos:onEnterTransitionFinish()

end

function BattleDropPos:close()

end

function BattleDropPos:destroy()

end
-- ----------------------------------------------------------------------------------------------------