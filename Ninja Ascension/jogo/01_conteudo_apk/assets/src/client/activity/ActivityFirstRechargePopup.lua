
-- 首冲弹出界面

ActivityFirstRechargePopup = class("ActivityFirstRechargePopupClass", Window)
    
local activity_first_recharge_popup_open_window_terminal = {
    _name = "activity_first_recharge_popup_open_window",
    _init = function (terminal) 
    	-- 今日不再提醒
    	local server_date = os.date("%x", _ED.system_time)
    	local save_date = cc.UserDefault:getInstance():getStringForKey(getKey("first_recharge_popup_unopen_date"), "")
    	if save_date == server_date then
        	terminal.unopen = true
        else
        	terminal.unopen = false
    	end
    	-- cc.UserDefault:getInstance():setStringForKey(getKey("first_recharge_popup_unopen_date"), "")
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)	
	    if _ED.active_activity[4] ~= nil 
	    	and _ED.active_activity[4]~="" 
	    	and _ED.active_activity[4].activity_id == "0" 
	    	and missionIsOver() == true
	    	and terminal.unopen ~= true
	    	then
	        fwin:open(ActivityFirstRechargePopup:new(), fwin._ui)
	    end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(activity_first_recharge_popup_open_window_terminal)
state_machine.init()

function ActivityFirstRechargePopup:ctor()
    self.super:ctor()
	self.actions = {}
	self.roots = {}
	self.panelList = {}

	self.chooseHeroIndex = 1
	self.currentChooseWidget = nil
	self.currentChooseInfo = nil
	
	
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	
	
    -- Initialize ActivityFirstRechargePopup page state machine.
    local function init_terminal()
	
	
		--关闭
		local activity_first_recharge_popup_close_terminal = {
            _name = "activity_first_recharge_popup_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 			
				instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local activity_first_recharge_popup_close_window_terminal = {
            _name = "activity_first_recharge_popup_close_window",
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
		
		--前往充值
		local activity_first_recharge_popup_go_to_rechargeable_button_terminal = {
            _name = "activity_first_recharge_popup_go_to_rechargeable_button",
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
				instance.actions[1]:play("window_close", false)
				if ___is_open_firstCharge == true then
					local action = instance.actions[1]
					if action:IsAnimationInfoExists("window_close") == false then
						state_machine.excute("activity_first_recharge_popup_close_window", 0,"")
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--今天可开启状态
		local activity_first_recharge_popup_unopen_status_terminal = {
            _name = "activity_first_recharge_popup_unopen_status",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	local checkBox = params
            	local window_terminal = state_machine.find("activity_first_recharge_popup_open_window")
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

		--选择首充奖励的的武将索引
		local activity_first_recharge_popup_choose_hero_index_terminal = {
            _name = "activity_first_recharge_popup_choose_hero_index",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				params._datas._self.chooseHeroIndex = params._datas._index
				params._datas._self:updateChooseHeroHead()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示金币信息
        local activity_first_recharge_popup_show_gold_info_terminal = {
            _name = "activity_first_recharge_popup_show_gold_info",
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
        local activity_first_recharge_popup_show_equip_info_terminal = {
            _name = "activity_first_recharge_popup_show_equip_info",
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
	
		
		state_machine.add(activity_first_recharge_popup_close_terminal)
		state_machine.add(activity_first_recharge_popup_close_window_terminal)
		state_machine.add(activity_first_recharge_popup_go_to_rechargeable_button_terminal)
		state_machine.add(activity_first_recharge_popup_unopen_status_terminal)
		state_machine.add(activity_first_recharge_popup_choose_hero_index_terminal)
		state_machine.add(activity_first_recharge_popup_show_gold_info_terminal)
		state_machine.add(activity_first_recharge_popup_show_equip_info_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_terminal()
end

function ActivityFirstRechargePopup:addCell(cell)
	if table.getn(self.panelList) > 0 then
		local root = self.roots[1]
		local name = table.remove(self.panelList,1,1)
		local p = ccui.Helper:seekWidgetByName(root, name)
		p:addChild(cell)
	end
end

function ActivityFirstRechargePopup:onUpdateDraw()

	local root = self.roots[1]

	local activeItem = _ED.active_activity[4]
	
	if activeItem == nil then
		return 
	end
	
	self.panelList = {
		"Panel_1",
		"Panel_3",
		"Panel_5",
	}

	if tonumber(activeItem.activity_Info[1].activityInfo_equip_count) > 0 then	--可领取装备种类数量
		for n, v in pairs(activeItem.activity_Info[1].activityInfo_equip_info) do
			if v.equipMould ~= nil then
				local cell = EquipIconCell:createCell()
				cell:init(10, nil, v.equipMould, nil, false, tonumber(v.equipMouldCount))
				self:addCell(cell)
			end
		end
	end
	if tonumber(activeItem.activity_Info[1].activityInfo_prop_count) > 0 then--可领取道具种类数量
		for n, v in pairs(activeItem.activity_Info[1].activityInfo_prop_info) do
			if v.propMould ~= nil then
				local cell = PropIconCell:createCell()
				cell:init(24, v.propMould, tonumber(v.propMouldCount),false)
				self:addCell(cell)
			end
		end
	end
	if tonumber(activeItem.activity_Info[1].activityInfo_silver) > 0 then--可领取银币数量
		local cell = propMoneyIcon:createCell()
		cell:init("1",tonumber(activeItem.activity_Info[1].activityInfo_silver),nil)
		self:addCell(cell)
	end
	
	if tonumber(activeItem.activity_Info[1].activityInfo_gold) > 0 then--可领取的金币数量
		local cell = propMoneyIcon:createCell()
		cell:init("2",tonumber(activeItem.activity_Info[1].activityInfo_gold),nil)
		self:addCell(cell)
	end
	
	if tonumber(activeItem.activity_Info[1].activityInfo_food) > 0 then--奖励1可领取体力数量
		local cell = ResourcesIconCell:createCell()
		cell:init(0, 0, 0, {show_reward_list={{prop_type = 12, item_value = activeItem.activity_Info[1].activityInfo_food}}})
		self:addCell(cell)
	end
	
	if tonumber(activeItem.activity_Info[1].activityInfo_honour) > 0 then--奖励1可领取声望数量
		local cell = propMoneyIcon:createCell()
		cell:init("3",tonumber(activeItem.activity_Info[1].activityInfo_honour),nil)
		self:addCell(cell)
	end
	
end

function ActivityFirstRechargePopup:updateChooseHeroHead()
	local root = self.roots[1]
	local shipMoulds = zstring.split(dms.string(dms["pirates_config"], 298, pirates_config.param), ",")
	local shipMouldId = shipMoulds[self.chooseHeroIndex]
	local pic = dms.int(dms["ship_mould"], shipMouldId, ship_mould.All_icon)

	-- 设置角色名称的图片 images/ui/play/wonderful_activity/role_1.png
	local Panel_name = ccui.Helper:seekWidgetByName(root, "Panel_name")
	Panel_name:setBackGroundImage(string.format("images/ui/play/wonderful_activity/role_%d.png", self.chooseHeroIndex))

	-- 设置角色的描述信息
	local Panel_info = ccui.Helper:seekWidgetByName(root, "Panel_info_" .. self.chooseHeroIndex)
	if self.currentChooseInfo ~= nil then
		self.currentChooseInfo:setVisible(false)
	end
	Panel_info:setVisible(true)
	self.currentChooseInfo = Panel_info

	-- 设置角色调用的半身像
	local Panel_role_n = ccui.Helper:seekWidgetByName(root, "Panel_role_n")
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto then 
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

function ActivityFirstRechargePopup:onEnterTransitionFinish()

    local csbRecharge = csb.createNode("activity/wonderful/first_recharge.csb")	
	local root = csbRecharge:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbRecharge)

	local action = csb.createTimeline("activity/wonderful/first_recharge.csb") 
    table.insert(self.actions, action )
    csbRecharge:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
		
        local str = frame:getEvent()

        if str == "window_close_over" then
        	fwin:close(self)
        end
    end)
    action:play("window_open", false)
	
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "activity_first_recharge_popup_go_to_rechargeable_button", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)
	
	if __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cs_close"), nil, 
		{
			terminal_name = "activity_first_recharge_popup_close", 
			terminal_state = 0, 
		},
		nil,0)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_4"), nil, 
		{
			terminal_name = "activity_first_recharge_popup_close", 
			terminal_state = 0, 
		},
		nil,0)
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		terminal_name = "activity_first_recharge_popup_close_window", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil,0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_1"), nil, 
	{
		terminal_name = "activity_first_recharge_popup_unopen_status", 
		terminal_state = 0, 
	},
	nil,0)

	self:onUpdateDraw()
	if (__lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh)
		and ___is_open_firstCharge == true
		then
		local updateDrawIndex = 0
		for i=1, 4 do
			local Button_role = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_role_"..i), nil, 
			{
				terminal_name = "activity_first_recharge_popup_choose_hero_index", 
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
				terminal_name = "activity_first_recharge_popup_show_gold_info", 
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
				terminal_name = "activity_first_recharge_popup_show_equip_info", 
				terminal_state = 0, 
				isPressedActionEnabled = true,
				_equip_mould_id = _equip_mould_id
			},
			nil,0)

			self.chooseHeroIndex = 2
			self:updateChooseHeroHead()
		end
	end
end


function ActivityFirstRechargePopup:onExit()
	state_machine.remove("activity_first_recharge_popup_close")
	state_machine.remove("ctivity_first_recharge_popup_close_window")
	state_machine.remove("activity_first_recharge_popup_go_to_rechargeable_button")
	state_machine.remove("activity_first_recharge_popup_unopen_status")
	state_machine.remove("activity_first_recharge_popup_choose_hero_index")
	state_machine.remove("activity_first_recharge_popup_show_gold_info")
	state_machine.remove("activity_first_recharge_popup_show_equip_info")
end
