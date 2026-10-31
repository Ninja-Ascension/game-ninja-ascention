-----------------------------
--结算头像
-----------------------------
NationalWarHeroBillingIcon = class("NationalWarHeroBillingIconClass", Window)

local national_war_hero_billing_icon_create_cell_terminal = {
    _name = "national_war_hero_billing_icon_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = NationalWarHeroBillingIcon:new()
        local ship = params[1]
        cell:init(ship)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_hero_billing_icon_create_cell_terminal)
state_machine.init()

function NationalWarHeroBillingIcon:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship = nil
    -- Initialize national_war_hero_icon machine.
    local function init_national_war_hero_icon_terminal()

        -- 刷新血条
        local national_war_hero_billing_icon_update_hp_terminal = {
            _name = "national_war_hero_billing_icon_update_hp",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                params:updateHP()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(national_war_hero_billing_icon_update_hp_terminal)    
        state_machine.init()
    end
    
    -- call func init national_war_hero_icon machine.
    init_national_war_hero_icon_terminal()
end

function NationalWarHeroBillingIcon:updateHP()
    
end

function NationalWarHeroBillingIcon:onUpdateDraw()
    local root = self.roots[1]

    self.panel_bolld = ccui.Helper:seekWidgetByName(root, "Panel_bolld")
    self.Sprite_bolld = self.panel_bolld:getChildByName("Sprite_bolld")
    local pos = cc.p(self.Sprite_bolld:getPosition())
    local anchor = self.Sprite_bolld:getAnchorPoint()
    local persent_hp = (zstring.tonumber(self.ship.lessHp)/zstring.tonumber(self.ship.maxHp) /2)  * 100
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
		persent_hp = (zstring.tonumber(self.ship.lessHp)/zstring.tonumber(self.ship.maxHp))  * 100
	else
		persent_hp = (zstring.tonumber(self.ship.lessHp)/zstring.tonumber(self.ship.maxHp) /2)  * 100
	end
        -- print("============lessHp=========",self.ship.lessHp,self.ship.maxHp,persent_hp)
	self.LoadingBar_bolld = ccui.Helper:seekWidgetByName(root,"LoadingBar_bolld")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
        self.LoadingBar_bolld:setPercent(persent_hp)
    else
		self.Sprite_bolld:removeFromParent(false)
		self.ProgressTimerBarBolld = cc.ProgressTimer:create(self.Sprite_bolld)
		self.Sprite_bolld:setAnchorPoint(anchor)
		self.ProgressTimerBarBolld:setPosition(pos)
		self.panel_bolld:addChild(self.ProgressTimerBarBolld)
		self.ProgressTimerBarBolld:setReverseDirection(false)
		self.ProgressTimerBarBolld:setPercentage(persent_hp)

		self.panel_angry = ccui.Helper:seekWidgetByName(root, "Panel_angry")
		self.Sprite_angry = self.panel_angry:getChildByName("Sprite_angry")
		local pos2 = cc.p(self.Sprite_angry:getPosition())
		local anchor2 = self.Sprite_angry:getAnchorPoint()

		local persent_bolld = 0
		self.Sprite_angry:removeFromParent(false)
		self.ProgressTimerBarBolld2 = cc.ProgressTimer:create(self.Sprite_angry)
		self.Sprite_angry:setAnchorPoint(anchor2)
		self.ProgressTimerBarBolld2:setPosition(pos2)
		self.panel_angry:addChild(self.ProgressTimerBarBolld2)
		self.ProgressTimerBarBolld2:setReverseDirection(true)
		self.ProgressTimerBarBolld2:setPercentage(persent_bolld)    
	end
    local user_ship = _ED.user_ship[self.ship.ship_id]
	local ship_mould_id = self.ship.ship_id
    local quality = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.ship_type)
	-- local quality = nil
	-- if self.ship.ship_id== nil then
	-- 	ship_mould_id = self.ship.shipMould
	-- 	quality = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.ship_type)
	-- else
	-- 	ship_mould_id = user_ship.ship_template_id
		
	-- end
    
    local Panel_battle_ui_icon = ccui.Helper:seekWidgetByName(root,"Panel_battle_ui_icon")
    local picIndex = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.head_icon)
    Panel_battle_ui_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex)) 
    local Panel_hero_quality = ccui.Helper:seekWidgetByName(root,"Panel_hero_quality")
    Panel_hero_quality:setBackGroundImage(string.format("images/ui/quality/hero_icon_quality_%d.png", quality))
    local Panel_battle_ui_icon_star = ccui.Helper:seekWidgetByName(root,"Panel_battle_ui_icon_star")
    local stars,stars_level = getHeroStars(ship_mould_id)
    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
    else
        draw.addHeroStar(Panel_battle_ui_icon_star,stars,stars_level)
    end
end

function NationalWarHeroBillingIcon:onInit()
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.nationalwar_hero_icon)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)

    local __size = root:getContentSize()
    self:setContentSize(__size)
    table.insert(self.roots, root)
    self:addChild(root)
    self:onUpdateDraw() 
end

function NationalWarHeroBillingIcon:init(ship)
    self.ship = ship
    self:onInit()
    return self
end

function NationalWarHeroBillingIcon:onExit()

end
