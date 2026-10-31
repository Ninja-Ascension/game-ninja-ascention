-- ----------------------------------------------------------------------------------------------------
-- 说明：灵魂守卫界面
-------------------------------------------------------------------------------------------------------
SoulWardingWindow = class("SoulWardingWindowClass", Window)

local soul_warding_window_open_terminal = {
    _name = "soul_warding_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SoulWardingWindowClass") == nil then           
            fwin:open(SoulWardingWindow:new():init(params),fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local soul_warding_window_close_terminal = {
    _name = "soul_warding_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SoulWardingWindowClass") then
            fwin:close(fwin:find("SoulWardingWindowClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(soul_warding_window_open_terminal)
state_machine.add(soul_warding_window_close_terminal)
state_machine.init()

function SoulWardingWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.idex = 1    --库组
    self.iscanunlock = false --是否可以解锁
    self.isunlock = false  -- 是否已经解锁

    self.islv = false --是否升级
    app.load("client.l_digital.cultivate.soulward.SoulWardingRule")
    app.load("client.l_digital.cultivate.soulward.SoulWardingUpLv")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.packs.hero.HeroFormationChoiceWear")
    app.load("client.cells.ship.hero_icon_list_cell")
    local function init_SoulWardingWindow_terminal()
        --解锁
        local init_soul_warding_window_unlock_terminal = {
            _name = "soul_warding_window_unlock",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if not  instance.iscanunlock then
                    TipDlg.drawTextDailog(tipStringInfo_soul_warding[7])
                else 
                    local function callBack( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            instance:onUpdateDrawinfo()
                        end
                    end
                    protocol_command.soul_gruad_un_lock.param_list = instance.idex
                    NetworkManager:register(protocol_command.soul_gruad_un_lock.code, nil, nil, nil, instance, callBack, false, nil)
                end
                
                
                    return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --升级
        local init_soul_warding_window_uplv_terminal = {
            _name = "soul_warding_window_uplv",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            local function callBack( response )
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    instance.islv = true
                    instance:onUpdateDrawinfo()
                end
            end
            protocol_command.soul_gruad_level_up.param_list = instance.idex
            NetworkManager:register(protocol_command.soul_gruad_level_up.code, nil, nil, nil, instance, callBack, false, nil)
                    return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         
        --上阵按钮
        local init_soul_warding_window_goto_terminal = {
            _name = "soul_warding_window_goto",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.isunlock then
                    state_machine.excute("hero_formation_choice_wear_window_open", 0, {1, 6, -1, nil, nil,1,nil,1})
                else
                    TipDlg.drawTextDailog(tipStringInfo_soul_warding[8])
                end
                    return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --上阵界面内
        local init_soul_warding_window_change_terminal = {
            _name = "soul_warding_window_change",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function callBack( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("choice_hero_the_soul_ward", 0, nil)
                        if fwin:find("HeroFormationChoiceWearClass") ~= nil then
                             fwin:close(fwin:find("HeroFormationChoiceWearClass"))
                        end
                       instance:onUpdateDrawinfo()
                       instance:drawFormation(params._datas._ship)
                    end
                end
                protocol_command.soul_gruad_use_ship_mould.param_list = instance.idex.."\r\n"..params._datas._ship.ship_template_id
                NetworkManager:register(protocol_command.soul_gruad_use_ship_mould.code, nil, nil, nil, instance, callBack, false, nil)
                    return true
            end,
            _terminal = nil,
            _terminals = nil
        }

          --左右查看
        local init_soul_warding_window_look_terminal = {
            _name = "soul_warding_window_look",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local num = dms.count(dms["soul_guard_group_mould"])
                if params._datas.dir == 1 and (instance.idex - 1 >= 1 ) then
                    instance.idex =  instance.idex - 1
                elseif params._datas.dir == 2 and (instance.idex + 1 <= num) then
                    instance.idex =  instance.idex + 1
                else
                    return
                end
                instance:onUpdateDraw()
                instance:onUpdateDrawinfo()
                if _ED.soul_warding_formation_hero  then
                    if _ED.soul_warding_formation_hero[instance.idex..""]  then
                        instance:drawFormation(getShipByTemplateId(_ED.soul_warding_formation_hero[instance.idex..""].onUseShipMouldId))
                    else
                        instance:drawFormation()
                    end
                else
                    instance:drawFormation()
                end
                    return true
            end,
            _terminal = nil,
            _terminals = nil
        }

     

        state_machine.add(init_soul_warding_window_unlock_terminal)
        state_machine.add(init_soul_warding_window_uplv_terminal)
        state_machine.add(init_soul_warding_window_goto_terminal)
        state_machine.add(init_soul_warding_window_change_terminal)
        state_machine.add(init_soul_warding_window_look_terminal)
        state_machine.init()
    end

     init_SoulWardingWindow_terminal()
end

function SoulWardingWindow:init(params)
    return self
end


function SoulWardingWindow:onUpdate(dt)
end

function SoulWardingWindow:judgeIsLock(infos,txt)
    if not _ED.mega_info then
        return false
    end

    local tpyed = tonumber(infos[2])
    local herosid = {}   --拥有的所有宝可梦的实例id
    for k,v in pairs(_ED.mega_info) do
        table.insert(herosid, tonumber(v.shipId))    
    end

    if tpyed == 1 then  --八门等级
        local count = 0
        for k,v in pairs(_ED.mega_info) do
            local heroinfo = {}
            heroinfo = v.info
            heroinfo = json.decode(heroinfo)
            
            local temp = 0
            for k,v in pairs(heroinfo.megaLevel) do
                temp = temp +1
            end
            if temp >= tonumber(infos[4]) then
                count = count + 1
            end
        end
        txt:setString(string.format(tipStringInfo_soul_warding[1], infos[3], infos[4]))
        if count >= tonumber(infos[3]) then
            return true
        end
    elseif tpyed == 2 then  --上级祝福等级
        txt:setString(string.format(tipStringInfo_soul_warding[2],infos[3]))
        if  not _ED.soul_warding_formation_hero or not _ED.soul_warding_formation_hero[(self.idex-1)..""] then
        else
            if _ED.soul_warding_formation_hero and tonumber(_ED.soul_warding_formation_hero[(self.idex-1)..""].level) >= tonumber(infos[3]) then
               return true
            end
        end
    elseif  tpyed == 3 then  --精灵阶级
        local count = 0
        for k,v in pairs(herosid) do
            if tonumber(_ED.user_ship[""..v].Order) >= tonumber(infos[4]) then
               count = count + 1
            end
        end
        txt:setString(string.format(tipStringInfo_soul_warding[3],infos[3], tipStringInfo_maga_uplv[tonumber(infos[4])]))
        if count >=  tonumber(infos[3]) then
            return true
        end
    elseif  tpyed == 4 then  --图鉴等级
       
    elseif  tpyed == 5 then  --战队等级
        txt:setString(string.format(tipStringInfo_soul_warding[5],infos[3]))
        if tonumber(_ED.user_info.user_grade) >= tonumber(infos[3]) then
            return true
        end
    elseif  tpyed == 6 then  --精灵等级
        local count = 0
        for k,v in pairs(herosid) do
            if tonumber(_ED.user_ship[v].ship_grade) >= tonumber(infos[4]) then
               count = count + 1
            end
        end
        txt:setString(string.format(tipStringInfo_soul_warding[6],infos[3],infos[4]))
        if count >=  tonumber(infos[3]) then
            return true
        end
    end
    return false
end

function SoulWardingWindow:onUpdateDraw()  
    local lockinfo =  dms.string(dms["soul_guard_group_mould"], self.idex, 3)
    lockinfo = zstring.split(lockinfo,",")
   
    local Button_unlock = ccui.Helper:seekWidgetByName(self.roots[1],"Button_unlock")
    Button_unlock:setHighlighted(false)

    local Text_warding_all_atk_n = ccui.Helper:seekWidgetByName(self.roots[1],"Text_warding_all_atk_n")  
    Text_warding_all_atk_n:setString(0)

    local Text_warding_all_def = ccui.Helper:seekWidgetByName(self.roots[1],"Text_warding_all_def_n")
    Text_warding_all_def:setString(0)

    local Text_warding_all_hp_n = ccui.Helper:seekWidgetByName(self.roots[1],"Text_warding_all_hp_n")
    Text_warding_all_hp_n:setString(0)

    local Button_arrt_infor =  ccui.Helper:seekWidgetByName(self.roots[1], "Button_arrt_infor")
    Button_arrt_infor:setVisible(false)

    local Button_additional_infor =  ccui.Helper:seekWidgetByName(self.roots[1], "Button_additional_infor")
    Button_additional_infor:setVisible(false)

    local jsonFile = "images/ui/effice/effect_lihunshouhu/effect_lihunshouhu.json"      --背景
    local atlasFile = "images/ui/effice/effect_lihunshouhu/effect_lihunshouhu.atlas"
    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation1", true, nil)
    local Panel_aoul_effect = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_aoul_effect")
    
    Panel_aoul_effect:removeAllChildren(true) 
    Panel_aoul_effect:addChild(animation)

    for i =1, 4 do
        local Text_unlock = ccui.Helper:seekWidgetByName(self.roots[1],"Text_unlock_"..i)
        Text_unlock:setVisible(false)
    end
    self.iscanunlock = false
    local locktexts = {}
    if #lockinfo >0 then
        local count = 0  --记录解锁的条件
        for i = 1 , #lockinfo  do
            local Text_unlock = ccui.Helper:seekWidgetByName(self.roots[1],"Text_unlock_"..i)
            Text_unlock:setVisible(true)
            Text_unlock:setColor(cc.c3b(255, 0, 0))
            local alllockinfo  = dms.searchs(dms["soul_guard_unlock_mould"],1,lockinfo[i])
            local isunlock = self:judgeIsLock(alllockinfo[1],Text_unlock)   --是否满足条件解锁
            if isunlock then
              count = count + 1
              Text_unlock:setColor(cc.c3b(0, 255, 0))
            end
        end
        if count == #lockinfo then
            self.iscanunlock = true
        end
    end

    if self.iscanunlock then
        Button_unlock:setHighlighted(true)
    end
   
    local Text_17 = ccui.Helper:seekWidgetByName(self.roots[1],"Text_17")  
    Text_17:setString(tipStringInfo_soul_warding_name[self.idex])
end

--布阵
function SoulWardingWindow:drawFormation(ship)
    local Image_34 = ccui.Helper:seekWidgetByName(self.roots[1],"Image_34")
    Image_34:removeAllChildren(true)

    -- DSC重塑
    local Panel_soul_head = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_soul_head")
    if __lua_project_id == __lua_project_l_digital and Panel_soul_head then
        Panel_soul_head:removeAllChildren(true)
    end
    
    if not ship then
        return
    end
    local cell = HeroIconListCell:createCell()
    if nil ~= ship then
        cell:init(ship, 1, true,nil,nil,nil,1)   
    else
        cell:init(nil,1, true, nil,nil,true)
    end
    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital and Panel_soul_head then
        Panel_soul_head:addChild(cell)
    else
        cell:setPosition(26,25)
        Image_34:addChild(cell)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"), nil, 
        {
            terminal_name = "soul_warding_window_goto",
            cell_index = 1,
            isPressedActionEnabled = true
        },
        nil,0)
  
end

function SoulWardingWindow:onUpdateDrawinfo()
    local Text_17_0 = ccui.Helper:seekWidgetByName(self.roots[1],"Text_17_0")  
    Text_17_0:setString(_new_interface_text[30].."."..0)
    if not _ED.soul_warding_formation_hero then
        return
    end
    self.isunlock = false
    local info = {}

    local bestLvs = dms.searchs(dms["soul_guard_level_mould"], 5, self.idex)    --最高等级
    local bestLv = table.nums(bestLvs)

    local Panel_soul_up_infor = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_soul_up_infor") 
    Panel_soul_up_infor:setVisible(true)

    local Image_soul_up_top = ccui.Helper:seekWidgetByName(self.roots[1],"Image_soul_up_top") 
    Image_soul_up_top:setVisible(false)

    local Panel_warding_unlock = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_warding_unlock") 
    local Panel_warding = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_warding")
    Panel_warding_unlock:setVisible(true)
    Panel_warding:setVisible(false)
    
    local Panel_aoul_effect = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_aoul_effect")

    local jsonFile = "images/ui/effice/effect_lihunshouhu/effect_lihunshouhu.json"      --背景
    local atlasFile = "images/ui/effice/effect_lihunshouhu/effect_lihunshouhu.atlas"
    local animation  = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
    for k,v in pairs(_ED.soul_warding_formation_hero) do
        if _ED.soul_warding_formation_hero[self.idex..""] then
            info = _ED.soul_warding_formation_hero[self.idex..""]
            self.isunlock = true
            animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation"..(self.idex+1), true, nil)
            Panel_aoul_effect:removeAllChildren(true) 
            Panel_aoul_effect:addChild(animation)
        end
    end
    
    if next(info) == nil then   
        Text_17_0:setString(_new_interface_text[30].."."..0)
        return
    end
   
    if tonumber(info.level) >= tonumber(bestLv) then
        Panel_soul_up_infor:setVisible(false)
        Image_soul_up_top:setVisible(true)
    end

    Panel_warding_unlock:setVisible(false)
    Panel_warding:setVisible(true)

    Text_17_0:setString(_new_interface_text[30].."."..info.level)

    for i=1,3 do
        local Text_soul_add = ccui.Helper:seekWidgetByName(self.roots[1],"Text_soul_add_"..i)
        Text_soul_add:setString(info.addFinalProperty[i][2])
        
        local Text_soul_attr = ccui.Helper:seekWidgetByName(self.roots[1],"Text_soul_attr_"..i)
        Text_soul_attr:setString(info.addBaseProperty[i][2])

        local Text_soul_additional = ccui.Helper:seekWidgetByName(self.roots[1],"Text_soul_additional_"..i)
        Text_soul_additional:setString(((info.addExtraPropertyPercent[1]+info.addExtraPropertyPercent[2]+info.addExtraPropertyPercent[3])*100).."%")
    end

    local Text_warding_all_atk_n = ccui.Helper:seekWidgetByName(self.roots[1],"Text_warding_all_atk_n")  
    Text_warding_all_atk_n:setString(info.addFinalProperty[1][2])

    local Text_warding_all_def = ccui.Helper:seekWidgetByName(self.roots[1],"Text_warding_all_def_n")
    Text_warding_all_def:setString(info.addFinalProperty[2][2])

    local Text_warding_all_hp_n = ccui.Helper:seekWidgetByName(self.roots[1],"Text_warding_all_hp_n")
    Text_warding_all_hp_n:setString(info.addFinalProperty[3][2])
    
    local Text_soul_attr_0_1 = ccui.Helper:seekWidgetByName(self.roots[1],"Text_soul_attr_0_1")
    local Text_soul_attr_0_2 = ccui.Helper:seekWidgetByName(self.roots[1],"Text_soul_attr_0_2")
    local Text_soul_attr_0_3 = ccui.Helper:seekWidgetByName(self.roots[1],"Text_soul_attr_0_3")
   
    local limit = nil
    if tonumber(info.level) == 0 then
        Text_soul_attr_0_1:setString("(".."0"..")")
        Text_soul_attr_0_2:setString("(".."0"..")")
        Text_soul_attr_0_3:setString("(".."0"..")")
    else
        limit = zstring.splits(dms.string(dms["soul_guard_level_mould"], info.level, 4),"|",",")     --上限
        for k,v in pairs(limit) do
            if tonumber(v[1]) == 0 then
                Text_soul_attr_0_1:setString("("..limit[1][2]..")")
            elseif tonumber(v[1]) == 1 then
                Text_soul_attr_0_2:setString("("..limit[2][2]..")")
            elseif tonumber(v[1]) == 2 then
                Text_soul_attr_0_3:setString("("..limit[3][2]..")")
            end
        end
    end

   local function onOpenTouchEvent(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_arrt_infor"):setVisible(true)
        elseif evenType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_arrt_infor"):setVisible(false)
        end
    end

    local function onOpenTouchEventtwo(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_additional_infor"):setVisible(true)
        elseif evenType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
            ccui.Helper:seekWidgetByName(self.roots[1], "Panel_additional_infor"):setVisible(false)
        end
    end

    local Button_arrt_infor =  ccui.Helper:seekWidgetByName(self.roots[1], "Button_arrt_infor")
    Button_arrt_infor:addTouchEventListener(onOpenTouchEvent)
    
    local Button_additional_infor =  ccui.Helper:seekWidgetByName(self.roots[1], "Button_additional_infor")
    Button_additional_infor:addTouchEventListener(onOpenTouchEventtwo)

    if self.islv then
        state_machine.excute("soul_warding_up_lv_open", 0, {info.level,limit})
    end
    
    local megalv = 0
    local heroinfo = {}
    for k,v in pairs(_ED.mega_info) do
       
        if tonumber(info.onUseShipMouldId) ~= -1  then
            if tonumber(v.shipId) == tonumber((getShipByTemplateId(info.onUseShipMouldId).ship_id)) then
                megalv = 0
                heroinfo = v.info
                heroinfo = json.decode(heroinfo)
                if heroinfo.megaLevel then
                   for k,v in pairs(heroinfo.megaLevel) do
                     megalv = megalv + 1
                   end
                end
            end
        end
    end
    local Text_dev_ing_n = ccui.Helper:seekWidgetByName(self.roots[1],"Text_dev_ing_n")
    Text_dev_ing_n:setString(megalv)
    
    if tonumber(info.onUseShipMouldId) ~= -1 then
        local shipData = getShipByTemplateId(info.onUseShipMouldId)
        local ability = dms.int(dms["ship_mould"], tonumber(info.onUseShipMouldId), ship_mould.ability)
        local m_Order = 0
        
        if shipData ~= nil then
            ability = getAbilityFromBaMen(shipData, ability)
            m_Order = tonumber(shipData.Order)
        end

        local Text_other_n = ccui.Helper:seekWidgetByName(self.roots[1],"Text_other_n")
        if m_Order == 0 then
            Text_other_n:setString(0)
        else
            Text_other_n:setString(tipStringInfo_maga_uplv[m_Order])
        end
        
        local Text_qut_n = ccui.Helper:seekWidgetByName(self.roots[1],"Text_qut_n")
        Text_qut_n:setString(ability)

        Button_arrt_infor:setVisible(true)
        Button_additional_infor:setVisible(true)
    end

    local Text_additional_evolution = ccui.Helper:seekWidgetByName(self.roots[1],"Text_additional_evolution")
    Text_additional_evolution:setString((info.addExtraPropertyPercent[1]*100).."%")

    local Text_additional_qua = ccui.Helper:seekWidgetByName(self.roots[1],"Text_additional_qua")
    Text_additional_qua:setString((info.addExtraPropertyPercent[2]*100).."%")

    local Text_additional_other = ccui.Helper:seekWidgetByName(self.roots[1],"Text_additional_other")
    Text_additional_other:setString((info.addExtraPropertyPercent[3]*100).."%")

    local Text_zuanshi_n = ccui.Helper:seekWidgetByName(self.roots[1],"Text_zuanshi_n")
    
    for i=1,3 do
        local Panel_soul_props = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_soul_props_"..i)
        Panel_soul_props:removeAllChildren(true)
    end

    local upuses = zstring.splits(dms.string(dms["soul_guard_level_mould"], info.level+1, 3),"|",",")     --升级消耗
    local temp = 0
    for k,v in pairs(upuses) do
        if tonumber(v[1]) == 1 then  --金币
          Text_zuanshi_n:setString(v[3])
        elseif tonumber(v[1]) == 6 then  --道具
          temp = temp + 1
        end
    end

    if temp ~= 0 then
        for i=1,temp do
            local cell = ResourcesIconCell:createCell()
            cell:init(cell.enum_type.PROP_INFORMATION,tonumber(upuses[1+i][3]),tonumber(upuses[1+i][2]),nil,nil,true,true,1)
            local Panel_soul_props = ccui.Helper:seekWidgetByName(self.roots[1],"Panel_soul_props_"..i)
            Panel_soul_props:addChild(cell)
        end
    end
    self.islv = false --是否升级
end


function SoulWardingWindow:onEnterTransitionFinish()
    local csbNode = csb.createNode("cultivate/soul_warding.csb")
    local root = csbNode:getChildByName("root")                         
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 解锁
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_unlock"), nil, 
    {
        terminal_name = "soul_warding_window_unlock", 
        isPressedActionEnabled = true, 
    },
    nil, 0)
    --   -- 规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_soul_help"), nil, 
    {
        terminal_name = "soul_warding_rule_open", 
        isPressedActionEnabled = true,
    },
    nil, 0)
     
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "soul_warding_window_close", 
        isPressedActionEnabled = true,
    },
    nil, 0)
    --升级
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_soul_up"), nil, 
    {
        terminal_name = "soul_warding_window_uplv", 
        isPressedActionEnabled = true,
    },
    nil, 0)
    
    --上阵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_34"), nil, 
    {
        terminal_name = "soul_warding_window_goto", 
        isPressedActionEnabled = true,
    },
    nil, 0)

     --向左查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_soul_left"), nil, 
    {
        terminal_name = "soul_warding_window_look", 
        isPressedActionEnabled = true,
        dir = 1,
    },
    nil, 0)

     --向右查看
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_soul_right"), nil, 
    {
        terminal_name = "soul_warding_window_look", 
        isPressedActionEnabled = true,
        dir = 2
    },
    nil, 0)

    local userinfo = UserTopInfoA:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

    if _ED.soul_warding_formation_hero and _ED.soul_warding_formation_hero[self.idex..""] then
        self:drawFormation(getShipByTemplateId(_ED.soul_warding_formation_hero[self.idex..""].onUseShipMouldId))
    else
        self:drawFormation()
    end
    self:onUpdateDraw()
    self:onUpdateDrawinfo()
    self:registerOnNoteUpdate(self, 1)
end

function SoulWardingWindow:onExit()
  
end 
