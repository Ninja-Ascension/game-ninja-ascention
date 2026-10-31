-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场排行榜
-- 创建时间：2015-04-01
-- 作者：刘迎
-- 修改记录：界面呈现 功能实现
-- 最后修改人：刘迎
-------------------------------------------------------------------------------------------------------

ArenaRankingPanel = class("ArenaRankingPanelClass", Window)
    
function ArenaRankingPanel:ctor()
    self.super:ctor()
    self.roots = {}
	
	app.load("client.cells.campaign.arena_ranking_seat_cell")	
	app.load("client.player.PlayerReviewInfomation")
	
	--缓存listview
	self.cacheListView = nil
	
	--缓存我的排行
	self.cacheMyRankText = nil
	
	--目标排名*
	self.cacheTargetRankText = nil
	
	--目标奖励荣誉*
	self.cacheTargetHonorText = nil
	
	--目标奖励银子*
	self.cacheTargetCoinText = nil
	
	--奖励道具*
	self.cacheTargetNumsText = nil
	
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
	
	---[[
	self.cacheMyRankText:setString(_ED.arena_user_rank)
	
	--获取目标排名
	local targetRankRow = self:getArenaRewardRowForRank(tonumber(_ED.arena_user_rank)) - 1
	if targetRankRow < 1 then
		targetRankRow = 1
	end	

	local maxRank = dms.int(dms["arena_reward_param"], targetRankRow, arena_reward_param.arena_order_end)
	self.cacheTargetRankText:setString(maxRank)

	-- --目标奖励荣誉*
	local targetHonor = dms.int(dms["arena_reward_param"], targetRankRow, arena_reward_param.arena1_reward_bounty)
	self.cacheTargetHonorText:setString(targetHonor)

	-- --目标奖励银子*
	local targetCoin = dms.int(dms["arena_reward_param"], targetRankRow, arena_reward_param.arena1_reward_silver)
	self.cacheTargetCoinText:setString(targetCoin)
	
	-- --奖励道具*
	local targetItemNums = dms.int(dms["arena_reward_param"], targetRankRow, arena_reward_param.arena1_reward_prop_count)
	self.cacheTargetNumsText:setString(targetItemNums)
	
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- ArenaRankingPanel.asyncIndex = 1
	-- ArenaRankingPanel.cacheListView = self.cacheListView
	--添加列表
	for i, v in ipairs(_ED.arena_rank_user) do
		--cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell)
		local arsc = ArenaRankingSeatCell:createCell()
		arsc:init(v, i)
		self.cacheListView:addChild(arsc)
	end
	self.cacheListView:requestRefreshView()
	
	--重置listview的size
	--self:reviseListviewSize(self.cacheListView)
	--]]
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
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
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

	-- 协议对照表
	-- -------------------------------------------------------------------------------------------------------
	-- parse_return_arena_order 62
	-- -------------------------------------------------------------------------------------------------------
	-- function parse_return_arena_order(interpreter,datas,pos,strDatas,list,count)
		-- _ED.arena_rank_type_id = npos(list)
		-- _ED.arena_rank_cur = npos(list)
		-- _ED.arena_rank_user_number = npos(list)
		-- for i=1, _ED.arena_rank_user_number do
			-- local arenaRank = {
				-- user_id = npos(list),
				-- user_icon = npos(list),
				-- user_template = {
					-- npos(list),
					-- npos(list),
					-- npos(list),
					-- npos(list),
				-- },
				-- user_rank = npos(list),
				-- user_name = npos(list),
				-- user_level = npos(list),
				-- user_army_name = npos(list),
				-- user_reward_gold = npos(list),
				-- user_reward_reputation = npos(list),
			-- }
			-- _ED.arena_rank_user[i] = arenaRank
		-- end
	-- end

	---[[
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		self:initDraw()
		self:updateMyRankInfo()
	else
		local function responseArenaRankingPanelInitCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_yugioh then
					if response.node == nil or response.node.roots == nil then
						return
					end
				end
				response.node:initDraw()
				response.node:updateMyRankInfo()
			end
		end
		
		protocol_command.arena_order.param_list = "0"
		NetworkManager:register(protocol_command.arena_order.code, nil, nil, nil, self, responseArenaRankingPanelInitCallback, false, nil)
	end
	--]]
end

--撸向服务器 我要查别人的阵容啊啊啊
-- function ArenaRankingPanel:requestRankingDatas(prodID, nums)
	-- ---[[
	-- local function responseArenaRankingDatasCallback(response)
		-- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			-- -- self:initDraw()
			--> print("服务器数据来了。。。")
			-- TipDlg.drawTextDailog(_string_piece_info[76])
			
			-- --更新数据
			-- --设置可用的荣誉值
			-- self.cacheHonorText:setString(_ED.user_info.user_honour)
			-- for i, v in pairs(self.cacheListView:getItems()) do
				--> print("zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz", self.currentBuyId)
				-- if tonumber(v.seatIndex) == tonumber(self.currentBuyId) then
					-- v:updateDataForProdID(self.currentBuyId, self.currentBuyNums)
					-- break
				-- end
			-- end
		-- end
	-- end
	
	-- protocol_command.arena_shop_exchange.param_list = prodID .. "\r\n" .. nums
	-- NetworkManager:register(protocol_command.arena_shop_exchange.code, nil, nil, nil, nil, responseArenaRankingDatasCallback, true, nil)
	-- --]]
-- end



function ArenaRankingPanel:updateMyRankInfo()
	function getSectionIndex(userRank)
		-- 获取该排名的区间索引
		for i, v in ipairs(dms["arena_reward_param"]) do
			local minRank = dms.int(dms["arena_reward_param"], i, arena_reward_param.arena_order_begin)
			local maxRank = dms.int(dms["arena_reward_param"], i, arena_reward_param.arena_order_end)
			if userRank > minRank and userRank < maxRank or userRank == minRank or userRank == maxRank then
				return i
			end
		end
		return 0
	end
	
	self.rankInfoPanel:setVisible(false)
	self.boundaryText:setVisible(false)
	
	-- 取配置文件的排名区间
	--local boundaryRankNum = dms.int(dms["pirates_config"], 286, pirates_config.param)
	
	-- 从竞技场排名模板的末尾名
	local rewardData = dms["arena_reward_param"]
	local boundaryRankNum = dms.int(rewardData, #rewardData, arena_reward_param.arena_order_end)
	
	-- 取自己的排名
	local myRankIndex = tonumber(_ED.arena_user_rank)

	if myRankIndex <= boundaryRankNum then
		-- 显示具体的内容
		
		-- 取自己排名位的模板数据
		local sectionIndex = getSectionIndex(myRankIndex)

		-- 奖励荣誉*
		local targetHonor = dms.int(dms["arena_reward_param"], sectionIndex, arena_reward_param.arena1_reward_bounty)
		self.cacheMyHonorText:setString(targetHonor)

		-- 奖励银子*
		local targetCoin = dms.int(dms["arena_reward_param"], sectionIndex, arena_reward_param.arena1_reward_silver)
		self.cacheMyCoinText:setString(targetCoin)

		-- 奖励道具*
		local targetItemNums = dms.int(dms["arena_reward_param"], sectionIndex, arena_reward_param.arena1_reward_prop_count)
		self.cacheMyNumsText:setString(targetItemNums)

		self.rankInfoPanel:setVisible(true)
	else
		-- 显示文本
		self.boundaryText:setString(string.format(tipStringInfo_arena[3],boundaryRankNum))
		self.boundaryText:setVisible(true)
	end

end


function ArenaRankingPanel:onEnterTransitionFinish()
	
    local csbArenaRankPanel = csb.createNode("campaign/ArenaStorage/ArenaStorage_ranking.csb")
	local action = csb.createTimeline("campaign/ArenaStorage/ArenaStorage_ranking.csb")
	local root = csbArenaRankPanel:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaRankPanel)
	
	csbArenaRankPanel:runAction(action)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	--------------------------------------------------------------------------------
	-- 0409新增文本
	
	--奖励信息容器
	self.rankInfoPanel = ccui.Helper:seekWidgetByName(root, "Panel_jjc_04")
	self.rankInfoPanel:setVisible(false)
	
	--荣誉
	self.cacheMyHonorText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_7_0")
	
	--金钱
	self.cacheMyCoinText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_8_0")
	
	--突破石 道具
	self.cacheMyNumsText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_9_0")
	
	--低于排名分界显示的文本
	self.boundaryText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_5")
	self.boundaryText:setVisible(false)
	
	--------------------------------------------------------------------------------
	
	--缓存listview
	self.cacheListView = ccui.Helper:seekWidgetByName(root, "ListView_jjc_ph")
	
	--缓存我的排行
	self.cacheMyRankText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_2")
	
	--目标排名*
	self.cacheTargetRankText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_4")
	
	--目标奖励荣誉*
	self.cacheTargetHonorText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_7")
	
	--目标奖励银子*
	self.cacheTargetCoinText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_8")
	
	--奖励道具*
	self.cacheTargetNumsText = ccui.Helper:seekWidgetByName(root, "Text_jjc_ph_9")
	
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
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jjc_ph_gb"), 	nil, 
	{
		terminal_name = "arena_ranking_panel_close", 	
		next_terminal_name = "arena_ranking_panel_close", 	
		current_button_name = "Button_jjc_ph_gb",		
		but_image = "ranking_panel_close",	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	self:requestInitDatas()
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
