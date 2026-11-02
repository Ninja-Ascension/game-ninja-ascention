--------------------------------------------------------------------------------
-- 三国无双 战斗  过关条件 ,覆盖在战斗场景上
--------------------------------------------------------------------------------


TrialTowerBattleDescribe = class("TrialTowerBattleDescribeClass", Window)
    
function TrialTowerBattleDescribe:ctor()
    self.super:ctor()
	self.actions = {}
	self.roots = {}
    -- Initialize TrialTowerBattleDescribe page state machine.
    local function init_trial_tower_terminal()
	
	
	--返回
		local trial_tower_battle_describe_back_activity_terminal = {
            _name = "trial_tower_battle_describe_back_activity",
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
	--隐藏
		local trial_tower_battle_describe_hidden_terminal = {
            _name = "trial_tower_battle_describe_hidden",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
              	for i, v in pairs(instance.roots) do
					v:setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- state_machine.add(trial_tower_back_activity_terminal)
		state_machine.add(trial_tower_battle_describe_back_activity_terminal)
		state_machine.add(trial_tower_battle_describe_hidden_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_trial_tower_terminal()
end


-- 回合
function TrialTowerBattleDescribe:addRoundCount(text)
	local root = self.roots[1]
	local trial_tower_battle_describe_add_round_count_terminal = {
            _name = "trial_tower_battle_describe_add_round_count",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
              
				local count = params._value
				ccui.Helper:seekWidgetByName(root, text[3]):setString(count)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

	state_machine.add(trial_tower_battle_describe_add_round_count_terminal)
	state_machine.init()
end

-- 死亡
function TrialTowerBattleDescribe:addDeadUnitLimitCount(text)
	local root = self.roots[1]
	
	local sum = 0
	
	local trial_tower_battle_describe_add_dead_unit_limit_count_terminal = {
            _name = "trial_tower_battle_describe_add_dead_unit_limit_count",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
            		ccui.Helper:seekWidgetByName(root, text[3]):setString(params)
            	else
					sum = sum + 1
					ccui.Helper:seekWidgetByName(root, text[3]):setString(sum)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

	state_machine.add(trial_tower_battle_describe_add_dead_unit_limit_count_terminal)
	state_machine.init()
end

-- 血量
function TrialTowerBattleDescribe:addHPRemainderPercent(text)
	local root = self.roots[1]
	
	local trial_tower_battle_describe_add_hp_remainder_percent_terminal = {
            _name = "trial_tower_battle_describe_add_hp_remainder_percent",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
              
				local count = params._value
				ccui.Helper:seekWidgetByName(root, text[3]):setString(count.."%")
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

	state_machine.add(trial_tower_battle_describe_add_hp_remainder_percent_terminal)
	state_machine.init()
end


function TrialTowerBattleDescribe:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	then
		return
	end
    local csbCampaign = csb.createNode("campaign/TrialTower/trial_tower_battle.csb")	
	local root = csbCampaign:getChildByName("root")
    self:addChild(csbCampaign)
	table.insert(self.roots, root)
	
	
	local textpanel_1 = ccui.Helper:seekWidgetByName(root,"Panel_1")
	local textpanel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
	local textpanel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	
	local textpanel = {textpanel_1, textpanel_2, textpanel_3}
	
	textpanel_1:setVisible(false)
	textpanel_2:setVisible(false)
	textpanel_3:setVisible(false)
	
	-- self.textlist = {
	-- 	{"Text_778_2_29", "Text_778_0_4_31", "Text_778_0_0_6_33"},
	-- 	{"Text_778", "Text_778_0", "Text_778_0_0"},
	-- 	{"Text_778_2", "Text_778_0_4", "Text_778_0_0_6"},
	-- }
	-- local textlistIndex = 1
	-- --关卡条件描述 Text_778
	
	-- --条件名:Text_778_0
	
	-- --条件值: Text_778_0_0

	-- -- 遍历 表 取出 值,比对基准值
	-- local round_count = dms.int(dms["achievement_mould"], self.achievementIndex, achievement_mould.round_count)
	-- local dead_unit_limit_count = dms.int(dms["achievement_mould"], self.achievementIndex, achievement_mould.dead_unit_limit_count)
	-- local hp_remainder_percent = dms.int(dms["achievement_mould"], self.achievementIndex, achievement_mould.hp_remainder_percent)
	
	-- -- 检查 回合内获胜
	-- if round_count ~= tipStringInfo_trialTowerBattleDescribe[1][3] then
		
	-- 	local text = self.textlist[textlistIndex]
		
	-- 	ccui.Helper:seekWidgetByName(root, text[1]):setString(string.format(tipStringInfo_trialTowerBattleDescribe[1][1],round_count))
	-- 	ccui.Helper:seekWidgetByName(root, text[2]):setString(tipStringInfo_trialTowerBattleDescribe[1][2])
	-- 	ccui.Helper:seekWidgetByName(root, text[3]):setString("0")
		
	-- 	--添加 监听
	-- 	self:addRoundCount(text)
		
	-- 	textpanel[textlistIndex]:setVisible(true)
		
	-- 	textlistIndex = textlistIndex + 1
	-- end
	-- -- 检查 死亡人数
	-- if dead_unit_limit_count ~= tipStringInfo_trialTowerBattleDescribe[2][3] then
		
	-- 	local text = self.textlist[textlistIndex]
		
	-- 	ccui.Helper:seekWidgetByName(root, text[1]):setString(string.format(tipStringInfo_trialTowerBattleDescribe[2][1],dead_unit_limit_count))
	-- 	ccui.Helper:seekWidgetByName(root, text[2]):setString(tipStringInfo_trialTowerBattleDescribe[2][2])
	-- 	ccui.Helper:seekWidgetByName(root, text[3]):setString("0")
		
	-- 	--添加 监听
	-- 	self:addDeadUnitLimitCount(text)
	
	-- 	textpanel[textlistIndex]:setVisible(true)
		
	-- 	textlistIndex = textlistIndex + 1
	-- end
	-- -- 检查 剩余血量
	-- if hp_remainder_percent ~= tipStringInfo_trialTowerBattleDescribe[3][3] then
		
	-- 	local text = self.textlist[textlistIndex]
		
	-- 	ccui.Helper:seekWidgetByName(root, text[1]):setString(string.format(tipStringInfo_trialTowerBattleDescribe[3][1],hp_remainder_percent).."%")
	-- 	ccui.Helper:seekWidgetByName(root, text[2]):setString(tipStringInfo_trialTowerBattleDescribe[3][2])
	-- 	ccui.Helper:seekWidgetByName(root, text[3]):setString("100%")
		
	-- 	--添加 监听
	-- 	self:addHPRemainderPercent(text)
		
	-- 	textpanel[textlistIndex]:setVisible(true)
		
	-- 	textlistIndex = textlistIndex + 1
	-- end
	
	
end

-- 成就模板的索引id
function TrialTowerBattleDescribe:init(achievementIndex)
	

	-- local layerCount = tonumber(_ED.three_kingdoms_view.current_floor) -- 第几层
	-- local currentIndex = tonumber(_ED.three_kingdoms_view.current_npc_pos) --当前挑战位置
	-- local npcList = dms.string(dms["three_kingdoms_config"], tonumber(layerCount), three_kingdoms_config.npc_id) -- {npc_id1, npc_id2,...}  当前npc列表
	-- local datas = zstring.split(npcList , ",")  --拆分
	-- local currentIndex = tonumber(_ED.three_kingdoms_view.current_npc_pos) --当前挑战位置
	-- local npcMID = tonumber(datas[currentIndex+1])
	-- local achievementIndex = dms.string(dms["npc"], npcMID, npc.get_star_condition)	--通关条件-从npc取找成就模板
	
	if nil == achievementIndex then
	
		achievementIndex = _ED.three_kingdoms_view.achievementIndex
	end
	
	self.achievementIndex = achievementIndex
	
	
end

function TrialTowerBattleDescribe:onExit()
	state_machine.remove("trial_tower_battle_describe_add_round_count")
	state_machine.remove("trial_tower_battle_describe_add_hp_remainder_percent")
	state_machine.remove("trial_tower_battle_describe_add_dead_unit_limit_count")
	state_machine.remove("trial_tower_battle_describe_back_activity")
	state_machine.remove("trial_tower_battle_describe_hidden")

end
