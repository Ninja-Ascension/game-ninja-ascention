-- ----------------------------------------------------------------------------------------------------
-- 说明：探索积分
-------------------------------------------------------------------------------------------------------
ActivityLimitRank = class("ActivityLimitRankClass", Window)

local activity_limit_rank_open_terminal = {
    _name = "activity_limit_rank_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local function callBack(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            	if fwin:find("ActivityLimitRankClass") == nil then
		            fwin:open(ActivityLimitRank:new():init(params), fwin._view)
		        end
            end
        end
        protocol_command.get_activity_reward.param_list = "".._ED.active_activity[143].activity_id.."\r\n".. -1 .."\r\n".."1"
        NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, _self, callBack, false, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local activity_limit_rank_close_terminal = {
    _name = "activity_limit_rank_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("ActivityLimitRankClass") then
            fwin:close(fwin:find("ActivityLimitRankClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_limit_rank_open_terminal)
state_machine.add(activity_limit_rank_close_terminal)
state_machine.init()

function ActivityLimitRank:ctor()
    self.super:ctor()
    self.roots = {}
    app.load("client.activity.ActivityLimitRankStarCell")
    app.load("client.activity.ActivityLimitRankLevelCell")

    -- 根据类型确定下标索引 type 1限时闯关 2限时等级 3限时战力
    self.typeCastIndexEnum = {
        [1] = 1,
        [2] = 2,
        [3] = 1,
    }

    local function init_activity_limit_rank_terminal()
        local activity_limit_rank_type_terminal = {
            _name = "activity_limit_rank_type",
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

        local activity_limit_rank_update_terminal = {
            _name = "activity_limit_rank_update",
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

        state_machine.add(activity_limit_rank_type_terminal)
        state_machine.add(activity_limit_rank_update_terminal)
        state_machine.init()
    end
    
    init_activity_limit_rank_terminal()
end

function ActivityLimitRank:init(params)
    return self
end

function ActivityLimitRank:onUpdate(dt)
	if _ED.active_activity[143] == nil then
        return
    end

    local current = _ED.system_time + (os.time() - _ED.native_time)
    local surplus_time = _ED.active_activity[143].end_time / 1000 - current
    self.Text_time_limit_time_n:setString(getRedAlertTimeActivityFormat(surplus_time))
end

function ActivityLimitRank:sorceTypeTab( _type )
    local root = self.roots[1]
    local day = ccui.Helper:seekWidgetByName(root, "Button_time_limit_activity_1")
    local add = ccui.Helper:seekWidgetByName(root, "Button_time_limit_activity_2")
    if _type == 1 then
        day:setTouchEnabled(false)
        day:setHighlighted(true)
        add:setTouchEnabled(true)
        add:setHighlighted(false)
        self.dailyList:setVisible(true)
        self.addList:setVisible(false)
    else
        day:setTouchEnabled(true)
        day:setHighlighted(false)
        add:setTouchEnabled(false)
        add:setHighlighted(true)
        self.dailyList:setVisible(false)
        self.addList:setVisible(true)
    end
end

function ActivityLimitRank:onUpdateDraw(_type)
    local root = self.roots[1]
    -- self.initData()
	self.Text_time_limit_time_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_time_limit_time_n")

    local ListView_exploration_everyday_integral = ccui.Helper:seekWidgetByName(root, "ListView_time_limit_gk")
    local ListView_exploration_integral = ccui.Helper:seekWidgetByName(root, "ListView_time_limit_dj")
    local Text_integral_t_n = ccui.Helper:seekWidgetByName(root, "Text_integral_t_n")
    local Text_integral_a_n = ccui.Helper:seekWidgetByName(root, "Text_integral_a_n")
    
    ListView_exploration_everyday_integral:removeAllItems()
    ListView_exploration_integral:removeAllItems()

    local dailyList = self:sortScoreIds()[1]
    local totalList = self:sortScoreIds()[2]

    for k,v in pairs(dailyList) do
        local cell = ActivityLimitRankStarCell:createCell()
		cell:init({_type = 1, info = v})
        ListView_exploration_everyday_integral:addChild(cell)
    end

    for k,v in pairs(totalList) do
        local cell = ActivityLimitRankLevelCell:createCell()
		cell:init({_type = 2, info = v})
        ListView_exploration_integral:addChild(cell)
    end

    self.dailyList = ListView_exploration_everyday_integral
    self.addList = ListView_exploration_integral

    local _type1 = _type or 1
    self:sorceTypeTab(_type1)
    self:updateRedot()
end

function ActivityLimitRank:sortScoreIds()
    local ids = {}

    local myData = zstring.splits(_ED.active_activity[143].activity_params, "|", ",")

    local myProgressData = {}
    for _, v in pairs(myData) do
        local taskType = tonumber(v[1])
        myProgressData[taskType] = tonumber(v[2])
    end

    for i, info in ipairs(_ED.active_activity[143].activity_Info) do
        local data = {}
        local needData = zstring.split(info.activityInfo_need_day, ":")
        local canGetNums = tonumber(needData[3]) - tonumber(needData[4])
        local _type = tonumber(needData[1])

        data.id = info.index
        data.info = info

        local curProgress = tonumber(myProgressData[_type])
        data.curProgress = curProgress

        if tonumber(info.activityInfo_isReward) == 1 then -- 已经领取
            data.state = 2
        else
            if curProgress >= tonumber(needData[2]) then --已完成
            	if canGetNums > 0 then -- 完成条件可领取
                	data.state = 0
                else
                	data.state = 4 -- 完成条件不可领取
                end
            else--未完成
                data.state = 1
            end
        end

        local index = self.typeCastIndexEnum[_type]

        ids[index] = ids[index] or {}
        table.insert(ids[index], data)
    end
    
    local function sortList( a, b )
        if a.state < b.state then
            return true
        elseif a.state == b.state then
            return a.id < b.id
        else
            return false
        end
    end
        
    table.sort(ids[1], sortList)
    table.sort(ids[2], sortList)

    return ids
end

--红点
function ActivityLimitRank:updateRedot()
	local root = self.roots[1]
	local function isHaveRedot( _type )
		if _ED.active_activity[143] == nil or _ED.active_activity[143] == "" then
			return false
		end

		local info = self:sortScoreIds()[_type]
		for i,v in pairs(info) do
			if v.state == 0 then
				return true
			end
		end

		return false
	end

	for i = 1, 2 do
		local Button_time_limit_activity = ccui.Helper:seekWidgetByName(root, "Button_time_limit_activity_" .. i)
		if isHaveRedot(i) == true then
			if Button_time_limit_activity._istips == nil or Button_time_limit_activity._istips == false then
				local ball = cc.Sprite:create("images/ui/bar/tips.png")
				ball:setAnchorPoint(cc.p(0.5, 0.5))
				ball:setPosition(cc.p(Button_time_limit_activity:getContentSize().width-ball:getContentSize().width*0.5, Button_time_limit_activity:getContentSize().height-ball:getContentSize().height*0.5))
				Button_time_limit_activity:addChild(ball)
				Button_time_limit_activity._nodeChild = ball
				Button_time_limit_activity._istips = true
			end
		else
			if Button_time_limit_activity._istips == true then
				Button_time_limit_activity:removeChild(Button_time_limit_activity._nodeChild, true)
				Button_time_limit_activity._nodeChild = nil
				Button_time_limit_activity._istips = false
			end
		end
	end
end

function ActivityLimitRank:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/wonderful/time_limit_activity.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    -- debug.print_r(_ED.active_activity[143])
    -- 开启
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recharge_three_close"), nil, 
    {
        terminal_name = "activity_limit_rank_close", 
        isPressedActionEnabled = true
    },
    nil, 0)

     -- 限时闯关
     fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_time_limit_activity_1"), nil, 
     {
         terminal_name = "activity_limit_rank_type", 
         isPressedActionEnabled = true,
         _type = 1
     },
     nil, 0)

     -- 限时等级
     fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_time_limit_activity_2"), nil, 
     {
         terminal_name = "activity_limit_rank_type", 
         isPressedActionEnabled = true,
          _type = 2
     },
     nil, 0)

    self:onUpdateDraw()
end

function ActivityLimitRank:onExit()

end
