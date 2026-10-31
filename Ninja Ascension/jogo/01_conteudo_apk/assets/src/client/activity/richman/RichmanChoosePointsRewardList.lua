--[[ ----------------------------------------------------------------------------
-- 可选奖励cell
--]] ----------------------------------------------------------------------------
RichmanChoosePointsRewardList = class("RichmanChoosePointsRewardListClass", Window)
RichmanChoosePointsRewardList.__size = nil

-- 创建Cell实例
local richman_choose_points_reward_list_create_terminal = {
	_name = "richman_choose_points_reward_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RichmanChoosePointsRewardList then
			local cell = RichmanChoosePointsRewardList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(richman_choose_points_reward_list_create_terminal)
state_machine.init()

-- 构造器
function RichmanChoosePointsRewardList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.propInfo = nil
    self.canSelect = nil

	self.curNeedPoints = -1

	-- load lua files.

	local function init_richman_choose_points_reward_list_terminal()
		-- 更新选中框的显示
		local richman_choose_points_reward_list_choose_terminal = {
			_name = "richman_choose_points_reward_list_choose",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					if params._datas.canSelect == true then
						local remainCounts = params._datas.remainCounts
						if remainCounts == 0 then
							TipDlg.drawTextDailog(string.format(tipStringInfo_richman[12]))
							return
						end

						local cellIndex = params._datas.cellIndex
						local scoreRewardIndex = params._datas.scoreRewardIndex
						local optionSelectIndex = params._datas.optionSelectIndex

						state_machine.excute("richman_choose_points_reward_idx", 0, {cellIndex, scoreRewardIndex, optionSelectIndex})
					else
						-- xx积分可选择
						TipDlg.drawTextDailog(string.format(tipStringInfo_richman[10], params._datas.curNeedPoints))
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(richman_choose_points_reward_list_choose_terminal)
		state_machine.init()
	end
	
	init_richman_choose_points_reward_list_terminal()
end

function RichmanChoosePointsRewardList:updateChoose(state)
	local children = self.Panel_icon:getChildren()
	local cell = children[1]
	if cell ~= nil then
		cell:setChooseSelectState(state)
	end
end

function RichmanChoosePointsRewardList:initNeedPoints()
	local _userDataInfo = _ED.active_activity[187].activity_data
	local pointRewardsInfo = _userDataInfo.pointRewardsInfo
	for i, v in ipairs(pointRewardsInfo) do
		local rewardIdxInfo = v.rewardIdxInfo
		if self.curNeedPoints == -1 then
			for j, k in ipairs(rewardIdxInfo) do
				if self.rewardPoolIndex == k then
					self.curNeedPoints = v.needPoints
					break
				end
			end
		end
	end

end

-- 对象初始化
function RichmanChoosePointsRewardList:init(params)
	self.scoreRewardIndex = params.scoreRewardIndex
	self.rewardPoolIndex = params.rewardPoolIndex
    self.propInfo = params.propInfo
    self.canSelect = params.canSelect
    self.optionSelectIndex = params.optionSelectIndex
    self.cellIndex = params.cellIndex
	self.remainCounts = params.exchangeCountsInfo.remainCounts
	self.allCounts = params.exchangeCountsInfo.allCounts

	self:onInit(params)
	self:setContentSize(RichmanChoosePointsRewardList.__size)
	return self
end

function RichmanChoosePointsRewardList:updateUI()
    self.Panel_icon:removeAllChildren(true)

    local cell = DrawHandle.drawIcon(self.propInfo)
    self.Panel_icon:addChild(cell)

    self.Image_3:setVisible(self.canSelect == false)
    self.Image_mask:setVisible(self.canSelect == false)
	self.Text_tips:setVisible(self.canSelect == false)
	self.Text_integral:setVisible(self.canSelect == false)

	if self.canSelect == false then
		self.Text_integral:setString(self.curNeedPoints)
	end
	
	local countsText = nil
	if self.allCounts == -1 then
		countsText = tipStringInfo_richman[13]
	else
		countsText = self.remainCounts .. "/" .. self.allCounts
	end
	self.Text_1:setString(countsText)
end

function RichmanChoosePointsRewardList:onUpdateDraw()
	local root = self.roots[1]

	-- 道具容器
	self.Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")

	-- 遮罩
	self.Image_mask = ccui.Helper:seekWidgetByName(root, "Image_mask")
    
	-- 不可选择
	self.Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")

	-- 积分提示文本
	self.Text_tips = ccui.Helper:seekWidgetByName(root, "Text_tips")
	-- 积分数量提示文本
	self.Text_integral = ccui.Helper:seekWidgetByName(root, "Text_integral")

	-- 剩余选择次数文本
	self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	
	self:updateUI()
end

function RichmanChoosePointsRewardList:onEnterTransitionFinish()
	
end

function RichmanChoosePointsRewardList:onInit(params)
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("activity/dafuweng/dafuweng_jiangli_icon.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RichmanChoosePointsRewardList.__size == nil then
		RichmanChoosePointsRewardList.__size = root:getContentSize()
	end

	self:initNeedPoints()

    -- 选择按钮    如果不可以选择，不能点击按钮
    self.Panel_icon = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_icon"), nil,
    {
        terminal_name = "richman_choose_points_reward_list_choose",
        terminal_state = 0,
        isPressedActionEnabled = true,
        scoreRewardIndex = self.scoreRewardIndex,
        canSelect = self.canSelect,
        optionSelectIndex = self.optionSelectIndex,
        cellIndex = self.cellIndex,
		curNeedPoints = self.curNeedPoints,
		remainCounts = self.remainCounts
	}, nil, 0)

	self:onUpdateDraw()
end

function RichmanChoosePointsRewardList:onExit()
	-- 释放LimPoolRewardListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/dafuweng/dafuweng_jiangli_icon.csb", root)
	-- ]]
end

function RichmanChoosePointsRewardList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RichmanChoosePointsRewardList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/dafuweng/dafuweng_jiangli_icon.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
