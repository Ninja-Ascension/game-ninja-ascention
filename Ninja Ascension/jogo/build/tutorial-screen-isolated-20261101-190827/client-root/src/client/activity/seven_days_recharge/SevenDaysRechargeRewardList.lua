--[[ ----------------------------------------------------------------------------
-- 奖励领取分页
--]] ----------------------------------------------------------------------------
SevenDaysRechargeRewardList = class("SevenDaysRechargeRewardListClass", Window)
SevenDaysRechargeRewardList.__size = nil

-- 创建Cell实例
local seven_days_recharge_reward_list_create_terminal = {
    _name = "seven_days_recharge_reward_list_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if SevenDaysRechargeRewardList then
            local cell = SevenDaysRechargeRewardList:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(seven_days_recharge_reward_list_create_terminal)
state_machine.init()

-- 构造器
function SevenDaysRechargeRewardList:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self.taskDatas = {}
    -- load lua files.

    -- Initialize seven days recharge reward list page state machine.
	local function init_seven_days_recharge_reward_list_terminal()
		-- 领取奖励
		local seven_days_recharge_reward_list_get_reward_terminal = {
			_name = "seven_days_recharge_reward_list_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local infos = params._datas.mDatas
				local function responseChangeCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
						fwin:open(getRewardWnd,fwin._ui)
						state_machine.excute("seven_days_recharge_refush",0,"")
						state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 1003)
						state_machine.excute("seven_days_recharge_change_red_plot_tip_page",0,"")
					end
                end
                protocol_command.seven_day_recharge_get_reward.param_list = ""..infos.mType.."\r\n"..infos.index
                NetworkManager:register(protocol_command.seven_day_recharge_get_reward.code, nil, nil, nil, instance, responseChangeCallback, false, nil)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
        }
        
        -- 前往充值
		local seven_days_go_to_recharge_terminal = {
			_name = "seven_days_go_to_recharge",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
            _invoke = function(terminal, instance, params)
                local infos = params._datas.mDatas
                if tonumber(infos.mType) == 0 and _ED.seven_day_recharge_infos.todayHasRecharge then 
                    --提示
                    function showConfirmTip(instance,n)
                        state_machine.excute("activity_home_recharge_button",0,"")
				        state_machine.excute("seven_days_recharge_window_close",0,"")
                    end
                    app.load("client.utils.ConfirmTip")
                    local tip = ConfirmTip:new()
                    tip:init(instance, showConfirmTip, tipStringInfo_seven_days_recharge_tips[6],nil,nil,nil,false)
                    fwin:open(tip,fwin._ui)
                else
                    state_machine.excute("activity_home_recharge_button",0,"")
				    state_machine.excute("seven_days_recharge_window_close",0,"")
                end
                
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


        state_machine.add(seven_days_go_to_recharge_terminal)
		state_machine.add(seven_days_recharge_reward_list_get_reward_terminal)
		state_machine.init()
    end
    -- call func init seven days recharge reward list state machine.
    init_seven_days_recharge_reward_list_terminal()
end

-- 对象初始化
function SevenDaysRechargeRewardList:init(params)
    self:onInit(params)
    return self
end

function SevenDaysRechargeRewardList:onUpdateDraw()
    local root = self.roots[1]
    local infos = self.taskDatas

    -- 标题
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    -- 连续天数/累计充值
    local Text_namesun = ccui.Helper:seekWidgetByName(root, "Text_namesun")
	local Text_number_now = ccui.Helper:seekWidgetByName(root, "Text_number_now")
	local Text_number_now_green = ccui.Helper:seekWidgetByName(root, "Text_number_now_green")
	Text_number_now:setVisible(false)
	Text_number_now_green:setVisible(false)
    local Text_number_max = ccui.Helper:seekWidgetByName(root, "Text_number_max")
    
	local Image_ylq = ccui.Helper:seekWidgetByName(root, "Image_ylq")
	Image_ylq:setVisible(false)
	self.Button_lq:setVisible(false)
    self.Button_qw:setVisible(false)
    self.Button_qw:setEnabled(true)
    self.Button_qw:setBright(true)
	
	if infos.status == 1 then
		self.Button_lq:setVisible(true)
	elseif infos.status == 2 then
        Image_ylq:setVisible(true)
    end

    if infos.mType == 0 then -- 天数
        local curSignDay = infos.signDays 
        local curIndex = infos.index + 1
        Text_name:setString(string.format(tipStringInfo_seven_days_recharge_tips[1], curIndex .. ""))
        Text_namesun:setString(tipStringInfo_seven_days_recharge_tips[3])
        
        if infos.status ~= 0 and curSignDay >= curIndex then
            curSignDay = curIndex
            Text_number_now_green:setString(curSignDay .. "")
			Text_number_now_green:setVisible(true)
        elseif infos.status == 0 and curSignDay + 1 == curIndex then 
            self.Button_qw:setVisible(true)
            Text_number_now:setString(curSignDay .. "")
            Text_number_now:setVisible(true)
        else
            self.Button_qw:setVisible(true)
            self.Button_qw:setEnabled(false)
            self.Button_qw:setBright(false)
            Text_number_now:setString(curSignDay .. "")
            Text_number_now:setVisible(true)
        end
        Text_number_max:setString(curIndex .. "")

    elseif infos.mType == 1 then -- 充值数量
        Text_name:setString(string.format(tipStringInfo_seven_days_recharge_tips[2], infos.taskProgress .. ""))
        Text_namesun:setString(tipStringInfo_seven_days_recharge_tips[4])
        local curRechargeNum = infos.rechargeNums
        if curRechargeNum >= infos.taskProgress then
			curRechargeNum = infos.taskProgress
            Text_number_now_green:setVisible(true)
            Text_number_now_green:setString(curRechargeNum)
        else
			Text_number_now:setString(curRechargeNum .. "")
			Text_number_now:setVisible(true)
        end
		Text_number_max:setString(infos.taskProgress .. "")
		
		if infos.status == 0 then
			self.Button_qw:setVisible(true)
        end
    end

    self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    self.ListView_1:removeAllItems()

    local propDatas = zstring.splits(infos.reward, "|", ",")
    for i = 1, #propDatas do
        local propData = propDatas[i]
        local propType = tonumber(propData[1])

        local cell = ResourcesIconCell:createCell()
        if 13 == propType then
            local extraTable = {}
            if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
                extraTable.shipStar = tonumber(propData[4])
            else
                extraTable.shipStar = 0
            end
            cell:init(propType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
        else
            cell:init(propType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1)
        end

        self.ListView_1:addChild(cell)
    end
    self.ListView_1:jumpToTop()
    self.ListView_1:requestRefreshView()
end

function SevenDaysRechargeRewardList:onEnterTransitionFinish()
end

function SevenDaysRechargeRewardList:onInit(params)
    -- [[ 使用缓存创建
    local root = cacher.createUIRef("activity/sevenday_recharge/sevenday_recharge_reward_list.csb", "root")
    -- ]]
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if SevenDaysRechargeRewardList.__size == nil then
        SevenDaysRechargeRewardList.__size = root:getContentSize()
    end
    self:setContentSize(SevenDaysRechargeRewardList.__size)

	self.taskDatas = params[1]
	
    self.Button_qw =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_qw"),
        nil,
        {
            terminal_name = "seven_days_go_to_recharge",
            terminal_state = 0,
            mDatas = self.taskDatas,
            isPressedActionEnabled = true
        },
        nil,
        0
	)
	
	-- 领取
	self.Button_lq = fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_lq"),
        nil,
        {
            terminal_name = "seven_days_recharge_reward_list_get_reward",
			terminal_state = 0,
			mDatas = self.taskDatas,
            isPressedActionEnabled = true
        },
        nil,
        0
	)

    

    self:onUpdateDraw()
end

function SevenDaysRechargeRewardList:onExit()
    -- 释放SevenDaysRechargeRewardListWindow界面资源.

    -- [[ 释放缓存
    self:clearUIInfo()
    local root = self.roots[1]
    cacher.freeRef("activity/sevenday_recharge/sevenday_recharge_reward_list.csb", root)
    -- ]]
end

function SevenDaysRechargeRewardList:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SevenDaysRechargeRewardList:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("activity/sevenday_recharge/sevenday_recharge_reward_list.csb", root)

    self.roots = {}
end

function SevenDaysRechargeRewardList:clearUIInfo()
    local root = self.roots[1]
    if root == nil then
        return
    end
    if root._x ~= nil then
        root:setPositionX(root._x)
    end
    if root._y ~= nil then
        root:setPositionY(root._y)
    end

    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
    Text_name:setString(Text_name:getString())
    local Text_namesun = ccui.Helper:seekWidgetByName(root, "Text_namesun")
    Text_namesun:setString(Text_name:getString())
    local Text_number_now = ccui.Helper:seekWidgetByName(root, "Text_number_now")
    Text_number_now:setString(Text_number_now:getString())
	local Text_number_now_green = ccui.Helper:seekWidgetByName(root, "Text_number_now_green")
    Text_number_now_green:setString(Text_number_now_green:getString())
    local Text_number_max = ccui.Helper:seekWidgetByName(root, "Text_number_max")
    Text_number_max:setString(Text_number_max:getString())

    local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    ListView_1:removeAllChildren()
    fwin:removeTouchEventListener(ListView_1)
end

-- ~END
-- ----------------------------------------------------------------------------
