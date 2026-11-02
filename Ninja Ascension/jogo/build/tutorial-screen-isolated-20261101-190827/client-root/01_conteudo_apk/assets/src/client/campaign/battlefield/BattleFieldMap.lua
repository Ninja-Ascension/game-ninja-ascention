-- ----------------------------------------------------------------------------------------------------
-- 说明：皇骑战场地图
-------------------------------------------------------------------------------------------------------

BattleFieldMap = class("BattleFieldMapClass", Window)
BattleFieldMap._victory_self = nil 

function BattleFieldMap:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}
    self._can_get_reward = false
    self._come_anmation_cells = nil --出场动画

    app.load("client.cells.campaign.battle_field_map_role_cell")
    -- Initialize BattleFieldMap page state machine.
    local function init_battle_field_map_terminal()
	   
        ----查看奖励
		local battle_field_map_pop_reward_terminal = {
            _name = "battle_field_map_pop_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                app.load("client.campaign.battlefield.BattleFieldReward")
                state_machine.excute("battle_field_reward_window_open",0,instance._can_get_reward)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(battle_field_map_pop_reward_terminal)
        state_machine.init()
    end
    -- call func init hom state machine.
    init_battle_field_map_terminal()
end


function BattleFieldMap:onEnterTransitionFinish()
	 
end

function BattleFieldMap:init(changeStates, isRefreshed)
	self:onInit()
    return self
end

function BattleFieldMap:onUpdateDraw()
     local root = self.roots[1]
    if root == nil then 
        return
    end
    self._can_get_reward = false
    local lines = {}
    self._come_anmation_cells = {}
    local current_floor = zstring.tonumber(_ED._pet_battle_filed_info.current_floor)
    for i=1,12 do
        local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_emeny_"..i)
        rolePanel:removeAllChildren(true)
        rolePanel:setSwallowTouches(false)
        -- 0未激活 1激活 2击杀
        local linePanel = ccui.Helper:seekWidgetByName(root, "Panel_line_"..i)
        linePanel:setVisible(false)
        local attact_state = _ED._pet_battle_filed_info.players[i]._player_attact_state
        if attact_state == 2 then
            linePanel:setVisible(true)
            if i == 10 or i == 11 or i == 12 then 
                self._can_get_reward = true
            end
        end

        local deDate = _ED._pet_battle_filed_info.players[i]
        if deDate ~= nil then 
            local roleCell = BattleFieldMapRoleCell:createCell()
            roleCell:init(deDate,current_floor,i)
            rolePanel:addChild(roleCell)
            if attact_state == 1 then 
                table.insert(self._come_anmation_cells,roleCell)
            end
        end
    end
    local rewardButton1 = ccui.Helper:seekWidgetByName(root, "Button_bz_1")
    local rewardButton2 = ccui.Helper:seekWidgetByName(root, "Button_bz_2")
    rewardButton1:setVisible(self._can_get_reward == false)
    rewardButton2:setVisible(self._can_get_reward)
    ccui.Helper:seekWidgetByName(root, "Text_bz"):setString(string.format(_pet_tipString_info[30],current_floor))
    BattleFieldMap._victory_self = self
    local function executePlayFunc( ... )
        local target = BattleFieldMap._victory_self
        if target ~= nil  then 
            for k,v in pairs(target._come_anmation_cells) do
                v:playVictoryAnimation()
            end
        end
    end 
    if self._come_anmation_cells ~= nil and #self._come_anmation_cells > 0  then 
        --播放动画
        self:stopAllActions()
        self:runAction(cc.Sequence:create(cc.DelayTime:create(0.2), cc.CallFunc:create(executePlayFunc)))
           
    end
end

function BattleFieldMap:onInit()
    local csbBattleFieldMap = csb.createNode("campaign/BattleField/BattleField_map.csb")
    local root = csbBattleFieldMap:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbBattleFieldMap)

    --self:onUpdateDraw()
    --查看奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bz_1"),     nil, 
    {
        terminal_name = "battle_field_map_pop_reward",   
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    --领取奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bz_2"),     nil, 
    {
        terminal_name = "battle_field_map_pop_reward",   
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function BattleFieldMap:close( ... )

end

function BattleFieldMap:onExit()
	state_machine.remove("battle_field_map_pop_reward")
end
