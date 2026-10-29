-----------------------------
--扫荡
-----------------------------
TrialtowerRaids = class("TrialtowerRaidsClass", Window)

local trialtower_raids_window_open_terminal = {
    _name = "trialtower_raids_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)     
        if nil == fwin:find("TrialtowerRaidsClass") then
            local last_floor = params[1]
            local now_floor = params[2] -- or _ED.three_kings_now_floor
            fwin:open(TrialtowerRaids:new():init(last_floor,now_floor), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local trialtower_raids_window_close_terminal = {
    _name = "trialtower_raids_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TrialtowerRaidsClass"))
        state_machine.excute("trialtower_update_draw",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(trialtower_raids_window_open_terminal)
state_machine.add(trialtower_raids_window_close_terminal)
state_machine.init()

function TrialtowerRaids:ctor()
    self.super:ctor()
    self.roots = {}

    --load lua file
    app.load("client.red_alert.cells.campaign.trialtower.trialtower_raids_cell")
    -- var 
    -- 列表
    self.list_view = nil
    self.list_view_posY = nil
    --上次层级
    self._last_floor = nil
    self._now_floor = nil
end

function TrialtowerRaids:onUpdateDraw()
    local root = self.roots[1]
    local ListView_duplicate_raids = ccui.Helper:seekWidgetByName(root,"ListView_duplicate_raids")
    ListView_duplicate_raids:removeAllItems()

    local Text_duplicate_raids_objects = ccui.Helper:seekWidgetByName(root,"Text_duplicate_raids_objects")
    Text_duplicate_raids_objects:setString(string.format(red_alert_all_str[161],self._last_floor,self._now_floor))
    local index = 1
    local height = 0 
    local all_datas = {}
    for i = self._last_floor, self._now_floor do
        local reward_id = 0
        if _ED.three_kings_reset_times > 0 then 
            reward_id = dms.int(dms["three_kingdoms_config"],i,three_kingdoms_config.re_attack_reward_id)
        else
            reward_id = dms.int(dms["three_kingdoms_config"],i,three_kingdoms_config.reward_id)
        end
        local reward_items = dms.string(dms["scene_reward"], reward_id, scene_reward.reward_items)
        reward_items = zstring.split(reward_items,"|")
        local datas = {}
        for j,reward in pairs(reward_items) do
            local reward_tab = zstring.split(reward,",")
            local _prop_item = tonumber(reward_tab[1])
            local _prop_type = tonumber(reward_tab[2])
            local _item_value = tonumber(reward_tab[3])
            local data = 
            {
                item_value = _item_value,
                prop_type = _prop_type,
                prop_item = _prop_item,
            }
            table.insert(datas,data)
            table.insert(all_datas,data)
        end
       local cell = state_machine.excute("trialtower_raids_create_cell",0,{datas,i,index})
       ListView_duplicate_raids:addChild(cell)
       height = cell:getContentSize().height
       index = index + 1
    end

    local result = {}
    for i,v in ipairs(all_datas) do
        if result[""..v.prop_type] == nil then
            result[""..v.prop_type] = {}--{item_value = 0, prop_type = v.prop_type, prop_item = v.prop_item}
        end
        if result[""..v.prop_type][""..v.prop_item] == nil then 
            result[""..v.prop_type][""..v.prop_item] = {item_value = 0, prop_type = v.prop_type, prop_item = v.prop_item}
        end
        result[""..v.prop_type][""..v.prop_item].item_value = tonumber(v.item_value) + tonumber(result[""..v.prop_type][""..v.prop_item].item_value)
    end
    local info = {}
    for k,v in pairs(result) do
        for k1,v1 in pairs(v) do
            table.insert(info, v1)
        end
    end
    local cell = state_machine.excute("trialtower_raids_create_cell",0,{nil,nil,index})
    ListView_duplicate_raids:addChild(cell)  
    local cell = state_machine.excute("trialtower_raids_create_cell",0,{info,index+1,index+1,1})
    ListView_duplicate_raids:addChild(cell)

    ListView_duplicate_raids:requestRefreshView()
    self.list_view = ListView_duplicate_raids
    
    self.list_view:getInnerContainer():setPositionY(-height*index)
    self.list_view = ListView_duplicate_raids
    self.list_view_posY = ListView_duplicate_raids:getInnerContainer():getPositionY()

    local ac = cc.Sequence:create({cc.DelayTime:create(0.5), cc.CallFunc:create(function(sender)
        self.action_play = true
    end)})
    self:stopAllActions()
    self:runAction(ac)
end

--设置扫荡列表Y轴
function TrialtowerRaids:onUpdate(dt)
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

function TrialtowerRaids:onEnterTransitionFinish()

end

function TrialtowerRaids:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.trialtower.trialtower_raids)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_duplicate_raids_ten"), nil, 
    {
        terminal_name = "trialtower_raids_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()	
end

function TrialtowerRaids:init(last_floor,now_floor)
    self._last_floor = last_floor
    self._now_floor = now_floor
	self:onInit()
    return self
end

function TrialtowerRaids:onExit()
    
end
