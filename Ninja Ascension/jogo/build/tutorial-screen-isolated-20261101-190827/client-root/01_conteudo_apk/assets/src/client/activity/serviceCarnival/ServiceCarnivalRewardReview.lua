--[[ ----------------------------------------------------------------------------
-- 獎勵预览弹窗
--]] ----------------------------------------------------------------------------
ServiceCarnivalRewardReview = class("ServiceCarnivalRewardReviewClass", Window)

-- 打开窗口
local service_carnival_reward_review_window_open_terminal = {
	_name = "service_carnival_reward_review_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("ServiceCarnivalRewardReviewClass") then
			fwin:open(ServiceCarnivalRewardReview:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local service_carnival_reward_review_window_close_terminal = {
	_name = "service_carnival_reward_review_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ServiceCarnivalRewardReviewClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(service_carnival_reward_review_window_open_terminal)
state_machine.add(service_carnival_reward_review_window_close_terminal)
state_machine.init()

-- 构造器
function ServiceCarnivalRewardReview:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.m_type = 1
	self.click_indx = 1

	self.listViewPosY = 0

	self.Text_rankList = {}		-- 排行类型文本信息
	-- load lua files.
	app.load("client.activity.serviceCarnival.servicecarnivalrewardreviewlist")
	-- Initialize service carnival reward review page state machine.
	local function init_service_carnival_reward_review_terminal()
		-- 打开角色创建窗口
		local service_carnival_reward_review_open_terminal = {
			_name = "service_carnival_reward_review_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local service_carnival_reward_review_close_terminal = {
			_name = "service_carnival_reward_review_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local service_carnival_reward_review_show_terminal = {
			_name = "service_carnival_reward_review_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local service_carnival_reward_review_hide_terminal = {
			_name = "service_carnival_reward_review_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(service_carnival_reward_review_open_terminal)
		state_machine.add(service_carnival_reward_review_close_terminal)
		state_machine.add(service_carnival_reward_review_show_terminal)
		state_machine.add(service_carnival_reward_review_hide_terminal)
		state_machine.init()
	end
	-- call func init service carnival reward review state machine.
	init_service_carnival_reward_review_terminal()
end

function ServiceCarnivalRewardReview:updateListView()
	if self.ListView_reward_yulan ~= nil then
		local size = self.ListView_reward_yulan:getContentSize()
		local posY = self.ListView_reward_yulan:getInnerContainer():getPositionY()
		if self.listViewPosY == posY then
			return
		end
		self.listViewPosY = posY
		local items = self.ListView_reward_yulan:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height/2 < 0 or tempY > size.height + itemSize.height/2 then
				v:unload()
			else
				v:reload()
			end
		end
	end
end

function ServiceCarnivalRewardReview:updateDrawContent()
	
	self.ListView_reward_yulan:removeAllItems()
	self.Text_rankList[self.m_type]:setVisible(true)
	local typeArray = dms.searchs(dms["new_server_celebration"], new_server_celebration.type, self.m_type)
	local rewardString = typeArray[1][new_server_celebration.reward]
	local rewardsInfo = zstring.split(rewardString , '@')
	local rewardLength = #rewardsInfo
	for i = 1, #rewardsInfo + 1 do
		local reward = nil
		local curIndex = i
		if i == #rewardsInfo + 1 then
			reward = rewardsInfo[#rewardsInfo]
			
			curIndex =  #rewardsInfo
		else
			reward = rewardsInfo[i]
		end
		local cell = state_machine.excute("service_carnival_reward_review_list_create", nil, {rewardInfo = reward, rankNum = i, index = i, curLevel = curIndex, type = self.m_type})
		self.ListView_reward_yulan:addChild(cell)
	end

	self.ListView_reward_yulan:jumpToTop()
	self.ListView_reward_yulan:requestRefreshView()
	self.listViewPosY = self.ListView_reward_yulan:getInnerContainer():getPositionY()
	local function listViewListener(sender, evenType)
		self:updateListView()
	end
	self.ListView_reward_yulan:addScrollViewEventListener(listViewListener)
	
end

-- 对象初始化
function ServiceCarnivalRewardReview:init(params)
	self.m_type = params.type
	self.click_indx = params.clickIndx
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ServiceCarnivalRewardReview:onUpdateDraw()
	local root = self.roots[1]

	-- 关卡星级排行奖励
	self.Text_checkpoint = ccui.Helper:seekWidgetByName(root, "Text_checkpoint")
	table.insert(self.Text_rankList , self.Text_checkpoint)

	-- 战力星级排行奖励
	self.Text_CR_rank = ccui.Helper:seekWidgetByName(root, "Text_CR_rank")
	table.insert(self.Text_rankList , self.Text_CR_rank)

	-- 星级排行奖励
	self.Text_star = ccui.Helper:seekWidgetByName(root, "Text_star")
	table.insert(self.Text_rankList , self.Text_star)

	-- 预览獎勵列表容器
	self.ListView_reward_yulan = ccui.Helper:seekWidgetByName(root, "ListView_reward_yulan")

	-- 提示文本
	self.Text_tips = ccui.Helper:seekWidgetByName(root, "Text_tips")

	for i, v in ipairs(self.Text_rankList) do
		self.Text_rankList[i]:setVisible(false)
	end

	self:updateDrawContent()
end

function ServiceCarnivalRewardReview:onEnterTransitionFinish()
	-- 加载ServiceCarnivalRewardReviewWindow界面资源.
	-- res.activity.service_carnival.service_carnival_reward_review = res/activity/service_carnival/service_carnival_reward_review.csb
	local csbNode = csb.createNode("activity/service_carnival/service_carnival_reward_review.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil,
	{
		terminal_name = "service_carnival_reward_review_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function ServiceCarnivalRewardReview:onExit()
	-- 释放ServiceCarnivalRewardReviewWindow界面资源.
	state_machine.remove("service_carnival_reward_review_open")
	state_machine.remove("service_carnival_reward_review_close")
	state_machine.remove("service_carnival_reward_review_show")
	state_machine.remove("service_carnival_reward_review_hide")
end

function ServiceCarnivalRewardReview:close()
	-- window event : close.
	
end

function ServiceCarnivalRewardReview:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
