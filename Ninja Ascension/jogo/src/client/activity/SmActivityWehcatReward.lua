-- ----------------------------------------------------------------------------------------------------
-- 说明：探索积分
-------------------------------------------------------------------------------------------------------
SmActivityWehcatReward = class("SmActivityWehcatRewardClass", Window)

local activity_wehcat_reward_open_terminal = {
    _name = "activity_wehcat_reward_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SmActivityWehcatRewardClass") == nil then
            fwin:open(SmActivityWehcatReward:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_wehcat_reward_close_terminal = {
    _name = "activity_wehcat_reward_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("SmActivityWehcatRewardClass") then
            fwin:close(fwin:find("SmActivityWehcatRewardClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_wehcat_reward_open_terminal)
state_machine.add(activity_wehcat_reward_close_terminal)
state_machine.init()

function SmActivityWehcatReward:ctor()
    self.super:ctor()
    self.roots = {}

    local function init_activity_wehcat_reward_terminal()
        local activity_wehcat_recharge_terminal = {
            _name = "activity_wehcat_recharge",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local target = params._datas._self
                local inviteString = ccui.Helper:seekWidgetByName(target.roots[1], "TextField_recharge_three_tips")
                local getNum = inviteString:getString()
                local jhNum = zstring.split(_ED.active_activity[146].need_recharge_count, ",")[2]
                if getNum == nil or getNum == "" or getNum ~= jhNum then 
                    TipDlg.drawTextDailog(tipStringInfo_new_activity_tips[3])
                    return
                end
                
                local function responseCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(7)
                            fwin:open(getRewardWnd, fwin._ui)
                            fwin:close(fwin:find("SmActivityWehcatRewardClass"))
                        end
                    end
                end
                protocol_command.get_activity_reward.param_list = ""..(_ED.active_activity[146].activity_id).."\r\n".."0".."\r\n".."0".."\r\n".."146".."\r\n"..getNum
                NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_wehcat_recharge_terminal)
        state_machine.init()
    end
    
    init_activity_wehcat_reward_terminal()
end

function SmActivityWehcatReward:init(params)
    return self
end

function SmActivityWehcatReward:onUpdate(dt)
end

function SmActivityWehcatReward:onUpdateDraw()
    local root = self.roots[1]
    local inviteString = ccui.Helper:seekWidgetByName(root, "TextField_recharge_three_tips")
    draw:addEditBox(inviteString, tipStringInfo_new_activity_tips[4], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_1"), 12, cc.KEYBOARD_RETURNTYPE_DONE)
    local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_recharge_three_reward")
    ListViewDraw:removeAllItems()
    local activeItem = _ED.active_activity[146]
    if nil == ListViewDraw or nil == activeItem then
        return
    end

    local scaleBase = ListViewDraw:getScale()
    local centerPosX = 199.60
    local cellSize = 0
    local index = 1
    -- 奖励
    local rewards = zstring.splits(activeItem.activity_Info[1].activityInfo_reward_select, "|", ",")
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
        -- local rewardinfo = {}
        -- rewardinfo.type = rewardType
        -- rewardinfo.id = reward[2]
        -- rewardinfo.number = tonumber(reward[3])
        -- self.reworld_sorting[index] = rewardinfo
        index = index + 1
        ListViewDraw:addChild(cell)
    end

    ListViewDraw:requestRefreshView()

    local cellsAllSize = (cellSize*activity_count + (activity_count -1)*ListViewDraw:getItemsMargin())*scaleBase
    local newPosX = centerPosX - cellsAllSize/2
    ListViewDraw:setPositionX(newPosX)
end


function SmActivityWehcatReward:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/wonderful/recharge_wechat.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    -- debug.print_r(_ED.active_activity[143])
    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge"), nil, 
    {
        terminal_name = "activity_wehcat_recharge", 
        _self = self, 
        isPressedActionEnabled = true
    },
    nil, 0)

     -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge_three_close"), nil, 
    {
        terminal_name = "activity_wehcat_reward_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

    self:onUpdateDraw()
end

function SmActivityWehcatReward:onExit()

end
