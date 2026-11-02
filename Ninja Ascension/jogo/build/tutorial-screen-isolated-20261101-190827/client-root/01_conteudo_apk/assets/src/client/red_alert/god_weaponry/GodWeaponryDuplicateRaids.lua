-----------------------------
--扫荡
-----------------------------
GodWeaponryDuplicateRaids = class("GodWeaponryDuplicateRaidsClass", Window)

local god_weaponry_duplicate_raids_window_open_terminal = {
    _name = "god_weaponry_duplicate_raids_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)     
        if nil == fwin:find("GodWeaponryDuplicateRaidsClass") then
            local times = params[1]
            local difficulty_index = params[2]
            local npc_name = params[3]
            fwin:open(GodWeaponryDuplicateRaids:new():init(times,difficulty_index,npc_name), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local god_weaponry_duplicate_raids_window_close_terminal = {
    _name = "god_weaponry_duplicate_raids_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GodWeaponryDuplicateRaidsClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(god_weaponry_duplicate_raids_window_open_terminal)
state_machine.add(god_weaponry_duplicate_raids_window_close_terminal)
state_machine.init()

function GodWeaponryDuplicateRaids:ctor()
    self.super:ctor()
    self.roots = {}

    --load lua file
    app.load("client.red_alert.cells.god_weaponry.god_weaponry_duplicate_raids_cell")
    -- var 
    -- 列表
    self.list_view = nil
    self.list_view_posY = nil
    -- 扫荡次数
    self.times = 0
    -- 难度
    self.difficulty_index = 0
    -- npc名字
    self.npc_name = nil
end

function GodWeaponryDuplicateRaids:onUpdateDraw()
    local root = self.roots[1]
    local ListView_duplicate_raids = ccui.Helper:seekWidgetByName(root,"ListView_duplicate_raids")
    ListView_duplicate_raids:removeAllItems()
    -- 扫荡对象
    local Text_duplicate_raids_objects = ccui.Helper:seekWidgetByName(root,"Text_duplicate_raids_objects")
    Text_duplicate_raids_objects:setString(gems_duplicate_level[self._difficulty_index].. "·" ..self._npc_name)
    local Button_duplicate_raids_one = ccui.Helper:seekWidgetByName(root,"Button_duplicate_raids_one"):setVisible(false)
    local Button_duplicate_raids_ten = ccui.Helper:seekWidgetByName(root,"Button_duplicate_raids_ten"):setVisible(false)
    
    local index = 1
    local result = {}
    for i1,v1 in pairs(_ED.show_reward_list_group) do
        for i,v in ipairs(v1.show_reward_list) do
            if result[""..v.prop_type] == nil then
                result[""..v.prop_type] = {}--{item_value = 0, prop_type = v.prop_type, prop_item = v.prop_item}
            end
            if result[""..v.prop_type][""..v.prop_item] == nil then 
                result[""..v.prop_type][""..v.prop_item] = {item_value = 0, prop_type = v.prop_type, prop_item = v.prop_item}
            end
            result[""..v.prop_type][""..v.prop_item].item_value = tonumber(v.item_value) + tonumber(result[""..v.prop_type][""..v.prop_item].item_value)
        end
        local cell = state_machine.excute("god_weaponry_duplicate_raids_create_cell",0,{v1,i1})
        ListView_duplicate_raids:addChild(cell)
        index = index + 1
    end

    local info = {show_reward_list = {}, show_reward_type = 2, show_reward_item_count = 0}
    for k,v in pairs(result) do
        for k1,v1 in pairs(v) do
            info.show_reward_item_count = info.show_reward_item_count + 1
            table.insert(info.show_reward_list, v1)
        end
    end
    local cell = state_machine.excute("god_weaponry_duplicate_raids_create_cell",0,{nil,index})
    ListView_duplicate_raids:addChild(cell)  
    local cell = state_machine.excute("god_weaponry_duplicate_raids_create_cell",0,{info,index + 1,1})
    ListView_duplicate_raids:addChild(cell)
    local height = cell:getContentSize().height
    ListView_duplicate_raids:requestRefreshView()
    self.list_view = ListView_duplicate_raids
    self.list_view:getInnerContainer():setPositionY(-height*index + 1)
    self.list_view = ListView_duplicate_raids
    self.list_view_posY = ListView_duplicate_raids:getInnerContainer():getPositionY()

    local ac = cc.Sequence:create({cc.DelayTime:create(0.5), cc.CallFunc:create(function(sender)
        self.action_play = true
    end)})
    self:stopAllActions()
    self:runAction(ac)
end

--设置扫荡列表Y轴
function GodWeaponryDuplicateRaids:onUpdate(dt)
    if self.list_view ~= nil then
        if self.action_play == true then
            local y = self.list_view:getInnerContainer():getPositionY()
            if y + 25  > 0 then
                self.action_play = false
            else
                self.list_view:getInnerContainer():setPositionY(y+25)
            end
        end
    end

    if self.list_view ~= nil then
        local size = self.list_view:getContentSize()
        local posY = self.list_view:getInnerContainer():getPositionY()
        if self.list_view_posY == posY then
            return
        end
        self.list_view_posY = posY
        local items = self.list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function GodWeaponryDuplicateRaids:onEnterTransitionFinish()

end

function GodWeaponryDuplicateRaids:onInit( )
    local csbItem = csb.createNode(config_csb.duplicate.duplicate_raids)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_duplicate_raids_close"), nil, 
    {
        terminal_name = "god_weaponry_duplicate_raids_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    self:onUpdateDraw() 
end

function GodWeaponryDuplicateRaids:init(times,difficulty_index,npc_name)
    self._times = times
    self._difficulty_index = difficulty_index
    self._npc_name = npc_name
    self:onInit()
    return self
end

function GodWeaponryDuplicateRaids:onExit()
    
end
