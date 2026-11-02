--------------------------------------------------------------------------------------------------------------
--  说明：开服狂欢奖励的单个控件
--------------------------------------------------------------------------------------------------------------
SmActivityCarnivalRewardCell = class("SmActivityCarnivalRewardCellClass", Window)
SmActivityCarnivalRewardCell.__size = nil

--创建cell
local sm_activity_carnival_reward_cell_terminal = {
    _name = "sm_activity_carnival_reward_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivityCarnivalRewardCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        -- cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_activity_carnival_reward_cell_check_terminal = {
    _name = "sm_activity_carnival_reward_cell_check",
    _init = function (terminal)       
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cells= params._datas.cells
        local function responseDrawWeekRewardCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
                    return
                end

                local cell = response.node
                app.load("client.reward.DrawRareReward")
                local getRewardWnd = DrawRareReward:new()
                getRewardWnd:init(47,nil,cells.reworld_sorting)
                -- getRewardWnd:init(47)
                fwin:open(getRewardWnd, fwin._ui)
                --刷新
                -- state_machine.excute("sm_activity_langing_reword_window_update_draw", 0, "")
                _ED.active_activity[42].seven_days_rewards[tonumber(cell.activity.dayIndex)].achievement_pages[tonumber(cell.activity.pageIndex)]._achievement_rewards[tonumber(cell.activity.drawIndex)].state = 1
                cell:updateDraw()
                state_machine.excute("seven_days_welfare_change_tab_page", 0, {true})
            end
        end
        --第几天,领取类型,领取的ID,领取的索引
        protocol_command.draw_week_reward.param_list = ""..cells.activity.dayIndex.."\r\n".."1".."\r\n"..cells.activity.id.."\r\n".."-1"
        NetworkManager:register(protocol_command.draw_week_reward.code, nil, nil, nil, cells, responseDrawWeekRewardCallback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_carnival_reward_cell_check_terminal)
state_machine.add(sm_activity_carnival_reward_cell_terminal)
state_machine.init()

function SmActivityCarnivalRewardCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.rewardState = 0
    self.reworld_sorting = {}
    app.load("client.cells.utils.resources_icon_cell")
	 -- Initialize sm_activity_carnival_reward_cell state machine.
    local function init_sm_activity_carnival_reward_cell_terminal()
        -- 
        local sm_activity_carnival_reward_cell_set_number_terminal = {
            _name = "sm_activity_carnival_reward_cell_set_number",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params[1]
                local mm_index = tonumber(params[2])
                if params[3] ~= nil and params[3] == true then
                else
                    cell:runAction(cc.Sequence:create({cc.DelayTime:create((mm_index-1)*0.1), cc.CallFunc:create(function ( sender )
                    cell:setVisible(true)
                        sender:runAction(cc.Sequence:create(
                            cc.ScaleTo:create(0.2, 0.9),
                            cc.ScaleTo:create(0.1, 1)
                            ))
                    end)}))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_activity_carnival_reward_cell_set_number_terminal)
        state_machine.init()
    end 
    -- call func sm_activity_carnival_reward_cell create state machine.
    init_sm_activity_carnival_reward_cell_terminal()

end

function SmActivityCarnivalRewardCell:updateDraw()
    local root = self.roots[1]
    local dailyTaskMould = dms.element(dms["achieve"], self.activity.id)
    --奖励名称
    local Text_103 = ccui.Helper:seekWidgetByName(root,"Text_103")
    Text_103:setString(dms.atos(dailyTaskMould, achieve.title))


    --进度
    local Text_jindu = ccui.Helper:seekWidgetByName(root,"Text_jindu")
    -- local needCompleteCount = dms.atoi(dailyTaskMould, achieve.param2)
    
    local achieveid = tonumber(self.activity.id)
    local nowpersent = tonumber(_ED.active_activity[42].seven_days_rewards[tonumber(self.activity.dayIndex)].achievement_pages[tonumber(self.activity.pageIndex)]._achievement_rewards[tonumber(self.activity.drawIndex)].complete_count)
    local maxpersent = 0
    local data = 
    {
        achieve_data = dailyTaskMould,
        achieve_id = achieveid,
        state = tonumber(_ED.active_activity[42].seven_days_rewards[tonumber(self.activity.dayIndex)].achievement_pages[tonumber(self.activity.pageIndex)]._achievement_rewards[tonumber(self.activity.drawIndex)].state),--0未, 1 已领取 
        persent = nowpersent,
        maxper = 0 ,
    }
    
    data.progress = 0

    if data.state == 1 then
        data.state = 1
    else
        local param2 = dms.atoi(dailyTaskMould,achieve.param2) 
        local param3 = dms.atoi(dailyTaskMould,achieve.param3) 
        
        if param3 ~= -1 then
            maxpersent = param3
        else 
            maxpersent = param2
        end
        data.maxper = maxpersent
        data.progress = nowpersent / maxpersent
        
        if self.activity.dayIndex == 4 and self.activity.pageIndex == 2 then
            if nowpersent > 0 and nowpersent <= maxpersent then
                data.state = 0
            else
                data.state = 2
            end
        else
            if nowpersent >= maxpersent then
                data.state = 0
            else
                data.state = 2
            end
        end
    end
    Text_jindu:setString(data.persent.."/"..data.maxper)

    --奖励
    local ListView_login_gift_list = ccui.Helper:seekWidgetByName(root,"ListView_1")
    ListView_login_gift_list:removeAllItems()
    local index = 1
    local dailyTaskTrace = dms.atoi(dailyTaskMould, achieve.track_address)
    local rewards = zstring.split(dms.atos(dailyTaskMould, achieve.reward_value), "|")
    for i, v in pairs(rewards) do
        local reward = zstring.split(v, ",")
        local rewardType = zstring.tonumber(reward[1])
        if rewardType == 1 then
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(1, tonumber(reward[3]), -1,nil,nil,true,true,1)
            ListView_login_gift_list:addChild(rewardIcon)
            -- rewardIcon:hideCount(false)
            local rewardinfo = {}
            rewardinfo.type = 1
            rewardinfo.id = -1
            rewardinfo.number = tonumber(reward[3])
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        elseif rewardType == 2 then
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(2, tonumber(reward[3]), -1,nil,nil,true,true,1)
            ListView_login_gift_list:addChild(rewardIcon)
            -- rewardIcon:hideCount(false)
            local rewardinfo = {}
            rewardinfo.type = 2
            rewardinfo.id = -1
            rewardinfo.number = tonumber(reward[3])
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
         elseif rewardType == 3 then
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(3, tonumber(reward[3]), -1,nil,nil,true,true,1)
            ListView_login_gift_list:addChild(rewardIcon)
            -- rewardIcon:hideCount(false)
            local rewardinfo = {}
            rewardinfo.type = 3
            rewardinfo.id = -1
            rewardinfo.number = tonumber(reward[3])
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        elseif rewardType == 12 then
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(12, tonumber(reward[3]), -1,nil,nil,true,true,1)
            ListView_login_gift_list:addChild(rewardIcon)
            -- rewardIcon:hideCount(false)
            local rewardinfo = {}
            rewardinfo.type = 12
            rewardinfo.id = -1
            rewardinfo.number = tonumber(reward[3])
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        elseif rewardType == 6 or reward[1] == "5" then
            local reawrdID = tonumber(reward[2])
            local rewardNum = tonumber(reward[3])
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(6, rewardNum, reawrdID,nil,nil,true,true,1)  
            ListView_login_gift_list:addChild(rewardIcon)
            local rewardinfo = {}
            rewardinfo.type = 6
            rewardinfo.id = reawrdID
            rewardinfo.number = rewardNum
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        elseif rewardType == 7 then
            local reawrdID = tonumber(reward[2])
            local rewardNum = tonumber(reward[3])
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(7, rewardNum, reawrdID,nil,nil,true,true,1,{equipQuality = 3})
            ListView_login_gift_list:addChild(rewardIcon)
            local rewardinfo = {}
            rewardinfo.type = 7
            rewardinfo.id = reawrdID
            rewardinfo.number = rewardNum
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        else
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1)
            ListView_login_gift_list:addChild(rewardIcon)
            local rewardinfo = {}
            rewardinfo.type = rewardType
            rewardinfo.id = tonumber(reward[2])
            rewardinfo.number = tonumber(reward[3])
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        end
    end

    ListView_login_gift_list:requestRefreshView()
	ccui.Helper:seekWidgetByName(root,"Button_lingqu"):setVisible(true)
    ccui.Helper:seekWidgetByName(root,"Image_13"):setVisible(false)
    Text_jindu:setVisible(true)
    --进度的判断
    if tonumber(data.state) == 0 then
        self.rewardState = 1
        ccui.Helper:seekWidgetByName(root,"Button_lingqu"):setBright(true)
        ccui.Helper:seekWidgetByName(root,"Button_lingqu"):setTouchEnabled(true)
    elseif tonumber(data.state) == 2 then
        self.rewardState = 0
        ccui.Helper:seekWidgetByName(root,"Button_lingqu"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_lingqu"):setTouchEnabled(false)
    elseif tonumber(data.state) == 1 then
        self.rewardState = 2
        ccui.Helper:seekWidgetByName(root,"Button_lingqu"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Image_13"):setVisible(true)
        Text_jindu:setVisible(false)
    end
end

function SmActivityCarnivalRewardCell:onUpdate(dt)
    
end

function SmActivityCarnivalRewardCell:onInit()
    local root = cacher.createUIRef("activity/7days/week_Activities_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    if SmActivityCarnivalRewardCell.__size == nil then
        SmActivityCarnivalRewardCell.__size = root:getContentSize()
    end
    -- if tonumber(self.m_type) == 0 then
    -- 	--
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lingqu"), nil, 
        {
            terminal_name = "sm_activity_carnival_reward_cell_check", 
            terminal_state = 0, 
            touch_black = true,
    		cells = self,
        }, nil, 1)
    -- end

	self:updateDraw()
end

function SmActivityCarnivalRewardCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function SmActivityCarnivalRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    local Text_103 = ccui.Helper:seekWidgetByName(root,"Text_103")
    local Text_jindu = ccui.Helper:seekWidgetByName(root,"Text_jindu")
    if ListView_1 ~= nil then
        ListView_1:removeAllItems()
        Text_103:setString("")
        Text_jindu:setString("")
    end
end

function SmActivityCarnivalRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    -- self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmActivityCarnivalRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/7days/week_Activities_list.csb", root)
    root:stopAllActions()
    -- self:unregisterOnNoteUpdate(self)
    root:removeFromParent(true)
    self.roots = {}
end

function SmActivityCarnivalRewardCell:init(params)
    self.activity = params[1]
    -- if tonumber(self.activity.drawIndex) <= 5 then
    	self:onInit()
    -- end
    self:setContentSize(SmActivityCarnivalRewardCell.__size)
    return self
end

function SmActivityCarnivalRewardCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/7days/week_Activities_list.csb", self.roots[1])
end