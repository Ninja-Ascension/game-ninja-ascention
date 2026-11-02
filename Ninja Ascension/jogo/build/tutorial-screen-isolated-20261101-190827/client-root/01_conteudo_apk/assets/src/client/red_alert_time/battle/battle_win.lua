-----------------------------
--战斗胜利
-----------------------------
BattleWin = class("BattleWinClass", Window)

--打开战斗胜利界面
local battle_win_window_open_terminal = {
    _name = "battle_win_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("battle_ui_window_close", 0, 0)
        local _Window = fwin:find("BattleWinClass")
        if nil == _Window then
            local star = params[1]
            fwin:open(BattleWin:new():init(star), fwin._view)
        end
        
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭战斗胜利界面
local battle_win_window_close_terminal = {
    _name = "battle_win_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleWinClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_win_window_open_terminal)
state_machine.add(battle_win_window_close_terminal)
state_machine.init()

function BattleWin:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    --var
    self.rewardList = nil
    --星级
    self.star = 3
    --原经验值百分比
    self.percent = nil
    --播放星级动画状态
    self.play_loading_action = false
    --经验条
    self.loadingbar = nil
    --当前经验值百分比
    self.now_percent = 0
    --战斗胜利获得道具列表
    self.reward_cells = {}

    -- Initialize battle_win state machine.
    local function init_battle_win_terminal()
	    local battle_win_play_animation_terminal = {
            _name = "battle_win_play_animation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:playAnimations()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(battle_win_play_animation_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_battle_win_terminal()
end

--刷新战斗胜利获得道具列表
function BattleWin:onUpdateDraw()
    -- debug.print_r(_ED.user_info)
    -- debug.print_r(self.rewardList)    
    local root = self.roots[1]
    local add_exp = 0
    local ListView_victory_in_battle = ccui.Helper:seekWidgetByName(root,"ListView_victory_in_battle")      --战斗胜利获得道具列表
    if self.rewardList ~= nil then
        for i,v in pairs(self.rewardList.show_reward_list) do
            if zstring.tonumber(v.prop_type) ~= 8 then
                local cell = nil
                if zstring.tonumber(v.prop_type) == 6 and 
                    (zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.change_of_equipment))> 0 
                    or zstring.tonumber(dms.int(dms["prop_mould"], zstring.tonumber(v.prop_item), prop_mould.use_of_ship)) > 0) then
                    cell = state_machine.excute("all_resource_create_cell",0,{3,v,v,9,0})
                elseif zstring.tonumber(v.prop_type) == 7 then
                    cell = state_machine.excute("all_resource_create_cell",0,{6,v,v,9,0})
                elseif zstring.tonumber(v.prop_type) == 13 then
                    cell = state_machine.excute("all_resource_create_cell",0,{7,v,v,9,0})
                else
                    cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,9,0})
                end
                ListView_victory_in_battle:addChild(cell)
                cell:setVisible(false)
                table.insert(self.reward_cells,cell)
            elseif zstring.tonumber(v.prop_type) == 8 then
                add_exp = tonumber(v.item_value)
            end
        end
    end
    ListView_victory_in_battle:requestRefreshView()

    -- 绘制主公动画
    local Panel_player_role = ccui.Helper:seekWidgetByName(root,"Panel_player_role")
    if nil ~= Panel_player_role and Panel_player_role:isVisible() == true then
        local jsonPath = nil
        local atlasPath = nil
        if tonumber(_ED.user_info.user_gender) == 1 then
            jsonPath = "sprite/spirte_nanzhu.json"
            atlasPath = "sprite/spirte_nanzhu.atlas"
        elseif tonumber(_ED.user_info.user_gender) == 2 then
            jsonPath = "sprite/spirte_nvzhu.json"
            atlasPath = "sprite/spirte_nvzhu.atlas"
        end
        local animation = sp.spine(jsonPath, atlasPath, 1, 0, null, false, nil)
        animation:addAnimation(0, "animation_victory", false)
        animation:addAnimation(0, "animation", true)
        -- local animation = sp.spine(jsonPath, atlasPath, 1, 0, "animation", false, nil)
        animation:setPosition(cc.p(Panel_player_role:getContentSize().width / 2, 0))
        Panel_player_role:addChild(animation)
    end

    local user_experience = tonumber(_ED.user_info.user_experience)
    local user_grade_need_experience = tonumber(_ED.user_info.user_grade_need_experience)
    local Text_victory_in_battle_lv = ccui.Helper:seekWidgetByName(root,"Text_victory_in_battle_lv")        --角色等级
    Text_victory_in_battle_lv:setString(string.format(red_alert_all_str[13],_ED.user_info.user_grade))
    local Text_victory_in_battle_exp = ccui.Helper:seekWidgetByName(root,"Text_victory_in_battle_exp")      --角色经验值
    Text_victory_in_battle_exp:setString("+"..zstring.tonumber(_ED.user_info.change_experience))
    self.percent = math.floor((user_experience / user_grade_need_experience) *100)
    local LoadingBar_victory_in_battle = ccui.Helper:seekWidgetByName(root,"LoadingBar_victory_in_battle")  --经验条
    LoadingBar_victory_in_battle:setPercent(self.now_percent)    
    self.loadingbar = LoadingBar_victory_in_battle
    self:playArmatureNodeAnimation()

    local Panel_2xing = ccui.Helper:seekWidgetByName(root,"Panel_2xing")
    local Panel_3xing = ccui.Helper:seekWidgetByName(root,"Panel_3xing")
    Panel_2xing:setVisible(false)
    Panel_3xing:setVisible(false)
    if self.star == 2 then
        Panel_2xing:setVisible(true)
    elseif self.star == 3 then
        Panel_2xing:setVisible(true)
        Panel_3xing:setVisible(true)
    end
end

--播放战斗胜利动画
function BattleWin:playArmatureNodeAnimation()
    local root = self.roots[1]
    local Panel_open = ccui.Helper:seekWidgetByName(root, "Panel_open")
    local Panel_win = ccui.Helper:seekWidgetByName(root, "Panel_win")
    local Panel_text_win = ccui.Helper:seekWidgetByName(root,"Panel_text_win")
    local ArmatureNode_1 = Panel_open:getChildByName("ArmatureNode_1")
    local ArmatureNode_1_0 = Panel_win:getChildByName("ArmatureNode_1_0")
    local ArmatureNode_win = Panel_text_win:getChildByName("ArmatureNode_win")
    Panel_text_win:setVisible(true)
    Panel_open:setVisible(true)
    if nil ~= ArmatureNode_1 then
        local animation = ArmatureNode_1:getAnimation()
        local animation_2 = ArmatureNode_1_0:getAnimation()
        local animationEventCallFunc = function()
            Panel_open:setVisible(false)
            Panel_win:setVisible(true)
            animation_2:playWithIndex(1, 0, -1)
        end 
        animation:playWithIndex(0, 0, 0)
        animation:setMovementEventCallFunc(animationEventCallFunc)
    end

    local animation_3 = ArmatureNode_win:getAnimation()
    if nil ~= animation_3 then
        animation_3:playWithIndex(0, 0, 0)
    end
    local function doOther()
        state_machine.excute("battle_win_play_animation",0,"")

    end
    Panel_text_win:runAction(cc.Sequence:create(cc.DelayTime:create(0.5), cc.CallFunc:create(doOther)))
end

--播放星星动画
function BattleWin:playAnimations()
    local root = self.roots[1]
    local action = self.actions[1]
    local star = self.star
    local Panel_infor = ccui.Helper:seekWidgetByName(root, "Panel_infor")       --信息层
    local Panel_win_star = ccui.Helper:seekWidgetByName(root,"Panel_win_star") 

    local Button_victory_in_battle_go_on = ccui.Helper:seekWidgetByName(root,"Button_victory_in_battle_go_on")  --继续按钮
    Button_victory_in_battle_go_on:setVisible(true)
    Button_victory_in_battle_go_on:setOpacity(0)
    Button_victory_in_battle_go_on:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.FadeIn:create(1)))
    if _ED._battle_init_type == battle_enum._fight_type._fight_type_11 then
        Panel_infor:setVisible(false)
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_16 then--宝石
        Panel_infor:setVisible(false)
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_17 then-- 兵器
        Panel_infor:setVisible(false)
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_10 then
        Panel_infor:setVisible(false)
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_18 then
        Panel_infor:setVisible(false)
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_19 then  -- 运送军资
        Panel_infor:setVisible(false)
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_23 then  -- 资源掠夺
        Panel_infor:setVisible(false)
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_102 then
        Panel_infor:setVisible(false)
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_103 then-- 神兵副本
        Panel_infor:setVisible(false)
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_104 then-- 七星台
        Panel_infor:setVisible(false)
    else
        Panel_infor:setVisible(true)
    end

    if nil ~= Panel_win_star then
        -- batlle win star with spine
        local skeletonNode = sp.spine(config_res.images.ui.effice.spirte_star.json, config_res.images.ui.effice.spirte_star.atlas, 1, 0, nil, false, nil)
        skeletonNode:registerSpineEventHandler(function (event)
            -- event.skeletonAnimation:pause()
            -- self:playLoadingBarAction()
        end, sp.EventType.ANIMATION_COMPLETE)

        skeletonNode:registerSpineEventHandler(function (event)
            if event.eventData.stringValue == config_res.images.ui.effice.spirte_star.animation_events.playmusic then
                playEffectMusic(config_res.images.ui.effice.spirte_star.music)
            elseif event.eventData.stringValue == config_res.images.ui.effice.spirte_star.animation_events.shake then
                action:stop()
                action:play("battle_star", false)
            elseif event.eventData.stringValue == config_res.images.ui.effice.spirte_star.animation_events.animation_over then
                event.skeletonAnimation:pause()
                self:playLoadingBarAction()
            end
        end, sp.EventType.ANIMATION_EVENT)

        skeletonNode:setAnimation(0, config_res.images.ui.effice.spirte_star.animations[star], true)
        Panel_win_star:addChild(skeletonNode)
    else
        local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star")          --星星动画层

        if _ED._battle_init_type == battle_enum._fight_type._fight_type_11 then
            Panel_star:setVisible(false)
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_16 then--宝石
            Panel_star:setVisible(false)
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_17 then-- 兵器
            Panel_star:setVisible(false)
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_10 then
            Panel_star:setVisible(false)
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_18 then
            Panel_star:setVisible(false)
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_19 then  -- 运送军资
            Panel_star:setVisible(false)
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_102 then
            Panel_star:setVisible(true)
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_103 then-- 神兵副本
            Panel_star:setVisible(false)
        elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_104 then-- 七星台
            Panel_star:setVisible(false)
        else
            Panel_star:setVisible(true)
        end
        
        local ArmatureNode_star_1 = Panel_star:getChildByName("ArmatureNode_star_1")
        local ArmatureNode_star_2 = Panel_star:getChildByName("ArmatureNode_star_2")
        local ArmatureNode_star_3 = Panel_star:getChildByName("ArmatureNode_star_3")
        local animation_1 = ArmatureNode_star_1:getAnimation()
        local animation_2 = ArmatureNode_star_2:getAnimation()
        local animation_3 = ArmatureNode_star_3:getAnimation()

        action:play("victory_in_battle_star_1", false)
        action:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end
            
            local str = frame:getEvent()
            if str == "victory_in_battle_star_1_over" then
                if star == 1 then
                    animation_1:playWithIndex(0, 0, 0)
                    self:playLoadingBarAction()
                else
                    animation_1:playWithIndex(0, 0, 0)
                    local animationStarTwo = function()
                        action:play("victory_in_battle_star_2", false)
                    end 
                    animation_1:setMovementEventCallFunc(animationStarTwo)
                end
            elseif str == "victory_in_battle_star_2_over" then
                if star == 2 then
                    animation_2:playWithIndex(0, 0, 0)
                    self:playLoadingBarAction()
                else
                    animation_2:playWithIndex(0, 0, 0)
                    local animationStarThree = function()
                        action:play("victory_in_battle_star_3", false)
                    end 
                    animation_2:setMovementEventCallFunc(animationStarThree)
                end            
            elseif str == "victory_in_battle_star_3_over" then
                animation_3:playWithIndex(0, 0, 0)
                self:playLoadingBarAction()
            end
        end)    
    end

    local max_cell = #self.reward_cells
    local index = 1
    --战斗胜利获得道具顺序显示
    local function playRewardCells()
        if index > max_cell then
            self:stopAllActions()
            return
        else
            self.reward_cells[index]:setVisible(true)
            index = index + 1 
        end
    end
    local action_2 = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.2),cc.CallFunc:create(playRewardCells)))
    self:runAction(action_2)
end

function BattleWin:onEnterTransitionFinish()
    
end

--播放星级动画
function BattleWin:playLoadingBarAction()
    local root = self.roots[1]
    self.play_loading_action = true
end

--刷新经验条
function BattleWin:onUpdate(dt)
    if self.play_loading_action == true then
        self.now_percent = self.now_percent + 4
        if self.now_percent > self.percent then
            self.play_loading_action = false
            return
        end
        -- ccui.Helper:seekWidgetByName(self.roots[1],"Button_victory_in_battle_go_on"):setVisible(true)
        self.loadingbar:setPercent(self.now_percent)
    end
end

--初始化战斗胜利界面
function BattleWin:onInit( )
    local csbItem = csb.createNode(config_csb.battle.battle_win)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.battle.battle_win)
    table.insert(self.actions,action)
    csbItem:runAction(action)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_victory_in_battle_go_on"), nil, 
    {
        terminal_name = "battle_win_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    
	self:onUpdateDraw()	

    local Panel_infor = ccui.Helper:seekWidgetByName(root,"Panel_infor")
    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star")
    Panel_infor:setVisible(false)
    if nil ~= Panel_star then
        Panel_star:setVisible(false)
    end
end


function BattleWin:init(star)
    self.star = star or self.star
    if _ED._battle_init_type == battle_enum._fight_type._fight_type_102 then
        -- self.rewardList = getSceneReward(37)
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_10 then
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_24 then
    else
        self.rewardList = getSceneReward(2)
    end
	self:onInit()
    return self
end

--关闭战斗胜利界面
function BattleWin:destroy()
    -- cacher.removeAllTextures()
    -- fwin:reset(nil)
    -- fwin:removeAll()
    -- fwin:freeAllMemeryPool()
    fwin:removeAll()
    cacher.destorySystemCacher()
    if _ED._battle_init_type == battle_enum._fight_type._fight_type_0 then      -- 普通
        -- app.load("client.red_alert_time.activity.wonderful.ActivityFristRechargeTop")
        -- if tonumber(_ED._current_scene_id) == 1 then
        --     local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(_ED._current_scene_id), pve_scene.npcs), ",")
        --     local maxNpcId = tonumber(tempNpcIds[#tempNpcIds])
        --     if maxNpcId - 1 == tonumber(_ED._scene_npc_id)
        --         and _ED.activity_info["2"] ~= nil 
        --         and zstring.tonumber(_ED.user_info.recharge_all_rmb) == 0
        --         and zstring.tonumber(_ED.npcLastState) == 0
        --         then
        --         state_machine.excute("activity_frist_recharge_top_window_open", 0, nil)
        --     end
        -- end
        -- state_machine.excute("duplicate_manager_window_open",0,{1})
        state_machine.excute("duplicate_title_window_open",0,"")
        state_machine.excute("duplicate_map_window_open",0,"")

        -- -- 移除25元月卡在主线副本4-1战斗胜利的弹出
        -- if tonumber(_ED._current_scene_id) == 4 then
        --     local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(_ED._current_scene_id), pve_scene.npcs), ",")
        --     local firstNpcId = tonumber(tempNpcIds[1])
        --     if firstNpcId == tonumber(_ED._scene_npc_id) 
        --         and zstring.tonumber(_ED.npcLastState) == 0
        --         then
        --         app.load("client.red_alert_time.activity.wonderful.ActivityMonthCardPush")
        --         state_machine.excute("activity_month_card_window_open", 0, {_scene_id = 4})
        --     end
        -- end
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_1 then  -- 精英
        -- state_machine.excute("duplicate_manager_window_open",0,{2})
        state_machine.excute("duplicate_title_window_open",0,"")
        state_machine.excute("duplicate_map_window_open",0,"")
        

        -- -- 移除25元月卡在精英副本3-1战斗胜利的弹出
        -- if tonumber(_ED._current_scene_id) == 23 then
        --     local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(_ED._current_scene_id), pve_scene.npcs), ",")
        --     local firstNpcId = tonumber(tempNpcIds[1])
        --     if firstNpcId == tonumber(_ED._scene_npc_id) 
        --         and zstring.tonumber(_ED.npcLastState) == 0
        --         then
        --         app.load("client.red_alert_time.activity.wonderful.ActivityMonthCardPush")
        --         state_machine.excute("activity_month_card_window_open", 0, {_scene_id = 23})
        --     end
        -- end
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_15 then -- 炼狱
        -- state_machine.excute("duplicate_manager_window_open",0,{3})
        state_machine.excute("duplicate_title_window_open",0,"")
        state_machine.excute("duplicate_map_window_open",0,"")
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_10 then
        state_machine.excute("campaign_window_open",0,"")
        state_machine.excute("raiders_cut_window_open",0,"")
        -- state_machine.excute("national_truce_loading_window_open", 0, {_datas = {open_type = 1}})
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_11 then
        state_machine.excute("tourneyfield_window_open",0,"")
        if _ED.arena_info.last_user_arena_id ~= nil then
            if _ED.arena_info.arena_id > _ED.arena_info.last_user_arena_id then--如果当前官阶更低或者没变，不播放动画
                --如果当前官阶更低或者没变，不播放动画
                state_machine.excute("tourneyfield_officer_window_open",0,"")
            end
        end
        -- 第一次弹出首冲
        if _ED.frist_enter_tourneyField == nil or _ED.frist_enter_tourneyField == false then
            local last_open_scene = 1
            for k,v in pairs(_ED.scene_current_state) do
                if tonumber(v) >= 0 then
                    last_open_scene = k
                else
                    break
                end
            end
            if last_open_scene == 2 then
                local tempNpcIds = zstring.split(dms.string(dms["pve_scene"], tonumber(last_open_scene), pve_scene.npcs), ",")
                local minNpcId = tonumber(tempNpcIds[1])
                local minNpcState = _ED.npc_state[minNpcId]
                if tonumber(minNpcState) <= 0
                    and _ED.activity_info["2"] ~= nil
                    and zstring.tonumber(_ED.user_info.recharge_all_rmb) == 0
                    then
                    state_machine.excute("activity_frist_recharge_top_window_open", 0, nil)
                end
            end
        end
        _ED.frist_enter_tourneyField = true
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_16 then --宝石
        state_machine.excute("campaign_window_open",0,"")
        state_machine.excute("gem_duplicate_window_open",0,"")
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_17 then -- 兵器
        state_machine.excute("campaign_window_open",0,"")
        state_machine.excute("weaponry_window_open",0,"")
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_18 then  -- 将魂试炼
        state_machine.excute("campaign_window_open",0,"")
        state_machine.excute("soul_duplicate_window_open",0,"")
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_19 then  -- 运送军资
        state_machine.excute("campaign_window_open",0,"")
        state_machine.excute("ship_military_use_window_open",0,"")
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_20 then
        app.load("configs.csb.config")
        app.load("client.red_alert_time.login.LoginLoading")
        state_machine.excute("login_loading_window_open",0,"")
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_21 then  -- 组队争霸
        state_machine.excute("union_open", 0, "")
        state_machine.excute("union_team_fight_window_open", 0, nil)
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_22 then  -- 阿拉希之战
        state_machine.excute("union_open", 0, "")
        state_machine.excute("union_get_physical_fight_window_open", 0, nil)
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_23 then  -- 攻城拔寨
        -- state_machine.excute("national_truce_loading_window_open", 0, {_datas = {open_type = 1, open_info = true}})
        state_machine.excute("campaign_window_open",0,"")
        if _ED.city_resource_battle_end_info ~= nil then
            state_machine.excute("map_rattling_window_open", 0, _ED.city_resource_battle_end_info)
            _ED.city_resource_battle_end_info = nil
        end
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_102 then -- 无尽之战
        state_machine.excute("campaign_window_open",0,"")
        state_machine.excute("trialtower_window_open",0,"")
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_103 then -- 神兵副本
        state_machine.excute("god_weaponry_duplicate_window_open",0,_ED._god_weaponry_duplicate_level)
    elseif _ED._battle_init_type == battle_enum._fight_type._fight_type_104 then -- 七星台
        state_machine.excute("seven_star_window_open",0,"")
        state_machine.excute("seven_star_map_ui_window_open",0,"")
        state_machine.excute("duplicate_map_window_open",0,"")
    end

    -- -- collectgarbage("step")
    -- print("....................1...........................")
    -- _ED.user_info.battleCache:clear()
    -- _ED.user_info.battleCache = nil
    -- -- debug.print_r(_ED.user_info.battleCache)

    -- _ED._fightModule:clear()
    -- -- debug.print_r(_ED._fightModule)
    

    -- local S2 = cc.snapshot()
    -- for k,v in pairs(S2) do
    --     if ____S1[k] == nil then
    --         print(k,v)
    --         -- if v == "userdata" then
    --         --     print("------>>>:", v:getReferenceCount())
    --         -- end
    --     end
    -- end
end

--移除状态机
function BattleWin:onExit()
    state_machine.remove("battle_win_play_animation")
end
