---------------------------------
---说明：宠物信息选项卡扩展界面
-- 创建时间:2015.03.16
-- 作者：李潮
-- 修改记录：
-- 最后修改人：
---------------------------------

PetExpansionsCell = class("PetExpansionsCellClass", Window)
   
function PetExpansionsCell:ctor()
    self.super:ctor()
	
	self.heroInstance = nil
	self.roots = {}
	self.isPlayer = false
	self.num = nil
    local function init_pet_seat_expansions_terminal()
	
		local pet_seat_expansions_manager_terminal = {
            _name = "pet_seat_expansions_manager",
            _init = function (terminal) 
				app.load("client.packs.pet.PetDevelop")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local arena_grade=dms.int(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.level)
				if arena_grade <= zstring.tonumber(_ED.user_info.user_grade) then
					if tonumber(instance.heroInstance.ship_grade) >= tonumber(_ED.user_info.user_grade) and 
						params._datas.next_terminal_name == "pet_seat_strong" then
						TipDlg.drawTextDailog(_pet_tipString_info[6])
						return
					end
					
					state_machine.excute("pet_storage_show_listview_bounce", 0,{_datas = instance.num})
					local heroInstance = params._datas.heroInstance
		    		if fwin:find("PetDevelopClass") ~= nil then
		    			fwin:close(fwin:find("PetDevelopClass"))
		    		end
					local heroDevelopWindow = PetDevelop:new()
					heroDevelopWindow:init(heroInstance.ship_id)
					fwin:open(heroDevelopWindow, fwin._viewdialog)
					
					terminal.last_terminal_name = params._datas.next_terminal_name
					state_machine.excute(params._datas.next_terminal_name, 0, params)
					state_machine.excute("pet_storage_hide_window", 0, params)
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--宠物强化
		local pet_seat_strong_terminal = {
            _name = "pet_seat_strong",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local heroInstance = params._datas.heroInstance
				state_machine.excute("pet_develop_page_manager", 0, 
					{
						_datas = {
							terminal_name = "pet_develop_page_manager", 	
							next_terminal_name = "pet_develop_page_open_strengthen_page", 
							current_button_name = "Button_zhanchong",
							but_image = "", 		
							heroInstance = heroInstance,
							terminal_state = 0,
							openWinId = 33,
							isPressedActionEnabled = false
						}
					}
				)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		--宠物升星
		local pet_seat_awaken_terminal = {
            _name = "pet_seat_awaken",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local heroInstance = params._datas.heroInstance
				state_machine.excute("pet_develop_page_manager", 0, 
					{
						_datas = {
							terminal_name = "pet_develop_page_manager", 	
							next_terminal_name = "pet_develop_page_open_juexin", 
							current_button_name = "Button_suipian",
							but_image = "", 		
							heroInstance = heroInstance,
							terminal_state = 0,
							openWinId = 33,
							isPressedActionEnabled = false
						}
					}
				)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --宠物训练
		local pet_seat_train_terminal = {
            _name = "pet_seat_train",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local heroInstance = params._datas.heroInstance
				state_machine.excute("pet_develop_page_manager", 0, 
					{
						_datas = {
							terminal_name = "pet_develop_page_manager", 	
							next_terminal_name = "pet_develop_page_open_train_page", 
							current_button_name = "Button_pieces_tujian",
							but_image = "", 		
							heroInstance = heroInstance,
							terminal_state = 0,
							openWinId = 58,
							isPressedActionEnabled = false
						}
					}
				)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(pet_seat_expansions_manager_terminal)
		state_machine.add(pet_seat_strong_terminal)
		state_machine.add(pet_seat_train_terminal)
		state_machine.add(pet_seat_awaken_terminal)
        state_machine.init()
    end
    
    init_pet_seat_expansions_terminal()
end


function PetExpansionsCell:onEnterTransitionFinish()

    --获取 角色信息选项卡 --该资源包含扩展界面资源 美术资源
    local csbListGenerals = csb.createNode("packs/PetStorage/list_generals_2.csb")
	local root = csbListGenerals:getChildByName("root")
	--> print("root", root)
	table.insert(self.roots, root)
    self:addChild(csbListGenerals)
	
	--宠物升星
	local hero_strengthen_button = ccui.Helper:seekWidgetByName(root, "Button_shengxing")
	fwin:addTouchEventListener(hero_strengthen_button, nil, 
	{
		terminal_name = "pet_seat_expansions_manager", 
		next_terminal_name = "pet_seat_awaken", 
		current_button_name = "Button_shengxing",  
		but_image = "", 	
		heroInstance = self.heroInstance,
		terminal_state = 0, 
		openWinId = 57,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	local fun_id = 57
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
        fun_id = 61
    end
	local Text_shengxing = ccui.Helper:seekWidgetByName(root, "Text_shengxing")
	Text_shengxing:setString(dms.string(dms["fun_open_condition"], fun_id, fun_open_condition.tip_info))
	--是否开启
	if dms.int(dms["fun_open_condition"], fun_id, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
		Text_shengxing:setVisible(false)
		hero_strengthen_button:setTouchEnabled(true)
		hero_strengthen_button:setColor(cc.c3b(255, 255, 255))
	else
		hero_strengthen_button:setTouchEnabled(false)
		hero_strengthen_button:setColor(cc.c3b(150, 150, 150))
		Text_shengxing:setVisible(true)
	end
	
	local startLevel = dms.int(dms["ship_mould"],self.heroInstance.ship_template_id,ship_mould.initial_rank_level)
	if startLevel >= 5 then 
		--满级了
		Text_shengxing:setVisible(true)
		hero_strengthen_button:setTouchEnabled(false)
		hero_strengthen_button:setColor(cc.c3b(150, 150, 150))
		Text_shengxing:setString(_string_piece_info[344])
	end
	
	--宠物训练
	local seat_breach_button = ccui.Helper:seekWidgetByName(root, "Button_xunlian")
	fwin:addTouchEventListener(seat_breach_button, nil, 
	{
		terminal_name = "pet_seat_expansions_manager", 
		next_terminal_name = "pet_seat_train", 
		current_button_name = "Button_xunlian",  
		but_image = "", 		
		heroInstance = self.heroInstance,
		terminal_state = 0, 
		openWinId = 58,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	local fun_id = 58
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
        fun_id = 62
    end
	local Text_xunlian = ccui.Helper:seekWidgetByName(root, "Text_xunlian")
	Text_xunlian:setString(dms.string(dms["fun_open_condition"], fun_id, fun_open_condition.tip_info))
	if dms.int(dms["fun_open_condition"], fun_id, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
		Text_xunlian:setVisible(false)
	end
	
	if dms.int(dms["fun_open_condition"], fun_id, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
		Text_xunlian:setVisible(false)
		seat_breach_button:setTouchEnabled(true)
		seat_breach_button:setColor(cc.c3b(255, 255, 255))
	else
		seat_breach_button:setTouchEnabled(false)
		seat_breach_button:setColor(cc.c3b(150, 150, 150))
		Text_xunlian:setVisible(true)
	end
	--训练满阶判断
	local pet_id = dms.int(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.base_mould2) 
    local formationId = dms.int(dms["pet_mould"],pet_id,pet_mould.train_group_id)
	local trains = dms.searchs(dms["pet_train_experience"], pet_train_experience.group_id, formationId)
	if trains ~= nil then 
		local level = zstring.tonumber(self.heroInstance.train_level)
		local currentTrainId = nil
		for i,v in pairs(trains) do
			if dms.atoi(v, pet_train_experience.train_level) == level then 
				currentTrainId = dms.atoi(v, pet_train_experience.id)
				break
			end
		end
		if currentTrainId ~= nil then 
			local nextTrainId = dms.int(dms["pet_train_experience"],currentTrainId,pet_train_experience.train_next_level)
			if nextTrainId == -1 then 
				--满级
				Text_xunlian:setVisible(true)
				seat_breach_button:setTouchEnabled(false)
				seat_breach_button:setColor(cc.c3b(150, 150, 150))
				Text_xunlian:setString(_pet_tipString_info[24])
			end

		end
	end
	
	--宠物强化
	local seat_culture_button = ccui.Helper:seekWidgetByName(root, "Button_qianghua")
	fwin:addTouchEventListener(seat_culture_button, nil, 
	{
		terminal_name = "pet_seat_expansions_manager", 
		next_terminal_name = "pet_seat_strong", 
		current_button_name = "Button_qianghua",  
		but_image = "", 	 
		heroInstance = self.heroInstance,	
		terminal_state = 0, 
		openWinId = 56,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	local Text_qianghua = ccui.Helper:seekWidgetByName(root, "Text_qianghua")
	local pet_level = zstring.tonumber(self.heroInstance.ship_grade)
	local fun_id = 56
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
        fun_id = 60
    end
	Text_qianghua:setString(dms.string(dms["fun_open_condition"], fun_id, fun_open_condition.tip_info))
	
	if pet_level < zstring.tonumber(_ED.user_info.user_grade) then
		Text_qianghua:setVisible(false)
		seat_culture_button:setTouchEnabled(true)
		seat_culture_button:setColor(cc.c3b(255, 255, 255))
	else
		Text_qianghua:setVisible(true)
		Text_qianghua:setString(_string_piece_info[344])
		seat_culture_button:setTouchEnabled(false)
		seat_culture_button:setColor(cc.c3b(150, 150, 150))
	end
end


function PetExpansionsCell:onExit()
	state_machine.remove("pet_seat_expansions_manager")
	state_machine.remove("pet_seat_strong")
	state_machine.remove("pet_seat_train")
	state_machine.remove("pet_seat_awaken")
end

function PetExpansionsCell:init(heroInstance,num)
	self.heroInstance = heroInstance
	self.isPlayer = false
	if dms.int(dms["ship_mould"], self.heroInstance.ship_template_id, ship_mould.captain_type) == 0 then 	
		self.isPlayer = true
	else
		self.isPlayer = false
	end
	self.num = num
end

function PetExpansionsCell:createCell()
	local cell = PetExpansionsCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end