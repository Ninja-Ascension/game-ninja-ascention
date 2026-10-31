-----------------------------
-- 试炼积分奖励界面
-----------------------------
SmTrialTowerReward = class("SmTrialTowerRewardClass", Window)

--打开界面
local sm_trial_tower_reward_open_terminal = {
	_name = "sm_trial_tower_reward_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmTrialTowerRewardClass") == nil then
			fwin:open(SmTrialTowerReward:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_trial_tower_reward_close_terminal = {
	_name = "sm_trial_tower_reward_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmTrialTowerRewardClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_trial_tower_reward_open_terminal)
state_machine.add(sm_trial_tower_reward_close_terminal)
state_machine.init()

function SmTrialTowerReward:ctor()
	self.super:ctor()
	self.roots = {}

    self.per = 0
    self._list_view_posY = 0

	app.load("client.l_digital.cells.campaign.sm_trial_tower_reward_list_cell")
    app.load("client.reward.DrawRareReward")

    local function init_sm_trial_tower_reward_terminal()
        --
        local sm_trial_tower_reward_all_get_update_terminal = {
            _name = "sm_trial_tower_reward_all_get_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:allGetUpdate()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_trial_tower_reward_show_all_info_terminal = {
            _name = "sm_trial_tower_reward_show_all_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:showAllInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 滑动listView
        local arena_achieve_reward_slip_listView_terminal = {
            _name = "arena_achieve_reward_slip_listView",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currType = params._datas._type
                if currType == 1 then
                    instance.per = instance.per - instance.page_per
                elseif currType == 2 then
                    instance.per = instance.per + instance.page_per  
                end
                instance.per = math.min(instance.per , 100)
                instance.per = math.max(instance.per , 0)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
                    instance.currentListView:jumpToPercentVertical(instance.per)
                else
                    instance.currentListView:jumpToPercentHorizontal(instance.per)
                end
                instance.currentListView:refreshView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_trial_tower_reward_one_key_get_reward_terminal = {
            _name = "sm_trial_tower_reward_one_key_get_reward",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local totalRewards = params._datas.totalRewards
                if #totalRewards <= 0 then
                    return true
                end

                local function callback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots[1] ~= nil then
                            
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(37, nil, totalRewards)
                            fwin:open(getRewardWnd, fwin._windows)

                            response.node:updateDraw()

                            state_machine.unlock("sm_trial_tower_reward_one_key_get_reward")
                        else
                            state_machine.unlock("sm_trial_tower_reward_one_key_get_reward")
                        end
                    else
                        state_machine.unlock("sm_trial_tower_reward_one_key_get_reward")
                    end
                end

                state_machine.lock("sm_trial_tower_reward_one_key_get_reward")
                protocol_command.three_kingdoms_draw_score_reward.param_list = ""..-1
                NetworkManager:register(protocol_command.three_kingdoms_draw_score_reward.code, nil, nil, nil, instance, callback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新一键领取按钮
        local sm_trial_tower_reward_refresh_one_key_button_terminal = {
            _name = "sm_trial_tower_reward_refresh_one_key_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local totalRewards = self:getOneKeyRewardList()
                if self.Button_onKeyReward ~= nil then
                    self.Button_onKeyReward:setVisible(#totalRewards > 0)
                end                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_trial_tower_reward_all_get_update_terminal)
        state_machine.add(sm_trial_tower_reward_show_all_info_terminal)
        state_machine.add(arena_achieve_reward_slip_listView_terminal)
        state_machine.add(sm_trial_tower_reward_one_key_get_reward_terminal)
        state_machine.add(sm_trial_tower_reward_refresh_one_key_button_terminal)
        state_machine.init()
    end
    init_sm_trial_tower_reward_terminal()
end

function SmTrialTowerReward:allGetUpdate( ... )
    local root = self.roots[1]
    --总收益
    local ListView_profit = ccui.Helper:seekWidgetByName(root,"ListView_profit")
    ListView_profit:removeAllItems()
    local reworldInfos = {}
    for i, v in pairs(_ED.user_try_highest_score_reward_state) do
        local reworldInfo = dms.string(dms["three_kingdoms_score_reward_param"], v, three_kingdoms_score_reward_param.rewards)
        local rewards = zstring.splits(reworldInfo, "|", ",")
        for r, m in pairs(rewards) do
            local key = m[1] .. m[2]
            if nil == reworldInfos[key] then
                reworldInfos[key] = m
            else
                local nCount = tonumber(reworldInfos[key][3]) + tonumber(m[3])
                reworldInfos[key][3] = "" .. nCount
            end
        end
    end

    for i, v in pairs(reworldInfos) do
        -- local cell = ResourcesIconCell:createCell()
        -- cell:init(v[1], v[3], v[2],nil,nil,nil,true,true)
        -- ListView_profit:addChild(cell)
        local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{v[1],v[2],v[3]},false,true,false,true})
        ListView_profit:addChild(cell)
    end
end

function SmTrialTowerReward:showAllInfo( ... )
    local root = self.roots[1]
    local Panel_chakan = ccui.Helper:seekWidgetByName(root,"Panel_chakan")
    Panel_chakan:setVisible(not Panel_chakan:isVisible())
    local Text_jifen_gs = ccui.Helper:seekWidgetByName(root,"Text_jifen_gs")
    local percent = dms.float(dms["play_config"], 54, play_config.param)
    local total = math.floor(tonumber(_ED.user_try_total_highest_integral) * percent) + tonumber(_ED.user_try_to_score_points)
    Text_jifen_gs:setString(total.."="..math.floor((tonumber(_ED.user_try_total_highest_integral) * percent)).."+".._ED.user_try_to_score_points)
end

function SmTrialTowerReward:updateDraw()
	local root = self.roots[1]
	local ListView_challenger = ccui.Helper:seekWidgetByName(root,"ListView_challenger")
	ListView_challenger:removeAllItems()
    self.cacheListView = ListView_challenger
    self.currentListView = self.cacheListView
    self.currentInnerContainer = self.cacheListView:getInnerContainer()
    self.currentInnerContainerPosX = self.currentInnerContainer:getPositionX()
    self.currentInnerContainerPosY = self.cacheListView:getInnerContainer():getPositionY()

    local rewardInfo = dms["three_kingdoms_score_reward_param"]

    local rewardIndex = 0
    local width = 0
    local height = 0

    local sortList = self:getSortRewardList()
    for i, v in ipairs(sortList) do
        local index = v
        local cell = state_machine.excute("sm_trial_tower_reward_list_cell", 0, {index, i})
        if width == 0 then
            width = cell:getContentSize().width
        elseif height == 0 then
            height = cell:getContentSize().height
        end
        self.cacheListView:addChild(cell)
        if rewardIndex == 0 and _ED.user_try_highest_score_reward_state[""..index] == nil then
            rewardIndex = i
        end
    end
    self.cacheListView:requestRefreshView()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
        if rewardIndex == #rewardInfo or rewardIndex == (#rewardInfo - 1) then
            rewardIndex = #rewardInfo - 2
        end
    end
    self.per = rewardIndex * 100 / (#rewardInfo)
    self.page_per = 2 * 100 / (#rewardInfo)

    --历史最大积分
    local Text_my_jifen = ccui.Helper:seekWidgetByName(root,"Text_my_jifen")
    local percent = dms.float(dms["play_config"], 54, play_config.param)
    local total = math.floor(tonumber(_ED.user_try_total_highest_integral) * percent) + tonumber(_ED.user_try_to_score_points)
    Text_my_jifen:setString("" .. total)

    self:allGetUpdate()

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
        self:runAction(cc.Sequence:create({cc.DelayTime:create(0.01), cc.CallFunc:create(function ( sender )
            listviewPositioningMoves(self.cacheListView, rewardIndex)
            self.cacheListView:requestRefreshView()
        end)}))
    else
        self:runAction(cc.Sequence:create({cc.DelayTime:create(0.05), cc.CallFunc:create(function ( sender )
            if rewardIndex == 1 then
                sender.currentInnerContainer:setPositionX(-1)
            else
                sender.currentInnerContainer:setPositionX(-width * (rewardIndex - 1))
            end
            sender.cacheListView:requestRefreshView()
        end)}))
    end

    local totalRewards = self:getOneKeyRewardList()
    if self.Button_onKeyReward ~= nil then
        self.Button_onKeyReward:setVisible(#totalRewards > 0)
    end
end

function SmTrialTowerReward:onUpdate(dt)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
        if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
            local size = self.currentListView:getContentSize()
            local posY = self.currentInnerContainer:getPositionY()
            
            if self._list_view_posY == 0 then
                self._list_view_posY = posY
            end

            if self.right_button ~= nil then
                if self._list_view_posY < -30 then 
                    self.right_button:setVisible(true)
                else
                    self.right_button:setVisible(false)
                end
                if self._list_view_posY >= size.height - self.currentListView:getInnerContainer():getContentSize().height + 30 then
                    self.left_button:setVisible(true)
                else
                    self.left_button:setVisible(false)
                end
            end
            self._list_view_posY = posY
            
            if self.currentInnerContainerPosY == posY then
                return
            end
            self.currentInnerContainerPosY = posY
            local items = self.currentListView:getItems()
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

         
    else
        if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
            local size = self.currentListView:getContentSize()
            local posX = self.currentInnerContainer:getPositionX()
            if self.currentInnerContainerPosX == posX then
                return
            end
            local items = self.currentListView:getItems()
            if items[1] == nil then
                return
            end
            self.currentInnerContainerPosX = posX
            local itemSize = items[1]:getContentSize()
            for i, v in pairs(items) do
                local tempX = v:getPositionX() + posX
                if tempX + itemSize.width/2 < 0 or tempX > size.width + itemSize.width / 2 then
                    v:unload()
                else
                    v:reload()
                end
            end
        end
    end
end

function SmTrialTowerReward:init(params)
	self:onInit()
    return self
end

function SmTrialTowerReward:onInit()
    local csbItem = csb.createNode("campaign/TrialTower/sm_trial_tower_reward.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "sm_trial_tower_reward_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_chakan"), nil, 
    {
        terminal_name = "sm_trial_tower_reward_show_all_info", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
        
    -- 一键领取
    local Button_onKeyReward = ccui.Helper:seekWidgetByName(root,"Button_onKeyReward")
    local totalRewards = self:getOneKeyRewardList()

    self.Button_onKeyReward = Button_onKeyReward

    if Button_onKeyReward ~= nil then
        Button_onKeyReward:setVisible(#totalRewards > 0)
        fwin:addTouchEventListener(Button_onKeyReward, nil, 
        {
            terminal_name = "sm_trial_tower_reward_one_key_get_reward", 
            terminal_state = 0, 
            touch_black = true,
            totalRewards = totalRewards,
        }, nil, 0)
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 then
        self.left_button = ccui.Helper:seekWidgetByName(root, "Button_arrow_l")
        self.right_button = ccui.Helper:seekWidgetByName(root, "Button_arrow_r")
        --左滑
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_l"),nil, 
        {
            terminal_name = "arena_achieve_reward_slip_listView",           
            terminal_state = 0,
            _type = 1, 
            isPressedActionEnabled = true
        }, 
        nil, 0)

        --右滑
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_r"),nil, 
        {
            terminal_name = "arena_achieve_reward_slip_listView",           
            terminal_state = 0, 
            _type = 2,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end
    
	self:updateDraw()
end

function SmTrialTowerReward:getSortRewardList()
    local sortList = {}

    local canGet = {}
    local doingGet = {}
    local alreadyGet = {}

    local rewardInfo = dms["three_kingdoms_score_reward_param"]
    for index = 1, #rewardInfo do
        if _ED.user_try_highest_score_reward_state[""..index] == nil then
            local integral = dms.int(dms["three_kingdoms_score_reward_param"], index, three_kingdoms_score_reward_param.need_integral)
            if integral <= _ED.user_try_highest_integral then
                table.insert(canGet, index)
            else
                table.insert(doingGet, index)
            end
        else
            table.insert(alreadyGet, index)
        end
    end

    -- 可领取＞进行中＞已领取
    -- index排序
    table.sort(canGet, function(a, b)
        return a < b
    end)

    table.sort(doingGet, function(a, b)
        return a < b
    end)

    table.sort(alreadyGet, function(a, b)
        return a < b
    end)

    for _, v in ipairs(canGet) do
        table.insert(sortList, v)
    end

    for _, v in ipairs(doingGet) do
        table.insert(sortList, v)
    end

    for _, v in ipairs(alreadyGet) do
        table.insert(sortList, v)
    end

    return sortList
end

function SmTrialTowerReward:getOneKeyRewardList()
    local totalRewards = {}
    local rewardInfo = dms["three_kingdoms_score_reward_param"]
    for index = 1, #rewardInfo do
        if _ED.user_try_highest_score_reward_state[""..index] == nil then
            local integral = dms.int(dms["three_kingdoms_score_reward_param"], index, three_kingdoms_score_reward_param.need_integral)
            if integral <= _ED.user_try_highest_integral then
                local reworlds = dms.string(dms["three_kingdoms_score_reward_param"], index, three_kingdoms_score_reward_param.rewards)
                local reward = zstring.split(reworlds, "|")

                for i = 1, #reward do
                    local data = zstring.split(reward[i], ",") 

                    local rewardData = {}
                    rewardData.type = data[1]
                    rewardData.id = data[2]
                    rewardData.number = data[3]

                    table.insert(totalRewards, rewardData)
                end
            end
        end
    end

    return totalRewards
end

function SmTrialTowerReward:onEnterTransitionFinish()
    
end


function SmTrialTowerReward:onExit()
    state_machine.remove("sm_trial_tower_reward_all_get_update")
    state_machine.remove("sm_trial_tower_reward_show_all_info")
    state_machine.remove("arena_achieve_reward_slip_listView")
    state_machine.remove("sm_trial_tower_reward_one_key_get_reward")
    state_machine.remove("sm_trial_tower_reward_refresh_one_key_button")
end

