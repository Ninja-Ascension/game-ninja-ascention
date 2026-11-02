-- ----------------------------------------------------------------------------------------------------
-- 说明：战地争霸排名奖励界面
-------------------------------------------------------------------------------------------------------
ArenaRewardRankingTab = class("ArenaRewardRankingTabClass", Window)

local arena_reward_ranking_tab_open_terminal = {
    _name = "arena_reward_ranking_tab_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRewardRankingTabClass")
        if nil == _homeWindow then
    		fwin:open(ArenaRewardRankingTab:new():init(params[1]), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local arena_reward_ranking_tab_close_terminal = {
    _name = "arena_reward_ranking_tab_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("ArenaRewardRankingTabClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("ArenaRewardRankingTabClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(arena_reward_ranking_tab_open_terminal)
state_machine.add(arena_reward_ranking_tab_close_terminal)
state_machine.init()
    
function ArenaRewardRankingTab:ctor()
    self.super:ctor()
    self.roots = {}
	self._current_page = 0

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil
	
	app.load("client.red_alert_time.cells.arena.arena_reward_rank_cell")
	
	local function init_arena_reward_ranking_tab_terminal()
		local arena_reward_ranking_tab_show_terminal = {
            _name = "arena_reward_ranking_tab_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local arena_reward_ranking_tab_hide_terminal = {
            _name = "arena_reward_ranking_tab_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--领取
		local arena_reward_ranking_tabreceive_terminal = {
            _name = "arena_reward_ranking_tab_receive",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:onUpdateDraw()
                        end
						checkRewardObtainDraw()
                        state_machine.excute("arena_shop_tab_update_honour", 0, "")
                        state_machine.excute("main_window_update_gold_info", 0, "")
					end
				end
				NetworkManager:register(protocol_command.draw_arena_order_reward.code, nil, nil, nil, instance, responseCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
        state_machine.add(arena_reward_ranking_tab_show_terminal)
        state_machine.add(arena_reward_ranking_tab_hide_terminal) 
        state_machine.add(arena_reward_ranking_tabreceive_terminal) 
		state_machine.init()
	end
	
	init_arena_reward_ranking_tab_terminal()
	
end

function ArenaRewardRankingTab:onUpdateDraw()
	local root = self.roots[1]
	--我的排名
	local Text_rank_me_n = ccui.Helper:seekWidgetByName(root, "Text_rank_me_n")
	Text_rank_me_n:setString(_ED.arena_info.settlement_rankings)
	--我的积分
	local Text_integral_me_n = ccui.Helper:seekWidgetByName(root, "Text_integral_me_n")
	Text_integral_me_n:setString(_ED.arena_info.integral)
	
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
	
	-- 取自己的排名
	local myRankIndex = tonumber(_ED.arena_info.settlement_rankings)

	-- 从竞技场排名模板的末尾名
	local rewardData = dms["arena_reward_param"]
	local boundaryRankNum = dms.int(rewardData, #rewardData, arena_reward_param.arena_order_end)
	
	--列表
	local ListView_rank_reward = ccui.Helper:seekWidgetByName(root, "ListView_rank_reward")
    ListView_rank_reward:jumpToTop()
	ListView_rank_reward:removeAllItems()
	local index = 0
	for i, v in ipairs(dms["arena_reward_param"]) do
		local cells = state_machine.excute("arena_reward_rank_cell", 0, i) 
		ListView_rank_reward:addChild(cells)
		index = index + 1
	end
	ListView_rank_reward:requestRefreshView()
    self._list_view = ListView_rank_reward
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
	
	--奖励
	if myRankIndex > 0 then
		-- 取自己排名位的模板数据
		local sectionIndex = getSectionIndex(myRankIndex)
		if sectionIndex == 0 then
			sectionIndex = index
		end
		local rewarld = zstring.split(dms.string(dms["arena_reward_param"], sectionIndex, arena_reward_param.arena_every_reward), "|")
		for i=1,#rewarld do
			local Panel_rank_me_reward = ccui.Helper:seekWidgetByName(root, string.format("Panel_rank_me_reward_%s", i))
			Panel_rank_me_reward:removeAllChildren(true)
			local info = zstring.split(rewarld[i], ",")
			if tonumber(info[1]) == -1 then
				info[1] = resource_prop_id[tonumber(info[2])]
				info[2] = 1
			end
			local prop_type = tonumber(info[2])
			local show_type = 6
			if tonumber(info[2]) == 13 then --坦克
				prop_type = 3
			elseif tonumber(info[2]) == 6 then --道具	
				prop_type = 1
			elseif tonumber(info[2]) == 7 then --配件	
				prop_type = 7
			else
				prop_type = 1
			end
			local cell = state_machine.excute("props_icon_create_cell",0,{show_type, 1, tonumber(info[1]), prop_type, tonumber(info[3])})
			Panel_rank_me_reward:addChild(cell)
		end
    	if tonumber(_ED.arena_info.settlement_state) == 0 then
    		ccui.Helper:seekWidgetByName(root, "Button_reward_receive"):setTouchEnabled(true)
    		ccui.Helper:seekWidgetByName(root, "Button_reward_receive"):setBright(true)
    		ccui.Helper:seekWidgetByName(root, "Button_reward_receive"):setTitleText(arena_tip_text[25]) 
    	else
    		ccui.Helper:seekWidgetByName(root, "Button_reward_receive"):setTouchEnabled(false)
    		ccui.Helper:seekWidgetByName(root, "Button_reward_receive"):setBright(false)
    		ccui.Helper:seekWidgetByName(root, "Button_reward_receive"):setTitleText(arena_tip_text[22]) 
    	end
    end
end

function ArenaRewardRankingTab:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_arrow_down:setVisible(true)
        else
            self._Image_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_arrow_up:setVisible(true)
        else
            self._Image_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
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

function ArenaRewardRankingTab:init(params1)
	self._rootWindows = params1
    self:onInit()
    return self
end

function ArenaRewardRankingTab:onInit()
    local csbArenaRewardRankingTab = nil
    if tonumber(_ED.arena_info.settlement_rankings) <= 0 then
        csbArenaRewardRankingTab = csb.createNode(config_csb.arena.arena_reward_tab_2)
    else
        csbArenaRewardRankingTab = csb.createNode(config_csb.arena.arena_reward_tab_3)
    end
    local root = csbArenaRewardRankingTab:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbArenaRewardRankingTab)
	
	--领取
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reward_receive"), nil, 
    {
        terminal_name = "arena_reward_ranking_tab_receive", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_integral_reward_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_integral_reward_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_arrow_down:stopAllActions()
    self._Image_arrow_up:stopAllActions()
    playActions(self._Image_arrow_down)
    playActions(self._Image_arrow_up)
    self._Image_arrow_down:setVisible(false)
    self._Image_arrow_up:setVisible(false)
	
	self:onUpdateDraw()
end

function ArenaRewardRankingTab:onExit()
    state_machine.remove("arena_reward_ranking_tab_show")
    state_machine.remove("arena_reward_ranking_tab_hide")
    state_machine.remove("arena_reward_ranking_tab_receive")
end