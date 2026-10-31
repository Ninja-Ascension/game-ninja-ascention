-- ----------------------------------------------------------------------------------------------------
-- 说明：宠物副本挑战对话框
-------------------------------------------------------------------------------------------------------

BattleFieldChallenge = class("BattleFieldChallengeClass", Window)
   
local battle_field_challenge_window_open_terminal = {
    _name = "battle_field_challenge_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("BattleFieldChallengeClass") then
        	local challengeWindow = BattleFieldChallenge:new()
            local data = params[1]
            local index = params[2]
			challengeWindow:init(data,index)
			fwin:open(challengeWindow, fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_field_challenge_window_close_terminal = {
    _name = "battle_field_challenge_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleFieldChallengeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_field_challenge_window_open_terminal)
state_machine.add(battle_field_challenge_window_close_terminal)
state_machine.init()
  
function BattleFieldChallenge:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
    self._attackDate = nil --挑战玩家数据
    self._currrent_index = 0 -- 当前据点
    self._zj_template_id = 0 --主角模板ID
	
    app.load("client.cells.ship.ship_head_cell")
    -- Initialize Home page state machine.
    local function init_battle_field_challenge_terminal()
        --切换阵型
        local battle_field_challenge_change_formation_terminal = {
            _name = "battle_field_challenge_change_formation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                app.load("client.formation.FormationChange") 
                local formationChangeWindow = FormationChange:new()
                fwin:open(formationChangeWindow, fwin._dialog)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --战斗
        local battle_field_challenge_fight_terminal = {
            _name = "battle_field_challenge_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local target  = params._datas._self
                local attackId = _ED._pet_battle_filed_info.current_attack_npc_id
                if attackId > 0 and attackId ~= zstring.tonumber(target._attackDate._player_id) then
                    --跟换攻打玩家弹出确认框
                    local function requestReset(instance,n)
                        if n == 0 then 
                            state_machine.excute("battle_field_challenge_fight_request",0,{_datas = {_self = target}})
                        end
                    end
                    app.load("client.utils.ConfirmPrompted")
                    local tip = ConfirmPrompted:new()
                    tip:init(self, requestReset, _pet_tipString_info[33])
                    fwin:open(tip,fwin._windows)
                    return
                end
                state_machine.excute("battle_field_challenge_fight_request",0,{_datas = {_self = target}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --战斗请求
        local battle_field_challenge_fight_request_terminal = {
            _name = "battle_field_challenge_fight_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local target  = params._datas._self
                local function responseFightCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.battle.BattleStartEffect")
                        fwin:cleanView(fwin._windows)
                        
                        local bse = BattleStartEffect:new()
                        bse:init(_enum_fight_type._fight_type_109)
                        fwin:open(bse, fwin._windows)
                
                    end
                end
                _ED._attack_battle_field_name = target ._attackDate._player_nick_name
                _ED._attack_battle_field_template = target ._zj_template_id
                protocol_command.pet_counterpart_launch.param_list = "" .. target ._currrent_index
                NetworkManager:register(protocol_command.pet_counterpart_launch.code, nil, nil, nil, target , responseFightCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(battle_field_challenge_change_formation_terminal)
        state_machine.add(battle_field_challenge_fight_terminal)
        state_machine.add(battle_field_challenge_fight_request_terminal)
        state_machine.init()
    end    
    init_battle_field_challenge_terminal()
end

function BattleFieldChallenge:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
    ccui.Helper:seekWidgetByName(root, "Text_hero_name"):setString(self._attackDate._player_nick_name)
    ccui.Helper:seekWidgetByName(root, "Text_hero_lv"):setString("" ..self._attackDate._player_level.. _string_piece_info[6])
    ccui.Helper:seekWidgetByName(root, "Text_zl_1"):setString(self._attackDate._player_fight)
    local zjTemplate = 1
    for i=1,6 do
        local playerDate = self._attackDate.formations[i]
        local Panel = ccui.Helper:seekWidgetByName(root, "Panel_tx_"..i)
        local perText = ccui.Helper:seekWidgetByName(root, "Text_hp_"..i)
        local template_id = zstring.tonumber(playerDate._player_template_id)
        local perCount = zstring.tonumber(playerDate._player_remain_hp)
        Panel:removeAllChildren(true)
        
        if template_id > 0 then 
            local cell = ShipHeadCell:createCell()
            cell:init(nil,5,template_id)
            local captain_type = dms.int(dms["ship_mould"],template_id,ship_mould.captain_type)
            if captain_type == 0 then 
                --主角的头像索引
                zjTemplate = playerDate._player_pic_index - 1000
                self._zj_template_id = template_id
            end
            Panel:addChild(cell)
            local imageHp = ccui.Helper:seekWidgetByName(root, "Image_hp_"..i)
            if perCount <= 0  then 
                --已经阵亡
                local wujiangPanel = ccui.Helper:seekWidgetByName(root, "Panel_wujiang_"..i)
                local noPlayerText = wujiangPanel:getChildByName("Text_dead")
                noPlayerText:setString(_pet_tipString_info[41])
                imageHp:setVisible(false)
            else
                imageHp:setVisible(true)
                perText:setString("" .. perCount .. "%")
                ccui.Helper:seekWidgetByName(root, "LoadingBar_hp_"..i):setPercent(perCount)
            end
        else

            local imageHp = ccui.Helper:seekWidgetByName(root, "Image_hp_"..i)
            imageHp:setVisible(false)
            local wujiangPanel = ccui.Helper:seekWidgetByName(root, "Panel_wujiang_"..i)
            local noPlayerText = wujiangPanel:getChildByName("Text_dead")
            noPlayerText:setString(_pet_tipString_info[40])

        end
    end
    local zjPanel = ccui.Helper:seekWidgetByName(root, "Panel_hero")
    zjPanel:removeBackGroundImage()
    zjPanel:setBackGroundImage(string.format("images/face/big_head/big_head_%s.png", "" ..zjTemplate ))
    local petPanel = ccui.Helper:seekWidgetByName(root, "Panel_pet")
    local noPetText = ccui.Helper:seekWidgetByName(root, "Text_wsz")
    local petNameText = ccui.Helper:seekWidgetByName(root, "Text_pet_name")
    local pet_template_id = self._attackDate.formations[7]._player_template_id
    noPetText:setVisible(false)
    petNameText:setString("")
    petPanel:removeAllChildren(true)

    if pet_template_id > 0 then 
        --有宠物
        petNameText:setString(dms.string(dms["ship_mould"],pet_template_id,ship_mould.captain_name))
        local qualituy = dms.int(dms["ship_mould"], pet_template_id, ship_mould.ship_type)
        petNameText:setColor(cc.c3b(color_Type[qualituy+1][1], color_Type[qualituy+1][2], color_Type[qualituy+1][3]))
        local cell = ShipHeadCell:createCell()
        cell:init(nil,5,pet_template_id)
        petPanel:addChild(cell)
    else
        noPetText:setVisible(true)
    end
    local unionText = ccui.Helper:seekWidgetByName(root, "Text_gonghui")
    if self._attackDate._player_union == nil
        or self._attackDate._player_union == "" 
        then 
        unionText:setString(tipStringInfo_union_str[69])
    else
        unionText:setString(self._attackDate._player_union)
    end
    ccui.Helper:seekWidgetByName(root, "Text_zsjl_1"):setString(self._attackDate._player_pet_soul)
    local rewards = zstring.split(dms.string(dms["pet_counterpart_mould"],_ED._pet_battle_filed_info.current_floor,pet_counterpart_mould.current_rewards),",")

    ccui.Helper:seekWidgetByName(root, "Text_glhd_1"):setString(""..rewards[3])
end

function BattleFieldChallenge:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("campaign/BattleField/BattleField_inter_window.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdateDraw()

	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		terminal_name = "battle_field_challenge_window_close",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)

    --布阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bz"), nil, 
    {
        terminal_name = "battle_field_challenge_change_formation",
        terminal_state = 0, 
        isPressedActionEnabled = true,
        _self = self,
    },
    nil,0)

    --战斗
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tz"), nil, 
    {
        terminal_name = "battle_field_challenge_fight",
        terminal_state = 0, 
        isPressedActionEnabled = true,
        _self = self,
    },
    nil,0)
    
end

function BattleFieldChallenge:onExit()
    state_machine.remove("battle_field_challenge_change_formation")
    state_machine.remove("battle_field_challenge_fight")
end

function BattleFieldChallenge:init(attackDate,index)
	self._attackDate = attackDate
    self._currrent_index = index

end
