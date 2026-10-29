-- ----------------------------------------------------------------------------------------------------
-- 说明：偷师学艺
-- 创建时间 2015-11-25
-- 作者：yanghan
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

LearingListviewEquipDemons = class("LearingListviewEquipDemonsClass", Window)

function LearingListviewEquipDemons:ctor()
    self.super:ctor()
    self.roots = {}
    self.list_view = nil
    self.list_view_posY = nil

    self.sort_datas = {} --排序后的数据

    -- Initialize EmailManager page state machine.
    local function init_learing_skills_list_equip_demons_terminal()
        local learing_skills_list_equip_demons_shot_terminal = {
            _name = "learing_skills_list_equip_demons_shot",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:getSort()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local learing_skills_list_equip_demons_update_terminal = {
            _name = "learing_skills_list_equip_demons_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("learing_skills_list_equip_demons_shot",0,"")
                instance:onUpdateDraw()
                self.list_view_posY = -1
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(learing_skills_list_equip_demons_shot_terminal)
        state_machine.add(learing_skills_list_equip_demons_update_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_learing_skills_list_equip_demons_terminal()
end

function LearingListviewEquipDemons:getSort()
    local result = {}
    local hero_main = {}
    local hero_other = {}
    local hero_skill_date = {}
    local favor_top = dms.int(dms["teacher_pupil_link_parm"],1,teacher_pupil_link_parm.total_experience)
    for i=1,#dms["skill_equipment_mould"] do
        local ship_id = tonumber(dms.int(dms["skill_equipment_mould"],i,skill_equipment_mould.ship_mould))
        local camp_preference = dms.int(dms["ship_mould"],ship_id,ship_mould.camp_preference)
        local skill_type = tonumber(dms.int(dms["skill_equipment_mould"],i,skill_equipment_mould.skill_type))
        local _ship_type = dms.int(dms["ship_mould"],ship_id,ship_mould.ship_type)
        local skill_id = i
        if camp_preference == 0 then
            local data = {
                ship_data = {},
                skill_data = {},
                ship_type = _ship_type,
                state = 0, --  0未装备 1 已装备
                skill_type = 0
            }
            data.ship_data = dms.element(dms["ship_mould"], ship_id)
            data.skill_data = dms.element(dms["skill_equipment_mould"],i) 
            data.skill_type = skill_type
            if tonumber(_ED.user_info.user_gender) == 1 and skill_type == 1 then --男默认技能
                for i , v in pairs(_ED.user_skill_equipment) do
                    if skill_id == tonumber(v.skill_equipment_base_mould) then   
                        data.state = v.equip_state
                        if tonumber(data.state) == 1 then
                            table.insert(hero_skill_date,data)
                        else
                            table.insert(hero_main,data)
                        end
                        break
                    end
                end  
            end
            if tonumber(_ED.user_info.user_gender) == 2 and skill_type == 2 then --nv默认技能
                for i , v in pairs(_ED.user_skill_equipment) do
                    if skill_id == tonumber(v.skill_equipment_base_mould) then    
                        data.state = v.equip_state
                        if tonumber(data.state) == 1 then
                            table.insert(hero_skill_date,data)
                        else
                            table.insert(hero_main,data)
                        end
                        break
                    end
                end  
            end
        end

        if camp_preference == 2 then
            local data = {
                ship_data = {},
                skill_data = {},
                ship_type = _ship_type,
                state = 0,--  0未装备 1 
                skill_type = 0
            }
            data.ship_data = dms.element(dms["ship_mould"], ship_id)
            data.skill_data = dms.element(dms["skill_equipment_mould"],i)
            data.skill_type = skill_type
            for i , v in pairs(_ED.user_skill_equipment) do
                if skill_id == tonumber(v.skill_equipment_base_mould) then
                    if tonumber(v.favor_level) == 1 or tonumber(v.favor) >= favor_top then     
                        data.state = v.equip_state
                        if tonumber(data.state) == 1 then
                            table.insert(hero_skill_date,data)
                        else
                            table.insert(hero_other,data)
                        end
                        break
                    end
                end
            end
        end
    end

    local function sortShipType( a, b )
        return tonumber(a.state) > tonumber(b.state)
            or tonumber(a.state) == tonumber(b.state) and tonumber(a.ship_type) > tonumber(b.ship_type)
    end
    table.sort(hero_main, sortShipType)
    table.sort(hero_other, sortShipType)
    for i=1, #hero_skill_date do
        table.insert(result, hero_skill_date[i])
    end
    for i=1, #hero_main do
        table.insert(result, hero_main[i])
    end
    for i=1, #hero_other do
        table.insert(result, hero_other[i])
    end    
    self.sort_datas = result
end
function LearingListviewEquipDemons:onInit()
    local csbItem = csb.createNode("skills/skills_listview_1.csb")
    local root = csbItem:getChildByName("root")
    table.insert(self.roots,root)
    self:addChild(csbItem)
    state_machine.excute("learing_skills_list_equip_demons_shot",0,"")
    self:onUpdateDraw()
end

function LearingListviewEquipDemons:onUpdate()
    if self.list_view ~= nil then
        local size = self.list_view:getContentSize()
        local posY = self.list_view:getInnerContainer():getPositionY()
        if self.list_view_posY == posY then
            return
        end
        self.list_view_posY = posY
        local items = self.list_view:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end
function LearingListviewEquipDemons:onUpdateDraw()
    local root = self.roots[1]
    local ListView_skills = ccui.Helper:seekWidgetByName(root,"ListView_skills")
    ListView_skills:removeAllItems()
    for i , v in pairs(self.sort_datas) do
        local cell = LearingChangeListCell:createCell()
        cell:init(v,i)
        ListView_skills:addChild(cell)
    end
    ListView_skills:requestRefreshView()
    self.list_view = ListView_skills
    self.list_view_posY = ListView_skills:getInnerContainer():getPositionY()
end
function LearingListviewEquipDemons:init()
    self:onInit()
end
function LearingListviewEquipDemons:onEnterTransitionFinish()

end

function LearingListviewEquipDemons:onExit()
    state_machine.remove("learing_skills_list_equip_demons_shot") 
    state_machine.remove("learing_skills_list_equip_demons_update")
end