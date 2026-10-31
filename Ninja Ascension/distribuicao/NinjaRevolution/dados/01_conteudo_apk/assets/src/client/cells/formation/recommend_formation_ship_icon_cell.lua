----------------------------------------------------------------------------------------------------
-- 说明：图鉴图标绘制
----------------------------------------------------------------------------------------------------
RecommendFormationShipIconCell = class("RecommendFormationShipIconCellClass", Window)
RecommendFormationShipIconCell.__size = nil

function RecommendFormationShipIconCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.heroId = nil
	self._isLight = false
	-- Initialize adventure hero icon cell state machine.
	local function init_recommend_formation_ship_icon_cell_terminal()
        -- 显示武将信息
        local recommend_formation_ship_icon_cell_click_head_terminal = {
            _name = "recommend_formation_ship_icon_cell_click_head",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	--state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.Home)
				app.load("client.packs.hero.HeroPatchInformation")
				local cell = HeroPatchInformation:new()
				cell:init(params._datas._id, nil , nil, 2)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(recommend_formation_ship_icon_cell_click_head_terminal)	
        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_recommend_formation_ship_icon_cell_terminal()
end

function RecommendFormationShipIconCell:onEnterTransitionFinish()

end

function RecommendFormationShipIconCell:updateDraw()
	local roots = self.roots[1]
	local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
	local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
	Panel_kuang:removeBackGroundImage()
	Panel_head:removeBackGroundImage()
	local heroData = nil
	if self.heroId == 0 then 
		local user_info = nil
		for i = 2, 7 do
			local shipId = _ED.formetion[i]
			if tonumber(shipId) > 0 then
				local isleadtype = dms.int(dms["ship_mould"], _ED.user_ship[shipId].ship_template_id, ship_mould.captain_type)
				if tonumber(isleadtype) == 0 then
					user_info = _ED.user_ship[_ED.formetion[i]]
					break
				end
			end
		end
		self._isLight = true
		heroData = dms.element(dms["ship_mould"], user_info.ship_template_id)
	else
		heroData = dms.element(dms["ship_mould"], self.heroId)
	end
	
	local name = ccui.Helper:seekWidgetByName(roots, "Label_name")
	local quality = dms.atoi(heroData,ship_mould.ship_type)
	local pic = dms.atoi(heroData,ship_mould.head_icon)
	local quality_path = nil
	local big_icon_path = string.format("images/ui/props/props_%s.png", pic)
	Panel_kuang:setColor(cc.c3b(255, 255, 255))
	Panel_head:setColor(cc.c3b(255, 255, 255))
	Panel_head:setBackGroundImage(big_icon_path)
	local captain_type = dms.atoi(heroData, ship_mould.captain_type)
	if self._isLight == false then 
		Panel_head:setColor(cc.c3b(150, 150, 150))
		Panel_kuang:setColor(cc.c3b(150, 150, 150))
	end
	quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality)+1)
	Panel_kuang:setBackGroundImage(quality_path)
	
	name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		evo_mould_id = nil
		if self._isLight == true then
			local evo_image = dms.string(dms["ship_mould"], user_info.ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			evo_mould_id = evo_info[tonumber(ship_evo[1])]
		else
			local evo_image = dms.string(dms["ship_mould"], self.heroId, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			-- local ship_evo = zstring.split(self.ship.evolution_status, "|")
			evo_mould_id = evo_info[1]
		end
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		_name = word_info[3]
		name:setString(_name)	
	else
		if captain_type ~= 0 then 
			name:setString(dms.atos(heroData,ship_mould.captain_name))	
			fwin:addTouchEventListener(Panel_head, nil, 
			{
				terminal_name = "recommend_formation_ship_icon_cell_click_head", 	
				_id = self.heroId,
				terminal_state = 0,
			}, 
			nil, 0)
		else
			name:setString(_ED.user_info.user_name)	
		end
	end
end

function RecommendFormationShipIconCell:onInit()
	self.roots = {}
	local root = cacher.createUIRef("icon/item.csb", "root")
 	table.insert(self.roots, root)
 	root:setColor(cc.c3b(255, 255, 255))
 	self:addChild(root)
 	self.actions = {}
 	
	-- Get size for root node.
	if RecommendFormationShipIconCell.__size == nil then
		local size = root:getContentSize()
		RecommendFormationShipIconCell.__size = size
	end
	
	self:updateDraw()
end

function RecommendFormationShipIconCell:onExit()
	cacher.freeRef("icon/item.csb", self.roots[1])
	self.roots = {}
end

function RecommendFormationShipIconCell:init(heroId,light)
	self.heroId = heroId
	self._isLight = light
	self:onInit()
	self:setContentSize(RecommendFormationShipIconCell.__size)
	return self
end

function RecommendFormationShipIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RecommendFormationShipIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	root:stopAllActions()
	cacher.freeRef("icon/item.csb", root)
	root:removeFromParent(false)
	self.roots = {}
end

function RecommendFormationShipIconCell:createCell()
	local cell = RecommendFormationShipIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

