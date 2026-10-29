-- ----------------------------------------------------------------------------------------------------
-- 说明：跳转或领取
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
AccumlateGotoCell = class("AccumlateGotoCellClass", Window)
    
function AccumlateGotoCell:ctor()
    self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	self.example = nil
	self.index = 0
	self.typeIndex = 0
    -- Initialize AccumlateGotoCell state machine.
    local function init_AccumlateGotoCell_terminal()
		--去跳转
        local go_to_accumlate_button_terminal = {
            _name = "accumlate_go_to_page_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local typeIndex = params._datas._typeIndex
				if typeIndex == 47 or typeIndex == 66 or typeIndex == 67 then 
				
					local isOpen_worldboss = tonumber(_ED.user_info.user_grade) >= dms.int(dms["fun_open_condition"], 12, fun_open_condition.level)
	
					if false == isOpen_worldboss then
					
						TipDlg.drawTextDailog( dms.string(dms["fun_open_condition"], 12, fun_open_condition.tip_info))
						return
					end
				
				
					app.load("client.campaign.worldboss.WorldBoss")
					local function recruitCallBack(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							-- fwin:cleanView(fwin._view) 
							-- fwin:open(WorldBoss:new(), fwin._view)	
							fwin:removeAll()
							app.load("client.home.Menu")
							fwin:open(WorldBoss:new(), fwin._view)	
							fwin:open(Menu:new(), fwin._taskbar)
							-- if fwin:find("MenuClass") == nil then
								-- fwin:open(Menu:new(), fwin._taskbar)
							-- end
							-- state_machine.excute("menu_manager", 0, 
								-- {
									-- _datas = {
										-- terminal_name = "menu_manager", 	
										-- next_terminal_name = "menu_show_campaign", 		
										-- current_button_name = "Button_activity", 		
										-- but_image = "Image_activity",	
										-- terminal_state = 0, 
										-- isPressedActionEnabled = true
									-- }
								-- }
							-- )
					
							-- fwin:open(WorldBoss:new(), fwin._view) 
						end
					end
					NetworkManager:register(protocol_command.rebel_army_init.code, nil, nil, nil, nil, recruitCallBack, false, nil)

				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--领取
		local get_accumlate_button_terminal = {
            _name = "accumlate_get_accumlate_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					local typeIndex = params._datas._typeIndex
					local index = params._datas._index
					local mCell = params._datas._cell
					local _replyPhysical = params._datas.replyPhysical
					local param = params._datas
					local function responseGetServerListCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							response.node._cell:rewadDraw(response.node._index)
						end
					end

					local activityId = _ED.active_activity[typeIndex].activity_id
					if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
						protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(index)-1).."\r\n".."1"
					else	
						protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(index)-1).."\r\n1"
					end	
					NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, param, responseGetServerListCallback, false, nil)
					return true
				end
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(go_to_accumlate_button_terminal)
        state_machine.add(get_accumlate_button_terminal)
        state_machine.init()
    end
    
    -- call func init AccumlateGotoCell state machine.
    init_AccumlateGotoCell_terminal()
end

function AccumlateGotoCell:rewadDraw(_index)
	local root = self.roots[1]
	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(7)
	fwin:open(getRewardWnd,fwin._ui)
	local activity = _ED.active_activity[self.typeIndex]
	
	if self.typeIndex == 47 then
		activity.activity_Info[_index].activityInfo_isReward = 1
	end
	if self.typeIndex == 66 or self.typeIndex == 67 then
		activity.activity_Info[_index].activityInfo_isReward = 1
	end
	
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12")
	local hasGetButton = ccui.Helper:seekWidgetByName(root, "Image_13") -- 已领取
	if tonumber(activity.activity_Info[_index].activityInfo_isReward) == 1 then--DOTO	明明满足条件了。
		GetButton:setBright(false)
		GetButton:setTouchEnabled(false)
		GetButton:setVisible(false)
		hasGetButton:setVisible(true)
	end
end


function AccumlateGotoCell:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.typeIndex]
	
	local titleListText = ccui.Helper:seekWidgetByName(root, "Text_11")
	
	local scheduleText = ccui.Helper:seekWidgetByName(root, "Text_13")

	local str = ""
	if self.typeIndex == 47 then
		str = string.format(_tip_info_activity[47][3][self.example.activityInfo_rebelArmyType+1],self.example.activityInfo_need)
	end
	if self.typeIndex == 66 or self.typeIndex == 67 then
		str = string.format(_tip_info_activity[self.typeIndex][3],self.example.activityInfo_need)
	end
	
	titleListText:setString(str)

	scheduleText:setString(activity.total_recharge_count.."/"..self.example.activityInfo_need)

	local rechargeButton = ccui.Helper:seekWidgetByName(root, "Button_11") -- 充值
	local getButton = ccui.Helper:seekWidgetByName(root, "Button_12") -- 领取
	local gotoButton = ccui.Helper:seekWidgetByName(root, "Button_13") -- 跳转
	local hasGetButton = ccui.Helper:seekWidgetByName(root, "Image_13") -- 已领取
	getButton:setVisible(false)
	rechargeButton:setVisible(false)
	gotoButton:setVisible(false)
	hasGetButton:setVisible(false)
	-- -1 未达成
	-- 0 可领取
	-- 1 不可领取
	if tonumber(self.example.activityInfo_isReward) < 0 then
		gotoButton:setVisible(true)
		
	elseif tonumber(self.example.activityInfo_isReward) == 0 then
		getButton:setVisible(true)
	else
		--gotoButton:setVisible(true)
		-- rechargeButton:setVisible(false)
		getButton:setVisible(false)
		getButton:setBright(false)
		getButton:setTouchEnabled(false)
		hasGetButton:setVisible(true)
	end
	
end

function AccumlateGotoCell:updateRewardInfo( ... )
	local root = self.roots[1]
	local activity = _ED.active_activity[self.typeIndex]

	local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_11")
	ListViewDraw:removeAllItems()
	if tonumber(activity.activity_Info[self.index].activityInfo_silver) > 0 then--可领取银币数量
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 1, item_value = activity.activity_Info[self.index].activityInfo_silver}}})
		-- ListViewDraw:addChild(cell)
		local cell = propMoneyIcon:createCell()
		cell:init("1",activity.activity_Info[self.index].activityInfo_silver,nil)
		ListViewDraw:addChild(cell)
		
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_gold) > 0 then--奖励1可领取金币数量
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 2, item_value = activity.activity_Info[self.index].activityInfo_gold}}})
		-- ListViewDraw:addChild(cell)
		local cell = propMoneyIcon:createCell()
		cell:init("2",activity.activity_Info[self.index].activityInfo_gold,nil)
		ListViewDraw:addChild(cell)
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_food) > 0 then--奖励1可领取体力数量
		local cell = ResourcesIconCell:createCell()
		cell:init(0, 0, 0, {show_reward_list={{prop_type = 12, item_value = activity.activity_Info[self.index].activityInfo_food}}})
		ListViewDraw:addChild(cell)
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_honour) > 0 then--奖励1可领取声望数量
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 3, item_value = activity.activity_Info[self.index].activityInfo_honour}}})
		-- ListViewDraw:addChild(cell)
		local cell = propMoneyIcon:createCell()
		cell:init("3",activity.activity_Info[self.index].activityInfo_honour,nil)
		ListViewDraw:addChild(cell)
	end

	if tonumber(activity.activity_Info[self.index].activityInfo_equip_count) > 0 then	--可领取装备种类数量
		for n, v in pairs(activity.activity_Info[self.index].activityInfo_equip_info) do
			-- local cell = ResourcesIconCell:createCell()
			-- cell:init(cell.enum_type.EQUIPMENT_INFORMATION, v.equipMouldCount, v.equipMould, nil)
			-- ListViewDraw:addChild(cell)
			local cell = EquipIconCell:createCell()
			cell:init(10, nil, v.equipMould, nil, nil, v.equipMouldCount)
			ListViewDraw:addChild(cell)
		end
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_general_soul) > 0 then	--可领取水雷魂种类数量
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(cell.enum_type.EQUIPMENT_INFORMATION, v.equipMouldCount, v.equipMould, nil)
		-- ListViewDraw:addChild(cell)
		local cell = propMoneyIcon:createCell()
		cell:init("5",zstring.tonumber(activity.activity_Info[self.index].activityInfo_general_soul), nil)
		ListViewDraw:addChild(cell)
	end
	if tonumber(activity.activity_Info[self.index].activityInfo_prop_count) > 0 then--可领取道具种类数量
		for n, v in pairs(activity.activity_Info[self.index].activityInfo_prop_info) do
			-- local cell = ResourcesIconCell:createCell()
			-- cell:init(cell.enum_type.PROP_INFORMATION, v.propMouldCount, v.propMould, nil)
			-- ListViewDraw:addChild(cell)
			-- local cell = PropIconCell:createCell()
			-- cell:init(26, v.propMould,v.propMouldCount)
			local cell = self:getItemCell(v.propMould,nil,v.propMouldCount)
			ListViewDraw:addChild(cell)
		end
	end
	
	if zstring.tonumber(activity.activity_Info[self.index].activityInfo_general_exploit) > 0 then	--可领取战功种类数量
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(cell.enum_type.EQUIPMENT_INFORMATION, v.equipMouldCount, v.equipMould, nil)
		-- ListViewDraw:addChild(cell)
		local cell = propMoneyIcon:createCell()
		cell:init("7",zstring.tonumber(activity.activity_Info[self.index].activityInfo_general_exploit), nil)
		ListViewDraw:addChild(cell)
	end
	ListViewDraw:requestRefreshView()
	
end

--道具
function AccumlateGotoCell:getItemCell(mid,mtype,count,isCertainly)
	app.load("client.cells.prop.model_prop_icon_cell")
	local cell = ModelPropIconCell:createCell()
	local cellConfig = cell:createConfig()
	cellConfig.mouldId = mid
	cellConfig.isShowName = false
	cellConfig.isDebris = true
	cellConfig.mouldType = mtype
	cellConfig.touchShowType = 1
	cellConfig.count = count
	cellConfig.isCertainly = isCertainly
	cell:init(cellConfig)
	return cell
end
function AccumlateGotoCell:onEnterTransitionFinish()
	local csbAccumlateGotoCell = csb.createNode("activity/wonderful/landed_gifts_list.csb")
    local root = csbAccumlateGotoCell:getChildByName("root")
    table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	
	self:setContentSize(root:getChildByName("Panel_land_list"):getContentSize())
	state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.AccumlateRechargeable)
	-- 列表控件动画播放
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local action = csb.createTimeline("activity/wonderful/landed_gifts_list.csb")
	    root:runAction(action)
	    action:play("list_view_cell_open", false)
	end
	
	self:onUpdateDraw()
	self:updateRewardInfo()
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
 --    cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
    
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_13"), nil, 
		{
			terminal_name = "accumlate_go_to_page_button", 
			terminal_state = 0, 
			isPressedActionEnabled = true,
			_typeIndex = self.typeIndex,	
		},
		nil,0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"), nil, 
		{
			terminal_name = "accumlate_get_accumlate_button", 
			terminal_state = 0, 
			_index = self.index,
			_cell = self,		
			_typeIndex = self.typeIndex,		
			isPressedActionEnabled = true
		},
		nil,0)
end

function AccumlateGotoCell:onExit()
	
end

function AccumlateGotoCell:init(example,index,typeIndex)
	self.example = example
	self.index = index
	self.typeIndex = tonumber(typeIndex) or 7
end


function AccumlateGotoCell:createCell()
	local cell = AccumlateGotoCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end