----------------------------------------------------------------------------------------------------
-- 说明：主线副本列表元件的绘制及逻辑实现
-------------------------------------------------------------------------------------------------------
BattleAcquireProp = class("BattleAcquirePropClass", Window)
 
function BattleAcquireProp:ctor()
    self.super:ctor()
	self.roots = {}
    self.AcquireProp = nil
    self.actions = {}
	local function init_battle_function_open_terminal()
		local battle_acquire_prop_close_terminal = {
            _name = "battle_acquire_prop_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local mAction = params._datas._action
				if mAction ~= nil then
					mAction:play("props_xiaoshi", false)
					mAction:setFrameEventCallFunc(function (frame)
						if nil == frame then
							return
						end

						local str = frame:getEvent()
						if str == "open" then
						elseif str == "over2" then
							fwin:close(instance)
							executeNextEvent(nil, true)
						end
					end)
					params._datas._action = nil 
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(battle_acquire_prop_close_terminal)
        state_machine.init()
    end
    -- init_plot_copy_cell_terminal()
	
	init_battle_function_open_terminal()
end

function BattleAcquireProp:onUpdateDraw()
	local root = self.roots[1]
	
	local PropIcon = ccui.Helper:seekWidgetByName(root, "Panel_er_15")
	local PropNameText = ccui.Helper:seekWidgetByName(root, "Text_ev_1")
	local PropIntroText = ccui.Helper:seekWidgetByName(root, "Text_ev_2")
	
	if self.AcquireProp ~= nil then
		local prop_icon = string.format("images/ui/big_props/big_props_%s.png", self.AcquireProp.BigIconIndex)
		PropIcon:setBackGroundImage(prop_icon)
		PropNameText:setString(_string_piece_info[183]..self.AcquireProp.PropName.._string_piece_info[184]..self.AcquireProp.PropNumber)
		PropIntroText:setString(self.AcquireProp.PropCount)
	end
end
function BattleAcquireProp:ShowUI()
	local csbEquipPatchListCell = csb.createNode("events_interpretation/events_reward.csb")
	local root = csbEquipPatchListCell:getChildByName("root")
	local action = csb.createTimeline("events_interpretation/events_reward.csb")
	table.insert(self.actions, action)
	action:play("window_open", false)
	csbEquipPatchListCell:runAction(action)
	table.insert(self.roots, root)
	self:addChild(csbEquipPatchListCell)
	action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end

		local str = frame:getEvent()
		if str == "open" then
		elseif str == "over1" then
			local PanelClose=  ccui.Helper:seekWidgetByName(root, "Panel_ev_re")
			PanelClose:setTouchEnabled(true)
			fwin:addTouchEventListener(PanelClose, nil, 
				{
					terminal_name = "battle_acquire_prop_close", 
					terminal_state = 0, 
					_action = action,
					_PanelClose = PanelClose,
				},
				nil,0)
		end
	end)
end


function BattleAcquireProp:onEnterTransitionFinish()
	self:ShowUI()
	self:onUpdateDraw()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local se = cc.Sequence:create({cc.DelayTime:create(3), cc.CallFunc:create(function(sender)
				local PanelClose=  ccui.Helper:seekWidgetByName(root, "Panel_ev_re")
				state_machine.excute("battle_acquire_prop_close",0,{
					_datas = 
						{
							terminal_name = "battle_acquire_prop_close", 
							terminal_state = 0, 
							_action = self.actions[1],
							_PanelClose = PanelClose,					
						}
										
					}
					)
			end)})
		self:runAction(se)
	end	
end


function BattleAcquireProp:init(AcquirePropId)
	self.AcquireProp = AcquirePropId
end

function BattleAcquireProp:createCell()
	local cell = BattleAcquireProp:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function BattleAcquireProp:onExit()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self:stopAllActions()
	end
	state_machine.remove("battle_acquire_prop_close")
end