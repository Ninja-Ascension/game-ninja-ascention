-----------------------------
--限时宝箱活动
-----------------------------
SmLimitedTimeEquipBoxWindow = class("SmLimitedTimeEquipBoxWindowClass", Window)

--打开界面
local sm_limited_time_equip_box_window_open_terminal = {
	_name = "sm_limited_time_equip_box_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmLimitedTimeEquipBoxWindowClass") == nil then
			fwin:open(SmLimitedTimeEquipBoxWindow:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_limited_time_equip_box_window_close_terminal = {
	_name = "sm_limited_time_equip_box_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmLimitedTimeEquipBoxWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_limited_time_equip_box_window_open_terminal)
state_machine.add(sm_limited_time_equip_box_window_close_terminal)
state_machine.init()

function SmLimitedTimeEquipBoxWindow:ctor()
	self.super:ctor()
	self.roots = {}

    self._activity_type = 0
    self._info = nil

    app.load("client.reward.DrawRareReward")
    self.reworld_sorting = {}
    local function init_sm_limited_time_equip_box_window_terminal()
    	local sm_limited_time_equip_box_window_get_reward_terminal = {
            _name = "sm_limited_time_equip_box_window_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local activity = _ED.active_activity[instance._activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7,nil,instance.reworld_sorting)
                        -- getRewardWnd:init(7)
                        fwin:open(getRewardWnd,fwin._ui)
                        state_machine.excute("sm_limited_time_equip_box_window_close", 0, "")
                        state_machine.excute("sm_limited_time_equip_box_update_draw", 0, "")
                    end
                end
                protocol_command.get_activity_reward.param_list = ""..activity.activity_id.."\r\n"..(instance._info.index - 1).."\r\n".."0".."\r\n"..instance._activity_type.."\r\n".."1".."\r\n".."0"
                NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_limited_time_equip_box_window_get_reward_terminal)
        state_machine.init()
    end
    init_sm_limited_time_equip_box_window_terminal()
end

function SmLimitedTimeEquipBoxWindow:onUpdateDraw()
    local root = self.roots[1]

    local Button_closed_1 = ccui.Helper:seekWidgetByName(root, "Button_closed_1")
    local Button_receive = ccui.Helper:seekWidgetByName(root, "Button_receive") 
    Button_closed_1:setVisible(false)
    Button_receive:setVisible(false)

    local activity_info = _ED.active_activity[self._activity_type]
    local activity_params = zstring.split(activity_info.activity_params, "!")

    local current_score = tonumber(zstring.split(activity_params[1], ",")[2])             -- 当前积分
    local need_score = tonumber(self._info.activityInfo_need_day)

    if current_score < need_score or tonumber(self._info.activityInfo_isReward) > 0 then
        Button_closed_1:setVisible(true)
    else
        Button_receive:setVisible(true)
    end
end

function SmLimitedTimeEquipBoxWindow:updateRewardInfo( ... )
    local root = self.roots[1]

    local ListView_award = ccui.Helper:seekWidgetByName(root, "ListView_award")
    ListView_award:removeAllItems()
    local index = 1
    if tonumber(self._info.activityInfo_silver) > 0 then--可领取银币数量
        local cell = ResourcesIconCell:createCell()
        cell:init(1, tonumber(self._info.activityInfo_silver), -1,nil,nil,true,true)
        ListView_award:addChild(cell)
        local rewardinfo = {}
        rewardinfo.type = 1
        rewardinfo.id = -1
        rewardinfo.number = tonumber(self._info.activityInfo_silver)
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
    end
    if tonumber(self._info.activityInfo_gold) > 0 then--奖励1可领取金币数量
        local cell = ResourcesIconCell:createCell()
        cell:init(2, tonumber(self._info.activityInfo_gold), -1,nil,nil,true,true)
        ListView_award:addChild(cell)
        local rewardinfo = {}
        rewardinfo.type = 2
        rewardinfo.id = -1
        rewardinfo.number = tonumber(self._info.activityInfo_gold)
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
    end
    if tonumber(self._info.activityInfo_food) > 0 then--奖励1可领取体力数量
        local cell = ResourcesIconCell:createCell()
        cell:init(12, tonumber(self._info.activityInfo_food), -1,nil,nil,true,true)
        ListView_award:addChild(cell)
    end
    if tonumber(self._info.activityInfo_honour) > 0 then--奖励1可领取声望数量
        local cell = ResourcesIconCell:createCell()
        cell:init(3, tonumber(self._info.activityInfo_honour), -1,nil,nil,true,true)
        ListView_award:addChild(cell)
        local rewardinfo = {}
        rewardinfo.type = 3
        rewardinfo.id = -1
        rewardinfo.number = tonumber(self._info.activityInfo_honour)
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
    end
    if tonumber(self._info.activityInfo_equip_count) > 0 then   --可领取装备种类数量
        for n, v in pairs(self._info.activityInfo_equip_info) do
            local cell = ResourcesIconCell:createCell()
            cell:init(7, tonumber(v.equipMouldCount), v.equipMould,nil,nil,true,true)
            ListView_award:addChild(cell)
            local rewardinfo = {}
            rewardinfo.type = 7
            rewardinfo.id = v.equipMould
            rewardinfo.number = tonumber(v.equipMouldCount)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        end
    end
    if tonumber(self._info.activityInfo_prop_count) > 0 then--可领取道具种类数量
        for n, v in pairs(self._info.activityInfo_prop_info) do
            local cell = ResourcesIconCell:createCell()
            cell:init(6, tonumber(v.propMouldCount), v.propMould,nil,nil,true,true)
            ListView_award:addChild(cell)
            local rewardinfo = {}
            rewardinfo.type = 6
            rewardinfo.id = v.propMould
            rewardinfo.number = tonumber(v.propMouldCount)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        end
    end
    if tonumber(self._info.activityInfo_general_soul) > 0 then  --可领取水雷魂种类数量
        local cell = ResourcesIconCell:createCell()
        cell:init(5, tonumber(self._info.activityInfo_general_soul), -1,nil,nil,true,true)
        ListView_award:addChild(cell)
        local rewardinfo = {}
        rewardinfo.type = 5
        rewardinfo.id = -1
        rewardinfo.number = tonumber(self._info.activityInfo_general_soul)
        self.reworld_sorting[index] = rewardinfo
        index = index + 1
    end

    local otherRewards = zstring.splits(self._info.activityInfo_reward_select, "|", ",")
    if #otherRewards > 0 then
        for i, v in pairs(otherRewards) do
            -- 类型、ID、数量、星级
            if #v >= 3 then
                local cell = ResourcesIconCell:createCell()
                local rewardType = tonumber(v[1])
                if 13 == rewardType then
                    local table = {}
                    if v[4] ~= nil and tonumber(v[4]) ~= -1 then
                        table.shipStar = tonumber(v[4])
                    end
                    cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1,table)
                    local ships = fundShipWidthTemplateId(tonumber(v[2]))
                    if ships == nil then
                        local rewardinfo = {}
                        rewardinfo.type = rewardType
                        rewardinfo.id = tonumber(v[2])
                        rewardinfo.number = tonumber(v[3])
                        self.reworld_sorting[index] = rewardinfo
                        index = index + 1
                    else
                        local prop_mlds = dms.int(dms["ship_mould"], tonumber(v[2]), ship_mould.fitSkillOne)
                        local number_info = zstring.split(dms.string(dms["ship_config"], 13, ship_config.param),"!")[tonumber(v[4])]
                        local ability = dms.int(dms["ship_mould"], tonumber(v[2]), ship_mould.ability)
                        local number_data = zstring.split(number_info,"|")[ability-13+1]
                        local m_number = tonumber(zstring.split(number_data,",")[2])
                        -- local prop_mlds = dms.int(dms["ship_mould"], tonumber(v[2]), ship_mould.fitSkillOne)
                        -- local m_number = dms.int(dms["prop_mould"], prop_mlds, prop_mould.split_or_merge_count)
                        local rewardinfo = {}
                        rewardinfo.type = 6
                        rewardinfo.id = prop_mlds
                        rewardinfo.number = m_number
                        self.reworld_sorting[index] = rewardinfo
                        index = index + 1
                    end
                else
                    cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1)
                    local rewardinfo = {}
                    rewardinfo.type = rewardType
                    rewardinfo.id = tonumber(v[2])
                    rewardinfo.number = tonumber(v[3])
                    self.reworld_sorting[index] = rewardinfo
                    index = index + 1
                end
                ListView_award:addChild(cell)
            end
        end
    end

    ListView_award:requestRefreshView()
end

function SmLimitedTimeEquipBoxWindow:init(params)
    self._activity_type = params[1]
    self._info = params[2]
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function SmLimitedTimeEquipBoxWindow:onInit()
    local csbItem = csb.createNode("activity/wonderful/sm_limited_time_equip_box_window.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed_2"), nil, 
    {
        terminal_name = "sm_limited_time_equip_box_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed_1"), nil, 
    {
        terminal_name = "sm_limited_time_equip_box_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    -- 领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_receive"), nil, 
    {
        terminal_name = "sm_limited_time_equip_box_window_get_reward", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)


    self:onUpdateDraw()
    self:updateRewardInfo()
end

function SmLimitedTimeEquipBoxWindow:onEnterTransitionFinish()
    
end


function SmLimitedTimeEquipBoxWindow:onExit()
    state_machine.remove("sm_limited_time_equip_box_window_get_reward")
end

