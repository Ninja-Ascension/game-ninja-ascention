HeroInfoUI = class("HeroInfoUIClass", Window)
HeroInfoUI.__userHeroFontName = nil
function HeroInfoUI:ctor()
    self.super:ctor()
    self.roots = {}
    
	self.armature = nil
	
	self.nControl = -1
	
	self.nKeepShow = 0
	
	self.bIsAttacking = false

	self.heroNameText = nil

	self._hero_type = 0
	
    -- Initialize HeroInfoUI state machine.
    local function init_hero_info_ui_terminal()
        -- local _terminal = {
            -- _name = "",
            -- _init = function (terminal)
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }

        -- state_machine.add(_terminal)
        -- state_machine.init()
    end

    -- call func init HeroInfoUI state machine.
    init_hero_info_ui_terminal()

end

function HeroInfoUI:onUpdateDraw()
	local csbHeroInfoUI = nil

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_2
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_3
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_4
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_7 
            or _ED.battleData.battle_init_type == _enum_fight_type._fight_type_218 
            then
            if self.armature._camp == 1 then
            	self._hero_type = 1
            	csbHeroInfoUI = csb.createNode("campaign/maoxian_battle_xuetiao.csb")
            else
            	csbHeroInfoUI = csb.createNode("card/battle_card.csb")
            end
        else
        	csbHeroInfoUI = csb.createNode("card/battle_card.csb")
        end
    else
		csbHeroInfoUI = csb.createNode("card/battle_card.csb")
	end

    local root = csbHeroInfoUI:getChildByName("root")
	root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
	self:setContentSize(root:getContentSize())

	self.heroNameText = ccui.Helper:seekWidgetByName(root, "Text_hero_name")
	
	local HPWidget = ccui.Helper:seekWidgetByName(root, "LoadingBar_xuetiao")
	if HPWidget ~= nil then
		HPWidget:setPercent(100)
	end

	if self._hero_type == 1 then
		
		local AtlasLabel_maoxian_xuetiao_n = ccui.Helper:seekWidgetByName(root, "AtlasLabel_maoxian_xuetiao_n")
		AtlasLabel_maoxian_xuetiao_n:setString("10")
		local LoadingBar_maoxian_xuetiao = ccui.Helper:seekWidgetByName(root, "LoadingBar_maoxian_xuetiao")
		LoadingBar_maoxian_xuetiao:setPercent(100)
		self._LoadingBar_maoxian_xuetiao = LoadingBar_maoxian_xuetiao
		self._LoadingBar_pic_index = 1
		self._LoadingBar_n_Count = 10
		self._LoadingBar_nc_Count = 10
		self._AtlasLabel_maoxian_xuetiao_n = AtlasLabel_maoxian_xuetiao_n
		self._LoadingBar_m_hp = self.armature._role._hp / self._LoadingBar_n_Count
		self._LoadingBar_mc_hp = self._LoadingBar_m_hp
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			if _ED.battleData.battle_init_type == _enum_fight_type._fight_type_7 then
				local maxHP = 0
			    local environment_formation1 = dms.int(dms["npc"], zstring.tonumber(_ED.union_attack_npc_id), npc.environment_formation1)
			    for i=1, 6 do
			        local environment_ship_id = dms.int(dms["environment_formation"], zstring.tonumber(environment_formation1), environment_formation.seat_one+i-1)
			        if environment_ship_id ~= 0 and environment_ship_id ~= nil then
			            maxHP = dms.int(dms["environment_ship"], environment_ship_id, environment_ship.power)
			            break
			        end
			    end
				-- if _ED.union_pve_info_current_hp ~= nil and _ED.union_pve_info_current_hp ~= 0 then
					if maxHP then
						self._LoadingBar_m_hp = maxHP / self._LoadingBar_n_Count
						self._LoadingBar_mc_hp = self._LoadingBar_m_hp
						self._LoadingBar_n_Count = math.ceil(self.armature._role._hp / self._LoadingBar_m_hp)
						AtlasLabel_maoxian_xuetiao_n:setString(self._LoadingBar_n_Count)
						local percent = (self.armature._role._hp % self._LoadingBar_m_hp) / self._LoadingBar_m_hp * 100
						LoadingBar_maoxian_xuetiao:setPercent(percent)
						self.armature._role._max_hp = maxHP
					end
				-- end
			elseif _ED.battleData.battle_init_type == _enum_fight_type._fight_type_218 then
			    local maxHP = tonumber(_ED.world_boss_info.maxHp)
				if maxHP then
					self._LoadingBar_m_hp = maxHP / self._LoadingBar_n_Count
					self._LoadingBar_mc_hp = self._LoadingBar_m_hp
					self._LoadingBar_n_Count = math.ceil(self.armature._role._hp / self._LoadingBar_m_hp)
					AtlasLabel_maoxian_xuetiao_n:setString(self._LoadingBar_n_Count)
					local percent = (self.armature._role._hp % self._LoadingBar_m_hp) / self._LoadingBar_m_hp * 100
					LoadingBar_maoxian_xuetiao:setPercent(percent)
					self.armature._role._max_hp = maxHP
				end
			end
		end
	end
end

function HeroInfoUI:controlLife(boolean, priority)
	if self._hero_type == 1 then
		return
	end
	
	-- 控制过程中无法调用showControl控制显示
	local _priority = zstring.tonumber(priority)
	
	-- if _priority == 0 then
		-- if boolean ~= false then
			-- self.nControl = 0
		-- else
			-- self.nControl = -1
		-- end
	-- end	
	
	-- if _priority > 0 and boolean == true then
		-- self.nControl = 2
	-- elseif _priority > 0 and boolean == false then
		-- self.nControl = -1
	-- end
	
	if boolean == true then
		if _priority > self.nControl then
			self.nControl = _priority
		end	
	elseif boolean == false then
		if _priority >= self.nControl then
			self.nControl = -1
		end
	end
end

function HeroInfoUI:keepShow(_time)
	if self._hero_type == 1 then
		return
	end

	if self.nControl >= 0 then
		return
	end	

	self:setVisible(true)
	local m_isShowMasterHp = cc.UserDefault:getInstance():getStringForKey("m_isShowMasterHp", "")
    -- 0 不显示 1显示
    if m_isShowMasterHp == nil or m_isShowMasterHp == "" or m_isShowMasterHp == "0" then
        self:setVisible(false)
    else
        self:setVisible(true)
    end
	self:controlLife(true, 2)
	self.nKeepShow = self.nKeepShow + 1
	local function keepOverFunc()
		self.nKeepShow = self.nKeepShow - 1 
		if self.nKeepShow <= 0 and self.bIsAttacking == false then
			self:controlLife(false, 2)
			self:showControl(attack_logic.__hero_ui_visible)
		end	
	end
	self:runAction(cc.Sequence:create(cc.DelayTime:create(_time), cc.CallFunc:create(keepOverFunc)))
end

function HeroInfoUI:udpateMasterPosition(boolean)
	local root = self.roots[1]
	local Image_tank_number_bg = ccui.Helper:seekWidgetByName(root, "Image_tank_number_bg")
	local NameWidget = ccui.Helper:seekWidgetByName(root, "Text_hero_name")
	Image_tank_number_bg:setPositionY(Image_tank_number_bg:getPositionY() - 54)
	NameWidget:setPositionY(NameWidget:getPositionY() - 54)
end

function HeroInfoUI:showControl(boolean)
	if self._hero_type == 1 then
		return
	end

	if self.nControl >= 0 then
		return
	end	
	local m_isShowMasterHp = cc.UserDefault:getInstance():getStringForKey("m_isShowMasterHp", "")
    -- 0 不显示 1显示
    if m_isShowMasterHp == nil or m_isShowMasterHp == "" or m_isShowMasterHp == "0" then
        self:setVisible(false)
        return
    else
        self:setVisible(true)
    end
	if __lua_project_id == __lua_project_rouge then
		self:setVisible(true)
		if self.armature._role._hp <= 0 then
			self:setVisible(false)
		end
		if boolean ~= false then
			self.heroNameText:setVisible(true)
		else
			self.heroNameText:setVisible(false)
		end
	else
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			self:setVisible(true)
		else
			if boolean ~= false then
				self:setVisible(true)
			else
				self:setVisible(false)
			end
		end
	end
end

function HeroInfoUI:hideControl(boolean)
	if __lua_project_id == __lua_project_rouge then
		self:setVisible(false)
	end
end

function HeroInfoUI:showRoleType(boolean)
	local root = self.roots[1]
	if self._hero_type == 1 then
		return
	end

	if boolean ~= false then
		local pve_leixing = 0
		
		if tonumber(self.armature._role._type) == 0 then
			pve_leixing = dms.int(dms["ship_mould"], self.armature._role._mouldId, ship_mould.capacity)
		else
			-- 只有 我方角色时  _original_mouldId 才被传入 (06/19) 
			-- 当前版本,只有我方显示类型异常所以只处理我方行为
 			local mid = self.armature._role._original_mouldId or self.armature._role._mouldId
			pve_leixing = dms.int(dms["environment_ship"], mid, environment_ship.capacity)
		end	
		
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		else	
			local PanelType = ccui.Helper:seekWidgetByName(root, "Panel_type")
			if pve_leixing ~= nil and nil ~= PanelType then 
				PanelType:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png", pve_leixing))
			end
		end
	end	
end

function HeroInfoUI:showRoleName(boolean)

	if self._hero_type == 1 then
		return
	end

	if boolean ~= false then
		local root = self.roots[1]
		
		if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
			local nCount = self.armature._brole._bcount
			local NameWidget = ccui.Helper:seekWidgetByName(root, "Text_hero_name")
			NameWidget:setString(nCount)

			local size = NameWidget:getContentSize()
			size.width = size.width + 5

			local Image_tank_number_bg = ccui.Helper:seekWidgetByName(root, "Image_tank_number_bg")
			Image_tank_number_bg:setContentSize(size)


			if nil == NameWidget._start_pos_x then
				NameWidget._start_pos_x = NameWidget:getPositionX()
			end
			NameWidget:setPositionX(NameWidget._start_pos_x - size.width / 2)

			if nil == Image_tank_number_bg._start_pos_x then
				Image_tank_number_bg._start_pos_x = Image_tank_number_bg:getPositionX()
			end
			Image_tank_number_bg:setPositionX(Image_tank_number_bg._start_pos_x - size.width / 2)
		else
			local heroId = self.armature._role._id
			local heroMouldId = self.armature._role._mouldId
			local heroQuality = zstring.tonumber(self.armature._role._quality)
			
			local heroName = self.armature._role._name
			
			if tonumber(self.armature._role._type) == 1 and tonumber(self.armature._camp) == 0 then
				local heroType = dms.string(dms["ship_mould"], heroMouldId, ship_mould.captain_type)
				if heroType == "0" then
					heroName = _ED.user_info.user_name
				end
			end	
			
			-- else
				-- heroName = dms.string(dms["environment_ship"], heroMouldId, environment_ship.ship_name)
			-- end
				
			if self.armature._role._name == "?" then
				heroName = _ED.user_info.user_name
			end
			
			local NameWidget = ccui.Helper:seekWidgetByName(root, "Text_hero_name")
			if ___is_open_leadname == true then
				if HeroInfoUI.__userHeroFontName == nil then
					HeroInfoUI.__userHeroFontName = NameWidget:getFontName()
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
					if tonumber(self.armature._role._type) == 1 then
						NameWidget:setFontName("")
						NameWidget:setFontSize(NameWidget:getFontSize())-->设置字体大小
					else
						NameWidget:setFontName(HeroInfoUI.__userHeroFontName)
					end
				else
					if dms.int(dms["ship_mould"], zstring.tonumber(heroMouldId), ship_mould.captain_type) == 0 then
						NameWidget:setFontName("")
						NameWidget:setFontSize(NameWidget:getFontSize())-->设置字体大小
					else
						NameWidget:setFontName(HeroInfoUI.__userHeroFontName)
					end
				end
			end
			NameWidget:setString(heroName)
			NameWidget:setColor(cc.c3b(color_Type[heroQuality+1][1],color_Type[heroQuality+1][2],color_Type[heroQuality+1][3]))
		end
	end	
end

function HeroInfoUI:showRoleHP()
	local root = self.roots[1]
	
	if self._hero_type == 1 then
		local percent = (self.armature._role._hp % self._LoadingBar_m_hp) / self._LoadingBar_m_hp * 100
		if percent > 100 then
			percent = 100
		end
		if percent < 0 then
			percent = 0
		end
		self._LoadingBar_maoxian_xuetiao:setPercent(percent)

		local nlCount = self._LoadingBar_n_Count
		self._LoadingBar_n_Count = math.ceil(self.armature._role._hp / self._LoadingBar_m_hp)
		if nlCount ~= self._LoadingBar_n_Count then
			self._AtlasLabel_maoxian_xuetiao_n:setString("" .. self._LoadingBar_n_Count)
			self._LoadingBar_pic_index = self._LoadingBar_pic_index + 1
			if self._LoadingBar_pic_index > 4 then
				self._LoadingBar_pic_index = 1
			end
			self._LoadingBar_maoxian_xuetiao:loadTexture("images/ui/battle/zd_xuetiao_0" .. self._LoadingBar_pic_index .. ".png")

			local poIdx = self._LoadingBar_pic_index + 1
			if poIdx > 4 then
				poIdx = 1
			end
			local Panel_xuetiao = ccui.Helper:seekWidgetByName(root, "Panel_xuetiao")
			Panel_xuetiao:removeBackGroundImage()
			if self._LoadingBar_n_Count > 1 then
				Panel_xuetiao:setBackGroundImage("images/ui/battle/zd_xuetiao_0" .. poIdx .. ".png")
			end
		end
		return
	end

	self.armature._role._hp = zstring.tonumber(self.armature._role._hp) < 0 and 0 or zstring.tonumber(self.armature._role._hp)
	local percent = self.armature._role._hp / self.armature._brole._hp * 100
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if self.armature._brole._max_hp ~= nil then
			percent = self.armature._role._hp / self.armature._brole._max_hp * 100
		end 
	end
	percent = percent > 100 and 100 or percent
	local HPWidget = ccui.Helper:seekWidgetByName(root, "LoadingBar_xuetiao")
	HPWidget:setPercent(percent)

	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then

	else
		local nCount = math.ceil(self.armature._role._hp / self.armature._brole._hp * self.armature._brole._bcount)
		local NameWidget = ccui.Helper:seekWidgetByName(root, "Text_hero_name")
		NameWidget:setString(nCount)

		local size = NameWidget:getContentSize()
		size.width = size.width + 5

		local Image_tank_number_bg = ccui.Helper:seekWidgetByName(root, "Image_tank_number_bg")
		Image_tank_number_bg:setContentSize(size)


		if nil == NameWidget._start_pos_x then
			NameWidget._start_pos_x = NameWidget:getPositionX()
		end
		NameWidget:setPositionX(NameWidget._start_pos_x - size.width / 2)

		if nil == Image_tank_number_bg._start_pos_x then
			Image_tank_number_bg._start_pos_x = Image_tank_number_bg:getPositionX()
		end
		Image_tank_number_bg:setPositionX(Image_tank_number_bg._start_pos_x - size.width / 2)
	end
end		

function HeroInfoUI:showRoleSP()
	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		return
	end
	
	local root = self.roots[1]
	
	if self._hero_type == 1 then
		return
	end

	local _multiPad = ccui.Helper:seekWidgetByName(root, "Panel_nuqix5")
	local _spNumber = ccui.Helper:seekWidgetByName(root, "AtlasLabel_1")
	local _multiIcon = ccui.Helper:seekWidgetByName(root, "Image_7")
	
	local _spIcon = {
		ccui.Helper:seekWidgetByName(root, "Image_3"),
		ccui.Helper:seekWidgetByName(root, "Image_3_0"),
		ccui.Helper:seekWidgetByName(root, "Image_3_1"),
		ccui.Helper:seekWidgetByName(root, "Image_3_2")
	}
	
	local _sp = self.armature._role._sp
	
	_spIcon[1]:setVisible(_sp > 0 and true or false)
	_spIcon[2]:setVisible(_sp > 1 and true or false)
	_spIcon[3]:setVisible(_sp > 2 and true or false)
	_spIcon[4]:setVisible(_sp > 3 and true or false)
	
	_multiPad:setVisible(_sp > 4 and true or false)
	_spNumber:setVisible(_sp > 4 and true or false)
	_multiIcon:setVisible(_sp > 4 and true or false)
	if _sp > 4 then
		_spNumber:setString("".._sp)
	end
end

function HeroInfoUI:init(_armature)
    self.armature = _armature
    local m_isShowMasterHp = cc.UserDefault:getInstance():getStringForKey("m_isShowMasterHp", "")
    -- 0 不显示 1显示
    if m_isShowMasterHp == nil or m_isShowMasterHp == "" or m_isShowMasterHp == "0" then
        self:setVisible(false)
    else
        self:setVisible(true)
    end
    self:onUpdateDraw()
    return self
end

function HeroInfoUI:createCell()
	local cell = HeroInfoUI:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

function HeroInfoUI:onExit()
    
end