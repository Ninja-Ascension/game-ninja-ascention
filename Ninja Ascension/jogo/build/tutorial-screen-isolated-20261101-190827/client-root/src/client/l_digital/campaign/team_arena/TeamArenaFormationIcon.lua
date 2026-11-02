----------------------------------------------------------------------------------------------------
-- 说明：工会战阵型图标
-------------------------------------------------------------------------------------------------------
TeamArenaFormationIcon = class("TeamArenaFormationIconClass", Window)

local team_arena_formation_icon_create_terminal = {
    _name = "team_arena_formation_icon_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = TeamArenaFormationIcon:new()
        cell:init(params[1], params[2], params[3])
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(team_arena_formation_icon_create_terminal)
state_machine.init()

function TeamArenaFormationIcon:ctor()
    self.super:ctor()
	self.roots = {}

	self.ship = nil
	self.isInFormation = false
	self.index = 0
	self:setAnchorPoint(0.5,0.5)
	local function init_team_arena_formation_icon_terminal()
        --王者之战上阵
		local ship_head_cell_battle_kings_go_to_terminal = {
            _name = "ship_head_cell_battle_kings_go_to",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				local m_type = 0
				if ccui.Helper:seekWidgetByName(cell.roots[1], "Image_chuzhan"):isVisible() == false then
					if ShipIconCell.battle_kings_number >= 10 then
						return
					end
					ShipIconCell.battle_kings_number = ShipIconCell.battle_kings_number + 1
					ccui.Helper:seekWidgetByName(cell.roots[1], "Image_chuzhan"):setVisible(true)
					m_type = 0
				else
					ShipIconCell.battle_kings_number = ShipIconCell.battle_kings_number - 1
					ccui.Helper:seekWidgetByName(cell.roots[1], "Image_chuzhan"):setVisible(false)
					m_type = 1
				end
				state_machine.excute("sm_battleof_kings_start_go_to_battle", 0, {m_type, cell.ship})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		-- state_machine.add(ship_head_cell_battle_kings_go_to_terminal)
        state_machine.init()
	end
	init_team_arena_formation_icon_terminal()
end

function TeamArenaFormationIcon:onUpdateDraw()
	local root = self.roots[1]

	local Panel_ghz_line_pz_icon = ccui.Helper:seekWidgetByName(root, "Panel_ghz_line_pz_icon")
	local Panel_ghz_line_star_box = ccui.Helper:seekWidgetByName(root, "Panel_ghz_line_star_box")
	local Panel_ghz_line_icon = ccui.Helper:seekWidgetByName(root, "Panel_ghz_line_icon")
	local Image_ghz_line_up = ccui.Helper:seekWidgetByName(root, "Image_ghz_line_up")
	local Text_ghz_line_n = ccui.Helper:seekWidgetByName(root, "Text_ghz_line_n")
	local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
	self.Image_ghz_line_up = Image_ghz_line_up
	self.Image_choosed = ccui.Helper:seekWidgetByName(root, "Image_choosed")
	self:showFormation()
	
	Panel_ghz_line_pz_icon:removeAllChildren(true)
	Panel_ghz_line_star_box:removeAllChildren(true)
	Panel_ghz_line_icon:removeAllChildren(true)
	Panel_star:removeAllChildren(true)
	Image_ghz_line_up:setVisible(false)
	Text_ghz_line_n:setString("")
	if self.ship ~= nil then
		local picIndex = 0
		local quality = 0
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		local ship_evo = zstring.split(self.ship.evolution_status, "|")
		if ship_evo[2] == nil then
			picIndex = self.ship.evolution_status
		else
			local evo_mould_id = smGetSkinEvoIdChange(self.ship)
			if self.ship.skin_id and zstring.tonumber(self.ship.skin_id) ~= 0 then
		    	evo_mould_id = dms.int(dms["ship_skin_mould"], self.ship.skin_id, ship_skin_mould.ship_evo_id)
			end
			picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
		end
		quality = tonumber(self.ship.Order)

		local Panel_prop_icon = cc.Sprite:create(string.format("images/ui/props/props_%d.png", picIndex))
		Panel_prop_icon:setPosition(cc.p(Panel_ghz_line_icon:getContentSize().width/2, Panel_ghz_line_icon:getContentSize().height/2))
		Panel_ghz_line_icon:addChild(Panel_prop_icon)

		local Panel_kuang_icon = cc.Sprite:create(string.format("images/ui/quality/quality_frame_%d.png", quality+1))
		if Panel_kuang_icon ~= nil then
			Panel_kuang_icon:setPosition(cc.p(Panel_ghz_line_star_box:getContentSize().width/2, Panel_ghz_line_star_box:getContentSize().height/2))
			Panel_ghz_line_star_box:addChild(Panel_kuang_icon)
		end
		local Panel_ditu_icon = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", shipOrEquipSetColour(quality)))
		if Panel_ditu_icon ~= nil then
			Panel_ditu_icon:setPosition(cc.p(Panel_ghz_line_pz_icon:getContentSize().width/2, Panel_ghz_line_pz_icon:getContentSize().height/2))
			Panel_ghz_line_pz_icon:addChild(Panel_ditu_icon)
		end

		if self.isInFormation == true then
			Image_ghz_line_up:setVisible(true)
		end
		Text_ghz_line_n:setString(self.ship.ship_grade)
		neWshowShipStar(Panel_star, tonumber(self.ship.StarRating))

		-- pmc武将图标显示ssr
		if true then
			local ability = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ability)
			local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
			ssrIcon:setVisible(true)
			ssrIcon:loadTexture(string.format("images/ui/quality/quality_%d.png", ability))
		end
		
		if __lua_project_id == __lua_project_l_digital then 
			-- 武将限定卡SP标签
			local spIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
			DisplaySpCardTag(self.ship.ship_template_id, spIcon)
		else
			-- 武将限定卡显示
			local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
			if Panel_xianding then 
				Panel_xianding:setVisible(false)
				Panel_xianding:removeAllChildren(true)
				DisplayLimitCard(self.ship.ship_template_id ,Panel_xianding , 1)
			end
		end
	end
end

function TeamArenaFormationIcon:getFormationInfo( ... )
	return self.ship.ship_template_id..":"..self.ship.ship_grade..":"..self.ship.evolution_status..":"..self.ship.StarRating..":"..self.ship.Order..":"..self.ship.hero_fight..":"..self.ship.ship_id..":"..math.ceil(self.ship.ship_wisdom)
end

function TeamArenaFormationIcon:showFormation()
	self.Image_choosed:setVisible(self.isInFormation)
	self.Image_ghz_line_up:setVisible(self.isInFormation)
end


function TeamArenaFormationIcon:udpateCellInfo( ship, isInFormation, index )
	self.ship = ship
	self.isInFormation = isInFormation
	self.index = index
	self:onUpdateDraw()
end

function TeamArenaFormationIcon:onEnterTransitionFinish()
end

function TeamArenaFormationIcon:onInit()
	if table.getn(self.roots) > 0 then
		return
	end
	local root = cacher.createUIRef("campaign/cross_total_war/cross_total_war_line_up_icon.csb", "root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	self:setContentSize(root:getContentSize())

	self:onUpdateDraw()
	self:setTouchEnabled(true)
end

function TeamArenaFormationIcon:clearUIInfo( ... )
	local root = self.roots[1]
	local Panel_ghz_line_pz_icon = ccui.Helper:seekWidgetByName(root, "Panel_ghz_line_pz_icon")
	local Panel_ghz_line_star_box = ccui.Helper:seekWidgetByName(root, "Panel_ghz_line_star_box")
	local Panel_ghz_line_icon = ccui.Helper:seekWidgetByName(root, "Panel_ghz_line_icon")
	local Image_ghz_line_up = ccui.Helper:seekWidgetByName(root, "Image_ghz_line_up")
	local Text_ghz_line_n = ccui.Helper:seekWidgetByName(root, "Text_ghz_line_n")
	local Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")
	local ssrIcon = ccui.Helper:seekWidgetByName(root, "Image_quality")
	local Panel_xianding = ccui.Helper:seekWidgetByName(root, "Panel_xianding")
	if ssrIcon then
		ssrIcon:setVisible(false)
	end
	if Panel_xianding ~= nil then 
		Panel_xianding:removeAllChildren(true)
	end
	if Panel_ghz_line_pz_icon ~= nil then
		Panel_ghz_line_pz_icon:removeAllChildren(true)
		Panel_ghz_line_star_box:removeAllChildren(true)
		Panel_ghz_line_icon:removeAllChildren(true)
		Image_ghz_line_up:setVisible(false)
		Text_ghz_line_n:setString("")
		Panel_star:removeAllChildren(true)
	end
end

function TeamArenaFormationIcon:onExit()
	local root = self.roots[1]
	self:clearUIInfo()
	if root ~= nil then
		cacher.freeRef("campaign/cross_total_war/cross_total_war_line_up_icon.csb", root)
	    root:stopAllActions()
	    self:unregisterOnNoteUpdate(self)
	    root:removeFromParent(false)
	    self.roots = {}
	end
end

function TeamArenaFormationIcon:init(ship, isInFormation, index)
	self.ship = ship
	self.isInFormation = isInFormation
	self.index = index
	self:onInit()
end
