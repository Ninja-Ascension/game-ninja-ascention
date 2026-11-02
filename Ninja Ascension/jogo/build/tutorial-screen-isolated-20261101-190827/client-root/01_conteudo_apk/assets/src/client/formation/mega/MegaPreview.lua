--------------------------------------------------------------------------------------------------------------
--  说明：超进化预览界面
--------------------------------------------------------------------------------------------------------------
MegaPreview = class("MegaPreviewClass", Window)

local megapreview_open_terminal = {
    _name = "megapreview_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaPreviewClass") == nil then           
            fwin:open(MegaPreview:new():init(params), fwin._viewdialog)
        end
    end,
    _terminal = nil,
    _terminals = nil
}

local megapreview_close_terminal = {
    _name = "megapreview_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaPreviewClass") then
            fwin:close(fwin:find("MegaPreviewClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(megapreview_open_terminal)
state_machine.add(megapreview_close_terminal)
state_machine.init()

function MegaPreview:ctor()
    self.super:ctor()
    self.roots = {}  
    app.load("client.cells.formation.mega_preview_cell")
end

function MegaPreview:updateDraw()
    local ListView_5 = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_5")   

    if self.ship then
        local currShip = self.ship  
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            currShip = getShipByTalent(_ED.user_ship[self.ship.ship_id])
        end   

        local ability = dms.int(dms["ship_mould"], _ED.user_ship[self.ship.ship_id].ship_template_id,ship_mould.ability)

          
        local info = {}
        info = dms.searchs(dms["mega_property"], 2,ability,3,1) 

        local num = GetMegeDataByShipID(_ED.user_ship[self.ship.ship_id].ship_template_id, false)
        num = tonumber(num[1][7])
        for i= 1,num do
            local attacks = 0  --总攻击力
            local lifes = 0    --总生命值
            local defenses = 0 --总防御力
            local skill = 0    --技能
            for k= 4 , 14 do
               info = zstring.splits(dms.searchs(dms["mega_property"], 2,ability,3,i)[1][k],"|",",") 
               attacks = info[1][2] + attacks
               lifes =  info[3][2] + lifes
               defenses =  info[2][2] + defenses
            end 
            local cell = state_machine.excute("magepreviewcell_create",0,{i,attacks,defenses,lifes,self.ship,ability})
            ListView_5:addChild(cell)
        end 
    end
end


function MegaPreview:onUpdate(dt)
    
end

function MegaPreview:onEnterTransitionFinish()
    local csbNode = csb.createNode("packs/HeroStorage/sm_role_evolution_preview_window.csb")
    local root = csbNode:getChildByName("root")                         
    table.insert(self.roots, root)
    self:addChild(csbNode)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "megapreview_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 0)

  
    self:updateDraw()
    -- self:updateDrawInfo()
end


function MegaPreview:init(params)
    self.ship = params._datas.ship
    return self
end

function MegaPreview:onExit()
    
end