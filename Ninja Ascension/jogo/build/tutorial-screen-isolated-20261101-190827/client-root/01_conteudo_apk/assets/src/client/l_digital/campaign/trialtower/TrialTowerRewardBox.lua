--------------------------------------------------------------------------------
-- 显示获得的关卡宝箱
--------------------------------------------------------------------------------
TrialTowerRewardBox = class("TrialTowerRewardBoxClass", Window)
    
function TrialTowerRewardBox:ctor()
    self.super:ctor()
    self.roots = {}
	self.stats = nil
	self.arrange={
	
	}
	self.actions = {}
	
    -- Initialize TrialTowerRewardBox page state machine.
    local function init_trial_tower_terminal()
		-- 
	
		local trialtower_draw_reward_terminal = {
            _name = "trialtower_draw_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
					--fwin:close(instance)
					instance.actions[1]:play("window_close", false)
					state_machine.excute("trialtower_draw_reward_end", 0, nil) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(trialtower_draw_reward_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_trial_tower_terminal()
end

function TrialTowerRewardBox:onEnterTransitionFinish()
	-- campaign\TrialTower
    local csbCampaign = csb.createNode("campaign/TrialTower/trial_tower_chest.csb")	
	local root = csbCampaign:getChildByName("root")
    self:addChild(csbCampaign)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {
		func_string = [[state_machine.excute("trialtower_draw_reward", 0, "trialtower_draw_reward.")]],
		isPressedActionEnabled = true,
	}, nil, 0)
	
	ccui.Helper:seekWidgetByName(root, "Text_state"):setString(_ED.three_kingdoms_view.current_max_stars)
	
	

    local action = csb.createTimeline("campaign/TrialTower/trial_tower_chest.csb")	
    table.insert(self.actions, action )
    csbCampaign:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
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
	
	
	for i = 1, self.rewardList171.show_reward_item_count do
		local item = self.rewardList171.show_reward_list[i]
		local cell = nil
			-----------
			if tonumber(item.prop_type) == 6 then
			
				cell = self:getPropCell(tonumber(item.prop_item), tonumber(item.item_value))
				
			elseif tonumber(item.prop_type) == 18 then
			
				cell = self:getHonourCell(tonumber(item.item_value))
				
			end
			
			if nil ~= cell then
				ccui.Helper:seekWidgetByName(root, "ListView_1"):addChild(cell)
			end
			---------
	end
end


--道具
function TrialTowerRewardBox:getPropCell(mid, num)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.count = num
	cellConfig.isShowName = true
	cellConfig.isDebris = true
	cell:init(cellConfig)
	return cell
end

--威名
function TrialTowerRewardBox:getHonourCell(num)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldType = 18
	cellConfig.count = num
	cellConfig.isShowName = true
	cell:init(cellConfig)
	return cell
end


function TrialTowerRewardBox:onExit()
	
	-- state_machine.remove("TrialTowerRewardBox_back_activity")
	-- state_machine.remove("trial_tower_init_treasure")
end


function TrialTowerRewardBox:init(rewardList171)
	self.rewardList171 = rewardList171
end

function TrialTowerRewardBox:createCell()
	local cell = TrialTowerRewardBox:new()
	cell:registerOnNodeEvent(cell)
	return cell
end