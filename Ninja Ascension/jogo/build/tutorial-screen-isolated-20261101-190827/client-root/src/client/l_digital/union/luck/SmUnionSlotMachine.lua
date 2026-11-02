-- ----------------------------------------------------------------------------------------------------
-- 说明：公会老虎机
-------------------------------------------------------------------------------------------------------
SmUnionSlotMachine = class("SmUnionSlotMachineClass", Window)

local sm_union_slot_machine_open_terminal = {
    _name = "sm_union_slot_machine_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("union_lock_state_machine", 0, nil)
        local server_time = _ED.system_time + (os.time() - _ED.native_time) - _ED.GTM_Time
        if nil == _ED.union or nil == _ED.union.user_union_info or _ED.union.user_union_info.union_last_enter_time - server_time > 0 then
            TipDlg.drawTextDailog(_new_interface_text[195])
            state_machine.excute("union_unlock_state_machine", 0, nil)
            return
        end
		local _homeWindow = fwin:find("SmUnionSlotMachineClass")
        if nil == _homeWindow then
            local panel = SmUnionSlotMachine:new():init()
            fwin:open(panel,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_slot_machine_close_terminal = {
    _name = "sm_union_slot_machine_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("union_unlock_state_machine", 0, nil)
		local _homeWindow = fwin:find("SmUnionSlotMachineClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionSlotMachineClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_slot_machine_open_terminal)
state_machine.add(sm_union_slot_machine_close_terminal)
state_machine.init()
    
function SmUnionSlotMachine:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.start_up_page = 1

    self.isOver = true
    self._needNumber = 0

    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.prop.prop_money_icon")
    app.load("client.l_digital.union.luck.SmUnionSlotMachineRank")
    app.load("client.l_digital.union.luck.SmUnionSlotMachineRule")
    local function init_sm_union_slot_machine_terminal()
        -- 显示界面
        local sm_union_slot_machine_display_terminal = {
            _name = "sm_union_slot_machine_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionSlotMachineWindow = fwin:find("SmUnionSlotMachineClass")
                if SmUnionSlotMachineWindow ~= nil then
                    SmUnionSlotMachineWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_slot_machine_hide_terminal = {
            _name = "sm_union_slot_machine_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionSlotMachineWindow = fwin:find("SmUnionSlotMachineClass")
                if SmUnionSlotMachineWindow ~= nil then
                    SmUnionSlotMachineWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 转
        local sm_union_slot_machine_lottery_terminal = {
          _name = "sm_union_slot_machine_lottery",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                state_machine.lock("sm_union_slot_machine_lottery")
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node._needNumber = 0
                            response.node:startRound()
                            local machine_data = zstring.split(_ED.union_slot_machine_data ,",")
                            response.node.start_up_page = 1
                            for i,v in pairs(machine_data) do
                                if tonumber(v) ==6 then
                                    response.node.start_up_page = response.node.start_up_page + 1
                                end
                            end
                            -- instance:updateButton()
                            -- state_machine.excute("home_map_update_build", 0, nil)
                            -- state_machine.lock("sm_union_slot_machine_close")
                        end
                    else
                        state_machine.unlock("sm_union_slot_machine_lottery")   
                    end
                end     
                
                NetworkManager:register(protocol_command.union_ship_slot_machine_start_rotate.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

         -- 改变
        local sm_union_slot_machine_change_lottery_terminal = {
          _name = "sm_union_slot_machine_change_lottery",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                state_machine.lock("sm_union_slot_machine_change_lottery")
                state_machine.lock("sm_union_slot_machine_lottery")
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            local machine_data = zstring.split(_ED.union_slot_machine_data ,",")
                            if ccui.Helper:seekWidgetByName(instance.roots[1], "CheckBox_skip"):isSelected() == true then
                                for i=1,6 do
                                    instance:replaceSkeleton(i)
                                end
                                instance:onUpdateDrawInfo()
                                state_machine.unlock("sm_union_slot_machine_change_lottery")    
                            else
                                state_machine.lock("sm_union_slot_machine_lottery")
                                instance:startRound()
                            end
                            
                            self.start_up_page = 1
                            for i,v in pairs(machine_data) do
                                if tonumber(v) ==6 then
                                    self.start_up_page = self.start_up_page + 1
                                end
                            end
                            -- instance:updateButton()
                            -- state_machine.excute("home_map_update_build", 0, nil)
                            -- state_machine.lock("sm_union_slot_machine_close")
                        end
                    else
                        state_machine.unlock("sm_union_slot_machine_change_lottery")     
                        state_machine.unlock("sm_union_slot_machine_lottery")     
                    end
                end     
                
                NetworkManager:register(protocol_command.union_ship_slot_machine_change_result.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

          -- 领奖
        local sm_union_slot_machine_accept_the_prize_terminal = {
          _name = "sm_union_slot_machine_accept_the_prize",
          _init = function (terminal) 
              
      
          end,
          _inited = false,
          _instance = self,
          _state = 0,
          _invoke = function(terminal, instance, params) 
                
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            --25
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(25)
                            fwin:open(getRewardWnd, fwin._windows)
                            instance:onUpdateDraw()
                            state_machine.unlock("sm_union_slot_machine_lottery")   
                        end
                    end
                end     
                
                NetworkManager:register(protocol_command.union_ship_slot_machine_draw_reward.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
         }

         -- 进入排行
        local sm_union_slot_machine_open_rank_window_terminal = {
            _name = "sm_union_slot_machine_open_rank_window",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("sm_union_slot_machine_rank_open", 0, "")
                        end
                    end
                end     
                NetworkManager:register(protocol_command.union_ship_slot_machine_get_rank.code, nil, nil, nil, instance, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(sm_union_slot_machine_display_terminal)
        state_machine.add(sm_union_slot_machine_hide_terminal)
        state_machine.add(sm_union_slot_machine_lottery_terminal)
        state_machine.add(sm_union_slot_machine_change_lottery_terminal)
        state_machine.add(sm_union_slot_machine_accept_the_prize_terminal)
        state_machine.add(sm_union_slot_machine_open_rank_window_terminal)

        state_machine.init()
    end
    init_sm_union_slot_machine_terminal()
end


function SmUnionSlotMachine:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local machine_data = zstring.split(_ED.union_slot_machine_data ,",")
    self.start_up_page = 1
    for i,v in pairs(machine_data) do
        if tonumber(v) ==6 then
            self.start_up_page = self.start_up_page + 1
        end
    end
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("images/ui/effice/effect_act_tank_draw/effect_act_tank_draw.ExportJson")
    self.ArmatureNodes = {}
    for i=1,6 do
        local panel = ccui.Helper:seekWidgetByName(root, "Panel_laba_"..i)
        panel:removeAllChildren(true)
        panel:removeBackGroundImage()
        local cell = ccs.Armature:create("effect_act_tank_draw")
        cell:getAnimation():playWithIndex(0)
        cell:setAnchorPoint(0.5,0.5)
        cell.index = i
        cell._number = 0
        cell._over = false
        table.insert(self.ArmatureNodes,cell)

        for k=1,6 do
            -- local All_icon = dms.string(dms["ship_mould"], activity_optimal_tank[k], ship_mould.All_icon)
            local All_icon = k-1
            if k == 2 then
                -- All_icon = dms.string(dms["ship_mould"], activity_optimal_one[i], ship_mould.All_icon)
                if tonumber(machine_data[i]) == 0 then
                    All_icon = k-1
                else
                    All_icon = tonumber(machine_data[i])-1
                end
            end
            local icon_name = nil
            if tonumber(machine_data[i]) == 6 then
                icon_name = string.format("images/ui/text/NIUDAN_res/ndj_%d.png", All_icon)
            else
                icon_name = string.format("images/ui/text/NIUDAN_res/ndj_%d.png", math.random(0, 4))
            end
            local icon = ccs.Skin:create(icon_name)
            cell:getBone("Layer_tank_"..k):addDisplay(icon, 0)
        end
        -- cell:setPosition(cc.p(panel:getContentSize().width/2,150))
        cell:setTag(100)
        panel:addChild(cell)
    end
    local function resetOver_changeActionCallback(armatureBack)
        local armature = armatureBack
        if armature ~= nil then
            local actionIndex = armature._actionIndex
            if actionIndex == 0 then
                -- armature._nextAction = 1
                if tonumber(armature.index) == 6 and armature._over ~= false then
                    -- self.isOver = true
                    self.isOver = true
                    self.isCanSpeedUp = true
                    armature._over = false
                    -- checkPlayEffect(67)
                    -- state_machine.excute("red_alert_time_congratulations_get_window_open", 0, self._activity_type.activity_type)
                    -- self:updateButton()
                    -- state_machine.unlock("sm_union_slot_machine_close")
                    
                end
                if armature._over ~= false then
                    armature._over = false
                    -- checkPlayEffect(67)
                end
            elseif actionIndex == 1 then
                local function stopRoundFuncN(sender)
                    armature._nextAction = 2
                end
                self.ArmatureNodes[tonumber(armature.index)]:runAction(cc.Sequence:create(
                cc.DelayTime:create((tonumber(armature.index)-1)*0.05),
                cc.CallFunc:create(stopRoundFuncN)))
            elseif actionIndex == 2 then
                armature._number = 0
                -- armature._nextAction = 0

                if tonumber(armature.index) == 6 and armature._over ~= false then
                    self.isOver = true
                    self:onUpdateDrawInfo()
                    -- 彩蛋事件添加
                    app.load("client.activity.easter_egg.EasterEggHandle")
                    EasterEggHandle.showRequstReward()
                    state_machine.unlock("sm_union_slot_machine_change_lottery")  
                    -- state_machine.unlock("sm_union_slot_machine_lottery")
                end
                armature._over = true
                self.isCanSpeedUp = false
            end
        end
    end
    
    local function drawFrameEvent(bone,evt,originFrameIndex,currentFrameIndex)
        local armature = bone:getArmature()
        if evt == "change" then
            self:replaceSkeleton(armature.index)
        end
    end
        
    for i=self.start_up_page,6 do    
        -- self.ArmatureNodes[i]:getAnimation():playWithIndex(1)
        self.ArmatureNodes[i]:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
        self.ArmatureNodes[i]._actionIndex = 0
        self.ArmatureNodes[i]._nextAction = 0
        self.ArmatureNodes[i]._invoke = resetOver_changeActionCallback
        self.ArmatureNodes[i]:getAnimation():setFrameEventCallFunc(drawFrameEvent)
    end
    
    self:onUpdateDrawInfo()
end

-- 隐藏Panel_btn_1和Panel_btn_2
function SmUnionSlotMachine:hidePanelBtn()
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Panel_btn_1"):setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Panel_btn_2"):setVisible(false)
end

function SmUnionSlotMachine:onUpdateDrawInfo()
    local root = self.roots[1]
    local Text_wfcs = ccui.Helper:seekWidgetByName(root, "Text_wfcs")
    local science_info = zstring.split(_ED.union_science_info,"|")
    --当前等级，当前经验，今天获得的总经验，（第一个科技表示全部科技使用次数）已经使用的次数，改变次数|
    local hall_technology = zstring.split(science_info[2],",")
    --通过科技类型找到科技模板的库组
    local parameter_group = dms.int(dms["union_science_mould"], 2, union_science_mould.parameter_group)
    --通过参数库组找到对应de经验参数表数据
    local expMould = dms.searchs(dms["union_science_exp"], union_science_exp.group_id, parameter_group)
    local expData = nil
    for i, v in pairs(expMould) do
        if tonumber(hall_technology[1]) == tonumber(v[3]) then
            expData = v
            break
        end
    end
    local numberInfo = (tonumber(expData[5])- tonumber(hall_technology[4])).."/"..tonumber(expData[5])
    Text_wfcs:setString(numberInfo)
    if tonumber(expData[5]) - tonumber(hall_technology[4]) == 0 then
        Text_wfcs:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    else
        Text_wfcs:setColor(cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3]))
    end

    local Text_mfgycs = ccui.Helper:seekWidgetByName(root, "Text_mfgycs")
    --当前等级，当前经验，今天获得的总经验，（第一个科技表示全部科技使用次数）已经使用的次数，改变次数|
    local change_technology = zstring.split(science_info[3],",")
    --通过科技类型找到科技模板的库组
    local parameter_group = dms.int(dms["union_science_mould"], 3, union_science_mould.parameter_group)
    --通过参数库组找到对应de经验参数表数据
    local changeexpMould = dms.searchs(dms["union_science_exp"], union_science_exp.group_id, parameter_group)
    local changeexpData = nil
    for i, v in pairs(changeexpMould) do
        if tonumber(change_technology[1]) == tonumber(v[3]) then
            changeexpData = v
            break
        end
    end
    local changeNumberInfo = (tonumber(changeexpData[5]) - tonumber(change_technology[4]))
    Text_mfgycs:setString(changeNumberInfo)
    ccui.Helper:seekWidgetByName(root, "Text_mfgycs_n"):setString(changeNumberInfo.."/"..tonumber(changeexpData[5]))
    local param = zstring.split(dms.string(dms["union_config"], 31, union_config.param) ,",")
    if tonumber(change_technology[5]) > 0 then
        local godneedNumber = 0
        if tonumber(change_technology[5])+1 >= #param then
            godneedNumber = param[#param]
        else
            godneedNumber = param[tonumber(change_technology[5])+1]
        end
        ccui.Helper:seekWidgetByName(root, "Text_zsgyjg_n"):setString(godneedNumber)
    else
        ccui.Helper:seekWidgetByName(root, "Text_zsgyjg_n"):setString(param[1])    
    end

    local machine_data = zstring.split(_ED.union_slot_machine_data ,",")
    local isSended = false
    local needNumber = 0
    for i,v in pairs(machine_data) do
        if tonumber(v) ~= 0 then
            isSended = true
        end
        if tonumber(v) == 6 then
            needNumber = needNumber + 1
        end
    end
    if self.isOver == false then
        needNumber = self._needNumber
    end
    self._needNumber = needNumber

    local Button_mfgy = ccui.Helper:seekWidgetByName(root, "Button_mfgy")
    local Button_zsgy = ccui.Helper:seekWidgetByName(root, "Button_zsgy")
    local Button_jhjs = ccui.Helper:seekWidgetByName(root, "Button_jhjs")
    Button_jhjs:setTouchEnabled(true)

    if self.isOver == false then
        Button_mfgy:setBright(true)
        Button_mfgy:setTouchEnabled(false)
        Button_zsgy:setBright(true)
        Button_zsgy:setTouchEnabled(false)
        Button_jhjs:setTouchEnabled(false)
    elseif needNumber == 6 then
        Button_mfgy:setBright(false)
        Button_mfgy:setTouchEnabled(false)
        Button_zsgy:setBright(false)
        Button_zsgy:setTouchEnabled(false)
    else
        Button_mfgy:setBright(true)
        Button_mfgy:setTouchEnabled(true)
        Button_zsgy:setBright(true)
        Button_zsgy:setTouchEnabled(true)
    end
    if isSended == false or self.isOver == false then
        ccui.Helper:seekWidgetByName(root, "Panel_btn_1"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Panel_btn_2"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root, "Panel_btn_1"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Panel_btn_2"):setVisible(true)

        local reworldmID = 7 - needNumber
        local getReworld = zstring.split(dms.string(dms["union_extract_reward"], reworldmID, union_extract_reward.reworld) ,"|")
        for i = 1, 3 do
            local Panel_reward_icon = ccui.Helper:seekWidgetByName(root, "Panel_reward_icon_"..i)
            local Text_reward_n = ccui.Helper:seekWidgetByName(root, "Text_reward_n_"..i)
            Panel_reward_icon:removeAllChildren(true)
            Text_reward_n:setString("")
            if getReworld[i] ~= nil then
                local reworldData = zstring.split(getReworld[i],",")
                if tonumber(reworldData[1]) == 1 then
                    --钱
                    local cell = ResourcesIconCell:createCell()
                    cell:init(reworldData[1], 0,-1,nil,nil)
                    Panel_reward_icon:addChild(cell)
                end
                if tonumber(reworldData[1]) == 28 then
                    --工会币
                    local cell = ResourcesIconCell:createCell()
                    cell:init(reworldData[1], 0,-1)
                    Panel_reward_icon:addChild(cell)
                end
                if tonumber(reworldData[1]) == 6 then
                    --道具
                    local cell = ResourcesIconCell:createCell()
                    cell:init(reworldData[1], 0, reworldData[2],nil,nil)
                    Panel_reward_icon:addChild(cell)
                end
                Text_reward_n:setString("x"..reworldData[3])
            end
        end
    end

    if changeNumberInfo ~= 0 then
        ccui.Helper:seekWidgetByName(root, "Image_zs_icon"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Text_zsgyjg_n"):setVisible(false)
        ccui.Helper:seekWidgetByName(root, "Text_mfgycs_n"):setVisible(true)
        Button_mfgy:setVisible(true)
        Button_zsgy:setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root, "Image_zs_icon"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_zsgyjg_n"):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_mfgycs_n"):setVisible(false)
        Button_mfgy:setVisible(false)
        Button_zsgy:setVisible(true)
    end

end

function SmUnionSlotMachine:replaceSkeleton(index)
    -- debug.print_r(self._activity_type)
    local root = self.roots[1]
    -- local activity_info = zstring.split(self._activity_type.activity_add_state,"|")
    -- local activity_optimal_tank = zstring.split(activity_info[#activity_info],",")
    -- for i=1,3 do
        local panel = ccui.Helper:seekWidgetByName(root, "Panel_laba_"..index)
        local cell = panel:getChildByTag(100)
            -- local All_icon = dms.string(dms["ship_mould"], activity_optimal_tank[index], ship_mould.All_icon)
        local machine_data = zstring.split(_ED.union_slot_machine_data ,",")

        local icon_name = string.format("images/ui/text/NIUDAN_res/ndj_%d.png", tonumber(machine_data[index])-1)
        local icon = ccs.Skin:create(icon_name)
        cell:getBone("Layer_tank_2"):addDisplay(icon, 0)
    -- end
end

--开始转动
function SmUnionSlotMachine:startRound()
    self.isOver = false
    for i=self.start_up_page,6 do
        -- self.ArmatureNodes[i]:getAnimation():playWithIndex(0)
        csb.animationChangeToAction(self.ArmatureNodes[i], 0, 0, false)
        local function startRoundFuncN(sender)
            if self.isOver == false then
                self.ArmatureNodes[i]._over = false
                self.ArmatureNodes[i]._nextAction = 1
            end
        end
        self.ArmatureNodes[i]:runAction(cc.Sequence:create(
        -- cc.DelayTime:create((i-1)/2),
        cc.CallFunc:create(startRoundFuncN)))
    end 
    self:onUpdateDrawInfo()
    self:hidePanelBtn()
end

function SmUnionSlotMachine:init()
    self:onInit()
    return self
end

function SmUnionSlotMachine:onInit()
    local csbSmUnionSlotMachine = csb.createNode("legion/sm_legion_luck_draw.csb")
    local root = csbSmUnionSlotMachine:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionSlotMachine)
	
	-- self:onUpdateDraw()
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_union_slot_machine_close",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_pull"), nil, 
    {
        terminal_name = "sm_union_slot_machine_lottery",
        terminal_state = 0,
        touch_black = true,
    },
    nil,0)

    --改变
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_mfgy"), nil, 
    {
        terminal_name = "sm_union_slot_machine_change_lottery",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_zsgy"), nil, 
    {
        terminal_name = "sm_union_slot_machine_change_lottery",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)


    --见好就收
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_jhjs"), nil, 
    {
        terminal_name = "sm_union_slot_machine_accept_the_prize",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)

    --排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank"), nil, 
    {
        terminal_name = "sm_union_slot_machine_open_rank_window",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)
    
    --规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rule"), nil, 
    {
        terminal_name = "sm_union_slot_machine_rule_open",
        terminal_state = 0,
        touch_black = true,
        isPressedActionEnabled = true
    },
    nil,0)
    
    
    self:onUpdateDraw()
end

function SmUnionSlotMachine:onExit()
    state_machine.remove("sm_union_slot_machine_display")
    state_machine.remove("sm_union_slot_machine_hide")
end