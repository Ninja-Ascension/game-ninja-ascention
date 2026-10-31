-- ----------------------------------------------------------------------------------------------------
-- 说明：偷师学艺
-- 创建时间 2015-11-25
-- 作者：yanghan
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
LearingChangeListCell = class("LearingChangeListCellClass", Window)
LearingChangeListCell.__size = nil
function LearingChangeListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.data = {}

    self.ship_data = nil
    self.skill_data = nil
    self.state = nil
    local function init_learing_change_list_cell_terminal() 
        local learing_change_list_cell_to_changeskill_terminal = {
            _name = "learing_change_list_cell_to_changeskill",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local skill_data = params._datas.skill_data
                local function responseLearingCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local _skill_id = dms.atos(response.node,skill_equipment_mould.id)
                        state_machine.excute("learing_skills_list_equip_dragons_update",0,"")
                        state_machine.excute("learing_skills_list_equip_demons_update",0,"")
                        state_machine.excute("learing_skills_list_equip_lotus_update",0,"")
                        state_machine.excute("learing_skills_list_equip_heroes_update",0,"")
                        state_machine.excute("formation_update_skill_icon",0,_skill_id)
                        app.load("client.learingskills.LearingSkillsChangeSuccess")
                        state_machine.excute("learing_skills_change_success_open",0,response.node) -- response.node == skill_data
                    end
                end
                local skill_id = dms.atos(skill_data,skill_equipment_mould.id)
                protocol_command.skill_adron.param_list = skill_id
                NetworkManager:register(protocol_command.skill_adron.code, nil, nil, nil, skill_data, responseLearingCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local learing_change_list_cell_go_to_skill_level_up_terminal = {
            _name = "learing_change_list_cell_go_to_skill_level_up",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local isopen , tipstr = getFunopenLevelAndTip(4)
                if isopen == true then
                    state_machine.excute("learing_skills_develop_close",0,"")              
                    app.load("client.formation.HeroInformation")
                    ---1 代表主角并且从学艺界面来                    
                    -- state_machine.excute("hero_information_open_window", 0, {-1})
                    if fwin:find("FormationTigerGateClass") ~= nil then
                        state_machine.excute("hero_develop_page_manager", 0, 
                            {
                                _datas = {
                                    terminal_name = "hero_develop_page_manager",    
                                    next_terminal_name = "hero_develop_page_open_skill_stren_page", 
                                    current_button_name = "Button_tianming",
                                    but_image = "",         
                                    heroInstance = ship,
                                    terminal_state = 0,
                                    openWinId = 4,
                                    isPressedActionEnabled = false
                                }
                            }
                        )
                    else
                        state_machine.excute("formation_open_instance_window", 0, {_datas = {_shipInstance = ship, _touch_type = "list_cell", _enter_type = "learn"}})
                    end
                else
                    TipDlg.drawTextDailog(tipstr)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(learing_change_list_cell_go_to_skill_level_up_terminal)
        state_machine.add(learing_change_list_cell_to_changeskill_terminal)
        state_machine.init()
    end
    
   -- call func init hom state machine.
   init_learing_change_list_cell_terminal()
end



function LearingChangeListCell:onEnterTransitionFinish()

end

function LearingChangeListCell:onInit()
    local root = cacher.createUIRef("skills/skills_list_line_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if LearingChangeListCell.__size == nil then
        LearingChangeListCell.__size = root:getContentSize()
    end
    local Button_skills_change = ccui.Helper:seekWidgetByName(root,"Button_skills_change") --按钮 提升亲密度
    fwin:addTouchEventListener(Button_skills_change,nil, 
    {
        terminal_name = "learing_change_list_cell_to_changeskill", 
        terminal_state = 0,
        skill_data = self.skill_data,
        isPressedActionEnabled = true
    }
    ,nil, 0)

    local Button_skills_up = ccui.Helper:seekWidgetByName(root,"Button_skills_up") --升级
    fwin:addTouchEventListener(Button_skills_up,nil, 
    {
        terminal_name = "learing_change_list_cell_go_to_skill_level_up", 
        terminal_state = 0,
        skill_data = self.skill_data,
        isPressedActionEnabled = true
    }
    ,nil, 0)    
    self:initDraw()
end


function LearingChangeListCell:initDraw()
    local root = self.roots[1]
    local ship_data = self.ship_data
    local skill_data = self.skill_data
    local state = self.state
    local skill_type = self.skill_type
    local skill_id = dms.atoi(skill_data,skill_equipment_mould.skill_equipment_base_mould)
    local level = tonumber(_ED.user_ship[_ED.user_formetion_status[1]].ship_skillstren.skill_level)
    if level == nil then
        level = 1
    end
    skill_id = skill_id + level - 1
    local Panel_2 = ccui.Helper:seekWidgetByName(root,"Panel_2") --头像
    local Panel_kuang = ccui.Helper:seekWidgetByName(root,"Panel_kuang") --头像品质框 
    local Panel_skills_icon = ccui.Helper:seekWidgetByName(root,"Panel_skills_icon") --头像品质框 
    local Text_skills_name = ccui.Helper:seekWidgetByName(root,"Text_skills_name")--技能名字
    local Text_skills_ms = ccui.Helper:seekWidgetByName(root,"Text_skills_ms")--技能描述
    local Text_teacher_name = ccui.Helper:seekWidgetByName(root,"Text_role_name") --导师名
    local Text_xx = ccui.Helper:seekWidgetByName(root,"Text_xx") --默认技能
    local picIndex = dms.atoi(ship_data, ship_mould.head_icon) --头像索引
    local quality = dms.atoi(ship_data, ship_mould.ship_type) + 1 --品质索引
    local skills_picIndex = dms.atoi(skill_data, skill_equipment_mould.pic) --技能图片索引
    local skill_name_str = dms.string(dms["skill_mould"],skill_id,skill_mould.skill_name) --技能名
    local skill_describe = dms.string(dms["skill_mould"],skill_id,skill_mould.skill_describe) --技能描述
    local skill_name = zstring.split(skill_name_str,"L")
    local hero_name = dms.atos(ship_data, ship_mould.captain_name) --英雄名字
    Text_skills_name:setString("")
    Text_skills_name:setString(skill_name[1])
    Text_skills_ms:setString("")
    Text_skills_ms:setString(skill_describe)

    Text_teacher_name:setString("")
    Text_teacher_name:setString(hero_name)
    
    Panel_2:removeBackGroundImage()
    Panel_2:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))

    Panel_skills_icon:removeBackGroundImage()
    Panel_skills_icon:setBackGroundImage(string.format("images/ui/skills_props/skills_props_%d.png", skills_picIndex)) 
    
    local Button_skills_change = ccui.Helper:seekWidgetByName(root,"Button_skills_change") --更换
    local Button_skills_up = ccui.Helper:seekWidgetByName(root,"Button_skills_up") --升级
    -- local Image_shiyong_skills = ccui.Helper:seekWidgetByName(root,"Image_shiyong_skills")--使用中
    -- Image_shiyong_skills:setVisible(false)
    Button_skills_up:setVisible(false)
    Button_skills_change:setVisible(false)
    Text_xx:setVisible(false)

    if skill_type ~= 0 then
        Text_xx:setVisible(true)
    end
    if state == 1 then
        -- Image_shiyong_skills:setVisible(true)
        Button_skills_up:setVisible(true)
        Button_skills_change:setVisible(false)
    elseif state == 0 then
        -- Image_shiyong_skills:setVisible(false)
        Button_skills_up:setVisible(false)
        Button_skills_change:setVisible(true)
    end
    local ship_mould_id = dms.atoi(skill_data,skill_equipment_mould.ship_mould)
    local ship = nil
    local captain_type = dms.atoi(ship_data,ship_mould.captain_type)
    if captain_type == 0 then
        for i , v in pairs(_ED.user_ship) do 
            if tonumber(v.ship_base_template_id) == ship_mould_id then
                quality = tonumber(v.ship_type) + 1
            end
        end
        Text_teacher_name:setString(_ED.user_info.user_name)
        if ___is_open_leadname == true then
            Text_teacher_name:setFontName("")
            Text_teacher_name:setFontSize(Text_teacher_name:getFontSize())
        end
    end
    Panel_kuang:removeBackGroundImage()
    if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
        or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
        Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_ditu_%d.png", quality))
    else
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
        else
            Panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_bigkuang_%d.png", quality))
        end
    end
    
    Text_teacher_name:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
end

function LearingChangeListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function LearingChangeListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    cacher.freeRef("skills/skills_list_line_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function LearingChangeListCell:init(data,index)
    self.data = data
    self.ship_data = data.ship_data
    self.skill_data = data.skill_data
    self.state = tonumber(data.state)
    self.skill_type =tonumber(data.skill_type)
    if index ~= nil and index < 3 then
        self:onInit()
    end
    self:setContentSize(LearingChangeListCell.__size)
    return self
end

function LearingChangeListCell:createCell()
    local cell = LearingChangeListCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end


function LearingChangeListCell:onExit()
    cacher.freeRef("skills/skills_list_line_list.csb", self.roots[1])
end

