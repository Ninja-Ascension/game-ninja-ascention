----------------------------------------------------------------------------------------------------
-- 说明：成就新版列表控件
--yanghan 
----------------------------------------------------------------------------------------------------
AchievementListCellNew = class("AchievementListCellNewClass", Window)
AchievementListCellNew.__size = nil
function AchievementListCellNew:ctor()
    self.super:ctor()
    self.roots = {}

    self.achieve_type = 0
	self.achieve_data = nil
    self.achieve_id = nil
    self.state = nil--0已领取 1 未达成 2 可领取
    self.persent = nil 
    self.maxper = nil


    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.equip.equip_icon_cell")

	local function init_achievement_ex_list_cell_terminal()
		local achievement_ex_list_cell_trace_terminal = {
            _name = "achievement_ex_list_cell_trace",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local traceFunctionId = params._datas.trace_function_id
                if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
                    if traceFunctionId == 9999 then
                        app.load("client.system.share.ShareCenter")
                        local invite_id = 0
                        for i=1,#dms["share_reward_mould"] do
                            local share_type = dms.int(dms["share_reward_mould"],i,share_reward_mould.share_type)
                            if share_type == 5 then
                                invite_id = dms.int(dms["share_reward_mould"],i,share_reward_mould.id)
                                break
                            end
                        end
                        state_machine.excute("shareCenter_to_getdata_and_open_share_dlg",0,{ _datas = { share_id = invite_id } })                   
                        return
                    end
                end
				local openFunctionId = dms.int(dms["function_param"], traceFunctionId, function_param.open_function)
                if dms.int(dms["fun_open_condition"], openFunctionId, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
					if dms.int(dms["function_param"], traceFunctionId, function_param.genre) ~= 27 then
						fwin:cleanViews({fwin._background, fwin._view, fwin._viewdialog})
					end
					state_machine.excute("shortcut_function_trace", 0, {trace_function_id = traceFunctionId, _datas = {}})
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], openFunctionId, fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local achievement_ex_list_cell_show_reward_info_terminal = {
            _name = "achievement_ex_list_cell_show_reward_info",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("shortcut_open_show_reward_item_info", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local achievement_ex_list_cell_draw_reward_terminal = {
            _name = "achievement_ex_list_cell_draw_reward",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                --控制按钮连点
                local btn = params._datas.terminal_button
                if btn then
                    btn:setTouchEnabled(false)
                    btn:runAction(cc.Sequence:create({cc.DelayTime:create(1), cc.CallFunc:create(function ( sender )
                        btn:setTouchEnabled(true)
                    end)})
                    )
                end
                if cell.state == 0 then
                    return 
                end
                local function responseDrawAchieveRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						app.load("client.reward.DrawRareReward")
						local getRewardWnd = DrawRareReward:new()
						getRewardWnd:init(24)
						fwin:open(getRewardWnd, fwin._ui)
                        if response.node ~= nil and response.node.roots ~= nil and response.node.onUpdateDraw ~= nil then
                            if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                                or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                then
                                    -- cell:runAction(cc.Sequence:create({cc.DelayTime:create(0.5), cc.CallFunc:create(function ( sender )
                                        -- response.node:onUpdateDraw()
                                        state_machine.unlock("achievement_ex_list_cell_draw_reward", 0, "")
                                        state_machine.excute("daily_task_achievement", 0, {refresh = true})
                                    -- end)}))
                            else
                                response.node:onUpdateDraw()
                                state_machine.unlock("achievement_ex_list_cell_draw_reward", 0, "")
                                if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
                                    then
                                    state_machine.excute("daily_task_achievement", 0, {refresh = true})
                                end   
                            end
                        end
                        -- print("=====================",response.node.achieve_type)
                        -- if response.node.achieve_type == 1 then
                        --     state_machine.excute("achieve_list_level_remove_one_item",0,response.node)
                        -- elseif response.node.achieve_type == 2 then
                        --     state_machine.excute("achieve_list_passduplicute_remove_one_item",0,response.node)
                        -- elseif response.node.achieve_type == 3 then
                        --     state_machine.excute("achieve_list_fightup_remove_one_item",0,response.node)
                        -- elseif response.node.achieve_type == 4 then     
                        --     state_machine.excute("achieve_list_fighttop_remove_one_item",0,response.node)
                        -- elseif response.node.achieve_type == 5 then
                        --     state_machine.excute("achieve_list_vip_remove_one_item",0,response.node)
                        -- elseif response.node.achieve_type == 6 then
                        --     state_machine.excute("achieve_list_equip_remove_one_item",0,response.node)
                        -- elseif response.node.achieve_type == 7 then  
                        --     state_machine.excute("achieve_list_treasure_remove_one_item",0,response.node)
                        -- elseif response.node.achieve_type == 8 then
                        --     state_machine.excute("achieve_list_formation_remove_one_item",0,response.node)
                        -- elseif response.node.achieve_type == 9 then
                        --     state_machine.excute("achieve_list_trialtower_remove_one_item",0,response.node)
                        -- elseif response.node.achieve_type == 10 then  
                        --     state_machine.excute("achieve_list_skill_remove_one_item",0,response.node)
                        -- elseif response.node.achieve_type == 11 then
                        --     state_machine.excute("achieve_list_mine_remove_one_item",0,response.node)
                        -- elseif response.node.achieve_type == 12 then
                        --     state_machine.excute("achieve_list_worldboss_remove_one_item",0,response.node)
                        -- elseif response.node.achieve_type == 13 then  
                        --     state_machine.excute("achieve_list_stars_remove_one_item",0,response.node)
                        -- elseif response.node.achieve_type == 14 then
                        --     state_machine.excute("achieve_list_awaken_remove_one_item",0,response.node)
                        -- elseif response.node.achieve_type == 15 then
                        --     state_machine.excute("achieve_list_ability_remove_one_item",0,response.node)
                        -- end         
                    else
                        state_machine.unlock("achievement_ex_list_cell_draw_reward", 0, "")    
                    end
                end
                -- print("==================",cell.achieve_id)
                state_machine.lock("achievement_ex_list_cell_draw_reward", 0, "")
                protocol_command.draw_achieve_reward.param_list = ""..cell.achieve_id
                NetworkManager:register(protocol_command.draw_achieve_reward.code, nil, nil, nil, cell, responseDrawAchieveRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(achievement_ex_list_cell_trace_terminal)
        state_machine.add(achievement_ex_list_cell_show_reward_info_terminal)
		state_machine.add(achievement_ex_list_cell_draw_reward_terminal)
        state_machine.init()
	end
	init_achievement_ex_list_cell_terminal()
end

function AchievementListCellNew:addIcon()

    app.load("client.cells.prop.prop_icon_new_cell")
    app.load("client.cells.prop.prop_money_icon")  
    local root = self.roots[1]
    local Panel_richang_icon = ccui.Helper:seekWidgetByName(root, "Panel_richang_icon")
    if Panel_richang_icon ~= nil then
        Panel_richang_icon:removeAllChildren(true)
    end
    local dailyTaskTrace = dms.atoi(self.achieve_data, achieve.track_address)

    local rewardParams = zstring.splits(dms.atos(self.achieve_data, achieve.reward_value), "|", ",")
    local rewardParam = nil
    if rewardParams[2] ~= nil then
        rewardParam = rewardParams[2] -- zstring.split(rewardParam[2], ",")
    else
        rewardParam = rewardParams[1] -- zstring.split(rewardParam[1], ",")
    end
    
    local newType = zstring.tonumber(rewardParam[1])

    local rewardIcon = dms.atoi(self.achieve_data, achieve.pic)

    if Panel_richang_icon ~= nil then
        Panel_richang_icon:removeBackGroundImage()
        Panel_richang_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", rewardIcon))
    end
    -- if newType == 6 then
    --     local cell = PropIconNewCell:createCell()
    --     cell:init(15,rewardParam[2])
    --     Panel_richang_icon:addChild(cell)   
    -- else
    --     local cell = propMoneyIcon:createCell()
    --     cell:init(""..newType)
    --     Panel_richang_icon:addChild(cell)
    -- end

    -- 绘制奖励信息
    local Panel_props_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_1")
    if nil ~= Panel_props_icon_1 then
        -- Panel_richang_icon 任务大图标
        -- Panel_props_icon_1 绘制奖励1图标 图标ID策划给出
        -- Text_reward_number_1 奖励1数量 
        -- Panel_props_icon_2 绘制奖励2图标  图标ID策划给出
        -- Text_reward_number_2 奖励2数量
        -- Image_zhandui_exp  战队经验ICON，默认不可见
        -- Text_reward_number_3 奖励战队经验数量

        local Text_reward_number_1 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_1")
        local Panel_props_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_2")
        local Text_reward_number_2 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_2")
        local Image_zhandui_exp = ccui.Helper:seekWidgetByName(root, "Image_zhandui_exp")
        local Text_reward_number_3 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_3")

        local Text_reward_number_4= ccui.Helper:seekWidgetByName(root, "Text_reward_number_4")
        local Panel_props_icon_4 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_4")
        -- DSC重塑
        local Text_reward_number_5 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_5")
        local Panel_props_icon_5 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_5")
        if __lua_project_id == __lua_project_l_digital then 
            for i=1,5 do
                local Panel_richang_di = ccui.Helper:seekWidgetByName(root, "Panel_richang_di_"..i)
                if Panel_richang_di then 
                    Panel_richang_di:setVisible(false)
                end
            end
        end

        Panel_props_icon_1:setVisible(false)
        Text_reward_number_1:setVisible(false)
        Panel_props_icon_2:setVisible(false)
        Text_reward_number_2:setVisible(false)
        if Image_zhandui_exp ~= nil then
            Image_zhandui_exp:setVisible(false)
        end
        Text_reward_number_3:setVisible(false)

        Panel_props_icon_1:removeAllChildren(true)
        Panel_props_icon_1:removeBackGroundImage()

        Panel_props_icon_2:removeAllChildren(true)
        Panel_props_icon_2:removeBackGroundImage()

        if Text_reward_number_4 ~= nil then
            Text_reward_number_4:setVisible(false)
        end
        
        if Panel_props_icon_4 ~= nil then
            Panel_props_icon_4:removeAllChildren(true)
            Panel_props_icon_4:removeBackGroundImage()
        end

        local prop_icon_type = 23 
        if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
           prop_icon_type = 9 
        end
        if nil ~= rewardParams[1] then
            local pType = tonumber(rewardParams[1])
            if pType == 8 then
                if Image_zhandui_exp ~= nil then
                    Image_zhandui_exp:setVisible(true)
                end
                Text_reward_number_3:setString("x" .. rewardParams[1][3])
            else
                -- DSC重塑
                local Panel_richang_di_1 = ccui.Helper:seekWidgetByName(root, "Panel_richang_di_1")
                if __lua_project_id == __lua_project_l_digital and  Panel_richang_di_1 then 
                    Panel_richang_di_1:setVisible(true)
                end
                Panel_props_icon_1:setVisible(true)
                local info = rewardParams[1]
                if info[1] == "1" then
                    local cell1 = ResourcesIconCell:createCell()
                    cell1:init(1, tonumber(info[3]), -1)
                    cell1:hideCount(false)
                    Panel_props_icon_1:addChild(cell1)
                elseif info[1] == "2" then
                    local cell2 = ResourcesIconCell:createCell()
                    cell2:init(2, tonumber(info[3]), -1)
                    cell2:hideCount(false)
                    Panel_props_icon_1:addChild(cell2)
                elseif info[1] == "6" or info[1] == "5" then
                    local cell = PropIconCell:createCell()
                    local reawrdID = tonumber(info[2])
                    local rewardNum = tonumber(info[3])
                    cell:hideNameAndCount()
                    cell:init(prop_icon_type, {user_prop_template = reawrdID, prop_number = 0}, nil, false)
                    Panel_props_icon_1:addChild(cell)
                elseif info[1] == "7" then
                    local reawrdID = tonumber(info[2])
                    local rewardNum = tonumber(info[3])
                    
                    local tmpTable = {
                        user_equiment_template = reawrdID,
                        mould_id = reawrdID,
                        user_equiment_grade = 1
                    }
                    
                    local cell = EquipIconCell:createCell()
                    cell:init(10, tmpTable, reawrdID, nil, false)
                    Panel_props_icon_1:addChild(cell)
                end

                Text_reward_number_1:setVisible(true)
                Text_reward_number_1:setString("x" .. rewardParams[1][3])
            end
        end

        if nil ~= rewardParams[2] then
            local pType = tonumber(rewardParams[2][1])
            if pType == 8 then
                if Image_zhandui_exp ~= nil then
                    Image_zhandui_exp:setVisible(true)
                end
                Text_reward_number_3:setString("x" .. rewardParams[2][3])
            else
                -- DSC重塑
                local Panel_richang_di_2 = ccui.Helper:seekWidgetByName(root, "Panel_richang_di_2")
                if __lua_project_id == __lua_project_l_digital and  Panel_richang_di_2 then 
                    Panel_richang_di_2:setVisible(true)
                end
                Panel_props_icon_2:setVisible(true)
                local info = rewardParams[2]
                if info[1] == "1" then
                    local cell = ResourcesIconCell:createCell()
                    cell:init(1, tonumber(info[3]), -1)
                    cell:hideCount(false)
                    Panel_props_icon_2:addChild(cell)
                elseif info[1] == "2" then
                    local cell = ResourcesIconCell:createCell()
                    cell:init(2, tonumber(info[3]), -1)
                    cell:hideCount(false)
                    Panel_props_icon_2:addChild(cell)
                elseif info[1] == "6" or info[1] == "5" then
                    local cell = PropIconCell:createCell()
                    local reawrdID = tonumber(info[2])
                    local rewardNum = tonumber(info[3])
                    cell:hideNameAndCount()
                    cell:init(prop_icon_type, {user_prop_template = reawrdID, prop_number = 0}, nil, false)
                    Panel_props_icon_2:addChild(cell)
                elseif info[1] == "7" then
                    local reawrdID = tonumber(info[2])
                    local rewardNum = tonumber(info[3])
                    
                    local tmpTable = {
                        user_equiment_template = reawrdID,
                        mould_id = reawrdID,
                        user_equiment_grade = 1
                    }
                    
                    local cell = EquipIconCell:createCell()
                    cell:init(10, tmpTable, reawrdID, nil, false)
                    Panel_props_icon_2:addChild(cell)
                end

                Text_reward_number_2:setVisible(true)
                Text_reward_number_2:setString("x" .. rewardParams[2][3])
            end
        end

        if nil ~= rewardParams[3] then
            local pType = tonumber(rewardParams[3][1])
            if pType == 8 then
                if Image_zhandui_exp ~= nil then
                    Image_zhandui_exp:setVisible(true)
                end
                Text_reward_number_4:setString("x" .. rewardParams[3][3])
            else
                -- DSC重塑
                local Panel_richang_di_4 = ccui.Helper:seekWidgetByName(root, "Panel_richang_di_4")
                if __lua_project_id == __lua_project_l_digital and  Panel_richang_di_4 then 
                    Panel_richang_di_4:setVisible(true)
                end
                Panel_props_icon_4:setVisible(true)
                local info = rewardParams[3]
                if info[1] == "1" then
                    local cell = ResourcesIconCell:createCell()
                    cell:init(1, tonumber(info[3]), -1)
                    cell:hideCount(false)
                    Panel_props_icon_4:addChild(cell)
                elseif info[1] == "2" then
                    local cell = ResourcesIconCell:createCell()
                    cell:init(2, tonumber(info[3]), -1)
                    cell:hideCount(false)
                    Panel_props_icon_4:addChild(cell)
                elseif info[1] == "6" or info[1] == "5" then
                    local cell = PropIconCell:createCell()
                    local reawrdID = tonumber(info[2])
                    local rewardNum = tonumber(info[3])
                    cell:hideNameAndCount()
                    cell:init(prop_icon_type, {user_prop_template = reawrdID, prop_number = 0}, nil, false)
                    Panel_props_icon_4:addChild(cell)
                elseif info[1] == "7" then
                    local reawrdID = tonumber(info[2])
                    local rewardNum = tonumber(info[3])
                    
                    local tmpTable = {
                        user_equiment_template = reawrdID,
                        mould_id = reawrdID,
                        user_equiment_grade = 1
                    }
                    
                    local cell = EquipIconCell:createCell()
                    cell:init(10, tmpTable, reawrdID, nil, false)
                    Panel_props_icon_4:addChild(cell)
                end

                Text_reward_number_4:setVisible(true)
                Text_reward_number_4:setString("x" .. rewardParams[3][3])
            end
        end

        -- DSC重塑
        if __lua_project_id == __lua_project_l_digital and nil ~= rewardParams[4] and Text_reward_number_5 and Panel_props_icon_5 then
            local pType = tonumber(rewardParams[4][1])
            if pType == 8 then
                if Image_zhandui_exp ~= nil then
                    Image_zhandui_exp:setVisible(true)
                end
                Text_reward_number_5:setString("x" .. rewardParams[4][3])
            else
                -- DSC重塑
                local Panel_richang_di_5 = ccui.Helper:seekWidgetByName(root, "Panel_richang_di_5")
                if __lua_project_id == __lua_project_l_digital and  Panel_richang_di_5 then 
                    Panel_richang_di_5:setVisible(true)
                end
                Panel_props_icon_5:setVisible(true)
                local info = rewardParams[3]
                if info[1] == "1" then
                    local cell = ResourcesIconCell:createCell()
                    cell:init(1, tonumber(info[3]), -1)
                    cell:hideCount(false)
                    Panel_props_icon_5:addChild(cell)
                elseif info[1] == "2" then
                    local cell = ResourcesIconCell:createCell()
                    cell:init(2, tonumber(info[3]), -1)
                    cell:hideCount(false)
                    Panel_props_icon_5:addChild(cell)
                elseif info[1] == "6" or info[1] == "5" then
                    local cell = PropIconCell:createCell()
                    local reawrdID = tonumber(info[2])
                    local rewardNum = tonumber(info[3])
                    cell:hideNameAndCount()
                    cell:init(prop_icon_type, {user_prop_template = reawrdID, prop_number = 0}, nil, false)
                    Panel_props_icon_5:addChild(cell)
                elseif info[1] == "7" then
                    local reawrdID = tonumber(info[2])
                    local rewardNum = tonumber(info[3])
                    
                    local tmpTable = {
                        user_equiment_template = reawrdID,
                        mould_id = reawrdID,
                        user_equiment_grade = 1
                    }
                    
                    local cell = EquipIconCell:createCell()
                    cell:init(10, tmpTable, reawrdID, nil, false)
                    Panel_props_icon_5:addChild(cell)
                end

                Text_reward_number_5:setVisible(true)
                Text_reward_number_5:setString("x" .. rewardParams[3][3])
            end
        end
    end
end

function AchievementListCellNew:onUpdateDraw()

    local root = self.roots[1]
    local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1") --背景图
    local Text_rc_3 = ccui.Helper:seekWidgetByName(root, "Text_rc_3") --描述信息
    local Text_rc_1 = ccui.Helper:seekWidgetByName(root, "Text_rc_1") --描述信息2
    local drawButton = ccui.Helper:seekWidgetByName(root, "Button_1") --领取按钮
    local traceButton = ccui.Helper:seekWidgetByName(root, "Button_2") --前往按钮
    local Image_38 = ccui.Helper:seekWidgetByName(root, "Image_38") -- 已完成图片

    local rewardIcon = dms.atos(self.achieve_data, achieve.pic)
    local rewardParam = zstring.split(dms.atos(self.achieve_data, achieve.reward_value), "|")
    rewardParam = zstring.split(rewardParam[1], ",")
    local rewardType = zstring.split(rewardParam[1], "-")
    local rewardString = dms.atos(self.achieve_data, achieve.descript)
    local showComplete = dms.atoi(self.achieve_data, achieve.show_progress)

    if Panel_1 ~= nil then
        Panel_1:removeBackGroundImage()
        Panel_1:setBackGroundImage(string.format("images/ui/props/props_%d.png", rewardIcon))
    end
    Text_rc_3:setString(rewardString)
    Text_rc_1:setString(dms.atos(self.achieve_data, achieve.title))
    local Text_rc_5 = ccui.Helper:seekWidgetByName(root, "Text_rc_5") 
    local Text_rc_4 = ccui.Helper:seekWidgetByName(root, "Text_rc_4")
    if Text_rc_4 ~= nil then
        Text_rc_4:setVisible(true)
    end
    Text_rc_5:setVisible(true)
    Text_rc_5:setString("")
    if showComplete == 1 then
        local persent =  tonumber(_ED.all_achieve[self.achieve_id]) --当前
        local maxper = self.maxper-- 最高

        if persent > 10000 then
            persent = math.floor(persent/1000)..string_equiprety_name[40]
        -- elseif persent > 100000000 then
        --     persent = math.floor(persent/100000000)..string_equiprety_name[38]
        else
            persent = persent
        end

        if maxper > 10000 then
            maxper = math.floor(maxper/1000)..string_equiprety_name[40]
        -- elseif maxper > 100000000 then
        --     maxper = math.floor(maxper/100000000)..string_equiprety_name[38]
        else
            maxper = maxper
        end
        Text_rc_5:setString(persent .. "/" ..maxper)
    else
        if Text_rc_4 ~= nil then
            Text_rc_4:setVisible(false)
        end
    end
    drawButton:setVisible(false)
    traceButton:setVisible(false)
    Image_38:setVisible(false) 
    --0已领取 1 未达成 2 可领取
    
    if tonumber(_ED.all_achieve[self.achieve_id]) == -1 then
        self.state = 0
    end
    if self.state == 0 then
        Image_38:setVisible(true) 
        Text_rc_5:setVisible(false)  
        if Text_rc_4 ~= nil then
            Text_rc_4:setVisible(false) 
        end
    elseif self.state == 1 then
        traceButton:setVisible(true)        
    elseif self.state == 2 then
        drawButton:setVisible(true)
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
        then
        local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
        local Image_klq = ccui.Helper:seekWidgetByName(root, "Image_klq")
        local Panel_klq = ccui.Helper:seekWidgetByName(root, "Panel_klq")
        if __lua_project_id == __lua_project_l_naruto then
            Panel_klq:setVisible(false)
        else
            Panel_klq:removeAllChildren(true)
        end
        if self.state == 0 or self.state == 2 then
            Text_rc_5:setVisible(false)
            Image_1:setVisible(false)
            Image_klq:setVisible(true)

            if self.state == 2 then
                if __lua_project_id == __lua_project_l_naruto then
                    Panel_klq:setVisible(true)
                else
                    local jsonFile = "sprite/spirte_kelingqu.json"
                    local atlasFile = "sprite/spirte_kelingqu.atlas"
                    local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
                    Panel_klq:addChild(animation)
                end
            end
        else
            Image_1:setVisible(true)
            Image_klq:setVisible(false)
        end
    end
end

function AchievementListCellNew:onInit()
    local root= cacher.createUIRef("activity/DailyTasks/dailytasks_list.csb","root")
	self:addChild(root)
	table.insert(self.roots, root)
    local controllerPad = ccui.Helper:seekWidgetByName(root, "Panel_rcrw_list")

    self:setContentSize(controllerPad:getContentSize())
    if AchievementListCellNew.__size == nil then
        AchievementListCellNew.__size = controllerPad:getContentSize()
    end

    local dailyTaskTrace = dms.atoi(self.achieve_data, achieve.track_address)

    local rewardParam = zstring.split(dms.atos(self.achieve_data, achieve.reward_value), "|")
	if rewardParam[2] ~= nil then
		rewardParam = zstring.split(rewardParam[2], ",")
	else
		rewardParam = zstring.split(rewardParam[1], ",")
	end

    -- 查看奖励信息的事件响应
    local showInfoPanel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_3"),       nil, 
    {
        terminal_name = "achievement_ex_list_cell_show_reward_info",      
        terminal_state = 0, 
        cell = self,
        reward = {zstring.tonumber(rewardParam[1]), zstring.tonumber(rewardParam[2])}
    }, 
    nil, 0)

    -- 领取奖励的事件响应
    local Button_1 = ccui.Helper:seekWidgetByName(root, "Button_1")
    fwin:addTouchEventListener(Button_1,       nil, 
    {
        terminal_name = "achievement_ex_list_cell_draw_reward",      
        terminal_state = 0, 
        cell = self,
        terminal_button = Button_1,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 前往奖励的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"),       nil, 
    {
        terminal_name = "achievement_ex_list_cell_trace",      
        terminal_state = 0, 
        cell = self,
        trace_function_id = dailyTaskTrace,
        isPressedActionEnabled = true
    }, 
    nil, 0):setSwallowTouches(false)

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local Image_klq = ccui.Helper:seekWidgetByName(root, "Image_klq")
        Image_klq:setTouchEnabled(true)
        fwin:addTouchEventListener(Image_klq,       nil, 
        {
            terminal_name = "achievement_ex_list_cell_draw_reward",      
            terminal_state = 0, 
            cell = self,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end
    self:clearUIInfo()
    self:onUpdateDraw()
    self:addIcon()
end

function AchievementListCellNew:onEnterTransitionFinish()

end

function AchievementListCellNew:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_richang_icon = ccui.Helper:seekWidgetByName(root, "Panel_richang_icon")
    if Panel_richang_icon ~= nil then
        Panel_richang_icon:removeAllChildren(true)
    end
    local Panel_props_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_1")
    if Panel_props_icon_1 ~= nil then
        Panel_props_icon_1:removeAllChildren(true)
        Panel_props_icon_1:removeBackGroundImage()
    end
    local Text_reward_number_1 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_1")
    if Text_reward_number_1 ~= nil then
        Text_reward_number_1:setString("")
    end
    local Panel_props_icon_2 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_2")
    if Panel_props_icon_2 ~= nil then
        Panel_props_icon_2:removeAllChildren(true)
        Panel_props_icon_2:removeBackGroundImage()
    end
    local Text_reward_number_2 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_2")
    if Text_reward_number_2 ~= nil then
        Text_reward_number_2:setString("")
    end
    local Text_reward_number_3 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_3")
    if Text_reward_number_3 ~= nil then
        Text_reward_number_3:setString("")
    end

    if Panel_props_icon_4 ~= nil then
        Panel_props_icon_4:removeAllChildren(true)
        Panel_props_icon_4:removeBackGroundImage()
    end

    local Text_reward_number_4 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_4")
    if Text_reward_number_4 ~= nil then
        Text_reward_number_4:setString("")
    end

    -- DSC重塑
    local Panel_props_icon_5 = ccui.Helper:seekWidgetByName(root, "Panel_props_icon_5")
    if Panel_props_icon_5 ~= nil then
        Panel_props_icon_5:removeAllChildren(true)
        Panel_props_icon_5:removeBackGroundImage()
    end
    local Text_reward_number_5 = ccui.Helper:seekWidgetByName(root, "Text_reward_number_5")
    if Text_reward_number_5 ~= nil then
        Text_reward_number_5:setString("")
    end
    -- vip标签
    local Image_vip_tag = ccui.Helper:seekWidgetByName(root, "Image_vip_tag")
    if Image_vip_tag ~= nil then
        Image_vip_tag:setVisible(false)
    end

    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece
        then
        local Panel_klq = ccui.Helper:seekWidgetByName(root, "Panel_klq")
        if Panel_klq ~= nil then
            Panel_klq:removeAllChildren(true)
        end
    end
    -- self.achieve_type = 0
    -- self.achieve_data = nil
    -- self.achieve_id = nil
    -- self.state = nil
    -- self.persent = nil 
    -- self.maxper = nil
end

function AchievementListCellNew:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function AchievementListCellNew:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef("activity/DailyTasks/dailytasks_list.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end
function AchievementListCellNew:onExit()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef("activity/DailyTasks/dailytasks_list.csb", root)
end

function AchievementListCellNew:init(achieve_type,data,index)
    self.achieve_type= achieve_type
    self.achieve_data = data.achieve_data
    self.achieve_id = data.achieve_id
    self.state = data.state
    self.persent = data.persent
    self.maxper = data.maxper
    -- print("==============",self.achieve_id ,self.state)
    if index ~= nil and index <= 4 then
        self:onInit()       
    end
    
    self:setContentSize(AchievementListCellNew.__size)
    return self
end

function AchievementListCellNew:createCell()
	local cell = AchievementListCellNew:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

