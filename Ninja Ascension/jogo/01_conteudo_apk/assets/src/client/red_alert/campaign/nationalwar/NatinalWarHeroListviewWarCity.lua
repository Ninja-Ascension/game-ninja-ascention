-----------------------------
--头像列表
-----------------------------
NatinalWarHeroListviewWarCity = class("NatinalWarHeroListviewWarCityClass", Window)

local natinal_war_hero_listview_war_city_window_open_terminal = {
    _name = "natinal_war_hero_listview_war_city_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- if fwin:find("NatinalWarHeroListviewClass") == nil then
            fwin:open(NatinalWarHeroListviewWarCity:new():init(params))
        -- end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(natinal_war_hero_listview_war_city_window_open_terminal)
state_machine.init()

function NatinalWarHeroListviewWarCity:ctor()
    self.super:ctor()
    self.roots = {}
    self.icon_cells = {}
    -- Initialize natinal_war_hero_listview machine.
    local function init_natinal_war_hero_listview_war_city_terminal()
        -- 刷新血条
        local national_war_hero_listview_war_city_update_hp_terminal = {
            _name = "national_war_hero_listview_war_city_update_hp",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.onUpdateHp ~= nil then
                    instance:onUpdateHp()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(national_war_hero_listview_war_city_update_hp_terminal)    
        state_machine.init()
    end
    
    -- call func init national_war_decree machine.
    init_natinal_war_hero_listview_war_city_terminal()
end

function NatinalWarHeroListviewWarCity:onUpdateHp()
    for i,cell in ipairs(self.icon_cells) do
        state_machine.excute("national_war_hero_icon_update_hp",0,cell)
    end
end

function NatinalWarHeroListviewWarCity:onUpdateDraw()
    local root = self.roots[1]
    local index = 0

    for i,v in pairs(_ED.warfare_formation) do
        if index == 6 then
            return
        end
        index = index + 1
        local Panel_hero_head = ccui.Helper:seekWidgetByName(root,"Panel_hero_head_"..index)
        local cell = state_machine.excute("national_war_hero_icon_create_cell",0,{v})
        Panel_hero_head:addChild(cell)
        table.insert(self.icon_cells , cell)
    end

end

function NatinalWarHeroListviewWarCity:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.natinalwar_hero_listview)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self:onUpdateDraw() 
end

function NatinalWarHeroListviewWarCity:init(params)
    self._rootWindows = params[1]
    self:onInit()
    return self
end

function NatinalWarHeroListviewWarCity:onExit()
    state_machine.remove("national_war_hero_listview_war_city_update_hp")
end
