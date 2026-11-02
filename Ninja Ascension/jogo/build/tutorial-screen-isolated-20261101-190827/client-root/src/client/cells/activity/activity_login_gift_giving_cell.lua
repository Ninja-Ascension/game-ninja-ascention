-- ----------------------------------------------------------------------------------------------------
-- 说明：登陆送礼
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ActivityLoginGiftGivingCell = class("ActivityLoginGiftGivingCellClass", Window)

function ActivityLoginGiftGivingCell:ctor()
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
	self.typeIndex = 24 
	self.isSelect = false   --是否为选择奖励类型
	self.selectConut = 0     -- 可选择数量
	self.shipInfoMould = nil      -- 可选择的武将模板
    -- Initialize ActivityLoginGiftGivingCell state machine.
    local function init_ActivityLoginGiftGivingCell_terminal()
		--领取activity_login_gift_giving_cell.lua
		local get_activity_login_gift_giving_button_terminal = {
            _name = "get_activity_login_gift_giving_button",
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
					if  mCell.isSelect == true and mCell.selectConut > 1 then
						local activityId = _ED.active_activity[typeIndex].activity_id
						mCell.command_param_list = ""..activityId.."\r\n"..tonumber(index)-1
						app.load("client.activity.ActivityAccumlateRechargeableForDrawSelectAward")
						fwin:open(ActivityAccumlateRechargeableForDrawSelectAward:new():init(params), fwin._dview)
					else
						local function responseGetServerListCallback(response)
							if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
								-- mCell:rewadDraw(index)
								if response.node ~= nil then
									response.node._cell:rewadDraw(response.node._index)
								end
							end
						end
						if TipDlg.drawStorageTipo() == false then
							local activityId = _ED.active_activity[typeIndex].activity_id
							protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(index)-1).."\r\n".."1"
							NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, param, responseGetServerListCallback, false, nil)
						end							
					end
				
					return true
				end
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(get_activity_login_gift_giving_button_terminal)
        state_machine.init()
    end
    
    -- call func init ActivityLoginGiftGivingCell state machine.
    init_ActivityLoginGiftGivingCell_terminal()
end

function ActivityLoginGiftGivingCell:rewadDraw(_index)
	local root = self.roots[1]
	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(7)
	fwin:open(getRewardWnd,fwin._ui)
	local activity = _ED.active_activity[self.typeIndex]

	
	local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12")
	if tonumber(activity.activity_Info[_index].activityInfo_isReward) == 1 then--DOTO	明明满足条件了。
		Image_13:setVisible(true)
		GetButton:setVisible(false)
	end
end

function ActivityLoginGiftGivingCell:onUpdateDrawText()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.typeIndex]
	local titleListText = ccui.Helper:seekWidgetByName(root, "Text_11")
	local scheduleText = ccui.Helper:seekWidgetByName(root, "Text_13")
	titleListText:setString(string.format(_tip_info_activity[self.typeIndex][3],self.example.activityInfo_need_day))
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh or
		__lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			scheduleText:setString((zstring.tonumber(activity.activity_login_day)).."/"..self.example.activityInfo_need_day)
	else
		scheduleText:setString((zstring.tonumber(activity.activity_login_day)+1).."/"..self.example.activityInfo_need_day)
	end
end

function ActivityLoginGiftGivingCell:onUpdateDrawLiset()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.typeIndex]
	
	local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_11")
	ListViewDraw:removeAllItmes()

	local shipinfo = self.example.activityInfo_reward_select  --奖励选择
	if shipinfo ~= nil and shipinfo ~= "" and shipinfo ~= " " then
		self.isSelect = true
		local shipinfomould = zstring.split(shipinfo, ",")
		local count = #shipinfomould
		self.selectConut = count
		self.shipInfoMould = shipinfomould
		for i = 1,count do
			local cell = ShipHeadCell:createCell()
			cell:init(nil, cell.enum_type._DUPLICATE, tonumber(shipinfomould[i]), 1, false)
			ListViewDraw:addChild(cell)
		end
		ListViewDraw:requestRefreshView()
		return
	end
	
	if zstring.tonumber(activity.activity_Info[self.index].activityInfo_silver) > 0 then--可领取银币数量
		local cell = propMoneyIcon:createCell()
		cell:init("1",activity.activity_Info[self.index].activityInfo_silver,nil)
		ListViewDraw:addChild(cell)
		
	end
	if zstring.tonumber(activity.activity_Info[self.index].activityInfo_gold) > 0 then--奖励1可领取金币数量
		local cell = propMoneyIcon:createCell()
		cell:init("2",activity.activity_Info[self.index].activityInfo_gold,nil)
		ListViewDraw:addChild(cell)
	end
	if zstring.tonumber(activity.activity_Info[self.index].activityInfo_food) > 0 then--奖励1可领取体力数量
		local cell = ResourcesIconCell:createCell()
		cell:init(0, 0, 0, {show_reward_list={{prop_type = 12, item_value = activity.activity_Info[self.index].activityInfo_food}}})
		ListViewDraw:addChild(cell)
	end
	if zstring.tonumber(activity.activity_Info[self.index].activityInfo_honour) > 0 then--奖励1可领取声望数量

		local cell = propMoneyIcon:createCell()
		cell:init("3",activity.activity_Info[self.index].activityInfo_honour,nil)
		ListViewDraw:addChild(cell)
	end
	if zstring.tonumber(activity.activity_Info[self.index].activityInfo_equip_count) > 0 then	--可领取装备种类数量
		for n, v in pairs(activity.activity_Info[self.index].activityInfo_equip_info) do
			local cell = EquipIconCell:createCell()
			cell:init(10, nil, v.equipMould, nil, nil, v.equipMouldCount)
			ListViewDraw:addChild(cell)
		end
	end
	if zstring.tonumber(activity.activity_Info[self.index].activityInfo_general_soul) > 0 then	--可领取水雷魂种类数量
		local cell = propMoneyIcon:createCell()
		cell:init("5",zstring.tonumber(activity.activity_Info[self.index].activityInfo_general_soul), nil)
		ListViewDraw:addChild(cell)
	end
	if zstring.tonumber(activity.activity_Info[self.index].activityInfo_prop_count) > 0 then--可领取道具种类数量
		for n, v in pairs(activity.activity_Info[self.index].activityInfo_prop_info) do
			local cell = PropIconCell:createCell()
			cell:init(26, v.propMould,v.propMouldCount)
			ListViewDraw:addChild(cell)
		end
	end
	ListViewDraw:requestRefreshView()

end


function ActivityLoginGiftGivingCell:onUpdateDrawButton()
	local root = self.roots[1]
	local activity = _ED.active_activity[self.typeIndex]
	local loginDay = zstring.tonumber(activity.activity_login_day)-- 已登陆天数
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh or
		__lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			
	else
		loginDay = loginDay + 1 
	end
	local hasGet  =	 tonumber(self.example.activityInfo_isReward)   -- 是否已领取
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12")
	local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
	Image_13:setVisible(false)
	if hasGet == 0 then   -- 未领取
		if tonumber(self.example.activityInfo_need_day) <= loginDay then  -- 可领取
			GetButton:setBright(true)
			GetButton:setVisible(true)
			GetButton:setTouchEnabled(true)
		else
			GetButton:setBright(false)
			GetButton:setTouchEnabled(false)
			GetButton:setVisible(true)
		end
	else
		Image_13:setVisible(true)
		GetButton:setVisible(false)
	end
end

function ActivityLoginGiftGivingCell:onUpdateDraw()
	self:onUpdateDrawText()
	self:onUpdateDrawLiset()
	self:onUpdateDrawButton()
end
function ActivityLoginGiftGivingCell:onEnterTransitionFinish()
	local root = cacher.createUIRef("activity/wonderful/landed_gifts_list.csb", "root")
	-- local csbActivityLoginGiftGivingCell = csb.createNode("activity/wonderful/landed_gifts_list.csb")
 --    local root = csbActivityLoginGiftGivingCell:getChildByName("root")
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
	self:onUpdateDrawLiset()
    
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"), nil, 
		{
			terminal_name = "get_activity_login_gift_giving_button", 
			terminal_state = 0, 
			_index = self.index,
			_cell = self,		
			_typeIndex = self.typeIndex,
			isPressedActionEnabled = true
		},
		nil,0)
end

function ActivityLoginGiftGivingCell:clearUIInfo( ... )
    local root = self.roots[1]
	local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_11")
	if ListViewDraw ~= nil then
		ListViewDraw:removeAllItems()
	end
	local Button_11 = ccui.Helper:seekWidgetByName(root, "Button_11")
	local Button_12 = ccui.Helper:seekWidgetByName(root, "Button_12")
	local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_13")
	local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
	local Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")
	if Button_11 ~= nil then
		Button_11:setVisible(true)
		Button_12:setVisible(true)
		Button_12:setTouchEnabled(true)
		Button_12:setBright(true)
		Button_13:setVisible(false)
		Image_13:setVisible(false)
		Text_13:setVisible(true)
		Text_13:setString("")
	end
end

function ActivityLoginGiftGivingCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/landed_gifts_list.csb", self.roots[1])
end

function ActivityLoginGiftGivingCell:init(example,index,typeIndex)
	self.example = example
	self.index = index
	self.typeIndex = tonumber(typeIndex) or 24
end


function ActivityLoginGiftGivingCell:createCell()
	local cell = ActivityLoginGiftGivingCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end