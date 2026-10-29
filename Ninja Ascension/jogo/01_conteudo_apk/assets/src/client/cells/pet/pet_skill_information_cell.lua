---------------------------------
---说明：宠物信息界面的 技能卡
-- 作者：李潮
---------------------------------

PetInformationSkill = class("PetInformationSkillClass", Window)
   
function PetInformationSkill:ctor()
    self.super:ctor()
	self.hero = nil
	self.userfashion = nil  
	self.info = {}
	self.listPositionX = nil
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	local function init_formation_hero_skill_terminal()
		local pet_information_see_skill_terminal = {
            _name = "pet_information_see_skill",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.packs.pet.PetSkillSeeInfo")
            	local cell = PetSkillSeeInfo:new()
				cell:init(instance.hero.ship_template_id)
 				fwin:open(cell, fwin._dialog)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(pet_information_see_skill_terminal)
		state_machine.init()
	end
	init_formation_hero_skill_terminal()
end

function PetInformationSkill:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local Text_skill1 = ccui.Helper:seekWidgetByName(root, "Text_putong_skill")
	local Text_skill2 = ccui.Helper:seekWidgetByName(root, "Text_jim")
	local skill_id1 = dms.int(dms["ship_mould"],self.hero.ship_template_id,ship_mould.skill_mould)
	local skill_id2 = dms.int(dms["ship_mould"],self.hero.ship_template_id,ship_mould.deadly_skill_mould)
	Text_skill1:setString("[".. dms.string(dms["skill_mould"],skill_id1,skill_mould.skill_name) .. "]" .. dms.string(dms["skill_mould"],skill_id1,skill_mould.skill_describe))
	Text_skill2:setString("[".. dms.string(dms["skill_mould"],skill_id2,skill_mould.skill_name) .. "]" .. dms.string(dms["skill_mould"],skill_id2,skill_mould.skill_describe))
end

function PetInformationSkill:onEnterTransitionFinish()

    --获取 宠物碎片选项卡 美术资源
    local csbGeneralsInformation_4 = csb.createNode("packs/PetStorage/PetStorage_information_list_3.csb")
	local root = csbGeneralsInformation_4:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_4)

    local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qh"), nil, 
	{
		terminal_name = "pet_information_see_skill",
		terminal_state = 0,
		_ship_id = self.hero.ship_id,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	self:onUpdateDraw()
end

function PetInformationSkill:onExit()
	state_machine.remove("pet_information_see_skill")
end

function PetInformationSkill:init(hero,userfashion,listPositionX)
	self.hero = hero
end

function PetInformationSkill:createCell()
	local cell = PetInformationSkill:new()
	cell:registerOnNodeEvent(cell)
	return cell
end