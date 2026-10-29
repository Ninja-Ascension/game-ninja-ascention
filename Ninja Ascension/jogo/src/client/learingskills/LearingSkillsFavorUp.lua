-- ----------------------------------------------------------------------------------------------------
-- 说明：偷师学艺
-- 创建时间	2015-11-25
-- 作者：yanghan
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

LearingSkillsFavorUp = class("LearingSkillsFavorUpClass", Window)
local learing_skills_favor_open_terminal = {
    _name = "learing_skills_favor_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.lock("learing_skills_favor_open")
        local data = params._datas.data
        local _LearingSkillsFavorUp = LearingSkillsFavorUp:new()
        _LearingSkillsFavorUp:init(data)
        fwin:open(_LearingSkillsFavorUp,fwin._windows)


        fwin:open(UserTopInfoA:new(),fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(learing_skills_favor_open_terminal)
state_machine.init()
function LearingSkillsFavorUp:ctor()
    self.super:ctor()
	self.roots = {}
    self.ship_data = nil
    self.skill_data = nil
    self.state = nil
    self.favor = nil
    self.skill_id = nil
    self.camp = nil
    self.nowneedmoney = nil
    self.nowtenneedmoney = nil
    self.isSureGoldToBuye = false
    -- Initialize LearingSkillsFavorUp page state machine.
    local function init_learing_skills_favor_up_terminal()
        --关闭界面
        local learing_skills_favor_up_close_terminal = {
            _name = "learing_skills_favor_up_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
                fwin:close(fwin:find("UserTopInfoAClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新
        local learing_skills_favor_up_update_terminal = {
            _name = "learing_skills_favor_up_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateData()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --偷师
        local learing_skills_favor_up_onece_terminal = {
            _name = "learing_skills_favor_up_onece",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local learing_type = params._datas.learing_type
                local function responseLearingCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil then
                            if fwin:find("LearingSkillsEventClass") ~= nil then
                                fwin:close(fwin:find("LearingSkillsEventClass"))
                            end
                            state_machine.excute("learing_skills_event_open",0,{response.node.skill_id,response.node.camp,response.node.skill_data})
                        end
                    end
                end
                local skill_equipment = _ED.user_skill_equipment[""..instance.skill_id]
                if skill_equipment == nil then
                    skill_equipment = {
                        id = 0, -- ID 
                        user_id = _ED.user_info.user_id, -- 用户ID 
                        skill_equipment_mould = ""..instance.skill_id, -- 技能装备模板ID 
                        skill_equipment_base_mould = ""..instance.skill_id, -- 技能装备基础模板ID 
                        skill_level = 0, -- 技能等级  
                        equip_state = 0, -- 装备状态(1,已装备 0,未装备)  
                        favor_level = 0, -- 好感等级   
                        favor = 0,     -- 好感度 
                        master_type = 0,   -- 学艺类型
                        masters = "", -- 抽卡状态(1,2,3,…(只有-1表示为无))
                        master_favor_value = -1, -- 奖励值
                    }
                    _ED.user_skill_equipment[""..instance.skill_id] = skill_equipment
                end
                if instance.isSureGoldToBuye == false 
                    and tonumber(_ED.free_learn_skill_count) == 0 
                    and tonumber(_ED.user_skill_equipment[""..instance.skill_id].master_favor_value) == -1 then
                    app.load("client.utils.ConfirmTip")
                    local tip = ConfirmTip:new()
                    -- print("================",instance.nowneedmoney)
                    tip:init(instance,instance.sureToBuyLearingOne,string.format(_string_piece_info[388],instance.nowneedmoney),nil,nil)
                    fwin:open(tip,fwin._windows)
                    return
                end
                instance.isSureGoldToBuye = false
                if instance.nowneedmoney > tonumber(_ED.user_info.user_gold) 
                    and tonumber(_ED.free_learn_skill_count) == 0 
                    and tonumber(_ED.user_skill_equipment[""..instance.skill_id].master_favor_value) == -1 then
            -- 提示宝石不足,去充值
                        state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                        {
                            terminal_name = "shortcut_open_recharge_window", 
                            terminal_state = 0, 
                            _msg = _string_piece_info[273], 
                            _datas= 
                            {

                            }
                        })
                        
                        return
                end

                local favor_top = dms.int(dms["teacher_pupil_link_parm"],1,teacher_pupil_link_parm.total_experience)
                if tonumber(_ED.user_skill_equipment[""..instance.skill_id].favor_level) == 1 or
                    tonumber(_ED.user_skill_equipment[""..instance.skill_id].favor) >= favor_top then
                    TipDlg.drawTextDailog("技能已经习得")
                    return
                end
                if tonumber(_ED.user_skill_equipment[""..instance.skill_id].master_favor_value) ~= -1 then --有奖励未领取直接打开不请求
                    state_machine.excute("learing_skills_event_open",0,{instance.skill_id,instance.camp})
                else
                    protocol_command.study_event.param_list = instance.skill_id .. "\r\n" .. learing_type
                    NetworkManager:register(protocol_command.study_event.code, nil, nil, nil, instance, responseLearingCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

                --10偷师
        local learing_skills_favor_up_ten_terminal = {
            _name = "learing_skills_favor_up_ten",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local learing_type = params._datas.learing_type
                local function responseLearingCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil then
                            response.node:onUpdateData()

                            local textData = {}
                            local name = "熟练度增加"
                            table.insert(textData, {nameOne = name,nameTwo = _ED.user_skill_equipment[""..response.node.skill_id].cur_add_favor .."%"})
                            local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
                            tipInfo:init(10,"", textData)   
                            fwin:open(tipInfo, fwin._dialog)
                            if response.node.camp == 1 then
                                state_machine.excute("learing_skills_list_dragons_update",0,"")
                            elseif response.node.camp == 2 then
                                state_machine.excute("learing_skills_list_demons_update",0,"")
                            elseif response.node.camp == 3 then
                                state_machine.excute("learing_skills_list_lotus_update",0,"")
                            elseif response.node.camp == 4 then
                                state_machine.excute("learing_skills_list_heroes_update",0,"")
                            end
                            state_machine.excute("learing_skills_develop_update_skills_number",0,"")
                            state_machine.excute("learing_skills_list_equip_dragons_update",0,"")
                            state_machine.excute("learing_skills_list_equip_demons_update",0,"")
                            state_machine.excute("learing_skills_list_equip_lotus_update",0,"")
                            state_machine.excute("learing_skills_list_equip_heroes_update",0,"")
                            local favor_top = dms.int(dms["teacher_pupil_link_parm"],1,teacher_pupil_link_parm.total_experience)
                            if tonumber(_ED.user_skill_equipment[""..response.node.skill_id].favor_level) == 1 
                                or tonumber(_ED.user_skill_equipment[""..response.node.skill_id].favor) >= favor_top then
                                --print("学到技能了")
                                state_machine.excute("learing_skills_tip_open",0,response.node.skill_data)      
                            end
                        end
                    end
                end
                local skill_equipment = _ED.user_skill_equipment[""..instance.skill_id]
                if skill_equipment == nil then
                    skill_equipment = {
                        id = 0, -- ID 
                        user_id = _ED.user_info.user_id, -- 用户ID 
                        skill_equipment_mould = ""..instance.skill_id ,-- 技能装备模板ID 
                        skill_equipment_base_mould = ""..instance.skill_id ,-- 技能装备基础模板ID 
                        skill_level = 0, -- 技能等级  
                        equip_state = 0, -- 装备状态(1,已装备 0,未装备)  
                        favor_level = 0, -- 好感等级   
                        favor = 0,     -- 好感度 
                        master_type = 0,   -- 学艺类型
                        masters = "", -- 抽卡状态(1,2,3,…(只有-1表示为无))
                        master_favor_value = -1, -- 奖励值
                    }
                    _ED.user_skill_equipment[""..instance.skill_id] = skill_equipment
                end
                if instance.isSureGoldToBuye == false and tonumber(_ED.free_learn_skill_count) == 0 then
                    app.load("client.utils.ConfirmTip")
                    local tip = ConfirmTip:new()
                    -- print("=========2=======",instance.nowtenneedmoney)
                    tip:init(instance,instance.sureToBuyLearingTen,string.format(_string_piece_info[389],instance.nowtenneedmoney),nil,nil)
                    fwin:open(tip,fwin._windows)
                    return
                end
                instance.isSureGoldToBuye = false
                if instance.nowtenneedmoney > tonumber(_ED.user_info.user_gold) and tonumber(_ED.free_learn_skill_count) == 0 then
                -- 宝石不够，并且没有免费次数的时候
                        state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                        {
                            terminal_name = "shortcut_open_recharge_window", 
                            terminal_state = 0, 
                            _msg = _string_piece_info[273], 
                            _datas= 
                            {

                            }
                        }) 
                        return
                end
                local favor_top = dms.int(dms["teacher_pupil_link_parm"],1,teacher_pupil_link_parm.total_experience)
                if tonumber(_ED.user_skill_equipment[""..instance.skill_id].favor_level) == 1 or
                    tonumber(_ED.user_skill_equipment[""..instance.skill_id].favor) >= favor_top then
                    TipDlg.drawTextDailog("技能已经习得")
                    return
                end
                protocol_command.study_event_reward.param_list = instance.skill_id .. "\r\n" .. learing_type
                NetworkManager:register(protocol_command.study_event_reward.code, nil, nil, nil, instance, responseLearingCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        
        state_machine.add(learing_skills_favor_up_close_terminal)
        state_machine.add(learing_skills_favor_up_update_terminal)
        state_machine.add(learing_skills_favor_up_onece_terminal)
        state_machine.add(learing_skills_favor_up_ten_terminal)
        state_machine.init()
    end
    -- call func init hom state machine.
    init_learing_skills_favor_up_terminal()
end
function LearingSkillsFavorUp:sureToBuyLearingOne(surenumber)
    if surenumber == 0 then
        self.isSureGoldToBuye = true
        state_machine.excute("learing_skills_favor_up_onece",0,
            {
            _datas={
                    terminal_name = "learing_skills_favor_up_onece",     
                    terminal_state = 0, 
                    learing_type = 1,
                    isPressedActionEnabled = true
                }
            })
    end 
end
function LearingSkillsFavorUp:sureToBuyLearingTen(surenumber)
    if surenumber == 0 then
        self.isSureGoldToBuye = true
        state_machine.excute("learing_skills_favor_up_ten",0,
            {
            _datas={
                    terminal_name = "learing_skills_favor_up_ten",     
                    terminal_state = 0, 
                    learing_type = 1,
                    isPressedActionEnabled = true
                }
            })
    end  
end
function LearingSkillsFavorUp:onInit()
	local csbItem = csb.createNode("skills/skills_up_xx.csb")
	local root = csbItem:getChildByName("root")
	table.insert(self.roots,root)
    self:addChild(csbItem)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil, 
    {
        terminal_name = "learing_skills_favor_up_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --免费偷师
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_toushi"), nil, 
    {
        terminal_name = "learing_skills_favor_up_onece",     
        terminal_state = 0, 
        learing_type = 1,
        isPressedActionEnabled = true
    }, 
    nil, 0) 
    --一件偷师
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yijiantoushi"), nil, 
    {
        terminal_name = "learing_skills_favor_up_ten",     
        terminal_state = 0, 
        learing_type = 2,
        isPressedActionEnabled = true
    }, 
    nil, 0) 
    --偷师十次
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yijiantoushi_0"), nil, 
    {
        terminal_name = "learing_skills_favor_up_ten",     
        terminal_state = 0, 
        learing_type = 1,
        isPressedActionEnabled = true
    }, 
    nil, 0)  
    self:onUpdateDraw()
    self:onUpdateData()
end

function LearingSkillsFavorUp:onUpdateData()
    local root = self.roots[1]
    local Text_mianfei_cishu = ccui.Helper:seekWidgetByName(root,"Text_mianfei_cishu")
    local freetimes = tonumber(_ED.free_learn_skill_count)
    local Button_toushi = ccui.Helper:seekWidgetByName(root,"Button_toushi") --免费偷师
    local Button_yijiantoushi = ccui.Helper:seekWidgetByName(root,"Button_yijiantoushi") -- 一键偷师
    local Button_yijiantoushi_0 = ccui.Helper:seekWidgetByName(root,"Button_yijiantoushi_0") --偷师十次
    local Panel_baoshi_xx = ccui.Helper:seekWidgetByName(root,"Panel_baoshi_xx") --偷师耗费宝石
    local Panel_16_0 = ccui.Helper:seekWidgetByName(root,"Panel_16_0") -- 十次偷师耗费宝石
    local LoadingBar_qinmidu = ccui.Helper:seekWidgetByName(root,"LoadingBar_qinmidu") -- 进度条
    local favor_top = dms.int(dms["teacher_pupil_link_parm"],1,teacher_pupil_link_parm.total_experience)
    Panel_baoshi_xx:setVisible(false)
    Panel_16_0:setVisible(false)
    Button_yijiantoushi:setVisible(false)
    Button_yijiantoushi_0:setVisible(false)
    local favor = 0
    if _ED.user_skill_equipment[""..self.skill_id] ~= nil then
        favor = tonumber(_ED.user_skill_equipment[""..self.skill_id].favor)
    else
        favor = self.favor
    end
    local per = math.floor(favor/favor_top*100)
    if per > 100 then
        per = 100
    end
    LoadingBar_qinmidu:setPercent(per)

    local Text_jindu_text = ccui.Helper:seekWidgetByName(root,"Text_jindu_text")
    Text_jindu_text:setString(favor.."/"..favor_top)
    Text_mianfei_cishu:setString(freetimes)
    if freetimes > 0 then
        Button_yijiantoushi:setVisible(true)
    else
        Button_yijiantoushi_0:setVisible(true)
        Panel_baoshi_xx:setVisible(true)
        Panel_16_0:setVisible(true)
    end
    local config = zstring.split(dms.string(dms["pirates_config"],231,pirates_config.param),"|")
    local timestable = zstring.split(config[1],",")
    local moneytable = zstring.split(config[2],",")
    -- print("==========",config[1],config[2])
    -- print(" _ED.stone_learn_skill_count",_ED.stone_learn_skill_count) 
    local text_money = ccui.Helper:seekWidgetByName(root,"Text_zhuanshi") --
    local nowneedmoney = tonumber(moneytable[1])-- + tonumber(moneytable[2])*(tonumber(timestable[4]-tonumber(_ED.stone_learn_skill_count)))
    text_money:setString(nowneedmoney)
    self.nowneedmoney = nowneedmoney

    local text_money_ten = ccui.Helper:seekWidgetByName(root,"Text_zhuanshi_ten") --
    local nowtenneedmoney = tonumber(moneytable[2]) --*10
    text_money_ten:setString(nowtenneedmoney)
    self.nowtenneedmoney = nowtenneedmoney

    local text_money_ten_yuan = ccui.Helper:seekWidgetByName(root,"Text_zhuanshi_yuanjia") 
    local tenneedmoney = tonumber(moneytable[1])*10
    text_money_ten_yuan:setString(tenneedmoney..")")
end
function LearingSkillsFavorUp:onUpdateDraw()
    local root = self.roots[1]

    local ship_data = self.ship_data
    local skill_data = self.skill_data
    local state = self.state
    local favor_level = self.favor
    self.skill_id = dms.atoi(skill_data,skill_equipment_mould.id)
    self.camp = dms.atoi(ship_data,ship_mould.camp_preference)
    local name = dms.atos(ship_data,ship_mould.captain_name)
    local bust_index = dms.atoi(ship_data,ship_mould.bust_index)
    local quality = dms.atoi(ship_data, ship_mould.ship_type) + 1 --品质索引
    local user_pic_index = 0
    if tonumber(_ED.user_info.user_gender) == 1 then --男
        user_pic_index = 1501
    elseif tonumber(_ED.user_info.user_gender) == 2 then --女
        user_pic_index = 1511
    end
    local Panel_role_1 = ccui.Helper:seekWidgetByName(root,"Panel_role_1") -- 自己
    local Panel_role_2 = ccui.Helper:seekWidgetByName(root,"Panel_role_2") -- 师傅
    Panel_role_1:removeAllChildren(true)
    Panel_role_2:removeAllChildren(true)
    app.load("client.battle.fight.FightEnum")
    sp.spine_sprite(Panel_role_1, user_pic_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
    local hero = sp.spine_sprite(Panel_role_2, bust_index, spineAnimations[_enum_animation_frame_index.animation_standby + 1], true, nil, nil, cc.p(0.5, 0))
    hero:setScaleX(-1)
    local Text_role_name_1 = ccui.Helper:seekWidgetByName(root,"Text_role_name_1") -- 自己
    local Text_role_name_2 = ccui.Helper:seekWidgetByName(root,"Text_role_name_2") -- 师傅
    Text_role_name_1:setString(_ED.user_info.user_name)
    if ___is_open_leadname == true then
        Text_role_name_1:setFontName("")
        Text_role_name_1:setFontSize(Text_role_name_1:getFontSize())
    end
    Text_role_name_2:setString(name)
    Text_role_name_2:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
    local user_color_type = 3
    for i , v in pairs(_ED.user_ship) do 
        if tonumber(v.captain_type) == 0 then
            user_color_type = tonumber(v.ship_type) + 1
        end
    end
    Text_role_name_1:setColor(cc.c3b(color_Type[user_color_type][1],color_Type[user_color_type][2],color_Type[user_color_type][3]))
	state_machine.unlock("learing_skills_favor_open")
end
function LearingSkillsFavorUp:init(data)
    self.ship_data = data.ship_data
    self.skill_data = data.skill_data
    self.state = data.state
    self.favor = data.favor
    self.skill_request_id = data.skill_request_id
	self:onInit()
end
function LearingSkillsFavorUp:onEnterTransitionFinish()

end

function LearingSkillsFavorUp:onExit()
    state_machine.remove("learing_skills_favor_up_close")
    state_machine.remove("learing_skills_favor_up_onece")
    state_machine.remove("learing_skills_favor_up_ten")
    state_machine.remove("learing_skills_favor_up_update")
end