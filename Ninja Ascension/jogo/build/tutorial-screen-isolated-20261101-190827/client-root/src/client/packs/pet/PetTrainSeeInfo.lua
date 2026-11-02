-- ----------------------------------------------------------------------------------------------------
-- 说明：宠物驯养查看
-------------------------------------------------------------------------------------------------------

PetTrainSeeInfo = class("PetTrainSeeInfoClass", Window)
   
local pet_train_see_info_window_open_terminal = {
    _name = "pet_train_see_info_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("PetTrainSeeInfoClass") then
        	local seeInfoWindow = PetTrainSeeInfo:new()
			seeInfoWindow:init(params)
			fwin:open(seeInfoWindow, fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local pet_train_see_info_window_close_terminal = {
    _name = "pet_train_see_info_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PetTrainSeeInfoClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pet_train_see_info_window_open_terminal)
state_machine.add(pet_train_see_info_window_close_terminal)
state_machine.init()
  
function PetTrainSeeInfo:ctor()
    self.super:ctor()
	self.roots = {}
	
	app.load("client.cells.ship.ship_head_cell")
	self._ship = 0 -- 英雄实例ID
	self._pet_id = 0 --宠物ID
	
    -- Initialize Home page state machine.
    local function init_pet_train_see_info_terminal()
        --卸下
        local pet_train_see_info_pet_equip_down_terminal = {
            _name = "pet_train_see_info_pet_equip_down",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
               local t_self = params._datas._self
    	     	local function responsePetEquipCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil then 
							return
						end
						state_machine.excute("formation_advanced_updata", 0,{"downPet",response.node._pet_id})
						state_machine.excute("pet_train_see_info_window_close", 0,0)
					end
				end
            	protocol_command.pet_equip.param_list = "" ..t_self._ship.ship_id .."\r\n".. "0"
				NetworkManager:register(protocol_command.pet_equip.code, nil, nil, nil, t_self, responsePetEquipCallback, false, nil)
            	return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --更换
        local pet_train_see_info_pet_equip_change_terminal = {
            _name = "pet_train_see_info_pet_equip_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                --无战宠需要弹出列表
    			app.load("client.packs.pet.PetFormationChoiceWear")
        		local petChooseWindow = PetFormationChoiceWear:new()
         		petChooseWindow:init(4,instance._ship)
         		fwin:open(petChooseWindow, fwin._windows)
         		state_machine.excute("pet_train_see_info_window_close", 0,0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(pet_train_see_info_pet_equip_down_terminal)
		state_machine.add(pet_train_see_info_pet_equip_change_terminal)
        state_machine.init()
    end
    
    init_pet_train_see_info_terminal()
end

function PetTrainSeeInfo:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	
	local heroPanel = ccui.Helper:seekWidgetByName(root, "Panel_6")
	local petPanel = ccui.Helper:seekWidgetByName(root, "Panel_6_0")
	heroPanel:removeAllChildren(true)
	petPanel:removeAllChildren(true)
	local heroNameText = ccui.Helper:seekWidgetByName(root, "Text_name")
	local petNameText = ccui.Helper:seekWidgetByName(root, "Text_name_0")
	local gongjiText = ccui.Helper:seekWidgetByName(root, "Text_3")
	local shengmingText = ccui.Helper:seekWidgetByName(root, "Text_8")
	local wufangText = ccui.Helper:seekWidgetByName(root, "Text_5")
	local fafangText = ccui.Helper:seekWidgetByName(root, "Text_9")
	--数据
	local heroDate = dms.element(dms["ship_mould"], self._ship.ship_template_id)
	local petEquipId = self._ship.pet_equip_id
	local pet = _ED.user_ship[""..petEquipId]
	self._pet_id = petEquipId
	local petDate = dms.element(dms["ship_mould"], pet.ship_template_id)
	local ship_type = dms.atoi(heroDate,ship_mould.ship_type) +1
	heroNameText:setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type][1], tipStringInfo_quality_color_Type[ship_type][2], tipStringInfo_quality_color_Type[ship_type][3]))
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], pet.ship_template_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        local ship_evo = zstring.split(pet.evolution_status, "|")
        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
   		local name = word_info[3]
        heroNameText:setString(name)
    else
		heroNameText:setString(dms.atos(petDate,ship_mould.captain_name))
	end
	
	local pet_type = dms.atoi(petDate,ship_mould.ship_type) +1
	heroNameText:setColor(cc.c3b(tipStringInfo_quality_color_Type[ship_type][1], tipStringInfo_quality_color_Type[ship_type][2], tipStringInfo_quality_color_Type[ship_type][3]))
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], self._ship.ship_template_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        local ship_evo = zstring.split(self._ship.evolution_status, "|")
        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
   		local name = word_info[3]
        heroNameText:setString(name)
    else
		if dms.atoi(heroDate,ship_mould.captain_type) == 0 then 
			--主角
			heroNameText:setString(_ED.user_info.user_name)
			if ___is_open_leadname == true then 
				local fontSize = heroNameText:getFontSize()
				heroNameText:setFontName("")
				heroNameText:setFontSize(fontSize)
			end
		else
			heroNameText:setString(dms.atos(heroDate,ship_mould.captain_name))
		end
	end
	
	
	petNameText:setColor(cc.c3b(tipStringInfo_quality_color_Type[pet_type][1], tipStringInfo_quality_color_Type[pet_type][2], tipStringInfo_quality_color_Type[pet_type][3]))
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], pet.ship_template_id, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        local ship_evo = zstring.split(pet.evolution_status, "|")
        local evo_mould_id = evo_info[tonumber(ship_evo[1])]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
   		local name = word_info[3]
        petNameText:setString(name)
    else
		petNameText:setString(dms.atos(petDate,ship_mould.captain_name))
	end

	local perAdd = dms.int(dms["pirates_config"], 328, pirates_config.param)
	gongjiText:setString("+"..math.floor(tonumber(pet.ship_courage)*perAdd/100))
	wufangText:setString("+"..math.floor(tonumber(pet.ship_intellect)*perAdd/100))
	shengmingText:setString("+"..math.floor(tonumber(pet.ship_health)*perAdd/100))
	fafangText:setString("+"..math.floor(tonumber(pet.ship_quick)*perAdd/100))
	
	local cell = ShipHeadCell:createCell()
	cell:init(self._ship,5,self._ship.ship_template_id)
	heroPanel:addChild(cell)

	local cell = ShipHeadCell:createCell()
	cell:init(pet,5,pet.ship_template_id)
	petPanel:addChild(cell)
end

function PetTrainSeeInfo:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("packs/PetStorage/PetStorage_xunyangtc.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdateDraw()
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		terminal_name = "pet_train_see_info_window_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)	
	--战宠下阵
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qd"), nil, 
	{
		terminal_name = "pet_train_see_info_pet_equip_down", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)	

	--更换
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qx"), nil, 
	{
		terminal_name = "pet_train_see_info_pet_equip_change", 
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)	
	
end

function PetTrainSeeInfo:onExit()
	state_machine.remove("pet_train_see_info_pet_equip_down")
	state_machine.remove("pet_train_see_info_pet_equip_change")
end

function PetTrainSeeInfo:init(ship)
	
	self._ship = ship
end
