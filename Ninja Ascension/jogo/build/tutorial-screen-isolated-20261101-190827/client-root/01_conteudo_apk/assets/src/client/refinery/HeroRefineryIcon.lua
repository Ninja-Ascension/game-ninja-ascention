----------------------------------------------------------------------------------------------------
-- 说明：回收模块图标绘制 -- 武将
-------------------------------------------------------------------------------------------------------
HeroRefineryIcon = class("HeroRefineryIconClass", Window)

function HeroRefineryIcon:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}
	self.current_type = 0
	self.enum_type = {
		_HERO_RESOLVE = 1,		-- 武将分解
		_HERO_REBORN = 2,		-- 武将重生
	}
	self.mould_id = nil
	self.instance_id = nil
end

function HeroRefineryIcon:onUpdateDraw()
	local root = self.roots[1]
	if self.enum_type._HERO_RESOLVE == self.current_type then
		local hero_data = dms.element(dms["ship_mould"], self.mould_id)
		local hero_name = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            --进化形象
            local evo_image = dms.string(dms["ship_mould"], self.mould_id, ship_mould.fitSkillTwo)
            local evo_info = zstring.split(evo_image, ",")
            --进化模板id
            -- local ship_evo = zstring.split(self.ship.evolution_status, "|")
            local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self.mould_id, ship_mould.captain_name)]
            local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
            local word_info = dms.element(dms["word_mould"], name_mould_id)
            hero_name = word_info[3]
        else 
			hero_name = dms.atos(hero_data, ship_mould.captain_name)
		end
		local hero_color = dms.atoi(hero_data, ship_mould.ship_type)
		local hero_icon = dms.atoi(hero_data, ship_mould.head_icon)
		
		local name_text = ccui.Helper:seekWidgetByName(root, "Text_name")
		name_text:setString(hero_name)
		name_text:setColor(cc.c3b(color_Type[hero_color+1][1],color_Type[hero_color+1][2],color_Type[hero_color+1][3]))
		
		local icon_panel = ccui.Helper:seekWidgetByName(root, "Panel_4")
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			or __lua_project_id == __lua_project_legendary_game 
			then			--龙虎门项目控制
			local temp_bust_index = 0
			if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				then
				----------------------新的数码的形象------------------------
				--进化形象
				local evo_image = dms.string(dms["ship_mould"], self.mould_id, ship_mould.fitSkillTwo)
				local evo_info = zstring.split(evo_image, ",")
				--进化模板id
				-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
				local evo_mould_id = evo_info[dms.int(dms["ship_mould"], self.mould_id, ship_mould.captain_name)]
				--新的形象编号
				temp_bust_index = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
			else
				temp_bust_index = dms.atoi(hero_data, ship_mould.bust_index)
			end
			-- ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/spirte_" .. temp_bust_index .. ".ExportJson")
			-- local cell = ccs.Armature:create("spirte_" .. temp_bust_index)
			-- cell:getAnimation():playWithIndex(0)
			-- icon_panel:addChild(cell)
			-- -- cell:setAnchorPoint(cc.p(0.5, 0.5))
			-- -- cell:setPosition(cc.p(icon_panel:getContentSize().width/2, icon_panel:getContentSize().height/2))
			-- cell:setPosition(cc.p(icon_panel:getContentSize().width/2, 0))
			ccui.Helper:seekWidgetByName(root, "Panel_13_pinzi"):setVisible(false)

			icon_panel:removeAllChildren(true)
			draw.sprite("sprite/spirte_2442.png", nil, 100, cc.rect(0, 0, 193, 89), cc.p(0.5, 0.5), icon_panel, nil, nil, cc.p(0.5, 0))
			if animationMode == 1 then
				app.load("client.battle.fight.FightEnum")
				local shipSpine = sp.spine_sprite(icon_panel, temp_bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					then
			        shipSpine:setScaleX(-1)
			    end
			else
				draw.createEffect("spirte_" .. temp_bust_index, "sprite/spirte_" .. temp_bust_index .. ".ExportJson", icon_panel, -1, nil, nil, cc.p(0.5, 0))
			end
		else
			local iconpinzi = ccui.Helper:seekWidgetByName(root, "Panel_13_pinzi")
			if __lua_project_id == __lua_project_digimon_adventure 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_yugioh 
				then 
				--icon_panel:setBackGroundImage(string.format("images/ui/props/props_%d.png", hero_icon))
				icon_panel:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", hero_icon-1000))
				iconpinzi:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", hero_color+1))
				iconpinzi:setVisible(false)
			else
				icon_panel:setBackGroundImage(string.format("images/face/hero_head/props_%d.png", hero_icon))
				if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
					iconpinzi:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", hero_color+1))
				else
					iconpinzi:setBackGroundImage(string.format("images/ui/quality/icon_hero_%d.png", hero_color+1))
				end
			end
		end
	elseif self.enum_type._HERO_REBORN == self.current_type then
		local cancel_button = ccui.Helper:seekWidgetByName(root, "Button_1") 
		cancel_button:setVisible(false)
	end
end

function HeroRefineryIcon:onEnterTransitionFinish()
	local csbItem = csb.createNode("refinery/refinery_generals_flash.csb")
	local action = csb.createTimeline("refinery/refinery_generals_flash.csb")
    action:gotoFrameAndPlay(0, action:getDuration(), false)
    -- action:setFrameEventCallFunc(function (frame)
        -- if nil == frame then
            -- return
        -- end

        -- local str = frame:getEvent()
        -- if str == "exit" then
           
        -- end
    -- end)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	root:runAction(action)
	
	self:onUpdateDraw()
	
	if self.enum_type._HERO_RESOLVE == self.current_type then
		local cancel_button = ccui.Helper:seekWidgetByName(root, "Button_1")
		fwin:addTouchEventListener(cancel_button, nil, 
		{
			terminal_name = "hero_resolve_cancel_one", 	
			terminal_state = 0, 
			_ship_id = self.instance_id,
			isPressedActionEnabled = true
		}, 
		nil, 2)
		
		
	end
end

function HeroRefineryIcon:onExit()
	
end

function HeroRefineryIcon:init(interfaceType, mouldId, instanceId)
	self.current_type = interfaceType
	self.mould_id = mouldId
	self.instance_id = instanceId
end

function HeroRefineryIcon:createCell()
	local cell = HeroRefineryIcon:new()
	cell:registerOnNodeEvent(cell)
	return cell
end