-----------------------------
--副本地图顶部信息栏
-----------------------------
DuplicateNpcWindow = class("DuplicateNpcWindowClass", Window)

--打开界面
local duplicate_npc_window_open_terminal = {
    _name = "duplicate_npc_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _duplicateNpcWindow = fwin:find("DuplicateNpcWindowClass")
        if nil == _duplicateNpcWindow then
            if type(params) == "table" then
                terminal._datas = params._datas -- 记录数据
            end

            local npc_id = terminal._datas.npc_id
            local scene_id = terminal._datas.scene_id  
            local boss_flag = terminal._datas.boss_flag  
            local npc_state = terminal._datas.npc_state
            local index = terminal._datas.index
            fwin:open(DuplicateNpcWindow:new():init(npc_id,scene_id,boss_flag,npc_state,index), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local duplicate_npc_window_close_terminal = {
    _name = "duplicate_npc_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("DuplicateNpcWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(duplicate_npc_window_open_terminal)
state_machine.add(duplicate_npc_window_close_terminal)
state_machine.init()

function DuplicateNpcWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    
    --load lua file 
    app.load("client.red_alert.duplicate.DulipcateBuyTimes")
    app.load("client.red_alert.battle.battle_enum")
    --var
    --用户ID
    self.npc_id = nil
    --场景ID
    self.scene_id = nil
    --boss标记
    self.boss_flag = nil
    --角色状态
    self.npc_state = nil
    --场景类型
    self.scene_type = nil
    --需要体力量
    self.need_food = nil
    --npc 顺序
    self._index = nil
    -- Initialize duplicate_npc_window state machine.
    local function init_duplicate_npc_window_terminal()
	
        -- 出战
        local duplicate_window_go_fight_terminal = {
            _name = "duplicate_window_go_fight",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 处理 开战时 体力不足 -----------------
                local max_times = dms.int(dms["npc"],instance.npc_id,npc.daily_attack_count)
                if zstring.tonumber(_ED.user_info.user_food) < zstring.tonumber(instance.need_food) then
                    state_machine.excute("buy_resource_window_open",0,{_datas = 
                    {
                        resource_type = 1
                    }})
                    return
                end

                -- 处理开战时候 次数不足
                local fight_type = 0
                if instance.scene_type == 15 then
                    fight_type = battle_enum._fight_type._fight_type_15
                    if tonumber(_ED.npc_hard_all_attack_times) >= dms.int(dms["copy_config"],1,copy_config.param) then
                        TipDlg.drawTextDailog(red_alert_all_str[162])
                        return
                    end
                    --攻击次数
                    local attack_times = zstring.tonumber(_ED.npc_current_attack_count[tonumber(instance.npc_id)])
                    
                    local times = max_times - attack_times
                    if times <= 0 then
                        TipDlg.drawTextDailog(red_alert_all_str[124])
                        return
                    end
                elseif instance.scene_type == 1 then
                    --攻击次数
                    fight_type = battle_enum._fight_type._fight_type_1
                    local attack_times = zstring.tonumber(_ED.npc_current_attack_count[tonumber(instance.npc_id)])
                    --购买次数
                    local now_times = zstring.tonumber(_ED.npc_current_buy_count[tonumber(instance.npc_id)])
                    
                    local times = max_times - attack_times + now_times
                    if times <= 0 then
                        TipDlg.drawTextDailog(red_alert_all_str[124])
                        return
                    end
                elseif instance.scene_type == 104 then
                    --攻击次数
                    fight_type = battle_enum._fight_type._fight_type_104
                    local attack_times = zstring.tonumber(_ED.npc_current_attack_count[tonumber(instance.npc_id)])
                    local times = max_times - attack_times
                    if times <= 0 then
                        TipDlg.drawTextDailog(red_alert_all_str[124])
                        return
                    end
                end

                instance.npc_id = zstring.tonumber(instance.npc_id)
                _ED.npc_last_state[instance.npc_id] = "".._ED.npc_state[instance.npc_id]
                _ED._current_scene_id = instance.scene_id
                _ED._scene_npc_id = instance.npc_id
                _ED._npc_difficulty_index = "1"
                local function responseBattleStartCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        protocol_command.battle_result_verify.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id
                        app.load("client.red_alert.battle.battle_loading")
                        state_machine.excute("battle_loading_window_open",0,fight_type)                                            
                    end
                end
                _ED.show_reward_list_group = {}
                _ED.last_level = _ED.user_info.user_grade
                _ED.last_user_food = "".. (zstring.tonumber(_ED.user_info.user_food) - zstring.tonumber(instance.need_food))
                _ED._battle_init_type = fight_type
                protocol_command.battle_result_start.param_list = ""..fight_type.."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id.."\r\n"
                NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        --购买次数
        local duplicate_window_buy_npc_attack_times_terminal = {
            _name = "duplicate_window_buy_npc_attack_times",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("dulipcate_buy_times_window_open",0,{self.npc_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新攻击次数
        local duplicate_window_update_attack_times_terminal = {
            _name = "duplicate_window_update_attack_times",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:drawBuyTimes()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }       
        state_machine.add(duplicate_window_go_fight_terminal)
        state_machine.add(duplicate_window_buy_npc_attack_times_terminal)
        state_machine.add(duplicate_window_update_attack_times_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_duplicate_npc_window_terminal()
end

--更新界面
function DuplicateNpcWindow:onUpdateDraw()
    local root = self.roots[1]

    --胜利星级
    local star = 0
    if zstring.tonumber(_ED.npc_state[tonumber(""..self.npc_id)]) < zstring.tonumber(_ED.npc_max_state[tonumber(""..self.npc_id)]) and zstring.tonumber(_ED.npc_state[tonumber(""..self.npc_id)]) ~= 0 then
        star = tonumber(_ED.npc_max_state[tonumber(""..self.npc_id)])
    else
        star = tonumber(_ED.npc_state[tonumber(""..self.npc_id)])
    end          
    for i = 1 , star do
        local Image_fit_star = ccui.Helper:seekWidgetByName(root,"Image_fit_star_"..i)
        Image_fit_star:setVisible(true)
    end

    --挑战需要体力
    local attack_need_food = dms.int(dms["npc"],self.npc_id,npc.attack_need_food)
    self.need_food = attack_need_food
    local Text_power_fighting = ccui.Helper:seekWidgetByName(root,"Text_power_fighting")
    local Text_dup_pw_infor = ccui.Helper:seekWidgetByName(root,"Text_dup_pw_infor")
    local Image_8 = ccui.Helper:seekWidgetByName(root,"Image_8")
    local Text_dup_dropped = ccui.Helper:seekWidgetByName(root,"Text_dup_dropped") 
    Text_power_fighting:setString(attack_need_food)

    --战斗npc图标
    local Panel_npc_fighting = ccui.Helper:seekWidgetByName(root,"Panel_npc_fighting")      
    Panel_npc_fighting:setVisible(true)
    Panel_npc_fighting:removeAllChildren(true)
    local temp_bust_index = dms.int(dms["npc"], self.npc_id, npc.head_pic)
    if self.scene_type == battle_enum._fight_type._fight_type_104 then -- 七星台npc绘制
        for i = 1, dms.count( dms["seven_units_param"] ) do 
            if tonumber(self.scene_id) == dms.int(dms["seven_units_param"],i,seven_units_param.scene_id)
            and tonumber(_ED.user_info.user_grade) >= dms.int(dms["seven_units_param"],i,seven_units_param.start_level)
            and tonumber(_ED.user_info.user_grade) <= dms.int(dms["seven_units_param"],i,seven_units_param.end_level)
            then
                local image_id = zstring.split(dms.string(dms["seven_units_param"], i, seven_units_param.image_id), ",")
                temp_bust_index = image_id[self._index]
            end
        end
        for i = 1 , 3 do
            local Image_fit_star = ccui.Helper:seekWidgetByName(root,"Image_fit_star_"..i)
            Image_fit_star:setVisible(false)
            local Image_fighting_star = ccui.Helper:seekWidgetByName(root,"Image_fighting_star_"..i)
            Image_fighting_star:setVisible(false)
        end
        Text_power_fighting:setVisible(false)
        Text_dup_pw_infor:setVisible(false)
        Image_8:setVisible(false)
        Text_dup_dropped:setString(seven_star_tipStringInfo[1])
    end
    -- temp_bust_index = 10000 + temp_bust_index
    local jsonPath = "images/face/big_head/big_head_" .. temp_bust_index .. ".json"
    local atlasPath = "images/face/big_head/big_head_" .. temp_bust_index .. ".atlas"
    local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", true, nil)
    animation:setPosition(cc.p(Panel_npc_fighting:getContentSize().width/2,Panel_npc_fighting:getContentSize().height/2))
    Panel_npc_fighting:addChild(animation)

    --npc描述签名
    local Text_say = ccui.Helper:seekWidgetByName(root,"Text_say")
    local say_dec = dms.string(dms["npc"],self.npc_id,npc.sign_msg)     
    Text_say:setString(say_dec)

    --npc名称
    local Text_npc_window_name = ccui.Helper:seekWidgetByName(root,"Text_npc_window_name")  
    local npc_name = dms.string(dms["npc"],self.npc_id,npc.npc_name)                        
    Text_npc_window_name:setString(npc_name)

    --掉落库表
    local rewardID = dms.int(dms["npc"],self.npc_id,npc.drop_library)
    -- print("=========",rewardID)
    local ListView_dropped = ccui.Helper:seekWidgetByName(root,"ListView_dropped")
    ListView_dropped:removeAllChildren(true)
    if rewardID > 0 then
        local reward_items = dms.string(dms["scene_reward"], rewardID, scene_reward.reward_items)
        reward_items = zstring.split(reward_items,"|")
        for i,reward in ipairs(reward_items) do
            local reward_tab = zstring.split(reward,",")
            local _prop_type = tonumber(reward_tab[2])
            local _prop_item = tonumber(reward_tab[1])
            local _item_value = tonumber(reward_tab[3])
            local data = 
            {
                item_value = _item_value,
                prop_type = _prop_type,
                prop_item = _prop_item,
            }

            local cell = nil
            if _prop_type == 6 then
                local equipment_mould_id = zstring.tonumber(dms.int(dms["prop_mould"], _prop_item, prop_mould.change_of_equipment))
                local ship_mould_id = zstring.tonumber(dms.int(dms["prop_mould"],_prop_item, prop_mould.use_of_ship))
                if equipment_mould_id > 0 or ship_mould_id > 0 then
                    cell = state_machine.excute("all_resource_create_cell",0,{3,data,data,9,0,false,true})
                else
                    cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
                end
                ListView_dropped:addChild(cell)
            else
                cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
                ListView_dropped:addChild(cell)
            end
        end
    end    
end

--购买挑战次数
function DuplicateNpcWindow:drawBuyTimes()
    local root = self.roots[1]
    local Panel_not_easy_duplicate = ccui.Helper:seekWidgetByName(root,"Panel_not_easy_duplicate")
    local Panel_normal_duplicate = ccui.Helper:seekWidgetByName(root,"Panel_normal_duplicate")
    local Text_leave_times = ccui.Helper:seekWidgetByName(root,"Text_leave_times")
    --最大次数
    local max_times = dms.int(dms["npc"],self.npc_id,npc.daily_attack_count)
    --攻击次数
    local attack_times = zstring.tonumber(_ED.npc_current_attack_count[tonumber(self.npc_id)])
    if self.scene_type == 0 or self.scene_type == battle_enum._fight_type._fight_type_104 then
        Panel_normal_duplicate:setVisible(false)
        Panel_not_easy_duplicate:setVisible(false)
    elseif self.scene_type == 1 then
        Panel_not_easy_duplicate:setVisible(true)
        Panel_normal_duplicate:setVisible(true)
        --todo 获得精英剩余次数
        --购买次数
        local now_times = zstring.tonumber(_ED.npc_current_buy_count[tonumber(self.npc_id)])
        
        local times = max_times - attack_times + now_times
        Text_leave_times:setString(times)
    elseif self.scene_type == 15 then
        Panel_not_easy_duplicate:setVisible(true)
        Panel_normal_duplicate:setVisible(false)
        local times = max_times - attack_times
        Text_leave_times:setString(times)
    end
end

function DuplicateNpcWindow:onEnterTransitionFinish()
    
end

--初始化界面
function DuplicateNpcWindow:onInit( )
    local csbItem = csb.createNode(config_csb.duplicate.duplicate_npc_window)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.duplicate.duplicate_npc_window)
    table.insert(self.actions, action)
    action:setTimeSpeed(app.getTimeSpeed())
    action:play("window_open", false)
    csbItem:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then

        end  
    end)
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_npc_window"), nil, 
    {
        terminal_name = "duplicate_npc_window_close", 
        terminal_state = 0, 
    }, nil, 0)

    --攻击
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_attack"), nil, 
    {
        terminal_name = "duplicate_window_go_fight", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --购买次数
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_buy_times"), nil, 
    {
        terminal_name = "duplicate_window_buy_npc_attack_times", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    local Button_raids = ccui.Helper:seekWidgetByName(root,"Button_raids")
    --扫荡
    fwin:addTouchEventListener(Button_raids, nil, 
    {
        terminal_name = "duplicate_raids_window_open", 
        terminal_state = 0,
        npc_id = self.npc_id ,
        scene_type = self.scene_type,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    if self.npc_state ~= 0 or self.scene_type == battle_enum._fight_type._fight_type_104 then
        Button_raids:setVisible(false)
    end
	self:onUpdateDraw()	
    self:drawBuyTimes()
end

--初始化
function DuplicateNpcWindow:init(npc_id,scene_id,boss_flag,npc_state,index)
    self.npc_id = npc_id
    self.scene_id = scene_id
    self.boss_flag = boss_flag
    self.npc_state = npc_state
    self.scene_type = dms.int(dms["pve_scene"],self.scene_id,pve_scene.scene_type)
    self._index = index
    -- 环境阵型
    if self.scene_type == battle_enum._fight_type._fight_type_104 then
        for i = 1, dms.count( dms["seven_units_param"] ) do 
            if tonumber(self.scene_id) == dms.int(dms["seven_units_param"],i,seven_units_param.scene_id)
            and tonumber(_ED.user_info.user_grade) >= dms.int(dms["seven_units_param"],i,seven_units_param.start_level)
            and tonumber(_ED.user_info.user_grade) <= dms.int(dms["seven_units_param"],i,seven_units_param.end_level)
            then
                local formation = zstring.split(dms.string(dms["seven_units_param"], i, seven_units_param.formation), ",")
                _ED._seven_star_formation = formation[self._index]
            end
        end
    end
	self:onInit()
    return self
end

--移除状态机
function DuplicateNpcWindow:onExit()
    state_machine.remove("duplicate_window_go_fight")
    state_machine.remove("duplicate_window_buy_npc_attack_times")
    state_machine.remove("duplicate_window_update_attack_times") 
end
