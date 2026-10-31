--------------------------------------------------------------------------------------------------------------
--  国战城池战场角色名称显示
--------------------------------------------------------------------------------------------------------------
nationalWarCityWarHeroCell = class("nationalWarCityWarHeroCellClass", Window)
nationalWarCityWarHeroCell.__size = nil
nationalWarCityWarHeroCell.__fontName = ""

--创建cell
local national_war_city_war_hero_cell_create_terminal = {
    _name = "national_war_city_war_hero_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = nationalWarCityWarHeroCell:new()
        cell:init(params)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_war_city_war_hero_cell_create_terminal)
state_machine.init()

function nationalWarCityWarHeroCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.m_ship_info = nil

    -- Initialize national_task_cell state machine.
    local function init_national_war_city_war_hero_cell_terminal()
        
        --更新（状态） 创建一个
        local national_war_city_war_hero_cell_update_terminal = {
            _name = "national_war_city_war_hero_cell_update",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }



        state_machine.add(national_war_city_war_hero_cell_update_terminal)
        state_machine.init()
    end
    
    -- call func init national task cell state machine.
    init_national_war_city_war_hero_cell_terminal()

end


function nationalWarCityWarHeroCell:onInit(params)
    -- 绘图初始化
    local csbItem = csb.createNode(config_csb.cells.campaign.nationalwar.nationalwar_battle_hero)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    
    local Panel_camp = ccui.Helper:seekWidgetByName(root,"Panel_camp")
    local Text_role_name = ccui.Helper:seekWidgetByName(root,"Text_role_name")
    local index =  zstring.tonumber(self.m_ship_info.country)
    Panel_camp:setBackGroundImage(string.format("images/ui/play/nationalwar/camp_text_%d.png",index))
    if nationalWarCityWarHeroCell.__fontName == "" then 
        nationalWarCityWarHeroCell.__fontName = Text_role_name:getFontName()
    end
    if index ~= 0 and index ~= 4 then 
        if ___is_open_leadname == true then 
            Text_role_name:setFontName("")
            Text_role_name:setFontSize(Text_role_name:getFontSize() + 2)
        end
    end
    Text_role_name:setString(self.m_ship_info.userName)
end

function nationalWarCityWarHeroCell:onUpdate(dt)
    
end


function nationalWarCityWarHeroCell:init(params)
    self._rootWindows = params[1]  
    self.m_ship_info = params[2]  
    self:onInit(params)
    return self
end

function nationalWarCityWarHeroCell:onExit()
    state_machine.remove("national_war_city_war_hero_cell_update")
end
