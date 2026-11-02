-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的宠物升星界面
-------------------------------------------------------------------------------------------------------
PetStarUpPage = class("PetStarUpPageClass", Window)

function PetStarUpPage:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.petId = 0        --当前武将Id
	self.pet = nil		--当前武将信息
	self.currentStars = {}
	self.nextStars = {}
	self.ArmatureNode_1 = nil  --升星成功动画
	self.ArmatureNodePanel = nil  --
	self.need_same_prop_id = 0
	self.current_template_id = 0 --当前模板
	
	app.load("client.packs.pet.PetUpStarSuccess") 
	app.load("client.cells.prop.prop_icon_new_cell")
    local function init_pet_star_up_page_terminal()
		local pet_star_up_page_up_star_terminal = {
            _name = "pet_star_up_page_up_star",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local function responseWearCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						_ED.baseFightingCount = calcTotalFormationFight()
						if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
	            			return
	            		end
	            		local successPage = PetUpStarSuccess:new()
						successPage:init(instance.current_template_id)
						fwin:open(successPage, fwin._ui)
	            		instance:onUpdateDraw()
	            		instance:playAwakenAction()
	            		state_machine.excute("pet_list_view_update_cell",0,instance.petId)
	            		
	            		state_machine.excute("pet_develop_update_pet",0,0)
	            		state_machine.excute("pet_strengthen_page_check_updata_by_other_page",0,0)
	            		state_machine.excute("pet_patch_update_item_for_id",0,instance.need_same_prop_id)
	            		--阵营刷新
						local formatinWindow = fwin:find("FormationClass")
						if formatinWindow ~= nil then 
							state_machine.excute("formation_pet_update_data",0,0)
						end
		            end
				end
				local shipId = params._datas.shipId
				protocol_command.pet_grow_up.param_list = shipId
				NetworkManager:register(protocol_command.pet_grow_up.code, nil, nil, nil, instance, responseWearCallback, false, nil)
    			return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --通过改变其他页面内容更新本类信息
		local pet_star_up_page_check_update_by_other_page_terminal = {
            _name = "pet_star_up_page_check_update_by_other_page",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
    			if instance ~= nil and instance.roots ~= nil then 
    				instance:onUpdateDraw()
    			end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(pet_star_up_page_up_star_terminal)
        state_machine.add(pet_star_up_page_check_update_by_other_page_terminal)
        state_machine.init()
    end
    init_pet_star_up_page_terminal()
end


--播放强化动画
function PetStarUpPage:playAwakenAction()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	self.ArmatureNodePanel:setVisible(true)
	self.ArmatureNode_1:setVisible(true)
    draw.initArmature(self.ArmatureNode_1, nil, -1, 0, 1)
    csb.animationChangeToAction(self.ArmatureNode_1, 0, 0, false)
    self.ArmatureNode_1._invoke = function(armatureBack)
        if armatureBack:isVisible() == true then
            self.ArmatureNodePanel:setVisible(false)
            armatureBack:setVisible(false)
        end
    end 
end

function PetStarUpPage:onUpdateDraw()
	local root = self.roots[1]
	if root == nil or self.pet == nil then 
		return
	end

	local Panel_wujiang = ccui.Helper:seekWidgetByName(root,"Panel_wujiang")
	Panel_wujiang:removeAllChildren(true)
	local shipCell = ShipBodyCell:createCell()
	shipCell:init(self.pet, 0)
	Panel_wujiang:addChild(shipCell)
	
	local shipData = dms.element(dms["ship_mould"], self.pet.ship_template_id)
	local base_mould2 = dms.atoi(shipData, ship_mould.base_mould2)

	local power = dms.atoi(shipData, ship_mould.initial_power)
	local courage = dms.atoi(shipData, ship_mould.initial_courage)
	local intellect = dms.atoi(shipData, ship_mould.initial_intellect)
	local nimable = dms.atoi(shipData, ship_mould.initial_nimable)
	local initial_rank_level = dms.atoi(shipData, ship_mould.initial_rank_level)
	local grow_target_id = dms.atoi(shipData, ship_mould.grow_target_id)
	self.current_template_id = self.pet.ship_template_id

	local deadly_skill_mould = dms.atoi(shipData, ship_mould.deadly_skill_mould)
	local skillName = dms.string(dms["skill_mould"], deadly_skill_mould, skill_mould.skill_name)
	
	local petLevel = zstring.tonumber(self.pet.ship_grade)
	local nextShipData = dms.element(dms["ship_mould"], grow_target_id)

	local prop_piece_id = dms.int(dms["pet_mould"], base_mould2, pet_mould.prop_piece_id)

	self.currentAttributeText[1]:setString(""..(power + (petLevel-1) * dms.atoi(shipData,ship_mould.grow_power)))
	self.currentAttributeText[2]:setString(""..(courage + (petLevel-1) * dms.atoi(shipData,ship_mould.grow_courage)))
	self.currentAttributeText[3]:setString(""..(intellect + (petLevel-1) * dms.atoi(shipData,ship_mould.grow_intellect)))
	self.currentAttributeText[4]:setString(""..(nimable + (petLevel-1) * dms.atoi(shipData,ship_mould.grow_nimable)))
	
	local addPer = zstring.split(dms.string(dms["pet_mould"], base_mould2, pet_mould.skill_attribute),",")
	self.currentAttributeText[5]:setString(""..addPer[2].. "%")
	self.currentAttributeText[6]:setString(skillName)
	local maxStarPanel = ccui.Helper:seekWidgetByName(root, "Panel_2_0")
	maxStarPanel:setVisible(false)

	local sxButton = ccui.Helper:seekWidgetByName(root, "Button_1")
	for i=1,5 do
		self.currentStars[i]:setVisible(false)
		if i <= initial_rank_level then
			self.currentStars[i]:setVisible(true)
		end
	end
	if grow_target_id == -1 then 
		--满星
		sxButton:setTouchEnabled(false)
		sxButton:setColor(cc.c3b(150, 150, 150))
		ccui.Helper:seekWidgetByName(root, "Panel_you"):setVisible(false)
		maxStarPanel:setVisible(true)
		return
	end
	ccui.Helper:seekWidgetByName(root, "Panel_you"):setVisible(true)
	local nextPower = dms.atoi(nextShipData, ship_mould.initial_power)
	local nextCourage = dms.atoi(nextShipData, ship_mould.initial_courage)
	local nextIntellect = dms.atoi(nextShipData, ship_mould.initial_intellect)
	local nextNimable = dms.atoi(nextShipData, ship_mould.initial_nimable)
	local nextDeadlySkillMould = dms.atoi(nextShipData, ship_mould.deadly_skill_mould)
	local nextSkillName = dms.string(dms["skill_mould"], nextDeadlySkillMould, skill_mould.skill_name)
	local next_rank_level = dms.atoi(nextShipData, ship_mould.initial_rank_level)
	local next_base_mould2 = dms.atoi(nextShipData, ship_mould.base_mould2)

	self.nextAttributeText[1]:setString(""..(nextPower + (petLevel - 1) * dms.atoi(nextShipData,ship_mould.grow_power)))
	self.nextAttributeText[2]:setString(""..(nextCourage + (petLevel - 1) * dms.atoi(nextShipData,ship_mould.grow_courage)))
	self.nextAttributeText[3]:setString(""..(nextIntellect + (petLevel -1) * dms.atoi(nextShipData,ship_mould.grow_intellect)))
	self.nextAttributeText[4]:setString(""..(nextNimable + (petLevel -1) * dms.atoi(nextShipData,ship_mould.grow_nimable)))
	self.nextAttributeText[6]:setString(nextSkillName)

	local addPer = zstring.split(dms.string(dms["pet_mould"], next_base_mould2, pet_mould.skill_attribute),",")
	self.nextAttributeText[5]:setString(""..addPer[2] .. "%")

	for i=1,5 do
		self.nextStars[i]:setVisible(false)
		if i <= next_rank_level then
			self.nextStars[i]:setVisible(true)
		end
	end
	local Text_dengji_0 = ccui.Helper:seekWidgetByName(root, "Text_dengji_0")
	local Text_1_money = ccui.Helper:seekWidgetByName(root, "Text_1_money")
	local Panel_prop_1 = ccui.Helper:seekWidgetByName(root, "Panel_prop_1")
	local Panel_prop_3 = ccui.Helper:seekWidgetByName(root, "Panel_prop_3")
	local Text_djn = ccui.Helper:seekWidgetByName(root, "Text_djn")
	local Text_djn_1 = ccui.Helper:seekWidgetByName(root, "Text_djn_1")
	local Text_zcm = ccui.Helper:seekWidgetByName(root, "Text_zcm")
	local Text_zcm_1 = ccui.Helper:seekWidgetByName(root, "Text_zcm_1")
	

	local pet_star_id = dms.atoi(shipData,ship_mould.required_material_id)
	local petStarData = dms.element(dms["pet_star_param"], pet_star_id)
	local need_level = dms.atoi(petStarData, pet_star_param.need_level)
	local need_silver = dms.atoi(petStarData, pet_star_param.need_silver)
	local need_stone_count = dms.atoi(petStarData, pet_star_param.need_stone_count)
	local need_same_piece_count = dms.atoi(petStarData, pet_star_param.need_same_piece_count)
	local petLevel = zstring.tonumber(self.pet.ship_grade)
	Text_dengji_0:setString(""..petLevel .."/" ..need_level)
	Text_1_money:setString(""..need_silver)
	local silver = zstring.tonumber(_ED.user_info.user_silver)
	if silver >= need_silver then 
		if __lua_project_id == __lua_project_pokemon then
			Text_1_money:setColor(cc.c3b(255, 255, 255))
		else
			Text_1_money:setColor(cc.c3b(0, 0, 0))
		end
	else
		Text_1_money:setColor(cc.c3b(255, 0, 0))
	end
	local propId = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")[26]
	if petLevel >= need_level then 
		--可以升星
		sxButton:setTouchEnabled(true)
		sxButton:setColor(cc.c3b(255, 255, 255))
		Text_dengji_0:setColor(cc.c3b(0, 0, 0))
	else
		sxButton:setTouchEnabled(false)
		sxButton:setColor(cc.c3b(150, 150, 150))
		Text_dengji_0:setColor(cc.c3b(255, 0, 0))
	end
	local prop = fundPropWidthId(propId)
	local pic_index = dms.int(dms["prop_mould"], propId, prop_mould.pic_index)
	local prop_name = dms.string(dms["prop_mould"], propId, prop_mould.prop_name)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        pic_index = setThePropsIcon(propId)[1]
        prop_name = setThePropsIcon(propId)[2]
    end
	Text_djn:setString(prop_name)
	local count = 0
	if prop ~= nil then
		count = prop.prop_number
	end
	Text_djn_1:setString(count.."/"..need_stone_count)
	if zstring.tonumber(count) >= need_stone_count then
		Text_djn_1:setColor(cc.c3b(255, 255, 255))
	else
		Text_djn_1:setColor(cc.c3b(255, 0, 0))
	end
	Panel_prop_1:removeAllChildren(true)
	local cell = PropIconNewCell:createCell()
  	cell:init(13,propId)
  	Panel_prop_1:addChild(cell)

	local prop_piece_id = dms.int(dms["pet_mould"], base_mould2, pet_mould.prop_piece_id)
	pic_index = dms.int(dms["prop_mould"], prop_piece_id, prop_mould.pic_index)
	prop_name = dms.string(dms["prop_mould"], prop_piece_id, prop_mould.prop_name)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        pic_index = setThePropsIcon(prop_piece_id)[1]
        prop_name = setThePropsIcon(prop_piece_id)[2]
    end
	Text_zcm:setString(prop_name)
	
	self.need_same_prop_id = prop_piece_id
	prop = fundPropWidthId(prop_piece_id)
	
	count = 0
	if prop ~= nil then
		count = prop.prop_number
	end
	Text_zcm_1:setString(count.."/"..need_same_piece_count)
	if zstring.tonumber(count) >= need_same_piece_count then 
		Text_zcm_1:setColor(cc.c3b(255, 255, 255))
	else
		Text_zcm_1:setColor(cc.c3b(255, 0, 0))
	end
	local cell = PropIconNewCell:createCell()
  	cell:init(20,prop_piece_id)
  	Panel_prop_3:addChild(cell)  
end

function PetStarUpPage:onEnterTransitionFinish()
	local csbGeneralsQianghua = csb.createNode("packs/PetStorage/PetStorage_shengxing.csb")
    local root = csbGeneralsQianghua:getChildByName("root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
    self:addChild(root)
	
	self.ArmatureNodePanel = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_donghua")   --
    self.ArmatureNode_1 = self.ArmatureNodePanel:getChildByName("ArmatureNode_2")
    draw.initArmature(self.ArmatureNode_1, nil, -1, 0, 1)
    csb.animationChangeToAction(self.ArmatureNode_1, 0, 0, false)
    self.ArmatureNodePanel:setVisible(false)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil,
	{
		terminal_name = "pet_star_up_page_up_star", 
		shipId = self.petId
	}, nil, 0)

	if self.types == "formation" then
		app.load("client.player.UserInformationHeroStorage")
		local seq = fwin:find("UserInformationHeroStorageClass")
		if seq == nil then
			fwin:open(UserInformationHeroStorage:new(), fwin._ui)
		end
		state_machine.excute("formation_property_change_before", 0, "formation_property_change_before.")
	end
	if fwin:find("UserInformationHeroStorageClass") == nil then
		if fwin:find("HeroFormationChoiceWearClass") ~= nil then
			fwin:open(UserInformationHeroStorage:new(), fwin._ui)
		end
	end

	self.currentAttributeText = 
	{
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_shengming_1"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_gongji_1"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_wufang_1"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_fafang_1"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_jnj_1"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_jmc"),
	}
	self.nextAttributeText = 
	{
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_shengming_1_0"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_gongji_1_0"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_wufang_1_0"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_fafang_1_0"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_jnj_1_0"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_jmc_0"),
	}
	for i=1,5 do
		table.insert(self.currentStars, ccui.Helper:seekWidgetByName(self.roots[1], "Image_x_"..i))
		table.insert(self.nextStars, ccui.Helper:seekWidgetByName(self.roots[1], "Image_x_"..i.."_0"))
	end
	self:onUpdateDraw()
end

function PetStarUpPage:close()
	local Panel_wujiang_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_wujiang")
	if Panel_wujiang_1 ~= nil then
		Panel_wujiang_1:removeAllChildren(true)		
	end
end

function PetStarUpPage:onExit()
	state_machine.remove("pet_star_up_page_up_star")
	state_machine.remove("pet_star_up_page_check_update_by_other_page")
end

function PetStarUpPage:init(shipId, types)
	self.petId = shipId
	self.pet = fundShipWidthId(self.petId)
	self.types = types
end