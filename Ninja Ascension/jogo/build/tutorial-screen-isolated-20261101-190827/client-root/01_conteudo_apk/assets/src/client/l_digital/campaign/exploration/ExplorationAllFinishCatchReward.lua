-- ----------------------------------------------------------------------------------------------------
-- 说明：探索捕捉奖励
-------------------------------------------------------------------------------------------------------
ExplorationAllFinishCatchReward = class("ExplorationAllFinishCatchRewardClass", Window)

local exploration_all_finish_catch_reward_window_open_terminal = {
    _name = "exploration_all_finish_catch_reward_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("ExplorationAllFinishCatchRewardClass") == nil then
            fwin:open(ExplorationAllFinishCatchReward:new():init(params), fwin._view)
        end

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local exploration_all_finish_catch_reward_window_close_terminal = {
    _name = "exploration_all_finish_catch_reward_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("ExplorationAllFinishCatchRewardClass") then
            fwin:close(fwin:find("ExplorationAllFinishCatchRewardClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(exploration_all_finish_catch_reward_window_open_terminal)
state_machine.add(exploration_all_finish_catch_reward_window_close_terminal)
state_machine.init()

function ExplorationAllFinishCatchReward:ctor()
    self.super:ctor()
    self.roots = {}
    
    local function init_exploration_all_finish_catch_reward_terminal()
        local exploration_all_finish_catch_reward_type_terminal = {
            _name = "exploration_all_finish_catch_reward_type",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _type = params._datas._type
                instance:sorceTypeTab(_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_all_finish_catch_reward_update_terminal = {
            _name = "exploration_all_finish_catch_reward_update",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local _type = params
                instance:onUpdateDraw(_type)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(exploration_all_finish_catch_reward_type_terminal)
        state_machine.add(exploration_all_finish_catch_reward_update_terminal)
        state_machine.init()
    end
    
    init_exploration_all_finish_catch_reward_terminal()
end

function ExplorationAllFinishCatchReward:init(params)
    return self
end

function ExplorationAllFinishCatchReward:onUpdate(dt)

end

function ExplorationAllFinishCatchReward:drawReword()
    local root = self.roots[1]
    local rewardInfo = getSceneReward(75).show_reward_list
    local max_num = table.nums(rewardInfo)
    local ScrollView_41 = ccui.Helper:seekWidgetByName(root, "ScrollView_get")
    local panel = ScrollView_41:getInnerContainer()
    panel:setContentSize(ScrollView_41:getContentSize())
    panel:setPosition(cc.p(0, 0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local tHeight = 0
    local tWidth = 0
    local wPosition = sSize.width/5
    local Hlindex = 0
    local m_number = max_num
    local cellHeight = 0
    local cellWidth = 0
    index = 0
    cellHeight = m_number/5*(ScrollView_41:getContentSize().height/2)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(ScrollView_41:getContentSize().width, sHeight)
    ScrollView_41:jumpToTop()
    local function addReward( sender )
        if index >= max_num then
            -- ccui.Helper:seekWidgetByName(root, "Panel_15"):setVisible(true)
            return
        end
        playEffect(formatMusicFile("effect", 9988))
        index = index + 1
        local info = rewardInfo[index]
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{info.prop_type, info.prop_item, info.item_value},true,true,false,true})
        if tonumber(info.prop_type) == 13 then
            local ship = nil
            for i,v in pairs(_ED.user_ship) do
                if _ED.recruit_success_ship_id == v.ship_id then
                    ship = v
                end
            end
            local table = {}
            if ship ~= nil then
                table.shipStar = ship.StarRating
            end
            cell = nil
            cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{info.prop_type, info.prop_item, info.item_value},true,true,false,true, table})
        end

        panel:addChild(cell)
        tWidth = tWidth + wPosition
        if (index - 1)%5 == 0 then
            Hlindex = Hlindex + 1
            tWidth = 0
            tHeight = sHeight - wPosition * Hlindex
            if Hlindex >= 20 then
                ScrollView_41:scrollToPercentVertical(100, 0, false)
            elseif Hlindex >= 18 then
                ScrollView_41:scrollToPercentVertical((Hlindex - 5/Hlindex)*100/m_number, 0, false)
            elseif Hlindex >= 3 then
                ScrollView_41:scrollToPercentVertical((Hlindex - 8/Hlindex)*100/m_number, 0, false)
            end
        end
        if index <= 5 then
            tHeight = sHeight - wPosition
        end

        cell:setPosition(cc.p(tWidth, tHeight + 10))
        cell:setScale(0.1)
        local seq = cc.Sequence:create(
            cc.ScaleTo:create(0.12, 1.2),
            cc.ScaleTo:create(0.02, 1),
            cc.CallFunc:create(addReward)
         )
        cell:runAction(seq)
    end
    addReward(self)
end

function ExplorationAllFinishCatchReward:onUpdateDraw()
    local root = self.roots[1]
    self:drawReword()
end

function ExplorationAllFinishCatchReward:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/exploration/exploration_catch_get.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "exploration_all_finish_catch_reward_window_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function ExplorationAllFinishCatchReward:onExit()

end
