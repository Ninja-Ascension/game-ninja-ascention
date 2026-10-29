
----------------------------------------------------------------------------------------------------
-- 说明：用于提示购买界面
-------------------------------------------------------------------------------------------------------
PropBuyPrompt = class("PropBuyPromptClass", Window)

function PropBuyPrompt:ctor()
    self.super:ctor()
    -- 定义封装类中的变量
	self.roots = {}				-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.interfaceType = 0
	self._enum_type = {
		_PAGE_INDEX_DAILY_ACTIVITY_COPY = 1, 		-- 从日常副本进入
		_ENDURANCE = 2 ,		-- 体力丹
		_DISPATCH = 3 ,		-- 出击令
		_AMMO = 4 ,		-- 弹药不足
	}
	
	app.load("client.cells.prop.model_prop_icon_cell")
	app.load("client.utils.objectMessage.ObjectMessage")
	
	local function init_prop_buy_prompt_terminal()
		local prop_buy_prompt_close_terminal = {
            _name = "prop_buy_prompt_close",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local prop_buy_prompt_buy_button_terminal = {
            _name = "prop_buy_prompt_buy_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:buy()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local prop_buy_prompt_use_button_terminal = {
            _name = "prop_buy_prompt_use_button",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:use()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(prop_buy_prompt_close_terminal)
		state_machine.add(prop_buy_prompt_buy_button_terminal)
		state_machine.add(prop_buy_prompt_use_button_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_prop_buy_prompt_terminal()
end

function PropBuyPrompt:getIconCell()
	local cell = ModelPropIconCell:createCell()
	return cell
end

function PropBuyPrompt:getIconCellTouchEvent(iconCell)
	self:onIconCellTouchEvent(iconCell)
end

function PropBuyPrompt:onIconCellTouchEvent(iconCell)
	app.load("client.cells.prop.prop_information")
	local win = propInformation:new()
	local prop = win:constructionPropTemplate(self.mould_id)
	win:init(prop,1)
	fwin:open(win, fwin._ui)
end


-----------------------------------------------------------------------------
--这是一段神奇的代码,我也不清楚细节
--具体详情 请联系 : ShopPropBuyNumberTip 这个类-------------------------------

-- function PropBuyPrompt:drawPrice(_prop)
	-- if tonumber(_prop.price_increase) == -1 then
		-- return tonumber(_prop.original_cost) * tonumber(self.buy_number)
	-- end
	-- local ret = _prop.price_increase
	-- local ret2 = zstring.split(ret,"!")
	-- local priceConfig = {}
	-- for n, v in pairs(ret2) do
		-- local temp = zstring.split(v,",")
		-- local range = zstring.split(temp[1], "-")
		-- local price = {
			-- _range = range,
			-- _price = temp[2]
		-- }
		-- priceConfig[n] = price
	-- end

	-- local buyTimes = tonumber(_prop.buy_times + 1)
	
	-- local price = 0
	-- for i=1, self.buy_number do 
		-- for k, m in pairs(priceConfig) do 
			-- if tonumber(buyTimes) >= tonumber(m._range[1]) and tonumber(buyTimes) <= tonumber(m._range[2]) then
				-- price = price + m._price
				-- buyTimes = buyTimes+1
				-- break
			-- end
		-- end
	-- end
	-- return price
-- end	

-- function PropBuyPrompt:drawDiscount(_prop)
	-- if tonumber(_prop.price_increase) == -1 then
		-- return tonumber(_prop.sale_price) * tonumber(self.buy_number)
	-- end
	-- local ret = _prop.price_increase
	-- local ret2 = zstring.split(ret,"!")
	-- local priceConfig = {}
	-- for n, v in pairs(ret2) do
		-- local temp = zstring.split(v,",")
		-- local range = zstring.split(temp[1], "-")
		-- local price = {
			-- _range = range,
			-- _price = temp[2]
		-- }
		-- priceConfig[n] = price
	-- end

	-- local buyTimes = tonumber(_prop.buy_times + 1)
	
	-- local price = 0
	-- for i=1, self.buy_number do 
		-- for k, m in pairs(priceConfig) do 
			-- if tonumber(buyTimes) >= tonumber(m._range[1]) and tonumber(buyTimes) <= tonumber(m._range[2]) then
				-- price = price + m._price
				-- buyTimes = buyTimes+1
				-- break
			-- end
		-- end
	-- end
	-- return price
	
-- end	


--神奇代码结束
--------------------------------------------------------------------------------



function PropBuyPrompt:getBuyNumber()
	--self.mould_id
	--_ED.return_prop
	
	for k, v in pairs(_ED.return_prop) do
		if tonumber(v.mould_id) == tonumber(self.mould_id) then
		
		
			return
		end
	end
	
	-- 无限制的用 -1
	return -1
end

function PropBuyPrompt:getBuyPrice()
	--self.mould_id
	
	
end



function PropBuyPrompt:onUpdateDraw()

	-- 资源道具ID：觉醒丹,宝物精炼石,刷新令,天命石,极品精炼石,高级精炼石,中级精炼石,初级精炼石,培养丹,突破石,免战令（小）,免战令（大）,小型开发书,大型开发书,体力丹,耐力丹,出击令

	--提示说明文本
	-- if self.interfaceType == self._enum_type._PAGE_INDEX_DAILY_ACTIVITY_COPY then
		-- self.tipText:setString(_string_piece_info[241])
	-- else
		
		local index = getPiratesConfigPropIndex(self.mould_id)
	
		self.tipText:setString(tipStringInfo_prop_buy[index][1])
	--end	
	
	-- elseif self.interfaceType == self._enum_type._ENDURANCE then
		-- self.tipText:setString(tipStringInfo_prop_buy[5])
	-- elseif self.interfaceType == self._enum_type._DISPATCH then
		-- self.tipText:setString(tipStringInfo_prop_buy[6])
		
	-- elseif self.interfaceType == self._enum_type._AMMO then
		-- self.tipText:setString(tipStringInfo_prop_buy[8])
	-- else
		-- self.tipText:setString(tipStringInfo_prop_buy[1])
	-- end
	
	--使用说明
	if self.interfaceType == self._enum_type._DISPATCH then
		for i, v in pairs(_ED.return_prop) do
			if tonumber(self.mould_id) == tonumber(v.mould_id) then
				local propQuality = tonumber(v.prop_quality) + 1
				self.explainText:setString(v.mould_name)
				self.explainText:setColor(cc.c3b(color_Type[propQuality][1], color_Type[propQuality][2], color_Type[propQuality][3]))
			end
		end
	else
		local propremark = dms.string(dms["prop_mould"],self.mould_id,prop_mould.remarks)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			propremark = drawPropsDescription(self.mould_id)
		end
		self.explainText:setString(propremark)
	end
	--元宝数
	-- local price = 0
	-- local buyNumber = self:getBuyNumber()
	-- if buyNumber == -1 then
		-- price = self:getShopProp(self.mould_id).original_cost
		-- price = self:drawPrice(self:getShopProp(self.mould_id))
	-- esle
		-- price = self:getBuyPrice()
	-- end
	-- self.gemText:setString(price)
	
	self:updatePrice()
end

function PropBuyPrompt:updatePrice()
	price = self:drawPrice(self:getShopProp(self.mould_id))
	self.gemText:setString(price)
end

function PropBuyPrompt:getUI(name)
	return ccui.Helper:seekWidgetByName(self.roots[1], name)
end

function PropBuyPrompt:drawPrice(_prop)
	if _prop == nil then
		--print("未获得道具信息...")
	end
	if tonumber(_prop.price_increase) == -1 then
		return tonumber(_prop.original_cost)
	end
	local ret = _prop.price_increase
	local ret2 = zstring.split(ret,"!")
	local priceConfig = {}
	for n, v in pairs(ret2) do
		local temp = zstring.split(v,",")
		local range = zstring.split(temp[1], "-")
		local price = {
			_range = range,
			_price = temp[2]
		}
		priceConfig[n] = price
	end
	
	local buyTimes = tonumber(_prop.buy_times + 1)
	local price = 0
	for i, v in pairs(priceConfig) do
		if buyTimes >= tonumber(v._range[1]) and buyTimes <= tonumber(v._range[2]) then
			return tonumber(v._price)
		end
	end
	return price
end

function PropBuyPrompt:getShopProp(mould_id)
	for i, v in pairs(_ED.return_prop) do
		if tonumber(v.mould_id) == mould_id then
			return v
		end
	end
	
		
	for i, v in pairs(_ED.return_equipment) do
		if tonumber(v.mould_id) == mould_id then
			return v
		end
	end
	
	return nil 
end

function PropBuyPrompt:buy_state_machine()
	-- 填入 各种来源的 需要收到的 状态机
	-- 这就意味着,每新增一个界面或修改一个界面这里都会变更
end


-- 计算 当前物品的 可购买次数
function PropBuyPrompt:showSurplusBuyTimes()
-- 只要当前物品id是在商店的就默认它有购买上限的
-- 对于 没有购买上限的就隐藏可购买次数
-- 否则,显示可购买次数
-- 无需特定指明哪种物品
	self.surplusBuyPanel:setVisible(false)
	for i, v in pairs(_ED.return_prop) do
		if tonumber(self.mould_id) == tonumber(v.mould_id) then
			
			local times = tonumber(v.VIP_buy_times) - tonumber(v.buy_times)
			if tonumber(v.VIP_buy_times) == -1 then
				self.surplusBuyText:setString(_string_piece_info[75])
			else
				if times >= 0 then
					self.surplusBuyText:setString(times)
				else
					self.surplusBuyText:setString("0")
				end
				self.surplusBuyPanel:setVisible(true)
			end
		end
	end

end

function PropBuyPrompt:afterBuyResponse()
	TipDlg.drawTextDailog(string.format(tipStringInfo_prop_buy_tip[2]))
	-- 刷新拥有数
	self.surplusText:setString(getPropAllCountByMouldId(self.mould_id))
	--发出消息买了东西了.
	state_machine.excute("prop_buy_prompt_buy_info", 0, {mould_id = zstring.tonumber(self.mould_id),count = 1 })
	state_machine.excute("prop_buy_prompt_use_info_to_plunder_use_prop", 0, {mould_id = zstring.tonumber(self.mould_id), count = 1})
	
	-- 刷新当前物品已购买数
	for i, v in pairs(_ED.return_prop) do
		if tonumber(self.mould_id) == tonumber(v.mould_id) then
			v.buy_times = v.buy_times + 1
			break
		end
	end
	
	-- 更新可购买次数
	self:showSurplusBuyTimes()
	-- 更新价格
	self:updatePrice()
end
function PropBuyPrompt:buy(backN)
	if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and backN ~= nil and backN == 1 then
        return
    end
	-- 买买买买
	local function responseBuyPropCallback(response)
		if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) and backN ~= nil then
            state_machine.excute("use_diamond_confirm_tip_close",0,"")
        end
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node ~= nil then
				response.node:afterBuyResponse()
			end
			-- TipDlg.drawTextDailog(string.format(tipStringInfo_prop_buy_tip[2]))
			-- -- 刷新拥有数
			-- self.surplusText:setString(getPropAllCountByMouldId(self.mould_id))
			-- --发出消息买了东西了.
			-- state_machine.excute("prop_buy_prompt_buy_info", 0, {mould_id = zstring.tonumber(self.mould_id),count = 1 })
			-- state_machine.excute("prop_buy_prompt_use_info_to_plunder_use_prop", 0, {mould_id = zstring.tonumber(self.mould_id), count = 1})
			
			-- -- 刷新当前物品已购买数
			-- for i, v in pairs(_ED.return_prop) do
			-- 	if tonumber(self.mould_id) == tonumber(v.mould_id) then
			-- 		v.buy_times = v.buy_times + 1
			-- 		break
			-- 	end
			-- end
			
			-- -- 更新可购买次数
			-- self:showSurplusBuyTimes()
			-- -- 更新价格
			-- self:updatePrice()
		end
	end

	local _shopId = self:getShopProp(self.mould_id).shop_prop_instance
	local _shopType = 0
	local _number = 1
	local _price = self.gemText:getString()
	
	if zstring.tonumber(_price) <= zstring.tonumber(_ED.user_info.user_gold) then
		_ED._buy_item_consumption = _price
		protocol_command.prop_purchase.param_list = _shopId .. 
			"\r\n" .. 
			tonumber(_number).. 
			"\r\n" .. 
			tonumber(_shopType)


		if (__lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh) 
            and ___is_open_diamond_confirm == true and (backN == nil or backN ~= 0) then
            app.load("client.utils.UseDiamondConfirmTip")
            local window_terminal = state_machine.find("use_diamond_confirm_tip_open")
            if window_terminal.unopen ~= true then
                local str1 = string.format(tipStringInfo_use_diamond[1],zstring.tonumber(_price))
                local str2 = tipStringInfo_use_diamond[4]..self.propName
                state_machine.excute("use_diamond_confirm_tip_open", 0, {_datas={self,self.buy,str1.."|"..str2 }})
                return
            else
	               NetworkManager:register(protocol_command.prop_purchase.code, 
					nil, 
					nil, 
					nil, 
					self, 
					responseBuyPropCallback, 
					true, 
					nil
				)
            end
        else

			NetworkManager:register(protocol_command.prop_purchase.code, 
				nil, 
				nil, 
				nil, 
				self, 
				responseBuyPropCallback, 
				true, 
				nil
			)
		end
	else
		TipDlg.drawTextDailog(_string_piece_info[74])
	end
	--if self.interfaceType == self._enum_type._DISPATCH then
		-- for i, v in pairs(_ED.return_prop) do
			-- if tonumber(self.mould_id) == tonumber(v.mould_id) then
				-- --征讨令的可购买次数
				-- v.buy_times = v.buy_times + 1
				-- local times = tonumber(v.VIP_buy_times) - tonumber(v.buy_times)
				-- if tonumber(v.VIP_buy_times) == -1 then
					-- self.surplusBuyText:setString(_string_piece_info[75])
				-- else
					-- if times >= 0 then
						-- self.surplusBuyText:setString(times)
					-- else
						-- self.surplusBuyText:setString("0")
					-- end
				-- end
			-- end
		-- end
	--end
end

function PropBuyPrompt:showConfirmTip(n)
	if n == 0 then
		-- yes
		self:sendUse()
	else
		-- no
	end
end

function PropBuyPrompt:checkupUse(item_mouldid)

	
	if smallAvoidTemplateId == tonumber(item_mouldid) or bigAvoidTemplateId == tonumber(item_mouldid) then
		local timer = getAvoidFightTime()
		if timer > 0 then
			local tip = ConfirmTip:new()
			tip:init(self, self.showConfirmTip, string.format(tipStringInfo_plunder[8], self:formatTime(timer/1000)))
			fwin:open(tip,fwin._ui)
			return
		end
	end

	self:showConfirmTip(0)
end

-- 返回格式化时间,参数是秒
function PropBuyPrompt:formatTime (second)
	local timeTabel = {}
	local day = 0
	local hour = math.floor(tonumber(second)/3600)
	local minute = math.floor((tonumber(second)%3600)/60)
	local second = math.ceil(tonumber(second)%60)
	if second == 60 then
		second = 0
		minute = minute + 1
	end
	if minute == 60 then
		minute = 0
		hour = hour + 1
	end
	
	if hour < 10 then
		hour = "0"..hour
	end
	
	if minute < 10 then
		minute = "0"..minute
	end
	
	if second < 10 then
		second = "0"..second
	end
	local str = hour..":"..minute..":"..second
	return str
end


function PropBuyPrompt:use()
	-- 用用用用
	if zstring.tonumber(self.surplusText:getString()) > 0 then
	
		local config = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
		local bigAvoidTemplateId =  tonumber(config[12])
		local smallAvoidTemplateId =  tonumber(config[11])
		-- local ammunitionMID =  tonumber(config[16])
		-- if ammunitionMID == self.mould_id then
			-- local timer = getAvoidFightTime()
			-- if timer > 0 then
				-- local tip = ConfirmTip:new()
				-- tip:init(self, self.showConfirmTip, string.format(tipStringInfo_plunder[8], self:formatTime(timer/1000)))
				-- fwin:open(tip,fwin._ui)
				-- return
			-- end
		if smallAvoidTemplateId == tonumber(self.mould_id) or bigAvoidTemplateId == tonumber(self.mould_id) then
			local timer = getAvoidFightTime()
			if timer > 0 then
				local tip = ConfirmTip:new()
				tip:init(self, self.showConfirmTip, string.format(tipStringInfo_plunder[8], self:formatTime(timer/1000)))
				fwin:open(tip,fwin._dialog)
				return
			end
		end
		
		self:sendUse()
	else
		TipDlg.drawTextDailog(string.format(tipStringInfo_prop_buy_tip[1], self.propName))
	end
end

function PropBuyPrompt:sendUse()

		local function responseUsePropCallback(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
				-- 根据不同使用物品的提示不同
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					if response.node == nil then
						return
					end
				end
				if response.node.propName == nil then
					return
				end
				local str = string.format(tipStringInfo_prop_buy_tip[3], response.node.propName)
				
				local propremark = dms.string(dms["prop_mould"],response.node.mould_id,prop_mould.remarks)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					propremark = drawPropsDescription(response.node.mould_id)
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					TipDlg.drawTextDailog(str) --应策划需求，使用东西之后，不拼接说明在后面
				else
					TipDlg.drawTextDailog(str..propremark)
				end
				response.node.surplusText:setString(getPropAllCountByMouldId(response.node.mould_id))
				--发出消息使用了东西了.
				state_machine.excute("prop_buy_prompt_use_info_to_plunder", 0, {mould_id = zstring.tonumber(response.node.mould_id), count = 1})
				
				--发出消息使用了东西了.
				state_machine.excute("prop_buy_prompt_use_info_to_plunder_use_prop", 0, {mould_id = zstring.tonumber(response.node.mould_id), count = 1})
				--发出消息使用了东西了出击令.
				state_machine.excute("betray_army_battle_scene_refresh_state", 0, "betray_army_battle_scene_refresh_state.")

				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
					if fwin:find("LPVESceneClass") ~= nil then
						state_machine.excute("lpve_scene_updeteinfo",0,"")
					end
					state_machine.excute("lpve_main_scene_updeteinfo",0,"")
				end
			end
		end

		local _count = 1
		local prop = fundPropWidthId(self.mould_id)
		local _prop_id = prop.user_prop_id
		
		protocol_command.prop_use.param_list = _prop_id.."\r\n" .. _count
		NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, self, responseUsePropCallback,false, nil)
end



function PropBuyPrompt:initDraw()
	--买
	-- local function buy_onTouchEvent(sender, evenType)
		-- local __spoint = sender:getTouchBeganPosition()
		-- local __mpoint = sender:getTouchMovePosition()
		-- local __epoint = sender:getTouchEndPosition()
		-- if evenType == ccui.TouchEventType.began then
		-- elseif evenType == ccui.TouchEventType.moved then
		-- elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
			-- if math.abs(__epoint.x - __spoint.x) < 5 then
				-- self:buy()
			-- end
		-- end
	-- end
	-- self.buyButton:addTouchEventListener(buy_onTouchEvent)
	
	--用
	-- local function use_onTouchEvent(sender, evenType)
		-- local __spoint = sender:getTouchBeganPosition()
		-- local __mpoint = sender:getTouchMovePosition()
		-- local __epoint = sender:getTouchEndPosition()
		-- if evenType == ccui.TouchEventType.began then
		-- elseif evenType == ccui.TouchEventType.moved then
		-- elseif evenType == ccui.TouchEventType.ended or evenType == ccui.TouchEventType.canceled then
			-- if math.abs(__epoint.x - __spoint.x) < 5 then
				-- self:use()
			-- end
		-- end
	-- end
	-- self.useButton:addTouchEventListener(use_onTouchEvent)

	
	self:showSurplusBuyTimes()
	
	self:onUpdateDraw()

	self:setCloseWin()

end

function PropBuyPrompt:setCloseWin()




end

function PropBuyPrompt:onEnterTransitionFinish()
	local csbItem = csb.createNode("campaign/activity_buy_props.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("sm_buy_physicalopen",0,"")
		state_machine.excute("prop_buy_prompt_close",0,"")
		return
	end

	--提示说明文本
	self.tipText = self:getUI("Text_3")
	
	--icon
	self.iconPanel = self:getUI("Panel_4")
	
	--使用说明
	self.explainText = self:getUI("Text_4")
	
	--元宝数
	self.gemText = self:getUI("Text_5")
	
	--购买
	self.buyButton = self:getUI("Button_3")
	fwin:addTouchEventListener(self.buyButton, nil, 
	{
		terminal_name = "prop_buy_prompt_buy_button", 
		cell = self,
		isPressedActionEnabled = true
	},
	nil, 1)	
	
	--还可购买数量
	self.surplusBuyText = self:getUI("Text_10")

	--还可购买数panel
	self.surplusBuyPanel = self:getUI("Panel_wenzi_1")
	self.surplusBuyPanel:setVisible(false)
	--if self.interfaceType == self._enum_type._DISPATCH then
	--	self.surplusBuyPanel:setVisible(true)
		-- for i, v in pairs(_ED.return_prop) do
			-- if tonumber(self.mould_id) == tonumber(v.mould_id) then
				-- --征讨令的可购买次数
				-- local times = tonumber(v.VIP_buy_times) - tonumber(v.buy_times)
				-- if tonumber(v.VIP_buy_times) == -1 then
					-- self.surplusBuyText:setString(_string_piece_info[75])
				-- else
					-- if times >= 0 then
						-- self.surplusBuyText:setString(times)
					-- else
						-- self.surplusBuyText:setString("0")
					-- end
				-- end
			-- end
		-- end
	--else	
	--	self.surplusBuyPanel:setVisible(false)
	--end	
	
	--使用
	self.useButton = self:getUI("Button_2")
	fwin:addTouchEventListener(self.useButton, nil, 
	{
		terminal_name = "prop_buy_prompt_use_button", 
		cell = self,
		isPressedActionEnabled = true
	},
	nil, 1)	
	
	--当前拥有个数
	self.surplusText = self:getUI("Text_7")
	self.surplusText:setString(getPropAllCountByMouldId(self.mould_id))
	
	self.propName = dms.string(dms["prop_mould"], self.mould_id, prop_mould.prop_name)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        self.propName = setThePropsIcon(self.mould_id)[2]
    end
	
	local iconCell = self:getIconCell()
	local config = iconCell:createConfig(self.mould_id, 1, false)
	iconCell:init(config, self.getIconCellTouchEvent, self)
	self.iconPanel:addChild(iconCell)

	if nil ~= _ED.return_prop and nil ~= _ED.return_equipment then
		self:initDraw()
	else
		local function responseShopViewCallBack(response)
			if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
				if nil ~= response.node and response.node.roots ~= nil then
					response.node:initDraw()
				end
			end
		end
	
		protocol_command.shop_view.param_list = "0"
		NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, self, responseShopViewCallBack, false, nil)
	end
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Button_gmdj_gb"), nil, 
	{
		terminal_name = "prop_buy_prompt_close", 
		cell = self,
		isPressedActionEnabled = true
	},
	nil, 2)	
end

function PropBuyPrompt:onExit()
	state_machine.remove("prop_buy_prompt_close")
end

function PropBuyPrompt:init(mould_id, interfaceType)
	self.mould_id = mould_id
	self.interfaceType = interfaceType or 0
	return self
end

