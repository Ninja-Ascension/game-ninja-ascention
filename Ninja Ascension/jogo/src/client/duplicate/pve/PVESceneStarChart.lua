-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE场景星数排行榜
-------------------------------------------------------------------------------------------------------
PVESceneStarChart = class("PVESceneStarChartClass", Window)

function PVESceneStarChart:ctor()
    self.super:ctor()
    self.roots = {}
	self.eliteStar = {} -- --全服副本星数排行信息_ED.charts.elite_star
	self.order = ""  						--用户排名
	self.user_name = _ED.user_info.user_name	--用户名
	self.order_value = _ED.total_star_count		--用户总星数
	self.currentPageType = 0 -- 1 普通副本 2 精英副本

	
	app.load("client.cells.copy.plot_copy_start")
    -- Initialize PVESceneStarChart page state machine.
    local function init_pve_scene_star_chart_terminal()	
		--关闭当前窗口
		local pve_scene_star_close_terminal = {
            _name = "pve_scene_star_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- fwin:close(instance)
				fwin:close(fwin:find("PVESceneStarChartClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(pve_scene_star_close_terminal)
        state_machine.init()
    end    
    -- call func init PVESceneStarChart state machine.
    init_pve_scene_star_chart_terminal()
end

function PVESceneStarChart:onUpdateDraw()
	local ListView_1 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_1")
	for i = 1,table.getn(self.eliteStar) do
		cell = PlotCopyStart:createCell()
		cell:init(self.eliteStar[i],i)
		ListView_1:addChild(cell)
	end
	ListView_1:requestRefreshView()
	--检查用户自己是否在排名中
	for i, v in pairs(_ED.charts.elite_star) do
		if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
			self.order = v.order
		end
	end
	if self.order == "" then
		self.order = tipStringInfo_trialTower[3]
	end
	
	local charts 	= ccui.Helper:seekWidgetByName(self.roots[1], "Text_mingci_2")
	local name 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_name_2")
	local start 	= ccui.Helper:seekWidgetByName(self.roots[1], "Text_star_2")
	
	charts:setString(self.order)
	name:setString(self.user_name)
	start:setString(self.order_value)
	if ___is_open_leadname == true then
		name:setFontName("")
		name:setFontSize(name:getFontSize())
	end
end

function PVESceneStarChart:init(pageType)
	self.eliteStar = _ED.charts.elite_star
	self.order = ""  						--用户排名
	self.user_name = _ED.user_info.user_name	--用户名
	self.currentPageType = pageType
	if zstring.tonumber(self.currentPageType) == 1 then
		self.order_value = _ED.total_star_count		--用户总星数
	else
		self.order_value = _ED.elite_star_count		--用户总星数
	end
end

function PVESceneStarChart:onEnterTransitionFinish()
	local csbPveDuplicate = csb.createNode("duplicate/pve_leaderboard.csb")
	local action = csb.createTimeline("duplicate/pve_leaderboard.csb")
	local root = csbPveDuplicate:getChildByName("root")
	csbPveDuplicate:runAction(action)
	table.insert(self.roots, root)
    self:addChild(csbPveDuplicate)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	-- local csbPveDuplicate = csb.createNode("duplicate/pve_leaderboard.csb")
    -- local root = csbPveDuplicate:getChildByName("root")
	-- root:removeFromParent()
	-- table.insert(self.roots, root)
    -- self:addChild(root)
	
	local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"), nil, {terminal_name = "pve_scene_star_close", terminal_state = 0}, nil, 2)


	local function responseDrawStarRewardCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node == nil or response.node.init == nil then
				return
			end
			response.node:init(response.node.currentPageType)
			response.node:onUpdateDraw()
		else
			-- error tip
			--> print("副本星数:", _ED.charts.elite_star)
		end
	end

	
	if self.currentPageType == 1 then 
		protocol_command.search_order_list.param_list = "6"
	else
		protocol_command.search_order_list.param_list = "15"
	end
	NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, self, responseDrawStarRewardCallback, false, nil)
end

function PVESceneStarChart:onExit()
	state_machine.remove("pve_scene_star_close")
end