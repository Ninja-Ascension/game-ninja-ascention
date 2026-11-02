----------------------------------------------------------------------------------------------------
-- 说明：
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
ShipPictureCellTen = class("ShipPictureCellTenClass", Window)

function ShipPictureCellTen:ctor()
    self.super:ctor()
	
	self.roots = {}
	self.ship = nil
	local function init_HeroShop_terminal()
	
	    state_machine.init()
    end
    
    -- call func init hom state machine.
    init_HeroShop_terminal()
end

function ShipPictureCellTen:onEnterTransitionFinish()
	local csbFormation = csb.createNode("shop/shop_wujiang1.csb")
    self:addChild(csbFormation)
	local action = csb.createTimeline("shop/shop_wujiang1.csb") 
	action:gotoFrameAndPlay(0, action:getDuration(), true)
	csbFormation:runAction(action)
	
	local csbFormation_root = csbFormation:getChildByName("root")
	table.insert(self.roots,csbFormation_root)
	ccui.Helper:seekWidgetByName(csbFormation_root, "Panel_2"):setTouchEnabled(false)
	local picIndex_name = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], self.shipInstance.ship_template_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship_evo = zstring.split(self.shipInstance.evolution_status, "|")
		local evo_mould_id = evo_info[tonumber(ship_evo[1])]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		picIndex_name = word_info[3]
	else
		picIndex_name = dms.string(dms["ship_mould"], self.shipInstance.ship_template_id, ship_mould.captain_name)
	end
	local picIndex_pic = nil
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		----------------------新的数码的形象------------------------
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], self.shipInstance.ship_template_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship_evo = zstring.split(self.shipInstance.evolution_status, "|")
		local evo_mould_id = evo_info[tonumber(ship_evo[1])]
		--新的形象编号
		picIndex_pic = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
	else
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			picIndex_pic = dms.int(dms["ship_mould"], self.shipInstance.ship_template_id, ship_mould.bust_index)
		else
			picIndex_pic = dms.int(dms["ship_mould"], self.shipInstance.ship_template_id, ship_mould.All_icon)
		end
	end
	local colortype = dms.string(dms["ship_mould"], self.shipInstance.ship_template_id,ship_mould.ship_type)
	local TypeCurrent = tonumber(dms.string(dms["ship_mould"],self.shipInstance.ship_template_id,ship_mould.camp_preference)) 
	local TypeCamp = tonumber(dms.string(dms["ship_mould"],self.shipInstance.ship_template_id,ship_mould.capacity)) 
	
	local panel = ccui.Helper:seekWidgetByName(csbFormation_root, "Panel_3")
	local Text_name = ccui.Helper:seekWidgetByName(csbFormation_root, "Text_name")
	local cardType = ccui.Helper:seekWidgetByName(csbFormation_root, "Panel_4")
	local cardCamp = ccui.Helper:seekWidgetByName(csbFormation_root, "Panel_5")
	local cardInformation = ccui.Helper:seekWidgetByName(csbFormation_root, "Button_1")
	if self.types == false then
		cardInformation:setVisible(false)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. picIndex_pic .. ".ExportJson")
		-- local spx = ccs.Armature:create("spirte_" .. picIndex_pic)
		-- spx:getAnimation():playWithIndex(0)
		-- panel:addChild(spx)
		-- spx:setPosition(cc.p(panel:getContentSize().width/2, 0))

		local temp_bust_index = picIndex_pic
		local shipPanel = panel
		shipPanel:removeAllChildren(true)
		draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), shipPanel, nil, nil, cc.p(0.5, 0))
		if animationMode == 1 then
			app.load("client.battle.fight.FightEnum")
			local shipSpine = sp.spine_sprite(shipPanel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		        shipSpine:setScaleX(-1)
		    end
		else
			draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", shipPanel, -1, nil, nil, cc.p(0.5, 0))
		end
	else	
		panel:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png",picIndex_pic))
	end
		Text_name:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
		Text_name:setString(picIndex_name)
	
	--武将类型
	local equipIconeType = nil
	if TypeCurrent == 1 then
		equipIconeType = string.format("images/ui/quality/leixing_1.png")
	elseif TypeCurrent == 2 then 
		equipIconeType = string.format("images/ui/quality/leixing_2.png")
	elseif TypeCurrent == 3 then
		equipIconeType = string.format("images/ui/quality/leixing_3.png")
	elseif TypeCurrent == 4 then
		equipIconeType = string.format("images/ui/quality/leixing_4.png")
	end
	cardType:setBackGroundImage(equipIconeType)
	
	--武将阵营
	local HreoCamp = nil
	if TypeCamp == 0 then
	elseif TypeCamp ==1 then 
		HreoCamp = string.format("images/ui/quality/pve_leixing_1.png")
	elseif TypeCamp ==2 then 
		HreoCamp = string.format("images/ui/quality/pve_leixing_2.png")
	elseif TypeCamp ==3 then 
		HreoCamp = string.format("images/ui/quality/pve_leixing_3.png")
	elseif TypeCamp ==4 then 
		HreoCamp = string.format("images/ui/quality/pve_leixing_4.png")
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else
		cardCamp:setBackGroundImage(HreoCamp)
	end
	--查看武将详情
	fwin:addTouchEventListener(cardInformation, nil, 
		{
			terminal_name = "check_information_hero_shop", 
			terminal_state = 0,
			isPressedActionEnabled = true,
			shipId = self.shipInstance
		},
		nil,0)
	-- fwin:addTouchEventListener(cardInformation, nil, 
		-- {
			-- terminal_name = "hero_information_recruit", 
			-- terminal_state = 0, 
			-- shipId = self.shipInstance
		-- },
		-- nil,0)
end

function ShipPictureCellTen:onExit()
	
end

function ShipPictureCellTen:init()
	
end

function ShipPictureCellTen:close( ... )
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local root = self.roots[1]
		if root == nil then
			return
		end

		local panel = ccui.Helper:seekWidgetByName(root, "Panel_3")
		panel:removeAllChildren(true)
	end
end

function ShipPictureCellTen:createCell(shipInstance, types)
	local cell = ShipPictureCellTen:new()
	cell.shipInstance = shipInstance
	cell.types = types
	cell:registerOnNodeEvent(cell)
	return cell
end