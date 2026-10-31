-- ----------------------------------------------------------------------------------------------------
-- 说明：领奖中心
-- 创建时间2014-03-02 22:07
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

GainRewardListCell = class("GainRewardListCellClass", Window)

function GainRewardListCell:ctor()
    self.super:ctor()
	app.load("client.cells.utils.resources_icon_cell")
	self.roots = {}
	self.example = nil
	
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.cells.prop.prop_money_icon")
    local function init_GainRewardListCell_terminal()
		local reward_gain_button_terminal = {
            _name = "reward_gain_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if TipDlg.drawStorageTipo() == false then
					local RewardCell = params._datas._cell
					local _rewardId = params._datas.rewardId
					local _rewardType = params._datas.rewardType
					local function responsePropCompoundCallback(response)
						if response.node == nil or response.node.roots == nil then 
							return
						end
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							state_machine.excute("gain_reward_news_send", 0, {response.node, response.node.example})
						else
							--龙虎门，公会战奖励可以在公会中领取 ,已经领取后，删除
							if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then 
								if zstring.tonumber(response.node.example._reward_type) == 14 then 
									state_machine.excute("gain_reward_news_send", 0, {response.node, response.node.example})
									_ED.union_fight_reward_info = nil
								end
							end
						end
						
					end
					protocol_command.draw_reward_center.param_list = "".."1".."\r\n".._rewardId..",".._rewardType
					NetworkManager:register(protocol_command.draw_reward_center.code, nil, nil, nil, RewardCell, responsePropCompoundCallback, false, nil)
				end
			  return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(reward_gain_button_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_GainRewardListCell_terminal()
end


function GainRewardListCell:getRewardTime(n)

	-- 在线时间 0 表示在线, 大于0表示离线时间,毫秒转为分钟做单位,直接取整
	local current_interval = n
	local timeString = ""
	if current_interval > 0 then
		
		local week	= math.floor(tonumber(current_interval)/3600/24/7)
		local day	= math.floor(tonumber(current_interval)/3600/24)
		local hour = math.floor(tonumber(current_interval)/3600%24)
		local minute  = math.floor((tonumber(current_interval)%3600)/60)
		minute = math.max(minute,1)
		
		
		if week > 0 then
			timeString 	= timeString..week..tipStringInfo_time_info[3]..tipStringInfo_time_info[9]
		elseif day > 0 then
			timeString 	= timeString..day..tipStringInfo_time_info[4]..tipStringInfo_time_info[9]
		elseif hour > 0 then
			timeString 	= timeString..hour..tipStringInfo_time_info[5]..tipStringInfo_time_info[9]
		elseif minute > 0 then
			timeString 	= timeString..minute..tipStringInfo_time_info[6]..tipStringInfo_time_info[9]
		end
	
	else
		timeString = tipStringInfo_time_info[8]
	
	end

	return timeString

end

function GainRewardListCell:upDataDraw()
	local root = self.roots[1]
	
	local RewardName = ccui.Helper:seekWidgetByName(root, "Text_21")	--奖励类型：名字
	local RewardCount = ccui.Helper:seekWidgetByName(root, "Text_22")	--奖励介绍
	local RewardListView = ccui.Helper:seekWidgetByName(root, "ListView_21")	--奖励内容
	
	local times = os.time() - self.example._reward_time
	ccui.Helper:seekWidgetByName(root, "Text_25"):setString(self:getRewardTime(times))
	
	-- 奖励类型(0:竞技场 1:竞技场幸运 2:gm发放 3:VIP宝箱)
	-- 物品1类型(1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:武将 9:鬼道 10: 决斗荣誉)
	if tonumber(self.example._reward_type) == 0 then
		RewardName:setString(_string_piece_info[185])
		RewardCount:setString(_string_piece_info[186]..self.example._reward_describe.._string_piece_info[187])
	elseif tonumber(self.example._reward_type) == 1 then
		RewardName:setString(_string_piece_info[190])
		RewardCount:setString(self.example._reward_describe)
		
	elseif tonumber(self.example._reward_type) == 2 then
		RewardName:setString(_string_piece_info[188])
		RewardCount:setString(self.example._reward_describe)
		
	elseif tonumber(self.example._reward_type) == 3 then
		RewardName:setString(_string_piece_info[189])
		RewardCount:setString(self.example._reward_describe)
	elseif tonumber(self.example._reward_type) == 12 then
		RewardName:setString(_string_piece_info[357])
		RewardCount:setString(self.example._reward_describe)
	elseif tonumber(self.example._reward_type) == 13 then
		RewardName:setString(_string_piece_info[402])
		RewardCount:setString(self.example._reward_describe)
	elseif tonumber(self.example._reward_type) == 15 then
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
			RewardName:setString(_string_piece_info[424])
			RewardCount:setString(self.example._reward_describe)
		end
	elseif tonumber(self.example._reward_type) == 14 then 
		--公会奖励
		RewardName:setString(tipStringInfo_union_str[71])
		RewardCount:setString(self.example._reward_describe)
	elseif tonumber(self.example._reward_type) == 16 then 
		--宠物副本排行榜奖励
		RewardName:setString(_pet_tipString_info[39])
		RewardCount:setString(self.example._reward_describe)
	end
	for i=1, tonumber(self.example._reward_item_count) do
		local tempItem = self.example._reward_list[i]
		if tonumber(self.example._reward_list[i].prop_type) == 6 then	--道具
			-- local cell = PropIconCell:createCell()
			-- cell:init(26, tostring(tempItem.prop_item),  tempItem.item_value)
			-- RewardListView:addChild(cell)
			local cell = self:getItemCell(tostring(tempItem.prop_item),nil,tempItem.item_value)
			RewardListView:addChild(cell)
		elseif tonumber(self.example._reward_list[i].prop_type) == 7 then	--装备
			local cell = EquipIconCell:createCell()
			cell:init(11, nil, tostring( tempItem.prop_item), nil, nil, tempItem.item_value)
			RewardListView:addChild(cell)
		elseif tonumber(self.example._reward_list[i].prop_type) == 8 then	--武将
			local cell = ShipHeadCell:createCell()
			cell:init(nil, 13,  tostring(tempItem.prop_item), tempItem.item_value)
			RewardListView:addChild(cell)
		elseif tonumber(self.example._reward_list[i].prop_type) == 1 then	--银币
			local cell = propMoneyIcon:createCell()
			cell:init("1",tempItem.item_value,nil)
			RewardListView:addChild(cell)
		elseif tonumber(self.example._reward_list[i].prop_type) == 2 then	--金币
			local cell = propMoneyIcon:createCell()
			cell:init("2",tempItem.item_value,nil)
			RewardListView:addChild(cell)
		elseif tonumber(self.example._reward_list[i].prop_type) == 3 then	--声望
			local cell = propMoneyIcon:createCell()
			cell:init("3",tempItem.item_value,nil)
			RewardListView:addChild(cell)
		elseif tonumber(self.example._reward_list[i].prop_type) == 4 then	--将魂
			local cell = propMoneyIcon:createCell()
			cell:init("4",tempItem.item_value,nil)
			RewardListView:addChild(cell)
		elseif tonumber(self.example._reward_list[i].prop_type) == 5 then	--魂玉
			local cell = propMoneyIcon:createCell()
			cell:init("5",tempItem.item_value,nil)
			RewardListView:addChild(cell)
		elseif tonumber(self.example._reward_list[i].prop_type) == 10 then	--决斗荣誉
			local cell = propMoneyIcon:createCell()
			cell:init("6",tempItem.item_value,nil)
			RewardListView:addChild(cell)
		elseif tonumber(self.example._reward_list[i].prop_type) == 11 then	--功勋
			local cell = propMoneyIcon:createCell()
			cell:init("7",tempItem.item_value,nil)
			RewardListView:addChild(cell)
		elseif tonumber(self.example._reward_list[i].prop_type) == 14 then	--胜点(排位赛)
			local cell = propMoneyIcon:createCell()
			cell:init("29",tempItem.item_value,nil)
			RewardListView:addChild(cell)
		elseif tonumber(self.example._reward_list[i].prop_type) == 15 then	--驯兽魂
			local cell = propMoneyIcon:createCell()
			cell:init("33",tempItem.item_value,nil)
			RewardListView:addChild(cell)
		elseif  tonumber(self.example._reward_list[i].prop_type) == 31 then	--战神令
			local cell = propMoneyIcon:createCell()
			cell:init("31",tempItem.item_value,nil)
			RewardListView:addChild(cell)
		end
	end
	RewardListView:requestRefreshView()
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_22"), nil, 
		{
			terminal_name = "reward_gain_button", 
			terminal_state = 0, 
			rewardId = self.example._reward_centre_id,
			rewardType = self.example._reward_type,
			_cell = self,
			isPressedActionEnabled = true
		},
		nil,0)	
end

--道具
function GainRewardListCell:getItemCell(mid,mtype,count,isCertainly)
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

function GainRewardListCell:onEnterTransitionFinish()
    local csbGainRewardListCell = csb.createNode("activity/award_center_list.csb")
	local root = csbGainRewardListCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
    self:addChild(root)
	self:setContentSize(root:getChildByName("Panel_22"):getContentSize())
	
	-- 列表控件动画播放
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
	else
		local action = csb.createTimeline("activity/award_center_list.csb")
	    root:runAction(action)
	    action:play("list_view_cell_open", false)
	end
	
	self:upDataDraw()
	
end

function GainRewardListCell:init(example)
	self.example = example
end


function GainRewardListCell:createCell()
	local cell = GainRewardListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function GainRewardListCell:onExit()
end