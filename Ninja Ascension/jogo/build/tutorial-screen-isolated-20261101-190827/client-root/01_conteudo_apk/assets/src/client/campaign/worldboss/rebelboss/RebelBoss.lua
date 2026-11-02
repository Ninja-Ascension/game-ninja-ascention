-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军BOSS
-------------------------------------------------------------------------------------------------------
RebelBoss = class("RebelBossClass", Window)

local rebel_boss_window_open_terminal = {
    _name = "rebel_boss_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RebelBossClass") then
        	local RebelBossWindow = RebelBoss:new()
			RebelBossWindow:init()
			fwin:open(RebelBossWindow, fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local rebel_boss_window_close_terminal = {
    _name = "rebel_boss_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RebelBossClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rebel_boss_window_open_terminal)
state_machine.add(rebel_boss_window_close_terminal)
state_machine.init()  
function RebelBoss:ctor()
    self.super:ctor()
    self.roots = {}
	self.actions = {}
	self._current_type = 1 --当前状态
	self.enum_initType = {
        _FIGHT = 0, --可以战斗
		_DEAD = 1,	--打死了
		_OVER = 2,	--活动结束
	}
    self._integral_open = false --是否展开积分浏览
    self.needupdateRefreshCd11 = false --是否可以刷新挑战次数
    self.needupdateRefreshCd12 = false --是否可以刷新boss重生
    self.interval1 = 0 --挑战次数剩余时间
    self.interval2 = 0 --刷新BOSS重生
	app.load("client.utils.ConfirmTip")
    app.load("client.utils.TimeUtil")
    app.load("client.battle.BattleStartEffect")
    app.load("client.battle.fight.FightEnum")
    -- Initialize RebelBoss page state machine.
    local function init_rebel_boss_terminal()
		--排行榜
		local button_seniority_terminal = {
            _name = "button_seniority",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
        		local function responsePropCompoundCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local function responseCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								fwin:open(SeniorityExploit:new(), fwin._ui)
							end
						end
						protocol_command.search_order_list.param_list = "".."11"
						NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responseCallback, false, nil)
					end
                end
				
				protocol_command.search_order_list.param_list = "".."12"
                NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--叛军商店
		local button_betray_army_shop_terminal = {
            _name = "button_betray_army_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local function recruitCallBack(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						fwin:open(BetrayArmyShop:new(), fwin._view)
					end
				end
				NetworkManager:register(protocol_command.rebel_exploit_shop_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--进入副本
		local rebel_boss_show_duplicate_terminal = {
            _name = "rebel_boss_show_duplicate",
            _init = function (terminal) 
				app.load("client.duplicate.DuplicateController")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
			
				fwin:open(DuplicateController:new(), fwin._view)
				
				state_machine.excute("duplicate_controller_manager", 0, 
					{
						_datas = {
							terminal_name = "duplicate_controller_manager",     
							next_terminal_name = "duplicate_controller_copy_page",       
							current_button_name = "Button_putong",    
							but_image = "Image_copy",       
							terminal_state = 0, 
							isPressedActionEnabled = true
						}
					}
				)
				
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --帮助
		local rebel_boss_help_terminal = {
            _name = "rebel_boss_help",
            _init = function (terminal) 
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.campaign.worldboss.RebelBoss.RebelBossHelp")
            	state_machine.excute("rebel_boss_help_window_open", 0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --布阵
		local rebel_boss_formation_change_terminal = {
            _name = "rebel_boss_formation_change",
            _init = function (terminal) 
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	app.load("client.formation.FormationChange") 
            	local formationChangeWindow = FormationChange:new()
				fwin:open(formationChangeWindow, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --战报
		local rebel_boss_fight_report_terminal = {
            _name = "rebel_boss_fight_report",
            _init = function (terminal) 
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	app.load("client.campaign.worldboss.RebelBoss.RebelBossChooseCamp")
            	state_machine.excute("rebel_boss_choose_camp_window_open", 0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --积分排行榜
        local rebel_boss_integral_rank_terminal = {
            _name = "rebel_boss_integral_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- local function responsePropCompoundCallback(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         local function responseCallback(response)
                --             if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                
                --             end
                --         end
                --         protocol_command.search_order_list.param_list = "".."11"
                --         NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responseCallback, false, nil)
                --     end
                -- end
                
                -- protocol_command.search_order_list.param_list = "".."12"
                -- NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
                _ED.RebelBoss.integral_rank = {}
                for i=1,4 do
                    _ED.RebelBoss.integral_rank[i] = {}
                    for j=1,5 do
                        local player = {
                            _id = j ,
                            _mould_id = 1102,
                            _name = "abb".. j,
                            _union = "wo qu"..j,
                            _fight = 151515 + j,
                            _value = 7777 + j
                        }   
                    _ED.RebelBoss.integral_rank[i][j] = player
                    end
                end
                _ED.RebelBoss.integral_rank[5] = {}
                for i=1,10 do
                    local player = {
                        mould_id1 = 500 + i,
                        mould_id2 = 600 + i,
                        prop_counts1 = 200 + i,
                        prop_counts2 = 50 + i,
                    }
                    _ED.RebelBoss.integral_rank[5][i] = player 
                end
                _ED.RebelBoss.integral_rank.rank_index = 21
                _ED.RebelBoss.integral_rank.reward_rank_index = 31
                _ED.RebelBoss.integral_rank.reward_mould_id1 = 600
                _ED.RebelBoss.integral_rank.reward_mould_id2 = 602

                app.load("client.campaign.worldboss.rebelboss.RebelBossIntegralRank")
                state_machine.excute("rebel_boss_integral_rank_window_open",0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --伤害排行榜
        local rebel_boss_hurt_rank_terminal = {
            _name = "rebel_boss_hurt_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- local function responsePropCompoundCallback(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         local function responseCallback(response)
                --             if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                
                --             end
                --         end
                --         protocol_command.search_order_list.param_list = "".."11"
                --         NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responseCallback, false, nil)
                --     end
                -- end
                
                -- protocol_command.search_order_list.param_list = "".."12"
                -- NetworkManager:register(protocol_command.search_order_list.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --展开
        local rebel_boss_fight_report_terminal = {
            _name = "rebel_boss_integral_open",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local isOpen = cell._integral_open
                if isOpen == false then 
                    cell.actions[1]:play("zhankai",false)
                    cell._integral_open = true
                else
                    cell.actions[1]:play("shouhui",false)
                    cell._integral_open = false
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --开始战斗
        local rebel_boss_star_fight_terminal = {
            _name = "rebel_boss_star_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function recruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        fwin:cleanView(fwin._windows)
                        local bse = BattleStartEffect:new()
                        bse:init(_enum_fight_type._fight_type_110)
                        fwin:open(bse, fwin._windows)
                    end
                end
                NetworkManager:register(protocol_command.rebel_boss_fight.code, nil, nil, nil, nil, recruitCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(button_betray_army_shop_terminal)
		state_machine.add(rebel_boss_show_duplicate_terminal)
		state_machine.add(rebel_boss_help_terminal)
		state_machine.add(rebel_boss_rebel_boss_terminal)
		state_machine.add(rebel_boss_formation_change_terminal) 
		state_machine.add(rebel_boss_fight_report_terminal)
        state_machine.add(rebel_boss_hurt_rank_terminal)
        state_machine.add(rebel_boss_integral_rank_terminal)
        state_machine.add(rebel_boss_star_fight_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_rebel_boss_terminal()
end

-- 绘制基本信息
function RebelBoss:onUpdateDrawInfo()
	local root = self.roots[1]
	if root == nil then 
        return
    end
    local jifenText = ccui.Helper:seekWidgetByName(root, "Text_2")--积分
    local hurtText = ccui.Helper:seekWidgetByName(root, "Text_4")--最高伤害
    local rankText = ccui.Helper:seekWidgetByName(root, "Text_6")--公会排行
    if _ED.RebelBoss.integral_rank > 0 then
        local rank = "(".._string_piece_info[330].._ED.RebelBoss.integral_rank .._string_piece_info[331] .. ")"
        jifenText:setString("" .._ED.RebelBoss.integral..rank)
    else
        jifenText:setString("" .._ED.RebelBoss.integral.. "(".._string_piece_info[3] .. ")")
    end
    if _ED.RebelBoss.highest_hurt > 0 then
        local rank = "(".._string_piece_info[330].._ED.RebelBoss.highest_hurt .._string_piece_info[331] .. ")"
        hurtText:setString("" .._ED.RebelBoss.highest_hurt..rank)
    else
        hurtText:setString("" .._ED.RebelBoss.highest_hurt.. "(".._string_piece_info[3] .. ")")
    end
    if _ED.RebelBoss.union_rank == -1 then 
        --未入公会
        rankText:setString(tipStringInfo_union_str[69])
    elseif _ED.RebelBoss.union_rank == 0 then 
        rankText:setString(_string_piece_info[3])
    else
        rankText:setString("(".._string_piece_info[330].._ED.RebelBoss.union_rank .._string_piece_info[331] .. ")")
    end
end

-- 绘制BOSS信息
function RebelBoss:onUpdateDrawBoss()
    local root = self.roots[1]
    if root == nil then 
        return
    end
 
    local bossPanel = ccui.Helper:seekWidgetByName(root, "Panel_boss")
    bossPanel:setVisible(true)
    ccui.Helper:seekWidgetByName(root, "Panel_zuo"):setVisible(true)
    ccui.Helper:seekWidgetByName(root, "Panel_zuo_1"):setVisible(true)
    ccui.Helper:seekWidgetByName(root, "Panel_cs"):setVisible(true)
    ccui.Helper:seekWidgetByName(root, "Panel_wks"):setVisible(false)
    local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_role_1")
    rolePanel:removeAllChildren(true)
    ccui.Helper:seekWidgetByName(root, "Text_bosslv")
    local bossNameText = ccui.Helper:seekWidgetByName(root, "Text_bossname")
    local hpText = ccui.Helper:seekWidgetByName(root, "Text_hp1")
    local hpLoadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
    local bossId = dms.int(dms["pirates_config"], 360, pirates_config.param)
    local npcData = dms.element(dms["npc"], bossId)
    local npcName = dms.atos(npcData,npc.npc_name)
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local name_info = ""
        local name_data = zstring.split(npcName, "|")
        for i, v in pairs(name_data) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            name_info = name_info..word_info[3]
        end
        npcName = name_info
    end
    bossNameText:setString(npcName .. _ED.RebelBoss.boss_level.._string_piece_info[6])
    local npcIcon = string.format("images/face/big_head/big_head_%d.png", dms.atoi(npcData,npc.head_pic) - 1000)
    rolePanel:setBackGroundImage(npcIcon)
    local jsPanle = ccui.Helper:seekWidgetByName(root, "Panel_js")
    jsPanle:setVisible(false)
    if self._current_type == self.enum_initType._DEAD then 
        --死了
        local background = cc.Sprite:create(npcIcon)
        background:setBlendFunc(cc.blendFunc(gl.SRC_ALPHA, gl.ONE))
        background:setAnchorPoint(cc.p(0.5, 0.5))
        background:setPosition(cc.p(rolePanel:getContentSize().width/2,rolePanel:getContentSize().height/2))
        rolePanel:addChild(background)
        jsPanle:setVisible(true)
    else
        self.actions[1]:play("Panel_role_dh",true)
    end
    local totalHp = 0
    local formationData = dms.element(dms["environment_formation"],dms.atoi(npcData,npc.environment_formation1))
    for i=1,6 do
        local id = dms.atoi(formationData,environment_formation.level + i)
        if id  > 0 then
            totalHp = totalHp + dms.int(dms["environment_ship"],id,environment_ship.power)
        end
    end
    hpText:setString("" .. self:convertHp(_ED.RebelBoss.boss_current_hp) .. "/" .. self:convertHp(totalHp))
    local parent = math.max(0, math.min(100, _ED.RebelBoss.boss_current_hp / totalHp * 100))
    hpLoadingBar:setPercent(parent)
    --选召积分
    for i=1,4 do
        local nameText = ccui.Helper:seekWidgetByName(root, "Text_name_"..i)
        local valueText = ccui.Helper:seekWidgetByName(root, "Text_jf_"..i)
        if i <= #_ED.RebelBoss.goodPlayers then 
            local data = _ED.RebelBoss.goodPlayers[i]
            nameText:setString(data._name)
            valueText:setString("" .. data._integral .._All_tip_string_info._integralName )
        end
    end

    self.needupdateRefreshCd11 = true
    self.interval = _ED.RebelBoss.os_time + _ED.RebelBoss.challenge_remain_time - os.time()
    self:refreshChallengeTimes()
end

function RebelBoss:refreshChallengeTimes()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    ccui.Helper:seekWidgetByName(root, "Text_cs"):setString("".._ED.RebelBoss.challenge_times)
end


function RebelBoss:convertHp(num)
    local numStr = "" .. num
    if num >= 10000 then
        numStr =  math.floor(num / 10000).._string_piece_info[150]
    end
    return numStr
end

-- 绘制BOSS结束
function RebelBoss:onUpdateDrawBossOver()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local bossPanel = ccui.Helper:seekWidgetByName(root, "Panel_boss")
    ccui.Helper:seekWidgetByName(root, "Panel_cs"):setVisible(false)
    bossPanel:setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Panel_wks"):setVisible(true)
end

-- 绘制
function RebelBoss:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
        return
    end
    self._integral_open = false
    if _ED.RebelBoss.is_open_state == 2 then 
        self._current_type = self.enum_initType._OVER
    else
        self._current_type = _ED.RebelBoss.boss_states
    end
    if self._current_type == self.enum_initType._FIGHT 
        or self._current_type == self.enum_initType._DEAD then 
        self:onUpdateDrawBoss()
    elseif self._current_type == self.enum_initType._OVER then
        self:onUpdateDrawBossOver()
    end
    self:onUpdateDrawInfo()
end

function RebelBoss:onUpdate(dt)
    local root = self.roots[1]
    if _ED.RebelBoss.challenge_remain_time ~= nil then
       local interval = _ED.RebelBoss.os_time + _ED.RebelBoss.challenge_remain_time - os.time()
        if self.interval1 >= 0 then 
            self.interval1 = interval
        end
        self:updateRefreshCd1()
    end
end

function RebelBoss:formatTimeString(_time)   --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

--挑战次数
function RebelBoss:updateRefreshCd1()
    if self.needupdateRefreshCd11 == false then
        return
    end
    local root = self.roots[1]
    local interval = self.interval1
    if interval <= 0 then
        ccui.Helper:seekWidgetByName(root, "Text_tzcshf"):setString("00"..tipStringInfo_time_info[6] .. "00"..tipStringInfo_time_info[7])
        self:onUpdateSendRequestInit()
    else
        self.interval1 = math.max(0, self.interval1)
        local timeTabel = formatTime(self.interval1)
        local str = ""
        str = str .. string.format("%02d"..tipStringInfo_time_info[6], timeTabel.minute)
        str = str .. string.format("%02d"..tipStringInfo_time_info[7], timeTabel.second)
        ccui.Helper:seekWidgetByName(root, "Text_tzcshf"):setString(str .._rebel_boss_tip_string_info[1])
    end
end

--boss重生倒计时
function RebelBoss:updateRefreshCd2()
    if self.needupdateRefreshCd12 == false then
        return
    end
    local root = self.roots[1]
    local interval = self.interval2
    if interval <= 0 then
        ccui.Helper:seekWidgetByName(root, "Text_tzcshf"):setString("00"..tipStringInfo_time_info[6] .. "00"..tipStringInfo_time_info[7])
        self:onUpdateSendRequestInit()
    else
        self.interval1 = math.max(0, self.interval1)
        local timeTabel = formatTime(self.interval1)
        local str = ""
        str = str .. string.format("%02d"..tipStringInfo_time_info[6], timeTabel.minute)
        str = str .. string.format("%02d"..tipStringInfo_time_info[7], timeTabel.second)
        ccui.Helper:seekWidgetByName(root, "Text_tzcshf"):setString(str .._rebel_boss_tip_string_info[1])
    end
end

function RebelBoss:onUpdateSendRequestInit()
   self.needupdateRefreshCd11 = false
   local function responseLimitInitCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                --response.node.needupdateRefreshCd11 = true
                response.node:refreshChallengeTimes()
            end
        end
    end
    --NetworkManager:register(protocol_command.limited_recharge_init.code, nil, nil, nil, self, responseLimitInitCallback, false, nil)
end

function RebelBoss:onEnterTransitionFinish()
	
	self.lastTime = os.time()
	local csbRebelBoss = csb.createNode("campaign/WorldBoss/worldBoss_2.csb")
	self:addChild(csbRebelBoss)
	local root = csbRebelBoss:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline("campaign/WorldBoss/worldBoss_2.csb")
    table.insert(self.actions, action)
    csbRebelBoss:runAction(action)
    self:onUpdateDraw()

    --帮助
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
    {
        terminal_name = "rebel_boss_help", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 2)

    --返回
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil, 
    {
        terminal_name = "rebel_boss_window_close",
        terminal_state = 0,
        isPressedActionEnabled = true
    }, nil, 2)

    --布阵
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buzhen"), nil, 
    {
        terminal_name = "rebel_boss_formation_change", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 2)

    --战报
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhanbao"), nil, 
    {
        terminal_name = "rebel_boss_fight_report", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 2)

    --伤害排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shph"), nil, 
    {
        terminal_name = "rebel_boss_hurt_rank", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 2)

    --积分排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jfph"), nil, 
    {
        terminal_name = "rebel_boss_integral_rank", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, nil, 2)

    --积分展开
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5"), nil, 
    {
        terminal_name = "rebel_boss_integral_open", 
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, nil, 2)
    local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_role_1")
    rolePanel:setTouchEnabled(true)
    --请求战斗
    fwin:addTouchEventListener(rolePanel, nil, 
    {
        terminal_name = "rebel_boss_star_fight", 
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, nil, 2)
end

function RebelBoss:init(etype)
	self.etype = etype
end

function RebelBoss:onExit()
	cacher.destoryRefPools()
	cacher.cleanSystemCacher()
	cacher.removeAllTextures()
	state_machine.remove("button_betray_army_shop")
	state_machine.remove("rebel_boss_rebel_boss")
	state_machine.remove("rebel_boss_help")
	state_machine.remove("rebel_boss_formation_change")
	state_machine.remove("rebel_boss_fight_report")
    state_machine.remove("rebel_boss_hurt_rank")
    state_machine.remove("rebel_boss_integral_rank")
    state_machine.remove("rebel_boss_integral_open")
    state_machine.remove("rebel_boss_star_fight")
end