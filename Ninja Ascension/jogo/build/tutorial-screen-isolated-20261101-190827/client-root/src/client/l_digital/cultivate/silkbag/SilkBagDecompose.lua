--[[ ----------------------------------------------------------------------------
-- 装备分解界面
--]] ----------------------------------------------------------------------------
SilkBagDecompose = class("SilkBagDecomposeClass", Window)

-- 打开窗口
local silk_bag_decompose_window_open_terminal = {
	_name = "silk_bag_decompose_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SilkBagDecomposeClass") then
			fwin:open(SilkBagDecompose:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local silk_bag_decompose_window_close_terminal = {
	_name = "silk_bag_decompose_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SilkBagDecomposeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(silk_bag_decompose_window_open_terminal)
state_machine.add(silk_bag_decompose_window_close_terminal)
state_machine.init()

-- 构造器
function SilkBagDecompose:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.mould_id = -1
	self.tempor_id = -1
	-- var
	self._grow_level = 1
	-- load lua files.
	app.load("client.cells.utils.resources_icon_cell")
	-- Initialize silk bag decompose page state machine.
	local function init_silk_bag_decompose_terminal()
		-- 打开角色创建窗口
		local silk_bag_decompose_open_terminal = {
			_name = "silk_bag_decompose_open",
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
		local silk_bag_decompose_close_terminal = {
			_name = "silk_bag_decompose_close",
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
		local silk_bag_decompose_show_terminal = {
			_name = "silk_bag_decompose_show",
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
		local silk_bag_decompose_hide_terminal = {
			_name = "silk_bag_decompose_hide",
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

		-- 点击装备锦囊
		local silk_bag_click_equip_terminal = {
			_name = "silk_bag_click_equip",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local mould_id = instance.mould_id
					local tempor_id = instance.tempor_id
					state_machine.excute("silk_bag_load_equip",0,{mould_id,tempor_id})
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 点击分解锦囊
		local silk_bag_resolve_equip_terminal = {
			_name = "silk_bag_resolve_equip",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil == instance then
					return true 
				end

				local function responseResolveSilkbagCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	if nil ~= response.node and nil ~= response.node.roots and nil ~= response.node.roots[1] then
                    		local rewardGroup = _ED.silkbag_decompose_resolveRescouce

                    		local rewardList = {}
							rewardList.show_reward_list = {}
							rewardList.show_reward_item_count = 0
                    		if nil ~= rewardGroup then 
                    			local rewardSplits = zstring.split(rewardGroup,"|") 
                    			for k,v in pairs(rewardSplits) do
                    				local rewardSplit = zstring.split(v,",")
                    				local reward = {}
                    				reward.prop_type = tonumber(rewardSplit[1])
                    				reward.prop_item = tonumber(rewardSplit[2])
                    				reward.item_value = tonumber(rewardSplit[3])
                    				rewardList.show_reward_list[k] = reward
                    			end
                    		end
                    		rewardList.show_reward_item_count = table.nums(rewardList.show_reward_list)

                    		state_machine.excute("silk_bag_knapsack_update",0,"")	
							state_machine.excute("silk_bag_decompose_window_close",0,"")
                    		--奖励绘制
                    		app.load("client.reward.DrawRareReward")
                    		local getRewardWnd = DrawRareReward:new()
                    		getRewardWnd:init(6,rewardList)
                    		fwin:open(getRewardWnd, fwin._ui)
						end
                    end
                end

				local function commendResolve()
					local tempor_id = nil
					if 1 == params._datas.index_type then
						tempor_id = instance.tempor_id
					else
						--一键分解
					end
					protocol_command.ship_slik_bag_resolve.param_list = tempor_id    
	                NetworkManager:register(protocol_command.ship_slik_bag_resolve.code, nil, nil, nil, instance, responseResolveSilkbagCallBack, false, nil) 
            	end

				--判断锦囊的品质
				local mould_id = instance.mould_id
				local level = tonumber(instance._grow_level)
				local quality = dms.int(dms["ship_silk_bag_mould"], mould_id,ship_silk_bag_mould.quality_level)

				function showConfirmTip(instance,n)
					if 0 == n then
						--分解
						commendResolve()
					end
				end

				if 1 < level then 
					app.load("client.utils.ConfirmTip")
					local tip = ConfirmTip:new()
					tip:init(instance, showConfirmTip, tipStringInfo_rescue_silkbag[19])
					fwin:open(tip,fwin._ui)
				elseif 3 <= quality then
					app.load("client.utils.ConfirmTip")
					local tip = ConfirmTip:new()
					tip:init(instance, showConfirmTip, tipStringInfo_rescue_silkbag[6])
					fwin:open(tip,fwin._ui)
				else
					--分解
					commendResolve()
				end
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}


		state_machine.add(silk_bag_decompose_open_terminal)
		state_machine.add(silk_bag_decompose_close_terminal)
		state_machine.add(silk_bag_decompose_show_terminal)
		state_machine.add(silk_bag_decompose_hide_terminal)
		state_machine.add(silk_bag_click_equip_terminal)
		state_machine.add(silk_bag_resolve_equip_terminal)
		state_machine.init()
	end
	-- call func init silk bag decompose state machine.
	init_silk_bag_decompose_terminal()
end

-- 对象初始化
function SilkBagDecompose:init(params)
	if nil ~= params then
		self.mould_id = params[1]
		self.tempor_id = params[2]
	end
	
	return self
end

function SilkBagDecompose:onUpdateDraw()
	local root = self.roots[1]
	if -1 == self.mould_id then
		return
	end
	local silkMouldId = self.mould_id
	local id = self.tempor_id
	-- 突破
	local breakLevel = 0
	-- 基础属性
	local baseProperty = nil    

	for k,v in pairs(_ED.silkbag_pack_info) do
		if tonumber(id) == tonumber(v.id) then
			breakLevel = v.quality
			self._grow_level = v.level
			baseProperty = v.addBaseProperty
			break
		end
	end

	--锦囊基础属性
	for i=1,5 do
		local Text_attribute_t = ccui.Helper:seekWidgetByName(root, "Text_attribute_t_"..i)
		local Text_attribute_n = ccui.Helper:seekWidgetByName(root, "Text_attribute_n_"..i)
		Text_attribute_t:setVisible(false)
		Text_attribute_n:setVisible(false)
	end

	-- 技能图标
	local Panel_skill_icon = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon")

	local cell= ResourcesIconCell:createCell()
 	cell:init(71,-1,silkMouldId,nil,nil,false,false,0,nil)
	Panel_skill_icon:addChild(cell)

	local silkbag_name_id = dms.int(dms["ship_silk_bag_mould"], silkMouldId,ship_silk_bag_mould.silkbag_name)
	local silkbag_name_word = dms.element(dms["word_mould"], silkbag_name_id)
    local name = silkbag_name_word[3]

	-- 技能名称
	local Text_up_star_add_name = ccui.Helper:seekWidgetByName(root, "Text_up_star_add_name")
	Text_up_star_add_name:setString(name)
	
	-- 突破值
	local Text_dh_type_n = ccui.Helper:seekWidgetByName(root, "Text_dh_type_n")
	local breakeLibId = dms.int(dms["ship_silk_bag_mould"],silkMouldId,ship_silk_bag_mould.breake_group) 
	local breakeLib =dms.searchs(dms["silk_bag_break_group_mould"],ship_silk_bag_breake.lib_id,breakeLibId,ship_silk_bag_breake.cur_breake_level,breakLevel)
	Text_dh_type_n:setString(breakLevel)

	-- 等级
	local Text_dh_lv_n = ccui.Helper:seekWidgetByName(root, "Text_dh_lv_n")
	local growLevelExp = 0
	local levelLibId = dms.int(dms["ship_silk_bag_mould"],silkMouldId,ship_silk_bag_mould.upgrade_group) 
	local levelLib =dms.searchs(dms["silk_bag_level_up_group_mould"],ship_silk_bag_level.lib_id,levelLibId)

	for k,v in pairs(levelLib) do
		local rangeLevel = zstring.split(v[ship_silk_bag_level.cur_level_range],",")

		if tonumber(self._grow_level) >= tonumber(rangeLevel[1]) and tonumber(self._grow_level) <= tonumber(rangeLevel[2]) then
			growLevelExp = levelLib[k][5]
			break
		end

	end
	Text_dh_lv_n:setString(self._grow_level)

	--锦囊基础属性
	local add_property_info = zstring.split(baseProperty,"|")

	for i=1,table.nums(add_property_info) do
		local Text_attribute_t = ccui.Helper:seekWidgetByName(root, "Text_attribute_t_"..i)
		Text_attribute_t:setVisible(true)

		local Text_attribute_n = ccui.Helper:seekWidgetByName(root, "Text_attribute_n_"..i)
		local add_property_per = zstring.split(add_property_info[i],",")
		if nil ~= add_property_per then
			Text_attribute_n:setString(tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])].." "..add_property_per[2])
		end
		Text_attribute_n:setVisible(true)
	end

	local extraGroups = dms.string(dms["ship_silk_bag_mould"],silkMouldId,ship_silk_bag_mould.extra_property)
	local extra_property_info  = zstring.split(extraGroups,"|")

	--额外属性
	if -1 ~= tonumber(extra_property_info[1]) then
		for i=1,table.nums(extra_property_info) do
			if 1 == i then
				local Text_attribute_t = ccui.Helper:seekWidgetByName(root, "Text_attribute_t_"..(i+3))
				Text_attribute_t:setVisible(true)
			end

			local Text_attribute_n = ccui.Helper:seekWidgetByName(root, "Text_attribute_n_"..(i+3))
			local extra_property_per = zstring.split(extra_property_info[i],",")

			if nil ~= extra_property_per then
				local strData = tipStringInfo_rescue_silkbag_property[tostring(extra_property_per[1])]
				local str = ""
				local flag = string.find(strData,"%%d")
				if nil ~= flag then
					str = string.format(strData,tonumber(extra_property_per[2])).."%"
				else
					str = strData..extra_property_per[2]
				end
				Text_attribute_n:setString(str)
			end

			Text_attribute_n:setVisible(true)
		end
	end
	local mouldType = dms.int(dms["ship_silk_bag_mould"],silkMouldId,ship_silk_bag_mould.mould_type)
    -- 专属道具
    if mouldType == 2 then
        local str = self:getExcluseSkill(silkMouldId)
        if str then
        	local Text_attribute_t_6 = ccui.Helper:seekWidgetByName(root, "Text_attribute_t_6")
            Text_attribute_t_6:setVisible(true)
            Text_attribute_t_6:setString(str)
        end
    end
end

--获得专属技能描述
function SilkBagDecompose:getExcluseSkill(silkMouldId)
    local excluseInfos = dms.string(dms["ship_silk_bag_mould"],tonumber(silkMouldId),ship_silk_bag_mould.exclusive_skill)
    if "-1" == tostring(excluseInfos) then
        return nil
    end
    local protectLv = SilkBagHandler.getProtectLv(getSilkbagMouldByTemplateId(self.tempor_id))
    local excluseGroups = nil
	local excluseList = zstring.split(excluseInfos,"|")
    for i,v in ipairs(excluseList) do 
        if "-1" ~= tostring(v) then
            if i == tonumber(protectLv) then 
                excluseGroups = v
                break
            end
        end
    end

    if excluseGroups == nil then 
        return nil
    end

	local str = "" 
	local excluseInfoGroups = zstring.split(excluseGroups,",")
	local describeCallback = function (word_id)
        if word_id ~= "-1" then 
            local word_info = dms.element(dms["word_mould"], tonumber(word_id))
            if word_info ~= nil then 
                local desName = word_info[3]
                str = str .. tostring(desName)
            end
        end
    end
    for k,v in pairs(excluseInfoGroups) do
        local skillNameId = dms.string(dms["talent_mould"], tonumber(v), talent_mould.talent_name)
		local skillDescribeId = dms.string(dms["talent_mould"], tonumber(v), talent_mould.talent_describe)
		describeCallback(skillNameId)
        describeCallback(skillDescribeId)
    end
    if str == "" then 
        return nil
	end
	return str
end

function SilkBagDecompose:onEnterTransitionFinish()
	-- 加载SilkBagDecomposeWindow界面资源.
	-- res.cultivate.silk_bag_decompose = res/cultivate/silk_bag_decompose.csb
	local csbNode = csb.createNode("cultivate/silk_bag_decompose.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 分解
	self.Button_silk_decompose = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_silk_decompose"), nil,
	{
		terminal_name = "silk_bag_resolve_equip",
		terminal_state = 0,
		index_type = 1,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 装备
	self.Button_silk_equipment = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_silk_equipment"), nil,
	{
		terminal_name = "silk_bag_click_equip",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_up_star_add_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_up_star_add_closed"), nil,
	{
		terminal_name = "silk_bag_decompose_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

function SilkBagDecompose:onExit()
	-- 释放SilkBagDecomposeWindow界面资源.
	state_machine.remove("silk_bag_decompose_open")
	state_machine.remove("silk_bag_decompose_close")
	state_machine.remove("silk_bag_decompose_show")
	state_machine.remove("silk_bag_decompose_hide")
	state_machine.remove("silk_bag_click_equip")
	state_machine.remove("silk_bag_resolve_equip")
end

function SilkBagDecompose:close()
	-- window event : close.
	
end

function SilkBagDecompose:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
