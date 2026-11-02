----------------------------------------------------------------------------------------------------
-- 说明：抢夺5次战报列表
-------------------------------------------------------------------------------------------------------
PlunderSpoilsReport = class("PlunderSpoilsReportClass", Window)

function PlunderSpoilsReport:ctor()
    self.super:ctor()
	app.load("client.utils.scene.SceneCacheData")
	app.load("client.campaign.plunder.PlunderSpoilsReportCell")
	
	self.roots = {}
	self.lotteryIsWin = false
	
	local function init_plunder_spoils_report_terminal()
		local plunder_spoils_report_close_terminal = {
            _name = "plunder_spoils_report_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:gotoWin()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(plunder_spoils_report_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_plunder_spoils_report_terminal()
end


function PlunderSpoilsReport:gotoWin()
	-- 抢到了胜利的
	-- 没抢到,但抽到的
	if self.isWin == 1 or self.lotteryIsWin == true then
		-- 获得了,填入得到
		-----------记录当前场景缓存数据
		local cacheName = SceneCacheNameEnum.PLUNDER
		local cacheData = SceneCacheData.read(cacheName)

		if nil == cacheData then
			cacheData = SceneCacheData.getInitExample(cacheName)
		end
		cacheData.isWin = true
		cacheData.rewardMouldId = tonumber(self.mouldId)
		SceneCacheData.write(cacheName, cacheData)
		--如果抢到了，重绘page页面，关闭掉抢夺列表。
		--没抢到，不重绘，不关闭列表。
		state_machine.excute("plunder_update_pageview_update_all",0,1)
		state_machine.excute("plunder_list_close_from_challenge",0,"")
	else
		state_machine.excute("plunder_update_pageview_update_all",0,0)
	end
	fwin:close(self)
	
	-- 跳回 抢夺主页
	--fwin:removeAll()
	--fwin:open(Menu:new(), fwin._taskbar)
end

-- 更新画面
function PlunderSpoilsReport:onUpdateDraw()
	self.lotteryIsWin = false
	app.load("client.utils.scene.SceneCacheData")
	local cacheName = SceneCacheNameEnum.PLUNDER
	local cacheData = SceneCacheData.read(cacheName)

	local reportListView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_2")	-- 要添加的地方
	reportListView:removeAllItems()
	
	self.isWin = tonumber(_ED.grab.launch_ten.grab_isTrue)

	local mid = nil
	local height = nil
	for i = 1,tonumber(_ED.grab.launch_ten.count) do
		local item = _ED.grab.launch_ten.infos[i]
		local cell = PlunderSpoilsReportCell:createCell()
		if i == tonumber(_ED.grab.launch_ten.count) then
			if self.isWin == 1 then
				mid = self.mouldId
			end
		end
		local config = cell:createConfig(mid,
					i,
					item.grab_exp,
					item.grab_silver,
					item.grab_spoils_id,
					item.grab_spoils_type,
					item.grab_spoils_count
					)
		
		cell:init(config)
		reportListView:addChild(cell)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			height = cell:getContentSize().height
		end
		if tonumber(item.grab_spoils_id) == tonumber(self.mouldId) then
			--检查是否为我要抢的id
			self.lotteryIsWin = true 
		end
	end

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		if tonumber(_ED.grab.launch_ten.count) > 3 then
			reportListView:getInnerContainer():setPositionY(height*(tonumber(_ED.grab.launch_ten.count)-3))
		end
	end
end

function PlunderSpoilsReport:onEnterTransitionFinish()
	local csbItem = csb.createNode("campaign/Snatch/snatch_results.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_1"), nil, 
	{
		terminal_name = "plunder_spoils_report_close", 
		terminal_state = nil,
		cell = self,
		isPressedActionEnabled = true,
	},
	nil, 2)
end

function PlunderSpoilsReport:onExit()
	state_machine.remove("plunder_spoils_report_close")
end

function PlunderSpoilsReport:init(mouldId)
	self.mouldId = mouldId
end