-- ----------------------------------------------------------------------------------------------------
-- 说明：偷师学艺
-- 创建时间	2015-11-25
-- 作者：yanghan
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

LearingSkillsEvent = class("LearingSkillsEventClass", Window)

local learing_skills_event_open_terminal = {
    _name = "learing_skills_event_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.lock("learing_skills_event_open")
        local skill_id = params[1]
        local camp = params[2]
        local skill_data = params[3]
        local _LearingSkillsEvent = LearingSkillsEvent:new()
        _LearingSkillsEvent:init(skill_id,camp,skill_data)
        fwin:open(_LearingSkillsEvent,fwin._windows)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(learing_skills_event_open_terminal)
state_machine.init()
function LearingSkillsEvent:ctor()
    self.super:ctor()
	self.roots = {}
    self.skill_id = nil
    self.skill_data = nil
    self.camp = nil
    self.speed = 1
    self.isSureGoldToBuye = false
    self.canclose = true
    -- Initialize LearingSkillsFavorUp page state machine.
    local function init_learing_skills_event_terminal()
        --关闭界面
        local learing_skills_event_close_terminal = {
            _name = "learing_skills_event_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.canclose == false then
                    return
                end
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --万世师表
        local learing_skills_event_teacher_open_terminal = {
            _name = "learing_skills_event_teacher_open",
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
                            response.node:onUpdateDraw(true)
                        end
                    end
                end
                local pic_index = _ED.user_skill_equipment[instance.skill_id].master_type
                local config = zstring.split(dms.string(dms["pirates_config"],231,pirates_config.param),"|")
                if tonumber(pic_index) == 7 then
                    return
                end
                if instance.isSureGoldToBuye == false then
                    app.load("client.learingskills.LearingConfirmTip")
                    local tip = LearingConfirmTip:new()
                    tip:init(instance,instance.sureToBuy,pic_index)
                    fwin:open(tip,fwin._windows)
                    return
                end
                instance.isSureGoldToBuye = false

                if tonumber(config[4]) > tonumber(_ED.user_info.user_gold) then
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
                instance.isSureGoldToBuye = false
                state_machine.excute("learing_skills_event_hide_other",0,"")
                protocol_command.study_event.param_list = instance.skill_id .. "\r\n" .. learing_type
                NetworkManager:register(protocol_command.study_event.code, nil, nil, nil, instance, responseLearingCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }    
        --领取奖励
        local learing_skills_event_getreward_terminal = {
            _name = "learing_skills_event_getreward",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.canclose = false
                local function responseLearingCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil then
                            local textData = {}
                            local name = "熟练度增加"
                            table.insert(textData, {nameOne = name,nameTwo = _ED.user_skill_equipment[""..instance.skill_id].master_favor_value.."%" })
                            local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
                            tipInfo:init(10,"", textData)   
                            fwin:open(tipInfo, fwin._dialog)

                            local favor_top = dms.int(dms["teacher_pupil_link_parm"],1,teacher_pupil_link_parm.total_experience)

                            state_machine.excute("learing_skills_favor_up_update",0,"")
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

                            -- print("============",tonumber(_ED.user_skill_equipment[""..response.node.skill_id].favor_level),tonumber(_ED.user_skill_equipment[""..response.node.skill_id].favor),favor_top)
                            _ED.user_skill_equipment[""..response.node.skill_id].master_favor_value = "-1"
                            if tonumber(_ED.user_skill_equipment[""..response.node.skill_id].favor_level) == 1 
                                or tonumber(_ED.user_skill_equipment[""..response.node.skill_id].favor) >= favor_top then
                                -- print("学到技能了")
                                state_machine.excute("learing_skills_tip_open",0,response.node.skill_data)
                            end
                            -- fwin:close(response.node)
                            response.node:closeUI()
                        end
                    end
                end
                protocol_command.study_event_reward.param_list = instance.skill_id .. "\r\n" .. 0
                NetworkManager:register(protocol_command.study_event_reward.code, nil, nil, nil, instance, responseLearingCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
                --
        local learing_skills_event_change_speed_terminal = {
            _name = "learing_skills_event_change_speed",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.speed = 0.01
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local learing_skills_event_show_other_terminal = {
            _name = "learing_skills_event_show_other",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    local Panel_xx_yc = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xx_yc")
                    Panel_xx_yc:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        local learing_skills_event_hide_other_terminal = {
            _name = "learing_skills_event_hide_other",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    local Panel_xx_yc = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_xx_yc")
                    Panel_xx_yc:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }                 
        state_machine.add(learing_skills_event_close_terminal)
        state_machine.add(learing_skills_event_teacher_open_terminal)
        state_machine.add(learing_skills_event_getreward_terminal)
        state_machine.add(learing_skills_event_change_speed_terminal)
        state_machine.add(learing_skills_event_show_other_terminal)
        state_machine.add(learing_skills_event_hide_other_terminal)
        state_machine.init()
    end

    -- call func init hom state machine.
    init_learing_skills_event_terminal()
end
function LearingSkillsEvent:sureToBuy(surenumber)
    if surenumber == 0 then
        self.isSureGoldToBuye = true
        state_machine.excute("learing_skills_event_teacher_open",0,
            {
            _datas={
                    terminal_name = "learing_skills_event_teacher_open",     
                    terminal_state = 0, 
                    learing_type = 2,
                    isPressedActionEnabled = true
                }
            })
    end 
end
function LearingSkillsEvent:onInit()
	local csbItem = csb.createNode("skills/skills_xx_event.csb")
	local root = csbItem:getChildByName("root")
	table.insert(self.roots,root)
    self:addChild(csbItem)
    state_machine.excute("learing_skills_event_hide_other",0,"")
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_event_back"), nil, 
    {
        terminal_name = "learing_skills_event_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    --万世师表
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kaiqiwaishishibiao"), nil, 
    {
        terminal_name = "learing_skills_event_teacher_open",     
        terminal_state = 0, 
        learing_type = 2,
        isPressedActionEnabled = true
    }, 
    nil, 0) 
    --领取奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_28_0"), nil, 
    {
        terminal_name = "learing_skills_event_getreward",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0) 

        --事件预览
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_yulan"), nil, 
    {
        terminal_name = "learing_skills_see_event_open",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

        --加速播放
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_event"), nil, 
    {
        terminal_name = "learing_skills_event_change_speed",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)   
    state_machine.unlock("learing_skills_event_open") 
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_skills_2/effect_skills_2.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_kapai1/effect_kapai1.ExportJson")
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_kapai2/effect_kapai2.ExportJson")
    self:onUpdateData()
    self:onUpdateDraw()
    
end

function LearingSkillsEvent:onUpdateData()

    local root = self.roots[1]
    local data = _ED.user_skill_equipment[self.skill_id]
    -- debug.print_r(data)
    local card_names = zstring.split(data.masters,",")
    local Text_qinmizhi = ccui.Helper:seekWidgetByName(root,"Text_qinmizhi")
    Text_qinmizhi:setString("+"..data.master_favor_value.."%")
    local Panel_event_name = ccui.Helper:seekWidgetByName(root,"Panel_event_name")
    local Text_event_jiesuan = ccui.Helper:seekWidgetByName(root,"Text_event_jiesuan")
    Text_event_jiesuan:setString(_learn_skill_str[2][tonumber(data.master_type)])
    for i=1,5 do
        local text = ccui.Helper:seekWidgetByName(root,"Text_event_card_name_"..i)
        text:setString(_learn_skill_str[1][tonumber(card_names[i])])
    end
    local event_type = data.master_type
    Panel_event_name:removeBackGroundImage()
    Panel_event_name:setBackGroundImage(string.format("images/ui/skills_props/skills_event_%s.png",event_type))
end
function LearingSkillsEvent:closeUI()
    local root = self.roots[1]
    local Panel_toushi_yinchang = ccui.Helper:seekWidgetByName(root,"Panel_toushi_yinchang")
    Panel_toushi_yinchang:setVisible(false)
    local Panel_28 = ccui.Helper:seekWidgetByName(root,"Panel_28")
    local armature = Panel_28:getChildByName("ArmatureNode_xuexi_3")
    local function changeActionCallback(armatureBack)
        Panel_28:setVisible(false)
        fwin:close(self)
    end
    Panel_28:setVisible(true)
    draw.initArmature(armature, nil, -1, 0, 1)
    armature._invoke = changeActionCallback
    csb.animationChangeToAction(armature, 0, 0, false)
    
end

function LearingSkillsEvent:onUpdateDraw(_type)
    local root = self.roots[1]
    if _type == true then
        self.speed = 0.01
    end
    local data = _ED.user_skill_equipment[self.skill_id]
    local card_names = zstring.split(data.masters,",")
    local green = {}
    local orange = {}
    local temp1 = nil
    local temp2 = nil

    for i,v in pairs(card_names) do
        local inser1 = false
        local inser2 = false
        for k,j in pairs(card_names) do
            if k ~= i and v == j then
                if temp1 == nil or temp1 == v then
                    inser1 = true
                    temp1 = v
                elseif temp2 == nil or temp2 == v then       
                    inser2 = true
                    temp2 = v
                else
                    inser1 = false
                    inser2 = false
                end
            end
        end
        if inser1 == true then
            -- table.insert(green,v)
            table.insert(green,i)
        end
        if inser2 == true then
            -- table.insert(orange,v)
            table.insert(orange,i)
        end
    end
    -- debug.print_r(card_names)
    -- debug.print_r(green)
    -- debug.print_r(orange)

    local path = "images/ui/skills_props/shijian_card_z_%s.png"
    
    local animationIndex = 1
    if false then
        --预留
        -- local function playAnimations()
        --     if animationIndex == 6 then
        --         for i,v in pairs(green) do
        --             local  panel = ccui.Helper:seekWidgetByName(root,"Panel_event_light_"..v)
        --             panel:removeAllChildren(true)
        --             local armature = ccs.Armature:create("effect_kapai1")
        --             csb.animationChangeToAction(armature, 0, 0, false)
        --             draw.initArmature(armature, nil, -1, 0, 1)
        --             panel:addChild(armature)
        --         end
        --         for i,v in pairs(orange) do
        --             local  panel = ccui.Helper:seekWidgetByName(root,"Panel_event_light_"..v)
        --             panel:removeAllChildren(true)
        --             local armature = ccs.Armature:create("effect_kapai2")
        --             csb.animationChangeToAction(armature, 0, 0, false)
        --             draw.initArmature(armature, nil, -1, 0, 1)
        --             panel:addChild(armature)
        --         end
        --     end
        --     if self.roots ~= nil and animationIndex <= 5 then
        --         local Panel_event_card = ccui.Helper:seekWidgetByName(root,"Panel_event_card_"..animationIndex)
        --         Panel_event_card:removeAllChildren(true)
        --         local armature = ccs.Armature:create("effect_skills_2")
        --         local skin_path = string.format(path,"0"..card_names[animationIndex]) 
        --         local event_bg = ccs.Skin:create(skin_path)
        --         armature:getBone("Layer1"):addDisplay(event_bg, 0)
                
        --         draw.initArmature(armature, nil, -1, 0, 1)
        --         local function changeActionCallback( armatureBack )
        --             local _self = armatureBack._self
        --             playAnimations()
        --         end
        --         armature._self = self
        --         armature._invoke = changeActionCallback
        --         armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        --         csb.animationChangeToAction(armature, 0, 0, false)
        --         Panel_event_card:addChild(armature)
        --     end
        --     animationIndex = animationIndex + 1
            
        -- end
        -- playAnimations()
    end
    state_machine.lock("learing_skills_event_close")
    state_machine.lock("learing_skills_event_teacher_open")
    state_machine.lock("learing_skills_event_getreward")
    for i=1,5 do
        local panel = ccui.Helper:seekWidgetByName(root,"Panel_event_light_"..i)
        local Panel_event_card = ccui.Helper:seekWidgetByName(root,"Panel_event_card_"..i)
        panel:removeAllChildren(true)
        Panel_event_card:removeAllChildren(true)
    end
    local function delatEnd( ... )
        local function playAnimations( ... )
            if animationIndex == 6 then
                for i,v in pairs(green) do
                    local  panel = ccui.Helper:seekWidgetByName(root,"Panel_event_light_"..v)
                    panel:removeAllChildren(true)
                    local armature = ccs.Armature:create("effect_kapai1")
                    csb.animationChangeToAction(armature, 0, 0, false)
                    draw.initArmature(armature, nil, -1, 0, 1)
                    panel:addChild(armature)
                end
                for i,v in pairs(orange) do
                    local  panel = ccui.Helper:seekWidgetByName(root,"Panel_event_light_"..v)
                    panel:removeAllChildren(true)
                    local armature = ccs.Armature:create("effect_kapai2")
                    csb.animationChangeToAction(armature, 0, 0, false)
                    draw.initArmature(armature, nil, -1, 0, 1)
                    panel:addChild(armature)
                end
                state_machine.excute("learing_skills_event_show_other",0,"")
                state_machine.unlock("learing_skills_event_close")
                state_machine.unlock("learing_skills_event_teacher_open")
                state_machine.unlock("learing_skills_event_getreward")
                self:stopAllActions()
            end
            if self.roots ~= nil and animationIndex <= 5 then
                local Panel_event_card = ccui.Helper:seekWidgetByName(root,"Panel_event_card_"..animationIndex)
                Panel_event_card:removeAllChildren(true)
                local armature = ccs.Armature:create("effect_skills_2")
                local skin_path = string.format(path,"0"..card_names[animationIndex]) 
                local event_bg = ccs.Skin:create(skin_path)
                armature:getBone("Layer1"):addDisplay(event_bg, 0)
                
                draw.initArmature(armature, nil, -1, 0, 1)
                local function changeActionCallback( armatureBack )
                    local _self = armatureBack._self
                    -- playAnimations()
                end
                armature._self = self
                armature._invoke = changeActionCallback
                armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
                csb.animationChangeToAction(armature, 0, 0, false)
                Panel_event_card:addChild(armature)
            end
            animationIndex = animationIndex + 1
        end
        playAnimations()
        if animationIndex > 6 then
            return
        end
        if animationIndex == 6 then
            self.speed = 1.5
        end
        self:runAction(cc.Sequence:create(cc.DelayTime:create(self.speed), cc.CallFunc:create(delatEnd)))
            --self:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(self.speed), cc.CallFunc:create(playAnimations))))
    end

    self:runAction(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(delatEnd)))
end

function LearingSkillsEvent:init(skill_id , camp , skill_data)
    self.skill_id = ""..skill_id
    self.camp = camp
    self.skill_data = skill_data
	self:onInit()
end
function LearingSkillsEvent:onEnterTransitionFinish()

end

function LearingSkillsEvent:onExit()
    state_machine.remove("learing_skills_event_close")
    state_machine.remove("learing_skills_event_teacher_open")
    state_machine.remove("learing_skills_event_getreward")
    state_machine.remove("learing_skills_event_change_speed")
    state_machine.remove("learing_skills_event_show_other")
    state_machine.remove("learing_skills_event_hide_other")    
end