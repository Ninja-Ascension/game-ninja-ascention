-- ----------------------------------------------------------------------------------------------------
-- 说明：红装信息界面展示
-------------------------------------------------------------------------------------------------------

EquipRedSeeInfo = class("EquipRedSeeInfoClass", Window)
   
function EquipRedSeeInfo:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
	app.load("client.cells.equip.equip_red_talent_list_cell")
    -- Initialize Home page state machine.
    local function init_see_red_equip_information_terminal()
		-- local equip_information_quality_request_terminal = {
  --           _name = "equip_information_quality_request",
  --           _init = function (terminal) 
                
  --           end,
  --           _inited = false,
  --           _instance = self,
  --           _state = 0,
  --           _invoke = function(terminal, instance, params)
		-- 		fwin:close(instance)
		-- 		state_machine.excute("replacement_or_unload_ship_equip_wear_request", 0, params)
  --               return true
  --           end,
  --           _terminal = nil,
  --           _terminals = nil
  --       }
		

--		state_machine.add(equip_information_quality_request_terminal)

        --state_machine.init()
    end
    
    init_see_red_equip_information_terminal()
end

function EquipRedSeeInfo:onUpdateDraw()
	local root = self.roots[1]

	local equipType = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_type)
	local isEquip = true
	local levels = nil 
	if equipType <= 3 then 
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			levels = zstring.split(dms.string(dms["pirates_config"], 319, pirates_config.param), ",")
		else
			levels = zstring.split(dms.string(dms["pirates_config"], 314, pirates_config.param), ",")
		end
		isEquip = true
	else
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			levels = zstring.split(dms.string(dms["pirates_config"], 321, pirates_config.param), ",")
		else
			levels = zstring.split(dms.string(dms["pirates_config"], 322, pirates_config.param), ",")
		end
		isEquip = false
	end
	
	local talents = zstring.split(dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_talent_ids),",")
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	
	 
	listView:removeAllItems()
	if levels == nil then 
		return
	end
	for i,v in pairs(talents) do
		local cell = EquipRedTalentListCell:createCell()
		local activate = zstring.tonumber(self.equipmentInstance.equiment_refine_level)
		if activate >= zstring.tonumber(levels[i]) then 
			cell:init(v,levels[i],true)			
		else
			cell:init(v,levels[i],false)			
		end
		listView:addChild(cell)
	end
end

function EquipRedSeeInfo:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("packs/EquipStorage/equipment_information_tanchuan.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdateDraw()
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		func_string = [[fwin:close(fwin:find("EquipRedSeeInfoClass"))]],   
		terminal_state = 0, 
		isPressedActionEnabled = true,
	},
	nil,0)	
	
end


function EquipRedSeeInfo:onExit()
end

function EquipRedSeeInfo:init(equipmentInstance)
	self.equipmentInstance = equipmentInstance
end
