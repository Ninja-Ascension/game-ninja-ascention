--[[ ----------------------------------------------------------------------------
-- 奖励预览
--]] ----------------------------------------------------------------------------
CrossTotalWarPreview = class("CrossTotalWarPreviewClass", Window)

-- 打开窗口
local cross_total_war_preview_window_open_terminal = {
	_name = "cross_total_war_preview_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CrossTotalWarPreviewClass") then
			fwin:open(CrossTotalWarPreview:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local cross_total_war_preview_window_close_terminal = {
	_name = "cross_total_war_preview_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CrossTotalWarPreviewClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(cross_total_war_preview_window_open_terminal)
state_machine.add(cross_total_war_preview_window_close_terminal)
state_machine.init()

-- 构造器
function CrossTotalWarPreview:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.curReward = 0
	self.RewardBtn = {}

	-- var

	-- load lua files.
	app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarRankCell")

	-- Initialize cross total war preview page state machine.
	local function init_cross_total_war_preview_terminal()
		-- 打开角色创建窗口
		local cross_total_war_preview_open_terminal = {
			_name = "cross_total_war_preview_open",
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
		local cross_total_war_preview_close_terminal = {
			_name = "cross_total_war_preview_close",
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
		local cross_total_war_preview_show_terminal = {
			_name = "cross_total_war_preview_show",
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
		local cross_total_war_preview_hide_terminal = {
			_name = "cross_total_war_preview_hide",
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

		state_machine.add(cross_total_war_preview_open_terminal)
		state_machine.add(cross_total_war_preview_close_terminal)
		state_machine.add(cross_total_war_preview_show_terminal)
		state_machine.add(cross_total_war_preview_hide_terminal)
		state_machine.init()
	end
	-- call func init cross total war preview state machine.
	init_cross_total_war_preview_terminal()
end

-- 对象初始化
function CrossTotalWarPreview:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CrossTotalWarPreview:onUpdateDraw()
	local root = self.roots[1]

	-- 全部奖励显示1为预赛，2为决赛，3为点赞奖励，4为全服奖励，5为预测奖励
	
	self.Button_ysjl = ccui.Helper:seekWidgetByName(root, "Button_ysjl") --1为预赛
	self.Button_ysjl.rewardType = 1
	self.Button_jsjl = ccui.Helper:seekWidgetByName(root, "Button_jsjl") --2为决赛
	self.Button_jsjl.rewardType = 2
	self.Button_qfjl = ccui.Helper:seekWidgetByName(root, "Button_qfjl")  --4为全服奖励
	self.Button_qfjl.rewardType = 4
	self.Button_dzjl = ccui.Helper:seekWidgetByName(root, "Button_dzjl") --5为预测奖励
	self.Button_dzjl.rewardType = 5

	ccui.Helper:seekWidgetByName(root, "Text_ranking_n"):setString(_ED.cross_arena_data.myRank)

	self.ListView_preview = ccui.Helper:seekWidgetByName(root, "ListView_preview") 


	table.insert(self.RewardBtn,self.Button_ysjl)
	table.insert(self.RewardBtn,self.Button_jsjl)
	table.insert(self.RewardBtn,self.Button_jsjl)
	table.insert(self.RewardBtn,self.Button_qfjl)
	table.insert(self.RewardBtn,self.Button_dzjl)

	local function func_reward(sender, eventType)
		if eventType == ccui.TouchEventType.ended then
			self:changePage(sender.rewardType)
		end
   end
   self.Button_ysjl:addTouchEventListener(func_reward)
   self.Button_jsjl:addTouchEventListener(func_reward)
   self.Button_qfjl:addTouchEventListener(func_reward)
   self.Button_dzjl:addTouchEventListener(func_reward)
	
   self:changePage(1)
end

function CrossTotalWarPreview:changePage(type)
	self.RewardBtn[type]:setEnabled(false)
	self.RewardBtn[type]:setBright(false)
	if self.RewardBtn[self.curReward] then
		self.RewardBtn[self.curReward]:setEnabled(true)
		self.RewardBtn[self.curReward]:setBright(true)
	end
	self.curReward = type

	local re = dms.searchs(dms["cross_arena_rank"], 2,type)
	self.ListView_preview:removeAllItems()
	self.ListView_preview:removeAllChildren(true)
	local myrank = nil
	for k,v in pairs(re) do
		local ele = {}
		ele.rank = k
		ele.reward = v
		ele.type = type
		local cell = state_machine.excute("cross_total_war_rank_cell_create",0, ele)
		self.ListView_preview:addChild(cell)
	end
	self.ListView_preview:jumpToTop()
	self.ListView_preview:refreshView()
	self.ListView_preview_poy = self.ListView_preview:getInnerContainer():getPositionY()
end
function CrossTotalWarPreview:onEnterTransitionFinish()
	-- 加载CrossTotalWarPreviewWindow界面资源.
	-- res.campaign.cross_total_war.cross_total_war_preview = res/campaign/cross_total_war/cross_total_war_preview.csb
	local csbNode = csb.createNode("campaign/cross_total_war/cross_total_war_preview.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "cross_total_war_preview_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

-- @onUpdate(dt)
function CrossTotalWarPreview:onUpdate(dt)
	
	if self.ListView_preview ~= nil then
		local size = self.ListView_preview:getContentSize()
		local posY = self.ListView_preview:getInnerContainer():getPositionY()
		if self.ListView_preview_poy == posY then
			return
		end
		self.ListView_preview_poy = posY
		local items = self.ListView_preview:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then	
					v:unload()		
			else	
					v:reload()				
			end
		end
	end
end

function CrossTotalWarPreview:onExit()
	-- 释放CrossTotalWarPreviewWindow界面资源.
	state_machine.remove("cross_total_war_preview_open")
	state_machine.remove("cross_total_war_preview_close")
	state_machine.remove("cross_total_war_preview_show")
	state_machine.remove("cross_total_war_preview_hide")
end

function CrossTotalWarPreview:close()
	-- window event : close.
	
end

function CrossTotalWarPreview:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
