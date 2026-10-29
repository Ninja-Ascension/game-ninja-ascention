-- ----------------------------------------------------------------------------------------------------
-- 说明：三国无双排行榜界面
-- 创建时间
-- 作者：杨俊
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
PaiHang = class("PaiHangClass", Window)
    
function PaiHang:ctor()
    self.super:ctor()
	app.load("client.campaign.trialtower.ArrangeList")
	
	self.roots = {}
	self.actions = {}
    self.one_index = { -- 格式数据
		-- {id = 1, name = game_infomation_tip_str[4],star = game_infomation_tip_str[14]},
		-- {id = 2, name = game_infomation_tip_str[5],star = game_infomation_tip_str[15]},
		-- {id = 3, name = game_infomation_tip_str[6],star = game_infomation_tip_str[16]},
		
	}
	
	self.myselfRankingInformation = {
		id = tipStringInfo_trialTower[3], 
		name = _ED.user_info.user_name, 
		star = _ED.three_kingdoms_view.history_max_stars
	}
	
    -- Initialize PaiHang page state machine.
    local function init_trial_tower_terminal()
		--三国无双里面的排行榜
		local PaiHang_back_activity_terminal = {
            _name = "PaiHang_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
              
				--fwin:close(instance)
				instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--三国无双里面的排行榜关闭
		local PaiHang_back_button_terminal = {
            _name = "PaiHang_back_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
              
				--fwin:close(instance)
				instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- state_machine.add(trial_tower_back_activity_terminal)
		state_machine.add(PaiHang_back_activity_terminal)
		state_machine.add(PaiHang_back_button_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_trial_tower_terminal()
end

function PaiHang:checkupMe()
	for i, v in ipairs(_ED.charts.three_kingdoms) do
		if v.user_id == _ED.user_info.user_id then
			self.myselfRankingInformation.id = i
			self.myselfRankingInformation.star = v.user_fighting
			break
		end
	end
end

function PaiHang:updateDrawPlayerRankingInformation()
	local root = self.roots[1]
	-- for i,v in pairs(sortEquip) do
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	listView:removeAllItems()
	for i= 1 ,table.getn(self.one_index) do
		local cell = ArrangeList:createCell()
		cell:init(self.one_index[i],i)
		listView:addChild(cell)
	end
end

function PaiHang:updateDrawMyselfRankingInformation()
	self:checkupMe()
	local root = self.roots[1]
	local infoPanel = ccui.Helper:seekWidgetByName(root, "Panel_4")
	ccui.Helper:seekWidgetByName(infoPanel, "Text_3"):setString(self.myselfRankingInformation.id)
	ccui.Helper:seekWidgetByName(infoPanel, "Text_3"):enableOutline(cc.c4b(0,0,0,255), 2)
	local Text_1 = ccui.Helper:seekWidgetByName(infoPanel, "Text_1")
	Text_1:setString(self.myselfRankingInformation.name)
	if ___is_open_leadname == true then
        Text_1:setFontName("")
        Text_1:setFontSize(Text_1:getFontSize())
    end
	ccui.Helper:seekWidgetByName(infoPanel, "Text_2"):setString(self.myselfRankingInformation.star..tipStringInfo_trialTower[4])
end

function PaiHang:onEnterTransitionFinish()
    local csbCampaign = csb.createNode("campaign/TrialTower/trial_tower_list.csb")
	local root = csbCampaign:getChildByName("root")	
	table.insert(self.roots, root)
    self:addChild(csbCampaign)
	
	local action = csb.createTimeline("campaign/TrialTower/trial_tower_list.csb") 
    table.insert(self.actions, action )
    csbCampaign:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "ranking_open" then
        elseif str == "ranking_close" then
        	fwin:close(self)
        end
    end)
    action:play("window_open", false)
	
	-- add interface button callback, set machine name 'PaiHang_back_activity'
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, {
		func_string = [[state_machine.excute("PaiHang_back_activity", 0, "PaiHang_back_activity.'")]],
		isPressedActionEnabled = true,
	}, nil, 2)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {
		func_string = [[state_machine.excute("PaiHang_back_button", 0, "PaiHang_back_button.'")]],
		isPressedActionEnabled = true,
	}, nil,2)
	
	
	--解析排行榜
	
	if nil ~= _ED.charts.three_kingdoms then
		self.one_index = {}
		
		for i = 1, table.getn(_ED.charts.three_kingdoms) do
			local item = {
				id = _ED.charts.three_kingdoms[i].order,
				name = _ED.charts.three_kingdoms[i].user_name,
				star = _ED.charts.three_kingdoms[i].user_fighting,
			}
			table.insert(self.one_index, item)
		end
		
	end
	-- draw trial tower moudle interface 
	self:updateDrawPlayerRankingInformation()
	self:updateDrawMyselfRankingInformation()
end




function PaiHang:onExit()
	state_machine.remove("PaiHang_back_activity")
	state_machine.remove("PaiHang_back_button")
end
