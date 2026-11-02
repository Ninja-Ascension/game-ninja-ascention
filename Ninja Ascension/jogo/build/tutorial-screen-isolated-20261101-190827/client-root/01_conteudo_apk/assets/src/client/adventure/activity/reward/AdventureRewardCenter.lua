-- ----------------------------------------------------------------------------------------------------
-- 说明：奖励中心
-------------------------------------------------------------------------------------------------------
AdventureRewardCenter = class("AdventureRewardCenterClass", Window)
AdventureRewardCenter.__reward_centre_count = 0

--获取奖励中心奖励数量
function getReardCenterCount()
    local reardCount = 0
    if _ED._reward_centre ~= nil then 
        for k,v in pairs(_ED._reward_centre) do
            reardCount = reardCount + 1
        end
    end
    return reardCount
end

local adventure_reward_center_open_terminal = {
    _name = "adventure_reward_center_open",
    _init = function (terminal)
    	app.load("client.notification.push_notification_adventure_sign_in")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
            if terminal._state == 0 then
        	terminal._state = 1
        	if #_ED._reward_centre <= 0 then
	        	-- open sign window
	        	if getIsSign_in() == true and funOpenConditionJudge(59) == true then
	        		fwin:open(AdventureDailySignIn:new():init(), fwin._windows)
	        	end	        	
        		state_machine.change_state(state_machine.find("adventure_reward_center_close_window"), 1)
        		return true
        	end
        end
        fwin:open(AdventureRewardCenter:new():init(), fwin._ui)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local adventure_reward_center_close_window_terminal = {
    _name = "adventure_reward_center_close_window",
    _init = function (terminal)
    	app.load("client.notification.push_notification_adventure_sign_in")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if terminal._state == 0 then
        	terminal._state = 1
        	-- open sign window
        	if getIsSign_in() == true and funOpenConditionJudge(59) == true then
        		fwin:open(AdventureDailySignIn:new():init(), fwin._windows)
	        end	        	
        end

        fwin:close(fwin:find("AdventureRewardCenterClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(adventure_reward_center_open_terminal)
state_machine.add(adventure_reward_center_close_window_terminal)
state_machine.init()

function AdventureRewardCenter:ctor()
    self.super:ctor()
    self.roots = {}
	self.reward = {}
	self.litview = nil
	app.load("client.adventure.activity.reward.AdventureRewardCenterRewardList")
    -- Initialize adventure reward center state machine.
    local function init_adventure_reward_center_terminal()
		-- 刷新
        local adventure_reward_center_update_list_terminal = {
            _name = "adventure_reward_center_update_list",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local items = self.litview:getItems()
				for i, v in pairs(items) do
					if zstring.tonumber(v.rewardData._reward_centre_id) == zstring.tonumber(params[1]._reward_centre_id) then
						self.litview:removeItem(i-1)
						break
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 关闭公告
		local adventure_reward_center_close_terminal = {
             _name = "adventure_reward_center_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("adventure_reward_center_close_window", state_machine.find("adventure_reward_center_close_window")._state, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(adventure_reward_center_update_list_terminal)
		state_machine.add(adventure_reward_center_close_terminal)
        state_machine.init()
    end
    -- call func init adventure reward center state machine.
    init_adventure_reward_center_terminal()
end

function AdventureRewardCenter:init(type)

	return self
end

function AdventureRewardCenter:onUpdateDraw()
	-- for k,v in pairs(_ED._reward_centre) do
		-- table.insert(self.reward, v)
	-- end
	self:drawReward()
end

function AdventureRewardCenter:drawReward()
	local root = self.roots[1]
	self.litview = ccui.Helper:seekWidgetByName(root, "ListView_libao")
	self.litview:removeAllChildren(true)
	for k,v in pairs(_ED._reward_centre) do
		local cell = AdventureRewardCenterRewardList:createCell()
		cell:init(v,k)
		self.litview:addChild(cell)
		self.litview:requestRefreshView()
	end
end

function AdventureRewardCenter:onEnterTransitionFinish()
    local csbAdventureRewardCenter = csb.createNode("activity/gift/gift_box.csb")
    local root = csbAdventureRewardCenter:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureRewardCenter)
    --if _ED._reward_centre == nil or _ED._reward_centre == "" or #_ED._reward_centre == 0 then
    _ED._reward_centre = nil
    _ED._reward_centre = {}
    local function responsePropCompoundCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then 
                response.node:onUpdateDraw() 
                AdventureRewardCenter.__reward_centre_count = getReardCenterCount() 
                
            end
        end
    end
	NetworkManager:register(protocol_command.reward_center_init.code, nil, nil, nil, self, responsePropCompoundCallback, false, nil)
	--else
	--	self:onUpdateDraw()
	--end
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
		terminal_name = "adventure_reward_center_close",
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureRewardCenter:onExit()

end