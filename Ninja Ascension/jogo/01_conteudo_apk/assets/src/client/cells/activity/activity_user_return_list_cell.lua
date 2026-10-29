--[[ ----------------------------------------------------------------------------
-- 周登录福利列表内容
--]] ----------------------------------------------------------------------------
ActivityUserReturnListCell = class("ActivityUserReturnListCellClass", Window)
ActivityUserReturnListCell.__size = nil

-- 创建Cell实例
local activity_user_return_list_cell_create_terminal = {
	_name = "activity_user_return_list_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if ActivityUserReturnListCell then
			local cell = ActivityUserReturnListCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			cell:registerOnNoteUpdate(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_user_return_list_cell_create_terminal)
state_machine.init()

-- 构造器
function ActivityUserReturnListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.dayNum = 0				-- 天数
	self.rewardState = 0		-- 领取状态
	self.rewardData = nil 		-- 奖励数据
	self.activityDatas = nil
	
	-- load lua files.

	-- Initialize activity user return list cell page state machine.
	local function init_activity_user_return_list_cell_terminal()
		-- 领取奖励
		local activity_user_return_list_cell_get_reward_terminal = {
			_name = "activity_user_return_list_cell_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local dayNum = params._datas.m_day
				local function responseChangeCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd,fwin._ui)
						state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 164)
						state_machine.excute("user_return_window_refresh_red_tip",0,"")
                        state_machine.excute("sm_role_strengthen_tab_rising_star_update_draw", 0 , "sm_role_strengthen_tab_rising_star_update_draw.")
						state_machine.excute("user_return_main_tab3_refresh",0,"")
					end
                end
                protocol_command.old_user_back_seven_day_get_reward.param_list = ""..dayNum
                NetworkManager:register(protocol_command.old_user_back_seven_day_get_reward.code, nil, nil, nil, instance, responseChangeCallback, false, nil)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(activity_user_return_list_cell_get_reward_terminal)
		state_machine.init()
	end

	init_activity_user_return_list_cell_terminal()
end

-- 对象初始化
function ActivityUserReturnListCell:init(params)
	self:onInit(params)
	self:setContentSize(ActivityUserReturnListCell.__size)
	return self
end

function ActivityUserReturnListCell:onUpdateDraw()
	local root = self.roots[1]
	-- 领取文字
	self.Image_receive = ccui.Helper:seekWidgetByName(root, "Text_receive")
	self.Image_receive:setVisible(false)
	-- 已领取文字
	self.Image_received = ccui.Helper:seekWidgetByName(root, "Text_received")
	self.Image_received:setVisible(false)
	local datas = self.activityDatas
	if nil == datas.canGetReward then
		self.Image_receive:setVisible(true)
		self.Button_recruit_card_send_rec:setEnabled(false)
		self.Button_recruit_card_send_rec:setBright(false)
	else
		if 1 == tonumber(datas.canGetReward) then
			self.Image_receive:setVisible(true)
			self.Button_recruit_card_send_rec:setEnabled(true)
			self.Button_recruit_card_send_rec:setBright(true)
		else
			if 0 == tonumber(datas.hasGetReward) then
				self.Image_receive:setVisible(true)
				self.Button_recruit_card_send_rec:setEnabled(false)
				self.Button_recruit_card_send_rec:setBright(false)
			else
				self.Image_received:setVisible(true)
				self.Button_recruit_card_send_rec:setEnabled(false)
				self.Button_recruit_card_send_rec:setBright(false)
			end
		end
	end
	
	-- 第%s天
	self.Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")
	self.Text_11:setString(string.format(_new_interface_text[219],tonumber(datas.dayNum)))
	-- 奖励道具列表
	self.ListView_11 = ccui.Helper:seekWidgetByName(root, "ListView_11")
	self.ListView_11:jumpToTop()
	self.ListView_11:removeAllItems()
	
	local propDatas = zstring.splits(datas.rewardData, "|", ",")
	for i=1,#propDatas do
		local propData = propDatas[i]
		local propType = propData[1]
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
			cell:init(propType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
		end
		self.ListView_11:addChild(cell)
	end
	self.ListView_11:requestRefreshView()
end

function ActivityUserReturnListCell:onEnterTransitionFinish()
	
end

function ActivityUserReturnListCell:onInit(params)
	self.activityDatas = params[1]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/user_return/user_return_tab_3_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)

	if ActivityUserReturnListCell.__size == nil then
		ActivityUserReturnListCell.__size = ccui.Helper:seekWidgetByName(root, "Panel_land_list"):getContentSize()
	end

	self:setContentSize(ActivityUserReturnListCell.__size)

	-- 领取/已领取按钮
	self.Button_recruit_card_send_rec = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive"), nil,
	{
		terminal_name = "activity_user_return_list_cell_get_reward",
		terminal_state = 0,
		m_day = self.activityDatas.dayNum,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function ActivityUserReturnListCell:onExit()
	-- 释放ActivityUserReturnListCellWindow界面资源.
	
	-- [[ 释放缓存
	self:clearUIInfo()
	local root = self.roots[1]
	cacher.freeRef("activity/user_return/user_return_tab_3_list.csb", root)
	-- ]]
end

function ActivityUserReturnListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function ActivityUserReturnListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/user_return/user_return_tab_3_list.csb", root)
	
	self.roots = {}
end

function ActivityUserReturnListCell:clearUIInfo()
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
	local Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")
	Text_11:setString(Text_11:getString())
	local ListView_11 = ccui.Helper:seekWidgetByName(root, "ListView_11")
	ListView_11:removeAllChildren()
	fwin:removeTouchEventListener(ListView_11)

end

-- ~END
-- ----------------------------------------------------------------------------
