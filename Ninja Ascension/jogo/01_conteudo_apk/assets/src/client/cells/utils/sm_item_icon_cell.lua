----------------------------------------------------------------------------------------------------
-- 说明：数码的小图标绘制
-------------------------------------------------------------------------------------------------------
SmItemIconCell = class("SmItemIconCellClass", Window)
SmItemIconCell.__size = nil

local sm_item_icon_cell_create_terminal = {
    _name = "sm_item_icon_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmItemIconCell:new()
        cell:init(params[1],params[2],params[3],params[4],params[5],params[6],params[7])
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_item_icon_cell_create_terminal)
state_machine.init()

function SmItemIconCell:ctor()
    self.super:ctor()
	self.roots = {}

	self.res_data = {
		{2,"images/ui/props/props_4002.png", _All_tip_string_info._fundName},				-- 	1:银币
		{2,"images/ui/props/props_4001.png", _All_tip_string_info._crystalName},			-- 	2:金币 
		{2,"images/ui/props/props_4004.png", _All_tip_string_info._reputation},--  3:声望 
		{0,"images/ui/props/props_4007.png", _All_tip_string_info._hero},												-- 	4:将魂 
		{2,"images/ui/props/props_3000.png", _All_tip_string_info._juexingsuipian},												-- 	5:魂玉 (水雷魂)
		{0,"", ""},												-- 	6:道具
		{0,"", ""},												-- 	7:装备 
		{2,"images/ui/props/props_4003.png", reward_prop_list[8]},				-- 	8:经验
		{0,"", ""},												-- 	9:耐力 
		{0,"", ""},												-- 	10:功能点
		{0,"", ""},												-- 	11:上阵人数 
		{2,"images/ui/props/props_4005.png", _All_tip_string_info._energyName},					--	12:体力
		{0,"", ""},												-- 	13:武将 
		{0,"", ""},												-- 	14:竞技场排名
		{0,"", ""},												-- 	15:伤害 
		{0,"", ""},												-- 	16:比武积分 
		{0,"", ""},												-- 	17:霸气 
		{2,"images/ui/props/props_4006.png", _All_tip_string_info._glories},	-- 	18:试炼币
		{0,"", ""},												-- 	19:日常任务积分 
		{0,"", ""},												-- 	20:功勋 
		{0,"", ""},												-- 	21:战功
		{4," ", " "},											-- 	22:日常副本基本奖励
		{4," ", " "},											-- 	23:日常副本额外奖励
		{4," ", " "},											-- 	24:出击令
		{4," ", " "},											-- 	25:免战
		{4," ", " "},											-- 	26:
		{4," ", " "},											-- 	27:
		{2,"images/ui/props/props_4013.png", _All_tip_string_info._union_exploit},			-- 	28:公会币
		{4," ", " "},											-- 	29
		{4," ", " "},											-- 	30
		{0,"", ""},												-- 	31
		{0,"", ""},												-- 	32
		{0,"", ""},												-- 	33:驯兽魂
		{2,"images/ui/props/props_4008.png", _my_gane_name[15]},				-- 	34:天赋点
		{2,"images/ui/props/props_4009.png", " "},											-- 	35:探索币
		{0," ", " "},											-- 	36
		{0," ", " "},											-- 	37
		{0," ", " "},											-- 	38
		{4,"images/ui/props/props_4039.png", _my_gane_name[17]},										-- 	39
		{0," ", " "},											-- 	40
		{0," ", " "},											-- 	41
		{0," ", " "},											-- 	42
		{0," ", " "},											-- 	43
		{0," ", " "},											-- 	44
		{0," ", " "},											-- 	45
		{0," ", " "},											-- 	46
		{0," ", " "},											-- 	47
		{0," ", " "},											-- 	48
		{0," ", " "},											-- 	49
		{0," ", " "},											-- 	50
		{0," ", " "},											-- 	51
		{0," ", " "},											-- 	52
		{0," ", " "},											-- 	53
		{0," ", " "},											-- 	54
		{0," ", " "},											-- 	55
		{0," ", " "},											-- 	56
		{0," ", " "},											-- 	57
		{0," ", " "},											-- 	58
		{0," ", " "},											-- 	59
		{0," ", " "},											-- 	60
		{0," ", " "},											-- 	61
		{0," ", " "},											-- 	62
		{4,"images/ui/props/props_4063.png", _my_gane_name[16]},	-- 	63:活跃度
		{4,"", ""},	                                               -- 	64
		{4,"images/ui/props/props_4065.png", _my_gane_name[18]},	-- 	65:矿石
		{0,"", ""},				-- 	66 合金
		{3,"images/ui/props/props_4067.png", _All_tip_string_info._matrix_essence},				-- 	67 合金精华

		{3, "images/ui/props/props_4009.png", _All_tip_string_info._explore_money},				-- 	68 探索币
		{3, "images/ui/props/props_4069.png", _All_tip_string_info._holy_essence},				-- 	69 圣物精华
		{3, "images/ui/props/props_4009.png", _All_tip_string_info._explore_money},				-- 	70 探索币（口袋）
		{0, "images/ui/props/props_%d.png", " "},				                                -- 	71 锦囊
		{0, "images/ui/props/props_%d.png", " "},				                                -- 	71 锦囊
		{0, "images/ui/props/props_%d.png", " "},				                                -- 	71 战魂
		{0, "images/ui/props/props_%d.png", " "},				                                -- 	74 代金券
		{2, "image/activity/passport/activity_passport_icon_exchange.png", " "},				-- 	75 战令经验代币
		{6, "", " "},																			-- 	76 头像框
	}

	app.load("client.cells.prop.prop_money_info")
	app.load("client.cells.prop.prop_information")
	app.load("client.cells.prop.vouchers_information")
	app.load("client.cells.prop.sm_hero_information")
	app.load("client.l_digital.cultivate.matrix.AlloyMatrixHold")
	app.load("client.l_digital.cultivate.silkbag.SilkBagHold")
	app.load("client.shop.recharge.RechargeVoucher")
	app.load("client.l_digital.cells.player.head_frame_information")

	local function init_sm_item_icon_cell_terminal()
		local prop_money_icon_cell_show_info_terminal = {
            _name = "sm_item_icon_cell_show_info",
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
            	if fwin:find("AlloyMatrixHoldClass") ~= nil then
            		fwin:close(fwin:find("AlloyMatrixHoldClass"))
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
		local sm_item_icon_cell_show_prop_info_terminal = {
            _name = "sm_item_icon_cell_show_prop_info",
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
            	if fwin:find("AlloyMatrixHoldClass") ~= nil then
            		fwin:close(fwin:find("AlloyMatrixHoldClass"))
				end
				if fwin:find("SilkBagHoldClass") ~= nil then
					fwin:close(fwin:find("SilkBagHoldClass"))
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
        state_machine.add(sm_item_icon_cell_show_prop_info_terminal)
		state_machine.add(prop_money_icon_cell_show_info_terminal)
        state_machine.init()
        state_machine.init()
	end
	init_sm_item_icon_cell_terminal()
end

function SmItemIconCell:onUpdateDraw()
	local root = self.roots[1]
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
	local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
	local Text_num = ccui.Helper:seekWidgetByName(root, "Text_num")
	local Image_jiaobiao = ccui.Helper:seekWidgetByName(root, "Image_jiaobiao")
	local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
	local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
	local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head")
	Text_time:setVisible(false)
	Text_num:setVisible(false)
	Image_jiaobiao:setVisible(false)
	if ssrIcon then
		ssrIcon:setVisible(false)
	end
	if Panel_xianding ~= nil then 
		Panel_xianding:removeAllChildren(true)
	end
	local name = ""
	local quality = 0
	local count = 0
	local prop_icon = nil
	local items = self.item
	if zstring.tonumber(items[3]) > 0 then
		count = zstring.tonumber(items[3])
		if zstring.tonumber(items[1]) == 1 then
			quality = self.res_data[1][1]
			prop_icon = cc.Sprite:create(self.res_data[1][2])
			name = _my_gane_name[1]
		elseif zstring.tonumber(items[1]) == 2 then
			quality = self.res_data[2][1]
			prop_icon = cc.Sprite:create(self.res_data[2][2])
			name = _my_gane_name[2]
		elseif zstring.tonumber(items[1]) == 3 then
			quality = self.res_data[3][1]
			prop_icon = cc.Sprite:create(self.res_data[3][2])
			name = _my_gane_name[3]
		elseif zstring.tonumber(items[1]) == 4 then	--将魂
			quality = self.res_data[4][1]
			prop_icon = cc.Sprite:create(self.res_data[4][2])
			name = _my_gane_name[5]
		elseif zstring.tonumber(items[1]) == 5 then	--魂玉
			quality = self.res_data[5][1]
			prop_icon = cc.Sprite:create(self.res_data[5][2])
			name = self.res_data[5][3]
		elseif zstring.tonumber(items[1]) == 8 then	--经验
			quality = self.res_data[8][1]
			prop_icon = cc.Sprite:create(self.res_data[8][2])
			count = zstring.tonumber(items[3])
			name = _my_gane_name[7]
		elseif zstring.tonumber(items[1]) == 9 then	--耐力
			quality = self.res_data[9][1]
			prop_icon = cc.Sprite:create(self.res_data[9][2])
			name = _my_gane_name[9]
		elseif zstring.tonumber(items[1]) == 10 then	--功能点
			quality = self.res_data[10][1]
			prop_icon = cc.Sprite:create(self.res_data[10][2])
			name = _my_gane_name[10]
		elseif zstring.tonumber(items[1]) == 12 then	--体力
			quality = self.res_data[12][1]
			prop_icon = cc.Sprite:create(self.res_data[12][2])
			name = _my_gane_name[8]
		elseif zstring.tonumber(items[1]) == 18 then	--威名
			quality = self.res_data[18][1]
			prop_icon = cc.Sprite:create(self.res_data[18][2])
			name = _my_gane_name[6]
		elseif zstring.tonumber(items[1]) == 20 then	--功勋
			quality = self.res_data[20][1]
			prop_icon = cc.Sprite:createshow_reward_list(self.res_data[20][2])
			name = _my_gane_name[11]
		-- elseif zstring.tonumber(items[1]) == 21 then	--战功
		-- 	quality = 0
		-- 	prop_icon = cc.Sprite:create(self.res_data[21][2])
		elseif zstring.tonumber(items[1]) == 28 then	--军团贡献
			quality = self.res_data[28][1]
			prop_icon = cc.Sprite:create(self.res_data[28][2])
			name = _my_gane_name[13]
		elseif zstring.tonumber(items[1]) == 31 then	--战神令
			quality = self.res_data[31][1]
			prop_icon = cc.Sprite:create(self.res_data[31][2])
			name = red_alert_resouce_tip[1][1]
		elseif zstring.tonumber(items[1]) == 6 then	--道具
			quality = dms.int(dms["prop_mould"], items[2], prop_mould.prop_quality)
			local info = setThePropsIcon(items[2])
			prop_icon = cc.Sprite:create(string.format("images/ui/props/props_%d.png", info[1]))
			name = info[2]
	        local sell_tag = dms.int(dms["prop_mould"], items[2], prop_mould.sell_tag)
			if sell_tag == 3 then
				local effect_paths = string.format(config_res.images.ui.effice.effect_quality_box, 1, 1)
				if cc.FileUtils:getInstance():isFileExist(effect_paths) == true then
					ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
					local armature = ccs.Armature:create("effect_quality_box_1")
					draw.initArmature(armature, nil, -1, 0, 1)
					armature:setPosition(cc.p(Panel_prop:getContentSize().width/2, Panel_prop:getContentSize().height/2))
					Panel_prop:addChild(armature,10)
				end
			end
			if dms.int(dms["prop_mould"], items[2], prop_mould.change_of_equipment) ~= 0 then
				if Image_26 ~= nil then
					Image_26:setVisible(true)
				end
			elseif dms.int(dms["prop_mould"], items[2],  prop_mould.use_of_ship) ~= 0 then
				if dms.int(dms["prop_mould"], items[2],  prop_mould.props_type) == 16 then 
					if Image_26 ~= nil then
						Image_26:setVisible(false)
					end
				else
					if Image_26 ~= nil then
						Image_26:setVisible(true)
					end
				end
			end
			local footerData = dms.string(dms["prop_mould"], items[2], prop_mould.trace_remarks)
		    local footerInfo = zstring.split(footerData, ",")
		    -- local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon")
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
		    -- local Panel_props_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_right_icon")
		    if Panel_props_right_icon ~= nil then
			    Panel_props_right_icon:removeAllChildren(true)
			    if footerInfo[2] ~= nil and tonumber(footerInfo[2]) ~= -1 then
			        local props_right_icon = cc.Sprite:create(string.format("images/ui/icon/icon_%d.png", tonumber(footerInfo[2])))
			        if props_right_icon ~= nil then
				        props_right_icon:setPosition(cc.p(Panel_props_right_icon:getContentSize().width/2,Panel_props_right_icon:getContentSize().height/2))
				        Panel_props_right_icon:addChild(props_right_icon)
				    end
			    end
			end
			-- pmc武将碎片图标显示ssr
			if true then
				local storage_page_index = dms.int(dms["prop_mould"], items[2], prop_mould.storage_page_index)
				local shipMouldId = dms.int(dms["prop_mould"], items[2], prop_mould.use_of_ship)

				if storage_page_index == 18 and shipMouldId > 0 then
					local ability = dms.int(dms["ship_mould"], shipMouldId, ship_mould.ability)
					local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
					ssrIcon:setVisible(true)
					ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
				end
			end
			
			if __lua_project_id == __lua_project_l_digital then 
				-- 武将限定卡SP标签
				local storage_page_index = dms.int(dms["prop_mould"], items[2], prop_mould.storage_page_index)
				local shipMouldId = dms.int(dms["prop_mould"], items[2], prop_mould.use_of_ship)
				local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
				DisplaySpCardTag(shipMouldId, spIcon)
			else
				-- 武将限定卡显示
				local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
				if Panel_xianding then 
					Panel_xianding:setVisible(false)
					Panel_xianding:removeAllChildren(true)
					local storage_page_index = dms.int(dms["prop_mould"], items[2], prop_mould.storage_page_index)
					local shipMouldId = dms.int(dms["prop_mould"], items[2], prop_mould.use_of_ship)
		
					if storage_page_index == 18 and shipMouldId > 0 then
						DisplayLimitCard(shipMouldId ,Panel_xianding , 1)
					else
						-- 限定神兽标签
						DisplayLimitAnimal(nil, items[2], Panel_xianding, 1)
					end
		
				end
			end
		elseif zstring.tonumber(items[1]) == 7 then	--装备
			-- quality = dms.int(dms["equipment_mould"], items[2], equipment_mould.grow_level)
			quality = dms.int(dms["equipment_mould"], items[2], equipment_mould.trace_npc_index)
			local icon_index = dms.int(dms["equipment_mould"], items[2], equipment_mould.pic_index)
			prop_icon = cc.Sprite:create(string.format("images/ui/props/props_%d.png", icon_index))
			local nameindex = dms.int(dms["equipment_mould"], items[2], equipment_mould.equipment_name)
			local word_info = dms.element(dms["word_mould"], nameindex)
			name = word_info[3]
		elseif zstring.tonumber(items[1]) == 13 then	--武将
			local evo_image = dms.string(dms["ship_mould"], items[2], ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			local evo_mould_id = evo_info[dms.int(dms["ship_mould"], items[2], ship_mould.captain_name)]
			picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			prop_icon = cc.Sprite:create(string.format("images/ui/props/props_%d.png", picIndex))
			quality = shipOrEquipSetColour(dms.int(dms["ship_mould"], items[2], ship_mould.initial_rank_level))-1
			
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			name = word_info[3]

			if Panel_star ~= nil then
				Panel_star:removeAllChildren(true)
			end
			local initStar = dms.int(dms["ship_mould"], items[2], ship_mould.ship_star)
			if self.table.shipStar ~= nil then
				initStar = tonumber(self.table.shipStar)
			end
			if Panel_star ~= nil then
				neWshowShipStar(Panel_star , initStar)
			end
			self.isShowCount = false

			-- pmc武将图标显示ssr
			if true then
				local ability = dms.int(dms["ship_mould"], items[2], ship_mould.ability)
				local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
				ssrIcon:setVisible(true)
				ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
			end

			if __lua_project_id == __lua_project_l_digital then 
				-- 武将限定卡SP标签
				local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
				DisplaySpCardTag(tonumber(items[2]), spIcon)
			else
				-- 武将限定卡显示
				local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
				if Panel_xianding then 
					Panel_xianding:setVisible(false)
					Panel_xianding:removeAllChildren(true)
					DisplayLimitCard(tonumber(items[2]) ,Panel_xianding , 1)
				end
			end
		elseif zstring.tonumber(items[1]) == 64 then	--皮肤
			local evo_image = dms.string(dms["ship_mould"], items[2], ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			local evo_mould_id = dms.int(dms["ship_skin_mould"], items[2], ship_skin_mould.ship_evo_id)
			picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			prop_icon = cc.Sprite:create(string.format("images/ui/props/props_%d.png", picIndex))
			quality = 3
			if Panel_star ~= nil then
				Panel_star:removeAllChildren(true)
			end
			Panel_star:setVisible(false)

			local evo_mould_id = dms.int(dms["ship_skin_mould"], items[2], ship_skin_mould.ship_evo_id)
			local name_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_index)
			name = word_info[3]

			local limit_time_index  = dms.int(dms["ship_skin_mould"], items[2], ship_skin_mould.duration)
			local des_time_r = zstring.tonumber(limit_time_index) == -1 and tipStringInfo_evolution_status_tips[4] or limit_time_index .. tipStringInfo_evolution_status_tips[5]
			local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")
			local Text_num = ccui.Helper:seekWidgetByName(root, "Text_num")
			local Image_jiaobiao = ccui.Helper:seekWidgetByName(root, "Image_jiaobiao")
			Text_time:setVisible(true)
			Text_num:setVisible(true)
			Image_jiaobiao:setVisible(true)
			Text_time:setString(des_time_r)
			Text_num:setString("1")
			Image_jiaobiao:setVisible(true)
			self.isShowCount = false
		elseif zstring.tonumber(items[1]) == 33 then	--驯兽魂
			quality = self.res_data[33][1]
			prop_icon = cc.Sprite:create(self.res_data[33][2])
			name = _my_gane_name[14]
		elseif zstring.tonumber(items[1]) == 34 then	
			quality = self.res_data[34][1]
			prop_icon = cc.Sprite:create(self.res_data[34][2])
			name = _my_gane_name[15]
		elseif zstring.tonumber(items[1]) == 39 then	
			quality = self.res_data[39][1]
			prop_icon = cc.Sprite:create(self.res_data[39][2])
			name = self.res_data[39][3]
		elseif zstring.tonumber(items[1]) == 63 then	--活跃度
			quality = self.res_data[63][1]
			prop_icon = cc.Sprite:create(self.res_data[63][2])
			name = _my_gane_name[16]
		elseif zstring.tonumber(items[1]) == 65 then	--矿石
			quality = self.res_data[63][1]
			prop_icon = cc.Sprite:create(self.res_data[65][2])
			name = self.res_data[65][3]
		elseif zstring.tonumber(items[1]) == 66 then --合金
			local nameindex = dms.int(dms["ship_metal_mould"], items[2], ship_metal_mould.name)
			local word_info = dms.element(dms["word_mould"], nameindex)
			name = word_info[3]

			local pic_id = dms.int(dms["ship_metal_mould"], items[2], ship_metal_mould.pic_id)
			quality = dms.int(dms["ship_metal_mould"], items[2], ship_metal_mould.quality)
			prop_icon = cc.Sprite:create(string.format("images/ui/props/props_%d.png", pic_id))

			local matrix_add_type = dms.int(dms["ship_metal_mould"], items[2], ship_metal_mould.add_type)
			local add_attribute = cc.Sprite:create(string.format("images/ui/text/smhj/attr_text_%d.png", matrix_add_type))
			local Panel_props_left_icon = ccui.Helper:seekWidgetByName(root, "Panel_props_left_icon")

		    if add_attribute then
		    	add_attribute:setPosition(cc.p(Panel_props_left_icon:getContentSize().width/2,Panel_props_left_icon:getContentSize().height/2))
		        Panel_props_left_icon:addChild(add_attribute)
		    end
		elseif zstring.tonumber(items[1]) == 67 then	--合金精华
			quality = 3
			prop_icon = cc.Sprite:create(self.res_data[67][2])
			name = self.res_data[67][3]

		elseif zstring.tonumber(items[1]) == 68 then	-- 探索币
			quality = 3
			prop_icon = cc.Sprite:create(self.res_data[68][2])
			name = self.res_data[68][3]
		elseif zstring.tonumber(items[1]) == 70 then	-- 探索币（口袋）
			quality = 3
			prop_icon = cc.Sprite:create(self.res_data[70][2])
			name = self.res_data[70][3]

		elseif zstring.tonumber(items[1]) == 69 then	-- 圣物精华
			quality = 3
			prop_icon = cc.Sprite:create(self.res_data[69][2])
			name = self.res_data[69][3]
		elseif zstring.tonumber(items[1]) == 71 then	-- 锦囊
			local silk_mould_id = tonumber(items[2])
			quality = dms.int(dms["ship_silk_bag_mould"], silk_mould_id,ship_silk_bag_mould.quality_level)
			local icon_index = dms.int(dms["ship_silk_bag_mould"], silk_mould_id, ship_silk_bag_mould.pic_index)
			resIndex = string.format(self.res_data[71][2], icon_index)
			prop_icon = cc.Sprite:create(resIndex)
			--获取装备名称索引
			local nameindex = dms.int(dms["ship_silk_bag_mould"], silk_mould_id, ship_silk_bag_mould.silkbag_name)
			--通过索引找到word_mould
			local word_info = dms.element(dms["word_mould"], nameindex)
			local names = word_info[3]		
			name = names
		elseif zstring.tonumber(items[1]) == 73 then	-- 战魂
			local pos = dms.int(dms["fight_spirit_mould"], items[2], fight_spirit_mould.pos)
			quality = dms.int(dms["fight_spirit_mould"], items[2], fight_spirit_mould.quality)
			local path = "images/ui/text/TF_res/FightSpirit/zhanhun_icon/zhanhun_light_"..quality..".png"
			-- DSC重塑
			local backImgPath = "image/roles/suit/roles_suit_button_"..(pos + 1)..".png"
			if __lua_project_id == __lua_project_l_digital and cc.FileUtils:getInstance():isFileExist(backImgPath) then
				local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
				Panel_kuang:removeAllChildren(true)
				local backPnel = cc.Sprite:create(backImgPath)
				backPnel:setPosition(cc.p(Panel_kuang:getContentSize().width/2,Panel_kuang:getContentSize().height/2))
				Panel_kuang:addChild(backPnel)
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
				backPnel:addChild(lightIcon)
			else
				local kuang = cc.Sprite:create(path)

				kuang:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				Panel_prop:addChild(kuang)

				local rotate = 0
				if pos == 2 then
					rotate = 90
				elseif pos == 3 then
					rotate = -90
				elseif pos == 4 then
					rotate = 180
				end
				kuang:setRotation(rotate)
			end

	        local suitId = dms.int(dms["fight_spirit_mould"], items[2], fight_spirit_mould.suit_id)
	        local path = "images/ui/text/TF_res/FightSpirit/zhanhun_icon/zhanhun_icon_"..suitId..".png"
			local icon = cc.Sprite:create(path)
			if __lua_project_id == __lua_project_l_digital then
				icon:setPosition(cc.p(Panel_kuang:getContentSize().width/2,Panel_kuang:getContentSize().height/2))
				Panel_kuang:addChild(icon)
			else
				icon:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
				Panel_prop:addChild(icon)
			end
			name = self.res_data[73][3]
		elseif zstring.tonumber(items[1]) == 74 then	-- 代金券
			local vouchers_mould_id = tonumber(items[2])
			quality = dms.int(dms["vouchers_mould"], vouchers_mould_id,warehouse_vouchers_mould.quality_level)
			local icon_index = dms.int(dms["vouchers_mould"], vouchers_mould_id, warehouse_vouchers_mould.pic_index)
			local resIndex = string.format(self.res_data[74][2], icon_index)
			prop_icon = cc.Sprite:create(resIndex)
			--获取装备名称索引
			local nameindex = dms.int(dms["vouchers_mould"], vouchers_mould_id, warehouse_vouchers_mould.name_id)
			--通过索引找到word_mould
			local word_info = dms.element(dms["word_mould"], nameindex)
			local names = word_info[3]		
			name = names
		elseif zstring.tonumber(items[1]) == 75 then  --战令经验代币
			quality = 2
			local resIndex = self.res_data[75][2]
			prop_icon = cc.Sprite:create(resIndex)
			-- 战令经验代币名称
			local names = _All_tip_string_info._warOrderExp
			--绘制
			name = names
		elseif zstring.tonumber(items[1]) == 76 then  --头像框
			quality = 6
			
			local headFrameInfo = dms.searchs(dms["face_frame_mould"], face_frame_mould.id, zstring.tonumber(items[2]))[1]
			-- 头像框名称
			local nameIndex = dms.atoi(headFrameInfo, face_frame_mould.nameID)
			local names = dms.string(dms["word_mould"], nameIndex, word_mould.text_info)
			--绘制
			name = names
			
			local effectIndex = zstring.split(dms.atos(headFrameInfo, face_frame_mould.effectIDInfo), ",", tonumber)[1]
			local isPlayEffect = false
			if effectIndex and effectIndex ~= -1 then
				isPlayEffect = self:addHeadFrameEffect(effectIndex, Panel_head)
			end

			if isPlayEffect == false then
				local picID = dms.atoi(headFrameInfo, face_frame_mould.resID)
				local resPath = string.format("image/cut/frame/cut_frame_%d.png", picID)
				
				local headIcon = cc.Sprite:create(resPath)
				if headIcon ~= nil then
					Panel_head:addChild(headIcon)
					headIcon:setPosition(Panel_head:getContentSize().width / 2, Panel_head:getContentSize().height / 2)
				end
			end
		end
	end
    if prop_icon ~= nil then
        prop_icon:setPosition(cc.p(Panel_prop:getContentSize().width/2,Panel_prop:getContentSize().height/2))
        Panel_prop:addChild(prop_icon)
    end
    if self.isShowName == true then
		Label_name:setString(name)
	end
	Label_name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	if self.isShowCount == true then
		-- if tonumber(count) >= 100000000 then
		-- 	Label_l_order_level:setString(math.floor(count / 100000000) .. string_equiprety_name[39])
		-- else
		if tonumber(count) >= 10000 then
			Label_l_order_level:setString(math.floor(count / 1000) .. string_equiprety_name[40])
		else
			Label_l_order_level:setString(count)
		end
	end
	if quality ~= nil then
		Panel_ditu:removeBackGroundImage()
		Panel_ditu:setVisible(true)
		Panel_ditu:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality+1))
		if zstring.tonumber(items[1]) == 13 then
			Panel_kuang:setBackGroundImage(string.format("images/ui/quality/quality_frame_%d.png", quality))
		end
	end
end

function SmItemIconCell:onEnterTransitionFinish()
end

function SmItemIconCell:showIconInfo(datas ,sender)
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

	if fwin:find("FightSpiritSkill1Class") ~= nil then
		fwin:close(fwin:find("FightSpiritSkill1Class"))
	end

	if fwin:find("HeadFrameInformationClass") ~= nil then
		fwin:close(fwin:find("HeadFrameInformationClass"))
	end

	if datas.item_type == 1 
		or datas.item_type == 2
		or datas.item_type == 3
		or datas.item_type == 8
		or datas.item_type == 18
		or datas.item_type == 34
		or datas.item_type == 65
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
      	cell:init(71,datas.item_info, datas.table, sender)
		  fwin:open(cell, fwin._windows)
	elseif datas.item_type == 73 then
		local cell = state_machine.excute("fight_spirit_skill1_create", 0, {fightSpirit = datas.table[1], previewType = 1, widget = sender})
		fwin:open(cell, fwin._windows)
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

-- 星级-------------需要干掉
function SmItemIconCell:updateStarInfo( bounty_hero_param_id )
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
		end
	end
end

function SmItemIconCell:onInit()
	local root = nil
	root = cacher.createUIRef("icon/item.csb", "root")
	root:removeFromParent(false)
	self:setContentSize(ccui.Helper:seekWidgetByName(root, "Panel_prop_box"):getContentSize())
	self:addChild(root)
	table.insert(self.roots, root)

	if SmItemIconCell.__size == nil then
		SmItemIconCell.__size = root:getContentSize()
	end
	if root._x == nil then
		root._x = 0
	end
	if root._y == nil then
		root._x = 0
	end

	self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")--右下角等级
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end


	self:clearUIInfo()
	self:onUpdateDraw()

	if self.showTip == true then 
		--弹出提示 
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, 
		{
			terminal_name = "sm_item_icon_cell_show_prop_info", 
			terminal_state = 0, 
			_prop = self.item[1],
			_id = self.item[2],
		},
		nil,0)
	else
		if self.isLongTouch == true then
			local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
			local function rewardTouchCallback(sender, eventType)
		        if eventType == ccui.TouchEventType.began then
		        	sender._hasShow = false
		        	if sender._self ~= nil and sender._self.roots ~= nil and sender._self.roots[1] ~= nil and sender._self.isLongTouch == true then
			        	sender:runAction(cc.Sequence:create(cc.DelayTime:create(0.5),cc.CallFunc:create((function ( sender )
			        		if sender._self ~= nil and sender._self.roots ~= nil and sender._self.roots[1] ~= nil and sender._self.isLongTouch == true then
								local cell = sender._self
								sender._hasShow = true
								cell:showIconInfo(sender._datas ,sender)     
							end
	                    end))))
			        end
				elseif eventType == ccui.TouchEventType.moved then
				elseif eventType == ccui.TouchEventType.ended 
					or eventType == ccui.TouchEventType.canceled
					then
					sender:stopAllActions()
					local datas = sender._datas
					if eventType == ccui.TouchEventType.ended and sender._hasShow ~= true and datas ~= nil then
						local beganPos = sender:getTouchBeganPosition()
						local endPos = sender:getTouchEndPosition()
						if math.abs(beganPos.x-endPos.x) < 20 and math.abs(beganPos.y-endPos.y) < 20 then
							local cell = sender._self
							fwin:showIconInfoOnTap(sender, function() if cell ~= nil and cell.showIconInfo ~= nil then cell:showIconInfo(datas, sender) end end)
						end
					end
					if tonumber(datas.item_type) == 1 
						or tonumber(datas.item_type) == 2
						or tonumber(datas.item_type) == 3
						or tonumber(datas.item_type) == 8
						or tonumber(datas.item_type) == 18
						or tonumber(datas.item_type) == 34
						or tonumber(datas.item_type) == 65
						or tonumber(datas.item_type) == 67
						or tonumber(datas.item_type) == 68
						or tonumber(datas.item_type) == 69
						or tonumber(datas.item_type) == 75
						then
						fwin:close(fwin:find("propMoneyInfoClass"))
					elseif tonumber(datas.item_type) == 66 then
						fwin:close(fwin:find("AlloyMatrixHoldClass"))
					elseif tonumber(datas.item_type) == 6
						or tonumber(datas.item_type) == 7 
						then
						fwin:close(fwin:find("propInformationClass"))
					elseif tonumber(datas.item_type) == 13 then
						fwin:close(fwin:find("smHeroInformationClass"))
					elseif tonumber(datas.item_type) == 71 then
						fwin:close(fwin:find("SilkBagHoldClass"))
					elseif tonumber(datas.item_type) == 74 then
						fwin:close(fwin:find("vouchersInformationClass"))
					elseif tonumber(datas.item_type) == 76 then
						fwin:close(fwin:find("HeadFrameInformationClass"))
					end
				end
		    end
			if nil ~= Panel_prop then
				Panel_prop._self = self
				Panel_prop:addTouchEventListener(rewardTouchCallback)
				Panel_prop:setSwallowTouches(false)
				local info = nil
			    local table = {}
			    local types = 0
			    if zstring.tonumber(self.item[1]) == 6 then
			    	info = {user_prop_template = self.item[2], prop_number = zstring.tonumber(self.item[3])}
			    	types = 1
			    elseif zstring.tonumber(self.item[1]) == 7 then
			    	local equipmentData = dms.element(dms["equipment_mould"] , self.item[2])
			    	local quality = dms.atoi(equipmentData, equipment_mould.grow_level)
			    	if self.table ~= nil and self.table.equipQuality ~= nil then
			    		quality = dms.atoi(equipmentData, equipment_mould.trace_npc_index)
			    	end
			    	local name = smEquipWordlFundByIndex( self.item[2] , 1)
			    	info = {user_prop_template = self.item[2], mould_id = self.item[2] ,equipment_quality = quality,mould_name = name}
			    	types = 2
			    elseif zstring.tonumber(self.item[1]) == 13 then
				    if info == nil then
				    	info = self.item[2]
				    	if self.table ~= nil and self.table.shipStar ~= nil then
				    		table = self.table
				    	end
				    end
				elseif zstring.tonumber(self.item[1]) == 66 then
					info = {metalMould = self.item[2], metalLevel = 1, metalRankLevel = 0}
				elseif zstring.tonumber(self.item[1]) == 71 then
					info = self.item[2]
					table = self.table
				elseif zstring.tonumber(self.item[1]) == 73 then
					info = self.item[2]
					table = self.table
				elseif zstring.tonumber(self.item[1]) == 74 then
					info = self.item[2]
					table = self.table
				elseif zstring.tonumber(self.item[1]) == 76 then
					info = self.item[2]
			    else
			    	info = zstring.tonumber(self.item[1])
			    end
			    Panel_prop._datas = {
					item_type = tonumber(self.item[1]),
					item_info = info,
					types = tonumber(types),
					table = table,
				}
			end
		else
			fwin:removeTouchEventListener(Panel_prop)
		end
	end
end

-- 选中框
function SmItemIconCell:setChooseSelectState( isChoose )
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Image_xuanzhong = ccui.Helper:seekWidgetByName(root, "Image_xuanzhong")
	if Image_xuanzhong ~= nil then
    	Image_xuanzhong:setVisible(isChoose)
    end
end

-- 双倍
function SmItemIconCell:setActivityDouble( isShow )
	local root = self.roots[1]
	if root == nil then
		return
	end
	local Image_double = ccui.Helper:seekWidgetByName(root, "Image_double")
	if Image_double ~= nil then
    	Image_double:setVisible(isShow)
    end
end

-- 绘制头像框特效
function SmItemIconCell:addHeadFrameEffect(effectIndex, panelHead)
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

function SmItemIconCell:clearUIInfo( ... )
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
	local Text_num = ccui.Helper:seekWidgetByName(root, "Text_num")
	local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
	local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
	local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head")
	if Panel_head then
		Panel_head:removeAllChildren(true)
	end
	if Image_double ~= nil then
		Image_double:setVisible(false)
	end
	if Image_2 ~= nil then
		Image_2:setVisible(false)
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
		Panel_prop._self = nil
		Panel_prop._datas = nil
		Panel_prop:setVisible(true)
		Panel_prop:removeAllChildren(true)
		Panel_prop:removeBackGroundImage()
		Panel_prop:setSwallowTouches(false)
		fwin:removeTouchEventListener(Panel_prop)
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
		Panel_star:setVisible(true)
		Panel_star:removeAllChildren(true)
		Panel_star:removeBackGroundImage()
	end
	if Panel_props_right_icon ~= nil then
		Panel_props_right_icon:setVisible(true)
		Panel_props_right_icon:removeAllChildren(true)
		Panel_props_right_icon:removeBackGroundImage()
	end
	if Panel_props_left_icon ~= nil then
		Panel_props_left_icon:setVisible(true)
		Panel_props_left_icon:removeAllChildren(true)
		Panel_props_left_icon:removeBackGroundImage()
	end
	if Panel_num ~= nil then
		Panel_num:setVisible(true)
		Panel_num:removeAllChildren(true)
		Panel_num:removeBackGroundImage()
	end
	if Panel_4 ~= nil then
		Panel_4:setVisible(true)
		Panel_4:removeAllChildren(true)
		Panel_4:removeBackGroundImage()
	end
	if Text_1 ~= nil then
		Text_1:setVisible(true)
		Text_1:setString("")
	end
	if Text_num ~= nil then
		Text_num:setVisible(true)
		Text_num:setString("")
	end
	if Image_xuanzhong ~= nil then
		Image_xuanzhong:setVisible(true)
		Image_xuanzhong:setVisible(false)
	end

	if ssrIcon then
		ssrIcon:setVisible(false)
	end
	if Panel_xianding ~= nil then 
		Panel_xianding:removeAllChildren(true)
	end
end

function SmItemIconCell:onExit()
	local root = self.roots[1]
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", root)
end

--为防止参数项过多，第7个定义为table类型，想要什么可以往里面加 
--interfaceType:使用类型
--item：道具信息（{type, mouldid, num}）
--isShowName：是否显示名字
--isShowCount：是否显示数量
--showTip：是否弹出提示
--isLongTouch：是否长按出提示
--table解析
--table.shipStar --战船星级
--table.equipQuality -- 装备品质，不填为初始品质，填则为显示品质		
function SmItemIconCell:init(interfaceType, item, isShowName, isShowCount, showTip, isLongTouch, table)
	self.current_type = zstring.tonumber(interfaceType)
	self.item = item
	self.isShowName = isShowName
	self.isShowCount = isShowCount
	self.showTip = showTip
	self.isLongTouch = isLongTouch
	self.table = table or {}
	self:onInit()
	self:setContentSize(SmItemIconCell.__size)
end

function SmItemIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SmItemIconCell:unload()
    local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("icon/item.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

