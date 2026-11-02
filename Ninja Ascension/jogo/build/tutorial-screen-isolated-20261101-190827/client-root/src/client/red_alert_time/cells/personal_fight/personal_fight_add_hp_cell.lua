PersonalFightAddHpCell = class("PersonalFightAddHpCellClass", Window)
PersonalFightAddHpCell.__size = nil

local personal_fight_add_hp_cell_create_terminal = {
    _name = "personal_fight_add_hp_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = PersonalFightAddHpCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(personal_fight_add_hp_cell_create_terminal)
state_machine.init()

function PersonalFightAddHpCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self._info = nil

    -- load lua file
    app.load("client.red_alert_time.cells.hero.hero_icon_cell")

    local function init_personal_fight_add_hp_cell_terminal()
        local personal_fight_add_hp_cell_update_slider_terminal = {
            _name = "personal_fight_add_hp_cell_update_slider",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                params[1]:updateSliderInfo(params[2])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(personal_fight_add_hp_cell_update_slider_terminal)
        state_machine.init()
    end
    init_personal_fight_add_hp_cell_terminal()
end

function PersonalFightAddHpCell:getTotalAddHp( ... )
    -- local lessHp = tonumber(self._info.ship_health) - tonumber(self._info.current_hp)
    -- local current_hp = 0
    -- if self._current_silder ~= nil then
    --     current_hp = lessHp*tonumber(self._current_silder)/100
    -- end
    return 0--math.ceil(current_hp)
end

function PersonalFightAddHpCell:onUpdateDraw()
    local root = self.roots[1]
    local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
    Panel_player_icon:removeAllChildren(true)
    local cell = state_machine.excute("hero_icon_create_cell", 0, {self._info, 4, 1})
    Panel_player_icon:addChild(cell)
    self:updateSliderInfo()
end

function PersonalFightAddHpCell:updateSliderInfo( )
    local root = self.roots[1]
    -- self._info.current_hp
    -- self._info.review_hp
    -- self._info.review_time
    local index = 0
    for i=2,6 do
        local ship_id = _ED.formetion[i]
        if tonumber(ship_id) > 0 then
            local ship = _ED.user_ship[""..ship_id]
            if ship ~= nil 
                and tonumber(ship.current_hp) < tonumber(ship.ship_health) 
                then
                index = index + 1
            end
        end
    end

    -- total_time = add_hp * (roleCount * 720) / max_hp
    
    -- _ED.personal_add_hp_cd_time_end - (os.time() + _ED.time_add_or_sub)

    -- index

    local Text_add_bolld = ccui.Helper:seekWidgetByName(root, "Text_add_bolld")
    local Text_all_bolld = ccui.Helper:seekWidgetByName(root, "Text_all_bolld")
    local LoadingBar_bolld = ccui.Helper:seekWidgetByName(root, "LoadingBar_bolld")
    Text_all_bolld:setString("/"..tonumber(self._info.ship_health))

    Text_add_bolld:setString(self._info.current_hp)
    LoadingBar_bolld:setPercent(tonumber(self._info.current_hp)/tonumber(self._info.ship_health))
end

function PersonalFightAddHpCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.palyer_build.palyer_build_add_blood_cell, "root")
    self:addChild(root)
    table.insert(self.roots, root)
    if PersonalFightAddHpCell.__size == nil then
        PersonalFightAddHpCell.__size = root:getContentSize()
    end
    
    self:onUpdateDraw()
end

function PersonalFightAddHpCell:reload()
    -- local root = self.roots[1]
    -- if root ~= nil then
    --     return
    -- end
    -- self:onInit()
end

function PersonalFightAddHpCell:unload()
    -- local root = self.roots[1]
    -- if root == nil then
    --     return
    -- end
    -- local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
    -- Panel_player_icon:removeAllChildren(true)
    -- cacher.freeRef(config_csb.cells.palyer_build.palyer_build_add_blood_cell, root)
    -- root:stopAllActions()
    -- root:removeFromParent(false)
    -- self.roots = {}
end

function PersonalFightAddHpCell:init(params)
    self._info = params[2]
    -- if params[1] < 5 then
        self:onInit()
    -- end
    self:setContentSize(PersonalFightAddHpCell.__size)
    return self
end

function PersonalFightAddHpCell:onExit()
    local Panel_player_icon = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_player_icon")
    if Panel_player_icon ~= nil then
        Panel_player_icon:removeAllChildren(true)
    end
    cacher.freeRef(config_csb.cells.palyer_build.palyer_build_add_blood_cell, self.roots[1])
end

