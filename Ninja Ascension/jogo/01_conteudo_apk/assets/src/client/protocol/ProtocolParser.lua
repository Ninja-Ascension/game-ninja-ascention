-- ---------------------------------------------------------------------------
-- 本地数据解析 strData,code
-- ---------------------------------------------------------------------------
function parser2(strData, code)
	local strDatas = strData
	local lists = lua_string_split_line(strDatas, "\n")
	local list = lua_string_splits(lists, " ")

	pos = 2
	list.pos = pos
	if code == 182 then		
		parse_battle_field_init(nil,nil,nil,nil,list,nil)
	elseif code == 39 then
		parse_environment_fight(nil,nil,nil,nil,list,nil)
	elseif code == 400 then
		parse_battle_role_info(nil,nil,nil,nil,list,nil)
	end
end


-- 文件已经超过上限(256KB),后续协议解析放到ProtocolParserCopy.lua中.
require "client.protocol.ProtocolParserCopy"
require "client.protocol.ProtocolParserCopyEx" 
require "client.protocol.ProtocolParserCopyExx"

-- -------------------------------------------------------------------------------------------------------
-- parse_cmd_command 0
----------------------------------------------------------------------------------------------------------
local function parse_cmd_command(interpreter,datas,pos,strDatas,list,count)

end

-- -------------------------------------------------------------------------------------------------------
-- parse_power_init 70
----------------------------------------------------------------------------------------------------------
local function parse_power(interpreter,datas,pos,strDatas,list,count)
	local power = {
		power_id = npos(list), -- 霸气id 
		power_mould_id = npos(list), -- 霸气模板id 
		ship_id = npos(list), -- 伙伴id(没有为0) 
		tag_index = npos(list), -- 所在位置(0背包，1装备栏) 
		at_index = npos(list), -- 位置索引(从1开始) 
		level = npos(list), -- 等级
		total_exp = npos(list), -- 总经验
		power_mould = nil,-- 当前霸气模板实例
	}
	-- power.power_mould = elementAt(powerMould, power.power_mould_id) -- 初始化当前霸气模板实例
	-- _ED.user_powers[power.power_id] = power
	-- table.insert(_ED.user_new_powers, power) 
end

function parse_power_init(interpreter,datas,pos,strDatas,list,count) --返回霸气初始化
	_ED.user_current_master = zstring.tonumber(npos(list)) --霸气师的状态
	_ED.user_total_power_count = zstring.tonumber(npos(list))
	_ED.user_powers = {}
	for i = 1,_ED.user_total_power_count do 
		parse_power(interpreter,datas,pos,strDatas,list,count)
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_power_make 71
----------------------------------------------------------------------------------------------------------
function parse_power_make(interpreter,datas,pos,strDatas,list,count) --猎魂
	_ED.user_current_master = zstring.tonumber(npos(list)) --霸气师的状态
	
	-- 白色 绿色 蓝色 紫色(抽取的各种品质的霸气数量例如：1 2 3 4)
	_ED.master_one = npos(list)
	_ED.master_two = npos(list)
	_ED.master_three = npos(list)
	_ED.master_four = npos(list)
	
	-- 是否整合成一个经验霸气（0没有，1有）
	local comp = npos(list)
	
	-- 重置新增加的霸气
	_ED.user_new_powers = {}
	
	-- 解析猎取到的霸气
	local nCount = npos(list)
	for i = 1,nCount do 
		parse_power(interpreter,datas,pos,strDatas,list,count)
	end
	_ED.user_total_power_count = _ED.user_total_power_count + nCount
	
	-- 解析赠送的霸气
	nCount = npos(list)
	for i = 1,nCount do 
		parse_power(interpreter,datas,pos,strDatas,list,count)
	end
	_ED.user_total_power_count = _ED.user_total_power_count + nCount
end

-- -------------------------------------------------------------------------------------------------------
-- parse_power_swallow 73 --霸气吞噬
----------------------------------------------------------------------------------------------------------
function parse_power_swallow(interpreter,datas,pos,strDatas,list,count)
	local ativePowerId = npos(list)
	local power = _ED.user_powers[ativePowerId]
	power.level = npos(list)
	power.total_exp = npos(list)
	local size = npos(list)
	for i=1,size do
		_ED.user_powers[npos(list)]=nil
		_ED.user_total_power_count = _ED.user_total_power_count - 1
	end
end

-- --------------------------------------------------------------------------------------------------------
-- parse_power_equip 74 --霸气装备
-- --------------------------------------------------------------------------------------------------------
function parse_power_equip(interpreter,datas,pos,strDatas,list,count)
	-- 当前装备的霸气(装备的霸气id 位置(0背包，1装备栏) 索引位置（从1开始）)
	local equipPowerId = npos(list)
	local equipPower = _ED.user_powers[equipPowerId]
	equipPower.ship_id = npos(list)
	equipPower.tag_index = npos(list)
	equipPower.at_index = npos(list)
	
	local changePowerId = npos(list)
	local temp_ship_id = npos(list)
	local temp_tag_index = npos(list)
	local temp_at_index = npos(list)
	local changePower = _ED.user_powers[changePowerId]
	
	if changePower ~= nil then
		changePower.ship_id = temp_ship_id
		changePower.tag_index = temp_tag_index
		changePower.at_index = temp_at_index
	end
end

-- --------------------------------------------------------------------------------------------------------
-- parse_power_exchange 75 --霸气的兑换
-- --------------------------------------------------------------------------------------------------------
function parse_power_exchange(interpreter,datas,pos,strDatas,list,count)
	
end

-- -- -------------------------------------------------------------------------------------------------------
-- -- parse_search_order_list 168 --返回用户排行榜信息
-- -- --------------------------------------------------------------------------------------------------------
-- function parse_search_order_list(interpreter,datas,pos,strDatas,list,count)
	-- _ED.charts.order = npos(list)
	-- _ED.charts.user_name = npos(list)
	-- _ED.charts.order_value = npos(list)
	
	
-- end

-- -------------------------------------------------------------------------------------------------------
--    parse_user_skill_equipment  286
-- -------------------------------------------------------------------------------------------------------
function parse_user_skill_equipment(interpreter,datas,pos,strDatas,list,count)
	local nCount = zstring.tonumber(npos(list))
	for i = 1, nCount do
		local skill_equipment = {
			id = npos(list), -- ID 
			user_id = npos(list), -- 用户ID 
			skill_equipment_mould = npos(list), -- 技能装备模板ID 
			skill_equipment_base_mould = npos(list), -- 技能装备基础模板ID 
			skill_level = npos(list), -- 技能等级  
			equip_state = npos(list), -- 装备状态(1,已装备 0,未装备)  
			favor_level = npos(list), -- 好感等级	
			favor = npos(list), 	-- 好感度 
			master_type = npos(list), 	-- 学艺类型
			masters = npos(list), -- 抽卡状态(1,2,3,…(只有-1表示为无))
			master_favor_value = npos(list), -- 奖励值
		}
		skill_equipment.previous_skill_level = skill_equipment.skill_level
		_ED.user_skill_equipment[skill_equipment.skill_equipment_base_mould] = skill_equipment
	end
end

-- -------------------------------------------------------------------------------------------------------
--    parse_user_skill_equipment_learn_count  287
-- -------------------------------------------------------------------------------------------------------
function parse_user_skill_equipment_learn_count(interpreter,datas,pos,strDatas,list,count)
	_ED.free_learn_skill_count = npos(list) --免费次数
	_ED.stone_learn_skill_count = npos(list) --金币次数
end

-- -------------------------------------------------------------------------------------------------------
--    parse_user_skill_equipment_add_favor  288
-- -------------------------------------------------------------------------------------------------------
function parse_user_skill_equipment_add_favor(interpreter,datas,pos,strDatas,list,count)
	local skillEquipmentBaseMould = npos(list)
	local skill_equipment = _ED.user_skill_equipment[skillEquipmentBaseMould]
	skill_equipment.skill_equipment_mould = npos(list) -- 变更前
	skill_equipment.skill_equipment_base_mould = npos(list) -- 变更后
	skill_equipment.cur_add_favor = npos(list)
	skill_equipment.favor = npos(list)
	skill_equipment.favor_level = npos(list)
	skill_equipment.skill_level = npos(list)

end

-- -------------------------------------------------------------------------------------------------------
--    parse_user_skill_equipment_master_learn  289
-- -------------------------------------------------------------------------------------------------------
function parse_user_skill_equipment_master_learn(interpreter,datas,pos,strDatas,list,count)
	local skillEquipmentBaseMould = npos(list)
	local skill_equipment = _ED.user_skill_equipment[skillEquipmentBaseMould]
	skill_equipment.master_type = npos(list)	-- 学艺类型
	skill_equipment.masters = npos(list) -- 抽卡状态(1,2,3,…(只有-1表示为无))
	skill_equipment.master_favor_value = npos(list) -- 奖励值
end

-- -------------------------------------------------------------------------------------------------------
-- parse_user_skill_equipment_replace 290
-- -------------------------------------------------------------------------------------------------------
function parse_user_skill_equipment_replace(interpreter,datas,pos,strDatas,list,count)
		local skill_equipment_unsnatch_ID = npos(list)
		local skill_equipment_mould_ID = npos(list)
		_ED.user_skill_equipment[skill_equipment_unsnatch_ID].equip_state = "0"
		_ED.user_skill_equipment[skill_equipment_mould_ID].equip_state = "1"
end

-- -------------------------------------------------------------------------------------------------------
-- parse_user_sufficient_two 291
----------------------------------------------------------------------------------------------------------
function parse_user_sufficient_type(interpreter,datas,pos,strDatas,list,count) --充值状态
		_ED.user_sufficient_type = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
-- parse_update_notice 292
----------------------------------------------------------------------------------------------------------
function parse_update_notice(interpreter,datas,pos,strDatas,list,count) --返回资源更新公告信息
	local nCount = npos(list)
	_ED.resource_package_notices = {}
	for i=1, nCount do
		local package_notice = {
			id = npos(list),
			tile = npos(list),
			notice = npos(list)
		}
		table.insert(_ED.resource_package_notices, package_notice)
	end
end

-- --------------------------------------------------------------------------------------------------------
-- parse_buy_master_four 293 --开启第四个霸气师返回信息
-- --------------------------------------------------------------------------------------------------------
function parse_buy_master_four(interpreter,datas,pos,strDatas,list,count)
	_ED.user_current_master = zstring.tonumber(npos(list)) --霸气师的状态
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_hero_open_item 294 --返回霸气开启状态
-- ---------------------------------------------------------------------------------------------------------
function parse_hero_open_item(interpreter,datas,pos,strDatas,list,count)
	_ED.user_info.power_open_state = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_execute_string 295 --返回执行的脚本字符串
-- ---------------------------------------------------------------------------------------------------------
function parse_execute_string(interpreter,datas,pos,strDatas,list,count)
	local code = zstring.exchangeFrom(npos(list))
	local func = assert(loadstring(code))
	func()
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_execute_script_file 296 --返回执行的脚本文件
-- ---------------------------------------------------------------------------------------------------------
function parse_execute_script_file(interpreter,datas,pos,strDatas,list,count)
	local fileUrl = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_power_ten_call_back 297 --返回霸气召唤10次信息
-- ---------------------------------------------------------------------------------------------------------
function parse_power_ten_call_back(interpreter,datas,pos,strDatas,list,count)
	_ED.hunt_ten_message={}
	local count = npos(list)
	for i=1,count do
		_ED.hunt_ten_message[i]=npos(list)
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_power_info_change 298 --返回霸气所属变更信息
-- ---------------------------------------------------------------------------------------------------------
function parse_power_info_change(interpreter,datas,pos,strDatas,list,count)
	local size = npos(list)
	for i = 1, size do
		local id = npos(list)
		local shipid = npos(list)
		local tagindex = npos(list)
		local index = npos(list)
		
		_ED.user_powers[id].ship_id = shipid
		_ED.user_powers[id].tag_index = tagindex --标志在装备栏或是背包; 0:背包 1：装备栏
		_ED.user_powers[id].at_index = index
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_expcat_info 299 --返回经验金猫副本开启状态和剩余次数
-- ---------------------------------------------------------------------------------------------------------
local goldCat = 438
function parse_expcat_info(interpreter,datas,pos,strDatas,list,count)
	local openStatus = npos(list)
	local challengeLeft = npos(list)
	local buyCount = npos(list)
	
	if __lua_project_id==__lua_project_all_star then
		goldCat = 441
	end
	_ED.goldcat_exp_status = openStatus
	_ED.activity_pve_times[goldCat] = challengeLeft
	_ED.goldcat_exp_buy_count = buyCount
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_resource_mineral_init 300 --返回资源矿初始化信息
-- ---------------------------------------------------------------------------------------------------------
function parse_resource_mineral_init(interpreter,datas,pos,strDatas,list,count)
	_ED.resource_mineral = {}
	local area = npos(list)
	local page = npos(list)	
	local size = zstring.tonumber(npos(list))
	for i = 1, size do
		local mineralId = npos(list)
		local mouldId = npos(list)
		local playerId = npos(list)
		local playerLevel = npos(list)
		local playerName = npos(list)
		local ownTime = npos(list)
		local extendTimes = npos(list)
		local societyName = npos(list)
		local helperCounts = zstring.tonumber(npos(list))
		local _mineral = {
			index = i,
			resource_id = mineralId,
			resource_mould_id = mouldId,
			resource_area = area,
			resource_page = page,
			user_info = playerId,
			user_level = playerLevel,
			user_name = playerName,
			user_sociaty = societyName,
			mine_own_start_time = os.time(),
			own_time_get = zstring.tonumber(ownTime) / 1000,
			own_time = zstring.tonumber(ownTime) / 1000,
			extend_seize_times = extendTimes,
			helper_counts = helperCounts,
		}
		_ED.resource_mineral[mineralId]=_mineral
		_ED.resource_mineral[mineralId].resource_mineral_helper_info={}
		for j = 1, helperCounts do
			local helperId = npos(list)
			local helperName = npos(list)
			local helperLevel = npos(list)
			local helperIcon = npos(list)
			local helperTime_get = zstring.tonumber(npos(list)) / 1000
			local helperMouldId = npos(list)
			local _helper_info = {
				helper_id = helperId,
				helper_name = helperName,
				helper_level = helperLevel,
				helper_icon = helperIcon,
				helper_time_start = os.time(),
				helper_time_get = helperTime_get,
				helper_time = helperTime_get,
				helper_mould_id = helperMouldId,
			}
			_ED.resource_mineral[mineralId].resource_mineral_helper_info[_helper_info.helper_id] = _helper_info
		end
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_rob_mineral_info 301 --返回资源矿抢夺信息
-- ---------------------------------------------------------------------------------------------------------
function parse_rob_mineral_info(interpreter,datas,pos,strDatas,list,count)
	local infoCounts = npos(list)
	for i = 1, infoCounts do
		local fight_user_name = npos(list)
		local by_fight_user_name = npos(list)
		local resource_area = npos(list)
		local resource_page = npos(list)
		local resource_mineral_name = npos(list)
		local update_time = zstring.tonumber(npos(list))
		local specific_time = npos(list)
		
		local _rob_info = {
			fight_user_name = fight_user_name,
			by_fight_user_name = by_fight_user_name,
			resource_area = resource_area,
			resource_page = resource_page,
			resource_mineral_name = resource_mineral_name,
			update_time = update_time/1000,
			specific_time = specific_time,
		}
		_ED.resource_mineral_fight_info[i] = _rob_info
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_my_resource_mineral 302 --返回个人资源矿信息
-- ---------------------------------------------------------------------------------------------------------
function parse_my_resource_mineral(interpreter,datas,pos,strDatas,list,count)
	_ED.my_resource_mineral.resource_id = npos(list)
	if _ED.my_resource_mineral.resource_id ~= "0" then
		_ED.my_resource_mineral.resource_mould_id = npos(list)
		_ED.my_resource_mineral.owner_id = npos(list)
		_ED.my_resource_mineral.owner_level = npos(list)
		_ED.my_resource_mineral.owner_name = npos(list)
		_ED.my_resource_mineral.mine_own_start_time = os.time()
		_ED.my_resource_mineral.own_time_get = zstring.tonumber(npos(list)) / 1000 	
		_ED.my_resource_mineral.own_time = _ED.my_resource_mineral.own_time_get
		_ED.my_resource_mineral.extend_seize_times = npos(list)	
		local helperCounts = zstring.tonumber(npos(list))
		_ED.my_resource_mineral.helper_counts = helperCounts
		_ED.my_resource_mineral.resource_mineral_helper_info = {}
		for j = 1, helperCounts do
			local helper_id = npos(list)
			local helper_name = npos(list)
			local helper_level = npos(list)
			local helper_icon = npos(list)
			local helperTime_get = zstring.tonumber(npos(list)) / 1000
			local helperMouldId = npos(list)
			
			local help_info = {
				helper_id = helper_id,
				helper_name = helper_name,
				helper_level = helper_level,
				helper_icon = helper_icon,
				helper_time_start = os.time(),
				helper_time_get = helperTime_get,
				helper_time = helperTime_get,
				helper_mould_id = helperMouldId,
			}
			
			_ED.my_resource_mineral.resource_mineral_helper_info[helper_id] = help_info
		end
	else
		_ED.my_resource_mineral.resource_mould_id = ""
		_ED.my_resource_mineral.owner_id = ""
		_ED.my_resource_mineral.owner_level = ""
		_ED.my_resource_mineral.owner_name = ""
		_ED.my_resource_mineral.own_time = ""
		_ED.my_resource_mineral.extend_seize_times = ""
		_ED.my_resource_mineral.resource_mineral_helper_info = {}
	end
	
	_ED.my_resource_mineral.diamond_id = npos(list)	
	if _ED.my_resource_mineral.diamond_id ~= "0" then
		_ED.my_resource_mineral.diamond_mould_id = npos(list)	
		_ED.my_resource_mineral.diamond_owner_id = npos(list)	
		_ED.my_resource_mineral.diamond_owner_level = npos(list)	
		_ED.my_resource_mineral.diamond_owner_name = npos(list)
		_ED.my_resource_mineral.diamond_start_time = os.time()
		_ED.my_resource_mineral.diamond_time_get = zstring.tonumber(npos(list)) / 1000 	
		_ED.my_resource_mineral.diamond_time = _ED.my_resource_mineral.diamond_time_get
		_ED.my_resource_mineral.diamond_extend_times = npos(list)
	else
		_ED.my_resource_mineral.diamond_mould_id = ""
		_ED.my_resource_mineral.diamond_owner_id = ""	
		_ED.my_resource_mineral.diamond_owner_level = ""
		_ED.my_resource_mineral.diamond_owner_name = ""
		_ED.my_resource_mineral.diamond_time = ""	
		_ED.my_resource_mineral.diamond_extend_times = ""
	end
end


-- ---------------------------------------------------------------------------------------------------------
-- parse_glories_shop_info 303 --返回荣誉商店信息
-- ---------------------------------------------------------------------------------------------------------
function parse_glories_shop_info(interpreter,datas,pos,strDatas,list,count)
	local infoCounts = zstring.tonumber(npos(list))
	for i=1, infoCounts do
		-- local goods_id = npos(list)
		-- local goods_exchange_times = npos(list)
		local _goods = {
			goods_id = npos(list),
			goods_exchange_times = npos(list),
		}
		_ED.glories_shop_info[i] = _goods
	end
	_ED.glories_shop_refreash_times = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_glories_shop_exchange_info 304 --返回荣誉信息
-- ---------------------------------------------------------------------------------------------------------
function parse_glories_shop_exchange_info(interpreter,datas,pos,strDatas,list,count)
	local all_glories = npos(list)
	_ED.user_info.all_glories = all_glories
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_palace_exchange_shop_info 305 --返回灵王宫积分商店信息
-- ---------------------------------------------------------------------------------------------------------
function parse_palace_exchange_shop_info(interpreter,datas,pos,strDatas,list,count)
	local counts = zstring.tonumber(npos(list))
	_ED.palace_exchange_shop_info = {}
	for i=1, counts do
		local _goods = {
			good_id = npos(list),
			exchange_times = npos(list),
		}
		_ED.palace_exchange_shop_info[i] = _goods
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_palace_score_info 306 --返回灵王宫积分信息
-- ---------------------------------------------------------------------------------------------------------
function parse_palace_score_info(interpreter,datas,pos,strDatas,list,count)
	local palace_score = npos(list)
	_ED.palace_inside_info.user_palace_score = tonumber(palace_score)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_fashion_info 307 --返回时装穿戴信息
-- ---------------------------------------------------------------------------------------------------------
function parse_fashion_info(interpreter,datas,pos,strDatas,list,count)
	_ED.fashion_equipment = {}
	for i=1, 8 do
		local user_id = npos(list)								--用户ID
		local user_gender = npos(list)								--用户性别
		local user_equip_index = npos(list)						--用户时装位置
		local user_equiment_id = npos(list)						--用户装备ID
		local _fashion = {}
		if zstring.tonumber(user_equiment_id) > 0 then
			_fashion ={
				user_id = user_id,								--用户ID
				user_gender = user_gender,								--用户性别
				user_equip_index = user_equip_index,			--用户时装位置
				user_equiment_id=user_equiment_id,				--用户装备ID号
				user_equiment_template=npos(list),					--用户装备模版ID号
				user_equiment_name=npos(list),						--用户装备名称
				sell_price=npos(list),								--出售价格
				user_equiment_influence_type=npos(list),			--用户装备影响类型
				equipment_type=npos(list),							--装备类型
				user_equiment_ability=npos(list),					--用户装备能力值
				user_equiment_grade=npos(list),					--用户装备等级
				user_equiment_exprience=npos(list),					--用户装备经验
				user_equiment_growup_grade=npos(list),				--用户装备成长等级
				growup_value=npos(list),								--成长值
				adorn_need_ship=npos(list),								--佩戴所需战船等级
				equiment_picture=npos(list),							--装备图片标识
				equiment_track_remark=npos(list),					--追踪备注
				equiment_track_scene=npos(list),						--追踪场景
				equiment_track_npc=npos(list),						--追踪NPC
				equiment_track_npc_index=npos(list),				--追踪NPC下标
				equiment_refine_level = npos(list),				--精炼等级
				equiment_refine_param = npos(list),				--精炼属性
				refining_times = npos(list),				--洗练次数
				refining_value_life = npos(list),			--int		洗练生命值
				refining_value_temp_life = npos(list),		--int		洗练生命临时值
				refining_value_attack = npos(list),				--int		洗练攻击值
				refining_value_temp_attack = npos(list),			--int		洗练攻击临时值
				refining_value_physical_defence = npos(list),			--int		洗练物防值
				refining_value_temp_physical_defence = npos(list),	--int		洗练物防临时值
				refining_value_skill_defence = npos(list),			--int		洗练法防值
				refining_value_temp_skill_defence = npos(list),			--int		洗练法防临时值
				refining_value_final_damange = npos(list),			--int		洗练终伤值
				refining_value_temp_final_damange = npos(list),			--int		洗练终伤临时值
				refining_value_final_lessen_damange = npos(list),		--	int		洗练终减伤值
				refining_value_temp_final_lessen_damange = npos(list),			--int		洗练终减伤临时值
				prop_timestamp = npos(list),							--最新获取时间
			}
			_ED.fashion_equipment[i] = _fashion
		else
			_fashion ={
				user_id = user_id,								--用户ID
				user_gender = user_gender,						--用户性别
				user_equip_index = user_equip_index,			--用户时装位置
				user_equiment_id=user_equiment_id,				--用户装备ID号
			}
			_ED.fashion_equipment[i] = _fashion
		end
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_palace_init_info 308 --返回灵王宫初始化信息
-- ---------------------------------------------------------------------------------------------------------
function parse_palace_init_info(interpreter,datas,pos,strDatas,list,count)
	_ED.palace_inside_info.current_floor = npos(list)
	_ED.palace_inside_info.current_progress = npos(list)
	local maxMoveNum = elementAtToString(spiritePalaceMould, tonumber(_ED.palace_inside_info.current_floor), spirite_palace_mould.max_move_num)
	if tonumber(_ED.palace_inside_info.current_progress) >= tonumber(maxMoveNum) then
		_ED.palace_inside_info.floor_over = true
	end
	_ED.palace_inside_info.current_action_power = npos(list)
	_ED.palace_inside_info.current_hp = npos(list)
	_ED.palace_inside_info.max_hp = npos(list)
	_ED.palace_inside_info.current_score = npos(list)
	_ED.palace_inside_info.last_score = npos(list)
	_ED.palace_inside_info.user_palace_score = npos(list)
	_ED.palace_encounter_type["Left"] = tonumber(npos(list))
	_ED.palace_encounter_type["Forward"] = tonumber(npos(list))
	_ED.palace_encounter_type["Right"] = tonumber(npos(list))
	_ED.palace_inside_info.encounter_info.cur_type = tonumber(npos(list))
	if _ED.palace_inside_info.encounter_info.cur_type == 0 then
		_ED.palace_inside_info.encounter_info.is_over = true
	else 
		_ED.palace_inside_info.last_event = _ED.palace_inside_info.encounter_info.cur_type
		local encounterInfo = elementAt(spiritePalaceEventParam, _ED.palace_inside_info.encounter_info.cur_type)
		local eventParam = encounterInfo:atos(spirite_palace_event_param.event_param)
		local dataString = zstring.split(eventParam, ",")
		local eventType = dataString[1] -- 事件类型
		if eventType == "0" then	 	-- 战斗
			_ED.palace_encounter_param.event_image_index = npos(list)
			_ED.palace_encounter_param.event_person_name = npos(list)
		elseif 	eventType == "1" then 	-- 问答
			_ED.palace_encounter_param.question_index = npos(list)
		end
		if eventType == "7" or eventType == "8" then
			_ED.palace_inside_info.encounter_info.is_over = true
		else 
			_ED.palace_inside_info.encounter_info.is_over = false
		end	
	end
	_ED.palace_inside_info.action_power_buytimes = npos(list)
	_ED.palace_inside_info.hp_buytimes = npos(list)
	_ED.palace_inside_info.reset_times = npos(list)
	_ED.palace_inside_info.destination_flag = npos(list)
	_ED.palace_inside_info.ATK_up = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_palace_formation_display 309 --返回灵王宫查看阵型
-- ---------------------------------------------------------------------------------------------------------
function parse_palace_formation_display(interpreter,datas,pos,strDatas,list,count)
	local counts = npos(list)
	_ED.palace_formation = {}
	for i=1, counts do
		local shipId = npos(list)
		local shipMouldId = shipId == "0" and "0" or npos(list)
		local shipLevel = shipId == "0" and "0" or npos(list)
		local shipImageIndex = shipId == "0" and "0" or npos(list)
		local temp_palace_formation = {
			ship_id = shipId,
			ship_mould_id = shipMouldId,
			ship_level = shipLevel,
			ship_image_index = shipImageIndex,
		}
		_ED.palace_formation[i] = temp_palace_formation
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_palace_battle_result 310 --返回灵王宫战斗结果评分
-- ---------------------------------------------------------------------------------------------------------
function parse_palace_battle_result(interpreter,datas,pos,strDatas,list,count)
	_ED.palace_battle_result_info.grade = npos(list)
	_ED.palace_battle_result_info.originalScore = npos(list)
	_ED.palace_battle_result_info.addScore = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_palace_auto_explore 311 --返回灵王宫自动探宝信息
-- ---------------------------------------------------------------------------------------------------------
function parse_palace_auto_explore(interpreter,datas,pos,strDatas,list,count)
	_ED.palace_auto_explore = {}
	_ED.palace_auto_explore.action_power_consume = npos(list)
	_ED.palace_auto_explore.score_get = npos(list)
	_ED.palace_auto_explore.spoils_of_war = {}
	local size = npos(list)
	for i = 1, size do
		local spoilsOfWar = {
			mould_id = npos(list),
			count = npos(list),
		}
		_ED.palace_auto_explore.spoils_of_war[i] = spoilsOfWar
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_battle_fashion_info 312 --返回战场初始化时装信息
-- ---------------------------------------------------------------------------------------------------------
function parse_battle_fashion_info(interpreter,datas,pos,strDatas,list,count)
	for i=1,2 do
		local self={
			mType=npos(list),
			leaderId=npos(list),
			genderId=npos(list),
			eye =npos(list),   
			ear =npos(list),
			cap =npos(list),
			cloth =npos(list),
			glove =npos(list),
			weapon =npos(list),
			shoes =npos(list),
			wing =npos(list),
		}
		_ED.battle_fashion_info[i] = self
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_palace_cast_equipment 313 --返回灵王宫橙装铸造信息
-- ---------------------------------------------------------------------------------------------------------
function parse_palace_cast_equipment(interpreter,datas,pos,strDatas,list,count)
	_ED.palace_cast_equipment_id = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_cross_server_fight_init 314 --返回跨服争霸初始化信息
-- ---------------------------------------------------------------------------------------------------------
function parse_cross_server_fight_init(interpreter,datas,pos,strDatas,list,count)
	local sessionNum = npos(list)
	local state = npos(list)
	local stateProgress = nil
	local stateType = nil
	if state == "3" then
		stateProgress = npos(list)
		stateType = npos(list)
	end
	local remainTime = tonumber(npos(list)) / 1000 + 5
	local remainTimeStart = os.time()
	local applyState = npos(list)
	local serverCode = npos(list)
	_ED.cross_battle_info = {
		session_num = sessionNum,
		state = state,
		state_progress = tonumber(stateProgress),	
		state_type = stateType,
		remain_time = remainTime,
		remain_time_start = remainTimeStart,
		apply_state = applyState,
		server_code = serverCode
	}
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_cross_server_join_game_init 315 --返回跨服争霸进入赛场初始化
-- ---------------------------------------------------------------------------------------------------------
function parse_cross_server_join_game_init(interpreter,datas,pos,strDatas,list,count)
	_ED.cross_battle_info.match_state = npos(list)
	_ED.cross_battle_info.match_progress = tonumber(npos(list))
	_ED.cross_battle_info.match_type = npos(list)
	_ED.cross_battle_info.match_remain_time = tonumber(npos(list)) / 1000 + 5
	_ED.cross_battle_info.match_remain_time_start = os.time()
	_ED.cross_battle_play_info = {}
	_ED.cross_battle_match_group = {}
	local size1 = zstring.tonumber(npos(list))
	for i=1, size1 do -- 16 pairs
		local _match_id = npos(list)
		
		local _player1_id = npos(list)
		local _player1_name = npos(list)
		local _player1_level = npos(list)
		local _player1_zone = npos(list)
		local _player1_power = npos(list)
		local _player1_icon = npos(list)
		local _player1_quality = npos(list)
		
		local _player2_id = npos(list)
		local _player2_name = npos(list)
		local _player2_level = npos(list)
		local _player2_zone = npos(list)
		local _player2_power = npos(list)
		local _player2_icon = npos(list)
		local _player2_quality = npos(list)
		
		local _winner_zone = npos(list)
		local _winner_id = npos(list)
		
		local _supported_zone = npos(list)
		local _supported_id = npos(list)
		
		_ED.cross_battle_play_info[1+2*(i-1)] = {
			index = 1+2*((i-1)%4),
			id = _player1_id,
			icon_id = _player1_icon,
			name = _player1_name,
			level = _player1_level,
			power_num = _player1_power,
			zone_name = _player1_zone,
			quality = _player1_quality,
		}
		
		_ED.cross_battle_play_info[2+2*(i-1)] = {
			index = 2+2*((i-1)%4),
			id = _player2_id,
			icon_id = _player2_icon,
			name = _player2_name,
			level = _player2_level,
			power_num = _player2_power,
			zone_name = _player2_zone,
			quality = _player2_quality,
		}
		
		if _ED.cross_battle_match_group[math.floor((i-1)/4)+1] == nil then
			_ED.cross_battle_match_group[math.floor((i-1)/4)+1] = {}
		end
		_ED.cross_battle_match_group[math.floor((i-1)/4)+1][(i-1)%4+1] = {
			match_id = _match_id,
			winner_id = _winner_id,
			winner_zone = _winner_zone,
			player1_id = _player1_id,
			player1_zone = _player1_zone,
			player2_id = _player2_id,
			player2_zone = _player2_zone,
			supported_id = _supported_id,
			supported_zone = _supported_zone
		}
	end
	local size2 = zstring.tonumber(npos(list))
	for i=1, size2 do -- 8 pairs
		local _match_id = npos(list)
		
		local _player1_id = npos(list)
		local _player1_name = npos(list)
		local _player1_level = npos(list)
		local _player1_zone = npos(list)
		local _player1_power = npos(list)
		local _player1_icon = npos(list)
		local _player1_quality = npos(list)
		
		local _player2_id = npos(list)
		local _player2_name = npos(list)
		local _player2_level = npos(list)
		local _player2_zone = npos(list)
		local _player2_power = npos(list)
		local _player2_icon = npos(list)
		local _player2_quality = npos(list)
		
		local _winner_zone = npos(list)
		local _winner_id = npos(list)
		
		local _supported_zone = npos(list)
		local _supported_id = npos(list)
		
		if _ED.cross_battle_match_group[math.floor((i-1)/2)+1] == nil then
			_ED.cross_battle_match_group[math.floor((i-1)/2)+1] = {}
		end
		_ED.cross_battle_match_group[math.floor((i-1)/2)+1][(i-1)%2+5] = {
			match_id = _match_id,
			winner_id = _winner_id,
			winner_zone = _winner_zone,
			player1_id = _player1_id,
			player1_zone = _player1_zone,
			player2_id = _player2_id,
			player2_zone = _player2_zone,
			supported_id = _supported_id,
			supported_zone = _supported_zone
		}
	end
	local size3 = zstring.tonumber(npos(list))
	for i=1, size3 do -- 4 pairs
		local _match_id = npos(list)
		
		local _player1_id = npos(list)
		local _player1_name = npos(list)
		local _player1_level = npos(list)
		local _player1_zone = npos(list)
		local _player1_power = npos(list)
		local _player1_icon = npos(list)
		local _player1_quality = npos(list)
		
		local _player2_id = npos(list)
		local _player2_name = npos(list)
		local _player2_level = npos(list)
		local _player2_zone = npos(list)
		local _player2_power = npos(list)
		local _player2_icon = npos(list)
		local _player2_quality = npos(list)
		
		local _winner_zone = npos(list)
		local _winner_id = npos(list)
		
		local _supported_zone = npos(list)
		local _supported_id = npos(list)
		
		if _ED.cross_battle_match_group[i] == nil then
			_ED.cross_battle_match_group[i] = {}
		end	
		_ED.cross_battle_match_group[i][7] = {
			match_id = _match_id,
			winner_id = _winner_id,
			winner_zone = _winner_zone,
			player1_id = _player1_id,
			player1_zone = _player1_zone,
			player2_id = _player2_id,
			player2_zone = _player2_zone,
			supported_id = _supported_id,
			supported_zone = _supported_zone
		}
	end
	local size4 = zstring.tonumber(npos(list))
	for i=1, size4 do -- 2 pairs
		local _match_id = npos(list)
		
		local _player1_id = npos(list)
		local _player1_name = npos(list)
		local _player1_level = npos(list)
		local _player1_zone = npos(list)
		local _player1_power = npos(list)
		local _player1_icon = npos(list)
		local _player1_quality = npos(list)
		
		local _player2_id = npos(list)
		local _player2_name = npos(list)
		local _player2_level = npos(list)
		local _player2_zone = npos(list)
		local _player2_power = npos(list)
		local _player2_icon = npos(list)
		local _player2_quality = npos(list)
		
		local _winner_zone = npos(list)
		local _winner_id = npos(list)
		
		local _supported_zone = npos(list)
		local _supported_id = npos(list)
		
		_ED.cross_battle_play_info[1+2*(i-1)] = {
			index = 1+2*(i-1),
			id = _player1_id,
			icon_id = _player1_icon,
			name = _player1_name,
			level = _player1_level,
			power_num = _player1_power,
			zone_name = _player1_zone,
			quality = _player1_quality
		}
		
		_ED.cross_battle_play_info[2+2*(i-1)] = {
			index = 2+2*(i-1),
			id = _player2_id,
			icon_id = _player2_icon,
			name = _player2_name,
			level = _player2_level,
			power_num = _player2_power,
			zone_name = _player2_zone,
			quality = _player2_quality
		}
		
		if _ED.cross_battle_match_group[0] == nil then
			_ED.cross_battle_match_group[0] = {}
		end	
		_ED.cross_battle_match_group[0][i] = {
			match_id = _match_id,
			winner_id = _winner_id,
			winner_zone = _winner_zone,
			player1_id = _player1_id,
			player1_zone = _player1_zone,
			player2_id = _player2_id,
			player2_zone = _player2_zone,
			supported_id = _supported_id,
			supported_zone = _supported_zone
		}
	end
	local size5 = zstring.tonumber(npos(list))
	for i=1, size5 do -- 1 pairs
		local _match_id = npos(list)
		
		local _player1_id = npos(list)
		local _player1_name = npos(list)
		local _player1_level = npos(list)
		local _player1_zone = npos(list)
		local _player1_power = npos(list)
		local _player1_icon = npos(list)
		local _player1_quality = npos(list)
		
		local _player2_id = npos(list)
		local _player2_name = npos(list)
		local _player2_level = npos(list)
		local _player2_zone = npos(list)
		local _player2_power = npos(list)
		local _player2_icon = npos(list)
		local _player2_quality = npos(list)
		
		local _winner_zone = npos(list)
		local _winner_id = npos(list)
		
		local _supported_zone = npos(list)
		local _supported_id = npos(list)
		
		if _ED.cross_battle_match_group[0] == nil then
			_ED.cross_battle_match_group[0] = {}
		end	
		_ED.cross_battle_match_group[0][3] = {
			match_id = _match_id,
			winner_id = _winner_id,
			winner_zone = _winner_zone,
			player1_id = _player1_id,
			player1_zone = _player1_zone,
			player2_id = _player2_id,
			player2_zone = _player2_zone,
			supported_id = _supported_id,
			supported_zone = _supported_zone
		}
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_cross_server_self_info 316 --返回跨服争霸我的信息
-- ---------------------------------------------------------------------------------------------------------
function parse_cross_server_self_info(interpreter,datas,pos,strDatas,list,count)
	-- 主角历史品质
	_ED.cross_battle_myinfo.history_myquality = npos(list)
		
	-- 主角历史头像
	_ED.cross_battle_myinfo.history_myicon = npos(list)

	_ED.cross_battle_myinfo.reports = {}
	local sizeR = tonumber(npos(list))
	for i=1, sizeR do
		_ED.cross_battle_myinfo.reports[i] = {
			match_id = npos(list),
			match_progress = npos(list),
			round = npos(list),
			enemy_name = npos(list),
			enemy_server = npos(list),
			enemy_icon = npos(list),
			enemy_quality = npos(list),
			group = npos(list),
			score = npos(list),
			KO_state = npos(list)
		}
	end
	_ED.cross_battle_myinfo.supports = {}
	local sizeS = tonumber(npos(list))
	for i=1, sizeS do
		_ED.cross_battle_myinfo.supports[i] = {
			match_progress = npos(list),
			player_name = npos(list),
			player_server = npos(list),
			state = npos(list),
			state_param = npos(list)
		}
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_cross_server_fight_record_list 317 --返回跨服晋级赛战斗录像列表
-- ---------------------------------------------------------------------------------------------------------
function parse_cross_server_fight_record_list(interpreter,datas,pos,strDatas,list,count)
	_ED.cross_battle_record_list.match_score = npos(list)
	_ED.cross_battle_record_list.battle_info = {}
	local size = npos(list)
	for i=1, size do
		_ED.cross_battle_record_list.battle_info[i] = {
			match_id = npos(list),
			winner_zone = npos(list),
			winner_id = npos(list)
		}
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_cross_server_prostrate_init 318 --返回跨服膜拜冠军初始化信息
-- ---------------------------------------------------------------------------------------------------------
function parse_cross_server_prostrate_init(interpreter,datas,pos,strDatas,list,count)
	for i=1, 3 do
		_ED.cross_battle_worship_players[i] = {
			zone_name = npos(list),
			name = npos(list),
			power_num = npos(list),
			level = npos(list),
			icon_id = npos(list)
		}
	end	
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_arena_first_info 319 --返回竞技排行榜第一名信息
-- ---------------------------------------------------------------------------------------------------------
function parse_arena_first_info(interpreter,datas,pos,strDatas,list,count)
	_ED.arena_first_info = {
		id = npos(list),
		name = npos(list),
		gender = npos(list),
		icon = npos(list),
		eye =npos(list),   
		ear =npos(list),
		cap =npos(list),
		cloth =npos(list),
		glove =npos(list),
		weapon =npos(list),
		shoes =npos(list),
		wing =npos(list),
	}
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_return_update_talent 320 --返回刷新战船天赋
-- ---------------------------------------------------------------------------------------------------------
function parse_return_update_talent(interpreter,datas,pos,strDatas,list,count)
	local ship_id = npos(list)
	local talents_counts = npos(list)
	_ED.user_ship[ship_id].talent_count = talents_counts
	_ED.user_ship[ship_id].talents = {}
	for r = 1, tonumber(_ED.user_ship[ship_id].talent_count) do
		_ED.user_ship[ship_id].talents[r] = {
			talent_id = npos(list),		-- 天赋1id
			is_activited = npos(list),	-- 是否激活
		}
	end
end

-- -------------------------------------------------------------------------------------------------------
--   parse_return_turn_table_reward_info    323
-- -------------------------------------------------------------------------------------------------------
function parse_return_turn_table_reward_info(interpreter,datas,pos,strDatas,list,count)
	local reward_count = tonumber(npos(list))						 --信息数量
	for i = 1,reward_count do
		_ED.wonderful_turntable_reward_info[i] = npos(list)				 --信息内容
	end
	_ED.wonderful_turntable_reward_count = reward_count
end

-- -------------------------------------------------------------------------------------------------------
--   parse_secret_shopman_init    324
-- -------------------------------------------------------------------------------------------------------
function parse_secret_shopman_init(interpreter,datas,pos,strDatas,list,count)
	_ED.secret_shopPerson_pageIndex = tonumber(npos(list))				--页面状态
	_ED.secret_shopPerson_init_info.goods_info={}
	_ED.secret_shopPerson_init_info.count = tonumber(npos(list))					--商品数量
	for i=1,_ED.secret_shopPerson_init_info.count do
		local goods = {
			goods_id = npos(list),
			goods_type = npos(list),
			goods_mould_id = npos(list),
			sell_type = npos(list),
			sell_count = npos(list),
			remain_times = npos(list),
			sell_price = npos(list),
		}
		_ED.secret_shopPerson_init_info.goods_info[i] = goods
	end
	_ED.secret_shopPerson_init_info.refresh_time = tonumber(npos(list))			--剩余刷新时间
	_ED.secret_shopPerson_init_info.leave_time = tonumber(npos(list))			--商人离开时间
	_ED.secret_shopPerson_init_info.refresh_times = tonumber(npos(list))		--刷新次数
	_ED.secret_shopPerson_init_info.native_time = os.time()
end

-- -------------------------------------------------------------------------------------------------------
--   parse_secret_shopman_surprise    325
-- -------------------------------------------------------------------------------------------------------
function parse_secret_shopman_surprise(interpreter,datas,pos,strDatas,list,count)
	_ED.secret_shopPerson_prop_info.prop_count = tonumber(npos(list))		--商品数量
	_ED.secret_shopPerson_prop_info.prop_info = {}
	for i=1, _ED.secret_shopPerson_prop_info.prop_count do
		local goods = {
			goods_id = npos(list),
			goods_type = npos(list),
			goods_mould_id = npos(list),
			sell_type = npos(list),
			sell_count = npos(list),
			remain_times = npos(list),
			sell_price = npos(list),
		}
		_ED.secret_shopPerson_prop_info.prop_info[i] = goods
	end
end

-- -------------------------------------------------------------------------------------------------------
--   new_platform_user_registration_information    326返回新平台用户注册信息
-- -------------------------------------------------------------------------------------------------------
function new_platform_user_registration_information(interpreter,datas,pos,strDatas,list,count)
	m_sUin = npos(list)
	local platformloginInfo = {}
		platformloginInfo = {
			platform_id=m_sUserAccountPlatformName,				--平台id
			register_type="0", 				--注册类型
			platform_account=m_sUin,		--游戏账号
			nickname=m_sUserAccountPlatformName,					--注册昵称
			password="123456",					--注册密码
			is_registered = false
		}
		if m_sUserAccountPlatformName ~= "t4" then
			if (package_operator_name ~= nil and m_sUserAccountPlatformName == package_operator_name) then
			elseif (OperatorNameConfig ~= nil and OperatorNameConfig[app.configJson.OperatorName] == "t4") then
			else
				_ED.user_platform = {}
			end
		end
	if m_sUin ~= nil then
		local params = zstring.split(m_sUin, ",")
		if #params > 1 then
			_ED.default_user = params[1]
		else
			_ED.default_user = m_sUin
		end
		_ED.user_platform[_ED.default_user] = platformloginInfo
	end
end

-- -------------------------------------------------------------------------------------------------------
--   new_platform_user_login_information    327返回新平台用户登陆信息
-- -------------------------------------------------------------------------------------------------------
function new_platform_user_login_information(interpreter,datas,pos,strDatas,list,count)
	m_sUin = npos(list)

	-- 用户token
	userLoginToken = npos(list)

	-- 用户包名
	userLoginPackageName = npos(list)
	if userLoginPackageName == nil or userLoginPackageName == "" then
		if app.configJson.PackageName ~= nil and app.configJson.PackageName ~= "" then
			userLoginPackageName = app.configJson.PackageName
		end
	end

	-- 用户账号创建时间
	_ED.userAccountCreateTime = tonumber(npos(list))

	-- print("327返回新平台用户登陆信息 userLoginToken = ", userLoginToken, " userLoginPackageName = ", userLoginPackageName, " _ED.userAccountCreateTime = ", _ED.userAccountCreateTime)

	local platformloginInfo = {}
		platformloginInfo = {
			platform_id=m_sUserAccountPlatformName,				--平台id
			register_type="0", 				--注册类型
			platform_account=m_sUin,		--游戏账号
			nickname=m_sUserAccountPlatformName,					--注册昵称
			password="123456",					--注册密码
			is_registered = false
		}

		
		if m_sUserAccountPlatformName ~= "t4" then
			if (package_operator_name ~= nil and m_sUserAccountPlatformName == package_operator_name) then
			elseif (OperatorNameConfig ~= nil and OperatorNameConfig[app.configJson.OperatorName] == "t4") then
			else
				_ED.user_platform = {}
			end
		end
		
	if m_sUin ~= nil then
		local params = zstring.split(m_sUin, ",")
		if #params > 1 then
			_ED.default_user = params[1]
		else
			_ED.default_user = m_sUin
		end
		_ED.user_platform[_ED.default_user] = platformloginInfo
	end

	-- 服务器列表数据没有更新前，不能点击服务器列表
	state_machine.lock("login_select_server")
	state_machine.excute("login_get_server_list", 0, "login_get_server_list.")
end


-- -------------------------------------------------------------------------------------------------------
--   parse_guest_account_generate 478 --获取新创建的随机账号
-- -------------------------------------------------------------------------------------------------------
function parse_guest_account_generate(interpreter,datas,pos,strDatas,list,count)
	_ED.guest_account = npos(list)
end
-- -------------------------------------------------------------------------------------------------------
-- parse_vice_captain_init 329 --返回副队长初始化
-- -------------------------------------------------------------------------------------------------------
function parse_vice_captain_init(interpreter,datas,pos,strDatas,list,count)
	-- _ED.user_vices.max_num 在82号返回
	_ED.user_vices.bag = {}
	local vices_num = npos(list)
	_ED.user_vices.vices_num = vices_num
	for i=1, vices_num do
		local vice_id = npos(list)
		local vice_mould_id = npos(list)
		local position = tonumber(npos(list))
		local fight_state = npos(list)
		local power = npos(list)
		local level = npos(list)
		local current_exp = npos(list)
		local skill_point = npos(list)
		local attribute = npos(list)
		local special_skill_cd = npos(list)
		
		local life = 0
		local attack = 0
		local physical_defence = 0
		local skill_defence = 0
		
		if attribute ~= nil then
			local attribute_group = zstring.split(attribute, "|")
			
			for i, v in ipairs(attribute_group) do 
				local attribute_data = zstring.split(v, ",")
				if attribute_data[1] == "0" then
					life = attribute_data[2]
				elseif attribute_data[1] == "1" then
					attack = attribute_data[2]
				elseif attribute_data[1] == "2" then
					physical_defence = attribute_data[2]
				elseif attribute_data[1] == "3" then
					skill_defence = attribute_data[2]
				end
			end
		end
		
		_ED.user_vices.bag[vice_id] = {
			vice_id = vice_id,
			vice_mould_id = vice_mould_id,
			position = position,
			fight_state = fight_state,
			power = power,
			level = level,
			current_exp = current_exp,
			skill_point = skill_point,
			
			life = life,
			attack = attack,
			physical_defence = physical_defence,
			skill_defence = skill_defence,
			
			special_skill_cd = special_skill_cd,
			
			normal_skills = {},
			
			talents = {},
		}
		
		local max_skill_num = npos(list)
		for m=1, max_skill_num do
			local skill_id = npos(list)
			local skill_level = tonumber(npos(list))
			local skill_locked = npos(list)
			_ED.user_vices.bag[vice_id].normal_skills[m] = {
				skill_id = skill_id,
				skill_level = skill_level,
				skill_locked = skill_locked,
			}
		end
		
		local talent_num = npos(list)
		for n=1, talent_num do
			local talent_mould_id = npos(list)
			local actice_state = npos(list)
			_ED.user_vices.bag[vice_id].talents[n] = {
				id = talent_mould_id,
				isActive = actice_state,
			}
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vice_formation_state 330 --返回副队长阵容开启状态
-- -------------------------------------------------------------------------------------------------------
function parse_vice_formation_state(interpreter,datas,pos,strDatas,list,count)
	_ED.vices_formation_state = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vice_captain_get 331 --返回副队长获得
-- -------------------------------------------------------------------------------------------------------
function parse_vice_captain_get(interpreter,datas,pos,strDatas,list,count)
	local vice_id = npos(list)
	local vice_mould_id = npos(list)
	local position = tonumber(npos(list))
	local fight_state = npos(list)
	local power = npos(list)
	local level = npos(list)
	local current_exp = npos(list)
	local skill_point = npos(list)
	local attribute = npos(list)
	local special_skill_cd = npos(list)
	
	local life = 0
	local attack = 0
	local physical_defence = 0
	local skill_defence = 0
	
	local attribute_group = zstring.split(attribute, "|")
	
	if attribute ~= nil then
		for i, v in ipairs(attribute_group) do 
			local attribute_data = zstring.split(v, ",")
			if attribute_data[1] == "0" then
				life = attribute_data[2]
			elseif attribute_data[1] == "1" then
				attack = attribute_data[2]
			elseif attribute_data[1] == "2" then
				physical_defence = attribute_data[2]
			elseif attribute_data[1] == "3" then
				skill_defence = attribute_data[2]
			end
		end
	end
	
	_ED.user_vices.bag[vice_id] = {
		vice_id = vice_id,
		vice_mould_id = vice_mould_id,
		position = position,
		fight_state = fight_state,
		power = power,
		level = level,
		current_exp = current_exp,
		skill_point = skill_point,
		
		life = life,
		attack = attack,
		physical_defence = physical_defence,
		skill_defence = skill_defence,
		
		special_skill_cd = special_skill_cd,
		
		normal_skills = {},
		
		talents = {},
	}
	
	local max_skill_num = npos(list)
	for m=1, max_skill_num do
		local skill_id = npos(list)
		local skill_level = tonumber(npos(list))
		local skill_locked = npos(list)
		_ED.user_vices.bag[vice_id].normal_skills[m] = {
			skill_id = skill_id,
			skill_level = skill_level,
			skill_locked = skill_locked,
		}
	end
	
	local talent_num = npos(list)
	for n=1, talent_num do
		local talent_mould_id = npos(list)
		local actice_state = npos(list)
		_ED.user_vices.bag[vice_id].talents[n] = {
			id = talent_mould_id,
			isActive = actice_state,
		}
	end
	_ED.user_vices.vices_num = _ED.user_vices.vices_num + 1
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vice_captain_equip 332 --返回副队长上阵
-- -------------------------------------------------------------------------------------------------------
function parse_vice_captain_equip(interpreter,datas,pos,strDatas,list,count)
	local vice_id_on = npos(list)
	local position = tonumber(npos(list))
	local vice_id_off = npos(list)
	if _ED.user_vices.bag[vice_id_on] ~= nil then
		_ED.user_vices.bag[vice_id_on].position = position
	end
	if _ED.user_vices.bag[vice_id_off] ~= nil then
		_ED.user_vices.bag[vice_id_off].position = 0
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vice_captain_fight 333 --返回副队长出战
-- -------------------------------------------------------------------------------------------------------
function parse_vice_captain_fight(interpreter,datas,pos,strDatas,list,count)
	local vice_id_on = npos(list)
	local vice_id_off = npos(list)
	if _ED.user_vices.bag[vice_id_on] ~= nil then
		_ED.user_vices.bag[vice_id_on].fight_state = "1"
	end	
	if _ED.user_vices.bag[vice_id_off] ~= nil then
		_ED.user_vices.bag[vice_id_off].fight_state = "0"
	end	
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vice_captain_study 334 --返回副队长领悟技能
-- -------------------------------------------------------------------------------------------------------
function parse_vice_captain_study(interpreter,datas,pos,strDatas,list,count)
	local vice_id = npos(list)
	local study_state = npos(list) -- 领悟状态(0:失败,1:开启技能槽,2领悟新技能,3.技能提升)
	_ED.vices_study_state = study_state
	_ED.user_vices.bag[vice_id].skill_point = npos(list)
	if study_state == "0" then
		-- 失败
	elseif study_state == "1" then
		-- 开启技能槽
		for i, v in ipairs(_ED.user_vices.bag[vice_id].normal_skills) do
			if v.skill_id == "-1" then
				v.skill_id = "0"
				break
			end	
		end
	elseif study_state == "2" then
		-- 领悟新技能
		local skill_id = npos(list)
		_ED.vices_study_skill_id = skill_id
		for i, v in ipairs(_ED.user_vices.bag[vice_id].normal_skills) do
			if v.skill_id == "0" then
				v.skill_id = skill_id
				v.skill_level = 1
				v.skill_locked = "0"
				break
			end	
		end
		
		local attribute = npos(list)
		local attribute_group = zstring.split(attribute, "|")
		for i, v in ipairs(attribute_group) do 
			local attribute_data = zstring.split(v, ",")
			if attribute_data[1] == "0" then
				_ED.user_vices.bag[vice_id].life = attribute_data[2]
			elseif attribute_data[1] == "1" then
				_ED.user_vices.bag[vice_id].attack = attribute_data[2]
			elseif attribute_data[1] == "2" then
				_ED.user_vices.bag[vice_id].physical_defence = attribute_data[2]
			elseif attribute_data[1] == "3" then
				_ED.user_vices.bag[vice_id].skill_defence = attribute_data[2]
			end
		end
		
		local talent_num = npos(list)
		_ED.user_vices.bag[vice_id].talents = {}
		for n=1, zstring.tonumber(talent_num) do
			local talent_mould_id = npos(list)
			local actice_state = npos(list)
			_ED.user_vices.bag[vice_id].talents[n] = {
				id = talent_mould_id,
				isActive = actice_state,
			}
		end
	elseif study_state == "3" then
		-- 技能提升		
		local skill_id = npos(list)
		_ED.vices_study_skill_id = skill_id
		for i, v in ipairs(_ED.user_vices.bag[vice_id].normal_skills) do
			if v.skill_id == skill_id then
				v.skill_level = 1 + v.skill_level
				break
			end	
		end
		
		local attribute = npos(list)
		local attribute_group = zstring.split(attribute, "|")
		for i, v in ipairs(attribute_group) do 
			local attribute_data = zstring.split(v, ",")
			if attribute_data[1] == "0" then
				_ED.user_vices.bag[vice_id].life = attribute_data[2]
			elseif attribute_data[1] == "1" then
				_ED.user_vices.bag[vice_id].attack = attribute_data[2]
			elseif attribute_data[1] == "2" then
				_ED.user_vices.bag[vice_id].physical_defence = attribute_data[2]
			elseif attribute_data[1] == "3" then
				_ED.user_vices.bag[vice_id].skill_defence = attribute_data[2]
			end
		end
		
		local talent_num = npos(list)
		_ED.user_vices.bag[vice_id].talents = {}
		for n=1, talent_num do
			local talent_mould_id = npos(list)
			local actice_state = npos(list)
			_ED.user_vices.bag[vice_id].talents[n] = {
				id = talent_mould_id,
				isActive = actice_state,
			}
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vice_captain_feed 335 --返回副队长喂养
-- -------------------------------------------------------------------------------------------------------
function parse_vice_captain_feed(interpreter,datas,pos,strDatas,list,count)
	local vice_id = npos(list)
	_ED.vices_add_exp = npos(list)
	if _ED.user_vices.bag[vice_id] == nil then 
		return
	end
	_ED.user_vices.bag[vice_id].current_exp = npos(list)
	_ED.user_vices.bag[vice_id].level = npos(list)
	_ED.user_vices.bag[vice_id].skill_point = npos(list)
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vice_captain_lock 336 --返回副队长锁定技能
-- -------------------------------------------------------------------------------------------------------
function parse_vice_captain_lock(interpreter,datas,pos,strDatas,list,count)
	local vice_id = npos(list)
	if _ED.user_vices.bag[vice_id] == nil then 
		return
	end
	local skill_id = npos(list)
	for i, v in ipairs(_ED.user_vices.bag[vice_id].normal_skills) do
		if v.skill_id == skill_id then
			v.skill_locked = "1"
			break
		end	
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vice_captain_delete 337 --返回副队长删除
-- -------------------------------------------------------------------------------------------------------
function parse_vice_captain_delete(interpreter,datas,pos,strDatas,list,count)
	local vice_id = npos(list)
	_ED.user_vices.bag[vice_id] = nil
	_ED.user_vices.vices_num = _ED.user_vices.vices_num - 1
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vice_captain_update 338 --副队长刷新
-- -------------------------------------------------------------------------------------------------------
function parse_vice_captain_update(interpreter,datas,pos,strDatas,list,count)
	local vice_id = npos(list)
	local vice_mould_id = npos(list)
	local position = tonumber(npos(list))
	local fight_state = npos(list)
	local power = npos(list)
	local level = npos(list)
	local current_exp = npos(list)
	local skill_point = npos(list)
	local attribute = npos(list)
	local special_skill_cd = npos(list)
	
	local life = 0
	local attack = 0
	local physical_defence = 0
	local skill_defence = 0
	
	local attribute_group = zstring.split(attribute, "|")
	
	if attribute ~= nil then
		for i, v in ipairs(attribute_group) do 
			local attribute_data = zstring.split(v, ",")
			if attribute_data[1] == "0" then
				life = attribute_data[2]
			elseif attribute_data[1] == "1" then
				attack = attribute_data[2]
			elseif attribute_data[1] == "2" then
				physical_defence = attribute_data[2]
			elseif attribute_data[1] == "3" then
				skill_defence = attribute_data[2]
			end
		end
	end
	
	_ED.user_vices.bag[vice_id] = {
		vice_id = vice_id,
		vice_mould_id = vice_mould_id,
		position = position,
		fight_state = fight_state,
		power = power,
		level = level,
		current_exp = current_exp,
		skill_point = skill_point,
		
		life = life,
		attack = attack,
		physical_defence = physical_defence,
		skill_defence = skill_defence,
		
		special_skill_cd = special_skill_cd,
		
		normal_skills = {},
		
		talents = {},
	}
	
	local max_skill_num = npos(list)
	for m=1, max_skill_num do
		local skill_id = npos(list)
		local skill_level = tonumber(npos(list))
		local skill_locked = npos(list)
		_ED.user_vices.bag[vice_id].normal_skills[m] = {
			skill_id = skill_id,
			skill_level = skill_level,
			skill_locked = skill_locked,
		}
	end
	
	local talent_num = npos(list)
	for n=1, talent_num do
		local talent_mould_id = npos(list)
		local actice_state = npos(list)
		_ED.user_vices.bag[vice_id].talents[n] = {
			id = talent_mould_id,
			isActive = actice_state,
		}
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vice_captain_unlock 339 --副队长解锁技能
-- -------------------------------------------------------------------------------------------------------
function parse_vice_captain_unlock(interpreter,datas,pos,strDatas,list,count)
	local vice_id = npos(list)
	if _ED.user_vices.bag[vice_id] == nil then 
		return
	end
	local skill_id = npos(list)
	for i, v in ipairs(_ED.user_vices.bag[vice_id].normal_skills) do
		if v.skill_id == skill_id then
			v.skill_locked = "0"
			break
		end	
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vice_captain_talent 340 --副队长天赋激活状态
-- -------------------------------------------------------------------------------------------------------
function parse_vice_captain_talent(interpreter,datas,pos,strDatas,list,count)
	local vice_id = npos(list)
	local talent_num = npos(list)
	for n=1, talent_num do
		local talent_mould_id = npos(list)
		local actice_state = npos(list)
		_ED.user_vices.bag[vice_id].talents[n] = {
			id = talent_mould_id,
			isActive = actice_state,
		}
	end
	
	local attribute = npos(list)
	local attribute_group = zstring.split(attribute, "|")
	for i, v in ipairs(attribute_group) do 
		local attribute_data = zstring.split(v, ",")
		if attribute_data[1] == "0" then
			_ED.user_vices.bag[vice_id].life = attribute_data[2]
		elseif attribute_data[1] == "1" then
			_ED.user_vices.bag[vice_id].attack = attribute_data[2]
		elseif attribute_data[1] == "2" then
			_ED.user_vices.bag[vice_id].physical_defence = attribute_data[2]
		elseif attribute_data[1] == "3" then
			_ED.user_vices.bag[vice_id].skill_defence = attribute_data[2]
		end
	end
end

-- -------------------------------------------------------------------------------------------------------
-- parse_vice_captain_power 341 --副队长战力
-- -------------------------------------------------------------------------------------------------------
function parse_vice_captain_power(interpreter,datas,pos,strDatas,list,count)
	local vice_id = npos(list)
	local vice_power = npos(list)
	_ED.user_vices.bag[vice_id].power = vice_power
end

-- ---------------------------------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------------------------------
-- parse_activity_request_address 342 --活动服务器请求地址
-- -------------------------------------------------------------------------------------------------------
function parse_activity_request_address(interpreter,datas,pos,strDatas,list,count)
	_ED.activity_request_address = npos(list)
	_ED.game_request_address = npos(list)
end


-- -------------------------------------------------------------------------------------------------------
-- parse_three_kingdoms_init 343 --返回三国无双初始化信息
-- -------------------------------------------------------------------------------------------------------
function parse_three_kingdoms_init(interpreter,datas,pos,strDatas,list,count)
	_ED.three_kingdoms_view = {}
				 -- 	历史最高星数
			 	-- 当前的星数
			 	-- 本关卡获得的星数
			 	-- 属性加成参数
			 	-- 当前过关层数
			 	-- 当前状态（可攻打的层数）
			 	-- 奖励领取状态
	_ED.three_kingdoms_view.history_max_stars = npos(list)   		--历史最高星数
	_ED.three_kingdoms_view.current_max_stars = npos(list)			--当前的星数
	_ED.three_kingdoms_view.left_stars = npos(list) 				--本关卡获得的星数
	
	_ED.three_kingdoms_view.atrribute = {}

	local atrributeData = npos(list) -- “baoji,10|mingzhong,30|gongji,20”  --属性加成参数

	if atrributeData ~= nil and atrributeData ~= "" and atrributeData ~= " " then 
		local datas = zstring.split(atrributeData, "|") -- {"baoji,10","mingzhong,30","gongji,20"}
		for i, v in ipairs (datas) do
			local item = zstring.split(v, ",") -- {baoji, 10}
			local name = item[1]
			local value = item[2]
			local one_atrr = {name, value}
			table.insert(_ED.three_kingdoms_view.atrribute, one_atrr)
		end
	end
	
	_ED.three_kingdoms_view.current_floor = npos(list)    --当前过关层数
	_ED.three_kingdoms_view.current_npc_pos = npos(list)   	--当前状态（可攻打的层数）
	_ED.three_kingdoms_view.lost_stae = npos(list) --失败状态 -1 就是失败,其他的就算成功 -2已经通关   新数码是（奖励领取状态）

end

-- -------------------------------------------------------------------------------------------------------
-- parse_three_kingdoms_property 344 --返回三国无双随机属性信息
-- -------------------------------------------------------------------------------------------------------
function parse_three_kingdoms_property(interpreter,datas,pos,strDatas,list,count)
	local kingdoms_property = npos(list)
	if kingdoms_property ~= nil and kingdoms_property ~= "" and kingdoms_property ~= " " then
		local datas = zstring.split(kingdoms_property , ",")
		for i , v in ipairs (datas) do
			if i == 1 then 
				_ED.three_kingdoms_property.three_star = v
			elseif i == 2 then
				_ED.three_kingdoms_property.six_star = v
			elseif i == 3 then
				_ED.three_kingdoms_property.nine_star = v	
			end	
		end
	end
end	

-- ---------------------------------------------------------------------------------------------------------
-- parse_three_reset_times 345 --返回三国无双重置次数
-- ---------------------------------------------------------------------------------------------------------
function parse_three_reset_times(interpreter,datas,pos,strDatas,list,count)
	_ED.three_kingdoms_reset_times = npos(list)
	
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_dignified_shop_init 346 --返回三国商店初始化（346）
-- ---------------------------------------------------------------------------------------------------------
function parse_dignified_shop_init(interpreter,datas,pos,strDatas,list,count)
	_ED.dignified_shop_init = {}
	--npos(list)
	-- 数量
	-- Id 1 数量
	-- Id 2 数量
	_ED.dignified_shop_init.count = zstring.tonumber(npos(list))
	_ED.dignified_shop_init.goods = {}
	for i=1, _ED.dignified_shop_init.count do
		local id = npos(list)
		
		local num = npos(list)
		
		local item = {
			id = tonumber(id), --此处是表的索引id,非模板id
			num = tonumber(num),
		}
		table.insert(_ED.dignified_shop_init.goods, item)
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_three_npc_star 347 --返回三国难度星数
-- ---------------------------------------------------------------------------------------------------------
function parse_three_npc_star(interpreter,datas,pos,strDatas,list,count)
	_ED.three_kingdoms_view.npc_star = {}
	_ED.three_kingdoms_view.npc_star[1] = npos(list)
	_ED.three_kingdoms_view.npc_star[2] = npos(list)
	_ED.three_kingdoms_view.npc_star[3] = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_game_activity_times 348 --返回日常副本剩余次数
-- ---------------------------------------------------------------------------------------------------------
function parse_game_activity_times(interpreter,datas,pos,strDatas,list,count)
	_ED.game_activity_times = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_resolve_preview 349 --返回回收预览信息
-- ---------------------------------------------------------------------------------------------------------
function parse_resolve_preview(interpreter,datas,pos,strDatas,list,count)
	_ED.resolve_preview_info = {}
	_ED.resolve_preview_info.mould_type = npos(list)
	_ED.resolve_preview_info.res_info = {}
	local size = npos(list)
	for i=1, size do
		local mouldId = npos(list)
		local mould_type = tonumber(npos(list))
		local value = tonumber(npos(list))
		_ED.resolve_preview_info.res_info[i] = {mould_id = mouldId, mould_type = mould_type, value = value}
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_hero_train 350 --返回培养信息 
-- ---------------------------------------------------------------------------------------------------------
function parse_hero_train(interpreter,datas,pos,strDatas,list,count)
	local heroId = npos(list)
	_ED.hero_train_info[heroId] = {}
	_ED.hero_train_info[heroId].hero_id = heroId
	
	_ED.hero_train_info[heroId].hero_attribute = {}
	local size = npos(list)
	for i=1, size do
		local type = npos(list)
		local value = npos(list)
		local temp_value = npos(list)
		_ED.hero_train_info[heroId].hero_attribute[i] = {type, value, temp_value}
	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_hero_skillstren 351 --返回天命信息  
-- ---------------------------------------------------------------------------------------------------------
function parse_hero_skillstren(interpreter,datas,pos,strDatas,list,count)
	local heroId = npos(list)
	_ED.hero_skillstren_info.hero_id = heroId
	local level = npos(list)
	local value = npos(list)
	_ED.hero_skillstren_info.level = level
	_ED.hero_skillstren_info.value = value
	
	local usership = _ED.user_ship[heroId]
	usership.ship_skillstren.skill_level = level -- 天命等级 
	usership.ship_skillstren.skill_value = value -- 天命等级 
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_camps_recruit_type 352 --返回阵营招募类型   
-- ---------------------------------------------------------------------------------------------------------
function parse_camps_recruit_type(interpreter,datas,pos,strDatas,list,count)
	_ED.camps_recruit_type = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_manor_init 353 --返回领地初始化信息    
-- ---------------------------------------------------------------------------------------------------------
function parse_manor_init(interpreter,datas,pos,strDatas,list,count)
	
	_ED.manor_info = _ED.manor_info or {}
	
	local user_id = tonumber(npos(list))
	local user_name = tostring(npos(list))
	
	local city = {}
	
	local city_count = tonumber(npos(list))
	
	for i=1, city_count do
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_yugioh
			then 
			local info = {
				manor_id	= tonumber(npos(list)), 		--领地id
				manor_index_id 	= tonumber(npos(list)), 	--模板索引ID
				manor_status 	= tonumber(npos(list)), 	--状态(0锁定 1开启 2可巡逻 3巡逻中 4 可领奖 5暴动)
				surplus_times 	= tonumber(npos(list)), 	--巡逻剩余时间 
				ship_mould_id = tonumber(npos(list)),		-- 巡逻武将模板
				patrol_status = tonumber(npos(list)),		-- 巡逻状态  0 未开启双倍 1 已经开启双倍
			}
			city[i] = info
		else
			local info = {
				manor_id	= tonumber(npos(list)), 		--领地id
				manor_index_id 	= tonumber(npos(list)), 	--模板索引ID
				manor_status 	= tonumber(npos(list)), 	--状态(0锁定 1开启 2可巡逻 3巡逻中 4 可领奖 5暴动)
				surplus_times 	= tonumber(npos(list)), 	--巡逻剩余时间 
				ship_mould_id = tonumber(npos(list)),		-- 巡逻武将模板
			}
			city[i] = info
		end
	end
	
	-- 分自己和别人存两份
	if tonumber(_ED.user_info.user_id) == user_id then
		_ED.manor_info.player = {
			user_id = nil,
			user_name = nil,
			city_count = city_count,
			city = city
		}
	else
		_ED.manor_info.friend = {
			user_id = user_id,
			user_name = user_name,	
			city_count = city_count,
			city = city
		}
	end
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_betray_army_dispatch 354 --返回用户剩余征讨次数   
-- ---------------------------------------------------------------------------------------------------------
function parse_betray_army_dispatch(interpreter,datas,pos,strDatas,list,count)
	_ED.user_info.dispatch_token = npos(list)
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_betray_army_return 355 --返回用户叛军信息   
-- ---------------------------------------------------------------------------------------------------------
function parse_betray_army_information(interpreter,datas,pos,strDatas,list,count)
	_ED.betray_army_information.is_exploit = npos(list)			--是否功勋加倍(0否 1是)	
	_ED.betray_army_information.is_consume = npos(list)			--是否消耗减半(0否 1是)	
	_ED.betray_army_information.army_count = npos(list)			--叛军数量	
	_ED.betray_army_information.betray_army_info = {}
	
	local shareState = 1
	
	local is2007 = false
	if __lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh
		or __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if dev_version >= 2007 then
			is2007 = true
		end
	end
	
	for i = 1,_ED.betray_army_information.army_count do
		local betrayInfo = {
			betray_army_example = npos(list),	--实例 
			betray_army_id = npos(list),		--叛军模板 
			belong_to_id = npos(list),			--所属用户 
			friend_name = npos(list),			--用户昵称 
			stop_time = npos(list),				--停留时间
			all_hp = npos(list),					--总血量
			surplus_hp = npos(list),				--剩余血量
			betray_level = npos(list),			--等级
			share_state = is2007 and npos(list) or shareState,	--分享状态(0否 1是)
		}
		_ED.betray_army_information.betray_army_info[i] = betrayInfo
	end
	_ED.betray_army_information.army_time = os.time()
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_exploit_second_information 356 --返回用户功勋信息   
-- ---------------------------------------------------------------------------------------------------------
function parse_exploit_second_information(interpreter,datas,pos,strDatas,list,count)
	if __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_gragon_tiger_gate 
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then 
		_ED.exploit_second_information.dayAccumulate = npos(list)			--我的功勋排名 --累计功勋
		_ED.exploit_second_information.oneHurt = npos(list)				--单次伤害排名 --最高伤害
		_ED.exploit_second_information.myExploit = npos(list)		--今日功勋累计--战功
		_ED.exploit_second_information.featsRank = npos(list)			--功勋排名
		_ED.exploit_second_information.hurtRank = npos(list)			--伤害排名
			
	else
		_ED.exploit_second_information.myExploit = npos(list)			--我的功勋排名
		_ED.exploit_second_information.oneHurt = npos(list)				--单次伤害排名
		_ED.exploit_second_information.dayAccumulate = npos(list)		--今日功勋累计
	end
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_manor_friend_info 357 --返回领地好友信息   
-- ---------------------------------------------------------------------------------------------------------
function parse_manor_friend_info(interpreter,datas,pos,strDatas,list,count)
	_ED.manor_friend_num = npos(list)
	_ED.manor_friend_info = {}
	for i = 1, tonumber(_ED.manor_friend_num) do
		local friend_info = {
			uid = zstring.tonumber(npos(list)),
			quality = zstring.tonumber(npos(list)),
			head_picIndex = zstring.tonumber(npos(list)),
			name = npos(list),
			level = npos(list),
			offline = zstring.tonumber(npos(list)),
			have_city = npos(list),
			patrol_city = npos(list),
			riot_city = npos(list),
		}
		_ED.manor_friend_info[i] = friend_info
	end
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_now_exploit 358 --返回用户战功   
-- ---------------------------------------------------------------------------------------------------------
function parse_now_exploit(interpreter,datas,pos,strDatas,list,count)
	_ED.user_info.exploit = zstring.tonumber(npos(list)) -- 用户当前战功
	if _ED.exploit_second_information ~= nil then
		_ED.exploit_second_information.myExploit = _ED.user_info.exploit
	end
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_manor_repress_riot 359 --返回领地镇压暴乱 
-- ---------------------------------------------------------------------------------------------------------
function parse_manor_repress_riot(interpreter,datas,pos,strDatas,list,count)
	--_ED.manor_repress_riot_num = npos(list)
	_ED.manor_repress_riot_info = {}
	
	--for i = 1, tonumber(_ED.manor_repress_riot_num) do
	
		local item = {}
		for j = 1, 5 do
			item[j] = npos(list)
		end

		_ED.manor_repress_riot_info = item
	--end
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_return_rebel_army 360 --返回功勋奖励信息   
-- ---------------------------------------------------------------------------------------------------------
function parse_return_rebel_army(interpreter,datas,pos,strDatas,list,count)
	_ED.return_rebel_army_awardInfo.return_rebel_army = npos(list)
	_ED.return_rebel_army_awardInfo.award_info = {}
	for i =1 ,tonumber(_ED.return_rebel_army_awardInfo.return_rebel_army) do
		local awardInfo = {
			award_id = zstring.tonumber(npos(list)),	--id 
			award_state = zstring.tonumber(npos(list)),		--奖励状态
		}
		_ED.return_rebel_army_awardInfo.award_info[i] = awardInfo
	end
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_daily_mission_init 361 --返日常任务初始化
-- ---------------------------------------------------------------------------------------------------------
function parse_daily_mission_init(interpreter,datas,pos,strDatas,list,count)
	_ED.daily_task_integral = zstring.tonumber(npos(list))
	_ED.daily_task_draw_index = zstring.split(npos(list), ",")
	local newNumber = zstring.tonumber(npos(list))
	if _ED.user_reset_is ~= nil and _ED.user_reset_is ~= "" and _ED.user_reset_is ~= false then
		_ED.daily_task_info = {}
		for i = 1, newNumber do
			local task_mould = {
				daily_task_id=npos(list),						--日常任务ID
				daily_task_mould_id=npos(list),			--日常任务模板ID
				daily_task_complete_count=npos(list),	--日常任务完成次数
				daily_task_param=npos(list),				--日常任务状态
			}
			table.insert(_ED.daily_task_info, task_mould)
		end
		_ED.user_reset_is = false
	else
		for i = 1, newNumber do
			local task_mould = {
				daily_task_id=npos(list),						--日常任务ID
				daily_task_mould_id=npos(list),			--日常任务模板ID
				daily_task_complete_count=npos(list),	--日常任务完成次数
				daily_task_param=npos(list),				--日常任务状态
			}
			local isFind = false
			for i,v in pairs(_ED.daily_task_info) do
				if v.daily_task_id == task_mould.daily_task_id then
					_ED.daily_task_info[i] = task_mould
					isFind = true
				end
			end
			if isFind == false then
				table.insert(_ED.daily_task_info, task_mould)
			end
		end
	end
	
	_ED.daily_task_number = #_ED.daily_task_info
	-- _ED.daily_task_info={}
	-- for i = 1, _ED.daily_task_number do
	-- 	local task_mould = {
	-- 		daily_task_id=npos(list),						--日常任务ID
	-- 		daily_task_mould_id=npos(list),			--日常任务模板ID
	-- 		daily_task_complete_count=npos(list),	--日常任务完成次数
	-- 		daily_task_param=npos(list),				--日常任务状态
	-- 	}
	-- 	table.insert(_ED.daily_task_info, task_mould)
	-- end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("daily_task_update_daily_list", 0, nil)
		state_machine.excute("sm_activity_active_window_update", 0, nil)
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity")
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_daily_activity_daily_page_button")
		state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 10000)
	end
end
-- ---------------------------------------------------------------------------------------------------------


-- ---------------------------------------------------------------------------------------------------------
-- parse_rebel_exploit_shop 362 --返回战功商店初始化   
-- ---------------------------------------------------------------------------------------------------------
function parse_rebel_exploit_shop(interpreter,datas,pos,strDatas,list,count)
	_ED.rebel_exploit_shop.count = npos(list)
	_ED.rebel_exploit_shop.shop_info = {}
	for i =1 ,tonumber(_ED.rebel_exploit_shop.count) do
		local commodityInfo = {
			commodity_id = npos(list),	--id 
			commodity_state = tonumber(npos(list)),		--已兑换次数
		}
		_ED.rebel_exploit_shop.shop_info[i] = commodityInfo
	end
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_celebrity_bulletin_init 363 --返回名人堂初始化   
-- ---------------------------------------------------------------------------------------------------------
function parse_celebrity_bulletin_init(interpreter,datas,pos,strDatas,list,count)
	_ED.celebrity_num = npos(list)
	for i = 1, tonumber(_ED.celebrity_num) do
		local celebrity_info = {
			user_id = npos(list),
			user_name = npos(list),
			user_fighting = npos(list),
			user_ranking = npos(list),
			user_level = npos(list),
			user_star_num = npos(list),
			user_message = zstring.exchangeFrom(npos(list)),
			pic_index = npos(list),
		}
		_ED.celebrity_info[i] = celebrity_info
	end
end
-- ---------------------------------------------------------------------------------------------------------


-- ---------------------------------------------------------------------------------------------------------
-- parse_return_black_user 364 --返回黑名单信息   
-- ---------------------------------------------------------------------------------------------------------
function parse_return_black_user(interpreter,datas,pos,strDatas,list,count)
	-- 用户Id	VIP等级 战船模板 称号 昵称 等级 战力 所属军团 离线时间
	_ED.black_user_num = npos(list)
	for i=1, tonumber(_ED.black_user_num) do
		if (__lua_project_id == __lua_project_warship_girl_a 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh)
			and ___is_open_fashion == true
			 then
			local black_users = {
				user_id = npos(list),
				vip_grade = npos(list),
				lead_mould_id = npos(list),
				title = npos(list),
				name = npos(list),
				grade = npos(list),
				fighting  = npos(list),
				army = npos(list),
				leave_time = npos(list),
				fashion_pic = npos(list),
			}
			_ED.black_user[i] = black_users
		elseif __lua_project_id == __lua_project_red_alert_time 
			or __lua_project_id == __lua_project_pacific_rim 
			then 
			local black_users = {
				user_id = npos(list),		--屏蔽id
				shield_user_id = npos(list),--用户
				vip_grade = npos(list),		--vip等级
				head_pic = npos(list),		--头像
				lead_mould_id = npos(list),	--废弃
				title = npos(list),			--废弃
				name = npos(list),			--昵称
				grade = npos(list),			--等级
				fighting  = npos(list),		--战力
				army = npos(list),			--军团
				leave_time = npos(list),	--最后登录时间
			}
			_ED.black_user[i] = black_users
		elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
			or __lua_project_id == __lua_project_l_naruto
			then
			local black_users = {
				user_id = npos(list),
				vip_grade = npos(list),
				lead_mould_id = npos(list),
				title = npos(list),
				name = npos(list),
				grade = npos(list),
				fighting  = npos(list),
				army = npos(list),
				leave_time = npos(list),
			}
			black_users.shield_user_id = black_users.user_id
			
			-- 新增头像框功能
			if true then
				black_users.headFrameID = zstring.tonumber(npos(list))
				black_users.headFrameStage = zstring.tonumber(npos(list))
			end
			_ED.black_user[i] = black_users
		else
			local black_users = {
				user_id = npos(list),
				vip_grade = npos(list),
				lead_mould_id = npos(list),
				title = npos(list),
				name = npos(list),
				grade = npos(list),
				fighting  = npos(list),
				army = npos(list),
				leave_time = npos(list),
			}
			_ED.black_user[i] = black_users
		end
	end
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_celebrity_bulletin_add 365 --返回名人堂点赞增加
-- ---------------------------------------------------------------------------------------------------------
function parse_celebrity_bulletin_add(interpreter,datas,pos,strDatas,list,count)
	_ED.celebrity_star_add_num = npos(list)
	_ED.celebrity_star_add_all_num = npos(list)
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_celebrity_bulletin_lessen 366 --返回名人点赞减少  
-- ---------------------------------------------------------------------------------------------------------
function parse_celebrity_bulletin_lessen(interpreter,datas,pos,strDatas,list,count)
	_ED.celebrity_star_lessen_all_num = npos(list)
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_daily_task_achievement 367 --返回成就
-- ---------------------------------------------------------------------------------------------------------
function parse_daily_task_achievement(interpreter,datas,pos,strDatas,list,count)
	local nCount = zstring.tonumber(npos(list))
	_ED.daily_task_achievement = {}
	for i = 1, nCount do
		local achievement_instance = {
			daily_task_mould_id=npos(list),			 --成就模板ID
			daily_task_complete_count=npos(list),	--成就完成次数
			daily_task_param=npos(list),				--成就的领取状态
		}
		table.insert(_ED.daily_task_achievement, achievement_instance)
	end
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_sesrver_fund_activity_buy_count 368 --返返回开服基金活动的购买人数
-- ---------------------------------------------------------------------------------------------------------
function parse_sesrver_fund_activity_buy_count(interpreter,datas,pos,strDatas,list,count)
	local nCount = npos(list)
	local activity = _ED.active_activity[41]
	if activity ~= nil then
		activity.activity_buy_count = nCount
	end
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_week_active_init 369 --返回七日活动初始化
-- ---------------------------------------------------------------------------------------------------------
function parse_week_active_init(interpreter,datas,pos,strDatas,list,count)
	local activity = _ED.active_activity[42]
	if nil == activity then
		activity = {}
	end
	local dayCount = zstring.tonumber(npos(list))
	for d = 1, dayCount do
		activity.seven_days_rewards = activity.seven_days_rewards or {}
		local days_rewards = {}
		local dayIndex = zstring.tonumber(npos(list))
		activity.seven_days_rewards[dayIndex] = days_rewards
		local welfareCount = zstring.tonumber(npos(list))

		days_rewards.welfare = {}
		for i = 1, welfareCount do
			local _reward = {
				id = npos(list),
				state = npos(list)
			}
			days_rewards.welfare[i] = _reward
		end

		days_rewards.achievement_pages = {} 
		local pageCount = zstring.tonumber(npos(list))
		for i = 1, pageCount do
			local _achievement_page = {}
			days_rewards.achievement_pages[i] = _achievement_page
			_achievement_page.page_name = npos(list)
			_achievement_page.reward_count = zstring.tonumber(npos(list))
			_achievement_page._achievement_rewards = {}
			for j = 1, _achievement_page.reward_count do
				_achievement_page._achievement_rewards[j] = {
					id = npos(list),
					state= npos(list),
					complete_count = npos(list)
				}
			end
		end
		days_rewards.half_prop_buy_count = npos(list)
		days_rewards.half_prop_buy_state = npos(list)
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		state_machine.excute("notification_center_update", 0, "push_notification_center_activity_main_page_seven_days_activity")
		state_machine.excute("notification_center_update", 0, "push_notification_activity_everydays_all_target")
		state_machine.excute("notification_center_update", 0, "push_notification_activity_everydays_page_push")
		state_machine.excute("notification_center_update", 0, "push_notification_new_everydays_recharge")
        state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 42)

	end
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_manor_patrol_in 371 --   
-- ---------------------------------------------------------------------------------------------------------
function parse_manor_patrol_in(interpreter,datas,pos,strDatas,list,count)
	_ED.manor_patrol_income_type = npos(list)
	_ED.manor_patrol_hero_id = npos(list)
	_ED.manor_patrol_end_time = tonumber(npos(list)) / 1000
	_ED.manor_patrol_info_number = npos(list)
	for i=1 ,tonumber(_ED.manor_patrol_info_number) do
		local item = {}
		for j = 1, 5 do
			item[j] = npos(list)
		end
		_ED.manor_patrol_info_describe[i] = item
	end
	--> print("_ED.manor_patrol_end_time",_ED.manor_patrol_end_time)
	_ED.manor_patrol_reward = npos(list)
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_rebel_army_trigger 372 --  返回叛军触发 
-- ---------------------------------------------------------------------------------------------------------
function parse_rebel_army_trigger(interpreter,datas,pos,strDatas,list,count)
	_ED.rebel_army_mould_id = npos(list)	--模板ID
	_ED.rebel_aram_level = npos(list)		--等级
end


-- ---------------------------------------------------------------------------------------------------------
-- parse_scene_chest_draw_npc 373 --   
-- ---------------------------------------------------------------------------------------------------------
function parse_scene_chest_draw_npc(interpreter,datas,pos,strDatas,list,count)
	_ED.scene_draw_chest_npcs = {}
	local tempNpsIdList = zstring.split(npos(list), ",")
	for i, v in pairs(tempNpsIdList) do
		_ED.scene_draw_chest_npcs[v] = 1
	end
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_update_scene_chest_draw_npc 374 --   
-- ---------------------------------------------------------------------------------------------------------
function parse_update_scene_chest_draw_npc(interpreter,datas,pos,strDatas,list,count)
	local drawNpcId = npos(list)
	_ED.scene_draw_chest_npcs[drawNpcId] = 1
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------




-- ---------------------------------------------------------------------------------------------------------
-- parse_return_user_info 377 --   
-- ---------------------------------------------------------------------------------------------------------
function parse_return_user_info(interpreter,datas,pos,strDatas,list,count)
	if (__lua_project_id == __lua_project_warship_girl_a 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_digimon_adventure 
		or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh)
		and ___is_open_fashion == true
		 then
		_ED.chat_user_info = {
			user_id = npos(list),
			vip_grade = npos(list),
			lead_mould_id = npos(list),
			title = npos(list),
			name = npos(list),
			grade = npos(list),
			fighting  = npos(list),
			army = npos(list),
			is_friend = npos(list),
			user_fashion_pic = npos(list),  -- 穿上时装PIC
		}
	elseif __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		_ED.chat_user_info = {
			user_id = npos(list),
			vip_grade = npos(list),
			lead_mould_id = npos(list),
			title = npos(list),
			name = npos(list),
			grade = npos(list),
			fighting  = npos(list),
			army = npos(list),
			formation = npos(list),
			signature = npos(list),
			is_friend = npos(list),
			speed = npos(list),
		}
		-- 新增头像框功能
		if true then
			_ED.chat_user_info.headFrameID = zstring.tonumber(npos(list))
			_ED.chat_user_info.headFrameStage = zstring.tonumber(npos(list))
		end
		-- 详情界面新增显示内容
		if true then
			_ED.chat_user_info.imageID = zstring.tonumber(npos(list))
			_ED.chat_user_info.titleID = zstring.tonumber(npos(list))
			_ED.chat_user_info.isBlock = zstring.tonumber(npos(list))
		end
	else
		_ED.chat_user_info = {
			user_id = npos(list),
			vip_grade = npos(list),
			lead_mould_id = npos(list),
			title = npos(list),
			name = npos(list),
			grade = npos(list),
			fighting  = npos(list),
			army = npos(list),
			is_friend = npos(list),
		}
	end
	
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_search_friend_apply 378 --   
-- ---------------------------------------------------------------------------------------------------------
function parse_search_friend_apply(interpreter,datas,pos,strDatas,list,count)
	-- 玩家Id	VIP等级 战船模板 称号 昵称 等级 战力 所属军团 离线时间
	_ED.request_user = {}
	_ED.request_user_num = npos(list)
	for i =1, tonumber(_ED.request_user_num) do
		if (__lua_project_id == __lua_project_warship_girl_a 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh)
			and ___is_open_fashion == true
			 then
			 local info = {
				user_id = npos(list),
				vip_grade = npos(list),
				lead_mould_id = npos(list),
				title = npos(list),
				name = npos(list),
				grade = npos(list),
				fighting  = npos(list),
				army = npos(list),
				leave_time = npos(list),
				fashion_pic = npos(list),
			}
			_ED.request_user[i] =  info
		else
			 local info = {
				user_id = npos(list),
				vip_grade = npos(list),
				lead_mould_id = npos(list),
				title = npos(list),
				name = npos(list),
				grade = npos(list),
				fighting  = npos(list),
				army = npos(list),
				leave_time = tonumber(npos(list))/1000,
				begin_time = os.time(),
			}
			-- 新增头像框功能
			if true then
				info.headFrameID = zstring.tonumber(npos(list))
				info.headFrameStage = zstring.tonumber(npos(list))
			end
			_ED.request_user[i] =  info
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
		or __lua_project_id == __lua_project_l_naruto
		then
		state_machine.excute("notification_center_update", 0, "push_notification_center_friend_all")
		state_machine.excute("notification_center_update", 0, "push_notification_center_friend_apply")
	end
end
-- ---------------------------------------------------------------------------------------------------------


-- ---------------------------------------------------------------------------------------------------------
-- parse_search_hero_is_have 379
-- ---------------------------------------------------------------------------------------------------------
function parse_search_hero_is_have(interpreter,datas,pos,strDatas,list,count)
	_ED.catalogue_hero_is_have = npos(list)
	local data = zstring.split(_ED.catalogue_hero_is_have, ",")
	_ED._legendNumber = table.getn(data)-1
end
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------
-- parse_manor_limit_times 385 --返回领地用户已经镇压次数   
-- ---------------------------------------------------------------------------------------------------------
function parse_manor_limit_times(interpreter,datas,pos,strDatas,list,count)
	_ED.parse_manor_last_patrol_status = npos(list)
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_arena_attack_count 386 --返回竞技场攻击次数
-- ---------------------------------------------------------------------------------------------------------
function parse_arena_attack_count(interpreter,datas,pos,strDatas,list,count)
	_ED.arena_module.battle_count = zstring.tonumber(npos(list))
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_manor_limit_times 387 --返回抢夺次数
-- ---------------------------------------------------------------------------------------------------------
function parse_plunder_attack_count(interpreter,datas,pos,strDatas,list,count)
	_ED.plunder_module.battle_count = zstring.tonumber(npos(list))
end

-- ---------------------------------------------------------------------------------------------------------
-- parse_return_tencent_account_balance 388 --返回腾讯账户余额(388)
-- ---------------------------------------------------------------------------------------------------------
function parse_return_tencent_account_balance(interpreter,datas,pos,strDatas,list,count)
	local error_code = zstring.tonumber(npos(list))
	if error_code>0 then
		local error_tip = npos(list)
	elseif error_code==0 then
		local moneyNumber = zstring.tonumber(npos(list))
		if moneyNumber > 0 then
			m_tx_pay_over = true
		end
	end
end


protocol_parse = {
	{ code = -493, 	parser = "parse_login_of_other", 										parser_fun=parse_login_of_other										},		--返回账号别处已登录
	{ code = -16, 	parser = "parse_lack_of_diamond", 										parser_fun=parse_lack_of_diamond									},		--返回钻石不足
	{ code = -243, 	parser = "parse_cannot_login", 											parser_fun=parse_cannot_login										},		--返回账号封停
	{ code = 0, 	parser = "parse_cmd_command", 											parser_fun=parse_cmd_command										},		--返回空命令
	{ code = 1, 	parser = "parse_get_version", 											parser_fun=parse_get_version										},		--返回版本信息
	{ code = 2, 	parser = "parse_register", 												parser_fun=parse_register											},		--返回用户id号
	{ code = 3, 	parser = "parse_login_init", 											parser_fun=parse_login_init											},		--返回用户登陆信息
	{ code = 9, 	parser = "parse_boatyard_recruit", 										parser_fun=parse_boatyard_recruit									},		--返回用户船坞招募信息
	{ code = 12, 	parser = "parse_shop_view",												parser_fun=parse_shop_view											},		--返回用户商店浏览信息
	{ code = 15, 	parser = "parse_equipment_adorn",  										parser_fun=parse_equipment_adorn									},		--返回用户装备佩戴信息
	{ code = 20, 	parser = "parse_equipment_escalate",  									parser_fun=parse_equipment_escalate									},
	{ code = 22, 	parser = "parse_return_user_sliver",  									parser_fun=parse_return_user_sliver									},		--增加用户银币信息
	{ code = 25, 	parser = "parse_add_gold",  											parser_fun=parse_add_gold											},		--增加用户金币信息
	{ code = 26, 	parser = "parse_reduce_gold",  											parser_fun=parse_reduce_gold										},		--减少用户金币信息
	{ code = 27, 	parser = "parse_add_silver",  											parser_fun=parse_add_silver											},		--增加用户银币信息
	{ code = 28, 	parser = "parse_reduce_silver",  										parser_fun=parse_reduce_silver										},		--减少用户银币信息
	{ code = 29,	parser = "parse_add_food"	,											parser_fun=parse_add_food											},		--增加用户干粮信息
	{ code = 30, 	parser = "parse_reduce_food",  											parser_fun=parse_reduce_food										},		--减少用户体力信息
	{ code = 31,	parser = "parse_add_user_honour",										parser_fun=parse_add_user_honour									},		--增加用户声望信息
	{ code = 32, 	parser = "parse_user_prop_add",  										parser_fun=parse_user_prop_add										},		--用户道具增加信息
	{ code = 33, 	parser = "parse_user_equip_add",  										parser_fun=parse_user_equip_add										},		--用户装备增加信息
	{ code = 36, 	parser = "parse_user_state_change",  									parser_fun=parse_user_state_change									},		--NPC状态变更信息
	{ code = 37, 	parser = "parse_reduce_prop",  											parser_fun=parse_reduce_prop										},		--减少道具
	{ code = 38, 	parser = "parse_reduce_equip",  										parser_fun=parse_reduce_equip										},		--减少装备
	{ code = 39, 	parser = "parse_environment_fight", 									parser_fun=parse_environment_fight									},		--战斗信息
	{ code = 40, 	parser = "parse_user_level_up", 										parser_fun=parse_user_level_up										},		--用户升级
	{ code = 41, 	parser = "parse_user_update_exp", 										parser_fun=parse_user_update_exp									},		--用户经验更新
	{ code = 44, 	parser = "parse_user_ship_info_change", 								parser_fun=parse_user_ship_info_change								},		--战船信息变更信息
	{ code = 45,	parser = "parse_return_arena_init",										parser_fun=parse_return_arena_init									},		--竞技场初始化
	{ code = 47,	parser = "parse_return_equip_refine",									parser_fun=parse_return_equip_refine								},		--装备精炼
	{ code = 51, 	parser = "parse_get_random_name",  										parser_fun=parse_get_random_name									},		--返回随机名称
	{ code = 52, 	parser = "parse_return_sweep_info",  									parser_fun=parse_return_sweep_info									},		--返回扫荡返回值
	{ code = 53, 	parser = "parse_open_function",  										parser_fun=parse_open_function										},		--开启功能
	{ code = 54,	parser = "parse_gm_message_init",										parser_fun=parse_gm_message_init									},		--GM消息初始面板
	{ code = 56,	parser = "parse_formation_change",  									parser_fun=parse_formation_change									},		--阵型变更结果
	{ code = 57, 	parser = "parse_vali_register",  										parser_fun=parse_vali_register										},		--注册验证结果
	{ code = 58, 	parser = "parse_get_server_list",  										parser_fun=parse_get_server_list									},		--获取服务器地址列表结果
	{ code = 59, 	parser = "parse_rechange_get_list",  									parser_fun=parse_rechange_get_list									},		--获取充值订单号结果
	{ code = 60, 	parser = "parse_vali_top_up_order",  									parser_fun=parse_vali_top_up_order									},		--查询充值订单编号
	{ code = 61,	parser = "parse_red_jewel_change",										parser_fun=parse_red_jewel_change									},		--红宝石（游戏币）数量变更
	{ code = 62,	parser = "parse_return_arena_order",									parser_fun=parse_return_arena_order									},		--竞技场英雄榜
	{ code = 63,	parser = "parse_look_at_user_fleet",									parser_fun=parse_look_at_user_fleet									},		--查询用户舰队信息
	{ code = 66,	parser = "parse_sports_field_reward",									parser_fun=parse_sports_field_reward								},		--竞技场奖励信息
	{ code = 67,	parser = "parse_return_random_user_list",								parser_fun=parse_return_random_user_list							},		--获取用户查找信息
	{ code = 68,	parser = "parse_friend_request_info",									parser_fun=parse_friend_request_info								},		--好友请求信息
	{ code = 69,	parser = "parse_return_friend_list",									parser_fun=parse_return_friend_list									},		--返回玩家好友列表
	{ code = 70,	parser = "parse_power_init",											parser_fun=parse_power_init											},		--霸气初始化
	{ code = 71,	parser = "parse_power_make",									    	parser_fun=parse_power_make											},		--返回霸气初始化
	{ code = 73,    parser = "parse_power_swallow",											parser_fun=parse_power_swallow										},		--霸气吞噬	
	{ code = 74,	parser = "parse_power_equip",											parser_fun=parse_power_equip										},		--霸气装备
	{ code = 75,	parser = "parse_power_exchange",										parser_fun=parse_power_exchange										},      --霸气的兑换
	{ code = 81,	parser = "parse_user_train_cont",										parser_fun=parse_user_train_cont									},		--用户训练位计数
	{ code = 82,	parser = "parse_package_opende_cont",									parser_fun=parse_package_opende_cont								},		--用户包裹已开数量(82)
	{ code = 84,	parser = "parse_patch_change",											parser_fun=parse_patch_change										},		--用户碎片改变(84)
	{ code = 85,	parser = "parse_active_activity",										parser_fun=parse_active_activity									},		-- 用户可参与活动85
	{ code = 86,	parser = "parse_package_toplimit_cue",									parser_fun=parse_package_toplimit_cue								},		--包裹上限提示(86)
	{ code = 88,	parser = "parse_award_honour",											parser_fun=parse_award_honour										},		--奖励用户声望(88)
	{ code = 89, 	parser = "parse_viatual_username", 										parser_fun=parse_viatual_username									},		--101个虚拟用户名
	{ code = 90,	parser = "parse_accept_chat_information",								parser_fun=parse_accept_chat_information							},		--接收聊天信息（90
	{ code = 91,	parser = "parse_vip_level_change",										parser_fun=parse_vip_level_change									},		--用户vip等级改变（91）
	{ code = 92,	parser = "parse_vip_draw_state",										parser_fun=parse_vip_draw_state										},		--每日vip奖励领取状态（92）
	{ code = 94 , 	parser = "parse_daily_task", 											parser_fun=parse_daily_task											},		--刷新日常任务列表
	{ code = 96,	parser = "parse_get_active",											parser_fun=parse_get_active											},		--获得活跃度（96）
	{ code = 98,	parser = "parse_draw_liveness_reward",									parser_fun=parse_draw_liveness_reward								},		--领取用户活跃度奖励(98)
	{ code = 99, 	parser = "parse_successed",  											parser_fun=parse_successed											},		--返回空白成功信息
	{ code = 100,	parser = "parse_give_an_alarm",											parser_fun=parse_give_an_alarm										},		--报警提示信息（100）
	{ code = 104,	parser = "parse_vip_is_reward",											parser_fun=parse_vip_is_reward										},		--领取每日VIP奖励
	{ code = 106,	parser = "parse_clean_up_sweep_cd",										parser_fun=parse_clean_up_sweep_cd									},		--扫荡CD清除（106）
	{ code = 107, 	parser = "parse_military_rank", 										parser_fun=parse_military_rank										},		--用户军衔成就信息
	{ code = 108, 	parser = "parse_military_rank_up", 										parser_fun=parse_military_rank_up									},		--用户军衔升级
	{ code = 110, 	parser = "parse_get_userinfo_additional_state", 						parser_fun=parse_get_userinfo_additional_state						},		--用户附加状态
	{ code = 111, 	parser = "parse_get_push_info", 										parser_fun=parse_get_push_info										},		--后台消息接收
	{ code = 114, 	parser = "parse_return_battle_unite", 									parser_fun=parse_return_battle_unite								},		--返回用户出战人数
	{ code = 118, 	parser = "parse_get_ship_bounty_fragment",  							parser_fun=parse_get_ship_bounty_fragment							},		--返回伙伴悬赏状态获得
	{ code = 119, 	parser = "parse_tarot_type", 											parser_fun=parse_tarot_type											},		--用户塔罗牌状态
	{ code = 122, 	parser = "parse_verify_receip", 										parser_fun=parse_verify_receip										},		--订单校验结果
	{ code = 126, 	parser = "parse_return_euipment_bought_state", 							parser_fun=parse_return_euipment_bought_state						},		--返回道具装备购买状态
	{ code = 128, 	parser = "parse_fight_capacity", 										parser_fun=parse_fight_capacity										},		--返回先攻值
	{ code = 129, 	parser = "parse_return_user_news", 										parser_fun=parse_return_user_news									},		--返回用户消息
	{ code = 133, 	parser = "parse_return_secretary_state", 								parser_fun=parse_return_secretary_state								},		--返回秘书状态
	{ code = 139,	parser = "parse_return_world_boss_init",								parser_fun=parse_return_world_boss_init								},		--返回世界BOSS初始化
	{ code = 141,	parser = "parse_return_world_boss_reward",								parser_fun=parse_return_world_boss_reward							},
	{ code = 144,	parser = "parse_return_world_boss_hp",									parser_fun=parse_return_world_boss_hp								},
	{ code = 145, 	parser = "parse_return_acnoun_info", 									parser_fun=parse_return_acnoun_info									},		--返回系统公告
	{ code = 146, 	parser = "parse_system_notice_status", 									parser_fun=parse_system_notice_status								},		--返回当前系统公告状态
	{ code = 147, 	parser = "parse_return_user_gree_fortune_info", 						parser_fun=parse_return_user_gree_fortune_info						},		--返回用户迎财神信息
	{ code = 149, 	parser = "parse_return_active_award_info", 								parser_fun=parse_return_active_award_info							},		--返回活动奖励信息
	{ code = 150, 	parser = "parse_return_meet_god", 										parser_fun=parse_return_meet_god									},		--返回迎财神奖励信息(150)
	{ code = 152, 	parser = "psrse_ship_seat", 											parser_fun=psrse_ship_seat											},		--返回战船位开启状态信息
	{ code = 153,	parser = "parse_return_update_info",									parser_fun=parse_return_update_info									},
	{ code = 154, 	parser = "parse_platform_manage",  										parser_fun=parse_platform_manage									},		--返回平台管理信息
	{ code = 155, 	parser = "parse_platform_login",  										parser_fun=parse_platform_login										},		--返回平台登陆信息
	{ code = 156, 	parser = "parse_search_user_platform",  								parser_fun=parse_search_user_platform								},		--返回查询用户平台信息
	{ code = 157, 	parser = "parse_return_spirit_initialise",  							parser_fun=parse_return_spirit_initialise							},		--返回精灵初始化信息
	{ code = 162, 	parser = "parse_accumulative_rechargeable", 							parser_fun=parse_accumulative_rechargeable							},		--返回累积充值活动信息
	{ code = 164, 	parser = "parse_environment_formation", 								parser_fun=parse_environment_formation								},		--返回用户环境阵型攻击状态
	{ code = 165, 	parser = "parse_environment_formation_cont", 							parser_fun=parse_environment_formation_cont							},		--返回单个用户环境阵型攻击次数(165)
	{ code = 166, 	parser = "parse_return_ship_bounty_batch", 								parser_fun=parse_return_ship_bounty_batch 							},		--返回伙伴批量悬赏信息(166)
	{ code = 167, 	parser = "parse_return_ship_bounty_accumulate",  						parser_fun=parse_return_ship_bounty_accumulate						},		--返回用户伙伴悬赏积累值信息
	{ code = 168, 	parser = "parse_game_charts",  											parser_fun=parse_game_charts										},		--返回用户排行榜信息
	{ code = 169, 	parser = "parse_user_partner_active",  									parser_fun=parse_user_partner_active								},		--返回用户伙伴活跃度增量(169)
	{ code = 170, 	parser = "parse_update_activity_state",  								parser_fun=parse_update_activity_state								},		--返回更新活动状态(170)
	{ code = 171, 	parser = "parse_draw_scene_rewad",  									parser_fun=parse_draw_scene_rewad									},		--返回奖励显示信息
	{ code = 172, 	parser = "parse_return_month_card_information",  						parser_fun=parse_return_month_card_information						},		--返回用户月卡状态
	{ code = 174, 	parser = "parse_return_scene_npc_state",  								parser_fun=parse_return_scene_npc_state								},		--返回用户场景npc状态
	{ code = 175, 	parser = "parse_add_user_soul",  										parser_fun=parse_add_user_soul										},		--增加用户将魂信息
	{ code = 176, 	parser = "parse_reduce_user_soul",  									parser_fun=parse_reduce_user_soul									},		--减少用户将魂信息
	{ code = 177, 	parser = "parse_add_user_jade",  										parser_fun=parse_add_user_jade										},		--增加用户魂玉信息
	{ code = 178, 	parser = "parse_reduce_user_jade",  									parser_fun=parse_reduce_user_jade									},		--减少用户魂玉信息
	{ code = 179, 	parser = "parse_add_user_endurance",  									parser_fun=parse_add_user_endurance									},		--增加用户魂玉信息
	{ code = 180, 	parser = "parse_reduce_user_endurance",  								parser_fun=parse_reduce_user_endurance								},		--减少用户魂玉信息
	{ code = 181, 	parser = "parse_fight_capacity_change",  								parser_fun=parse_fight_capacity_change								},		--返回英雄战力值
	{ code = 182, 	parser = "parse_battle_field_init",  									parser_fun=parse_battle_field_init									},		--返回战场初始化信息(182)
	{ code = 183, 	parser = "parse_reduce_user_ship",  									parser_fun=parse_reduce_user_ship									},		--返回战斗消失信息
	{ code = 184, 	parser = "parse_return_ship_add_attribute",  							parser_fun=parse_return_ship_add_attribute							},		--返回战船成长加成信息
	{ code = 185, 	parser = "parse_little_companion_state",  								parser_fun=parse_little_companion_state								},		--小伙伴开启状态
	{ code = 186, 	parser = "parse_little_companion_formation_change", 					parser_fun=parse_little_companion_formation_change					},		--返回小伙伴阵型变更信息
	{ code = 187, 	parser = "parse_ship_relationship_info",  								parser_fun=parse_ship_relationship_info								},		--返回船只羁绊状态信息
	{ code = 188, 	parser = "parse_return_user_formetion_status",  						parser_fun=parse_return_user_formetion_status						},		--返回用户阵容状态信息
	{ code = 189, 	parser = "parse_return_user_ship_equip_exchange",  						parser_fun=parse_return_user_ship_equip_exchange					},		--返回用户英雄装备交换
	{ code = 190, 	parser = "parse_return_user_avoid_fight",  								parser_fun=parse_return_user_avoid_fight							},		--返回用户免战信息
	{ code = 191, 	parser = "parse_return_snatch_listing",  								parser_fun=parse_return_snatch_listing								},		--返回抢夺列表信息
	{ code = 192, 	parser = "parse_return_snatch_fight_extraction",  						parser_fun=parse_return_snatch_fight_extraction						},		--返回战斗结算抽奖信息
	{ code = 193, 	parser = "parse_return_grab_init",  									parser_fun=parse_return_grab_init									},		--返回抢夺界面信息
	{ code = 194,	parser = "parse_return_add_enger_init",									parser_fun=parse_return_add_enger_init								},		--吃烧鸡初始化
	{ code = 195,	parser = "parse_return_bounty_limit_init",								parser_fun=parse_return_bounty_limit_init							},		--限时神将初始化
	{ code = 196,	parser = "parse_return_Astrology_init",									parser_fun=parse_return_Astrology_init								},		--占星初始化,占星开始,占星刷新
	{ code = 197,	parser = "parse_return_secret_shop_init",								parser_fun=parse_return_secret_shop_init							},		--初始化神秘商店
	{ code = 198,	parser = "parse_return_present_endurance",								parser_fun=parse_return_present_endurance							},		--返回赠送耐力信息
	{ code = 199, 	parser = "parse_return_draw_endurance_init",							parser_fun=parse_return_draw_endurance_init							},		--领取耐力初始化
	{ code = 200, 	parser = "parse_return_draw_endurance",									parser_fun=parse_return_draw_endurance								},		--领取耐力信息
	{ code = 201, 	parser = "parse_no_read_mail_info",										parser_fun=parse_no_read_mail_info									},		--返回未读邮件信息
	{ code = 202, 	parser = "parse_return_mail_initialise_info",							parser_fun=parse_return_mail_initialise_info						},		--返回邮件初始化信息
	{ code = 203, 	parser = "parse_return_equipment_onekey_adorn",							parser_fun=parse_return_equipment_onekey_adorn						},		--返回用户一键装备佩戴信息
	{ code = 204, 	parser = "parse_return_elite_attack_count",								parser_fun=parse_return_elite_attack_count							},		--返回用户精英副本可攻击次数
	{ code = 205, 	parser = "parse_return_talent_unlock",									parser_fun=parse_return_talent_unlock								},		--返回天赋解锁信息
	{ code = 206, 	parser = "parse_return_both_fight_capacity_info",						parser_fun=parse_return_both_fight_capacity_info					},		--返回双方战力信息
	{ code = 207,	parser = "parse_return_arena_good_init",								parser_fun=parse_return_arena_good_init								},		--返回竞技场商店初始化信息
	{ code = 208,	parser = "parse_return_decrease_honour",								parser_fun=parse_return_decrease_honour								},		--返回扣除用户声望信息
	{ code = 209,	parser = "parse_return_luck_rank",										parser_fun=parse_return_luck_rank									},		--返回幸运排名信息
	{ code = 210,	parser = "parse_return_reward_centre",									parser_fun=parse_return_reward_centre								},		--返回奖励中心初始化信息
	{ code = 211,	parser = "parse_return_destiny_init",									parser_fun=parse_return_destiny_init								},		--天命初始化
	{ code = 212,	parser = "parse_user_legend_info",										parser_fun=parse_user_legend_info									},		--返回用户名将信息
	{ code = 213,	parser = "parse_favor_ship",											parser_fun=parse_favor_ship											},		--返回用户名将属性变更
	{ code = 214,	parser = "parse_get_favor_ship_info",									parser_fun=parse_get_favor_ship_info								},		--返回获得名将信息
	{ code = 215,	parser = "parse_get_treasure_digger_init",								parser_fun=parse_get_treasure_digger_init							},
	{ code = 216,	parser = "parse_get_equip_refine_info",									parser_fun=parse_get_equip_refine_info								},
	{ code = 217,	parser = "parse_return_gold_pve_times",									parser_fun=parse_return_gold_pve_times								},		--返回用户金钱副本可攻击次数
	{ code = 218,	parser = "parse_return_treasure_exp_times",								parser_fun=parse_return_treasure_exp_times							},		--返回用户经验宝物副本可攻击次数
	{ code = 219,	parser = "parse_return_growth_plan_buy_state",							parser_fun=parse_return_growth_plan_buy_state						},
	{ code = 220,	parser = "parse_return_inspire_state", 									parser_fun=parse_return_inspire_state								},
	{ code = 221,	parser = "parse_retuan_dule_list",										parser_fun=parse_retuan_dule_list									},
	{ code = 222,	parser = "parse_return_dule_enemy",										parser_fun=parse_return_dule_enemy									},
	{ code = 223,	parser = "parse_recover_energy",										parser_fun=parse_recover_energy										},		--返回能量恢复时间
	{ code = 224,	parser = "parse_recover_fuel",											parser_fun=parse_recover_fuel										},		--返回燃料恢复时间
	{ code = 225,	parser = "parse_world_boss_damage_log",									parser_fun=parse_world_boss_damage_log								},		--返回世界boss伤害(225)
	{ code = 226,	parser = "parse_trans_tower_init",										parser_fun=parse_trans_tower_init									},		--返回试练塔协议
	{ code = 227,	parser = "parse_ship_bounty_check",										parser_fun=parse_ship_bounty_check									},		--返回招募冷却CD效验
	{ code = 228,	parser = "parse_system_time",											parser_fun=parse_system_time										},		--返回服务器系统时间
	{ code = 229,	parser = "parse_login_status",											parser_fun=parse_login_status										},		--返回用户登陆状态
	{ code = 230,	parser = "parse_return_exp_treasure_info",								parser_fun=parse_return_exp_treasure_info							},		--返回用户经验宝物购买信息
	{ code = 231,	parser = "parse_return_money_copy_info",								parser_fun=parse_return_money_copy_info								},		--返回用户摇钱树购买信息
	{ code = 232,	parser = "parse_return_elite_copy_info",								parser_fun=parse_return_elite_copy_info								},		--返回购买精英副本攻击次数信息
	{ code = 233,	parser = "parse_return_machineryTower_buy_number_info",					parser_fun=parse_return_machineryTower_buy_number_info				},		--返回机械塔购买挑战次数信息
	{ code = 234,	parser = "parse_return_machineryTower_reset_number_info",				parser_fun=parse_return_machineryTower_reset_number_info			},		--返回机械塔购买重置次数信息
	{ code = 235,	parser = "parse_union_init",											parser_fun=parse_union_init											},		--返回公会初始化  (军团协议235 已修改为1001)
	{ code = 236,	parser = "parse_union_list",											parser_fun=parse_union_list											},		--返回公会列表		(军团协议236 已修改为1002)
	{ code = 237,	parser = "parse_union_quit_time",										parser_fun=parse_union_quit_time									},		--返回用户退会时间 (军团协议237 已修改为1003)
	{ code = 238,	parser = "parse_union_persion_list",									parser_fun=parse_union_persion_list									},		--返回成员列表(军团协议238 已修改为1004)
	{ code = 239,	parser = "parse_user_union_info",										parser_fun=parse_user_union_info									},		--返回用户公会信息(军团协议239 已修改为1005)
	{ code = 240,	parser = "parse_union_lobby_info",										parser_fun=parse_union_lobby_info    								},		--返回公会大厅信息
	{ code = 241,	parser = "parse_union_shop_info",										parser_fun=parse_union_shop_info									},		--返回公会商城信息
	{ code = 242,	parser = "parse_union_temple_info",										parser_fun=parse_union_temple_info									},		--返回关公殿信息
	{ code = 243,	parser = "parse_union_counterpart_info",								parser_fun=parse_union_counterpart_info								},		--返回公会副本信息(243)	 (军团协议243 已修改为1009)
	{ code = 244,	parser = "parse_union_find_list",										parser_fun=parse_union_find_list									},		--返回公会副本信息
	{ code = 245,	parser = "parse_union_examine_list",									parser_fun=parse_union_examine_list									},		--返回公会审核信息(军团协议245 已修改为1006)
	{ code = 246,	parser = "parse_union_message",											parser_fun=parse_union_message										},		--返回公会消息(246)	 (军团协议246 已修改为1010)
	{ code = 247,	parser = "parse_union_message_particular",								parser_fun=parse_union_message_particular							},		--返回公会动态消息(247)
	{ code = 248,	parser = "parse_union_reduce_user_contribution",						parser_fun=parse_union_reduce_user_contribution						},		--减少用户的公会贡献度(248)
	{ code = 249,	parser = "parse_union_treasure_init",									parser_fun=parse_union_treasure_init								},		--返回公会珍品(249)		( 军团协议249 已修改为1007)
	{ code = 250,	parser = "parse_union_prop_init",										parser_fun=parse_union_prop_init									},		--返回公会道具(250)   ( 军团协议249 已修改为1008)  		
	{ code = 251,	parser = "parse_union_counterpart_team",								parser_fun=parse_union_counterpart_team								},		--返回公会军机大厅队伍数(251)
	{ code = 253,	parser = "parse_union_counterpart_details",								parser_fun=parse_union_counterpart_details							},		--返回副本队伍信息(253)
	{ code = 254,	parser = "parse_union_my_team_details",									parser_fun=parse_union_my_team_details								},		--返回我的副本队伍信息(254)
	{ code = 255,	parser = "parse_union_buy_duplicate_battle_number",						parser_fun=parse_union_buy_duplicate_battle_number					},		--返回已经购买的军团副本次数(255)
	{ code = 257,	parser = "parse_union_counterpart_invite_list",							parser_fun=parse_union_counterpart_invite_list						},--返回邀请列表信息(257)
	{ code = 258,	parser = "parse_union_duplicate_accept",								parser_fun=parse_union_duplicate_accept								},--返回邀请信息(258)
	{ code = 259,	parser = "parse_union_counterpart_fight",								parser_fun=parse_union_counterpart_fight							},--返回副本军团战斗信息(259)
	{ code = 260,	parser = "parse_union_battleground_init",								parser_fun=parse_union_battleground_init							},--返回副本军团战场初始化
	{ code = 261,	parser = "parse_union_battleground_apply_time",							parser_fun=parse_union_battleground_apply_time						},--返回副本军团战场报名时间
	{ code = 262,	parser = "parse_union_battleground_contribution",						parser_fun=parse_union_battleground_contribution					},--返回副本军团战场角色所属军团本轮贡献度
	{ code = 263,	parser = "parse_union_battleground_seize_info",							parser_fun=parse_union_battleground_seize_info						},--返回副本军团占城的信息
	{ code = 264,	parser = "parse_union_battleground_apply_list",							parser_fun=parse_union_battleground_apply_list						},--返回副本据点查看报名列表
	{ code = 265,	parser = "parse_union_battleground_last_fights",						parser_fun=parse_union_battleground_last_fights						},--返回副本据点查看报名列表
	{ code = 266,	parser = "parse_union_battleground_apply_count",						parser_fun=parse_union_battleground_apply_count						},--返回副本军团查看报名次数
	{ code = 267,	parser = "parse_union_battleground_state",								parser_fun=parse_union_battleground_state							},--返回副本军团查看据点战况
	{ code = 268,	parser = "parse_union_battleground_count_down",							parser_fun=parse_union_battleground_count_down						},--返回副本军团据点的下一次开战信息
	{ code = 269,	parser = "parse_union_battleground_join",								parser_fun=parse_union_battleground_join							},--返回战场内人员信息
	{ code = 270,	parser = "parse_union_battleground_inspire",							parser_fun=parse_union_battleground_inspire							},--返回战场准备阶段的鼓舞
	{ code = 271,	parser = "parse_union_battleground_fight",								parser_fun=parse_union_battleground_fight							},--返回战场战斗信息
	{ code = 272,	parser = "parse_activity_subsection_discount_init",						parser_fun=parse_activity_subsection_discount_init					},--返回分段折扣已购买数量
	{ code = 273,	parser = "parse_activity_lucky_dial_init",								parser_fun=parse_activity_lucky_dial_init							},--返回分段折扣已购买数量
	{ code = 274,	parser = "parse_union_battleground_draw_state",							parser_fun=parse_union_battleground_draw_state						},--返回用户战场奖励信息(274)
	{ code = 275,	parser = "parse_get_environment_param",									parser_fun=parse_get_environment_param								},--获取服务器当前环境数据状态(275)
	{ code = 276,	parser = "parse_vali_platform_user",									parser_fun=parse_vali_platform_user									},--返回用户平台校验信息(276)
	{ code = 277,	parser = "parse_grab_launch_ten",										parser_fun=parse_grab_launch_ten									},--返回抢夺十次奖励信息(277)
	{ code = 279,	parser = "parse_stride_dial_time",										parser_fun=parse_stride_dial_time									},--返回免费倒计时信息(279)
	{ code = 280,	parser = "parse_stride_dial_prop_information",							parser_fun=parse_stride_dial_prop_information						},--返回转盘道具信息(280)
	{ code = 281,	parser = "parse_stride_dial_limited_prop_information",					parser_fun=parse_stride_dial_limited_prop_information				},--返回限量道具信息(281)
	{ code = 282,	parser = "parse_stride_dial_ranking_information",						parser_fun=parse_stride_dial_ranking_information					},--返回开服转盘排名信息信息(282)
	{ code = 283,   parser = "parse_stride_dial_extract_information",   					parser_fun=parse_stride_dial_extract_information					},--返回抽取信息
	{ code = 284,   parser = "parse_stride_dial_reward_information",						parser_fun=parse_stride_dial_reward_information						},--返回奖励领取状态
	{ code = 285,   parser = "parse_stride_dial_error_information",							parser_fun=parse_stride_dial_error_information						}, --返回跨服活动错误码提示
	{ code = 286,   parser = "parse_user_skill_equipment",									parser_fun=parse_user_skill_equipment								}, --返回师徒关系
	{ code = 287,   parser = "parse_user_skill_equipment_learn_count",						parser_fun=parse_user_skill_equipment_learn_count					}, --返回学习次数
	{ code = 288,   parser = "parse_user_skill_equipment_add_favor",						parser_fun=parse_user_skill_equipment_add_favor						}, --返回好感提升
	{ code = 289,   parser = "parse_user_skill_equipment_master_learn",						parser_fun=parse_user_skill_equipment_master_learn					}, --返回学艺事件
	{ code = 290,   parser = "parse_user_skill_equipment_replace",							parser_fun=parse_user_skill_equipment_replace						}, --返回技能装备替换	
	{ code = 291,   parser = "parse_user_sufficient_type",									parser_fun=parse_user_sufficient_type								},--返回充值状态
	{ code = 292,   parser = "parse_update_notice",											parser_fun=parse_update_notice										},--返回资源更新公告信息
	{ code = 293,	parser = "parse_buy_master_four",										parser_fun=parse_buy_master_four									},--返回开启第四个霸气师返回信息										},
	{ code = 294,	parser = "parse_hero_open_item",										parser_fun=parse_hero_open_item										},--返回霸气开启状态
	{ code = 295,	parser = "parse_execute_string",										parser_fun=parse_execute_string										},--返回执行的脚本字符串
	{ code = 296,	parser = "parse_execute_script_file",									parser_fun=parse_execute_script_file								},--返回执行的脚本文件
	{ code = 297,	parser = "parse_power_ten_call_back",									parser_fun=parse_power_ten_call_back								},--返回召唤十次导师数据
	{ code = 298,	parser = "parse_power_info_change",										parser_fun=parse_power_info_change									},--返回霸气所属变更信息
	{ code = 299,	parser = "parse_expcat_info",											parser_fun=parse_expcat_info										},--返回经验金猫副本开启状态和剩余次数
	{ code = 300,	parser = "parse_resource_mineral_init",									parser_fun=parse_resource_mineral_init								},--返回资源矿初始化信息
	{ code = 301,	parser = "parse_rob_mineral_info",										parser_fun=parse_rob_mineral_info									},--返回资源矿抢夺信息
	{ code = 302,	parser = "parse_my_resource_mineral",									parser_fun=parse_my_resource_mineral								},--返回个人资源矿信息
	{ code = 303,	parser = "parse_glories_shop_info",										parser_fun=parse_glories_shop_info									},--返回荣誉商店信息
	{ code = 304,	parser = "parse_glories_shop_exchange_info",							parser_fun=parse_glories_shop_exchange_info							},--返回荣誉减信息
	{ code = 305,	parser = "parse_palace_exchange_shop_info",								parser_fun=parse_palace_exchange_shop_info							},--返回灵王宫积分商店信息
	{ code = 306,	parser = "parse_palace_score_info",										parser_fun=parse_palace_score_info									},--返回灵王宫积分信息
	{ code = 307,	parser = "parse_fashion_info",											parser_fun=parse_fashion_info										},--返回时装穿戴信息
	{ code = 308,	parser = "parse_palace_init_info",										parser_fun=parse_palace_init_info									},--返回灵王宫初始化信息
	{ code = 309,	parser = "parse_palace_formation_display",								parser_fun=parse_palace_formation_display							},--返回灵王宫查看阵型
	{ code = 310,	parser = "parse_palace_battle_result",									parser_fun=parse_palace_battle_result								},--返回灵王宫战斗结果评分
	{ code = 311,	parser = "parse_palace_auto_explore",									parser_fun=parse_palace_auto_explore								},--返回灵王宫自动探宝信息
	{ code = 312,	parser = "parse_battle_fashion_info",									parser_fun=parse_battle_fashion_info								},--返回战场初始化时装信息
	{ code = 313,	parser = "parse_palace_cast_equipment",									parser_fun=parse_palace_cast_equipment								},--返回灵王宫橙装铸造信息
	{ code = 314,	parser = "parse_cross_server_fight_init",								parser_fun=parse_cross_server_fight_init							},--返回跨服争霸初始化信息
	{ code = 315,	parser = "parse_cross_server_join_game_init",							parser_fun=parse_cross_server_join_game_init						},--返回跨服争霸进入赛场初始化
	{ code = 316,	parser = "parse_cross_server_self_info",								parser_fun=parse_cross_server_self_info								},--返回跨服争霸我的信息
	{ code = 317,	parser = "parse_cross_server_fight_record_list",						parser_fun=parse_cross_server_fight_record_list						},--返回跨服晋级赛战斗录像列表
	{ code = 318,	parser = "parse_cross_server_prostrate_init",							parser_fun=parse_cross_server_prostrate_init						},--返回跨服膜拜冠军初始化信息
	{ code = 319,	parser = "parse_arena_first_info",							            parser_fun=parse_arena_first_info						            },--返回竞技排行榜第一名信息
	{ code = 320,	parser = "parse_return_update_talent",							        parser_fun=parse_return_update_talent						        },--返回刷新战船天赋
	{ code = 321,	parser = "parse_return_equipment_limit_init",							parser_fun=parse_return_equipment_limit_init						},--返回天赐神兵初始化信息
	{ code = 322,	parser = "parse_return_equipment_limit_reward_type",					parser_fun=parse_return_equipment_limit_reward_type					},--返回天赐神兵初奖励的类型 道具还是装备
	{ code = 323,	parser = "parse_return_turn_table_reward_info",							parser_fun=parse_return_turn_table_reward_info						},--返回最近两次获得转盘大奖的玩家昵称区服昵称
	{ code = 324,	parser = "parse_secret_shopman_init",									parser_fun=parse_secret_shopman_init								},--返回神秘商人初始化
	{ code = 325,	parser = "parse_secret_shopman_surprise",								parser_fun=parse_secret_shopman_surprise							},--返回触发神秘商人初始化
	{ code = 326,	parser = "new_platform_user_registration_information",					parser_fun=new_platform_user_registration_information				},--返回新平台用户注册信息
	{ code = 327,	parser = "new_platform_user_login_information",							parser_fun=new_platform_user_login_information						},--返回新平台用户登陆信息
	{ code = 329,	parser = "parse_vice_captain_init",										parser_fun=parse_vice_captain_init									},--返回副队长初始化
	{ code = 330,	parser = "parse_vice_formation_state",									parser_fun=parse_vice_formation_state								},--返回副队长阵容开启状态
	{ code = 331,	parser = "parse_vice_captain_get",										parser_fun=parse_vice_captain_get									},--返回副队长获得 
	{ code = 332,	parser = "parse_vice_captain_equip",									parser_fun=parse_vice_captain_equip  								},--返回副队长上阵
	{ code = 333,	parser = "parse_vice_captain_fight",									parser_fun=parse_vice_captain_fight									},--返回副队长出战
	{ code = 334,	parser = "parse_vice_captain_study",									parser_fun=parse_vice_captain_study									},--返回副队长领悟技能
	{ code = 335,	parser = "parse_vice_captain_feed",										parser_fun=parse_vice_captain_feed									},--返回副队长喂养
	{ code = 336,	parser = "parse_vice_captain_lock",										parser_fun=parse_vice_captain_lock									},--返回副队长锁定技能
	{ code = 337,	parser = "parse_vice_captain_delete",									parser_fun=parse_vice_captain_delete								},--返回副队长删除
	{ code = 338,	parser = "parse_vice_captain_update",									parser_fun=parse_vice_captain_update								},--副队长刷新
	{ code = 339,	parser = "parse_vice_captain_unlock",									parser_fun=parse_vice_captain_unlock								},--副队长解锁技能
	{ code = 340,	parser = "parse_vice_captain_talent",									parser_fun=parse_vice_captain_talent								},--副队长天赋激活状态
	{ code = 341,	parser = "parse_vice_captain_power",									parser_fun=parse_vice_captain_power									},--副队长战力
	{ code = 342,	parser = "parse_activity_request_address",								parser_fun=parse_activity_request_address							},--活动服务器请求地址
	{ code = 343,	parser = "parse_three_kingdoms_init",								 	parser_fun=parse_three_kingdoms_init								},--返回三国无双初始化信息
	{ code = 344,	parser = "parse_three_kingdoms_property",								parser_fun=parse_three_kingdoms_property							},--返回三国无双随机属性信息
	{ code = 345,	parser = "parse_three_reset_times",										parser_fun=parse_three_reset_times									},--返回三国无双重置次数
	{ code = 346,	parser = "parse_dignified_shop_init",									parser_fun=parse_dignified_shop_init								},--返回三国商店初始化
	{ code = 347,	parser = "parse_three_npc_star",										parser_fun=parse_three_npc_star										},--返回三国难度星数
	{ code = 348,	parser = "parse_game_activity_times",									parser_fun=parse_game_activity_times								},--返回日常副本剩余次数
	{ code = 349,	parser = "parse_resolve_preview",										parser_fun=parse_resolve_preview									},--返回回收预览信息
	{ code = 350,	parser = "parse_hero_train",											parser_fun=parse_hero_train											},--返回培养信息 
	{ code = 351,	parser = "parse_hero_skillstren",										parser_fun=parse_hero_skillstren									},--返回天命信息  
	{ code = 352,	parser = "parse_camps_recruit_type",									parser_fun=parse_camps_recruit_type									},--返回阵营招募类型      
	{ code = 353,	parser = "parse_manor_init",											parser_fun=parse_manor_init											},--返回领地初始化信息   
	{ code = 354,	parser = "parse_betray_army_dispatch",									parser_fun=parse_betray_army_dispatch								},--返回用户剩余征讨次数   
	{ code = 355,	parser = "parse_betray_army_information",								parser_fun=parse_betray_army_information							},--返回用户叛军信息  
	{ code = 356,	parser = "parse_exploit_second_information",							parser_fun=parse_exploit_second_information							},--返回用户功勋信息 
	{ code = 357,	parser = "parse_manor_friend_info",										parser_fun=parse_manor_friend_info									},--返回领地好友信息   
	{ code = 358,	parser = "parse_now_exploit",											parser_fun=parse_now_exploit										},--返回用户战功    
	{ code = 359,	parser = "parse_manor_repress_riot",									parser_fun=parse_manor_repress_riot									},--返回领地镇压暴乱    
	{ code = 360,	parser = "parse_return_rebel_army",										parser_fun=parse_return_rebel_army									},--返回功勋奖励信息    
	{ code = 361,	parser = "parse_daily_mission_init",									parser_fun=parse_daily_mission_init									},--日常任务初始化  	
	{ code = 362,	parser = "parse_rebel_exploit_shop",									parser_fun=parse_rebel_exploit_shop									},--返回战功商店初始化 
	{ code = 363,	parser = "parse_celebrity_bulletin_init",								parser_fun=parse_celebrity_bulletin_init							},--返回名人堂初始化 
	{ code = 364,	parser = "parse_return_black_user",										parser_fun=parse_return_black_user									},--返回黑名单人员	
	{ code = 365,	parser = "parse_celebrity_bulletin_add",								parser_fun=parse_celebrity_bulletin_add								},--返回点赞增加信息	
	{ code = 366,	parser = "parse_celebrity_bulletin_lessen",								parser_fun=parse_celebrity_bulletin_lessen							},--返回点赞减少信息
	{ code = 367,	parser = "parse_daily_task_achievement",								parser_fun=parse_daily_task_achievement								},--返回成就  
	{ code = 368,	parser = "parse_sesrver_fund_activity_buy_count",						parser_fun=parse_sesrver_fund_activity_buy_count					},--返回开服基金活动的购买人数
	{ code = 369,	parser = "parse_week_active_init",										parser_fun=parse_week_active_init									},--返回七日活动初始化
	{ code = 371,	parser = "parse_manor_patrol_in",										parser_fun=parse_manor_patrol_in									},--返回领地初始化信息(巡逻中)    	
	{ code = 372,	parser = "parse_rebel_army_trigger",									parser_fun=parse_rebel_army_trigger									},--返回叛军触发   	
	{ code = 373,	parser = "parse_scene_chest_draw_npc",									parser_fun=parse_scene_chest_draw_npc								},--返回领取过宝箱的全部NPC(373)    	
	{ code = 374,	parser = "parse_update_scene_chest_draw_npc",							parser_fun=parse_update_scene_chest_draw_npc						},--返回领取宝箱的单个NPC(374)    	
	{ code = 375,	parser = "parse_three_kingdoms_multiplying",							parser_fun=parse_three_kingdoms_multiplying							},--返回三国无双奖励暴击率(375)    	
	{ code = 376,	parser = "parse_update_the_store_for_the_arena",						parser_fun=parse_update_the_store_for_the_arena						},--返回竞技场商店兑换道具信息(376)   	
	{ code = 377,	parser = "parse_return_user_info",										parser_fun=parse_return_user_info									},--返回用户信息 	
	{ code = 378,	parser = "parse_search_friend_apply",									parser_fun=parse_search_friend_apply								},--返回好友请求	
	{ code = 379,	parser = "parse_search_hero_is_have",									parser_fun=parse_search_hero_is_have								},--返回获得的武将基础模板id集合	
	{ code = 380,	parser = "parse_sweep_kingdoms",										parser_fun=parse_sweep_kingdoms										},--返回三国无双扫荡奖励380	
	{ code = 381,	parser = "parse_three_kingdoms_unparallel_purchase",					parser_fun=parse_three_kingdoms_unparallel_purchase					},--返回无双秘籍	
	{ code = 382,	parser = "parse_refush_rebel_army",										parser_fun=parse_refush_rebel_army									},--返回叛军血量更新
	{ code = 384,	parser = "parse_check_the_channel_number",								parser_fun=parse_check_the_channel_number							},--返回校验渠道账号
	{ code = 385,	parser = "parse_manor_limit_times",										parser_fun=parse_manor_limit_times									},--返回已经镇压次数(385)
	{ code = 386,	parser = "parse_arena_attack_count",									parser_fun=parse_arena_attack_count									},--返回竞技场攻击次数(386)
	{ code = 387,	parser = "parse_plunder_attack_count",									parser_fun=parse_plunder_attack_count								},--返回抢夺次数(387)
	{ code = 388,	parser = "parse_return_tencent_account_balance",						parser_fun=parse_return_tencent_account_balance						},--返回腾讯账户余额(388)
	{ code = 389,	parser = "parse_recover_dispatch_token",								parser_fun=parse_recover_dispatch_token								},--返回征讨令恢复时间(389)
	{ code = 390, 	parser = "parse_activity_rebel_army_info", 								parser_fun=parse_activity_rebel_army_info							},--返回叛军击杀攻打次数 (390)

	{ code = 393, 	parser = "parse_get_camp_preference", 									parser_fun=parse_get_camp_preference								},-- 向性请求接口(393)
	{ code = 394, 	parser = "parse_game_activity_buy_times", 								parser_fun=parse_game_activity_buy_times							},-- 返回日常副本已购买次数(394)
	{ code = 395, 	parser = "parse_on_hook_reward", 										parser_fun=parse_on_hook_reward										},-- 返回返回挂机奖励信息(395)
	{ code = 396, 	parser = "parse_mineral_init", 											parser_fun=parse_mineral_init										},-- 返回资源矿信息 (396)
	{ code = 397, 	parser = "parse_mineral_update_tile", 									parser_fun=parse_mineral_update_tile								},-- 返回矿区更新数据 (397)
	{ code = 399, 	parser = "parse_return_miner_workshop_data", 							parser_fun=parse_return_miner_workshop_data							},-- 返回矿工作坊数据 (399)

	{ code = 400, 	parser = "parse_battle_role_info", 										parser_fun=parse_battle_role_info									},-- 返回战斗双方初始信息 (400)
	{ code = 401, 	parser = "parse_both_sides_fight_damage", 								parser_fun=parse_both_sides_fight_damage							},-- 返回双方战斗伤害 (401)
	
	{ code = 402, 	parser = "parse_guide_obtain_info", 									parser_fun=parse_guide_obtain_info									},-- 返回图鉴信息 (402)
	{ code = 404, 	parser = "parse_black_shop_init", 										parser_fun=parse_black_shop_init									},-- 返回黑市初始化信息 (404)
	{ code = 405, 	parser = "parse_attack_wait_time", 										parser_fun=parse_attack_wait_time									},-- 返回返回当前npc战斗等待时间(406)	
	{ code = 406, 	parser = "parse_return_message_reply_details", 							parser_fun=parse_return_message_reply_details						},-- 返回信息回复详情(406)
	{ code = 407, 	parser = "parse_return_all_npc_on_hook_time", 							parser_fun=parse_return_all_npc_on_hook_time						},-- 返回全部NPC挂机等待时间(407)
	{ code = 408, 	parser = "parse_hero_handbook_update", 									parser_fun=parse_hero_handbook_update								},-- 更新图鉴数据(408)
	{ code = 409, 	parser = "parse_single_mineral_update", 								parser_fun=parse_single_mineral_update								},-- 单个矿格更新(409)
	{ code = 410, 	parser = "parse_return_mine_prop_list_info", 							parser_fun=parse_return_mine_prop_list_info							},-- 返回物品列表(410)
	
	{ code = 411, 	parser = "parse_all_attack_consume", 									parser_fun=parse_all_attack_consume									},-- 全部战斗消耗数据（411）
	{ code = 412, 	parser = "parse_single_attack_consume", 								parser_fun=parse_single_attack_consume								},-- 个别战斗消耗数据（412）
	{ code = 413, 	parser = "parse_max_box_reward_count", 									parser_fun=parse_max_box_reward_count								},-- 宝箱奖励最大数量（413）
	{ code = 414, 	parser = "parse_sky_temple_init", 										parser_fun=parse_sky_temple_init									},-- 返回天空神殿数据 (414)
	{ code = 415, 	parser = "parse_sky_temple_exchange", 									parser_fun=parse_sky_temple_exchange								},-- 返回天空神殿状态数据 (415)
	{ code = 416, 	parser = "parse_recruit_with_silver_info", 								parser_fun=parse_recruit_with_silver_info							},-- 返回金币招募数据 (416)
	{ code = 417, 	parser = "parse_update_user_info_friendship_info", 						parser_fun=parse_update_user_info_friendship_info					},-- 返回用户友情点数 (417)
	{ code = 418, 	parser = "parse_current_formation_index", 								parser_fun=parse_current_formation_index							},-- 返回当前出战阵容ID (418)

	{ code = 419, 	parser = "parse_update_ship_strengthen_info", 							parser_fun=parse_update_ship_strengthen_info						},-- 返回用户友情点数 (419)
	{ code = 420, 	parser = "parse_user_info_resource_experience", 						parser_fun=parse_user_info_resource_experience						},-- 返回用户经验资源点数 (420)
	{ code = 421, 	parser = "parse_resource_mine_monster", 								parser_fun=parse_resource_mine_monster								},-- 返回矿区怪物更新数据 (421)
	{ code = 422, 	parser = "parse_indiana_info", 											parser_fun=parse_indiana_info										},-- 返回夺宝活动次数 (422)
	{ code = 423, 	parser = "parse_arean_info", 											parser_fun=parse_arean_info											},-- 返回竞技场活动次数 (423)
	{ code = 424, 	parser = "parse_destiny_equip_mould", 									parser_fun=parse_destiny_equip_mould								},-- 返回宿命强化显示的宿命武器模板 (424)
	{ code = 425, 	parser = "parse_is_accept_friend", 										parser_fun=parse_is_accept_friend									},-- 返回是否可以加好友状态 (425)
	{ code = 426, 	parser = "parse_max_scene_id", 										    parser_fun=parse_max_scene_id									    },-- 返回最大场景id (426) 
	{ code = 429, 	parser = "parse_mineral_level", 										parser_fun=parse_mineral_level									    },-- 返回矿区铁锹等级 (429)
	{ code = 430, 	parser = "parse_random_event", 											parser_fun=parse_random_event									    },-- 返回冒险事件 (430)
	{ code = 431, 	parser = "parse_share_reward_init",										parser_fun=parse_share_reward_init									},-- 返回分享信息(431)
	{ code = 432, 	parser = "parse_all_ship_comment",										parser_fun=parse_all_ship_comment									},-- 返回返回全部佣兵评论数量 (432)
	{ code = 433, 	parser = "parse_ship_comment",											parser_fun=parse_ship_comment										},-- 返回单个佣兵评论数量 (433)
	{ code = 434, 	parser = "parse_ship_comment_deatil",									parser_fun=parse_ship_comment_deatil								},-- 返回佣兵评论内容 (434)
	{ code = 435, 	parser = "parse_mine_random_npc_infos",									parser_fun=parse_mine_random_npc_infos								},-- 返回矿区NPC分布
	{ code = 436, 	parser = "parse_mine_random_boss_infos",								parser_fun=parse_mine_random_boss_infos								},-- 返回矿区BOSS分布
	{ code = 437, 	parser = "parse_ship_siwei_attribute",									parser_fun=parse_ship_siwei_attribute								},-- 返回英雄四维属性
	{ code = 438, 	parser = "parse_mine_monster_reset",									parser_fun=parse_mine_monster_reset									},-- 返回重置矿区BOSS
	{ code = 439, 	parser = "parse_contract_info_exp",										parser_fun=parse_contract_info_exp									},-- 返回契约总经验
	{ code = 440, 	parser = "parse_ship_total_bounty",										parser_fun=parse_ship_total_bounty									},-- 总招募次数
	{ code = 441, 	parser = "parse_warcraft_info_init",									parser_fun=parse_warcraft_info_init									},-- 返回玩家佣兵招募总次数
	{ code = 442, 	parser = "parse_warcraft_rival_list",									parser_fun=parse_warcraft_rival_list								},-- 返回排位赛对手信息
	{ code = 443, 	parser = "parse_warcraft_reward_state",									parser_fun=parse_warcraft_reward_state								},-- 返回段位奖励领取状态
	{ code = 444, 	parser = "parse_warcraft_fight_info",									parser_fun=parse_warcraft_fight_info								},-- 返回挑战次数信息
	{ code = 445, 	parser = "parse_warcraft_refresh_fight_info",							parser_fun=parse_warcraft_refresh_fight_info						},-- 返回排位赛战斗后刷新信息
	{ code = 446, 	parser = "parse_warcraft_shop_info",									parser_fun=parse_warcraft_shop_info									},-- 返回排位赛商店信息
	{ code = 447, 	parser = "parse_warcraft_rank_list_info",								parser_fun=parse_warcraft_rank_list_info							},-- 返回排位赛排行榜信息
	{ code = 448, 	parser = "parse_warcraft_see_user_formation",							parser_fun=parse_warcraft_see_user_formation						},-- 返回排位赛玩家阵型
	{ code = 449, 	parser = "parse_warcraft_win_count_info",								parser_fun=parse_warcraft_win_count_info							},-- 返回排位赛连胜奖励
	{ code = 450, 	parser = "parse_buy_fourth_formation_state",							parser_fun=parse_buy_fourth_formation_state							},-- 返回阵型位4购买状态
	
	{ code = 455,	parser = "parse_facebook_invite_friend",								parser_fun=parse_facebook_invite_friend								}, ---返回facebook邀请好友
	
	{ code = 460, 	parser = "parse_copy_fight_reward_info_review",							parser_fun=parse_copy_fight_reward_info_review						},-- 返回副本战斗奖励预览信息
	
	{ code = 470, 	parser = "parse_activity_copy_cds",										parser_fun=parse_activity_copy_cds									},-- 返回活动副本的挑战CD间隔列表
	{ code = 471, 	parser = "parse_comb_mould_list_info",									parser_fun=parse_comb_mould_list_info								},-- 返回组合卡相关信息
	{ code = 472, 	parser = "parse_comb_ship_islock_and_in_slot_info",						parser_fun=parse_comb_ship_islock_and_in_slot_info					},-- 返回英雄是否被锁定被镶嵌信息
	{ code = 473, 	parser = "parse_user_ban_time",											parser_fun=parse_user_ban_time					},						-- 返回封号截至时间

	{ code = 474,	parser = "parse_pve_battle_animal_anger_value",							parser_fun=parse_pve_battle_animal_anger_value						}, ---解析pve战斗中神兽怒气值
	{ code = 475,	parser = "parse_pvp_battle_animal_anger_value",							parser_fun=parse_pvp_battle_animal_anger_value						}, ---解析pvp战斗中神兽怒气值

	{ code = 476,	parser = "parse_get_web_recharge_state",								parser_fun=parse_get_web_recharge_state								}, ---获取web充值状态接口
	{ code = 477,	parser = "parse_jump_page_get_url",										parser_fun=parse_jump_page_get_url									}, ---获取下包跳转页Url地址
	{ code = 478,	parser = "parse_guest_account_generate",								parser_fun=parse_guest_account_generate								}, ---获取新创建的随机账号

	{ code = 999, 	parser = "parse_get_system_notice", 									parser_fun=parse_get_system_notice									},-- 返回系统公告(999)

	{ code = 1001,	parser = "parse_union_init",											parser_fun=parse_union_init											},		--返回公会初始化  (军团协议235 已修改为1001)
	{ code = 1002,	parser = "parse_union_list",											parser_fun=parse_union_list											},		--返回公会列表		(军团协议236 已修改为1002)
	{ code = 1003,	parser = "parse_union_quit_time",										parser_fun=parse_union_quit_time									},		--返回用户退会时间 (军团协议237 已修改为1003)
	{ code = 1004,	parser = "parse_union_persion_list",									parser_fun=parse_union_persion_list									},		--返回成员列表(军团协议238 已修改为1004)
	{ code = 1005,	parser = "parse_user_union_info",										parser_fun=parse_user_union_info									},		--返回用户公会信息(军团协议239 已修改为1005)
	{ code = 1006,	parser = "parse_union_examine_list",									parser_fun=parse_union_examine_list									},		--返回公会审核信息(军团协议245 已修改为1006)
	{ code = 1007,	parser = "parse_union_treasure_init",									parser_fun=parse_union_treasure_init								},		--返回公会珍品( 军团协议249 已修改为1007)
	{ code = 1008,	parser = "parse_union_prop_init",										parser_fun=parse_union_prop_init									},		--返回公会道具 ( 军团协议245 已修改为1008)  		
	{ code = 1009,	parser = "parse_union_counterpart_info",								parser_fun=parse_union_counterpart_info								},		--返回公会副本信息 (军团协议243 已修改为1009)
	{ code = 1010,	parser = "parse_union_message",											parser_fun=parse_union_message										},		--返回公会消息 (军团协议246 已修改为1010)
	{ code = 1011, 	parser = "parse_is_accept_friend", 										parser_fun=parse_is_accept_friend									},-- 返回是否可以加好友状态  (军团协议425 已修改为1011)
	{ code = 1012, 	parser = "parse_union_duplicate_npc_reward", 							parser_fun=parse_is_union_duplicate_npc_reward						},--  军团副本奖励领取状态（1012）
	{ code = 1013, 	parser = "parse_union_persion_member_info", 							parser_fun=parse_union_persion_member_info							},-- 返回公会成员增加信息 (427)(军团协议427 已修改为1013)
	{ code = 1014, 	parser = "parse_union_add_message", 									parser_fun=parse_union_add_message									},-- 返回新增动态 (428)(军团协议428 已修改为1014)
	{ code = 1015, 	parser = "parse_union_push_notification", 								parser_fun=parse_union_push_notification							},-- 返回公会推送消息（1015）
	{ code = 1016, 	parser = "parse_union_fight_init_message", 								parser_fun=parse_union_fight_init_message							},-- 返回公会战基础信息 1016
	{ code = 1017, 	parser = "parse_union_fight_member_message", 							parser_fun=parse_union_fight_member_message							},-- 返回公会战布阵成员列表 1017
	{ code = 1018, 	parser = "parse_union_fight_map_update", 								parser_fun=parse_union_fight_map_update								},-- 返回公会战地图变更 1018
	{ code = 1019, 	parser = "parse_union_fight_info_update", 								parser_fun=parse_union_fight_info_update							},-- 返回公会战基础信息变更 1019
	{ code = 1020, 	parser = "parse_union_fight_state", 									parser_fun=parse_union_fight_state									},-- 返回公会战状态 1020
	{ code = 1021, 	parser = "parse_union_fight_init", 										parser_fun=parse_union_fight_init									},-- 返回公会战初始化 1021
	{ code = 1022, 	parser = "parse_union_fight_result", 									parser_fun=parse_union_fight_result									},-- 返回公会战结果 1022
	{ code = 1023, 	parser = "parse_union_kick_out", 										parser_fun=parse_union_kick_out										},-- 被踢出工会 1023
	
	--战宠
	{ code = 1101,	parser = "parse_pet_formation",											parser_fun=parse_pet_formation										}, ---返回战宠上阵信息
	{ code = 1102,	parser = "parse_pet_soul_count",										parser_fun=parse_pet_soul_count										}, ---返回驯兽魂(1102)
	{ code = 1103,	parser = "parse_return_pet_shop_init",									parser_fun=parse_return_pet_shop_init								}, ---返回战宠商店(1103)
	{ code = 1104,	parser = "parse_pet_train_info",										parser_fun=parse_pet_train_info										}, ---返回战宠训练信息
	{ code = 1105,	parser = "parse_pet_arena_info",										parser_fun=parse_pet_arena_info										}, ---返回竞技场战宠信息
	{ code = 1106,	parser = "parse_pet_battle_field_info",									parser_fun=parse_pet_battle_field_info								}, ---返回战宠副本信息
	{ code = 1107,	parser = "parse_pet_look_at_user",										parser_fun=parse_pet_look_at_user									}, ---返回竞技场角色带宠物信息
	{ code = 1201,	parser = "parse_share_reward_info",										parser_fun=parse_share_reward_info									}, ---返回分享信息
	{ code = 1301,	parser = "parse_one_key_sweep_arena",									parser_fun=parse_one_key_sweep_arena								}, ---返回竞技场一键扫荡
	{ code = 1302,	parser = "parse_one_key_sweep_three_kingdoms",						    parser_fun=parse_one_key_sweep_three_kingdoms						}, ---返回扫荡无限山奖励
	{ code = 1303,	parser = "parse_one_key_sweep_three_kingdoms_max_pass",					parser_fun=parse_one_key_sweep_three_kingdoms_max_pass				}, ---返回无限山扫荡最大三星关卡
	{ code = 1401,	parser = "parse_limit_recharge_init",									parser_fun=parse_limit_recharge_init								}, ---返回限時優惠

	{ code = 1501,	parser = "parse_rebel_boss_state",										parser_fun=parse_rebel_boss_state									}, ---返回叛军BOSS开启状态
	{ code = 1502,	parser = "parse_rebel_boss_info_init",									parser_fun=parse_rebel_boss_info_init								}, ---返回限時優惠		
	{ code = 1503,	parser = "parse_rebel_boss_reward_info",								parser_fun=parse_rebel_boss_reward_info								}, ---返回叛军BOSS战斗奖励	
	--等级礼包
	{ code = 1601,	parser = "parse_level_gift_bag_status",									parser_fun=parse_level_gift_bag_status								}, ---返回等级礼包状态
	{ code = 1602,	parser = "parse_user_create_time",										parser_fun=parse_user_create_time									}, ---返回角色创建时间
	{ code = 1603,	parser = "parse_get_online_gift_info",									parser_fun=parse_get_online_gift_info								}, ---返回在線獎勵活動

	{ code = 2001,	parser = "parse_partner_bounty_init",									parser_fun=parse_partner_bounty_init								}, ---返回阵营招募初始化信息(2001)
	{ code = 2002,	parser = "parse_partner_bounty_get_return",								parser_fun=parse_partner_bounty_get_return							}, ---返回阵营招募获取信息（2002）

	{ code = 3001,	parser = "parse_capture_resource_map_init",								parser_fun=parse_capture_resource_map_init							}, ---地图分布(3001)
	{ code = 3002,	parser = "parse_capture_resource_map_info",								parser_fun=parse_capture_resource_map_info							}, ---地图初始化协议(3002) 
	{ code = 3003,	parser = "parse_capture_resource_change",								parser_fun=parse_capture_resource_change							}, ---建筑变更协议(3003)
	{ code = 3004,	parser = "parse_capture_resource_ower_info",							parser_fun=parse_capture_resource_ower_info							}, ---个人占领信息(3004)
	{ code = 3005,	parser = "parse_capture_resource_ower_info_change",						parser_fun=parse_capture_resource_ower_info_change					}, ---个人占领信息变更(3005)
	{ code = 3006,	parser = "parse_capture_resource_out_ship",								parser_fun=parse_capture_resource_out_ship							}, ---出战中的战船(3006)
	{ code = 3007,	parser = "parse_capture_resource_out_ship_change",						parser_fun=parse_capture_resource_out_ship_change					}, ---战船变更(3007)
	{ code = 3008,	parser = "parse_capture_resource_build_init",							parser_fun=parse_capture_resource_build_init						}, ---初始占领建筑数量(3008)
	{ code = 3009,	parser = "parse_capture_resource_notice",								parser_fun=parse_capture_resource_notice							}, ---资源抢夺推送通知(3009)
	{ code = 3010,	parser = "parse_capture_resource_reward",								parser_fun=parse_capture_resource_reward							}, ---当前建筑奖励数量(3010)
	{ code = 3011,	parser = "parse_hold_integral_init",									parser_fun=parse_hold_integral_init									}, ---返回用户竞技场分享状态 (5002)
	{ code = 3501,	parser = "parse_all_achieve_init",										parser_fun=parse_all_achieve_init									}, ---所有成就进度
	{ code = 3502,	parser = "parse_some_achieve_init",										parser_fun=parse_some_achieve_init									}, ---部分
    { code = 4001,	parser = "parse_gm_push_info",											parser_fun=parse_gm_push_info										}, ---后台消息推送
	{ code = 5001,	parser = "parse_fortune_info",											parser_fun=parse_fortune_info										}, --返回迎财神数据
	{ code = 5002,	parser = "parse_return_arena_can_share",								parser_fun=parse_return_arena_can_share								}, ---返回用户竞技场分享状态 (5002)
	-- red_lert 
	{ code = 5100,  parser = "parse_id_register", 											parser_fun=parse_id_register										},-- 返回防沉迷用户身份证和生日
	{ code = 5109,  parser = "parse_user_register_anti", 									parser_fun=parse_user_register_anti									},-- 返回用户是否注册
	{ code = 5103,  parser = "parse_user_login_at_time", 									parser_fun=parse_user_login_at_time									},-- 返回用户在线时间
	{ code = 6012,	parser = "parse_return_red_alert_formation",							parser_fun=parse_return_red_alert_formation							}, ---返回红警阵型 (6012)
	{ code = 6013,	parser = "parse_gem_duplicate_attack_times",							parser_fun=parse_gem_duplicate_attack_times							}, ---返回红警宝石副本攻击次数 (6013)
	{ code = 6014,	parser = "parse_weapon_house_attack_times",								parser_fun=parse_weapon_house_attack_times							}, ---返回红警兵器琢攻击次数 (6013)
	{ code = 6015,	parser = "parse_hero_soul_duplicate_attack_times",						parser_fun=parse_hero_soul_duplicate_attack_times					}, ---返回红警将魂副本攻击次数 (6015)
	{ code = 6020,	parser = "parse_user_scene_states",										parser_fun=parse_user_scene_states									}, ---返回红警用户NPC场景状态(6020)
	{ code = 6021,	parser = "parse_user_scene_change",										parser_fun=parse_user_scene_change									}, ---返回红警用户NPC场景变更(6021)
	{ code = 6022,	parser = "parse_user_npc_states",										parser_fun=parse_user_npc_states									}, ---返回红警用户NPC状态(6022)
	{ code = 6023,	parser = "parse_user_npc_change",										parser_fun=parse_user_npc_change									}, ---返回红警用户NPC状态变更(6023)
	{ code = 6024,	parser = "parse_user_prop_list",										parser_fun=parse_user_prop_list										}, ---返回红警用户道具列表(6024)
	{ code = 6025,	parser = "parse_user_prop_change_list",									parser_fun=parse_user_prop_change_list								}, ---返回红警用户道具增加(6025)
	{ code = 6026,	parser = "parse_user_prop_remove",										parser_fun=parse_user_prop_remove									}, ---返回红警用户道具移除(6026)
	{ code = 6027,	parser = "parse_return_all_user_equip",									parser_fun=parse_return_all_user_equip								}, ---返回红警所有装备(6027)
	{ code = 6028,	parser = "parse_return_add_user_equip",									parser_fun=parse_return_add_user_equip								}, ---返回红警装备增加(6028)
	{ code = 6029,	parser = "parse_return_remove_user_equip",								parser_fun=parse_return_remove_user_equip							}, ---返回红警装备移除 (6029)
	{ code = 6030,	parser = "parse_return_all_user_ship",									parser_fun=parse_return_all_user_ship								}, ---返回红警所有英雄 (6030)
	{ code = 6031,	parser = "parse_add_user_ship",											parser_fun=parse_add_user_ship										}, ---返回增加英雄 (6033)
	{ code = 6032,	parser = "parse_remove_user_ship",										parser_fun=parse_remove_user_ship									}, ---返回移除英雄 (6032)
	{ code = 6033,	parser = "parse_change_user_ship",										parser_fun=parse_change_user_ship									}, ---返回变更英雄 (6033)
	{ code = 6039,	parser = "parse_return_all_user_info",									parser_fun=parse_return_all_user_info								}, ---返回红警用户信息 (6039)
	{ code = 6040,	parser = "parse_return_recuit_times",									parser_fun=parse_return_recuit_times								}, ---返回红警z招募次数和时间 (6040)
	{ code = 6041,	parser = "parse_return_food_ready_buy_times",						    parser_fun=parse_return_food_ready_buy_times						}, ---返回体力已经购买次数(6041)
	{ code = 6042,	parser = "parse_return_server_review",						    		parser_fun=parse_return_server_review								}, ---返回服务器评审状态
	{ code = 6043,	parser = "parse_return_user_resource_change",						    parser_fun=parse_return_user_resource_change						}, ---返回用户资源变更

	--横扫千军 国战
	{ code = 6501,	parser = "parse_return_warfare_info",						    		parser_fun=parse_return_warfare_info								}, ---返回国战信息(6501)
	{ code = 6502,	parser = "parse_return_city_info",						    			parser_fun=parse_return_city_info									}, ---返回城池状态更新(6502)
	{ code = 6503,	parser = "parse_return_battle_result",						    		parser_fun=parse_return_battle_result								}, ---返回战斗结算(6503)
	{ code = 6504,	parser = "parse_return_self_warfare_info",						    	parser_fun=parse_return_self_warfare_info							}, ---返回国战个人信息(6504)
	{ code = 6505,	parser = "parse_return_warfare_order_info",						    	parser_fun=parse_return_warfare_order_info							}, ---返回号令发放信息(6505)
	{ code = 6506,	parser = "parse_return_warfare_city_info",						    	parser_fun=parse_return_warfare_city_info							}, ---返回城池信息(6506)
	{ code = 6507,	parser = "parse_return_warfare_formation_change",						parser_fun=parse_return_warfare_formation_change					}, ---返回自身血量更新(6507)
	{ code = 6508,	parser = "parse_return_warfare_news_info",						    	parser_fun=parse_return_warfare_news_info							}, ---返回战况信息(6508)
	{ code = 6509,	parser = "parse_return_battle_cooling_time",						    parser_fun=parse_return_battle_cooling_time							}, ---返回战斗冷却时间(6509)
	{ code = 6510,	parser = "parse_return_revive_cooling_time",						    parser_fun=parse_return_revive_cooling_time							}, ---返回死亡复活时间(6510)
	{ code = 6511,	parser = "parse_return_city_buff_info",						    		parser_fun=parse_return_city_buff_info								}, ---返回城池附加状态(6511)
	{ code = 6512,	parser = "parse_return_user_at_city_id_change",						    parser_fun=parse_return_user_at_city_id_change						}, ---返回个人城池地点变更(6512)
	{ code = 6513,	parser = "parse_return_city_fight_info",						    	parser_fun=parse_return_city_fight_info								}, ---返回城池军情(6513)
	{ code = 6514,	parser = "parse_return_warfare_task_info",						    	parser_fun=parse_return_warfare_task_info							}, ---返回国战任务信息(6514)
	{ code = 6515,	parser = "parse_return_warfare_fail_info",						    	parser_fun=parse_return_warfare_fail_info							}, ---返回战败信息(6515)
	{ code = 6516,	parser = "parse_return_outcome_of_the_battle_in_the_city",				parser_fun=parse_return_outcome_of_the_battle_in_the_city			}, ---返回城内战斗结果(6516)
	{ code = 6517,	parser = "parse_return_warfare_rank_info",								parser_fun=parse_return_warfare_rank_info							}, ---返回国战排行榜信息(6517)
	{ code = 6518,	parser = "parse_return_warfare_get_order_time",							parser_fun=parse_return_warfare_get_order_time						}, ---返回国战领旨时间(6518)
	{ code = 6519,	parser = "parse_return_warfare_get_order_task",							parser_fun=parse_return_warfare_get_order_task						}, ---返回国战领旨任务(6519)
	{ code = 6520,	parser = "parse_return_warfare_personal_card_info",						parser_fun=parse_return_warfare_personal_card_info					}, ---返回个人卡牌信息(6520)
	{ code = 6521,	parser = "parse_return_warfare_personal_buff_info",						parser_fun=parse_return_warfare_personal_buff_info					}, ---返回个人buff信息(6521)
	{ code = 6522,	parser = "parse_return_warfare_get_reward",								parser_fun=parse_return_warfare_get_reward							}, ---返回国战奖励(6522)
	{ code = 6523,	parser = "parse_return_warfare_my_fighting_info",						parser_fun=parse_return_warfare_my_fighting_info					}, ---返回个人战报信息(6523)
	{ code = 6524,	parser = "parse_return_open_server_days",								parser_fun=parse_return_open_server_days							}, ---返回开服天数(6524)

	--数码宝贝 排位赛
	{ code = 7001,	parser = "parse_warcraft_info_init_new",								parser_fun=parse_warcraft_info_init_new								}, ---排位赛初始化 (7001)
	{ code = 7002,	parser = "parse_warcraft_fights_info_new",								parser_fun=parse_warcraft_fights_info_new							}, ---对手信息 (7002)
	{ code = 7003,	parser = "parse_warcraft_rank_reward_new",								parser_fun=parse_warcraft_rank_reward_new							}, ---返回段位奖励领取状态 (7003)
	{ code = 7004,	parser = "parse_warcraft_fight_count_new",								parser_fun=parse_warcraft_fight_count_new							}, ---返回挑战次数信息 (7004)
	{ code = 7005,	parser = "parse_warcraft_fight_rush_new",								parser_fun=parse_warcraft_fight_rush_new							}, ---返回排位赛战斗后刷新信息 (7005)
	{ code = 7006,	parser = "parse_warcraft_shop_info_new",								parser_fun=parse_warcraft_shop_info_new								}, ---返回排位赛商店信息 (7006)
	{ code = 7007,	parser = "parse_warcraft_rank_info_new",								parser_fun=parse_warcraft_rank_info_new								}, ---返回排位赛排行榜信息 (7007)
	{ code = 7008,	parser = "parse_warcraft_win_count_info_new",							parser_fun=parse_warcraft_win_count_info_new						}, ---返回排位赛连胜奖励状态 (7008)
	{ code = 7009,	parser = "parse_warcraft_see_formation_new",							parser_fun=parse_warcraft_see_formation_new							}, ---返回查看信息 (7009)

	{ code = 8001,	parser = "parse_magic_trap_info",										parser_fun=parse_magic_trap_info									}, ---返回魔陷卡信息 (8001)
	{ code = 8002,	parser = "parse_user_magic_trap_info",									parser_fun=parse_user_magic_trap_info								}, ---返回用户魔陷卡信息 (8002)
	{ code = 8003,	parser = "parse_add_user_magic_trap_info",								parser_fun=parse_add_user_magic_trap_info							}, ---返回魔陷卡信息 (8003)
	{ code = 8004,	parser = "parse_remove_user_magic_trap_info",							parser_fun=parse_remove_user_magic_trap_info						}, ---返回魔陷卡信息 (8004)
	{ code = 8005,	parser = "parse_magic_trap_change",										parser_fun=parse_magic_trap_change									}, ---返回魔陷卡信息变更 (8005)
	{ code = 9001,	parser = "parse_awaken_shop_init",										parser_fun=parse_awaken_shop_init									}, ---返回觉醒商店初始化 (9001)
	{ code = 9002,	parser = "parse_ship_awaken_info",										parser_fun=parse_ship_awaken_info									}, ---返回英雄觉醒信息(9002)

	{ code = 10001,	parser = "parse_activity_rush_message",									parser_fun=parse_activity_rush_message								}, ---返回数码活动推送
	{ code = 11001,	parser = "parse_equipment_up_star_info",								parser_fun=parse_equipment_up_star_info								}, ---返回装备升星信息
	{ code = 11002,	parser = "parse_equipment_up_star_result",								parser_fun=parse_equipment_up_star_result							}, ---返回装备升星属性变化
	{ code = 12000,	parser = "parse_return_user_iron_number",								parser_fun=parse_return_user_iron_number							}, ---返回用户铁矿
	{ code = 12001,	parser = "parse_return_system_time",									parser_fun=parse_return_system_time									}, ---返回服务器时间
	{ code = 12002,	parser = "parse_return_user_levelex",									parser_fun=parse_return_user_levelex								}, ---返回经验值和等级变更
	{ code = 12003,	parser = "parse_return_pvp_formation_info",								parser_fun=parse_return_pvp_formation_info							}, ---返回PVP战斗玩家阵容信息
	{ code = 12004,	parser = "parse_return_pvp_user_info",									parser_fun=parse_return_pvp_user_info								}, ---返回PVP战斗玩家信息
	{ code = 12005,	parser = "parse_return_other_user_info",								parser_fun=parse_return_other_user_info								}, ---返回用户信息
	{ code = 12006,	parser = "parse_return_user_change_honor",								parser_fun=parse_return_user_change_honor							}, ---返回用户声望信息
	{ code = 12007,	parser = "parse_return_user_horse_spirit_patch",						parser_fun=parse_return_user_horse_spirit_patch						}, ---返回用户马魂碎片
	{ code = 12008,	parser = "parse_return_user_dragon_horse_patch",						parser_fun=parse_return_user_dragon_horse_patch						}, ---返回用户龙马碎片
	{ code = 12009,	parser = "parse_return_user_union_contribute",							parser_fun=parse_return_user_union_contribute						}, ---返回用户军团贡献
	{ code = 12010,	parser = "parse_return_user_all_gems",									parser_fun=parse_return_user_all_gems								}, ---返回用户军团贡献
	{ code = 12011,	parser = "parse_return_god_weaponry_open_state",						parser_fun=parse_return_god_weaponry_open_state						}, ---返回神将开启状态
	{ code = 12012,	parser = "parse_return_user_union_fight_exploit",						parser_fun=parse_return_user_union_fight_exploit					}, ---返回工会战战功值
	{ code = 12013,	parser = "parse_return_function_open_state",							parser_fun=parse_return_function_open_state							}, ---返回功能是否开启（个人战，七星台）
	{ code = 12014,	parser = "parse_return_user_oil_field",									parser_fun=parse_return_user_oil_field								}, ---返回油矿
	{ code = 12015,	parser = "parse_return_user_exploits",									parser_fun=parse_return_user_exploits								}, ---返回铅矿
	{ code = 12016,	parser = "parse_return_user_tiger_shaped",								parser_fun=parse_return_user_tiger_shaped							}, ---返回钛矿
	{ code = 12017,	parser = "parse_return_user_booming",									parser_fun=parse_return_user_booming								}, ---返回繁荣度
	{ code = 12018,	parser = "parse_return_user_credit",									parser_fun=parse_return_user_credit									}, ---返回声望
	{ code = 12019,	parser = "parse_return_user_credit_buy_state",							parser_fun=parse_return_user_credit_buy_state						}, ---返回声望购买状态
	{ code = 12020,	parser = "parse_return_user_war_industry",								parser_fun=parse_return_user_war_industry							}, ---返回用户军功信息
	{ code = 12021,	parser = "parse_return_user_command_level",								parser_fun=parse_return_user_command_level							}, ---返回用户统率升级信息
	{ code = 12022,	parser = "parse_return_user_famtion",									parser_fun=parse_return_user_famtion								}, ---返回用户带兵量信息
	{ code = 12023,	parser = "parse_return_formation_info",									parser_fun=parse_return_formation_info								}, ---返回用户阵形信息
	{ code = 12024,	parser = "parse_return_fighter_capacity",								parser_fun=parse_return_fighter_capacity							}, ---返回用户战力信息
	{ code = 12025,	parser = "parse_return_factor_info",									parser_fun=parse_return_factor_info									}, ---返回用户限时增益信息
	{ code = 12026,	parser = "parse_returns_the_user_avatar_activation_status",				parser_fun=parse_returns_the_user_avatar_activation_status			}, ---返回用户头像激活状态
	{ code = 12027,	parser = "parse_returns_the_user_avatar_information",					parser_fun=parse_returns_the_user_avatar_information				}, ---返回用户头像信息
	{ code = 12028,	parser = "parse_returns_the_user_attribute_addition_information",		parser_fun=parse_returns_the_user_attribute_addition_information	}, ---返回用户属性加成信息
	{ code = 12029,	parser = "parse_returns_user_function_push_info",						parser_fun=parse_returns_user_function_push_info					}, ---返回用户功能模块推送信息
	{ code = 12030,	parser = "parse_returns_complete_function_push_info",					parser_fun=parse_returns_complete_function_push_info				}, ---返回全服推送信息
	{ code = 12031,	parser = "parse_returns_mission_skip_info",								parser_fun=parse_returns_mission_skip_info							}, ---返回用户事件跳过记录
	{ code = 12032,	parser = "parse_returns_booming_info",									parser_fun=parse_returns_booming_info								}, ---返回繁荣度恢复信息
	{ code = 12033,	parser = "parse_returns_change_user_name",								parser_fun=parse_returns_change_user_name							}, ---返回用户昵称信息
	{ code = 12034,	parser = "parse_user_data_combine",										parser_fun=parse_user_data_combine									}, ---返回用户跨服数据合并中
	{ code = 12035,	parser = "parse_return_remove_factor_info",								parser_fun=parse_return_remove_factor_info							}, ---返回移除用户增益
	{ code = 12036,	parser = "parse_return_update_factor_info",								parser_fun=parse_return_update_factor_info							}, ---返回更新用户增益
	{ code = 12037,	parser = "parse_user_info_level_up",									parser_fun=parse_user_info_level_up									}, ---返回用户等级变更
	{ code = 12038,	parser = "parse_user_title_info",										parser_fun=parse_user_title_info									}, ---返回用户称号信息
	{ code = 12039,	parser = "parse_system_base_time",										parser_fun=parse_system_base_time									}, ---同步系统时区时间
	{ code = 12040,	parser = "parse_return_return_skill_points",							parser_fun=parse_return_return_skill_points							}, ---返回用户技能点信息
	{ code = 12041,	parser = "parse_seq_user_sign_info",									parser_fun=parse_seq_user_sign_info									}, ---返回用户签名
	{ code = 12042,	parser = "parse_return_ship_all_speed_info",							parser_fun=parse_return_ship_all_speed_info							}, ---返回战队总速度
	{ code = 12043,	parser = "parse_return_user_data_reset_info",							parser_fun=parse_return_user_data_reset_info						}, ---返回用户数据重置信息
	{ code = 12044,	parser = "parse_return_recruit_state",									parser_fun=parse_return_recruit_state								}, ---返回用户抽卡状态
	{ code = 12045, parser = "parse_linkage_check_server",									parser_fun=parse_linkage_check_server								}, -- 返回在hg登录后请求，如果返回服务器id大于0，则限定只能登陆这个服务器
	{ code = 12046, parser = "parse_title_open_stutas",										parser_fun=parse_title_open_stutas									}, ---返回头衔开启
	{ code = 12047, parser = "parse_essence_info",											parser_fun=parse_essence_info										}, ---返回精华数量
	{ code = 12048, parser = "parse_user_searchCoin",										parser_fun=parse_user_searchCoin									}, ---返回探索币
	{ code = 12049, parser = "parse_user_holy_thing_essence",								parser_fun=parse_user_holy_thing_essence							}, ---返回圣物精华
	{ code = 12050, parser = "parse_user_pokemon_explore_coin",								parser_fun=parse_user_pokemon_explore_coin							}, ---返回探索币(口袋)
	{ code = 12052, parser = "parse_user_return_open_tip",									parser_fun=parse_user_return_open_tip								}, ---返回老用户回归弹出状态
	{ code = 12053, parser = "parse_change_user_head_frame",								parser_fun=parse_change_user_head_frame								}, ---返回用户头像框信息


	{ code = 12100,	parser = "parse_return_user_home_build_info",							parser_fun=parse_return_user_home_build_info						}, ---返回用户建筑信息
	{ code = 12101,	parser = "parse_return_user_barracks_info",								parser_fun=parse_return_user_barracks_info							}, ---返回用户兵营科技信息
	{ code = 12102,	parser = "parse_return_majesty_info",									parser_fun=parse_return_majesty_info								}, ---返回主主公技信息
	{ code = 12103,	parser = "parse_return_fate_times",										parser_fun=parse_return_fate_times									}, ---返回祭祀次数
	{ code = 12104,	parser = "parse_return_user_all_max_packs",								parser_fun=parse_return_user_all_max_packs							}, ---返回资源容量上限
	{ code = 12105,	parser = "parse_return_production_info",								parser_fun=parse_return_production_info								}, ---返回生产信息
	{ code = 12106,	parser = "parse_return_build_auto_upgrade_state",						parser_fun=parse_return_build_auto_upgrade_state					}, ---返回自动建造信息
	{ code = 12107,	parser = "parse_return_resource_output_per_hour",						parser_fun=parse_return_resource_output_per_hour					}, ---返回用户资源产出信息
	{ code = 12108,	parser = "parse_return_warehouse_capacity",								parser_fun=parse_return_warehouse_capacity							}, ---返回用户资源仓库容量信息
	{ code = 12109,	parser = "parse_return_update_time_factor",								parser_fun=parse_return_update_time_factor							}, ---返回用户时间消耗增益信息
	{ code = 12110,	parser = "parse_home_build_level_up",									parser_fun=parse_home_build_level_up								}, ---返回建筑升级
	{ code = 12111,	parser = "parse_home_patrol_reward_info",								parser_fun=parse_home_patrol_reward_info							}, ---返回主城巡逻兵奖励信息

	{ code = 12200,	parser = "parse_return_user_gems",										parser_fun=parse_return_user_gems									}, ---返回用户宝石信息
	{ code = 12201,	parser = "parse_remove_user_gems",										parser_fun=parse_remove_user_gems									}, ---返回用户宝石移除
	{ code = 12202,	parser = "parse_return_other_user_gems",								parser_fun=parse_return_other_user_gems								}, ---返回其他用户宝石信息
	{ code = 12300,	parser = "parse_return_user_horses",									parser_fun=parse_return_user_horses									}, ---返回用户战马信息
	{ code = 12301,	parser = "parse_remove_user_horse",										parser_fun=parse_remove_user_horse									}, ---返回用户战马移除
	{ code = 12303,	parser = "parse_server_open_day_count_info",							parser_fun=parse_server_open_day_count_info							}, ---返回服务器开服天数
	
	{ code = 12320,	parser = "parse_return_user_horse_spirits",								parser_fun=parse_return_user_horse_spirits							}, ---返回用户马魂信息
	{ code = 12321,	parser = "parse_remove_user_horse_spirits",								parser_fun=parse_remove_user_horse_spirits									}, ---返回用户马魂移除
	{ code = 12340,	parser = "parse_return_user_horse_recuit_info",							parser_fun=parse_return_user_horse_recuit_info						}, ---返回用户战马招募
	{ code = 12342,	parser = "parse_return_other_user_horses",								parser_fun=parse_return_other_user_horses							}, ---返回其他用户珍兽信息
	{ code = 12343,	parser = "parse_return_other_user_horse_spirits",						parser_fun=parse_return_other_user_horse_spirits					}, ---返回其他用户兽魂信息
	{ code = 12400,	parser = "parse_return_three_kings_info",								parser_fun=parse_return_three_kings_info							}, ---返回三国无双信息
	{ code = 12401,	parser = "parse_return_three_kings_rank_info",							parser_fun=parse_return_three_kings_rank_info						}, ---返回三国无双排行信息
	{ code = 12402,	parser = "parse_open_new_scene",										parser_fun=parse_open_new_scene										}, ---返回场景开启信息
	{ code = 12403,	parser = "parse_god_weaponry_dup_info",									parser_fun=parse_god_weaponry_dup_info								}, ---返回神兵副本战斗次数
	{ code = 12404,	parser = "parse_returns_the_number_of_elapsed_copies_of_the_elite",		parser_fun=parse_returns_the_number_of_elapsed_copies_of_the_elite	}, ---返回精英副本重置次数
	{ code = 12405,	parser = "parse_user_scene_info_battle_state",							parser_fun=parse_user_scene_info_battle_state						}, ---返回用户副本战斗状态
	{ code = 12406,	parser = "parse_copy_clear_user_info",									parser_fun=parse_copy_clear_user_info								}, ---返回副本通关用户信息
	{ code = 12407,	parser = "parse_seq_hard_copy_user_formation",							parser_fun=parse_seq_hard_copy_user_formation						}, ---返回噩梦副本用户阵形
	{ code = 12408,	parser = "parse_reward_all_npcs_ex",									parser_fun=parse_reward_all_npcs_ex									}, ---返回所有领取过3星宝箱的NPC
	{ code = 12409,	parser = "parse_reward_npcs_ex",										parser_fun=parse_reward_npcs_ex										}, ---返回领取过3星宝箱的NPC

	{ code = 12500,	parser = "parse_return_raiders_cut",									parser_fun=parse_return_raiders_cut									}, ---返回斩将夺宝信息
	{ code = 12501,	parser = "parse_return_raiders_cut_other_info",							parser_fun=parse_return_raiders_cut_other_info						}, ---返回斩将夺宝用户信息
	{ code = 12502,	parser = "parse_return_soul_my_info",									parser_fun=parse_return_soul_my_info								}, ---返回用户英魂试炼信息
	{ code = 12503,	parser = "parse_return_soul_rank_info",									parser_fun=parse_return_soul_rank_info								}, ---返回英魂试炼排行信息
	{ code = 12504,	parser = "parse_return_user_ship_military_info",						parser_fun=parse_return_user_ship_military_info						}, ---返回用户运送军资信息
	{ code = 12505,	parser = "parse_return_other_user_ship_military_info",					parser_fun=parse_return_other_user_ship_military_info				}, ---返回其他用户信息
	{ code = 12506,	parser = "parse_user_buff_shop_buy_state",								parser_fun=parse_user_buff_shop_buy_state							}, ---返回所有商店购买信息
	{ code = 12507,	parser = "parse_city_resource_hold_init",								parser_fun=parse_city_resource_hold_init							}, ---返回攻城拔寨初始化
	{ code = 12508,	parser = "parse_city_resource_hold_notificate_city_change",				parser_fun=parse_city_resource_hold_notificate_city_change			}, ---返回攻城拔寨推送城池信息变更
	{ code = 12509,	parser = "parse_city_resource_hold_notificate_user_position",			parser_fun=parse_city_resource_hold_notificate_user_position		}, ---返回攻城拔寨推送用户的坐标
	{ code = 12510,	parser = "parse_city_resource_hold_resource",							parser_fun=parse_city_resource_hold_resource						}, ---返回城池资源信息
	{ code = 12511,	parser = "parse_city_resource_hold_resource_users",						parser_fun=parse_city_resource_hold_resource_users					}, ---返回某城池某资源信息
	{ code = 12512,	parser = "parse_city_resource_users_position",							parser_fun=parse_city_resource_users_position						}, ---返回单个采集信息
	{ code = 12513,	parser = "parse_city_resource_users_info",								parser_fun=parse_city_resource_users_info							}, ---返回玩家采集信息
	{ code = 12514,	parser = "parse_city_resource_hold_get_invites",						parser_fun=parse_city_resource_hold_get_invites						}, ---返回邀请信息
	{ code = 12515,	parser = "parse_city_resource_hold_add_invites",						parser_fun=parse_city_resource_hold_add_invites						}, ---新增邀请信息
	{ code = 12516,	parser = "parse_city_resource_robot",									parser_fun=parse_city_resource_robot								}, ---机器人信息
	{ code = 12517,	parser = "parse_city_resource_rank_list",								parser_fun=parse_city_resource_rank_list							}, ---资源占领点排行信息
	{ code = 12518,	parser = "parse_presonal_fighting_map_info",							parser_fun=parse_presonal_fighting_map_info							}, ---返回个人据点掠夺信息
	{ code = 12519,	parser = "parse_presonal_fighting_user_info",							parser_fun=parse_presonal_fighting_user_info						}, ---返回个人据点掠夺详细信息
	{ code = 12520,	parser = "parse_presonal_fighting_my_hp",								parser_fun=parse_presonal_fighting_my_hp							}, ---返回个人我方血量
	{ code = 12521,	parser = "parse_presonal_fighting_other_hp",							parser_fun=parse_presonal_fighting_other_hp							}, ---返回个人其他方血量
	{ code = 12522,	parser = "parse_presonal_fighting_lose_info",							parser_fun=parse_presonal_fighting_lose_info						}, ---返回个人战失败信息
	{ code = 12523,	parser = "parse_presonal_fighting_add_hp_cd",							parser_fun=parse_presonal_fighting_add_hp_cd						}, ---返回个人战恢复血量cd
	{ code = 12524,	parser = "parse_presonal_fighting_user_score",							parser_fun=parse_presonal_fighting_user_score						}, ---返回个人战当前积分
	{ code = 12525,	parser = "parse_presonal_fighting_other_user_info",						parser_fun=parse_presonal_fighting_other_user_info					}, ---返回查看其他玩家个人战信息
	{ code = 12526,	parser = "parse_return_answer_player_list",								parser_fun=parse_return_answer_player_list							}, ---返回学霸用户列表
	{ code = 12527,	parser = "parse_return_answer_update_player_list",						parser_fun=parse_return_answer_update_player_list					}, ---返回更新学霸用户信息
	{ code = 12528,	parser = "parse_return_answer_question_info",							parser_fun=parse_return_answer_question_info						}, ---返回学霸答题信息
	{ code = 12529,	parser = "parse_return_answer_choose_info",								parser_fun=parse_return_answer_choose_info							}, ---返回玩家答题信息
	{ code = 12530,	parser = "parse_return_user_expedition_info",							parser_fun=parse_return_user_expedition_info						}, ---返回用户远征信息
	{ code = 12531,	parser = "parse_return_user_expedition_shop_info",						parser_fun=parse_return_user_expedition_shop_info					}, ---返回用户远征商店信息
	{ code = 12532,	parser = "parse_return_user_expedition_integral",						parser_fun=parse_return_user_expedition_integral					}, ---返回用户远征积分更新
	{ code = 12533,	parser = "parse_return_user_extreme_info",								parser_fun=parse_return_user_extreme_info							}, ---返回用户极限挑战信息
	{ code = 12534,	parser = "parse_return_user_extreme_rank_info",							parser_fun=parse_return_user_extreme_rank_info						}, ---返回用户极限挑战排行信息
	{ code = 12535,	parser = "parse_return_user_extreme_reward",							parser_fun=parse_return_user_extreme_reward							}, ---返回用户极限挑战奖励结算
	{ code = 12536,	parser = "parse_return_enemy_strike_user_info",							parser_fun=parse_return_enemy_strike_user_info						}, ---返回用户敌军来袭信息
	{ code = 12537,	parser = "parse_return_enemy_strike_boss_info",							parser_fun=parse_return_enemy_strike_boss_info						}, ---返回敌军来袭boss信息
	{ code = 12538,	parser = "parse_return_enemy_strike_rank_info",							parser_fun=parse_return_enemy_strike_rank_info						}, ---返回敌军来袭排行榜信息
	{ code = 12539,	parser = "parse_return_enemy_strike_change_hp",							parser_fun=parse_return_enemy_strike_change_hp						}, ---返回敌军来袭boss血量变化
	{ code = 12540,	parser = "parse_return_enemy_strike_hurt_info",							parser_fun=parse_return_enemy_strike_hurt_info						}, ---返回敌军来袭伤害变化
	{ code = 12541,	parser = "parse_return_camp_pk_info",									parser_fun=parse_return_camp_pk_info								}, ---返回阵营对决信息
	{ code = 12542,	parser = "parse_return_camp_pk_user_info",								parser_fun=parse_return_camp_pk_user_info							}, ---返回用户阵营对决信息
	{ code = 12543,	parser = "parse_return_camp_pk_shop_info",								parser_fun=parse_return_camp_pk_shop_info							}, ---返回阵营对决商店信息
	{ code = 12544,	parser = "parse_return_camp_pk_rank_info",								parser_fun=parse_return_camp_pk_rank_info							}, ---返回阵营对决排行榜
	{ code = 12545,	parser = "parse_return_camp_pk_battle_info",							parser_fun=parse_return_camp_pk_battle_info							}, ---返回阵营对决战场初始化
	{ code = 12546,	parser = "parse_return_camp_pk_battle_stronghold_info",					parser_fun=parse_return_camp_pk_battle_stronghold_info				}, ---返回阵营对决战场据点信息
	{ code = 12547,	parser = "parse_return_camp_pk_battle_move_info",						parser_fun=parse_return_camp_pk_battle_move_info					}, ---返回阵营对决用户战场移动信息
	{ code = 12548,	parser = "parse_return_camp_pk_battle_user_info",						parser_fun=parse_return_camp_pk_battle_user_info					}, ---返回阵营对决用户战场基本信息
	{ code = 12549,	parser = "parse_return_camp_pk_battle_score_info",						parser_fun=parse_return_camp_pk_battle_score_info					}, ---返回阵营对决战场积分人数信息
	{ code = 12550,	parser = "parse_return_camp_pk_battle_event_info",						parser_fun=parse_return_camp_pk_battle_event_info					}, ---返回阵营对决战场事件列表
	{ code = 12551,	parser = "parse_return_camp_pk_battle_event_info_update",				parser_fun=parse_return_camp_pk_battle_event_info_update			}, ---返回阵营对决战场事件信息涂推送
	{ code = 12552,	parser = "parse_return_answer_reward_state",							parser_fun=parse_return_answer_reward_state							}, ---返回学霸之战奖励领取状态
	{ code = 12553,	parser = "parse_return_camp_pk_enter_battle",							parser_fun=parse_return_camp_pk_enter_battle						}, ---返回阵营战进入战斗场景
	{ code = 12554,	parser = "parse_return_limit_dekaron_enter_battle",						parser_fun=parse_return_limit_dekaron_enter_battle					}, ---返回极限挑战快速战斗进入战斗场景
	{ code = 12555,	parser = "parse_return_enemy_strike_reward_list",						parser_fun=parse_return_enemy_strike_reward_list					}, ---返回敌军来袭奖励列表
	{ code = 12556,	parser = "parse_ship_purify_init_info",									parser_fun=parse_ship_purify_init_info								}, ---返回武将净化初始化信息
	{ code = 12557,	parser = "parse_ship_purify_team_info",									parser_fun=parse_ship_purify_team_info								}, ---返回武将净化队伍信息
	{ code = 12558,	parser = "parse_seq_digital_trial_init_info",							parser_fun=parse_seq_digital_trial_init_info						}, ---返回数码试炼初始化信息
	{ code = 12559,	parser = "parse_digital_talent_state_info",								parser_fun=parse_digital_talent_state_info							}, ---返回数码天赋状态信息
	{ code = 12560,	parser = "parse_digital_spirit_state_info",								parser_fun=parse_digital_spirit_state_info							}, ---返回数码神精状态信息
	{ code = 12561,	parser = "parse_every_day_online_reward_times",							parser_fun=parse_every_day_online_reward_times						}, ---返回天降好礼领取次数
	{ code = 12562,	parser = "parse_every_day_online_reward_double",						parser_fun=parse_every_day_online_reward_double						}, ---返回天降好礼领取双倍
	{ code = 12563,	parser = "parse_artifact_info",											parser_fun=parse_artifact_info										}, ---返回神器信息
	{ code = 12564,	parser = "parse_artifact_culture_info",									parser_fun=parse_artifact_culture_info								}, ---返回神器培养信息
	{ code = 12565,	parser = "parse_artifact_achieve_info",									parser_fun=parse_artifact_achieve_info								}, ---返回成就信息
	{ code = 12566,	parser = "parse_constellation_get",										parser_fun=parse_constellation_get									}, ---返回星座信息
	{ code = 12567,	parser = "parse_constellation_buy",										parser_fun=parse_constellation_buy									}, ---返回购买星座信息
	{ code = 12568,	parser = "parse_constellation_exchange",								parser_fun=parse_constellation_exchange								}, ---返回使用星座信息

	-- 文件岛 start
	{ code = 12569,	parser = "parse_fileIslandEnter",										parser_fun=parse_fileIslandEnter									}, -- 进入文件岛
	{ code = 12570,	parser = "parse_fileIslandSearch",										parser_fun=parse_fileIslandSearch									}, -- 探索文件岛
	{ code = 12571,	parser = "parse_fileIslandSearchPointBuy",								parser_fun=parse_fileIslandSearchPointBuy							}, -- 购买探索点
	{ code = 12572,	parser = "parse_fileIslandBossInfo",									parser_fun=parse_fileIslandBossInfo									}, -- 获取团队Boss信息
	{ code = 12573,	parser = "parse_fileIslandTaskInfo",									parser_fun=parse_fileIslandTaskInfo									}, -- 获取好友任务信息
	{ code = 12574,	parser = "parse_fileIslandHolyThingsInfo",								parser_fun=parse_fileIslandHolyThingsInfo							}, -- 获取圣物信息
	{ code = 12575,	parser = "parse_file_island_boss_challenge",							parser_fun=parse_file_island_boss_challenge							}, -- 处理boss挑战
	{ code = 12576,	parser = "parse_fileIslandHolyThingUnlock",								parser_fun=parse_fileIslandHolyThingUnlock							}, -- 圣物解锁
	{ code = 12577,	parser = "parse_fileIslandHolyThingLevUp",								parser_fun=parse_fileIslandHolyThingLevUp							}, -- 圣物升级
	{ code = 12578,	parser = "parse_fileIslandTaskRelease",									parser_fun=parse_fileIslandTaskRelease								}, -- 任务邀请/发布
	{ code = 12579,	parser = "parse_fileIslandSingleChallenge",								parser_fun=parse_fileIslandSingleChallenge							}, -- 单人挑战
	{ code = 12580,	parser = "parse_fileIslandSingleChallengeCancle",						parser_fun=parse_fileIslandSingleChallengeCancle					}, -- 取消单人挑战
	{ code = 12581,	parser = "parse_fileIslandRewardBoxBuy",								parser_fun=parse_fileIslandRewardBoxBuy								}, -- 奖励宝箱购买
	{ code = 12582,	parser = "parse_fileIslandAnswer",										parser_fun=parse_fileIslandAnswer									}, -- 答题
	{ code = 12583,	parser = "parse_fileIslandFriendTaskJoin",								parser_fun=parse_fileIslandFriendTaskJoin							}, -- 加入好友任务
	{ code = 12584,	parser = "parse_fileIslandFriendTaskExecute",							parser_fun=parse_fileIslandFriendTaskExecute						}, -- 执行好友任务
	{ code = 12585,	parser = "parse_fileIslandFriendTaskReward",							parser_fun=parse_fileIslandFriendTaskReward							}, -- 好友任务奖励
	{ code = 12586,	parser = "parse_fileIslandShopInfo",									parser_fun=parse_fileIslandShopInfo									}, -- 商店信息
	{ code = 12587,	parser = "parse_fileIslandShopThingsBuy",								parser_fun=parse_fileIslandShopThingsBuy							}, -- 商店购买
	{ code = 12588,	parser = "parse_composeEquip",											parser_fun=parse_composeEquip										}, -- 合成装备
	{ code = 12589,	parser = "parse_fileIslandPushMessage",									parser_fun=parse_fileIslandPushMessage								}, -- 推送消息
	{ code = 12590,	parser = "parse_fileIslandRefreshSearchPoint",							parser_fun=parse_fileIslandRefreshSearchPoint						}, -- 刷新探索点
	{ code = 12591,	parser = "parse_file_island_clear_all_result",							parser_fun=parse_file_island_clear_all_result						}, -- 一键探索退出，探索结果清除
	-- 文件岛 end

	-- 探索
	{ code = 12593,	parser = "parse_pokemonExplore_info",									parser_fun=parse_pokemonExplore_info								}, -- 进入探索界面
	{ code = 12594,	parser = "parse_pokemonExplore_search",									parser_fun=parse_pokemonExplore_search								}, -- 返回探索信息
	{ code = 12595,	parser = "parse_pokemonExplore_buy_searchPoint",						parser_fun=parse_pokemonExplore_buy_searchPoint						}, -- 返回购买探索点
	{ code = 12596,	parser = "parse_pokemonExplore_boss_info",								parser_fun=parse_pokemonExplore_boss_info							}, -- 返回口袋探索好友Boss信息
	{ code = 12597,	parser = "parse_pokemonExplore_friend_tasks",							parser_fun=parse_pokemonExplore_friend_tasks						}, -- 返回口袋探索好友协作任务信息
	{ code = 12598,	parser = "parse_pokemonExplore_holyThings_info",						parser_fun=parse_pokemonExplore_holyThings_info						}, -- 返回口袋探索圣物信息
	{ code = 12599,	parser = "parse_pokemonExplore_boss_challenge",							parser_fun=parse_pokemonExplore_boss_challenge						}, -- 返回口袋探索挑战boss信息
	{ code = 12630,	parser = "parse_pokemonExplore_holyThing_unlock",						parser_fun=parse_pokemonExplore_holyThing_unlock					}, -- 返回口袋探索圣物解锁
	{ code = 12631,	parser = "parse_pokemonExplore_holyThing_levUp",						parser_fun=parse_pokemonExplore_holyThing_levUp						}, -- 返回口袋探索圣物升级
	{ code = 12632,	parser = "parse_pokemonExplore_friendTask_release",						parser_fun=parse_pokemonExplore_friendTask_release					}, -- 返回口袋探索好友协作任务发布
	{ code = 12633,	parser = "parse_pokemonExplore_single_challenge",						parser_fun=parse_pokemonExplore_single_challenge					}, -- 返回口袋探索个人挑战
	{ code = 12634,	parser = "parse_pokemonExplore_single_challenge_cancel",				parser_fun=parse_pokemonExplore_single_challenge_cancel				}, -- 返回口袋探索放弃个人挑战
	{ code = 12635,	parser = "parse_pokemonExplore_buy_box",								parser_fun=parse_pokemonExplore_buy_box								}, -- 返回口袋探索钻石购买宝箱
	{ code = 12636,	parser = "parse_pokemonExplore_answer",									parser_fun=parse_pokemonExplore_answer								}, -- 返回口袋探索答题
	{ code = 12637,	parser = "parse_pokemonExplore_join_friend_task",						parser_fun=parse_pokemonExplore_join_friend_task					}, -- 返回口袋探索进入好友任务
	{ code = 12638,	parser = "parse_pokemonExplore_execute_friend_task",					parser_fun=parse_pokemonExplore_execute_friend_task					}, -- 返回口袋探索执行好友任务
	{ code = 12639,	parser = "parse_pokemonExplore_reward_friend_task",						parser_fun=parse_pokemonExplore_reward_friend_task					}, -- 返回口袋探索领取好友任务奖励
	{ code = 12640,	parser = "parse_pokemonExplore_shop_info",								parser_fun=parse_pokemonExplore_shop_info							}, -- 返回口袋探索商店信息
	{ code = 12641,	parser = "parse_pokemonExplore_buy_shop_things",						parser_fun=parse_pokemonExplore_buy_shop_things						}, -- 返回口袋探索购买商店物品
	{ code = 12642,	parser = "parse_pokemonExplore_compose_equip",							parser_fun=parse_pokemonExplore_compose_equip						}, -- 返回口袋探索合成装备
	{ code = 12643,	parser = "parse_pokemonExplore_push_message",							parser_fun=parse_pokemonExplore_push_message						}, -- 口袋探索推送消息
	{ code = 12644,	parser = "parse_pokemonExplore_refresh_search_point",					parser_fun=parse_pokemonExplore_refresh_search_point				}, -- 口袋探索刷新探索点
	{ code = 12645,	parser = "parse_pokemonExplore_finish_search_result",					parser_fun=parse_pokemonExplore_finish_search_result				}, -- 口袋探索结束探索结果
	{ code = 12646,	parser = "parse_pokemonExplore_dispose_next_eventId",					parser_fun=parse_pokemonExplore_dispose_next_eventId				}, -- 口袋探索处理下一个探索事件类型
	{ code = 12647,	parser = "parse_pokemonExplore_score_reward",							parser_fun=parse_pokemonExplore_score_reward						}, -- 口袋探索领取积分奖励信息
    { code = 12648,	parser = "parse_seq_pokemonExplore_score_rank_info",				    parser_fun=parse_seq_pokemonExplore_score_rank_info 				}, ---接收返回探索排行榜信息
    { code = 12649,	parser = "parse_pokemonExplore_map_catch_buy",				    		parser_fun=parse_pokemonExplore_map_catch_buy 						}, ---接收口袋探索捕捉购买次数
    { code = 12650,	parser = "parse_pokemonExplore_map_catch_enter",				    	parser_fun=parse_pokemonExplore_map_catch_enter 					}, ---接收口袋探索捕捉进入
    { code = 12651,	parser = "parse_pokemonExplore_map_catch_hit",				    		parser_fun=parse_pokemonExplore_map_catch_hit 						}, ---接收口袋探索捕捉出手
    { code = 12652,	parser = "parse_pokemonExplore_map_catch_over",				    		parser_fun=parse_pokemonExplore_map_catch_over 						}, ---接收口袋探索捕捉结束
    { code = 12653,	parser = "parse_pokemonExplore_map_catch_cancel",				    	parser_fun=parse_pokemonExplore_map_catch_cancel 					}, ---接收口袋探索捕捉取消
    { code = 12654,	parser = "parse_pokemonExplore_event_touch",				    		parser_fun=parse_pokemonExplore_event_touch 						}, ---口袋探索事件触碰
    { code = 12655,	parser = "parse_pokemonExplore_single_event_finish",				    parser_fun=parse_pokemonExplore_single_event_finish					}, ---口袋探索单个事件结束

    { code = 12656,	parser = "parse_world_boss_personal_info",				    			parser_fun=parse_world_boss_personal_info							}, ---世界boss玩家数据
    { code = 12657,	parser = "parse_world_boss_personal_rank",				    			parser_fun=parse_world_boss_personal_rank							}, ---世界boss玩家排行
    { code = 12658,	parser = "parse_world_boss_info",				    					parser_fun=parse_world_boss_info									}, ---世界boss boss信息
    { code = 12659,	parser = "parse_world_boss_state",				    					parser_fun=parse_world_boss_state									}, ---世界boss boss状态
    { code = 12660,	parser = "parse_world_boss_union_rank",				    				parser_fun=parse_world_boss_union_rank								}, ---世界boss 工会排行榜

    { code = 12661,	parser = "parse_soul_warding_info",				    				    parser_fun=parse_soul_warding_info								    }, ---灵魂守卫
	{ code = 12662,	parser = "parse_illustration_info_init",				    			parser_fun=parse_illustration_info_init								}, ---卡册初始化
	{ code = 12663,	parser = "parse_illustration_info_init_active",				    		parser_fun=parse_illustration_info_init_active						}, ---卡册激活返回
	{ code = 12664,	parser = "parse_illustration_info_init_uplevel",				    	parser_fun=parse_illustration_info_init_uplevel						}, ---卡册升级返回

	{ code = 12665,	parser = "parse_illustration_info_rank",				    			parser_fun=parse_illustration_info_rank								}, ---卡册排行榜数据
	{ code = 12666,	parser = "parse_user_comb_card_info",				    			 	parser_fun=parse_user_comb_card_info								}, ---组合卡册数据

	{ code = 12667,	parser = "parse_world_boss_user_damage",				    			parser_fun=parse_world_boss_user_damage								}, ---返回世界BOSS用户造成的伤害

	{ code = 12668,	parser = "parse_all_biographies_info",				    				parser_fun=parse_all_biographies_info								}, ---用户所有激活列传信息
	{ code = 12669,	parser = "parse_single_biographies_info",				    			parser_fun=parse_single_biographies_info							}, ---用户单个列传信息
	{ code = 12670,	parser = "parse_biographies_achieve_info",				    			parser_fun=parse_biographies_achieve_info						}, ---用户成就信息
	{ code = 12671,	parser = "parse_biographies_chapter_info",				    			parser_fun=parse_biographies_chapter_info							}, ---用户篇章信息
	{ code = 12672,	parser = "parse_biographies_draw_info",				    				parser_fun=parse_biographies_draw_info								}, ---用户抽奖信息
	{ code = 12673,	parser = "parse_biographies_rank_info",				    				parser_fun=parse_biographies_rank_info								}, ---用户排行榜个人信息（跨服本服数据一致）
	{ code = 12674,	parser = "parse_biographies_draw_rewards_info",				    		parser_fun=parse_biographies_draw_rewards_info						}, ---奖励预览信息

	{ code = 12675,	parser = "parse_all_magical_animals_info",				    			parser_fun=parse_all_magical_animals_info							}, ---所有神兽信息
	{ code = 12676,	parser = "parse_single_magical_animals_info",				    		parser_fun=parse_single_magical_animals_info						}, ---单个神兽信息
	{ code = 12677,	parser = "parse_magical_animals_skill_info",				    		parser_fun=parse_magical_animals_skill_info							}, ---神兽技能信息
	{ code = 12678,	parser = "parse_magical_animals_fate_info",				    			parser_fun=parse_magical_animals_fate_info							}, ---神兽天命信息
	{ code = 12679,	parser = "parse_magical_animals_fate_task_info",				    	parser_fun=parse_magical_animals_fate_task_info						}, ---神兽天命任务信息
	{ code = 12680,	parser = "parse_seven_day_recharge_init_info",				    		parser_fun=parse_seven_day_recharge_init_info						}, ---七日连充初始化信息
	{ code = 12681,	parser = "parse_cash_vouchers_init_info",				    			parser_fun=parse_cash_vouchers_init_info							}, ---代金券初始化信息
	{ code = 12682,	parser = "parse_cash_vouchers_use_info",				    			parser_fun=parse_cash_vouchers_use_info								}, ---代金券使用返回信息
	{ code = 12683,	parser = "parse_cash_vouchers_get_info",				    			parser_fun=parse_cash_vouchers_get_info								}, ---代金券获得信息
	{ code = 12684,	parser = "parse_user_advertisement_info",				    			parser_fun=parse_user_advertisement_info							}, ---广告观看功能返回信息

	{ code = 12600,	parser = "parse_return_user_fight_rank_info",							parser_fun=parse_return_user_fight_rank_info						}, ---返回战力排行
	{ code = 12601,	parser = "parse_user_level_rank_info",									parser_fun=parse_user_level_rank_info								}, ---返回角色等级排行
	{ code = 12602,	parser = "parse_return_user_npc_rank_info",								parser_fun=parse_return_user_npc_rank_info							}, ---返回角色关卡排行
	{ code = 12603,	parser = "parse_return_user_exploit_rank_info",							parser_fun=parse_return_user_exploit_rank_info						}, ---返回角色军功排行
	{ code = 12604,	parser = "parse_return_to_the_user_own_ranking",						parser_fun=parse_return_to_the_user_own_ranking						}, ---返回用户自己排行
	{ code = 12605,	parser = "parse_return_the_number_of_cards",							parser_fun=parse_return_the_number_of_cards							}, ---返回卡牌数量排行
	{ code = 12606,	parser = "parse_return_to_the_strongest_card_list",						parser_fun=parse_return_to_the_strongest_card_list					}, ---返回最强数码兽排行
	{ code = 12607,	parser = "parse_user_three_kingdoms_score_rank_info",					parser_fun=parse_user_three_kingdoms_score_rank_info				}, ---返回用户数码试炼排行
	{ code = 12608,	parser = "parse_user_union_stick_crazy_adventure_progress_rank_info",	parser_fun=parse_user_union_stick_crazy_adventure_progress_rank_info	}, ---返回用户比利的棍子排行榜排行
	{ code = 12609,	parser = "parse_user_the_kings_battle_score_rank_info",					parser_fun=parse_user_the_kings_battle_score_rank_info	}, 				---返回用户王者之战排行榜排行
	{ code = 12610,	parser = "parse_user_achieve_score_rank_info",							parser_fun=parse_user_achieve_score_rank_info	}, 				       ---返回用户成就积分榜排行
	{ code = 12611,	parser = "parse_user_constellation_score_rank_info",					parser_fun=parse_user_constellation_score_rank_info	}, 				       ---返回用户成就积分榜排行
	{ code = 12612,	parser = "parse_world_grade",											parser_fun=parse_world_grade										}, ---返回世界等级
	{ code = 12620,	parser = "parse_explore_book_info",										parser_fun=parse_explore_book_info									}, ---登陆时接收探索图鉴信息
   
    { code = 12690,	parser = "parse_mega_info",								                parser_fun=parse_mega_info									        }, ---登陆时接收超进化信息

	{ code = 12700,	parser = "parse_return_arena_user_info",								parser_fun=parse_return_arena_user_info								}, ---返回竞技场初始化
	{ code = 12701,	parser = "parse_return_arena_user_change_info",							parser_fun=parse_return_arena_user_change_info						}, ---返回竞技场角色列表刷新
	{ code = 12702,	parser = "parse_return_arena_rank_info",								parser_fun=parse_return_arena_rank_info								}, ---返回竞技场战斗次数购买
	{ code = 12703,	parser = "parse_return_arena_lounch",									parser_fun=parse_return_arena_lounch								}, ---返回竞技场战斗请求
	{ code = 12704,	parser = "parse_return_arena_all_rank_info",							parser_fun=parse_return_arena_all_rank_info							}, ---返回竞技场总排行榜信息
	{ code = 12706,	parser = "parse_back_to_the_arena_store",								parser_fun=parse_back_to_the_arena_store							}, ---返回战地争霸商店信息
	{ code = 12707,	parser = "parse_return_to_the_arena_lucky_information",					parser_fun=parse_return_to_the_arena_lucky_information				}, ---返回战地争霸幸运排名信息
	{ code = 12710,	parser = "parse_the_kings_battle_init_info",							parser_fun=parse_the_kings_battle_init_info							}, ---返回王者之战的初始化信息
	{ code = 12711,	parser = "parse_the_kings_battle_user_info",							parser_fun=parse_the_kings_battle_user_info							}, ---返回王者之战的用户信息
	{ code = 12712,	parser = "parse_the_kings_battle_peakedness_duel_info",					parser_fun=parse_the_kings_battle_peakedness_duel_info				}, ---返回王者之战的巅峰对决的信息
	{ code = 12713,	parser = "parse_the_kings_battle_battle_report_info",					parser_fun=parse_the_kings_battle_battle_report_info				}, ---返回王者之战的战报推送信息
	{ code = 12714,	parser = "parse_the_kings_battle_match_info",							parser_fun=parse_the_kings_battle_match_info						}, ---返回王者之战的战半匹配信息
	{ code = 12715,	parser = "parse_arena_statistics",										parser_fun=parse_arena_statistics									}, ---返回竞技场数据统计
	{ code = 12800,	parser = "parse_return_mail_info",										parser_fun=parse_return_mail_info									}, ---返回邮件信息
	{ code = 12801,	parser = "parse_return_mail_delete",									parser_fun=parse_return_mail_delete									}, ---返回邮件删除
	{ code = 12802,	parser = "parse_return_mail_have_new",									parser_fun=parse_return_mail_have_new								}, ---返回有新邮件了
	{ code = 12900,	parser = "parse_return_user_tacks_info",								parser_fun=parse_return_user_tacks_info								}, ---返回所有任务信息
	{ code = 12901,	parser = "parse_return_change_user_tacks_info",							parser_fun=parse_return_change_user_tacks_info						}, ---返回任务改变
	{ code = 12902,	parser = "parse_return_remove_user_tacks_info",							parser_fun=parse_return_remove_user_tacks_info						}, ---返回任务移除
	{ code = 13000,	parser = "parse_return_activity_info",									parser_fun=parse_return_activity_info								}, ---返回活动信息
	{ code = 13001,	parser = "parse_return_activity_push_new_activity",						parser_fun=parse_return_activity_push_new_activity					}, ---返回新活动状态
	{ code = 13002,	parser = "parse_return_activity_info_change",							parser_fun=parse_return_activity_info_change						}, ---返回活动信息变更
	{ code = 13003,	parser = "parse_return_activity_rotary_info",							parser_fun=parse_return_activity_rotary_info						}, ---返回活动转盘奖励索引
	{ code = 13004,	parser = "parse_return_server_rank_info",								parser_fun=parse_return_server_rank_info							}, ---返回开服top
	{ code = 13005,	parser = "parse_return_activity_over_info",								parser_fun=parse_return_activity_over_info							}, ---返回活动关闭状态
	{ code = 13006,	parser = "parse_return_activity_cost_ratory_rank_message",				parser_fun=parse_return_activity_cost_ratory_rank_message			}, ---返回累计消费积分转盘活动消息
	{ code = 13007,	parser = "parse_return_activity_cost_ratory_rank_info",					parser_fun=parse_return_activity_cost_ratory_rank_info				}, ---返回累计消费积分转盘活动积分排行榜
	{ code = 13008,	parser = "parse_return_to_the_list_of_activities",						parser_fun=parse_return_to_the_list_of_activities					}, ---返回活动宝箱列表
	{ code = 13009,	parser = "parse_return_to_the_accessories_activity_ranking",			parser_fun=parse_return_to_the_accessories_activity_ranking			}, ---返回配件活动积分排行
	{ code = 13010,	parser = "parse_return_to_full_service",								parser_fun=parse_return_to_full_service								}, ---返回全服总军资
	{ code = 13011,	parser = "parse_return_to_the_integral_carousel",						parser_fun=parse_return_to_the_integral_carousel					}, ---返回积分转盘排行
	{ code = 13012,	parser = "parse_return_a_copy_of_the_legion",							parser_fun=parse_return_a_copy_of_the_legion						}, ---返回军团副本击破数
	{ code = 13013,	parser = "parse_return_all_rank_of_rankings",							parser_fun=parse_return_all_rank_of_rankings						}, ---返回所有军团副本排行
	{ code = 13014,	parser = "parse_return_union_total_contribute",							parser_fun=parse_return_union_total_contribute						}, ---返回军团总贡献
	{ code = 13015,	parser = "parse_return_spectral_decay_rank_exploits_order",				parser_fun=parse_return_spectral_decay_rank_exploits_order			}, ---返回摧枯拉朽军功排行榜
	{ code = 13016,	parser = "parse_return_fire_line_general_rank_score_order",				parser_fun=parse_return_fire_line_general_rank_score_order			}, ---返回火线将领招募积分排行榜
	{ code = 13017,	parser = "parse_return_military_pulpit_rank_score_order",				parser_fun=parse_return_military_pulpit_rank_score_order			}, ---返回军事讲坛的学分排行榜
	{ code = 13018,	parser = "parse_return_treasure_discount_store_info",					parser_fun=parse_return_treasure_discount_store_info				}, ---返回折扣卖场信息
	{ code = 13019,	parser = "parse_return_discount_store_transfer_number_change",			parser_fun=parse_return_discount_store_transfer_number_change		}, ---返回折扣卖场推送
	{ code = 13020,	parser = "parse_return_largesse_give_rank_score_order",					parser_fun=parse_return_largesse_give_rank_score_order				}, ---返回慷慨馈赠积分排行榜
	{ code = 13021,	parser = "parse_return_recharge_activity_rank",							parser_fun=parse_return_recharge_activity_rank						}, ---返回充值排行排行榜
	{ code = 13022,	parser = "parse_return_consume_activity_rank",							parser_fun=parse_return_consume_activity_rank						}, ---返回消费排行排行榜
	{ code = 13023,	parser = "parse_return_activity_params",								parser_fun=parse_return_activity_params								}, ---返回活动附加状态
	{ code = 13024,	parser = "parse_return_full_vitality_activity_rank",					parser_fun=parse_return_full_vitality_activity_rank					}, ---返回火力全开排行榜
	{ code = 13025,	parser = "parse_return_happy_buy_all_count_info",						parser_fun=parse_return_happy_buy_all_count_info					}, ---返回欢乐团购商品全服剩余数量
	{ code = 13026,	parser = "parse_return_happy_buy_record_info",							parser_fun=parse_return_happy_buy_record_info						}, ---返回欢乐团购购买记录
	{ code = 13027,	parser = "parse_return_carnival_hour_shop_list",						parser_fun=parse_return_carnival_hour_shop_list						}, ---返回狂欢时刻兑换下标
	{ code = 13028,	parser = "parse_return_leagion_online_reward_record",					parser_fun=parse_return_leagion_online_reward_record				}, ---返回军团在线奖励幸运记录
	{ code = 13029,	parser = "parse_return_festival_bless_activity_record",					parser_fun=parse_return_festival_bless_activity_record				}, ---返回节日祝福集福记录
	{ code = 13030,	parser = "parse_return_smoked_eggs_push_info",							parser_fun=parse_return_smoked_eggs_push_info						}, ---返回砸金蛋推送信息
	{ code = 13031,	parser = "parse_return_limited_time_box_score_rank",					parser_fun=parse_return_limited_time_box_score_rank					}, ---返回限时宝箱积分排行榜
	{ code = 13032,	parser = "parse_return_remove_activity_by_type",						parser_fun=parse_return_remove_activity_by_type						}, ---返回移除活动
	{ code = 13033,	parser = "parse_return_update_activity_day_discount_info",				parser_fun=parse_return_update_activity_day_discount_info			}, ---返回每日折扣信息
	{ code = 13034,	parser = "parse_return_recruit_activity_reward",						parser_fun=parse_return_recruit_activity_reward						}, ---机械邪龙兽来袭
	{ code = 13035,	parser = "parse_return_all_activity_banner_info",						parser_fun=parse_return_all_activity_banner_info					}, ---返回活动弹窗信息
	{ code = 13036,	parser = "parse_return_activity_treasures_notification_info",			parser_fun=parse_return_activity_treasures_notification_info		}, ---返回活动弹窗信息
    { code = 13037,	parser = "parse_return_activity_recharge_enter",			            parser_fun=parse_return_activity_recharge_enter	                 	}, ---跨服充值排行榜进入
    { code = 13038,	parser = "parse_return_activity_recharge_info",			                parser_fun=parse_return_activity_recharge_info		                }, ---跨服充值排行榜排行榜信息
    { code = 13039,	parser = "parse_return_activity_recharge_state",			            parser_fun=parse_return_activity_recharge_state	                	}, ---跨服充值排行榜活动状态

    { code = 13040,	parser = "parse_red_packet_enter_info",									parser_fun=parse_red_packet_enter_info								}, ---进入接收节日红包信息
    { code = 13041,	parser = "parse_red_packet_get_info",									parser_fun=parse_red_packet_get_info								}, ---领取红包排行榜
    
    { code = 13042,	parser = "parse_training_camp_init_info",							    parser_fun=parse_training_camp_init_info							}, ---大师训练营初始化
	{ code = 13043,	parser = "parse_rescue_station_rank_info",							    parser_fun=parse_rescue_station_rank_info							}, ---救助站排行榜
	{ code = 13046,	parser = "parse_activity_luckydivine_notification_info",				parser_fun=parse_activity_luckydivine_notification_info						}, ---开服7日排行榜
	{ code = 13047,	parser = "parse_activity_get_luckydivine_info",							parser_fun=parse_activity_get_luckydivine_info						}, ---开服7日排行榜
	{ code = 13048,	parser = "parse_activity_get_luckydivine_rank_info",					parser_fun=parse_activity_get_luckydivine_rank_info						}, ---开服7日排行榜
	{ code = 13049,	parser = "parse_lucky_pull_rod_init",					parser_fun=parse_lucky_pull_rod_init						}, ---幸运拉霸初始化
	{ code = 13050,	parser = "parse_lucky_pull_rod_start",					parser_fun=parse_lucky_pull_rod_start						}, ---开始拉霸
	{ code = 13051,	parser = "parse_get_lucky_pull_rod_lottery_record",					parser_fun=parse_get_lucky_pull_rod_lottery_record						}, ---获取拉霸活动抽奖记录
	{ code = 13052,	parser = "parse_activity_privilege_card_init",					parser_fun=parse_activity_privilege_card_init						}, ---特权卡信息初始化
	{ code = 13053,	parser = "parse_privilege_card_buy",							parser_fun=parse_privilege_card_buy						}, ---购买特权卡成功
	{ code = 13054,	parser = "parse_activity_privilege_card_get_reward",					parser_fun=parse_activity_privilege_card_get_reward						}, ---返回购买特权卡首冲奖励信息
	{ code = 13055,	parser = "parse_activity_old_user_back_seven_day_init",					parser_fun=parse_activity_old_user_back_seven_day_init				}, ---返回老用户回归七日登录活动初始化信息
	{ code = 13056,	parser = "parse_activity_old_user_back_seven_day_get_reward",			parser_fun=parse_activity_old_user_back_seven_day_get_reward		}, ---返回老用户回归七日登录活动领取奖励信息
	{ code = 13057,	parser = "parse_activity_old_user_back_recharge_init",					parser_fun=parse_activity_old_user_back_recharge_init				}, ---返回老用户回归充值活动初始化信息
	{ code = 13058,	parser = "parse_activity_old_user_back_recharge_get_reward",			parser_fun=parse_activity_old_user_back_recharge_get_reward			}, ---返回老用户回归充值活动领取奖励信息
	{ code = 13059,	parser = "parse_jin_pig_nabao_activity_extraction_information",			parser_fun=parse_jin_pig_nabao_activity_extraction_information		}, ---返回金猪纳宝活动抽取信息
	{ code = 13060,	parser = "parse_time_limit_jackpot_init",								parser_fun=parse_time_limit_jackpot_init		}, ---返回限时奖池初始化信息
	{ code = 13061,	parser = "parse_time_limit_jackpot_draw",								parser_fun=parse_time_limit_jackpot_draw		}, ---返回限时奖池抽奖信息
	{ code = 13062,	parser = "parse_time_limit_jackpot_rank",								parser_fun=parse_time_limit_jackpot_rank		}, ---返回限时奖池排行榜信息
	{ code = 13063,	parser = "parse_time_limit_jackpot_notice",								parser_fun=parse_time_limit_jackpot_notice		}, ---返回限时奖池跑马灯信息
	{ code = 13065,	parser = "parse_time_limit_jackpot_user_rank_info",						parser_fun=parse_time_limit_jackpot_user_rank_info		}, ---返回限时奖池我的排行信息
	{ code = 13066,	parser = "parse_lucky_match_init",										parser_fun=parse_lucky_match_init						}, ---返回排重福袋初始化信息
	{ code = 13068,	parser = "parse_time_lucky_match_notice",								parser_fun=parse_time_lucky_match_notice				}, ---返回排重福袋跑马灯信息
	{ code = 13069,	parser = "parse_lucky_match_get_reward",								parser_fun=parse_lucky_match_get_reward					}, ---返回排重福袋领取配对奖励信息
	{ code = 13070,	parser = "parse_lucky_match_exchange_prop",								parser_fun=parse_lucky_match_exchange_prop				}, ---返回排重福袋道具兑换信息
	{ code = 13071,	parser = "parse_private_custom_enter",									parser_fun=parse_private_custom_enter				}, ---返回私人定制信息
	{ code = 13072,	parser = "parse_egg_frenzy_init",										parser_fun=parse_egg_frenzy_init				}, ---返回彩蛋舞会信息
	{ code = 13073,	parser = "parse_egg_frenzy_reward",										parser_fun=parse_egg_frenzy_reward				}, ---返回彩蛋舞会砸蛋道具库
	{ code = 13074,	parser = "parse_summer_cool_weal_init",									parser_fun=parse_summer_cool_weal_init				}, ---返回夏日酷饮初始化信息
	{ code = 13075,	parser = "parse_summer_cool_weal_reward",								parser_fun=parse_summer_cool_weal_reward				}, ---返回夏日酷饮奖励信息
	{ code = 13076,	parser = "parse_secret_travel_init",									parser_fun=parse_secret_travel_init				}, ---返回秘境之旅初始化信息
	{ code = 13077,	parser = "parse_secret_travel_reward",									parser_fun=parse_secret_travel_reward				}, ---返回秘境之旅奖励信息

	{ code = 13078,	parser = "parse_command_world_run_house_info",							parser_fun=parse_command_world_run_house_info				}, ---返回号令天下跑马灯信息
	{ code = 13079,	parser = "parse_command_world_union_score_reward",						parser_fun=parse_command_world_union_score_reward				}, ---返回号令天下公会积分等级信息
	{ code = 13080,	parser = "parse_command_world_task",									parser_fun=parse_command_world_task				}, ---返回号令天下任务信息
	{ code = 13081,	parser = "parse_command_world_shop_info",								parser_fun=parse_command_world_shop_info				}, ---返回号令天下商店信息
	{ code = 13082,	parser = "parse_command_world_rank",									parser_fun=parse_command_world_rank				}, ---返回号令天下排行信息
	{ code = 13083,	parser = "parse_command_world_glory_info",								parser_fun=parse_command_world_glory_info				}, ---返回号令天下荣耀榜信息
	{ code = 13084,	parser = "parse_command_world_all_reward",								parser_fun=parse_command_world_all_reward				}, ---返回号令天下所有奖励信息
	{ code = 13085,	parser = "parse_command_world_end_time",								parser_fun=parse_command_world_end_time				}, ---返回号令天下本服/跨服排行结束时间信息

	{ code = 13086,	parser = "parse_command_half_the_ritual_init",							parser_fun=parse_command_half_the_ritual_init				}, ---半月礼活动返回信息

	{ code = 13087,	parser = "parse_command_activity_group_buy_person_buy_info",							parser_fun=parse_command_activity_group_buy_person_buy_info				}, ---超值团购活动充值团购信息
	{ code = 13088,	parser = "parse_command_activity_group_buy_group_buy_info",							parser_fun=parse_command_activity_group_buy_group_buy_info				}, ---超值团购活动团购礼包信息
	{ code = 13089,	parser = "parse_command_activity_group_buy_server_achievement_info",							parser_fun=parse_command_activity_group_buy_server_achievement_info				}, ---超值团购活动服务器团购礼包成就信息
	{ code = 13090,	parser = "parse_command_activity_group_buy_person_achievement_info",							parser_fun=parse_command_activity_group_buy_person_achievement_info				}, ---超值团购活动个人团购礼包成就信息

	{ code = 13091,	parser = "parse_limit_blessing_init_info",								parser_fun=parse_limit_blessing_init_info				}, ---限时祈愿初始化接口
	{ code = 13092,	parser = "parse_limit_blessing_set",									parser_fun=parse_limit_blessing_set						}, ---返回设置祈福奖励
	{ code = 13093,	parser = "parse_limit_blessing_get_blessing_reward",					parser_fun=parse_limit_blessing_get_blessing_reward		}, ---返回祈福值信息
	{ code = 13094,	parser = "parse_limit_blessing_set_spree_reward",						parser_fun=parse_limit_blessing_set_spree_reward		}, ---返回设置礼包奖励
	{ code = 13095,	parser = "parse_limit_blessing_get_task_reward",						parser_fun=parse_limit_blessing_get_task_reward			}, ---返回祈福任务信息	
	{ code = 13096,	parser = "parse_limit_blessing_match_notice",							parser_fun=parse_limit_blessing_match_notice			}, ---限时祈福跑马灯信息

	{ code = 13097,	parser = "parse_lucky_turntable_init_info",								parser_fun=parse_lucky_turntable_init_info			}, ---返回圣诞奇缘初始化
	{ code = 13098,	parser = "parse_lucky_turntable_draw_info",								parser_fun=parse_lucky_turntable_draw_info			}, ---返回圣诞奇缘转盘抽奖
	{ code = 13099,	parser = "parse_lucky_turntable_open_chest",							parser_fun=parse_lucky_turntable_open_chest			}, ---返回圣诞奇缘转盘开宝箱
	{ code = 13100,	parser = "parse_lucky_turntable_flash",									parser_fun=parse_lucky_turntable_flash				}, ---返回圣诞奇缘重置幸运转盘
	{ code = 13101,	parser = "parse_lucky_turntable_buy_prop",								parser_fun=parse_lucky_turntable_buy_prop			}, ---返回圣诞奇缘购买商城物品
	
	{ code = 13102,	parser = "parse_celebration_order_init",								parser_fun=parse_celebration_order_init				}, ---返回新服庆典初始化
	{ code = 13103,	parser = "parse_celebration_order_get_order",							parser_fun=parse_celebration_order_get_order		}, ---返回新服庆典获取排行榜接口
	{ code = 13104,	parser = "parse_celebration_order_get_order_reward",					parser_fun=parse_celebration_order_get_order_reward	}, ---返回新服庆典获取排行榜成就奖励
	{ code = 13105,	parser = "parse_celebration_order_get_achieve",							parser_fun=parse_celebration_order_get_achieve	}, 	   ---返回新服庆典获取用户成就任务详情

	{ code = 13106,	parser = "parse_normal_war_order_info",									parser_fun=parse_normal_war_order_info				}, ---返回常规战令信息
	{ code = 13107,	parser = "parse_normal_national_welfare",								parser_fun=parse_normal_national_welfare			}, ---返回常规战令全民福利信息
	{ code = 13108,	parser = "parse_construction_war_order_info",							parser_fun=parse_construction_war_order_info		}, ---返回建号战令初始化信息
	{ code = 13109,	parser = "parse_construction_national_welfare",							parser_fun=parse_construction_national_welfare		}, ---返回建号战令全民福利信息
	{ code = 13110,	parser = "parse_construction_war_order_shop",							parser_fun=parse_construction_war_order_shop		}, ---返回建号战令商店信息
	{ code = 13111,	parser = "parse_war_order_exp",											parser_fun=parse_war_order_exp						}, ---返回建号战令商店信息

	{ code = 13112,	parser = "parse_monopoly_init_data",									parser_fun=parse_monopoly_init_data					}, ---返回大富翁初始化
	{ code = 13113,	parser = "parse_monopoly_cell_dice",									parser_fun=parse_monopoly_cell_dice					}, ---返回大富翁用户投掷
	{ code = 13114,	parser = "parse_monopoly_move_info",									parser_fun=parse_monopoly_move_info					}, ---返回大富翁用户传送
	{ code = 13115,	parser = "parse_monopoly_achive_info",									parser_fun=parse_monopoly_achive_info				}, ---返回大富翁成就数据
	{ code = 13116,	parser = "parse_monopoly_get_reward_history",							parser_fun=parse_monopoly_get_reward_history		}, ---返回大富翁获取奖励记录

	{ code = 13117,	parser = "parse_cross_time_limit_jackpot_init",							parser_fun=parse_cross_time_limit_jackpot_init				}, ---返回跨服限时奖池初始化信息
	{ code = 13118,	parser = "parse_cross_time_limit_jackpot_draw",							parser_fun=parse_cross_time_limit_jackpot_draw				}, ---返回跨服限时奖池抽奖信息
	{ code = 13119,	parser = "parse_cross_time_limit_jackpot_rank",							parser_fun=parse_cross_time_limit_jackpot_rank				}, ---返回跨服限时奖池排行榜信息
	{ code = 13120,	parser = "parse_cross_time_limit_jackpot_notice",						parser_fun=parse_cross_time_limit_jackpot_notice			}, ---返回跨服限时奖池跑马灯信息
	{ code = 13121,	parser = "parse_cross_time_limit_jackpot_user_rank_info",				parser_fun=parse_cross_time_limit_jackpot_user_rank_info	}, ---返回跨服限时奖池我的排行信息
	
	{ code = 13122,	parser = "parse_time_limit_lottery_init",								parser_fun=parse_time_limit_lottery_init	}, ---返回限时抽奖初始化数据
	{ code = 13123,	parser = "parse_time_limit_lottery_user_info",							parser_fun=parse_time_limit_lottery_user_info	}, ---返回限时抽奖用户信息
	{ code = 13124,	parser = "parse_time_limit_lottery_log",								parser_fun=parse_time_limit_lottery_log	}, ---返回限时抽奖用户抽卡记录
	
	{ code = 13125,	parser = "parse_mysterious_egg_task_info",								parser_fun=parse_mysterious_egg_task_info	},---返回彩蛋任务完成情况
	{ code = 13126,	parser = "parse_mysterious_egg_reward_info",							parser_fun=parse_mysterious_egg_reward_info	},---返回彩蛋领奖情况
	
	{ code = 13127,	parser = "parse_activate_first_charge",									parser_fun=parse_activate_first_charge},---返回首冲重塑初始化信息
	{ code = 13128,	parser = "parse_monthly_card_receive",									parser_fun=parse_monthly_card_receive},---返回月卡重塑状态信息

	{ code = 13129,	parser = "parse_open_carnival",											parser_fun=parse_open_carnival},	---返回开服狂欢重塑初始化信息

	{ code = 14000,	parser = "parse_return_all_chat_info",									parser_fun=parse_return_all_chat_info								}, ---返回聊天信息
	{ code = 14001,	parser = "parse_return_game_message_info",								parser_fun=parse_return_game_message_info							}, ---GM推送信息
	{ code = 14002,	parser = "parse_return_red_envelopes_info",								parser_fun=parse_return_red_envelopes_info							}, ---红包信息
	{ code = 14003,	parser = "parse_return_system_push_info",								parser_fun=parse_return_system_push_info							}, ---返回系统推送状态
	{ code = 14004,	parser = "parse_return_resource_update_tips",							parser_fun=parse_return_resource_update_tips						}, ---返回资源更新提示
	{ code = 14005,	parser = "parse_return_system_special_tips",							parser_fun=parse_return_system_special_tips							}, ---返回系统特殊提示
	{ code = 14100,	parser = "parse_read_all_other_ship_info",								parser_fun=parse_read_all_other_ship_info							}, ---返回其他用户英雄信息
	{ code = 14101,	parser = "parse_red_alert_union_team_fight_ship_info",					parser_fun=parse_red_alert_union_team_fight_ship_info				}, ---返回组队争霸战船实例数据
	{ code = 14103,	parser = "parse_red_alert_time_ship_count_change",						parser_fun=parse_red_alert_time_ship_count_change					}, ---返回坦克数量减少信息
	{ code = 14104,	parser = "parse_seq_user_ship_evolution_status_info",					parser_fun=parse_seq_user_ship_evolution_status_info				}, ---返回玩家英雄进化信息
	{ code = 14105,	parser = "parse_return_user_ship_experience_change",					parser_fun=parse_return_user_ship_experience_change					}, ---返回武将经验变更信息
	{ code = 14106,	parser = "parse_user_ship_soul_state_info_change",						parser_fun=parse_user_ship_soul_state_info_change					}, ---返回武将斗魂信息变更
	{ code = 14107,	parser = "parse_return_user_rebirth_ship_reward_info",					parser_fun=parse_return_user_rebirth_ship_reward_info				}, ---返回武将重生初始化
	{ code = 14108,	parser = "parse_return_user_ship_change_ex",							parser_fun=parse_return_user_ship_change_ex							}, ---返回战船批量属性变更
	{ code = 14109,	parser = "parse_return_user_ship_praise_state",							parser_fun=parse_return_user_ship_praise_state						}, ---返回自己的点赞状态
	{ code = 14110,	parser = "parse_return_ship_praise_rank_info",							parser_fun=parse_return_ship_praise_rank_info						}, ---返回武将点赞排行信息
	{ code = 14111,	parser = "parse_user_alloy_matrix_info",								parser_fun=parse_user_alloy_matrix_info								}, ---返回数码合金信息
	{ code = 14112,	parser = "parse_user_alloy_matrix_info_change",							parser_fun=parse_user_alloy_matrix_info_change						}, ---返回数码合金信息变化
	{ code = 14113,	parser = "parse_alloy_matrix_get_reword",								parser_fun=parse_alloy_matrix_get_reword							}, ---返回数码合金抽卡信息

	{ code = 14114,	parser = "parse_alloy_matrix_delete",									parser_fun=parse_alloy_matrix_delete								}, ---返回数码合金删除
	{ code = 14115,	parser = "parse_alloy_matrix_property_change",							parser_fun=parse_alloy_matrix_property_change						}, ---返回数码合金属性变更信息
	{ code = 14116,	parser = "parse_skin_exchange_info",							        parser_fun=parse_skin_exchange_info									}, ---返回数码合金属性变更信息
	{ code = 14117,	parser = "parse_silkbag_pack_info",							        	parser_fun=parse_silkbag_pack_info									}, ---返回锦囊背包信息
	{ code = 14118,	parser = "parse_silkbag_resolve_info",							        parser_fun=parse_silkbag_resolve_info								}, ---返回锦囊分解信息

	{ code = 14120,	parser = "parse_combine_ship_unlock_card",							    parser_fun=parse_combine_ship_unlock_card							}, ---返回解锁组合卡信息
	{ code = 14121,	parser = "parse_combine_card_list_info",								parser_fun=parse_combine_card_list_info								}, ---返回组合卡信息初始化
	{ code = 14123,	parser = "parse_combine_ship_change_slot",							    parser_fun=parse_combine_ship_change_slot							}, ---返回更改组合卡槽位角色信息
	{ code = 14127,	parser = "parse_combine_ship_field_expansion",							parser_fun=parse_combine_ship_field_expansion						}, ---返回组合卡上阵栏位扩展
	{ code = 14128,	parser = "parse_combine_ship_get_one",									parser_fun=parse_combine_ship_get_one								}, ---返回获取单个组合卡信息
	{ code = 14129,	parser = "parse_combine_ship_prop_receive",								parser_fun=parse_combine_ship_prop_receive							}, ---返回组合卡道具领取信息

	{ code = 14130, parser = "parser_fight_spirit_infos",									parser_fun=parser_fight_spirit_infos								}, ---所有战魂信息
	{ code = 14131, parser = "parse_ship_fight_spirit_infos",								parser_fun=parse_ship_fight_spirit_infos							}, ---所有角色战魂信息
	{ code = 14132, parser = "parser_fight_spirit_info",									parser_fun=parser_fight_spirit_info									}, ---单个战魂信息
	{ code = 14133, parser = "parse_ship_fight_spirit_info",								parser_fun=parse_ship_fight_spirit_info								}, ---单个角色战魂信息
	{ code = 14134, parser = "parse_delete_fight_spirit",									parser_fun=parse_delete_fight_spirit								}, ---战魂删除


	{ code = 14200,	parser = "parse_return_all_other_user_equip",							parser_fun=parse_return_all_other_user_equip						}, ---返回其他用户装备信息
	{ code = 14201,	parser = "parse_return_user_equip_clear_info",							parser_fun=parse_return_user_equip_clear_info						}, ---返回装备洗练信息
	{ code = 14202,	parser = "parse_return_user_all_equip_clear_info",						parser_fun=parse_return_user_all_equip_clear_info					}, ---返回初始化装备洗练信息
	{ code = 14203,	parser = "parse_return_equipment_strength_result",						parser_fun=parse_return_equipment_strength_result					}, ---返回装备强化结果信息
	{ code = 14204,	parser = "parse_return_user_armor_info",						    	parser_fun=parse_return_user_armor_info								}, ---返回装甲生产信息
	{ code = 14205,	parser = "parse_return_armor_pve_info",									parser_fun=parse_return_armor_pve_info								}, ---返回装甲副本信息
	{ code = 14206,	parser = "parse_return_new_equip_batch_add",							parser_fun=parse_return_new_equip_batch_add							}, ---返回新的装备批量增加
	{ code = 14207,	parser = "parse_return_equipment_harden_info",							parser_fun=parse_return_equipment_harden_info						}, ---返回装备淬炼信息
	{ code = 14208,	parser = "parse_return_equipment_harden_boom_info",						parser_fun=parse_return_equipment_harden_boom_info					}, ---返回装备淬炼暴击信息


	{ code = 14300,	parser = "parse_get_socket_service_url",								parser_fun=parse_get_socket_service_url								}, ---返回socket service URL
	{ code = 14301,	parser = "parse_init_user_socket_service",								parser_fun=parse_init_user_socket_service							}, ---返回长连成功信息
	{ code = 14302,	parser = "parse_reconnect_socket",										parser_fun=parse_reconnect_socket									}, ---断线重新连接网络

	{ code = 14600,	parser = "parse_red_alert_union_list",									parser_fun=parse_red_alert_union_list								}, ---返回工会列表
	{ code = 14601,	parser = "parse_red_alert_union_rank",									parser_fun=parse_red_alert_union_rank								}, ---返回工会排行
	{ code = 14602,	parser = "parse_red_alert_user_union",									parser_fun=parse_red_alert_user_union								}, ---返回用户工会信息
	{ code = 14603,	parser = "parse_red_alert_union_info",									parser_fun=parse_red_alert_union_info								}, ---返回工会信息
	{ code = 14604,	parser = "parse_red_alert_union_member_info",							parser_fun=parse_red_alert_union_member_info						}, ---返回工会成员信息
	{ code = 14605,	parser = "parse_red_alert_union_apply_list",							parser_fun=parse_red_alert_union_apply_list							}, ---返回工会申请列表
	{ code = 14606,	parser = "parse_red_alert_union_message_info",							parser_fun=parse_red_alert_union_message_info						}, ---返回工会动态信息
	{ code = 14607,	parser = "parse_red_alert_union_team_fight_info",						parser_fun=parse_red_alert_union_team_fight_info					}, ---返回工会争霸队伍信息
	{ code = 14608,	parser = "parse_red_alert_union_other_member",							parser_fun=parse_red_alert_union_other_member						}, ---返回其他工会成员
	{ code = 14609,	parser = "parse_red_alert_union_get_physical_info",						parser_fun=parse_red_alert_union_get_physical_info					}, ---阿希拉之战队伍信息
	{ code = 14610,	parser = "parse_red_alert_union_stronghold_info",						parser_fun=parse_red_alert_union_stronghold_info					}, ---公会据点占领信息
	{ code = 14611,	parser = "parse_red_alert_union_fight_city_info",						parser_fun=parse_red_alert_union_fight_city_info					}, ---单个公会城池据点初始化
	{ code = 14612,	parser = "parse_red_alert_owner_union_fight_city_info",					parser_fun=parse_red_alert_owner_union_fight_city_info				}, ---玩家公会城池据点信息
	{ code = 14613,	parser = "parse_red_alert_union_fight_city_one_battle_result",			parser_fun=parse_red_alert_union_fight_city_one_battle_result		}, ---返回公会据点内战斗信息
	{ code = 14614,	parser = "parse_red_alert_union_fight_city_result",						parser_fun=parse_red_alert_union_fight_city_result					}, ---返回公会据点最终结算
	{ code = 14615,	parser = "parse_red_alert_union_fight_city_report_add",					parser_fun=parse_red_alert_union_fight_city_report_add				}, ---返回公会战报推送
	{ code = 14616,	parser = "parse_red_alert_union_fight_move_city",						parser_fun=parse_red_alert_union_fight_move_city					}, ---返回公会战角色移动
	{ code = 14617,	parser = "parse_red_alert_union_fight_city_report_init",				parser_fun=parse_red_alert_union_fight_city_report_init				}, ---返回初始化公会战报
	{ code = 14618,	parser = "parse_red_alert_union_fight_city_state",						parser_fun=parse_red_alert_union_fight_city_state					}, ---返回工会战状态
	{ code = 14619,	parser = "parse_red_alert_union_fight_attack_rank_list",				parser_fun=parse_red_alert_union_fight_attack_rank_list				}, ---返回工会战竞价信息初始化
	{ code = 14620,	parser = "parse_red_alert_union_fight_attack_rank_info",				parser_fun=parse_red_alert_union_fight_attack_rank_info				}, ---返回工会战竞价信息变更
	{ code = 14621,	parser = "parse_union_stronghold_battle_result",						parser_fun=parse_union_stronghold_battle_result						}, ---返回公会战单场战斗结果信息
	{ code = 14622,	parser = "parse_union_stronghold_battle_details",						parser_fun=parse_union_stronghold_battle_details					}, ---返回公会战城池战斗详情信息
	{ code = 14623,	parser = "parse_union_stronghold_formation_info",						parser_fun=parse_union_stronghold_formation_info					}, ---返回公会战城池阵容信息
	{ code = 14624,	parser = "parse_union_stronghold_user_hp_info",							parser_fun=parse_union_stronghold_user_hp_info						}, ---返回公会战个人血量信息
	{ code = 14625,	parser = "parse_red_alert_union_stronghold_reward",						parser_fun=parse_red_alert_union_stronghold_reward					}, ---返回公会战城池奖励信息
	{ code = 14626,	parser = "parse_return_union_first_join_reward",						parser_fun=parse_return_union_first_join_reward						}, ---返回军团首次加入奖励状态
	{ code = 14627,	parser = "parse_return_union_science_info",								parser_fun=parse_return_union_science_info							}, ---返回军团科技状态列表
	{ code = 14628,	parser = "parse_return_union_shop_info",								parser_fun=parse_return_union_shop_info								}, ---返回军团商店列表
	{ code = 14629,	parser = "parse_return_union_active_info",								parser_fun=parse_return_union_active_info							}, ---返回军团活跃信息
	{ code = 14630,	parser = "parse_union_copy_init",											parser_fun=parse_union_copy_init									}, ---返回军团副本初始化
	{ code = 14631,	parser = "parse_return_union_event_add",								parser_fun=parse_return_union_event_add								}, ---返回军团事件增加
	{ code = 14632,	parser = "parse_return_union_hegemony_info",							parser_fun=parse_return_union_hegemony_info							}, ---返回军团争霸信息
	{ code = 14633,	parser = "parse_red_alert_union_hegemony_rank_info",					parser_fun=parse_red_alert_union_hegemony_rank_info					}, ---返回军团争霸排行榜信息
	{ code = 14634,	parser = "parse_red_alert_union_pack_reward_info",						parser_fun=parse_red_alert_union_pack_reward_info					}, ---返回军团仓库列表
	{ code = 14635,	parser = "parse_red_alert_union_member_info_change",					parser_fun=parse_red_alert_union_member_info_change					}, ---返回军团成员信息变更
	{ code = 14636,	parser = "parse_red_alert_union_member_info_delete",					parser_fun=parse_red_alert_union_member_info_delete					}, ---返回军团成员删除
	{ code = 14637,	parser = "parse_red_alert_union_frist_enter_legion",					parser_fun=parse_red_alert_union_frist_enter_legion					}, ---返回军团成员首次被同意进入工会
	{ code = 14638,	parser = "parse_return_union_science_info_update",						parser_fun=parse_return_union_science_info_update					}, ---返回军团科技信息变更
	{ code = 14639,	parser = "parse_return_union_science_info_times",						parser_fun=parse_return_union_science_info_times					}, ---返回军团科技信息次数变更
	{ code = 14640,	parser = "parse_return_union_pve_info_update",							parser_fun=parse_return_union_pve_info_update						}, ---返回军团副本状态更新信息
	{ code = 14641,	parser = "parse_return_user_union_pve_info_update",						parser_fun=parse_return_user_union_pve_info_update					}, ---返回用户军团副本状态更新信息
	{ code = 14642,	parser = "parse_return_union_hegemony_sign_info",						parser_fun=parse_return_union_hegemony_sign_info					}, ---返回用户军团争霸报名信息
	{ code = 14643,	parser = "parse_return_union_hegemony_sign_union_info",					parser_fun=parse_return_union_hegemony_sign_union_info				}, ---返回用户军团争霸军团信息
	{ code = 14644,	parser = "parse_return_union_level_info",								parser_fun=parse_return_union_level_info							}, ---返回用户军团等级信息
	{ code = 14645,	parser = "parse_red_alert_guard_battle_stronghold_info",				parser_fun=parse_red_alert_guard_battle_stronghold_info				}, ---返回守卫战据点信息
	{ code = 14646,	parser = "parse_red_alert_guard_list_info",								parser_fun=parse_red_alert_guard_list_info							}, ---返回守卫战防守列表信息
	{ code = 14647,	parser = "parse_red_alert_guard_update_list_info",						parser_fun=parse_red_alert_guard_update_list_info					}, ---返回守卫战防守列表信息
	{ code = 14648,	parser = "parse_red_alert_guard_battle_user_info",						parser_fun=parse_red_alert_guard_battle_user_info					}, ---返回守卫战用户守卫战信息
	{ code = 14649,	parser = "parse_red_alert_guard_battle_rank_info",						parser_fun=parse_red_alert_guard_battle_rank_info					}, ---返回守卫战排行榜
	{ code = 14650,	parser = "parse_red_alert_guard_battle_list_info_delete",				parser_fun=parse_red_alert_guard_battle_list_info_delete			}, ---返回守卫战防守列表消失
	{ code = 14651,	parser = "parse_red_alert_guard_battle_factor_info",					parser_fun=parse_red_alert_guard_battle_factor_info					}, ---返回守卫战胜利方增益列表
	{ code = 14652,	parser = "parse_return_energy_house_is_initialized",					parser_fun=parse_return_energy_house_is_initialized					}, ---返回能量屋初始化信息
	{ code = 14653,	parser = "parse_return_energy_house_is_initialized_personal",			parser_fun=parse_return_energy_house_is_initialized_personal		}, ---返回能量屋个人信息
	{ code = 14654,	parser = "parse_return_the_public_copy_of_the_injury_list",				parser_fun=parse_return_the_public_copy_of_the_injury_list			}, ---返回公会副本NPC的伤害排行榜信息
	{ code = 14655,	parser = "parse_returns_the_slot_machine_data",							parser_fun=parse_returns_the_slot_machine_data						}, ---返回老虎机数据
	{ code = 14656,	parser = "parse_return_to_the_guild_slot_list",							parser_fun=parse_return_to_the_guild_slot_list						}, ---返回公会老虎机的排行榜
	{ code = 14657,	parser = "parse_return_member_copy_damage_ranking_information",			parser_fun=parse_return_member_copy_damage_ranking_information		}, ---返回公会成员副本NPC的伤害排行榜信息
	{ code = 14658,	parser = "parse_return_the_guild_copy_lucky_reward_information",		parser_fun=parse_return_the_guild_copy_lucky_reward_information		}, ---返回公会副本NPC战斗幸运奖励信息数量
	{ code = 14659,	parser = "parse_return_union_pve_info",									parser_fun=parse_return_union_pve_info								}, ---返回军团副本初始化
	{ code = 14660,	parser = "parse_return_union_red_packet_info",							parser_fun=parse_return_union_red_packet_info						}, ---返回军团红包信息
	{ code = 14661,	parser = "parse_return_red_envelopes_grab_the_list_of_information",		parser_fun=parse_return_red_envelopes_grab_the_list_of_information	}, ---返回军团红包抢夺的榜单信息
	{ code = 14662,	parser = "parse_return_red_packet_personal_message_preview_info",		parser_fun=parse_return_red_packet_personal_message_preview_info	}, ---返回军团红包抢夺的个人预览信息
	{ code = 14663,	parser = "parse_return_red_packet_personal_rap_list_info",				parser_fun=parse_return_red_packet_personal_rap_list_info			}, ---返回军团红包抢夺的列表
	{ code = 14664,	parser = "parse_return_push_legion_info",								parser_fun=parse_return_push_legion_info							}, ---返回军团创建信息
	{ code = 14665,	parser = "parse_return_legion_factory_buff_info",						parser_fun=parse_return_legion_factory_buff_info					}, ---返回军团工厂buff信息
	{ code = 14666,	parser = "parse_return_legion_occupy_factory_info",						parser_fun=parse_return_legion_occupy_factory_info					}, ---返回军团工厂信息
	{ code = 14667,	parser = "parse_union_stick_crazy_adventure_state_info",				parser_fun=parse_union_stick_crazy_adventure_state_info				}, ---返回比利的棍子游戏状态
	{ code = 14668,	parser = "parse_red_alert_recommend_union_list",						parser_fun=parse_red_alert_recommend_union_list						}, ---返回推荐工会列表
	{ code = 14669,	parser = "parse_sm_union_fighting_user_init_info",						parser_fun=parse_sm_union_fighting_user_init_info					}, ---返回公会战的用户信息
	{ code = 14670,	parser = "parse_sm_union_fighting_battle_init_info",					parser_fun=parse_sm_union_fighting_battle_init_info					}, ---返回公会战的初始化用户信息
	{ code = 14671,	parser = "parse_sm_union_fighting_union_info",							parser_fun=parse_sm_union_fighting_union_info						}, ---返回公会战的工会信息
	{ code = 14672,	parser = "parse_sm_union_fighting_union_member_info",					parser_fun=parse_sm_union_fighting_union_member_info				}, ---返回公会战的工会成员信息
	{ code = 14673,	parser = "parse_sm_union_fighting_union_report_info",					parser_fun=parse_sm_union_fighting_union_report_info				}, ---返回公会战的战报信息
	{ code = 14674,	parser = "parse_sm_union_fighting_union_rank_info",						parser_fun=parse_sm_union_fighting_union_rank_info					}, ---返回公会战的排行信息
	{ code = 14675,	parser = "parse_sm_union_fighting_bet_info",							parser_fun=parse_sm_union_fighting_bet_info							}, ---返回公会战的下注信息
	{ code = 14676,	parser = "parse_sm_union_fighting_duel_info",							parser_fun=parse_sm_union_fighting_duel_info						}, ---返回公会战决赛信息
	{ code = 14677,	parser = "parse_sm_union_fighting_duel_match_info",						parser_fun=parse_sm_union_fighting_duel_match_info					}, ---返回公会战决赛匹配信息
	{ code = 14678,	parser = "parse_sm_union_energyhouse_exp_up",							parser_fun=parse_sm_union_energyhouse_exp_up						}, ---返回公会能量屋经验增加动画的显示

	{ code = 14679,	parser = "parse_union_assistance_init",									parser_fun=parse_union_assistance_init								}, ---返回公会援助信息
	{ code = 14680,	parser = "parse_union_assistance_all_record",							parser_fun=parse_union_assistance_all_record						}, ---返回公会援助记录
	{ code = 14681,	parser = "parse_see_union_info",										parser_fun=parse_see_union_info										}, ---返回公会详情信息

	{ code = 14700,	parser = "parse_city_resource_battle_reports_init",						parser_fun=parse_city_resource_battle_reports_init					}, ---战报信息
	{ code = 14701,	parser = "parse_city_resource_battle_report",							parser_fun=parse_city_resource_battle_report						}, ---更新战报信息
	{ code = 14702,	parser = "parse_return_combat_force_loss",								parser_fun=parse_return_combat_force_loss							}, ---返回战斗兵力损失
	{ code = 14703,	parser = "parse_back_to_the_report_details_reward_info",				parser_fun=parse_back_to_the_report_details_reward_info				}, ---返回战报奖励详细信息
	{ code = 14704,	parser = "parse_return_to_the_battlefield_to_save_the_information",		parser_fun=parse_return_to_the_battlefield_to_save_the_information	}, ---返回战报保存信息
	{ code = 14706,	parser = "parse_fight_round_begin_talent_attack_all",					parser_fun=parse_fight_round_begin_talent_attack_all				}, ---返回战斗回合开始攻击所有角色
	{ code = 14707,	parser = "parse_return_to_battle_result_star_info",						parser_fun=parse_return_to_battle_result_star_info					}, ---返回战斗星数
	{ code = 14708,	parser = "parse_return_seq_battlefield_report_info_delete",				parser_fun=parse_return_seq_battlefield_report_info_delete			}, ---返回战报信息删除
	{ code = 14709,	parser = "parse_arena_battle_data_report",								parser_fun=parse_arena_battle_data_report							}, ---更新战报信息
	{ code = 14710,	parser = "parse_environment_fight_battle_start_influence_info",			parser_fun=parse_environment_fight_battle_start_influence_info		}, ---返回战斗开始前的信息
	{ code = 14711,	parser = "parse_environment_fight_round_start_influence_info",			parser_fun=parse_environment_fight_round_start_influence_info		}, ---返回战斗每个回合前的信息
	{ code = 14712,	parser = "parse_environment_fight_battle_camp_change_influence_info",	parser_fun=parse_environment_fight_battle_camp_change_influence_info	}, ---返回战斗每个回合内的攻击方切换的信息
	{ code = 14713,	parser = "parse_environment_fight_battle_init_object_info",				parser_fun=parse_environment_fight_battle_init_object_info			}, ---返回战场对象的基础属性
	
	{ code = 14714,	parser = "parse_fight_battle_report_info",								parser_fun=parse_fight_battle_report_info							}, ---返回战报统计信息
	{ code = 14715,	parser = "parse_cross_fight_battle_report_info",						parser_fun=parse_cross_fight_battle_report_info						}, ---返回战报统计信息(小队竞技场和跨服忍界大战)

	{ code = 14800,	parser = "parse_user_stronghold_view_score_rank",						parser_fun=parse_user_stronghold_view_score_rank					}, ---返回个人战积分排行榜
	
	{ code = 14803,	parser = "parse_cross_server_battel_shop_info",							parser_fun=parse_cross_server_battel_shop_info						}, ---返回跨服矿战商店信息
	{ code = 14804,	parser = "parse_cross_server_battel_addition_info",						parser_fun=parse_cross_server_battel_addition_info					}, ---返回跨服矿战鼓舞信息
	{ code = 14805,	parser = "parse_cross_server_battel_map_info",							parser_fun=parse_cross_server_battel_map_info						}, ---返回跨服矿战矿区信息
	{ code = 14806,	parser = "parse_cross_server_battel_rank_info",							parser_fun=parse_cross_server_battel_rank_info						}, ---返回跨服矿战服务器排行信息
	{ code = 14807,	parser = "parse_cross_server_battel_user_info",							parser_fun=parse_cross_server_battel_user_info						}, ---返回跨服矿战用户信息
	{ code = 14802,	parser = "parse_cross_server_battel_personal_rank_info",				parser_fun=parse_cross_server_battel_personal_rank_info				}, ---返回跨服矿战个人排行信息
	{ code = 14809,	parser = "parse_cross_server_battel_server_rank_info",					parser_fun=parse_cross_server_battel_server_rank_info				}, ---返回跨服矿战贡献排行信息
	{ code = 14812,	parser = "parse_cross_server_battel_formation_info",					parser_fun=parse_cross_server_battel_formation_info					}, ---返回跨服矿战阵型信息

	{ code = 14813,	parser = "parse_cross_server_battel_mineral_num",						parser_fun=parse_cross_server_battel_mineral_num					}, ---返回跨服矿战矿石数量信息
	{ code = 14814,	parser = "parse_cross_server_battel_grab_other_formation",				parser_fun=parse_cross_server_battel_grab_other_formation			}, ---返回跨服矿战抢矿信息
	{ code = 14816,	parser = "parse_cross_server_battel_grab_other_formation2",				parser_fun=parse_cross_server_battel_grab_other_formation2			}, ---返回跨服矿战抢矿信息

	{ code = 14817,	parser = "parse_cross_server_battel_report_info",						parser_fun=parse_cross_server_battel_report_info					}, ---返回跨服矿战战报信息
	{ code = 14818,	parser = "parse_cross_server_battel_is_open",							parser_fun=parse_cross_server_battel_is_open						}, ---返回跨服矿战是否开启
	{ code = 14819,	parser = "parse_cross_server_battel_map_refresh",						parser_fun=parse_cross_server_battel_map_refresh					}, ---返回跨服矿战普通矿区换一批信息
	{ code = 14820,	parser = "parse_cross_server_battel_map_close_info",					parser_fun=parse_cross_server_battel_map_close_info					}, ---返回跨服矿战未开启时排名信息
	{ code = 14821,	parser = "parse_cross_server_battel_map_rob_info",						parser_fun=parse_cross_server_battel_map_rob_info					}, ---返回跨服矿战抢夺信息
	{ code = 14823,	parser = "parse_cross_server_battel_get_rank_formation",				parser_fun=parse_cross_server_battel_get_rank_formation				}, ---返回跨服矿战排名前三阵容信息
	{ code = 14824,	parser = "parse_cross_server_battel_get_all_servers",					parser_fun=parse_cross_server_battel_get_all_servers				}, ---返回跨服矿战所有服务器信息
	{ code = 14825,	parser = "parse_cross_server_battel_rank_refresh_time",					parser_fun=parse_cross_server_battel_rank_refresh_time				}, ---返回跨服矿战所有服务器信息

	{ code = 14826,	parser = "parse_cross_server_the_kings_battle_init_info",				parser_fun=parse_cross_server_the_kings_battle_init_info			}, ---返回跨服王者之战的初始化信息
	{ code = 14828,	parser = "parse_the_cross_server_kings_battle_peakedness_duel_info",	parser_fun=parse_the_cross_server_kings_battle_peakedness_duel_info	}, ---返回跨服王者之战的决赛战报信息
	{ code = 14829,	parser = "parse_cross_server_the_kings_battle_match_info",				parser_fun=parse_cross_server_the_kings_battle_match_info			}, ---返回跨服王者之战的匹配战报
	{ code = 14830,	parser = "parse_the_cross_server_kings_battle_battle_report_info",		parser_fun=parse_the_cross_server_kings_battle_battle_report_info	}, ---返回跨服王者之战的战报推送
	{ code = 14831,	parser = "parse_user_cross_server_the_kings_battle_score_rank_info",	parser_fun=parse_user_cross_server_the_kings_battle_score_rank_info	}, ---返回跨服王者之战的排行相关数据
	{ code = 14832,	parser = "parse_cross_server_the_kings_battle_other_formation",			parser_fun=parse_cross_server_the_kings_battle_other_formation		}, ---返回跨服王者之战别人的阵型
	{ code = 14833,	parser = "parse_cross_server_the_kings_battle_play_back",				parser_fun=parse_cross_server_the_kings_battle_play_back			}, ---返回跨服王者之战回放
	
	{ code = 14834,	parser = "parse_cross_arena_init",				parser_fun=parse_cross_arena_init			}, ---跨服忍者战接口
	{ code = 14835,	parser = "parse_cross_arena_defensive_formation_get",				parser_fun=parse_cross_arena_defensive_formation_get			}, ---跨服忍者战接口
	{ code = 14836,	parser = "parse_cross_arena_remaining_challenges",				parser_fun=parse_cross_arena_remaining_challenges			}, ---跨服忍者战接口
	{ code = 14837,	parser = "parse_cross_arena_shop_init",				parser_fun=parse_cross_arena_shop_init			}, ---跨服忍者战接口
	{ code = 14838,	parser = "parse_cross_arena_battle_report_list",				parser_fun=parse_cross_arena_battle_report_list			}, ---跨服忍者战接口
	{ code = 14839,	parser = "parse_cross_arena_matching",				parser_fun=parse_cross_arena_matching			}, ---跨服忍者战接口
	{ code = 14840,	parser = "parse_cross_arena_choose_reward",				parser_fun=parse_cross_arena_choose_reward			}, ---跨服忍者战接口
	{ code = 14841,	parser = "parse_cross_arena_attack_formation_get",				parser_fun=parse_cross_arena_attack_formation_get			}, ---跨服忍者战接口
	{ code = 14842,	parser = "parse_cross_arena_attack_result",				parser_fun=parse_cross_arena_attack_result			}, ---跨服忍者战接口
	{ code = 14843,	parser = "parse_cross_arena_status_change",				parser_fun=parse_cross_arena_status_change			}, ---跨服忍者战接口
	{ code = 14844,	parser = "parse_team_arena_enter",				parser_fun=parse_team_arena_enter			}, ---跨服小队竞技场进入信息
	{ code = 14845,	parser = "parse_team_arena_formation_get",				parser_fun=parse_team_arena_formation_get		}, ---获取防守阵容信息接口
	{ code = 14846,	parser = "parse_team_arena_enter_build_up_hall",				parser_fun=parse_team_arena_enter_build_up_hall			}, ---进入集结大厅接口
	{ code = 14847,	parser = "parse_team_arena_enter_build_up_hall_in",				parser_fun=parse_team_arena_enter_build_up_hall_in			}, ---进入集结大厅返回信息--未组队状态
	{ code = 14848,	parser = "parse_team_arena_enter_build_up_hall_out",				parser_fun=parse_team_arena_enter_build_up_hall_out			}, ---进入集结大厅返回信息--组队状态
	{ code = 14849,	parser = "parse_team_arena_team_info_get",				parser_fun=parse_team_arena_team_info_get			}, ---获取小队信息接口
	{ code = 14850,	parser = "parse_team_arena_get_invite_infos",				parser_fun=parse_team_arena_get_invite_infos			}, ---邀请信息
	{ code = 14851,	parser = "parse_team_arena_get_can_invite_users",				parser_fun=parse_team_arena_get_can_invite_users			}, ---获取可邀请玩家列表接口
	{ code = 14852,	parser = "parse_team_arena_get_apply_infos",				parser_fun=parse_team_arena_get_apply_infos			}, ---获取申请列表信息接口
	{ code = 14853,	parser = "parse_team_arena_challenge_times",				parser_fun=parse_team_arena_challenge_times			}, ---获取挑战次数接口
	{ code = 14854,	parser = "parse_team_arena_matching",				parser_fun=parse_team_arena_matching			}, ---玩家匹配可攻打的列表接口
	{ code = 14855,	parser = "parse_team_arena_challenge",				parser_fun=parse_team_arena_challenge			}, ---发起战斗接口
	{ code = 14856,	parser = "parse_team_arena_check_battle_report",				parser_fun=parse_team_arena_check_battle_report			}, ---战报信息列表
	{ code = 14857,	parser = "parse_team_arena_status_change",				parser_fun=parse_team_arena_status_change			}, ---状态变更

	{ code = 14900,	parser = "parse_user_open_server_recharge_rebate_info",					parser_fun=parse_user_open_server_recharge_rebate_info				}, ---返回个人开服充值返利信息

	{ code = 14901,	parser = "parse_red_alert_time_facebook_reward_info",					parser_fun=parse_red_alert_time_facebook_reward_info				}, ---返回facebook状态信息
	{ code = 14902,	parser = "parse_user_google_bind_info",									parser_fun=parse_user_google_bind_info								}, ---返回用户谷歌绑定信息


	{ code = 15000,	parser = "parse_shop_info",												parser_fun=parse_shop_info											}, ---返回商城信息
	{ code = 15001,	parser = "parse_return_shop_frags_info",								parser_fun=parse_return_shop_frags_info								}, ---返回碎片兑换商店信息
	{ code = 15002,	parser = "parse_secret_shop_info",										parser_fun=parse_secret_shop_info									}, ---返回神秘商店信息
	{ code = 15003,	parser = "parse_secret_shop_open_event",								parser_fun=parse_secret_shop_open_event								}, ---返回神秘商店出现
	{ code = 15004,	parser = "parse_return_recruit_result",									parser_fun=parse_return_recruit_result								}, ---返回抽卡信息

	{ code = 15005,	parser = "parse_new_recruitment_system_enter",							parser_fun=parse_new_recruitment_system_enter						}, ---返回新抽卡系统初始化信息
	{ code = 15006,	parser = "parse_new_recruitment_system",								parser_fun=parse_new_recruitment_system								}, ---返回新抽卡双黄暴击信息
	{ code = 15007,	parser = "parse_view_draw_items",										parser_fun=parse_view_draw_items									}, ---返回新抽卡系统抽卡记录信息
	{ code = 15008,	parser = "parse_wish_list",												parser_fun=parse_wish_list											}, ---返回新抽卡系统心愿单活动信息
	
	{ code = 15200,	parser = "parse_return_a_single_buddy_message",							parser_fun=parse_return_a_single_buddy_message						}, ---返回单个好友信息
	{ code = 15201,	parser = "parse_return_friend_receive_the_number_of_information",		parser_fun=parse_return_friend_receive_the_number_of_information	}, ---返回好友耐力领取次数信息
	{ code = 15202,	parser = "parse_return_to_increase_the_masking_information",			parser_fun=parse_return_to_increase_the_masking_information			}, ---返回增加屏蔽信息
	{ code = 15203,	parser = "parse_return_the_masked_information",							parser_fun=parse_return_the_masked_information						}, ---返回解除屏蔽信息
	{ code = 15100,	parser = "parse_world_info_request",									parser_fun=parse_world_info_request									}, ---返回世界信息初始化
	{ code = 15101,	parser = "parse_world_map_arena_info_refresh_request",					parser_fun=parse_world_map_arena_info_refresh_request				}, ---返回世界地图区域信息刷新
	{ code = 15102,	parser = "parse_world_map_personal_information_request",				parser_fun=parse_world_map_personal_information_request				}, ---返回世界地图个人信息
	{ code = 15103,	parser = "parse_world_search_info",										parser_fun=parse_world_search_info									}, ---返回世界地图搜索信息
	{ code = 15104,	parser = "parse_world_coord_collect_info",								parser_fun=parse_world_coord_collect_info							}, ---返回世界地图收藏信息
	{ code = 15105,	parser = "parse_world_map_remove_tile_info",							parser_fun=parse_world_map_remove_tile_info							}, ---返回世界地图个人信息
	{ code = 15106,	parser = "parse_world_map_arena_info_chnage",							parser_fun=parse_world_map_arena_info_chnage						}, ---返回世界地图区域信息变更
	{ code = 15107,	parser = "parse_world_map_investigate_info",							parser_fun=parse_world_map_investigate_info							}, ---返回世界地图侦查信息
	{ code = 15108,	parser = "parse_world_target_event_info",								parser_fun=parse_world_target_event_info							}, ---返回世界地图事件信息
	{ code = 15109,	parser = "parse_world_by_rob_update_user_info",							parser_fun=parse_world_by_rob_update_user_info						}, ---返回玩家被掠夺后的资源信息
	{ code = 15110,	parser = "parse_rebel_haunt_state_info",								parser_fun=parse_rebel_haunt_state_info								}, ---返回叛军活动状态
	{ code = 15111,	parser = "parse_rebel_haunt_list_info",									parser_fun=parse_rebel_haunt_list_info								}, ---返回叛军列表
	{ code = 15112,	parser = "parse_rebel_haunt_user_info",									parser_fun=parse_rebel_haunt_user_info								}, ---返回用户叛军信息
	{ code = 15113,	parser = "parse_rebel_haunt_rank_info",									parser_fun=parse_rebel_haunt_rank_info								}, ---返回叛军排行信息
	{ code = 15114,	parser = "parse_rebel_map_haunt_info",									parser_fun=parse_rebel_map_haunt_info								}, ---返回地图叛军信息
	{ code = 15115,	parser = "parse_return_reconnaissance",									parser_fun=parse_return_reconnaissance								}, ---返回道具侦察定位
	{ code = 15116,	parser = "parse_return_haunt_factor_info",								parser_fun=parse_return_haunt_factor_info							}, ---返回用户叛军限时增益信息
	{ code = 15117,	parser = "parse_rebel_haunt_list_info_update",							parser_fun=parse_rebel_haunt_list_info_update						}, ---返回用户叛军变更
	{ code = 15118,	parser = "parse_return_to_defense_settings",							parser_fun=parse_return_to_defense_settings							}, ---返回协防设置
	{ code = 15119,	parser = "parse_world_map_help_defence_investigate_info",				parser_fun=parse_world_map_help_defence_investigate_info			}, ---返回世界地图协防侦查信息
	{ code = 15121,	parser = "parse_world_map_refresh_all_info",							parser_fun=parse_world_map_refresh_all_info							}, ---返回刷新世界地图信息
	{ code = 15122,	parser = "parse_world_all_attack_event_path_info",						parser_fun=parse_world_all_attack_event_path_info					}, ---返回世界行军路径信息
	{ code = 15123,	parser = "parse_user_world_city_info",									parser_fun=parse_user_world_city_info								}, ---返回城市战用户信息
	{ code = 15124,	parser = "parse_world_city_list_info",									parser_fun=parse_world_city_list_info								}, ---返回城市战城市列表
	{ code = 15125,	parser = "parse_world_city_detail_info",								parser_fun=parse_world_city_detail_info								}, ---返回城市战城市详情
	{ code = 15126,	parser = "parse_world_city_rank_list_info",								parser_fun=parse_world_city_rank_list_info							}, ---返回城市战排行信息
	{ code = 15127,	parser = "parse_world_city_open_state",									parser_fun=parse_world_city_open_state								}, ---返回城市战城市开启状态
	{ code = 15128,	parser = "parse_world_city_shop_list_info",								parser_fun=parse_world_city_shop_list_info							}, ---返回城市战商店列表
	{ code = 15129,	parser = "parse_world_city_shop_user_info",								parser_fun=parse_world_city_shop_user_info							}, ---返回城市战用户商店信息
	{ code = 15130,	parser = "parse_world_investigate_end_time",							parser_fun=parse_world_investigate_end_time							}, ---返回地块侦查时间

	{ code = 15300,	parser = "parse_return_server_maintenance_info",						parser_fun=parse_return_server_maintenance_info						}, ---返回维护服务器信息
	{ code = 15301,	parser = "parse_return_server_open_info",								parser_fun=parse_return_server_open_info							}, ---返回开服服务器信息
	{ code = 15302,	parser = "parse_return_server_list_time_info",							parser_fun=parse_return_server_list_time_info						}, ---返回服务器列表时间信息
	{ code = 15303,	parser = "parse_return_server_list_time_stamp",							parser_fun=parse_return_server_list_time_stamp						}, ---返回服务器列表时间戳检验值
	{ code = 15304,	parser = "parse_return_server_list_next_time_stamp",					parser_fun=parse_return_server_list_next_time_stamp					}, ---返回下一个开的新服的服务器显示时间

	{ code = 16000,	parser = "parse_return_reduce_some_props",								parser_fun=parse_return_reduce_some_props								}, ---返回批量消耗道具

	{ code = "heartbeat",	parser = "parse_heartbeat",										parser_fun=parse_heartbeat											}, ---解析空协议
	{ code = "closed",		parser = "parse_closed",										parser_fun=parse_closed												}, ---解析空协议
	{ code = 18999,	parser = "parse_return_record_log_information",							parser_fun=parse_return_record_log_information						}, ---解析空协议
}