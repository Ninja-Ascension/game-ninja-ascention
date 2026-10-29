-- ------------------------------------------------------------------------------------------------------------
--  说明：选择分配成员
-- ------------------------------------------------------------------------------------------------------------
LegionWelfareWindow = class("LegionWelfareWindowClass", Window)

--打开界面
local legion_welfare_window_window_open_terminal = {
    _name = "legion_welfare_window_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionWelfareWindowClass") == nil then
            local _win = LegionWelfareWindow:new()
            _win:init(params)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_welfare_window_window_close_terminal = {
    _name = "legion_welfare_window_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionWelfareWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_welfare_window_window_open_terminal)
state_machine.add(legion_welfare_window_window_close_terminal)
state_machine.init()

function LegionWelfareWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._choose_index = 0
    self._reward_info = nil

    self._Panel_num_input = nil
    self._Text_everybody_n = nil
    self._everybody_number = 1

    self._Text_selected_n = nil
    self._selected_number = 0
    self._is_select_all = false

    self._CheckBox_creeps = nil

    app.load("client.red_alert_time.cells.player.input_digital_window")
     -- Initialize alert_home state machine.
    local function init_legion_welfare_window_terminal()
        -- 刷新
        local legion_welfare_window_update_draw_terminal = {
            _name = "legion_welfare_window_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 设置数量
        local legion_welfare_window_select_number_terminal = {
            _name = "legion_welfare_window_select_number",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local reward_info = zstring.split(instance._reward_info, ",")
                state_machine.excute("legion_manage_close_input_digital", 0, "")
                local cell = InputDigitalWindow:createCell()
                cell:init(6, reward_info[3])
                instance._Panel_num_input:addChild(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭键盘
        local legion_welfare_window_close_input_digital_terminal = {
            _name = "legion_welfare_window_close_input_digital",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._Panel_num_input:removeAllChildren(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新设置数量
        local legion_welfare_window_update_condition_terminal = {
            _name = "legion_welfare_window_update_condition",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params[1] ~= nil then
                    instance._everybody_number = params[1]
                    instance._Text_everybody_n:setString(params[1])
                    instance:updateDrawCountInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_welfare_window_update_select_num_terminal = {
            _name = "legion_welfare_window_update_select_num",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._selected_number = instance._selected_number + params
                instance._Text_selected_n:setString(instance._selected_number)
                instance:updateDrawCountInfo()
                local items = instance.listview:getItems()
                local isAllChose = true
                for k, v in pairs(items) do
                    if v._is_selected == false then
                        isAllChose = false
                        break
                    end
                end
                if isAllChose ~= instance._is_select_all then
                    self._CheckBox_creeps:setSelected(isAllChose)
                end
                instance._is_select_all = isAllChose
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_welfare_window_select_all_terminal = {
            _name = "legion_welfare_window_select_all",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._is_select_all = not instance._is_select_all

                local items = instance.listview:getItems()
                for k, v in pairs(items) do
                    state_machine.excute("legion_welfare_window_cell_set_selected", 0, {v, instance._is_select_all})
                end
                if instance._is_select_all == true then
                    instance._selected_number = #items
                else
                    instance._selected_number = 0
                end
                instance._Text_selected_n:setString(instance._selected_number)
                instance:updateDrawCountInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local legion_welfare_window_distribution_reward_terminal = {
            _name = "legion_welfare_window_distribution_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("legion_welfare_reward_update_draw", 0, nil)
                        state_machine.excute("legion_welfare_window_window_close", 0, nil)
                        TipDlg.drawTextDailog(tipStringInfo_union_str[130])
                    end
                end
                if tonumber(instance._everybody_number) <= 0 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[129])
                    return
                end
                local str = ""
                local items = instance.listview:getItems()
                local index = 0
                local chooseCount = 0
                for k, v in pairs(items) do
                    if v._is_selected == true then
                        if index == 0 then
                            str = v._info.id
                        else
                            str = str..","..v._info.id
                        end
                        chooseCount = chooseCount + 1
                        index = index + 1
                    end
                end
                if chooseCount == 0 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[128])
                    return
                end
                protocol_command.union_welfare_distribute.param_list = (instance._choose_index - 1).."\r\n"..instance._everybody_number.."\r\n"..str
                NetworkManager:register(protocol_command.union_welfare_distribute.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_welfare_window_update_draw_terminal)
        state_machine.add(legion_welfare_window_select_number_terminal)
        state_machine.add(legion_welfare_window_close_input_digital_terminal)
        state_machine.add(legion_welfare_window_update_condition_terminal)
        state_machine.add(legion_welfare_window_update_select_num_terminal)
        state_machine.add(legion_welfare_window_select_all_terminal)
        state_machine.add(legion_welfare_window_distribution_reward_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_welfare_window_terminal()
end

function LegionWelfareWindow:updateDrawCountInfo( ... )
    local root = self.roots[1]
    local Text_consume_n = ccui.Helper:seekWidgetByName(root, "Text_consume_n")
    Text_consume_n:setString(self._selected_number * self._everybody_number)
end

-- 显示信息
function LegionWelfareWindow:onUpdateDraw()
    local root = self.roots[1]
    local reward_info = zstring.split(self._reward_info, ",")
    local prop_type = tonumber(reward_info[2])
    if tonumber(reward_info[2]) == 13 then --坦克
        prop_type = 3
    elseif tonumber(reward_info[2]) == 6 then --道具    
        prop_type = 1
    elseif tonumber(reward_info[2]) == 7 then --配件    
        prop_type = 7
    else
        prop_type = 1
    end
    -- icon
    local Panel_legion_welfare_icon = ccui.Helper:seekWidgetByName(root, "Panel_legion_welfare_icon")
    Panel_legion_welfare_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{4,3,tonumber(reward_info[1]),prop_type,tonumber(reward_info[3])})
    Panel_legion_welfare_icon:addChild(cell) 

    -- name
    local Text_legion_welfare_name = ccui.Helper:seekWidgetByName(root, "Text_legion_welfare_name")
    local prop_name = dms.string(dms["prop_mould"], reward_info[1], prop_mould.prop_name)
    Text_legion_welfare_name:setString(prop_name)

    -- 拥有数量
    local Text_have_n = ccui.Helper:seekWidgetByName(root,"Text_have_n")
    Text_have_n:setString(reward_info[3])

    local Panel_num_input = ccui.Helper:seekWidgetByName(root,"Panel_num_input")
    local Text_everybody_n = ccui.Helper:seekWidgetByName(root,"Text_everybody_n")
    Panel_num_input:removeAllChildren(true)
    Text_everybody_n:setString(self._everybody_number)

    self._Panel_num_input = Panel_num_input
    self._Text_everybody_n = Text_everybody_n

    -- 分配消耗
    local Text_consume_n = ccui.Helper:seekWidgetByName(root,"Text_consume_n")
    Text_consume_n:setString("0")

    -- 已勾选人数
    local Text_selected_n = ccui.Helper:seekWidgetByName(root,"Text_selected_n")
    self._CheckBox_creeps = ccui.Helper:seekWidgetByName(root,"CheckBox_creeps")
    Text_selected_n:setString(self._selected_number)
    self._CheckBox_creeps:setSelected(self._is_select_all)
    self._Text_selected_n = Text_selected_n

    local ListView_member = ccui.Helper:seekWidgetByName(root,"ListView_member")
    ListView_member:jumpToTop()
    ListView_member:removeAllItems()

    if tonumber(_ED.union.union_member_list_sum) == nil then
        return
    end
    local arry = _ED.union.union_member_list_info
    local function sortfunction( a,b )
        local result = false
        if tonumber(a.weak_activity_join_times) > tonumber(b.weak_activity_join_times)  then
            return true
        end 
        return result
    end
    table.sort( arry, sortfunction )
    for i=1,tonumber(_ED.union.union_member_list_sum) do
        local info = arry[i]
        if info ~= nil then
            local cell = state_machine.excute("legion_welfare_window_cell_create", 0, {info, i})
            ListView_member:addChild(cell)
        end
    end

    ListView_member:requestRefreshView()
    self.listview = ListView_member
    self.listview_poy = ListView_member:getInnerContainer():getPositionY()
    self.listview_height = ListView_member:getInnerContainer():getPositionY()
end


function LegionWelfareWindow:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_welfare_window_arrow_down:setVisible(true)
        else
            self._Image_welfare_window_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_welfare_window_arrow_up:setVisible(true)
        else
            self._Image_welfare_window_arrow_up:setVisible(false)
        end
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
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


--初始化界面
function LegionWelfareWindow:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_welfare_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_infor_close"), nil, 
    {
        terminal_name = "legion_welfare_window_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_welfare_window_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)   

    -- 分配
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_distribution"), nil, 
    {
        terminal_name = "legion_welfare_window_distribution_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)    

    -- 全选
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_creeps"), nil, 
    {
        terminal_name = "legion_welfare_window_select_all", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)    

    -- 设置数量
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_select_number"), nil, 
    {
        terminal_name = "legion_welfare_window_select_number", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    self._Image_welfare_window_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_welfare_window_arrow_down")
    self._Image_welfare_window_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_welfare_window_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_welfare_window_arrow_down:stopAllActions()
    self._Image_welfare_window_arrow_up:stopAllActions()
    playActions(self._Image_welfare_window_arrow_down)
    playActions(self._Image_welfare_window_arrow_up)
    self._Image_welfare_window_arrow_down:setVisible(false)
    self._Image_welfare_window_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

--初始化
function LegionWelfareWindow:init(params)
    self._choose_index = params[1]
    self._reward_info = params[2]
    self:onInit()
end

--移除状态机
function LegionWelfareWindow:onExit()
    state_machine.remove("legion_welfare_window_update_draw")
    state_machine.remove("legion_welfare_window_select_number")
    state_machine.remove("legion_welfare_window_close_input_digital")
    state_machine.remove("legion_welfare_window_update_condition")
    state_machine.remove("legion_welfare_window_update_select_num")
    state_machine.remove("legion_welfare_window_select_all")
end