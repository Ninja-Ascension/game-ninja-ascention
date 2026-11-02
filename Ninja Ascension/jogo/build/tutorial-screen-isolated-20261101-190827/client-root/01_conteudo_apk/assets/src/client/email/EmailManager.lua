-- ----------------------------------------------------------------------------------------------------
-- 说明：邮件
-- 创建时间	2015-04-23
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EmailManager = class("EmailManagerClass", Window)
    
function EmailManager:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions={}
	self.isResource = false
	app.load("client.player.UserInformationShop") 					--顶部用户信息
	app.load("client.email.EmailManagerOne")
	app.load("client.email.EmailManagerTwo")
	app.load("client.email.EmailManagerThree")
	app.load("client.email.EmailManagerFour")
	self.max_number = 0
	self.number_text = nil
    -- Initialize EmailManager page state machine.
    local function init_email_manager_terminal()
		local email_manager_back_terminal = {
            _name = "email_manager_back",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if instance.isResource == true then
            		fwin:close(fwin:find("UserInformationShopClass"))
            		instance:cleanMailInfo()
            		fwin:close(instance)
        		else
					fwin:cleanView(fwin._view)
					fwin:close(instance)
					state_machine.excute("menu_back_home_page", 0, "")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--全部
		local email_manager_click_all_terminal = {
            _name = "email_manager_click_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDrawOne()
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					then
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24_6"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_25_8"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_26_10"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_27_12"):setVisible(false)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--系统
		local email_manager_click_system_terminal = {
            _name = "email_manager_click_system",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDrawTwo()
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					then
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24_6"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_25_8"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_26_10"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_27_12"):setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--战斗
		local email_manager_click_battle_terminal = {
            _name = "email_manager_click_battle",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDrawThree()
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					then
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24_6"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_25_8"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_26_10"):setVisible(true)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_27_12"):setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--社交
		local email_manager_click_email_terminal = {
            _name = "email_manager_click_email",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateDrawFour()
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
					then
				else
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_24_6"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_25_8"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_26_10"):setVisible(false)
					ccui.Helper:seekWidgetByName(instance.roots[1], "Image_27_12"):setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--一键领取
		local email_manager_onekey_get_all_terminal = {
            _name = "email_manager_onekey_get_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local str1 = ""
            	local curr_number1 = 0
            	local curr_number2 = 0
            	local allIdStr = ""
            	local allDataTypeStr = ""
            	for i , v in pairs(_ED._reward_centre) do
            		if tonumber(v.draw_state) == 0 then
            			if tonumber(v.data_type) == 1 then
							curr_number1 = curr_number1 + 1
						else
							curr_number2 = curr_number2 + 1
						end
						str1 = str1.."\r\n"..v._reward_centre_id..","..v._reward_type
						allIdStr = allIdStr..v._reward_centre_id..","
						allDataTypeStr = allDataTypeStr..v.data_type..","
					end
            	end
            	if curr_number1 + curr_number2 == 0 then
            		TipDlg.drawTextDailog(_new_interface_text[67])
            		return
            	else
					allIdStr = string.sub(allIdStr,1,-2)
            		allDataTypeStr = string.sub(allDataTypeStr,1,-2)
            	end
				local function responsePropCompoundCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- emailLocalWrite(allIdStr , allDataTypeStr)
						for i, v in pairs(_ED._reward_centre) do
							if v then
								v.read_type = 1
							end
							if tonumber(v._reward_item_count) > 0 then
								v.draw_state = 1
							end
						end
						state_machine.excute("email_manager_one_updata",0,"email_manager_one_updata.")
						checkRewardObtainDraw()
						state_machine.excute("email_manager_email_number_show",0,"email_manager_email_number_show.")
						state_machine.excute("notification_center_update", 0, "push_notification_center_mall_all")
						-- Fury (30-sep): el sobre del cobro trae un 12801 por carta y el cliente las quitaba de
						-- la lista; el servidor ahora las CONSERVA cobradas (migracion 2043). Se vuelve a pedir el
						-- buzon y se repinta, como al abrir la ventana, sin tener que cerrarla.
						NetworkManager:register(protocol_command.reward_center_init.code, nil, nil, nil, nil, function(r)
							if r.RESPONSE_SUCCESS and r.PROTOCOL_STATUS >= 0 then
								state_machine.excute("email_manager_one_updata", 0, "email_manager_one_updata.")
								state_machine.excute("email_manager_email_number_show", 0, "email_manager_email_number_show.")
							end
						end, false, nil)
					end
				end
				if curr_number1 + curr_number2 > 0 then
            		str1 = ""..(curr_number1 + curr_number2).."-1"..str1
            	else
            		str1 = "0-1"
            	end
            	_ED.show_reward_list_group_ex = {}
				protocol_command.draw_reward_center.param_list = str1
				NetworkManager:register(protocol_command.draw_reward_center.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --未读邮件数量
		local email_manager_email_number_show_terminal = {
            _name = "email_manager_email_number_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local curr_number = 0
				for i , v in pairs(_ED._reward_centre) do
					if tonumber(v.read_type) == 0 then 
						curr_number = curr_number + 1
					end
				end
				curr_number = math.min(curr_number , instance.max_number)
				instance.number_text:setString(curr_number.."/"..instance.max_number)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local email_manager_open_GMMessage_terminal = {
            _name = "email_manager_open_GMMessage",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local function responseGMCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.l_digital.player.SmPlayerSystemGMMessage")
                        state_machine.excute("sm_player_system_GM_message_page_open",0,"sm_player_system_GM_message_page_open.")
                    end
                end
                NetworkManager:register(protocol_command.gm_message_init.code, nil, nil, nil, instance, responseGMCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        

		state_machine.add(email_manager_back_terminal)
		state_machine.add(email_manager_click_all_terminal)
		state_machine.add(email_manager_click_system_terminal)
		state_machine.add(email_manager_click_battle_terminal)
		state_machine.add(email_manager_click_email_terminal)
		state_machine.add(email_manager_onekey_get_all_terminal)
		state_machine.add(email_manager_email_number_show_terminal)
		state_machine.add(email_manager_open_GMMessage_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_email_manager_terminal()
end

function EmailManager:onUpdateDrawOne()
	local root = self.roots[1]
	local pageOne = fwin:find("EmailManagerOneClass")
	local pageTwo = fwin:find("EmailManagerTwoClass")
	local pageThree = fwin:find("EmailManagerThreeClass")
	local pageFour = fwin:find("EmailManagerFourClass")
	if pageTwo ~= nil then
		pageTwo:setVisible(false)
	end
	
	if pageThree ~= nil then
		pageThree:setVisible(false)
	end
	
	if pageFour ~= nil then
		pageFour:setVisible(false)
	end
	
	if pageOne == nil then
		fwin:open(EmailManagerOne:new(),fwin._view)
	else
		pageOne:setVisible(true)
	end
	
	
end

function EmailManager:onUpdateDrawTwo()
	local root = self.roots[1]
	local pageOne = fwin:find("EmailManagerOneClass")
	local pageTwo = fwin:find("EmailManagerTwoClass")
	local pageThree = fwin:find("EmailManagerThreeClass")
	local pageFour = fwin:find("EmailManagerFourClass")
	if pageOne ~= nil then
		pageOne:setVisible(false)
	end
	
	if pageThree ~= nil then
		pageThree:setVisible(false)
	end
	
	if pageFour ~= nil then
		pageFour:setVisible(false)
	end
	
	if pageTwo == nil then
		fwin:open(EmailManagerTwo:new(),fwin._view)
	else
		pageTwo:setVisible(true)
	end
	
end

function EmailManager:onUpdateDrawThree()
	local root = self.roots[1]
	local pageOne = fwin:find("EmailManagerOneClass")
	local pageTwo = fwin:find("EmailManagerTwoClass")
	local pageThree = fwin:find("EmailManagerThreeClass")
	local pageFour = fwin:find("EmailManagerFourClass")
	
	if pageOne ~= nil then
		pageOne:setVisible(false)
	end
	
	if pageTwo ~= nil then
		pageTwo:setVisible(false)
	end
	
	if pageFour ~= nil then
		pageFour:setVisible(false)
	end
	
	if pageThree == nil then
		fwin:open(EmailManagerThree:new(),fwin._view)
	else
		pageThree:setVisible(true)
	end
	
end

function EmailManager:onUpdateDrawFour()
	local root = self.roots[1]
	local pageOne = fwin:find("EmailManagerOneClass")
	local pageTwo = fwin:find("EmailManagerTwoClass")
	local pageThree = fwin:find("EmailManagerThreeClass")
	local pageFour = fwin:find("EmailManagerFourClass")
	if pageOne ~= nil then
		pageOne:setVisible(false)
	end
	
	if pageTwo ~= nil then
		pageTwo:setVisible(false)
	end
	
	if pageThree ~= nil then
		pageThree:setVisible(false)
	end
	
	if pageFour == nil then
		fwin:open(EmailManagerFour:new(),fwin._view)
	else
		pageFour:setVisible(true)
	end
	
end

function EmailManager:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
	else
		local userinfo = UserInformationShop:new()
		fwin:open(userinfo,fwin._view)
	end
	local csbEmailManager = csb.createNode("email/email.csb")
	self:addChild(csbEmailManager)
	
	
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		-- or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		-- or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local action = csb.createTimeline("email/email.csb") 
		table.insert(self.actions, action )
		csbEmailManager:runAction(action)
		action:play("window_open", false)
	end
	
	local root = csbEmailManager:getChildByName("root")
	table.insert(self.roots, root)
	
	local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_05_10"), nil, {terminal_name = "email_manager_back", terminal_state = 0,isPressedActionEnabled = true}, nil, 2)
	local Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_01_2"), nil, {terminal_name = "email_manager_click_all", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_02_4"), nil, {terminal_name = "email_manager_click_system", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_03_6"), nil, {terminal_name = "email_manager_click_battle", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_4 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_04_8"), nil, {terminal_name = "email_manager_click_email", terminal_state = 0,isPressedActionEnabled = true}, nil, 0)
	local Button_10 = ccui.Helper:seekWidgetByName(root, "Button_10")
	local Text_4 = ccui.Helper:seekWidgetByName(root, "Text_4")
	if Button_10 ~= nil then
		fwin:addTouchEventListener(Button_10, nil, 
		{	
			terminal_name = "email_manager_onekey_get_all", 
			terminal_state = 0,
			isPressedActionEnabled = true
		}, nil, 0)
	end
	if Text_4 ~= nil then
		self.number_text = Text_4
		self.max_number = tonumber(zstring.split(dms.string(dms["mail_config"] , 1 , mail_config.param),",")[1])
		state_machine.excute("email_manager_email_number_show",0,"email_manager_email_number_show.")
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert
		then
	else
		_ED.no_read_mail_cont = -1
	end
	state_machine.excute("email_manager_click_all", 0, "email_manager_click_all.")

	local Button_contact_us_1 = ccui.Helper:seekWidgetByName(root, "Button_contact_us_1")
    if Button_contact_us_1 ~= nil then
	    if config_operation.gmMessageAndReply == true then
	    	Button_contact_us_1:setVisible(true)
	    else
	    	Button_contact_us_1:setVisible(false)
	    end
	    fwin:addTouchEventListener(Button_contact_us_1,nil, 
	    {
	        terminal_name = "email_manager_open_GMMessage",     
	        terminal_state = 0,
	        isPressedActionEnabled = true
	    },
	    nil, 0)
    end
end

function EmailManager:init( is_resource )
	self.isResource = is_resource
	return self
end

function EmailManager:cleanMailInfo( ... )
	local pageOne = fwin:find("EmailManagerOneClass")
	local pageTwo = fwin:find("EmailManagerTwoClass")
	local pageThree = fwin:find("EmailManagerThreeClass")
	local pageFour = fwin:find("EmailManagerFourClass")
	if pageOne ~= nil then
		fwin:close(pageOne)
	end
	
	if pageTwo ~= nil then
		fwin:close(pageTwo)
	end
	
	if pageThree ~= nil then
		fwin:close(pageThree)
	end
	
	if pageFour ~= nil then
		fwin:close(pageFour)
	end
end

function EmailManager:onExit()
	state_machine.remove("email_manager_back")
	state_machine.remove("email_manager_click_all")
	state_machine.remove("email_manager_click_system")
	state_machine.remove("email_manager_click_battle")
	state_machine.remove("email_manager_click_email")
	state_machine.remove("email_manager_onekey_get_all")
	state_machine.remove("email_manager_email_number_show")
end