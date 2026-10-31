--------------------------------------------------------------------------------------------------------------
--  说明：超进化小阶数单个icon信息界面  
--------------------------------------------------------------------------------------------------------------
MegaIconInfo = class("MegaIconInfoClass", Window)

local megaiconinfo_open_terminal = {
    _name = "megaiconinfo_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaIconInfoClass") == nil then           
            fwin:open(MegaIconInfo:new():init(params), fwin._viewdialog)
        end
    end,
    _terminal = nil,
    _terminals = nil
}

local megaiconinfo_close_terminal = {
    _name = "megaiconinfo_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaIconInfoClass") then
            fwin:close(fwin:find("MegaIconInfoClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(megaiconinfo_open_terminal)
state_machine.add(megaiconinfo_close_terminal)
state_machine.init()

function MegaIconInfo:ctor()
    self.super:ctor()
    self.roots = {}   
end

function MegaIconInfo:updateDraw()
    if self.ship then
        local currShip = self.ship  
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            currShip = getShipByTalent(_ED.user_ship[self.ship.ship_id])
        end  
         
        local ability = dms.int(dms["ship_mould"],_ED.user_ship[self.ship.ship_id].ship_template_id,ship_mould.ability) 
      
        local info = {}
        info = zstring.splits(dms.searchs(dms["mega_property"], 2,ability,3,self.page)[1][self.idex+4],"|",",") 
        local Text_atk_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_attack_n")   --攻击
        Text_atk_n:setString(info[1][2])
        local Text_defense = ccui.Helper:seekWidgetByName(self.roots[1], "Text_defense_n")   --防御
        Text_defense:setString(info[2][2])
        local Text_life_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_life_n")    --生命
        Text_life_n:setString(info[3][2])

        local Text_effect = ccui.Helper:seekWidgetByName(self.roots[1], "Text_effect")  
        local Text_effect_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_effect_name")
        Text_effect:setString(tipStringInfo_maga_unlock[14])
        if self.idex == 10 then
           -- Text_effect:setVisible(true)
            local txt =  dms.searchs(dms["mega_property"], 2,ability,3,self.page)[1][16]
            Text_effect:setString(txt)
          --  Text_effect_name:setVisible(true)
        end
       
    end
end

function MegaIconInfo:updateDrawInfo( )
   
end


function MegaIconInfo:onUpdate(dt)
    
end

function MegaIconInfo:onEnterTransitionFinish()
    local csbNode = csb.createNode("packs/HeroStorage/sm_role_evolution_information.csb")
    local root = csbNode:getChildByName("root")                         
    table.insert(self.roots, root)
    self:addChild(csbNode)
    csbNode:setScale(0.7)
    csbNode:setPosition(self.posX,self.posY)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_dj_xx"), nil, 
    {
        terminal_name = "megaiconinfo_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 0)

    self:updateDraw()
    -- self:updateDrawInfo()
end


function MegaIconInfo:init(params)
    self.idex = params[1]
    self.posX =  params[2]
    self.posY =  params[3]
    self._rootWindows = params[4]
    self.ship = params[5]
    self.page = params[6]
    return self
end

function MegaIconInfo:onExit()
    
end