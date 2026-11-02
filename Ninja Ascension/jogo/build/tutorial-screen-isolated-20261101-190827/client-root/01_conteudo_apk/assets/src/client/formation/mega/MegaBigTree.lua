--------------------------------------------------------------------------------------------------------------
--  说明：超进化大阶数界面  
--------------------------------------------------------------------------------------------------------------
MegaBigTree = class("MegaBigTreeClass", Window)

local megabigtree_open_terminal = {
    _name = "megabigtree_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaBigTreeClass") == nil then           
            fwin:open(MegaBigTree:new():init(params), fwin._viewdialog)
        end
    end,
    _terminal = nil,
    _terminals = nil
}

local megabigtree_close_terminal = {
    _name = "megabigtree_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaBigTreeClass") then
            fwin:close(fwin:find("MegaBigTreeClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(megabigtree_open_terminal)
state_machine.add(megabigtree_close_terminal)
state_machine.init()

function MegaBigTree:ctor()
	self.super:ctor()
	self.roots = {}
    self.curpage = 1   --当前升级到的大阶数序号
    self.page = 1      --当前点击到的大阶数序号
    self.attacks = 0  --总攻击力
    self.lifes = 0    --总生命值
    self.defenses = 0 --总防御力
    self.cells = {}
    self.panels = {}
    self.heroinfo = {} --升级信息
    app.load("client.formation.mega.MegaWindow")
    app.load("client.cells.formation.mega_bigtree_cell")
    local function init_megabigtree_terminal()
        local init_megabigtree_unlock_terminal = {
            _name = "megabigtree_unlock",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
           _invoke = function(terminal, instance, params)
            local function callBack( response )
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                   instance:updateDrawInfo()
                   instance.curpage = instance.page
                end
            end
            local ability=dms.int(dms['ship_mould'],instance.ship.ship_template_id,ship_mould.ability)
            local requirements=dms.searchs(dms['mega_unblock'],2,ability,3,instance.page)
            if not requirements or not requirements[1] then return false end
            for _,condition in ipairs(zstring.splits(requirements[1][4],'|',',')) do
                if not instance:judgeType(tonumber(condition[1]),tonumber(condition[2]),tonumber(condition[3])) then
                    TipDlg.drawTextDailog(_new_interface_text[3])
                    return true
                end
            end
            protocol_command.mega_unblock.param_list = (instance.ship.ship_id).."\r\n"..(instance.page)
            NetworkManager:register(protocol_command.mega_unblock.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local init_megabigtree_updatebt_terminal = {
            _name = "megabigtree_updatebt",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
           _invoke = function(terminal, instance, params)
            local num = GetMegeDataByShipID(_ED.user_ship[instance.ship.ship_id].ship_template_id, false)

            num = tonumber(num[1][7])
            if (params._datas.page > num) or params._datas.page > instance.curpage + 1 then
               TipDlg.drawTextDailog(_new_interface_text[113])

            else
               instance.page = params._datas.page
               instance:updateDrawInfo()
               state_machine.excute("megawindow_update",0,{instance.page})  
               instance:switichIcon()
            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local init_megabigtree_changepage_terminal = {
            _name = "megabigtree_changepage",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
           _invoke = function(terminal, instance, params)
             state_machine.excute("megawindow_enter",0,{params._datas.isbig, params._datas.page})   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(init_megabigtree_unlock_terminal) 
        state_machine.add(init_megabigtree_updatebt_terminal)
        state_machine.add(init_megabigtree_changepage_terminal)
        state_machine.init()
    end 
    init_megabigtree_terminal()
end

function MegaBigTree:updateDraw()
    if not _ED.mega_info or not self.ship  then
      return
    end
    local jsonFile = "images/ui/effice/spirte_zhuangshi/spirte_zhuangshi.json"      --背景光效
    local atlasFile = "images/ui/effice/spirte_zhuangshi/spirte_zhuangshi.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    local Panel_evolu_effect_zhuangshi = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_evolu_effect_zhuangshi") 
    Panel_evolu_effect_zhuangshi:removeAllChildren(true) 
    Panel_evolu_effect_zhuangshi:addChild(animation)
    
    local jsonFile = "images/ui/effice/spirte_dtbj/spirte_dtbj.json"                --背景动画
    local atlasFile = "images/ui/effice/spirte_dtbj/spirte_dtbj.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    local Panel_evolu_effect_dtbj = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_evolu_effect_dtbj") 
    Panel_evolu_effect_dtbj:removeAllChildren(true) 
    Panel_evolu_effect_dtbj:addChild(animation)

    local jsonFile = "images/ui/effice/spirte_jinglingqiu/spirte_jinglingqiu.json"                --精灵球动画
    local atlasFile = "images/ui/effice/spirte_jinglingqiu/spirte_jinglingqiu.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    local Panel_evolu_effect_jinglingqiu = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_evolu_effect_jinglingqiu") 
    Panel_evolu_effect_jinglingqiu:removeAllChildren(true) 
    Panel_evolu_effect_jinglingqiu:addChild(animation)


    local heroinfo = {}
    local count= 0
    for k,v in pairs(_ED.mega_info) do
        if v.shipId == self.ship.ship_id then
            heroinfo = v.info
        end
    end
    if type(heroinfo) == "string" then heroinfo = json.decode(heroinfo) end
    heroinfo = heroinfo or {}
    heroinfo.megaLevel = heroinfo.megaLevel or {}
    heroinfo.megaUse = heroinfo.megaUse or {}
    if heroinfo.megaLevel then
       for k,v in pairs(heroinfo.megaLevel) do
         count = count + 1
       end
       self.curpage = count
    end
    if self.ship then
        local currShip = self.ship  
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            currShip = getShipByTalent(_ED.user_ship[self.ship.ship_id])
        end   
        local num = 8
        for i =1,tonumber(num) do
            local Panel_light_ing = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_evolution_schedule_%d",i))
            local cell = MegaBigtreeCell:createCell()
            table.insert(self.cells,cell)
            table.insert(self.panels,Panel_light_ing)
            cell:init(heroinfo.megaLevel[tostring(i)],i)
            Panel_light_ing:addChild(cell)
            fwin:addTouchEventListener(Panel_light_ing, nil, 
            {
                terminal_name = "megabigtree_updatebt", 
                terminal_state = 0, 
                isPressedActionEnabled = true,
                page = i
            }, nil, 0)   
        end
        self:switichIcon()
    end
end

function MegaBigTree:judgeType(tpyed,infoone,infotwo)
    if tpyed == 1 then  --星級等數
       return (tonumber(_ED.user_ship[self.ship.ship_id].StarRating) >= infotwo) 
    elseif tpyed == 2 then  --進階等級
       return (tonumber(_ED.user_ship[self.ship.ship_id].Order) >= infotwo) 
    elseif tpyed == 3 then  --心魂等級
       local info = zstring.splits(_ED.user_ship[self.ship.ship_id].ship_fighting_spirit,"|",",") 
       local faction_id = zstring.split(dms.string(dms["ship_mould"], _ED.user_ship[self.ship.ship_id].ship_template_id, ship_mould.faction_id),",")
       local lv = 0
       for i=1,#info do
           local unlock_condition = dms.int(dms["ship_soul_mould"], faction_id[i], ship_soul_mould.unlock_condition)
           if unlock_condition <=  tonumber(_ED.user_ship[self.ship.ship_id].Order) then
              lv =  lv + tonumber(info[i][1]) 
           end
       end
       return (lv >= infotwo) 
    elseif tpyed == 4 then  --超进化x阶x级
        local heroinfo = {}
        local page = 0 
        local idex = 0
        for k,v in pairs(_ED.mega_info) do
            if v.shipId == self.ship.ship_id then
                heroinfo = v.info
            end
        end
        if type(heroinfo) == "string" then heroinfo = json.decode(heroinfo) end
    heroinfo = heroinfo or {}
    heroinfo.megaLevel = heroinfo.megaLevel or {}
    heroinfo.megaUse = heroinfo.megaUse or {}
        if heroinfo.megaLevel then
           for k,v in pairs(heroinfo.megaLevel) do
             page = page + 1
           end
        end
        idex =  heroinfo.megaLevel[tostring(page)]
        if page > infoone then
          return true
        elseif  page == infoone then
          return idex >= infotwo
        else
          return false
        end
    elseif tpyed == 5 then  --装备总星数
       local info = zstring.splits(_ED.user_ship[self.ship.ship_id].equipInfo,"|",",") 
       local lv = 0
       for i=1,#(info[4]) do
           lv =  lv + tonumber(info[4][i]) 
       end
       return (lv >= infotwo) 
    elseif tpyed == 6 then  --合金总等级
        local info = _ED.user_ship[self.ship.ship_id].alloyMatrix.mmi
        local lv = 0
        if info then
            for k,v in pairs(info) do
                for i,s in pairs(v) do
                    local metal = (_ED.user_alloy_matrix or {})[tonumber(s)]
                    if not metal then return false end
                    local level = metal.metalLevel
                    lv = lv + level
                end
            end
        end
        return (lv >= infotwo)
    elseif tpyed == 7 or tpyed == 8 then  --关联宝可梦进阶等级
        local releheroid = GetMegeDataByShipID(_ED.user_ship[self.ship.ship_id].ship_template_id, false)

	     	releheroid = zstring.split(releheroid[1][6],",")
        if not releheroid  then
            return false
        end
     
            for k,v in pairs(releheroid) do
                local shipid = nil
                local info = getShipByTemplateId(v)
                if not info then
                    return false
                end    
                if info.ship_template_id == v  then
                     shipid = info.ship_id
                end
                if tpyed == 7 then
                    if tonumber(_ED.user_ship[shipid].Order) < infotwo then
                       return false
                    end
                elseif tpyed == 8 then
                    local heroinfo = {}
                    local page = 0 
                    local idex = 0
                    for k,v in pairs(_ED.mega_info) do
                        if v.shipId == shipid then
                            heroinfo = v.info
                        end
                    end
                    if type(heroinfo) == "string" then heroinfo = json.decode(heroinfo) end
    heroinfo = heroinfo or {}
    heroinfo.megaLevel = heroinfo.megaLevel or {}
    heroinfo.megaUse = heroinfo.megaUse or {}
                    if heroinfo.megaLevel then
                       for k,v in pairs(heroinfo.megaLevel) do
                         page = page + 1
                       end
                    end
                    idex =  heroinfo.megaLevel[tostring(page)]
                    if page < infoone then
                      return false
                    elseif  page == infoone then
                        if idex < infotwo then
                            return false 
                        end
                    end
                end
            end
                return true
    elseif tpyed == 9 then    --当前宝可梦合金
        local metalinfo = _ED.user_ship[self.ship.ship_id].alloyMatrix.mmi
        if not metalinfo then return false end
        local len = 0
        if metalinfo then
            local len =  0
             for k,v in pairs(metalinfo) do
                for i,s in pairs(v) do
                    len = len +1
                    local metal = (_ED.user_alloy_matrix or {})[tonumber(s)]
                    if not metal then return false end
                    local quality = dms.int(dms["ship_metal_mould"], metal.metalMould,ship_metal_mould.quality) 
                    if quality < infotwo then
                        return false
                    end
                end
            end
            if len < 18 then 
                return false
            end
        end
        return true
    end
end


function MegaBigTree:updateDrawInfo( )
    if not _ED.mega_info or not self.ship and not self.roots[1]  then
      return
    end

    local Image_unlock = ccui.Helper:seekWidgetByName(self.roots[1],"Image_unlock")

    local num = GetMegeDataByShipID(_ED.user_ship[self.ship.ship_id].ship_template_id, false)
    num = tonumber(num[1][7])
    if num == 0 then
        for i = 1,3 do
          local Text_condition = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Text_condition_%d",i))
          Text_condition:setVisible(false)
          local signno =  ccui.Helper:seekWidgetByName(self.roots[1], string.format("Image_no_%d",i))
          signno:setVisible(false)
          local signyes =  ccui.Helper:seekWidgetByName(self.roots[1], string.format("Image_yes_%d",i))
          signyes:setVisible(false)
        end
         Image_unlock:setVisible(true)
         return
    else
         Image_unlock:setVisible(false)
    end

    local heroinfo = {}
    local count=0
    for k,v in pairs(_ED.mega_info) do
        if v.shipId == self.ship.ship_id then
            heroinfo = v.info
        end
    end

    if type(heroinfo) == "string" then heroinfo = json.decode(heroinfo) end
    heroinfo = heroinfo or {}
    heroinfo.megaLevel = heroinfo.megaLevel or {}
    heroinfo.megaUse = heroinfo.megaUse or {}
    self.attacks = 0  --总攻击力
    self.lifes = 0    --总生命值
    self.defenses = 0 --总防御力
    if self.ship then
        local currShip = self.ship  
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            currShip = getShipByTalent(_ED.user_ship[self.ship.ship_id])
        end 
        local ability = dms.int(dms["ship_mould"], _ED.user_ship[self.ship.ship_id].ship_template_id,ship_mould.ability) 
        
       local releheroid = GetMegeDataByShipID(_ED.user_ship[self.ship.ship_id].ship_template_id, false)
	     releheroid = zstring.split(releheroid[1][6],",")
        for i= 1, 3 do
           local Text_condition = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Text_condition_%d",i))
           local info = {}
           info = zstring.splits((dms.searchs(dms["mega_unblock"], 2,ability,3,self.page))[1][4],"|",",") 
           info = info[i]
            local isgreen = self:judgeType(tonumber(info[1]),tonumber(info[2]),tonumber(info[3]))
            local signno =  ccui.Helper:seekWidgetByName(self.roots[1], string.format("Image_no_%d",i))
            local signyes =  ccui.Helper:seekWidgetByName(self.roots[1], string.format("Image_yes_%d",i))
           if isgreen then
             Text_condition:setColor(cc.c3b(0, 255, 0))
             signyes:setVisible(true)
             signno:setVisible(false)
           else 
             Text_condition:setColor(cc.c3b(255, 0, 0))
             signyes:setVisible(false)
             signno:setVisible(true)
           end
           local text = ""
            if tonumber(info[1]) == 9 then                                        
              text = string.format(tipStringInfo_maga_unlock[tonumber(info[1])], _ship_types_by_color[tonumber(info[3])+1])
            elseif tonumber(info[1]) == 2 then
              text = string.format(tipStringInfo_maga_unlock[tonumber(info[1])], tipStringInfo_maga_uplv[tonumber(info[3])]) 
            elseif tonumber(info[1]) == 7 or tonumber(info[1]) == 8 then
              local name = ""
              for k,v in pairs(releheroid) do
                local evo_image = dms.string(dms["ship_mould"], v, ship_mould.fitSkillTwo)
                local evo_info = zstring.split(evo_image, ",")
                local evo_mould_id = evo_info[dms.int(dms["ship_mould"], v, ship_mould.captain_name)]
                local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
                local word_info = dms.element(dms["word_mould"], name_mould_id)
                name = word_info[3].."  "..name
              end
                if tonumber(info[1]) == 7 then
                 text = name..string.format(tipStringInfo_maga_unlock[tonumber(info[1])],tipStringInfo_maga_uplv[tonumber(info[3])])
                else
                 text = name..string.format(tipStringInfo_maga_unlock[tonumber(info[1])],info[2],info[3])
                end
            elseif tonumber(info[2]) == -1 then
              text = string.format(tipStringInfo_maga_unlock[tonumber(info[1])],info[3])
            else
              text = string.format(tipStringInfo_maga_unlock[tonumber(info[1])],info[2],info[3])
            end
            Text_condition:setString(text)
        end

        local idexs = tonumber(heroinfo.megaLevel[tostring(self.page)])
        local info = {}
        if idexs then
            for i=0, idexs do
                info = zstring.splits(dms.searchs(dms["mega_property"], 2,ability,3,self.page)[1][i+4],"|",",")  
                self.attacks = info[1][2] + self.attacks 
                self.lifes =  info[3][2] + self.lifes
                self.defenses = info[2][2] + self.defenses
            end
        end 

        local Text_atk_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_atk_n")   --攻击
        Text_atk_n:setString(self.attacks)
        local Text_defense = ccui.Helper:seekWidgetByName(self.roots[1], "Text_defense_n")   --防御
        Text_defense:setString(self.defenses)
        local Text_life_n = ccui.Helper:seekWidgetByName(self.roots[1], "Text_life_n")    --生命
        Text_life_n:setString(self.lifes)
        local Text_attribute = ccui.Helper:seekWidgetByName(self.roots[1], "Text_attribute") 
        Text_attribute:setString(string.format(tipStringInfo_maga_unlock[10],self.page))
        
        local Panel_text_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_text_1")
        local Panel_text_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_text_2")
        if heroinfo.megaLevel[tostring(self.page)] then
            Panel_text_1:setVisible(true)
            Panel_text_2:setVisible(false)
        else
            Panel_text_1:setVisible(false)
            Panel_text_2:setVisible(true)
        end
        self.cells[self.page]:onUpdateDraw(self.curpage,num,heroinfo.megaLevel[tostring(self.page)])
    end
end


function MegaBigTree:switichIcon()
    if not self.cells then
        return
    end
    local num = GetMegeDataByShipID(_ED.user_ship[self.ship.ship_id].ship_template_id, false)
    num = tonumber(num[1][7])
    for k,v in pairs(self.cells) do
        v:onUpdateSwitch(self.page)
        v:onUpdateDraw(self.curpage,num)
    end
end


function MegaBigTree:onUpdate(dt)
    
end

function MegaBigTree:onEnterTransitionFinish()
    local csbNode = csb.createNode("packs/HeroStorage/sm_role_evolution_activation_cell.csb")
    local root = csbNode:getChildByName("root")                         
    table.insert(self.roots, root)
    self:addChild(csbNode)
  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_activation_unlock"), nil, 
    {
        terminal_name = "megabigtree_unlock", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        ship_id = self.ship.ship_id
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_activation"), nil, 
    {
        terminal_name = "megabigtree_changepage",
        terminal_state = 0, 
        isPressedActionEnabled = true,
        isbig = false,
        page = self.page
    }, nil, 0)
  
    self:updateDraw()
    self:updateDrawInfo()

end


function MegaBigTree:init(params)
    self.ship = params[1]
    self._rootWindows = params[2]
    self.page = params[3]
    return self
end

function MegaBigTree:onExit()
	self.cells = {}
    self.panels = {}
end