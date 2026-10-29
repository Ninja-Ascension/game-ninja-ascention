----------------------------------------------------------------------------------------------------
-- 说明：七日活动每日福领取武将的奖励
-------------------------------------------------------------------------------------------------------
SevenDaysForDrawShip = class("SevenDaysForDrawShipClass", Window)
    
function SevenDaysForDrawShip:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.params = 0
    self.selectIndex = -1

    app.load("client.cells.ship.ship_head_cell")

    -- Initialize seven days activity for draw ship page state machine.
    local function init_seven_days_activity_for_draw_ship_terminal()
        -- 选择要领取的武将
        local seven_days_activity_for_draw_ship_select_ship_terminal = {
            _name = "seven_days_activity_for_draw_ship_select_ship",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.selectIndex = params._datas.selectIndex

                local but_bgImage = nil
                if terminal.page_name ~= nil then
                    but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                    if but_bgImage ~= nil then
                        but_bgImage:setVisible(false)
                    end
                end
                terminal.page_name = params._datas.but_image
                but_bgImage = ccui.Helper:seekWidgetByName(instance.roots[1], terminal.page_name)
                if but_bgImage ~= nil then
                    but_bgImage:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 领取武将
        local seven_days_activity_for_draw_ship_request_terminal = {
            _name = "seven_days_activity_for_draw_ship_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell.selectIndex < 0 then
                    TipDlg.drawTextDailog(_string_piece_info[304])
                    return
                end
                cell.params._datas.cell.command_param_list = cell.params._datas.cell.command_param_list .. cell.selectIndex
                state_machine.excute("every_day_welfare_list_cell_draw_reward_request", 0, cell.params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭窗口
        local seven_days_activity_for_draw_ship_close_terminal = {
            _name = "seven_days_activity_for_draw_ship_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(seven_days_activity_for_draw_ship_select_ship_terminal)
        state_machine.add(seven_days_activity_for_draw_ship_request_terminal)
        state_machine.add(seven_days_activity_for_draw_ship_close_terminal)
        state_machine.init()
    end
    
    -- call func init seven days activity for draw ship state machine.
    init_seven_days_activity_for_draw_ship_terminal()
end

function SevenDaysForDrawShip:onEnterTransitionFinish()
    local csbSevenDaysForDrawShip = csb.createNode("utils/select_award.csb")
    self:addChild(csbSevenDaysForDrawShip)

    local root = csbSevenDaysForDrawShip:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("utils/select_award.csb")
    table.insert(self.actions, action)
    csbSevenDaysForDrawShip:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("window_open", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then
            fwin:close(self)
        end
        
    end)

    -- 绘制武将信息
    for i = 1, 4 do
        local rewardPad = ccui.Helper:seekWidgetByName(root, "Panel_2"..(i - 1))
        local cell = ShipHeadCell:createCell()
        cell:init(nil, cell.enum_type._DUPLICATE, _seven_day_activity_reward_hero_ids[i], 0, true)
        rewardPad:addChild(cell)
    end

    for i = 1, 4 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_xy_0"..i),       nil, 
        {
            terminal_name = "seven_days_activity_for_draw_ship_select_ship",     
            but_image = "Image_"..(37 + i),
            terminal_state = 0, 
            cell = self,
            selectIndex = i - 1,
            isPressedActionEnabled = false
        }, 
        nil, 0)
    end

   -- 领取奖励的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_10"),       nil, 
    {
        terminal_name = "seven_days_activity_for_draw_ship_request",     
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 关闭窗口的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11"),       nil, 
    {
        terminal_name = "seven_days_activity_for_draw_ship_close",     
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function SevenDaysForDrawShip:onExit()
    state_machine.remove("seven_days_activity_for_draw_ship_select_ship")
    state_machine.remove("seven_days_activity_for_draw_ship_request")
    state_machine.remove("seven_days_activity_for_draw_ship_close")
end

function SevenDaysForDrawShip:init(params)
    self.params = params
    return self
end

function SevenDaysForDrawShip:createCell()
    local cell = SevenDaysForDrawShip:new()
    cell:registerOnNodeEvent(cell)
    return cell
end