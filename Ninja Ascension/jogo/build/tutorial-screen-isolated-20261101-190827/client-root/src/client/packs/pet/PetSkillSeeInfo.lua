-- ----------------------------------------------------------------------------------------------------
-- 说明：红装信息界面展示
-------------------------------------------------------------------------------------------------------

PetSkillSeeInfo = class("PetSkillSeeInfoClass", Window)
   
function PetSkillSeeInfo:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
	app.load("client.cells.pet.pet_skill_list_cell")
    -- Initialize Home page state machine.
    local function init_see_red_equip_information_terminal()
		
    end
    
    init_see_red_equip_information_terminal()
end

function PetSkillSeeInfo:onUpdateDraw()
	local root = self.roots[1]
	 
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	listView:removeAllItems()
	local base_mould = dms.int(dms["ship_mould"],self.ship_template_id,ship_mould.base_mould)
	local next_mould = base_mould
	local skills = {}
	for i=1,10 do
		local skillId = dms.int(dms["ship_mould"],next_mould,ship_mould.deadly_skill_mould)
		next_mould = dms.int(dms["ship_mould"],next_mould,ship_mould.grow_target_id)
		table.insert(skills,skillId)
		if next_mould == -1 then 
			break
		end
	end
	for i,v in pairs(skills) do
		local cell = PetSkillListCell:createCell()
		cell:init(v)			
		listView:addChild(cell)
	end
end

function PetSkillSeeInfo:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("packs/PetStorage/PetStorage_tanchuan.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	self:onUpdateDraw()
	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		func_string = [[fwin:close(fwin:find("PetSkillSeeInfoClass"))]],   
		terminal_state = 0, 
		isPressedActionEnabled = true,
	},
	nil,0)	
	
end


function PetSkillSeeInfo:onExit()
end

function PetSkillSeeInfo:init(ship_template_id)
	self.ship_template_id = ship_template_id
end
