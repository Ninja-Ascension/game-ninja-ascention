-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军Boss战斗结算
-- 创建时间	2015-03-06
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

RebelBossBattleEnd = class("RebelBossBattleEndClass", Window)
    
function RebelBossBattleEnd:ctor()
    self.super:ctor()
    self.roots = {}
	app.load("client.campaign.worldboss.WorldBoss")
    -- Initialize RebelBossBattleEnd page state machine.
    local function init_world_boss_terminal()
		--	关闭
		local rebel_boss_battle_end_button_close_terminal = {
            _name = "rebel_boss_battle_end_button_close",
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
				app.load("client.campaign.worldboss.rebelboss.RebelBoss")
   				state_machine.excute("rebel_boss_window_open",0,1)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(rebel_boss_battle_end_button_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_world_boss_terminal()
end

function RebelBossBattleEnd:onUpdateDraw()
	local root = self.roots[1]
	
end

function RebelBossBattleEnd:onEnterTransitionFinish()

	local csbRebelBossBattleEnd = csb.createNode("campaign/WorldBoss/wordBoss_victory_2.csb")
	self:addChild(csbRebelBossBattleEnd)
	local root = csbRebelBossBattleEnd:getChildByName("root")
	table.insert(self.roots, root)
	local rewardList = getSceneReward(43)
	
	-- battle_exp_7_over
	local action = csb.createTimeline("campaign/WorldBoss/wordBoss_victory_2.csb")
    csbRebelBossBattleEnd:runAction(action)
   
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
		if str == "window_open_win_over" then
		
		elseif str == "over" then
            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, 
			{
				terminal_name = "rebel_boss_battle_end_button_close",
				
				terminal_state = 0
			}, nil, 0)
		elseif str == "battle_ganglv_1_over" then
			ccui.Helper:seekWidgetByName(root, "Text_5_8"):setString("".._ED.RebelBossFightReard.damage)
			ccui.Helper:seekWidgetByName(root, "Text_7_12_1"):setString("".._ED.RebelBossFightReard.integral)
			ccui.Helper:seekWidgetByName(root, "Text_7_12_0_1"):setString("".._ED.RebelBossFightReard.exploits)
			local baojiType = _ED.RebelBossFightReard.rewadType
			if nil ~= baojiType and baojiType > 0 then 
				local baojiText = ccui.Helper:seekWidgetByName(root, "Text_baoji")
				baojiText:setString("(" .. tipStringInfo_trialTower_multiplying[baojiType].. ")")
				baojiText:setColor(cc.c3b(
					tipStringInfo_trialTower_multiplying_color[baojiType][1], 
					tipStringInfo_trialTower_multiplying_color[baojiType][2], 
					tipStringInfo_trialTower_multiplying_color[baojiType][3])
				)
			end
			_ED.RebelBossFightReard.rewardPropId = 786
			if _ED.RebelBossFightReard.rewardPropId > 0 then 
				local propPanel = ccui.Helper:seekWidgetByName(root, "Panel_3_6_0")
				propPanel:setVisible(true)
				local propName = dms.string(dms["prop_mould"],_ED.RebelBossFightReard.rewardPropId,prop_mould.prop_name)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		            propName = setThePropsIcon(_ED.RebelBossFightReard.rewardPropId)[2]
		        end
				ccui.Helper:seekWidgetByName(root, "Text_prop_name"):setString(propName.. "x" ..4) -- _ED.RebelBossFightReard.rewardPropCounts)
			end
		end
    end)
end


function RebelBossBattleEnd:init()
end
function RebelBossBattleEnd:createCell()
	local cell = RebelBossBattleEnd:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
function RebelBossBattleEnd:onExit()
	
end