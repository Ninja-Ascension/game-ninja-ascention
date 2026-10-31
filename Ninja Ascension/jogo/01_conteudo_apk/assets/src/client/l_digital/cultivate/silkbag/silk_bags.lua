--[[ ----------------------------------------------------------------------------
-- 锦囊主界面
--]] ----------------------------------------------------------------------------
SilkBags = class("SilkBagsClass", Window)

-- 打开窗口
local silk_bag_window_open_terminal = {
	_name = "silk_bag_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SilkBagsClass") then
			fwin:open(SilkBags:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local silk_bag_window_close_terminal = {
	_name = "silk_bag_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SilkBagsClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}



state_machine.add(silk_bag_window_open_terminal)
state_machine.add(silk_bag_window_close_terminal)

state_machine.init()

-- 构造器
function SilkBags:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.ship = nil
	self.lastcell = nil
	self.listview = nil
	self.useIndex = -1        --当前选择槽位
	self.useSilkId = -1      --当前选择锦囊moudleID 
	self.useSilkTemporId = -1 --当前选择锦囊temporID
	self.silkList = {
		[1]=-1,
		[2]=-1,
		[3]=-1,
		[4]=-1
	}
	self.buyLevelCounts = 0  --升级消耗数量
	self.consume_prop_id = nil --消耗道具类型
	self.Button_level_consume = nil --升级按钮
	self.click_time = nil
	self.click_start = false
	self.displace_config_info = nil--置换道具配置
	self.is_level_flag = false		-- 是否是升级
	--升级&突破类型枚举
	self.enum_type = {
		_TYPE_GROW_LEVEL = 1,						-- 升级
		_TYPE_BREAKE = 2,				-- 突破
	}
	
	self._can_start_upgrage = true  --是否可以长按升级

	self._exclusive_mould_id = nil
	
	app.load("client.l_digital.cultivate.silkbag.SilkBagHandler")
	app.load("client.cells.ship.hero_icon_list_cell")
	app.load("client.l_digital.cultivate.silkbag.SilkBagKnapsack")
	app.load("client.cells.utils.resources_icon_cell")
    app.load("client.l_digital.cultivate.silkbag.SilkBagUpgrade")
	app.load("client.l_digital.cultivate.silkbag.Silkbaghelp")
	app.load("client.l_digital.cultivate.silkbag.SilkBagTalentInfo")
	app.load("client.l_digital.cultivate.silkbag.SilkBagFastResolve")
	
	local function init_silk_bag_terminal()
		-- 打开角色创建窗口
		local silk_bag_open_terminal = {
			_name = "silk_bag_open",
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
		local silk_bag_close_terminal = {
			_name = "silk_bag_close",
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
		local silk_bag_show_terminal = {
			_name = "silk_bag_show",
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
		local silk_bag_hide_terminal = {
			_name = "silk_bag_hide",
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

		-- 宠物锦囊信息刷新
		local silk_bag_hero_info_terminal = {
			_name = "silk_bag_hero_info",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance.ship = params
                instance.useIndex = -1
				instance:onUpdateHeroSilkBagInfo()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		---设置头像高亮
		local silk_bag_page_strength_to_highlighted_terminal = {
            _name = "silk_bag_page_strength_to_highlighted",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= params then
                    instance:setIndex(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--第一次进入设置亮框
		local silk_bag_listview_first_set_index_terminal = {
            _name = "silk_bag_listview_first_set_index",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= params then
                    instance.ship = params
                    instance:firstIconIndex()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		--添加锦囊
		local silk_bag_equip_features_terminal = {
            _name = "silk_bag_equip_features",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("silk_bag_equip_features")
				local m_index = params._datas.m_index
				-- 护佑槽位提示未达到镶嵌条件
				if m_index >= 5 and tonumber(instance.silkList[m_index]) == -1 and tonumber(instance.silkList[1]) ~= -1 then 
					local excluseSilkData = getSilkbagMouldByTemplateId(instance.silkList[1])
					if SilkBagHandler.getSilkProtectOpen(excluseSilkData) == false then 
						local lockLV = SilkBagHandler.getSilkProtectLock(excluseSilkData)
						if lockLV ~= nil then 
							local tipStr = string.format(tipStringInfo_rescue_silkbag[24],lockLV.."")
							TipDlg.drawTextDailog(tipStr)
							state_machine.unlock("silk_bag_equip_features")
							return
						end
					end
				end
				-- 判断装备槽是否解锁

				if nil ~= instance.silkList[m_index] then
					--判断是否已经装备锦囊
					if -1 ~= tonumber(instance.silkList[m_index]) then
						state_machine.excute("silk_bag_switch_choose",0,{m_index})
						state_machine.unlock("silk_bag_equip_features")
						return true
					end
				end
				
                --判断是否有锦囊
                if nil ~= _ED.silkbag_pack_info then
					local flag = false
					local curIndex = m_index
					if tonumber(m_index) == 11 then 
						curIndex = instance.useIndex
					end
                	for k,v in pairs(_ED.silkbag_pack_info) do
						if -1 == v.onUseIndex then
							if 1 < tonumber(curIndex) and tonumber(curIndex) < 5 then
								local mType = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.mould_type)
								if mType == 1 then
									flag = true
									break
								end
							elseif tonumber(curIndex) > 4  then
								local mType = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.mould_type)
								if mType == 3 then
									flag = true
									break
								end
							else
								flag = true
								break
							end
						end
					end

                	if flag == false then
                		--弹无锦囊提示
                		SilkBagHandler.openConfirmTip()
                		state_machine.unlock("silk_bag_equip_features")
                		return true
                	end
                else
                	--弹无锦囊提示
                	SilkBagHandler.openConfirmTip()
                	state_machine.unlock("silk_bag_equip_features")
                	return true
                end
                self._exclusive_mould_id = nil
                if tonumber(m_index) == 1 then   --装备专属锦囊
                	--判断是否有专属锦囊且未装备
                	local flag = instance:getHaveExclusive()
                	if flag then
                		instance.useIndex = 1
                		instance:onUpdateSilkBagListInfo()
                		state_machine.excute("silk_bag_knapsack_window_open",0,{openType = 1,exclusiveId = self._exclusive_mould_id})
                	else
                		--提示无此类专属
                		function showConfirmTip(instance,n)

                		end
                		app.load("client.utils.ConfirmTip")
                		local tip = ConfirmTip:new()
                		tip:init(instance, showConfirmTip, tipStringInfo_rescue_silkbag[9])
                		fwin:open(tip,fwin._ui)
                	end
                elseif tonumber(m_index) == 2 then --装备普通锦囊槽
                	instance.useIndex = 2
                	instance:onUpdateSilkBagListInfo()
                	state_machine.excute("silk_bag_knapsack_window_open",0,{openType = 2})
                elseif tonumber(m_index) == 3 then
                	instance.useIndex = 3
                	instance:onUpdateSilkBagListInfo()
                	state_machine.excute("silk_bag_knapsack_window_open",0,{openType = 2})	
                elseif tonumber(m_index) == 4 then  
                	instance.useIndex = 4
                	instance:onUpdateSilkBagListInfo()
					state_machine.excute("silk_bag_knapsack_window_open",0,{openType = 2})	
				elseif tonumber(m_index) >= 5 and tonumber(m_index) <= 8 then 
					instance.useIndex = tonumber(m_index)
                	instance:onUpdateSilkBagListInfo()
					state_machine.excute("silk_bag_knapsack_window_open",0,{openType = 3})
                elseif tonumber(m_index) == 11 then  --更换锦囊按钮
                	if 1 == instance.useIndex then
                		--判断是否有专属锦囊且未装备
                		local flag = instance:getHaveExclusive()
                		if flag then
                			state_machine.excute("silk_bag_knapsack_window_open",0,{openType = 1,exclusiveId = self._exclusive_mould_id})
                        else
                            function showConfirmTip(instance,n)

                            end
                            app.load("client.utils.ConfirmTip")
                            local tip = ConfirmTip:new()
                            tip:init(instance, showConfirmTip, tipStringInfo_rescue_silkbag[9])
                            fwin:open(tip,fwin._ui)
                		end
					
					elseif instance.useIndex < 5 then 
						state_machine.excute("silk_bag_knapsack_window_open",0,{openType = 2})
					else
						state_machine.excute("silk_bag_knapsack_window_open",0,{openType = 3})
                	end  
                end
                state_machine.unlock("silk_bag_equip_features")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --锦囊升级消耗
		local silk_bag_upgrade_consume_terminal={
			 _name = "silk_bag_upgrade_consume",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
            	local function responseLevelSilkbagCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if nil ~= response.node and nil ~= response.node.roots and nil ~= response.node.roots[1] then
							self._can_start_upgrage = true
							if response.node.useIndex == 1 then 
								response.node:onUpdateHeroSilkBagInfo()
							else
								response.node:onUpdateSilkBagDetailInfo()
							end
							smFightingChange()
						end
                    end
                end
                local silk_tempor_id = params[1]
                local prop_id = params[2]
                local prop_num = params[3]
                local param = prop_id..":"..prop_num

            	protocol_command.ship_slik_bag_level_up.param_list = silk_tempor_id.."\r\n"..param       
                NetworkManager:register(protocol_command.ship_slik_bag_level_up.code, nil, nil, nil, instance, responseLevelSilkbagCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}
        -- 锦囊刷新
        local silk_bag_info_refresh_terminal = {
            _name = "silk_bag_info_refresh",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
				if instance then 
					if instance.useIndex == 1  then 
						instance:onUpdateHeroSilkBagInfo()
					else
						instance:onUpdateSilkBagDetailInfo()
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--锦囊突破消耗
		local silk_bag_breake_consume_terminal={
			 _name = "silk_bag_breake_consume",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
            	local function responseBreakeSilkbagCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if nil ~= response.node and nil ~= response.node.roots and nil ~= response.node.roots[1] then
							if response.node.useIndex == 1 then 
								response.node:onUpdateHeroSilkBagInfo()
							else 
								response.node:onUpdateSilkBagDetailInfo()
							end
						end
                    end
                end
                local silk_tempor_id = params[1]

            	protocol_command.ship_slik_bag_promote.param_list = silk_tempor_id   
                NetworkManager:register(protocol_command.ship_slik_bag_promote.code, nil, nil, nil, instance, responseBreakeSilkbagCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		--安上锦囊
		local silk_bag_load_equip_terminal={
			 _name = "silk_bag_load_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	
            	local function responseLoadEquipCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	if nil ~= response.node and nil ~= response.node.roots and nil ~= response.node.roots[1] then
	                        state_machine.excute("silk_bag_decompose_window_close",0,"")
							state_machine.excute("silk_bag_knapsack_window_close",0,"")
							state_machine.excute("sm_all_warehouse_update_draw",0,"")
							state_machine.excute("sm_silkbags_warehouse_update_draw",0,"")
							state_machine.excute("notification_center_update",0,"push_notification_cultivate_silkbag")
							response.node.silkList[response.node.useIndex] = params[2]
							response.node.useSilkTemporId = params[2]
							response.node:onUpdateHeroSilkBagInfo()
							smFightingChange()
						end
                    end
                end
                local ship = instance.ship
                local ship_tempor_id = ship.ship_id
                local silkbag_tempor_id = params[2]
                local use_index = instance.useIndex

                protocol_command.ship_slik_bag_use.param_list = ship_tempor_id.."\r\n"..silkbag_tempor_id.."\r\n".. use_index          
                NetworkManager:register(protocol_command.ship_slik_bag_use.code, nil, nil, nil, instance, responseLoadEquipCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		--卸下锦囊
		local silk_bag_unload_equip_terminal={
			 _name = "silk_bag_unload_equip",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if -1 == instance.useIndex or -1 == instance.useSilkTemporId then
            		return true
            	end
            	local function responseUnLoadEquipCallBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    	if nil ~= response.node and nil ~= response.node.roots and nil ~= response.node.roots[1] then
                    		state_machine.excute("sm_all_warehouse_update_draw",0,"")
							state_machine.excute("sm_silkbags_warehouse_update_draw",0,"")
							state_machine.excute("notification_center_update",0,"push_notification_cultivate_silkbag")
							response.node.silkList[tonumber(response.node.useIndex)] = -1
							response.node:onUpdateHeroSilkBagInfo()
							smFightingChange()
						end
                    end
                end
                local ship = instance.ship
                local ship_tempor_id = ship.ship_id 
                local silkbag_tempor_id = instance.useSilkTemporId
                local use_index = instance.useIndex

                protocol_command.ship_slik_bag_un_use.param_list = ship_tempor_id.."\r\n"..silkbag_tempor_id.."\r\n".. use_index          
                NetworkManager:register(protocol_command.ship_slik_bag_un_use.code, nil, nil, nil, instance, responseUnLoadEquipCallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		--锦囊置换
		local silk_bag_displace_terminal={
			 _name = "silk_bag_displace",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if -1 == instance.useSilkId or -1 == instance.useSilkTemporId or nil == params then
            		return true
				end
				local useSilkTemporId = instance.useSilkTemporId
				local useSilkId = instance.useSilkId
            	local displace_mould = instance:getDisplacePropMould()
            	local propId = displace_mould.prop_id
            	local propNum = displace_mould.need_num
				if nil == fundPropWidthId(propId) then
					TipDlg.drawTextDailog(tipStringInfo_rescue_silkbag[7])
					return true
				end
            	local porp_name_word = dms.element(dms["word_mould"], fundPropWidthId(propId).prop_name)
            	local porp_name = porp_name_word[3]
				if fundPropWidthId(propId) then
					if tonumber(propNum) >= tonumber(fundPropWidthId(propId).prop_name) then
						TipDlg.drawTextDailog(string.format(tipStringInfo_rescue_silkbag[17],porp_name))
						return true
					end
				end
            	

            	local function responseDisplaceSilkbagCallBack( response )
            		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            			if nil ~= response.node and nil ~= response.node.roots and nil ~= response.node.roots[1] then
            				state_machine.excute("sm_all_warehouse_update_draw",0,"")
                        	state_machine.excute("sm_silkbags_warehouse_update_draw",0,"")
            				response.node:onUpdateSilkBagListInfo()
            				smFightingChange()
            			end
            		end
            	end
            	--提示是否消耗道具置换
            	function showConfirmTip(instance,n)
            		if 0 == n then
	                    protocol_command.ship_slik_bag_change_mould.param_list = "" .. useSilkTemporId   
	                    NetworkManager:register(protocol_command.ship_slik_bag_change_mould.code, nil, nil, nil, instance, responseDisplaceSilkbagCallBack, false, nil)
            		end
            	end

            	app.load("client.utils.ConfirmTip")
            	local tip = ConfirmTip:new()
            	tip:init(instance, showConfirmTip, string.format(tipStringInfo_rescue_silkbag[16],tonumber(propNum),porp_name))
            	fwin:open(tip,fwin._ui)

                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		
		--点击切换槽位
		local silk_bag_switch_choose_terminal={
			 _name = "silk_bag_switch_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
				
            	if nil ~= params and nil ~= instance then
            		local choose_id = params[1]
					instance:selectBlink(choose_id)
            		instance.useIndex = choose_id
            		instance:onUpdateSilkBagListInfo()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		--一键升级
		local silk_bag_one_click_grow_level_terminal={
			 _name = "silk_bag_one_click_grow_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if nil ~= instance and nil ~= params then
                        state_machine.lock("silk_bag_one_click_grow_level",0,"")
                        if self.enum_type._TYPE_GROW_LEVEL == tonumber(params._datas.m_index)  then
                            --一键升级
                            local curSilkTemporId = instance.useSilkTemporId

                            local silk_ship = {}

                            for k,v in pairs(_ED.silkbag_pack_info) do
                                if tonumber(curSilkTemporId) == v.id then
                                    silk_ship.breakLevel = v.quality
                                    silk_ship.ship_grade = v.level
                                    silk_ship.exprience = v.exp
                                    silk_ship.silkMouldId = v.silkBagMouldId
                                    silk_ship.temporId = v.id
                                    break       
                                end
							end
							if SilkBagHandler.comeAutoUpgradeFlag(silk_ship.ship_grade,silk_ship.silkMouldId,silk_ship.breakLevel,silk_ship.exprience) then
								state_machine.excute("silkbag_auto_upgrade_window_open", 0, silk_ship)
							else
								TipDlg.drawTextDailog(tipStringInfo_rescue_silkbag[7])
							end
                            
                        else
                            -- 突破
                            state_machine.excute("silk_bag_breake_consume",0,{instance.useSilkTemporId})
                        end
                        state_machine.unlock("silk_bag_one_click_grow_level")
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
		}

		-- 跳转属性详情
		local silk_bag_goto_protect_talent_terminal={
			_name = "silk_bag_goto_protect_talent",
		   _init = function (terminal) 
			   
		   end,
		   _inited = false,
		   _instance = self,
		   _state = 0,
		   _invoke = function(terminal, instance, params)
			   if nil ~= instance then
				   local silkBagInfo = getSilkbagMouldByTemplateId(instance.useSilkTemporId)
				   state_machine.excute("silkbag_talent_info_window_open",0,{silkBagInfo})
			   end
			   return true
		   end,
		   _terminal = nil,
		   _terminals = nil
	   }

	   -- 打开快速筛选
		local silk_bag_fast_resolve_terminal={
			_name = "silk_bag_fast_resolve",
		   _init = function (terminal) 
			   
		   end,
		   _inited = false,
		   _instance = self,
		   _state = 0,
		   _invoke = function(terminal, instance, params)
			   state_machine.excute("silkbag_fast_resolve_window_open",0,"")
			   return true
		   end,
		   _terminal = nil,
		   _terminals = nil
	   }
		
		
		state_machine.add(silk_bag_open_terminal)
		state_machine.add(silk_bag_close_terminal)
		state_machine.add(silk_bag_show_terminal)
		state_machine.add(silk_bag_hide_terminal)
		state_machine.add(silk_bag_hero_info_terminal)
		state_machine.add(silk_bag_equip_features_terminal)
		state_machine.add(silk_bag_page_strength_to_highlighted_terminal)
		state_machine.add(silk_bag_listview_first_set_index_terminal)
		state_machine.add(silk_bag_upgrade_consume_terminal)
		state_machine.add(silk_bag_unload_equip_terminal)
		state_machine.add(silk_bag_load_equip_terminal)
		state_machine.add(silk_bag_breake_consume_terminal)
		state_machine.add(silk_bag_displace_terminal)
		state_machine.add(silk_bag_switch_choose_terminal)
		state_machine.add(silk_bag_one_click_grow_level_terminal)
		state_machine.add(silk_bag_info_refresh_terminal)
		state_machine.add(silk_bag_goto_protect_talent_terminal)
		state_machine.add(silk_bag_fast_resolve_terminal)
		
		state_machine.init()
	end
	-- call func init silk bag state machine.
	init_silk_bag_terminal()
end

-- 对象初始化
function SilkBags:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

--填充宠物列表
function SilkBags:drawHeroIcon()
	local root = self.roots[1]
	local ListView_head_bag = ccui.Helper:seekWidgetByName(root, "ListView_head_bag") --容器
    ListView_head_bag:removeAllItems()
    local ship = nil
    local tence = 1
    for i, v in pairs(self:getSortedHeroes()) do
	    local cell = HeroIconListCell:createCell()
	    local Panel_prop = ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop")
	    if 1 == tence then
	       tence = tence + 1
	       ship = v
	    end
	    if nil ~= v then
	        cell:init(v, 1, true,200,nil,nil,1)   
	    else
	        cell:init(nil,1, true, nil,nil,true)
		end
        ListView_head_bag:addChild(cell)
    end
    self.listview = ListView_head_bag
    state_machine.excute("silk_bag_listview_first_set_index",0,ship)	
end

--宠物排序
function SilkBags:getSortedHeroes()
	local function fightingCapacity(a,b)
		local al = tonumber(a.hero_fight)
		local bl = tonumber(b.hero_fight)
		local result = false
		if al > bl then
			result = true
		end
		return result 
	end

	local tSortedHeroes = {}
	-- 上阵武将数组
	local arrBusyHeroes = {}
	-- 各星级武将数组
	local arrStarLevelHeroesWhite = {}--白
	local arrStarLevelHeroesGreen = {}--绿
	local arrStarLevelHeroesKohlrabiblue= {}--蓝
	local arrStarLevelHeroesPurple = {}--紫
	local arrStarLevelHeroesOrange = {}--橙
	local arrStarLevelHeroesRed = {}--红
	local arrStarLevelHeroesGold = {}--金
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		for i, ship in pairs(_ED.user_ship) do
			if ship.ship_id ~= nil then
				if zstring.tonumber(ship.formation_index) > 0 or zstring.tonumber(ship.little_partner_formation_index) > 0 then
					table.insert(arrBusyHeroes, ship)
				else
					table.insert(arrStarLevelHeroesWhite, ship)	
				end
			end
		end
		table.sort(arrBusyHeroes, fightingCapacity)
		table.sort(arrStarLevelHeroesWhite, fightingCapacity)
		for i=1, #arrBusyHeroes do
			table.insert(tSortedHeroes, arrBusyHeroes[i])
		end
		for i=1, #arrStarLevelHeroesWhite do
			table.insert(tSortedHeroes, arrStarLevelHeroesWhite[i])
		end
	else
		-- 主角放在第一位
		for i, ship in pairs(_ED.user_ship) do
			if ship.ship_id ~= nil then
				local shipData = dms.element(dms["ship_mould"], ship.ship_template_id)
				local captain_type = dms.atoi(shipData, ship_mould.captain_type)
				if captain_type == 0 then
					tSortedHeroes[1] = ship
				elseif zstring.tonumber(ship.formation_index) > 0 or zstring.tonumber(ship.little_partner_formation_index) > 0 then
					table.insert(arrBusyHeroes, ship)
				else
					if captain_type ~= 3 then 
						if dms.atoi(shipData, ship_mould.ship_type) == 0 then
							table.insert(arrStarLevelHeroesWhite, ship)
						elseif dms.atoi(shipData, ship_mould.ship_type) == 1 then
							table.insert(arrStarLevelHeroesGreen, ship)
						elseif dms.atoi(shipData, ship_mould.ship_type) == 2 then
							table.insert(arrStarLevelHeroesKohlrabiblue, ship)
						elseif dms.atoi(shipData, ship_mould.ship_type) == 3 then
							table.insert(arrStarLevelHeroesPurple, ship)
						elseif dms.atoi(shipData, ship_mould.ship_type) == 4 then
							table.insert(arrStarLevelHeroesOrange, ship)
						elseif dms.atoi(shipData, ship_mould.ship_type) == 5 then
							table.insert(arrStarLevelHeroesRed, ship)
						elseif dms.atoi(shipData, ship_mould.ship_type) == 6 then
							table.insert(arrStarLevelHeroesGold, ship)
						end 
					end
				end
			end
		end
		table.sort(arrBusyHeroes, fightingCapacity)
		table.sort(arrStarLevelHeroesWhite, fightingCapacity)
		table.sort(arrStarLevelHeroesGreen, fightingCapacity)
		table.sort(arrStarLevelHeroesKohlrabiblue, fightingCapacity)
		table.sort(arrStarLevelHeroesPurple, fightingCapacity)
		table.sort(arrStarLevelHeroesOrange, fightingCapacity)
		table.sort(arrStarLevelHeroesRed, fightingCapacity)
		table.sort(arrStarLevelHeroesGold, fightingCapacity)
		-- 把已排序好的上阵武将加入到 武将排序数组中
		for i=1, #arrBusyHeroes do
			table.insert(tSortedHeroes, arrBusyHeroes[i])
		end
		for i=1, #arrStarLevelHeroesGold do
			table.insert(tSortedHeroes, arrStarLevelHeroesGold[i])
		end
		for i=1, #arrStarLevelHeroesRed do
			table.insert(tSortedHeroes, arrStarLevelHeroesRed[i])
		end
		for i=1, #arrStarLevelHeroesOrange do
			table.insert(tSortedHeroes, arrStarLevelHeroesOrange[i])
		end
		for i=1, #arrStarLevelHeroesPurple do
			table.insert(tSortedHeroes, arrStarLevelHeroesPurple[i])
		end
		for i=1, #arrStarLevelHeroesKohlrabiblue do
			table.insert(tSortedHeroes, arrStarLevelHeroesKohlrabiblue[i])
		end
		for i=1, #arrStarLevelHeroesGreen do
			table.insert(tSortedHeroes, arrStarLevelHeroesGreen[i])
		end
		for i=1, #arrStarLevelHeroesWhite do
			table.insert(tSortedHeroes, arrStarLevelHeroesWhite[i])
		end
	end
	
	return tSortedHeroes
end

--设置第一次进入宠物选中
function SilkBags:firstIconIndex()
	--todo 设置第一次的底框 和listvew位置
	local ship = self.ship
	local items = self.listview:getItems()
	local index = 1
	local itemsnumber = #items
	local height = 0
	for i,v in pairs(items) do
		if v.ship == ship then
			v:setSelected(true)
			v.ishow = true
			self.lastcell = v
			index = i 
			widget = v:getContentSize().width
			break
		end
	end
	self.listview:getInnerContainer():setPositionX((index-1)*widget)

	self:onUpdateHeroSilkBagInfo()
end

--红点显示
function SilkBags:updateSilkBagRedPoint(shipId, shipTemplateId)
	local function isHaveRedot(slotIndex)
		local isHaveNoUseSilk = false
		if slotIndex > 4 then 
			local excluseSilkData = nil
			local haveUpNum = 0
			for k, v in pairs(_ED.silkbag_pack_info) do
				local mouldType = dms.int(dms["ship_silk_bag_mould"], tonumber(v.silkBagMouldId), ship_silk_bag_mould.exclusive_id)
				local mType = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.mould_type)

				if 2 == mType and mouldType == shipTemplateId and 1 == tonumber(v.onUseIndex) then 
					excluseSilkData = v
					break
				end
			end
			if excluseSilkData and SilkBagHandler.getOpenProtect() and SilkBagHandler.getSilkProtectOpen(excluseSilkData) then 
				for k, v in pairs(_ED.silkbag_pack_info) do
					if -1 == tonumber(v.onUseIndex) then
						local mType = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.mould_type)
						if 3 == mType then 
							isHaveNoUseSilk = true
							break
						end
					end
				end
			end
		else
			for k, v in pairs(_ED.silkbag_pack_info) do
				local mouldType = dms.int(dms["ship_silk_bag_mould"], tonumber(v.silkBagMouldId), ship_silk_bag_mould.exclusive_id)
				local mType = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.mould_type)

				local condition = false
				if slotIndex == 1 then
					condition = mouldType == shipTemplateId and mType == 2
				else
					condition = mouldType == -1 and mType == 1
				end
	
				if -1 == tonumber(v.onUseIndex) and condition then
					isHaveNoUseSilk = true
					break
				end
			end
	
		end
		
		--如果没有相关类型的忍具
		if not isHaveNoUseSilk then
			return false
		end

		for k, v in pairs(_ED.silkbag_pack_info) do
			if tonumber(v.onUseShipId) == shipId and tonumber(v.onUseIndex) == slotIndex then
				return false
			end
		end
		return true
	end

	local root = self.roots[1]
	local widget = self.Panel_silk_special_icon

	if widget._istips == true then
		widget:removeChild(widget._nodeChild, true)
		widget._nodeChild = nil
		widget._istips = false
	end

	--专属忍具槽位是1
	if isHaveRedot(1) == true then
		if widget._istips == nil or widget._istips == false then
			local ball = cc.Sprite:create("images/ui/bar/tips.png")
			ball:setAnchorPoint(cc.p(1, 1))
			ball:setPosition(cc.p(widget:getContentSize().width-ball:getContentSize().width*0.5, widget:getContentSize().height-ball:getContentSize().height*0.5))
			widget:addChild(ball)
			widget._nodeChild = ball
			widget._istips = true
		end
	end

	-- 普通忍具槽位是2,3,4
	for i = 1, (SilkBagHandler.getSlotsNums() - 1) do
		local widget = nil 
		if i < 4 then 
			widget = ccui.Helper:seekWidgetByName(root, "Panel_equipment_icon_box_"..i)
		else
			-- 护佑控件
			widget = ccui.Helper:seekWidgetByName(root, "Panel_huyou_icon_"..(i+1))
		end

		if widget._istips == true then
			widget:removeChild(widget._nodeChild, true)
			widget._nodeChild = nil
			widget._istips = false
		end

		if isHaveRedot(i + 1) == true then
			if widget._istips == nil or widget._istips == false then
				local ball = cc.Sprite:create("images/ui/bar/tips.png")
				ball:setAnchorPoint(cc.p(1, 1))
				ball:setPosition(cc.p(widget:getContentSize().width-ball:getContentSize().width*0.5, widget:getContentSize().height-ball:getContentSize().height*0.5))
				widget:addChild(ball)
				widget._nodeChild = ball
				widget._istips = true
			end
		end
	end
end

--刷新宠物锦囊信息
function SilkBags:onUpdateHeroSilkBagInfo()
	local root = self.roots[1]
	local ship = self.ship
	self.useSilkId = -1
	--重置锦囊列表
	for i=1,SilkBagHandler.getSlotsNums() do
		self.silkList[i] = -1
	end
	for i=1,3 do
		local Button_equipment_icon = ccui.Helper:seekWidgetByName(root, "Panel_equipment_icon_"..i)
		Button_equipment_icon:removeAllChildren()
		local Text_equipment_no = ccui.Helper:seekWidgetByName(root, "Text_equipment_no_"..i)
		Text_equipment_no:setString(tipStringInfo_rescue_silkbag[5])
	end

	-- 护佑重置
	for i=5,8 do
		local Panel_huyou = ccui.Helper:seekWidgetByName(root, "Panel_huyou_"..i)
		if Panel_huyou then 
			Panel_huyou:setVisible(false)
		end

		local Image_lcok = ccui.Helper:seekWidgetByName(root, "Image_lcok_"..i)
		if Image_lcok then 
			Image_lcok:setVisible(false)
		end
		
		local Panel_huyou_icon = ccui.Helper:seekWidgetByName(root, "Panel_huyou_icon_"..i)
		if Panel_huyou_icon then 
			Panel_huyou_icon:removeAllChildren()
		end
		local Image_choose = ccui.Helper:seekWidgetByName(root, "Image_choose_"..i)
		if Image_choose then 
			Image_choose:setVisible(false)
		end
		local Image_add = ccui.Helper:seekWidgetByName(root, "Image_add_"..i)
		if Image_add then 
			Image_add:setVisible(false)
		end
	end

	self.Panel_silk_special_icon:removeAllChildren()

	--专属资质判断
	local ability = dms.int(dms["ship_mould"], tonumber(ship.ship_template_id), ship_mould.ability)
	local limitAbility = dms.int(dms["ship_config"], 47, 4)

    if ability < limitAbility then
		self.Panel_silk_special_icon:setVisible(false)
		self.Image_one:setVisible(false)
	else
		self.Panel_silk_special_icon:setVisible(true)
		self.Image_one:setVisible(true)
	end

	if _ED.silkbag_pack_info ~= nil then
		for k,v in pairs(_ED.silkbag_pack_info) do
				
			if tonumber(ship.ship_id) == tonumber(v.onUseShipId) then
				if -1 ~= tonumber(v.onUseIndex) then
					self.silkList[v.onUseIndex] = v.id	
				end
			end	
		end
	end
    if -1 == self.useIndex then
        for i=1,4 do
            local existFlag = self.silkList[i]
            if -1 ~= tonumber(existFlag) then
                self.useIndex = i
                break
            end
        end
    end
    
    if -1 == tonumber(self.useIndex) then
        self.useIndex = 2
    end

	self:onUpdateSilkBagListInfo()

	self:updateSilkBagRedPoint(tonumber(ship.ship_id), tonumber(ship.ship_template_id))
end

--刷新锦囊列表
function SilkBags:onUpdateSilkBagListInfo()
	local root = self.roots[1]
	local excluseSilkData = nil
	if self.Panel_effect_huyou ~= nil then
		self.Panel_effect_huyou:removeAllChildren(true)
		self.Panel_effect_huyou:setVisible(false)
	end
	for k,v in pairs(self.silkList) do
		if -1 ~= v then
			local Button_equipment_icon = nil
			if k >= 5 then 
				if excluseSilkData and SilkBagHandler.getSilkProtectOpen(excluseSilkData) then 
					local Panel_huyou = ccui.Helper:seekWidgetByName(root, "Panel_huyou_"..k)
					if Panel_huyou then 
						Panel_huyou:setVisible(true)
						self.Panel_effect_huyou:setVisible(true)
						self:playAnimations(self.Panel_effect_huyou,"images/ui/effice/effect_huyou/effect_huyou",true)
					end
					Button_equipment_icon = ccui.Helper:seekWidgetByName(root, "Panel_huyou_icon_"..k)
				end
			elseif k >= 2 then
				local Text_equipment_no = ccui.Helper:seekWidgetByName(root, "Text_equipment_no_"..(k-1)) --显示名字
				self:drawSilkName(Text_equipment_no,getSilkbagMouldByTemplateId(v).silkBagMouldId)
				Button_equipment_icon = ccui.Helper:seekWidgetByName(root, "Panel_equipment_icon_"..(k-1))
			else
				Button_equipment_icon = ccui.Helper:seekWidgetByName(root, "Panel_silk_special_icon")
				excluseSilkData = getSilkbagMouldByTemplateId(v)
			end
			if Button_equipment_icon then 
				Button_equipment_icon:removeAllChildren()
				self:drawSilkIcon(Button_equipment_icon,getSilkbagMouldByTemplateId(v).silkBagMouldId, k)
			end
		else
			if k >= 5 then
				-- 护佑状态
				if excluseSilkData and SilkBagHandler.getSilkProtectOpen(excluseSilkData) then 
					local Panel_huyou = ccui.Helper:seekWidgetByName(root, "Panel_huyou_"..k)
					if Panel_huyou then 
						Panel_huyou:setVisible(true)
						self.Panel_effect_huyou:setVisible(true)
						self:playAnimations(self.Panel_effect_huyou,"images/ui/effice/effect_huyou/effect_huyou",true)
					end
					local Image_add = ccui.Helper:seekWidgetByName(root, "Image_add_"..k)
					if Image_add then 
						Image_add:setVisible(true)
					end
				elseif excluseSilkData and SilkBagHandler.getSilkProtectLock(excluseSilkData) ~= nil and k <= SilkBagHandler.getSlotsNums() then 
					-- 锦囊等级不足,锁住护佑框
					local Panel_huyou = ccui.Helper:seekWidgetByName(root, "Panel_huyou_"..k)
					if Panel_huyou then 
						Panel_huyou:setVisible(true)
					end
					-- 显示锁住icon
					local Image_lcok = ccui.Helper:seekWidgetByName(root, "Image_lcok_"..k)
					if Image_lcok then 
						Image_lcok:setVisible(true)
					end
				end
			end
		end
	end

	if -1 ~= self.useIndex then
		--选中的锦囊
		self.useSilkTemporId = self.silkList[tonumber(self.useIndex)]

		if -1 ~= self.useSilkTemporId then
			self.useSilkId = getSilkbagMouldByTemplateId(self.useSilkTemporId).silkBagMouldId
		else
			self.useSilkId = -1
		end 
	end 
	self:selectBlink(self.useIndex)
	--刷新详细信息
	self:onUpdateSilkBagDetailInfo()
end

--刷新单个锦囊详细信息
function SilkBags:onUpdateSilkBagDetailInfo()

	local silkMouldId = self.useSilkId
    local silkTemporId = self.useSilkTemporId
	local root = self.roots[1]

	self.Panel_equipment_icon:removeAllChildren()
	-- 护佑开启提示
	if self.Text_infor_0_0 then 
		self.Text_infor_0_0:setVisible(false)
	end

	--锦囊基础属性
	for i=1,2 do
		local Text_attribute_t = ccui.Helper:seekWidgetByName(root, "Text_attribute_t_"..(i*i))
		Text_attribute_t:setVisible(false)
		local Image_silk_bag_attribute_bg = ccui.Helper:seekWidgetByName(root, "Image_silk_bag_attribute_bg_"..(i*i))
		Image_silk_bag_attribute_bg:setVisible(false)
	end

	-- 护佑属性
	if self.Text_attribute_t_1_0 then 
		self.Text_attribute_t_1_0:setVisible(false)
	end
	-- 护佑无特殊属性提示
	if self.Text_infor_0 then 
		self.Text_infor_0:setVisible(false)
	end

	-- 护佑未上阵显示
	if self.Text_equipment_huyou_no then 
		self.Text_equipment_huyou_no:setVisible(false)
	end
	if self.Text_equipment_no_1_0_0 then 
		self.Text_equipment_no_1_0_0:setVisible(false)
	end
	self.Image_no_have:setVisible(false)

	--专属技能
    self.Text_infor = ccui.Helper:seekWidgetByName(root, "Text_infor")
	self.Text_infor:setVisible(false)
	if self.Button_xiangqing then 
		self.Button_xiangqing:setVisible(false)
	end

	for i=1,5 do
		local Text_attribute_n = ccui.Helper:seekWidgetByName(root, "Text_attribute_n_"..i)
		Text_attribute_n:setVisible(false)
	end
	--重置经验道具
	for i=1,3 do
		local Panel_silk_icon=ccui.Helper:seekWidgetByName(root, "Panel_silk_icon_"..i)
		Panel_silk_icon:removeAllChildren(true)
		Panel_silk_icon:setVisible(false)
	end

    self.Button_silk_up_breake_img:setVisible(false)
    self.Button_silk_up_level_img:setVisible(true)

    self.ScrollView_infor:jumpToTop()
	--道具显示
	for i=1,3 do
		local Text_up_exp_n = ccui.Helper:seekWidgetByName(root, "Text_up_exp_n_"..i)
		Text_up_exp_n:setVisible(false)
		local Panel_silk_icon = ccui.Helper:seekWidgetByName(root, "Panel_silk_icon_"..i)
		Panel_silk_icon:setVisible(false)
	end
	self.Image_silk_max:setVisible(false)
	if -1 == silkMouldId then
		self.Text_silk_bag_name:setVisible(false)
		self.Text_silk_bag_breach_n:setString("0")
		self.Text_silk_bag_lv_n:setString("0")
		for i=1,5 do
			-- 基础属性
			local Text_attribute_n = ccui.Helper:seekWidgetByName(root, "Text_attribute_n_"..i)
			Text_attribute_n:setString("0")
		end
		self.Text_up_exp_n:setString("0")
        self.Text_up_exp_n:setVisible(true)
		self.Text_up_exp_all:setString("/".."0")
        self.Text_up_exp_all:setVisible(true)
        self.Text_up_exp_t:setString(tipStringInfo_rescue_silkbag[11])
        self.Text_consume_t:setString(tipStringInfo_rescue_silkbag[12])
        self.Text_consume_tip:setString(tipStringInfo_rescue_silkbag[14])
        self.Button_silk_up_sky:setVisible(false)
		self.Button_silk_up_substitution:setVisible(false)
		-- 护佑未上阵显示
		self.Image_no_have:setVisible(true)
		if self.Text_equipment_huyou_no then 
			if self.useIndex > 4  then 
				self.Text_equipment_huyou_no:setVisible(true)
			else
				self.Text_equipment_no_1_0_0:setVisible(true)
			end
		else
			if self.Text_equipment_no_1_0_0 then 
				self.Text_equipment_no_1_0_0:setVisible(true)
			end
		end

		local ship_config_prop = dms.string(dms["ship_config"],45,ship_config.param)
		local ship_config_info = zstring.split(ship_config_prop,"|")
		for i=1,table.nums(ship_config_info) do
			local Panel_silk_icon=ccui.Helper:seekWidgetByName(root, "Panel_silk_icon_"..i)
			local ship_config_info_per = zstring.split(ship_config_info[i],",")
			local cell = ResourcesIconCell:createCell()
			local haveNum = 0
			if fundPropWidthId(ship_config_info_per[2]) then
				haveNum = fundPropWidthId(ship_config_info_per[2]).prop_number
			end
			cell:init(ship_config_info_per[1],0,ship_config_info_per[2],nil,nil,true,true,0,nil)      
			Panel_silk_icon:addChild(cell)
			Panel_silk_icon:setVisible(true)
			local Text_up_exp_n = ccui.Helper:seekWidgetByName(root, "Text_up_exp_n_"..i)
			Text_up_exp_n:setColor(cc.c3b(127,127,127))
			Text_up_exp_n:setString(haveNum.."/".."0")
			Text_up_exp_n:setVisible(true)
			local Panel_silk_icon = ccui.Helper:seekWidgetByName(root, "Panel_silk_icon_"..i)
			Panel_silk_icon:setVisible(true)
		end
	else
		local isProtectType = self.useIndex > 4 and true or false
		local curSelectSilk = nil
		self.Button_silk_up_substitution:setVisible(true)
		-- 锦囊名称
		self:drawSilkName(self.Text_silk_bag_name,silkMouldId)
	    --锦囊图标
	    self:drawSilkIcon(self.Panel_equipment_icon,silkMouldId, self.useIndex)
	    -- 突破
	    local breakLevel = 0
	    --等级
	    local growLevel = 1
	    --当前经验
	    local curExp = 0
	    -- 基础属性
	    local baseProperty = nil
	    for k,v in pairs(_ED.silkbag_pack_info) do
	    	if tonumber(silkTemporId) == tonumber(v.id) then
	    		breakLevel = v.quality
	    		growLevel = v.level
	    		curExp = v.exp
				baseProperty = v.addBaseProperty
				curSelectSilk = v
	    		break
	    	end
	    end

		local add_property_info = zstring.split(baseProperty,"|")

		--基础属性
		for i=1,table.nums(add_property_info) do
			if 1 == i then
				if isProtectType then 
					-- 护佑属性
					if self.Text_attribute_t_1_0 then 
						self.Text_attribute_t_1_0:setVisible(true)
					end
				else
					-- 锦囊属性
					self.Text_attribute_t_1:setVisible(true)
				end
				
				local Image_silk_bag_attribute_bg = ccui.Helper:seekWidgetByName(root, "Image_silk_bag_attribute_bg_"..i)
				Image_silk_bag_attribute_bg:setVisible(true)
			end

			local Text_attribute_n = ccui.Helper:seekWidgetByName(root, "Text_attribute_n_"..i)
			local add_property_per = zstring.split(add_property_info[i],",")
			if nil ~= add_property_per then
				if isProtectType then 
					Text_attribute_n:setString(tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])].." "..add_property_per[2])
				else
					Text_attribute_n:setString(tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])].." "..add_property_per[2])
				end	
			end
			Text_attribute_n:setVisible(true)
		end
		--专属技能
		if not isProtectType then 
			local curPrectLv = SilkBagHandler.getProtectLv(curSelectSilk)
			local excluseSkillStr = SilkBagHandler.getExcluseSkill(silkMouldId,curPrectLv)
			
			if nil ~= excluseSkillStr then
				self.Text_infor:setString(excluseSkillStr)
				self.Text_infor:setVisible(true)
				if self.Button_xiangqing then 
					self.Button_xiangqing:setVisible(true)
				end
				-- 护佑开启提示
				local openInfo = dms.element(dms["ship_silk_bag_mould"],tonumber(silkMouldId))
				if openInfo then 
					local openConditionLv = openInfo[ship_silk_bag_mould.protect_open]
					if tostring(openConditionLv) ~= "-1" then 
						if self.Text_infor_0_0 then 
							self.Text_infor_0_0:setString(string.format(tipStringInfo_rescue_silkbag[24],openConditionLv))
							self.Text_infor_0_0:setVisible(true)
						end
					end
				end
			end
		end

		local extraGroups = dms.string(dms["ship_silk_bag_mould"],self.useSilkId,ship_silk_bag_mould.extra_property)
		local extra_property_info  = zstring.split(extraGroups,"|")
		if isProtectType then 
			-- 护佑不显示额外属性的提示
			if self.Text_infor_0 then 
				self.Text_infor_0:setVisible(true)
			end
		end
		if -1 ~= tonumber(extra_property_info[1]) and not isProtectType then
			--额外属性
			for i=1,table.nums(extra_property_info) do
				if 1 == i then
					local Text_attribute_t = ccui.Helper:seekWidgetByName(root, "Text_attribute_t_"..(i+3))
					Text_attribute_t:setVisible(true)
					local Image_silk_bag_attribute_bg = ccui.Helper:seekWidgetByName(root, "Image_silk_bag_attribute_bg_"..(i+3))
					Image_silk_bag_attribute_bg:setVisible(true)
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
		
		--突破
		local breakeLibId = dms.int(dms["ship_silk_bag_mould"],silkMouldId,ship_silk_bag_mould.breake_group) 
		local breakeLib =dms.searchs(dms["silk_bag_break_group_mould"],ship_silk_bag_breake.lib_id,breakeLibId,ship_silk_bag_breake.cur_breake_level,breakLevel)
		self.Text_silk_bag_breach_n:setString(breakLevel)

		--置换按钮显影
		local mouldType = dms.int(dms["ship_silk_bag_mould"],silkMouldId,ship_silk_bag_mould.exclusive_id)
		if -1 ~= mouldType then
			self.Button_silk_up_substitution:setVisible(false)
		else
			self.Button_silk_up_substitution:setVisible(true)
		end

		-- 等级
		local growLevelExp = 0
		local levelLibId = dms.int(dms["ship_silk_bag_mould"],silkMouldId,ship_silk_bag_mould.upgrade_group) 
		local levelLib =dms.searchs(dms["silk_bag_level_up_group_mould"],ship_silk_bag_level.lib_id,levelLibId)

		for k,v in pairs(levelLib) do
			local rangeLevel = zstring.split(v[ship_silk_bag_level.cur_level_range],",")

			if tonumber(growLevel) >= tonumber(rangeLevel[1]) and tonumber(growLevel) <= tonumber(rangeLevel[2]) then
				growLevelExp = levelLib[k][5]
				break
			end
			
		end

	    self.Text_silk_bag_lv_n:setString(growLevel)
		-- 当前拥有升级经验值
	   	self.Text_up_exp_n:setString(curExp)
		-- 升级经验总值
		self.Text_up_exp_all:setString("/"..growLevelExp)
		--处理经验道具
		local ship_config = nil
		local excute_type = nil
        local click_type = nil
        local max_level = self:getMaxLevelByDms()
        if nil ~= max_level then
            if tonumber(max_level) <= tonumber(growLevel) then --隐藏升级突破 满级了
                self.Text_up_exp_t:setString(tipStringInfo_rescue_silkbag[10])
                self.Button_silk_up_sky:setVisible(false)
                self.Text_up_exp_n:setVisible(false)
				self.Text_up_exp_all:setVisible(false)
				self.Image_silk_max:setVisible(true)

            else
                self.Button_silk_up_sky:setVisible(true)
                self.Text_up_exp_n:setVisible(true)
				self.Text_up_exp_all:setVisible(true)
				self.Image_silk_max:setVisible(false)
				
				if tonumber(growLevel) >= tonumber((breakLevel+1)*10) then --突破
					self.is_level_flag = false
                    self.Button_silk_up_level_img:setVisible(false)
                    self.Button_silk_up_breake_img:setVisible(true)
                    self.Text_up_exp_t:setString(tipStringInfo_rescue_silkbag[8])
                    self.Text_consume_t:setString(tipStringInfo_rescue_silkbag[13])
                    self.Text_consume_tip:setString(tipStringInfo_rescue_silkbag[15])
                    ship_config = breakeLib[1][ship_silk_bag_breake.breake_consume]
                    excute_type = "silk_bag_breake_consume"
					click_type = self.enum_type._TYPE_BREAKE

					local ship_config_info = zstring.split(ship_config,"|")
					for i=1,table.nums(ship_config_info) do
						local prop_type_config = zstring.split(ship_config_info[i],",")
						local curBreakeCousume = self:getBreakeConsumeByLevel(growLevel,silkMouldId,tonumber(prop_type_config[2]),breakLevel)
						local existNumber = tonumber(getPropAllCountByMouldId(curBreakeCousume.prop_type))
						local needNumber = tonumber(curBreakeCousume.prop_num)
						local Text_up_exp_n = ccui.Helper:seekWidgetByName(root, "Text_up_exp_n_"..i)
						Text_up_exp_n:setVisible(true)
						if existNumber >= needNumber then
							Text_up_exp_n:setColor(cc.c3b(40,197,15))
						else
							Text_up_exp_n:setColor(cc.c3b(127,127,127))
						end
						Text_up_exp_n:setString(existNumber.."/"..needNumber)
						local Panel_silk_icon = ccui.Helper:seekWidgetByName(root, "Panel_silk_icon_"..i)
						Panel_silk_icon:setVisible(true)
					end
					
				else                                                        --升级
					self.is_level_flag = true
                    self.Button_silk_up_level_img:setVisible(true)
                    self.Button_silk_up_breake_img:setVisible(false)
                    self.Text_up_exp_t:setString(tipStringInfo_rescue_silkbag[11])
                    self.Text_consume_t:setString(tipStringInfo_rescue_silkbag[12])
                    self.Text_consume_tip:setString(tipStringInfo_rescue_silkbag[14])
                    ship_config = dms.string(dms["ship_config"],45,4)
                    excute_type = "silk_bag_upgrade_consume"
					click_type = self.enum_type._TYPE_GROW_LEVEL

					local prop_ship_config_info = zstring.split(ship_config,"|")
					--道具数量显示
					local needExp = tonumber(SilkBagHandler.getExpByLevel(growLevel,silkMouldId)) - curExp
					for i=1,table.nums(prop_ship_config_info) do
						local prop_ship_config_info_per = zstring.split(prop_ship_config_info[i],",")
						local existNumber = tonumber(getPropAllCountByMouldId(prop_ship_config_info_per[2]))
						local expProvide = tonumber(prop_ship_config_info_per[3])
						local needNumber = math.ceil( needExp/expProvide )
						--道具显示
						local Text_up_exp_n = ccui.Helper:seekWidgetByName(root, "Text_up_exp_n_"..i)
						Text_up_exp_n:setVisible(true)
						if existNumber >= needNumber then
							Text_up_exp_n:setColor(cc.c3b(40,197,15))
						else
							Text_up_exp_n:setColor(cc.c3b(127,127,127))
						end
						Text_up_exp_n:setString(existNumber.."/"..needNumber)
					end
                end
                if nil ~= ship_config then
                    local ship_config_info = zstring.split(ship_config,"|")
                    for i=1,table.nums(ship_config_info) do
                        local Panel_silk_icon=ccui.Helper:seekWidgetByName(root, "Panel_silk_icon_"..i)
                        local ship_config_info_per = zstring.split(ship_config_info[i],",")
						local cell = ResourcesIconCell:createCell()
						
						local haveNum = 0
						if fundPropWidthId(ship_config_info_per[2]) then 
							haveNum = fundPropWidthId(ship_config_info_per[2]).prop_number
						end
                        cell:init(ship_config_info_per[1],0,ship_config_info_per[2],nil,nil,true,true,0,nil)      
                        Panel_silk_icon:addChild(cell)
                        Panel_silk_icon:setVisible(true)
						local Panel_silk_icon = ccui.Helper:seekWidgetByName(root, "Panel_silk_icon_"..i)
						Panel_silk_icon:setVisible(true)
                        local function addTouchListener(sender, eventType)
                            if eventType == ccui.TouchEventType.began then
                                if 0 >= tonumber(haveNum)  then
                                      
                                else
                                    local prop_id = ship_config_info_per[2]
                                    self.consume_prop_id = prop_id
                                    self.buyLevelCounts = 1
                                    self.click_time = 0
                                    self.click_start = true
                                end
                            elseif eventType == ccui.TouchEventType.moved then 
                                if "silk_bag_upgrade_consume" == tostring(excute_type)  then
                                    self.isItemMove = true
                                end

							elseif eventType == ccui.TouchEventType.ended then
								self.click_start = false 
								if 0 >= tonumber(haveNum)  then
                                    -- 弹道具不足
                                    function showConfirmTip(instance,n)

                                    end
                                    app.load("client.utils.ConfirmTip")
                                    local tip = ConfirmTip:new()
                                    tip:init(instance, showConfirmTip, tipStringInfo_rescue_silkbag[7])
                                    fwin:open(tip,fwin._ui)    
								else
									if "silk_bag_upgrade_consume" == tostring(excute_type) then
										
										self:onLevelAddCounts()
									else
										state_machine.excute(excute_type,0,{self.useSilkTemporId})
									end
								end
                                self._can_start_upgrage = true
                            end
                        end
                        self.Button_level_consume = Panel_silk_icon
                        Panel_silk_icon:addTouchEventListener(addTouchListener)
                    end
                    fwin:addTouchEventListener(self.Button_silk_up_sky, nil,
                    {
                        terminal_name = "silk_bag_one_click_grow_level",
                        terminal_state = 0,
                        m_index = click_type,
                        isPressedActionEnabled = true,
                    }, nil, 0)    
                end
            end
        end
	end
end

function SilkBags:onUpdate(dt)
    -- 长按升级按钮 自动升级
	if nil ~= self.Button_level_consume and true == self.click_start and self.is_level_flag then
        self.click_time = self.click_time + dt
        if self.click_time > 0.5 then 
			self.click_time = 0
            self:onLevelAddCounts()
        end 
    end
end

--升级长按处理
function SilkBags:onLevelAddCounts()
	if not self._can_start_upgrage then
		return
	end
	self._can_start_upgrage = false
    local max_level = self:getMaxLevelByDms()
    if nil ~= max_level  then
        if self.buyLevelCounts >= tonumber(max_level) then 
            return
        end

        local silk_tempor_id = self.useSilkTemporId
        local prop_id = self.consume_prop_id
        local prop_num = self.buyLevelCounts
        self.buyLevelCounts = 1
        state_machine.excute("silk_bag_upgrade_consume",0,{silk_tempor_id,prop_id,prop_num})
    end
end

--锦囊图标的绘制
function SilkBags:drawSilkIcon(node, silkMouldId, index)
	local cell= ResourcesIconCell:createCell()
	local property_info = dms.string(dms["ship_silk_bag_mould"],silkMouldId,ship_silk_bag_mould.base_property)
	local level = 0
	for k,v in pairs(_ED.silkbag_pack_info) do
		if tonumber(self.silkList[tonumber(index)]) == tonumber(v.id) then
			level = v.level
			property_info = v.addBaseProperty
			break
		end
	end
	
	local basePropertyList = {}
	if nil ~= property_info then
		local add_property_info = zstring.split(property_info,"|")
		for i = 1,table.nums(add_property_info) do
			local add_property_per = zstring.split(add_property_info[i],",")
			if nil ~= add_property_per then
				local a = tipStringInfo_rescue_silkbag_property["0"]
				local baseProperty ={}
				baseProperty.property_name = tipStringInfo_rescue_silkbag_property[tostring(add_property_per[1])]
				baseProperty.property_value = add_property_per[2]
				basePropertyList[i] = baseProperty
			end
		end
	end

	cell:init(71,-1,silkMouldId,nil,nil,true,true,0,{basePropertyList,level})
	node:addChild(cell)
end

--锦囊名称设置
function SilkBags:drawSilkName(node,silkMouldId)
	local silkbag_name_id = dms.int(dms["ship_silk_bag_mould"],silkMouldId,ship_silk_bag_mould.silkbag_name)
	local silkbag_name_word = dms.element(dms["word_mould"], silkbag_name_id)
	local name = silkbag_name_word[3]
	node:setString(name)
	node:setVisible(true)
end

--设置宠物高亮
function SilkBags:setIndex(cell)
	if self.lastcell ~= nil and self.lastcell.setSelected ~= nil then
		self.lastcell.ishow = false
		self.lastcell:setSelected(false)
	end
	cell:setSelected(true)
	cell.ishow = true
	self.lastcell = cell
end

--弹无锦囊提示
function SilkBags:openConfirmTip()
	function showConfirmTip(instance,n)

	end
	app.load("client.utils.ConfirmTip")
	local tip = ConfirmTip:new()
	tip:init(instance, showConfirmTip, tipStringInfo_rescue_silkbag[1])
	fwin:open(tip,fwin._ui)
end

--判断是否有专属锦囊
function SilkBags:getHaveExclusive()
	for k,v in pairs(_ED.silkbag_pack_info) do
		local mouldType = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.exclusive_id)
		local mType = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.mould_type)

		if -1 ~= mouldType and 2 == mType then
			if tonumber(self.ship.ship_base_template_id) == tonumber(mouldType) and -1 == tonumber(v.onUseIndex) then
				self._exclusive_mould_id = mouldType
				return true
			end
		end
	end
	return false
end

--解析置换需要的道具
function SilkBags:setPropForDisplace()
	if nil == self.displace_config_info then
		self.displace_config_info = {}
		local displaceConfig = dms.string(dms["ship_config"],46,4)
		if nil == displaceConfig then
			return
		end

		local group = zstring.split(displaceConfig,"@")
		for k,v in pairs(group) do
			local temps = zstring.split(v,",")
			if nil ~= temps then
				local quality_propType = zstring.split(temps[1],":")
				local per_data = {}
				per_data.quality_type = quality_propType[1]
				per_data.prop_type = quality_propType[2]
				per_data.prop_id = temps[2]
				per_data.need_num = temps[3]
				self.displace_config_info[k] = per_data
			end
		end
	end
end

-- 护佑动画播放
function SilkBags:playAnimations(sender, file, loop)
    sender:removeAllChildren()
    local jsonFile = file .. ".json"
    local atlasFile = file .. ".atlas"
    local aniName = "animation"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, aniName, loop, nil)
	animation:setPosition(cc.p(sender:getContentSize().width / 2, sender:getContentSize().height / 2))
    sender:addChild(animation)
end

--获得置换道具模版
function SilkBags:getDisplacePropMould()
	local silkQuality = dms.int(dms["ship_silk_bag_mould"],tonumber(self.useSilkId),ship_silk_bag_mould.quality_level)
	local displace_config_info = self.displace_config_info

	for k,v in pairs(displace_config_info) do
		if tonumber(silkQuality) == tonumber(v.quality_type)  then
			return v
		end
	end
	return nil
end

--获取对应品质最大等级
function SilkBags:getMaxLevelByDms()
    if -1 ~= tonumber(self.useSilkId) then
        local quality = dms.int(dms["ship_silk_bag_mould"], self.useSilkId,ship_silk_bag_mould.quality_level)
        local shipConfig = dms.string(dms["ship_config"],44,4)
        local infoGroups = zstring.split(shipConfig,"|")
        for k,v in pairs(infoGroups) do
            local info = zstring.split(v,",")
            if tonumber(quality) == tonumber(info[1]) then
                local maxLevel = tonumber(info[2])
                return maxLevel
            end
        end
    end
    return nil
end



--根据等级获取突破道具数量
function SilkBags:getBreakeConsumeByLevel(curLevel,silkMouldId,propId,breakeLevel)
    local breakeInfo = {}

    local breakeLibId = dms.int(dms["ship_silk_bag_mould"],silkMouldId,ship_silk_bag_mould.breake_group) 
    local breakeLib =dms.searchs(dms["silk_bag_break_group_mould"],ship_silk_bag_breake.lib_id,breakeLibId,ship_silk_bag_breake.cur_breake_level,breakeLevel)

    local shipConfig = breakeLib[1][ship_silk_bag_breake.breake_consume]
    local shipConfigInfo = zstring.split(shipConfig,",")
    if -1 ~= tonumber(shipConfigInfo[1]) then
        breakeInfo.prop_id = shipConfigInfo[1]
        breakeInfo.prop_type = shipConfigInfo[2]
		breakeInfo.prop_num = shipConfigInfo[3]
		return breakeInfo
	end
	
    return nil
end

function SilkBags:selectBlink(useIndex)
	local root = self.roots[1]
	for i=1,SilkBagHandler.getSlotsNums() do
		if i > 4 then 
			local Image_choose = ccui.Helper:seekWidgetByName(root, "Image_choose_"..i)
			Image_choose:setVisible(false)
		else
			local Image_select = ccui.Helper:seekWidgetByName(root, "image_xuankuang_"..i)
			Image_select:setVisible(false)
		end
	end
	if useIndex > 4 then 
		local Image_choose = ccui.Helper:seekWidgetByName(root, "Image_choose_"..useIndex)
		Image_choose:setVisible(true)
	else
		local Image_select = ccui.Helper:seekWidgetByName(root, "image_xuankuang_"..useIndex)
		Image_select:setVisible(true)
	end
	
end


function SilkBags:onUpdateDraw()
    local root = self.roots[1]
    
    -- 锦囊名称
    self.Text_silk_bag_name = ccui.Helper:seekWidgetByName(root, "Text_silk_bag_name")
    --锦囊图标
    self.Panel_equipment_icon = ccui.Helper:seekWidgetByName(root, "Panel_equipment_icon")
    --突破
    self.Text_silk_bag_breach_n = ccui.Helper:seekWidgetByName(root, "Text_silk_bag_breach_n")
    --专属技能
    self.Text_infor = ccui.Helper:seekWidgetByName(root, "Text_infor")
    --等级
    self.Text_silk_bag_lv_n = ccui.Helper:seekWidgetByName(root, "Text_silk_bag_lv_n")
    --升级经验文本 
    self.Text_up_exp_t = ccui.Helper:seekWidgetByName(root, "Text_up_exp_t")
    --当前经验
    self.Text_up_exp_n = ccui.Helper:seekWidgetByName(root, "Text_up_exp_n")
    --总经验
    self.Text_up_exp_all = ccui.Helper:seekWidgetByName(root, "Text_up_exp_all")
    --升级消耗文本 
    self.Text_consume_t = ccui.Helper:seekWidgetByName(root, "Text_consume_t")
    --升级描述
    self.Text_consume_tip = ccui.Helper:seekWidgetByName(root, "Text_consume_tip")
    -- 突破&一键升级按钮
    self.Button_silk_up_sky = ccui.Helper:seekWidgetByName(root, "Button_silk_up_sky")
    --突破按钮图片
    self.Button_silk_up_breake_img = self.Button_silk_up_sky:getChildByName("Image_tupo")
    --一键升级图片
    self.Button_silk_up_level_img = self.Button_silk_up_sky:getChildByName("Image_76_1")
    --置换
    self.Button_silk_up_substitution = ccui.Helper:seekWidgetByName(root, "Button_silk_up_substitution")
    --描述ScrollView
	self.ScrollView_infor = ccui.Helper:seekWidgetByName(root, "ScrollView_infor")
	--无锦囊盖层
	self.Image_no_have = ccui.Helper:seekWidgetByName(root, "Image_22_1_1")
	--满级底图
	self.Image_silk_max = ccui.Helper:seekWidgetByName(root, "Image_silk_max")

	--专属底图
	self.Image_one = ccui.Helper:seekWidgetByName(root, "Image_41")
	-- 未上阵护佑标题
	self.Text_equipment_huyou_no = ccui.Helper:seekWidgetByName(root, "Text_equipment_huyou_no")
	-- 未上阵锦囊标题
	self.Text_equipment_no_1_0_0 = ccui.Helper:seekWidgetByName(root, "Text_equipment_no_1_0_0")
	-- 护佑标题 
	self.Text_attribute_t_1_0 = ccui.Helper:seekWidgetByName(root, "Text_attribute_t_1_0") 
	-- 基础属性标题
	self.Text_attribute_t_1 = ccui.Helper:seekWidgetByName(root, "Text_attribute_t_1") 
	-- 护佑无额外属性提示
	self.Text_infor_0 = ccui.Helper:seekWidgetByName(root, "Text_infor_0") 
	-- 护佑动画控件
	self.Panel_effect_huyou = ccui.Helper:seekWidgetByName(root, "Panel_effect_huyou") 
	-- 护佑开启条件显示
	self.Text_infor_0_0 = ccui.Helper:seekWidgetByName(root, "Text_infor_0_0")
end

function SilkBags:onEnterTransitionFinish()
	-- 加载SilkBagWindow界面资源.
	-- res.cultivate.silk_bag = res/cultivate/silk_bag.csb
	local csbNode = csb.createNode("cultivate/silk_bag.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 装备锦囊交互层
	for i=1,3 do
		self.Panel_equipment_icon_box = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_equipment_icon_box_"..i), nil,
		{
			terminal_name = "silk_bag_equip_features",
			terminal_state = 0,
			m_index = (i+1),
			isPressedActionEnabled = true,
		}, nil, 0)
	end

	-- 装备专属锦囊
	self.Panel_silk_special_icon = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_silk_special_icon"), nil,
	{
		terminal_name = "silk_bag_equip_features",
		terminal_state = 0,
		m_index = 1,
		isPressedActionEnabled = true,
	}, nil, 0)

	-- 装备护佑锦囊
	for i=5,8 do
		local Panel_huyou_icon = ccui.Helper:seekWidgetByName(root, "Panel_huyou_icon_"..i)
		if Panel_huyou_icon then 
			fwin:addTouchEventListener(Panel_huyou_icon, nil,
			{
				terminal_name = "silk_bag_equip_features",
				terminal_state = 0,
				m_index = i,
				isPressedActionEnabled = true,
			}, nil, 0)
		end
	end

	-- 批量分解
	local Button_fenjie = ccui.Helper:seekWidgetByName(root, "Button_fenjie")
	if Button_fenjie then 
		fwin:addTouchEventListener(Button_fenjie, nil,
		{
			terminal_name = "silk_bag_fast_resolve",
			terminal_state = 0,
			isPressedActionEnabled = true,
		}, nil, 0)
	end

	-- 属性详情
	self.Button_xiangqing = ccui.Helper:seekWidgetByName(root, "Button_xiangqing")
	if self.Button_xiangqing then 
		fwin:addTouchEventListener(self.Button_xiangqing, nil,
		{
			terminal_name = "silk_bag_goto_protect_talent",
			terminal_state = 0,
			isPressedActionEnabled = true,
		}, nil, 0)
	end
	

	-- 卸下
	self.Button_silk_down = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_silk_down"), nil,
	{
		terminal_name = "silk_bag_unload_equip",
		terminal_state = 0,
		b_index = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 更换
	self.Button_silk_change = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_silk_change"), nil,
	{
		terminal_name = "silk_bag_equip_features",
		terminal_state = 0,
		m_index = 11,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 置换
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_silk_up_substitution"), nil,
    	{
    		terminal_name = "silk_bag_displace",
    		terminal_state = 0,
    		silk_tempor_id = self.useSilkTemporId,
    		isPressedActionEnabled = true,
    	}, nil, 0)	

	-- 关闭
	self.Button_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil,
	{
		terminal_name = "silk_bag_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	
	-- 帮助
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_alloy_help1"), nil,
	{
		terminal_name = "silkbaghelp_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

    self:onUpdateDraw()
	self:setPropForDisplace()
	self:drawHeroIcon()
end

function SilkBags:onExit()
	app.unload("client.l_digital.cultivate.silkbag.SilkBagHandler")
	-- 释放SilkBagWindow界面资源.
	state_machine.remove("silk_bag_open")
	state_machine.remove("silk_bag_close")
	state_machine.remove("silk_bag_show")
	state_machine.remove("silk_bag_hide")
	state_machine.remove("silk_bag_hero_info")
	state_machine.remove("silk_bag_equip_features")
	state_machine.remove("silk_bag_page_strength_to_highlighted")
	state_machine.remove("silk_bag_listview_first_set_index")
	state_machine.remove("silk_bag_upgrade_consume_terminal")
	state_machine.remove("silk_bag_unload_equip")
	state_machine.remove("silk_bag_load_equip")
	state_machine.remove("silk_bag_breake_consume")
	state_machine.remove("silk_bag_displace")
	state_machine.remove("silk_bag_switch_choose")
	state_machine.remove("silk_bag_one_click_grow_level")
	state_machine.remove("silk_bag_info_refresh")
	state_machine.remove("silk_bag_goto_protect_talent")
	state_machine.remove("silk_bag_fast_resolve")
end

function SilkBags:close()
	-- window event : close.
	
end

function SilkBags:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
