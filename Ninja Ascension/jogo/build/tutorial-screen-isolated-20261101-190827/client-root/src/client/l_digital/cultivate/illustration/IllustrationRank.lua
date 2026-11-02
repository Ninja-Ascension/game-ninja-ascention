--[[ ----------------------------------------------------------------------------
-- 卡册排行榜
--]] ----------------------------------------------------------------------------
IllustrationRank = class("IllustrationRankClass", Window)

-- 打开窗口
local illustration_rank_window_open_terminal = {
	_name = "illustration_rank_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("IllustrationRankClass") then
			fwin:open(IllustrationRank:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local illustration_rank_window_close_terminal = {
	_name = "illustration_rank_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("IllustrationRankClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_rank_window_open_terminal)
state_machine.add(illustration_rank_window_close_terminal)
state_machine.init()

-- 构造器
function IllustrationRank:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.l_digital.cells.cultivate.illustration.illustration_rank_list")
	-- Initialize illustration rank page state machine.
	local function init_illustration_rank_terminal()
		-- 打开角色创建窗口
		local illustration_rank_open_terminal = {
			_name = "illustration_rank_open",
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
		local illustration_rank_close_terminal = {
			_name = "illustration_rank_close",
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
		local illustration_rank_show_terminal = {
			_name = "illustration_rank_show",
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
		local illustration_rank_hide_terminal = {
			_name = "illustration_rank_hide",
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

		state_machine.add(illustration_rank_open_terminal)
		state_machine.add(illustration_rank_close_terminal)
		state_machine.add(illustration_rank_show_terminal)
		state_machine.add(illustration_rank_hide_terminal)
		state_machine.init()
	end
	-- call func init illustration rank state machine.
	init_illustration_rank_terminal()
end

-- 对象初始化
function IllustrationRank:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function IllustrationRank:onUpdateDraw()
	local root = self.roots[1]
	local rankData = _ED.illustration_info_rank
	local rankSize = tonumber(rankData.rankSize)
	local otherData = rankData.rankInfo
	local myData = rankData.myRankInfo
	local myRank = tonumber(rankData.myRank)

	self.ListView_rank = ccui.Helper:seekWidgetByName(root, "ListView_rank")
	self.ListView_rank:removeAllItems()
	if 0 < rankSize then
		for i=1,rankSize do
			local cell = state_machine.excute("illustration_rank_list_create",0,{otherData[i],i})
			self.ListView_rank:addChild(cell)
		end
	end
	
	self.ListView_rank_poy = self.ListView_rank:getInnerContainer():getPositionY()
	self.ListView_rank:requestRefreshView()
	self.ListView_rank:jumpToTop()

	-- 我的排行
	local rankStr = tipStringInfo_illustration_tip[5]
	if 0 < myRank then
		rankStr = ""..myRank
	end
	local Text_ranking_t = ccui.Helper:seekWidgetByName(root, "Text_ranking_t")
	Text_ranking_t:setString(rankStr)
	-- 我的评分
	local Text_card_t = ccui.Helper:seekWidgetByName(root, "Text_card_t")
	Text_card_t:setString(""..myData.score)
end

-- @onUpdate(dt)
function IllustrationRank:onUpdate(dt)
	if self.ListView_rank ~= nil then
		local size = self.ListView_rank:getContentSize()
		local posY = self.ListView_rank:getInnerContainer():getPositionY()
		if self.ListView_rank_poy == posY then
			return
		end
		self.ListView_rank_poy = posY
		local items = self.ListView_rank:getItems()
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

function IllustrationRank:onEnterTransitionFinish()
	-- 加载IllustrationRankWindow界面资源.
	-- res.cultivate.illustration.illustration_rank = res/cultivate/illustration/illustration_rank.csb
	local csbNode = csb.createNode("cultivate/illustration/illustration_rank.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "illustration_rank_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	local function responseRankCallBack( response )
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			self:onUpdateDraw()
		end
	end

	protocol_command.user_card_info_rank.param_list = ""
	NetworkManager:register(protocol_command.user_card_info_rank.code, nil, nil, nil, self, responseRankCallBack, false, nil)
end

function IllustrationRank:onExit()
	-- 释放IllustrationRankWindow界面资源.
	state_machine.remove("illustration_rank_open")
	state_machine.remove("illustration_rank_close")
	state_machine.remove("illustration_rank_show")
	state_machine.remove("illustration_rank_hide")
end

function IllustrationRank:close()
	-- window event : close.
	
end

function IllustrationRank:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
