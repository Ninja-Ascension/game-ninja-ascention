-- ----------------------------------------------------------------------------------------------------
-- 说明：数码活动成就类型cell
-------------------------------------------------------------------------------------------------------
AdventureTaskCell = class("AdventureTaskCellClass", Window)
    
function AdventureTaskCell:ctor()
    self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.activity.adventure.AdventureTaskWindow")
	app.load("client.activity.adventure.AdventureWindow")
	self.example = nil
	self.index = 0
	self.activityType = 0
	self.rewardState = 0

	self.reworld_sorting = {}
    -- Initialize AdventureTaskCell state machine.
    local function init_AdventureTaskCell_terminal()
		
		--领取
		local adventure_task_cell_reward_terminal = {
            _name = "adventure_task_cell_reward",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					local index = params._datas._index
					local tempCell = params._datas._cell
					local function responseGetServerListCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								local getRewardWnd = DrawRareReward:new()
								getRewardWnd:init(7, nil, response.node.reworld_sorting)
								fwin:open(getRewardWnd, fwin._ui)
								state_machine.excute("adventure_task_window_onUpdate_data", 0, "")
								state_machine.excute("adventure_dice_num_update", 0, "")
							end
						end
					end
					local activityId = _ED.active_activity[153].activity_id	
					protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(index)-1).."\r\n1"
					NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, tempCell, responseGetServerListCallback, false, nil)
					return true
				end
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 前往
        local adventure_task_cell_go_to_terminal = {
            _name = "adventure_task_cell_go_to",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas._cell
            	local index = params._datas._index
            	local trace_id = 0
            	local activity_info = _ED.active_activity[153].activity_Info
    			local achieve_id 	= tonumber(zstring.split(activity_info[index].activityInfo_need_day, ",")[1])
    			trace_id 			= tonumber(dms.string(dms["achieve"], achieve_id, achieve.track_address))
        		if trace_id > 0 then
        			state_machine.excute("shortcut_function_trace", 0, {trace_function_id = trace_id, _datas = {}})
        		end
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(adventure_task_cell_reward_terminal)
        state_machine.add(adventure_task_cell_go_to_terminal)
        state_machine.init()
    end
    
    -- call func init AdventureTaskCell state machine.
    init_AdventureTaskCell_terminal()
end

function AdventureTaskCell:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[153]
	local other_info = zstring.split(activity.activity_params ,"|")
	local activity_params = other_info[1]
	local titleListText = ccui.Helper:seekWidgetByName(root, "Text_task_01")
	local tipProperty = tipStringInfo_activity_local_data_property[""..153]
	if tipProperty then
		local infoId = zstring.split(self.example.activityInfo_need_day,",")
		local activityId = tonumber(infoId[1])
		local activityValue = tonumber(infoId[2])
		local str = dms.string(dms["achieve"],activityId,achieve.title)
		local strSub = zstring.split(str,"%d")
		local length = table.nums(strSub)
		if activityValue >= 10000 and activityId == 732 then
			activityValue = math.ceil( activityValue/10000 )
		end
		tipProperty = strSub[1]..tostring(activityValue)..strSub[length]
	else
		tipProperty = self.example.activityInfo_name
	end
	titleListText:setString(tipProperty)
	local scheduleText = ccui.Helper:seekWidgetByName(root, "Text_task_ing")

	other_info = other_info[self.index]
	scheduleText:setString(zstring.split(other_info, ",")[2].."/"..zstring.split(self.example.activityInfo_need_day, ",")[2])
	
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_task_lq") 	 	-- 领取	
	local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_task_qw") 		-- 前往
	local Image_50 = ccui.Helper:seekWidgetByName(root, "Image_50") 		-- 已领取
	GetButton:setTouchEnabled(true)
	GetButton:setVisible(false)
	Button_13:setVisible(false)
	Image_50:setVisible(false)
	scheduleText:setVisible(true)
	local isComplete = 0
	local max = 0
	isComplete = tonumber(zstring.split(other_info, ",")[2])
	max = tonumber(zstring.split(self.example.activityInfo_need_day, ",")[2])

	if isComplete < max then
		self.rewardState = 0
		Button_13:setVisible(true)
	elseif tonumber(self.example.activityInfo_isReward) == 0 then
		self.rewardState = 1
		GetButton:setVisible(true)
		scheduleText:setString("")
	else
		self.rewardState = 2
		Image_50:setVisible(true)
		scheduleText:setString("")
	end
end

function AdventureTaskCell:updateRewardInfo( ... )
	local root = self.roots[1]
	local activity = _ED.active_activity[self.activityType]
	local addCount = 0
	local Panel_task_frame = ccui.Helper:seekWidgetByName(root, "Panel_task_frame")
	local Text_task_05 = ccui.Helper:seekWidgetByName(root, "Text_task_05")
	Panel_task_frame:removeAllChildren(true)

	local index = 1
	local cell = nil
	if tonumber(activity.activity_Info[self.index].activityInfo_prop_count) > 0 then--可领取道具种类数量
		for n, v in pairs(activity.activity_Info[self.index].activityInfo_prop_info) do
	        local cell = ResourcesIconCell:createCell()
	        cell:init(6, tonumber(v.propMouldCount), v.propMould,nil,nil,true,true)
	        local rewardinfo = {}
	        rewardinfo.type = 6
	        rewardinfo.id = v.propMould
	        rewardinfo.number = tonumber(v.propMouldCount)
	        addCount = tonumber(v.propMouldCount)
	        self.reworld_sorting[index] = rewardinfo
	        index = index + 1
		end
	end

	local otherRewards = zstring.splits(activity.activity_Info[self.index].activityInfo_reward_select, "|", ",")
    if #otherRewards > 0 then
        for i, v in pairs(otherRewards) do
            -- 类型、ID、数量、星级
            if #v >= 3 then
                cell = ResourcesIconCell:createCell()
                local rewardType = tonumber(v[1])
                if 13 == rewardType then
                    local table = {}
                    if v[4] ~= nil and tonumber(v[4]) ~= -1 then
                        table.shipStar = tonumber(v[4])
                    end
                    cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1,table)
                    local ships = fundShipWidthTemplateId(tonumber(v[2]))
                    if ships == nil then
                        local rewardinfo = {}
                        rewardinfo.type = rewardType
                        rewardinfo.id = tonumber(v[2])
                        rewardinfo.number = tonumber(v[3])
                        self.reworld_sorting[index] = rewardinfo
                        index = index + 1
                    else
                        local prop_mlds = dms.int(dms["ship_mould"], tonumber(v[2]), ship_mould.fitSkillOne)
                        local number_info = zstring.split(dms.string(dms["ship_config"], 13, ship_config.param),"!")[tonumber(v[4])]
                        local ability = dms.int(dms["ship_mould"], tonumber(v[2]), ship_mould.ability)
                        local number_data = zstring.split(number_info,"|")[ability-13+1]
                        local m_number = tonumber(zstring.split(number_data,",")[2])
                        local rewardinfo = {}
                        rewardinfo.type = 6
                        rewardinfo.id = prop_mlds
                        rewardinfo.number = m_number
                        self.reworld_sorting[index] = rewardinfo
                        index = index + 1
                    end
                elseif 18 == rewardType then
                    cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1)
                    local rewardinfo = {}
			        rewardinfo.type = rewardType
			        rewardinfo.id = tonumber(v[2])
			        rewardinfo.number = tonumber(v[3])
			        self.reworld_sorting[index] = rewardinfo
			        index = index + 1
                else
                    cell:init(rewardType, tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,1)
                    local rewardinfo = {}
			        rewardinfo.type = rewardType
			        rewardinfo.id = tonumber(v[2])
			        rewardinfo.number = tonumber(v[3])
			        addCount = tonumber(v[3])
			        self.reworld_sorting[index] = rewardinfo
			        index = index + 1
                end
            end
        end
    end

    Panel_task_frame:addChild(cell)
    Text_task_05:setString("+" .. addCount)
end

function AdventureTaskCell:onEnterTransitionFinish()

end

function AdventureTaskCell:onInit()
	local root = cacher.createUIRef("activity/adventure/adv_task_buy_list.csb", "root")
    table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	
	self:setContentSize(root:getChildByName("Image_37"):getContentSize())
	state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.AccumlateConsumption)
	
	self:onUpdateDraw()
	self:updateRewardInfo()
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_lq"), nil, 
		{
			terminal_name = "adventure_task_cell_reward", 
			terminal_state = 0, 
			_index = self.index,
			_cell = self,			
			isPressedActionEnabled = true
		},
		nil,0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_task_qw"), nil, 
	{
		terminal_name = "adventure_task_cell_go_to", 
		terminal_state = 0, 
		_index = self.index,
		_cell = self,			
		isPressedActionEnabled = true
	},
	nil,0)
end

function AdventureTaskCell:clearUIInfo( ... )
    local root = self.roots[1]
	local Panel_task_frame = ccui.Helper:seekWidgetByName(root, "Panel_task_frame")
	if Panel_task_frame ~= nil then
		Panel_task_frame:removeAllChildren(true)
	end
	local Button_task_qw = ccui.Helper:seekWidgetByName(root, "Button_task_qw")
	local Button_task_lq = ccui.Helper:seekWidgetByName(root, "Button_task_lq")
	local Button_task_lq = ccui.Helper:seekWidgetByName(root, "Button_task_lq")
	local Text_task_01 = ccui.Helper:seekWidgetByName(root, "Text_task_01")
	if Button_task_qw ~= nil then
		Button_task_qw:setVisible(true)
		Button_task_lq:setVisible(false)
		Text_task_01:setVisible(true)
		Text_task_01:setString("")
	end
end

function AdventureTaskCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/adventure/adv_task_buy_list.csb", self.roots[1])
end

function AdventureTaskCell:init(example,index,activityType)
	self.example = example
	self.index = index
	self.activityType = activityType
	self:onInit()
end

function AdventureTaskCell:createCell()
	local cell = AdventureTaskCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end