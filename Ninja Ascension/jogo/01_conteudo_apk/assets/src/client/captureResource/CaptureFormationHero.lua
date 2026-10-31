CaptureFormationHero = class("CaptureFormationHeroClass", Window)

function CaptureFormationHero:ctor()
    self.super:ctor()
	self.templateShipid = 0
	self.shipId = 0
	self.state = 0 --(-1别人占领，0无人占领，1自己占领)
	self.roots = {}
end

function CaptureFormationHero:onEnterTransitionFinish()

end

function CaptureFormationHero:onInit()
	local csbItem = csb.createNode("formation/FormationChange_role.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	local Panel_buzhen_role = ccui.Helper:seekWidgetByName(root, "Panel_buzhen_role")
	local Panel_line_role = ccui.Helper:seekWidgetByName(root, "Panel_line_role")
	Panel_buzhen_role:setTouchEnabled(false)
	Panel_line_role:setTouchEnabled(false)
	
	Panel_buzhen_role:removeAllChildren(true)
	draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), Panel_buzhen_role, nil, nil, cc.p(0.5, 0))

	local temp_bust_index = 0
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		----------------------新的数码的形象------------------------
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], tonumber(self.templateShipid), ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship = fundShipWidthId(self.shipId)
		local ship_evo = zstring.split(ship.evolution_status, "|")
		local evo_mould_id = evo_info[tonumber(ship_evo[1])]
		--新的形象编号
		temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
	else
		temp_bust_index = dms.int(dms["ship_mould"], tonumber(self.templateShipid), ship_mould.bust_index)
	end

	app.load("client.battle.fight.FightEnum")
	local shipSpine = sp.spine_sprite(Panel_buzhen_role, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        shipSpine:setScaleX(-1)
    end

	local cancel_button = ccui.Helper:seekWidgetByName(root, "Button_dellet")
	if self.state == 1 then
		cancel_button:setVisible(false)
	else
		cancel_button:setVisible(true)
	end
	fwin:addTouchEventListener(cancel_button, nil, 
	{
		terminal_name = "resource_hero_resolve_cancel_one", 	
		terminal_state = 0, 
		_ship_id = self.shipId,
		isPressedActionEnabled = true
	}, 
	nil, 2)

	self:setTouchEnabled(true)
end

function CaptureFormationHero:onExit()
end

function CaptureFormationHero:init(templateShipid, shipId, state)
	self.templateShipid = templateShipid
	self.shipId = shipId
	self.state = state
	self:onInit()
end

function CaptureFormationHero:createCell()
    local effect_paths = "images/ui/effice/effice_ui_npc_2/effice_ui_npc_2.ExportJson"
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)			
	local cell = CaptureFormationHero:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

