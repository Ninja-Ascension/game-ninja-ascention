-- ----------------------------------------------------------------------------------------------------
-- 说明：角色技能界面
-------------------------------------------------------------------------------------------------------
SmRoleStrengthenTabSkill = class("SmRoleStrengthenTabSkillClass", Window)

local sm_role_strengthen_tab_skill_open_terminal = {
    _name = "sm_role_strengthen_tab_skill_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabSkillClass")
        if nil == _homeWindow then
            local panel = SmRoleStrengthenTabSkill:new():init(params)
            fwin:open(panel)
        else
            fwin:close(fwin:find("SmRoleStrengthenTabSkillClass"))
            local panel = SmRoleStrengthenTabSkill:new():init(params)
            fwin:open(panel)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_role_strengthen_tab_skill_close_terminal = {
    _name = "sm_role_strengthen_tab_skill_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmRoleStrengthenTabSkillClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmRoleStrengthenTabSkillClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_role_strengthen_tab_skill_open_terminal)
state_machine.add(sm_role_strengthen_tab_skill_close_terminal)
state_machine.init()
    
function SmRoleStrengthenTabSkill:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0
    self.is_upgrade = false
    self.text_skill_point = nil
    self.max_skill_point = 0
    self.m_times = 0 
    self.resume_times = 0 --技能恢复时间
    self.save_sel_skills = {}   --存储选择的技能

    local function init_sm_role_strengthen_tab_skill_terminal()
        -- 显示界面
        local sm_role_strengthen_tab_skill_display_terminal = {
            _name = "sm_role_strengthen_tab_skill_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabSkillWindow = fwin:find("SmRoleStrengthenTabSkillClass")
                if SmRoleStrengthenTabSkillWindow ~= nil then
                    SmRoleStrengthenTabSkillWindow:setVisible(true)
                end
                state_machine.excute("sm_role_strengthen_tab_skill_update_draw",0,"sm_role_strengthen_tab_skill_update_draw.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_role_strengthen_tab_skill_hide_terminal = {
            _name = "sm_role_strengthen_tab_skill_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmRoleStrengthenTabSkillWindow = fwin:find("SmRoleStrengthenTabSkillClass")
                if SmRoleStrengthenTabSkillWindow ~= nil then
                    SmRoleStrengthenTabSkillWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local sm_role_strengthen_tab_skill_update_draw_terminal = {
            _name = "sm_role_strengthen_tab_skill_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params ~= nil and params[1] ~= nil then
                    instance.ship_id = params[1]
                end
                if nil ~= instance.onUpdateDraw then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 请求升级
        local sm_role_strengthen_tab_skill_request_terminal = {
            _name = "sm_role_strengthen_tab_skill_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = params._datas.index
                local cell = params._datas.cell
                local shipInfo = _ED.user_ship[""..cell.ship_id]
                --进化形象
                local evo_image = dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.fitSkillTwo)
                local evo_info = zstring.split(evo_image, ",")
                --进化模板id
                local ship_evo = zstring.split(shipInfo.evolution_status, "|")
                local evo_mould_id = evo_info[tonumber(ship_evo[1])]
                --进化的天赋
                local talent = dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index)
                local talentData = zstring.splits(talent, "|",",")
                local isusemega = false
                talentData,isusemega = ReplaceMegaSkill(talentData, cell.ship_id)

                local skillData = talentData[tonumber(index)]
                   
                --天赋模板id
                local talentMouldid = skillData[3]
                local skillAllLevel = zstring.split(shipInfo.skillLevel, ",")
                --技能解锁的需求
                local demandInfo = dms.string(dms["ship_config"], 2, ship_config.param)
                local demands = zstring.split(demandInfo, ",")
                --未解锁的无法升级
                if tonumber(shipInfo.StarRating) < tonumber(demands[tonumber(index)]) then
                    return
                end
                if tonumber(skillAllLevel[index]) >= tonumber(shipInfo.ship_grade) then
                    TipDlg.drawTextDailog(_new_interface_text[19])
                    return
                end
                -- Older local profiles do not carry a skill-point recovery snapshot.
    local skill_point = zstring.split(_ED.skill_number_info or ("0," .. tostring(os.time() * 1000) .. ",0"), ",")
                if tonumber(skill_point[1]) <= 0 then
                    state_machine.excute("sm_role_strengthen_tab_bug_skill_point",0,"sm_role_strengthen_tab_bug_skill_point.")
                    return
                end 
                local function responseAdvenceHeroCallback(response)
                    state_machine.unlock("sm_role_strengthen_tab_skill_request")
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            playEffect(formatMusicFile("effect", 9993))   
                            response.node:onUpdateDraw()
                            smFightingChange()
                            local currShip = getShipByTalent(_ED.user_ship[""..response.node.ship_id])
                            response.node:onSucceedDraw(talentMouldid,shipInfo.ship_template_id,currShip,index,isusemega)

                            if fwin:find("FormationTigerGateClass") ~= nil then
                                state_machine.excute("sm_role_formation_strengthen_tab_play_control_effect",0,"")
                            end
                            if fwin:find("SmRoleStrengthenTabClass") ~= nil then
                                state_machine.excute("sm_role_strengthen_tab_play_control_effect", 0, 0)
                            end

                            -- local currShip = getShipByTalent(_ED.user_ship[""..response.node.ship_id])
                            -- local Text_digimon_fighting_n = ccui.Helper:seekWidgetByName(response.node.roots[1], "Text_digimon_fighting_n")
                            -- Text_digimon_fighting_n:setString(currShip.hero_fight)
                            -- if fwin:find("SmRoleStrengthenTabClass") ~= nil then
                            --     state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{response.node.ship_id})
                            -- end
                            -- if fwin:find("HeroDevelopClass") ~= nil then
                            -- else
                            --     for i, v in pairs(_ED.user_formetion_status) do
                            --         if tonumber(v) == tonumber(response.node.ship_id) then
                            --             state_machine.excute("formation_set_ship",0,currShip)
                            --             break
                            --         end
                            --     end
                            -- end
                            
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                then
                                local Panel_jnsj_x = ccui.Helper:seekWidgetByName(response.node.roots[1], "Panel_jnsj_" .. response.node.__f_index)
                                -- draw.createEffect("effice_skill_qh", "images/ui/effice/effice_skill_qh/effice_skill_qh.ExportJson", Panel_jnsj_x, 1, 100)
                                Panel_jnsj_x:removeAllChildren(true)
                                local effice_skill_qh = ccs.Armature:create("effice_skill_qh")
                                effice_skill_qh:removeFromParent(true)
                                effice_skill_qh:getAnimation():playWithIndex(0)
                                Panel_jnsj_x:addChild(effice_skill_qh)
                                effice_skill_qh:setPosition(cc.p((Panel_jnsj_x:getContentSize().width - effice_skill_qh:getContentSize().width)/2+effice_skill_qh:getContentSize().width/2, (Panel_jnsj_x:getContentSize().height - effice_skill_qh:getContentSize().height)/2+effice_skill_qh:getContentSize().height/2))
                            end
                        end
                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                    else
                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                    end
                end
                state_machine.lock("sm_role_strengthen_tab_skill_request")
                state_machine.lock("formation_back_to_home_activity", 0, "")
                cell.__f_index = index
                protocol_command.ship_skill_level_up.param_list = ""..cell.ship_id.."\r\n"..index.."\r\n"..talentMouldid
                NetworkManager:register(protocol_command.ship_skill_level_up.code, nil, nil, nil, cell, responseAdvenceHeroCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 请求一键升级处理 确定
        local sm_role_strengthen_tab_onekey_upgrade_ok_terminal = {
            _name = "sm_role_strengthen_tab_onekey_upgrade_ok",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local shipInfo = _ED.user_ship[""..cell.ship_id]
                --进化形象
                local evo_image = dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.fitSkillTwo)
                local evo_info = zstring.split(evo_image, ",")
                --进化模板id
                local ship_evo = zstring.split(shipInfo.evolution_status, "|")
                local evo_mould_id = evo_info[tonumber(ship_evo[1])]
                --进化的天赋
                local talent = dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index)
                local talentData = zstring.splits(talent, "|",",")
                local isusemega = false
                talentData,isusemega = ReplaceMegaSkill(talentData, cell.ship_id)
                --天赋模板id
                local talentMouldid = ""

                local needLvs = ""
                for index = 1, 6 do
                    if instance.save_sel_skills[index] ~= nil then
                        local curNeedLv = tonumber(instance.save_sel_skills[index])
                        if curNeedLv~= 0 then
                            if needLvs == "" then
                                needLvs = index..":"..curNeedLv
                            else
                                needLvs = needLvs.."|"..index..":"..curNeedLv
                            end
                            local skillData = talentData[index]
                            if talentMouldid == "" then
                                talentMouldid = skillData[3]
                            else
                                talentMouldid = talentMouldid .."|" ..skillData[3]
                            end
                            local skillAllLevel = zstring.split(shipInfo.skillLevel, ",")
                            --技能解锁的需求
                            local demandInfo = dms.string(dms["ship_config"], 2, ship_config.param)
                            local demands = zstring.split(demandInfo, ",")
                            --未解锁的无法升级
                            if tonumber(shipInfo.StarRating) < tonumber(demands[tonumber(index)]) then
                                return
                            end
                            if tonumber(skillAllLevel[index]) >= tonumber(shipInfo.ship_grade) then
                                TipDlg.drawTextDailog(_new_interface_text[19])
                                return
                            end
                            -- Older local profiles do not carry a skill-point recovery snapshot.
    local skill_point = zstring.split(_ED.skill_number_info or ("0," .. tostring(os.time() * 1000) .. ",0"), ",")
                            if tonumber(skill_point[1]) <= 0 then
                                state_machine.excute("sm_role_strengthen_tab_bug_skill_point",0,"sm_role_strengthen_tab_bug_skill_point.")
                                return
                            end
                        end
                    end
                end

                if needLvs == "" then
                    return
                end
                local function responseAdvenceHeroCallback(response)
                    state_machine.unlock("sm_role_strengthen_tab_onekey_skill_request")
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            playEffect(formatMusicFile("effect", 9993))
                            response.node.is_upgrade = false
                            response.node:onUpdateDraw()
                            smFightingChange()
--                            local currShip = getShipByTalent(_ED.user_ship[""..response.node.ship_id])
--                            response.node:onSucceedDraw(talentMouldid,shipInfo.ship_template_id,currShip,index,isusemega)

                            if fwin:find("FormationTigerGateClass") ~= nil then
                                state_machine.excute("sm_role_formation_strengthen_tab_play_control_effect",0,"")
                            end
                            if fwin:find("SmRoleStrengthenTabClass") ~= nil then
                                state_machine.excute("sm_role_strengthen_tab_play_control_effect", 0, 0)
                            end
                            TipDlg.drawTextDailog(string.format(_new_interface_text[321]))
                            -- local currShip = getShipByTalent(_ED.user_ship[""..response.node.ship_id])
                            -- local Text_digimon_fighting_n = ccui.Helper:seekWidgetByName(response.node.roots[1], "Text_digimon_fighting_n")
                            -- Text_digimon_fighting_n:setString(currShip.hero_fight)
                            -- if fwin:find("SmRoleStrengthenTabClass") ~= nil then
                            --     state_machine.excute("sm_role_strengthen_tab_update_ship_info",0,{response.node.ship_id})
                            -- end
                            -- if fwin:find("HeroDevelopClass") ~= nil then
                            -- else
                            --     for i, v in pairs(_ED.user_formetion_status) do
                            --         if tonumber(v) == tonumber(response.node.ship_id) then
                            --             state_machine.excute("formation_set_ship",0,currShip)
                            --             break
                            --         end
                            --     end
                            -- end

--                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
--                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
--                                then
--                                local Panel_jnsj_x = ccui.Helper:seekWidgetByName(response.node.roots[1], "Panel_jnsj_" .. response.node.__f_index)
--                                -- draw.createEffect("effice_skill_qh", "images/ui/effice/effice_skill_qh/effice_skill_qh.ExportJson", Panel_jnsj_x, 1, 100)
--                                Panel_jnsj_x:removeAllChildren(true)
--                                local effice_skill_qh = ccs.Armature:create("effice_skill_qh")
--                                effice_skill_qh:removeFromParent(true)
--                                effice_skill_qh:getAnimation():playWithIndex(0)
--                                Panel_jnsj_x:addChild(effice_skill_qh)
--                                effice_skill_qh:setPosition(cc.p((Panel_jnsj_x:getContentSize().width - effice_skill_qh:getContentSize().width)/2+effice_skill_qh:getContentSize().width/2, (Panel_jnsj_x:getContentSize().height - effice_skill_qh:getContentSize().height)/2+effice_skill_qh:getContentSize().height/2))
--                            end
                        end
                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                    else
                        state_machine.unlock("formation_back_to_home_activity", 0, "")
                    end
                end
                state_machine.lock("sm_role_strengthen_tab_onekey_skill_request")
                state_machine.lock("formation_back_to_home_activity", 0, "")
--                cell.__f_index = index
                protocol_command.ship_skill_level_up_one_key.param_list = ""..cell.ship_id.."\r\n"..needLvs.."\r\n"..talentMouldid

                NetworkManager:register(protocol_command.ship_skill_level_up_one_key.code, nil, nil, nil, cell, responseAdvenceHeroCallback, false, nil)


                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 查看技能
        local sm_role_strengthen_tab_skill_to_view_terminal = {
            _name = "sm_role_strengthen_tab_skill_to_view",
            _init = function (terminal) 
                app.load("client.packs.hero.SmRoleStrengthenTabSkillDescription")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local index = tonumber(params._datas.index)
                local shipInfo = _ED.user_ship[""..instance.ship_id]
                --进化形象
                local evo_image = dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.fitSkillTwo)
                local evo_info = zstring.split(evo_image, ",")
                --进化模板id
                local ship_evo = zstring.split(shipInfo.evolution_status, "|")
                local evo_mould_id = smGetSkinEvoIdChange(shipInfo)
                --进化的天赋
                local talent = dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index)
                local talentData = zstring.splits(talent, "|",",")
                local isusemega = false
                talentData,isusemega = ReplaceMegaSkill(talentData, instance.ship_id)
                local skillData =  talentData[index]

                --天赋模板id
                local talentMouldid = skillData[3]
                --技能模板id
                local skillMouldid = dms.int(dms["talent_mould"], talentMouldid, talent_mould.skill_mould_id)
                state_machine.excute("sm_role_strengthen_tab_skill_description_open",0,{shipInfo,talentMouldid,index,isusemega})

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 购买技能点
        local sm_role_strengthen_tab_bug_skill_point_terminal = {
            _name = "sm_role_strengthen_tab_bug_skill_point",
            _init = function (terminal) 
                app.load("client.utils.SmBuyPhysical")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local canBuyTimes = dms.int(dms["base_consume"] ,58 , base_consume.vip_0_value + tonumber(_ED.vip_grade))
                -- Older local profiles do not carry a skill-point recovery snapshot.
    local skill_point = zstring.split(_ED.skill_number_info or ("0," .. tostring(os.time() * 1000) .. ",0"), ",")
                canBuyTimes = canBuyTimes - tonumber(skill_point[3])
                local needGoodsArry = zstring.split(dms.string(dms["ship_config"] ,7, ship_config.param) , ",")
                local needGoods = 0
                local pointNumber = dms.int(dms["ship_config"] ,6, ship_config.param)
                if tonumber(skill_point[3]) < #needGoodsArry then
                    needGoods = needGoodsArry[tonumber(skill_point[3]) + 1]
                else
                    needGoods = needGoodsArry[#needGoodsArry]
                end
                local data = {}
                if canBuyTimes > 0 then
                    data[1] = 1
                    data[2] = "1"
                    data[3] = true
                    data[4] = _new_interface_text[24]--标题
                    data[5] = string.format(_new_interface_text[20] , tonumber(_ED.vip_grade) , canBuyTimes)
                    data[6] = false
                    data[7] = string.format(_new_interface_text[21] , pointNumber)
                    data[8] = needGoods
                else
                    data[1] = true
                    data[2] = "2"
                    data[3] = false
                    data[4] = _new_interface_text[24]--标题
                    data[5] = _new_interface_text[22]
                    data[6] = _new_interface_text[23]
                end
                state_machine.excute("sm_buy_physicalopen", 0 , data)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 一键升级处理
        local sm_role_strengthen_tab_onekey_upgrade_terminal = {
            _name = "sm_role_strengthen_tab_onekey_upgrade",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.is_upgrade = true
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 一键升级处理 取消
        local sm_role_strengthen_tab_onekey_upgrade_no_terminal = {
            _name = "sm_role_strengthen_tab_onekey_upgrade_no",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.is_upgrade = false
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_role_strengthen_tab_skill_display_terminal)
        state_machine.add(sm_role_strengthen_tab_skill_hide_terminal)
        state_machine.add(sm_role_strengthen_tab_skill_update_draw_terminal)
        state_machine.add(sm_role_strengthen_tab_skill_request_terminal)
        state_machine.add(sm_role_strengthen_tab_skill_to_view_terminal)
        state_machine.add(sm_role_strengthen_tab_bug_skill_point_terminal)
        state_machine.add(sm_role_strengthen_tab_onekey_upgrade_terminal)
        state_machine.add(sm_role_strengthen_tab_onekey_upgrade_ok_terminal)
        state_machine.add(sm_role_strengthen_tab_onekey_upgrade_no_terminal)

        state_machine.init()
    end
    init_sm_role_strengthen_tab_skill_terminal()
end

function SmRoleStrengthenTabSkill:onSucceedDraw(talentMould,shipMould,shipInfo,index,isusemega)
    local isusemega = isusemega
    local root = self.roots[1]
    local Panel_skill_icon = ccui.Helper:seekWidgetByName(root, "Panel_skiil_"..self.__f_index)
    -- 临时处理
    if tonumber(index) == 2 then
        local evo_image = dms.string(dms["ship_mould"], tonumber(shipMould), ship_mould.fitSkillTwo)
        --进化形象
        local evo_info = zstring.split(evo_image, ",")
        --先找到羁绊
        local myRelatioInfo = zstring.zsplit(dms.string(dms["ship_mould"], tonumber(shipMould), ship_mould.relationship_id), ",")
        --看是否有羁绊可以影响必杀觉醒
        local influences_id = 0
        for i,v in pairs(myRelatioInfo) do
            local influences = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.zoarium_skill)
            if influences > 0 then
                influences_id = dms.int(dms["fate_relationship_mould"], v, fate_relationship_mould.id)
                break
            end
        end
        --不等于0说明影响
        if influences_id ~= 0 then
            --判断羁绊是否激活
            local relation_need1_type = dms.int(dms["fate_relationship_mould"], influences_id, fate_relationship_mould.relation_need1_type)
            
            if relation_need1_type == 1 then        --装备需求
                --武将装备数据（等级|品质|经验|星级|模板）
                local shipEquip = zstring.split(shipInfo.equipInfo, "|")[5]
                local equip_mould = zstring.split(shipEquip, ",")
                local relation_need1 = dms.int(dms["fate_relationship_mould"], influences_id, fate_relationship_mould.relation_need1)
                for i,v in pairs(equip_mould) do
                    if tonumber(v) == tonumber(relation_need1) then
                        local ship_evo = zstring.split(shipInfo.evolution_status, "|")
                        evo_mould_id = evo_info[tonumber(ship_evo[1])]
                        local talent_id = dms.string(dms["ship_mould"], tonumber(shipMould), ship_mould.talent_id)
                        local new_talent_info = zstring.split(talent_id, "|")[tonumber(ship_evo[1])]

                        --有皮肤直接取皮肤的觉醒技能id
                        local current_skin_id = 0
                        if shipInfo.ship_skin_info and shipInfo.ship_skin_info ~= "" then
                            local skin_info = zstring.splits(shipInfo.ship_skin_info, "|", ":")
                            local temp = zstring.split(skin_info[1][1], ",")
                            current_skin_id = zstring.tonumber(temp[1])
                        end
                        if current_skin_id ~= 0 then
                            local zoarium_skill_ids = dms.string(dms["ship_skin_mould"], current_skin_id, ship_skin_mould.zoarium_skill_id)
                            new_talent_info = zoarium_skill_ids
                        end
                      
                        if not isusemega then
                           talentMould = zstring.split(new_talent_info, ",")[3]
                        end
                        break
                    end
                end
            elseif relation_need1_type == 0 then        --武将需求

            elseif relation_need1_type == 2 then        --皮肤需求

            end
        end
        -- --找到对应的天赋觉醒需求数据
        -- local talent_activite_need = dms.string(dms["ship_mould"], tonumber(shipMould), ship_mould.talent_activite_need)
        -- local need_info = zstring.split(talent_activite_need, ",")
        -- --武将装备数据（等级|品质|经验|星级|模板）
        -- local shipEquip = zstring.split(shipInfo.equipInfo, "|")[4]
        -- local equip_star = zstring.split(shipEquip, ",")

        -- --先找到觉醒技能的需求
        -- --再找到对应的装备进化后的天赋模板
        -- if #need_info > 1 then
        --     if tonumber(equip_star[tonumber(need_info[1])+1]) > tonumber(need_info[2]) then
        --         local talent_id = dms.string(dms["ship_mould"], tonumber(shipMould), ship_mould.talent_id)
        --         local new_talent_info = zstring.split(talent_id, "|")[tonumber(evo_mould_id)]
        --         talentMould = zstring.split(new_talent_info, ",")[3]
        --     end
        -- end
    end
    --技能成长
    -- local baseData = ""
    -- local talent_star_quality = dms.string(dms["talent_mould"], talentMould, talent_mould.upgrade_require)
    -- local growing_info = zstring.split(talent_star_quality, "|")
    -- for i,v in pairs(growing_info) do
    --     local value = zstring.split(v, ",")
    --     local addPercent = ""
    --     if tonumber(value[1]) >= 4 and tonumber(value[1]) <= 17 then
    --         addPercent = "%"
    --     elseif tonumber(value[1]) >= 33 and tonumber(value[1]) <= 36 then
    --         addPercent = "%"
    --     elseif tonumber(value[1]) >= 39 and tonumber(value[1]) <= 40 then
    --         addPercent = "%"
    --     elseif tonumber(value[1]) >= 42 and tonumber(value[1]) <= 63 then
    --         addPercent = "%"
    --     elseif tonumber(value[1]) >= 65 and tonumber(value[1]) <= 71 then
    --         addPercent = "%"
    --     elseif tonumber(value[1]) >= 73 and tonumber(value[1]) <= 83 then
    --         addPercent = "%"
    --     end
    --     if i == 1 then
    --         baseData = baseData..skill_attributes_text_tips[tonumber(value[1])+1].."+"..value[2]..addPercent
    --     else
    --         baseData = baseData.." "..skill_attributes_text_tips[tonumber(value[1])+1].."+"..value[2]..addPercent
    --     end
    -- end

    for i=1,10 do
        if Panel_skill_icon:getChildByTag(9981+i) ~= nil then 
            Panel_skill_icon:removeChildByTag(9981+i)
        end
        if Panel_skill_icon:getChildByTag(8981+i) ~= nil then 
            Panel_skill_icon:removeChildByTag(8981+i)
        end
    end

    local Text_digimon_name = ccui.Helper:seekWidgetByName(root, "Text_digimon_name")
    local skill_describe_id = dms.int(dms["talent_mould"], talentMould, talent_mould.talent_describe)
    local word_info = dms.element(dms["word_mould"], skill_describe_id)
    local skill_txt = word_info[4]
    if skill_txt ~= -1 then
        local txt = zstring.split(skill_txt, "|")
        local index = 0
        for i,v in pairs(txt) do
            index = index + 1
            local text = cc.Label:createWithTTF(v, Text_digimon_name:getFontName(), 18 / CC_CONTENT_SCALE_FACTOR(), cc.size(250, 50))
            text:setName("skill_info")
            text:setTag(9981+index)
            Panel_skill_icon:addChild(text,10000)
            text:setPosition(cc.p(150, 10-index*9))
            text:setColor(cc.c3b(0,175,0))
            local text2 = cc.Label:createWithTTF(v, Text_digimon_name:getFontName(), 18 / CC_CONTENT_SCALE_FACTOR(), cc.size(250, 50))
            text2:setName("skill_info2")
            text2:setTag(8981+index)
            Panel_skill_icon:addChild(text2,9999)
            text2:setPosition(cc.p(151, 11-index*9))
            text2:setColor(cc.c3b(0,0,0))
            local seq = cc.Sequence:create(
                cc.Spawn:create({cc.MoveBy:create(1, cc.p(0, 50))
                        -- cc.FadeTo:create(0.5, 0)
                    }),
                cc.CallFunc:create(function ( sender )
                sender:removeFromParent(true)
            end))
            local seq2 = cc.Sequence:create(
                cc.Spawn:create({cc.MoveBy:create(1, cc.p(0, 50))
                        -- cc.FadeTo:create(0.5, 0)
                    }),
                cc.CallFunc:create(function ( sender )
                sender:removeFromParent(true)
            end))
            text:runAction(seq)
            text2:runAction(seq2)
        end
    end
    -- local text = cc.Label:createWithTTF(baseData, "fonts/FZYiHei-M20S.ttf", 18 / CC_CONTENT_SCALE_FACTOR(), cc.size(250, 50))
    -- text:setName("skill_info")
    -- text:setTag(9981)
    -- Panel_skill_icon:addChild(text,10000)
    -- text:setPosition(cc.p(150, 10))
    -- text:setColor(cc.c3b(0,175,0))

    -- local text2 = cc.Label:createWithTTF(baseData, "fonts/FZYiHei-M20S.ttf", 18 / CC_CONTENT_SCALE_FACTOR(), cc.size(250, 50))
    -- text2:setName("skill_info2")
    -- text2:setTag(9982)
    -- Panel_skill_icon:addChild(text2,9999)
    -- text2:setPosition(cc.p(151, 11))
    -- text2:setColor(cc.c3b(0,0,0))

    -- local seq = cc.Sequence:create(
    --     cc.Spawn:create({cc.MoveBy:create(1, cc.p(0, 50))
    --             -- cc.FadeTo:create(0.5, 0)
    --         }),
    --     cc.CallFunc:create(function ( sender )
    --     sender:removeFromParent(true)
    -- end))
    -- local seq2 = cc.Sequence:create(
    --     cc.Spawn:create({cc.MoveBy:create(1, cc.p(0, 50))
    --             -- cc.FadeTo:create(0.5, 0)
    --         }),
    --     cc.CallFunc:create(function ( sender )
    --     sender:removeFromParent(true)
    -- end))
    -- text:runAction(seq)
    -- text2:runAction(seq2)
end


function SmRoleStrengthenTabSkill:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local shipInfo = _ED.user_ship[""..self.ship_id]
    if shipInfo == nil then
        return
    end
    local currShip = getShipByTalent(_ED.user_ship[""..self.ship_id])
    self.save_sel_skills = {}   --存储选择的技能
    local userGrade = tonumber(_ED.user_info.user_grade) --玩家等级(用户等级)
    local shipGrade = tonumber(shipInfo.ship_grade) --多柯梦等级
    local limitSliderDis = math.min(userGrade,shipGrade) --获取滑块可以滑动的距离
    local userMaxLevel = dms.int(dms["user_config"], 5, user_config.param) --玩家最大等级
    --获取天赋
    --进化形象
    local evo_image = dms.string(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.fitSkillTwo)
    local evo_info = zstring.split(evo_image, ",")
    --进化模板id
    local ship_evo = zstring.split(shipInfo.evolution_status, "|")
    local evo_mould_id = smGetSkinEvoIdChange(shipInfo)
    --进化的天赋
    local talent = dms.string(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.talent_index)
    local talentData = zstring.splits(talent, "|",",")
    local isusemega = false
    talentData,isusemega = ReplaceMegaSkill(talentData, self.ship_id)
  
    --技能解锁的需求
    local demandInfo = dms.string(dms["ship_config"], 2, ship_config.param)
    local demands = zstring.split(demandInfo, ",")

    --攻防技
    local Panel_strengthen_stye = ccui.Helper:seekWidgetByName(root, "Panel_strengthen_stye")
    Panel_strengthen_stye:removeBackGroundImage()
    local camp_preference = dms.int(dms["ship_mould"], shipInfo.ship_template_id, ship_mould.camp_preference)
    if camp_preference> 0 and camp_preference <=3 then
        Panel_strengthen_stye:setBackGroundImage(string.format("images/ui/icon/type_icon_%d.png", camp_preference))
    end

    --名称
    local Text_digimon_name = ccui.Helper:seekWidgetByName(root, "Text_digimon_name")
    local name = nil
    local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    name = word_info[3]
    if getShipNameOrder(tonumber(shipInfo.Order)) > 0 then
        name = name.." +"..getShipNameOrder(shipInfo.Order)
    end
    Text_digimon_name:setString(name)
    local quality = 1
    quality = shipOrEquipSetColour(tonumber(shipInfo.Order))
    local color_R = tipStringInfo_quality_color_Type[quality][1]
    local color_G = tipStringInfo_quality_color_Type[quality][2]
    local color_B = tipStringInfo_quality_color_Type[quality][3]
    Text_digimon_name:setColor(cc.c3b(color_R, color_G, color_B))

    for i=1, 7 do
        local Image_star = ccui.Helper:seekWidgetByName(root, "Image_star_"..i)
        if tonumber(shipInfo.StarRating) >= i then
            Image_star:setVisible(true)
        else
            Image_star:setVisible(false)
        end
    end

    --等级
    local Text_digimon_lv_n = ccui.Helper:seekWidgetByName(root, "Text_digimon_lv_n")
    Text_digimon_lv_n:setString(shipInfo.ship_grade)

    --战力
    local Text_digimon_fighting_n = ccui.Helper:seekWidgetByName(root, "Text_digimon_fighting_n")
    Text_digimon_fighting_n:setString(currShip.hero_fight)

    --技能等级
    local skillAllLevel = zstring.split(shipInfo.skillLevel, ",")

    local Text_skill_point = ccui.Helper:seekWidgetByName(root,"Text_skill_point")
    -- local max_skill_point = zstring.split(dms.string(dms["ship_config"], 5 , ship_config.param) , ",")
    local max_skill_Interval = zstring.split(dms.string(dms["user_config"], 14 , ship_config.param) , "|")
    for i,v in pairs(max_skill_Interval) do
        local datas = zstring.split(v , ",")
        local interval = zstring.split(datas[1] , "-")
        if userGrade >= tonumber(interval[1]) and userGrade <= tonumber(interval[2]) then
            self.max_skill_point = tonumber(datas[2])
            break
        end
    end
    -- self.max_skill_point = tonumber(max_skill_point[2])
    -- Older local profiles do not carry a skill-point recovery snapshot.
    local skill_point = zstring.split(_ED.skill_number_info or ("0," .. tostring(os.time() * 1000) .. ",0"), ",")
    self.resume_times = dms.int(dms["base_consume"] ,59 , base_consume.vip_0_value + tonumber(_ED.vip_grade))
    --计算已经恢复了多少点
    local currSystemTime = os.time() - tonumber(_ED.native_time) + tonumber(_ED.system_time)
    local alreadyGoTime = ( currSystemTime - zstring.tonumber(skill_point[2]) / 1000 )
    alreadyGoTime = math.max(0 , alreadyGoTime)
    local alreadyResume = math.floor( alreadyGoTime / self.resume_times)
    local currPoint = tonumber(skill_point[1]) + alreadyResume
    local lastResumeTime = (zstring.tonumber(skill_point[2]) + alreadyResume * self.resume_times * 1000) 
    currPoint = math.min(currPoint , self.max_skill_point)
    currPoint = math.max(0 , currPoint)
    _ED.skill_number_info = ""
    _ED.skill_number_info = currPoint..","..lastResumeTime..","..skill_point[3]

    self.m_times = lastResumeTime / 1000 + self.resume_times - currSystemTime--下次恢复倒计时
    self.text_skill_point = Text_skill_point
    
    for i=1,6 do
        local percent = 0
        local skillData = talentData[i]
        --天赋模板id
        local talentMouldid = skillData[3]
        -- local skillMouldid = skillData[3]
        local isReal = true
        --技能模板id
        local skillMouldid = dms.int(dms["talent_mould"], talentMouldid, talent_mould.skill_mould_id)
        -- if skillMouldid == -1 then
        --     isReal = false
        -- end
        --画技能图标
        local Panel_skill_icon = ccui.Helper:seekWidgetByName(root, "Panel_skill_icon_"..i)
        Panel_skill_icon:removeAllChildren(true)
        local skill_icon = nil
        local pic_index = dms.int(dms["talent_mould"], talentMouldid, talent_mould.new_skill_pic)
        skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", pic_index))
        --测试临时的图,正式的时候换成上面的代码
        --skill_icon = cc.Sprite:create(string.format("images/ui/skills/skills_%d.png", i))
        if skill_icon ~= nil then
            skill_icon:setPosition(cc.p(Panel_skill_icon:getContentSize().width/2,Panel_skill_icon:getContentSize().height/2))
            Panel_skill_icon:addChild(skill_icon)
        end
        --技能名称
        local Text_skill_name = ccui.Helper:seekWidgetByName(root, "Text_skill_name_"..i)
        local skillNameId = dms.int(dms["talent_mould"], talentMouldid, talent_mould.talent_name)
        local word_info = dms.element(dms["word_mould"], skillNameId)
        local skillName = word_info[3]
        skillName = skillDescriptionReplaceData(talentMouldid,shipInfo.ship_template_id,i,1,false,nil,isusemega)
        Text_skill_name:setString(skillName)
        --技能升级消耗金钱
        local Text_lvup_gold_n = ccui.Helper:seekWidgetByName(root, "Text_lvup_gold_n_"..i)
        --先找到天赋的消耗库组
        local LibraryGroup = dms.int(dms["talent_mould"], talentMouldid, talent_mould.consumption_Library_group)
        --通过库组和等级在天赋消耗表里找徐要消耗的金钱(现在没有技能数据，暂时都是1级)
        local requirement = dms.searchs(dms["talent_level_requirement"], talent_level_requirement.current_level, skillAllLevel[i])
        if zstring.tonumber(requirement[1][LibraryGroup+2]) > tonumber(_ED.user_info.user_silver) then
            Text_lvup_gold_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        else
            Text_lvup_gold_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
        end
        Text_lvup_gold_n:setString(requirement[1][LibraryGroup+2])
        --技能解锁说明
        local Text_tip = ccui.Helper:seekWidgetByName(root, "Text_tip_"..i)
        --技能等级
        local Text_skill_lv = ccui.Helper:seekWidgetByName(root, "Text_skill_lv_"..i)
        --(现在没有技能数据，暂时都是1级)
        Text_skill_lv:setString(skillAllLevel[i])
        local cur_skill_lv = tonumber(skillAllLevel[i])
        --技能锁定图标
        local Image_locking = ccui.Helper:seekWidgetByName(root, "Image_locking_"..i)
        --金钱图标
        local Button_lvup = ccui.Helper:seekWidgetByName(root,"Button_lvup_"..i)
        local Image_gold_icon = ccui.Helper:seekWidgetByName(root, "Image_gold_icon_"..i)
        if tonumber(shipInfo.StarRating) >= tonumber(demands[i]) then
            Image_locking:setVisible(false)
            Image_gold_icon:setVisible(true)
            Text_tip:setString("")
            -- display:ungray(skill_icon)
            Button_lvup:setVisible(true)
        else
            Button_lvup:setVisible(false)
            Image_locking:setVisible(true)
            Text_tip:setString(string.format(_new_interface_text[7],zstring.tonumber(demands[i])))
            Image_gold_icon:setVisible(false)
            -- display:gray(skill_icon)
            Text_lvup_gold_n:setString("")
            Text_skill_lv:setString("")
        end
        local Panel_onekey_box = ccui.Helper:seekWidgetByName(root,"Panel_onekey_box_"..i)
        if cur_skill_lv >= userGrade
            or cur_skill_lv >= shipGrade
            -- or tonumber(currPoint) == 0 
            then
            Button_lvup:setBright(false)
            Button_lvup:setHighlighted(false)
        else
            if Panel_onekey_box ~= nil then
                Button_lvup:setBright(not self.is_upgrade)
                Button_lvup:setHighlighted(not self.is_upgrade)
            else
                Button_lvup:setBright(true)
                Button_lvup:setHighlighted(true)
            end
        end
        if Panel_onekey_box  then
            if Image_locking:isVisible() == false and cur_skill_lv < limitSliderDis then
                Panel_onekey_box:setVisible(self.is_upgrade)
                Panel_onekey_box:setBright(self.is_upgrade)
                Panel_onekey_box:setTouchEnabled(self.is_upgrade)
            else
                Panel_onekey_box:setVisible(false)
                Panel_onekey_box:setBright(false)
                Panel_onekey_box:setTouchEnabled(false)
            end
            local Image_skill_bg = ccui.Helper:seekWidgetByName(root,"Image_skill_bg_"..i)
            Image_skill_bg:setTouchEnabled(not self.is_upgrade)

            if Button_lvup:isVisible() == true then
                Button_lvup:setVisible(not self.is_upgrade)
                Button_lvup:setTouchEnabled(not self.is_upgrade)
                Image_gold_icon:setVisible(not self.is_upgrade)
            end

            if self.is_upgrade == true then
                Text_lvup_gold_n:setString("")
            end
            local Text_lvup_gold_onekey_n = ccui.Helper:seekWidgetByName(root,"Text_lvup_gold_onekey_n_"..i) --升级要用的金币

            local Image_gold_icon_onekey = ccui.Helper:seekWidgetByName(root,"Image_gold_icon_onekey_"..i)  --升级要用的金币icon

            local Slider_onekey = ccui.Helper:seekWidgetByName(root,"Slider_onekey_"..i)  --滚动条

            local changePercentShow         --改变滚动条显示
            local function changeCostGold()     --改变金币消耗显示
                local costGold = 0
                local last = limitSliderDis - cur_skill_lv
                local saveSelSkillLv = math.ceil(percent/100*last)
                local curLvPer = cur_skill_lv
                local tempLv = saveSelSkillLv+ curLvPer
                Slider_onekey:setPercent(percent)
                if curLvPer <= 0 then
                    curLvPer = 1
                end
                if tempLv <= 0 then
                    tempLv = 1
                elseif(tempLv > limitSliderDis) then
                    tempLv = limitSliderDis
                end
                tempLv = tempLv -1
                for i = curLvPer, tempLv do
                    local lvRequirement = dms.searchs(dms["talent_level_requirement"], talent_level_requirement.current_level, i)
                    if lvRequirement  then
                        if lvRequirement[1] then
                            local curCostGold = zstring.tonumber(lvRequirement[1][LibraryGroup+2])
                            costGold = costGold + curCostGold
                        end
                    end
                end
                if costGold > tonumber(_ED.user_info.user_silver) then
                    Text_lvup_gold_onekey_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
                else
                    Text_lvup_gold_onekey_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
                end
                Text_lvup_gold_onekey_n:setString(""..costGold)
            end
            local Button_onekey_add = ccui.Helper:seekWidgetByName(root,"Button_onekey_add_"..i)  --添加 Button
            local function onAddTouchEvent(sender, eventType)
                if eventType == ccui.TouchEventType.began then
                elseif eventType == ccui.TouchEventType.moved then
                elseif eventType == ccui.TouchEventType.ended then
                    local last = limitSliderDis - cur_skill_lv
                    local select_num = math.ceil(100/last)
                    percent = percent + select_num
                    changePercentShow()
                    changeCostGold()
                end
            end
            Button_onekey_add:addTouchEventListener(onAddTouchEvent)
            Button_onekey_add:setTouchEnabled(percent ~= 100)
            Button_onekey_add:setBright(percent ~= 100)

            local Button_onekey_red = ccui.Helper:seekWidgetByName(root,"Button_onekey_minus_"..i)  --减少 Button
            local function onRedTouchEvent(sender, eventType)
                if eventType == ccui.TouchEventType.began then
                elseif eventType == ccui.TouchEventType.moved then
                elseif eventType == ccui.TouchEventType.ended then
                    local last = limitSliderDis - cur_skill_lv
                    local select_num = math.ceil(100/last)
                    percent = percent - select_num
                    changePercentShow()
                    changeCostGold()
                end
            end
            Button_onekey_red:addTouchEventListener(onRedTouchEvent)
            Button_onekey_red:setTouchEnabled(percent ~= 0)
            Button_onekey_red:setBright(percent ~= 0)

            local function percentChangedEvent(sender,eventType)
                if eventType == ccui.SliderEventType.percentChanged then
                    percent = tonumber(sender:getPercent())
                    changePercentShow()
                    changeCostGold()
                end
            end
            Slider_onekey:addEventListener(percentChangedEvent)
            Slider_onekey:setPercent(percent)
            Image_gold_icon_onekey:setVisible(false)
            Text_lvup_gold_onekey_n:setVisible(false)
            Text_skill_name:setVisible(true)

            --改变滚动条滑动显示逻辑处理
            changePercentShow = function()
                local last = limitSliderDis - cur_skill_lv
                local curLvPer = cur_skill_lv
                local select_num = math.ceil(percent/100*last) + curLvPer
                if select_num > limitSliderDis then      --小于限制等级
                    select_num = limitSliderDis
                end
                Text_skill_lv:setString(""..select_num)
                local is_show_gold_onekey = (percent >0) and true or false
                Image_gold_icon_onekey:setVisible(is_show_gold_onekey)
                Text_lvup_gold_onekey_n:setVisible(is_show_gold_onekey)
                Text_skill_name:setVisible(not is_show_gold_onekey)
                Button_onekey_add:setTouchEnabled(percent ~= 100)
                Button_onekey_add:setBright(percent ~= 100)
                Button_onekey_red:setTouchEnabled(percent ~= 0)
                Button_onekey_red:setBright(percent ~= 0)

                --通过库组和等级在天赋消耗表里找徐要消耗的金钱(现在没有技能数据，暂时都是1级)
                local saveSelSkillLv = select_num - curLvPer
                self.save_sel_skills[i] = saveSelSkillLv
                --            debug.print_r(self.save_sel_skills,"self.save_sel_skills=")
            end
            local Button_skiil_onekey = ccui.Helper:seekWidgetByName(root,"Button_skiil_onekey")
            Button_skiil_onekey:setVisible(not self.is_upgrade)
            local Button_skiil_onekey_ok = ccui.Helper:seekWidgetByName(root,"Button_skiil_onekey_ok")
            Button_skiil_onekey_ok:setVisible( self.is_upgrade)
            local Button_skiil_onekey_no = ccui.Helper:seekWidgetByName(root,"Button_skiil_onekey_no")
            Button_skiil_onekey_no:setVisible( self.is_upgrade)
        end
    end

end

function SmRoleStrengthenTabSkill:formatTimeString(_time)  --系统时间转换
    local timeString = ""
    --timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
    return timeString
end

function SmRoleStrengthenTabSkill:onUpdate(dt)
    -- Older local profiles do not carry a skill-point recovery snapshot.
    local skill_point = zstring.split(_ED.skill_number_info or ("0," .. tostring(os.time() * 1000) .. ",0"), ",")
    local strs = ""
    if self.text_skill_point ~= nil then
        if tonumber(skill_point[1]) >= self.max_skill_point then
            strs = string.format(_new_interface_text[9],zstring.tonumber(skill_point[1]),_new_interface_text[18])
            self.text_skill_point:setString(strs)
            return
        end
        if tonumber(self.m_times) > 0 then
            self.m_times = self.m_times - dt
            strs = string.format(_new_interface_text[9],zstring.tonumber(skill_point[1]) ,self:formatTimeString(self.m_times))
            if self.m_times <= 0 then
                skill_point[1] = tonumber(skill_point[1]) + 1
                skill_point[2] = (os.time() - tonumber(_ED.native_time) + tonumber(_ED.system_time) + self.resume_times) * 1000
                self.m_times = self.resume_times
                _ED.skill_number_info = zstring.concat(skill_point, ",")
            end
        end
        self.text_skill_point:setString(strs)
    end
end

function SmRoleStrengthenTabSkill:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow     
    self.ship_id = params[2]
    self.is_upgrade = false
    self:onInit()
    return self
end

function SmRoleStrengthenTabSkill:onInit()
    local csbSmRoleStrengthenTabSkill = csb.createNode("packs/HeroStorage/sm_role_strengthen_tab_cell_4.csb")
    local root = csbSmRoleStrengthenTabSkill:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmRoleStrengthenTabSkill)
	
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effice_skill_qh/effice_skill_qh.ExportJson")

    self:onUpdateDraw()
    
    for i=1, 6 do
        --升级请求
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_lvup_"..i), nil, 
        {
            terminal_name = "sm_role_strengthen_tab_skill_request", 
            terminal_state = 0,
            index = i,
            cell = self,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        local Image_skill_bg = ccui.Helper:seekWidgetByName(self.roots[1],"Image_skill_bg_"..i)
        fwin:addTouchEventListener(Image_skill_bg, nil, 
        {
            terminal_name = "sm_role_strengthen_tab_skill_request", 
            terminal_state = 0,
            index = i,
            cell = self,
            isPressedActionEnabled = true
        }, 
        nil, 0)
        Image_skill_bg:setTouchEnabled(true)
        --查看技能
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Panel_skill_icon_"..i), nil, 
        {
            terminal_name = "sm_role_strengthen_tab_skill_to_view", 
            terminal_state = 0,
            index = i,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_add_point"), nil, 
    {
        terminal_name = "sm_role_strengthen_tab_bug_skill_point", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --点击一键升级按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_skiil_onekey"), nil,
    {
        terminal_name = "sm_role_strengthen_tab_onekey_upgrade",
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil, 0)
    --点击确定按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_skiil_onekey_ok"), nil,
    {
        terminal_name = "sm_role_strengthen_tab_onekey_upgrade_ok",
        terminal_state = 0,
        cell = self,
        isPressedActionEnabled = true
    },
    nil, 0)
    --点击取消按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(self.roots[1],"Button_skiil_onekey_no"), nil,
    {
        terminal_name = "sm_role_strengthen_tab_onekey_upgrade_no",
        terminal_state = 0,
        isPressedActionEnabled = true
    },
    nil, 0)

end

function SmRoleStrengthenTabSkill:onExit()
    state_machine.remove("sm_role_strengthen_tab_skill_display")
    state_machine.remove("sm_role_strengthen_tab_skill_hide")
    state_machine.remove("sm_role_strengthen_tab_skill_request")
    state_machine.remove("sm_role_strengthen_tab_skill_to_view")
    state_machine.remove("sm_role_strengthen_tab_bug_skill_point")
    state_machine.remove("sm_role_strengthen_tab_skill_update_draw")
    state_machine.remove("sm_role_strengthen_tab_onekey_upgrade")
    state_machine.remove("sm_role_strengthen_tab_onekey_upgrade_ok")
    state_machine.remove("sm_role_strengthen_tab_onekey_upgrade_no")
end