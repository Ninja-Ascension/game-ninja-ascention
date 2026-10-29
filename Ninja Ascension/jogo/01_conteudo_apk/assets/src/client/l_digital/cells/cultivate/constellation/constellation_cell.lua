----------------------------------------------------------------------------------------------------
-- 说明：星座数码兽控件
----------------------------------------------------------------------------------------------------
ConstellationCell = class("ConstellationCellClass", Window)
--  --红点
local constellation_ship_redot_update_terminal = {
    _name = "constellation_ship_redot_update",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = params
        local img_redot = ccui.Helper:seekWidgetByName(cell.roots[1],"Image_red")
        local is_show = false
        if not _ED.constellation_redot_data[tonumber(cell.constellation_mould_id)] then
            is_show = false
        else
            if not _ED.constellation_redot_data[tonumber(cell.constellation_mould_id)][tonumber(cell.index) - 1] then
                is_show = false
            else
                for k,v in pairs(_ED.constellation_redot_data[tonumber(cell.constellation_mould_id)][tonumber(cell.index) - 1]) do
                    if tonumber(v) == 0 then
                        is_show = true
                        break
                    else
                        is_show = false
                    end
                end
            end
        end
        img_redot:setVisible(is_show)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(constellation_ship_redot_update_terminal)
state_machine.init()

function ConstellationCell:ctor()
    self.super:ctor()
    self.roots = {}

    app.load("client.l_digital.cultivate.constellation.ConstellationShipInfo")
    app.load("client.l_digital.cultivate.constellation.ConstellationShipActivation")

	local function init_constellation_cell_terminal()
        local open_constellation_ship_info_terminal = {
            _name = "open_constellation_ship_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas._cell
                state_machine.excute("constellation_ship_info_open", 0, {cell.ship_template_id, cell.constellation_mould_id, cell.index, cell})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local constellation_ship_add_terminal = {
            _name = "constellation_ship_add",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas._cell
                state_machine.excute("constellation_ship_activation_open", 0, {cell.constellation_mould_id, cell.index, cell})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local constellation_ship_update_terminal = {
            _name = "constellation_ship_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params
                cell:initData()
                cell:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(open_constellation_ship_info_terminal)
		state_machine.add(constellation_ship_add_terminal)
        state_machine.add(constellation_ship_update_terminal)
        state_machine.init()
	end
	init_constellation_cell_terminal()
end

function ConstellationCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_xz_box_quality = ccui.Helper:seekWidgetByName(root,"Panel_xz_box_quality")
    local ship_icon = ccui.Helper:seekWidgetByName(root,"Panel_xz_hero_head")
    local Image_xz_hero_lock = ccui.Helper:seekWidgetByName(root,"Image_xz_hero_lock")
    local Image_xz_hero_add = ccui.Helper:seekWidgetByName(root,"Image_xz_hero_add")
    local ship_name = ccui.Helper:seekWidgetByName(root,"Text_xz_hero_name")
    local Text_xz_name = ccui.Helper:seekWidgetByName(root,"Text_xz_name")
    ship_name:setString("")
    Text_xz_name:setString("")
    ship_icon:removeBackGroundImage()
    Panel_xz_box_quality:setSwallowTouches(false)
    ship_icon:setSwallowTouches(false)

    local name_mould_id = dms.int(dms["constellation_mould"], self.constellation_mould_id, constellation_mould.constellation_name_id)
    local type_id = dms.int(dms["constellation_mould"], self.constellation_mould_id, constellation_mould.constellation_ship_type)
    local name = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
    Text_xz_name:setString(name)

    if self.ship_template_id ~= -1 then
        --进化形象
        local evo_image = dms.string(dms["ship_mould"], self.ship_template_id, ship_mould.fitSkillTwo)
        local initial_ship = dms.string(dms["ship_mould"], self.ship_template_id, ship_mould.captain_name)
        local evo_info = zstring.split(evo_image, ",")
        local quality = dms.int(dms["constellation_group"], self.group_id, constellation_group.level_id)
        -- --进化模板id
        local evo_mould_id = evo_info[zstring.tonumber(initial_ship)]
        if self.ship then
            evo_mould_id = smGetSkinEvoIdChange(self.ship)
        end

        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local name = dms.string(dms["word_mould"], name_mould_id, word_mould.text_info)
        local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
        ship_name:setString(name)   
        ship_name:setVisible(true)
        Text_xz_name:setVisible(true)
        if self.is_have then
            Panel_xz_box_quality:setBackGroundImage(string.format("images/ui/text/TF_res/galaxy/txk_%d.png", quality))
            ship_icon:setBackGroundImage(string.format("images/ui/pve_sn/props_%d.png", picIndex))
           
            
            ship_icon:setVisible(true)
            Image_xz_hero_add:setVisible(false)
            Image_xz_hero_lock:setVisible(false)
            Image_xz_hero_add:setTouchEnabled(false)


            fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_xz_box_quality"), nil, 
            {
                terminal_name = "open_constellation_ship_info", 
                terminal_state = 0, 
                _cell = self,
                touch_black = true,
            }, nil, 3)
        else
            ship_icon:setVisible(false)
            Image_xz_hero_add:setVisible(true)
            Image_xz_hero_lock:setVisible(false)
            Image_xz_hero_add:setTouchEnabled(true)
             fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_xz_hero_add"), nil, 
            {
                terminal_name = "constellation_ship_add", 
                terminal_state = 0, 
                _cell = self,
                touch_black = true,
            }, nil, 3)
        end
    else
        ship_name:setVisible(false)
        Text_xz_name:setVisible(false)
        ship_icon:setVisible(false)
        Image_xz_hero_add:setVisible(false)
        Image_xz_hero_lock:setVisible(true)
        Image_xz_hero_add:setTouchEnabled(false)
    end
end

function ConstellationCell:onInit()
    local csbDailyTaskListCell= csb.createNode("cultivate/constellation_cell.csb")
    local root = csbDailyTaskListCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
    state_machine.excute("constellation_ship_redot_update", 0, self)
    self:onUpdateDraw()
end

function ConstellationCell:onEnterTransitionFinish()
end

function ConstellationCell:onExit()
end

function ConstellationCell:initData()
    local use_ships = _ED.constellation_info.uc
    local is_use = false
    self.group_id = 0
    if not use_ships or not use_ships[self.constellation_mould_id] then
        is_use = false
    else
        for i,v in pairs(use_ships[self.constellation_mould_id]) do
            if v and tonumber(self.index) == tonumber(i) + 1 then
                is_use = true
                self.group_id = v
            end
        end
    end
    self.is_have = is_use
    for i,ship in pairs(_ED.user_ship) do
        if tonumber(ship.ship_template_id) == tonumber(self.ship_template_id) then
            self.ship = ship
        end
    end
end

function ConstellationCell:init(params)
    if params then
        self.ship_template_id = tonumber(params[1])
        self.constellation_mould_id = params[2] .. ""
        self.index = params[3] .. ""
    else
        return
    end
    self:initData()
    self:onInit()
end

function ConstellationCell:createCell()
	local cell = ConstellationCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

