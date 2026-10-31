-- ----------------------------------------------------------------------------------------------------
-- 说明：活动子界面
-------------------------------------------------------------------------------------------------------
AdventureActivityInterface = class("AdventureActivityInterfaceClass", Window)
    
function AdventureActivityInterface:ctor()
    self.super:ctor()
    self.roots = {}
	self.listView = nil
	self.current_type = 1
	self.enum_type = {
		ACTIVITY_PACKAGE_EXCHANGE 							= 1,	-- 	1:礼包兑换
		ACTIVITY_CUMULATIVE_RECRUIT 						= 2,	-- 	2:累计招募
		ACTIVITY_DEKARON_BOSS 								= 3,	-- 	3:挑战boss
		ACTIVITY_CUMULATIVE_FIRE 							= 4,	-- 	4:累计解雇
		ACTIVITY_GIFTS			 							= 5,	-- 	5:友情送礼
		ACTIVITY_CUSTOMS_CLEARANCE			 				= 6	,	-- 	6:过关斩将
		ACTIVITY_XUEYUXINFENG			 					= 7	,	-- 	7:血雨腥风
		ACTIVITY_CAPABILITY_UP			 					= 8	,	-- 	8:战力爆表
		ACTIVITY_BINQIANGMAZHUANG			 				= 9	,	-- 	9:兵强马壮
		ACTIVITY_COMPETITIVE_KING			 				= 10,	-- 	10:竞技王者
		ACTIVITY_CUMULATIVE_RECHARGE			 			= 11,	-- 	11:累计充值
		ACTIVITY_CUMULATIVE_CONSUMPTION			 			= 12,	-- 	12:累计消费
		ACTIVITY_FIRST_RECHARGE			 					= 13,	-- 	13:首充奖励
		ACTIVITY_COMPETITIVE_KING_TWO			 			= 14,	-- 	14:竞技王者(20胜利)
		ACTIVITY_DIAMONDS_RECRUIT			 				= 15,	-- 	15:血钻招募
		ACTIVITY_KILL_SOLDIER			 					= 16,	-- 	16:击杀杂兵
		ACTIVITY_SINGLE_RECHARGE			 				= 17,	-- 	17:单日充值
		ACTIVITY_SIGNIN_SIGN			 					= 18,	-- 	18:登陆签到
		ACTIVITY_SINGLE_SROCK_RECHARGE			 			= 19,	-- 	19:单笔充值
		ACTIVITY_CUMULATIVE_CONSUMPTION_LONG			 	= 20,	-- 	19:累计消费(长期) --69
		ACTIVITY_SIGNIN_SIGN_NEW			 				= 21,	-- 	21:新登入签到
	}
	app.load("client.adventure.activity.AdventureActivityIcon")
	app.load("client.adventure.activity.AdventureActivityPackageExchange")
	app.load("client.adventure.activity.AdventureActivityCumulativeRecruit")
	app.load("client.adventure.activity.AdventureActivityFirstRecharge")
    -- Initialize adventure activity window state machine.
    local function init_adventure_activity_interface_terminal()
		local adventure_activity_interface_update_terminal = {
            _name = "adventure_activity_interface_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

				local cell = params._datas.cell
				if tonumber(terminal._selcet_type) == tonumber(cell.current_type) then 
					-- 点击的是上次记录的,不刷新
					return true
				end
				terminal._selcet_type = tonumber(cell.current_type)
				
				self.current_type = zstring.tonumber(cell.current_type)
				self:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_activity_interface_receive_first_reward_terminal = {
            _name = "adventure_activity_interface_receive_first_reward",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responsePropCompoundCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						_ED.active_activity[4] = nil
						_ED.recruit_success_ship_id = ""
    					_ED.recruit_success_ship_ids = ""
						TipDlg.drawTextDailog(_string_piece_info[400])

						ccui.Helper:seekWidgetByName(response.node.roots[1], "Button_huode"):setVisible(false)
						state_machine.excute("adventure_activity_move_first_recharge", 0, 0)
					end
				end
				NetworkManager:register(protocol_command.draw_first_top_up_reward.code, nil, nil, nil, instance, responsePropCompoundCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_activity_interface_update_terminal)
		state_machine.add(adventure_activity_interface_receive_first_reward_terminal)
        state_machine.init()
    end
    
    -- call func init adventure activity window state machine.
    init_adventure_activity_interface_terminal()
end

function AdventureActivityInterface:init()
	return self
end

function AdventureActivityInterface:onUpdateDraw()
	local root = self.roots[1]
	local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
	-- 活动描述
	local Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	Text_1:setString(_activity_name[zstring.tonumber(self.current_type)])
	local  time = ""

	local description = ""
	--Text_1_0:setString(_activity_Description[zstring.tonumber(self.current_type)])

	local Button_huode = ccui.Helper:seekWidgetByName(root, "Button_huode")
	Button_huode:setVisible(false)
	local ListView_reward = ccui.Helper:seekWidgetByName(root, "ListView_reward")
	ListView_reward:removeAllItems()
	ListView_reward:jumpToTop()
	if self.current_type == self.enum_type.ACTIVITY_PACKAGE_EXCHANGE then--礼包兑换
		local cell = AdventureActivityPackageExchange:createCell()
		cell:init()
		ListView_reward:addChild(cell)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],"")

	elseif self.current_type == self.enum_type.ACTIVITY_FIRST_RECHARGE then--首冲奖励
		for i, v in pairs(_ED.active_activity[4].activity_Info) do	
			if zstring.tonumber(v.activityInfo_silver) > 0 then --银币
				local cell = AdventureActivityFirstRecharge:createCell()
				cell:init(1,v.activityInfo_silver,nil)
				ListView_reward:addChild(cell)
			end
			if zstring.tonumber(v.activityInfo_gold) > 0 then --金币
				local cell = AdventureActivityFirstRecharge:createCell()
				cell:init(2,v.activityInfo_gold,nil)
				ListView_reward:addChild(cell)
			end
			if zstring.tonumber(v.activityInfo_honour) > 0 then --声望
				local cell = AdventureActivityFirstRecharge:createCell()
				cell:init(3,v.activityInfo_honour,nil)
				ListView_reward:addChild(cell)
			end
			if zstring.tonumber(v.activityInfo_general_soul) > 0 then --荣耀碎片
				local cell = AdventureActivityFirstRecharge:createCell()
				cell:init(4,v.activityInfo_general_soul,nil)
				ListView_reward:addChild(cell)
			end
			if zstring.tonumber(v.activityInfo_prop_count) > 0 then --道具
				for j, w in pairs(v.activityInfo_prop_info) do	
					local cell = AdventureActivityFirstRecharge:createCell()
					cell:init(6, w.propMouldCount, w)
					ListView_reward:addChild(cell)
				end
			end
			-- if zstring.tonumber(v.activityInfo_equip_count) > 0 then --装备
				-- for j, w in pairs(v.activityInfo_equip_info) do	
					-- local cell = AdventureActivityFirstRecharge:createCell()
					-- cell:init(7,0,w)
					-- ListView_reward:addChild(cell)
				-- end
			-- end 
			if tonumber(_ED.recharge_rmb_number) == 0  then 
				Button_huode:setColor(cc.c3b(150, 150, 150))
			else
				--可以领取
				Button_huode:setColor(cc.c3b(255, 255, 255))
			end
			Button_huode:setVisible(true)
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[4].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[4].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = _activity_Description[zstring.tonumber(self.current_type)]

		end
	elseif self.current_type == self.enum_type.ACTIVITY_CUMULATIVE_RECHARGE then--累计充值
		for i, v in pairs(_ED.active_activity[7].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,7)
			ListView_reward:addChild(cell)
		end
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[7].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[7].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	
	elseif self.current_type == self.enum_type.ACTIVITY_CUMULATIVE_CONSUMPTION then--累计消费
		for i, v in pairs(_ED.active_activity[17].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,17)
			ListView_reward:addChild(cell)
		end
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[17].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[17].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)

	elseif self.current_type == self.enum_type.ACTIVITY_CUMULATIVE_CONSUMPTION_LONG then--累计消费
		for i, v in pairs(_ED.active_activity[69].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,69)
			ListView_reward:addChild(cell)
		end
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[69].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[69].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)

	elseif self.current_type == self.enum_type.ACTIVITY_CUMULATIVE_RECRUIT then--累计招募
		for i, v in pairs(_ED.active_activity[50].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,50)
			ListView_reward:addChild(cell)
		end
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[50].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[50].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	elseif self.current_type == self.enum_type.ACTIVITY_DEKARON_BOSS then--挑战boss
		for i, v in pairs(_ED.active_activity[51].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,51)
			ListView_reward:addChild(cell)
		end
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[51].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[51].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	elseif self.current_type == self.enum_type.ACTIVITY_CUMULATIVE_FIRE then--累计解雇
		for i, v in pairs(_ED.active_activity[52].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,52)
			ListView_reward:addChild(cell)
		end
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[52].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[52].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	elseif self.current_type == self.enum_type.ACTIVITY_GIFTS then--友情送礼
		
		for i, v in pairs(_ED.active_activity[53].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,53)
			ListView_reward:addChild(cell)
		end
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[53].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[53].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	elseif self.current_type == self.enum_type.ACTIVITY_CUSTOMS_CLEARANCE then--过关斩将
		for i, v in pairs(_ED.active_activity[54].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,54)
			ListView_reward:addChild(cell)
		end
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[54].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[54].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	elseif self.current_type == self.enum_type.ACTIVITY_XUEYUXINFENG then--血雨腥风
		for i, v in pairs(_ED.active_activity[55].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,55)
			ListView_reward:addChild(cell)
		end
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[55].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[55].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	elseif self.current_type == self.enum_type.ACTIVITY_CAPABILITY_UP then--战力爆表
		for i, v in pairs(_ED.active_activity[56].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,56)
			ListView_reward:addChild(cell)
		end
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[56].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[56].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	elseif self.current_type == self.enum_type.ACTIVITY_BINQIANGMAZHUANG then--兵强马壮
		for i, v in pairs(_ED.active_activity[57].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,57)
			ListView_reward:addChild(cell)
		end
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[57].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[57].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	elseif self.current_type == self.enum_type.ACTIVITY_COMPETITIVE_KING then--竞技王者
		for i, v in pairs(_ED.active_activity[58].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,58)
			ListView_reward:addChild(cell)
		end
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[58].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[58].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	elseif self.current_type == self.enum_type.ACTIVITY_COMPETITIVE_KING_TWO then--竞技王者(20胜利)
		for i, v in pairs(_ED.active_activity[59].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,59)
			ListView_reward:addChild(cell)
		end	
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[59].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[59].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	elseif self.current_type == self.enum_type.ACTIVITY_DIAMONDS_RECRUIT then--血钻招募
		for i, v in pairs(_ED.active_activity[60].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,60)
			ListView_reward:addChild(cell)
		end		
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[60].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[60].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	elseif self.current_type == self.enum_type.ACTIVITY_KILL_SOLDIER then--击杀杂兵
		for i, v in pairs(_ED.active_activity[61].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,61)
			ListView_reward:addChild(cell)
		end	
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[61].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[61].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)		
	elseif self.current_type == self.enum_type.ACTIVITY_SINGLE_RECHARGE then--单次充值
		for i, v in pairs(_ED.active_activity[21].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,21)
			ListView_reward:addChild(cell)
		end
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[21].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[21].end_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	elseif self.current_type == self.enum_type.ACTIVITY_SIGNIN_SIGN then--登陆签到
		for i, v in pairs(_ED.active_activity[24].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,24)
			ListView_reward:addChild(cell)

		end
		-- local begin_time = os.date("%Y".."."
		-- 										.."%m".."."
		-- 										.."%d".." "
		-- 										.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[24].begin_time)/1000))
		-- local end_time = os.date("%Y".."."
		-- 										.."%m".."."
		-- 										.."%d".." "
		-- 										.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[24].end_time1)))	
		-- time = string.format(_string_piece_info[399],begin_time,end_time)
		description = _activity_Description[zstring.tonumber(self.current_type)]
	elseif self.current_type == self.enum_type.ACTIVITY_SIGNIN_SIGN_NEW then--新登陆签到
		for i, v in pairs(_ED.active_activity[73].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,73)
			ListView_reward:addChild(cell)
		end
		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[73].begin_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[73].end_time1)))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	elseif self.current_type == self.enum_type.ACTIVITY_SINGLE_SROCK_RECHARGE then--单笔充值
		for i, v in pairs(_ED.active_activity[45].activity_Info) do	
			local cell = AdventureActivityCumulativeRecruit:createCell()
			cell:init(v,self.current_type,i,45)
			ListView_reward:addChild(cell)
		end	

		local begin_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[45].activity_over_time)/1000))
		local end_time = os.date("%Y".."."
												.."%m".."."
												.."%d".." "
												.."%H"..":".."%M", zstring.exchangeFrom(zstring.tonumber(_ED.active_activity[45].activity_draw_over_time)/1000))	
		time = string.format(_string_piece_info[399],begin_time,end_time)
		description = string.format(_activity_Description[zstring.tonumber(self.current_type)],time)
	end
	Text_1_0:setString(description)
	ListView_reward:requestRefreshView()
	
end

function AdventureActivityInterface:onEnterTransitionFinish()
	local csbAdventureActivityWindow = csb.createNode("activity/wonderful/zhanli_up.csb")
    local root = csbAdventureActivityWindow:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureActivityWindow)
	self:onUpdateDraw()
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_huode"),       nil, 
	{
		terminal_name = "adventure_activity_interface_receive_first_reward",
		cell = self,        
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
end

function AdventureActivityInterface:onExit()
	state_machine.remove("adventure_activity_interface_update")
end