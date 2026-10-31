----------------------------------------------------------------------------------------------------
-- 说明：三国无双一键3星的战报列表
-------------------------------------------------------------------------------------------------------
TrialTowerSpoilsReport = class("TrialTowerSpoilsReportClass", Window)

function TrialTowerSpoilsReport:ctor()
    self.super:ctor()
	app.load("client.l_digital.campaign.trialtower.TrialTowerSpoilsReportCell")
	app.load("client.l_digital.campaign.trialtower.TrialTowerSpoilsReportRewardCell")
	
    -- 定义封装类中的变量
	self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.actions = {}

	
	local function init_trial_tower_spoils_report_terminal()
		local trial_tower_spoils_report_close_terminal = {
            _name = "trial_tower_spoils_report_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance.actions[1]:play("window_close", false)
				state_machine.excute("trialtower_sweep_end", 0, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(trial_tower_spoils_report_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_trial_tower_spoils_report_terminal()
end


function TrialTowerSpoilsReport:gotoWin()
	
end

-- 更新画面
function TrialTowerSpoilsReport:onUpdateDraw()
	
	if nil == _ED.sweep_kingdoms then
		return
	end
	
	local reportListView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_01")	-- 要添加的地方
	reportListView:removeAllItems()
	
	local height = 0
	
	-- 遍历普通奖励
	for i = 1 , _ED.sweep_kingdoms.battleRewardCount do
		local cell = TrialTowerSpoilsReportCell:createCell()
		local item = _ED.sweep_kingdoms.battleReward[i]
		cell:init(self.level + i -1,item[1],item[2],item[3],item[4])
		reportListView:addChild(cell)
		
		height = height + cell:getContentSize().height
		
	end
	reportListView:requestRefreshView()
	
	-- 通关奖励
	local list = {}
	for i =1, _ED.sweep_kingdoms.examRewardCount do
		local item = {
			mid = _ED.sweep_kingdoms.examReward[i][1] ,
			count = _ED.sweep_kingdoms.examReward[i][3] ,
			mouldType = _ED.sweep_kingdoms.examReward[i][2],
		}
		table.insert(list, item)
	end
	
	local rewardCell = TrialTowerSpoilsReportRewardCell:createCell()
	rewardCell:init(self.level, list, self.endlevel)
	reportListView:addChild(rewardCell)
	
	height = height + rewardCell:getContentSize().height
	
	reportListView:requestRefreshView()
	
	local lsize = reportListView:getContentSize()
	local csize = reportListView:getInnerContainer():getContentSize()

	reportListView:getInnerContainer():runAction(cc.MoveTo:create(1, cc.p(0,height - lsize.height)))
end

function TrialTowerSpoilsReport:onEnterTransitionFinish()
	local csbItem = csb.createNode("campaign/TrialTower/trial_tower_raids.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	
	local action = csb.createTimeline("campaign/TrialTower/trial_tower_raids.csb") 
    table.insert(self.actions, action )
    root:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()

        if str == "open" then
        elseif str == "close" then
        	fwin:close(self)
        end
    end)
    action:play("window_open", false)
	
	
	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_01"), nil, 
	{
		terminal_name = "trial_tower_spoils_report_close", 
		terminal_state = nil,
		cell = self,
		isPressedActionEnabled = true
	},
	nil, 2)	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_305"), nil, 
	{
		terminal_name = "trial_tower_spoils_report_close", 
		terminal_state = nil,
		cell = self,
		isPressedActionEnabled = true
	},
	nil, 2)	
	
end

function TrialTowerSpoilsReport:onExit()
	state_machine.remove("trial_tower_spoils_report_close")
end

function TrialTowerSpoilsReport:init(npcIndex,currentIndex)
	self.npcIndex = npcIndex
	self.currentIndex = currentIndex

	if __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		self.level = npcIndex
		self.endlevel = self.level + (3 - self.currentIndex)
	else
		self.level = npcIndex - (currentIndex + 1)
		
		self.endlevel = self.level + (2 - self.currentIndex)
	end
end