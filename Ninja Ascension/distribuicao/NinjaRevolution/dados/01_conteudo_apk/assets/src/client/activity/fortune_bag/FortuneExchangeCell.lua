-- ----------------------------------------------------------------------------------------------------
-- 说明:排重福袋道具兑换
-------------------------------------------------------------------------------------------------------
FortuneExchangeCell = class("FortuneExchangeCellClass", Window)
	
function FortuneExchangeCell:ctor()
	self.super:ctor()
	self.roots = {}
	
	-- var
	self._activity_data = nil

	-- load lua files
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")

	-- Initialize april_fortune_bag_exchange_cell state machine.
	local function init_fortune_bag_exchange_cell_terminal()
		--兑换
		local april_fortune_bag_exchange_cell_exchange_terminal = {
			_name = "april_fortune_bag_exchange_cell_exchange",
			_init = function (terminal) 
			
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				local mIndex = params._datas.m_index
				local activityInfo = cell._activity_data
				local may_num = instance:mayExchangeNum(activityInfo)
				if may_num > 0 then
					local function responseExchangeCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil then
								response.node:onUpdateDraw(true)

								app.load("client.reward.DrawRareReward")
								local getRewardWnd = DrawRareReward:new()
								getRewardWnd:init(7)
								fwin:open(getRewardWnd, fwin._ui)
								state_machine.excute("fortune_bag_refesh_windows",0,{m_page = 3})
							end
						end
					end
					local cell = params._datas.cell
					protocol_command.lucky_match_exchange_prop.param_list = ""..mIndex
					NetworkManager:register(protocol_command.lucky_match_exchange_prop.code, nil, nil, nil, cell, responseExchangeCallback, false, nil)
				else
					TipDlg.drawTextDailog(_string_piece_info[85])
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(april_fortune_bag_exchange_cell_exchange_terminal)
		state_machine.init()
	end
	
	-- call func init april_fortune_bag_exchange_cell state machine.
	init_fortune_bag_exchange_cell_terminal()
end
--返回可以兑换的物品数量
function FortuneExchangeCell:mayExchangeNum(activityInfo)
	local exchangeInfos = zstring.split(activityInfo.needProp, "|")
	local may_num = 0
	for i, v in pairs(exchangeInfos) do
		local info = zstring.split(v,",")
		local needPropItemNum = tonumber(info[3])
		local needMouldId = tonumber(info[2])
		local had_num = tonumber(getPropAllCountByMouldId(needMouldId))
		local cur_num =	math.floor(had_num / needPropItemNum )
		if may_num == 0 and cur_num > 0 then
			may_num = cur_num
		end
		if cur_num < may_num then
			may_num = cur_num
		end
	end
	return may_num
end

function FortuneExchangeCell:onUpdateDraw(update)
	local root = self.roots[1]
	local activityInfo = self._activity_data
	-- 剩余次数
	local remainNumber = activityInfo.remainNumber
	-- 总次数
	local totalNumber = activityInfo.totalNumber

	-- 交换条件
	local exchangeInfos = zstring.split(activityInfo.needProp, "|")
	-- 交换奖励
	local rewardInfo = 	zstring.split(activityInfo.exchangeProp,",")
	-- 标题
	local Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")

	local propType = tonumber(rewardInfo[1])
	local propId = tonumber(rewardInfo[2])
	local porp_name = nil 
	if 1 == propType or 
		2 == propType or 
		3 == propType or 
		9 == propType or
		10 == propType
		 then 
		porp_name = _my_gane_name[propType]
	elseif 4 == propType then 
		porp_name = _my_gane_name[5]
	elseif 6 == propType then
		local property = dms.int(dms["prop_mould"],propId,prop_mould.prop_name)
		local porp_name_word = dms.element(dms["word_mould"], property)
		porp_name = porp_name_word[3]
	elseif 7 == propType then 
		local nameindex = dms.int(dms["equipment_mould"], propId, equipment_mould.equipment_name)
		local word_info = dms.element(dms["word_mould"], nameindex)
		porp_name = word_info[3]	
	elseif 8 == propType then 
		porp_name = _my_gane_name[7]
	elseif 12 == propType then 
		porp_name = _my_gane_name[8]
	elseif 13 == propType then 
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_l_naruto then
			local evo_image = dms.string(dms["ship_mould"], propId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], propId, ship_mould.captain_name)]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			porp_name = word_info[3]
		else
			name = dms.string(dms["ship_mould"],propId, ship_mould.captain_name)
		end	
	elseif 18 == propType then 
		porp_name = _my_gane_name[6]
	elseif 20 == propType then 
		porp_name = _my_gane_name[11]
	elseif 28 == propType then 
		porp_name = _my_gane_name[13]
	elseif 31 == propType then 
		porp_name = red_alert_resouce_tip[1][1]
	elseif 33 == propType then 
		porp_name = _my_gane_name[14]
	elseif 34 == propType then 
		porp_name = _my_gane_name[15]
	elseif 71 == propType then
		local nameindex = dms.int(dms["ship_silk_bag_mould"], propId, ship_silk_bag_mould.silkbag_name)
		local word_info = dms.element(dms["word_mould"], nameindex)
		porp_name = word_info[3]
	elseif 73 == propType then
		local pos = dms.int(dms["fight_spirit_mould"], propId, fight_spirit_mould.pos)
		local suitId = dms.int(dms["fight_spirit_mould"], propId, fight_spirit_mould.suit_id)
		porp_name = dms.element(dms["word_mould"], dms.int(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.suit_name))[3].."."..chinese_num[pos]
	end

	if nil == porp_name or "" == porp_name  then 
		porp_name = ""
	end

	Text_11:setString(porp_name)

	-- 兑换次数
	self.Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")
	local nCount = remainNumber
	self.Text_13:setString(remainNumber .. "/" .. totalNumber)
	self.Text_13._def_color = self.Text_13:getColor()
	if nCount <= 0 then
		self.Text_13:setColor(cc.c3b(recruit_preview_tip_color[6][1], recruit_preview_tip_color[6][2], recruit_preview_tip_color[6][3]))

		self.Button_lingqu:setBright(false)
		self.Button_lingqu:setTouchEnabled(false)
		self.Button_lingqu:setHighlighted(true)
	else
		self.Text_13:setColor(self.Text_13._def_color)

		self.Button_lingqu:setBright(true)
		self.Button_lingqu:setTouchEnabled(true)
		self.Button_lingqu:setHighlighted(false)
	end

	self.nCount = nCount

	local ListView_011_2_0 = ccui.Helper:seekWidgetByName(root, "ListView_011_2_0")
	for i, v in pairs(exchangeInfos) do
		local info = zstring.split(v,",")
		local needPropIcon = ResourcesIconCell:createCell()
		needPropIcon:init(tonumber(info[1]), tonumber(info[3]), tonumber(info[2]), nil,nil,true,true,1)
		ListView_011_2_0:addChild(needPropIcon)
	end

	local Panel_reward_2 = ccui.Helper:seekWidgetByName(root, "Panel_reward_2")
	local rewardIcon = ResourcesIconCell:createCell()
	if rewardInfo[4] then
		rewardIcon:init(tonumber(rewardInfo[1]), tonumber(rewardInfo[3]), rewardInfo[2], nil,nil,true,true,1,{shipStar = tonumber(rewardInfo[4])})
	else
		rewardIcon:init(tonumber(rewardInfo[1]), tonumber(rewardInfo[3]), rewardInfo[2], nil,nil,true,true,1)
	end
	Panel_reward_2:addChild(rewardIcon)
end
function FortuneExchangeCell:onInit()
	local csbFortuneExchangeCell = csb.createNode("activity/wonderful/april_fools_day_list.csb")
	local root = csbFortuneExchangeCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	self:clearUIInfo()
	self:setContentSize(root:getChildByName("Panel_land_list"):getContentSize())

	-- 兑换奖励
	self.Button_lingqu = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12_4"), nil,
	{
		terminal_name = "april_fortune_bag_exchange_cell_exchange",
		terminal_state = 0,
		isPressedActionEnabled = true,
		cell = self,
		m_index = self._activity_data.index
	}, nil, 0)

	self:onUpdateDraw()
end

function FortuneExchangeCell:onExit()
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("activity/wonderful/april_fools_day_list.csb", root)
	-- ]]
end

function FortuneExchangeCell:init(activity)
	self._activity_data = activity
	self:onInit()
end

function FortuneExchangeCell:createCell()
	local cell = FortuneExchangeCell:new()
	cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell)
	return cell
end

function FortuneExchangeCell:clearUIInfo()
	local root = self.roots[1]
	if root == nil then
        return
    end
	if root._x ~= nil then
        root:setPositionX(root._x)
    end
    if root._y ~= nil then
        root:setPositionY(root._y)
    end
	local ListView_011_2_0 = ccui.Helper:seekWidgetByName(root, "ListView_011_2_0")
	ListView_011_2_0:removeAllChildren(true)
	local Panel_reward_2 = ccui.Helper:seekWidgetByName(root, "Panel_reward_2")
	Panel_reward_2:removeAllChildren(true)
	local Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")
	Text_13:setString("")
end

function FortuneExchangeCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:clearUIInfo()
	self:registerOnNoteUpdate(self)
	self:onInit()
end

function FortuneExchangeCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("activity/wonderful/april_fools_day_list.csb", root)
	
	self.roots = {}
end