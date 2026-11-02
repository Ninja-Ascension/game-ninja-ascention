-- ----------------------------------------------------------------------------------------------------
-- 说明：英雄碎片合成成功弹出界面
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

HeroFragmentSeatCombining = class("HeroFragmentSeatCombiningClass", Window)
    
function HeroFragmentSeatCombining:ctor()
    self.super:ctor()
	app.load("client.cells.ship_picture_cell_ten")
	self.roots = {}
	self.ship = nil
	self.info = nil
    -- Initialize HeroRecruitSuccess page state machine.
    local function init_hero_fragment_seat_combining_terminal()
		--返回招募预览界面
		local hero_fragment_seat_combining_over_terminal = {
            _name = "hero_fragment_seat_combining_over",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("HeroFragmentSeatCombiningClass"))
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					or __lua_project_id == __lua_project_legendary_game 
					then			--龙虎门项目控制
				else
					state_machine.excute("menu_show_event", 0, "menu_show_event.")
				end
				if fwin:find("UserInformationHeroStorageClass") ~= nil then
					fwin:find("UserInformationHeroStorageClass"):setVisible(true)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local hero_purple_close_terminal = {
            _name = "hero_purple_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
					local mAction = params._datas._action
					local mPanel_32 = params._datas._Panel_32
					mPanel_32:setTouchEnabled(false)
					mAction:play("close1", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(hero_fragment_seat_combining_over_terminal)
		state_machine.add(hero_purple_close_terminal)

        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_hero_fragment_seat_combining_terminal()
end

function HeroFragmentSeatCombining:ShowUI()
	local csbHeroRecruitSuccess = csb.createNode("shop/recruit_settlement_hecheng.csb")
	local csbHeroRecruitSuccess_root = csbHeroRecruitSuccess:getChildByName("root")
	local action = csb.createTimeline("shop/recruit_settlement_hecheng.csb")
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		for i,v in pairs(_ED.user_ship) do
			if _ED.recruit_success_ship_id == v.ship_id then
				self.ship = v
			end
		end
		local colortype = tonumber(dms.string(dms["ship_mould"], self.ship.ship_base_template_id,ship_mould.ship_type))
		if colortype >= 3 then
			action:play("open1", false)
		else
			action:play("window_open", false)
		end

		csbHeroRecruitSuccess:runAction(action)
		
		action:setTimeSpeed(app.getTimeSpeed())
		
		pushEffect(formatMusicFile("effect", 9991))
		table.insert(self.roots, csbHeroRecruitSuccess_root)
		self:addChild(csbHeroRecruitSuccess)
				
		local tempMusicIndex = zstring.tonumber(dms._element(dms["ship_sound_effect_param"], ship_sound_effect_param.ship_mould, self.ship.ship_template_id, ship_sound_effect_param.sound_effect2))
		if tempMusicIndex ~= nil and tempMusicIndex > 0  then
			pushEffect(formatMusicFile("effect", tempMusicIndex))
		end
		
		_ED.recruit_success_ship_id = nil
		

		if colortype >= 3 then
			pushEffect(formatMusicFile("effect", 9988))
			action:setFrameEventCallFunc(function (frame)
				if nil == frame then
					return
				end

				local str = frame:getEvent()
				if str == "open1_role" then
					self:createHero()
				elseif str == "next_close" then
					local Panel_32=  ccui.Helper:seekWidgetByName(csbHeroRecruitSuccess_root, "Panel_32")
					fwin:addTouchEventListener(Panel_32, nil, 
						{
							terminal_name = "hero_purple_close", 
							terminal_state = 0, 
							_action = action,
							_Panel_32 = Panel_32,
						},
						nil,0)
				end
			end)
		end

		if colortype < 3 then
			pushEffect(formatMusicFile("effect", 9988))
			action:setFrameEventCallFunc(function (frame)
				if nil == frame then
					return
				end

				local str = frame:getEvent()
				if str == "window_open_role" then
					self:createHero()
				elseif str == "next_action" then
					-- local Panel_32=  ccui.Helper:seekWidgetByName(csbHeroRecruitSuccess_root, "Panel_32")
					-- fwin:addTouchEventListener(Panel_32, nil, 
					-- 	{
					-- 		terminal_name = "hero_purple_close", 
					-- 		terminal_state = 0, 
					-- 		_action = action,
					-- 		_Panel_32 = Panel_32,
					-- 	},
					-- 	nil,0)
				end
			end)
		end

	else
		action:play("window_open", false)
		csbHeroRecruitSuccess:runAction(action)
		
		action:setTimeSpeed(app.getTimeSpeed())
		
			pushEffect(formatMusicFile("effect", 9991))
		table.insert(self.roots, csbHeroRecruitSuccess_root)
		self:addChild(csbHeroRecruitSuccess)
		
		for i,v in pairs(_ED.user_ship) do
			if _ED.recruit_success_ship_id == v.ship_id then
				self.ship = v
			end
		end
		
		local tempMusicIndex = zstring.tonumber(dms._element(dms["ship_sound_effect_param"], ship_sound_effect_param.ship_mould, self.ship.ship_template_id, ship_sound_effect_param.sound_effect2))
		if tempMusicIndex ~= nil and tempMusicIndex > 0  then
			pushEffect(formatMusicFile("effect", tempMusicIndex))
		end
		
		_ED.recruit_success_ship_id = nil
		local colortype = tonumber(dms.string(dms["ship_mould"], self.ship.ship_base_template_id,ship_mould.ship_type))
		if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
			self:createHero()
		end

		if colortype >= 3 then
			action:setFrameEventCallFunc(function (frame)
				if nil == frame then
					return
				end

				local str = frame:getEvent()
				if str == "open" then
				elseif str == "next_action" then
					action:play("open1", false)
					
					action:setFrameEventCallFunc(function (frame)
					pushEffect(formatMusicFile("effect", 9988))
						if nil == frame then
							return
						end

						local str1 = frame:getEvent()
						if str1 == "open" then
						elseif str1 == "next_close" then
							local Panel_32=  ccui.Helper:seekWidgetByName(csbHeroRecruitSuccess_root, "Panel_32")
							fwin:addTouchEventListener(Panel_32, nil, 
								{
									terminal_name = "hero_purple_close", 
									terminal_state = 0, 
									_action = action,
									_Panel_32 = Panel_32,
								},
								nil,0)
						end
					end)
				end
			end)
		end
		local captain_type = tonumber(dms.string(dms["ship_mould"], self.ship.ship_base_template_id,ship_mould.captain_type))
		if captain_type == 3 and colortype < 3 then 
			--宠物低品质
			action:setFrameEventCallFunc(function (frame)
				if nil == frame then
					return
				end

				local str = frame:getEvent()
				if str == "open" then
				elseif str == "next_action" then
					action:play("open1", false)
					
					action:setFrameEventCallFunc(function (frame)
					pushEffect(formatMusicFile("effect", 9988))
						if nil == frame then
							return
						end

						local str1 = frame:getEvent()
						if str1 == "open" then
						elseif str1 == "next_close" then
							local Panel_32=  ccui.Helper:seekWidgetByName(csbHeroRecruitSuccess_root, "Panel_32")
							fwin:addTouchEventListener(Panel_32, nil, 
								{
									terminal_name = "hero_purple_close", 
									terminal_state = 0, 
									_action = action,
									_Panel_32 = Panel_32,
								},
								nil,0)
						end
					end)
				end
			end)
		end
	end
end

function HeroFragmentSeatCombining:createHero()
	--获取武将信息
	self.cell = ShipPictureCellTen:createCell(self.ship,false)

	--获取对应放置图层
	local Panel_36549_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_danci")
	Panel_36549_1:setVisible(true)
	Panel_36549_1:addChild(self.cell)
end

function HeroFragmentSeatCombining:close( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local root = self.roots[1]
		local Panel_36549_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_danci")
		Panel_36549_1:removeAllChildren(true)
	end
	
end
function HeroFragmentSeatCombining:onEnterTransitionFinish()
	self:ShowUI()
	if fwin:find("UserInformationHeroStorageClass") ~= nil then
		fwin:find("UserInformationHeroStorageClass"):setVisible(false)
	end
	state_machine.excute("menu_hide_event", 0, "menu_hide_event.")
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_2"), nil, {terminal_name = "hero_fragment_seat_combining_over", terminal_state = 0, touch_scale = true}, nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_32"), nil, {terminal_name = "hero_fragment_seat_combining_over", terminal_state = 0, touch_scale = true}, nil, 0)
	fwin:addTouchEventListener(self.roots[1], nil, {terminal_name = "hero_fragment_seat_combining_over", terminal_state = 0, touch_scale = true}, nil, 0)
end

function HeroFragmentSeatCombining:onExit()
end