-- ----------------------------------------------------------------------------------------------------
-- 说明：商城，数码抽卡主界面
-------------------------------------------------------------------------------------------------------

HeroRecruitListView = class("HeroRecruitListViewClass", Window)

local recruitRequestSerial = 0
local function nextRecruitRequestId()
	recruitRequestSerial = recruitRequestSerial + 1
	return tostring(os.time()) .. ":" .. tostring(recruitRequestSerial) .. ":" .. tostring(math.random(1, 99999999))
end


app.load("client.shop.recruit.HeroRecruitGeneralView")
app.load("client.shop.ShopUserInformation")
function HeroRecruitListView:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.actions = {}
	self.group = {
		_recruit = nil,
		_prop = nil,
		_vip = nil
	}
	self.root = nil
	self.threeRecruitNeedLevel = 40
	self.userCurrentLevel = 1
	self.oneState = 1
	self._oneState = 1
	self.user_accumulate_buy_god = -1
	self.isshow = false
	self.lastupdatetime = 0
	self.campupdatetimetext = nil --阵营招募刷新时间
	self.update_type = false
	self.bounty_count = nil

	self.parentParent = nil
	self.currentState = 0
	self.openRecruitView = nil
    self.action_updateTimes = 0

    self._isChangePage = false
	-- Initialize hero_recruit_list_view page state machine.
    local function init_hero_recruit_list_view_terminal()
        --招募翻页回来
        local hero_recruit_list_view_recruit_Page_terminal = {
            _name = "hero_recruit_list_view_recruit_Page",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    if tonumber(params._datas.m_type) == 1 then
                        local Panel_ck_f_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_ck_f_1")
                        local Panel_ck_b_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_ck_b_1")
                        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                        else
                            Animations_openCard(instance,Panel_ck_f_1,Panel_ck_b_1)
                        end
                    else
                        local Panel_ck_f_2 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_ck_f_2")
                        local Panel_ck_b_2 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_ck_b_2")
                        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                        else
                            instance._isChangePage = not instance._isChangePage
                            instance.actions[1]:play("animation_close", false)
                            instance.action_updateTimes = 0
                            Animations_openCard(instance,Panel_ck_f_2,Panel_ck_b_2)
                        end
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --一次招募（金币和宝石）
        local hero_recruit_list_view_a_recruiting_terminal = {
            _name = "hero_recruit_list_view_a_recruiting",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --控制按钮连点
                local btn = params._datas.terminal_button
                if btn then
                    btn:setTouchEnabled(false)
                    btn:runAction(cc.Sequence:create({cc.DelayTime:create(1), cc.CallFunc:create(function ( sender )
                        btn:setTouchEnabled(true)
                    end)})
                    )
                end
                local m_type = tonumber(params._datas.m_type)
                local m_index = tonumber(params._datas.m_index)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
                    or __lua_project_id == __lua_project_l_pokemon 
                    or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    if m_type == 1 and getSmallBuildingTips() == false then
                        local need_silver = dms.int(dms["partner_bounty_param"],1,partner_bounty_param.spend_silver)
                        if need_silver > tonumber(_ED.user_info.user_silver) then
                            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
                                TipDlg.drawTextDailog(_string_piece_info[86])
                            else
                                app.load("client.packs.hero.HeroPatchInformationPageGetWay")
                                local fightWindow = HeroPatchInformationPageGetWay:new()
                                fightWindow:init(0,6)
                                fwin:open(fightWindow, fwin._windows)
                                state_machine.unlock("hero_recruit_list_view_a_recruiting")
                                state_machine.unlock("hero_recruit_list_view_ten_recruiting")
                            end
                            return
                        end
                    end
                end
                local function recruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            -- The legacy single-draw screen treats a missing ship ID as zero.
                            -- Set that sentinel explicitly when the response contains an item,
                            -- fragment, or Ryo so stale/default ninja details cannot be shown.
                            if (m_type == 1 or m_type == 2) and _ED.recruit_success_ship_id == nil then
                                _ED.recruit_success_ship_id = "0"
                            end
                            if __lua_project_id == __lua_project_gragon_tiger_gate
                                or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                or __lua_project_id == __lua_project_red_alert 
                                then
                                if fwin:find("HeroRecruitSuccessClass") ~= nil then
                                    fwin:close(fwin:find("HeroRecruitSuccessClass"))
                                end
                            end
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                then
                                getSceneReward(64)
                                _ED.show_reward_list_group_ex = {}
                            end
                            local obj = HeroRecruitSuccess:new()
                            obj:setRanking(herorIndex,m_type,true, nil, nil, nil, nil, nil, nil, m_index)
                            fwin:open(obj,fwin._ui)
                            state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                            -- smFightingChange()
                            if __lua_project_id == __lua_project_gragon_tiger_gate
                                or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                or __lua_project_id == __lua_project_red_alert 
                                then
                                state_machine.excute("hero_recruit_shop_twopage_close",0,"")
                            else
                                fwin:close(response.node)
                            end
                        end
                    end
                    state_machine.unlock("hero_recruit_list_view_a_recruiting")
                    state_machine.unlock("hero_recruit_list_view_ten_recruiting")
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
                        or __lua_project_id == __lua_project_l_pokemon 
                        or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                        then
                        _ED.prop_chest_store_recruiting = false
                    end
                end      
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    _ED.new_prop_object = {}
                    _ED.recruit_success_ship_id = nil
                    _ED.new_reward_object = {}
                    _ED.prop_chest_store_recruiting = true
                end
                state_machine.lock("hero_recruit_list_view_a_recruiting")
                state_machine.lock("hero_recruit_list_view_ten_recruiting")
                if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    local req = json.encode({drawId = m_index})
                    protocol_command.draw_reward_main.param_list = req
                    NetworkManager:register(protocol_command.draw_reward_main.code, nil, nil, nil, instance, recruitCallBack, false, nil)
                else
					protocol_command.ship_bounty.param_list = ""..m_type.."\r\n"..nextRecruitRequestId()
                    NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, instance, recruitCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --十次招募（金币和宝石）
        local hero_recruit_list_view_ten_recruiting_terminal = {
            _name = "hero_recruit_list_view_ten_recruiting",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                --控制按钮连点
                local btn = params._datas.terminal_button
                if btn then
                    btn:setTouchEnabled(false)
                    btn:runAction(cc.Sequence:create({cc.DelayTime:create(1), cc.CallFunc:create(function ( sender )
                        btn:setTouchEnabled(true)
                    end)})
                    )
                end

                local m_type = tonumber(params._datas.m_type)
                local m_index = tonumber(params._datas.m_index)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
                    or __lua_project_id == __lua_project_l_pokemon 
                    or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    if m_type == 4 then
                        if funOpenDrawTip(173) == true then
                            state_machine.unlock("hero_recruit_list_view_a_recruiting")
                            state_machine.unlock("hero_recruit_list_view_ten_recruiting")
                            return
                        end
                    end
                    if m_type == 1 or m_type == 4 then
                        local need_silver = dms.int(dms["partner_bounty_param"],9,partner_bounty_param.spend_silver)
                        if m_type == 4 then
                            need_silver = need_silver * 10
                        end
                        if need_silver > tonumber(_ED.user_info.user_silver) then
                            if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and zstring.tonumber(_ED.server_review) == 1 then
                                TipDlg.drawTextDailog(_string_piece_info[86])
                            else
                                app.load("client.packs.hero.HeroPatchInformationPageGetWay")
                                local fightWindow = HeroPatchInformationPageGetWay:new()
                                fightWindow:init(0,6)
                                fwin:open(fightWindow, fwin._windows)
                                state_machine.unlock("hero_recruit_list_view_a_recruiting")
                                state_machine.unlock("hero_recruit_list_view_ten_recruiting")
                            end
                            return
                        end
                    end
                end
                local function tenrecruitCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                then
                                getSceneReward(64)
                                _ED.show_reward_list_group_ex = {}
                                if app.configJson.OperatorName == "cayenne" then
                                    jttd.facebookAPPeventSlogger("9|".._ED.all_servers[_ED.selected_server].server_number.."_".._ED.user_info.user_id.."|"..m_type)
                                end
                            end
                            if m_type == 4 then
                                app.load("client.shop.recruit.HeroRecruitReward")
                                state_machine.excute("hero_recruit_reward_window_open", 0, nil)
                                state_machine.unlock("hero_recruit_list_view_a_recruiting")
                                state_machine.unlock("hero_recruit_list_view_ten_recruiting")
                            else
                                local obj = HeroRecruitSuccessTen:new()
                                obj:setRanking(herorIndex,m_type,true, m_index)
                                fwin:open(obj,fwin._ui)
                                state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
                                -- smFightingChange()
                                if __lua_project_id == __lua_project_gragon_tiger_gate
                                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
                                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                    or __lua_project_id == __lua_project_red_alert 
                                    then
                                    state_machine.excute("hero_recruit_shop_twopage_close",0,"")
                                else
                                    fwin:close(response.node)
                                end
                            end
                        end
                    end
                    state_machine.unlock("hero_recruit_list_view_a_recruiting")
                    state_machine.unlock("hero_recruit_list_view_ten_recruiting")
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
                        or __lua_project_id == __lua_project_l_pokemon 
                        or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                        then
                        _ED.prop_chest_store_recruiting = false
                    end
                end
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    _ED.new_prop_object = {}
                    _ED.recruit_success_ship_id = nil
                    _ED.new_reward_object = {}
                    _ED.prop_chest_store_recruiting = true
                end
                state_machine.lock("hero_recruit_list_view_a_recruiting")
                state_machine.lock("hero_recruit_list_view_ten_recruiting")
                if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    local req = json.encode({drawId = m_index})
                    protocol_command.draw_reward_main.param_list = req
                    NetworkManager:register(protocol_command.draw_reward_main.code, nil, nil, nil, instance, tenrecruitCallBack, false, nil)
                else
				     protocol_command.ship_batch_bounty.param_list =""..m_type.."\r\n"..nextRecruitRequestId()
                    NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, instance, tenrecruitCallBack, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        
	--战将
		local hero_recruit_list_view_manager_terminal = {
            _name = "hero_recruit_list_view_manager",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    local Panel_ck_f_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_ck_f_1")
                    local Panel_ck_b_1 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_ck_b_1")
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    else
                        Animations_openCard(instance,Panel_ck_b_1,Panel_ck_f_1)
                    end
                else
                	if __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge
                        then
                		instance:playActions(false)
                	end
    				local heroRecruitGeneralViewWindow = HeroRecruitGeneralView:new()
    				local state = self.oneState
    				heroRecruitGeneralViewWindow:init(1, state)
    				if __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge
                        then
    					instance.currentState = 1
    					instance.openRecruitView = heroRecruitGeneralViewWindow
    					instance.parentParent:removeAllChildren(true)
    					instance.parentParent:addChild(heroRecruitGeneralViewWindow)
    					-- state_machine.excute("shop_change_ui_layer_state", 0, false)
    					state_machine.excute("shop_insert_heroRecruitGeneral_root", 0, heroRecruitGeneralViewWindow.root)
    				else
    					fwin:open(heroRecruitGeneralViewWindow,fwin._ui)
                    end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	--神将
		local hero_recruit_shen_list_view_manager_terminal = {
            _name = "hero_recruit_shen_list_view_manager",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
                    local Panel_ck_f_2 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_ck_f_2")
                    local Panel_ck_b_2 = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_ck_b_2")
                    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
                    else
                        instance._isChangePage = not instance._isChangePage
                        Animations_openCard(instance,Panel_ck_b_2,Panel_ck_f_2)
                    end
                else
                	if __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge
                        then
                		instance:playActions(false)
                	end
    				local heroRecruitGeneralViewWindow = HeroRecruitGeneralView:new()
    				local state = self._oneState
    				heroRecruitGeneralViewWindow:init(2,state)
    				if __lua_project_id == __lua_project_pokemon 
                        or __lua_project_id == __lua_project_rouge
                        then
    					instance.currentState = 2
    					instance.openRecruitView = heroRecruitGeneralViewWindow
    					instance.parentParent:removeAllChildren(true)
    					instance.parentParent:addChild(heroRecruitGeneralViewWindow)
    					-- state_machine.excute("shop_change_ui_layer_state", 0, false)
    					state_machine.excute("shop_insert_heroRecruitGeneral_root", 0, heroRecruitGeneralViewWindow.root)
    				else
    					fwin:open(heroRecruitGeneralViewWindow,fwin._ui)
    				end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	--蜀将	
		local hero_recruit_shu_list_view_manager_terminal = {
            _name = "hero_recruit_shu_list_view_manager",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local heroRecruitGeneralViewWindow = HeroRecruitGeneralView:new()
				heroRecruitGeneralViewWindow:init(3)
				fwin:open(heroRecruitGeneralViewWindow,fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	--帮助	
		local hero_recruit_help_manager_terminal = {
            _name = "hero_recruit_help_manager",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			fwin:open(ShopHeroPage:new(),fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
      --阵营招募时间到了刷新充值	
		local hero_recruit_shop_updatecamp_terminal = {
            _name = "hero_recruit_shop_updatecamp",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.lock("hero_recruit_shop_updatecamp")
				local function responseBountyInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							response.node:updateDrawCamp(true)
						end
					else
						state_machine.unlock("hero_recruit_shop_updatecamp")
					end
				end
					NetworkManager:register(protocol_command.partner_bounty_init.code, nil, nil, nil, instance, responseBountyInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 打开
        local hero_recruit_shop_twopage_open_terminal = {
            _name = "hero_recruit_shop_twopage_open",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        	    if __lua_project_id == __lua_project_gragon_tiger_gate
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    or __lua_project_id == __lua_project_red_alert 
                    then
        	    	app.load("client.shop.recruit.LHeroRecruitGeneralViewTen")
					if fwin:find("LHeroRecruitGeneralViewTenClass") == nil then
						local LHeroRecruitGeneralViewTen = LHeroRecruitGeneralViewTen:new()
						LHeroRecruitGeneralViewTen:init(1, instance.oneState)
						fwin:open(LHeroRecruitGeneralViewTen,fwin._view)
						LHeroRecruitGeneralViewTen:setVisible(false)
					end
					if fwin:find("HeroRecruitGeneralViewClass") == nil then
						local _HeroRecruitGeneralView = HeroRecruitGeneralView:new()
						_HeroRecruitGeneralView:init(2, instance._oneState)
						fwin:open(_HeroRecruitGeneralView,fwin._view)
						_HeroRecruitGeneralView:setVisible(false)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local hero_recruit_shop_twopage_show_terminal = {
            _name = "hero_recruit_shop_twopage_show",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        	    if __lua_project_id == __lua_project_gragon_tiger_gate
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    or __lua_project_id == __lua_project_red_alert 
                    then
        	    	local view = fwin:find("LHeroRecruitGeneralViewTenClass")
					if view ~= nil then
						view:init(1, instance.oneState)
						view:onUpdateDraw()
						view:setVisible(true)
					end
					view = fwin:find("HeroRecruitGeneralViewClass")
					if view ~= nil then
						view:init(2, instance._oneState)
						view:onUpdateDraw()
						view:setVisible(true)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
               -- 关闭
        local hero_recruit_shop_twopage_close_terminal = {
            _name = "hero_recruit_shop_twopage_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
        	    if __lua_project_id == __lua_project_gragon_tiger_gate
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    or __lua_project_id == __lua_project_red_alert 
                    then
        	    	app.load("client.shop.recruit.LHeroRecruitGeneralViewTen")
					if fwin:find("LHeroRecruitGeneralViewTenClass") ~= nil then
						fwin:close(fwin:find("LHeroRecruitGeneralViewTenClass"))
					end
					if fwin:find("HeroRecruitGeneralViewClass") ~= nil then
						fwin:close(fwin:find("HeroRecruitGeneralViewClass"))
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        --返回，用于游戏王
        local hero_recruit_list_view_back_terminal = {
            _name = "hero_recruit_list_view_back",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
	     		fwin:cleanView(fwin._background)
                fwin:cleanView(fwin._view)
                fwin:cleanView(fwin._viewdialog)
                fwin:cleanView(fwin._ui)
                fwin:open(Home:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- Fecha apenas a janela do Recruit quando ela foi aberta pela Home.
        local hero_recruit_list_view_close_terminal = {
            _name = "hero_recruit_list_view_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local recruitWindow = fwin:find("HeroRecruitListViewClass")
                if recruitWindow ~= nil then
                    fwin:close(recruitWindow)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --
        local hero_recruit_list_view_chongzhi_terminal = {
            _name = "hero_recruit_list_view_chongzhi",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
                    or __lua_project_id == __lua_project_l_pokemon 
                    or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                    then
                    if funOpenDrawTip(181) == true then
                        return
                    end
                end
	     		app.load("client.shop.recharge.RechargeDialog")
				local Recharge = RechargeDialog:new()
				Recharge:init(4)
				fwin:open(Recharge , fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local hero_recruit_list_view_tujian_terminal = {
            _name = "hero_recruit_list_view_tujian",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.home.catalogue.CatalogueStorage")
	     		fwin:open(CatalogueStorage:new(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

        local hero_recruit_list_action_show_terminal = {
           	_name = "hero_recruit_list_action_show",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil then
            		instance:playActions(true)
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local hero_recruit_refreash_general_view_terminal = {
           	_name = "hero_recruit_refreash_general_view",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance ~= nil and instance.roots ~= nil then
            		if instance.openRecruitView ~= nil then
            			local pageIndex = instance.currentState
            			local pageState = 1
            			if instance.currentState == 1 then
							pageState = instance.oneState
            			else
            				pageState = instance._oneState
            			end
            			state_machine.excute("shop_hero_page_refresh_shop_info", 0, {pageIndex, pageState})
            		end
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local hero_recruit_list_open_camp_terminal = {
            _name = "hero_recruit_list_open_camp",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.user_info.user_grade) < dms.int(dms["fun_open_condition"],27,fun_open_condition.level) then
                    TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"],27,fun_open_condition.tip_info))
                    return
                end
                state_machine.excute("hero_recruit_of_camp_open", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local hero_recruit_list_view_preview_window_terminal = {
            _name = "hero_recruit_list_view_preview_window",
            _init = function (terminal) 
                app.load("client.l_digital.shop.SmRecruitPreviewWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local m_type = params._datas.m_type
                state_machine.excute("sm_recruit_preview_window_open", 0, {m_type})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(hero_recruit_list_view_chongzhi_terminal)
        state_machine.add(hero_recruit_list_view_tujian_terminal)
		state_machine.add(hero_recruit_list_view_manager_terminal)
		state_machine.add(hero_recruit_shen_list_view_manager_terminal)
		state_machine.add(hero_recruit_shu_list_view_manager_terminal)
		state_machine.add(hero_recruit_help_manager_terminal)
		state_machine.add(hero_recruit_shop_updatecamp_terminal)
		state_machine.add(hero_recruit_shop_twopage_open_terminal)
		state_machine.add(hero_recruit_shop_twopage_show_terminal)
		state_machine.add(hero_recruit_shop_twopage_close_terminal)
		state_machine.add(hero_recruit_list_view_back_terminal)
        state_machine.add(hero_recruit_list_view_close_terminal)
		state_machine.add(hero_recruit_list_action_show_terminal)
		state_machine.add(hero_recruit_refreash_general_view_terminal)
        state_machine.add(hero_recruit_list_open_camp_terminal)
        state_machine.add(hero_recruit_list_view_recruit_Page_terminal)
        state_machine.add(hero_recruit_list_view_a_recruiting_terminal)
        state_machine.add(hero_recruit_list_view_ten_recruiting_terminal)
        state_machine.add(hero_recruit_list_view_preview_window_terminal)

        state_machine.init()
    end
    
    -- call func init hero_recruit_list_view state machine.
    init_hero_recruit_list_view_terminal()
end

function HeroRecruitListView:formatTimeString(_time)	--系统时间转换
	local timeString = ""
    if math.floor(tonumber(_time)/3600) > 0 then
        timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    end
	timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
	return timeString
end

function HeroRecruitListView:playActions( isShow )
	local action = self.actions[1]
	if isShow == true then
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
            or __lua_project_id == __lua_project_l_pokemon 
            -- or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
            then
            action:play("animation_open", false)
        elseif __lua_project_id == __lua_project_l_naruto then
            action:play("animation_close", false)
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_18"):setVisible(false)
        else
            action:play("window_open", false)
        end
		state_machine.excute("shop_change_ui_layer_state", 0, true)
	else
		action:play("window_close", false)
		local function delatEnd( ... )
			state_machine.excute("shop_change_ui_layer_state", 0, false)
		end
		self:runAction(cc.Sequence:create(cc.DelayTime:create(0.1), cc.CallFunc:create(delatEnd)))
	end
end

function HeroRecruitListView:onUpdateDrawOne(dt)
	if __lua_project_id == __lua_project_warship_girl_a 
    	or __lua_project_id == __lua_project_warship_girl_b 
        or __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh 
    	or __lua_project_id == __lua_project_koone
    	then
		-- 首刷状态 -- 0 还有 -- 1 没有
		local first_satus_string = ccui.Helper:seekWidgetByName(self.roots[1], "Image_shoushuade")
		if missionIsOver() == false and zstring.tonumber(_ED.user_accumulate_buy_god) == zstring.tonumber(dms.string(dms["pirates_config"], 151, pirates_config.param)) then
		-- if first_satus_string:isVisible() == true and zstring.tonumber(_ED.free_info[2].first_satus) == 1 then
			first_satus_string:setVisible(true)
		-- end
		else
			first_satus_string:setVisible(false)
		end
	end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
        or __lua_project_id == __lua_project_l_pokemon 
        or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        local isChange = true
        if __lua_project_id == __lua_project_l_naruto then
            if self._isChangePage == false then
                isChange = false
            end
        end

        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            if tonumber(_ED.ten_reward_times) <= 0 then
                isChange = true
            else
                isChange = false
            end
        end 
        if isChange == true then
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_18"):setVisible(true)
            if self.action_updateTimes == 0 then
                self.actions[1]:play("animation_open", false)
            elseif self.action_updateTimes > 1.5 then
                self.actions[1]:play("animation_close", false)
                self.action_updateTimes = -3
            elseif self.action_updateTimes >= -1 and self.action_updateTimes < 0 then
                self.action_updateTimes = 0
                self.actions[1]:play("animation_open", false)
            end
            self.action_updateTimes = self.action_updateTimes + dt
        end
    end
    if _ED.user_recruit_state_info ~= nil then
        local Panel_18 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_18")
        if Panel_18 ~= nil then
            if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            else
                if tonumber(_ED.user_recruit_state_info[2]) == 1 then
                    Panel_18:setVisible(false)
                else
                    Panel_18:setVisible(true)
                end
            end
        end
    end
	local RecruitStr =dms.string(dms["pirates_config"], 273, pirates_config.param)
	local pMouID = zstring.split(RecruitStr,",")	
	local propRecruitCount = getPropAllCountByMouldId(pMouID[13])--战将招募令数量
	local propSpiritCount = getPropAllCountByMouldId(pMouID[14])--神将招募令数量
    if __lua_project_id == __lua_project_l_naruto then
        local ticket=dms.string(dms.shop_config,4,shop_config.param)
        propSpiritCount=getPropAllCountByMouldId(ticket)
    end
	local TextRecruit 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_1_1")--战将招募令
	if TextRecruit ~= nil then
        TextRecruit:setString(propRecruitCount)
    end
	local TextSpiritRecruit = ccui.Helper:seekWidgetByName(self.roots[1], "Text_lzy")--神将招募令
	if TextSpiritRecruit ~= nil then
        TextSpiritRecruit:setString(propSpiritCount)
    end
	local everyDayFreeTime = tonumber(_ED.free_info[1].surplus_free_number) or 0	-- 免费的次数
    local goldDayFreeTime = tonumber(_ED.free_info[2].surplus_free_number) or 0 -- 免费的次数
	local Panel_32 		= ccui.Helper:seekWidgetByName(self.roots[1], "Panel_32")	--免费次数已用完
	local Panel_33 		= ccui.Helper:seekWidgetByName(self.roots[1], "Panel_33")	--多少时间后免费
	local Panel_34 		= ccui.Helper:seekWidgetByName(self.roots[1], "Panel_34")	--本次免费
	local Panel_35 		= ccui.Helper:seekWidgetByName(self.roots[1], "Panel_32_1")	--神将多少时间后免费
	local Panel_36 		= ccui.Helper:seekWidgetByName(self.roots[1], "Panel_32_0_0")--神将本次免费
	local Panel_37		= ccui.Helper:seekWidgetByName(self.roots[1], "Panel_32_2")--神将招募令招募说明
	
	local diamond = dms.int(dms["partner_bounty_param"],2,partner_bounty_param.spend_gold)
	local Text_517 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_517")
	Text_517:setString(countActivityHeroDiscount().one)
	local Text_time = ccui.Helper:seekWidgetByName(Panel_33, "Text_shijian_1")	
	local Text_cishu	 = ccui.Helper:seekWidgetByName(Panel_34, "Text_cishu")
	
	local Text_time_1 = ccui.Helper:seekWidgetByName(Panel_35, "Text_518")	

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        local remainTime = (tonumber(_ED.free_info[1].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[1].free_start))--战将刷新时间
        local remainTime1 = (tonumber(_ED.free_info[2].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[2].free_start))--神将刷新时间

        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
            remainTime = (tonumber(_ED.free_info[1].next_free_time) or 0)/1000 - (_ED.system_time + (os.time() - _ED.native_time))
        end
        --银币的招募价格
        local Text_70_f = ccui.Helper:seekWidgetByName(self.roots[1], "Text_70_f") 
        Text_70_f:setString(dms.int(dms["partner_bounty_param"],1,partner_bounty_param.spend_silver))
        --银币招募的免费次数
        local Text_cishu2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_cishu") 
        Text_cishu2:setString(everyDayFreeTime.."/"..dms.int(dms["partner_bounty_param"],1,partner_bounty_param.free_count))
        --金币的招募价格
        local Text_517_f = ccui.Helper:seekWidgetByName(self.roots[1], "Text_517_f") 
        Text_517_f:setString(dms.int(dms["partner_bounty_param"],2,partner_bounty_param.spend_gold))
        --金币招募的免费次数
        local Text_cishu1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_cishu1") 
        Text_cishu1:setString(goldDayFreeTime.."/"..dms.int(dms["partner_bounty_param"],2,partner_bounty_param.free_count))
        local Text_551 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_551") 
        local Text_551_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_551_1") 
        Text_551_1:setString(everyDayFreeTime.."/"..dms.int(dms["partner_bounty_param"],1,partner_bounty_param.free_count))
        local Text_70 = ccui.Helper:seekWidgetByName(Panel_33, "Text_70") 
        --银币单次消耗的钱
        local Text_70_0 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_70_0") 
        Text_70_0:setString(dms.int(dms["partner_bounty_param"],1,partner_bounty_param.spend_silver))

        local Text_70_tip = ccui.Helper:seekWidgetByName(self.roots[1], "Text_70_tip") 
        --银币10次招募的钱
        local Text_70_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_70_1") 
        --临时的数据
        Text_70_1:setString(dms.int(dms["partner_bounty_param"],9,partner_bounty_param.spend_silver))
        if everyDayFreeTime <= 0 then 
            Text_551:setVisible(true)
            Text_551_1:setVisible(true)
            Text_time:setVisible(false)
            Text_70:setVisible(false)
            Text_70_tip:setVisible(false)
            Text_70_0:setVisible(true)
        else
            if remainTime > 0 then
                Text_time:setString(self:formatTimeString(remainTime))
                self.oneState = 1
                Text_551:setVisible(false)
                Text_551_1:setVisible(false)
                Text_time:setVisible(true)
                Text_70:setVisible(true)
                Text_70_tip:setVisible(false)
                Text_70_0:setVisible(true)
            else
                Text_551:setVisible(true)
                Text_551_1:setVisible(true)
                Text_time:setVisible(false)
                Text_70:setVisible(false)
                Text_70_0:setVisible(false)
                if everyDayFreeTime > 0 then
                    Text_70_tip:setVisible(true)
                    Text_70_0:setVisible(false)
                    Text_70_f:setString(_new_interface_text[16])
                else
                    Text_70_f:setString(dms.int(dms["partner_bounty_param"],1,partner_bounty_param.spend_silver))
                end   

            end
        end
        --宝石招募
        -- ccui.Helper:seekWidgetByName(Panel_36, "Text_55")       --本次免费
        -- ccui.Helper:seekWidgetByName(Panel_35, "Text_56")       --凌晨5点重置免费次数
        -- ccui.Helper:seekWidgetByName(Panel_35, "Text_cishu2")      --数字，接在Text_56_0前面
        -- ccui.Helper:seekWidgetByName(Panel_35, "Text_56_0")       --次后必得数码兽
        -- ccui.Helper:seekWidgetByName(Panel_35, "Text_56_1")       --本次必得数码兽
        ccui.Helper:seekWidgetByName(Panel_35, "Text_517"):setString(dms.int(dms["partner_bounty_param"],2,partner_bounty_param.spend_gold))       --单次招募用的宝石
        ccui.Helper:seekWidgetByName(Panel_35, "Text_5171"):setString(dms.int(dms["partner_bounty_param"],4,partner_bounty_param.spend_gold))       --十次招募用的宝石(这里写临时的)
        ccui.Helper:seekWidgetByName(Panel_35, "Text_5172")       --招募卡的数量显示
        local Text_517_f = ccui.Helper:seekWidgetByName(self.roots[1], "Text_517_f")
        
        local prop_id = dms.string(dms["shop_config"], 4, shop_config.param)
        local propData = fundPropWidthId(prop_id)

        if propData ~= nil and tonumber(propData.prop_number) >= 10 then
            ccui.Helper:seekWidgetByName(Panel_35, "Text_5171"):setString(propData.prop_number.."/10")
            ccui.Helper:seekWidgetByName(self.roots[1], "Image_21_1_0_0"):loadTexture("images/ui/icon/hongjiang.png")
        else
            if propData ~= nil then
                ccui.Helper:seekWidgetByName(self.roots[1], "Image_zuanshi"):loadTexture("images/ui/icon/hongjiang.png")
            else
                ccui.Helper:seekWidgetByName(self.roots[1], "Image_zuanshi"):loadTexture("images/ui/icon/zuanshi.png")
            end
            ccui.Helper:seekWidgetByName(self.roots[1], "Image_21_1_0_0"):loadTexture("images/ui/icon/zuanshi.png")
        end

        --有宝石免费
        local accumulateBuyGod = 0
        if tonumber(_ED.user_accumulate_buy_god) > 9 then
            accumulateBuyGod = tonumber(_ED.user_accumulate_buy_god)-10
        else
            accumulateBuyGod = tonumber(_ED.user_accumulate_buy_god)
        end
        local num_rest = 9-accumulateBuyGod
        if (__lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece) and _ED.hit_times then
            num_rest = _ED.hit_times
        end
        ccui.Helper:seekWidgetByName(Panel_35, "Text_cishu2"):setString(num_rest)
        if num_rest > 0 then
            ccui.Helper:seekWidgetByName(Panel_35, "Text_cishu2"):setVisible(true)
            ccui.Helper:seekWidgetByName(Panel_35, "Text_56_0"):setVisible(true)
            ccui.Helper:seekWidgetByName(Panel_35, "Text_56_1"):setVisible(false)
            if ccui.Helper:seekWidgetByName(Panel_35, "Text_56_0_0") ~= nil then
                ccui.Helper:seekWidgetByName(Panel_35, "Text_56_0_0"):setVisible(true)
            end
        else
            ccui.Helper:seekWidgetByName(Panel_35, "Text_cishu2"):setVisible(false)
            ccui.Helper:seekWidgetByName(Panel_35, "Text_56_0"):setVisible(false)
            ccui.Helper:seekWidgetByName(Panel_35, "Text_56_1"):setVisible(true)
            if ccui.Helper:seekWidgetByName(Panel_35, "Text_56_0_0") ~= nil then
                ccui.Helper:seekWidgetByName(Panel_35, "Text_56_0_0"):setVisible(false)
            end
        end

        if goldDayFreeTime > 0 then
            ccui.Helper:seekWidgetByName(Panel_36, "Text_55"):setVisible(true)
            ccui.Helper:seekWidgetByName(Panel_35, "Text_517"):setVisible(false)
            ccui.Helper:seekWidgetByName(Panel_35, "Text_5172"):setVisible(false)
            Text_517_f:setString(_new_interface_text[16])
        else
            ccui.Helper:seekWidgetByName(Panel_36, "Text_55"):setVisible(false)
            ccui.Helper:seekWidgetByName(Panel_35, "Text_517"):setVisible(true)
            ccui.Helper:seekWidgetByName(Panel_35, "Text_5172"):setVisible(false)
            if _ED.active_activity[46] ~= nil then
                if _ED.active_activity[46].activity_params == nil then
                    _ED.active_activity[46].activity_params = "0"
                end
                if tonumber(_ED.active_activity[46].activity_params) > 0 then
                    Text_517_f:setString(dms.int(dms["partner_bounty_param"],2,partner_bounty_param.spend_gold))
                else
                    Text_517_f:setString(_ED.active_activity[46].discount)
                end     
            else
                Text_517_f:setString(dms.int(dms["partner_bounty_param"],2,partner_bounty_param.spend_gold))
            end
            
            -- local prop_id = dms.string(dms["shop_config"], 4, shop_config.param)
            -- local propData = fundPropWidthId(prop_id)
            local Panel_ck_f_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_ck_f_2")
            local Panel_ck_b_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_ck_b_2")
            --有道具
            if propData ~= nil then
                ccui.Helper:seekWidgetByName(Panel_ck_f_2, "Image_21_1"):loadTexture("images/ui/icon/hongjiang.png")
                Text_517_f:setString(propData.prop_number.."/1")
                ccui.Helper:seekWidgetByName(Panel_ck_b_2, "Image_zuanshi"):loadTexture("images/ui/icon/hongjiang.png")
                ccui.Helper:seekWidgetByName(Panel_ck_b_2, "Image_zhaomushu"):setVisible(true)
                ccui.Helper:seekWidgetByName(Panel_35, "Text_517"):setString(propData.prop_number.."/1")
            else
                ccui.Helper:seekWidgetByName(Panel_ck_f_2, "Image_21_1"):loadTexture("images/ui/icon/zuanshi.png")
                ccui.Helper:seekWidgetByName(Panel_ck_b_2, "Image_zuanshi"):setVisible(true)
                ccui.Helper:seekWidgetByName(Panel_ck_b_2, "Image_zhaomushu"):setVisible(false)
                if _ED.active_activity[46] ~= nil then
                    if _ED.active_activity[46].activity_params == nil then
                        _ED.active_activity[46].activity_params = "0"
                    end
                    if tonumber(_ED.active_activity[46].activity_params) > 0 then
                        ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sale"):setVisible(false)
                        if __lua_project_id == __lua_project_l_naruto then
                            if ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sale_f") ~= nil then
                                ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sale_f"):setVisible(false)
                            end
                        end
                    else
                        ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sale"):setVisible(true)
                        if __lua_project_id == __lua_project_l_naruto then
                            if ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sale_f") ~= nil then
                                ccui.Helper:seekWidgetByName(self.roots[1], "Panel_sale_f"):setVisible(true)
                                Text_517_f:setString(dms.int(dms["partner_bounty_param"],2,partner_bounty_param.spend_gold))
                            end
                        end
                    end     
                end
            end
        end
    else
    	local remainTime = (tonumber(_ED.free_info[1].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[1].free_start))--战将刷新时间
    	local remainTime1 = (tonumber(_ED.free_info[2].next_free_time) or 0)/1000 - (os.time() - tonumber(_ED.free_info[2].free_start))--神将刷新时间
    	if remainTime == 0 then
    		if fwin:find("HeroRecruitGeneralViewClass")~= nil then 
    			fwin:close(fwin:find("HeroRecruitGeneralViewClass"))
    			fwin:open(HeroRecruitGeneralView:new(),_ui)
    		end
    	end
	
    	--战将
    	if everyDayFreeTime <= 0 then 
    		Panel_32:setVisible(true)
    		Panel_33:setVisible(false)
    		Panel_34:setVisible(false)
    		self.oneState = 2
    	else
    		if remainTime > 0 then
    			Text_time:setString(self:formatTimeString(remainTime))
    			Panel_33:setVisible(true)
    			Panel_32:setVisible(false)
    			Panel_34:setVisible(false)
    			self.oneState = 1
    				
    		else
    			if everyDayFreeTime <= 0 then
    				Panel_32:setVisible(true)
    				Panel_33:setVisible(false)
    				Panel_34:setVisible(false)
    				self.oneState = 2
    			else
    				Panel_34:setVisible(true)
    				Panel_32:setVisible(false)
    				Panel_33:setVisible(false)
    				self.oneState = 3
    				-- draw user prop count
    				Text_cishu:setString(""..everyDayFreeTime)
    			end
    		end
    	end
    	--神将
    	if remainTime1 > 0 then
    		Text_time_1:setString(self:formatTimeString(remainTime1))
    		if tonumber(propSpiritCount) > 0 then
    			Panel_37:setVisible(true)
    			Panel_35:setVisible(false)
    			Panel_36:setVisible(false)
    			self._oneState = 3
    		else
    			Panel_35:setVisible(true)
    			Panel_36:setVisible(false)
    			Panel_37:setVisible(false)
    			self._oneState = 1
    		end
    		
    	else
    		Panel_35:setVisible(false)
    		Panel_36:setVisible(true)
    		Panel_37:setVisible(false)
    		self._oneState = 2
    	end
	    if __lua_project_id == __lua_project_warship_girl_a 
            or __lua_project_id == __lua_project_warship_girl_b 
            or __lua_project_id == __lua_project_digimon_adventure 
            or __lua_project_id == __lua_project_naruto 
            or __lua_project_id == __lua_project_pokemon 
            or __lua_project_id == __lua_project_rouge 
            or __lua_project_id == __lua_project_yugioh 
            then

    		if self.user_accumulate_buy_god == -1 or  self.user_accumulate_buy_god ~= tonumber(_ED.user_accumulate_buy_god) then
    			local root = self.roots[1]
    			if root == nil then
    				return
    			end
    			self.user_accumulate_buy_god = tonumber(_ED.user_accumulate_buy_god)
    			local accumulateBuyGod = 0
    			ccui.Helper:seekWidgetByName(root, "Label_33404"):setVisible(true)
    			ccui.Helper:seekWidgetByName(root, "Label_33405"):setVisible(true)
    			ccui.Helper:seekWidgetByName(root, "Label_33406"):setVisible(true)
    			ccui.Helper:seekWidgetByName(root, "Label_33416"):setVisible(true)
    			if tonumber(_ED.user_accumulate_buy_god) > 9 then
    				accumulateBuyGod = tonumber(_ED.user_accumulate_buy_god)-10
    				ccui.Helper:seekWidgetByName(root, "Label_33406"):setVisible(false)
    				ccui.Helper:seekWidgetByName(root, "Label_33416"):setVisible(true)
    			else
    				accumulateBuyGod = tonumber(_ED.user_accumulate_buy_god)
    				ccui.Helper:seekWidgetByName(root, "Label_33406"):setVisible(true)
    				ccui.Helper:seekWidgetByName(root, "Label_33416"):setVisible(false)
    			end
    			
    			local getGodShipCont = 9 - accumulateBuyGod	--再抽几次就抽5星神将
    			if getGodShipCont > 0 then
    				local RecruitLabel = ccui.Helper:seekWidgetByName(root, "Label_33405")
    				RecruitLabel:setString(getGodShipCont)
    				
    				ccui.Helper:seekWidgetByName(root, "Label_33436"):setVisible(false)
    				ccui.Helper:seekWidgetByName(root, "Label_33426"):setVisible(false)
    			elseif getGodShipCont==0 then
    				ccui.Helper:seekWidgetByName(root, "Label_33404"):setVisible(false)
    				ccui.Helper:seekWidgetByName(root, "Label_33405"):setVisible(false)
    				ccui.Helper:seekWidgetByName(root, "Label_33406"):setVisible(false)
    				ccui.Helper:seekWidgetByName(root, "Label_33416"):setVisible(false)
    				if tonumber(_ED.user_accumulate_buy_god)>9 then
    					ccui.Helper:seekWidgetByName(root, "Label_33436"):setVisible(true)
    				else
    					ccui.Helper:seekWidgetByName(root, "Label_33426"):setVisible(true)
    				end
    			end
    		end	
    	end

    	if __lua_project_id == __lua_project_gragon_tiger_gate
            or __lua_project_id == __lua_project_red_alert 
            then
    		if self.isshow == false then
    			self.actions[1]:play("window_open",false)
    			self.isshow = true
    		end
        end
	end
end

function HeroRecruitListView:onUpdateDrawCampTime()
	if tonumber(_ED.user_info.user_grade) < dms.int(dms["fun_open_condition"],27,fun_open_condition.level) then --功能没开启的时候 就不刷新时间了
		return
	end
	local camptime =tonumber(_ED.user_bounty_update_times)/1000 - os.time() - (tonumber(_ED.system_time)- tonumber(_ED.native_time))
	--神将刷新时间
	if self.lastupdatetime == camptime or self.campupdatetimetext == nil then--时间变化没有1秒，并且页面未加载完 也不进入刷新
		return
	end
	self.lastupdatetime = camptime
	if camptime <= 0 then
		--如果时间小于等于0刷新
		state_machine.excute("hero_recruit_shop_updatecamp",0,"")
		return
	end
	local strtime = HeroRecruitListView:formatTimeString(camptime)
	self.campupdatetimetext:setString(strtime)
	if self.update_type == true then
		state_machine.unlock("hero_recruit_shop_updatecamp")
		self.update_type = false
	end
end
function HeroRecruitListView:onUpdate(dt)
	self:onUpdateDrawOne(dt)
	if (__lua_project_id == __lua_project_warship_girl_a 
        or __lua_project_id == __lua_project_warship_girl_b 
        or __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_naruto 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh)
		and  ___is_open_bounty == true
		then
		self:onUpdateDrawCampTime()
		if self.bounty_count ~= nil and self.bounty_count ~= _ED.user_bounty_info.today_bounty_count then
			local root = self.roots[1] 
			if root == nil then
				return
			end
			local config =  zstring.split( dms.string(dms["pirates_config"],294,pirates_config.param),",")
			self.bounty_count = _ED.user_bounty_info.today_bounty_count
			if tonumber(config[2]) >= _ED.user_bounty_info.today_bounty_count then 
				ccui.Helper:seekWidgetByName(root,"Text_515_0"):setString(tonumber(config[2])-_ED.user_bounty_info.today_bounty_count)
			else
				ccui.Helper:seekWidgetByName(root,"Text_515_0"):setString("0")
			end
		end
	end
end
function HeroRecruitListView:updateDrawCamp(update_type)
	local root = self.roots[1]
	local Text_515 = ccui.Helper:seekWidgetByName(root,"Text_515") --时间
	self.campupdatetimetext = Text_515
	local Text_516 = ccui.Helper:seekWidgetByName(root,"Text_516") --消耗宝石
	local camp_price_table = dms.string(dms["pirates_config"],293,pirates_config.param)
	local camp_price = zstring.split(camp_price_table,",")
	Text_516:setString(camp_price[1])
	local Button_17_zhenying = ccui.Helper:seekWidgetByName(root,"Button_17_zhenying")
	local config =  zstring.split( dms.string(dms["pirates_config"],294,pirates_config.param),",")
	self.bounty_count = _ED.user_bounty_info.today_bounty_count
	if tonumber(config[2]) >= _ED.user_bounty_info.today_bounty_count then 
 		ccui.Helper:seekWidgetByName(root,"Text_515_0"):setString(tonumber(config[2])-_ED.user_bounty_info.today_bounty_count)
 	else
 		ccui.Helper:seekWidgetByName(root,"Text_515_0"):setString("0")
 	end

	local typeid = _ED.user_bounty_typeid
	local button_name = string.format("images/ui/button/zhenying_%d.png",typeid)
	Button_17_zhenying:loadTextures(button_name,button_name,button_name)
	if tonumber(_ED.user_info.user_grade) < dms.int(dms["fun_open_condition"],27,fun_open_condition.level) then
		local Panel_32_1_0 = ccui.Helper:seekWidgetByName(root,"Panel_32_1_0")
		Panel_32_1_0:setVisible(false)
	end
	if update_type == true then
		self.update_type = true
	end
end

function HeroRecruitListView:onEnterTransitionFinish()
	-- Cenário de recrutamento extraído do APK de referência, atrás dos painéis.
	local recruitBackdrop = cc.Sprite:create("images/ui/bg/shop_bg.png")
	if recruitBackdrop ~= nil then
		local windowSize = cc.Director:getInstance():getWinSize()
		local imageSize = recruitBackdrop:getContentSize()
		local scale = math.max(windowSize.width / imageSize.width, windowSize.height / imageSize.height)
		recruitBackdrop:setScale(scale)
		recruitBackdrop:setPosition(cc.p(windowSize.width / 2, windowSize.height / 2))
		self:addChild(recruitBackdrop, -1)
	end
	state_machine.excute("hero_recruit_shop_twopage_open",0,"")
	local csbShopRecruitList = csb.createNode("shop/shop.csb")
	local root = csbShopRecruitList:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbShopRecruitList)
	-- A cena original não inclui um X para a abertura direta pela Home.
	local recruitCloseButton = ccui.Button:create("images/ui/button/button_close_1.png", "images/ui/button/button_close_1.png")
	if recruitCloseButton ~= nil then
		local windowSize = cc.Director:getInstance():getWinSize()
		local buttonSize = recruitCloseButton:getContentSize()
		recruitCloseButton:setScale(0.9)
		recruitCloseButton:setPosition(cc.p(windowSize.width - buttonSize.width * 0.55, windowSize.height - buttonSize.height * 0.55))
		self:addChild(recruitCloseButton, 1000)
		fwin:addTouchEventListener(recruitCloseButton, nil,
		{
			terminal_name = "hero_recruit_list_view_close",
			terminal_state = 0,
			isPressedActionEnabled = true
		}, nil, 0)
	end
	local action = csb.createTimeline("shop/shop.csb")
	table.insert(self.actions,action)
	if __lua_project_id == __lua_project_gragon_tiger_gate
        or __lua_project_id == __lua_project_red_alert 
        then
    elseif __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge
        then
        action:play("window_open", false)
    elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
        -- or __lua_project_id == __lua_project_l_naruto 
        then
        action:play("animation_open", false)
    elseif __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_l_pokemon then
        ccui.Helper:seekWidgetByName(self.roots[1], "Panel_18"):setVisible(false)
	else
		action:gotoFrameAndPlay(0, action:getDuration(), false)
	end
	csbShopRecruitList:runAction(action)

	if __lua_project_id == __lua_project_gragon_tiger_gate
        -- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
        -- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        or __lua_project_id == __lua_project_red_alert 
        then
	    action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end

	        local str = frame:getEvent()
	        if str == "window_open_over" then
	        	state_machine.excute("hero_recruit_shop_twopage_show",0,"")
	        end
	        
	    end)
		local Panel1 = ccui.Helper:seekWidgetByName(root, "Panel_chaofan_dh")
		local Panel2 = ccui.Helper:seekWidgetByName(root, "Panel_chaosheng_dh")
		Panel1:removeAllChildren(true)
		Panel2:removeAllChildren(true)
		local animation1 = "zhaomu_0"
		local jsonFile1 = "images/ui/effice/zhaomu_0/zhaomu_0.json"
		local atlasFile1 = "images/ui/effice/zhaomu_0/zhaomu_0.atlas"
		if cc.FileUtils:getInstance():isFileExist(jsonFile1) == true then
			local animate1= sp.spine(jsonFile1, atlasFile1, 1, 0, animation1, true, nil)
			Panel1:addChild(animate1)
		end

		
		local animation2 = "zhaomu_1"
		local jsonFile2 = "images/ui/effice/zhaomu_1/zhaomu_1.json"
		local atlasFile2 = "images/ui/effice/zhaomu_1/zhaomu_1.atlas"
		if cc.FileUtils:getInstance():isFileExist(jsonFile2) == true then
			local animate2= sp.spine(jsonFile2, atlasFile2, 1, 0, animation2, true, nil)
			Panel2:addChild(animate2)
		end
	elseif __lua_project_id == __lua_project_yugioh then 
		local Panel_shop = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
		Panel_shop:removeAllChildren(true)
		local animation1 = "daiji"
		local jsonFile1 = "images/ui/effice/effect_ui_magicgirl/effect_ui_magicgirl.json"
		local atlasFile1 = "images/ui/effice/effect_ui_magicgirl/effect_ui_magicgirl.atlas"
		if cc.FileUtils:getInstance():isFileExist(jsonFile1) == true then
			local animate1= sp.spine(jsonFile1, atlasFile1, 1, 0, animation1, true, nil)
			Panel_shop:addChild(animate1)
		end
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
		{
			terminal_name = "hero_recruit_list_view_back", 
			terminal_state = 1, 
			isPressedActionEnabled = SetPressedActionEnabled
		}, 
		nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tj"), nil, 
		{
			terminal_name = "hero_recruit_list_view_tujian", 
			terminal_state = 1, 
			isPressedActionEnabled = SetPressedActionEnabled
		}, 
		nil, 0)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cz"), nil, 
		{
			terminal_name = "hero_recruit_list_view_chongzhi", 
			terminal_state = 1, 
			isPressedActionEnabled = SetPressedActionEnabled
		}, 
		nil, 0)

	end
	-- Initialize ui widget callback
	local SetPressedActionEnabled = true 
	if __lua_project_id == __lua_project_gragon_tiger_gate
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        or __lua_project_id == __lua_project_red_alert 
        then
		SetPressedActionEnabled = false
	end
	if (__lua_project_id == __lua_project_warship_girl_a 
        or __lua_project_id == __lua_project_warship_girl_b 
        or __lua_project_id == __lua_project_digimon_adventure 
        or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge 
        or __lua_project_id == __lua_project_yugioh)
		and ___is_open_bounty == true
	    then
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_shop_zhengy_building",
		_widget = ccui.Helper:seekWidgetByName(root, "Button_17_zhenying"),
		_invoke = nil,
		_interval = 1,})	
	end
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        or __lua_project_id == __lua_project_red_alert 
        then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tujian"), nil, 
		{
			terminal_name = "home_click_CatalogueStorage", 
			terminal_state = 0,
			isPressedActionEnabled = true
		}, 
		nil, 0)
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_15"), nil, 
	{
		terminal_name = "hero_recruit_list_view_manager", 
		terminal_state = 1, 
		isPressedActionEnabled = SetPressedActionEnabled
	}, 
	nil, 0)
	
    local pushNode = ccui.Helper:seekWidgetByName(root, "Button_15")
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
        or __lua_project_id == __lua_project_l_pokemon 
        or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        pushNode = ccui.Helper:seekWidgetByName(root, "Image_zhaomu_di_1") 
    end
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_shop_small_building",
		_widget = pushNode,
		_invoke = nil,
		_interval = 1,})	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_16"), nil, 
	{
		terminal_name = "hero_recruit_shen_list_view_manager", 
		terminal_state = 2, 
		isPressedActionEnabled = SetPressedActionEnabled
	}, 
	nil, 0)

    local pushNode2 = ccui.Helper:seekWidgetByName(root, "Button_16")
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        pushNode2 = ccui.Helper:seekWidgetByName(root, "Image_zhaomu_di_2") 
    end
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_shop_large_building",
		_widget = pushNode2,
		_invoke = nil,
		_interval = 1,})

	local shu_recruit = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_17"), nil, 
	{
		terminal_name = "hero_recruit_shu_list_view_manager", 
		terminal_state = 3, 
		isPressedActionEnabled = SetPressedActionEnabled
	}, 
	nil, 0)
	
	if shu_recruit ~= nil and self.userCurrentLevel < self.threeRecruitNeedLevel then
		shu_recruit:setVisible(false)
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_18"), nil, 
	{
		func_string = [[state_machine.excute("hero_recruit_help_manager", 0, "click hero_recruit_help_manager.'")]],
		isPressedActionEnabled = SetPressedActionEnabled
	}, 
	nil, 0)

	if (__lua_project_id == __lua_project_warship_girl_a 
        or __lua_project_id ==__lua_project_warship_girl_b)
		and ___is_open_bounty == true
		then
		app.load("client.shop.recruit.HeroRecruitOfCamphelp")
		app.load("client.shop.recruit.HeroRecruitOfCamp")
		local Button_help = ccui.Helper:seekWidgetByName(root,"Button_help")
		fwin:addTouchEventListener(Button_help, nil, 
		{
			terminal_name = "hero_recruit_of_camphelp_open", 
			terminal_state = 0,
			isPressedActionEnabled = true
		}, 
		nil, 0)

		local Button_17_zhenying = ccui.Helper:seekWidgetByName(root,"Button_17_zhenying")
		fwin:addTouchEventListener(Button_17_zhenying, nil, 
		{
			terminal_name = "hero_recruit_list_open_camp", 
			terminal_state = 0,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		self:updateDrawCamp()
	end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        local Button_diji_back = ccui.Helper:seekWidgetByName(root,"Button_diji_back")
        fwin:addTouchEventListener(Button_diji_back, nil, 
        {
            terminal_name = "hero_recruit_list_view_recruit_Page", 
            terminal_state = 0,
            m_type = 1,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        local Button_gaoji_back = ccui.Helper:seekWidgetByName(root,"Button_gaoji_back")
        fwin:addTouchEventListener(Button_gaoji_back, nil, 
        {
            terminal_name = "hero_recruit_list_view_recruit_Page", 
            terminal_state = 0,
            m_type = 2,
            isPressedActionEnabled = true
        }, 
        nil, 0)

        --金币招募1次
        local Button_diji_1 = ccui.Helper:seekWidgetByName(root,"Button_diji_1")
        fwin:addTouchEventListener(Button_diji_1, nil, 
        {
            terminal_name = "hero_recruit_list_view_a_recruiting", 
            terminal_state = 0,
            m_type = 1,
            m_index = 1,
            terminal_button = Button_diji_1,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        --金币招募10次
        local Button_diji_10 = ccui.Helper:seekWidgetByName(root,"Button_diji_10")
        fwin:addTouchEventListener(Button_diji_10, nil, 
        {
            terminal_name = "hero_recruit_list_view_ten_recruiting", 
            terminal_state = 0,
            m_type = 1,
            m_index = 2,
            terminal_button = Button_diji_10,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        local Button_diji_100 = ccui.Helper:seekWidgetByName(root,"Button_diji_100")
        if Button_diji_100 ~= nil then
            fwin:addTouchEventListener(Button_diji_100, nil, 
            {
                terminal_name = "hero_recruit_list_view_ten_recruiting", 
                terminal_state = 0,
                m_type = 4,
                terminal_button = Button_diji_100,
                isPressedActionEnabled = true
            }, 
            nil, 0)
            if funOpenDrawTip(173, false) == true then
                Button_diji_100:setVisible(false)
                ccui.Helper:seekWidgetByName(root,"Image_21_0_0_444_0"):setVisible(false)
                ccui.Helper:seekWidgetByName(root,"Image_21_1_0"):setVisible(false)
                ccui.Helper:seekWidgetByName(root,"Text_70_1_0"):setVisible(false)
            else
                Button_diji_100:setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Image_21_0_0_444_0"):setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Image_21_1_0"):setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Text_70_1_0"):setVisible(true)
            end
        end
        --宝石招募1次
        local Button_gaoji_1 = ccui.Helper:seekWidgetByName(root,"Button_gaoji_1")
        fwin:addTouchEventListener(Button_gaoji_1, nil, 
        {
            terminal_name = "hero_recruit_list_view_a_recruiting", 
            terminal_state = 0,
            m_type = 2,
            m_index = 3,
            terminal_button = Button_gaoji_1,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        --宝石招募10次
        local Button_gaoji_10 = ccui.Helper:seekWidgetByName(root,"Button_gaoji_10")
        fwin:addTouchEventListener(Button_gaoji_10, nil, 
        {
            terminal_name = "hero_recruit_list_view_ten_recruiting", 
            terminal_state = 0,
            m_type = 2,
            m_index = 4,
            terminal_button = Button_gaoji_10,
            isPressedActionEnabled = true
        }, 
        nil, 0)

        --金币招募预览
        local Button_diji_yulan = ccui.Helper:seekWidgetByName(root,"Button_diji_yulan")
        fwin:addTouchEventListener(Button_diji_yulan, nil, 
        {
            terminal_name = "hero_recruit_list_view_preview_window", 
            terminal_state = 0,
            m_type = 1,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        --宝石招募预览
        local Button_gaoji_yulan = ccui.Helper:seekWidgetByName(root,"Button_gaoji_yulan")
        fwin:addTouchEventListener(Button_gaoji_yulan, nil, 
        {
            terminal_name = "hero_recruit_list_view_preview_window", 
            terminal_state = 0,
            m_type = 2,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

end

function HeroRecruitListView:onInit( parentParent )
	state_machine.excute("hero_recruit_shop_twopage_open",0,"")
	local csbShopRecruitList = csb.createNode("shop/shop.csb")
	local root = csbShopRecruitList:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
	self:addChild(csbShopRecruitList)
	local action = csb.createTimeline("shop/shop.csb")
	table.insert(self.actions,action)

	self.parentParent = parentParent

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball
        -- or __lua_project_id == __lua_project_l_naruto 
        then
        action:play("animation_open", false)
    elseif __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto or __lua_project_id == __lua_project_l_pokemon  then
        -- action:play("animation_close", false)
        ccui.Helper:seekWidgetByName(self.roots[1], "Panel_18"):setVisible(false)
    else
        action:play("window_open", false)
    end
	csbShopRecruitList:runAction(action)

	local function Button_15TouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
        sender = ccui.Helper:seekWidgetByName(self.roots[1], "Button_15")
        if eventType == ccui.TouchEventType.began then
        	if sender.playButtonTouchAction ~= true then
	        	sender.playButtonTouchAction = true
	        	sender:runAction(cc.ScaleTo:create(0.05, 1.08))
	        end
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        	if sender.playButtonTouchAction == true then
        		sender.playButtonTouchAction = false
        		sender:runAction(cc.ScaleTo:create(0.05, 1))
            end
        elseif eventType == ccui.TouchEventType.ended then
        	if sender.playButtonTouchAction == true then
        		sender.playButtonTouchAction = false
        		sender:runAction(cc.ScaleTo:create(0.05, 1))
            end
            if sender ~= nil and sender:getParent() ~= nil then
                if math.abs(__spoint.x - __epoint.x) <= 5 and math.abs(__spoint.y - __epoint.y) <= 3 then
                    state_machine.excute("hero_recruit_list_view_manager", 0, nil)
                end
            end
        end
    end

    local function Button_16TouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()
		sender = ccui.Helper:seekWidgetByName(self.roots[1], "Button_16")
		local scale = sender:getScale()
        if eventType == ccui.TouchEventType.began then
        	if sender.playButtonTouchAction ~= true then
	        	sender.playButtonTouchAction = true
	        	sender:runAction(cc.ScaleTo:create(0.05, 1.08))
	        end
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        	if sender.playButtonTouchAction == true then
        		sender.playButtonTouchAction = false
        		sender:runAction(cc.ScaleTo:create(0.05, 1))
            end
        elseif eventType == ccui.TouchEventType.ended then
        	if sender.playButtonTouchAction == true then
        		sender.playButtonTouchAction = false
        		sender:runAction(cc.ScaleTo:create(0.05, 1))
            end
            if sender ~= nil and sender:getParent() ~= nil then
                if math.abs(__spoint.x - __epoint.x) <= 5 and math.abs(__spoint.y - __epoint.y) <= 3 then
                    state_machine.excute("hero_recruit_shen_list_view_manager", 0, nil)
                end
            end
        end
    end

	local Button_putong = ccui.Helper:seekWidgetByName(root, "Button_putong")
	local Button_dashi = ccui.Helper:seekWidgetByName(root, "Button_dashi")
    if Button_putong ~= nil then
    	Button_putong:addTouchEventListener(Button_15TouchListener)
    end
    if Button_dashi ~= nil then
    	Button_dashi:addTouchEventListener(Button_16TouchListener)
    end

	if missionIsOver() == false then
		local Button_16 = ccui.Helper:seekWidgetByName(root, "Button_16")
		Button_16:setTouchEnabled(true)
		fwin:addTouchEventListener(Button_16, nil, 
		{
			terminal_name = "hero_recruit_shen_list_view_manager", 
			terminal_state = 2, 
			isPressedActionEnabled = SetPressedActionEnabled
		}, 
		nil, 0)
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_18"), nil, 
	{
		func_string = [[state_machine.excute("hero_recruit_help_manager", 0, "click hero_recruit_help_manager.'")]],
		isPressedActionEnabled = true
	}, 
	nil, 0)

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        local Panel_diwanglong = ccui.Helper:seekWidgetByName(root, "Panel_diwanglong")
        local Panel_lilith = ccui.Helper:seekWidgetByName(root, "Panel_lilith")
        if Panel_diwanglong ~= nil then
            Panel_diwanglong:removeAllChildren(true)
            local animation = "animation"
            local jsonFile = "images/ui/effice/effect_diwanglong/effect_diwanglong.json"
            local atlasFile = "images/ui/effice/effect_diwanglong/effect_diwanglong.atlas"
            if cc.FileUtils:getInstance():isFileExist(jsonFile) == true then
                local animate = sp.spine(jsonFile, atlasFile, 1, 0, animation, true, nil)
                Panel_diwanglong:addChild(animate)
            end
        end
        if Panel_lilith ~= nil then
            Panel_lilith:removeAllChildren(true)
            local animation1 = "animation"
            local jsonFile1 = "images/ui/effice/effect_lilith/effect_lilith.json"
            local atlasFile1 = "images/ui/effice/effect_lilith/effect_lilith.atlas"
            if cc.FileUtils:getInstance():isFileExist(jsonFile1) == true then
                local animate1 = sp.spine(jsonFile1, atlasFile1, 1, 0, animation1, true, nil)
                Panel_lilith:addChild(animate1)
            end
        end

        local Button_diji_back = ccui.Helper:seekWidgetByName(root,"Button_diji_back")
        fwin:addTouchEventListener(Button_diji_back, nil, 
        {
            terminal_name = "hero_recruit_list_view_recruit_Page", 
            terminal_state = 0,
            m_type = 1,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        local Button_gaoji_back = ccui.Helper:seekWidgetByName(root,"Button_gaoji_back")
        fwin:addTouchEventListener(Button_gaoji_back, nil, 
        {
            terminal_name = "hero_recruit_list_view_recruit_Page", 
            terminal_state = 0,
            m_type = 2,
            isPressedActionEnabled = true
        }, 
        nil, 0)

        --金币招募1次
        local Button_diji_1 = ccui.Helper:seekWidgetByName(root,"Button_diji_1")
        fwin:addTouchEventListener(Button_diji_1, nil, 
        {
            terminal_name = "hero_recruit_list_view_a_recruiting", 
            terminal_state = 0,
            m_type = 1,
            m_index = 1,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_shop_small_building",
            _widget = Button_diji_1,
            _invoke = nil,
            _interval = 1,})
        --金币招募10次
        local Button_diji_10 = ccui.Helper:seekWidgetByName(root,"Button_diji_10")
        fwin:addTouchEventListener(Button_diji_10, nil, 
        {
            terminal_name = "hero_recruit_list_view_ten_recruiting", 
            terminal_state = 0,
            m_type = 1,
            m_index = 2,
            terminal_button = Button_diji_10,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        local Button_diji_100 = ccui.Helper:seekWidgetByName(root,"Button_diji_100")
        if Button_diji_100 ~= nil then
            fwin:addTouchEventListener(Button_diji_100, nil, 
            {
                terminal_name = "hero_recruit_list_view_ten_recruiting", 
                terminal_state = 0,
                m_type = 4,
                terminal_button = Button_diji_100,
                isPressedActionEnabled = true
            }, 
            nil, 0)
            if funOpenDrawTip(173, false) == true then
                Button_diji_100:setVisible(false)
                ccui.Helper:seekWidgetByName(root,"Image_21_0_0_444_0"):setVisible(false)
                ccui.Helper:seekWidgetByName(root,"Image_21_1_0"):setVisible(false)
                ccui.Helper:seekWidgetByName(root,"Text_70_1_0"):setVisible(false)
            else
                Button_diji_100:setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Image_21_0_0_444_0"):setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Image_21_1_0"):setVisible(true)
                ccui.Helper:seekWidgetByName(root,"Text_70_1_0"):setVisible(true)
            end
        end
        --宝石招募1次
        local Button_gaoji_1 = ccui.Helper:seekWidgetByName(root,"Button_gaoji_1")
        fwin:addTouchEventListener(Button_gaoji_1, nil, 
        {
            terminal_name = "hero_recruit_list_view_a_recruiting", 
            terminal_state = 0,
            m_type = 2,
            m_index = 3,
            terminal_button = Button_gaoji_1,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_shop_large_building",
            _widget = Button_gaoji_1,
            _invoke = nil,
            _interval = 1,})
        --宝石招募10次
        local Button_gaoji_10 = ccui.Helper:seekWidgetByName(root,"Button_gaoji_10")
        fwin:addTouchEventListener(Button_gaoji_10, nil, 
        {
            terminal_name = "hero_recruit_list_view_ten_recruiting", 
            terminal_state = 0,
            m_type = 2,
            m_index = 4,
            terminal_button = Button_gaoji_10,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        --金币招募预览
        local Button_diji_yulan = ccui.Helper:seekWidgetByName(root,"Button_diji_yulan")
        fwin:addTouchEventListener(Button_diji_yulan, nil, 
        {
            terminal_name = "hero_recruit_list_view_preview_window", 
            terminal_state = 0,
            m_type = 1,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        --宝石招募预览
        local Button_gaoji_yulan = ccui.Helper:seekWidgetByName(root,"Button_gaoji_yulan")
        fwin:addTouchEventListener(Button_gaoji_yulan, nil, 
        {
            terminal_name = "hero_recruit_list_view_preview_window", 
            terminal_state = 0,
            m_type = 2,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

	self:registerOnNoteUpdate(self, 1)
end

function HeroRecruitListView:close( ... )
	self:unregisterOnNoteUpdate(self)
end

function HeroRecruitListView:onExit()
	state_machine.remove("hero_recruit_list_view_manager")
	state_machine.remove("hero_recruit_shen_list_view_manager")
	state_machine.remove("hero_recruit_shu_list_view_manager")
	state_machine.remove("hero_recruit_help_manager")
	state_machine.remove("hero_recruit_shop_updatecamp")
	state_machine.remove("hero_recruit_shop_twopage_open")
	state_machine.remove("hero_recruit_shop_twopage_show")
	state_machine.remove("hero_recruit_shop_twopage_close")
	state_machine.remove("hero_recruit_list_view_back")
	state_machine.remove("hero_recruit_list_view_close")
	state_machine.remove("hero_recruit_list_action_show")
	state_machine.remove("hero_recruit_refreash_general_view")
    state_machine.remove("hero_recruit_list_open_camp")
    state_machine.remove("hero_recruit_list_view_preview_window")
end
