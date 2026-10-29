-----------------------------
--无双试炼奖励显示
-----------------------------
TrialtowerReward = class("TrialtowerRewardClass", Window)

local trialtower_reward_window_open_terminal = {
    _name = "trialtower_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)     
        if nil == fwin:find("TrialtowerRewardClass") then
            fwin:open(TrialtowerReward:new():init(), fwin._ui)
        end

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local trialtower_reward_window_close_terminal = {
    _name = "trialtower_reward_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TrialtowerRewardClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(trialtower_reward_window_open_terminal)
state_machine.add(trialtower_reward_window_close_terminal)
state_machine.init()

function TrialtowerReward:ctor()
    self.super:ctor()
    self.roots = {}

    --load lua file
    app.load("client.red_alert.cells.campaign.trialtower.trialtower_reward_cell")

end

function TrialtowerReward:onUpdateDraw()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    ListView_1:removeAllItems()
    local index = 1
    for i = 1,dms.count(dms["three_kingdoms_config"]) do
        local tier = dms.int(dms["three_kingdoms_config"],i,three_kingdoms_config.tier)
        if tier % 5 == 0 then
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
            end

            local cell = state_machine.excute("trialtower_reward_create_cell",0,{datas,tier,index})
            ListView_1 :addChild(cell)
            index = index + 1
        end
    end 
    ListView_1:requestRefreshView()
    self.listview = ListView_1
    self.listview_PosY = self.listview:getInnerContainer():getPositionY()
end

function TrialtowerReward:onUpdate()
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_PosY == posY then
            return
        end
        self.listview_PosY = posY
        local items = self.listview:getItems()
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

function TrialtowerReward:onEnterTransitionFinish()

end

function TrialtowerReward:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.trialtower.trialtower_reward)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "trialtower_reward_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()	
end

function TrialtowerReward:init()
	self:onInit()
    return self
end

function TrialtowerReward:onExit()
    
end
