-- ----------------------------------------------------------------------------------------------------
-- 说明：围剿叛军战斗结算
-- 创建时间	2015-03-06
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

BetrayArmyBattleEnd = class("BetrayArmyBattleEndClass", Window)
    
function BetrayArmyBattleEnd:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.campaign.worldboss.WorldBoss")
    -- Initialize BetrayArmyBattleEnd page state machine.
    local function init_world_boss_terminal()
		--	关闭
		local betray_army_battle_end_button_close_terminal = {
            _name = "betray_army_battle_end_button_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
			local hurt_value = params._datas.hurtValue
				fwin:close(instance)
				fwin:close(fwin:find("BattleSceneClass"))
				fwin:removeAll()
				app.load("client.home.Menu")
				fwin:open(Menu:new(), fwin._taskbar)
				
				local view = WorldBoss:new()
				view:init(1)
				fwin:open(view, fwin._view)
				-- state_machine.excute("world_boss_npc_state_update", 0, "world_boss_npc_state_update.")
				-- state_machine.excute("world_boss_npc_state_update", 0, "world_boss_npc_state_update.")
				--state_machine.excute("campaign_show_palace", 0,0) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(betray_army_battle_end_button_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_world_boss_terminal()
end

function BetrayArmyBattleEnd:onUpdateDraw()
	local root = self.roots[1]
	
end

function BetrayArmyBattleEnd:onEnterTransitionFinish()

	local csbBetrayArmyBattleEnd = csb.createNode("campaign/WorldBoss/wordBoss_victory.csb")
	self:addChild(csbBetrayArmyBattleEnd)
	local root = csbBetrayArmyBattleEnd:getChildByName("root")
	table.insert(self.roots, root)
	local rewardList = getSceneReward(43)
	
	-- battle_exp_7_over
	local action = csb.createTimeline("campaign/WorldBoss/wordBoss_victory.csb")
    csbBetrayArmyBattleEnd:runAction(action)
   	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		action:play("window_open_win", false)
			local Panel_window_open = ccui.Helper:seekWidgetByName(root, "Panel_window_open")
			local ArmatureNode_100=Panel_window_open:getChildByName("ArmatureNode_100")
			draw.initArmature(ArmatureNode_100, nil, -1, 0, 1)
			ArmatureNode_100:getAnimation():playWithIndex(0, 0, 0)
			ArmatureNode_100:setVisible(false)
			
			ArmatureNode_100._invoke = function(armatureBack)
				armatureBack:setVisible(false)
				action:play("window_boss_open", false)
				armatureBack._invoke=nil
			end
	else
		action:gotoFrameAndPlay(0, action:getDuration(), false)
    end
	
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
		 if str == "window_open_win_over" then
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				local Panel_window_open = ccui.Helper:seekWidgetByName(root, "Panel_window_open")
				local ArmatureNode_100=Panel_window_open:getChildByName("ArmatureNode_100")
				ArmatureNode_100:setVisible(true)
				csb.animationChangeToAction(ArmatureNode_100, 0, 0, nil)
			end
		 elseif str == "over" then
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, 
			{
				terminal_name = "betray_army_battle_end_button_close",
				hurtValue = getRewardValueWithType(rewardList, 15),
				terminal_state = 0
			}, nil, 0)
			
		elseif str == "show" then
			
		elseif str == "battle_ganglv_1_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString(math.floor(getRewardValueWithType(rewardList, 15)*0.1))
			end
		elseif str == "battle_ganglv_2_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString(math.floor(getRewardValueWithType(rewardList, 15)*0.3))
			end
		elseif str == "battle_ganglv_3_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString(math.floor(getRewardValueWithType(rewardList, 15)*0.5))
			end
		elseif str == "battle_ganglv_4_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString(math.floor(getRewardValueWithType(rewardList, 15)*0.7))
			end
		elseif str == "battle_ganglv_5_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString(math.floor(getRewardValueWithType(rewardList, 15)*0.9))
			end
		elseif str == "battle_ganglv_6_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString(math.floor(getRewardValueWithType(rewardList, 15)*1))
			end
		elseif str == "battle_ganglv_7_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString(math.floor(getRewardValueWithType(rewardList, 15)*1))
			end
		elseif str == "battle_exp_1_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7_12_1"):setString(""..math.floor(getRewardValueWithType(rewardList, 20)*0.1))
			end
		elseif str == "battle_exp_2_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7_12_1"):setString(""..math.floor(getRewardValueWithType(rewardList, 20)*0.3))
			end
		elseif str == "battle_exp_3_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7_12_1"):setString(""..math.floor(getRewardValueWithType(rewardList, 20)*0.5))
			end
		elseif str == "battle_exp_4_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7_12_1"):setString(""..math.floor(getRewardValueWithType(rewardList, 20)*0.7))
			end
		elseif str == "battle_exp_5_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7_12_1"):setString(""..math.floor(getRewardValueWithType(rewardList, 20)*0.9))
			end
		elseif str == "battle_exp_6_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7_12_1"):setString(""..math.floor(getRewardValueWithType(rewardList, 20)*1))
			end
		elseif str == "battle_exp_7_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7_12_1"):setString(""..math.floor(getRewardValueWithType(rewardList, 20)*1))
			end
        elseif str == "battle_zhangou_1_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7_12_0_1"):setString(""..math.floor(getRewardValueWithType(rewardList, 21)*0.1))
			end
		elseif str == "battle_zhangou_2_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7_12_0_1"):setString(""..math.floor(getRewardValueWithType(rewardList, 21)*0.3))
			end
		elseif str == "battle_zhangou_3_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7_12_0_1"):setString(""..math.floor(getRewardValueWithType(rewardList, 21)*0.5))
			end
		elseif str == "battle_zhangou_4_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7_12_0_1"):setString(""..math.floor(getRewardValueWithType(rewardList, 21)*0.7))
			end
		elseif str == "battle_zhangou_5_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7_12_0_1"):setString(""..math.floor(getRewardValueWithType(rewardList, 21)*0.9))
			end
		elseif str == "battle_zhangou_6_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7_12_0_1"):setString(""..math.floor(getRewardValueWithType(rewardList, 21)*1))
			end
		elseif str == "battle_zhangou_7_over" then
			if rewardList ~= nil then
				ccui.Helper:seekWidgetByName(root, "Text_7_12_0_1"):setString(""..math.floor(getRewardValueWithType(rewardList, 21)*1))
			end
		end
    end)
end


function BetrayArmyBattleEnd:init()
end
function BetrayArmyBattleEnd:createCell()
	local cell = BetrayArmyBattleEnd:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
function BetrayArmyBattleEnd:onExit()
	
end