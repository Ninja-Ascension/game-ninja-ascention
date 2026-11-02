-----------------------------------------------------------------------------
-- 巡逻的开始提示
-- 
-----------------------------------------------------------------------------
MineManagerPatrolPrompt = class("MineManagerPatrolPromptClass", Window)
    
function MineManagerPatrolPrompt:ctor()
    self.super:ctor()
	self.actions = {}
	
	
	
    -- Initialize MineManagerPatrolPrompt page state machine.
    local function init_trial_tower_terminal()

	--返回
		local MineManagerPatrolPrompt_back_activity_terminal = {
            _name = "MineManagerPatrolPrompt_back_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 	
				instance.isSubmit = false
				instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
	-- 提交
		local MineManagerPatrolPrompt_submit_activity_terminal = {
            _name = "MineManagerPatrolPrompt_submit_activity",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 	
				instance.isSubmit = true
				instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		
		state_machine.add(MineManagerPatrolPrompt_submit_activity_terminal)
		state_machine.add(MineManagerPatrolPrompt_back_activity_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_trial_tower_terminal()
end

function MineManagerPatrolPrompt:onEnterTransitionFinish()
	
    local csbCampaign = csb.createNode("campaign/MineManager/attack_territory_prompt.csb")	
	local root = csbCampaign:getChildByName("root")
	self:addChild(csbCampaign)

	local action = csb.createTimeline("campaign/MineManager/attack_territory_prompt.csb") 
    table.insert(self.actions, action )
    csbCampaign:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()

        if str == "open" then
        elseif str == "close" then
        	
			if self.isSubmit == true then
				state_machine.excute("mine_manager_manager_add_person_start_go_patrol", 0, nil)
			end
			
			fwin:close(self)
        end
    end)
    action:play("window_open", false)

	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_51"), nil, 
	{
		terminal_name = "MineManagerPatrolPrompt_back_activity", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,2)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_55"), nil, 
	{
		terminal_name = "MineManagerPatrolPrompt_back_activity", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_52"), nil, 
	{
		terminal_name = "MineManagerPatrolPrompt_submit_activity",
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)
	
	if self.ptype == 1 then
		ccui.Helper:seekWidgetByName(root, "Image_14"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Image_14_0"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root, "Image_14"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Image_14_0"):setVisible(true)
	end
	
	-- 精力数 + -- 时间
	ccui.Helper:seekWidgetByName(root, "Text_519"):setString(string.format(tipStringInfo_mine_info[21], self.num,self.times))

	-- 巡逻类型
	ccui.Helper:seekWidgetByName(root, "Text_520"):setString(string.format(tipStringInfo_mine_info[22], tipStringInfo_mine_info[23][self.ptype]))
end

-- 精力数, 巡逻时间长, 巡逻类型
function MineManagerPatrolPrompt:init(num,times,ptype)
	self.num = tonumber(num)
	self.times = tonumber(times)
	self.ptype = tonumber(ptype)
end

function MineManagerPatrolPrompt:onExit()
	state_machine.remove("MineManagerPatrolPrompt_back_activity")
	state_machine.remove("MineManagerPatrolPrompt_submit_activity")
	
end


function MineManagerPatrolPrompt:createCell()
	local cell = MineManagerPatrolPrompt:new()
	cell:registerOnNodeEvent(cell)
	return cell
end