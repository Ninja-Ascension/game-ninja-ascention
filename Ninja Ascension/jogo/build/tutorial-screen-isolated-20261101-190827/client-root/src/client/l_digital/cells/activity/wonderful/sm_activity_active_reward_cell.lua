--------------------------------------------------------------------------------------------------------------
SmActivityActiveRewardCell = class("SmActivityActiveRewardCellClass", Window)
SmActivityActiveRewardCell.__size = nil

local sm_activity_active_reward_cell_create_terminal = {
    _name = "sm_activity_active_reward_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivityActiveRewardCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_active_reward_cell_create_terminal)
state_machine.init()

function SmActivityActiveRewardCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._index = 0
    self._state = 0

    local function init_sm_activity_active_reward_cell_terminal()
        local sm_activity_active_reward_cell_check_terminal = {
            _name = "sm_activity_active_reward_cell_check",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cells = params._datas.cells
                if cells._state == 1 then
                    state_machine.excute("sm_activity_active_reward_window_open", 0, {cells._index, cells._state})
                    return
                else
                    local needActive = dms.int(dms["active_reward"], cells._index, active_reward.need_active)
                    if _ED.daily_task_integral < needActive then
                        state_machine.excute("sm_activity_active_reward_window_open", 0, {cells._index, cells._state})
                        return
                    end
                end

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(42)
                        fwin:open(getRewardWnd, fwin._ui)
                        state_machine.excute("sm_activity_active_window_update_reward_info", 0, nil)
                    end
                end
                protocol_command.draw_liveness_reward.param_list = ""..(cells._index - 1)
                NetworkManager:register(protocol_command.draw_liveness_reward.code, nil, nil, nil, cells, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_activity_active_reward_cell_check_terminal)
        state_machine.init()
    end
    init_sm_activity_active_reward_cell_terminal()
end

function SmActivityActiveRewardCell:updateDraw()
    local root = self.roots[1]
    local Panel_pve_reward_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box")
    local Panel_pve_reward_box_rec = ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box_rec")
    Panel_pve_reward_box_rec:setVisible(false)
    ccui.Helper:seekWidgetByName(root, "Text_pve_reward_star"):setString("")
    ccui.Helper:seekWidgetByName(root, "ImageView_pve_reward_star"):setVisible(false)
    if self._state == 1 then
        Panel_pve_reward_box:setBackGroundImage("images/ui/reward/gq_pic_bx3open.png")
    else
        local needActive = dms.int(dms["active_reward"], self._index, active_reward.need_active)
        if _ED.daily_task_integral >= needActive then
            Panel_pve_reward_box_rec:setVisible(true)
            Panel_pve_reward_box:setBackGroundImage("images/ui/reward/gq_pic_bx3.png")
        else
            Panel_pve_reward_box:setBackGroundImage("images/ui/reward/gq_pic_bx3.png")
        end
    end
end

function SmActivityActiveRewardCell:onInit()
    local root = cacher.createUIRef("duplicate/pve_reward_sm.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmActivityActiveRewardCell.__size == nil then
        SmActivityActiveRewardCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box"), nil, 
    {
        terminal_name = "sm_activity_active_reward_cell_check", 
        terminal_state = 0, 
        touch_black = true,
		cells = self,
    }, nil, 1)

	self:updateDraw()
end

function SmActivityActiveRewardCell:onEnterTransitionFinish()
end

function SmActivityActiveRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_pve_reward_box = ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box")
    local Panel_pve_reward_box_rec = ccui.Helper:seekWidgetByName(root, "Panel_pve_reward_box_rec")
    local Text_pve_reward_star = ccui.Helper:seekWidgetByName(root, "Text_pve_reward_star")
    local ImageView_pve_reward_star = ccui.Helper:seekWidgetByName(root, "ImageView_pve_reward_star")
    if Panel_pve_reward_box ~= nil then
        Panel_pve_reward_box:removeBackGroundImage()
    end
    if Panel_pve_reward_box_rec ~= nil then
        Panel_pve_reward_box_rec:setVisible(false)
    end
    if Text_pve_reward_star ~= nil then
        Text_pve_reward_star:setString("")
    end
    if ImageView_pve_reward_star ~= nil then
        ImageView_pve_reward_star:setVisible(true)
    end
end

function SmActivityActiveRewardCell:init(params)
    self._index = params[1]
    self._state = params[2]

	self:onInit()
    self:setContentSize(SmActivityActiveRewardCell.__size)
    return self
end

function SmActivityActiveRewardCell:onExit()
    self:clearUIInfo()
    cacher.freeRef("duplicate/pve_reward_sm.csb", self.roots[1])
end