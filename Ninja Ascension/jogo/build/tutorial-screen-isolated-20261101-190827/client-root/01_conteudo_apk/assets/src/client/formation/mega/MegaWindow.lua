-- ----------------------------------------------------------------------------------------------------
-- 说明：超进化总界面
-------------------------------------------------------------------------------------------------------
MegaWindow = class("MegaWindowClass", Window)

local mega_window_open_terminal = {
    _name = "mega_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaWindowClass") == nil then           
            fwin:open(MegaWindow:new():init(params), fwin._viewdialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local mega_window_close_terminal = {
    _name = "mega_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaWindowClass") then
            fwin:close(fwin:find("MegaWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(mega_window_open_terminal)
state_machine.add(mega_window_close_terminal)
state_machine.init()

function MegaWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.page = 1
    app.load("client.formation.mega.MegaBigTree")
    app.load("client.formation.mega.MegaSmallTree")
    app.load("client.formation.mega.MegaPreview")
    app.load("client.formation.mega.MegaRuleInfo")
    local function init_megawindow_terminal()
        --切换界面
        local init_megawindow_enter_terminal = {
            _name = "megawindow_enter",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            instance:onUpdateDraw(params[1],instance.page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         
          --刷新界面
        local init_megawindow_update_terminal = {
            _name = "megawindow_update",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            instance.page = params[1]
            instance:onUpdateDrawinfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(init_megawindow_enter_terminal)
        state_machine.add(init_megawindow_update_terminal)
        state_machine.add(init_megawindow_rule_terminal)
        state_machine.init()
    end

    init_megawindow_terminal()
end

function MegaWindow:init(params)
    self.ship = params[1]
    self.equip = params[2]
    return self
end


function MegaWindow:onUpdate(dt)
end


function MegaWindow:onUpdateDraw(isbig,page)    --true为大阶数界面，false为小阶数界面
    local  Panel_realizable = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_realizable")
    Panel_realizable:removeAllChildren(true)
    if isbig then
      state_machine.excute("megasmalltree_close",0,nil)                          
      state_machine.excute("megabigtree_open",0,{self.ship, Panel_realizable,page})   --显示大阶数界面
    else
      state_machine.excute("megabigtree_close",0,nil)         
      state_machine.excute("megasmalltree_open",0,{self.ship,Panel_realizable,page})   --显示小阶数界面 
    end
end


function MegaWindow:onUpdateDrawinfo()
    if not _ED.mega_info then
        return
    end
    local  Text_name = ccui.Helper:seekWidgetByName(self.roots[1], "Text_name")
    local  Text_77 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_77")
    local  Text_progress_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_progress_n")
    local  Text_progress_t = ccui.Helper:seekWidgetByName(self.roots[1], "Text_progress_t") 
    local  Panel_strengthen_stye = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_evolution_tap_01")
           Panel_strengthen_stye:removeBackGroundImage()
    local  camp_preference = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.camp_preference)
    if camp_preference> 0 and camp_preference <=3 then
        Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
    end

    if self.ship ~= nil then
        local currShip = self.ship
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            currShip = getShipByTalent(_ED.user_ship[self.ship.ship_id])
        end

        local evo_mould_id = smGetSkinEvoIdChange(currShip)
        local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
        local word_info = dms.element(dms["word_mould"], name_mould_id)
        local name = word_info[3]
        
        if getShipNameOrder(tonumber(currShip.Order)) > 0 then
                name = name.." +"..getShipNameOrder(tonumber(currShip.Order))
        end
         
        local quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type) + 1
        local color_R = 0
        local color_G = 0
        local color_B = 0
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            quality = shipOrEquipSetColour(tonumber(self.ship.Order))
            color_R = tipStringInfo_quality_color_Type[quality][1]
            color_G = tipStringInfo_quality_color_Type[quality][2]
            color_B = tipStringInfo_quality_color_Type[quality][3]
        else
            color_R = tipStringInfo_quality_color_Type[quality][1]
            color_G = tipStringInfo_quality_color_Type[quality][2]
            color_B = tipStringInfo_quality_color_Type[quality][3]
        end
        Text_name:setColor(cc.c3b(color_R, color_G, color_B))
        Text_name:setString(name)
        Text_77:setString(currShip.hero_fight)
    end

    local heroinfo = {}
    for k,v in pairs(_ED.mega_info) do
        if v.shipId == self.ship.ship_id then
            heroinfo = v.info
        end
    end
    if type(heroinfo) == "string" then heroinfo = json.decode(heroinfo) end
    heroinfo = heroinfo or {}
    heroinfo.megaLevel = heroinfo.megaLevel or {}
    heroinfo.megaUse = heroinfo.megaUse or {}
    if heroinfo.megaLevel[tostring(self.page)] then
      Text_progress_n:setString(heroinfo.megaLevel[tostring(self.page)].."/10")
    else
      Text_progress_n:setString("0/10")  
    end
    Text_progress_t:setString(string.format(tipStringInfo_maga_unlock[12],self.page))
end


function MegaWindow:onEnterTransitionFinish()
  
    local csbNode = csb.createNode("packs/HeroStorage/sm_role_evolution_tab.csb")
    local root = csbNode:getChildByName("root")                         
    table.insert(self.roots, root)
    self:addChild(csbNode)
 
     -- 预览
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_jhyn"), nil, 
    {
        terminal_name = "megapreview_open", 
        isPressedActionEnabled = true,
        ship = self.ship 
    },
    nil, 0)
      -- 规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tips"), nil, 
    {
        terminal_name = "megaruleinfo_open", 
        isPressedActionEnabled = true,
        ship = self.ship 
    },
    nil, 0)
   
    self:onUpdateDraw(true,self.page)
    self:onUpdateDrawinfo()
    self:registerOnNoteUpdate(self, 1)
end

function MegaWindow:onExit()
  
end 
