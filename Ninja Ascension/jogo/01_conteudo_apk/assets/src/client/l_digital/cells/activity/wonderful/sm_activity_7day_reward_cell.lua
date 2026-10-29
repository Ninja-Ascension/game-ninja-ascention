--------------------------------------------------------------------------------------------------------------
--  说明：7天乐奖励的单个控件
--------------------------------------------------------------------------------------------------------------
SmActivity7dayRewardCell = class("SmActivity7dayRewardCellClass", Window)
SmActivity7dayRewardCell.__size = nil

--创建cell
local sm_activity_7day_reward_cell_terminal = {
    _name = "sm_activity_7day_reward_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivity7dayRewardCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

-- 领取
local sm_activity_7day_reward_cell_check_terminal = {
    _name = "sm_activity_7day_reward_cell_check",
    _init = function (terminal)       
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if _ED.active_activity[137] == nil then
            return
        end

        local cells = params._datas.cells

        local function callback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
                    return
                end

                local cell = response.node
                app.load("client.reward.DrawRareReward")
                local getRewardWnd = DrawRareReward:new()

                getRewardWnd:init(7, nil, cells.reworld_sorting)
                fwin:open(getRewardWnd, fwin._ui)

                local userData = cell.activity.userData
                local userData_day = userData.statusArr[tonumber(cell.activity.dayIndex)]
                local userData_page = userData_day[tonumber(cell.activity.pageIndex)]
                local userData_cell = userData_page[tonumber(cell.activity.drawIndex)]
                userData_cell.st = 1

                cell:updateDraw()
                state_machine.excute("seven_happy_page_change_tab_page", 0, {true}) 

                fwin:addService({
                    callback = function ( params )
                        state_machine.excute("notification_center_update", 0, "push_notification_7happy_day_push")
                        state_machine.excute("notification_center_update", 0, "push_notification_7happy_page_push")
                    end,
                    delay = 0,
                })

            end
        end

        local req = {}
        req.actId = _ED.active_activity[137].activity_id
        req.actType = 137
        req.rType = 0
        req.rDay = cells.activity.dayIndex
        req.rPage = cells.activity.pageIndex
        req.rIndex = cells.activity.drawIndex

        local reqStr = json.encode(req)
        protocol_command.reward_happy_n_day.param_list = reqStr
        NetworkManager:register(protocol_command.reward_happy_n_day.code, nil, nil, nil, cells, callback, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_7day_reward_cell_terminal)
state_machine.add(sm_activity_7day_reward_cell_check_terminal)
state_machine.init()

function SmActivity7dayRewardCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.rewardState = 0
    self.reworld_sorting = {}

    app.load("client.cells.utils.resources_icon_cell")

    local function init_sm_activity_carnival_reward_cell_terminal()

        local sm_activity_7day_reward_cell_set_number_terminal = {
            _name = "sm_activity_7day_reward_cell_set_number",
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
                    cell:runAction(cc.Sequence:create({cc.DelayTime:create((mm_index - 1) * 0.1), cc.CallFunc:create(function ( sender )
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

        state_machine.add(sm_activity_7day_reward_cell_set_number_terminal)
        state_machine.init()
    end 

    init_sm_activity_carnival_reward_cell_terminal()

end

function SmActivity7dayRewardCell:updateDraw()
    local root = self.roots[1]

    -- 当前cell的配置数据，成就id，目标完成最大数，奖励index
    local cellData = self.activity.data

    local dailyTaskMould = dms.element(dms["achieve"], self.activity.id)

    -- 奖励名称
    local Text_103 = ccui.Helper:seekWidgetByName(root, "Text_103")
    Text_103:setString(dms.atos(dailyTaskMould, achieve.title))

    -- 当前cell的用户数据
    local userData = self.activity.userData
    local userData_day = userData.statusArr[tonumber(self.activity.dayIndex)]
    local userData_page = userData_day[tonumber(self.activity.pageIndex)]
    local userData_cell = userData_page[tonumber(self.activity.drawIndex)]
    
    local achieveid = tonumber(self.activity.id)
    local nowpersent = tonumber(userData_cell.cc)
    local maxpersent = 0

    local data = 
    {
        achieve_data = dailyTaskMould,
        achieve_id = achieveid,
        state = tonumber(userData_cell.st), -- 0未, 1 已领取 
        persent = nowpersent,
        maxper = cellData[2],
    }
    
    if data.state == 1 then
        data.state = 1
    else
        if tonumber(data.persent) < tonumber(data.maxper) then
            data.state = 2
        else
            data.state = 0
        end
    end

    -- 进度
    local Text_jindu = ccui.Helper:seekWidgetByName(root, "Text_jindu")

    local strMaxper = data.maxper
    if tonumber(data.maxper) > 10000 then
        strMaxper = math.floor(tonumber(data.maxper) / 1000) .. string_equiprety_name[40]
    else
        strMaxper = data.maxper
    end

    local strNow = data.persent
    if tonumber(data.persent) > 10000 then
        strNow = math.floor(tonumber(data.persent) / 1000) .. string_equiprety_name[40]
    else
        strNow = data.persent
    end

    Text_jindu:setString(strNow .. "/" .. strMaxper)

    -- 奖励
    local activity_Info = _ED.active_activity[137].activity_Info
    local cell_gift = activity_Info[tonumber(cellData[3])]

    local ListView_login_gift_list = ccui.Helper:seekWidgetByName(root, "ListView_1")
    ListView_login_gift_list:removeAllItems()
    local index = 1
    local rewards = zstring.split(cell_gift.activityInfo_reward_select, "|")
    for i, v in pairs(rewards) do
        local reward = zstring.split(v, ",")
        local rewardType = zstring.tonumber(reward[1])
        if rewardType == 1 then
            local rewardIcon = ResourcesIconCell:createCell()
            rewardIcon:init(1, tonumber(reward[3]), -1,nil,nil,true,true,1)
            ListView_login_gift_list:addChild(rewardIcon)

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

    -- 进度已完成，可以领取
    if tonumber(data.state) == 0 then
        self.rewardState = 1
        ccui.Helper:seekWidgetByName(root,"Button_lingqu"):setBright(true)
        ccui.Helper:seekWidgetByName(root,"Button_lingqu"):setTouchEnabled(true)

    -- 进度没完成，不能领取
    elseif tonumber(data.state) == 2 then
        self.rewardState = 0
        ccui.Helper:seekWidgetByName(root,"Button_lingqu"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_lingqu"):setTouchEnabled(false)

    -- 已经领取
    elseif tonumber(data.state) == 1 then
        self.rewardState = 2
        ccui.Helper:seekWidgetByName(root,"Button_lingqu"):setVisible(false)
        ccui.Helper:seekWidgetByName(root,"Image_13"):setVisible(true)
        Text_jindu:setVisible(false)
    end

end

function SmActivity7dayRewardCell:onUpdate(dt)
    
end

function SmActivity7dayRewardCell:onInit()
    local root = cacher.createUIRef("activity/7days/happy_7days_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmActivity7dayRewardCell.__size == nil then
        SmActivity7dayRewardCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lingqu"), nil, 
    {
        terminal_name = "sm_activity_7day_reward_cell_check", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
    }, nil, 1)


	self:updateDraw()
end

function SmActivity7dayRewardCell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function SmActivity7dayRewardCell:clearUIInfo()
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

function SmActivity7dayRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:onInit()
end

function SmActivity7dayRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/7days/happy_7days_list.csb", root)
    root:stopAllActions()

    root:removeFromParent(true)
    self.roots = {}
end

function SmActivity7dayRewardCell:init(params)
    self.activity = params[1]

	self:onInit()

    self:setContentSize(SmActivity7dayRewardCell.__size)
    return self
end

function SmActivity7dayRewardCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/7days/happy_7days_list.csb", self.roots[1])
end