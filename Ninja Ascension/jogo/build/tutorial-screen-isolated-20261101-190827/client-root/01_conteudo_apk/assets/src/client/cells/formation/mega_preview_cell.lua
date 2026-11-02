--------------------------------------------------------------------------------------------------------------
--  说明：超进化预览cell
--------------------------------------------------------------------------------------------------------------
MagePreviewCell = class("MagePreviewCellClass", Window)
MagePreviewCell.__size = nil

--创建cell
local magepreviewcell_terminal = {
    _name = "magepreviewcell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = MagePreviewCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(magepreviewcell_terminal)
state_machine.init()

function MagePreviewCell:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.packs.hero.SmRoleStrengthenTabSkillDescription")
    local function init_magepreviewcell_terminal()
        --技能描述
        local init_magepreviewcell_skill_terminal = {
            _name = "magepreviewcell_skill",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
           
            local shipInfo = _ED.user_ship[""..instance.allinfo[5].ship_id]
            state_machine.excute("sm_role_strengthen_tab_skill_description_open",0,{shipInfo,params._datas.talentMouldid,params._datas.idex,true})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
         
        state_machine.add(init_magepreviewcell_skill_terminal)
        state_machine.init()
    end

    init_magepreviewcell_terminal()

end

function MagePreviewCell:updateDrawInfo()
    local root = self.roots[1]
    local Text_jn_name = ccui.Helper:seekWidgetByName(root, "Text_jn_name")  --阶段
    Text_jn_name:setString(string.format(tipStringInfo_maga_unlock[11],self.allinfo[1]))    

    local Text_gj_z_1 = ccui.Helper:seekWidgetByName(root, "Text_gj_z_1")  --攻击
    Text_gj_z_1:setString(self.allinfo[2])     
    local Text_sm_z_3 = ccui.Helper:seekWidgetByName(root, "Text_sm_z_3")  --生命
    Text_sm_z_3:setString(self.allinfo[4])   
    local Text_fy_z_2 = ccui.Helper:seekWidgetByName(root, "Text_fy_z_2")  --防御
    Text_fy_z_2:setString(self.allinfo[3])   

    
    local Panel_effect_t = ccui.Helper:seekWidgetByName(root, "Panel_effect_t")  
    local Panel_attribute = ccui.Helper:seekWidgetByName(root, "Panel_attribute")  --特殊属性
    local Panel_effect_8 = ccui.Helper:seekWidgetByName(root, "Panel_effect_8")  --特殊属性
    
  
    if self.allinfo[1] == 2 or  self.allinfo[1] == 4 or self.allinfo[1] == 6 then
      Panel_effect_t:setVisible(true)
      Panel_attribute:setVisible(false)
      Panel_effect_8:setVisible(false)
      local currShip = self.allinfo[5]  
      if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        currShip = getShipByTalent(_ED.user_ship[self.allinfo[5].ship_id])
      end 
      local skillinfo = {}
      local skill_evo_mould_id = 0
      local skill_mould_id = 0
      skillinfo = GetMegeDataByShipID(_ED.user_ship[self.allinfo[5].ship_id].ship_template_id, false)
      
        if self.allinfo[1] == 2 then
            skillinfo = skillinfo[1][3]
            skillinfo =  zstring.splits(skillinfo,"|",",")
          
        elseif self.allinfo[1] == 4 then
            skillinfo = skillinfo[1][4]
            skillinfo =  zstring.splits(skillinfo,"|",",")
        
         elseif self.allinfo[1] == 6 then
            skillinfo = skillinfo[1][5]
            skillinfo =  zstring.splits(skillinfo,"|",",")
        end
    
        local ship = fundShipWidthId(self.allinfo[5].ship_id)
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

        local Panel_jn_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_jn_icon_1")  --技能1
        Panel_jn_icon_1:removeBackGroundImage()
        local pic_index = dms.int(dms["talent_mould"], skill_mould_id, talent_mould.new_skill_pic)
        Panel_jn_icon_1:setBackGroundImage(string.format("images/ui/skills/skills_%d.png", pic_index))
         fwin:addTouchEventListener(Panel_jn_icon_1, nil, 
        {
            terminal_name = "magepreviewcell_skill", 
            terminal_state = 0, 
            isPressedActionEnabled = true,
            talentMouldid = skill_mould_id,
            idex = newidex
        }, nil, 0)   

        local Panel_jn_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_jn_icon_2")  --技能2
        Panel_jn_icon_2:removeBackGroundImage()
        local pic_index = dms.int(dms["talent_mould"], skill_evo_mould_id, talent_mould.new_skill_pic)
        Panel_jn_icon_2:setBackGroundImage(string.format("images/ui/skills/skills_%d.png", pic_index))
         fwin:addTouchEventListener(Panel_jn_icon_2, nil, 
        {
            terminal_name = "magepreviewcell_skill", 
            terminal_state = 0, 
            isPressedActionEnabled = true,
            talentMouldid = skill_evo_mould_id,
            idex = newidex
        }, nil, 0)   
    elseif self.allinfo[1] == 8 then
        Panel_effect_t:setVisible(false)
        Panel_attribute:setVisible(false)
        Panel_effect_8:setVisible(true)

        local ability = dms.int(dms["ship_mould"], _ED.user_ship[self.allinfo[5].ship_id].ship_template_id,ship_mould.ability)
        local Text_zz_n1 = ccui.Helper:seekWidgetByName(root, "Text_zz_n1")
        Text_zz_n1:setString(ability)

        local num = GetMegeDataByShipID(_ED.user_ship[self.allinfo[5].ship_id].ship_template_id, false)

        num = tonumber(num[1][8])
        local Text_zz_n2 = ccui.Helper:seekWidgetByName(root, "Text_zz_n2")
        Text_zz_n2:setString(num)

    else
        Panel_effect_t:setVisible(false)
        Panel_attribute:setVisible(true)
        Panel_effect_8:setVisible(false)

       

        local talent_id =  dms.searchs(dms["mega_property"],2,self.allinfo[6],3,self.allinfo[1])[1][15]
        local talen_info = zstring.split(dms.string(dms["talent_mould"], talent_id, talent_mould.base_additional),",") 
       
        local Text_1 = ccui.Helper:seekWidgetByName(self.roots[1], "Text_1")  
        local Text_crit = ccui.Helper:seekWidgetByName(self.roots[1], "Text_crit") 
        local txt_1 = tonumber(talen_info[1])
        local txt_2 = tonumber(talen_info[2]) 
       
        local temp1 = tipStringInfo_trialTower_attribute_info[txt_1+1][1]
        local temp2 = tipStringInfo_trialTower_attribute_info[txt_1+1][2]
        local temp3  = string.format(temp2,txt_2)
        Text_1:setString(tipStringInfo_maga_unlock[13].."  "..temp1)
        Text_crit:setString(temp3.."%")

    end

end

function MagePreviewCell:onUpdate(dt)
    
end

function MagePreviewCell:onInit()
    local root = cacher.createUIRef("packs/HeroStorage/sm_role_evolution_preview_window_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if MagePreviewCell.__size == nil then
        MagePreviewCell.__size = ccui.Helper:seekWidgetByName(root, "root"):getContentSize()
    end
  
    self:clearUIInfo()
	self:updateDrawInfo()
end

function MagePreviewCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function MagePreviewCell:clearUIInfo( ... )

end


function MagePreviewCell:init(params)
    self.allinfo = params 
	self:onInit()
    self:setContentSize(MagePreviewCell.__size)
    return self
end

function MagePreviewCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("packs/HeroStorage/sm_role_evolution_preview_window_list.csb", self.roots[1])
end