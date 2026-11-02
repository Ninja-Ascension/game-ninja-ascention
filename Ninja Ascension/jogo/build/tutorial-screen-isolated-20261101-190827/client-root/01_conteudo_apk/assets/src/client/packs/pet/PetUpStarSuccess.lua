----------------------------------------------------------------------------------------------------
-- 说明：宠物升星动画
-------------------------------------------------------------------------------------------------------
PetUpStarSuccess = class("PetUpStarSuccessClass", Window)

function PetUpStarSuccess:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.actions = {}
	self.petInstanceId = nil -- 宠物模板ID
	
	-- 初始化武将小像事件响应需要使用的状态机
	local function init_hero_advance_success_terminal()
		
		-- 设计在升级界面，点击武将全身图像需要处理的逻辑
		local pet_up_star_success_show_end_terminal = {
            _name = "pet_up_star_success_show_end",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				
				local action = nil
		
				action = csb.createTimeline("packs/PetStorage/pet_shengxingdh.csb")
				action:play("advanced_show_over", false)
				instance.roots[1]:runAction(action)
				
				action:setFrameEventCallFunc(function (frame)
					if nil == frame then
						return
					end
					
					local str = frame:getEvent()
					if str == "show_break_through_over" then
						fwin:close(instance)
						
					elseif str == "close" then
					end
				
				end)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 添加需要使用的状态机到状态机管理器去
		state_machine.add(pet_up_star_success_show_end_terminal)		
        state_machine.init()
	end
	init_hero_advance_success_terminal()
end

function PetUpStarSuccess:onUpdateDraw() -- Text_45
	local root = self.roots[1]
	if root == nil then 
		return
	end

	local shipData = dms.element(dms["ship_mould"], self.petInstanceId)
	local heroName = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], self.petInstanceId, ship_mould.fitSkillTwo)
        local evo_info = zstring.split(evo_image, ",")
        --进化模板id
        -- local ship_evo = zstring.split(pet.evolution_status, "|")
        local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self.petInstanceId, ship_mould.captain_name)]
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
   		heroName = word_info[3]
    else
		heroName = dms.atos(shipData, ship_mould.captain_name)
	end

	
	local allPic = ccui.Helper:seekWidgetByName(root, "Panel_hero_tupo")
	local all_icon = dms.atoi(shipData, ship_mould.All_icon)
	allPic:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", all_icon))
	local initial_rank_level = dms.atoi(shipData, ship_mould.initial_rank_level)
	local base_mould2 = dms.atoi(shipData, ship_mould.base_mould2)
	local prop_piece_id = dms.int(dms["pet_mould"], base_mould2, pet_mould.prop_piece_id)

	local grow_target_id = dms.atoi(shipData, ship_mould.grow_target_id)
	local nextShipData = dms.element(dms["ship_mould"], grow_target_id)
	
	local power = dms.atoi(shipData, ship_mould.initial_power)
	local courage = dms.atoi(shipData, ship_mould.initial_courage)
	local intellect = dms.atoi(shipData, ship_mould.initial_intellect)
	local nimable = dms.atoi(shipData, ship_mould.initial_nimable)
	
	ccui.Helper:seekWidgetByName(root, "Text_smcz_0"):setString(""..dms.atoi(shipData,ship_mould.grow_power))
	ccui.Helper:seekWidgetByName(root, "Text_gjcz_0"):setString(""..dms.atoi(shipData,ship_mould.grow_courage))
	ccui.Helper:seekWidgetByName(root, "Text_wfcz_0"):setString(""..dms.atoi(shipData,ship_mould.grow_intellect))
	ccui.Helper:seekWidgetByName(root, "Text_ffcz_0"):setString(""..dms.atoi(shipData,ship_mould.grow_nimable))

	ccui.Helper:seekWidgetByName(root, "Text_smcz_1"):setString(""..(dms.atos(nextShipData,ship_mould.grow_power)))
	ccui.Helper:seekWidgetByName(root, "Text_gjcz_1"):setString(""..(dms.atos(nextShipData,ship_mould.grow_courage)))
	ccui.Helper:seekWidgetByName(root, "Text_wfcz_1"):setString(""..(dms.atos(nextShipData,ship_mould.grow_intellect)))
	ccui.Helper:seekWidgetByName(root, "Text_ffcz_1"):setString(""..(dms.atos(nextShipData,ship_mould.grow_nimable)))

	local nextLeve = initial_rank_level + 1
	ccui.Helper:seekWidgetByName(root, "Text_name"):setString("" .. initial_rank_level .._pet_tipString_info[16] .. heroName)
	ccui.Helper:seekWidgetByName(root, "Text_name_0"):setString("" .. nextLeve .._pet_tipString_info[16] .. heroName)

	local addPer = zstring.split(dms.string(dms["pet_mould"], base_mould2, pet_mould.skill_attribute),",")
	ccui.Helper:seekWidgetByName(root, "Text_jnjs_0"):setString(""..addPer[2].. "%")
	
	
	local next_base_mould2 = dms.atoi(nextShipData, ship_mould.base_mould2)
	local addPer = zstring.split(dms.string(dms["pet_mould"], next_base_mould2, pet_mould.skill_attribute),",")
	ccui.Helper:seekWidgetByName(root, "Text_jnjs_1"):setString(""..addPer[2] .. "%")
end

function PetUpStarSuccess:onEnterTransitionFinish()
	local csbItem = csb.createNode("packs/PetStorage/pet_shengxingdh.csb")
	local root = nil
	root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	root:setTouchEnabled(true)
	local action = csb.createTimeline("packs/PetStorage/pet_shengxingdh.csb")
	action:play("advanced_show", false)
	root:runAction(action)
	table.insert(self.actions,action)
	action:setFrameEventCallFunc(function (frame)
		if nil == frame then
			return
		end
		
		local str = frame:getEvent()
		if str == "information_popup_over" then
			fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1], "Panel_14"), nil, {terminal_name = "pet_up_star_success_show_end"}, nil, 0)
		elseif str == "close" then
		end
		
		end)
	
	self:onUpdateDraw()
	playEffectForAbilityUp()
	
end

function PetUpStarSuccess:close( ... )

end
function PetUpStarSuccess:onExit()
	
	state_machine.remove("pet_up_star_success_show_end")
end

function PetUpStarSuccess:init(petId)
	
	self.petInstanceId = petId -- 宠物模板ID
end

