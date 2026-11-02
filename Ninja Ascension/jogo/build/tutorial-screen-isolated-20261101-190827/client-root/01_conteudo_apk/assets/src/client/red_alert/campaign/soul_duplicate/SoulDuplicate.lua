-----------------------------
--将魂副本
-----------------------------
SoulDuplicate = class("SoulDuplicateClass", Window)

local soul_duplicate_window_open_terminal = {
    _name = "soul_duplicate_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(115) == true then
            return
        end 
        if nil == fwin:find("SoulDuplicateClass") then
            fwin:open(SoulDuplicate:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local soul_duplicate_window_close_terminal = {
    _name = "soul_duplicate_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SoulDuplicateClass"))
        if fwin:find("TaskClass") ~= nil then
            state_machine.excute("campaign_window_close",0,"") 
            state_machine.excute("task_window_show",0,"") 
            state_machine.excute("player_resource_window_hide",0,"") 
            state_machine.excute("home_button_for_action_window_hide",0,"") 
            state_machine.excute("chat_view_window_hide",0,"")
            state_machine.excute("seven_star_map_ui_window_hide",0,"")
        end
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(soul_duplicate_window_open_terminal)
state_machine.add(soul_duplicate_window_close_terminal)
state_machine.init()

function SoulDuplicate:ctor()
    self.super:ctor()
    self.roots = {}
    self.listview = nil
    self.listview_PosY = nil

    app.load("client.red_alert.campaign.soul_duplicate.SoulDuplicateReward")
    app.load("client.red_alert.cells.campaign.soul_duplicate.soul_duplicate_cell")
    app.load("client.red_alert.cells.campaign.soul_duplicate.soul_duplicate_reward_cell")
    app.load("client.red_alert.campaign.soul_duplicate.SoulDuplicateResult")
    
    -- Initialize soul_duplicate state machine.
    local function init_soul_duplicate_terminal()
	
		  --挑战
		  local soul_duplicate_attack_npc_terminal = {
            _name = "soul_duplicate_attack_npc",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                --todo 请求改变npc
                if _ED.soul_duplicate.attack_count ~= 0 then
                    TipDlg.drawTextDailog(daily_string[9])
                    return
                end
                app.load("client.red_alert.battle.battle_enum")
                
                local npc_id = _ED.soul_duplicate.npc_id
                local scene_id = dms.string(dms["soul_copy_config"],5,soul_copy_config.param)
                _ED.npc_last_state[npc_id] = "".._ED.npc_state[npc_id]
                _ED._current_scene_id = scene_id
                _ED._scene_npc_id = npc_id
                _ED._npc_difficulty_index = "1"

                local function responseBattleStartCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        protocol_command.battle_result_verify.param_list = ""
                        app.load("client.red_alert.battle.battle_loading")
                        state_machine.excute("battle_loading_window_open",0,battle_enum._fight_type._fight_type_18)                                            
                    end
                end
                
                _ED._battle_init_type = battle_enum._fight_type._fight_type_18
                protocol_command.battle_result_start.param_list = ""..battle_enum._fight_type._fight_type_18
                NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(soul_duplicate_attack_npc_terminal)
        state_machine.init()
    end
    
    -- call func init soul_duplicate state machine.
    init_soul_duplicate_terminal()
end


function SoulDuplicate:onUpdateDraw()
    local root = self.roots[1]
    -- Text_camp_faction:setString(red_alert_hero_camp[tonumber(self.user_data.user_camp)])
    local ListView_right = ccui.Helper:seekWidgetByName(root,"ListView_right")
    ListView_right:removeAllItems()
    local Button_challenge = ccui.Helper:seekWidgetByName(root,"Button_challenge")  -- 挑战按钮
    local Panel_challenge_finish = ccui.Helper:seekWidgetByName(root,"Panel_challenge_finish")

    if _ED.soul_duplicate.attack_count ~= 0 then
        Button_challenge:setVisible(false)
        Panel_challenge_finish:setVisible(true)
    else
        Button_challenge:setVisible(true)
        --TipDlg.drawTextDailog(daily_string[9])
    end
    --绘制排行榜
    for i,user_info in pairs(_ED.soul_duplicate.rank_info) do
        local cell = state_machine.excute("soul_duplicate_create_cell",0,{user_info,i})
        ListView_right:addChild(cell)
    end
    ListView_right:requestRefreshView()

    self.listview = ListView_right
    self.listview_PosY = self.listview:getInnerContainer():getPositionY()

    -- 绘制个人信息
    local Text_rank_number = ccui.Helper:seekWidgetByName(root,"Text_rank_number") --我的排名
    local Text_harm_number = ccui.Helper:seekWidgetByName(root,"Text_harm_number") -- 我的伤害
    Text_harm_number:setString(_ED.soul_duplicate.my_damage.."%")
    if _ED.soul_duplicate.my_rank > 500 or _ED.soul_duplicate.my_rank == 0 then
        Text_rank_number:setString(red_alert_all_str[102])
    else
        Text_rank_number:setString(_ED.soul_duplicate.my_rank)
    end
    
    -- 绘制npc信息
    local Text_boss_name = ccui.Helper:seekWidgetByName(root,"Text_boss_name") -- boss名字
    local npc_name = dms.string(dms["npc"],_ED.soul_duplicate.npc_id,npc.npc_name)
    Text_boss_name:setString(npc_name)
    self:createNpcAnimation()
end

--创建npc形象
function SoulDuplicate:createNpcAnimation()
    local root = self.roots[1]
    local Panel_boss = ccui.Helper:seekWidgetByName(root,"Panel_boss")
    app.load("client.battle.fight.FightEnum")
    local temp_bust_index = dms.int(dms["npc"],_ED.soul_duplicate.npc_id,npc.head_pic)
    temp_bust_index = 10000 + temp_bust_index
    local armature = sp.spine_sprite(Panel_boss, temp_bust_index, _spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_10+1], true, nil, nil, cc.p(0.5, 0))
    armature:setPosition(cc.p(Panel_boss:getContentSize().width/2, 0))
end

function SoulDuplicate:onUpdate()
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_PosY == posY then
            return
        end
        self.listview_PosY = posY
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function SoulDuplicate:onEnterTransitionFinish()
   self:checkReward()
end

function SoulDuplicate:checkReward()
   -- state_machine.excute("reward_obtain_window_open",0,{69})
   state_machine.excute("soul_duplicate_result_window_open",0,{69})
end

function SoulDuplicate:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.soul_duplicate.soul_duplicate)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    local Button_challenge = ccui.Helper:seekWidgetByName(root,"Button_challenge")  -- 挑战按钮
    Button_challenge:setVisible(false)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "soul_duplicate_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --挑战
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_challenge"), nil, 
    {
        terminal_name = "soul_duplicate_attack_npc", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    

    --奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_reward"), nil, 
    {
        terminal_name = "soul_duplicate_reward_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    local function draw_other()
       self:onUpdateDraw() 
    end
    local run_action = cc.Sequence:create({cc.DelayTime:create(0), cc.CallFunc:create(function(sender)
        draw_other()
    end)})
	self:runAction(run_action)
end

function SoulDuplicate:init()
	self:onInit()
    return self
end

function SoulDuplicate:onExit()
    state_machine.remove("soul_duplicate_attack_npc",0,"")
end
