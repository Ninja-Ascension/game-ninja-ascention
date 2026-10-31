-- ----------------------------------------------------------------------------------------------------
-- 说明：月卡
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityMonthCard = class("ActivityMonthCardClass", Window)
    
function ActivityMonthCard:ctor()
    self.super:ctor()
	app.load("client.shop.recharge.RechargeDialog")
	self.roots = {}
	self.loaded = false
	self.goodsInfoList = {}
    -- Initialize ActivityMonthCard state machine.
    local function init_ActivityMonthCard_terminal()
		-- 充值界面跳转
        local go_to_month_card_button_terminal = {
            _name = "go_to_month_card_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
	            	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
	            	or __lua_project_id == __lua_project_l_naruto 
	            	then
		            if funOpenDrawTip(181) == true then
		                return
		            end
		        end
				local _cell = params._datas.cell
				local Recharge = RechargeDialog:new()
				Recharge:init(2,_cell)
				fwin:open(Recharge , fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--请求效验订单刷新列表
		local lcheck_the_order_to_refresh_the_list_terminal = {
            _name = "lcheck_the_order_to_refresh_the_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseGetServerListCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.onUpdateDraw ~= nil then
							response.node:onUpdateDraw()
						end
						state_machine.excute("activity_first_recharge_button", 0, "activity_first_recharge_button.")--刷新首充					
						state_machine.excute("activity_window_refresh_button", 0, "activity_window_refresh_button.")--刷新活动
					end
				end
				if app.configJson.UserAccountPlatformName ~= "jar-world" then
					if m_play_pay_type~= nil and m_play_pay_type~="" then
						protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id..m_play_pay_type
					else
						protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id
					end
				else
					protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n".."win32"
				end
				NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
				NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 购买月卡
		local lrecharge_list_button_terminal = {
            _name = "lrecharge_list_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
            		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
            		or __lua_project_id == __lua_project_l_naruto 
            		then
		            if funOpenDrawTip(181) == true then
		                return
		            end
            		app.load("client.shop.recharge.RechargeDialog")
					local Recharge = RechargeDialog:new()
					Recharge:init(4)
					fwin:open(Recharge , fwin._windows)
            	else
					local rechargeCell = params._datas._cell
					local rechargeIndex = params._datas.listIndex
					local _isMonthCard = params._datas.isMonthCard
					local _gradeMonthCard = params._datas.gradeMonthCard
					local _extra = params._datas.extra
					local _additional = params._datas.additional
					m_reqcharge_info.rechargeIndex = rechargeIndex
					m_reqcharge_info.isMonthCard = _isMonthCard
					m_reqcharge_info.gradeMonthCard = _gradeMonthCard
					m_reqcharge_info.extra = _extra
					m_reqcharge_info.additional = _additional
					local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
					local value = sufficientStr[zstring.tonumber(rechargeIndex)]
					local function responseGetServerListCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
							and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
							and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC then
								state_machine.excute("platform_request_for_payment", 0,params)
								return
							end
							state_machine.excute("lcheck_the_order_to_refresh_the_list", 0, params)
						end
					end
					protocol_command.request_top_up_order_number.param_list = ""..rechargeIndex.."\r\n"..m_sPayMould
					NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, params, responseGetServerListCallback, false, nil)
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--领取月卡
		local get_month_card_button_terminal = {
            _name = "get_month_card_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if __lua_project_id == __lua_project_gragon_tiger_gate 
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_red_alert 
					then
					local rechargeCell = params._datas._cell
					local _shopId = params._datas._shopId
					local _jewel = params._datas.jewel
					local ptype = params._datas.ptype
					local goodsInfo = rechargeCell.goodsInfoList[tonumber(ptype)]
					
					local function responseGetServerListCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots[1] ~= nil then
								if app.configJson.OperatorName == "gamedreamer" then
									local tipWindows = fwin:find("GameTipDialogClass")
									if tipWindows ~= nil  then 
										fwin:close(tipWindows)
									end
									-- _ED.user_info.user_gold = zstring.tonumber(_ED.user_info.user_gold)+zstring.tonumber(_jewel)
								end	
								local infoText = string.format(_month_card_tip[4], _jewel, goodsInfo)
								TipDlg.drawTextDailog(infoText)
								--TipDlg.drawTextDailog(_string_piece_info[232].._jewel.._string_piece_info[222])
								response.node:onUpdateDraw()
							end
						end
					end
					protocol_command.draw_month_card_reward.param_list = "".._shopId
					NetworkManager:register(protocol_command.draw_month_card_reward.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)            		
            	else
					if TipDlg.drawStorageTipo() == false then
						local rechargeCell = params._datas._cell
						local _shopId = params._datas._shopId
						local _jewel = params._datas.jewel
						local ptype = params._datas.ptype
						local goodsInfo = rechargeCell.goodsInfoList[tonumber(ptype)]
						
						local function responseGetServerListCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								
								local infoText = ""
								if __lua_project_id == __lua_project_yugioh then 
									if zstring.tonumber(_game_platform_version_type) == 2 or zstring.tonumber(_game_platform_version_type) == 3 then
										--特殊渠道修改描述
										infoText = string.format(_month_card_tip[4], _jewel)
									else
										infoText = string.format(_month_card_tip[4], _jewel, goodsInfo)	
									end
								else
									if app.configJson.OperatorName == "gamedreamer" then
										local tipWindows = fwin:find("GameTipDialogClass")
										if tipWindows ~= nil  then 
											fwin:close(tipWindows)
										end
										-- _ED.user_info.user_gold = zstring.tonumber(_ED.user_info.user_gold)+zstring.tonumber(_jewel)
									end
									infoText = string.format(_month_card_tip[4], _jewel, goodsInfo)
								end
								TipDlg.drawTextDailog(infoText)
								--TipDlg.drawTextDailog(_string_piece_info[232].._jewel.._string_piece_info[222])
								response.node:onUpdateDraw()
							end
						end
						protocol_command.draw_month_card_reward.param_list = "".._shopId
						NetworkManager:register(protocol_command.draw_month_card_reward.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
					end
				end
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- 刷新
        local activity_month_card_button_terminal = {
            _name = "activity_month_card_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- if params ~= nil then
				if instance ~= nil and instance.onUpdateDraw ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
					-- instance.loaded = true
					if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
						then
						local m_isVisible = false
						for i,v in pairs(_ED.month_card) do
							if tonumber(v.surplus_month_card_time) == 0 then
								m_isVisible = true
							end
						end
						if m_isVisible == false then
							state_machine.excute("activity_window_remove_activity_page", 0, {instance, "MonthCard"})
							--刷新主页上的福利按钮
							state_machine.excute("home_update_top_activity_info_state", 0, "")
						else
							instance:onUpdateDraw()
						end
					end
				end
				-- end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(go_to_month_card_button_terminal)
        state_machine.add(get_month_card_button_terminal)
        state_machine.add(activity_month_card_button_terminal)
        state_machine.add(lrecharge_list_button_terminal)
        state_machine.add(lcheck_the_order_to_refresh_the_list_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityMonthCard state machine.
    init_ActivityMonthCard_terminal()
    
    self._load_over = false
	self:onLoad()
end
function ActivityMonthCard:onUpdateDrawData( ... )
	self.loaded = true
	self:onUpdateDraw()
end
function ActivityMonthCard:onUpdateDraw()
	if self.loaded == false then
		return
	end
	local root = self.roots[1]
	local MonthCardOne = ccui.Helper:seekWidgetByName(root, "Button_307")
	local TextCountOne = ccui.Helper:seekWidgetByName(root, "Text_7")
	local MonthCardTwo = ccui.Helper:seekWidgetByName(root, "Button_308")
	local TextCountTwo = ccui.Helper:seekWidgetByName(root, "Text_7_0")
	local getMonthCardTwo = ccui.Helper:seekWidgetByName(root, "Button_310")
	local getTextTwo = ccui.Helper:seekWidgetByName(root, "Text_05")
	local getImageTwo = ccui.Helper:seekWidgetByName(root, "Image_34_0")
	
	local getMonthCardOne = ccui.Helper:seekWidgetByName(root, "Button_309")
	local getTextOne = ccui.Helper:seekWidgetByName(root, "Text_04")
	
	local getImageOne = ccui.Helper:seekWidgetByName(root, "Image_34")

	local Panel_card_open_1 = ccui.Helper:seekWidgetByName(root, "Panel_card_open_1")
	local Panel_card_open_2 = ccui.Helper:seekWidgetByName(root, "Panel_card_open_2")
	
	if MonthCardOne == nil then
		return
	end
	local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
	local monthCount = table.getn(_drawMonth)
	if monthCount ~= 0 and _drawMonth ~= nil and _drawMonth[1] ~= nil and _drawMonth[1][1] ~= nil then
		local monthCardDayOne = _ED.month_card[_drawMonth[1][1]].surplus_month_card_time	--第一种月卡天数
		local monthCardStateOne = _ED.month_card[_drawMonth[1][1]].draw_month_card_state		--第一种月卡领取状态
		if tonumber(monthCardDayOne) > 0 then	
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				or __lua_project_id == __lua_project_red_alert 
				then
				local Text_day_1 = ccui.Helper:seekWidgetByName(root,"Text_day_1")
				local str_day = string.format(_string_piece_info[421],monthCardDayOne)
				if Text_day_1 ~= nil then
					Text_day_1:setString(str_day)
				end
			end		
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				if tonumber(monthCardStateOne) == 0 then
					getMonthCardOne:setVisible(true)
					getImageOne:setVisible(false)
					
					local goodsInfo = getMonthCardString(_drawMonth[1])
					self.goodsInfoList[1] = goodsInfo
					local txt = ""
					if __lua_project_id == __lua_project_yugioh then 
						if zstring.tonumber(_game_platform_version_type) == 2 or zstring.tonumber(_game_platform_version_type) == 3 then 
							txt = string.format(_month_card_tip[2], _drawMonth[1][14], monthCardDayOne)	
						else
							txt = string.format(_month_card_tip[2], _drawMonth[1][14], goodsInfo, monthCardDayOne)
						end
					else
						txt = string.format(_month_card_tip[2], _drawMonth[1][14], goodsInfo, monthCardDayOne)
					end
					
					getTextOne:setString(txt)	
				else
					getImageOne:setVisible(true)
					getMonthCardOne:setVisible(false)
					getTextOne:setString(_string_piece_info[233]..monthCardDayOne.._string_piece_info[231])				
				end
				TextCountOne:setVisible(false)
			end
			-- MonthCardOne:setVisible(false)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				if ccui.Helper:seekWidgetByName(root,"Image_card_not_open_1") ~= nil then
					ccui.Helper:seekWidgetByName(root,"Image_card_not_open_1"):setVisible(false)
				end
				MonthCardOne:setBright(false)
       			MonthCardOne:setTouchEnabled(false)
       			local Text_recharge_card_n_2 = ccui.Helper:seekWidgetByName(root,"Text_recharge_card_n_2")
       			Text_recharge_card_n_2:removeAllChildren(true)

       			if Panel_card_open_1 ~= nil then
       				--已经激活
       				Panel_card_open_1:removeBackGroundImage()
					Panel_card_open_1:setBackGroundImage("images/ui/text/sm_hd/yijihuo.png")
					local Image_card_goon_1 = ccui.Helper:seekWidgetByName(root, "Image_card_goon_1")
					if Image_card_goon_1 ~= nil then
						Image_card_goon_1:setVisible(false)
					end
       			end
			end
		else
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
				or __lua_project_id == __lua_project_red_alert 
				then
				local Text_day_1 = ccui.Helper:seekWidgetByName(root,"Text_day_1")
				if Text_day_1 ~= nil then
					Text_day_1:setString("")
				end
				getMonthCardOne:setVisible(false)
			end
			MonthCardOne:setVisible(true)
			if TextCountOne ~= nil then
				TextCountOne:setVisible(true)
			end
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				if ccui.Helper:seekWidgetByName(root,"Image_card_not_open_1") ~= nil then
					ccui.Helper:seekWidgetByName(root,"Image_card_not_open_1"):setVisible(true)
				end
				ccui.Helper:seekWidgetByName(root,"Button_307"):setBright(true)
       			ccui.Helper:seekWidgetByName(root,"Button_307"):setTouchEnabled(true)

       			local Text_recharge_card_n_2 = ccui.Helper:seekWidgetByName(root,"Text_recharge_card_n_2")
       			Text_recharge_card_n_2:removeAllChildren(true)
       			local strs = ""
       			-- if verifySupportLanguage(_lua_release_language_en) == true then
       				strs = string.format(_new_interface_text[82],zstring.tonumber(_drawMonth[1][5]),zstring.tonumber(_ED.month_card[_drawMonth[1][1]].recharge_all_good),zstring.tonumber(_drawMonth[1][5]))
       				-- strs = string.format(_new_interface_text[82],zstring.tonumber(_drawMonth[1][4])*10-zstring.tonumber(_ED.month_card[_drawMonth[1][1]].recharge_all_money)*10)
       			-- else
       			-- 	strs = string.format(_new_interface_text[82],zstring.tonumber(_drawMonth[1][4])-zstring.tonumber(_ED.month_card[_drawMonth[1][1]].recharge_all_money))
       			-- end
       			local m_str_data = zstring.split(strs ,"|")
       			m_str_data[2] = "%|1|"..m_str_data[2].."%"
       			local m_str = ""
       			for i=1, #m_str_data do
       				if i==1 then
       					m_str = m_str_data[i]
       				else
       					m_str = m_str..m_str_data[i]
       				end
       			end
       			local _richText2 = ccui.RichText:create()
		        _richText2:ignoreContentAdaptWithSize(false)

		        local richTextWidth = Text_recharge_card_n_2:getContentSize().width
		        if richTextWidth == 0 then
			        richTextWidth = Text_recharge_card_n_2:getFontSize() * 6
			    end

		        _richText2:setContentSize(cc.size(richTextWidth, 0))
		        _richText2:setAnchorPoint(cc.p(0, 0))
		        local color_Type_1 = nil
		        local color_Type_2 = nil
		        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		        	color_Type_1 = cc.c3b(71, 71, 71)
		        	color_Type_2 = cc.c3b(71, 71, 71)
		        else
		        	color_Type_1 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
		        	color_Type_2 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
		        end

		        local char_str = m_str
		        local rt, count, text = draw.richTextCollectionMethod(_richText2, 
		        char_str, 
		        color_Type_1,
		        color_Type_2,
		        0, 
		        0, 
		        Text_recharge_card_n_2:getFontName(), 
		        Text_recharge_card_n_2:getFontSize(),
		        chat_rich_text_color)
		        if _ED.is_can_use_formatTextExt == false then
		            _richText2:setPositionX((_richText2:getPositionX() - _richText2:getContentSize().width / 2) + (Text_recharge_card_n_2:getContentSize().width-_richText2:getContentSize().width)/2)
		        else
		            _richText2:formatTextExt()
		        end
		        local rsize = _richText2:getContentSize()
		        _richText2:setPositionY(Text_recharge_card_n_2:getContentSize().height/2)
		        _richText2:setPositionX((Text_recharge_card_n_2:getContentSize().width-rsize.width)/2)
		        Text_recharge_card_n_2:addChild(_richText2)

		        if Panel_card_open_1 ~= nil then
       				--未激活
       				Panel_card_open_1:removeBackGroundImage()
					Panel_card_open_1:setBackGroundImage("images/ui/text/sm_hd/weijihuo.png")
					local Image_card_goon_1 = ccui.Helper:seekWidgetByName(root, "Image_card_goon_1")
					if Image_card_goon_1 ~= nil then
						Image_card_goon_1:setVisible(true)
					end
       			end
			end
		end
		
		if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert 
			then
			if monthCount == 1 then
				local Panel_yueka_25 = ccui.Helper:seekWidgetByName(root,"Panel_yueka_25")
				local Panel_yueka_50 = ccui.Helper:seekWidgetByName(root,"Panel_yueka_50")
				local Panel_555 = ccui.Helper:seekWidgetByName(root,"Panel_555")
				local Image_1 = ccui.Helper:seekWidgetByName(root,"Image_1")
				local Image_5 = ccui.Helper:seekWidgetByName(root,"Image_5")
				local x,y = Panel_555:getPosition()
				Panel_yueka_25:setPosition(cc.p(x,y))
				Panel_yueka_50:setVisible(false)
				Image_1:setVisible(false)
				return
			end
		end
		if _ED.month_card[_drawMonth[2][1]] == nil then
			return
		end
		local monthCardDayTwo = _ED.month_card[_drawMonth[2][1]].surplus_month_card_time	--第一种月卡天数
		local monthCardStateTwo = _ED.month_card[_drawMonth[2][1]].draw_month_card_state		--第一种月卡领取状态	
		if tonumber(monthCardDayTwo) > 0 then	
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
				local Text_day_2 = ccui.Helper:seekWidgetByName(root,"Text_day_2")
				local str_day = string.format(_string_piece_info[421],monthCardDayTwo)
				if Text_day_2 ~= nil then
					Text_day_2:setString(str_day)
				end
			end				
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
			else
				if tonumber(monthCardStateTwo) == 0 then
					getMonthCardTwo:setVisible(true)
					getImageTwo:setVisible(false)
					
					local goodsInfo = getMonthCardString(_drawMonth[2])
					self.goodsInfoList[2] = goodsInfo
					local txt = ""
					if __lua_project_id == __lua_project_yugioh then 
						if zstring.tonumber(_game_platform_version_type) == 2 or zstring.tonumber(_game_platform_version_type) == 3 then
							--特殊渠道描述修改 
							txt = string.format(_month_card_tip[2], _drawMonth[2][14], monthCardDayOne)				
						else
							txt = string.format(_month_card_tip[2], _drawMonth[2][14], goodsInfo, monthCardDayOne)				
						end
					else
						txt = string.format(_month_card_tip[2], _drawMonth[2][14], goodsInfo, monthCardDayOne)				
					end
					
					getTextTwo:setString(txt)				
				else
					getImageTwo:setVisible(true)
					getMonthCardTwo:setVisible(false)
					getTextTwo:setString(_string_piece_info[233]..monthCardDayTwo.._string_piece_info[231])				
				end
				TextCountTwo:setVisible(false)
			end
			-- MonthCardTwo:setVisible(false)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				if ccui.Helper:seekWidgetByName(root,"Image_card_not_open_2") ~= nil then
					ccui.Helper:seekWidgetByName(root,"Image_card_not_open_2"):setVisible(false)
				end
				MonthCardTwo:setBright(false)
       			MonthCardTwo:setTouchEnabled(false)
       			local Text_recharge_card_n_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_card_n_1")
       			Text_recharge_card_n_1:removeAllChildren(true)

       			if Panel_card_open_2 ~= nil then
       				--已经激活
       				Panel_card_open_2:removeBackGroundImage()
					Panel_card_open_2:setBackGroundImage("images/ui/text/sm_hd/yijihuo.png")
					local Image_card_goon_2 = ccui.Helper:seekWidgetByName(root, "Image_card_goon_2")
					if Image_card_goon_2 ~= nil then
						Image_card_goon_2:setVisible(false)
					end
       			end
			end
		else
			if __lua_project_id == __lua_project_gragon_tiger_gate 
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
			or __lua_project_id == __lua_project_red_alert then
				local Text_day_2 = ccui.Helper:seekWidgetByName(root,"Text_day_2")
				if Text_day_2 ~= nil then
					Text_day_2:setString("")
				end
				getMonthCardTwo:setVisible(false)
			end				
			MonthCardTwo:setVisible(true)
			if TextCountTwo ~= nil then
				TextCountTwo:setVisible(true)
			end
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				if ccui.Helper:seekWidgetByName(root,"Image_card_not_open_2") ~= nil then
					ccui.Helper:seekWidgetByName(root,"Image_card_not_open_2"):setVisible(true)
				end
				ccui.Helper:seekWidgetByName(root,"Button_308"):setBright(true)
       			ccui.Helper:seekWidgetByName(root,"Button_308"):setTouchEnabled(true)

       			local Text_recharge_card_n_1 = ccui.Helper:seekWidgetByName(root,"Text_recharge_card_n_1")
       			Text_recharge_card_n_1:removeAllChildren(true)
       			local strs = ""
       			-- if verifySupportLanguage(_lua_release_language_en) == true then
       				strs = string.format(_new_interface_text[82],zstring.tonumber(_drawMonth[2][5]),zstring.tonumber(_ED.month_card[_drawMonth[2][1]].recharge_all_good),zstring.tonumber(_drawMonth[2][5]))
       				-- strs = string.format(_new_interface_text[82],zstring.tonumber(_drawMonth[2][4])*10-zstring.tonumber(_ED.month_card[_drawMonth[2][1]].recharge_all_money)*10)
       			-- else
       			-- 	strs = string.format(_new_interface_text[82],zstring.tonumber(_drawMonth[2][4])-zstring.tonumber(_ED.month_card[_drawMonth[2][1]].recharge_all_money))
       			-- end
       			local m_str_data = zstring.split(strs ,"|")
       			m_str_data[2] = "%|1|"..m_str_data[2].."%"
       			local m_str = ""
       			for i=1, #m_str_data do
       				if i==1 then
       					m_str = m_str_data[i]
       				else
       					m_str = m_str..m_str_data[i]
       				end
       			end
       			local _richText2 = ccui.RichText:create()
		        _richText2:ignoreContentAdaptWithSize(false)

		        local richTextWidth = Text_recharge_card_n_1:getContentSize().width
		        if richTextWidth == 0 then
			        richTextWidth = Text_recharge_card_n_1:getFontSize() * 6
			    end

		        _richText2:setContentSize(cc.size(richTextWidth, 0))
		        _richText2:setAnchorPoint(cc.p(0, 0))
		        if __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		        	color_Type_1 = cc.c3b(71, 71, 71)
		        	color_Type_2 = cc.c3b(71, 71, 71)
		        else
		        	color_Type_1 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
		        	color_Type_2 = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
		        end
		        local char_str = m_str
		        local rt, count, text = draw.richTextCollectionMethod(_richText2, 
		        char_str, 
		        color_Type_1,
		        color_Type_2,
		        0, 
		        0, 
		        Text_recharge_card_n_1:getFontName(), 
		        Text_recharge_card_n_1:getFontSize(),
		        chat_rich_text_color)
		        if _ED.is_can_use_formatTextExt == false then
		            _richText2:setPositionX((_richText2:getPositionX() - _richText2:getContentSize().width / 2) + (Text_recharge_card_n_1:getContentSize().width-_richText2:getContentSize().width)/2)
		        else
		            _richText2:formatTextExt()
		        end
		        local rsize = _richText2:getContentSize()
		        _richText2:setPositionY(Text_recharge_card_n_1:getContentSize().height/2)
		        _richText2:setPositionX((Text_recharge_card_n_1:getContentSize().width-rsize.width)/2)
		        Text_recharge_card_n_1:addChild(_richText2)

		        if Panel_card_open_2 ~= nil then
       				--未激活
       				Panel_card_open_2:removeBackGroundImage()
					Panel_card_open_2:setBackGroundImage("images/ui/text/sm_hd/weijihuo.png")
					local Image_card_goon_2 = ccui.Helper:seekWidgetByName(root, "Image_card_goon_2")
					if Image_card_goon_2 ~= nil then
						Image_card_goon_2:setVisible(true)
					end
       			end
			end
		end
	end
end

function ActivityMonthCard:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onInit, self, false)
 	self:onInit()
end

function ActivityMonthCard:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
end

function ActivityMonthCard:onEnterTransitionFinish()

end

function ActivityMonthCard.onImageLoaded(texture)
	
end

function ActivityMonthCard:onArmatureDataLoad(percent)
	
end

function ActivityMonthCard:onArmatureDataLoadEx(percent)
	-- if percent >= 1 then
	-- 	if self._load_over == false then
	-- 		self._load_over = true
	-- 		self:onInit()
	-- 	end
	-- end
end

function ActivityMonthCard:onLoad()
	-- local effect_paths = {
	-- 	"images/ui/effice/effect_22/effect_22.ExportJson",
	-- 	"images/ui/effice/effect_26/effect_26.ExportJson"
	-- }
	-- for i, v in pairs(effect_paths) do
	-- 	local fileName = v
	-- 	ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, self.onArmatureDataLoad, self.onArmatureDataLoadEx, self)
	-- end

	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onInit, self, false)
end

function ActivityMonthCard:onInit()
	local csbMonthCard = csb.createNode("activity/wonderful/on_cards.csb")
    local root = csbMonthCard:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbMonthCard)
	
	-- self:onUpdateDraw()
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self, false)
	
	
	local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
	local monthCount = 0
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		then
		monthCount = table.getn(_drawMonth)
	end
	--领取
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_309"), nil, 
		{
			terminal_name = "get_month_card_button", 
			terminal_state = 0, 
			_shopId = _drawMonth[1][1], 
			jewel = _drawMonth[1][14], 
			ptype = 1,
			_cell = self,
			isPressedActionEnabled = true
		},
		nil,0)

	--前往购买
	-- 25

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_307"), nil, 
	{
		terminal_name = "lrecharge_list_button", 
		terminal_state = 0, 
		_cell = self, 
		listIndex = _drawMonth[1][1], 
		isMonthCard = _drawMonth[1][13], 
		gradeMonthCard = _drawMonth[1][4],  
		isPressedActionEnabled = true
	},
	nil,0)	

	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		then
		if monthCount == 1 then
			return
		end
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_310"), nil, 
		{
			terminal_name = "get_month_card_button", 
			terminal_state = 0, 
			_shopId = _drawMonth[2][1], 
			jewel = _drawMonth[2][14], 
			ptype = 2,
			_cell = self,
			isPressedActionEnabled = true
		},
		nil,0)

		
	-- 50	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_308"), nil, 
		{
			terminal_name = "lrecharge_list_button", 
			terminal_state = 0, 
			_cell = self, 
			listIndex = _drawMonth[2][1], 
			isMonthCard = _drawMonth[2][13], 
			gradeMonthCard = _drawMonth[2][4], 
			isPressedActionEnabled = true
		},
		nil,0)
	
end

function ActivityMonthCard:onExit()
	
end

function ActivityMonthCard:init()

end


function ActivityMonthCard:createCell()
	local cell = ActivityMonthCard:new()
	cell:registerOnNodeEvent(cell)
	-- cell:registerOnNoteUpdate(cell, 0.5)
	return cell
end