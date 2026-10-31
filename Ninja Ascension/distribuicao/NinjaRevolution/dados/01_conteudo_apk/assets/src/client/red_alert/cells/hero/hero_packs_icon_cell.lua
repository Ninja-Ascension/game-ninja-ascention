--------------------------------------------------------------------------------------------------------------
--  说明：武将包裹 武将icon
--------------------------------------------------------------------------------------------------------------
HeroPacksIconCell = class("HeroPacksIconCellClass", Window)
HeroPacksIconCell.__size = nil

--创建cell
local hero_packs_icon_create_cell_terminal = {
    _name = "hero_packs_icon_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local ship = params[1]
        local from_type = params[2]
        local index = params[3]
		local drawType = params[4]
        local cell = HeroPacksIconCell:new()
        cell:init(ship, from_type , index ,drawType)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(hero_packs_icon_create_cell_terminal)
state_machine.init()

function HeroPacksIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.ship = nil
    self.from_type = nil  -- 1 武将包裹头像
	
	self.draw_type = 0
    
    app.load("client.red_alert.packs.herostorage.HeroPacksInformation")

	 -- Initialize hero_packs_icon_cell state machine.
    local function init_hero_packs_icon_cell_terminal()
		
        -- 点击响应
		local hero_packs_icon_cell_click_head_terminal = {
            _name = "hero_packs_icon_cell_click_head",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				local ship = cell.ship
				if zstring.tonumber(instance.draw_type) == 1 then
					local str = "1&|&".._ED.user_info.user_id.."&|&"..ship.ship_id.."&|&" .. cell._quality .."&|&"..ship.captain_name..""
					state_machine.excute("voice_send_message",0,str)
					state_machine.excute("hero_packs_window_close",0,"hero_packs_window_close.")
				else
					if cell.from_type == 1 then
						state_machine.excute("hero_packs_information_window_open",0,{ship}) 
					end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
    
		state_machine.add(hero_packs_icon_cell_click_head_terminal)
        state_machine.init()
    end
    
    -- call func hero_packs_icon_cell create state machine.
    init_hero_packs_icon_cell_terminal()

end

function HeroPacksIconCell:updateDraw()
    local root = self.roots[1]

    local picIndex = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.head_icon)
    local quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type)
    local name = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_name)
    self._quality = quality

    local Panel_head_icon = ccui.Helper:seekWidgetByName(root, "Panel_head_icon")
    local Panel_quality_box = ccui.Helper:seekWidgetByName(root, "Panel_quality_box")
    local Text_role_name = ccui.Helper:seekWidgetByName(root,"Text_role_name")
    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star")
    Panel_star:removeAllChildren(true)
    Panel_head_icon:removeBackGroundImage()
    Panel_quality_box:removeBackGroundImage()
    Panel_head_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
    Panel_quality_box:setBackGroundImage(string.format("images/ui/quality/hero_icon_quality_%d.png", quality)) 
    Text_role_name:setString(name)
    Text_role_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))

    local Image_outbound = ccui.Helper:seekWidgetByName(root,"Image_outbound")
    local Image_fetters = ccui.Helper:seekWidgetByName(root,"Image_fetters")
    Image_outbound:setVisible(false)
    Image_fetters:setVisible(false)
    if zstring.tonumber(self.ship.formation_index) > 0 then
        Image_outbound:setVisible(true)
    elseif zstring.tonumber(self.ship.little_partner_formation_index) > 0 then
        Image_fetters:setVisible(true)
    end
	if zstring.tonumber(self.draw_type) == 1 then
		Image_outbound:setVisible(false)
		Image_fetters:setVisible(false)
	end

    local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star")
    Panel_star:removeAllChildren(true)
    local stars,stars_level = getHeroStars(self.ship.ship_template_id)
    draw.addHeroStar(Panel_star,stars,stars_level)
end


function HeroPacksIconCell:onInit() 
    local root = cacher.createUIRef(config_csb.cells.hero.hero_packs_icon_cell,"root")
    self:addChild(root)
    table.insert(self.roots, root) 
    local Panel_head_box = ccui.Helper:seekWidgetByName(root, "Panel_head_box")
    if HeroPacksIconCell.__size == nil then
        local __size = Panel_head_box:getContentSize()
        HeroPacksIconCell.__size = __size
    end
    --点击
    fwin:addTouchEventListener(Panel_head_box, nil, 
    {
        terminal_name = "hero_packs_icon_cell_click_head", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:updateDraw()
end

function HeroPacksIconCell:onEnterTransitionFinish()

end

function HeroPacksIconCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function HeroPacksIconCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef(config_csb.cells.hero.hero_packs_icon_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function HeroPacksIconCell:init(ship,from_type,index,drawType)
    self.ship = ship
    self.from_type = from_type
	if drawType~= nil and drawType~= "" then
		self.draw_type = drawType
	end
    if index ~= nil and index < 7 then
	   self:onInit()
    end
    self:setContentSize(HeroPacksIconCell.__size)
end

function HeroPacksIconCell:onExit()
    cacher.freeRef(config_csb.cells.hero.hero_packs_icon_cell, self.roots[1])
end