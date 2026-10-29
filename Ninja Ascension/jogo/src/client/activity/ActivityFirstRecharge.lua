-- ----------------------------------------------------------------------------------------------------
-- 说明：首冲活动
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityFirstRecharge = class("ActivityFirstRechargeClass", Window)

local rechargeable_open_terminal = {
    _name = "rechargeable_open",
    _init = function (terminal) 
    	local server_date = nil
    	local save_date = nil
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			server_date = os.date("%x", _ED.system_time)
	    	save_date = cc.UserDefault:getInstance():getStringForKey(getKey("first_recharge_popup_unopen_date"), "")
	    	if save_date == server_date or zstring.tonumber(_ED.recharge_rmb_number) > 0 then
	        	terminal.unopen = true
	        else
	        	terminal.unopen = false
	    	end
	    end
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	-- print("==============================",params)
		if params == 1 then
			local FirstRecharge = ActivityFirstRecharge:createCell()
			FirstRecharge:init()
			fwin:open(FirstRecharge,fwin._windows)
			return			
		end
		-- print("==========",terminal.unopen)
	    if _ED.active_activity[4] ~= nil 
	    	and _ED.active_activity[4]~="" 
	    	and _ED.active_activity[4].activity_id == "0" 
	    	and terminal.unopen ~= true
	    	then
			local FirstRecharge = ActivityFirstRecharge:createCell()
			FirstRecharge:init()
			fwin:open(FirstRecharge,fwin._windows)	       
	    end


        return true
    end,
    _terminal = nil,
    _terminals = nil
} 

state_machine.add(rechargeable_open_terminal)  
state_machine.init()
function ActivityFirstRecharge:ctor()
    self.super:ctor()
	self.roots = {}
	self.loaded = false
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")

	self.chooseHeroIndex = 1
	self.currentChooseWidget = nil
	self.currentChooseInfo = nil
	
	self.reworld_sorting = {}

    -- Initialize ActivityFirstRecharge state machine.
    local function init_ActivityFirstRecharge_terminal()
		--前往充值
		local go_to_rechargeable_button_terminal = {
            _name = "go_to_rechargeable_button",
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
				fwin:open(RechargeDialog:new(), fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--领取
		local get_first_recharge_reward_button_terminal = {
            _name = "get_first_recharge_reward_button",
            _init = function (terminal) 
                
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function responsePropCompoundCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- 领取首冲
						jttd.facebookAPPeventSlogger("16")
						response.node:firstRechargeReward()
					end
				end
				if TipDlg.drawStorageTipo() == false then
					if (__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh)
						and ___is_open_firstCharge == true
						then
						protocol_command.draw_first_top_up_reward.param_list = self.chooseHeroIndex - 1
					end

					if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
						protocol_command.draw_first_top_up_reward.param_list = self.chooseHeroIndex - 1
					end
					NetworkManager:register(protocol_command.draw_first_top_up_reward.code, nil, nil, nil, instance, responsePropCompoundCallback, false, nil)
				end
			    return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新
		local activity_first_recharge_button_terminal = {
            _name = "activity_first_recharge_button",
            _init = function (terminal) 
                
				
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if instance ~= nil and instance.onUpdateRefresh ~= nil then
					instance:onUpdateRefresh()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--选择首充奖励的的武将索引
		local get_first_recharge_choose_hero_index_terminal = {
            _name = "get_first_recharge_choose_hero_index",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				params._datas._self.chooseHeroIndex = params._datas._index
				params._datas._self:updateChooseHeroHead()
				-- app.load("client.activity.ActivityFirstRechargePopup")
    --         	state_machine.excute("activity_first_recharge_popup_open_window", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示金币信息
        local get_first_recharge_show_gold_info_terminal = {
            _name = "get_first_recharge_show_gold_info",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = propMoneyInfo:new()
				cell:init("1")
				fwin:open(cell, fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示装备信息
        local get_first_recharge_show_equip_info_terminal = {
            _name = "get_first_recharge_show_equip_info",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				app.load("client.packs.equipment.EquipFragmentInfomation")
				local prop = params._datas._equip_mould_id
				
				if (__lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh)
					and  dms.int(dms["equipment_mould"], prop, equipment_mould.equipment_type) == 6 then
					app.load("client.packs.fashion.FashionInformation")
            		state_machine.excute("fashion_information_open", 0, {_datas={_equip = nil,_equip_mould = prop}})
            		return true

            	end
				local FragmentInformation = EquipFragmentInfomation:new()
				
				if dms.int(dms["equipment_mould"], prop, equipment_mould.equipment_type) == 4 or 
					dms.int(dms["equipment_mould"], prop, equipment_mould.equipment_type) == 5 or
					dms.int(dms["equipment_mould"], prop, equipment_mould.equipment_type) == 8 then
					FragmentInformation:init(prop,2,3)
				else
					FragmentInformation:init(prop,nil,2)
				end
				fwin:open(FragmentInformation, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		local rechargeable_close_terminal = {
            _name = "rechargeable_close",
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

		local recharge_popup_unopen_status_terminal = {
            _name = "recharge_popup_unopen_status",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local checkBox = params
            	local window_terminal = state_machine.find("rechargeable_open")
            	if window_terminal.unopen == true then
            		window_terminal.unopen = false
            		cc.UserDefault:getInstance():setStringForKey(getKey("first_recharge_popup_unopen_date"), "")
            	else
            		window_terminal.unopen = true
	            	local server_date = os.date("%x", _ED.system_time)
	            	cc.UserDefault:getInstance():setStringForKey(getKey("first_recharge_popup_unopen_date"), server_date)
			    end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(go_to_rechargeable_button_terminal)
		state_machine.add(get_first_recharge_reward_button_terminal)
		state_machine.add(activity_first_recharge_button_terminal)
		state_machine.add(get_first_recharge_choose_hero_index_terminal)
		state_machine.add(get_first_recharge_show_gold_info_terminal)
		state_machine.add(get_first_recharge_show_equip_info_terminal)
		state_machine.add(rechargeable_close_terminal)
		state_machine.add(recharge_popup_unopen_status_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityFirstRecharge state machine.
    init_ActivityFirstRecharge_terminal()

    self._load_over = false
	self:onLoad()
end

function ActivityFirstRecharge:firstRechargeReward(reward)
	local root = self.roots[1]
	
	local getRewardWnd = DrawRareReward:new()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		getRewardWnd:init(7,nil,self.reworld_sorting)
	else
		getRewardWnd:init(7)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		then
		fwin:open(getRewardWnd,fwin._windows)
	else
		fwin:open(getRewardWnd,fwin._ui)
	end
	local buttonLQ = ccui.Helper:seekWidgetByName(root, "Button_fc_6_0")
	local buttonRE = ccui.Helper:seekWidgetByName(root, "Button_fc_6")
	local Image_7 = ccui.Helper:seekWidgetByName(root, "Image_7")
	buttonLQ:setVisible(false)
	buttonRE:setVisible(false)
	Image_7:setVisible(true)
	_ED.active_activity[4] = nil
	
	state_machine.excute("home_update_first_recharge", 0,nil)

	_ED.active_activity[4] = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		state_machine.excute("activity_window_remove_activity_page", 0, self)
	end
end

function ActivityFirstRecharge:onUpdateDraw()
	if self.loaded == false then
		return
	end
	local root = self.roots[1]
	state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.FirstRecharge)
	local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_fc_2")
	local activeItem = _ED.active_activity[4]
	if nil == ListViewDraw or nil == activeItem then
		return
	end
	ListViewDraw:removeAllItems()
	local index = 1
	if tonumber(activeItem.activity_Info[1].activityInfo_equip_count) > 0 then	--可领取装备种类数量
		for n, v in pairs(activeItem.activity_Info[1].activityInfo_equip_info) do
			if v.equipMould ~= nil then
				-- local iconEquip = EquipIconCell:createCell()
				-- iconEquip:init(7,nil,v.equipMould)
				-- ListViewDraw:addChild(iconEquip)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					local cell = ResourcesIconCell:createCell()
			        cell:init(7, tonumber(v.equipMouldCount), v.equipMould,nil,nil,true,true,0,{equipQuality = 3})
			        ListViewDraw:addChild(cell)
			        local rewardinfo = {}
	                rewardinfo.type = 7
	                rewardinfo.id = v.equipMould
	                rewardinfo.number = tonumber(v.equipMouldCount)
	                self.reworld_sorting[index] = rewardinfo
	                index = index + 1
			    else
					local cell = EquipIconCell:createCell()
					cell:init(10, nil, v.equipMould, nil, nil, tonumber(v.equipMouldCount))
					ListViewDraw:addChild(cell)
				end
			end
		end
	end
	if tonumber(activeItem.activity_Info[1].activityInfo_prop_count) > 0 then--可领取道具种类数量
		for n, v in pairs(activeItem.activity_Info[1].activityInfo_prop_info) do
			if v.propMould ~= nil then
				-- local iconProp = PropIconCell:createCell()
				-- iconProp:init(15, v.propMould)
				-- ListViewDraw:addChild(iconProp)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					local cell = ResourcesIconCell:createCell()
			        cell:init(6, tonumber(v.propMouldCount), v.propMould,nil,nil,true,true,0)
			        ListViewDraw:addChild(cell)
			        local rewardinfo = {}
	                rewardinfo.type = 6
	                rewardinfo.id = v.propMould
	                rewardinfo.number = tonumber(v.propMouldCount)
	                self.reworld_sorting[index] = rewardinfo
	                index = index + 1
			    else
					local cell = PropIconCell:createCell()
					cell:init(24, v.propMould, tonumber(v.propMouldCount))
					ListViewDraw:addChild(cell)
				end
			end
		end
	end
	if tonumber(activeItem.activity_Info[1].activityInfo_silver) > 0 then--可领取银币数量
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 1, item_value = activeItem.activity_Info[1].activityInfo_silver}}})
		-- ListViewDraw:addChild(cell)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			local cell = ResourcesIconCell:createCell()
	        cell:init(1, tonumber(activeItem.activity_Info[1].activityInfo_silver), -1,nil,nil,true,true,0)
	        ListViewDraw:addChild(cell)
	        local rewardinfo = {}
            rewardinfo.type = 1
            rewardinfo.id = -1
            rewardinfo.number = tonumber(activeItem.activity_Info[1].activityInfo_silver)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
	    else
			local cell = propMoneyIcon:createCell()
			cell:init("1",tonumber(activeItem.activity_Info[1].activityInfo_silver),nil)
			ListViewDraw:addChild(cell)
		end
	end
	
	if tonumber(activeItem.activity_Info[1].activityInfo_gold) > 0 then--可领取的金币数量
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 2, item_value = activeItem.activity_Info[1].activityInfo_gold}}})
		-- ListViewDraw:addChild(cell)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			local cell = ResourcesIconCell:createCell()
	        cell:init(2, tonumber(activeItem.activity_Info[1].activityInfo_gold), -1,nil,nil,true,true,0)
	        ListViewDraw:addChild(cell)
	        local rewardinfo = {}
            rewardinfo.type = 2
            rewardinfo.id = -1
            rewardinfo.number = tonumber(activeItem.activity_Info[1].activityInfo_gold)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
	    else
			local cell = propMoneyIcon:createCell()
			cell:init("2",tonumber(activeItem.activity_Info[1].activityInfo_gold),nil)
			ListViewDraw:addChild(cell)
		end
	end
	
	if tonumber(activeItem.activity_Info[1].activityInfo_food) > 0 then--奖励1可领取体力数量
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			local cell = ResourcesIconCell:createCell()
	        cell:init(12, tonumber(activeItem.activity_Info[1].activityInfo_food), -1,nil,nil,true,true,0)
	        ListViewDraw:addChild(cell)
	        local rewardinfo = {}
            rewardinfo.type = 12
            rewardinfo.id = -1
            rewardinfo.number = tonumber(activeItem.activity_Info[1].activityInfo_food)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
	    else
			local cell = ResourcesIconCell:createCell()
			cell:init(0, 0, 0, {show_reward_list={{prop_type = 12, item_value = activeItem.activity_Info[1].activityInfo_food}}})
			ListViewDraw:addChild(cell)
		end
	end
	
	if tonumber(activeItem.activity_Info[1].activityInfo_honour) > 0 then--奖励1可领取声望数量
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 3, item_value = activeItem.activity_Info[1].activityInfo_honour}}})
		-- ListViewDraw:addChild(cell)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			local cell = ResourcesIconCell:createCell()
	        cell:init(12, tonumber(activeItem.activity_Info[1].activityInfo_honour), -1,nil,nil,true,true,0)
	        ListViewDraw:addChild(cell)
	        local rewardinfo = {}
            rewardinfo.type = 12
            rewardinfo.id = -1
            rewardinfo.number = tonumber(activeItem.activity_Info[1].activityInfo_honour)
            self.reworld_sorting[index] = rewardinfo
            index = index + 1
	    else
			local cell = propMoneyIcon:createCell()
			cell:init("3",tonumber(activeItem.activity_Info[1].activityInfo_honour),nil)
			ListViewDraw:addChild(cell)
		end
	end

	ListViewDraw:requestRefreshView()
	
	
	-- local buttonRE = ccui.Helper:seekWidgetByName(root, "Button_fc_6")
	-- local buttonLQ = ccui.Helper:seekWidgetByName(root, "Button_fc_6_0")
	-- local Image_7 = ccui.Helper:seekWidgetByName(root, "Image_7")
	
	-- if tonumber(_ED.recharge_rmb_number) <= 0 then
		-- buttonRE:setVisible(true)
		-- buttonLQ:setVisible(false)
		-- Image_7:setVisible(false)
	-- else
		-- if tonumber(activeItem.activity_id) == 1 then
			-- buttonRE:setVisible(false)
			-- buttonLQ:setVisible(false)
			-- Image_7:setVisible(true)
		-- else
			-- buttonRE:setVisible(false)
			-- buttonLQ:setVisible(true)
			-- Image_7:setVisible(false)
		-- end
	-- end
	
	self:onUpdateRefresh()
end
function ActivityFirstRecharge:onUpdateRefresh()
	local root = self.roots[1]
	local buttonRE = ccui.Helper:seekWidgetByName(root, "Button_fc_6")
	local buttonLQ = ccui.Helper:seekWidgetByName(root, "Button_fc_6_0")
	local Image_7 = ccui.Helper:seekWidgetByName(root, "Image_7")
	
	if buttonRE == nil then
		return
	end
	
	buttonRE:setVisible(false)
	buttonLQ:setVisible(false)
	Image_7:setVisible(false)
	
	local recharge_rmb_number = 0 
	if __lua_project_id == __lua_project_yugioh then 
		if zstring.tonumber(_game_platform_version_type) == 2 then 
			--游戏王安卓渠道，月卡不算首充
			local counts = dms.count(dms["top_up_goods"])
			local sufficientStr = zstring.split(_ED.user_sufficient_type ,",")
   			local isFristCharge = true
			for i=1,counts do
				local types = dms.int(dms["top_up_goods"],""..i,top_up_goods.goods_type)
				local value = zstring.tonumber(sufficientStr[i])
				--每个档位的充值状态
				if types == 0 and value > 0 then 	
					recharge_rmb_number = zstring.tonumber(_ED.recharge_rmb_number)
					break
				end
			end
		else
			recharge_rmb_number = zstring.tonumber(_ED.recharge_rmb_number)
		end
	else
		recharge_rmb_number = zstring.tonumber(_ED.recharge_rmb_number)
	end
	if recharge_rmb_number == 0 then
		buttonRE:setVisible(true)
	elseif recharge_rmb_number > 0 then
		local activeItem = _ED.active_activity[4]
		if activeItem == nil then
			Image_7:setVisible(true)
		else
			local activity_id = activeItem.activity_id
			if zstring.tonumber(activity_id) == 0 then
				buttonLQ:setVisible(true)
			else
				Image_7:setVisible(true)
			end
		end
	end
	
	-- if tonumber(_ED.recharge_rmb_number) > 0 then
		-- if _ED.active_activity[4] ~= nil then
			-- buttonRE:setVisible(false)
			-- buttonLQ:setVisible(true)
			-- Image_7:setVisible(false)
		-- else
			-- buttonRE:setVisible(false)
			-- buttonLQ:setVisible(false)
			-- Image_7:setVisible(true)
		-- end
	-- end
end

function ActivityFirstRecharge:updateChooseHeroHead()
	local root = self.roots[1]
	local shipMoulds = zstring.split(dms.string(dms["pirates_config"], 298, pirates_config.param), ",")
	local shipMouldId = shipMoulds[self.chooseHeroIndex]
	local pic = dms.int(dms["ship_mould"], shipMouldId, ship_mould.All_icon)

	-- 设置角色名称的图片 images/ui/play/wonderful_activity/role_1.png
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		then
	else
		local Panel_name = ccui.Helper:seekWidgetByName(root, "Panel_name")
		Panel_name:setBackGroundImage(string.format("images/ui/play/wonderful_activity/role_%d.png", self.chooseHeroIndex))
	end

	-- 设置角色的描述信息
	local Panel_info = ccui.Helper:seekWidgetByName(root, "Panel_info_" .. self.chooseHeroIndex)
	if self.currentChooseInfo ~= nil then
		self.currentChooseInfo:setVisible(false)
	end
	Panel_info:setVisible(true)
	self.currentChooseInfo = Panel_info

	-- 设置角色调用的半身像
	local Panel_role_n = ccui.Helper:seekWidgetByName(root, "Panel_role_n")
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		then
		Panel_role_n:setBackGroundImage(string.format("images/ui/play/wonderful_activity/shouchong_role_%d.png", self.chooseHeroIndex))
	elseif __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		then 
		Panel_role_n:setBackGroundImage(string.format("images/ui/play/wonderful_activity/role_t_%d.png", self.chooseHeroIndex))
	elseif __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_pokemon 
		then 
		Panel_role_n:removeAllChildren(true)
		local jsonFile = ""
        local atlasFile = ""
        if __lua_project_id == __lua_project_yugioh then
            atlasFile = string.format("sprite/spirte_battle_card_%s.atlas", _frist_recharge_spine_index[self.chooseHeroIndex])
			jsonFile = string.format("sprite/spirte_battle_card_%s.json", _frist_recharge_spine_index[self.chooseHeroIndex])
		else
			atlasFile = string.format("sprite/big_head_%s.atlas", _frist_recharge_spine_index[self.chooseHeroIndex])
			jsonFile = string.format("sprite/big_head_%s.json", _frist_recharge_spine_index[self.chooseHeroIndex])
		end
        app.load("client.battle.fight.FightEnum")
        local spArmature = sp.spine(jsonFile, atlasFile, 1, 0, 
            spineAnimations[_enum_animation_l_frame_index.animation_standby + 1], true, nil)

        spArmature:setPosition(cc.p(Panel_role_n:getContentSize().width/2, 0))
        spArmature.animationNameList = spineAnimations
        sp.initArmature(spArmature, true)
        Panel_role_n:addChild(spArmature)
	else
		Panel_role_n:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", pic))
	end

	-- 设置按钮选中的光效
	local Panel_light = ccui.Helper:seekWidgetByName(root, "Panel_light_" .. self.chooseHeroIndex)
	if self.currentChooseWidget ~= nil then
		self.currentChooseWidget:setVisible(false)
	end
	Panel_light:setVisible(true)
	self.currentChooseWidget = Panel_light
end

function ActivityFirstRecharge:lazy()
	
	local root = self.roots[1]
	local buttonRE = ccui.Helper:seekWidgetByName(root, "Button_fc_6")
	if nil == buttonRE then
		-- 为空的时候重置
		self:unload()
	end
	
	
	if self.loaded == true then
		return
	end
	self.loaded = true
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	-- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onInit, self, false)
	self:onInit()
end

function ActivityFirstRecharge:unload()
	local ListViewDraw = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_fc_2")
	if ListViewDraw ~= nil then
		ListViewDraw:removeAllItems()
	end
	self:removeAllChildren(true)
	self.loaded = false
	self.roots = {}

	self.chooseHeroIndex = 1
	self.currentChooseWidget = nil
	self.currentChooseInfo = nil
end

function ActivityFirstRecharge:onEnterTransitionFinish()

end

function ActivityFirstRecharge.onImageLoaded(texture)
	
end

function ActivityFirstRecharge:onArmatureDataLoad(percent)
	
end

function ActivityFirstRecharge:onArmatureDataLoadEx(percent)
	-- if percent >= 1 then
	-- 	if self._load_over == false then
	-- 		self._load_over = true
	-- 		self:onInit()
	-- 	end
	-- end
end

function ActivityFirstRecharge:onLoad()
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

function ActivityFirstRecharge:onInit()
    local csbActivityFirstRecharge = csb.createNode("activity/wonderful/first_charge_spree.csb")
    local root = csbActivityFirstRecharge:getChildByName("root")
    table.insert(self.roots, root)
	self:addChild(csbActivityFirstRecharge)
	
	self:onUpdateDraw()
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self, false)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fc_6"), nil, 
			{
				terminal_name = "go_to_rechargeable_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_fc_6_0"), nil, 
			{
				terminal_name = "get_first_recharge_reward_button", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)
	if __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert 
		then
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_shouchong_close"), nil, 
			{
				terminal_name = "rechargeable_close", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)	

			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_1"), nil, 
			{
				terminal_name = "recharge_popup_unopen_status", 
				terminal_state = 0, 
			},
			nil,0)


		local updateDrawIndex = 0
		for i=1, 4 do
			local Button_role = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_role_"..i), nil, 
			{
				terminal_name = "get_first_recharge_choose_hero_index", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_self = self,
				_index = i
			},
			nil,0)
			if Button_role ~= nil then
				updateDrawIndex = updateDrawIndex + 1
			end
		end
		if updateDrawIndex == 4 then
			self:updateChooseHeroHead()

			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yulan_1"), nil, 
			{
				terminal_name = "get_first_recharge_show_gold_info", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)

			local _equip_mould_id = nil
			local activeItem = _ED.active_activity[4]
			if nil ~= activeItem then
				for n, v in pairs(activeItem.activity_Info[1].activityInfo_equip_info) do
					if v.equipMould ~= nil then
						_equip_mould_id = v.equipMould
					end
				end
			end

			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yulan_2"), nil, 
			{
				terminal_name = "get_first_recharge_show_equip_info", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_equip_mould_id = _equip_mould_id
			},
			nil,0)
		end
	end
	if (__lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh)
		and ___is_open_firstCharge == true
		then
		local updateDrawIndex = 0
		for i=1, 4 do
			local Button_role = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_role_"..i), nil, 
			{
				terminal_name = "get_first_recharge_choose_hero_index", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_self = self,
				_index = i
			},
			nil,0)
			if Button_role ~= nil then
				updateDrawIndex = updateDrawIndex + 1
			end
		end
		if updateDrawIndex == 4 then
			self:updateChooseHeroHead()

			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yulan_1"), nil, 
			{
				terminal_name = "get_first_recharge_show_gold_info", 
				terminal_state = 0, 
				isPressedActionEnabled = true
			},
			nil,0)

			local _equip_mould_id = nil
			local activeItem = _ED.active_activity[4]
			if nil ~= activeItem then
				for n, v in pairs(activeItem.activity_Info[1].activityInfo_equip_info) do
					if v.equipMould ~= nil then
						_equip_mould_id = v.equipMould
					end
				end
			end

			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yulan_2"), nil, 
			{
				terminal_name = "get_first_recharge_show_equip_info", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_equip_mould_id = _equip_mould_id
			},
			nil,0)
			if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then 
				self.chooseHeroIndex = 2
				self:updateChooseHeroHead()
			end
		end
	end
	local Panel_effect_baduola = ccui.Helper:seekWidgetByName(root, "Panel_effect_baduola")
	if Panel_effect_baduola ~= nil then
		local jsonFile = "images/ui/effice/effect_baduola/effect_baduola.json"
		local atlasFile = "images/ui/effice/effect_baduola/effect_baduola.atlas"
		local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		Panel_effect_baduola:addChild(animation)
	end
end

function ActivityFirstRecharge:onExit()
	state_machine.remove("go_to_rechargeable_button")
	state_machine.remove("get_first_recharge_choose_hero_index")
	state_machine.remove("get_first_recharge_show_gold_info")
	state_machine.remove("get_first_recharge_show_equip_info")
	state_machine.remove("rechargeable_close")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		state_machine.remove("activity_first_recharge_button")
	end
end

function ActivityFirstRecharge:init()
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
		or __lua_project_id == __lua_project_red_alert
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto
		or __lua_project_id == __lua_project_yugioh
		then
		self.loaded = true
		--self:lazy()
		self:onInit()		
	end
end

function ActivityFirstRecharge:createCell()
	local cell = ActivityFirstRecharge:new()
	cell:registerOnNodeEvent(cell)
	-- cell:registerOnNoteUpdate(cell, 0.5)
	return cell
end