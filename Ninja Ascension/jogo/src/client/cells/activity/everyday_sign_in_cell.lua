-- ----------------------------------------------------------------------------------------------------
-- 说明：每日签到list
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EverydaySignInCell = class("EverydaySignInCellClass", Window)
EverydaySignInCell.__size = nil

function EverydaySignInCell:ctor()
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
	self.activityIndex = 0
    -- Initialize EverydaySignInCell state machine.
    local function init_EverydaySignInCell_terminal()
		--每日豪华签到之去充值
        local luxury_to_accumlate_button_terminal = {
            _name = "luxury_to_accumlate_button",
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
				local cell = params._datas._cell
				local Recharge = RechargeDialog:new()
				Recharge:init(1,cell)
				fwin:open(Recharge, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--签到
		local sign_in_button_terminal = {
            _name = "sign_in_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if TipDlg.drawStorageTipo() == false then
					local index = params._datas._index
					local mCell = params._datas._cell
					local _count = params._datas.uiCount
					local _replyPhysical = params._datas.replyPhysical
					local function responseGetServerListCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
								if mCell == nil then
									return
								end
							end
							mCell:rewadDraw(index,_count)
						end
					end
					local activityId = nil
					if tonumber(_count) == 1 then
						activityId = _ED.active_activity[38].activity_id
					elseif tonumber(_count) == 2 then
						activityId = _ED.active_activity[39].activity_id
					end
					if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
						or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
						protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(index)-1).."\r\n".."1"
					else	
						protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(index)-1).."\r\n1"
					end	
					NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, mCell, responseGetServerListCallback, false, nil)
                end
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local activity_luxury_recharge_cell_button_terminal = {
            _name = "activity_luxury_recharge_cell_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				params:onUpdateDrawRecharge()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(luxury_to_accumlate_button_terminal)
        state_machine.add(sign_in_button_terminal)
        state_machine.add(activity_luxury_recharge_cell_button_terminal)
        state_machine.init()
    end
    
    -- call func init EverydaySignInCell state machine.
    init_EverydaySignInCell_terminal()
end

function EverydaySignInCell:onUpdateDrawRecharge()
	local root = self.roots[1]
	if root == nil then
		return
	end
	local activity = _ED.active_activity[39]
	local ImageNoReach = ccui.Helper:seekWidgetByName(root, "Image_ls6")	--未达成
	local ImageYetGet = ccui.Helper:seekWidgetByName(root, "Image_ls_5")	--已领取
	local getButton = ccui.Helper:seekWidgetByName(root, "Button_ls_1")	--领取
	local rmbButton = ccui.Helper:seekWidgetByName(root, "Button_ls_2")	--充值
	if tonumber(activity.activity_Info[tonumber(activity.activity_login_Max_day)].activityInfo_is_reach) == 1 then				--是否达成(0:未达成 1:已达成) 
		if tonumber(activity.activity_Info[tonumber(activity.activity_login_Max_day)].activityInfo_isReward) == 0 then	--未领取
			getButton:setVisible(true)
			ImageNoReach:setVisible(false)
			ImageYetGet:setVisible(false)
			rmbButton:setVisible(false)
		end
	end
end

function EverydaySignInCell:rewadDraw(_index,_count)
	local root = self.roots[1]
	
	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(7)
	fwin:open(getRewardWnd,fwin._ui)
	if _count == 1 then
		local activity = _ED.active_activity[38]
		
		local ImageYetGet = ccui.Helper:seekWidgetByName(root, "Image_ls_5")	--已领取
		local signInButton = ccui.Helper:seekWidgetByName(root, "Button_ls_3")	--签到
		if tonumber(activity.activity_Info[_index].activityInfo_isReward) == 1 then--DOTO	明明满足条件了。
			ImageYetGet:setVisible(true)
			signInButton:setVisible(false)
		end
	else
		local ImageNoReach = ccui.Helper:seekWidgetByName(root, "Image_ls6")	--未达成
		local ImageYetGet = ccui.Helper:seekWidgetByName(root, "Image_ls_5")	--已领取
		local getButton = ccui.Helper:seekWidgetByName(root, "Button_ls_1")	--领取
		local rmbButton = ccui.Helper:seekWidgetByName(root, "Button_ls_2")	--充值
		if tonumber(self.example.activityInfo_isReward) == 0 then	--未领取
			getButton:setVisible(true)
			ImageNoReach:setVisible(false)
			ImageYetGet:setVisible(false)
			rmbButton:setVisible(false)
		else
			getButton:setVisible(false)
			ImageNoReach:setVisible(false)
			ImageYetGet:setVisible(true)
			rmbButton:setVisible(false)
		end
	end
end


--每日签到
function EverydaySignInCell:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[38]
	
	local dayCount = ccui.Helper:seekWidgetByName(root, "AtlasLabel_ls_1")	--天数
	local ImageNoReach = ccui.Helper:seekWidgetByName(root, "Image_ls6")	--未达成
	local ImageYetGet = ccui.Helper:seekWidgetByName(root, "Image_ls_5")	--已领取
	local signInButton = ccui.Helper:seekWidgetByName(root, "Button_ls_3")	--签到
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		dayCount:setString(_string_piece_info[2]..self.example.activityInfo_need_day..tipStringInfo_mine_info[4])
	else
		dayCount:setString(self.example.activityInfo_need_day)
	end
	local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	ListViewDraw:removeAllItems()
	if tonumber(self.example.activityInfo_need_vip) <= 0 then
		if tonumber(activity.activity_Info[self.index].activityInfo_silver) > 0 then--可领取银币数量
			local cell = propMoneyIcon:createCell()
			cell:init("1",activity.activity_Info[self.index].activityInfo_silver,nil)
			ListViewDraw:addChild(cell)
		end
		if tonumber(activity.activity_Info[self.index].activityInfo_gold) > 0 then--奖励1可领取金币数量
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
			local cell = propMoneyIcon:createCell()
			cell:init("3",activity.activity_Info[self.index].activityInfo_honour,nil)
			ListViewDraw:addChild(cell)
		end
		if tonumber(activity.activity_Info[self.index].activityInfo_equip_count) > 0 then	--可领取装备种类数量
			for n, v in pairs(activity.activity_Info[self.index].activityInfo_equip_info) do
				local cell = EquipIconCell:createCell()
				cell:init(10, nil, v.equipMould, nil, nil, v.equipMouldCount)
				ListViewDraw:addChild(cell)
			end
		end
		if tonumber(activity.activity_Info[self.index].activityInfo_prop_count) > 0 then--可领取道具种类数量
			for n, v in pairs(activity.activity_Info[self.index].activityInfo_prop_info) do
				--local cell = PropIconCell:createCell()
				--cell:init(26, v.propMould,v.propMouldCount)
				--ListViewDraw:addChild(cell)
				
				local cell = self:getItemCell(v.propMould,nil,v.propMouldCount)
				ListViewDraw:addChild(cell)
			end
		end
	else
		if tonumber(activity.activity_Info[self.index].activityInfo_silver) > 0 then--可领取银币数量
			local cell = propMoneyIcon:createCell()
			cell:init("1",activity.activity_Info[self.index].activityInfo_silver,nil,self.example.activityInfo_need_vip)
			ListViewDraw:addChild(cell)
		end
		if tonumber(activity.activity_Info[self.index].activityInfo_gold) > 0 then--奖励1可领取金币数量
			local cell = propMoneyIcon:createCell()
			cell:init("2",activity.activity_Info[self.index].activityInfo_gold,nil,self.example.activityInfo_need_vip)
			ListViewDraw:addChild(cell)
		end
		if tonumber(activity.activity_Info[self.index].activityInfo_food) > 0 then--奖励1可领取体力数量
			local cell = ResourcesIconCell:createCell()
			cell:init(0, 0, 0, {show_reward_list={{prop_type = 12, item_value = activity.activity_Info[self.index].activityInfo_food}}})
			ListViewDraw:addChild(cell)
		end
		if tonumber(activity.activity_Info[self.index].activityInfo_honour) > 0 then--奖励1可领取声望数量
			local cell = propMoneyIcon:createCell()
			cell:init("3",activity.activity_Info[self.index].activityInfo_honour,nil,self.example.activityInfo_need_vip)
			ListViewDraw:addChild(cell)
		end
		if tonumber(activity.activity_Info[self.index].activityInfo_equip_count) > 0 then	--可领取装备种类数量
			for n, v in pairs(activity.activity_Info[self.index].activityInfo_equip_info) do
				local cell = EquipIconCell:createCell()
				cell:init(11, nil, v.equipMould, nil, self.example.activityInfo_need_vip, v.equipMouldCount)
				ListViewDraw:addChild(cell)
			end
		end
		if tonumber(activity.activity_Info[self.index].activityInfo_prop_count) > 0 then--可领取道具种类数量
			for n, v in pairs(activity.activity_Info[self.index].activityInfo_prop_info) do
				-- local cell = PropIconCell:createCell()
				-- cell:init(26, v.propMould,v.propMouldCount,self.example.activityInfo_need_vip)
				-- ListViewDraw:addChild(cell)
				local cell = self:getItemCell(v.propMould,nil,v.propMouldCount)
				ListViewDraw:addChild(cell)
			end
		end
	end
	ListViewDraw:requestRefreshView()
	
	if tonumber(activity.activity_login_day) < tonumber(self.example.activityInfo_need_day) then	--签到的天数小于当前的天数
		ImageNoReach:setVisible(true)
		ImageYetGet:setVisible(false)
		signInButton:setVisible(false)
	elseif tonumber(activity.activity_login_day) >= tonumber(self.example.activityInfo_need_day) then	--等于的时候
		if tonumber(activity.activity_Info[self.index].activityInfo_isReward) == 1 then
			ImageYetGet:setVisible(true)
			signInButton:setVisible(false)
			ImageNoReach:setVisible(false)
		else
			ImageNoReach:setVisible(false)
			ImageYetGet:setVisible(false)
			signInButton:setVisible(true)
		end
	end
	
end
--豪华签到
function EverydaySignInCell:luxuryDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[39]
	local dayCount = ccui.Helper:seekWidgetByName(root, "AtlasLabel_ls_1")	--天数
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		dayCount:setString(_string_piece_info[2]..self.index..tipStringInfo_mine_info[4])
	else
		dayCount:setString(self.index)
	end
	
	local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	ListViewDraw:removeAllItems()
	if tonumber(activity.activity_Info[self.index].activityInfo_silver) > 0 then--可领取银币数量
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
	if tonumber(activity.activity_Info[self.index].activityInfo_general_soul) > 0 then--奖励1可领取魂玉数量
		-- local cell = ResourcesIconCell:createCell()
		-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 4, item_value = activity.activity_Info[self.index].activityInfo_general_soul}}})
		-- ListViewDraw:addChild(cell)
		local cell = propMoneyIcon:createCell()
		cell:init("5",activity.activity_Info[self.index].activityInfo_general_soul,nil)
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
	if tonumber(activity.activity_Info[self.index].activityInfo_prop_count) > 0 then--可领取道具种类数量
		for n, v in pairs(activity.activity_Info[self.index].activityInfo_prop_info) do
			-- local cell = ResourcesIconCell:createCell()
			-- cell:init(cell.enum_type.PROP_INFORMATION, v.propMouldCount, v.propMould, nil)
			-- ListViewDraw:addChild(cell)
			
			-- local cell = PropIconCell:createCell()
			-- cell:init(26, v.propMould,v.propMouldCount)
			-- ListViewDraw:addChild(cell)
			
			local cell = self:getItemCell(v.propMould,nil,v.propMouldCount)
			ListViewDraw:addChild(cell)
		end
	end
	ListViewDraw:requestRefreshView()
	
	local ImageNoReach = ccui.Helper:seekWidgetByName(root, "Image_ls6")	--未达成
	local ImageYetGet = ccui.Helper:seekWidgetByName(root, "Image_ls_5")	--已领取
	local getButton = ccui.Helper:seekWidgetByName(root, "Button_ls_1")	--领取
	local rmbButton = ccui.Helper:seekWidgetByName(root, "Button_ls_2")	--充值
	
	if tonumber(self.example.activityInfo_is_reach) == 0 then				--是否达成(0:未达成 1:已达成) 
		if tonumber(activity.activity_login_Max_day) == tonumber(self.index) then
			ImageNoReach:setVisible(false)
			ImageYetGet:setVisible(false)
			getButton:setVisible(false)
			rmbButton:setVisible(true)
		else
			ImageNoReach:setVisible(true)
			ImageYetGet:setVisible(false)
			getButton:setVisible(false)
			rmbButton:setVisible(false)
		end
	else
		if tonumber(self.example.activityInfo_isReward) == 0 then	--未领取
			getButton:setVisible(true)
			ImageNoReach:setVisible(false)
			ImageYetGet:setVisible(false)
			rmbButton:setVisible(false)
		else
			getButton:setVisible(false)
			ImageNoReach:setVisible(false)
			ImageYetGet:setVisible(true)
			rmbButton:setVisible(false)
		end
		
	end
end

--道具
function EverydaySignInCell:getItemCell(mid,mtype,count,isCertainly)
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

function EverydaySignInCell:onEnterTransitionFinish()

end

function EverydaySignInCell:onInit()
	-- local csbEverydaySignInCell = csb.createNode("activity/wonderful/daily_attendance_list.csb")
 --    local root = csbEverydaySignInCell:getChildByName("root")
 --    table.insert(self.roots, root)
	-- root:removeFromParent(false)
 --    self:addChild(root)
 	local root = cacher.createUIRef("activity/wonderful/daily_attendance_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	
	local rmbButton = ccui.Helper:seekWidgetByName(root, "Button_ls_2")  --充值
	rmbButton:setVisible(false)
	local getButton = ccui.Helper:seekWidgetByName(root, "Button_ls_1")	--领取
	getButton:setVisible(false)
	local signInButton = ccui.Helper:seekWidgetByName(root, "Button_ls_3")	--签到
	signInButton:setVisible(false)
	if EverydaySignInCell.__size == nil then
		EverydaySignInCell.__size = root:getChildByName("Panel_day_list"):getContentSize()
	end
	
	-- self:setContentSize(EverydaySignInCell.__size)
	state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.ActivityDailySignIn)
	-- 列表控件动画播放
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local action = csb.createTimeline("activity/wonderful/daily_attendance_list.csb")
	    root:runAction(action)
	    action:play("list_view_cell_open", false)
	end

	if tonumber(self.activityIndex) == 1 then
		self:onUpdateDraw()
	else
		self:luxuryDraw()
	end
	local uiCount = 0
	--每日的签到
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ls_3"), nil, 
		{
			terminal_name = "sign_in_button", 
			terminal_state = 0, 
			_index = self.index,
			_cell = self,			
			uiCount = 1,			
			isPressedActionEnabled = true
		},
		nil,0)
	--豪华充值签到
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ls_2"), nil, 
		{
			terminal_name = "luxury_to_accumlate_button", 
			terminal_state = 0, 
			_cell = self,
			isPressedActionEnabled = true
		},
		nil,0)
	--每日的签到
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ls_1"), nil, 
		{
			terminal_name = "sign_in_button", 
			terminal_state = 0, 
			_index = self.index,
			_cell = self,	
			uiCount = 2,				
			isPressedActionEnabled = true
		},
		nil,0)
end

function EverydaySignInCell:onExit()
	self:clearUIInfo()
	cacher.freeRef("activity/wonderful/daily_attendance_list.csb", self.roots[1])
end

function EverydaySignInCell:clearUIInfo( ... )
	local root = self.roots[1]
	local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	if ListViewDraw ~= nil then
		ListViewDraw:removeAllItems()
	end
end

function EverydaySignInCell:init(example,index,activityIndex)
	self.example = example
	self.index = index
	self.activityIndex = activityIndex
	if index < 5 then
		self:onInit()
	end
	-- if activityIndex == 2 then
	-- 	self.index = self.index/5
	-- end
	self:setContentSize(EverydaySignInCell.__size)
end

function EverydaySignInCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function EverydaySignInCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("activity/wonderful/daily_attendance_list.csb", root)
	-- local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_ls_1")
	-- ListViewDraw:removeAllItems()
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function EverydaySignInCell:createCell()
	local cell = EverydaySignInCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end