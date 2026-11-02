-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的宠物碎片碎片信息界面2下拉列表子界面
-------------------------------------------------------------------------------------------------------
PetPatchInformationPageTwoChild = class("PetPatchInformationPageTwoChildClass", Window)

function PetPatchInformationPageTwoChild:ctor()
    self.super:ctor()
	self.hero = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.page = nil
	self.texts = {}
	local function init_pet_patch_information_page_terminal()
		local pet_patch_information_see_skill_terminal = {
            _name = "pet_patch_information_see_skill",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.packs.pet.PetSkillSeeInfo")
            	local cell = PetSkillSeeInfo:new()
				cell:init(instance.hero)
 				fwin:open(cell, fwin._dialog)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(pet_patch_information_see_skill_terminal)
		state_machine.init()
	end
	init_pet_patch_information_page_terminal()
end

function PetPatchInformationPageTwoChild:onUpdateDraw()
	local root = self.roots[1]
	-----基本信息
	local Text_gongji_0 = ccui.Helper:seekWidgetByName(root, "Text_3")		--攻击
	local Text_wufang_0 = ccui.Helper:seekWidgetByName(root, "Text_5")		--物防
	local Text_shengming_0 = ccui.Helper:seekWidgetByName(root, "Text_8")			--生命
	local Text_fafang_0 = ccui.Helper:seekWidgetByName(root, "Text_9")				--法防

	Text_gongji_0:setString(""..dms.int(dms["ship_mould"],self.hero,ship_mould.initial_courage))
	Text_wufang_0:setString(""..dms.int(dms["ship_mould"],self.hero,ship_mould.initial_intellect))
	Text_shengming_0:setString(""..dms.int(dms["ship_mould"],self.hero,ship_mould.initial_power))
	Text_fafang_0:setString(""..dms.int(dms["ship_mould"],self.hero,ship_mould.initial_nimable))

	-----技能信息
	local Text_skill1 = ccui.Helper:seekWidgetByName(root, "Text_putong_skill")
	local Text_skill2 = ccui.Helper:seekWidgetByName(root, "Text_jim")
	local skill_id1 = dms.int(dms["ship_mould"],self.hero,ship_mould.skill_mould)
	local skill_id2 = dms.int(dms["ship_mould"],self.hero,ship_mould.deadly_skill_mould)
	Text_skill1:setString("[".. dms.string(dms["skill_mould"],skill_id1,skill_mould.skill_name) .. "]" .. dms.string(dms["skill_mould"],skill_id1,skill_mould.skill_describe))
	Text_skill2:setString("[".. dms.string(dms["skill_mould"],skill_id2,skill_mould.skill_name) .. "]" .. dms.string(dms["skill_mould"],skill_id2,skill_mould.skill_describe))

	-----训练信息
	local pet_id = dms.int(dms["ship_mould"], self.hero, ship_mould.base_mould2)
    local formationId = dms.int(dms["pet_mould"],pet_id,pet_mould.train_group_id)
    local pet_formations = dms.searchs(dms["pet_train_experience"], pet_train_experience.group_id, formationId)
    for i=1,6 do
    	local image = ccui.Helper:seekWidgetByName(root, "Image_zw1_"..i)
    	image:setVisible(false)	
    	local formationText = ccui.Helper:seekWidgetByName(root, "Text_zw"..i)
    	formationText:setString("")
    end
    local level = 0
    if pet_formations ~= nil then 
        --有阵型加成
        local addFormation = nil
        for k,v in pairs(pet_formations) do
            if level == zstring.tonumber(v[3]) then 
                addFormation = v
                break
            end
        end
        if addFormation == nil then 
            return
        end
        local formations = {}
        local counts = 0
        for i=1,6 do
        	local image = ccui.Helper:seekWidgetByName(root, "Image_zw1_"..i)
    		local attribute = addFormation[5+i]
            local lenghtAdd = string.len(attribute)
            local value = 1
            local index = 1
            if lenghtAdd > 2 then 
            -- 有加层
            	image:setVisible(true)
        		local info = zstring.split("".. attribute,"|")
	        	if info ~= nil and #info == 2 then
	        		--两种属性 必然是防御 物理防御，法术防御
	        		index = 40
	        		value = zstring.tonumber(zstring.split(""..info[1],",")[2])
              	end
	         	if info ~= nil and #info == 1 then 
                    --一种属性
                    local addAttribute = zstring.split("".. info[1],",")
                    index = zstring.tonumber(addAttribute[1]) + 1
                    value = zstring.tonumber(addAttribute[2])
               	end
                counts = counts + 1
	            local formationText = ccui.Helper:seekWidgetByName(root, "Text_zw"..counts)
	            formationText:setString("" .._pet_tipString_info[13] .. i .. " " .. string_equiprety_name[index] .. value ..string_equiprety_name_vlua_type[index])
	        end
	    end
    end
    --描述信息
    ccui.Helper:seekWidgetByName(root, "Text_miaoshu_1"):setString(dms.string(dms["ship_mould"],self.hero,ship_mould.introduce))
end

function PetPatchInformationPageTwoChild:onEnterTransitionFinish()
	local csbPetPatchInformationPageTwoChild= csb.createNode("packs/PetStorage/PetStorage_information_1.csb")
	
    self:addChild(csbPetPatchInformationPageTwoChild)
	local root = csbPetPatchInformationPageTwoChild:getChildByName("root")
	table.insert(self.roots, root)
	self.oSize = ccui.Helper:seekWidgetByName(root, "Panel_3"):getContentSize()
	
	local Panel_32=  ccui.Helper:seekWidgetByName(root, "Button_qh")
	fwin:addTouchEventListener(Panel_32, nil, 
		{
			terminal_name = "pet_patch_information_see_skill", 
			terminal_state = 0, 
			_ship_template_id = self.hero,
		},
		nil,0)
	
	self:setContentSize(self.oSize)
	self:onUpdateDraw()
end

function PetPatchInformationPageTwoChild:onExit()

end

function PetPatchInformationPageTwoChild:init(hero)
	self.hero = hero	
end

function PetPatchInformationPageTwoChild:createCell()
	local cell = PetPatchInformationPageTwoChild:new()
	cell:registerOnNodeEvent(cell)
	return cell
end