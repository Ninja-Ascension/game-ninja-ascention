-- ----------------------------------------------------------------------------------------------------
-- 说明：月卡
-------------------------------------------------------------------------------------------------------
AdventureMonthCard = class("AdventureMonthCardClass", Window)
    
function AdventureMonthCard:ctor()
    self.super:ctor()
    self.roots = {}
	self.goodsInfoList = {}
    -- Initialize adventure month card state machine.
	app.load("client.adventure.cells.prop.adventure_prop_icon_cell")
    local function init_adventure_month_card_terminal()
	
		--请求效验订单刷新列表
		local adventure_lcheck_the_order_to_refresh_the_list_terminal = {
            _name = "adventure_lcheck_the_order_to_refresh_the_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local rechargeCell = params._datas._cell
				local function responseGetServerListCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if rechargeCell~=nil then
							rechargeCell:onUpdateDraw()
						end
						state_machine.excute("activity_window_refresh_button", 0, "activity_window_refresh_button.")--刷新活动
					end
				end
				if app.configJson.UserAccountPlatformName ~= "jar-world" then
					protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id
				else
					protocol_command.vali_top_up_order_number.param_list =  "".._ED.user_info.user_id.."\r\n".._ED.recharge_result.recharge_id.."\r\n".."win32"
				end
				if rechargeCell~=nil then
					NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, rechargeCell, responseGetServerListCallback, false, nil)
				else
					NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, nil, responseGetServerListCallback, false, nil)
				end
				NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        -- 月卡购买
        local adventure_month_card_buy_terminal = {
            _name = "adventure_month_card_buy",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
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
							state_machine.excute("platform_request_for_payment", 0, params)
							return
						end
						state_machine.excute("adventure_lcheck_the_order_to_refresh_the_list", 0, params)
					end
				end
				protocol_command.request_top_up_order_number.param_list = ""..rechargeIndex.."\r\n"..m_sPayMould
				NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, rechargeCell, responseGetServerListCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--领取月卡
		local adventure_get_month_card_button_terminal = {
            _name = "adventure_get_month_card_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	
				--if TipDlg.drawStorageTipo() == false then
					local rechargeCell = params._datas._cell
					local _shopId = params._datas._shopId
					local _jewel = params._datas.jewel
					local ptype = params._datas.ptype
					
					local function responseGetServerListCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							TipDlg.drawTextDailog(_string_piece_info[232].._jewel.._string_piece_info[222])
							response.node:onUpdateDraw()
						end
					end
					protocol_command.draw_month_card_reward.param_list = "".._shopId
					NetworkManager:register(protocol_command.draw_month_card_reward.code, nil, nil, nil, instance, responseGetServerListCallback, false, nil)
				--end
			   return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_month_card_buy_terminal)
        state_machine.add(adventure_get_month_card_button_terminal)
        state_machine.add(adventure_lcheck_the_order_to_refresh_the_list_terminal)
        state_machine.init()
    end
    
    -- call func init adventure month card state machine.
    init_adventure_month_card_terminal()
end

function AdventureMonthCard:init()
	return self
end

function getGoodInfo(mouldId, mouldType)
	local name = ""
	local quality = 1
	local picIndex = 1
	local pic = nil
	
	mouldId = tonumber(mouldId)
	mouldType = tonumber(mouldType)
	
	if mouldType == 6 then -- 默认是道具
		name = dms.string(dms["prop_mould"], mouldId, prop_mould.prop_name)
		quality = dms.int(dms["prop_mould"], mouldId, prop_mould.prop_quality)+1
		picIndex = dms.int(dms["prop_mould"], mouldId, prop_mould.pic_index)			-- 物品图标索引
		pic = string.format("images/ui/props/props_%d.png", zstring.tonumber(picIndex))
		
	elseif mouldType == 1 then
		name = _All_tip_string_info._fundName
		quality = 1
		pic = "images/ui/icon/icon_gold.png"
		
	elseif mouldType == 2 then
		name = _All_tip_string_info._crystalName
		quality = 5
		pic = "images/ui/icon/icon_baoshi.png"
		
	elseif mouldType == 3 then	
		name = _All_tip_string_info._reputation
		quality = 4
		pic = "images/ui/icon/icon_medal_s.png"
		
	elseif mouldType == 4 then
		name = _All_tip_string_info._soulName
		quality = 5
		pic = "images/ui/icon/icon_juntuan.png"
		
	elseif mouldType == 5 then
		name = _All_tip_string_info._hero
		quality = 4
		pic = "images/ui/icon/icon_resource_soul_chip.png"
	elseif mouldType == 7 then
		name 	= dms.string(dms["equipment_mould"], mouldId, equipment_mould.equipment_name)
		quality	= dms.int(dms["equipment_mould"], mouldId, equipment_mould.grow_level)+1
		picIndex = dms.int(dms["equipment_mould"], mouldId, equipment_mould.pic_index)			-- 物品图标索引
		pic = string.format("images/ui/props/props_%d.png", zstring.tonumber(picIndex))
		
	elseif mouldType == 9 then
		name 	= _All_tip_string_info._fuelName
		quality	= 5
		
	elseif mouldType == 13 then
		name 	= dms.string(dms["ship_mould"], mouldId, ship_mould.captain_name)
		quality	= dms.int(dms["ship_mould"], mouldId, ship_mould.ship_type)+1
		picIndex = dms.int(dms["ship_mould"], mouldId, ship_mould.pic_index)			-- 物品图标索引
		pic = string.format("images/ui/props/props_%d.png", zstring.tonumber(picIndex))
	elseif mouldType == 18 then
		name 	= _All_tip_string_info._glories
		quality	= 5
	end

	return {
		name = name,
		quality = quality,
		mould_id = mouldId,
		mould_pic = pic,
	}

end

function AdventureMonthCard:onUpdateDraw()
	local root = self.roots[1]
	local moneys_text = ccui.Helper:seekWidgetByName(root, "Text_rmb")
	local Text_no = ccui.Helper:seekWidgetByName(root, "Text_no")
	local Text_yes = ccui.Helper:seekWidgetByName(root, "Text_yes")
	local Button_buy = ccui.Helper:seekWidgetByName(root, "Button_buy")
	local Button_lingqu = ccui.Helper:seekWidgetByName(root, "Button_lingqu")
	
	

	local _drawMonth = dms.searchs(dms["top_up_goods"], top_up_goods.goods_type, 1)
	local rewardParam = zstring.split(_drawMonth[1][16], "|")
	
	local Panel_prop_1 = ccui.Helper:seekWidgetByName(root, "Panel_prop_1")
	Panel_prop_1:removeAllChildren(true)
	local cell = adventureNewSmallPropIconCell:createCell()
	cell:init(0, {resource_type = 2} , "" .. getResourceValueToStringForAdventure(_drawMonth[1][14]), nil, 0, 0)
	Panel_prop_1:addChild(cell)

	local Text_prop_name_1 = ccui.Helper:seekWidgetByName(root, "Text_prop_name_1")
	Text_prop_name_1:setString(_All_tip_string_info._crystalName)
	
	local Text_prop_ms_1 = ccui.Helper:seekWidgetByName(root, "Text_prop_ms_1")
	Text_prop_ms_1:setString(_All_tip_string_info_description._crystalNameDescription)
	
	local Text_prop_num_1 = ccui.Helper:seekWidgetByName(root, "Text_prop_num_1")
	Text_prop_num_1:setString("X30")
	
	local Panel_prop_2 = ccui.Helper:seekWidgetByName(root, "Panel_prop_2")
	Panel_prop_2:removeAllChildren(true)
	local info =  zstring.split(rewardParam[1] ,",")
	local cell = adventureNewSmallPropIconCell:createCell()
	cell:init(0, {resource_type = zstring.tonumber(info[1])} , "" .. getResourceValueToStringForAdventure(zstring.tonumber(info[3])), nil, 0, 0)
	Panel_prop_2:addChild(cell)
	
	local Text_prop_name_2 = ccui.Helper:seekWidgetByName(root, "Text_prop_name_2")
	Text_prop_name_2:setString(_All_tip_string_info._soulName)
	
	local Text_prop_ms_2 = ccui.Helper:seekWidgetByName(root, "Text_prop_ms_2")
	Text_prop_ms_2:setString(_All_tip_string_info_description._reputationDescription)
	
	local Text_prop_num_2 = ccui.Helper:seekWidgetByName(root, "Text_prop_num_2")
	Text_prop_num_2:setString("X30")
	
	moneys_text:setString(_drawMonth[1][4]) --金额
	
	local monthCardDayOne = _ED.month_card[_drawMonth[1][1]].surplus_month_card_time	--第一种月卡天数
	local monthCardStateOne = _ED.month_card[_drawMonth[1][1]].draw_month_card_state		--第一种月卡领取状态
	if tonumber(monthCardDayOne) > 0 then
		Text_no:setVisible(false)
		
		Button_lingqu:setVisible(true)
		if tonumber(monthCardStateOne) == 0 then
			--可领取
		else
			--领取过了
			Button_lingqu:setVisible(false)
		end
		Button_buy:setVisible(false)
	else
		Text_no:setVisible(true)
		--可购买
		Button_buy:setVisible(true)
		Button_lingqu:setVisible(false)

	end
	
		--前往购买
	-- 25
	fwin:addTouchEventListener(Button_buy, nil, 
		{
			terminal_name = "adventure_month_card_buy", 
			terminal_state = 0, 
			_cell = self, 
			listIndex = _drawMonth[1][1], 
			isMonthCard = _drawMonth[1][13], 
			gradeMonthCard = _drawMonth[1][4],  
			isPressedActionEnabled = true
		},
		nil,0)
		
			--领取
	fwin:addTouchEventListener(Button_lingqu, nil, 
		{
			terminal_name = "adventure_get_month_card_button", 
			terminal_state = 0, 
			_shopId = _drawMonth[1][1], 
			jewel = _drawMonth[1][14], 
			ptype = 1,
			_cell = self,
			isPressedActionEnabled = true
		},
		nil,0)
end

function AdventureMonthCard:onEnterTransitionFinish()
    local csbAdventureMonthCard = csb.createNode("system/vip.csb")
    local root = csbAdventureMonthCard:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMonthCard)

	self:onUpdateDraw()
		
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMonthCardClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 签到
    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sign"),       nil, 
    -- {
        -- terminal_name = "adventure_month_card_buy",        
        -- terminal_state = 0, 
        -- isPressedActionEnabled = true
    -- }, 
    -- nil, 0)
end

function AdventureMonthCard:onExit()
	-- state_machine.remove("adventure_month_card_buy")
end