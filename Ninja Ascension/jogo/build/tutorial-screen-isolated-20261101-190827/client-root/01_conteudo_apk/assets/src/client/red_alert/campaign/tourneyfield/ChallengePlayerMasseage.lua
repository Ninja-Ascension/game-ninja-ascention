--------------------------------------------------------------------------------------------------------------
--  皇城出站界面
--------------------------------------------------------------------------------------------------------------
ChallengePlayerMasseage = class("ChallengePlayerMasseageClass", Window)

--打开界面
local challenge_player_masseage_window_open_terminal = {
	_name = "challenge_player_masseage_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)  
        if fwin:find("ChallengePlayerMasseageClass") == nil then
            local user_data = params[1]
            if user_data == nil then
                return
            end
            local arena_id = params[2]
            fwin:open(ChallengePlayerMasseage:new():init(user_data,arena_id),fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local challenge_player_masseage_window_close_terminal = {
	_name = "challenge_player_masseage_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ChallengePlayerMasseageClass"))     
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(challenge_player_masseage_window_open_terminal)
state_machine.add(challenge_player_masseage_window_close_terminal)
state_machine.init()

function ChallengePlayerMasseage:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    -- var
    self._user_data = nil
    self._arena_id = nil
    -- load lua file
    app.load("client.red_alert.cells.hero.hero_icon_cell")

    local function init_challenge_player_masseage_terminal()
         --挑战
        local challenge_player_masseage_attack_terminal = {
            _name = "challenge_player_masseage_attack",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                app.load("client.red_alert.battle.battle_enum")
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            protocol_command.battle_result_verify.param_list = "0".."\r\n"..response.node._user_data.user_id.. "\r\n"..response.node._user_data.user_rank
                            app.load("client.red_alert.battle.battle_loading")
                            state_machine.excute("battle_loading_window_open",0,battle_enum._fight_type._fight_type_11)
                        end
                    end
                end
                local user_data = params._datas.user_data
                local scene_npc_tab = dms.string(dms["arena_config"],11,arena_config.param)
                scene_npc_tab = zstring.split(scene_npc_tab,",")
                local scene_id = scene_npc_tab[1]
                local npc_id = scene_npc_tab[2]
                _ED._current_scene_id = scene_id
                _ED._scene_npc_id = npc_id
                _ED._revenge_user_id = user_data.user_id
                _ED._npc_difficulty_index = "1"
                _ED._battle_init_type = battle_enum._fight_type._fight_type_11
                protocol_command.battle_result_start.param_list = ""..battle_enum._fight_type._fight_type_11.."\r\n".."0".."\r\n"..instance._user_data.user_id.. "\r\n"..instance._user_data.user_rank
                NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
        state_machine.add(challenge_player_masseage_attack_terminal)
        state_machine.init()
    end
    init_challenge_player_masseage_terminal()

end

function ChallengePlayerMasseage:onUpdateDraw()
    local root = self.roots[1]
    local Panel_header = ccui.Helper:seekWidgetByName(root,"Panel_header")
    Panel_header:removeAllChildren(true)
    local user_icon = state_machine.excute("user_head_icon_create",0,{self._user_data,1})
    Panel_header:addChild(user_icon)
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name")
    Text_name:setString(self._user_data.user_name)

    local Text_level = ccui.Helper:seekWidgetByName(root,"Text_level")
    local arena_official = dms.int(dms["arena_reward_param"],self._arena_id,arena_reward_param.arena_official)
    local color_table = red_alert_officer_color[arena_official]
    local arena_name = dms.string(dms["arena_reward_param"],self._arena_id,arena_reward_param.arena_name)
    arena_name = zstring.split(arena_name,",")
    arena_name = arena_name[tonumber(_ED.user_info.user_force)]
    
    Text_level:setString(red_alert_officer[arena_official])
    Text_level:setColor(cc.c3b(color_table[1],color_table[2],color_table[3]))
    
    local Text_combat_number = ccui.Helper:seekWidgetByName(root,"Text_combat_number")
    Text_combat_number:setString(self._user_data.user_fight)

    for i,v in pairs(self._user_data.ship_moulds) do
        local cell = state_machine.excute("hero_icon_create_cell",0,{v,4,0,true})
        local Panel_genral1_header = ccui.Helper:seekWidgetByName(root,"Panel_genral1_header_"..i)
        Panel_genral1_header:removeAllChildren(true)
        Panel_genral1_header:addChild(cell) 
    end

    local Button_challenge = ccui.Helper:seekWidgetByName(root, "Button_challenge")
    local my_arena_official = dms.int(dms["arena_reward_param"],_ED.arena_info.arena_id,arena_reward_param.arena_official)
    if tonumber(self._user_data.user_id) == tonumber(_ED.user_info.user_id)
        or my_arena_official - arena_official > 1 then
        Button_challenge:setVisible(false)
    end
end

--初始化界面
function ChallengePlayerMasseage:onInit()
    local csbItem = csb.createNode(config_csb.campaign.tourneyfield.challenge_player_masseage)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_player_message"), nil, 
    {
        terminal_name = "challenge_player_masseage_window_close", 
        terminal_state = 0, 
    }, nil, 0)     
    
    -- 换一批
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_challenge"), nil, 
    {
        terminal_name = "challenge_player_masseage_attack", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        user_data = self._user_data,
    }, nil, 0)   
    
   
    self:onUpdateDraw()
end

function ChallengePlayerMasseage:onEnterTransitionFinish()

end


function ChallengePlayerMasseage:close()

end

--初始化
function ChallengePlayerMasseage:init(user_data,arena_id)
    self._user_data = user_data
    self._arena_id = arena_id
	self:onInit()
    return self
end

--移除状态机
function ChallengePlayerMasseage:onExit()
    state_machine.remove("challenge_player_masseage_attack")
end