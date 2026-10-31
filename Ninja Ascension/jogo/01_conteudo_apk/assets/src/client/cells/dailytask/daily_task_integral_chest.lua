----------------------------------------------------------------------------------------------------
-- 说明：日常活动的积分宝箱
-------------------------------------------------------------------------------------------------------
DailyTaskIntegralChest = class("DailyTaskIntegralChestClass", Window)
 
function DailyTaskIntegralChest:ctor()
    self.super:ctor()
	self.roots = {}
	self.rewardId = 0
	self.drawState= 0   -- 0：不可领取    1：可领取    2：已经领取

    -- Initialize daily task integral chest page state machine.
    local function init_daily_task_integral_chest_terminal()	
		local daily_task_integral_chest_draw_reward_terminal = {
            _name = "daily_task_integral_chest_draw_reward",
            _init = function (terminal) 
                app.load("client.activity.dailytask.DailyTaskIntegralRewardDailog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if fwin:find("DailyTaskIntegralRewardDailogClass") ~= nil then
					return
				end
            	local cell = params._datas.cell
				fwin:open(DailyTaskIntegralRewardDailog:new():init(cell.rewardId, cell.drawState, cell), fwin._ui)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local daily_task_integral_chest_update_draw_terminal = {
            _name = "daily_task_integral_chest_update_draw",
            _init = function (terminal) 
                app.load("client.activity.dailytask.DailyTaskIntegralRewardDailog")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params
        		if cell == nil then
        			return
        		end
				cell:onUpdateDraw()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(daily_task_integral_chest_draw_reward_terminal)
        state_machine.add(daily_task_integral_chest_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init daily task integral chest state machine.
    init_daily_task_integral_chest_terminal()
end

function DailyTaskIntegralChest:onUpdateDraw()
	local currentIntegral = zstring.tonumber(_ED.daily_task_integral)
	local rewardElement = dms.element(dms["liveness_reward"], self.rewardId)
	local drawState = zstring.tonumber(_ED.daily_task_draw_index[self.rewardId])

	local needIntegral = dms.atoi(rewardElement, liveness_reward.need_liveness)

	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Text_101"):setString(""..needIntegral.."".._string_piece_info[267])
	-- 隐藏星星
	ccui.Helper:seekWidgetByName(root, "ImageView_15617"):setVisible(false)

	local config_data = {
		{"Panel_c_3", "Panel_r_3", "Panel_o_3"},
		{"Panel_c_2", "Panel_r_2", "Panel_o_2"},
		{"Panel_c_4", "Panel_r_4", "Panel_o_4"},
		{"Panel_c_1", "Panel_r_1", "Panel_o_1"},
	}

	ccui.Helper:seekWidgetByName(root, config_data[self.rewardId][1]):setVisible(false)
	ccui.Helper:seekWidgetByName(root, config_data[self.rewardId][2]):setVisible(false)
	ccui.Helper:seekWidgetByName(root, config_data[self.rewardId][3]):setVisible(false)

	if needIntegral > currentIntegral then
		self.drawState = 0
		ccui.Helper:seekWidgetByName(root, config_data[self.rewardId][1]):setVisible(true)
	else
		if drawState == 0 then
			self.drawState = 1
			ccui.Helper:seekWidgetByName(root, config_data[self.rewardId][2]):setVisible(true)
		else
			self.drawState = 2
			ccui.Helper:seekWidgetByName(root, config_data[self.rewardId][3]):setVisible(true)
		end
	end
end

function DailyTaskIntegralChest:onEnterTransitionFinish()
    local csbEquipPatchListCell = csb.createNode("duplicate/pve_reward.csb")
	local root = csbEquipPatchListCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(true)
	self:addChild(root)
	
	self:onUpdateDraw()
	local _scale = true
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		_scale = false
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_15612"), nil, 
	{
		terminal_name = "daily_task_integral_chest_draw_reward", 
		terminal_state = 0, 
		cell = self,
		touch_scale = _scale
	},nil, 0)
end

function DailyTaskIntegralChest:onExit()
    
end

function DailyTaskIntegralChest:init(rewardId)
	self.rewardId = zstring.tonumber(rewardId)
end

function DailyTaskIntegralChest:createCell()
	local cell = DailyTaskIntegralChest:new()
	cell:registerOnNodeEvent(cell)
	return cell
end