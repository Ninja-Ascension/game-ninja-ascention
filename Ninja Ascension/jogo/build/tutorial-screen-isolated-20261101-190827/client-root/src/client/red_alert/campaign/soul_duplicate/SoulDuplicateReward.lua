-----------------------------
--将魂副本奖励
-----------------------------
SoulDuplicateReward = class("SoulDuplicateRewardClass", Window)

local soul_duplicate_reward_window_open_terminal = {
    _name = "soul_duplicate_reward_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("SoulDuplicateRewardClass") then
            fwin:open(SoulDuplicateReward:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local soul_duplicate_reward_window_close_terminal = {
    _name = "soul_duplicate_reward_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SoulDuplicateRewardClass"))
      
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(soul_duplicate_reward_window_open_terminal)
state_machine.add(soul_duplicate_reward_window_close_terminal)
state_machine.init()

function SoulDuplicateReward:ctor()
    self.super:ctor()
    self.roots = {}

end


function SoulDuplicateReward:onUpdateDraw()
    local root = self.roots[1]
    local ListView_left = ccui.Helper:seekWidgetByName(root,"ListView_left")
    ListView_left:removeAllItems()
    local ListView_right = ccui.Helper:seekWidgetByName(root,"ListView_right")
    ListView_right:removeAllItems()
    for i=1,dms.count(dms["soul_copy_reward"]) do
        local reward_type = dms.int(dms["soul_copy_reward"],i,soul_copy_reward.reward_type)
        local left_index = 0
        local right_index = 0
        if reward_type == 1 then
            left_index = left_index + 1
            local cell = state_machine.excute("soul_duplicate_reward_create_cell",0,{i,left_index})
            ListView_left:addChild(cell)
        elseif reward_type == 2 then
            right_index = right_index + 1
            local cell = state_machine.excute("soul_duplicate_reward_create_cell",0,{i,right_index})
            ListView_right:addChild(cell)
        end
    end

    self.listview_left = ListView_left
    self.listview_right = ListView_right
    self.listview_left_PosY = self.listview_left:getInnerContainer():getPositionY()
    self.listview_right_PosY = self.listview_right:getInnerContainer():getPositionY()

end

function SoulDuplicateReward:onUpdate()
    self:onUpdateLeftListview()
    self:onUpdateRightListview()
end

function SoulDuplicateReward:onUpdateLeftListview()
    if self.listview_left ~= nil then
        local size = self.listview_left:getContentSize()
        local posY = self.listview_left:getInnerContainer():getPositionY()
        if self.listview_left_PosY == posY then
            return
        end
        self.listview_left_PosY = posY
        local items = self.listview_left:getItems()
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

function SoulDuplicateReward:onUpdateRightListview()
    if self.listview_right ~= nil then
        local size = self.listview_right:getContentSize()
        local posY = self.listview_right:getInnerContainer():getPositionY()
        if self.listview_right_PosY == posY then
            return
        end
        self.listview_right_PosY = posY
        local items = self.listview_right:getItems()
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

function SoulDuplicateReward:onEnterTransitionFinish()

end

function SoulDuplicateReward:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.soul_duplicate.soul_duplicate_reward)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "soul_duplicate_reward_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()	
end

function SoulDuplicateReward:initData()
    
end

function SoulDuplicateReward:init()
    self:initData()
	self:onInit()
    return self
end

function SoulDuplicateReward:onExit()

end
