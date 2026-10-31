-----------------------------
--国战城市战争地图ui按钮
-----------------------------
NationalWarCityWarMapUI = class("NationalWarCityWarMapUIClass", Window)

local national_war_city_war_map_ui_window_open_terminal = {
    _name = "national_war_city_war_map_ui_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        if fwin:find("NationalWarCityWarMapUIClass") == nil then
            fwin:open(NationalWarCityWarMapUI:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_war_city_war_map_ui_window_close_terminal = {
    _name = "national_war_city_war_map_ui_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalWarCityWarMapUIClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_city_war_map_ui_window_open_terminal)
state_machine.add(national_war_city_war_map_ui_window_close_terminal)
state_machine.init()

function NationalWarCityWarMapUI:ctor()
    self.super:ctor()
    self.roots = {}
	self.city_id = nil
	self.remainTime = 0
	self.m_isBattle = false
	self.m_kill_max = 0
	self.isMove = 0

    self.choose_camp = 0
	app.load("client.red_alert.campaign.nationalwar.NationalRank")
    app.load("client.red_alert.campaign.nationalwar.NationalTask")
    app.load("client.red_alert.campaign.nationalwar.NationalWarCityWarUITactics")
    app.load("client.red_alert.campaign.nationalwar.NationalWarCityWarCdRemoveTip")
    -- Initialize NationalWarMap state machine.
    local function init_national_war_war_city_war_ui_terminal()

		--返回国战大地图
        local national_war_city_war_map_ui_close_terminal = {
            _name = "national_war_city_war_map_ui_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--需要请求
				_ED.war_city_war_matchingData = nil
				--显示国战大地图
				state_machine.excute("national_war_map_window_show",0,"")
				--关闭城战界面
				state_machine.excute("national_war_city_war_map_window_close",0,"")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--城战攻击
        local national_war_city_war_attack_terminal = {
            _name = "national_war_city_war_attack",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if self.isMove ==  1 then
                    return
                end
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if zstring.tonumber(_ED.revive_cooling_time) > 0 then
                            -- state_machine.excute("national_war_record_window_open",0,{self.city_id})
							state_machine.excute("national_war_city_war_map_ui_close",0,"")
							state_machine.excute("national_war_map_return_home_city",0,"")
						else
							state_machine.excute("national_war_city_war_battle_request",0,"")
						end	
					end
				end
                protocol_command.begin_match.param_list = ""..zstring.tonumber(instance.choose_camp)
                -- print("==匹配阵营=======",instance.choose_camp)
				NetworkManager:register(protocol_command.begin_match.code, nil, nil, nil,nil, responseCallback, false, nil)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--城战cd
		local national_war_city_war_attack_cd_terminal = {
            _name = "national_war_city_war_attack_cd",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				for i,v in pairs(_ED.war_city_war_matchingData) do
					for j, w in pairs(v) do
						if zstring.tonumber(w.userId) == zstring.tonumber(_ED.user_info.user_id) then
							self.m_isBattle = true
						end
					end
				end
				
				_ED.war_city_war_m_trim = true
				_ED.war_city_war_m_trimTime = os.time()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--城战撤军
        local national_war_city_war_troopwithdrawls_terminal = {
            _name = "national_war_city_war_troopwithdrawls",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("national_war_city_war_map_ui_close",0,"")
						state_machine.excute("national_war_map_return_home_city",0,"")
					end
				end
				NetworkManager:register(protocol_command.retreat_city.code, nil, nil, nil,nil, responseCallback, false, nil)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--城战战术
        local national_war_city_war_tactics_terminal = {
            _name = "national_war_city_war_tactics",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("national_war_city_war_tactics_window_open",0,{instance.city_id,instance._rootWindows})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--战报
        local national_war_city_war_situation_terminal = {
            _name = "national_war_city_war_situation",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--结算时ui界面刷新
        local national_war_city_war_billing_ui_refresh_terminal = {
            _name = "national_war_city_war_billing_ui_refresh",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		-- 战斗冷却时间倒计时
		local national_war_city_war_billing_time_cool_dowen_terminal = {
            _name = "national_war_city_war_billing_time_cool_dowen",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				 instance:onUpdateTime(params._time)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		-- 绘制城池BUFF动画
		local national_war_city_war_buff_show_terminal = {
            _name = "national_war_city_war_buff_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:showBuffAnimation(params[1])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		--城池BUFF数量刷新
		local national_war_city_war_buff_number_update_terminal = {
            _name = "national_war_city_war_buff_number_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				 self:UpdateCityStatus()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		
		--战斗CD清除
		local national_war_city_war_cd_remove_terminal = {
            _name = "national_war_city_war_cd_remove",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("national_war_city_war_cd_remove_window_open",0,{instance.city_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
		
		
                --判断是否在移动
        local national_war_city_war_is_move_terminal = {
            _name = "national_war_city_war_is_move",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)      
                self.isMove = params[1]
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        --改变选择阵营
        local national_war_city_war_change_choose_camp_terminal = {
            _name = "national_war_city_war_change_choose_camp",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.choose_camp = params[1]
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        
        state_machine.add(national_war_city_war_map_ui_close_terminal)  
        state_machine.add(national_war_city_war_attack_terminal)  
        state_machine.add(national_war_city_war_attack_cd_terminal)  
        state_machine.add(national_war_city_war_troopwithdrawls_terminal)  
        state_machine.add(national_war_city_war_tactics_terminal) 
        state_machine.add(national_war_city_war_situation_terminal)  
        state_machine.add(national_war_city_war_billing_ui_refresh_terminal)  
        state_machine.add(national_war_city_war_billing_time_cool_dowen_terminal)  
        state_machine.add(national_war_city_war_buff_show_terminal)  
        state_machine.add(national_war_city_war_buff_number_update_terminal)  
        state_machine.add(national_war_city_war_cd_remove_terminal)  
        state_machine.add(national_war_city_war_is_move_terminal)
        state_machine.add(national_war_city_war_change_choose_camp_terminal)
        state_machine.init()
    end
    
    -- call func init rebirth state machine.
    init_national_war_war_city_war_ui_terminal()
end

function NationalWarCityWarMapUI:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_battle_ui)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
	--关闭 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_battle_ui_back"), nil, 
    {
        terminal_name = "national_war_city_war_map_ui_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
	
	--攻击 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_attack"), nil, 
    {
        terminal_name = "national_war_city_war_attack", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
	
	--撤军 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_troopwithdrawls"), nil, 
    {
        terminal_name = "national_war_city_war_troopwithdrawls", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
	
	--战术
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tactics"), nil, 
    {
        terminal_name = "national_war_city_war_tactics", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
	
	--排名
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ranking"), nil, 
    {
        terminal_name = "national_rank_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
	
	--任务
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_task"), nil, 
    {
        terminal_name = "national_task_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)

    -- 任务推送
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_war_fight_of_task",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_task"),
        _invoke = nil,
        _interval = 0.5,}) 

	--号令
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_decree"), nil, 
    {
        terminal_name = "national_war_decree_window_tow_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        city_id = self.city_id,
    }, nil, 0)

    -- 号令推送
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_war_fight_of_decree",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_decree"),
        _invoke = nil,
        _interval = 0.5,})  
	
	--战报
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_situation"), nil, 
    {
        terminal_name = "national_war_my_fight_info_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
	
	--cd清除时间
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_colling_time_add"), nil, 
    {
        terminal_name = "national_war_city_war_cd_remove", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)
	
    -- 打开选择阵营
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_renovate"), nil, 
    {
        terminal_name = "national_war_battle_renovate_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 0)    
    
	self:updateDraw()
	-- self:updateDrawEvenCut()
end

local function deleteEffectFile(armatureBack) 
	-- CCArmatureDataManager:sharedArmatureDataManager():removeArmatureFileInfo("images/ui/effice/effect_gzkapai/effect_gzkapai.ExportJson")
	if armatureBack.removeFromParent ~= nil then
		armatureBack:removeFromParent(true)
	end
	--刷新城池状态
	state_machine.excute("national_war_city_war_buff_number_update",0,"")
end

function NationalWarCityWarMapUI:showBuffAnimation(index)
	local root = self.roots[1]
	local Button_fire_attack = ccui.Helper:seekWidgetByName(root,"Button_fire_attack")
	local armature = nil
	if zstring.tonumber(index) == 2 then
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_huogong/effect_huogong.ExportJson")
		armature = ccs.Armature:create("effect_huogong")
	else
		ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_qiyu/effect_qiyu.ExportJson")
		armature = ccs.Armature:create("effect_qiyu")
	end
	armature:getAnimation():playWithIndex(0)
	armature:setAnchorPoint(0.5,0.5)
	armature:setPosition(cc.p(Button_fire_attack:getContentSize().width/2,Button_fire_attack:getContentSize().height/2))
	armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	armature._invoke = deleteEffectFile
	Button_fire_attack:addChild(armature)
	
	if zstring.tonumber(index) == 2 or zstring.tonumber(index) == 1 then
		local Button_tactics = ccui.Helper:seekWidgetByName(root,"Button_tactics")
		local skeletonNode = sp.spine("sprite/effect_gz_"..index..".json", "sprite/effect_gz_"..index..".atlas", 1, 0, nil, false, nil)
		local e_position_tactics =  Button_tactics:convertToWorldSpaceAR(cc.p(0,0))
		skeletonNode:setPosition(cc.p(e_position_tactics.x,e_position_tactics.y))
		skeletonNode:addAnimation(1, "animation_move_dir_1", true)
		sp.initArmature(skeletonNode, true)
		skeletonNode:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
		self:addChild(skeletonNode)
		local e_position =  Button_fire_attack:convertToWorldSpaceAR(cc.p(0,0))
		local x = e_position.x
		local y = e_position.y
		local move_x = x
		local move_y = y-Button_fire_attack:getContentSize().height/2
		local function change_npc_state()
			skeletonNode:removeFromParent(true)
		end
		skeletonNode:runAction(cc.Sequence:create(cc.MoveTo:create(1,cc.p(move_x,move_y)),cc.CallFunc:create(change_npc_state)))
	end
	
end

function NationalWarCityWarMapUI:UpdateCityStatus()
	local root = self.roots[1]
	local Text_fire_attack = ccui.Helper:seekWidgetByName(root,"Text_fire_attack")
	local m_buffLaye = 0
	for i,v in pairs(_ED.warfareCityInfo[zstring.tonumber(self.city_id)].buffs) do
		m_buffLaye = m_buffLaye + zstring.tonumber(v.buff_laye)
	end
	Text_fire_attack:setString(m_buffLaye)
	
	--层数
	local Text_fire_att_infor_number = ccui.Helper:seekWidgetByName(root,"Text_fire_att_infor_number")
	Text_fire_att_infor_number:setString(m_buffLaye.."/"..dms.string(dms["warfare_config"], 11, warfare_config.param))
	--描述
	local Text_fire_att_infor_v = ccui.Helper:seekWidgetByName(root,"Text_fire_att_infor_v")
	if m_buffLaye == 0 then
		Text_fire_att_infor_v:setString(red_alert_war_city_map_tip[5])
	else
		local number = m_buffLaye*zstring.tonumber(dms.string(dms["warfare_config"], 10, warfare_config.param))
		Text_fire_att_infor_v:setString(""..string.gsub(red_alert_war_city_map_tip[4], "d", ""..number))
	end
end

-- function NationalWarCityWarMapUI:updateDrawEvenCut()
-- 	local root = self.roots[1]
-- 	--连斩
-- 	local Panel_attac_right = ccui.Helper:seekWidgetByName(root,"Panel_attac_right")
-- 	local BitmapFontLabel_att_r = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_att_r")
-- 	if zstring.tonumber(_ED.war_fight_fail_info.kill_max) > 0 then
-- 		Panel_attac_right:setVisible(true)
-- 		BitmapFontLabel_att_r:setString(_ED.war_fight_fail_info.kill_max)
-- 		self.m_kill_max = _ED.war_fight_fail_info.kill_max
-- 	end
-- end

function NationalWarCityWarMapUI:updateDraw()
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(self.roots[1],"Image_arrange"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1],"Text_arrange"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1],"Text_arrange_time"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1],"Panel_matching"):setVisible(false)
	ccui.Helper:seekWidgetByName(self.roots[1],"Panel_colling_time"):setVisible(false)
	
    local panel_root = nil
    local Panel_battle_ui_1 = ccui.Helper:seekWidgetByName(root,"Panel_battle_ui_1")
    local Panel_battle_ui_2 = ccui.Helper:seekWidgetByName(root,"Panel_battle_ui_2")
    Panel_battle_ui_1:setVisible(false)
    Panel_battle_ui_2:setVisible(false)
    if zstring.tonumber(_ED.war_in_city_info.now_city_camp) == 0 then
        panel_root = Panel_battle_ui_2
    else
        panel_root = Panel_battle_ui_1
    end
    panel_root:setVisible(true)
	local Panel_battle_ui_camp_1 = panel_root:getChildByName("Panel_battle_ui_camp_1")
	local Panel_battle_ui_camp_2 = panel_root:getChildByName("Panel_battle_ui_camp_2")
	local Panel_battle_ui_camp_3 = panel_root:getChildByName("Panel_battle_ui_camp_3")
	local Panel_battle_ui_camp_4 = panel_root:getChildByName("Panel_battle_ui_camp_4")
	local Text_battle_ui_camp_1 = panel_root:getChildByName("Text_battle_ui_camp_1")
	local Text_battle_ui_camp_2 = panel_root:getChildByName("Text_battle_ui_camp_2")
	local Text_battle_ui_camp_3 = panel_root:getChildByName("Text_battle_ui_camp_3")
	local Text_battle_ui_camp_4 = panel_root:getChildByName("Text_battle_ui_camp_4")
	Panel_battle_ui_camp_4:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_0.png"))
	Text_battle_ui_camp_4:setString(_ED.war_in_city_info.defense_people_number)
	
	if zstring.tonumber(_ED.war_in_city_info.now_city_camp) == 1 then
		Panel_battle_ui_camp_1:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", 2))
		Panel_battle_ui_camp_2:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", 3))
		Text_battle_ui_camp_1:setString(_ED.war_in_city_info.natural_numbers)
		Text_battle_ui_camp_2:setString(_ED.war_in_city_info.act_of_god_numbers)
		Text_battle_ui_camp_3:setString(_ED.war_in_city_info.union_people_number)
        Panel_battle_ui_camp_3:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", zstring.tonumber(_ED.war_in_city_info.now_city_camp)))
	elseif zstring.tonumber(_ED.war_in_city_info.now_city_camp) == 2 then
		Panel_battle_ui_camp_1:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", 1))
		Panel_battle_ui_camp_2:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", 3))
		Text_battle_ui_camp_1:setString(_ED.war_in_city_info.union_people_number)
		Text_battle_ui_camp_2:setString(_ED.war_in_city_info.act_of_god_numbers)
		Text_battle_ui_camp_3:setString(_ED.war_in_city_info.natural_numbers)
        Panel_battle_ui_camp_3:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", zstring.tonumber(_ED.war_in_city_info.now_city_camp)))
	elseif zstring.tonumber(_ED.war_in_city_info.now_city_camp) == 3 then
		Panel_battle_ui_camp_1:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", 1))
		Panel_battle_ui_camp_2:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", 2))
		Text_battle_ui_camp_1:setString(_ED.war_in_city_info.union_people_number)
		Text_battle_ui_camp_2:setString(_ED.war_in_city_info.natural_numbers)
		Text_battle_ui_camp_3:setString(_ED.war_in_city_info.act_of_god_numbers)
        Panel_battle_ui_camp_3:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", zstring.tonumber(_ED.war_in_city_info.now_city_camp)))
    elseif zstring.tonumber(_ED.war_in_city_info.now_city_camp) == 0 then 
        Panel_battle_ui_camp_1:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", 1))
        Panel_battle_ui_camp_2:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", 2))
        Panel_battle_ui_camp_3:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png", 3))
        Text_battle_ui_camp_1:setString(_ED.war_in_city_info.union_people_number)
        Text_battle_ui_camp_2:setString(_ED.war_in_city_info.natural_numbers)
        Text_battle_ui_camp_3:setString(_ED.war_in_city_info.act_of_god_numbers)        
	end
	
	local Text_fire_attack = ccui.Helper:seekWidgetByName(root,"Text_fire_attack")
	local m_buffLaye = 0
    if _ED.warfareCityInfo[zstring.tonumber(self.city_id)].buffs ~= nil then
    	for i,v in pairs(_ED.warfareCityInfo[zstring.tonumber(self.city_id)].buffs) do
    		m_buffLaye = m_buffLaye + zstring.tonumber(v.buff_laye)
    	end
	    Text_fire_attack:setString(m_buffLaye)
    else
        Text_fire_attack:setString(0)
	end
	--右边的阵型显示
	local Panel_hero_head = ccui.Helper:seekWidgetByName(root,"Panel_hero_head")
	state_machine.excute("natinal_war_hero_listview_war_city_window_open",0,{Panel_hero_head})
	
	--Panel_fire_att_infor
	local Button_fire_attack = ccui.Helper:seekWidgetByName(root,"Button_fire_attack")
	local Panel_fire_att_infor = ccui.Helper:seekWidgetByName(root,"Panel_fire_att_infor") 
	local function changeSureCallback(sender, eventType)
		if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
			Panel_fire_att_infor:setVisible(false)
		else
			Panel_fire_att_infor:setVisible(true)
		end
	end	
	Button_fire_attack:addTouchEventListener(changeSureCallback)
	--层数
	local Text_fire_att_infor_number = ccui.Helper:seekWidgetByName(root,"Text_fire_att_infor_number")
	Text_fire_att_infor_number:setString(m_buffLaye.."/"..dms.string(dms["warfare_config"], 11, warfare_config.param))
	--描述
	local Text_fire_att_infor_v = ccui.Helper:seekWidgetByName(root,"Text_fire_att_infor_v")
	if m_buffLaye == 0 then
		Text_fire_att_infor_v:setString(red_alert_war_city_map_tip[5])
	else
		local number = m_buffLaye*zstring.tonumber(dms.string(dms["warfare_config"], 10, warfare_config.param))
		Text_fire_att_infor_v:setString(""..string.gsub(red_alert_war_city_map_tip[4], "d", ""..number))
	end

end

function NationalWarCityWarMapUI:updateTrimTime(test,params)
    local time = math.modf(params)
    local minute = math.floor(time / 60)
    local second = time % 60
    local millisecond = (params - time) * 1000
    test:setString(string.format("%02d", second))
end

function NationalWarCityWarMapUI:onUpdateTime(params)
	local root = self.roots[1]
    local time = math.modf(params)
    local hour = math.floor(time/ (60 * 60))
    time = time - (hour * 60 * 60)
    local minute = math.floor(time / 60)
    time = time - minute * 60
    local second = time % 60
    ccui.Helper:seekWidgetByName(root, "Text_colling_time"):setString(string.format("%s (%02d:%02d:%02d)", "", hour, minute, second))
	if _ED.battle_cooling_time_clolr == false then
		ccui.Helper:seekWidgetByName(root, "Text_colling_time"):setColor(cc.c3b(tipStringInfo_quality_color_Type[2][1],tipStringInfo_quality_color_Type[2][2],tipStringInfo_quality_color_Type[2][3]))
	else
		ccui.Helper:seekWidgetByName(root, "Text_colling_time"):setColor(cc.c3b(tipStringInfo_quality_color_Type[6][1],tipStringInfo_quality_color_Type[6][2],tipStringInfo_quality_color_Type[6][3]))
	end
end

function NationalWarCityWarMapUI:onUpdate(dt)
	local m_trimBattleTime = tonumber(_ED.battle_cooling_time)-(os.time()-_ED.battle_cooling_time_update)
    if m_trimBattleTime <= 0 then
		_ED.battle_cooling_time_clolr = false
		ccui.Helper:seekWidgetByName(self.roots[1],"Panel_colling_time"):setVisible(false)
    else
		if m_trimBattleTime >= 60 then
			_ED.battle_cooling_time_clolr = true
		end
		ccui.Helper:seekWidgetByName(self.roots[1],"Panel_colling_time"):setVisible(true)
        state_machine.excute("national_war_city_war_billing_time_cool_dowen", 0, {_instance = self, _time =m_trimBattleTime})
    end
	local m_trimTime = 10-(os.time()-_ED.war_city_war_m_trimTime)
	if _ED.war_city_war_m_trim == true then
		if m_trimTime <= 0 then
			_ED.war_city_war_m_trim = false
			ccui.Helper:seekWidgetByName(self.roots[1],"Image_arrange"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1],"Text_arrange"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1],"Text_arrange_time"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1],"Panel_matching"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_attack"):setBright(true)
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_attack"):setTouchEnabled(true)
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_battle_ui_back"):setTouchEnabled(true)
		else
			ccui.Helper:seekWidgetByName(self.roots[1],"Image_arrange"):setVisible(true)
			ccui.Helper:seekWidgetByName(self.roots[1],"Text_arrange"):setVisible(true)
			ccui.Helper:seekWidgetByName(self.roots[1],"Text_arrange_time"):setVisible(true)
			if self.m_isBattle == true then
				ccui.Helper:seekWidgetByName(self.roots[1],"Panel_matching"):setVisible(false)
			else
				if _ED.war_city_war_matchingData ~= nil then
					ccui.Helper:seekWidgetByName(self.roots[1],"Panel_matching"):setVisible(true)
					ccui.Helper:seekWidgetByName(self.roots[1],"Button_battle_ui_back"):setTouchEnabled(false)
				end
			end
			self:updateTrimTime(ccui.Helper:seekWidgetByName(self.roots[1], "Text_arrange_time"), m_trimTime)
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_attack"):setBright(false)
			ccui.Helper:seekWidgetByName(self.roots[1],"Button_attack"):setTouchEnabled(false)
			
			if _ED.war_city_war_m_trimTime == 3 or _ED.war_city_war_m_trimTime == 6 or _ED.war_city_war_m_trimTime == 9 then
				protocol_command.refush_city_info.param_list = self.city_id
				NetworkManager:register(protocol_command.refush_city_info.code, nil, nil, nil,nil, nil, false, nil)
			end	
		end
	end
	-- if self.m_kill_max ~= zstring.tonumber(_ED.war_fight_fail_info.kill_max) and zstring.tonumber(_ED.war_fight_fail_info.kill_max) > 0 then
	-- 	self:updateDrawEvenCut()
	-- end
end

function NationalWarCityWarMapUI:init(params)
	self._rootWindows = params[1]  
	self.city_id = params[2]
    self:onInit()
    return self
end

function NationalWarCityWarMapUI:onExit()
    state_machine.remove("national_war_city_war_map_ui_close")
    state_machine.remove("national_war_city_war_attack")  
    state_machine.remove("national_war_city_war_attack_cd")  
    state_machine.remove("national_war_city_war_troopwithdrawls")  
    state_machine.remove("national_war_city_war_tactics")  
    state_machine.remove("national_war_city_war_situation")  
    state_machine.remove("national_war_city_war_billing_ui_refresh")  
    state_machine.remove("national_war_city_war_billing_time_cool_dowen")  
    state_machine.remove("national_war_city_war_buff_show")  
    state_machine.remove("national_war_city_war_buff_number_update")  
    state_machine.remove("national_war_city_war_cd_remove")  
    state_machine.remove("national_war_city_war_is_move")
    state_machine.remove("national_war_city_war_change_choose_camp")
end
