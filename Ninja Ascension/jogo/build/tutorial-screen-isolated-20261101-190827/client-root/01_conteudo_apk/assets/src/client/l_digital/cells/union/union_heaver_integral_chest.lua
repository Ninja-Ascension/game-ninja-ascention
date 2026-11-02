----------------------------------------------------------------------------------------------------
-- 说明：祭天的积分宝箱
-------------------------------------------------------------------------------------------------------
UnionHeaverIntegralChest = class("UnionHeaverIntegralChestClass", Window)
 
function UnionHeaverIntegralChest:ctor()
    self.super:ctor()
	self.roots = {}
	self.index = 0
	self.rewardInfo = nil
	self.drawState = 0   -- 0：不可领取    1：可领取    2：已经领取

    -- Initialize daily task integral chest page state machine.
    local function init_union_heaver_integral_chest_terminal()	
		local union_heaver_integral_chest_draw_reward_terminal = {
            _name = "union_heaver_integral_chest_draw_reward",
            _init = function (terminal) 
	            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					app.load("client.l_digital.cells.union.union_heaver_integral_reward_dialog")
				else
	                app.load("client.cells.union.union_heaver_integral_reward_dialog")
	            end
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if fwin:find("UnionHeaverIntegralRewardDailogClass") ~= nil then
					return
				end
            	local cell = params._datas.cell
				fwin:open(UnionHeaverIntegralRewardDailog:new():init(cell.index, cell.rewardInfo, cell.drawState, cell), fwin._ui)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_heaver_integral_chest_update_draw_terminal = {
            _name = "union_heaver_integral_chest_update_draw",
            _init = function (terminal) 
	            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					app.load("client.l_digital.cells.union.union_heaver_integral_chest")
				else	
	                app.load("client.cells.union.union_heaver_integral_chest")
	            end
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params
            	cell.drawState = 2
				cell:onUpdateDraw()
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_heaver_integral_chest_draw_reward_terminal)
        state_machine.add(union_heaver_integral_chest_update_draw_terminal)
        state_machine.init()
    end
    
    -- call func init daily task integral chest state machine.
    init_union_heaver_integral_chest_terminal()
end

function UnionHeaverIntegralChest:onUpdateDraw()
	local root = self.roots[1]
	local getRewardProgress = zstring.split(dms.string(dms["union_lobby_param"], _ED.union.union_info.union_grade, union_lobby_param.getRewardProgress), "|")
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		ccui.Helper:seekWidgetByName(root, "Text_101"):setString(getRewardProgress[tonumber(self.index)])
	else
		ccui.Helper:seekWidgetByName(root, "Text_101"):setString(getRewardProgress[tonumber(self.index)].._string_piece_info[267])
	end
	-- 隐藏星星
	ccui.Helper:seekWidgetByName(root, "ImageView_15617"):setVisible(false)

	local config_data = {
		{"Panel_c_3", "Panel_r_3", "Panel_o_3"},
		{"Panel_c_2", "Panel_r_2", "Panel_o_2"},
		{"Panel_c_4", "Panel_r_4", "Panel_o_4"},
		{"Panel_c_1", "Panel_r_1", "Panel_o_1"},
	}

	ccui.Helper:seekWidgetByName(root, config_data[self.index][1]):setVisible(false)
	ccui.Helper:seekWidgetByName(root, config_data[self.index][2]):setVisible(false)
	ccui.Helper:seekWidgetByName(root, config_data[self.index][3]):setVisible(false)

	if self.drawState == 0 then
		ccui.Helper:seekWidgetByName(root, config_data[self.index][1]):setVisible(true)
	elseif self.drawState == 1 then
		ccui.Helper:seekWidgetByName(root, config_data[self.index][2]):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, config_data[self.index][3]):setVisible(true)
	end
end

function UnionHeaverIntegralChest:onEnterTransitionFinish()
    local csbEquipPatchListCell = csb.createNode("duplicate/pve_reward.csb")
	local root = csbEquipPatchListCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(true)
	self:addChild(root)
	
	self:onUpdateDraw()

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_15612"), nil, 
	{
		terminal_name = "union_heaver_integral_chest_draw_reward", 
		terminal_state = 0, 
		cell = self,
		touch_scale = true
	},nil, 0)
end

function UnionHeaverIntegralChest:onExit()
    
end

function UnionHeaverIntegralChest:init(index, rewardInfo, state)
	self.index = index
	self.rewardInfo = rewardInfo
	self.drawState = zstring.tonumber(state)
end

function UnionHeaverIntegralChest:createCell()
	local cell = UnionHeaverIntegralChest:new()
	cell:registerOnNodeEvent(cell)
	return cell
end