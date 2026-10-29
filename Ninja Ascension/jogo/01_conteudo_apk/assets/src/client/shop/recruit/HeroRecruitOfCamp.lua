--------------------------------------------------------------------------------------------------------------
--  说明：阵营招募主界面
--------------------------------------------------------------------------------------------------------------
HeroRecruitOfCamp = class("HeroRecruitOfCampClass", Window)
app.load("client.shop.recruit.HeroRecruitOfCamphelp")
app.load("client.shop.recruit.HeroRecruitOfCampAmation")
local hero_recruit_of_camp_open_terminal = {
    _name = "hero_recruit_of_camp_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.lock("hero_recruit_of_camp_open")
        local camp_view = HeroRecruitOfCamp:new()
        camp_view:init()
        fwin:open(camp_view,fwin._view)
		--打开动画界面	
		state_machine.excute("hero_recruit_of_camp_hero_amtion_open",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local hero_recruit_of_camp_close_terminal = {
    _name = "hero_recruit_of_camp_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("HeroRecruitOfCampClass"))
		
		state_machine.excute("hero_recruit_of_camp_hero_amtion_close",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_recruit_of_camp_open_terminal)
state_machine.add(hero_recruit_of_camp_close_terminal)
state_machine.init()
function HeroRecruitOfCamp:ctor()
	self.super:ctor()
	self.roots = {}
	
	self.updatetexttimes = nil
    self.update_type = false
	self.textData = {}
	self.playFontType = nil
	self.Animationisplaying = false
	 -- Initialize union duplicate seat machine.
    local function init_hero_recruit_of_camp_terminal()
				--招募一次
        local hero_recruit_of_camp_once_terminal = {
            _name = "hero_recruit_of_camp_once",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.Animationisplaying == true then
					return
				end		
				state_machine.lock("hero_recruit_of_camp_once")
				state_machine.lock("hero_recruit_of_camp_ten")
                local mcell =  params._datas.cell
                local config = zstring.split(dms.string(dms["pirates_config"], 294, pirates_config.param), ",")
                local config2 = zstring.split(dms.string(dms["pirates_config"], 293, pirates_config.param), ",")
                if _ED.user_bounty_info.has_free < tonumber(config[1]) or tonumber(config[2]) > _ED.user_bounty_info.today_bounty_count  then
                    if tonumber(config2[1]) > tonumber(_ED.user_info.user_gold) and _ED.user_bounty_info.has_free >= tonumber(config[1]) then
                        state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                        {
                            terminal_name = "shortcut_open_recharge_window", 
                            terminal_state = 0, 
                            _msg = _string_piece_info[316], 
                            _datas= 
                            {

                            }
                        })
						state_machine.unlock("hero_recruit_of_camp_ten")
						state_machine.unlock("hero_recruit_of_camp_once")	
                        return
                    end
                    if verifySupportLanguage(_lua_release_language_en) == true then
                        if __lua_project_id == __lua_project_warship_girl_b then
                            if _ED.user_bounty_info.has_free >= tonumber(config[1]) then
                                local config = zstring.split(dms.string(dms["pirates_config"], 293, pirates_config.param), ",")
                                app.load("client.utils.ConfirmTip")
                                local tip = ConfirmTip:new()
                                tip:init(instance, instance.confirmRefreshOnce, string.format(_string_piece_info[381], config[1]), nil, nil)
                                fwin:open(tip, fwin._windows)
                            else
                                mcell:sendOnce()
                            end
                        else
                            mcell:sendOnce()
                        end
                    else
                        mcell:sendOnce()
                    end
                else
					state_machine.unlock("hero_recruit_of_camp_ten")
					state_machine.unlock("hero_recruit_of_camp_once")
                    TipDlg.drawTextDailog(tipStringInfo_camp_recruitment_str[1])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --招募十次
        local hero_recruit_of_camp_ten_terminal = {
            _name = "hero_recruit_of_camp_ten",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.Animationisplaying == true then
					return
				end		
				state_machine.lock("hero_recruit_of_camp_ten")
				state_machine.lock("hero_recruit_of_camp_once")
                local mcell =  params._datas.cell
                local config = zstring.split(dms.string(dms["pirates_config"], 294, pirates_config.param), ",")
                local config2 = zstring.split(dms.string(dms["pirates_config"], 293, pirates_config.param), ",")
                if  tonumber(config[2]) >= _ED.user_bounty_info.today_bounty_count+10 then
                    if tonumber(config2[2]) > tonumber(_ED.user_info.user_gold) then
                        state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                        {
                            terminal_name = "shortcut_open_recharge_window", 
                            terminal_state = 0, 
                            _msg = _string_piece_info[316], 
                            _datas= 
                            {

                            }
                        })
						state_machine.unlock("hero_recruit_of_camp_ten")
						state_machine.unlock("hero_recruit_of_camp_once")	
                        return
                    end
					if verifySupportLanguage(_lua_release_language_en) == true then
                        if __lua_project_id == __lua_project_warship_girl_b then
                            local config = zstring.split(dms.string(dms["pirates_config"], 293, pirates_config.param), ",")
                            app.load("client.utils.ConfirmTip")
                            local tip = ConfirmTip:new()
                            tip:init(instance, instance.confirmRefreshTen, string.format(_string_piece_info[381], config[2]), nil, nil)
                            fwin:open(tip, fwin._windows)
                        else
                            mcell:sendTen()
                        end
                    else
                        mcell:sendTen()
                    end
                else
					state_machine.unlock("hero_recruit_of_camp_ten")
					state_machine.unlock("hero_recruit_of_camp_once")	
                    TipDlg.drawTextDailog(tipStringInfo_camp_recruitment_str[2])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --星运名将
        local hero_recruit_of_camp_famous_terminal = {
            _name = "hero_recruit_of_camp_famous",
            _init = function (terminal)
                app.load("client.shop.recruit.HeroRecruitOfCampSelectReward") 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local mcell =  params._datas.cell
     
                state_machine.excute("hero_recruit_of_camp_select_reward_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--shuax
        local hero_recruit_of_camp_refresh_terminal = {
            _name = "hero_recruit_of_camp_refresh",
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

        --阵营招募时间到了刷新充值    
        local hero_recruit_shop_updatecamp_main_terminal = {
            _name = "hero_recruit_shop_updatecamp_main",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("hero_recruit_shop_updatecamp_main")
                local function responseBountyInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            response.node:updateDraw(true)
							--还要通知动画的界面去刷新
							state_machine.excute("hero_recruit_of_camp_amation_update_all",0,"")
                        end
                    else
                        state_machine.unlock("hero_recruit_shop_updatecamp_main")
                    end
                end
                    NetworkManager:register(protocol_command.partner_bounty_init.code, nil, nil, nil, instance, responseBountyInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--播放动画招募后的光效上升动画
		local hero_recruit_of_camp_play_animation_terminal = {
            _name = "hero_recruit_of_camp_play_animation",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance ~= nil then
					state_machine.lock("hero_recruit_of_camp_play_animation")
					instance:playAnimation(params)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local hero_recruit_of_set_isplaying_terminal = {
            _name = "hero_recruit_of_set_isplaying",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance.Animationisplaying = true
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(hero_recruit_of_camp_once_terminal)
        state_machine.add(hero_recruit_of_camp_ten_terminal)
        state_machine.add(hero_recruit_of_camp_famous_terminal)
        state_machine.add(hero_recruit_of_camp_refresh_terminal)
		state_machine.add(hero_recruit_of_camp_play_animation_terminal)
        state_machine.add(hero_recruit_shop_updatecamp_main_terminal)
		state_machine.add(hero_recruit_of_set_isplaying_terminal)
        state_machine.init()
    end
    -- call func init union duplicate seat machine.
    init_hero_recruit_of_camp_terminal()
end

function HeroRecruitOfCamp:sendOnceDraw( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
    local panel = ccui.Helper:seekWidgetByName(root, "Text_22")
    local nameO = tipStringInfo_camp_recruitment_str[5]
    local nemefen = tipStringInfo_camp_recruitment_str[6].._ED.partner_bounty_get_fen
    local str = ""
    local jifencolor = 1
    if _ED.partner_bounty_get_num <= 0 then
        return
    end
	
    for i = 1,_ED.partner_bounty_get_num do
        local name = dms.string(dms["prop_mould"], _ED.partner_bounty_get_return_reward[i].reward_id, prop_mould.prop_name)
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            name = setThePropsIcon(_ED.partner_bounty_get_return_reward[i].reward_id)[2]
        end
        local number = _ED.partner_bounty_get_return_reward[i].reward_count
        local colort = dms.string(dms["prop_mould"], _ED.partner_bounty_get_return_reward[i].reward_id,prop_mould.prop_quality)
        -- propname:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
        jifencolor = colort
        local nameT = name.."x"..number
        table.insert(self.textData, {nameOne = nameO,nameTwo = nameT ,colortype = colort})
		--通知动画层播放动画
		self.playFontType = "one"
        state_machine.excute("hero_recruit_of_camp_amation_toplay",0,{"left",1,_ED.partner_bounty_get_return_reward[i].reward_id}) 
    end
    app.load("client.cells.utils.property_change_tip_info_cell") 
  
    table.insert(self.textData, {nameOne = nameO,nameTwo = nemefen ,colortype = jifencolor})
	state_machine.excute("hero_recruit_of_camp_refresh",0,"")
end
function HeroRecruitOfCamp:playFontAmation()
	local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
    tipInfo:init(9,str, self.textData)   
    fwin:open(tipInfo, fwin._ui)
	self.textData = {}
end
function HeroRecruitOfCamp:playAnimation()
	self.Animationisplaying = true
	local root = self.roots[1]
	local types = self.playFontType
	local Panel_role_zm = ccui.Helper:seekWidgetByName(root, "Panel_role_zm")
	Panel_role_zm:setVisible(true)
	local ArmatureNode_2 = Panel_role_zm:getChildByName("ArmatureNode_10")
	draw.initArmature(ArmatureNode_2, nil, -1, 0, 2)
		ArmatureNode_2._invoke = function(armatureBack)
			Panel_role_zm:setVisible(false)
			
			if types == "one" then
				self:playFontAmation()
			elseif types == "ten" then
				state_machine.excute("hero_recruit_of_camp_reward_open",0,"")
			end
			self.Animationisplaying = false
			state_machine.unlock("hero_recruit_of_camp_play_animation")
			self.playFontType = nil
			ArmatureNode_2._invoke = nil			
		end
	csb.animationChangeToAction(ArmatureNode_2, 0, 0, false)
end

function HeroRecruitOfCamp:confirmRefreshOnce( surenumber )
    if surenumber == 1 then
        state_machine.unlock("hero_recruit_of_camp_ten")
        state_machine.unlock("hero_recruit_of_camp_once")
        return
    end
    self:sendOnce()
end

function HeroRecruitOfCamp:confirmRefreshTen( surenumber )
    if surenumber == 1 then
        state_machine.unlock("hero_recruit_of_camp_ten")
        state_machine.unlock("hero_recruit_of_camp_once")
        return
    end
    self:sendTen()
end

function HeroRecruitOfCamp:sendOnce( ... )
    -- body
    local function responseOnceCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                state_machine.unlock("hero_recruit_of_camp_ten")
				state_machine.unlock("hero_recruit_of_camp_once")	
				response.node:sendOnceDraw()
			else
				state_machine.unlock("hero_recruit_of_camp_ten")
				state_machine.unlock("hero_recruit_of_camp_once")	
            end
        end
    end
    protocol_command.partner_bounty_get.param_list = "".."1"
    NetworkManager:register(protocol_command.partner_bounty_get.code, nil, nil, nil, self, responseOnceCallback, false, nil)
end
function HeroRecruitOfCamp:sendTenDraw( ... )

end

function HeroRecruitOfCamp:sendTen( ... )
     local function responseTenCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
				state_machine.unlock("hero_recruit_of_camp_ten")
				state_machine.unlock("hero_recruit_of_camp_once")	
                -- self:sendTenDraw()
                app.load("client.shop.recruit.HeroRecruitOfCampTenReward")
                state_machine.excute("hero_recruit_of_camp_refresh",0,"")
				
				local lastid = #(_ED.partner_bounty_get_return_reward)
				local last_prop_id =_ED.partner_bounty_get_return_reward[lastid].reward_id
				response.node.playFontType = "ten"
				state_machine.excute("hero_recruit_of_camp_amation_toplay",0,{"left",1,last_prop_id}) 		
				-- state_machine.excute("hero_recruit_of_camp_play_animation",0,"ten")
			else
				state_machine.unlock("hero_recruit_of_camp_ten")
				state_machine.unlock("hero_recruit_of_camp_once")	
            end
        end
    end
    protocol_command.partner_bounty_get.param_list = "".."2"
    NetworkManager:register(protocol_command.partner_bounty_get.code, nil, nil, nil, self, responseTenCallback, false, nil)
    -- body
end






function HeroRecruitOfCamp:updateDraw(update_type)
    local root = self.roots[1]
    local LoadingBar_1 = ccui.Helper:seekWidgetByName(root,"LoadingBar_1")
    local nowluckynumber = tonumber(_ED.user_bounty_info.integral)
    local neednumber = tonumber(dms.string(dms["pirates_config"],295,pirates_config.param))
    local perscent=nowluckynumber*100/neednumber
	if perscent >= 100 then
		ccui.Helper:seekWidgetByName(root, "Button_326_0"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Button_326"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Panel_201"):setVisible(true)
	else
		ccui.Helper:seekWidgetByName(root, "Button_326_0"):setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Button_326"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Panel_201"):setVisible(false)
	end
    LoadingBar_1:setPercent(perscent)
    ccui.Helper:seekWidgetByName(root, "Text_loading"):setString(""..nowluckynumber.."/"..neednumber)
    local Text_20_0 = ccui.Helper:seekWidgetByName(root,"Text_20_0")
    self.updatetexttimes = Text_20_0

	 local zhaoOnce = ccui.Helper:seekWidgetByName(root, "Text_23_money")
    local config = zstring.split(dms.string(dms["pirates_config"], 293, pirates_config.param), ",")
	local config2 = zstring.split(dms.string(dms["pirates_config"], 294, pirates_config.param), ",")
    zhaoOnce:setVisible(true)

    if _ED.user_bounty_info.has_free < tonumber(config2[1]) then
        ccui.Helper:seekWidgetByName(root, "Text_23"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_12"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root, "Text_23"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Panel_12"):setVisible(true)
        zhaoOnce:setString(config[1])
    end
    local zhaoTen = ccui.Helper:seekWidgetByName(root, "Text_23_money_0")
    zhaoTen:setString(config[2])
	ccui.Helper:seekWidgetByName(root, "Panel_role_zm"):setVisible(false)

    ccui.Helper:seekWidgetByName(root, "Panel_12_0"):setVisible(true)

    local mounld = _ED.user_bounty_typeid 
    local datas =  dms.element(dms["partner_bounty"], mounld)
    local shipIds = zstring.split(dms.atos(datas, partner_bounty.ship_mould),",")

    local shipname1 = nil
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], tonumber(shipIds[1]), ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        -- local ship_evo = zstring.split(fundShipWidthId(""..shipID).evolution_status, "|")
        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], tonumber(shipIds[1]), ship_mould.captain_name)]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        shipname1 = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
    else
        shipname1 = dms.string(dms["ship_mould"], tonumber(shipIds[1]), ship_mould.captain_name)
    end
    local colortype1 = dms.string(dms["ship_mould"],tonumber(shipIds[1]),ship_mould.ship_type)
    local shipnamecolor1 = cc.c3b(color_Type[colortype1+1][1],color_Type[colortype1+1][2],color_Type[colortype1+1][3])
    
    local shipname2 = nil
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], tonumber(shipIds[2]), ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        -- local ship_evo = zstring.split(fundShipWidthId(""..shipID).evolution_status, "|")
        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], tonumber(shipIds[2]), ship_mould.captain_name)]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
        shipname2 = word_info[3]
    else
        shipname2 = dms.string(dms["ship_mould"], tonumber(shipIds[2]), ship_mould.captain_name)
    end
    local colortype2 = dms.string(dms["ship_mould"],tonumber(shipIds[2]),ship_mould.ship_type)
    local shipnamecolor2 = cc.c3b(color_Type[colortype2+1][1],color_Type[colortype2+1][2],color_Type[colortype2+1][3])

	
	
	ccui.Helper:seekWidgetByName(root, "Text_128_0"):setString(tonumber(config2[2])-_ED.user_bounty_info.today_bounty_count)
    local Text = ccui.Helper:seekWidgetByName(root, "Text_22")
    Text:setString("")
    Text:removeAllChildren(true)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(true)
    _richText:setContentSize(cc.size(500, 10))
    local colortype = 2
    local color1 = cc.c3b(255,188,71)
    local color2 = cc.c3b(color_Type[5+1][1],color_Type[5+1][2],color_Type[5+1][3])


    local re1 = ccui.RichElementText:create(1, color1, 255, tipStringInfo_camp_recruitment_str[7], Text:getFontName(), Text:getFontSize())
    _richText:pushBackElement(re1)
                    
    local re2 = ccui.RichElementText:create(1, color2, 255, tipStringInfo_camp_recruitment_str[8], Text:getFontName(), Text:getFontSize())
    _richText:pushBackElement(re2)

     local re3 = ccui.RichElementText:create(1, color1, 255, tipStringInfo_camp_recruitment_str[9], Text:getFontName(), Text:getFontSize())
    _richText:pushBackElement(re3)
    local re4 = ccui.RichElementText:create(1, color2, 255, tipStringInfo_camp_recruitment_str[10], Text:getFontName(), Text:getFontSize())
    _richText:pushBackElement(re4)
     local re5 = ccui.RichElementText:create(1, color1, 255, tipStringInfo_camp_recruitment_str[11], Text:getFontName(), Text:getFontSize())
    _richText:pushBackElement(re5)
     local re6 = ccui.RichElementText:create(1, shipnamecolor1, 255, shipname1, Text:getFontName(), Text:getFontSize())
    _richText:pushBackElement(re6)
    local re7 = ccui.RichElementText:create(1, color1, 255, tipStringInfo_camp_recruitment_str[12], Text:getFontName(), Text:getFontSize())
    _richText:pushBackElement(re7)
    local re8 = ccui.RichElementText:create(1, shipnamecolor2, 255, shipname2, Text:getFontName(), Text:getFontSize())
    _richText:pushBackElement(re8)

    if verifySupportLanguage(_lua_release_language_en) == true then
        if __lua_project_id == __lua_project_warship_girl_b then
            local re9 = ccui.RichElementText:create(1, shipnamecolor2, 255, tipStringInfo_camp_recruitment_str[13], Text:getFontName(), Text:getFontSize())
            _richText:pushBackElement(re9)
            Text:addChild(_richText)
        else
            Text:addChild(_richText)
        end
    else
        Text:addChild(_richText)
    end
    
    _richText:setAnchorPoint(CCPoint(0.5, 0.5))
    _richText:setPosition(cc.p(0, 0))   
	
	
	
    local Button_zhenying_1 = ccui.Helper:seekWidgetByName(root, "Button_zhenying_1")
    local Button_zhenying_2 = ccui.Helper:seekWidgetByName(root, "Button_zhenying_2")
    local Button_zhenying_3 = ccui.Helper:seekWidgetByName(root, "Button_zhenying_3")
    local Button_zhenying_4 = ccui.Helper:seekWidgetByName(root, "Button_zhenying_4")
    local typeid = _ED.user_bounty_typeid
	Button_zhenying_1:setVisible(false)
	Button_zhenying_2:setVisible(false)
	Button_zhenying_3:setVisible(false)
	Button_zhenying_4:setVisible(false)
    if typeid == 1 then
        Button_zhenying_1:setVisible(true)
    elseif typeid == 2 then
        Button_zhenying_2:setVisible(true)
    elseif typeid == 3 then
        Button_zhenying_3:setVisible(true)
    elseif typeid == 4 then
        Button_zhenying_4:setVisible(true)
    end
    if update_type == true then
        self.update_type = true
    end
end
function HeroRecruitOfCamp:formatTimeString(_time)    --系统时间转换
    local timeString = ""
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end
function HeroRecruitOfCamp:onUpdate()
    local camptime = tonumber(_ED.user_bounty_update_times)/1000 - os.time() - (tonumber(_ED.system_time)- tonumber(_ED.native_time))
    if self.lastupdatetime == camptime or self.updatetexttimes == nil then--时间变化没有1秒，并且页面未加载完 也不进入刷新
        return
    end
    self.lastupdatetime = camptime

    if camptime <= 0 then
        --如果时间小于等于0刷新
        state_machine.excute("hero_recruit_shop_updatecamp_main",0,"")
        return
    end
    local strtime = HeroRecruitOfCamp:formatTimeString(camptime)
    self.updatetexttimes:setString(strtime)

    if self.update_type == true then
        state_machine.unlock("hero_recruit_shop_updatecamp_main")
        self.update_type = false
    end
end
function HeroRecruitOfCamp:onInit()
    
    local csbHeroRecruitOfCamp = csb.createNode("shop/shop_zhenying.csb") 
    local root = csbHeroRecruitOfCamp:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbHeroRecruitOfCamp)

    local Button_zy_shi = ccui.Helper:seekWidgetByName(root, "Button_zy_shi")
    fwin:addTouchEventListener(Button_zy_shi, nil, 
    {
        terminal_name = "hero_recruit_of_camp_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    local Button_zhenying_1 = ccui.Helper:seekWidgetByName(root, "Button_zhenying_1")
    local Button_zhenying_2 = ccui.Helper:seekWidgetByName(root, "Button_zhenying_2")
    local Button_zhenying_3 = ccui.Helper:seekWidgetByName(root, "Button_zhenying_3")
    local Button_zhenying_4 = ccui.Helper:seekWidgetByName(root, "Button_zhenying_4")
    fwin:addTouchEventListener(Button_zhenying_1, nil, 
    {
        terminal_name = "hero_recruit_of_camphelp_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(Button_zhenying_2, nil, 
    {
        terminal_name = "hero_recruit_of_camphelp_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(Button_zhenying_3, nil, 
    {
        terminal_name = "hero_recruit_of_camphelp_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(Button_zhenying_4, nil, 
    {
        terminal_name = "hero_recruit_of_camphelp_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	
 
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_51"), nil, 
    {
        terminal_name = "hero_recruit_of_camp_once", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_51_0"), nil, 
    {
        terminal_name = "hero_recruit_of_camp_ten", 
        terminal_state = 0,
        cell =self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_326"), nil, 
    {
        terminal_name = "hero_recruit_of_camp_famous", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)
	   
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_326_0"), nil, 
    {
        terminal_name = "hero_recruit_of_camp_famous", 
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	self:updateDraw()
    state_machine.unlock("hero_recruit_of_camp_open")

end

function HeroRecruitOfCamp:onEnterTransitionFinish()

end

function HeroRecruitOfCamp:init()
	self:onInit()
	return self
end

function HeroRecruitOfCamp:onExit()
    state_machine.remove("hero_recruit_of_camp_once")
    state_machine.remove("hero_recruit_of_camp_ten")
    state_machine.remove("hero_recruit_of_camp_famous")
    state_machine.remove("hero_recruit_of_camp_refresh")
    state_machine.remove("hero_recruit_shop_updatecamp_main")
	state_machine.remove("hero_recruit_of_camp_play_animation")
	state_machine.remove("hero_recruit_of_set_isplaying")
end