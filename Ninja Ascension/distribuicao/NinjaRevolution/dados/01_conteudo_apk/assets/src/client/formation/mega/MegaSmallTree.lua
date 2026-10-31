--------------------------------------------------------------------------------------------------------------
--  说明：超进化小阶数界面
--------------------------------------------------------------------------------------------------------------
MegaSmallTree = class("MegaSmallTreeClass", Window)

local megasmalltree_open_terminal = {
    _name = "megasmalltree_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaSmallTreeClass") == nil then           
            fwin:open(MegaSmallTree:new():init(params), fwin._viewdialog)
        end
    end,
    _terminal = nil,
    _terminals = nil
}

local megasmalltree_close_terminal = {
    _name = "megasmalltree_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaSmallTreeClass") then
            fwin:close(fwin:find("MegaSmallTreeClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}


state_machine.add(megasmalltree_open_terminal)
state_machine.add(megasmalltree_close_terminal)
state_machine.init()

function MegaSmallTree:ctor()
    self.super:ctor()
    self.roots = {}
    self.curidex = 0   --当前的升级到哪个小阶数序号
    self.idex = 1  --当前点击到哪个小阶数序号
    self.cells = {}
    self.panels = {}
    self.attacks = 0  --总攻击力
    self.lifes = 0    --总生命值
    self.defenses = 0 --总防御力
    app.load("client.cells.formation.mega_smalltree_cell")
    app.load("client.formation.mega.MegaIconInfo")
    app.load("client.formation.mega.MegaUnlockSuccess")
    app.load("client.formation.mega.MegaWindow")
    app.load("client.formation.mega.MegaTipinfo")
    app.load("client.cells.formation.mega_preview_cell")
    app.load("client.packs.hero.SmRoleStrengthenTabSkillDescription")
    app.load("client.cells.utils.resources_icon_cell")
    local function init_megasmalltree_terminal()
        local init_megasmalltree_unlock_terminal = {
            _name = "megasmalltree_unlock",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
           _invoke = function(terminal, instance, params)
            local function callBack( response )
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                        instance.curidex = instance.curidex + 1
                        instance:updateDraw(true)
                        instance:switichIcon()
                        state_machine.excute("megawindow_update",0,{instance.page})
                    end
                end
            end
            protocol_command.mega_level_up.param_list = (instance.ship.ship_id).."\r\n"..(instance.page)
            NetworkManager:register(protocol_command.mega_level_up.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local init_megasmalltree_updatebt_terminal = {
            _name = "megasmalltree_updatebt",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
           _invoke = function(terminal, instance, params)
                instance.idex = params._datas.idex
                local posX = instance.panels[instance.idex]:getPositionX()
                local posY = instance.panels[instance.idex]:getPositionY()
                state_machine.excute("megaiconinfo_open",0,{instance.idex,posX,posY,instance.roots[1],instance.ship,instance.page})           
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
       
        local init_megasmalltree_changepage_terminal = {
            _name = "megasmalltree_changepage",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            state_machine.excute("megawindow_enter",0,{params._datas.isbig,instance.page})   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local init_megasmalltree_skill_terminal = {
            _name = "megasmalltree_skill",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
        _invoke = function(terminal, instance, params)
            local shipInfo = _ED.user_ship[""..instance.ship.ship_id]
            state_machine.excute("sm_role_strengthen_tab_skill_description_open",0,{shipInfo,params._datas.talentMouldid,params._datas.idex,true})
            return true
        end,
        _terminal = nil,
        _terminals = nil
    }

        local init_megasmalltree_isuse_skill_terminal = {
            _name = "megasmalltree_isuse_skill",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            instance:judgeIsSkill()
                        end
                    end
                end
               
                protocol_command.mega_use_skill.param_list = (instance.ship.ship_id).."\r\n"..(instance.page).."\r\n"..params._datas.isuse
                NetworkManager:register(protocol_command.mega_use_skill.code, nil, nil, nil, instance, callBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(init_megasmalltree_unlock_terminal) 
        state_machine.add(init_megasmalltree_changepage_terminal)
        state_machine.add(init_megasmalltree_updatebt_terminal)
        state_machine.add(init_megasmalltree_skill_terminal)
        state_machine.add(init_megasmalltree_isuse_skill_terminal)
        state_machine.init()
    end 
    init_megasmalltree_terminal()
end


function MegaSmallTree:updateDraw(isopen)   --isopen true代表可以进入激活成功界面
    if not _ED.mega_info or not self.ship  then
      return
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
    self.attacks = 0
    self.lifes =  0
    self.defenses = 0
    if self.ship then
        local currShip = self.ship  
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            currShip = getShipByTalent(_ED.user_ship[self.ship.ship_id])
        end  
        local Panel_attribute = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_attribute")   --特殊屬性 
        local Panel_skill = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_skill")   --技能
        local Panel_quality = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_quality")   --8门特效

        local ability = dms.int(dms["ship_mould"], _ED.user_ship[self.ship.ship_id].ship_template_id,ship_mould.ability) 
        local info = {}
              info = zstring.splits(dms.searchs(dms["mega_property"], 2,ability,3,self.page)[1][self.curidex+4],"|",",") 
      
        local idexs = tonumber(heroinfo.megaLevel[tostring(self.page)])
        if idexs then
            for i=0, idexs do
                info = zstring.splits(dms.searchs(dms["mega_property"], 2,ability,3,self.page)[1][i+4],"|",",")  
                self.attacks = info[1][2] + self.attacks 
                self.lifes =  info[3][2] + self.lifes
                self.defenses = info[2][2] + self.defenses
            end
            if self.curidex < 10 then
               local expend = zstring.splits(dms.searchs(dms["mega_expend"], 2,ability,3,self.page)[1][self.curidex+4],"|",",")  --消耗 
                    for i =1, #expend do
                        if i == 1 then
                            local Text_consume_t = ccui.Helper:seekWidgetByName(self.roots[1], "Text_consume_t")   --消耗金币
                            Text_consume_t:setString(expend[i][2]) 
                        else
                            local cell = self:judgeType(tonumber(expend[i][1]),expend[i][2])
                            local Panel_consume_icon = nil
                            Panel_consume_icon = ccui.Helper:seekWidgetByName(self.roots[1],string.format("Panel_consume_icon_%d",i))
                            Panel_consume_icon:removeAllChildren(true)
                            if cell then
                               Panel_consume_icon:addChild(cell)
                            end
                        end
                    end
            else
                if self.page == 1 or  self.page == 3 or  self.page == 5 or self.page == 7 then
                    local talent_id =  dms.searchs(dms["mega_property"],2,ability,3,self.page)[1][15]
                    local talen_info = zstring.split(dms.string(dms["talent_mould"], talent_id, talent_mould.base_additional),",") 
                     
                    local Text_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_1")  
                    local Text_crit = ccui.Helper:seekWidgetByName(self.roots[1], "Text_crit") 
                    local txt_1 = tonumber(talen_info[1])
                    local txt_2 = tonumber(talen_info[2]) 
                   
                    local temp1 = tipStringInfo_trialTower_attribute_info[txt_1+1][1]
                    local temp2 = tipStringInfo_trialTower_attribute_info[txt_1+1][2]
                    local temp3 = string.format(temp2,txt_2)
                    Text_1:setString(tipStringInfo_maga_unlock[13].."  "..temp1)
                    Text_crit:setString(""..temp3.."%")
                  
                    Panel_attribute:setVisible(true)
                    Panel_skill:setVisible(false)
                    Panel_quality:setVisible(false)
                elseif self.page == 8 then
                    Panel_attribute:setVisible(false)
                    Panel_skill:setVisible(false)
                    Panel_quality:setVisible(true)

                    local ability = dms.int(dms["ship_mould"], _ED.user_ship[self.ship.ship_id].ship_template_id,ship_mould.ability)
                    local Text_before = ccui.Helper:seekWidgetByName(self.roots[1], "Text_before")
                    Text_before:setString(ability)

                    local num = GetMegeDataByShipID(_ED.user_ship[self.ship.ship_id].ship_template_id, false)
                    num = tonumber(num[1][8])
                    local Text_after = ccui.Helper:seekWidgetByName(self.roots[1], "Text_after")
                    Text_after:setString(num)
                else
                    Panel_attribute:setVisible(false)
                    Panel_skill:setVisible(true)
                    Panel_quality:setVisible(false)
                        
                    local skillinfo = GetMegeDataByShipID(_ED.user_ship[self.ship.ship_id].ship_template_id, false)
                    local skill_evo_mould_id = 0
                    local skill_mould_id = 0

                    if self.page == 2 then
                        skillinfo = skillinfo[1][3]
                        skillinfo =  zstring.splits(skillinfo,"|",",")
                      
                    elseif self.page == 4 then
                        skillinfo = skillinfo[1][4]
                        skillinfo =  zstring.splits(skillinfo,"|",",")
                     elseif self.page == 6 then
                        skillinfo = skillinfo[1][5]
                        skillinfo =  zstring.splits(skillinfo,"|",",")
                    end
                
                    local ship = fundShipWidthId(self.ship.ship_id)
                    local evo_mould_id = smGetSkinEvoIdChange(ship)
                    local level_groun_icon = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.level_groun_icon)
                    skill_evo_mould_id = tonumber(skillinfo[level_groun_icon][2]) 

                    local talent = zstring.splits(dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index),"|",",")  
                    local idex = tonumber(skillinfo[level_groun_icon][1]) 
                    local newidex = idex

                    if idex == 3 then
                       skill_mould_id = tonumber(talent[4][3]) 
                       newidex = 4
                    else
                       skill_mould_id = tonumber(talent[idex][3]) 
                    end
                    local Panel_jn_icon_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_evolution_ioc_z")  --技能1
                    Panel_jn_icon_1:removeBackGroundImage()
                    local pic_index = dms.int(dms["talent_mould"], skill_mould_id, talent_mould.new_skill_pic)
                    Panel_jn_icon_1:setBackGroundImage(string.format("images/ui/skills/skills_%d.png", pic_index))
                     fwin:addTouchEventListener(Panel_jn_icon_1, nil, 
                    {
                        terminal_name = "megasmalltree_skill", 
                        terminal_state = 0, 
                        isPressedActionEnabled = true,
                        talentMouldid = skill_mould_id,
                        idex = newidex
                    }, nil, 0)   

                    local Panel_jn_icon_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_evolution_ioc_y")  --技能2
                    Panel_jn_icon_2:removeBackGroundImage()
                    local pic_index = dms.int(dms["talent_mould"], skill_evo_mould_id, talent_mould.new_skill_pic)
                    Panel_jn_icon_2:setBackGroundImage(string.format("images/ui/skills/skills_%d.png", pic_index))
                     fwin:addTouchEventListener(Panel_jn_icon_2, nil, 
                    {
                        terminal_name = "megasmalltree_skill", 
                        terminal_state = 0, 
                        isPressedActionEnabled = true,
                        talentMouldid = skill_evo_mould_id,
                        idex = newidex
                    }, nil, 0)   

                end
                local Panel_consume = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_consume")   
                      Panel_consume:setVisible(false)
            end
        end     
        
        local allinfo = {self.curidex,self.attacks, self.attacks-info[1][2] ,self.lifes, self.lifes-info[3][2], self.defenses,self.defenses-info[2][2],self.page,self.ship}
        if isopen then
            --激活成功的界面所用数据
            if self.curidex == 10 and self.page == 6  then
                state_machine.excute("megatipinfo_open",0,allinfo)  
            else
                state_machine.excute("megaunlocksuccess_open",0,allinfo)   
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
        
        local Panel_number = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_number") 
        Panel_number:setBackGroundImage(string.format("images/ui/text/evolution/number_evolution_0%d.png",self.page))
        self.circleProgressBar:setPercentage(self.curidex*10)
    
        if idexs == 10 then
            local Text_evo_act_all = ccui.Helper:seekWidgetByName(self.roots[1], "Text_evo_act_all")   
            Text_evo_act_all:setVisible(true)
            local Button_activation = ccui.Helper:seekWidgetByName(self.roots[1], "Button_activation")   
            Button_activation:setVisible(false)  
        end
    end
end

function MegaSmallTree:judgeType(tooltype,num)   --根据类型创建不同的道具cell
    local ship_template_id = tonumber(_ED.user_ship[self.ship.ship_id].ship_template_id) 
    local info = zstring.split(dms.string(dms["ship_mould"], ship_template_id, 73),",")   --取初始化裝備
    if tooltype == 1 or  tooltype == 6 then
       local material = dms.searchs(dms["prop_mould"], prop_mould.use_of_ship, tonumber(_ED.user_ship[self.ship.ship_id].ship_template_id))
        if material ~= nil then
            for i=1, #material do
                if tonumber(material[i][9]) == 1 then
                    local  prop = 0 
                    if tooltype == 1 then
                       prop = material[i][1] --道具模板id
                    elseif  tooltype == 6 then
                       -- PC fix: show the fragment mould charged by the server.
                       prop = cc.Application:getInstance():getTargetPlatform()==cc.PLATFORM_OS_WINDOWS and material[i][1] or material[i][9] 
                    end
                    local cell = ResourcesIconCell:createCell()
                    cell:init(cell.enum_type.PROP_INFORMATION,num,prop,nil,nil,true,true,1)
                    return  cell                 
                end
            end
        end
    elseif tooltype == 3 then
        local propMould = 223  --覺醒合金 不会改变
        local cell = ResourcesIconCell:createCell()
              cell:init(cell.enum_type.PROP_INFORMATION,num,propMould,nil,nil,true,true,1)
            return cell
    elseif tooltype == 4 then
        local prop = tonumber(info[6]) 
        local equipid = dms.string(dms["equipment_mould"],prop,equipment_mould.equipment_seat)    
              equipid = dms.string(dms["equipment_mould"],equipid,equipment_mould.skill_mould)    
        local procost = zstring.splits(dms.searchs(dms["equipment_star"],equipment_star.group_id,equipid,equipment_star.cost_items)[1][6],"|",",") 
        local cell = ResourcesIconCell:createCell()
              cell:init(cell.enum_type.PROP_INFORMATION,num,tonumber(procost[2][2]),nil,nil,true,true,1)
            return cell
    elseif tooltype == 5 then
        local prop = tonumber(info[5]) 
        local equipid = dms.string(dms["equipment_mould"],prop,equipment_mould.equipment_seat)    
              equipid = dms.string(dms["equipment_mould"],equipid,equipment_mould.skill_mould)    
        local procost = zstring.splits(dms.searchs(dms["equipment_star"],equipment_star.group_id,equipid,equipment_star.cost_items)[1][6],"|",",") 
        local cell = ResourcesIconCell:createCell()
              cell:init(cell.enum_type.PROP_INFORMATION,num,tonumber(procost[2][2]),nil,nil,true,true,1)
            return cell 
    elseif tooltype == 7 then
        local equip = tonumber(info[1]) 
        local equipid = dms.string(dms["equipment_mould"],equip,equipment_mould.equipment_seat)    
              equipid = dms.string(dms["equipment_mould"],equipid,equipment_mould.skill_mould)  
        local temp = dms.searchs(dms["equipment_star"],equipment_star.group_id,equipid,equipment_star.cost_items)
        local procost = dms.searchs(dms["equipment_star"],equipment_star.group_id,equipid,equipment_star.cost_items)[1][6]
              procost = zstring.splits(procost,"|",",") 
        if #procost == 1 then
           return false
        end
        local cell = ResourcesIconCell:createCell()
              cell:init(cell.enum_type.EQUIPMENT_INFORMATION,num,tonumber(procost[2][2]),nil,nil,true,true,1)
            return cell
    end
end


function MegaSmallTree:onUpdate(dt)
    
end

function MegaSmallTree:judgeIsSkill()
    for k,v in pairs(_ED.mega_info) do
        if v.shipId == self.ship.ship_id then
            heroinfo = v.info
        end
    end
    if type(heroinfo) == "string" then heroinfo = json.decode(heroinfo) end
    heroinfo = heroinfo or {}
    heroinfo.megaLevel = heroinfo.megaLevel or {}
    heroinfo.megaUse = heroinfo.megaUse or {}
    
    local Button_use = ccui.Helper:seekWidgetByName(self.roots[1], "Button_use")  
          Button_use:setVisible(true)
    local Button_cancel = ccui.Helper:seekWidgetByName(self.roots[1], "Button_cancel") 
          Button_cancel:setVisible(false)   
    for k,v in pairs(heroinfo.megaUse) do
       if tonumber(v) == self.page  then
         Button_use:setVisible(false)
         Button_cancel:setVisible(true) 
         break
       end
    end
end

function MegaSmallTree:onInit()
    if not _ED.mega_info or not self.ship  then
      return
    end
    
    local jsonFile = "images/ui/effice/spirte_dianliu/spirte_dianliu.json"        --电流动画
    local atlasFile = "images/ui/effice/spirte_dianliu/spirte_dianliu.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    local Panel_evolu_effect_dianliu = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_evolu_effect_dianliu") 
    Panel_evolu_effect_dianliu:removeAllChildren(true) 
    Panel_evolu_effect_dianliu:addChild(animation)
                   
    local jsonFile = "images/ui/effice/spirte_lianxianyjh/spirte_lianxianyjh.json"        --箭头动画
    local atlasFile = "images/ui/effice/spirte_lianxianyjh/spirte_lianxianyjh.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    for i = 1 ,9 do
        local Panel_evolut_effect_arrow = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_evolut_effect_arrow_%d",i))
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_evolut_effect_arrow:removeAllChildren(true) 
        Panel_evolut_effect_arrow:addChild(animation)
    end

    local jsonFile = "images/ui/effice/spirte_yijihuo/spirte_yijihuo.json"      --激活光效
    local atlasFile = "images/ui/effice/spirte_yijihuo/spirte_yijihuo.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    local Panel_evolu_effect_act = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_evolu_effect_act") 
    Panel_evolu_effect_act:removeAllChildren(true) 
    Panel_evolu_effect_act:addChild(animation)

    local Panel_consume = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_consume")   
          Panel_consume:setVisible(true)
    local Panel_light_ing = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_light_ing") 
    Panel_light_ing:setVisible(true)
    local Sprite_light_ing =  Panel_light_ing:getChildByName("Sprite_light_ing")
    Sprite_light_ing:setVisible(false)
    self.circleProgressBar = cc.ProgressTimer:create(Sprite_light_ing)
    --设置类型
    self.circleProgressBar:setType(cc.PROGRESS_TIMER_TYPE_RADIAL)
    self.circleProgressBar:setAnchorPoint(cc.p(0.5, 0.5))
    self.circleProgressBar:setPosition(50,50)
    Panel_light_ing:addChild(self.circleProgressBar)  
    local Panel_skill = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_skill")   --技能
    Panel_skill:setVisible(false)
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
       self.curidex = heroinfo.megaLevel[tostring(self.page)] 
    end  
    self:judgeIsSkill()
    if self.ship then
        local currShip = self.ship  
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            currShip = getShipByTalent(_ED.user_ship[self.ship.ship_id])
        end  
        
        for i =1, 10 do
            local Panel_light_ing = ccui.Helper:seekWidgetByName(self.roots[1], string.format("Panel_evolution_schedule_%d",i))
            Panel_light_ing:setVisible(true)
            local cell = MegaSmalltreeCell:createCell()
            table.insert(self.cells,cell)
            table.insert(self.panels,Panel_light_ing)
            cell:init(self.curidex,i)
            Panel_light_ing:addChild(cell)
            fwin:addTouchEventListener(Panel_light_ing, nil, 
            {
                terminal_name = "megasmalltree_updatebt", 
                terminal_state = 0, 
                isPressedActionEnabled = true,
                idex = i
            }, nil, 0)   
            -- if i ~= 1 then 
            --   Panel_light_ing:setTouchEnabled(false)
            -- end                 
        end
        self:switichIcon()
    end
end

function MegaSmallTree:switichIcon()
    if not self.cells then
        return
    end
    for k,v in pairs(self.cells) do
        v:onUpdateSwitch(self.curidex)
        v:onUpdateDraw(self.curidex)
    end
end

function MegaSmallTree:onEnterTransitionFinish()
    local csbNode = csb.createNode("packs/HeroStorage/sm_role_evolution_unlock_cell.csb")
    local root = csbNode:getChildByName("root")                         
    table.insert(self.roots, root)
    self:addChild(csbNode)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_activation"), nil, 
    {
        terminal_name = "megasmalltree_unlock", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        ship_id = self.ship.ship_id
    }, nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_37"), nil, 
    {
        terminal_name = "megasmalltree_changepage", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        isbig = true,
    }, nil, 0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use"), nil,  --使用技能
    {
        terminal_name = "megasmalltree_isuse_skill", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        isuse = 1,
    }, nil, 0)
      fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,      --取消使用技能
    {
        terminal_name = "megasmalltree_isuse_skill", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
        isuse = 2,
    }, nil, 0)

    self:onInit()
    self:updateDraw(false)   
end 

function MegaSmallTree:init(params)
    self.ship = params[1]
    self._rootWindows = params[2]
    self.page = params[3]
    return self
end

function MegaSmallTree:onExit()
    
end