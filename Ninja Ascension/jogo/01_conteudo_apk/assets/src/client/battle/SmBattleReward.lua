-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗胜利界面
-------------------------------------------------------------------------------------------------------
SmBattleReward = class("SmBattleRewardClass", Window)

local sm_battle_reward_open_terminal = {
    _name = "sm_battle_reward_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmBattleRewardClass")
        if nil == _homeWindow then
            local panel = SmBattleReward:new():init(params)
            fwin:open(panel,fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_battle_reward_close_terminal = {
    _name = "sm_battle_reward_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmBattleRewardClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmBattleRewardClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_battle_reward_open_terminal)
state_machine.add(sm_battle_reward_close_terminal)
state_machine.init()
    
function SmBattleReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.ship_id = 0

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.ship.hero_icon_list_cell")
    app.load("client.cells.ship.ship_icon_cell")

    local function init_sm_battle_reward_terminal()
        -- 显示界面
        local sm_battle_reward_display_terminal = {
            _name = "sm_battle_reward_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmBattleRewardWindow = fwin:find("SmBattleRewardClass")
                if SmBattleRewardWindow ~= nil then
                    SmBattleRewardWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_battle_reward_hide_terminal = {
            _name = "sm_battle_reward_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmBattleRewardWindow = fwin:find("SmBattleRewardClass")
                if SmBattleRewardWindow ~= nil then
                    SmBattleRewardWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --退出
        local sm_battle_reward_drop_out_terminal = {
            _name = "sm_battle_reward_drop_out",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:addService({
                    callback = function ( params )
                        if zstring.tonumber(_ED.server_review) == 1 then
                        else
                            state_machine.excute("secret_shop_open_tip_window_open", 0, 0)
                        end
                    end,
                    delay = 0,
                    params = nil
                })
                
                if __lua_project_id == __lua_project_gragon_tiger_gate
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
					_ED._is_eve_battle = false
				end
                state_machine.lock("sm_battle_reward_drop_out")
				fwin:close(instance)
				
				
				-- 有升级,播升级
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                else
                    if true == _ED.user_is_level_up then
                        app.load("client.battle.BattleLevelUp")
                        local win = fwin:find("BattleLevelUpClass")
                        if nil ~= win then
                            fwin:close(win)
                        end
                        fwin:open(BattleLevelUp:new(), fwin._windows)
                        _ED.user_info.last_user_grade = _ED.user_info.user_grade
                        return
                    end
                end
				
				
				fwin:close(fwin:find("SmBattleRewardClass"))
            	cacher.removeAllTextures()
            	fwin:reset(nil)
				app.load("client.home.Menu")
				fwin:open(Menu:new(), fwin._taskbar) 
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then                    
                    if fwin:find("HomeClass") == nil 
                        and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_215
                        and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_216
                        and _ED.battleData.battle_init_type ~= _enum_fight_type._fight_type_217
                        and _ED.fileIsland ~= nil
                        and _ED.fileIsland.fileIslandFriendCellInfo_goBattle ~= true
                        then 
                        state_machine.excute("menu_manager", 0, 
                            {
                                _datas = {
                                    terminal_name = "menu_manager",
                                    next_terminal_name = "menu_show_home_page", 
                                    current_button_name = "Button_home",
                                    but_image = "Image_home",       
                                    terminal_state = 0, 
                                    _needOpenHomeHero = true,
                                    isPressedActionEnabled = true
                                }
                            }
                        )
                        state_machine.excute("menu_back_home_page", 0, "")
                        state_machine.excute("home_change_open_atrribute", 0, false)
                    end
                end
				if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
					or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4
                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_51
                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_52 
                    then
					state_machine.excute("explore_window_open", 0, 0)
					state_machine.excute("explore_window_open_fun_window", 0, nil)
                elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_212 then
                    if _ED.previous_ship_evo_window == "FormationTigerGateClass" then
                        state_machine.excute("formation_open_instance_window",0,{_datas = {_shipInstance = _ED.battle_evo_ship_info}})
                        -- state_machine.excute("formation_open_instance_window", 0, {_datas = {_shipInstance = }})
                        -- state_machine.excute("formation_set_ship",0,_ED.battle_evo_ship_info)
                    elseif _ED.previous_ship_evo_window == "SmRoleStrengthenTabClass" then
                        app.load("client.packs.hero.HeroDevelop")
                        local heroDevelopWindow = HeroDevelop:new()
                        local ship_info = _ED.battle_evo_ship_info
                        ship_info.shengming = zstring.tonumber(ship_info.ship_health)
                        ship_info.gongji = zstring.tonumber(ship_info.ship_courage)
                        ship_info.waigong = zstring.tonumber(ship_info.ship_intellect)
                        ship_info.neigong = zstring.tonumber(ship_info.ship_quick)
                        heroDevelopWindow:init(ship_info.ship_id, "learn")
                        fwin:open(heroDevelopWindow, fwin._viewdialog)
                    end
                    state_machine.excute("generals_evo_chain_window_open", 0, {_ED.battle_evo_ship_info})

                elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_215 
                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_216
                    or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_217
                    or (_ED.fileIsland ~= nil and _ED.fileIsland.fileIslandFriendCellInfo_goBattle == true)
                    then
                    if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                        -- if fwin:find("HomeClass") == nil then
                        --     state_machine.excute("menu_manager", 0, 
                        --         {
                        --             _datas = {
                        --                 terminal_name = "menu_manager",     
                        --                 next_terminal_name = "menu_show_home_page", 
                        --                 current_button_name = "Button_home",
                        --                 but_image = "Image_home",       
                        --                 terminal_state = 0, 
                        --                 _needOpenHomeHero = true,
                        --                 isPressedActionEnabled = true
                        --             }
                        --         }
                        --     )
                        -- end
                        -- state_machine.excute("menu_back_home_page", 0, "")
                        -- state_machine.excute("home_change_open_atrribute", 0, false)
                        app.load("client.l_digital.campaign.exploration.ExplorationLoading")
                        fwin:open(ExplorationLoading:new():init(), fwin._taskbar)
                    else
                        app.load("client.l_digital.campaign.fileIsland.FileIslandWindow")
                        state_machine.excute("fileIsland_window_open", 0, 1)
                    end
				else
					state_machine.excute("menu_show_duplicate_goto_last_view", 0, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_battle_reward_display_terminal)
        state_machine.add(sm_battle_reward_hide_terminal)
        state_machine.add(sm_battle_reward_drop_out_terminal)
        
        state_machine.init()
    end
    init_sm_battle_reward_terminal()
end

function SmBattleReward:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    --获得的金钱
    local Text_jb_n = ccui.Helper:seekWidgetByName(root,"Text_jb_n")
    Text_jb_n:setString("0")
    --获得的经验
    local Text_exp_n = ccui.Helper:seekWidgetByName(root,"Text_exp_n")
    Text_exp_n:setString("0")
    --当前的等级
    local Text_lv_n = ccui.Helper:seekWidgetByName(root,"Text_lv_n")
    Text_lv_n:setString(_ED.user_info.user_grade)

    --胜利动画
   	local Panel_win_dh = ccui.Helper:seekWidgetByName(root,"Panel_win_dh")

	local jsonFile = "sprite/spirte_shengli.json"
    local atlasFile = "sprite/spirte_shengli.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "chuxian", true, nil)
    animation.animationNameList = {"chuxian","xunhuan"}
	sp.initArmature(animation, false)
	local function changeActionCallback( armatureBack )
	end
	animation._invoke = changeActionCallback
	animation:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	csb.animationChangeToAction(animation, 0, 1, false)
    Panel_win_dh:addChild(animation)

   	--星级
   	local Panel_star_dh = ccui.Helper:seekWidgetByName(root,"Panel_star_dh") 
   	local npcData = dms.element(dms["npc"], _ED._scene_npc_id)	
	local npcCurStar = tonumber(_ED.npc_state[dms.atoi(npcData, npc.id)])
	local a_name = ""
	local cx_name = ""
	if npcCurStar == 1 then
		a_name = "1star"
		cx_name = "1star_cx"
	elseif npcCurStar == 2 then
		a_name = "2star"
		cx_name = "2star_cx"
	elseif npcCurStar == 3 then
		a_name = "3star"
		cx_name = "3star_cx"
    else    
        a_name = "3star"
        cx_name = "3star_cx"
	end
   	local jsonFile = "sprite/spirte_zaxing.json"
    local atlasFile = "sprite/spirte_zaxing.atlas"
    local animation2 = sp.spine(jsonFile, atlasFile, 1, 0, a_name, true, nil)
    animation2.animationNameList = {a_name,cx_name}
	sp.initArmature(animation2, false)

    local function onFrameEventBullet(bone,evt,originFrameIndex,currentFrameIndex)
        if evt ~= nil and #evt > 0 then
            if evt == "ding" then
                playEffect(formatMusicFile("effect", 9989))
            end
        end
    end
	local function changeActionCallback( armatureBack )
	end
	animation2._invoke = changeActionCallback
    animation2:getAnimation():setFrameEventCallFunc(onFrameEventBullet)
	animation2:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	csb.animationChangeToAction(animation2, 0, 1, false)
    Panel_star_dh:addChild(animation2)

    local addexps = dms.string(dms["npc"], zstring.tonumber(_ED._scene_npc_id), npc.on_hook_reward)
    local first_reward = dms.int(dms["npc"], zstring.tonumber(_ED._scene_npc_id), npc.first_reward)

	   --上阵武将的列表
    local ListView_digimon_icon = ccui.Helper:seekWidgetByName(root,"ListView_digimon_icon")
    local scene_type = dms.int(dms["pve_scene"], self.currentScencId, pve_scene.scene_type)
    local user_infos = zstring.tonumber(self._fight_type) == 15 and _ED.em_user_ship or _ED.user_formetion_status
    local ship_list = {}
    for i, v in pairs(user_infos) do
    	if zstring.tonumber(v) > 0 then
            local isAdd = false
            if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_212 then
                if zstring.tonumber(_ED.user_ship[""..v].ship_id) == zstring.tonumber(_ED.battle_evo_ship_info.ship_id) then
                    isAdd = true
                end
            else
                isAdd = true
            end
            if isAdd == true then
    	    	local cell = ShipIconCell:createCell()
    			cell:init(_ED.user_ship[""..v],9,nil,nil,nil,addexps)
    			ListView_digimon_icon:addChild(cell)
    			table.insert(ship_list, cell)
    			cell:setVisible(false)
                neWshowShipStar(ccui.Helper:seekWidgetByName(cell.roots[1],"Panel_star"),tonumber(_ED.user_ship[""..v].StarRating))
            end
		end
    end

    --获得奖励的列表
    local ListView_reward_icon = ccui.Helper:seekWidgetByName(root,"ListView_reward_icon")
   	local cell_list = {}
    local reward_list = {}
    if self.rewardList ~= nil then
        for i=1 , tonumber(self.rewardList.show_reward_item_count) do
        	local rewardList = self.rewardList.show_reward_list[i]
            local isSame = false
            for k,v in pairs(reward_list) do
                if tonumber(v.prop_type) == tonumber(rewardList.prop_type)
                    and tonumber(v.prop_item) == tonumber(rewardList.prop_item)
                    then
                    isSame = true
                    v.item_value = tonumber(v.item_value) + tonumber(rewardList.item_value)
                    break
                end
            end
            if isSame == false then
                table.insert(reward_list, rewardList)
            end
        end
    end
    local isHaveActivity = false

    if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_0 then
        if _ED.active_activity[97] ~= nil and _ED.active_activity[97] ~= "" then
            if first_reward == 0 or (first_reward ~= 0 and _ED.current_npc_battle_star ~= 0) then
                isHaveActivity = true
            end
        end
    elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_108 then
        if _ED.active_activity[98] ~= nil and _ED.active_activity[98] ~= "" then
            if first_reward == 0 or (first_reward ~= 0 and _ED.current_npc_battle_star ~= 0) then
                isHaveActivity = true
            end
        end
    elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_52 then
        if _ED.active_activity[132] ~= nil and _ED.active_activity[132] ~= "" then
            isHaveActivity = true
        end
    elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_51 then
        if _ED.active_activity[133] ~= nil and _ED.active_activity[133] ~= "" then
            isHaveActivity = true
        end
    end

    for k,rewardList in pairs(reward_list) do
        if tonumber(rewardList.prop_type) == 1 then         --银币
            Text_jb_n:setString(rewardList.item_value)
        elseif tonumber(rewardList.prop_type) == 8 then     --经验
            Text_exp_n:setString(rewardList.item_value)
        -- elseif tonumber(rewardList.prop_type) == 6 then     --道具
        --     local cell = ResourcesIconCell:createCell()
        --     cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item,nil,nil,true,true)
        --     table.insert(cell_list, cell)
        --     ListView_reward_icon:addChild(cell)
        --     cell:setVisible(false)
        --     if isHaveActivity == true then
        --         cell:setActivityDouble(true)
        --     end
        -- elseif tonumber(rewardList.prop_type) == 7 then     --装备
        --     local cell = ResourcesIconCell:createCell()
        --     cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item,nil,nil,true,true)
        --     table.insert(cell_list, cell)
        --     ListView_reward_icon:addChild(cell)
        --     cell:setVisible(false)
        --     if isHaveActivity == true then
        --         cell:setActivityDouble(true)
        --     end
        -- elseif tonumber(rewardList.prop_type) == 13 then    --武将
        --     local cell = ResourcesIconCell:createCell()
        --     cell:init(rewardList.prop_type, tonumber(rewardList.item_value), rewardList.prop_item,nil,nil,true ,true)
        --     table.insert(cell_list, cell)
        --     ListView_reward_icon:addChild(cell)
        --     cell:setVisible(false)
        --     if isHaveActivity == true then
        --         cell:setActivityDouble(true)
        --     end
        else
            local cell = state_machine.excute("sm_item_icon_cell_create",0,{0,{rewardList.prop_type,rewardList.prop_item,rewardList.item_value},false,true,false,true})
            ListView_reward_icon:addChild(cell)
            if isHaveActivity == true then
                cell:setActivityDouble(true)
            end
        end
    end
    self.actions[1]:play("text_open", false)
    self.actions[1]:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "icon_open" then
        	--开始绘制角色头像和奖励图标依次出现的动画
            local index = 0
            if #ship_list > 0 then
            	for i, v in pairs(ship_list) do
            		if #ship_list >= 1 then
                        index = index + 1
    	        		local t = 0.1 + 0.5 * (i - 1)
                        local function playOver()
                            if i==#ship_list then
                                state_machine.unlock("sm_battle_reward_drop_out")
                                self:addBackTouch()
                            end
                        end
    					v:runAction(cc.Sequence:create({cc.DelayTime:create(t/2), cc.ScaleTo:create(0.01, 1.05), cc.CallFunc:create(function ( sender )
    						sender:setVisible(true)
    					end), cc.ScaleTo:create(0.1, 1), cc.CallFunc:create(playOver)}))
    				end
            	end
            	ListView_digimon_icon:requestRefreshView()
            else
                state_machine.unlock("sm_battle_reward_drop_out")
                self:addBackTouch()
            end

        	for i, v in pairs(cell_list) do
        		if #cell_list >= 1 then
                    index = index + 1
	        		local t = 0.3 + 0.5 * (index - 1)
					v:runAction(cc.Sequence:create({cc.DelayTime:create(t/2), cc.ScaleTo:create(0.01, 1.05), cc.CallFunc:create(function ( sender )
						sender:setVisible(true)
					end), cc.ScaleTo:create(0.1, 1)}))
				end
        	end
        	ListView_reward_icon:requestRefreshView()
        end
        
    end)

end

function SmBattleReward:init(params)
	
    self._fight_type = params

    if self._fight_type ==  _enum_fight_type._fight_type_215
        or self._fight_type ==  _enum_fight_type._fight_type_216
        or self._fight_type ==  _enum_fight_type._fight_type_217 then
        self.rewardList = getSceneReward(7)
    else
        self.rewardList = getSceneReward(2)
    end


    --print("self._fight_type==================================", self._fight_type)
    -- local _scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, 15)
    -- for i, v in pairs(_scenes) do
    --     local tempSceneId = dms.atoi(v, pve_scene.id)
    --     if _ED.scene_current_state[tempSceneId] == nil
    --         or _ED.scene_current_state[tempSceneId] == ""
    --         or tonumber(_ED.scene_current_state[tempSceneId]) < 0 
    --         then
    --         self.currentScencId = tempSceneId - 1
    --         break
    --     end
    -- end
    self:onInit()
    _ED.user_is_level_up = false
    if _ED.user_info.last_user_grade ~= _ED.user_info.user_grade then
        _ED.user_is_level_up = true
    end
    return self
end

function SmBattleReward:addBackTouch()
    fwin:addService({
        callback = function ( params )
            if params.roots ~= nil then
                -- 关闭
                fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(params.roots[1],"Image_black_bg"), nil, 
                {
                    terminal_name = "sm_battle_reward_drop_out",
                    terminal_state = 0,
                },
                nil,3)
            end
        end,
        delay = 0.1,
        params = self
    })
end

function SmBattleReward:onInit()
    local csbSmBattleReward = csb.createNode("battle/sm_battle_victory.csb")
    local root = csbSmBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmBattleReward)
    local action = csb.createTimeline("battle/sm_battle_victory.csb")
    table.insert(self.actions, action)
    csbSmBattleReward:runAction(action)
	playEffect(formatMusicFile("effect", 9996))
    -- state_machine.lock("sm_battle_reward_drop_out")

    self:onUpdateDraw()

    fwin:addService({
        callback = function ( params )
            if params.roots ~= nil then
                params:addBackTouch()
            end
        end,
        delay = 5,
        params = self
    })

    -- self:showImageAnimation()
	-- -- 关闭
 --    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_black_bg"), nil, 
 --    {
 --        terminal_name = "sm_battle_reward_drop_out",
 --        terminal_state = 0,
 --    },
 --    nil,3)
end

function SmBattleReward:onExit()
    self.roots = nil
    state_machine.remove("sm_battle_reward_display")
    state_machine.remove("sm_battle_reward_hide")
end