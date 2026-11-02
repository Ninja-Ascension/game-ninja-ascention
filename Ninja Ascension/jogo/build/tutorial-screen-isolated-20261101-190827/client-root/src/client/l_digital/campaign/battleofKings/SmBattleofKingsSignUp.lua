-----------------------------
--王者之战主赛场界面
-----------------------------
SmBattleofKingsSignUp = class("SmBattleofKingsSignUpClass", Window)
SmBattleofKingsSignUp.__size = nil

local sm_battleof_kings_sign_up_window_open_terminal = {
    _name = "sm_battleof_kings_sign_up_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmBattleofKingsSignUp:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_battleof_kings_sign_up_window_open_terminal)
state_machine.init()

function SmBattleofKingsSignUp:ctor()
    self.super:ctor()
    self.roots = {}

    self.first_three_list = nil

	app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsStartRegistration")
	app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsBetting")

    local function init_sm_battleof_kings_sign_up_terminal()
		--显示界面
		local sm_battleof_kings_sign_up_show_terminal = {
            _name = "sm_battleof_kings_sign_up_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                local Panel_tab_1_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_tab_1_1")
                local Sprite_bm = Panel_tab_1_1:getChildByName("Sprite_bm")
                local Sprite_ybm = Panel_tab_1_1:getChildByName("Sprite_ybm")
                Sprite_bm:setVisible(false)
                Sprite_ybm:setVisible(false)
                if tonumber(_ED.kings_battle.kings_battle_open_type) == 0 then
                    ccui.Helper:seekWidgetByName(instance.roots[1],"Button_baoming"):setBright(false)
                    ccui.Helper:seekWidgetByName(instance.roots[1],"Button_baoming"):setTouchEnabled(false)
                    Sprite_bm:setVisible(true)
                    display:gray(Sprite_bm)

                    ccui.Helper:seekWidgetByName(instance.roots[1],"Button_xiazhu"):setBright(false)
                    ccui.Helper:seekWidgetByName(instance.roots[1],"Button_xiazhu"):setTouchEnabled(false)
                else
                    if tonumber(_ED.kings_battle.kings_battle_type) ~= 0 then
                        ccui.Helper:seekWidgetByName(instance.roots[1],"Button_baoming"):setBright(false)
                        ccui.Helper:seekWidgetByName(instance.roots[1],"Button_baoming"):setTouchEnabled(false)
                        Sprite_ybm:setVisible(true)
                    else
                        ccui.Helper:seekWidgetByName(instance.roots[1],"Button_baoming"):setBright(true)
                        ccui.Helper:seekWidgetByName(instance.roots[1],"Button_baoming"):setTouchEnabled(true)
                        Sprite_bm:setVisible(true)
                        display:ungray(Sprite_bm)
                    end

                    ccui.Helper:seekWidgetByName(instance.roots[1],"Button_xiazhu"):setBright(true)
                    ccui.Helper:seekWidgetByName(instance.roots[1],"Button_xiazhu"):setTouchEnabled(true)
                end
                state_machine.excute("sm_battleof_kings_look_peak_update_add_number", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local sm_battleof_kings_sign_up_hide_terminal = {
            _name = "sm_battleof_kings_sign_up_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        local sm_battleof_kings_sign_up_update_draw_terminal = {
            _name = "sm_battleof_kings_sign_up_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_battleof_kings_open_betting_terminal = {
            _name = "sm_battleof_kings_open_betting",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- if tonumber(_ED.kings_battle.kings_battle_open_type) == 1 or tonumber(_ED.kings_battle.kings_battle_open_type) == 2 then
                    state_machine.excute("sm_battleof_kings_betting_open", 0, {_datas = {from_type = 1}})
                -- else
                    
                -- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_battleof_kings_look_peak_formation_terminal = {
            _name = "sm_battleof_kings_look_peak_formation",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsViewPeakFormation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                if instance.first_three_list ~= nil and instance.first_three_list[index] ~= nil then
                    state_machine.excute("sm_battleof_kings_view_peak_formation_open", 0, {instance.first_three_list[index]})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_battleof_kings_look_peak_update_add_number_terminal = {
            _name = "sm_battleof_kings_look_peak_update_add_number",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --参赛人数
                if instance ~= nil then
                    local Text_csrs_n = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_csrs_n")
                    if _ED.kings_battle.add_number == nil then
                        Text_csrs_n:setString("0")
                    else
                        Text_csrs_n:setString(_ED.kings_battle.add_number)
                    end

                    local time1, time2 = instance:getSignUpAndStartTimeStr()
                    local Text_time = ccui.Helper:seekWidgetByName(instance.roots[1],"Text_time")
                    if tonumber(_ED.kings_battle.kings_battle_open_type) == 0 then
                        Text_time:setString(time1)
                    else
                        if tonumber(_ED.kings_battle.kings_battle_type) ~= 0 then
                            Text_time:setString(time2)
                        else
                            Text_time:setString(time1)
                        end 
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


		state_machine.add(sm_battleof_kings_sign_up_show_terminal)	
		state_machine.add(sm_battleof_kings_sign_up_hide_terminal)
        state_machine.add(sm_battleof_kings_sign_up_update_draw_terminal)
        state_machine.add(sm_battleof_kings_open_betting_terminal)
        state_machine.add(sm_battleof_kings_look_peak_formation_terminal)
        state_machine.add(sm_battleof_kings_look_peak_update_add_number_terminal)

        state_machine.init()
    end
    init_sm_battleof_kings_sign_up_terminal()
end

function SmBattleofKingsSignUp:onHide()
    self:setVisible(false)
end

function SmBattleofKingsSignUp:onShow()
    self:setVisible(true)
end

function SmBattleofKingsSignUp:onUpdateDraw()
    local root = self.roots[1]

	--参赛人数
    local Text_csrs_n = ccui.Helper:seekWidgetByName(root,"Text_csrs_n")
    if _ED.kings_battle.add_number == nil then
        Text_csrs_n:setString("0")
    else
        Text_csrs_n:setString(_ED.kings_battle.add_number)
    end

    if tonumber(_ED.kings_battle.kings_battle_open_type) == 0 then
        ccui.Helper:seekWidgetByName(root,"Button_xiazhu"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_xiazhu"):setTouchEnabled(false)
    else
        ccui.Helper:seekWidgetByName(root,"Button_xiazhu"):setBright(true)
        ccui.Helper:seekWidgetByName(root,"Button_xiazhu"):setTouchEnabled(true)
    end

    local function fightingCapacity(a,b)
        local al = tonumber(a.ranking)
        local bl = tonumber(b.ranking)
        local result = false
        if al < bl then
            result = true
        end
        return result 
    end

    local function integralCapacity(a,b)
        local al = tonumber(a.integral)
        local bl = tonumber(b.integral)
        local result = false
        if al > bl then
            result = true
        end
        return result 
    end

    local jsonFile = "sprite/sprite_wzzz_dizuo.json"
    local atlasFile = "sprite/sprite_wzzz_dizuo.atlas"
    
    for i=1,3 do
        local Panel_di = ccui.Helper:seekWidgetByName(root,"Panel_di_"..i)
        Panel_di:removeAllChildren(true)
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation_"..i, true, nil)
        -- animation:setPosition(cc.p(Panel_no:getContentSize().width/2,Panel_no:getContentSize().height/2))
        Panel_di:addChild(animation)
    end

    local isSpecial = false
    for i,v in pairs(_ED.kings_battle.peak_list) do
        local result = zstring.split(v.result,"|")[13]
        if result ~= nil then
            isSpecial = true
        end
    end
    
    if isSpecial == false then
        for i=1, 3 do
            local Image_no_pepole = ccui.Helper:seekWidgetByName(root,"Image_no_pepole_"..i)
            Image_no_pepole:setVisible(true)
            local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name_"..i)
            Text_name:removeAllChildren(true)
            Text_name:setString(_new_interface_text[154])
        end
        return
    end

    self.first_three_list = nil
    if zstring.tonumber(_ED.kings_battle.peak_number) > 0 then
        local first_three_list = {}
        local list_ranking_three = {}
        local secondInfo = nil
        local m_index_list = 0
        for j=1,3 do
            for i,v in pairs(_ED.kings_battle.peak_list) do
                local otherUser = _ED.battle_kings_score_rank.other_user[j]
                if nil ~= otherUser and tonumber(otherUser.user_id) == tonumber(v.id) then
                    table.insert(first_three_list, v)
                    break
                end
            end
        end
        -- for i,v in pairs(_ED.kings_battle.peak_list) do
        --     m_index_list = m_index_list + 1
        --     if tonumber(v.ranking) <= 3 and tonumber(v.ranking) > 0 then
        --         if tonumber(v.ranking) == 2 then
        --             secondInfo = v
        --         end
        --         table.insert(first_three_list, v)
        --     end
        --     if tonumber(v.ranking) == 4 then
        --         table.insert(list_ranking_three, v)
        --     end
        -- end
        -- if #_ED.battle_kings_score_rank.other_user  < 3 then
        --     if m_index_list > 3 and #first_three_list < 3 then
        --         table.sort(_ED.kings_battle.peak_list, integralCapacity)
        --         local m_x_index = 0
        --         local third_id = nil
        --         local result = zstring.split(secondInfo.result,"|")[12]
        --         third_id = zstring.split(result,",")[3]
        --         for i,v in pairs(_ED.kings_battle.peak_list) do
        --             -- m_x_index = m_x_index + 1
        --             -- if m_x_index == 3 then
        --             --     table.insert(first_three_list, v)
        --             -- end
        --             if tonumber(v.id) == tonumber(third_id) then
        --                 table.insert(first_three_list, v)
        --             end
        --         end
        --     end
        -- else
        --     for i,v in pairs(list_ranking_three) do
        --         if tonumber(_ED.battle_kings_score_rank.other_user[3].user_id) == tonumber(v.id) then
        --             table.insert(first_three_list, v)
        --             break
        --         end
        --     end
        -- end


        -- table.sort(first_three_list, fightingCapacity)
        if first_three_list[1] == nil then
            for i=1, 3 do
                local Image_no_pepole = ccui.Helper:seekWidgetByName(root,"Image_no_pepole_"..i)
                Image_no_pepole:setVisible(true)
                local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name_"..i)
                Text_name:removeAllChildren(true)
                Text_name:setString(_new_interface_text[154])
            end
            return
        end
        for i=1, 3 do
            if first_three_list[i] ~= nil then
                local Image_no_pepole = ccui.Helper:seekWidgetByName(root,"Image_no_pepole_"..i)
                Image_no_pepole:setVisible(false)
                local formation = zstring.split(first_three_list[i].formation, "!")
                local index = 0
                for j=1,3 do
                    --1,2,3名的阵型
                    local Panel_digimon_1_1 = ccui.Helper:seekWidgetByName(root,"Panel_digimon_"..i.."_"..j)
                    Panel_digimon_1_1:removeAllChildren(true)
                    if i == 1 then
                        index = 6
                    elseif i== 2 then
                        index = 6
                    elseif i== 3 then
                        index = 3
                    end
                    if formation[index+j] ~= nil then

                        --模块ID:等级:进化状态:星级:品阶:战力:实例ID!下一个武将
                        local datas = zstring.split(formation[index+j],":")
                        --进化形象
                        local evo_image = dms.string(dms["ship_mould"], datas[1], ship_mould.fitSkillTwo)
                        local evo_info = zstring.split(evo_image, ",")
                        local ship_evo = zstring.split(datas[3], "|")
                        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
                        if zstring.tonumber(datas[11]) ~= 0 then
                            evo_mould_id = dms.int(dms["ship_skin_mould"], datas[11], ship_skin_mould.ship_evo_id)
                        end
                        local temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
                        local function delayEnd( sender )
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                                app.load("client.battle.fight.FightEnum")
                                local armature_hero = sp.spine_sprite(sender, sender.delayInfo[2], spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
                                if sender.delayInfo[1] == 3 then
                                    armature_hero:setScaleX(1)
                                else
                                    armature_hero:setScaleX(-1)
                                end
                                armature_hero.animationNameList = spineAnimations
                                sp.initArmature(armature_hero, true)
                            else
                                sender:removeBackGroundImage()
                                sender:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", temp_bust_index))
                            end
                        end
                        local action = cc.Sequence:create(cc.DelayTime:create(0.2 * (i - 1) + 0.1 * j), cc.CallFunc:create(delayEnd))
                        Panel_digimon_1_1.delayInfo = {i, temp_bust_index}
                        Panel_digimon_1_1:runAction(action)
                    end
                end
                --名字
                local nickName = first_three_list[i].name
                local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name_"..i)
                Text_name:removeAllChildren(true)
                local richTextName = ccui.RichText:create()
                local size = Text_name:getContentSize()
                Text_name:setString("")
                richTextName:ignoreContentAdaptWithSize(false)
                if size.width == 0 then
                    size.width = Text_name:getFontSize() * 6
                end

                richTextName:setContentSize(cc.size(size.width, 0))
                richTextName:setAnchorPoint(0, 0)
                local rt, count, text = draw.richTextCollectionMethod(richTextName, 
                nickName, 
                cc.c3b(255, 255, 255),
                cc.c3b(255, 255, 255),
                0, 
                0, 
                Text_name:getFontName(), 
                Text_name:getFontSize(),
                chat_rich_text_color)
                richTextName:formatTextExt()
                local rich_size = richTextName:getContentSize()
                richTextName:setPositionY(size.height/2 + rich_size.height/2)
                Text_name:addChild(richTextName)

            else
                local Image_no_pepole = ccui.Helper:seekWidgetByName(root,"Image_no_pepole_"..i)
                Image_no_pepole:setVisible(true)
                local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name_"..i)
                Text_name:removeAllChildren(true)
                Text_name:setString(_new_interface_text[154])
            end
        end
        if #first_three_list > 0 then
            self.first_three_list = first_three_list
        end
    else
        for i=1, 3 do
            local Image_no_pepole = ccui.Helper:seekWidgetByName(root,"Image_no_pepole_"..i)
            Image_no_pepole:setVisible(true)
            local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name_"..i)
            Text_name:removeAllChildren(true)
            Text_name:setString(_new_interface_text[154])
        end
    end

    local Text_time = ccui.Helper:seekWidgetByName(root,"Text_time")
    local time1, time2 = self:getSignUpAndStartTimeStr()
    if tonumber(_ED.kings_battle.kings_battle_open_type) == 0 then
        Text_time:setString(time1)
    else
        if tonumber(_ED.kings_battle.kings_battle_type) ~= 0 then
            Text_time:setString(time2)
        else
            Text_time:setString(time1)
        end 
    end
end

function SmBattleofKingsSignUp:getSignUpAndStartTimeStr()
    local timeStr1 = dms.string(dms["play_config"], 35, play_config.param)
    local timeStr2 = dms.string(dms["play_config"], 36, play_config.param)

    local timeList1 = zstring.split(timeStr1, ",")
    local timeList2 = zstring.split(timeStr2, ",")

    return string.format(_new_interface_text[332], timeList1[1], timeList1[2]), string.format(_new_interface_text[333], timeList2[1])
end

function SmBattleofKingsSignUp:onUpdate(dt)
    
end

function SmBattleofKingsSignUp:onEnterTransitionFinish()

end

function SmBattleofKingsSignUp:onInit( )
    local csbItem = csb.createNode("campaign/BattleofKings/battle_of_kings_tab_1_1.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    if SmBattleofKingsSignUp.__size == nil then
        SmBattleofKingsSignUp.__size = root:getContentSize()
    end
    self:setContentSize(SmBattleofKingsSignUp.__size)


    local Panel_tab_1_1 = ccui.Helper:seekWidgetByName(root, "Panel_tab_1_1")
    local Sprite_bm = Panel_tab_1_1:getChildByName("Sprite_bm")
    local Sprite_ybm = Panel_tab_1_1:getChildByName("Sprite_ybm")
    Sprite_bm:setVisible(false)
    Sprite_ybm:setVisible(false)
	if tonumber(_ED.kings_battle.kings_battle_open_type) == 0 then
        ccui.Helper:seekWidgetByName(root,"Button_baoming"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_baoming"):setTouchEnabled(false)
        Sprite_bm:setVisible(true)
        display:gray(Sprite_bm)

        ccui.Helper:seekWidgetByName(root,"Button_xiazhu"):setBright(false)
        ccui.Helper:seekWidgetByName(root,"Button_xiazhu"):setTouchEnabled(false)
    else
        if tonumber(_ED.kings_battle.kings_battle_type) ~= 0 then
            ccui.Helper:seekWidgetByName(root,"Button_baoming"):setBright(false)
            ccui.Helper:seekWidgetByName(root,"Button_baoming"):setTouchEnabled(false)
            Sprite_ybm:setVisible(true)
        else
            ccui.Helper:seekWidgetByName(root,"Button_baoming"):setBright(true)
            ccui.Helper:seekWidgetByName(root,"Button_baoming"):setTouchEnabled(true)
            Sprite_bm:setVisible(true)
            display:ungray(Sprite_bm)
        end

        ccui.Helper:seekWidgetByName(root,"Button_xiazhu"):setBright(true)
        ccui.Helper:seekWidgetByName(root,"Button_xiazhu"):setTouchEnabled(true)
    end
	--报名
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_baoming"), nil, 
    {
        terminal_name = "sm_battleof_kings_start_registration_open", 
        terminal_state = 0, 
    }, nil, 1)
	
	--下注
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_xiazhu"), nil, 
    {
        terminal_name = "sm_battleof_kings_open_betting", 
        terminal_state = 0, 
    }, nil, 1)

    -- if tonumber(_ED.kings_battle.kings_battle_open_type) == 0 then
    --     ccui.Helper:seekWidgetByName(root,"Button_xiazhu"):setBright(false)
    --     ccui.Helper:seekWidgetByName(root,"Button_xiazhu"):setTouchEnabled(false)
    -- else
    --     ccui.Helper:seekWidgetByName(root,"Button_xiazhu"):setBright(true)
    --     ccui.Helper:seekWidgetByName(root,"Button_xiazhu"):setTouchEnabled(true)
    -- end
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_sm_battle_of_kings_betting",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_xiazhu"),
        _invoke = nil,
        _interval = 0.5,})
	
    for i=1,3 do
        --查看前3名的阵型
        local Panel_no = ccui.Helper:seekWidgetByName(root,"Panel_no_"..i)
        fwin:addTouchEventListener(Panel_no, nil, 
        {
            terminal_name = "sm_battleof_kings_look_peak_formation", 
            terminal_state = 0, 
            index = i
        }, nil, 0)
    end

    if zstring.tonumber(_ED.kings_battle.peak_number) > 0 then
        local function responseBattleKingCallback(response)
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateDraw()
            end
        end
        local scheduler3 = cc.Director:getInstance():getScheduler()  
        local schedulerID3 = nil
        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then  
            schedulerID3 = scheduler3:scheduleScriptFunc(function ()
                protocol_command.order_get_info.param_list = "7".."\r\n".."1".."\r\n".."10"
                NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, self, responseBattleKingCallback, false, nil)
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID3)
            end,0.1,false)
        else
            schedulerID3 = scheduler3:scheduleScriptFunc(function ()
                protocol_command.order_get_info.param_list = "7".."\r\n".."1".."\r\n".."10"
                NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, self, responseBattleKingCallback, false, nil)
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(schedulerID3)
            end,1,false)
        end
    else
        self:onUpdateDraw()
    end
    
end

function SmBattleofKingsSignUp:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmBattleofKingsSignUp:onExit()
    state_machine.remove("sm_battleof_kings_sign_up_show")    
    state_machine.remove("sm_battleof_kings_sign_up_hide")
    state_machine.remove("sm_battleof_kings_sign_up_update_draw")
    state_machine.remove("sm_battleof_kings_open_betting")
    state_machine.remove("sm_battleof_kings_look_peak_formation")
    state_machine.remove("sm_battleof_kings_look_peak_update_add_number")
end
