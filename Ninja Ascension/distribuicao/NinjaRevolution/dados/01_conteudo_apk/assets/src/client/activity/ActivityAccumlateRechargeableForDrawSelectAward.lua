----------------------------------------------------------------------------------------------------
-- 说明：累计送礼选择奖励
-------------------------------------------------------------------------------------------------------
ActivityAccumlateRechargeableForDrawSelectAward = class("ActivityAccumlateRechargeableForDrawSelectAwardClass", Window)
    
function ActivityAccumlateRechargeableForDrawSelectAward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.params = 0
    self.selectIndex = -1

    app.load("client.cells.ship.ship_head_cell")

    -- Initialize seven days activity for draw ship page state machine.
    local function init_activity_accumlate_rechargeable_for_draw_select_award_terminal()
        -- -- 选择要领取的物品
        local activity_accumlate_rechargeable_for_draw_select_award_select_terminal = {
            _name = "activity_accumlate_rechargeable_for_draw_select_award_select",
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

        -- -- 领取物品
        local aactivity_accumlate_rechargeable_for_draw_select_award_request_terminal = {
            _name = "activity_accumlate_rechargeable_for_draw_select_award_request",
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
				local index = cell.params._datas._index
				local function responseGetServerListCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots[1] ~= nil then
							response.node:rewadDraw(index)              -- 刷新兑换列表界面
							-- app.load("client.reward.DrawRareReward")
							-- local getRewardWnd = DrawRareReward:new()
							-- getRewardWnd:init(7)
							-- fwin:open(getRewardWnd, fwin._ui)
							state_machine.excute("activity_accumlate_rechargeable_for_draw_select_award_close", 0, "")
						end	
                    end
                end
				if TipDlg.drawStorageTipo() == false then
					protocol_command.get_activity_reward.param_list = cell.params._datas._cell.command_param_list.."\r\n"..(cell.selectIndex+1).."\r\n1"
					NetworkManager:register(protocol_command.get_activity_reward.code, nil, nil, nil, cell.params._datas._cell, responseGetServerListCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- -- 关闭窗口
        local activity_accumlate_rechargeable_for_draw_select_award_close_terminal = {
            _name = "activity_accumlate_rechargeable_for_draw_select_award_close",
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

        state_machine.add(activity_accumlate_rechargeable_for_draw_select_award_select_terminal)
        state_machine.add(aactivity_accumlate_rechargeable_for_draw_select_award_request_terminal)
        state_machine.add(activity_accumlate_rechargeable_for_draw_select_award_close_terminal)
        state_machine.init()
    end
    
    -- call func init seven days activity for draw ship state machine.
    init_activity_accumlate_rechargeable_for_draw_select_award_terminal()
end


function ActivityAccumlateRechargeableForDrawSelectAward:onUpdateDraw()
	local root = self.roots[1]
	local count = self.params._datas._cell.selectConut
	for i = 1, count do    					--根据可选择数量显示选择框
        local rewardPad = ccui.Helper:seekWidgetByName(root, "Panel_1"..(i + 1))
        rewardPad:setVisible(true)
    end
	
	local info = self.params._datas._cell
	local shipinfomould = info.shipInfoMould

	for i = 1,count do
		local rewardPad = ccui.Helper:seekWidgetByName(root, "Panel_2"..(i - 1))
		local cell = ShipHeadCell:createCell()
		cell:init(nil, cell.enum_type._DUPLICATE, tonumber(shipinfomould[i]), 1, true)
		-- local cell = self:getShipCell(v)
		rewardPad:addChild(cell)
	end
end

function ActivityAccumlateRechargeableForDrawSelectAward:onEnterTransitionFinish()

    local csbActivityAccumlateRechargeableForDrawSelectAward = csb.createNode("utils/select_award.csb")
    self:addChild(csbActivityAccumlateRechargeableForDrawSelectAward)

    local root = csbActivityAccumlateRechargeableForDrawSelectAward:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("utils/select_award.csb")
    table.insert(self.actions, action)
    csbActivityAccumlateRechargeableForDrawSelectAward:runAction(action)
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
    for i = 1, 4 do          ---先隐藏4个选择位置
        local rewardPad = ccui.Helper:seekWidgetByName(root, "Panel_1"..(i + 1))
        rewardPad:setVisible(false)
    end
	
	
	self:onUpdateDraw()
    
	local count = self.params._datas._cell.selectConut
    for i = 1, count do          -- 根据物品数量添加响应
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_xy_0"..i),       nil, 
        {
            terminal_name = "activity_accumlate_rechargeable_for_draw_select_award_select",     
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
        terminal_name = "activity_accumlate_rechargeable_for_draw_select_award_request",     
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 关闭窗口的事件响应
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_11"),       nil, 
    {
        terminal_name = "activity_accumlate_rechargeable_for_draw_select_award_close",     
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function ActivityAccumlateRechargeableForDrawSelectAward:onExit()
    state_machine.remove("activity_accumlate_rechargeable_for_draw_select_award_select")
    state_machine.remove("activity_accumlate_rechargeable_for_draw_select_award_request")
    state_machine.remove("activity_accumlate_rechargeable_for_draw_select_award_close")
end

function ActivityAccumlateRechargeableForDrawSelectAward:init(params)
    self.params = params
    return self
end

function ActivityAccumlateRechargeableForDrawSelectAward:createCell()
    local cell = ActivityAccumlateRechargeableForDrawSelectAward:new()
    cell:registerOnNodeEvent(cell)
    return cell
end