-- ----------------------------------------------------------------------------------------------------
-- 说明：偷师学艺
-- 创建时间 2015-11-25
-- 作者：yanghan
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

LearingListviewDemons = class("LearingListviewDemonsClass", Window)
app.load("client.learingskills.cells.learing_list_cell")
function LearingListviewDemons:ctor()
    self.super:ctor()
    self.roots = {}
    self.list_view = nil
    self.list_view_posY = nil

    self.sort_datas = {} --排序后的数据

    -- Initialize EmailManager page state machine.
    local function init_learing_skills_list_demons_terminal()
        local learing_skills_list_demons_shot_terminal = {
            _name = "learing_skills_list_demons_shot",
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

        local learing_skills_list_demons_update_terminal = {
            _name = "learing_skills_list_demons_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("learing_skills_list_demons_shot",0,"")
                instance:onUpdateDraw()
                self.list_view_posY = -1
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(learing_skills_list_demons_shot_terminal)
        state_machine.add(learing_skills_list_demons_update_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_learing_skills_list_demons_terminal()
end
function LearingListviewDemons:getSort()
    local result = {}
    local ready_lear = {} -- 已经学习
    local not_get = {} --未获得
    local ready_get = {} --以获得
    local favor_top = dms.int(dms["teacher_pupil_link_parm"],1,teacher_pupil_link_parm.total_experience)
    for i=1,#dms["skill_equipment_mould"] do
        local ship_id = tonumber(dms.int(dms["skill_equipment_mould"],i,skill_equipment_mould.ship_mould))
        local camp_preference = dms.int(dms["ship_mould"],ship_id,ship_mould.camp_preference)
        local skill_type = dms.int(dms["skill_equipment_mould"],i,skill_equipment_mould.skill_type)
        local can_learn_skilltype = 0
        if tonumber(_ED.user_info.user_gender) == 1 then --男默认技能
            can_learn_skilltype = 3
        elseif tonumber(_ED.user_info.user_gender) == 2 then 
            can_learn_skilltype = 4
        end
        if camp_preference == 2 and can_learn_skilltype == skill_type then
            local _ship_type = dms.int(dms["ship_mould"],ship_id,ship_mould.ship_type)
            local skill_id = i
            local data = {
                ship_data = {},
                skill_data = {},
                ship_type = _ship_type,
                favor = 0, --好感度
                state = 1 --  2 可学习、1未获得 0已习得
            }
            data.ship_data = dms.element(dms["ship_mould"], ship_id)
            data.skill_data = dms.element(dms["skill_equipment_mould"],i)
            local have_ship = zstring.split(_ED.catalogue_hero_is_have, ",")

                if _ED._legendInfoStatus == "" then
                    local have_ship = zstring.split(_ED.catalogue_hero_is_have, ",")
                    for i , v in pairs(have_ship) do
                        if ship_id == tonumber(v) then
                            data.state = 2
                            break
                        end
                    end  
                else
                    local nums = 0
                    local have_ship = zstring.split(_ED.catalogue_hero_is_have, ",")
                    for i , v in pairs(have_ship) do
                        if ship_id == tonumber(v) then
                            data.state = 2
                            break
                        end
                    end  
                    for i = nums+1 , tonumber(_ED._legendNumber) do
                        if _ED._legendInfo[i] ~= nil then
                            if ship_id ==  tonumber(_ED._legendInfo[i].legendMouldId) then
                                data.state = 2
                                break
                            end
                        end
                    end
                end
            for i , v in pairs(_ED.user_skill_equipment) do
                if skill_id == tonumber(v.skill_equipment_base_mould) then
                    data.favor = tonumber(v.favor)
                    if tonumber(v.favor_level) == 1 or data.favor >= favor_top then
                        data.state = 0
                    end
                    break
                end
            end
            if data.state == 0 then
                table.insert(ready_lear,data)
            elseif data.state == 1 then
                table.insert(not_get,data)
            elseif data.state == 2 then
                table.insert(ready_get,data)
            end
        end
    end

    local function sortShipType( a, b )
        return tonumber(a.favor) > tonumber(b.favor)
            or tonumber(a.favor) == tonumber(b.favor) and tonumber(a.ship_type) > tonumber(b.ship_type)
    end
    table.sort(ready_lear, sortShipType)
    table.sort(not_get , sortShipType)
    table.sort(ready_get , sortShipType)

    for i=1, #ready_get do
        table.insert(result, ready_get[i])
    end
    for i=1, #not_get do
        table.insert(result, not_get[i])
    end
    for i=1, #ready_lear do
        table.insert(result, ready_lear[i])
    end
    self.sort_datas = result
end
function LearingListviewDemons:onInit()
    local csbItem = csb.createNode("skills/skills_listview_1.csb")
    local root = csbItem:getChildByName("root")
    table.insert(self.roots,root)
    self:addChild(csbItem)
    state_machine.excute("learing_skills_list_demons_shot",0,"")
    self:onUpdateDraw()
end

function LearingListviewDemons:onUpdate()
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
function LearingListviewDemons:onUpdateDraw()
    local root = self.roots[1]
    local ListView_skills = ccui.Helper:seekWidgetByName(root,"ListView_skills")
    ListView_skills:removeAllItems()
    for i , v in pairs(self.sort_datas) do
        local cell = LearingListCell:createCell()
        cell:init(v,i)
        ListView_skills:addChild(cell)
    end
    ListView_skills:requestRefreshView()
    self.list_view = ListView_skills
    self.list_view_posY = ListView_skills:getInnerContainer():getPositionY()
end
function LearingListviewDemons:init()
    self:onInit()
end
function LearingListviewDemons:onEnterTransitionFinish()

end

function LearingListviewDemons:onExit()
    state_machine.remove("learing_skills_list_demons_shot") 
    state_machine.remove("learing_skills_list_demons_update")
end