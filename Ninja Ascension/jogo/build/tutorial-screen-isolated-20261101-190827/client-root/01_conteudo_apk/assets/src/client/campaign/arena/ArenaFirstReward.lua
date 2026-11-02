----------------------------------------------------------------------------------------------------
-- 说明：竞技场首胜奖励元宝
-- to:李彪
-------------------------------------------------------------------------------------------------------
ArenaFirstReward = class("ArenaFirstRewardClass", Window)

function ArenaFirstReward:ctor()
    self.super:ctor()
    -- 定义封装类中的变量
	self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
	self.enum_type = {
		_PROP_MOULD = 1,	
	}
	local function init_arena_first_reward_terminal()
		local arena_first_reward_close_terminal = {
            _name = "arena_first_reward_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(arena_first_reward_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_first_reward_terminal()
end

function ArenaFirstReward:onUpdateDraw()

end

function ArenaFirstReward:onEnterTransitionFinish()
	local csbItem = csb.createNode("campaign/ArenaStorage/ArenaStorage_award_reminder.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	
	--exit
	-- local action = csb.createTimeline("campaign/ArenaStorage/ArenaStorage_award_reminder.csb")
	-- root:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
	-- action:setFrameEventCallFunc(function (frame)
        -- if nil == frame then
            -- return
        -- end

        -- local str = frame:getEvent()
        -- if str == "exit" then
			-- fwin:close(self)
		-- end
	
	-- end)
	
	-- 获得名次 Text_paiming_shu
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_paiming_shu"):setString(self.ranking)
	
	-- 提升名次 Text_paiming_up
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_paiming_up"):setString(self.count)
	
	-- 获得宝石 Text_paiming_award
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_paiming_award"):setString(self.count)

	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_2"), nil, 
	{
		terminal_name = "arena_first_reward_close", 
		cell = self,
	
	},
	nil, 1)	
end

function ArenaFirstReward:onExit()
	state_machine.remove("arena_first_reward_close")
end

-- 元宝数, 当前排名
function ArenaFirstReward:init(count, ranking)
	self.count = count
	self.ranking = ranking
end
