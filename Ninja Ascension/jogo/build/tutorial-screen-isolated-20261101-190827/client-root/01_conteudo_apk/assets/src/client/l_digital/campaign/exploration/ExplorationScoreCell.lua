--------------------------------------------------------------------------------------------------------------
--  说明：成就单个控件
--------------------------------------------------------------------------------------------------------------
ExplorationScoreCell = class("ExplorationScoreCellClass", Window)
ExplorationScoreCell.__size = nil

--创建cell
local exploration_score_cell_terminal = {
    _name = "exploration_score_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = ExplorationScoreCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(exploration_score_cell_terminal)
state_machine.init()

function ExplorationScoreCell:ctor()
	self.super:ctor()
	self.roots = {}

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.shop.recharge.RechargeDialog")
    app.load("client.reward.DrawRareReward")
    app.load("client.cells.prop.prop_money_icon")

	 -- Initialize exploration_score_cell_cell state machine.
    local function init_exploration_score_cell_cell_terminal()
        
        local exploration_score_cell_cell_check_terminal = {
            _name = "exploration_score_cell_cell_check",
            _init = function (terminal)
                app.load("client.l_digital.campaign.exploration.ExplorationScore")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local needScore = dms.int(dms["role_explore_daily_score"], cell.id, 2)
                if cell._type == 1 then
                    needScore = dms.int(dms["role_explore_gather_score"], cell.id, 2)
                end
                local curScore = cell._type == 0 and _ED.pokemonExplore.scoreInfo.todayScore or _ED.pokemonExplore.scoreInfo.totalScore
                if tonumber(curScore) < needScore then
                    return
                end
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
                            state_machine.excute("exploration_score_update", 0, cell._type)
                            if fwin:find("ExplorationWindowClass") ~= nil then
                                app.load("client.l_digital.campaign.exploration.ExplorationWindow")
                                --积分红点
                                state_machine.excute("exploration_score_redot", 0, "")
                            end
                        end
                    end
                end
                local data = {}
                data.type = cell._type
                data.rId = cell.id
                local req = json.encode(data)
                protocol_command.pokemon_explore_score_reward.param_list = req
                NetworkManager:register(protocol_command.pokemon_explore_score_reward.code, nil, nil, nil, cell, responseDrawAchieveRewardCallback, false, nil)
            end,
            _terminal = nil,
            _terminals = nil
        }

        local exploration_score_cell_cell_update_terminal = {
            _name = "exploration_score_cell_cell_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells = params[1]
                cells:unload()
                cells:reload()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(exploration_score_cell_cell_check_terminal)
        state_machine.add(exploration_score_cell_cell_update_terminal)
        state_machine.init()
    end 
    -- call func exploration_score_cell_cell create state machine.
    init_exploration_score_cell_cell_terminal()

end

function ExplorationScoreCell:updateDraw()
    local root = self.roots[1]
    self.reworld_sorting = {}
    local Text_jifen = ccui.Helper:seekWidgetByName(root, "Text_jifen")
    local ListView_reward_icon = ccui.Helper:seekWidgetByName(root, "ListView_reward_icon")
    local Image_no = ccui.Helper:seekWidgetByName(root, "Image_no")
    local Image_over = ccui.Helper:seekWidgetByName(root, "Image_over")
    local Panel_receive = ccui.Helper:seekWidgetByName(root, "Panel_receive")
    local Panel_klq = ccui.Helper:seekWidgetByName(root, "Panel_klq")
    Panel_klq:removeAllChildren(true) 

    local needScore = dms.int(dms["role_explore_daily_score"], self.id, 2)
    local rewards = nil
    if self._type == 1 then
        needScore = dms.int(dms["role_explore_gather_score"], self.id, 2)
        rewards = zstring.splits(dms.string(dms["role_explore_gather_score"], self.id, 3), "|", ",")
    else
        rewards = zstring.splits(dms.string(dms["role_explore_daily_score"], self.id, 3), "|", ",")
    end
    Text_jifen:setString(needScore)

    local index = 1
    ListView_reward_icon:removeAllItems()
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
        ListView_reward_icon:addChild(cell)
    end

    local scoreCompelet = self._type == 0 and _ED.pokemonExplore.scoreInfo.todayScoreR or _ED.pokemonExplore.scoreInfo.totalScoreR
    local curScore = self._type == 0 and _ED.pokemonExplore.scoreInfo.todayScore or _ED.pokemonExplore.scoreInfo.totalScore
    

    if (table.containValue(scoreCompelet, "" .. self.id) or table.containValue(scoreCompelet, self.id)) then -- 已经领取
        Image_no:setVisible(false)
        Image_over:setVisible(true)
        Panel_receive:setVisible(false)
    else
        if tonumber(curScore) >= needScore then --已完成
            Image_no:setVisible(false)
            Panel_receive:setVisible(true)
            local jsonFile = "sprite/spirte_kelingqu.json"
            local atlasFile = "sprite/spirte_kelingqu.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            Panel_klq:addChild(animation)
        else--未完成
            Image_no:setVisible(true)
            Panel_receive:setVisible(false)
        end

        Image_over:setVisible(false)
    end

    -- local startAnimation = panel_list:getChildByName("ArmatureNode_2")
    -- local ArmatureNode_speed = panel_list:getChildByName("ArmatureNode_speed")
    
    -- local animation_index = self.params.speed >= self.params.condition and 0 or 1

    -- draw.initArmature(ArmatureNode_speed, nil, -1, 0, 1)
    -- csb.animationChangeToAction(ArmatureNode_speed, animation_index, animation_index, false)

    -- draw.initArmature(startAnimation, nil, -1, 0, 1)
    -- csb.animationChangeToAction(startAnimation, animation_index, animation_index, false)

    -- ArmatureNode_speed:setVisible(self.params.speed ~= -1)

    -- local img_ywc = ccui.Helper:seekWidgetByName(root, "Image_ywc")
    -- img_ywc:setVisible(self.params.speed == -1)
end

function ExplorationScoreCell:onInit()
    local root = cacher.createUIRef("campaign/exploration/exploration_integral_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if ExplorationScoreCell.__size == nil then
        ExplorationScoreCell.__size = ccui.Helper:seekWidgetByName(root, "Panel_2"):getContentSize()
    end

    -- 领取奖励的事件响应
    local Button_1 = ccui.Helper:seekWidgetByName(root, "Panel_receive")
    fwin:addTouchEventListener(Button_1, nil, 
    {
        terminal_name = "exploration_score_cell_cell_check",      
        terminal_state = 0, 
        cell = self,
        terminal_button = Button_1,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:updateDraw()
end

function ExplorationScoreCell:onEnterTransitionFinish()

end

function ExplorationScoreCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_jifen = ccui.Helper:seekWidgetByName(root, "Text_jifen")
    local ListView_reward_icon = ccui.Helper:seekWidgetByName(root, "ListView_reward_icon")
    local Image_no = ccui.Helper:seekWidgetByName(root, "Image_no")
    local Image_over = ccui.Helper:seekWidgetByName(root, "Image_over")
    local Panel_receive = ccui.Helper:seekWidgetByName(root, "Panel_receive")
    local Panel_klq = ccui.Helper:seekWidgetByName(root, "Panel_klq")
    if Text_jifen ~= nil then
        Text_jifen:setString("")
    end
    if ListView_reward_icon ~= nil then
        ListView_reward_icon:removeAllItems()
    end
    if Image_no ~= nil then
        Image_no:setVisible(true)
        Image_over:setVisible(false)
        Panel_receive:setVisible(false)
        Panel_klq:removeAllChildren(true)
    end
end

function ExplorationScoreCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ExplorationScoreCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("campaign/exploration/exploration_integral_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function ExplorationScoreCell:init(params)
    self.id = params.id
    self._type = params._type
    local index = params._index
    if index and index < 4 then
        self:onInit()
    end
    if ExplorationScoreCell.__size then
        self:setContentSize(ExplorationScoreCell.__size)
    end
    return self
end

function ExplorationScoreCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("campaign/exploration/exploration_integral_cell.csb", self.roots[1])
end