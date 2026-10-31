--------------------------------------------------------------------------------------------------------------
--  说明：超进化激活小阶数界面  
--------------------------------------------------------------------------------------------------------------
MegaUnlockSuccess = class("MegaUnlockSuccessClass", Window)

local mega_unlock_success_open_terminal = {
    _name = "megaunlocksuccess_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaUnlockSuccessClass") == nil then           
            fwin:open(MegaUnlockSuccess:new():init(params), fwin._viewdialog)
        end
    end,
    _terminal = nil,
    _terminals = nil
}

local mega_unlock_success_close_terminal = {
    _name = "megaunlocksuccess_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("MegaUnlockSuccessClass") then
            fwin:close(fwin:find("MegaUnlockSuccessClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(mega_unlock_success_open_terminal)
state_machine.add(mega_unlock_success_close_terminal)
state_machine.init()

function MegaUnlockSuccess:ctor()
    self.super:ctor()
    self.roots = {} 
    self.actions = {}
    self.allInfo = {}
    app.load("client.formation.mega.MegaSmallTree")
end

function MegaUnlockSuccess:updateDraw()
    local Text_name_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_name_2")   --激活等级
    Text_name_2:setString(self.allInfo[1].."/10")

    local Text_fighting_n_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_fighting_n_1")   --攻击
    Text_fighting_n_1:setString(self.allInfo[3])
    local Text_speed_n_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_speed_n_1")   --增加后攻击
    Text_speed_n_1:setString(self.allInfo[2])

    local Text_fighting_n_3 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_fighting_n_3")   --生命
    Text_fighting_n_3:setString(self.allInfo[5])
    local Text_speed_n_3 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_speed_n_3")   --增加后的生命
    Text_speed_n_3:setString(self.allInfo[4])

    local Text_fighting_n_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_fighting_n_2")   --防御
    Text_fighting_n_2:setString(self.allInfo[7])
    local Text_speed_n_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_speed_n_2")   --增加后的防御
    Text_speed_n_2:setString(self.allInfo[6])

    local Panel_attribute = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_attribute")   --特殊屬性 
    local Panel_quality = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_quality")   --8门特效

    local Panel_jnjs = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_jnjs")   --技能
    local ability = dms.int(dms["ship_mould"], _ED.user_ship[self.allInfo[9].ship_id].ship_template_id,ship_mould.ability) 
    if self.allInfo[1] == 10 then
        if self.allInfo[8] == 1  or self.allInfo[8]  == 3 or  self.allInfo[8]  == 5 or self.allInfo[8] == 7  then 
            local talent_id =  dms.searchs(dms["mega_property"],2,ability,3,self.allInfo[8])[1][15]
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
                Panel_jnjs:setVisible(false)
                Panel_quality:setVisible(false)
        elseif self.allInfo[8] == 8 then
            Panel_attribute:setVisible(false)
            Panel_jnjs:setVisible(false)
            Panel_quality:setVisible(true)

            local ability = dms.int(dms["ship_mould"],_ED.user_ship[self.allInfo[9].ship_id].ship_template_id,ship_mould.ability)
            local Text_before = ccui.Helper:seekWidgetByName(self.roots[1], "Text_before")
            Text_before:setString(ability)

            local num = GetMegeDataByShipID(_ED.user_ship[self.allInfo[9].ship_id].ship_template_id, false)
            num = tonumber(num[1][8])
            local Text_after = ccui.Helper:seekWidgetByName(self.roots[1], "Text_after")
            Text_after:setString(num)
        else
            Panel_attribute:setVisible(false)
            Panel_jnjs:setVisible(true)
            Panel_quality:setVisible(false)
                    
              local skillinfo = GetMegeDataByShipID(_ED.user_ship[self.allInfo[9].ship_id].ship_template_id, false)
              local skill_evo_mould_id = 0
              local skill_mould_id = 0
              local currShip = getShipByTalent(_ED.user_ship[self.allInfo[9].ship_id])

                if self.allInfo[8] == 2 then
                    skillinfo = skillinfo[1][3]
                    skillinfo =  zstring.splits(skillinfo,"|",",")
                  
                elseif self.allInfo[8] == 4 then
                    skillinfo = skillinfo[1][4]
                    skillinfo =  zstring.splits(skillinfo,"|",",")
                 elseif self.allInfo[8] == 6 then
                    skillinfo = skillinfo[1][5]
                    skillinfo =  zstring.splits(skillinfo,"|",",")
                end
            
                local ship = fundShipWidthId(self.allInfo[9].ship_id)
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
                local Panel_jn_icon_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_skill_icon_1")  --技能1
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

                local Panel_jn_icon_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_skill_icon_2")  --技能2
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
    end
end


function MegaUnlockSuccess:onUpdate(dt)
    
end

function MegaUnlockSuccess:onEnterTransitionFinish()
    local csbNode = csb.createNode("packs/HeroStorage/sm_role_evolution_success_window.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)
    local action = csb.createTimeline("packs/HeroStorage/sm_role_evolution_success_window.csb")
    table.insert(self.actions, action)
    csbNode:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("zhankai", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_bg"), nil, 
    {
        terminal_name = "megaunlocksuccess_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true,
    }, nil, 0)

  
    self:updateDraw()
end


function MegaUnlockSuccess:init(params)
    self.allInfo = params
    return self
end

function MegaUnlockSuccess:onExit()
    
end