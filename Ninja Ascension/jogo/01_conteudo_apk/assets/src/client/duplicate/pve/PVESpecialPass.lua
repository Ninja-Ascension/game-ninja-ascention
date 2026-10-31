-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE特殊副本(对应少三帐篷)
-- 创建时间：2015-05-25
-- 作者：邓啸宇
-------------------------------------------------------------------------------------------------------
PVESpecialPass = class("PVESpecialPassClass", Window)

function PVESpecialPass:ctor()
    self.super:ctor()
    self.roots = {}
	self.id = nil
	self.panel = {}
	-- Initialize PlotCopyChest page state machine.
    local function init_pve_special_pass_terminal()
		-- 关闭场景
		local pve_special_pass_close_terminal = {
            _name = "pve_special_pass_close",
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
		
		-- 挑战
		local pve_special_pass_start_terminal = {
            _name = "pve_special_pass_start",
            _init = function (terminal)
			
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					-- if instance.canClickBtn == false then return end
					-- if instance.currentAttackTimes >= instance.maxAttackCount then
						-- TipDlg.drawTextDailog(_string_piece_info[113])
						-- return
					-- end
					
					---[[
					--DOTO 战斗请求
					local function responseBattleInitCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							state_machine.excute("page_stage_fight_data_deal", 0, 0)
						
							fwin:cleanView(fwin._windows)
							local bse = BattleStartEffect:new()
							bse:init(1)
							fwin:open(bse, fwin._windows)
							-- state_machine.excute("battle_start_play_start_effect", 0, 1)
							-- BattleSceneClass.Draw()
							-- state_machine.excute("page_stage_fight_animation", 0, 0)
						end
					end

					-- 启动出战事件
					instance.id = zstring.tonumber(instance.id)
					local sceneParam = "nc".._ED.npc_state[instance.id]
					if missionIsOver() == false or executeMissionExt(mission_mould_plot, touch_off_mission_touch_npc, ""..instance.id, nil, true, sceneParam, false) == false then
						_ED.npc_last_state[instance.id] = "".._ED.npc_state[instance.id]

						_ED._current_scene_id = instance.id
						_ED._scene_npc_id = dms.string(dms["pve_scene"], instance.id, pve_scene.npcs)
						-- _ED._scene_npc_id = instance.id
						_ED._npc_difficulty_index = "1"
						
						if __lua_project_id == __lua_project_legendary_game then			-- 超神请求本地战斗数据
							app.load("client.battle.report.BattleReport")
							local fightModule = FightModule:new()
							fightModule:initFight(_ED._scene_npc_id, _ED._npc_difficulty_index, 0)
							fightModule:doFight()
							
							responseBattleInitCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
						else
							protocol_command.battle_field_init.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n".._ED._npc_difficulty_index.."\r\n".."0"
							NetworkManager:register(protocol_command.battle_field_init.code, nil, nil, nil, nil, responseBattleInitCallback, false, nil)
						end
					end
				end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(pve_special_pass_close_terminal)
        state_machine.add(pve_special_pass_start_terminal)
        state_machine.init()
    end
    
    -- call func init PlotCopyChest state machine.
    init_pve_special_pass_terminal()
end

function PVESpecialPass:onUpdateDraw()
	local root = self.roots[1]
	local nameLabel = ccui.Helper:seekWidgetByName(root, "Text_12")
	nameLabel:setString(dms.string(dms["pve_scene"], self.id, pve_scene.scene_name))
	local desLabel = ccui.Helper:seekWidgetByName(root, "Text_3")
	local pic = ccui.Helper:seekWidgetByName(root, "Panel_4")
	desLabel:setString(dms.string(dms["pve_scene"], self.id, pve_scene.brief_introduction))
	pic:setBackGroundImage(string.format("images/ui/pve_sn/gameElite/%d.png", 6000 + dms.int(dms["pve_scene"], self.id, pve_scene.scene_map_id)))
	
	local npcs = dms.string(dms["pve_scene"], self.id, pve_scene.npcs)
	local temp = dms.string(dms["npc"], npcs, npc.drop_library)
	
	local rewardMoney = dms.int(dms["scene_reward"], temp, scene_reward.reward_silver)
	local library = dms.string(dms["scene_reward"], temp, scene_reward.reward_prop)
	local rewardProp = zstring.split(library,"|")
	
	local item = 1
	if rewardMoney > 0 then
		local reward = ResourcesIconCell:createCell()
		reward:init(1, rewardMoney, -1)
		self.panel[item]:addChild(reward)
		reward:showName(-1,1)
		item = item + 1
	end
	for i,v in pairs(rewardProp) do
		local rewardPropInfo = zstring.split(v, ",")
		if tonumber(rewardPropInfo[1]) > 0 and tonumber(rewardPropInfo[2]) > 0 then
			local reawrdID = rewardPropInfo[2]
			local rewardNum = tonumber(rewardPropInfo[1])
			local cell = PropIconCell:createCell()
			cell:init(29,reawrdID,rewardNum)
			self.panel[item]:addChild(cell)
			item = item + 1
		end
	end	
	
	if tonumber(_ED.scene_current_state[tonumber(self.id)]) > 0 then
		ccui.Helper:seekWidgetByName(root, "Button_3"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_13"):setVisible(true)
	end
	
end

function PVESpecialPass:onEnterTransitionFinish()
	local csbPVESPecialPass = csb.createNode("duplicate/gameelite_inter_window.csb")
    local root = csbPVESPecialPass:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPVESPecialPass)
	
	
	self.panel = {
		ccui.Helper:seekWidgetByName(root, "Panel_icon_1"),
		ccui.Helper:seekWidgetByName(root, "Panel_icon_2"),
		ccui.Helper:seekWidgetByName(root, "Panel_icon_3"),
		ccui.Helper:seekWidgetByName(root, "Panel_icon_4"),
	}
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
	{
		terminal_name = "pve_special_pass_close",
		isPressedActionEnabled = true
	}, nil, 0)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil, 
	{
		terminal_name = "pve_special_pass_start",
		isPressedActionEnabled = true
	}, nil, 0)
	
    self:onUpdateDraw()
end

function PVESpecialPass:init(sceneID)
	self.id = sceneID
end

function PVESpecialPass:onExit()
	state_machine.remove("pve_special_pass_close")
	state_machine.remove("pve_special_pass_start")
end
