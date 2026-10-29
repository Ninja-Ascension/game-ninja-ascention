-- ----------------------------------------------------------------------------------------------------
-- 说明：皮肤兑换
-- 创建时间：2018-7-24
-- 作者：shinefeng
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
SkinExchangeRestrictionCell = class("SkinExchangeRestrictionCellClass", Window)
    
function SkinExchangeRestrictionCell:ctor()
	self.super:ctor()
	self.roots = {}
	
	-- var
	self.activity = nil
	self.index = 0

	-- load lua files
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.ship.hero_icon_list_cell")
	app.load("client.packs.hero.SmRoleFashionCard")
	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.reward.DrawRareReward")
	app.load("client.cells.prop.prop_money_icon")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	--app.load("client.shop.recruit.HeroRecruitSuccessTen")
	app.load("client.shop.recruit.HeroRecruitSuccess")

	-- Initialize emblem_limit_time_exchange_cell state machine.
	local function init_skin_exchange_restriction_cell_terminal()
		--兑换
		local skin_limit_time_exchange_cell_exchange_terminal = {
			_name = "skin_limit_time_exchange_cell_exchange",
			_init = function (terminal) 
			
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				local activity_skin_id = cell.activity_skin_id
				local ship_mould_id = dms.int(dms["ship_skin_mould"], tonumber(activity_skin_id), ship_skin_mould.ship_mould_id)
				local getShipByTemplateId = getShipByTemplateId(ship_mould_id)
				local activityId = nil
				if getShipByTemplateId and getShipByTemplateId ~= "" then
	            	local skin_info = zstring.splits(getShipByTemplateId.ship_skin_info, "|", ":")
	            	local have_id_t = nil
	            	local skin_info_r = zstring.split(getShipByTemplateId.ship_skin_info, "|")
	            	if skin_info_r and skin_info_r ~= nil and skin_info_r[2] ~= nil then
			            for i,v in ipairs(zstring.split(skin_info_r[2], ",")) do
			                local have_id_r = zstring.split(v, ":")[1]
			                local unlock_condition  = dms.int(dms["ship_skin_mould"], have_id_r, ship_skin_mould.unlock_condition)
			                if unlock_condition == -1 then
			                    have_id_t = have_id_r
			                end
			                local duration  = dms.int(dms["ship_skin_mould"], have_id_t, ship_skin_mould.duration)
			                if duration == -1 then
			                	activityId = have_id_t
			                end
			            end
			        end
	            end
				local function responseExchangeCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil then
							response.node:onUpdateDraw(true)
							------刷新排序
							if response.node.nCount == 0 then
								state_machine.excute("activity_skin_exchange_restriction_limit_update_draw",0,"")
							end

							app.load("client.reward.DrawRareReward")
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd, fwin._ui)


							getSceneReward(64)
                            _ED.show_reward_list_group_ex = {}
                            local obj = HeroRecruitSuccess:new()
                            obj:setRanking(herorIndex,m_type,false,nil,nil,nil,activityId,64,activity_skin_id)
                            fwin:open(obj,fwin._ui)
                            state_machine.excute("menu_hide_event", 0, "menu_hide_event.")

                            _ED.prop_chest_store_recruiting = true
						end							
					end
				end 
				protocol_command.get_activity_reward.param_list = cell.activity.activity_id.."\r\n" .. ""..tonumber(cell.index - 1).."\r\n".."0"
				NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, cell, responseExchangeCallback, false, nil)

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		state_machine.add(skin_limit_time_exchange_cell_exchange_terminal)
		state_machine.init()
	end
	
	-- call func init emblem_limit_time_exchange_cell state machine.
	init_skin_exchange_restriction_cell_terminal()
end

function SkinExchangeRestrictionCell:onUpdateDraw(update)
	local root = self.roots[1]
	local activityInfo = self.activity.activity_Info[tonumber(self.index)]
	local countInfos = zstring.split(self.activity.activity_params, ",")

	local activityInfo_need_day = activityInfo.activityInfo_need_day

	local exchangeInfos = zstring.split(activityInfo.activityInfo_need_day, ",")
	--local itemInfos = zstring.splits(exchangeInfos,",")

	-- 标题
	local Text_11 = ccui.Helper:seekWidgetByName(root, "Text_11")
	Text_11:setString(activityInfo.activityInfo_name)


	-- 兑换次数
	self.Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")
	local nCount = (1 - tonumber(countInfos[self.index]))
	self.Text_13:setString(nCount .. "/" .. 1)
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

	if true ~= update then
		local ListView_011_2_0 = ccui.Helper:seekWidgetByName(root, "ListView_011_2_0")
		--for i, info in pairs(#(activityInfo_need_day)) do
			local needPropIcon = ResourcesIconCell:createCell()

			needPropIcon:init(tonumber(exchangeInfos[1]), tonumber(exchangeInfos[2]), -1, nil,nil,true,true,1)
			ListView_011_2_0:addChild(needPropIcon)
			-- 设置数量颜色
			-- local item_order_level = ccui.Helper:seekWidgetByName(needPropIcon.roots[1], "Label_l-order_level") -- 右下角等级，数量
			-- item_order_level:setVisible(true)
		--end


		if "" ~= activityInfo.activityInfo_reward_select then
			local rewardInfo = zstring.splits(activityInfo.activityInfo_reward_select, "|", ",")[1]
			local limit_time_index  = dms.int(dms["ship_skin_mould"], tonumber(rewardInfo[2]), ship_skin_mould.duration)
			local des_time_r = zstring.tonumber(limit_time_index) == -1 and tipStringInfo_evolution_status_tips[4] or limit_time_index .. tipStringInfo_evolution_status_tips[5]
			local Panel_reward_2 = ccui.Helper:seekWidgetByName(root, "Panel_reward_2")
			local rewardIcon = HeroIconListCell:createCell()

			if tonumber(rewardInfo[1]) == 64 then

		        rewardIcon = ResourcesIconCell:createCell()
		        rewardIcon:init(64, 0, rewardInfo[2], nil, nil, true, true, 1,{des_time = des_time_r, skin_num = 1})
		        self.activity_skin_id = rewardInfo[2]
			else
			end
			Panel_reward_2:setPosition(Panel_reward_2:getPositionX(), Panel_reward_2:getPositionY())
			Panel_reward_2:addChild(rewardIcon)
		end
	end
end
function SkinExchangeRestrictionCell:onInit()
	local csbSkinExchangeRestrictionCell = csb.createNode("activity/wonderful/april_fools_day_list.csb")
	local root = csbSkinExchangeRestrictionCell:getChildByName("root")
	table.insert(self.roots, root)
	root:removeFromParent(false)
	self:addChild(root)
	
	self:setContentSize(root:getChildByName("Panel_land_list"):getContentSize())

	-- 兑换奖励
	self.Button_lingqu = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_12_4"), nil,
	{
		terminal_name = "skin_limit_time_exchange_cell_exchange",
		terminal_state = 0,
		isPressedActionEnabled = true,
		cell = self,
	}, nil, 0)

	self:onUpdateDraw()
end

function SkinExchangeRestrictionCell:onExit()
end

function SkinExchangeRestrictionCell:init(activity, index, listView)
	self.activity = activity
	self.index = index
	self.listView = listView
	self:onInit()
end

function SkinExchangeRestrictionCell:createCell()
	local cell = SkinExchangeRestrictionCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end