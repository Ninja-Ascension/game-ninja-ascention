-----------------------------
--签到的累计奖励
-----------------------------
SmCheckInInfoGrandTotal = class("SmCheckInInfoGrandTotalClass", Window)

--打开界面
local sm_check_in_info_grand_total_open_terminal = {
	_name = "sm_check_in_info_grand_total_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmCheckInInfoGrandTotalClass") == nil then
			fwin:open(SmCheckInInfoGrandTotal:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_check_in_info_grand_total_close_terminal = {
	_name = "sm_check_in_info_grand_total_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmCheckInInfoGrandTotalClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_check_in_info_grand_total_open_terminal)
state_machine.add(sm_check_in_info_grand_total_close_terminal)
state_machine.init()

function SmCheckInInfoGrandTotal:ctor()
	self.super:ctor()
	self.roots = {}
    self.reworld_sorting = {}
    local function init_prop_warehouse_terminal()
        local sm_check_in_info_grand_total_check_terminal = {
            _name = "sm_check_in_info_grand_total_check",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if instance == nil then
                            return
                        end
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7,nil,instance.reworld_sorting)
                        -- getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)
                        instance:onUpdateDraw()
                        state_machine.excute("sm_check_in_info_window_update_reworld_grand_total", 0, "")
                    end
                end
                local activityId = nil
                activityId = _ED.active_activity[38].activity_id
                protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(instance.activity2Datas.index)-1).."\r\n1"
                NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_check_in_info_grand_total_check_terminal)
        state_machine.init()
    end
    init_prop_warehouse_terminal()
end

function SmCheckInInfoGrandTotal:init(params)
    self.activity2Datas = params
	self:onInit()
    return self
end

function SmCheckInInfoGrandTotal:onUpdateDraw()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    ListView_1:removeAllItems()
    local index = 1
    if self.activity2Datas ~= nil then
        if tonumber(self.activity2Datas.activityInfo_silver) ~= 0 then
            --金币
            local cell = ResourcesIconCell:createCell()
            cell:init(1, tonumber(self.activity2Datas.activityInfo_silver), -1,nil,nil,true)
            ListView_1:addChild(cell)
            local rewardinfo = {}
            rewardinfo.type = 1
            rewardinfo.id = -1
            rewardinfo.number = tonumber(self.activity2Datas.activityInfo_silver)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        end
        if tonumber(self.activity2Datas.activityInfo_gold) ~= 0 then
            --钻石
            local cell = ResourcesIconCell:createCell()
            cell:init(2, tonumber(self.activity2Datas.activityInfo_gold), -1,nil,nil,true)
            ListView_1:addChild(cell)
            local rewardinfo = {}
            rewardinfo.type = 2
            rewardinfo.id = -1
            rewardinfo.number = tonumber(self.activity2Datas.activityInfo_gold)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        end
        if tonumber(self.activity2Datas.activityInfo_food) ~= 0 then
            --体力
            local cell = ResourcesIconCell:createCell()
            cell:init(12, tonumber(self.activity2Datas.activityInfo_food), -1,nil,nil,true)
            ListView_1:addChild(cell)
            local rewardinfo = {}
            rewardinfo.type = 12
            rewardinfo.id = -1
            rewardinfo.number = tonumber(self.activity2Datas.activityInfo_food)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        end
        -- if tonumber(_ED.active_activity[39].activity_Info[m_number].activityInfo_equip_count) ~= 0 then
        --     --装备
        --     local equip_data = _ED.active_activity[39].activity_Info[m_number].activityInfo_equip_info[1]
        --     local cell = ResourcesIconCell:createCell()
        --     cell:init(7, tonumber(equip_data.propMouldCount), equip_data.propMould,nil,nil,true,true)
        --     Panel_props:addChild(cell)
        -- end
        if tonumber(self.activity2Datas.activityInfo_prop_count) ~= 0 then
            --道具
            local prop_data = self.activity2Datas.activityInfo_prop_info[1]
            local cell = ResourcesIconCell:createCell()
            cell:init(6, tonumber(prop_data.propMouldCount), prop_data.propMould,nil,nil,true)
            ListView_1:addChild(cell)
            if dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.use_of_ship) > 0  and dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.storage_page_index) == 18 then
                local jsonFile = "sprite/sprite_wzkp.json"
                local atlasFile = "sprite/sprite_wzkp.atlas"
                local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                animation:setPosition(cc.p(cell:getContentSize().width/2,cell:getContentSize().height/2))
                cell:addChild(animation)
            end
            local rewardinfo = {}
            rewardinfo.type = 6
            rewardinfo.id = prop_data.propMould
            rewardinfo.number = tonumber(prop_data.propMouldCount)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
        end
        ListView_1:requestRefreshView()

        local Button_receive = ccui.Helper:seekWidgetByName(root,"Button_receive")
        ccui.Helper:seekWidgetByName(root,"Button_receive_ylq"):setVisible(false)
        Button_receive:setVisible(true)
        local activity = _ED.active_activity[38]
        local year,month = os.date("%Y", tonumber(_ED.system_time)), os.date("%m", tonumber(_ED.system_time))+1 -- 正常是获取服务器给的时间来算
        local dayAmount = os.date("%d", os.time({year=year, month=month, day=0})) -- 获取当月天数
        local receiveNumber = 0
        for i, v in pairs(activity.activity_Info) do
            if i<= tonumber(dayAmount) then
                if tonumber(v.activityInfo_isReward) > 0 then
                    receiveNumber = receiveNumber + 1
                end
            end
        end
        if receiveNumber < tonumber(self.activity2Datas.activityInfo_need_day) then
            Button_receive:setBright(false)
            Button_receive:setTouchEnabled(false)
            Button_receive:setVisible(true)
        else
            if tonumber(self.activity2Datas.activityInfo_isReward) == 0 then
                Button_receive:setBright(true)
                Button_receive:setTouchEnabled(true)
                Button_receive:setVisible(true)
            else
                Button_receive:setBright(false)
                Button_receive:setTouchEnabled(false)
                Button_receive:setVisible(false)
            end
        end
    end
end

function SmCheckInInfoGrandTotal:onInit()
    local csbItem = csb.createNode("activity/wonderful/sm_month_sign_copy_the_award.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "sm_check_in_info_grand_total_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --活动奖励
   	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_receive"), nil, 
    {
        terminal_name = "sm_check_in_info_grand_total_check", 
        terminal_state = 0, 
    }, nil, 0)

    self:onUpdateDraw()

end

function SmCheckInInfoGrandTotal:onEnterTransitionFinish()
    
end


function SmCheckInInfoGrandTotal:onExit()
end

