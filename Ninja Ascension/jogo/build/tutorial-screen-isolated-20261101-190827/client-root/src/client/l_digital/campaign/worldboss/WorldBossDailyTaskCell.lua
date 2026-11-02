--------------------------------------------------------------------------------------------------------------
--  说明：成就单个控件
--------------------------------------------------------------------------------------------------------------
WorldBossDailyTaskCell = class("WorldBossDailyTaskCellClass", Window)
WorldBossDailyTaskCell.__size = nil

--创建cell
local world_boss_daily_task_cell_terminal = {
    _name = "world_boss_daily_task_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = WorldBossDailyTaskCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(world_boss_daily_task_cell_terminal)
state_machine.init()

function WorldBossDailyTaskCell:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.shop.recharge.RechargeDialog")
    app.load("client.reward.DrawRareReward")
    app.load("client.cells.prop.prop_money_icon")

     -- Initialize world_boss_daily_task_cell_cell state machine.
    local function init_world_boss_daily_task_cell_cell_terminal()
        
        local world_boss_daily_task_cell_cell_check_terminal = {
            _name = "world_boss_daily_task_cell_cell_check",
            _init = function (terminal)
                app.load("client.l_digital.campaign.worldboss.WorldBossDailyTask")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                --控制按钮连点
                local btn = params._datas.terminal_button
                if btn then
                    btn:setTouchEnabled(false)
                    btn:runAction(cc.Sequence:create({cc.DelayTime:create(1), cc.CallFunc:create(function ( sender )
                        btn:setTouchEnabled(true)
                    end)})
                    )
                end
                local function responseDrawAchieveRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(7, nil, cell.reworld_sorting)
                            fwin:open(getRewardWnd, fwin._ui)
                            response.node:updateDraw()
                            state_machine.excute("world_boss_daily_task_update", 0, "")
                            -- if fwin:find("ExplorationWindowClass") ~= nil then
                            --     app.load("client.l_digital.campaign.worldboss.WorldBossWindow")
                            --     --积分红点
                            --     state_machine.excute("world_boss_open_daily_task_redot", 0, "")
                            -- end
                        end
                    end
                end
                protocol_command.world_boss_draw_task_reward.param_list = cell.id
                NetworkManager:register(protocol_command.world_boss_draw_task_reward.code, nil, nil, nil, cell, responseDrawAchieveRewardCallback, false, nil)
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(world_boss_daily_task_cell_cell_check_terminal)
        state_machine.init()
    end 
    -- call func world_boss_daily_task_cell_cell create state machine.
    init_world_boss_daily_task_cell_cell_terminal()

end

function WorldBossDailyTaskCell:updateDraw()
    local root = self.roots[1]
    self.reworld_sorting = {}
    local Text_world_boss_t = ccui.Helper:seekWidgetByName(root, "Text_world_boss_t")
    local ListView_boss_challenge_reward = ccui.Helper:seekWidgetByName(root, "ListView_boss_challenge_reward")
    local Image_boss_challenge_rec = ccui.Helper:seekWidgetByName(root, "Image_boss_challenge_rec")
    local Image_boss_challenge_no = ccui.Helper:seekWidgetByName(root, "Image_boss_challenge_no")
    local Button_boss_challenge_rec = ccui.Helper:seekWidgetByName(root, "Button_boss_challenge_rec")

    
    local rewards = zstring.splits(dms.string(dms["world_boss_daily_reward"], self.id, 4), "|", ",")

    local index = 1
    ListView_boss_challenge_reward:removeAllItems()
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
        local rewardinfo = {}
        rewardinfo.type = rewardType
        rewardinfo.id = reward[2]
        rewardinfo.number = tonumber(reward[3])
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
        ListView_boss_challenge_reward:addChild(cell)
    end

    local condition = dms.int(dms["world_boss_daily_reward"], self.id, 2)
    local needcount = dms.int(dms["world_boss_daily_reward"], self.id, 3)
    local curCount = _ED.world_boss_my_info.allTask.taskInfo[condition .. ""]
    Text_world_boss_t:setString(string.format(tipStringInfo_world_boss[condition+3], needcount))

    if table.containValue(_ED.world_boss_my_info.allTask.drawTaskId, self.id) then
        Image_boss_challenge_rec:setVisible(true)
        Image_boss_challenge_no:setVisible(false)
        Button_boss_challenge_rec:setVisible(false)
    else
        if tonumber(curCount) >= needcount then
            Image_boss_challenge_rec:setVisible(false)
            Image_boss_challenge_no:setVisible(false)
            Button_boss_challenge_rec:setVisible(true)
        else
            Image_boss_challenge_rec:setVisible(false)
            Image_boss_challenge_no:setVisible(true)
            Button_boss_challenge_rec:setVisible(false)
        end
    end
end

function WorldBossDailyTaskCell:onInit()
    local root = cacher.createUIRef("campaign/world_boss/world_boss_reward_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if WorldBossDailyTaskCell.__size == nil then
        WorldBossDailyTaskCell.__size = root:getContentSize()
    end

    -- 领取奖励的事件响应
    local Button_1 = ccui.Helper:seekWidgetByName(root, "Button_boss_challenge_rec")
    fwin:addTouchEventListener(Button_1, nil, 
    {
        terminal_name = "world_boss_daily_task_cell_cell_check",      
        terminal_state = 0, 
        cell = self,
        terminal_button = Button_1,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:updateDraw()
end

function WorldBossDailyTaskCell:onEnterTransitionFinish()

end

function WorldBossDailyTaskCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_world_boss_t = ccui.Helper:seekWidgetByName(root, "Text_world_boss_t")
    local ListView_boss_challenge_reward = ccui.Helper:seekWidgetByName(root, "ListView_boss_challenge_reward")
    local Image_boss_challenge_no = ccui.Helper:seekWidgetByName(root, "Image_boss_challenge_no")
    local Image_boss_challenge_rec = ccui.Helper:seekWidgetByName(root, "Image_boss_challenge_rec")
    local Button_boss_challenge_rec = ccui.Helper:seekWidgetByName(root, "Button_boss_challenge_rec")
    if Text_world_boss_t ~= nil then
        Text_world_boss_t:setString("")
    end
    if ListView_boss_challenge_reward ~= nil then
        ListView_boss_challenge_reward:removeAllItems()
    end
    if Image_boss_challenge_no ~= nil then
        Image_boss_challenge_no:setVisible(true)
        Image_boss_challenge_rec:setVisible(false)
        Button_boss_challenge_rec:setVisible(false)
    end
end

function WorldBossDailyTaskCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function WorldBossDailyTaskCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef("campaign/world_boss/world_boss_reward_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function WorldBossDailyTaskCell:init(params)
    self.id = params[1]
    local index = params[2]
    if index and tonumber(index) < 5 then
        self:onInit()
    end
    if WorldBossDailyTaskCell.__size then
        self:setContentSize(WorldBossDailyTaskCell.__size)
    end
    return self
end

function WorldBossDailyTaskCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("campaign/world_boss/world_boss_reward_cell.csb", self.roots[1])
end