-- ----------------------------------------------------------------------------------------------------
-- 说明：战将招募
-------------------------------------------------------------------------------------------------------

HeroRecruitGeneralView = class("HeroRecruitGeneralViewClass", Window)

function HeroRecruitGeneralView:ctor()
    self.super:ctor()
	app.load("client.shop.recruit.HeroRecruitSuccess")
	app.load("client.shop.recruit.HeroRecruitSuccessTen")
	app.load("client.shop.recruit.HeroPurpleShow")
	self.roots = {}
	self.group = {}
	self.pageIndex = 0			-- 哪个panel显示
	self.pageState = 0			-- recurit page state 
	self.Heronumber = 0			--战将招募令
	self.HeronumberGod = 0			--神将招募令
	self.everyDayFreeTime = 0	--战将免费时间
	self.root = nil
	
	
	-- Initialize hero_recruit_list_view page state machine.
    local function init_hero_recruit_list_view_terminal()
		
		-- The close recruit window, back shop recruit page.
		local hero_recruit_general_view_close_window_terminal = {
            _name = "hero_recruit_general_view_close_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge
					then
            		state_machine.excute("hero_recruit_list_action_show")
            		instance:removeFromParent(true)
                else
                	fwin:close(instance)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--招募预览按钮
		local shop_hero_page_return_show_shop_terminal = {
            _name = "shop_hero_page_return_show_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.shop.HeroRecruitPreview")
				local cell = HeroRecruitPreview:new()
				cell:init(params._datas._types)
				fwin:open(cell, fwin._windows)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- [[战将招募
		local shop_hero_free_recruit_terminal = {
            _name = "shop_hero_free_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					local herorIndex = params._datas._herorIndex --战将招募一次的索引
					local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
									or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
									or __lua_project_id == __lua_project_red_alert 
									then
									if fwin:find("HeroRecruitSuccessClass") ~= nil then
										fwin:close(fwin:find("HeroRecruitSuccessClass"))
									end
								end
								local obj = HeroRecruitSuccess:new()
								obj:setRanking(herorIndex,response.node.pageIndex)
								fwin:open(obj,fwin._view)
								state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
								if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
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
					if herorIndex == 1 then--战将免费招募
						if self.everyDayFreeTime > 0 or self.Heronumber > 0 and  self.Heronumber < 10 then
							protocol_command.ship_bounty.param_list = ""..instance.pageIndex
							NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, instance, recruitCallBack, false, nil)
						end
					elseif herorIndex == 2 then--战将令招募
						if self.Heronumber > 0 then
							protocol_command.ship_bounty.param_list = ""..instance.pageIndex
							NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, instance, recruitCallBack, false, nil)
						else
							TipDlg.drawTextDailog(_string_piece_info[72])
						end
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--招募十次
		local shop_hero_page_chick_recruit_ten_terminal = {
            _name = "shop_hero_free_recruit_ten",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					local herorIndex = params._datas._herorIndex
					local function tenrecruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								local obj = HeroRecruitSuccessTen:new()
								obj:setRanking(herorIndex,response.node.pageIndex)
								fwin:open(obj,fwin._view)
								state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
								
								if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
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
					if self.Heronumber >= 9 then
						protocol_command.ship_batch_bounty.param_list =""..instance.pageIndex
						NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, instance, tenrecruitCallBack, false, nil)
						
					else
						TipDlg.drawTextDailog(_string_piece_info[72])
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--]]
		-- [[神将招募
		--一次
		local shop_hero_free_deity_recruit_terminal = {
            _name = "shop_hero_free_deity_recruit",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					local herorIndex = params._datas._herorIndex
					-- local _goldNumber = tonumber(dms.string(dms["partner_bounty_param"],2,partner_bounty_param.spend_gold))
					local price = countActivityHeroDiscount()
					local function recruitCallBack(response)
						if (__lua_project_id == __lua_project_warship_girl_a 
							or __lua_project_id == __lua_project_warship_girl_b 
							or __lua_project_id == __lua_project_digimon_adventure 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_yugioh) 
							and params.status ~= nil then
							state_machine.excute("use_diamond_confirm_tip_close",0,"")
						end
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then

							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
								if fwin:find("HeroRecruitSuccessClass") ~= nil then
									fwin:close(fwin:find("HeroRecruitSuccessClass"))
								end
							end
							local obj = HeroRecruitSuccess:new()
							obj:setRanking(herorIndex,instance.pageIndex)
							fwin:open(obj,fwin._view)
							state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert
								 then
								state_machine.excute("hero_recruit_shop_twopage_close",0,"")
							else
								fwin:close(instance)
							end
						end
					end
					if herorIndex == 4 then--神将免费招募
						protocol_command.ship_bounty.param_list = ""..instance.pageIndex
						NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, instance, recruitCallBack, false, nil)
					elseif  herorIndex == 5 then--神将卡招募或者元宝招募
						if self.HeronumberGod > 0 or tonumber(_ED.user_info.user_gold) >= price.one or self.pageState == 2 or self.pageState == 3 then
							if (__lua_project_id == __lua_project_warship_girl_a 
								or __lua_project_id == __lua_project_warship_girl_b 
								or __lua_project_id == __lua_project_digimon_adventure 
								or __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge 
								or __lua_project_id == __lua_project_yugioh) 
								and ___is_open_diamond_confirm == true 
								and self.HeronumberGod <= 0 
								and params.status == nil 
								then
								app.load("client.utils.UseDiamondConfirmTip")
								local window_terminal = state_machine.find("use_diamond_confirm_tip_open")
				            	if window_terminal.unopen ~= true then
				            		local str1 = string.format(tipStringInfo_use_diamond[1],price.one)
				            		local str2 = tipStringInfo_use_diamond[2]
				            		state_machine.excute("use_diamond_confirm_tip_open", 0, {_datas={instance,nil,str1.."|"..str2 ,params}})
				            		return
				            	else
				            		protocol_command.ship_bounty.param_list = ""..instance.pageIndex
									NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, instance, recruitCallBack, false, nil)
							    end
							else
								protocol_command.ship_bounty.param_list = ""..instance.pageIndex
								NetworkManager:register(protocol_command.ship_bounty.code, nil, nil, nil, instance, recruitCallBack, false, nil)
							end
						else
							TipDlg.drawTextDailog(_string_piece_info[74])
						end
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--十次
		local shop_hero_free_deity_ten_recruit_terminal = {
            _name = "shop_hero_free_recruit_deity_ten",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					local herorIndex = params._datas._herorIndex
					-- local _goldNumber = tonumber(dms.string(dms["partner_bounty_param"],4,partner_bounty_param.spend_gold))
					local price = countActivityHeroDiscount()
					local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if (__lua_project_id == __lua_project_warship_girl_a 
								or __lua_project_id == __lua_project_warship_girl_b 
								or __lua_project_id == __lua_project_digimon_adventure 
								or __lua_project_id == __lua_project_pokemon 
								or __lua_project_id == __lua_project_rouge 
								or __lua_project_id == __lua_project_yugioh) 
								and params.status ~= nil then
								state_machine.excute("use_diamond_confirm_tip_close",0,"")
							end
							if response.node ~= nil and response.node.roots ~= nil then
								local obj = HeroRecruitSuccessTen:new()
								obj:setRanking(herorIndex,response.node.pageIndex)
								fwin:open(obj,fwin._view)
								state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
								
								if __lua_project_id == __lua_project_gragon_tiger_gate
									or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
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
					
					if self.HeronumberGod >= 9 or tonumber(_ED.user_info.user_gold) >= price.ten then
						if (__lua_project_id == __lua_project_warship_girl_a 
							or __lua_project_id == __lua_project_warship_girl_b 
							or __lua_project_id == __lua_project_digimon_adventure 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_yugioh) 
							and ___is_open_diamond_confirm == true 
							and self.HeronumberGod <= 8 
							and params.status == nil 
							then
							app.load("client.utils.UseDiamondConfirmTip")
							local window_terminal = state_machine.find("use_diamond_confirm_tip_open")
			            	if window_terminal.unopen ~= true then
			            		local str1 = string.format(tipStringInfo_use_diamond[1],price.ten)
			            		local str2 = tipStringInfo_use_diamond[3]
			            		state_machine.excute("use_diamond_confirm_tip_open", 0, {_datas={instance,nil,str1.."|"..str2 ,params}})
			            		return
			            	else
			            		protocol_command.ship_batch_bounty.param_list = ""..instance.pageIndex
								NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, instance, recruitCallBack, false, nil)
						    end
						else
							protocol_command.ship_batch_bounty.param_list = ""..instance.pageIndex
							NetworkManager:register(protocol_command.ship_batch_bounty.code, nil, nil, nil, instance, recruitCallBack, false, nil)
						end
					else
						TipDlg.drawTextDailog(_string_piece_info[74])
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--刷新
		local shop_hero_page_refresh_shop_info_terminal = {
            _name = "shop_hero_page_refresh_shop_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance ~= nil and instance.roots ~= nil then
					instance.pageIndex = params[1]
					instance.pageState = params[2]
					instance:onUpdateDraw()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--]]
		
		
		state_machine.add(hero_recruit_general_view_close_window_terminal)
		state_machine.add(shop_hero_page_return_show_shop_terminal)
		state_machine.add(shop_hero_free_recruit_terminal)
		state_machine.add(shop_hero_page_chick_recruit_ten_terminal)
		state_machine.add(shop_hero_free_deity_recruit_terminal)
		state_machine.add(shop_hero_free_deity_ten_recruit_terminal)
		state_machine.add(shop_hero_page_refresh_shop_info_terminal)
        state_machine.init()
    end
    
    -- call func init hero_recruit_list_view state machine.
    init_hero_recruit_list_view_terminal()
end

--战将招募信息
function HeroRecruitGeneralView:HeroInitInfo()
	
end

function HeroRecruitGeneralView:onUpdateDraw()
	local root = self.roots[1] 
	local userid = _ED.user_info.user_id
	local RecruitStr =dms.string(dms["pirates_config"], 273, pirates_config.param)
	local pMouID = zstring.split(RecruitStr,",")	
	local propRecruitCount = getPropAllCountByMouldId(pMouID[13])--战将招募令数量
	local propSpiritCount = getPropAllCountByMouldId(pMouID[14])--神将招募令数量
	self.Heronumber = tonumber(propRecruitCount)
	self.HeronumberGod = tonumber(propSpiritCount)
	local Text_8_1 = ccui.Helper:seekWidgetByName(root, "Text_8_1")
	Text_8_1:setString(""..self.HeronumberGod)
	local Text_8 = ccui.Helper:seekWidgetByName(root, "Text_8")
	Text_8:setString(""..self.Heronumber)
	
	local Panel_01 = ccui.Helper:seekWidgetByName(root, "Panel_01")
	local Panel_02 = ccui.Helper:seekWidgetByName(root, "Panel_02")
	local Panel_03 = ccui.Helper:seekWidgetByName(root, "Panel_03")
	--战将招募
	if self.pageIndex == 1 then
		Panel_01:setVisible(true)
		Panel_02:setVisible(false)
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
		else
			Panel_03:setVisible(false)
		end
		local Panel_03_1 = ccui.Helper:seekWidgetByName(root, "Panel_03_1")
		local Panel_02_1 = ccui.Helper:seekWidgetByName(root, "Panel_02_1")
		if self.pageState == 1 then		--时间不为0
			Panel_03_1:setVisible(false)
			Panel_02_1:setVisible(true)
			if self.Heronumber <= 9 and self.Heronumber >0 then
				Panel_03_1:setVisible(true)
				Panel_02_1:setVisible(false)
			elseif self.Heronumber == 0 then
				local ButtonTen = ccui.Helper:seekWidgetByName(root, "Button_3342314")
				ButtonTen:setBright(false)
				ButtonTen:setTouchEnabled(false)
			end
		elseif self.pageState == 2 then	 --时间为0，免费次数为0
			Panel_03_1:setVisible(false)
			Panel_02_1:setVisible(true)
			if self.Heronumber <= 9 and self.Heronumber >0 then
				Panel_03_1:setVisible(true)
				Panel_02_1:setVisible(false)
			elseif self.Heronumber == 0 then
				local ButtonTen = ccui.Helper:seekWidgetByName(root, "Button_3342314")
				ButtonTen:setBright(false)
				ButtonTen:setTouchEnabled(false)
			end
		elseif self.pageState == 3 then			--时间为0，免费次数不为0
			Panel_03_1:setVisible(true)
			Panel_02_1:setVisible(false)
			local Panel_39 = ccui.Helper:seekWidgetByName(root, "Panel_39") 
			Panel_39:setVisible(false)
			local Panel_40 = ccui.Helper:seekWidgetByName(root, "Panel_40") 
			Panel_40:setVisible(true)
			self.everyDayFreeTime = tonumber(_ED.free_info[1].surplus_free_number) or 0	-- 免费的次数
			local Text_57 = ccui.Helper:seekWidgetByName(root, "Panel_40"):getChildByName("Text_57")
			Text_57:setString(self.everyDayFreeTime)
		end
	--神将招募
	elseif self.pageIndex == 2 then
		Panel_01:setVisible(false)
		Panel_02:setVisible(true)
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
		else
			Panel_03:setVisible(false)
		end
		local RecruitLabel = ccui.Helper:seekWidgetByName(root, "Label_33405")
		local accumulateBuyGod = 0
		if __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			then
			ccui.Helper:seekWidgetByName(root, "Label_33436"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Label_33426"):setVisible(false)
			ccui.Helper:seekWidgetByName(root, "Label_33404"):setVisible(true)
			ccui.Helper:seekWidgetByName(root, "Label_33405"):setVisible(true)
		end
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
			RecruitLabel:setString(getGodShipCont)
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
		local RMBLabel = ccui.Helper:seekWidgetByName(root, "Text_8_2")
		RMBLabel:setString(_ED.user_info.user_gold)
		
		--local diamondOne = ccui.Helper:seekWidgetByName(root, "Label_ptl_1")
		--local diamondTen = ccui.Helper:seekWidgetByName(root, "Label_ptl")
		local Panel_one = ccui.Helper:seekWidgetByName(root, "Panel_60")
		local Panel_two = ccui.Helper:seekWidgetByName(root, "Panel_02_2")
		--local _diamondOne = dms.string(dms["partner_bounty_param"],2,partner_bounty_param.spend_gold)
		--local _diamondTen = dms.string(dms["partner_bounty_param"],4,partner_bounty_param.spend_gold)
		if self.pageState == 1 then		--时间不为0
			Panel_one:setVisible(false)
			Panel_two:setVisible(true)
			--diamondOne:setString(_diamondOne)
			--diamondTen:setString(_diamondTen)
		elseif self.pageState == 2 or self.pageState == 3 then	--时间为0
			Panel_one:setVisible(true)
			Panel_two:setVisible(false)
			if self.pageState == 3 then
				ccui.Helper:seekWidgetByName(root, "Text_72"):setVisible(false)
				ccui.Helper:seekWidgetByName(root, "Label_33446"):setVisible(true)		
			end
		end
	--其他阵容招募
	elseif self.pageIndex == 3 then
		Panel_01:setVisible(false)
		Panel_02:setVisible(false)
		Panel_03:setVisible(true)
		if self.pageState == 1 then
			
		
		elseif self.pageState == 2 then	
		
		end
	end
	
end

function HeroRecruitGeneralView:onEnterTransitionFinish()
	self:onInit()
end

function HeroRecruitGeneralView:onInit( ... )
	local csbShopHeroPage = csb.createNode("shop/recruit_god.csb")
	local root = csbShopHeroPage:getChildByName("root") 
	self.root = root
	table.insert(self.roots, root)
	
	-- 原价处理
	if _ED.activity_hero_discount ~= nil then
		ccui.Helper:seekWidgetByName(root, "Panel_yuanjia_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_yuanjia_1_0"):setVisible(true)
		local originalCostOne = dms.int(dms["partner_bounty_param"], 2, partner_bounty_param.spend_gold)
		local originalCostTen = dms.int(dms["partner_bounty_param"], 4, partner_bounty_param.spend_gold)
		ccui.Helper:seekWidgetByName(root, "Text_yuanjia_1"):setString(originalCostOne)
		ccui.Helper:seekWidgetByName(root, "Text_yuanjia_1_54"):setString(originalCostTen)
	end
	
	-- 给各个金币框 赋值
	local price = countActivityHeroDiscount()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		ccui.Helper:seekWidgetByName(root, "Label_33403_3"):setString(price.one)
	end
	ccui.Helper:seekWidgetByName(root, "Label_ptl_1"):setString(price.one)
	ccui.Helper:seekWidgetByName(root, "Label_ptl"):setString(price.ten)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		local action = csb.createTimeline("shop/recruit_god.csb")
	   	action:gotoFrameAndPlay(0, action:getDuration(), false)
	    csbShopHeroPage:runAction(action)
	end
	
	-- add node to window
	self:addChild(csbShopHeroPage)
	
	-- update ui information
	self:onUpdateDraw()
	
	-- self:HeroInitInfo()
	
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		local _drawShips = nil
		if zstring.tonumber(self.pageIndex) == 2 then
			_drawShips = dms.searchs(dms["bounty_hero_param"], bounty_hero_param.bounty_group, 3)
		else
			_drawShips = dms.searchs(dms["bounty_hero_param"], bounty_hero_param.bounty_group, 1)
		end
		local _widget = ccui.Helper:seekWidgetByName(root, "Panel_41")
		
		
		local heros = {"Panel_84991", "Panel_84991_0"}
		local heros1 = {"Panel_67", "Panel_67_0"}
		local controllerLayerSize = ccui.Helper:seekWidgetByName(_widget, "Panel_84991"):getContentSize()
		local herosCount = table.getn(_drawShips)
		local currentIndex = math.random(1, herosCount)--随机开始
		local _index = 0
		if currentIndex % 2 == 0 then--第一个必须为奇数
			currentIndex = currentIndex + 1
		end
		local createHeroHead = nil
		local addActionToHeroHead1 = nil
		local addActionToHeroHead2 = nil
		function createHeroBody(index, sender)
			local drawShips = nil
			local tPanel = nil
			local uiLayer = nil
			local curIndex =  (index - 1) % 2 + 1
			if sender ~= nil then 
				tPanel = sender
				drawShips = sender._drawShips
				uiLayer = sender._uiLayer
			else
				tPanel = ccui.Helper:seekWidgetByName(_widget, heros[curIndex])
				tPanel._drawShips = _drawShips
				tPanel._uiLayer = self._uiLayer
				--tPanel._uiLayer:retain()
				drawShips = tPanel._drawShips
				uiLayer = tPanel._uiLayer
			end
			local nsCount = table.getn(drawShips)
			local ship = drawShips[((index - 1) % nsCount) + 1]
			local shipId = dms.atoi(ship,bounty_hero_param.prop_mould)			
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				or __lua_project_id == __lua_project_legendary_game 
				then			--龙虎门项目控制
				local temp_bust_index = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					----------------------新的数码的形象------------------------
					--进化形象
					local evo_image = dms.string(dms["ship_mould"], shipId, ship_mould.fitSkillTwo)
					local evo_info = zstring.split(evo_image, ",")
					--进化模板id
					-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
					local evo_mould_id = evo_info[dms.int(dms["ship_mould"], shipId, ship_mould.captain_name)]
					--新的形象编号
					temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
				else
					temp_bust_index = dms.int(dms["ship_mould"], shipId, ship_mould.bust_index)
				end
				-- local shipactive = ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
				-- local cell = ccs.Armature:create("spirte_" .. temp_bust_index)
				-- cell:getAnimation():playWithIndex(0)
				-- local heroPanel = ccui.Helper:seekWidgetByName(_widget, heros1[curIndex])
				-- heroPanel:removeAllChildren(true)
				-- heroPanel:addChild(cell)
				-- cell:setPosition(cc.p(heroPanel:getContentSize().width/2, 0))

				local heroPanel = ccui.Helper:seekWidgetByName(_widget, heros1[curIndex])
				heroPanel:removeAllChildren(true)
				draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), heroPanel, nil, nil, cc.p(0.5, 0))
				if animationMode == 1 then
					app.load("client.battle.fight.FightEnum")
					local shipSpine = sp.spine_sprite(heroPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						then
				        shipSpine:setScaleX(-1)
				    end
				else
					draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", heroPanel, -1, nil, nil, cc.p(0.5, 0))
				end
			else
				local shipData = dms.string(dms["ship_mould"], shipId,ship_mould.All_icon)
				local iconImage = string.format("images/face/big_head/big_head_%s.png", shipData)
				ccui.Helper:seekWidgetByName(_widget, heros1[curIndex]):setBackGroundImage(iconImage)
			end
			local shipData1 = nil
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], shipId, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				-- local ship_evo = zstring.split(fundShipWidthId(""..shipID).evolution_status, "|")
				local evo_mould_id = evo_info[dms.int(dms["ship_mould"], shipId, ship_mould.captain_name)]
				local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				local word_info = dms.element(dms["word_mould"], name_mould_id)
    			shipData1 = word_info[3]
			else
				shipData1 = dms.string(dms["ship_mould"], shipId,ship_mould.captain_name)
			end
			local _NameOne = ccui.Helper:seekWidgetByName(root, "Text_74")
			local _NameTwo = ccui.Helper:seekWidgetByName(root, "Text_74_0")
			_index = _index+1
			if _index % 2 ~= 0 then
				local colortype = dms.string(dms["ship_mould"], shipId,ship_mould.ship_type)
				if colortype ~= nil then
					_NameOne:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
				end
				_NameOne:setString(shipData1)
			else
				local colortype = dms.string(dms["ship_mould"], shipId,ship_mould.ship_type)
				if colortype ~= nil then
					_NameTwo:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
				end
				_NameTwo:setString(shipData1)
			end
			
			return tPanel
		end
		
		local function createHeroHeadFunN2(sender)
			local currHero2 = createHeroBody(currentIndex, sender)
			currHero2:setPosition(cc.p(controllerLayerSize.width, currHero2:getPositionY()))
			addActionToHeroHead2(currHero2)
			local currHero1 = sender._mxb
			addActionToHeroHead1(currHero1)
			currentIndex = currentIndex + 1
			
			if currentIndex % 10 == 0 then
				cc.Director:getInstance():getTextureCache():removeUnusedTextures() --内存释放
			end
		end
		
		addActionToHeroHead1 = function(_headLayer, _wait)
			local array = {}
			local _pos = cc.p(_headLayer:getPositionX() - controllerLayerSize.width, _headLayer:getPositionY())
			local actions  = cc.MoveTo:create(4, _pos)
			if _wait == true then
				table.insert(array, cc.DelayTime:create(1.0))
			end
			table.insert(array, actions)
			table.insert(array, cc.CallFunc:create(createHeroHeadFunN2))
			local seq = cc.Sequence:create(array)
			_headLayer:runAction(seq)
			return _headLayer
		end
		
		addActionToHeroHead2 = function(_headLayer, _wait)
			local array = {}
			local _pos = cc.p(_headLayer:getPositionX() - controllerLayerSize.width, _headLayer:getPositionY())
			local actions  = cc.MoveTo:create(4, _pos)
			if _wait == true then
				table.insert(array, cc.DelayTime:create(1))
			end
			table.insert(array, actions)
			local seq = cc.Sequence:create(array)
			_headLayer:runAction(seq)
			return _headLayer
		end

		createHeroHead1 = function ()
			local currHero1 = createHeroBody(currentIndex, nil)
			local currHero2 = createHeroBody(currentIndex + 1, nil)
			currentIndex = currentIndex + 2
			currHero1._mxb = currHero2
			currHero2._mxb = currHero1
			addActionToHeroHead1(currHero1, true)
			addActionToHeroHead2(currHero2, true)
			return currHero
		end
		
		createHeroHead1()
	end
	local _herorIndex = 0 --招募索引
	-- control ui widget, add touch event call back func.
	-- The window close button.
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_33401"), nil, 
	{
		func_string = [[state_machine.excute("hero_recruit_general_view_close_window", 0, "click hero_recruit_general_view_close_window.'")]],
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		-- func_string = [[state_machine.excute("shop_hero_page_return_show_shop", 0, "click shop_hero_page_return_show_shop.'")]],
		terminal_name = "shop_hero_page_return_show_shop", 
		terminal_state = 0, 
		_types = self.pageIndex,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	-- [[战将招募
	--免费招募的时候
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_33413"), nil, 
		{
			terminal_name = "shop_hero_free_recruit", 
			terminal_state = 0, 
			_herorIndex = 1,
			isPressedActionEnabled = true
		},
		nil,0)
	--招募一次
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_334213"), nil, 
		{
			terminal_name = "shop_hero_free_recruit", 
			terminal_state = 0, 
			_herorIndex = 2,
			isPressedActionEnabled = true
		},
		nil,0)
	
	--招募十次
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3342314"), nil, 
		{
			terminal_name = "shop_hero_free_recruit_ten", 
			terminal_state = 0, 
			_herorIndex = 3,
			isPressedActionEnabled = true
		},
		nil,0)
		--]]
		
	-- [[神将招募
		-- 免费招募
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_33413123_0"), nil, 
		{
			terminal_name = "shop_hero_free_deity_recruit", 
			terminal_state = 0, 
			_herorIndex = 4,
			isPressedActionEnabled = true
		},
		nil,0)
	--招募一次
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_33413123"), nil, 
		{
			terminal_name = "shop_hero_free_deity_recruit", 
			terminal_state = 0, 
			_herorIndex = 5,
			isPressedActionEnabled = true
		},
		nil,0)
	--招募十次
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_33414"), nil, 
		{
			terminal_name = "shop_hero_free_recruit_deity_ten", 
			terminal_state = 0, 
			_herorIndex = 6,
			isPressedActionEnabled = true
		},
		nil,0)
	--]]
end

function HeroRecruitGeneralView:onExit()
	state_machine.remove("hero_recruit_general_view_close_window")
	state_machine.remove("shop_hero_page_return_show_shop")
	state_machine.remove("shop_hero_free_recruit")
	state_machine.remove("shop_hero_free_recruit_ten")
	state_machine.remove("shop_hero_free_deity_recruit")
	state_machine.remove("shop_hero_free_recruit_deity_ten")
	state_machine.remove("shop_hero_page_refresh_shop_info")
end

function HeroRecruitGeneralView:init(pageIndex, pageState)
	self.pageIndex = pageIndex
	self.pageState = pageState
	if __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		then
		self:onInit()
	end
end
