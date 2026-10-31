-- ----------------------------------------------------------------------------------------------------
-- 说明：大冒险开启宝箱
-------------------------------------------------------------------------------------------------------
AdventureBoxOpen = class("AdventureBoxOpenClass", Window)

local adventure_box_open_open_terminal = {
    _name = "adventure_box_open_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("AdventureBoxOpenClass") == nil then
            fwin:open(AdventureBoxOpen:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local adventure_box_open_close_terminal = {
    _name = "adventure_box_open_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("AdventureBoxOpenClass") then
            fwin:close(fwin:find("AdventureBoxOpenClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_box_open_open_terminal)
state_machine.add(adventure_box_open_close_terminal)
state_machine.init()

function AdventureBoxOpen:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.activity.adventure.AdventureWindow")

    local function adventure_box_open_terminal()
        --选择数字
        local adventure_box_get_reward_terminal = {
            _name = "adventure_box_get_reward",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)
                        instance.state = 2
                        instance:stateUpdate()
                        state_machine.excute("adventure_box_update", 0, "")
                    end
                end
                
                protocol_command.monololy_open_cheast.param_list = "" .. instance.boxId
                NetworkManager:register(protocol_command.monololy_open_cheast.code, nil, nil, nil, instance, callBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_box_get_reward_terminal)
        state_machine.init()
    end

    adventure_box_open_terminal()
end

function AdventureBoxOpen:init(params)
    self.boxId = params._datas.id
    self.state = params._datas.states
    return self
end

function AdventureBoxOpen:onUpdate(dt)
end

function AdventureBoxOpen:onUpdateDraw()
    local root = self.roots[1]
    local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_award")
    local ImageView_1226 = ccui.Helper:seekWidgetByName(root, "ImageView_1226")
    ListViewDraw:removeAllItems()

    local scaleBase = ListViewDraw:getScale()
    local centerPosX = ImageView_1226:getContentSize().width/2
    local cellSize = 0
    local index = 1
    -- 奖励
    local boxReward = _ED.active_activity[147].activity_Info
    local rewards = zstring.splits(boxReward[self.boxId].activityInfo_reward_select, "|", ",")
    local activity_count = tonumber(#rewards)
    for i, reward in ipairs(rewards) do
        local rewardType = zstring.tonumber(reward[1])
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
                table.shipStar = tonumber(reward[4])
            end
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1)
        end
        cellSize = cell:getContentSize().width
        index = index + 1
        ListViewDraw:addChild(cell)
    end
    ListViewDraw:requestRefreshView()

   self:stateUpdate()
end

function AdventureBoxOpen:stateUpdate()
    local Button_receive = ccui.Helper:seekWidgetByName(self.roots[1], "Button_receive")
     if self.state == 1 then
        Button_receive:setTouchEnabled(true)
        Button_receive:setBright(true)
    else
        Button_receive:setTouchEnabled(false)
        Button_receive:setBright(false)
    end
end


function AdventureBoxOpen:onEnterTransitionFinish()
    local csbNode = csb.createNode("duplicate/copy_the_award.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "adventure_box_open_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    -- 领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive"), nil, 
    {
        terminal_name = "adventure_box_get_reward", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function AdventureBoxOpen:onExit()

end
