-- ----------------------------------------------------------------------------------------------------
-- 说明：愚人节：节日登陆活动
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EmblemLoginCell = class("EmblemLoginCellClass", Window)
    
function EmblemLoginCell:ctor()
    self.super:ctor()
	self.roots = {}
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	self.example = nil
	self.index = 0

	self.reworld_sorting = {}
    -- Initialize EmblemLoginCell state machine.
    local function init_EmblemLoginCell_terminal()
		
		--领取
		local get_emblem_login_button_terminal = {
            _name = "get_emblem_login_button",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local tempCell = params._datas._cell
				local function responseHolidayLoginCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil then
							-- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
							-- 	response.node._cell:rewadDraw(response.node._index,tempCell)
							-- else
							-- 	response.node._cell:rewadDraw(response.node._index)
							-- end
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7, nil, response.node.reworld_sorting)
							fwin:open(getRewardWnd, fwin._ui)
						end
						state_machine.excute("activity_emblem_login_update_draw", 0, "")
					end
				end

				local activityId = _ED.active_activity[125].activity_id
				protocol_command.get_activity_reward.param_list = ""..activityId.."\r\n"..(tonumber(params._datas._index)-1).."\r\n".."1"
				NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, tempCell, responseHolidayLoginCallback, false, nil)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(get_emblem_login_button_terminal)
        state_machine.init()
    end
    
    -- call func init EmblemLoginCell state machine.
    init_EmblemLoginCell_terminal()
end

function EmblemLoginCell:rewadDraw(_index,tempCell)
	local root = self.roots[1]
	
	local getRewardWnd = DrawRareReward:new()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		getRewardWnd:init(7,nil,tempCell.reworld_sorting)
	else
		getRewardWnd:init(7)
	end
	
	fwin:open(getRewardWnd,fwin._ui)
	local activity = _ED.active_activity[125]
	
	local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12")
	local scheduleText = ccui.Helper:seekWidgetByName(root, "Text_13")
	--> print("tonumber(activity.activity_Info[_index].activityInfo_isReward)===",tonumber(activity.activity_Info[_index].activityInfo_isReward))
	if tonumber(activity.activity_Info[_index].activityInfo_isReward) == 1	then--DOTO	明明满足条件了。
		Image_13:setVisible(true)
		GetButton:setVisible(false)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			scheduleText:setVisible(false)
		end
	end
end

function EmblemLoginCell:updateGetRewardEnd( _index )
	local root = self.roots[1]
	
	local getRewardWnd = DrawRareReward:new()
	getRewardWnd:init(7)
	fwin:open(getRewardWnd,fwin._ui)
	local activity = _ED.active_activity[125]
	
	local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12")
	local scheduleText = ccui.Helper:seekWidgetByName(root, "Text_13")
	local Button_11 = ccui.Helper:seekWidgetByName(root, "Button_11")
	Button_11:setVisible(false)
	--> print("tonumber(activity.activity_Info[_index].activityInfo_isReward)===",tonumber(activity.activity_Info[_index].activityInfo_isReward))
	-- if tonumber(activity.activity_Info[_index].activityInfo_isReward) == 1	then--DOTO	明明满足条件了。
		Image_13:setVisible(true)
		GetButton:setVisible(false)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			scheduleText:setVisible(false)
		end
	-- end
end

function EmblemLoginCell:getPropIconCell(mid)
    app.load("client.cells.prop.model_prop_icon_cell")
    local iconCell = ModelPropIconCell:createCell()
    local config = iconCell:createConfig(mid, 1, true, 1, 13)
    config.isDebris = true
    iconCell:init(config)
    return iconCell
end

function EmblemLoginCell:onUpdateDraw()
	local root = self.roots[1]
	local activity = _ED.active_activity[125]
	
	local titleListText = ccui.Helper:seekWidgetByName(root, "Text_11")
	titleListText:setString(_string_piece_info[433]..self.example.activityInfo_need_day.._string_piece_info[231])
	local scheduleText = ccui.Helper:seekWidgetByName(root, "Text_13")
	if tonumber(activity.total_recharge_count) > tonumber(self.example.activityInfo_need_day) then
		scheduleText:setString(self.example.activityInfo_need_day.."/"..self.example.activityInfo_need_day)
	else
		scheduleText:setString(activity.total_recharge_count.."/"..self.example.activityInfo_need_day)
	end
	
	local GetButton = ccui.Helper:seekWidgetByName(root, "Button_12")
	local Image_14 = ccui.Helper:seekWidgetByName(root, "Image_14")
	local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
	local Button_11 = ccui.Helper:seekWidgetByName(root, "Button_11")
	local Button_13 = ccui.Helper:seekWidgetByName(root, "Button_13")

	Button_11:setVisible(false)
	Button_13:setVisible(false)
	GetButton:setVisible(true)
	if tonumber(self.example.activityInfo_isReward) < 0 then
		if nil ~= Image_14 then
			Image_14:setVisible(true)
		end
		Image_13:setVisible(false)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			GetButton:setBright(false)
			GetButton:setTouchEnabled(false)
			scheduleText:setVisible(true)
		else
			GetButton:setVisible(true)
		end
	elseif tonumber(self.example.activityInfo_isReward) == 0 then
		if nil ~= Image_14 then
			Image_14:setVisible(false)
		end
		Image_13:setVisible(false)
		GetButton:setVisible(true)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			GetButton:setBright(true)
			GetButton:setTouchEnabled(true)
			scheduleText:setVisible(false)
		end
	else
		if nil ~= Image_14 then
			Image_14:setVisible(false)
		end
		Image_13:setVisible(true)
		GetButton:setVisible(false)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			scheduleText:setVisible(false)
		end
	end
	
	if tonumber(activity.activity_params) >= tonumber(self.example.activityInfo_need_day) then
		GetButton:setBright(true)
		GetButton:setTouchEnabled(true)
		GetButton:setHighlighted(false)
	else
		GetButton:setBright(false)
		GetButton:setTouchEnabled(false)
		GetButton:setHighlighted(true)
	end
end

function EmblemLoginCell:updateRewardInfo( ... )
	local root = self.roots[1]
	local activity = _ED.active_activity[125]

	local cell_tables = {}
	local index = 1
	self.reworld_sorting = {}
	local selectInfo = activity.activity_Info[self.example.index].activityInfo_reward_select
	if selectInfo ~= nil and selectInfo ~= "" and zstring.tonumber(selectInfo) ~= 0 then
		local infoList = zstring.split(selectInfo, "|")
		for k,v in pairs(infoList) do
			v = zstring.split(v, ",")
			local cell = ResourcesIconCell:createCell()
	        cell:init(tonumber(v[1]), tonumber(v[3]), tonumber(v[2]),nil,nil,true,true,nil)
	        table.insert(cell_tables, cell)
	        local rewardinfo = {}
            rewardinfo.type = tonumber(v[1])
            rewardinfo.id = tonumber(v[2])
            rewardinfo.number = tonumber(v[3])
            self.reworld_sorting[index] = rewardinfo
            index = index + 1

	        -- local cell = self:getPropIconCell(infoList[i])
	        -- -- ListViewDraw:addChild(cell)
	        -- table.insert(cell_tables, cell)
	    end
	else
		if tonumber(activity.activity_Info[self.example.index].activityInfo_silver) > 0 then--可领取银币数量
			-- local cell = ResourcesIconCell:createCell()
			-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 1, item_value = activity.activity_Info[self.index].activityInfo_silver}}})
			-- ListViewDraw:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				local cell = ResourcesIconCell:createCell()
		        cell:init(1, tonumber(activity.activity_Info[self.example.index].activityInfo_silver), -1,nil,nil,true,true)
		        -- ListViewDraw:addChild(cell)
		        table.insert(cell_tables, cell)
		        local rewardinfo = {}
                rewardinfo.type = 1
                rewardinfo.id = -1
                rewardinfo.number = tonumber(activity.activity_Info[self.example.index].activityInfo_silver)
                self.reworld_sorting[index] = rewardinfo
                index = index + 1
			else
				local cell = propMoneyIcon:createCell()
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					cell:init("1",activity.activity_Info[self.example.index].activityInfo_silver,_All_tip_string_info._fundName)
				else
					cell:init("1",activity.activity_Info[self.example.index].activityInfo_silver,nil)
				end
				-- ListViewDraw:addChild(cell)
				table.insert(cell_tables, cell)
			end
		end
		if tonumber(activity.activity_Info[self.example.index].activityInfo_gold) > 0 then--奖励1可领取金币数量
			-- local cell = ResourcesIconCell:createCell()
			-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 2, item_value = activity.activity_Info[self.index].activityInfo_gold}}})
			-- ListViewDraw:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				local cell = ResourcesIconCell:createCell()
		        cell:init(2, tonumber(activity.activity_Info[self.example.index].activityInfo_gold), -1,nil,nil,true,true)
		        -- ListViewDraw:addChild(cell)
		        table.insert(cell_tables, cell)
		        local rewardinfo = {}
                rewardinfo.type = 2
                rewardinfo.id = -1
                rewardinfo.number = tonumber(activity.activity_Info[self.example.index].activityInfo_gold)
                self.reworld_sorting[index] = rewardinfo
                index = index + 1
	        else
				local cell = propMoneyIcon:createCell()
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					cell:init("2",activity.activity_Info[self.example.index].activityInfo_gold,_All_tip_string_info._crystalName)
				else
					cell:init("2",activity.activity_Info[self.example.index].activityInfo_gold,nil)
				end
				-- ListViewDraw:addChild(cell)
				table.insert(cell_tables, cell)
			end
			
		end
		if tonumber(activity.activity_Info[self.example.index].activityInfo_food) > 0 then--奖励1可领取体力数量
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				local cell = ResourcesIconCell:createCell()
		        cell:init(12, tonumber(activity.activity_Info[self.example.index].activityInfo_food), -1,nil,nil,true,true)
		        -- ListViewDraw:addChild(cell)
		        table.insert(cell_tables, cell)
		        local rewardinfo = {}
                rewardinfo.type = 12
                rewardinfo.id = -1
                rewardinfo.number = tonumber(activity.activity_Info[self.example.index].activityInfo_food)
                self.reworld_sorting[index] = rewardinfo
                index = index + 1
	        else
				local cell = ResourcesIconCell:createCell()
				cell:init(0, 0, 0, {show_reward_list={{prop_type = 12, item_value = activity.activity_Info[self.example.index].activityInfo_food}}})
				-- ListViewDraw:addChild(cell)
				table.insert(cell_tables, cell)
			end
		end
		if tonumber(activity.activity_Info[self.example.index].activityInfo_honour) > 0 then--奖励1可领取声望数量
			-- local cell = ResourcesIconCell:createCell()
			-- cell:init(0, 0, 0, {show_reward_list={{prop_type = 3, item_value = activity.activity_Info[self.index].activityInfo_honour}}})
			-- ListViewDraw:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				local cell = ResourcesIconCell:createCell()
		        cell:init(3, tonumber(activity.activity_Info[self.example.index].activityInfo_honour), -1,nil,nil,true,true)
		        -- ListViewDraw:addChild(cell)
		        table.insert(cell_tables, cell)
		        local rewardinfo = {}
                rewardinfo.type = 3
                rewardinfo.id = -1
                rewardinfo.number = tonumber(activity.activity_Info[self.example.index].activityInfo_honour)
                self.reworld_sorting[index] = rewardinfo
                index = index + 1
	        else
				local cell = propMoneyIcon:createCell()
				cell:init("3",activity.activity_Info[self.example.index].activityInfo_honour,nil)
				-- ListViewDraw:addChild(cell)
				table.insert(cell_tables, cell)
			end
		end
		if tonumber(activity.activity_Info[self.example.index].activityInfo_equip_count) > 0 then	--可领取装备种类数量
			for n, v in pairs(activity.activity_Info[self.example.index].activityInfo_equip_info) do
				-- local cell = ResourcesIconCell:createCell()
				-- cell:init(cell.enum_type.EQUIPMENT_INFORMATION, v.equipMouldCount, v.equipMould, nil)
				-- ListViewDraw:addChild(cell)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					local cell = ResourcesIconCell:createCell()
			        cell:init(7, tonumber(v.equipMouldCount), v.equipMould,nil,nil,true,true,nil,{equipQuality = 3})
			        -- ListViewDraw:addChild(cell)
			        table.insert(cell_tables, cell)
			        local rewardinfo = {}
	                rewardinfo.type = 7
	                rewardinfo.id = v.equipMould
	                rewardinfo.number = tonumber(v.equipMouldCount)
	                self.reworld_sorting[index] = rewardinfo
	                index = index + 1
				else
					local cell = EquipIconCell:createCell()
					cell:init(10, nil, v.equipMould, nil, nil, v.equipMouldCount)
					-- ListViewDraw:addChild(cell)
					table.insert(cell_tables, cell)
				end
			end
		end
		if tonumber(activity.activity_Info[self.example.index].activityInfo_prop_count) > 0 then--可领取道具种类数量
			for n, v in pairs(activity.activity_Info[self.example.index].activityInfo_prop_info) do
				-- local cell = ResourcesIconCell:createCell()
				-- cell:init(cell.enum_type.PROP_INFORMATION, v.propMouldCount, v.propMould, nil)
				-- ListViewDraw:addChild(cell)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			        local cell = ResourcesIconCell:createCell()
			        cell:init(6, tonumber(v.propMouldCount), v.propMould,nil,nil,true,true)
			        -- ListViewDraw:addChild(cell)
			        table.insert(cell_tables, cell)
			        local rewardinfo = {}
	                rewardinfo.type = 6
	                rewardinfo.id = v.propMould
	                rewardinfo.number = tonumber(v.propMouldCount)
	                self.reworld_sorting[index] = rewardinfo
	                index = index + 1
				else
					local cell = PropIconCell:createCell()
					cell:init(26, v.propMould,v.propMouldCount)
					-- ListViewDraw:addChild(cell)
					table.insert(cell_tables, cell)
				end
			end
		end
		if tonumber(activity.activity_Info[self.example.index].activityInfo_general_soul) > 0 then	--可领取水雷魂种类数量
			-- local cell = ResourcesIconCell:createCell()
			-- cell:init(cell.enum_type.EQUIPMENT_INFORMATION, v.equipMouldCount, v.equipMould, nil)
			-- ListViewDraw:addChild(cell)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				local cell = ResourcesIconCell:createCell()
		        cell:init(5, tonumber(activity.activity_Info[self.example.index].activityInfo_general_soul), -1,nil,nil,true,true)
		        -- ListViewDraw:addChild(cell)
		        table.insert(cell_tables, cell)
		        local rewardinfo = {}
                rewardinfo.type = 5
                rewardinfo.id = -1
                rewardinfo.number = tonumber(activity.activity_Info[self.example.index].activityInfo_general_soul)
                self.reworld_sorting[index] = rewardinfo
                index = index + 1
			else
				local cell = propMoneyIcon:createCell()
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then	
					cell:init("5",zstring.tonumber(activity.activity_Info[self.example.index].activityInfo_general_soul), "英魂")
				else
					cell:init("5",zstring.tonumber(activity.activity_Info[self.example.index].activityInfo_general_soul), nil)
				end
				-- ListViewDraw:addChild(cell)
				table.insert(cell_tables, cell)
			end
		end
	end
	local ListViewDraw = ccui.Helper:seekWidgetByName(root, "ListView_11")
    local ScrollView_icon = ccui.Helper:seekWidgetByName(root, "ScrollView_icon")
    if ScrollView_icon ~= nil then
    	ScrollView_icon:removeAllChildren(true)

		local total_col = 2
		local count = #cell_tables
		if count > 0 then
			local cell_size = cell_tables[1]:getContentSize()
		    local scroll_width = ScrollView_icon:getContentSize().width
		    local scroll_height = ScrollView_icon:getContentSize().height
		    local cell_width = cell_size.width
		    local cell_height = cell_size.height - 24
		    local height = cell_height * math.ceil(count / total_col)
		    local width = scroll_width / total_col
		    if height > scroll_height then
		        scroll_height = height
		        ScrollView_icon:setInnerContainerSize(cc.size(scroll_width, scroll_height))
		    end

		    for k, v in pairs(cell_tables) do
		    	ScrollView_icon:addChild(v)
		        local row = math.floor((k - 1) % total_col) + 1
		        local col = math.floor((k - 1) / total_col) + 1
		        local posX = scroll_width * row / total_col - width / 2 - cell_width / 2
		        local posY = scroll_height - cell_height * col - 7
		        v:setPosition(posX, posY)
		    end
		end

    else
		ListViewDraw:removeAllItems()
		for k, cell in pairs(cell_tables) do
			ListViewDraw:addChild(cell)
		end

		ListViewDraw:requestRefreshView()
	end
end

function EmblemLoginCell:onEnterTransitionFinish()
	local root = cacher.createUIRef("activity/wonderful/landed_gifts_list.csb", "root")
	-- local csbEmblemLoginCell = csb.createNode("activity/wonderful/landed_gifts_list.csb")
 --    local root = csbEmblemLoginCell:getChildByName("root")
    table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	
	self:setContentSize(root:getChildByName("Panel_land_list"):getContentSize())
	state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.HolidayLogin)
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
    -- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onUpdateDraw, self)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12"), nil, 
		{
			terminal_name = "get_emblem_login_button", 
			terminal_state = 0, 
			_index = self.example.index,
			_cell = self,			
			isPressedActionEnabled = true
		},
		nil,0)
end

function EmblemLoginCell:clearUIInfo( ... )
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
	local ScrollView_icon = ccui.Helper:seekWidgetByName(root, "ScrollView_icon")
	if ScrollView_icon ~= nil then
		ScrollView_icon:removeAllChildren(true)
	end
end

function EmblemLoginCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/landed_gifts_list.csb", self.roots[1])
end

function EmblemLoginCell:init(example,index)
	self.example = example
	self.index = index
end


function EmblemLoginCell:createCell()
	local cell = EmblemLoginCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end