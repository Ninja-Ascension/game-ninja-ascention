----------------------------------------------------------------------------------------------------
-- 说明：的小图标绘制
-- 物品1类型：
--	1:银币 
--	2:金币 
--	3:声望 
--	4:将魂 
--	5:魂玉 
--	6:道具 
--	7:装备 
--	8:经验 
--	9:耐力 
--	10:功能点 
--	11:上阵人数 
--	12:体力
--	13:武将 
--	14:竞技场排名
-- 	72:神兽整卡显示
-------------------------------------------------------------------------------------------------------
ResourcesIconCell = class("ResourcesIconCellClass", Window)
ResourcesIconCell.__size = nil
ResourcesIconCell.__big_size = nil

function ResourcesIconCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.prop = nil		-- 当前要绘制的道具实例数据对对象
	self.propName = "" --道具名称
	self.showTip = false --是否弹出提示
	self.isLongTouch = nil -- 长按弹出信息
	self.quality = 0 -- 品质
	self.enum_type = {
		SILVER_COIN_INFORMATION = 1,				-- 	1:银币
		GOLD_COIN_INFORMATION = 2,					--	2:金币 
		REPUTATION_INFORMATION = 3,					--	3:声望 
		HERO_SOUL_INFORMATION = 4,					--	4:将魂 
		SOUL_JADE_INFORMATION = 5,					--	5:魂玉 
		PROP_INFORMATION = 6,						--	6:道具 
		EQUIPMENT_INFORMATION = 7,					--	7:装备 
		EXPERIENCE_INFORMATION = 8,					--	8:经验 
		ENDURANCE_INFORMATION = 9,					--	9:耐力 
		FUNCTION_INFORMATION = 10,					--	10:功能点 
		BATTLE_NUMBER_PEOPLE_INFORMATION = 11,		--	11:上阵人数 
		PHYSICAL_STRENGTH_INFORMATION = 12,			--	12:体力
		HERO_INFORMATION = 13,						--	13:武将 
		AREAN_RANK_INFORMATION = 14,				--	14:竞技场排名
		DPS_INFORMATION = 15,						--	15:伤害
		DUEL_INFORMATION = 16,						--	16:比武积分
		POWER_INFORMATION = 17,						--	17:霸气
		GLORIES_INFORMATION= 18,					--	18:威名
		DAILYTASK_SCORE_INFORMATION = 19,			--	19:日常任务积分
		FEATS_INFORMATION = 20,						--	20:功勋
		BATTLE_ACHIEVEMENT_INFORMATION = 21,		--	21:战功
		RECHARGE_SHOP_INFORMATION = 22,				--	22:充值商店
		UNION_CONTRIBUTION = 28,             		--  28:军团贡献
		WAR_INFORMATION = 31,             			--  31:战神令
		PET_SOUL_INFORMATION = 33,             		--  33:驯兽魂
		TALENT_POINT = 34,             				--  34:天赋点

		VIP_EXPERIENCE = 39,             			--  39:VIP经验
		SKIN_COIN_INFORMATIO = 64,                  -- 皮肤
		ALLOY_MATRIX = 66,             				--  66:数码合金
		MATRIX_ESSENCE = 67,             		    --  66:数码合金精华
		EXPLORE_MONEY = 68,							-- 68:探索币
		HOLY_ESSENCE = 69,							-- 69:圣物精华
		EXPLORE_MONEY1 = 70,						-- 70:探索币（口袋）
		SILKBAG_INFORMATION=71,						-- 71:锦囊
		MAGIC_ANIMAL_INFORMATION=72,				-- 72:神兽整卡
		FIGHT_SPIRIT=73,							-- 73:战魂
		CASH_VOUCHER = 74,							-- 74:代金券
		WAR_ORDER_COIN = 75,						-- 75:战令经验代币
		HEAD_FRAME = 76,							-- 76:头像框
	}
	-- images/face/prop_head/props_%d.png
	self.res_data = {
		{0,"images/ui/props/props_4002.png", _All_tip_string_info._fundName},				-- 	1:银币
		{4,"images/ui/props/props_4001.png", _All_tip_string_info._crystalName},			-- 	2:金币 
		{3,"images/ui/props/props_4004.png", _All_tip_string_info._reputation},--  3:声望 
		{4,"images/ui/props/props_4007.png", _All_tip_string_info._hero},			-- 	4:将魂 
		{3,"images/ui/props/props_3000.png", _All_tip_string_info._juexingsuipian},			-- 	5:魂玉 (水雷魂)
		{0,"images/ui/props/props_2134.png", " "},				-- 	6:道具
		{0,"images/ui/props/props_2142.png", " "},				-- 	7:装备 
		{4,"images/ui/props/props_4003.png", reward_prop_list[8]},				-- 	8:经验
		{0,"images/ui/props/props_3030.png", " "},				-- 	9:耐力 
		{0,"images/ui/props/props_3315.png", " "},				-- 	10:功能点
		{0,"images/ui/props/props_20123.png", " "},				-- 	11:上阵人数 
		{4,"images/ui/props/props_4005.png", _All_tip_string_info._energyName},					--	12:体力
		{0,"images/ui/button/diaoluo_wujiang_small.png", " "},	-- 	13:武将 
		{0,"images/ui/button/icon_pj_paihangbang.png", " "},	-- 	14:竞技场排名
		{0,"images/ui/button/icon_pj_paihangbang.png", " "},	-- 	15:伤害 
		{0,"images/ui/button/icon_pj_paihangbang.png", " "},	-- 	16:比武积分 
		{0,"images/ui/button/icon_pj_paihangbang.png", " "},	-- 	17:霸气 
		{0,"images/ui/props/props_4006.png", _All_tip_string_info._glories},	-- 	18:威名 
		{0,"images/ui/button/icon_pj_paihangbang.png", " "},	-- 	19:日常任务积分 
		{0,"images/ui/icon/icon_juntuan.png", " "},				-- 	20:功勋 
		{0,"images/ui/icon/icon_zhangong.png", " "},			-- 	21:战功
		{4," ", " "},											-- 	22:日常副本基本奖励
		{4," ", " "},											-- 	23:日常副本额外奖励
		{4," ", " "},											-- 	24:出击令
		{4," ", " "},											-- 	25:免战
		{4," ", " "},											-- 	26:
		{4," ", " "},											-- 	27:
		{0,"images/ui/props/props_4013.png", _All_tip_string_info._union_exploit},			-- 	28:军团贡献
		{4," ", " "},											-- 	29
		{4," ", " "},											-- 	30
		{0,"images/ui/props/props_4016.png", ""},				-- 	31
		{0,"", ""},				-- 	32
		{4,"images/ui/props/props_3088.png", _my_gane_name[14]},				-- 	33:驯兽魂
		{4,"images/ui/props/props_4008.png", _my_gane_name[15]},				-- 	34:天赋点
		{3,"", ""},				-- 	35
		{3,"", ""},				-- 	36
		{3,"", ""},				-- 	37
		{3,"", ""},				-- 	38
		{4,"images/ui/props/props_4039.png", _my_gane_name[17]},				-- 	39 VIP经验
		[64] = {0,"images/ui/props/props_100101.png", _All_tip_string_info._skinName},       -- 皮肤
		[66] = {0,"", ""},				-- 	66 合金
		[67] = {3, "images/ui/props/props_4067.png", _All_tip_string_info._matrix_essence},				-- 	67 合金精华
		[68] = {3, "images/ui/props/props_4009.png", _All_tip_string_info._explore_money},				-- 	68 探索币
		[69] = {3, "images/ui/props/props_4069.png", _All_tip_string_info._holy_essence},				-- 	69 圣物精华
		[70] = {3, "images/ui/props/props_4009.png", _All_tip_string_info._explore_money},				-- 	70 探索币（口袋）
		[71] = {0, "images/ui/props/props_6201.png", " "},		                                        --	71 锦囊
		[72] = {0, "images/ui/props/props_6201.png", " "},		                                        --	71 锦囊
		[73] = {0, "images/ui/props/props_6201.png", " "},												--  73 战魂
		[74] = {0, "images/ui/props/props_6201.png", " "},												--  74 代金券
		[75] = {2, "image/activity/passport/activity_passport_icon_exchange.png", " "},					--  75 战令经验代币
		[76] = {6, "", " "},																			--  76 头像框
	}
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		self.res_data[28] = {3,"images/ui/props/props_4013.png", _All_tip_string_info._union_exploit}
		self.res_data[63] = {4,"images/ui/props/props_4063.png", _my_gane_name[16]}
		for i , v in pairs(_props_image_name) do 
			if v ~= nil and v ~= "" then
				local infor = zstring.split(v , ",")
				if self.res_data[i] ~= nil then
					self.res_data[i][1] = tonumber(infor[2])
				end
			end
		end
	end
	self.rewardType = nil
	self.current_type = 0
	self.item_count = 0
	self.mould_id = nil
	app.load("client.cells.prop.prop_money_info")
	app.load("client.cells.prop.prop_information")
	app.load("client.cells.prop.sm_hero_information")
	app.load("client.cells.prop.vouchers_information")
	app.load("client.l_digital.cultivate.matrix.AlloyMatrixHold")
	app.load("client.l_digital.cultivate.silkbag.SilkBagHold")
	app.load("client.l_digital.cultivate.mythicalAnimals.MythicalAnimalsTip")
	app.load("client.shop.recharge.RechargeVoucher")
	app.load("client.l_digital.cells.player.head_frame_information")
	
	local function init_resource_icon_cell_terminal()
		local prop_money_icon_cell_show_info_terminal = {
            _name = "resource_icon_cell_show_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	app.load("client.cells.prop.prop_money_info")
            	if fwin:find("propInformationClass") ~= nil then
            		fwin:close(fwin:find("propInformationClass"))
            	end
            	if fwin:find("propMoneyInfoClass") ~= nil then
            		fwin:close(fwin:find("propMoneyInfoClass"))
            	end
				local prop = params._datas._prop
				local cell = propMoneyInfo:new()
				cell:init("" .. prop)
				fwin:open(cell, fwin._dialog)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --显示道具信息
		local resource_icon_cell_show_prop_info_terminal = {
            _name = "resource_icon_cell_show_prop_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	if fwin:find("propInformationClass") ~= nil then
            		fwin:close(fwin:find("propInformationClass"))
            	end
            	if fwin:find("propMoneyInfoClass") ~= nil then
            		fwin:close(fwin:find("propMoneyInfoClass"))
				end
				if fwin:find("SilkBagHoldClass") ~= nil then
					fwin:close(fwin:find("SilkBagHoldClass"))
				end
				if fwin:find("MythicalAnimalsTipClass") ~= nil then
					fwin:close(fwin:find("MythicalAnimalsTipClass"))
				end
            				
            	local types = params._datas._prop
            	local mould_id = params._datas._id
            	if mould_id == -1 then 
            		app.load("client.cells.prop.prop_money_info")
					local prop = params._datas._prop
					local cell = propMoneyInfo:new()
					cell:init("" .. types)
					fwin:open(cell, fwin._dialog)
            	else
            		if types== 6 then
            			--道具
            			app.load("client.cells.prop.prop_information")
		        		local cell = propInformation:new()
						cell:init({user_prop_template = mould_id},1)
						fwin:open(cell, fwin._windows)
					elseif types == 7 then 
						--装备
						app.load("client.packs.equipment.EquipFragmentInfomation")
						local prop = mould_id
						if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto then
							if  dms.int(dms["equipment_mould"], prop, equipment_mould.equipment_type) == 6 then
								app.load("client.packs.fashion.FashionInformation")
			            		state_machine.excute("fashion_information_open", 0, {_datas={_equip = nil,_equip_mould = prop}})
		            			return true
		            		end
		            	end
						local FragmentInformation = EquipFragmentInfomation:new()
						
						if dms.int(dms["equipment_mould"], prop, equipment_mould.equipment_type) == 4 or 
							dms.int(dms["equipment_mould"], prop, equipment_mould.equipment_type) == 5 or
							dms.int(dms["equipment_mould"], prop, equipment_mould.equipment_type) == 8 then
							FragmentInformation:init(prop,2,3)
						else
							FragmentInformation:init(prop,nil,2)
						end
						fwin:open(FragmentInformation, fwin._windows)
            		end
            	end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(resource_icon_cell_show_prop_info_terminal)
		state_machine.add(prop_money_icon_cell_show_info_terminal)
        state_machine.init()
	end
	init_resource_icon_cell_terminal()

end

function ResourcesIconCell:onDrawIconPad(quality)
	local root = self.roots[1]
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")   		--底图
		if Panel_ditu ~= nil then
			Panel_ditu:removeBackGroundImage()
			Panel_ditu:setVisible(true)
			local sp = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", quality+1))
			-- Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality+1))
			Panel_ditu:removeAllChildren(true)
			Panel_ditu:addChild(sp)
		end
	else
		local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
		Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality+1))
	end
end

function ResourcesIconCell:onDrawIconPad2(quality)
	local root = self.roots[1]
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")   		--底图
	if Panel_ditu ~= nil then
		Panel_ditu:setVisible(true)
	end
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")

	if self.isBig == true then
		if __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			then
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
		else
			if Panel_kuang ~= nil then
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
				else
					Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))
				end
			end
			local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
			if Image_2 ~= nil then
				Image_2:setVisible(false)
			end
		end
	else
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			self.panel_ditu = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", quality))
	        if self.panel_ditu ~= nil then
		        self.panel_ditu:setPosition(cc.p(Panel_ditu:getContentSize().width/2,Panel_ditu:getContentSize().height/2))
		        Panel_ditu:addChild(self.panel_ditu)
		    end
			-- Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
		else
			Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_0.png"))
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		if self.current_type == self.enum_type.RECHARGE_SHOP_INFORMATION then
			Panel_ditu:setVisible(false)
		elseif self.current_type == self.enum_type.FIGHT_SPIRIT 
			and self.table.notShowBg then
			Panel_ditu:setVisible(false)
			local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
			if Image_2 ~= nil then
				Image_2:setVisible(false)
			end
		end
	end 
end

function ResourcesIconCell:getName()
	local root = self.roots[1]
	local nameCell = ccui.Helper:seekWidgetByName(root, "Label_name")--mingzi
	ccui.Helper:seekWidgetByName(root, "Label_name"):setVisible(true)
	return nameCell
end

function ResourcesIconCell:showName(id,types)
	local root = self.roots[1]
	local nameCell = ccui.Helper:seekWidgetByName(root, "Label_name")--mingzi
	ccui.Helper:seekWidgetByName(root, "Label_name"):setVisible(true)
	local Image_26 = ccui.Helper:seekWidgetByName(root, "Image_26")
	local quality = nil
	local name = nil
	if tonumber(id) == -1 then
		if types == 1 then		--金钱
			name = _All_tip_string_info._fundName
			quality = 3
		elseif types == 2 then		--转世
			name = _All_tip_string_info._crystalName
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				quality = 3
			else
				quality = 5
			end
		elseif types == 5 then			--魂玉
			name = _All_tip_string_info._soulName
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge then 
				quality = 4
			else
				quality = 5
			end
		elseif types == 8 then
			quality = 4
			name = reward_prop_list[8]
		elseif types == 18 then			--威名
			quality = 5
			name = _All_tip_string_info._glories
		elseif types == 3 then			--声望
			quality = 4
			name = _All_tip_string_info._reputation
		elseif types == 31 then
			quality = 4
			name = red_alert_resouce_tip[1][1]
		elseif types == 33 then 
			quality = 4
			name = _my_gane_name[14]
		elseif types == 34 then 
			quality = 3
			name = _my_gane_name[15]
		elseif types == 4 then  --数码魂
			quality = 4
			name = _All_tip_string_info._hero
		elseif types == 63 then
			quality = 4
			name = _my_gane_name[16]
		end
	else
		if types == self.enum_type.PROP_INFORMATION then
			quality = dms.int(dms["prop_mould"], id, prop_mould.prop_quality)+1
			name = dms.string(dms["prop_mould"], id, prop_mould.prop_name)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				name = setThePropsIcon(id)[2]
			end
			if dms.int(dms["prop_mould"], id, prop_mould.change_of_equipment) ~= 0 then
				if Image_26 ~= nil then
					Image_26:setVisible(true)
				end
			elseif dms.int(dms["prop_mould"], id,  prop_mould.use_of_ship) ~= 0 then
				if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  
					or __lua_project_id == __lua_project_yugioh 
					or __lua_project_id == __lua_project_warship_girl_b 
					then 
					--觉醒道具不显示碎片图标
					if dms.int(dms["prop_mould"], id,  prop_mould.props_type) == 16 then 
						if Image_26 ~= nil then
							Image_26:setVisible(false)
						end
					else
						if Image_26 ~= nil then
							Image_26:setVisible(true)
						end
					end
				else
					if Image_26 ~= nil then
						Image_26:setVisible(true)
					end
				end
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				    local footerData = dms.string(dms["prop_mould"], id, prop_mould.trace_remarks)
				    local footerInfo = zstring.split(footerData ,",")
				    --碎片标识
				    local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon")
				    if Panel_props_left_icon ~= nil then
					    Panel_props_left_icon:removeAllChildren(true)
					    if footerInfo[1] ~= nil and tonumber(footerInfo[1])~= -1 then
					        local props_left_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[1])))
					        if props_left_icon ~= nil then
						        props_left_icon:setPosition(cc.p(Panel_props_left_icon:getContentSize().width/2,Panel_props_left_icon:getContentSize().height/2))
						        Panel_props_left_icon:addChild(props_left_icon)
						    end
					    end
					end
				    --升级材料标识
				    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_right_icon")
				    if Panel_props_right_icon ~= nil then
					    Panel_props_right_icon:removeAllChildren(true)
					    if footerInfo[2] ~= nil and tonumber(footerInfo[2])~= -1 then
					        local props_right_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[2])))
					        if props_right_icon ~= nil then
						        props_right_icon:setPosition(cc.p(Panel_props_right_icon:getContentSize().width/2,Panel_props_right_icon:getContentSize().height/2))
						        Panel_props_right_icon:addChild(props_right_icon)
						    end
					    end
					end
			    end
			    -- pmc武将碎片图标显示ssr
			    if true then
					local storage_page_index = dms.int(dms["prop_mould"], id, prop_mould.storage_page_index)
					local shipMouldId = dms.int(dms["prop_mould"], id, prop_mould.use_of_ship)

					if storage_page_index == 18 and shipMouldId > 0 then
						local ability = dms.int(dms["ship_mould"], shipMouldId, ship_mould.ability)
						local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
						ssrIcon:setVisible(true)
						ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
					end
				end

				if __lua_project_id == __lua_project_l_digital then 
					-- 武将限定卡SP标签
					local storage_page_index = dms.int(dms["prop_mould"], id, prop_mould.storage_page_index)
					local shipMouldId = dms.int(dms["prop_mould"], id, prop_mould.use_of_ship)
					local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
					DisplaySpCardTag(shipMouldId, spIcon)
				else
					-- 武将限定卡显示
					local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
					if Panel_xianding then 
						Panel_xianding:setVisible(false)
						Panel_xianding:removeAllChildren(true)
						local storage_page_index = dms.int(dms["prop_mould"], id, prop_mould.storage_page_index)
						local shipMouldId = dms.int(dms["prop_mould"], id, prop_mould.use_of_ship)
			
						if storage_page_index == 18 and shipMouldId > 0 then
							DisplayLimitCard(tonumber(shipMouldId) , Panel_xianding , 1)
						else
							-- 限定神兽标签
							DisplayLimitAnimal(nil, id, Panel_xianding, 1)
						end
					end
				end
			end
		elseif types == self.enum_type.EQUIPMENT_INFORMATION then
			quality = dms.int(dms["equipment_mould"], id, equipment_mould.grow_level)+1
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				--获取装备名称索引
				local nameindex = dms.int(dms["equipment_mould"], id, equipment_mould.equipment_name)
				--通过索引找到word_mould
				local word_info = dms.element(dms["word_mould"], nameindex)
				local names = word_info[3]
				--绘制
				name = names
				if self.table ~= nil and self.table.equipQuality ~= nil then
					quality = dms.int(dms["equipment_mould"], id, equipment_mould.trace_npc_index)+1
				end
			else
				name = dms.string(dms["equipment_mould"], id, equipment_mould.equipment_name)
			end
		elseif types == self.enum_type.HERO_INFORMATION then
			quality = dms.int(dms["ship_mould"], id, ship_mould.ship_type)+1
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], id, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				-- local ship_evo = zstring.split(hero.evolution_status, "|")
				local evo_mould_id = evo_info[dms.int(dms["ship_mould"], id, ship_mould.captain_name)]
				local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
				local word_info = dms.element(dms["word_mould"], name_mould_id)
				name = word_info[3]
			else
				name = dms.string(dms["ship_mould"],id, ship_mould.captain_name)
			end
			-- pmc武将图标显示ssr
			if true then
				local ability = dms.int(dms["ship_mould"], id, ship_mould.ability)
				local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
				ssrIcon:setVisible(true)
				ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
			end

			if __lua_project_id == __lua_project_l_digital then 
				-- 武将限定卡SP标签
				local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
				DisplaySpCardTag(tonumber(id), spIcon)
			else
				-- 武将限定卡显示
				local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
				if Panel_xianding then 
					Panel_xianding:setVisible(false)
					Panel_xianding:removeAllChildren(true)
					DisplayLimitCard(tonumber(id) , Panel_xianding , 1)
				end
			end
		elseif types == self.enum_type.SILKBAG_INFORMATION then  --锦囊
			quality = dms.int(dms["ship_silk_bag_mould"], id, ship_silk_bag_mould.quality_level)
			--获取锦囊名称索引
			local nameindex = dms.int(dms["ship_silk_bag_mould"], id, equipment_mould.equipment_name)
			--通过锦囊索引找到word_mould
			local word_info = dms.element(dms["word_mould"], nameindex)
			local names = word_info[3]
			--绘制
			name = names
		elseif types == self.enum_type.CASH_VOUCHER then  --代金券
			quality = dms.int(dms["vouchers_mould"], id, warehouse_vouchers_mould.quality_level)
			--获取代金券名称索引
			local nameindex = dms.int(dms["vouchers_mould"], id, warehouse_vouchers_mould.name_id)
			--通过代金券索引找到word_mould
			local word_info = dms.element(dms["word_mould"], nameindex)
			local names = word_info[3]
			--绘制
			name = names
		elseif types == self.enum_type.MAGIC_ANIMAL_INFORMATION then  --神兽
			quality = dms.int(dms["magical_animals_mould"], id, magical_animals_mould.quality)
			local nameindex = dms.int(dms["magical_animals_mould"], id, magical_animals_mould.nameMouldId)
			local word_info = dms.element(dms["word_mould"], nameindex)
			local names = word_info[3]
			--绘制
			name = names	
			local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
			if Panel_xianding then 
				Panel_xianding:setVisible(false)
				Panel_xianding:removeAllChildren(true)
				-- 限定神兽标签
				DisplayLimitAnimal(id, nil, Panel_xianding, 1)
			end
		elseif types == self.enum_type.WAR_ORDER_COIN then  --战令经验代币
			quality = 2
			-- 战令经验代币名称
			local names = _All_tip_string_info._warOrderExp
			--绘制
			name = names	
		elseif types == self.enum_type.HEAD_FRAME then  --头像框
			quality = 6
			local headFrameInfo = dms.searchs(dms["face_frame_mould"], face_frame_mould.id, id)
			local nameIndex = dms.atoi(headFrameInfo, face_frame_mould.nameID)
			local names = dms.string(dms["word_mould"], nameIndex, word_mould.text_info)
			--绘制
			name = names	
		end
	end

	if nameCell ~= nil then
		nameCell:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
		nameCell:setString(name)
	end
	return name
end

function ResourcesIconCell:onUpdateDraw()
	local root = self.roots[1]
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.size = root:getContentSize()
	
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	Panel_prop:removeBackGroundImage()

	-- 头像框容器
	local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head")
	
	-- local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	local name = ccui.Helper:seekWidgetByName(root, "Label_name")--mingzi
	self:setContentSize(self.size)
	if Image_2 ~= nil then
		Image_2:setSwallowTouches(false)
	end
	local quality = nil
	local count = 0
	
	
	--1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:经验 9:耐力 10:功能点 11:上阵人数 12:体力 13:武将 14竞技场排名
	--15:伤害 16:比武积分 17:霸气 18 威名 19 日常任务积分 20功勋 21战功 33 驯兽魂
	--> print("00000000000001111111111",self.rewardType)
	for i, v in pairs(self.rewardType.show_reward_list) do
		-- if (tonumber(v.prop_type) == 6 and tonumber(v.item_value) > 0)
			-- or (tonumber(v.prop_type) == 7 and tonumber(v.item_value) > 0) 
			-- or (tonumber(v.prop_type) == 13 and tonumber(v.item_value) > 0) 
			-- or (tonumber(v.prop_type) == 17 and tonumber(v.item_value) > 0) 
			-- then
			-- (1:银币 2:金币 3:声望 4:将魂 5:魂玉 6:道具 7:装备 8:武将 9:鬼道 10: 决斗荣誉)
		if true then
			-- local cell = createRewardItem(v)
			if v.prop_type == -1 then
			
			elseif tonumber(v.prop_type) ==1 and tonumber(v.item_value) > 0 then	--银币
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
					self.panel_prop = cc.Sprite:create(self.res_data[1][2])
					if self.panel_prop ~= nil then
						self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
						Panel_prop:addChild(self.panel_prop)
					end
				else
					Panel_prop:setBackGroundImage(self.res_data[1][2])
				end
				count = v.item_value
				name:setString(_my_gane_name[1])
			elseif tonumber(v.prop_type) ==2 and tonumber(v.item_value) > 0 then	--金币
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[2][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[2][2])
				end
				count = v.item_value
				name:setString(_my_gane_name[2])
			elseif tonumber(v.prop_type) ==3 and tonumber(v.item_value) > 0 then	--声望
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[3][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[3][2])
				end
				count = v.item_value
				name:setString(_my_gane_name[3])
			elseif tonumber(v.prop_type) ==4 and tonumber(v.item_value) > 0 then	--将魂
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[4][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[4][2])
				end
				count = v.item_value
				name:setString(_my_gane_name[5])
			elseif tonumber(v.prop_type) ==5 and tonumber(v.item_value) > 0 then	--魂玉
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[5][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[5][2])
				end
				count = v.item_value
			elseif tonumber(v.prop_type) ==8 and tonumber(v.item_value) > 0 then	--经验
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[8][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[8][2])
				end
				count = v.item_value
				name:setString(_my_gane_name[7])
			elseif tonumber(v.prop_type) ==9 and tonumber(v.item_value) > 0 then	--耐力
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[9][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[9][2])
				end
				count = v.item_value
				name:setString(_my_gane_name[9])
			elseif tonumber(v.prop_type) ==10 and tonumber(v.item_value) > 0 then	--功能点
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[10][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[10][2])
				end
				count = v.item_value
				name:setString(_my_gane_name[10])
			elseif tonumber(v.prop_type) ==12 and tonumber(v.item_value) > 0 then	--体力
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[12][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[12][2])
				end
				count = v.item_value
				name:setString(_my_gane_name[8])
			elseif tonumber(v.prop_type) ==18 and tonumber(v.item_value) > 0 then	--威名
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[18][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[18][2])
				end
				count = v.item_value
				name:setString(_my_gane_name[6])
				
			elseif tonumber(v.prop_type) ==20 and tonumber(v.item_value) > 0 then	--功勋
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:createshow_reward_list(self.res_data[20][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[20][2])
				end
				count = v.item_value
				name:setString(_my_gane_name[11])
				
			elseif tonumber(v.prop_type) ==21 and tonumber(v.item_value) > 0 then	--战功
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[21][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[21][2])
				end
				count = v.item_value
			elseif tonumber(v.prop_type) ==28 and tonumber(v.item_value) > 0 then	--军团贡献
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[28][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[28][2])
				end
				count = v.item_value
				name:setString(_my_gane_name[13])
			elseif tonumber(v.prop_type) ==31 and tonumber(v.item_value) > 0 then	--战神令
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[31][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[31][2])
				end
				count = v.item_value
				name:setString(red_alert_resouce_tip[1][1])		
			elseif tonumber(v.prop_type) ==6 and tonumber(v.item_value) > 0 then	--道具
				quality = dms.int(dms["prop_mould"], v.prop_item, prop_mould.prop_quality)
				local icon_index = dms.int(dms["prop_mould"], v.prop_item, prop_mould.pic_index)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					icon_index = setThePropsIcon(v.prop_item)[1]
					self.panel_prop = cc.Sprite:create(string.format("images/ui/props/props_%d.png", icon_index))
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)

				        local sell_tag = dms.int(dms["prop_mould"], v.prop_item, prop_mould.sell_tag)
						if sell_tag == 3 then
							local effect_paths = string.format(config_res.images.ui.effice.effect_quality_box, 1, 1)
							if cc.FileUtils:getInstance():isFileExist(effect_paths) == true then
								ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
								local armature = ccs.Armature:create("effect_quality_box_1")
								draw.initArmature(armature, nil, -1, 0, 1)
								armature:setPosition(cc.p(Panel_prop:getContentSize().width/2, Panel_prop:getContentSize().height/2))
								Panel_prop:addChild(armature)
							end
						end
				    end
				else
					Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", icon_index))
				end
				count = v.item_value
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					name:setString(setThePropsIcon(v.prop_item)[2])
				else
					name:setString(dms.string(dms["prop_mould"], v.prop_item, prop_mould.prop_name))
				end
				name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
				local Image_26 = ccui.Helper:seekWidgetByName(root, "Image_26")
				if Image_26 ~= nil then
					if dms.int(dms["prop_mould"], v.prop_item, prop_mould.change_of_equipment) ~= 0 then
						Image_26:setVisible(true)
					elseif dms.int(dms["prop_mould"], v.prop_item,  prop_mould.use_of_ship) ~= 0 then
						Image_26:setVisible(true)
					end
				end
				self.propName = dms.string(dms["prop_mould"], v.prop_item, prop_mould.prop_name)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					local footerData = dms.string(dms["prop_mould"], v.prop_item, prop_mould.trace_remarks)
				    local footerInfo = zstring.split(footerData ,",")
				    --碎片标识
				   
				    local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon")
				    if Panel_props_left_icon ~= nil then
					    Panel_props_left_icon:removeAllChildren(true)
					    if footerInfo[1] ~= nil and tonumber(footerInfo[1])~= -1 then
					        local props_left_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[1])))
					        if props_left_icon ~= nil then
						        props_left_icon:setPosition(cc.p(Panel_props_left_icon:getContentSize().width/2,Panel_props_left_icon:getContentSize().height/2))
						        Panel_props_left_icon:addChild(props_left_icon)
						    end
					    end
					end
				    --升级材料标识
				    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_right_icon")
				    if Panel_props_right_icon ~= nil then
					    Panel_props_right_icon:removeAllChildren(true)
					    if footerInfo[2] ~= nil and tonumber(footerInfo[2])~= -1 then
					        local props_right_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[2])))
					        if props_right_icon ~= nil then
						        props_right_icon:setPosition(cc.p(Panel_props_right_icon:getContentSize().width/2,Panel_props_right_icon:getContentSize().height/2))
						        Panel_props_right_icon:addChild(props_right_icon)
						    end
					    end
					end
			    end

			    -- pmc武将碎片图标显示ssr
				if true then
					local storage_page_index = dms.int(dms["prop_mould"], v.prop_item, prop_mould.storage_page_index)
					local shipMouldId = dms.int(dms["prop_mould"], v.prop_item, prop_mould.use_of_ship)

					if storage_page_index == 18 and shipMouldId > 0 then
						local ability = dms.int(dms["ship_mould"], shipMouldId, ship_mould.ability)
						local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
						ssrIcon:setVisible(true)
						ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
					end
				end

				if __lua_project_id == __lua_project_l_digital then 
					-- 武将限定卡SP标签
					local storage_page_index = dms.int(dms["prop_mould"], v.prop_item, prop_mould.storage_page_index)
					local shipMouldId = dms.int(dms["prop_mould"], v.prop_item, prop_mould.use_of_ship)
					local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
					DisplaySpCardTag(shipMouldId, spIcon)
				else
					-- 武将限定卡显示
					local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
					if Panel_xianding then 
						Panel_xianding:setVisible(false)
						Panel_xianding:removeAllChildren(true)
						local storage_page_index = dms.int(dms["prop_mould"], v.prop_item, prop_mould.storage_page_index)
						local shipMouldId = dms.int(dms["prop_mould"], v.prop_item, prop_mould.use_of_ship)
			
						if storage_page_index == 18 and shipMouldId > 0 then
							DisplayLimitCard(shipMouldId , Panel_xianding , 1)
						else
							-- 限定神兽标签
							DisplayLimitAnimal(nil, v.prop_item, Panel_xianding, 1)
						end
			
					end
				end

			elseif tonumber(v.prop_type) ==7 and tonumber(v.item_value) > 0 then	--装备
				quality = dms.int(dms["equipment_mould"], v.prop_item, equipment_mould.grow_level)
				local icon_index = dms.int(dms["equipment_mould"], v.prop_item, equipment_mould.pic_index)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(string.format("images/ui/props/props_%d.png", icon_index))
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", icon_index))
				end
				count = v.item_value
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					--获取装备名称索引
					local nameindex = dms.int(dms["equipment_mould"], item_mouldid, equipment_mould.equipment_name)
					--通过索引找到word_mould
					local word_info = dms.element(dms["word_mould"], nameindex)
					local names = word_info[3]
					--绘制
					name:setString(names)
					name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
				else
					name:setString(dms.string(dms["equipment_mould"], v.prop_item, equipment_mould.equipment_name))
					name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
				end	
			elseif tonumber(v.prop_type) == 13 and tonumber(v.item_value) > 0 then	--武将
				quality = dms.int(dms["ship_mould"], v.prop_item, ship_mould.ship_type)
				--> print("self.mould_id----------------------------",self.mould_id)
				local icon_index = dms.int(dms["ship_mould"], v.prop_item, ship_mould.head_icon)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(string.format("images/ui/props/props_%d.png", icon_index))
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", icon_index))
				end
				count = v.item_value
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					--进化形象
					local evo_image = dms.string(dms["ship_mould"], v.prop_item, ship_mould.fitSkillTwo)
					local evo_info = zstring.split(evo_image, ",")
					--进化模板id
					-- local ship_evo = zstring.split(hero.evolution_status, "|")
					local evo_mould_id = evo_info[dms.int(dms["ship_mould"], v.prop_item, ship_mould.captain_name)]
					local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
					local word_info = dms.element(dms["word_mould"], name_mould_id)
					_name = word_info[3]
					name:setString(_name)
					quality = shipOrEquipSetColour(dms.int(dms["ship_mould"], v.prop_item, ship_mould.initial_rank_level))-1
				else
					name:setString(dms.string(dms["ship_mould"], v.prop_item, ship_mould.captain_name))
				end
				-- pmc武将图标显示ssr
				if true then
					local ability = dms.int(dms["ship_mould"], v.prop_item, ship_mould.ability)
					local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
					ssrIcon:setVisible(true)
					ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
				end
				
				if __lua_project_id == __lua_project_l_digital then 
					-- 武将限定卡SP标签
					local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
					DisplaySpCardTag(tonumber(v.prop_item), spIcon)
				else
					-- 武将限定卡显示
					local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
					if Panel_xianding then 
						Panel_xianding:setVisible(false)
						Panel_xianding:removeAllChildren(true)
						DisplayLimitCard(tonumber(v.prop_item) , Panel_xianding , 1)
					end
				end
				name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
			elseif tonumber(v.prop_type) == 33 and tonumber(v.item_value) > 0 then	--驯兽魂
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[33][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[33][2])
				end
				count = v.item_value
				name:setString(_my_gane_name[14])
			elseif tonumber(v.prop_type) == 34 and tonumber(v.item_value) > 0 then	
				quality = 0
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[34][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[34][2])
				end
				count = v.item_value
				name:setString(_my_gane_name[15])
			elseif tonumber(v.prop_type) == 39 and tonumber(v.item_value) > 0 then	
				quality = 4
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(self.res_data[39][2])
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(self.res_data[39][2])
				end
				count = v.item_value
				name:setString(self.res_data[39][3])
			elseif tonumber(v.prop_type) == 63 and tonumber(v.item_value) > 0 then	--活跃度
				quality = 0
				self.panel_prop = cc.Sprite:create(self.res_data[63][2])
		        if self.panel_prop ~= nil then
			        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
			        Panel_prop:addChild(self.panel_prop)
			    end
				count = v.item_value
				name:setString(_my_gane_name[16])
			elseif tonumber(v.prop_type) ==71 and tonumber(v.item_value) > 0 then	--锦囊
				quality = dms.int(dms["ship_silk_bag_mould"], v.prop_item, ship_silk_bag_mould.quality_level)
				local icon_index = dms.int(dms["ship_silk_bag_mould"], v.prop_item, ship_silk_bag_mould.pic_index)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(string.format("images/ui/props/props_%d.png", icon_index))
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(string.format("images/ui/props/props_%d.png", icon_index))
				end
				
				count = v.item_value
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					--获取装备名称索引
					local nameindex = dms.int(dms["ship_silk_bag_mould"], item_mouldid, ship_silk_bag_mould.silkbag_name)
					--通过索引找到word_mould
					local word_info = dms.element(dms["word_mould"], nameindex)
					local names = word_info[3]
					--绘制
					name:setString(names)
					name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
				else
					name:setString(dms.string(dms["ship_silk_bag_mould"], v.prop_item, ship_silk_bag_mould.silkbag_name))
					name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
				end
			elseif tonumber(v.prop_type) == 72 and tonumber(v.item_value) > 0 then	--神兽整卡显示
				quality = dms.int(dms["magical_animals_mould"], v.prop_item, magical_animals_mould.quality)
				local icon_index = dms.int(dms["magical_animals_mould"], v.prop_item, magical_animals_mould.picIndex)
				self.panel_prop = cc.Sprite:create(string.format("images/ui/props/props_%d.png", icon_index))
				if self.panel_prop ~= nil then
					self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
					Panel_prop:addChild(self.panel_prop)
				end

				count = v.item_value
				local nameindex = dms.int(dms["magical_animals_mould"], item_mouldid, magical_animals_mould.nameMouldId)
				local word_info = dms.element(dms["word_mould"], nameindex)
				local names = word_info[3]
				name:setString(names)
				name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
			elseif tonumber(v.prop_type) == 73 and tonumber(v.item_value) > 0 then	--战魂
				quality = dms.int(dms["fight_spirit_mould"], v.prop_item, fight_spirit_mould.quality)
				local suitId = dms.int(dms["fight_spirit_mould"], v.prop_item, fight_spirit_mould.suit_id)
				local icon_index = dms.string(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.prop_id)
				self.panel_prop = cc.Sprite:create(string.format("images/ui/props/props_%d.png", icon_index))
				if self.panel_prop ~= nil then
					self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
					Panel_prop:addChild(self.panel_prop)
				end

				count = v.item_value
				local pos = dms.int(dms["fight_spirit_mould"], v.prop_item, fight_spirit_mould.pos)
				name = dms.element(dms["word_mould"], dms.int(dms["fight_spirit_suit_mould"], suitId, fight_spirit_suit_mould.suit_name))[3].."."..chinese_num[pos]
				name:setString(names)
				name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
			elseif tonumber(v.prop_type) == 74 and tonumber(v.item_value) > 0 then	--代金券
				quality = dms.int(dms["vouchers_mould"], v.prop_item, warehouse_vouchers_mould.quality_level)
				local suitId = dms.int(dms["vouchers_mould"], v.prop_item, warehouse_vouchers_mould.name_id)
				local icon_index = dms.int(dms["vouchers_mould"], v.prop_item, warehouse_vouchers_mould.pic_index)
				
				self.panel_prop = cc.Sprite:create(string.format("images/ui/props/props_%d.png", icon_index))
				if self.panel_prop ~= nil then
					self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
					Panel_prop:addChild(self.panel_prop)
				end

				count = v.item_value
				--获取代金券名称索引
				local nameindex = dms.int(dms["vouchers_mould"], v.prop_item, warehouse_vouchers_mould.name_id)
				--通过索引找到word_mould
				local word_info = dms.element(dms["word_mould"], nameindex)
				local names = word_info[3]
				name:setString(names)
				name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
			elseif tonumber(v.prop_type) == 75 and tonumber(v.item_value) > 0 then	--战令经验代币
				quality = 2
				
				self.panel_prop = cc.Sprite:create("image/activity/passport/activity_passport_icon_exchange.png")
				if self.panel_prop ~= nil then
					self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
					Panel_prop:addChild(self.panel_prop)
				end

				count = v.item_value
				--获取战令经验代币名称
				
				local names = _All_tip_string_info._warOrderExp
				name:setString(names)
				name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
			elseif tonumber(v.prop_type) == 76 and tonumber(v.item_value) > 0 then	--头像框
				quality = 6
				
				local headFrameInfo = dms.searchs(dms["face_frame_mould"], face_frame_mould.id, v.prop_item)[1]

				local effectIndex = zstring.split(dms.atos(headFrameInfo, face_frame_mould.effectIDInfo), ",", tonumber)[1]
				local isPlayEffect = false
				if effectIndex and effectIndex ~= -1 then
					isPlayEffect = self:addHeadFrameEffect(effectIndex, Panel_head)
				end

				if isPlayEffect == false then
					local picID = dms.atoi(headFrameInfo, face_frame_mould.resID)
					local spritePath = string.format("image/cut/frame/cut_frame_%d.png", picID)

					self.panel_prop = cc.Sprite:create(spritePath)
					if self.panel_prop ~= nil then
						self.panel_prop:setPosition(cc.p(Panel_head:getContentSize().width/2,Panel_head:getContentSize().height/2))
						Panel_head:addChild(self.panel_prop)
					end
				end

				count = v.item_value
				--获取头像框名称
				local nameIndex = dms.atoi(headFrameInfo, face_frame_mould.nameID)
				local names = dms.string(dms["word_mould"], nameIndex, word_mould.text_info)
				name:setString(names)
				name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
			end

			if quality ~= nil then
				self:onDrawIconPad(quality)
			end
			if tonumber(count) >= 10000 then
				self.item_order_level:setString("x"..math.floor(count / 1000) .. string_equiprety_name[40])
			else
				self.item_order_level:setString("x"..count)
			end
		end
	end
end

function ResourcesIconCell:onUpdateDraw2()
	local root = self.roots[1]
	local Panel_prop_box = ccui.Helper:seekWidgetByName(root, "Panel_prop_box")
	-- local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.size = root:getContentSize()
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	Panel_prop:removeBackGroundImage()
	
	local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head")
	
	self:setContentSize(self.size)
	if Image_2 ~= nil then
		Image_2:setSwallowTouches(false)
	end
	local quality = self.res_data[self.current_type][1]  --判断显示哪个底框
	if self.mould_id == -1 then
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			self.panel_prop = cc.Sprite:create(self.res_data[self.current_type][2])
	        if self.panel_prop ~= nil then
		        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
		        Panel_prop:addChild(self.panel_prop)
		    end
		else
			Panel_prop:setBackGroundImage(self.res_data[self.current_type][2])  -- 判断显示那个底图
		end
		self:onDrawIconPad2(quality+1)
		self.propName = self.res_data[self.current_type][3]
		self.quality = quality+1
	else
		
		local path = "images/ui/props/props_%d.png"
		if self.isBig  == true then
			
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
				path = "images/ui/reward/cz_tubiao_%d.png"
				--path = "images/ui/props/props_%d.png"
				local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
				if Image_2 ~= nil then
					Image_2:setVisible(false)
				end
			else
				if __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					then 
					path = "images/ui/props/props_%d.png"
				else
					path = "images/face/prop_head/props_%d.png"
				end
			end
		end
		if self.current_type == self.enum_type.PROP_INFORMATION then
			quality = dms.int(dms["prop_mould"], self.mould_id, prop_mould.prop_quality)
			local icon_index = dms.int(dms["prop_mould"], self.mould_id, prop_mould.pic_index)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				icon_index = setThePropsIcon(self.mould_id)[1]
				self.panel_prop = cc.Sprite:create(string.format(path, icon_index))
		        if self.panel_prop ~= nil then
			        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
			        Panel_prop:addChild(self.panel_prop)
			        
					local sell_tag = dms.int(dms["prop_mould"], self.mould_id, prop_mould.sell_tag)
					if sell_tag == 3 then
						local effect_paths = string.format(config_res.images.ui.effice.effect_quality_box, 1, 1)
						if cc.FileUtils:getInstance():isFileExist(effect_paths) == true then
							ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
							local armature = ccs.Armature:create("effect_quality_box_1")
							draw.initArmature(armature, nil, -1, 0, 1)
							armature:setPosition(cc.p(Panel_prop:getContentSize().width/2, Panel_prop:getContentSize().height/2))
							Panel_prop:addChild(armature)
						end
					end
			    end
			else
				Panel_prop:setBackGroundImage(string.format(path, icon_index))
			end
			self.propName = dms.string(dms["prop_mould"],self.mould_id, prop_mould.prop_name)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				self.propName = setThePropsIcon(self.mould_id)[2]
			end
			self.quality = quality
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				local footerData = dms.string(dms["prop_mould"], self.mould_id, prop_mould.trace_remarks)
			    local footerInfo = zstring.split(footerData ,",")
			    --碎片标识
			    local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon")
			    if Panel_props_left_icon ~= nil then
				    Panel_props_left_icon:removeAllChildren(true)
				    if footerInfo[1] ~= nil and tonumber(footerInfo[1])~= -1 then
				        local props_left_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[1])))
				        if props_left_icon ~= nil then
					        props_left_icon:setPosition(cc.p(Panel_props_left_icon:getContentSize().width/2,Panel_props_left_icon:getContentSize().height/2))
					        Panel_props_left_icon:addChild(props_left_icon)
					    end
				    end
				end
			    --升级材料标识
			    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_right_icon")
			    if Panel_props_right_icon ~= nil then
				    Panel_props_right_icon:removeAllChildren(true)
				    if footerInfo[2] ~= nil and tonumber(footerInfo[2])~= -1 then
				        local props_right_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[2])))
				        if props_right_icon ~= nil then
					        props_right_icon:setPosition(cc.p(Panel_props_right_icon:getContentSize().width/2,Panel_props_right_icon:getContentSize().height/2))
					        Panel_props_right_icon:addChild(props_right_icon)
					    end
				    end
				end
		    end
			-- pmc武将图标显示ssr
		    if true then
				local storage_page_index = dms.int(dms["prop_mould"], self.mould_id, prop_mould.storage_page_index)
				local shipMouldId = dms.int(dms["prop_mould"], self.mould_id, prop_mould.use_of_ship)

				if storage_page_index == 18 and shipMouldId > 0 then
					local ability = dms.int(dms["ship_mould"], shipMouldId, ship_mould.ability)
					local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
					ssrIcon:setVisible(true)
					ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
				end
			end
			
			if __lua_project_id == __lua_project_l_digital then 
				-- 武将限定卡SP标签
				local storage_page_index = dms.int(dms["prop_mould"], self.mould_id, prop_mould.storage_page_index)
				local shipMouldId = dms.int(dms["prop_mould"], self.mould_id, prop_mould.use_of_ship)
				local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
				DisplaySpCardTag(shipMouldId, spIcon)
			else
				local storage_page_index = dms.int(dms["prop_mould"], self.mould_id, prop_mould.storage_page_index)
				local shipMouldId = dms.int(dms["prop_mould"], self.mould_id, prop_mould.use_of_ship)
				local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
				if Panel_xianding then 
					-- 武将限定卡显示
					Panel_xianding:setVisible(false)
					Panel_xianding:removeAllChildren(true)
					DisplayLimitCard(shipMouldId , Panel_xianding , 1)
				end
			end
		elseif self.current_type == self.enum_type.EQUIPMENT_INFORMATION then
			quality = dms.int(dms["equipment_mould"], self.mould_id, equipment_mould.grow_level)
			local icon_index = dms.int(dms["equipment_mould"], self.mould_id, equipment_mould.pic_index)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				self.panel_prop = cc.Sprite:create(string.format(path, icon_index))
		        if self.panel_prop ~= nil then
			        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
			        Panel_prop:addChild(self.panel_prop)
			    end
			    if self.table ~= nil and self.table.equipQuality ~= nil then
					quality = dms.int(dms["equipment_mould"], self.mould_id, equipment_mould.trace_npc_index)
				end
			else
				Panel_prop:setBackGroundImage(string.format(path, icon_index))
			end
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				--获取装备名称索引
				local nameindex = dms.int(dms["equipment_mould"], self.mould_id, equipment_mould.equipment_name)
				--通过索引找到word_mould
				local word_info = dms.element(dms["word_mould"], nameindex)
				local names = word_info[3]
				--绘制
				self.propName = names
			else
				self.propName = dms.string(dms["equipment_mould"],self.mould_id, equipment_mould.equipment_name)
			end
			self.quality = quality
		elseif self.current_type == self.enum_type.SILKBAG_INFORMATION then     --锦囊
			quality = dms.int(dms["ship_silk_bag_mould"], self.mould_id, ship_silk_bag_mould.quality_level)
			local icon_index = dms.int(dms["ship_silk_bag_mould"], self.mould_id, ship_silk_bag_mould.pic_index)
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				self.panel_prop = cc.Sprite:create(string.format(path, icon_index))
		        if self.panel_prop ~= nil then
			        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
			        Panel_prop:addChild(self.panel_prop)
			    end
			    if self.table ~= nil and self.table.silkbagQuality ~= nil then
					quality = self.table.silkbagQuality+1
				else 
					quality = dms.int(dms["ship_silk_bag_mould"], self.mould_id, ship_silk_bag_mould.quality_level)
				end
			else
				Panel_prop:setBackGroundImage(string.format(path, icon_index))
			end
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				--获取装备名称索引
				local nameindex = dms.int(dms["ship_silk_bag_mould"], self.mould_id, ship_silk_bag_mould.silkbag_name)
				--通过索引找到word_mould
				local word_info = dms.element(dms["word_mould"], nameindex)
				local names = word_info[3]
				--绘制
				self.propName = names
			else
				self.propName = dms.string(dms["ship_silk_bag_mould"],self.mould_id, ship_silk_bag_mould.silkbag_name)
			end
			self.quality = quality
		elseif self.current_type == self.enum_type.CASH_VOUCHER then     --代金券
			quality = dms.int(dms["vouchers_mould"], self.mould_id, warehouse_vouchers_mould.quality_level)
			local icon_index = dms.int(dms["vouchers_mould"], self.mould_id, warehouse_vouchers_mould.pic_index)
			self.panel_prop = cc.Sprite:create(string.format(path, icon_index))
			if self.panel_prop ~= nil then
				self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				Panel_prop:addChild(self.panel_prop)
			end
			
			--获取代金券名称索引
			local nameindex = dms.int(dms["vouchers_mould"], self.mould_id, warehouse_vouchers_mould.name_id)
			--通过索引找到word_mould
			local word_info = dms.element(dms["word_mould"], nameindex)
			local names = word_info[3]
			--绘制
			self.propName = names
			
			self.quality = quality
		elseif self.current_type == self.enum_type.WAR_ORDER_COIN then     --战令经验代币
			quality = 2
			
			self.panel_prop = cc.Sprite:create("image/activity/passport/activity_passport_icon_exchange.png")
			if self.panel_prop ~= nil then
				self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				Panel_prop:addChild(self.panel_prop)
			end
			
			
			local names = _All_tip_string_info._warOrderExp
			--绘制
			self.propName = names
			
			self.quality = quality
		elseif self.current_type == self.enum_type.HEAD_FRAME then     --头像框
			quality = 6
			
			local headFrameInfo = dms.searchs(dms["face_frame_mould"], face_frame_mould.id, self.mould_id)[1]
			
			local effectIndex = zstring.split(dms.atos(headFrameInfo, face_frame_mould.effectIDInfo), ",", tonumber)[1]
			local isPlayEffect = false
			if effectIndex and effectIndex ~= -1 then
				isPlayEffect = self:addHeadFrameEffect(effectIndex, Panel_head)
			end

			if isPlayEffect == false then
				local picID = dms.atoi(headFrameInfo, face_frame_mould.resID)
				local resPath = string.format("image/cut/frame/cut_frame_%d.png", picID)

				self.panel_prop = cc.Sprite:create(resPath)
				if self.panel_prop ~= nil then
					self.panel_prop:setPosition(cc.p(Panel_head:getContentSize().width/2,Panel_head:getContentSize().height/2))
					Panel_head:addChild(self.panel_prop)
				end
			end

			local nameIndex = dms.atoi(headFrameInfo, face_frame_mould.nameID)
			local names = dms.string(dms["word_mould"], nameIndex, word_mould.text_info)
			--绘制
			self.propName = names
			
			self.quality = quality
		elseif self.current_type == self.enum_type.HERO_INFORMATION then
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], self.mould_id, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
				local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self.mould_id, ship_mould.captain_name)]
				picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(string.format(path, picIndex))
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(string.format(path, picIndex))
				end
				quality = shipOrEquipSetColour(dms.int(dms["ship_mould"], self.mould_id, ship_mould.initial_rank_level))-1
				self.quality = quality
				self.item_count = 0 -- 不显示等级

				local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
				if Panel_star ~= nil then
					Panel_star:removeAllChildren(true)
				end
				local initStar = dms.int(dms["ship_mould"], self.mould_id, ship_mould.ship_star)
				if self.table.shipStar ~= nil then
					initStar = tonumber(self.table.shipStar)
				end
				if Panel_star ~= nil then
					neWshowShipStar(Panel_star , initStar)
				end
			else
				quality = dms.int(dms["ship_mould"], self.mould_id, ship_mould.ship_type)
				local icon_index = dms.int(dms["ship_mould"], self.mould_id, ship_mould.head_icon)
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					self.panel_prop = cc.Sprite:create(string.format(path, icon_index))
			        if self.panel_prop ~= nil then
				        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				        Panel_prop:addChild(self.panel_prop)
				    end
				else
					Panel_prop:setBackGroundImage(string.format(path, icon_index))
				end
				self.quality = quality
			end
			-- pmc武将图标显示ssr
			if true then
				local ability = dms.int(dms["ship_mould"], self.mould_id, ship_mould.ability)
				local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
				ssrIcon:setVisible(true)
				ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
			end

			-- 武将限定卡SP标签
			if __lua_project_id == __lua_project_l_digital then 
				local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
				DisplaySpCardTag(self.mould_id, spIcon)
			else
				-- 武将限定卡显示
				local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
				if Panel_xianding then 
					Panel_xianding:setVisible(false)
					Panel_xianding:removeAllChildren(true)
					DisplayLimitCard(self.mould_id , Panel_xianding , 1)
				end
			end
		elseif self.current_type == self.enum_type.RECHARGE_SHOP_INFORMATION then	--充值页面的图标
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
				self.panel_prop = cc.Sprite:create(string.format(path, self.mould_id))
		        if self.panel_prop ~= nil then
			        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
			        Panel_prop:addChild(self.panel_prop)
			    end
			else
				Panel_prop:setBackGroundImage(string.format(path, self.mould_id))
			end
			Panel_prop:setTouchEnabled(false)
			--print("图片下标",self.mould_id)
			if __lua_project_id == __lua_project_gragon_tiger_gate 
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
				ccui.Helper:seekWidgetByName(root, "Panel_kuang"):setVisible(false)
			end
		elseif self.current_type == self.enum_type.ALLOY_MATRIX then -- 合金图标
			local pic_id = dms.int(dms["ship_metal_mould"], self.mould_id, ship_metal_mould.pic_id)
			quality = dms.int(dms["ship_metal_mould"], self.mould_id, ship_metal_mould.quality)
			self.panel_prop = cc.Sprite:create(string.format(path, pic_id))

			local matrix_add_type = dms.int(dms["ship_metal_mould"], self.mould_id, ship_metal_mould.add_type)
			local add_attribute = cc.Sprite:create(string.format("images/ui/text/smhj/attr_text_%d.png", matrix_add_type))
			local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon")

	        if self.panel_prop ~= nil then
		        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
		        Panel_prop:addChild(self.panel_prop)
		    end

		    if add_attribute then
		    	add_attribute:setPosition(cc.p(Panel_props_left_icon:getContentSize().width/2,Panel_props_left_icon:getContentSize().height/2))
		        Panel_props_left_icon:addChild(add_attribute)
		    end
		elseif self.current_type == self.enum_type.MATRIX_ESSENCE then --合金精华
			self.panel_prop = cc.Sprite:create(self.res_data[self.current_type][2])
	        if self.panel_prop ~= nil then
		        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
		        Panel_prop:addChild(self.panel_prop)
		    end
		    quality = 3
		elseif self.current_type == self.enum_type.SKIN_COIN_INFORMATIO then --皮肤
			local evo_mould_id = dms.int(dms["ship_skin_mould"], self.mould_id, ship_skin_mould.ship_evo_id)
			local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			local ship_mould_id = dms.int(dms["ship_skin_mould"], self.mould_id, ship_skin_mould.ship_mould_id)
			quality = 3
			self.panel_prop = cc.Sprite:create(string.format(path, picIndex))
	        if self.panel_prop ~= nil then
		        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
		        Panel_prop:addChild(self.panel_prop)
		    end

		elseif self.current_type == self.enum_type.EXPLORE_MONEY then -- 探索币
			self.panel_prop = cc.Sprite:create(self.res_data[self.current_type][2])
	        if self.panel_prop ~= nil then
		        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
		        Panel_prop:addChild(self.panel_prop)
		    end
		    quality = 4
		elseif self.current_type == self.enum_type.EXPLORE_MONEY1 then -- 探索币（口袋）
			self.panel_prop = cc.Sprite:create(self.res_data[self.current_type][2])
	        if self.panel_prop ~= nil then
		        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
		        Panel_prop:addChild(self.panel_prop)
		    end
		    quality = 4

		elseif self.current_type == self.enum_type.HOLY_ESSENCE then -- 圣物精华
			self.panel_prop = cc.Sprite:create(self.res_data[self.current_type][2])
	        if self.panel_prop ~= nil then
		        self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
		        Panel_prop:addChild(self.panel_prop)
		    end
			quality = 3
		elseif self.current_type == self.enum_type.MAGIC_ANIMAL_INFORMATION then
			local icon_index = dms.int(dms["magical_animals_mould"], self.mould_id, magical_animals_mould.picIndex)
			self.panel_prop = cc.Sprite:create(string.format("images/ui/props/props_%d.png", icon_index))
			if self.panel_prop ~= nil then
				self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				Panel_prop:addChild(self.panel_prop)
			end
			quality = dms.int(dms["magical_animals_mould"], self.mould_id, magical_animals_mould.quality)
			self.quality = quality
			self.item_count = 0 -- 不显示等级

			local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
			if Panel_star ~= nil then
				Panel_star:removeAllChildren(true)
			end
			local initStar = 0
			if self.table.shipStar ~= nil then
				initStar = tonumber(self.table.shipStar)
			end
			if Panel_star ~= nil and initStar > 0 then
				neWshowShipStar(Panel_star , initStar)
			end
			local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
			if Panel_xianding then 
				Panel_xianding:setVisible(false)
				Panel_xianding:removeAllChildren(true)
				-- 限定神兽标签
				DisplayLimitAnimal(self.mould_id, nil, Panel_xianding, 1)
			end
		elseif self.current_type == self.enum_type.FIGHT_SPIRIT then
			--战魂数据，可以只有quality和mouldId
			local fightSpirit = self.table.fightSpirit
			if fightSpirit == nil then 
				fightSpirit = {}
				fightSpirit.mouldId = self.mould_id
				fightSpirit.quality = dms.int(dms["fight_spirit_mould"], self.mould_id, fight_spirit_mould.quality)
				fightSpirit.lockStatus = 0
			end
			-- if fightSpirit.id then
			-- 	self.item_count = fightSpirit.id
			-- else
				self.item_count = 0
			-- end
			quality = fightSpirit.quality
			local pos = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.pos)
			local path = "images/ui/text/TF_res/FightSpirit/zhanhun_icon/zhanhun_light_"..quality..".png"
			-- DSC重塑
			local backImgPath = "image/roles/suit/roles_suit_button_"..(pos + 1)..".png"
			if __lua_project_id == __lua_project_l_digital and cc.FileUtils:getInstance():isFileExist(backImgPath) then
				local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
				Panel_kuang:removeAllChildren(true)
				self.panel_prop = cc.Sprite:create(backImgPath)
				self.panel_prop:setPosition(cc.p(Panel_kuang:getContentSize().width/2,Panel_kuang:getContentSize().height/2))
				Panel_kuang:addChild(self.panel_prop)
				local lightIcon = cc.Sprite:create(path)
				local posInfo = cc.p(0,0)
				if pos == 1 then
					posInfo = cc.p(34,78)
				elseif pos == 2 then
					posInfo = cc.p(76,78)
				elseif pos == 3 then
					posInfo = cc.p(34,12)
				elseif pos == 4 then 
					posInfo = cc.p(75,12)
				end
				lightIcon:setPosition(posInfo)
				self.panel_prop:addChild(lightIcon)

				local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
				local path = "images/ui/text/TF_res/FightSpirit/zhanhun_icon/zhanhun_icon_"..suitId..".png"
				local icon = cc.Sprite:create(path)
				icon:setPosition(cc.p(Panel_kuang:getContentSize().width/2,Panel_kuang:getContentSize().height/2))
				Panel_kuang:addChild(icon)
			else
				self.panel_prop = cc.Sprite:create(path)
				if self.panel_prop ~= nil then 
					self.panel_prop:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
					Panel_prop:addChild(self.panel_prop)
					local rotate = 0
					if pos == 2 then
						rotate = 90
					elseif pos == 3 then
						rotate = -90
					elseif pos == 4 then
						rotate = 180
					end
					self.panel_prop:setRotation(rotate)

					local suitId = dms.int(dms["fight_spirit_mould"], fightSpirit.mouldId, fight_spirit_mould.suit_id)
					local path = "images/ui/text/TF_res/FightSpirit/zhanhun_icon/zhanhun_icon_"..suitId..".png"
					local icon = cc.Sprite:create(path)
					icon:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
					Panel_prop:addChild(icon)
				end
			end
			
		    if not self.table.notShowBg then
		    	ccui.Helper:seekWidgetByName(root,"Image_lock"):setVisible(fightSpirit.lockStatus == 1)
		    end
		    if self.table.showRecommend then
		        local path = "images/ui/quality/recommend.png"
				local icon = cc.Sprite:create(path)
				icon:setAnchorPoint(cc.p(0,0))
				ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon"):addChild(icon)
		    end
			if fightSpirit.level then
				ccui.Helper:seekWidgetByName(root, "Text_level_up"):setVisible(true)
				ccui.Helper:seekWidgetByName(root, "Text_level_up"):setString("+"..fightSpirit.level)
			end
		end
		self:onDrawIconPad2(quality+1)
		
	end
	if self.current_type == self.enum_type.RECHARGE_SHOP_INFORMATION then
	elseif self.current_type == self.enum_type.ALLOY_MATRIX then
	elseif self.item_count > 0 then
		
		self.item_order_level:setVisible(true)
		local strs = ""
		if self.isnumberX ~= nil then
			strs = ""
		else
			strs = "x"
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			strs = ""
		end
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			-- if  self.item_count >= 100000000 then
			-- 	item_order_level:setString(strs..math.floor(self.item_count / 100000000) .. string_equiprety_name[39])
			-- else
			if self.item_count >= 10000 then
				self.item_order_level:setString(strs..math.floor(self.item_count / 1000) .. "k")
			else
				self.item_order_level:setString(strs..self.item_count)
			end
		else
			if self.item_count >= 100000000 then
				self.item_order_level:setString(strs..math.floor(self.item_count / 100000000) .. string_equiprety_name[39])
			elseif self.item_count >= 10000 then
				self.item_order_level:setString(strs..math.floor(self.item_count / 10000) .. "w")
			else
				self.item_order_level:setString(strs..self.item_count)
			end
		end
		
	end
	
end
	
function ResourcesIconCell:hideCount(isVisibel)
	local root = self.roots[1]
	-- local item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")
	self.item_order_level:setVisible(isVisibel)
end

function ResourcesIconCell:onEnterTransitionFinish()
end

function ResourcesIconCell:showIconInfo(datas ,sender)
	-- Fury 4-oct (:1786): fwin:removeTouchEventListener vacia sender._datas si la
	-- celda se repinta durante el 0,5 s de la pulsacion larga.
	if datas == nil then
		return
	end
	if fwin:find("propInformationClass") ~= nil then
		fwin:close(fwin:find("propInformationClass"))
	end
	if fwin:find("propMoneyInfoClass") ~= nil then
		fwin:close(fwin:find("propMoneyInfoClass"))
	end
	if fwin:find("AlloyMatrixHoldClass") ~= nil then
		fwin:close(fwin:find("AlloyMatrixHoldClass"))
	end
	if fwin:find("SilkBagHoldClass") ~= nil then
		fwin:close(fwin:find("SilkBagHoldClass"))
	end

	if fwin:find("vouchersInformationClass") ~= nil then
		fwin:close(fwin:find("vouchersInformationClass"))
	end
	
	if fwin:find("HeadFrameInformationClass") ~= nil then
		fwin:close(fwin:find("HeadFrameInformationClass"))
	end

	-- if fwin:find("MythicalAnimalsTipClass") ~= nil then
	-- 	fwin:close(fwin:find("MythicalAnimalsTipClass"))
	-- end

	if datas.item_type == 1 
		or datas.item_type == 2
		or datas.item_type == 3
		or datas.item_type == 5
		or datas.item_type == 8
		or datas.item_type == 18
		or datas.item_type == 28
		or datas.item_type == 34
		or datas.item_type == 12
		or datas.item_type == 39
		or datas.item_type == 67
		or datas.item_type == 68
		or datas.item_type == 69
		or datas.item_type == 75
		then
		local cell = propMoneyInfo:new()
		cell:init(""..datas.item_info, nil, sender)
		fwin:open(cell, fwin._windows)
	elseif datas.item_type == 66 then
		local cell = AlloyMatrixHold:new()
      	cell:init(66, datas.item_info, sender)
      	fwin:open(cell, fwin._windows)
	elseif datas.item_type == 6
		or datas.item_type == 7
		or datas.item_type == 64
		then
		local cell = propInformation:new()
		cell:init(datas.item_info, datas.types, sender)
		fwin:open(cell, fwin._windows)
	elseif datas.item_type == 13 then
		local cell = smHeroInformation:new()
		cell:init(datas.item_info, sender , datas.table)
		fwin:open(cell, fwin._windows)
	elseif datas.item_type == 71 then
		local cell = SilkBagHold:new()
		cell:init(71,self.mould_id, datas.item_info, sender)
		fwin:open(cell, fwin._windows)
	elseif datas.item_type == 72 then
		state_machine.excute("mythical_animals_tip_window_open", 0, {mould_id = self.mould_id, info = datas.item_info})
	elseif datas.item_type == 74 then
		local cell = vouchersInformation:new()
		cell:init(datas.item_info, 1, sender)
		fwin:open(cell, fwin._windows)
	elseif datas.item_type == 76 then
		local cell = HeadFrameInformation:new()
		cell:init(datas.item_info, sender)
		fwin:open(cell, fwin._windows)
	end
end

function ResourcesIconCell:updateStarInfo( bounty_hero_param_id , stars)
	local root = self.roots[1]
	local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star")
	if Panel_star ~= nil then
		if bounty_hero_param_id ~= nil then
			local rewards = dms.string(dms["bounty_hero_param"], bounty_hero_param_id, bounty_hero_param.rewards)
			if rewards ~= nil then
				rewards = zstring.split(rewards, ",")
				if zstring.tonumber(rewards[4]) > 0 then
					Panel_star:removeAllChildren(true)
					neWshowShipStar(Panel_star, zstring.tonumber(rewards[4]))
				end
			end
		else
			Panel_star:removeAllChildren(true)
			if stars then
				neWshowShipStar(Panel_star, stars)
			end
		end
	end
end

function ResourcesIconCell:onInit()
	local root = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		if self.isBig == true then
			root = cacher.createUIRef("icon/item.csb", "root")
		else
			root = cacher.createUIRef("icon/item.csb", "root")
		end
	else
		local csbItem = nil
		if self.isBig == true then
			csbItem = csb.createNode("icon/item.csb")
		else
			csbItem = csb.createNode("icon/item.csb")
		end
		root = csbItem:getChildByName("root")
	end
	root:removeFromParent(false)
	self:setContentSize(ccui.Helper:seekWidgetByName(root, "Panel_prop_box"):getContentSize())
	self:addChild(root)
	table.insert(self.roots, root)

	self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end

	self:clearUIInfo()

	if self.isBig == true then
		if ResourcesIconCell.__big_size == nil then
			ResourcesIconCell.__big_size = root:getContentSize()
		end
	else
		if ResourcesIconCell.__size == nil then
			ResourcesIconCell.__size = root:getContentSize()
		end
	end

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon")
	    Panel_props_left_icon:removeAllChildren(true)

	    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_right_icon")
	    Panel_props_right_icon:removeAllChildren(true)

	    if root._x == nil then
	    	root._x = 0
	    	root:setPositionX(root._x)
	    end

	    if root._y == nil then
	    	root._y = 0
	    	root:setPositionY(root._y)
	    end
	end

	if self.rewardType ~= nil then
		self:onUpdateDraw()
	else
		self:onUpdateDraw2()
	end

	if self.current_type == 5 then
		if __lua_project_id ==__lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			then
			--只显示兽魂 
			local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
			fwin:addTouchEventListener(Panel_prop, nil, 
			{
				terminal_name = "resource_icon_cell_show_info", 
				terminal_state = 0, 
				_prop = self.current_type
			},
			nil,0)
			if nil ~= Panel_prop then
				Panel_prop:setSwallowTouches(false)
			end
		end
	end

	local Text_activity_num = ccui.Helper:seekWidgetByName(root,"Text_num")
	local Text_activity_time = ccui.Helper:seekWidgetByName(root,"Text_time")
	local Image_jiaobiao = ccui.Helper:seekWidgetByName(root,"Image_jiaobiao")
	if self.current_type == 64 then
		Text_activity_num:setVisible(true)
		Text_activity_time:setVisible(true)
		local limit_time_index  = dms.int(dms["ship_skin_mould"], self.mould_id, ship_skin_mould.duration)
		local des_time = zstring.tonumber(limit_time_index) == -1 and tipStringInfo_evolution_status_tips[4] or limit_time_index .. tipStringInfo_evolution_status_tips[5]
		Text_activity_num:setString("1")
		Text_activity_time:setString(des_time)
		Image_jiaobiao:setVisible(true)
		self.item_order_level:setVisible(false)
		Text_activity_num:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
		Text_activity_time:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
	end

	if self.showTip == true then 
		--弹出提示 
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, 
		{
			terminal_name = "resource_icon_cell_show_prop_info", 
			terminal_state = 0, 
			_prop = self.current_type,
			_id = self.mould_id,
		},
		nil,0)
	end

	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	Panel_prop._self = self
	if self.isLongTouch == true and self.current_type == self.enum_type.FIGHT_SPIRIT then
		local function rewardTouchCallback(sender, eventType)
	        if eventType == ccui.TouchEventType.began then
	        	sender._hasShow = false
	        	if sender._self ~= nil and sender._self.roots ~= nil and sender._self.roots[1] ~= nil and sender._self.isLongTouch == true then
		        	sender:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create((function ( sender )
		        		if sender._self ~= nil and sender._self.roots ~= nil and sender._self.roots[1] ~= nil then
		        			if not sender._hasShow then
								local cell = sender._self
								sender._hasShow = true
					        	local beganPos = sender:getTouchBeganPosition()
					        	local movePos = sender:getTouchMovePosition()
					        	if movePos.x == 0 or movePos.y == 0 or (math.abs(beganPos.x-movePos.x) < 20 and math.abs(beganPos.y-movePos.y) < 20) then
									-- 战魂长按
									if cell.table.fightSpirit then
										app.load("client.packs.FightSpirit.FightSpiritSkill")
										state_machine.excute("fight_spirit_skill_window_open", 0, {_datas = {fightSpirit1 = cell.table.fightSpirit}})
									else
										app.load("client.packs.FightSpirit.FightSpiritHandle")
										app.load("client.packs.FightSpirit.fightspiritskill1")
										local fightSp = FightSpiritHandle.getFightSpiritByMouldId(self.mould_id)
										local cell = state_machine.excute("fight_spirit_skill1_create", 0, {fightSpirit = fightSp, previewType = 1, widget = sender})
										fwin:open(cell, fwin._windows)
									end
								end
							end
						end
                    end))))
		        end
			elseif eventType == ccui.TouchEventType.moved then
			elseif eventType == ccui.TouchEventType.ended 
				or eventType == ccui.TouchEventType.canceled
				then
				sender:stopAllActions()
				if not sender._hasShow then
					local cell = sender._self
					sender._hasShow = true
					if self.table.callback then
						local beganPos = sender:getTouchBeganPosition()
			        	local endPos = sender:getTouchEndPosition()
						if math.abs(beganPos.x-endPos.x) < 20 and math.abs(beganPos.y-endPos.y) < 20 then
							if self.table.selectSpiritInfo then 
								self.table.callback(self.table.selectSpiritInfo.cellPos,self.table.selectSpiritInfo.cellIdx)
							else
								self.table.callback()
							end
						end
					end
				end
			end
	    end

	    Panel_prop:addTouchEventListener(rewardTouchCallback)
		if nil ~= Panel_prop then
			Panel_prop:setSwallowTouches(false)
		end
	elseif self.isLongTouch == true then
		local function rewardTouchCallback(sender, eventType)
	        if eventType == ccui.TouchEventType.began then
	        	sender._isTouch = true
	        	sender._hasShow = false
	        	if sender._self ~= nil and sender._self.roots ~= nil and sender._self.roots[1] ~= nil and sender._self.isLongTouch == true then
		        	sender:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create((function ( sender )
		        		if sender._self ~= nil and sender._self.roots ~= nil and sender._self.roots[1] ~= nil then
		        			if not sender._hasShow then
		        				sender._hasShow = true
								local cell = sender._self
								cell:showIconInfo(sender._datas, sender)     
							end
						end
                    end))))
		        end
			elseif eventType == ccui.TouchEventType.moved then
				if sender._isTouch == true then
					local beganPos = sender:getTouchBeganPosition()
		        	local movePos = sender:getTouchMovePosition()

					if (math.abs(beganPos.x-movePos.x) > 20 or math.abs(beganPos.y-movePos.y) > 20) then
						if sender._self ~= nil and sender._self.excuteTouchEndedEvent ~= nil then
							sender._self:excuteTouchEndedEvent(sender)
							sender._isTouch = false
						end
					end
				end
			elseif eventType == ccui.TouchEventType.ended 
				or eventType == ccui.TouchEventType.canceled
				then
				if sender._isTouch == true then
					if sender._self ~= nil and sender._self.excuteTouchEndedEvent ~= nil then
						sender._self:excuteTouchEndedEvent(sender, eventType)
						sender._isTouch = false
					end
				end
			end
	    end
	    Panel_prop:addTouchEventListener(rewardTouchCallback)
		if nil ~= Panel_prop then
			Panel_prop:setSwallowTouches(false)
		end

	    local info = nil
	    local table = {}
	    local types = 0
	    if self.current_type == 6 then
	    	info = {user_prop_template = self.mould_id, prop_number = tonumber(self.item_count)}
	    	types = 1
	    elseif self.current_type == 7 then
	    	local equipmentData = dms.element(dms["equipment_mould"] , self.mould_id)
	    	local quality = dms.atoi(equipmentData, equipment_mould.grow_level)
	    	if self.table ~= nil and self.table.equipQuality ~= nil then
	    		quality = dms.atoi(equipmentData, equipment_mould.trace_npc_index)
	    	end
	    	local name = smEquipWordlFundByIndex( self.mould_id , 1)
	    	info = {user_prop_template = self.mould_id, mould_id = self.mould_id ,equipment_quality = quality,mould_name = name}
	    	types = 2
	    elseif self.current_type == 13 then
		    if info == nil then
		    	info = self.mould_id
		    	if self.table ~= nil and self.table.shipStar ~= nil then
		    		table = self.table
		    	end
		    end
		elseif self.current_type == 66 then
		    info = {metalMould = self.mould_id, metalLevel = 1, metalRankLevel = 0}

		-- 如果是皮肤
		elseif self.current_type == 64 then
			info = {user_prop_template = self.mould_id}
			-- types只有材料弹窗用到，用来区分类型，这里新加一个皮肤类型
			types = 3
		elseif self.current_type == 71 then
			info = self.table
		elseif self.current_type == 72 then
			info = self.table
		elseif self.current_type == 73 then
			info = self.table
		elseif self.current_type == 74 then
			info = self.mould_id
		elseif self.current_type == 76 then
			-- 头像框
			info = self.mould_id
	    else
	    	info = self.current_type
	    end
	    
	    Panel_prop._datas = {
			item_type = self.current_type,
			item_info = info,
			types = types,
			table = table,
		}
	else
		fwin:removeTouchEventListener(Panel_prop)
	end
end

function ResourcesIconCell:excuteTouchEndedEvent(sender, eventType)
	sender:stopAllActions()
	if not sender._hasShow then
		local cell = sender._self
		sender._hasShow = true
		if self.table.callback then
			local beganPos = sender:getTouchBeganPosition()
        	local endPos = sender:getTouchEndPosition()

        	if math.abs(beganPos.x-endPos.x) < 20 and math.abs(beganPos.y-endPos.y) < 20 then
				if self.table.cellNums then 
					self.table.callback(self.table.cellNums)
				elseif self.table.selectSpiritInfo then 
					self.table.callback(self.table.selectSpiritInfo.cellPos,self.table.selectSpiritInfo.cellIdx)
				elseif self.table.mSelectPray then 
					self.table.callback(self.table.mCell,self.table.mType)
				else
					self.table.callback()
				end
			end
		elseif eventType == ccui.TouchEventType.ended and sender._datas ~= nil then
			local beganPos = sender:getTouchBeganPosition()
			local endPos = sender:getTouchEndPosition()
			if math.abs(beganPos.x-endPos.x) < 20 and math.abs(beganPos.y-endPos.y) < 20 then
				fwin:showIconInfoOnTap(sender, function() if self ~= nil and self.showIconInfo ~= nil then self:showIconInfo(sender._datas, sender) end end)
			end
		end
	else
		local datas = sender._datas
		if datas.item_type == 1 
			or datas.item_type == 2
			or datas.item_type == 3
			or datas.item_type == 5
			or datas.item_type == 8
			or datas.item_type == 12
			or datas.item_type == 18
			or datas.item_type == 28
			or datas.item_type == 34
			or datas.item_type == 39
			or datas.item_type == 67
			or datas.item_type == 68
			or datas.item_type == 69
			or datas.item_type == 75
			then
			fwin:close(fwin:find("propMoneyInfoClass"))
		elseif datas.item_type == 66 then
			fwin:close(fwin:find("AlloyMatrixHoldClass"))
		elseif datas.item_type == 71 then
			fwin:close(fwin:find("SilkBagHoldClass"))
		elseif datas.item_type == 72 then
			-- fwin:close(fwin:find("MythicalAnimalsTipClass"))
		elseif datas.item_type == 6
			or datas.item_type == 7 
			-- 皮肤用的框和数码兽碎片一样
			or datas.item_type == 64
			then
			fwin:close(fwin:find("propInformationClass"))
		elseif datas.item_type == 13 then
			fwin:close(fwin:find("smHeroInformationClass"))
		elseif datas.item_type == 74 then
			fwin:close(fwin:find("vouchersInformationClass"))
		elseif datas.item_type == 76 then
			fwin:close(fwin:find("HeadFrameInformationClass"))
		end
	end
end

function ResourcesIconCell:setChooseSelectState( isChoose )
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
	if Image_xuanzhong ~= nil then
    	Image_xuanzhong:setVisible(isChoose)
    end
end

function ResourcesIconCell:setActivityDouble( isShow )
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
	if Image_double ~= nil then
    	Image_double:setVisible(isShow)
    end
end

function ResourcesIconCell:setGrayState(isGray)
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	if Panel_prop ~= nil then
		local children = Panel_prop:getChildren()
		if children and children[1] then
			if isGray then
				display:gray(children[1])
			else
				display:ungray(children[1])
			end
		end
	end

	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	if Panel_ditu ~= nil then
		local children = Panel_ditu:getChildren()
		if children and children[1] then
			if isGray then
				display:gray(children[1])
			else
				display:ungray(children[1])
			end
		end
	end
end

-- 绘制头像框特效
function ResourcesIconCell:addHeadFrameEffect(effectIndex, panelHead)
	local isPlayEffect = false
	local jsonFile = string.format("images/ui/effice/effice_frame_%d/effice_frame_%d.json", effectIndex, effectIndex)
	local atlasFile = string.format("images/ui/effice/effice_frame_%d/effice_frame_%d.atlas", effectIndex, effectIndex)
	if true == cc.FileUtils:getInstance():isFileExist(jsonFile) then
		isPlayEffect = true

		local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		animation:setPosition(cc.p(panelHead:getContentSize().width / 2, panelHead:getContentSize().height / 2))
		panelHead:addChild(animation)
	end

	return isPlayEffect
end

function ResourcesIconCell:clearUIInfo( ... )
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
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
	    local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")        
	    local Label_name = ccui.Helper:seekWidgetByName(root,"Label_name")    
	    local Label_quantity = ccui.Helper:seekWidgetByName(root,"Label_quantity") 
	    local Label_shuxin = ccui.Helper:seekWidgetByName(root,"Label_shuxin") 
	    local Panel_prop = ccui.Helper:seekWidgetByName(root,"Panel_prop") 
	    local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") 
	    local Panel_ditu = ccui.Helper:seekWidgetByName(root,"Panel_ditu") 
	    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star") 
	    local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_right_icon") 
	    local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root,"Panel_props_left_icon") 
	    local Panel_num = ccui.Helper:seekWidgetByName(root,"Panel_num") 
	    local Text_1 = ccui.Helper:seekWidgetByName(root,"Text_1") 
	    local Image_26 = ccui.Helper:seekWidgetByName(root,"Image_26") 
	    local Image_item_vip = ccui.Helper:seekWidgetByName(root,"Image_item_vip") 
	    local Panel_4 = ccui.Helper:seekWidgetByName(root,"Panel_4") 
	    local Image_bidiao = ccui.Helper:seekWidgetByName(root,"Image_bidiao") 
	    local Image_dangqian = ccui.Helper:seekWidgetByName(root,"Image_dangqian") 
	    local Image_nub2 = ccui.Helper:seekWidgetByName(root,"Image_nub2") 
	    local Image_lock = ccui.Helper:seekWidgetByName(root,"Image_lock") 
	    local Image_3 = ccui.Helper:seekWidgetByName(root, "Image_3")
	    local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
	    local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	    local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
	    local Image_jiaobiao = ccui.Helper:seekWidgetByName(root, "Image_jiaobiao")
		local Text_activity_time = ccui.Helper:seekWidgetByName(root, "Text_time")
		local Text_activity_num = ccui.Helper:seekWidgetByName(root, "Text_num")
		local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
		local Text_level_up = ccui.Helper:seekWidgetByName(root, "Text_level_up")
		local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
		local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head")
		if Panel_head then
			Panel_head:removeAllChildren(true)
		end
		if Image_jiaobiao then
			Image_jiaobiao:setVisible(false)
		end
		if Text_activity_time then
			Text_activity_time:setString("")
		end 
		if Text_activity_num then
			Text_activity_num:setString("")
		end

		if Image_double ~= nil then
			Image_double:setVisible(false)
		end
		if Image_2 ~= nil then
			Image_2:setVisible(true)
		end
        if Image_3 ~= nil then
        	Image_3:setVisible(false)
        end
	    if Label_l_order_level ~= nil then 
	    	Label_l_order_level:setVisible(true)
	    	if Label_l_order_level._x then
		    	Label_l_order_level:setPositionX(Label_l_order_level._x)
		    end
	        Label_l_order_level:setString("")
	    end
	    if Label_name ~= nil then
	        Label_name:setString("")
	        Label_name:setVisible(true)
	        Label_name:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
	    end
	    if Label_quantity ~= nil then
	        Label_quantity:setString("")
	    end
	    if Label_shuxin ~= nil then
	        Label_shuxin:setString("")
	    end
	    if Panel_prop ~= nil then
	        Panel_prop:removeAllChildren(true)
	        Panel_prop:removeBackGroundImage()
	        Panel_prop:setTouchEnabled(true)
	    end
	    if Panel_kuang ~= nil then
	    	Panel_kuang:setVisible(true)
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
	    if Panel_ditu ~= nil then
	    	Panel_ditu:setVisible(true)
	        Panel_ditu:removeAllChildren(true)
	        Panel_ditu:removeBackGroundImage()
	    end
	    if Panel_star ~= nil then
	        Panel_star:removeAllChildren(true)
	        Panel_star:removeBackGroundImage()
	    end
	    if Panel_props_right_icon ~= nil then
	        Panel_props_right_icon:removeAllChildren(true)
	        Panel_props_right_icon:removeBackGroundImage()
	    end
	    if Panel_props_left_icon ~= nil then
	        Panel_props_left_icon:removeAllChildren(true)
	        Panel_props_left_icon:removeBackGroundImage()
	    end
	    if Panel_num ~= nil then
	        Panel_num:removeAllChildren(true)
	        Panel_num:removeBackGroundImage()
	    end
	    if Panel_4 ~= nil then
	        Panel_4:removeAllChildren(true)
	        Panel_4:removeBackGroundImage()
	    end
	    if Text_1 ~= nil then
	        Text_1:setString("")
	    end
	    if Image_xuanzhong ~= nil then
	    	Image_xuanzhong:setVisible(false)
	    end
	    if Image_lock ~= nil then
	    	Image_lock:setVisible(false)
	    end
	    if ssrIcon then
	    	ssrIcon:setVisible(false)
	    end
	    if Text_level_up ~= nil then
	    	Text_level_up:setVisible(false)
	    	Text_level_up:setString("")
		end
		if Panel_xianding ~= nil then 
			Panel_xianding:removeAllChildren(true)
		end
	end
end

function ResourcesIconCell:onExit()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
		local root = self.roots[1]
	    self:clearUIInfo()
	    if self.isBig == true then
			cacher.freeRef("icon/item.csb", root)
		else
			cacher.freeRef("icon/item.csb", root)
		end
	end
end
--为防止参数项过多，第9个定义为table类型，想要什么可以往里面加 
--table解析
--table.shipStar --战船星级
--table.equipQuality -- 装备品质，不填为初始品质，填则为显示品质
--table.lazy 	-- 延迟加载
function ResourcesIconCell:init(interfaceType, item_count, mould_id, rewardType, isBig,showTip ,isLongTouch, isnumberX ,table) -- 道具、道具模板ID，没有为-1
	self.current_type = tonumber(interfaceType)
	self.item_count = tonumber(item_count)
	self.mould_id = tonumber(mould_id)
	if rewardType ~= nil then
		self.rewardType = rewardType
	end
	self.isBig = isBig
	self.showTip = showTip or false
	self.isLongTouch = isLongTouch or nil
	self.isnumberX = isnumberX or nil
	self.table = table or {}
	if self.table.lazy == nil or self.table.lazy ~= true then
		self:onInit()
	end
	if self.isBig == true then
		self:setContentSize(ResourcesIconCell.__big_size)
	else
		self:setContentSize(ResourcesIconCell.__size)
	end
end

function ResourcesIconCell:createCell()
	local cell = ResourcesIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function ResourcesIconCell:reload()
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
	    local root = self.roots[1]
	    if root ~= nil then
	        return
	    end
	    self:onInit()
	end
end

function ResourcesIconCell:unload()
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
		then
	    local root = self.roots[1]
	    if root == nil then
	        return
	    end
	    self:clearUIInfo()
	    if self.isBig == true then
			cacher.freeRef("icon/item.csb", root)
		else
			cacher.freeRef("icon/item.csb", root)
		end
		root:removeFromParent(false)
    	self.roots = {}
	end
end

