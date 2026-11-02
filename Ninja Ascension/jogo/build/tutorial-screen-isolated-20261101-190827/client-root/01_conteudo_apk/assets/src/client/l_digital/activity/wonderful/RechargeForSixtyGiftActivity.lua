--[[ ----------------------------------------------------------------------------
-- 60元充值礼包
--]] ----------------------------------------------------------------------------
RechargeForSixtyGiftActivity = class("RechargeForSixtyGiftActivityClass", Window)

-- 打开窗口
local recharge_for_sixty_gift_activity_window_open_terminal = {
	_name = "recharge_for_sixty_gift_activity_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RechargeForSixtyGiftActivityClass") then
			fwin:open(RechargeForSixtyGiftActivity:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local recharge_for_sixty_gift_activity_window_close_terminal = {
	_name = "recharge_for_sixty_gift_activity_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RechargeForSixtyGiftActivityClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(recharge_for_sixty_gift_activity_window_open_terminal)
state_machine.add(recharge_for_sixty_gift_activity_window_close_terminal)
state_machine.init()

-- 构造器
function RechargeForSixtyGiftActivity:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize recharge for sixty gift activity page state machine.
	local function init_recharge_for_sixty_gift_activity_terminal()
		-- 打开角色创建窗口
		local recharge_for_sixty_gift_activity_open_terminal = {
			_name = "recharge_for_sixty_gift_activity_open",
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

		-- 关闭角色创建窗口
		local recharge_for_sixty_gift_activity_close_terminal = {
			_name = "recharge_for_sixty_gift_activity_close",
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

		-- 显示窗口
		local recharge_for_sixty_gift_activity_show_terminal = {
			_name = "recharge_for_sixty_gift_activity_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local recharge_for_sixty_gift_activity_hide_terminal = {
			_name = "recharge_for_sixty_gift_activity_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 请求获取充值订单号
		local recharge_for_sixty_gift_activity_request_recharge_terminal = {
            _name = "recharge_for_sixty_gift_activity_request_recharge",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local rechargeIndex = _ED.active_activity[119].activity_Info[1].activityInfo_need_day
				m_reqcharge_info.prevRechargeIndex = rechargeIndex
				local function responseRechargeCallback(response)
					fwin:close(fwin:find("ConnectingViewClass"))
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_WINDOWS 
							and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_LINUX 
							and cc.Application:getInstance():getTargetPlatform() ~= cc.PLATFORM_OS_MAC 
							then
							m_reqcharge_info.rechargeIndex = rechargeIndex
							if OperatorNameConfig[app.configJson.OperatorName] == "t4" then
								state_machine.excute("platform_request_for_payment", 0, "0")
							else
								state_machine.excute("platform_request_for_payment", 0, response.node)
							end
							return
						else
							state_machine.excute("recharge_for_sixty_gift_activity_request_recharge_vali", 0, 0)
						end
					end
				end

				if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_ANDROID then
					local platform_purchase_info = readKey("platform_purchase_info")
					if platform_purchase_info and platform_purchase_info ~= "" then
						CheckOrderToRechargeServer()
						return true
					end
				end

				cc.UserDefault:getInstance():setStringForKey("paySpecialpid", ""..rechargeIndex)
                cc.UserDefault:getInstance():flush()
				protocol_command.request_top_up_order_number.param_list = "".. rechargeIndex .."\r\n"..m_sPayMould
				NetworkManager:register(protocol_command.request_top_up_order_number.code, nil, nil, nil, instance, responseRechargeCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--请求完成订单
		local recharge_for_sixty_gift_activity_request_recharge_vali_terminal = {
            _name = "recharge_for_sixty_gift_activity_request_recharge_vali",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseRechargeCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.onUpdateDraw ~= nil then
							response.node:onUpdateDraw()
						end
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
				NetworkManager:register(protocol_command.vali_top_up_order_number.code, nil, nil, nil, instance, responseRechargeCallback, false, nil)
				-- NetworkManager:register(protocol_command.keep_alive.code, nil, nil, nil, nil, nil, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		
		local recharge_for_sixty_gift_activity_draw_reward_terminal = {
            _name = "recharge_for_sixty_gift_activity_draw_reward",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local activityData = _ED.active_activity[119]
            	local function responseRewardCallback (response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	if response.node ~= nil and response.node.onUpdateDraw ~= nil then
							response.node:onUpdateDraw()
						end
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)
                    end
                end
				if nil ~= instance.surplus_time and instance.surplus_time > 0 then
					protocol_command.get_activity_reward.param_list = activityData.activity_id.."\r\n"..(0).."\r\n0"
					NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, instance, responseRewardCallback, false, nil)
				else
					TipDlg.drawTextDailog(_string_piece_info[302])
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --查看奖励
        local recharge_for_sixty_gift_activity_check_rewards_terminal = {
            _name = "recharge_for_sixty_gift_activity_check_rewards",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.l_digital.activity.wonderful.SmActivityLimitedTimeGoodPacksInfor")
            	state_machine.excute("sm_activity_limited_time_good_packs_infor_open", 0, {_ED.active_activity[119]})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(recharge_for_sixty_gift_activity_open_terminal)
		state_machine.add(recharge_for_sixty_gift_activity_close_terminal)
		state_machine.add(recharge_for_sixty_gift_activity_show_terminal)
		state_machine.add(recharge_for_sixty_gift_activity_hide_terminal)
		state_machine.add(recharge_for_sixty_gift_activity_request_recharge_terminal)
		state_machine.add(recharge_for_sixty_gift_activity_request_recharge_vali_terminal)
		state_machine.add(recharge_for_sixty_gift_activity_draw_reward_terminal)
		state_machine.add(recharge_for_sixty_gift_activity_on_update_draw_terminal)
		state_machine.add(recharge_for_sixty_gift_activity_check_rewards_terminal)
		state_machine.init()
	end
	-- call func init recharge for sixty gift activity state machine.
	init_recharge_for_sixty_gift_activity_terminal()
end

function RechargeForSixtyGiftActivity:onUpdateDrawData( ... )
	self.loaded = true
	self:onUpdateDraw()
end

function RechargeForSixtyGiftActivity:onUpdate(dt)
    if self.Text_end_time == nil or nil == self.end_time then
        return
    end
    self.surplus_time = (self.end_time - ((os.time() + _ED.time_add_or_sub))*1000)
    self.Text_end_time:setString(self.surplus_time < 0 and _string_piece_info[305] or self:drawTime(self.surplus_time))
    if self.surplus_time <= 0 then
    	self.Text_end_time = nil
  --   	self.Button_chongzhi:setBright(false)
		-- self.Button_chongzhi:setTouchEnabled(false)
		-- self.Button_chongzhi:setHighlighted(true)

		fwin:addService({
			callback = function ( params )
				state_machine.excute("activity_window_remove_activity_page", 0, {self, "RechargeForSixtyGiftActivity"})
			end,
			delay = 0.1,
			params = self
		})
    end
end

function RechargeForSixtyGiftActivity:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.ceil((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .._string_piece_info[231]
    end
    --if _hourTime > 0 then
        if _hourTime < 10 then
    		timeString = timeString .. "0".._hourTime ..":"
    	else
    		timeString = timeString .. _hourTime ..":"
    	end
    --end
    --if _minutesTime > 0 then
        if _minutesTime < 10 then
    		timeString = timeString .. "0".._minutesTime ..":"
    	else
            timeString = timeString .. _minutesTime ..":"
        end
    --end
    --if _secondsTime > 0 then
    	if _secondsTime < 10 then
    		timeString = timeString .. "0".._secondsTime 
    	else
	        timeString = timeString .. _secondsTime 
	    end
    --end
    return timeString
end

function RechargeForSixtyGiftActivity:onUpdateDraw()
	if self.loaded == false then
		return
	end

	local root = self.roots[1]

	-- 用户附加参数:是否完成(0:未完成 1:完成)|打折率|排序权重|过期时间点
	-- 档位id:10
	local activityData = _ED.active_activity[119]

	local activity_params = zstring.split(activityData.activity_params, "|")

	self.end_time = tonumber(activity_params[4])

	local activityRewardInfo = activityData.activity_Info[1]

	local topUpGoods = dms.element(dms["top_up_goods"], tonumber(activityRewardInfo.activityInfo_need_day))

	-- 充值金额
	self.Text_open_lv_info_2_0 = ccui.Helper:seekWidgetByName(root, "Text_open_lv_info_2_0")
	self.Text_open_lv_info_2_0._def_value = self.Text_open_lv_info_2_0._def_value or self.Text_open_lv_info_2_0:getString()
	self.Text_open_lv_info_2_0:setString( string.format(self.Text_open_lv_info_2_0._def_value, dms.atos(topUpGoods, top_up_goods.money) ) )

	-- 绘制充值奖励 绘制顺序：钻石、VIP经验、体力、小型经验电池
	-- local Panel_prpos_1 = ccui.Helper:seekWidgetByName(root, "Panel_prpos_1")
	-- local Panel_prpos_2 = ccui.Helper:seekWidgetByName(root, "Panel_prpos_2")
	-- local Panel_prpos_3 = ccui.Helper:seekWidgetByName(root, "Panel_prpos_3")
	-- local Panel_prpos_4 = ccui.Helper:seekWidgetByName(root, "Panel_prpos_4")
	-- Panel_prpos_1:removeAllChildren(true)
	-- Panel_prpos_2:removeAllChildren(true)
	-- Panel_prpos_3:removeAllChildren(true)
	-- Panel_prpos_4:removeAllChildren(true)

	-- local cell1 = ResourcesIconCell:createCell()
 --    cell1:init(2, tonumber(activityRewardInfo.activityInfo_gold), -1,nil,nil,true,true)
 --    Panel_prpos_1:addChild(cell1)

 --    local otherRewards = zstring.splits(activityRewardInfo.activityInfo_reward_select, "|", ",")
 --    local cell2 = ResourcesIconCell:createCell()
 --    cell2:init(tonumber(otherRewards[1][1]), tonumber(otherRewards[1][3]), tonumber(otherRewards[1][2]),nil,nil,true,true,1)
 --    Panel_prpos_2:addChild(cell2)

 --    local cell3 = ResourcesIconCell:createCell()
 --    cell3:init(12, tonumber(activityRewardInfo.activityInfo_food), -1,nil,nil,true,true)
 --    Panel_prpos_3:addChild(cell3)

 --    if tonumber(activityRewardInfo.activityInfo_prop_count) ~= 0 then
 --        local prop_data = activityRewardInfo.activityInfo_prop_info[1]
 --        local cell4 = ResourcesIconCell:createCell()
 --        cell4:init(6, tonumber(prop_data.propMouldCount), prop_data.propMould, nil,nil,true,true)
 --        Panel_prpos_4:addChild(cell4)
 --        if dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.use_of_ship) > 0 
 --            and dms.int(dms["prop_mould"], prop_data.propMould, prop_mould.storage_page_index) == 18 
 --            then
 --            local jsonFile = "sprite/sprite_wzkp.json"
 --            local atlasFile = "sprite/sprite_wzkp.atlas"
 --            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
 --            animation:setPosition(cc.p(cell4:getContentSize().width/2,cell4:getContentSize().height/2))
 --            cell4:addChild(animation)
 --        end
 --    end

 	local otherRewards = zstring.splits(activityRewardInfo.activityInfo_reward_select, "|", ",")
 	for i, reward in pairs(otherRewards) do
 		local Panel_prpos_x = ccui.Helper:seekWidgetByName(root, "Panel_prpos_" .. i)
 		local cell = ResourcesIconCell:createCell()
 		local rewardType = tonumber(reward[1])
 		cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]), nil,nil,true,true)
 		if rewardType == 6 
 			and (dms.int(dms["prop_mould"], tonumber(reward[2]), prop_mould.use_of_ship) > 0 and dms.int(dms["prop_mould"], tonumber(reward[2]), prop_mould.storage_page_index) == 18) 
 			then
 			local jsonFile = "sprite/sprite_wzkp.json"
            local atlasFile = "sprite/sprite_wzkp.atlas"
            local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
            animation:setPosition(cc.p(cell:getContentSize().width/2,cell:getContentSize().height/2))
            cell:addChild(animation)
 		end
 		Panel_prpos_x:addChild(cell)
 	end
 	
	if tonumber(activity_params[1]) == 1 then
		if 1 == tonumber(activityRewardInfo.activityInfo_isReward) then
			ccui.Helper:seekWidgetByName(root, "Image_yilingqu"):setVisible(true)
			self.Button_lingqu:setVisible(false)
			self.Button_chongzhi:setVisible(false)
		else
			self.Button_lingqu:setVisible(true)
			self.Button_chongzhi:setVisible(false)
		end
	else
		self.Button_lingqu:setVisible(false)
		self.Button_chongzhi:setVisible(true)
	end
end


function RechargeForSixtyGiftActivity:lazy()
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onInit, self, false)
 	self:onInit()
end

function RechargeForSixtyGiftActivity:unload()
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}
	self.Text_end_time = nil
end

function RechargeForSixtyGiftActivity:onEnterTransitionFinish()

end

function RechargeForSixtyGiftActivity.onImageLoaded(texture)
	
end

function RechargeForSixtyGiftActivity:onArmatureDataLoad(percent)
	
end

function RechargeForSixtyGiftActivity:onArmatureDataLoadEx(percent)
	-- if percent >= 1 then
	-- 	if self._load_over == false then
	-- 		self._load_over = true
	-- 		self:onInit()
	-- 	end
	-- end
end

function RechargeForSixtyGiftActivity:onLoad()
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

function RechargeForSixtyGiftActivity:onInit()
	-- 加载RechargeForSixtyGiftActivityWindow界面资源.
	-- res.activity.wonderful.limited_time_good_packs = res/activity/wonderful/limited_time_good_packs.csb
	local csbNode = csb.createNode("activity/wonderful/limited_time_good_packs.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- self:onUpdateDraw()
	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self, false)

	-- 奖励领取
	self.Button_lingqu = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_lingqu"), nil,
	{
		terminal_name = "recharge_for_sixty_gift_activity_draw_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 前往充值
	self.Button_chongzhi = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chongzhi"), nil,
	{
		terminal_name = "recharge_for_sixty_gift_activity_request_recharge",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	if app.configJson.OperatorName == "cayenne" then
		-- 查看奖励
		self.Panel_prpos_5 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prpos_5"), nil,
		{
			terminal_name = "recharge_for_sixty_gift_activity_check_rewards",
			terminal_state = 0,
			isPressedActionEnabled = true,
		}, nil, 0)
	end
	

	self.Text_end_time = ccui.Helper:seekWidgetByName(root, "Text_end_time")
end

function RechargeForSixtyGiftActivity:onExit()
	state_machine.remove("recharge_for_sixty_gift_activity_open")
	state_machine.remove("recharge_for_sixty_gift_activity_close")
	state_machine.remove("recharge_for_sixty_gift_activity_show")
	state_machine.remove("recharge_for_sixty_gift_activity_hide")
	state_machine.remove("recharge_for_sixty_gift_activity_request_recharge")
	state_machine.remove("recharge_for_sixty_gift_activity_request_recharge_vali")
	state_machine.remove("recharge_for_sixty_gift_activity_draw_reward")
	state_machine.remove("recharge_for_sixty_gift_activity_on_update_draw")
end

function RechargeForSixtyGiftActivity:init()

end

function RechargeForSixtyGiftActivity:close()
	-- window event : close.
	
end

function RechargeForSixtyGiftActivity:destroy(window)
	-- window event : destroy.
	
end

function RechargeForSixtyGiftActivity:createCell()
	local cell = RechargeForSixtyGiftActivity:new()
	cell:registerOnNodeEvent(cell)
	cell:registerOnNoteUpdate(cell, 0.5)
	return cell
end

-- ~END
-- ----------------------------------------------------------------------------
