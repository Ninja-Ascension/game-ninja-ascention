-- ----------------------------------------------------------------------------------------------------
-- 说明：一键三星
-------------------------------------------------------------------------------------------------------

TrialTowerOneKeyThreeStar = class("TrialTowerOneKeyThreeStarClass", Window)
   
local trial_tower_one_key_three_star_window_open_terminal = {
    _name = "trial_tower_one_key_three_star_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("TrialTowerOneKeyThreeStarClass") then
        	
        	local oneKeyWindow = TrialTowerOneKeyThreeStar:new()
			oneKeyWindow:init()
			fwin:open(oneKeyWindow, fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local trial_tower_one_key_three_star_window_close_terminal = {
    _name = "trial_tower_one_key_three_star_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TrialTowerOneKeyThreeStarClass"))
        _ED.one_key_three_kingdoms = nil
        state_machine.excute("trialtower_goto_next_level", 0, nil) 
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(trial_tower_one_key_three_star_window_open_terminal)
state_machine.add(trial_tower_one_key_three_star_window_close_terminal)
state_machine.init()
  
function TrialTowerOneKeyThreeStar:ctor()
    self.super:ctor()
	self.roots = {}
	self._current_index = 0
	self._totalHonour = 0 --总威名
	self._totalSilver = 0 --总银币
	self._propsList = {} --总共获得道具
	self._otherRewardCounts = 0 -- 其他奖励数量
	self._floor = 0
	app.load("client.cells.campaign.trialtower.trial_tower_one_key_addition_list_cell")
	app.load("client.cells.campaign.trialtower.trial_tower_one_key_floor_list_cell")
	app.load("client.cells.campaign.trialtower.trial_tower_one_key_reward_list_cell")
	app.load("client.cells.campaign.trialtower.trial_tower_one_key_total_list_cell")
    -- Initialize Home page state machine.
    local function init_trial_tower_one_key_three_star_terminal()
        --
        local trial_tower_one_key_three_star_reward_terminal = {
            _name = "trial_tower_one_key_three_star_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local target = params._datas._self
                local function responseOneKeyCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil and _ED.one_key_three_kingdoms ~= nil then 
							response.node:addMopReward()
						end
					end
				end
				NetworkManager:register(protocol_command.one_key_sweep_three_kingdoms.code, nil, nil, nil, target, responseOneKeyCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(trial_tower_one_key_three_star_reward_terminal)
        state_machine.init()
    end
    
    init_trial_tower_one_key_three_star_terminal()
end

function TrialTowerOneKeyThreeStar:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_01")
	listView:removeAllItems()
	ccui.Helper:seekWidgetByName(root, "Text_999"):setString("".._ED.one_key_sweep_three_max_pass)
	self._current_index = zstring.tonumber(_ED.one_key_three_kingdoms.start_floor)
	self._propsList = {} 
	self._otherRewardCounts = 0 
	self._floor = math.floor(zstring.tonumber(_ED.one_key_three_kingdoms.start_floor))/3 + 1
	self:addMopReward()
end

-- 增加扫荡奖励
function TrialTowerOneKeyThreeStar:addMopReward()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_01")
	local current_floor = self._current_index
	local floor_reward = _ED.one_key_three_kingdoms.one_key_reward[current_floor]
	if floor_reward ~= nil then 
		for k,v in pairs(floor_reward) do
			local cell = TrialTowerOneKeyFloorListCell:createCell()
			cell:init(v,current_floor,k)
			self._totalHonour = self._totalHonour + cell.honour
			self._totalSilver = self._totalSilver + cell.silver
			listView:addChild(cell)
		end
	end
	
	local box_reward = _ED.one_key_three_kingdoms.one_key_box_reward[current_floor]
	if box_reward ~= nil and #box_reward > 0 then 
		local cell = TrialTowerOneKeyRewardListCell:createCell()
		cell:init(box_reward,current_floor)
		listView:addChild(cell)
		--计算总共的道具
		for k,v in pairs(box_reward) do
			if zstring.tonumber(v.prop_type) == 6 then 
				if self._propsList[zstring.tonumber(v.resource_id)] ~= nil then 
					self._propsList[zstring.tonumber(v.resource_id)] = self._propsList[zstring.tonumber(v.resource_id)] + zstring.tonumber(v.prop_count)
				else
					self._propsList[zstring.tonumber(v.resource_id)] = zstring.tonumber(v.prop_count)
				end
			elseif zstring.tonumber(v.prop_type) == 18 then 
				self._otherRewardCounts = self._otherRewardCounts + zstring.tonumber(v.prop_count)
			end
		end
	end
	
	local add_reward = _ED.one_key_three_kingdoms.one_key_addition[current_floor]
	if add_reward ~= nil and add_reward.describe ~= "" then 
		local cell = TrialTowerOneKeyAdditionListCell:createCell()
		cell:init(add_reward,current_floor)
		listView:addChild(cell)
	end
	local maxFloor = 0 
	if zstring.tonumber(_ED.one_key_sweep_three_max_pass)%3 > 0 then 
		maxFloor = math.floor(zstring.tonumber(_ED.one_key_sweep_three_max_pass)/3) + 1
	else
		maxFloor = math.floor(zstring.tonumber(_ED.one_key_sweep_three_max_pass)/3)
	end
	if current_floor >= maxFloor then
		--扫荡结束
		local cell = TrialTowerOneKeyTotalListCell:createCell()
		cell:init(self._totalHonour,self._totalSilver,self._propsList,self._otherRewardCounts)
		listView:addChild(cell)
		local Panel_text = ccui.Helper:seekWidgetByName(root, "Panel_text")
		Panel_text:setVisible(false)
		local Button_01 = ccui.Helper:seekWidgetByName(root, "Button_01")
		Button_01:setVisible(true)
	else
		self._current_index = self._current_index + 1
		state_machine.excute("trial_tower_one_key_three_star_reward",0,{_datas = {_self = self}})
	end

	listView:refreshView()
	listView:jumpToBottom()
end
	
function TrialTowerOneKeyThreeStar:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("campaign/TrialTower/trial_tower_3star.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	local Panel_text = ccui.Helper:seekWidgetByName(root, "Panel_text")
	Panel_text:setVisible(true)
	local Button_01 = ccui.Helper:seekWidgetByName(root, "Button_01")
	Button_01:setVisible(false)
	self:onUpdateDraw()
	--扫荡完成
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_01"), nil, 
	{
		terminal_name = "trial_tower_one_key_three_star_window_close",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)	
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_305"), nil, 
	{
		terminal_name = "trial_tower_one_key_three_star_window_close",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)	
	
end

function TrialTowerOneKeyThreeStar:onExit()
	state_machine.remove("trial_tower_one_key_three_star_reward")
end

function TrialTowerOneKeyThreeStar:init(props,needExp,getExp,shipId)
	
end
