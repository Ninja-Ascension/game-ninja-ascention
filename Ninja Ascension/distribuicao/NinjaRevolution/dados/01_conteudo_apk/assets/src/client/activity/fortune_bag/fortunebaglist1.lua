--[[ ----------------------------------------------------------------------------
-- 配对奖励页面
--]] ----------------------------------------------------------------------------
FortuneBagList1 = class("FortuneBagList1Class", Window)
FortuneBagList1.__size = nil

-- 创建Cell实例
local fortune_bag_list1_create_terminal = {
	_name = "fortune_bag_list1_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FortuneBagList1 then
			local cell = FortuneBagList1:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fortune_bag_list1_create_terminal)
state_machine.init()

-- 构造器
function FortuneBagList1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._reward_data = nil -- 奖励数据
	-- load lua files.
	app.load("client.cells.utils.resources_icon_cell")
	-- Initialize fortune bag list1 page state machine.
	local function init_fortune_bag_list1_terminal()
		-- 领取奖励
		local fortune_bag_list_cell_get_reward_terminal = {
			_name = "fortune_bag_list_cell_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local mIndex = params._datas.m_index
				local function responseChangeCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd,fwin._ui)
						state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 169)
						state_machine.excute("fortune_bag_refesh_windows",0,{m_page = 2})
                        state_machine.excute("sm_role_strengthen_tab_rising_star_update_draw", 0 , "sm_role_strengthen_tab_rising_star_update_draw.")
					end
                end
                protocol_command.lucky_match_get_reward.param_list = ""..mIndex
                NetworkManager:register(protocol_command.lucky_match_get_reward.code, nil, nil, nil, instance, responseChangeCallback, false, nil)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(fortune_bag_list_cell_get_reward_terminal)
		state_machine.init()
	end
	-- call func init fortune bag list1 state machine.
	init_fortune_bag_list1_terminal()
end

-- 对象初始化
function FortuneBagList1:init(params)
	self:onInit(params)
	
	return self
end

function FortuneBagList1:onInit(params)
	if params[1] then
		self._reward_data = params[1]
	end
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/fortune_bag/fortune_bag_list_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if FortuneBagList1.__size == nil then
		FortuneBagList1.__size = root:getContentSize()
	end
	self:setContentSize(FortuneBagList1.__size)
	-- 领取按钮
	self.Button_fortune_bag_lingqu = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fortune_bag_lingqu"), nil,
	{
		terminal_name = "fortune_bag_list_cell_get_reward",
		terminal_state = 0,
		m_index = self._reward_data.index,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

function FortuneBagList1:onUpdateDraw()
	local root = self.roots[1]
	local rewardData = self._reward_data
	local panelList = {}
	for i=1,3 do
		local panelPer = ccui.Helper:seekWidgetByName(root, "Panel_fortune_bag"..i)
		panelPer:removeAllChildren(true)
		table.insert(panelList,panelPer)
	end

	local matchConditions = zstring.split(rewardData.matchCondition,"|")
	for i=1,2 do
		local propData = zstring.split(matchConditions[i],",")
		local cell = self:addResourcesIconCell(propData)
		if rewardData.eachRewardStatus then 
			local rewardStatus = zstring.split(rewardData.eachRewardStatus,"|")
			if 2 ~= tonumber(rewardData.matchRewardStatus) and 1 == tonumber(rewardStatus[i]) then
				self:addEffectForRare(cell)
			end
		end
		panelList[i]:addChild(cell)
	end

	local getAward = zstring.split(rewardData.matchReward,"|")
	local getPropData = zstring.split(getAward[1],",")
	panelList[3]:addChild(self:addResourcesIconCell(getPropData))
	
	-- 已领图片Image_received
	local Image_received = ccui.Helper:seekWidgetByName(root, "Image_received")
	Image_received:setVisible(false)
	self.Button_fortune_bag_lingqu:setVisible(true)
	self.Button_fortune_bag_lingqu:setEnabled(true)
	self.Button_fortune_bag_lingqu:setBright(true)
	if 2 == tonumber(rewardData.matchRewardStatus) then
		Image_received:setVisible(true)
		-- 按钮置灰
		self.Button_fortune_bag_lingqu:setVisible(false)

	elseif 0 == tonumber(rewardData.matchRewardStatus) then 
		-- 按钮置灰
		self.Button_fortune_bag_lingqu:setEnabled(false)
		self.Button_fortune_bag_lingqu:setBright(false)
	end
	
end

-- 稀有奖励添加边框特效
function FortuneBagList1:addEffectForRare(panel)
	local jsonFile = "images/ui/effice/effice_luck_draw_frame/effice_luck_draw_frame.json"
	local atlasFile = "images/ui/effice/effice_luck_draw_frame/effice_luck_draw_frame.atlas"

	local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
	if __lua_project_id == __lua_project_l_naruto then
		animation:setPosition(cc.p(panel:getContentSize().width/2/2 - 8, panel:getContentSize().height/2/2 - 8))
	else
		animation:setPosition(cc.p(panel:getContentSize().width/2, panel:getContentSize().height/2))
	end
	panel:addChild(animation)
end

-- 添加道具图标
function FortuneBagList1:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
	end

	return cell
end

function FortuneBagList1:onEnterTransitionFinish()
	
end


function FortuneBagList1:onExit()
	-- 释放FortuneBagList1Window界面资源.
	state_machine.remove("fortune_bag_list_cell_get_reward")
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/fortune_bag/fortune_bag_list_1.csb", root)
	-- ]]
end

function FortuneBagList1:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function FortuneBagList1:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/fortune_bag/fortune_bag_list_1.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
