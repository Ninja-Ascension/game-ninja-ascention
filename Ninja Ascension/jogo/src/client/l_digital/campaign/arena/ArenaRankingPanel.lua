-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场排行榜
-- 创建时间：2015-04-01
-- 作者：刘迎
-- 修改记录：界面呈现 功能实现
-- 最后修改人：刘迎
-------------------------------------------------------------------------------------------------------

ArenaRankingPanel = class("ArenaRankingPanelClass", Window)

--打开界面
local sm_arena_ranking_panel_open_terminal = {
	_name = "sm_arena_ranking_panel_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("ArenaRankingPanelClass") == nil then
			fwin:open(ArenaRankingPanel:new(),_view)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_arena_ranking_panel_open_terminal)
state_machine.init()
    
function ArenaRankingPanel:ctor()
    self.super:ctor()
    self.roots = {}
	
	app.load("client.l_digital.cells.arena.arena_ranking_seat_cell")
	app.load("client.player.PlayerReviewInfomation")
	
	--缓存listview
	self.cacheListView = nil
	
	--缓存我的排行
	self.cacheMyRankText = nil
	
    -- Initialize ArenaRankingPanel page state machine.
    local function init_arena_ranking_panel_terminal()
	
		--关闭面板
		local arena_ranking_panel_close_terminal = {
            _name = "arena_ranking_panel_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- fwin:open(Campaign:new(), fwin._view)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--查看别人的阵容数据
		local arena_ranking_review_opponent_terminal = {
            _name = "arena_ranking_review_opponent",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local seat = params._datas.reviewOpponent
				local pri = PlayerReviewInfomation:new()
				pri:init(seat.roleInstance.user_id)
				fwin:open(pri, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(arena_ranking_panel_close_terminal)
		state_machine.add(arena_ranking_review_opponent_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_ranking_panel_terminal()
end

function ArenaRankingPanel.loading_cell()
	if ArenaRankingPanel.cacheListView == nil then
		return
	end	

	local arsc = ArenaRankingSeatCell:createCell()
	arsc:init(_ED.arena_rank_user[ArenaRankingPanel.asyncIndex])
	ArenaRankingPanel.cacheListView:addChild(arsc)
	ArenaRankingPanel.cacheListView:requestRefreshView()
	ArenaRankingPanel.asyncIndex = ArenaRankingPanel.asyncIndex + 1
end

function ArenaRankingPanel:initDraw()
	
	self.cacheMyRankText:setString(_ED.arena_user_rank)
	
	--添加列表
	for i, v in ipairs(_ED.arena_rank_user) do
		local arsc = ArenaRankingSeatCell:createCell()
		arsc:init(v, i)
		self.cacheListView:addChild(arsc)
	end
	self.cacheListView:requestRefreshView()
	
	self.currentInnerContainer = self.cacheListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function ArenaRankingPanel:onUpdate(dt)
	if self.cacheListView ~= nil and self.currentInnerContainer ~= nil then
		local size = self.cacheListView:getContentSize()
		local posY = self.currentInnerContainer:getPositionY()
		if self.currentInnerContainerPosY == posY then
			return
		end
		self.currentInnerContainerPosY = posY
		local items = self.cacheListView:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
				v:unload()
			else
				v:reload()
			end
		end
	end
end

--通过目标排名过去配置中的行数
function ArenaRankingPanel:getArenaRewardRowForRank(userRank)
	local nextIndex = 1
	for i, v in ipairs(dms["arena_reward_param"]) do
		local minRank = dms.int(dms["arena_reward_param"], i, arena_reward_param.arena_order_begin)
		local maxRank = dms.int(dms["arena_reward_param"], i, arena_reward_param.arena_order_end)
		nextIndex = i + 1
		if userRank >= minRank and userRank <= maxRank then
			return i
		end
	end
	return nextIndex
end

function ArenaRankingPanel:reviseListviewSize(listview)
	if #listview:getItems() <= 0 then return end
	local listviewContentSize = listview:getContentSize()
	local tmpContentSize = listview:getItem(0):getContentSize()
	tmpContentSize.height = tmpContentSize.height * #listview:getItems()
	listview:getInnerContainer():setContentSize(tmpContentSize)
	listviewContentSize.width = tmpContentSize.width
	listview:setContentSize(listviewContentSize)
end

--请求竞技场初始化数据
function ArenaRankingPanel:requestInitDatas()
	local function responseArenaRankingPanelInitCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node == nil or response.node.roots == nil then
				return
			end
			response.node:initDraw()
		end
	end
	
	protocol_command.arena_order.param_list = "0"
	NetworkManager:register(protocol_command.arena_order.code, nil, nil, nil, self, responseArenaRankingPanelInitCallback, false, nil)
end

function ArenaRankingPanel:onEnterTransitionFinish()
	
    local csbArenaRankPanel = csb.createNode("campaign/ArenaStorage/ArenaStorage_ranking.csb")
	local root = csbArenaRankPanel:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaRankPanel)
	
	--缓存listview
	self.cacheListView = ccui.Helper:seekWidgetByName(root, "ListView_jjc_ph")
	
	--缓存我的排行
	self.cacheMyRankText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_2")

	
	--添加返回点击事件
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jjc_ph_close"), 	nil, 
	{
		terminal_name = "arena_ranking_panel_close", 	
		next_terminal_name = "arena_ranking_panel_close", 	
		current_button_name = "Button_jjc_ph_close",		
		but_image = "ranking_panel_close",	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	self:requestInitDatas()

	app.load("client.player.UserInformationHeroStorage")
    local userInformationHeroStorage = UserInformationHeroStorage:new()
    userInformationHeroStorage._rootWindows = self
    fwin:open(userInformationHeroStorage,fwin._view)
end

--关闭所有按钮的高亮显示
function ArenaRankingPanel:closeHighlighted()
end

function ArenaRankingPanel:onExit()
	ArenaRankingPanel.asyncIndex = 1
	ArenaRankingPanel.cacheListView = nil

	state_machine.remove("arena_ranking_panel_close")
	state_machine.remove("arena_ranking_review_opponent")
end
