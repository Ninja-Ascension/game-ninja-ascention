
SmOtherRecruitList = class("SmOtherRecruitListClass", Window)

local sm_other_recruit_list_open_terminal = {
	_name = "sm_other_recruit_list_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmOtherRecruitListClass") == nil then
			fwin:open(SmOtherRecruitList:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local sm_other_recruit_list_close_terminal = {
	_name = "sm_other_recruit_list_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmOtherRecruitListClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_other_recruit_list_open_terminal)
state_machine.add(sm_other_recruit_list_close_terminal)
state_machine.init()

function SmOtherRecruitList:ctor()
	self.super:ctor()
	self.roots = {}

    -- app.load("client.l_digital.activity.wonderful.SmLimitedTimeEquipBoxHelp")
    -- app.load("client.l_digital.activity.wonderful.SmLimitedTimeEquipBoxWindow")

    -- app.load("client.l_digital.cells.activity.wonderful.sm_limited_time_equip_box_reward_cell")
    -- app.load("client.l_digital.cells.activity.wonderful.sm_limited_time_equip_box_rank_cell")

    local function init_sm_other_recruit_list_terminal()
        local sm_other_recruit_list_update_draw_terminal = {
            _name = "sm_other_recruit_list_update_draw",
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

        state_machine.add(sm_other_recruit_list_update_draw_terminal)
        state_machine.init()
    end
    init_sm_other_recruit_list_terminal()
end

function SmOtherRecruitList:onUpdateDraw()
    local root = self.roots[1]
    local activity_info = _ED.active_activity[114]
    local result = {}
    local info = zstring.split(activity_info.need_recharge_count, "@")
    info = zstring.split(info[4], ",")
    for i=4,#info do
        -- table.insert(result, tonumber(info[i]))
        table.insert(result, zstring.split(info[i], "-", function (value) return tonumber(value) end))
    end
    local function sortFunction(a, b)
        local a_ability = dms.int(dms["ship_mould"], a[1], ship_mould.ability)
        local b_ability = dms.int(dms["ship_mould"], b[1], ship_mould.ability)
        return a_ability > b_ability
    end
    table.sort(result, sortFunction)

    local ListView_xsbx_rule = ccui.Helper:seekWidgetByName(root, "ListView_xsbx_rule")
    ListView_xsbx_rule:removeAllItems()

    for k, v in pairs(result) do
        local cell = state_machine.excute("sm_activity_other_recruit_cell_create", 0, v)
        ListView_xsbx_rule:addChild(cell)
    end
    ListView_xsbx_rule:requestRefreshView()
end

function SmOtherRecruitList:init(params)
	self:onInit()
    return self
end

function SmOtherRecruitList:onInit()
    local csbItem = csb.createNode("activity/wonderful/sm_vip_chouka_help.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil, 
    {
        terminal_name = "sm_other_recruit_list_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
end

function SmOtherRecruitList:onEnterTransitionFinish()
end

function SmOtherRecruitList:onExit()
    state_machine.remove("sm_other_recruit_list_update_draw")
end

