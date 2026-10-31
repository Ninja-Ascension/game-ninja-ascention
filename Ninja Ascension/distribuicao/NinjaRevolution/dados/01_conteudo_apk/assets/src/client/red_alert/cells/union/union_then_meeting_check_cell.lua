--------------------------------------------------------------------------------------------------------------
--  说明：军团议事大厅审核申请列表
--------------------------------------------------------------------------------------------------------------
UnionTheMeetingCheckCell = class("UnionTheMeetingCheckCellClass", Window)
UnionTheMeetingCheckCell.__size = nil
--创建cell
local union_the_meeting_check_create_cell_terminal = {
    _name = "union_the_meeting_check_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local infoData = params[1]
        local index = params[2]
        local cell = UnionTheMeetingCheckCell:new()
        cell:init(infoData, index)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(union_the_meeting_check_create_cell_terminal)
state_machine.init()
function UnionTheMeetingCheckCell:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
	self.infoData = nil

    app.load("client.red_alert.union.meeting.UnionTheMeetingPlaceMember")
	
	 -- Initialize union the meeting check list cell state machine.
    local function init_union_then_meeting_check_cell_terminal()
		-- 通过审核
		local union_the_meeting_check_cell_yes_terminal = {
            _name = "union_the_meeting_check_cell_yes",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:requestChangePersion(true, params._datas.infoData)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--不通过审核状
		local union_the_meeting_check_cell_no_terminal = {
            _name = "union_the_meeting_check_cell_no",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:requestChangePersion(false, params._datas.infoData)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(union_the_meeting_check_cell_yes_terminal)
		state_machine.add(union_the_meeting_check_cell_no_terminal)
        state_machine.init()
    end
    -- call func init union the meeting check list cell l state machine.
    init_union_then_meeting_check_cell_terminal()

end

function UnionTheMeetingCheckCell:requestChangePersion( isArgree, infoData )
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            -- for k,v in pairs(_ED.union.union_examine_list_info) do
            --     if v == response.node[2] then
            --         table.remove(_ED.union.union_examine_list_info, k)
            --         _ED.union.union_examine_list_sum = _ED.union.union_examine_list_sum - 1
            --     end
            -- end
            state_machine.excute("union_the_meeting_check_refresh_info", 0, nil)
            state_machine.excute("union_the_meeting_place_information_refresh", 0, nil)
            -- if response.node[1] == true then
                state_machine.excute("union_the_meeting_place_member_refresh_info", 0, "")
            -- end
        end
    end
    local ntype = 0
    if isArgree == true then
        ntype = 1
    else
        ntype = 0
    end
    local persionParam = _ED.union.union_info.union_id.."\r\n"..infoData.id.."\r\n"..ntype
    protocol_command.union_persion_manage.param_list = persionParam
    NetworkManager:register(protocol_command.union_persion_manage.code, nil, nil, nil, {isArgree, infoData}, responseCallback, false, nil)
end

function UnionTheMeetingCheckCell:updateDraw()
    local root = self.roots[1]
    local Panel_13 = ccui.Helper:seekWidgetByName(root, "Panel_13")
    Panel_13:removeAllChildren(true)
    local Text_3_lv = ccui.Helper:seekWidgetByName(root, "Text_3_lv")
    local Text_16_zl = ccui.Helper:seekWidgetByName(root, "Text_16_zl")
    local nameText = ccui.Helper:seekWidgetByName(root, "Text_12_name")
    if self.infoData == nil then
        return
    end
    Text_3_lv:setString(""..self.infoData.level)
    Text_16_zl:setString(""..self.infoData.capactity)
    nameText:setString(self.infoData.name)

    local data = {
        user_sex = self.infoData.user_sex, 
        user_level = self.infoData.level,
        user_camp = _ED.union.union_info.union_camp,
    }
    Panel_13:addChild(state_machine.excute("user_head_icon_create", 0, {data, 1}))
end

function UnionTheMeetingCheckCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.legion.legion_pro_shenhe_list, "root")
    self:addChild(root)
    table.insert(self.roots, root)

    self:setContentSize(root:getContentSize())
    if UnionTheMeetingCheckCell.__size == nil then
        UnionTheMeetingCheckCell.__size = root:getContentSize()
    end
    -- 列表控件动画播放
    -- local action = csb.createTimeline(config_csb.cells.legion.legion_pro_shenhe_list)
    -- table.insert(self.actions, action)
    -- csbItem:runAction(action)
    -- action:play("list_view_cell_open", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_106_0_0"), nil, 
    {
        terminal_name = "union_the_meeting_check_cell_yes", 
        terminal_state = 0,
        infoData = self.infoData,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_106_0_0_0"), nil, 
    {
        terminal_name = "union_the_meeting_check_cell_no", 
        terminal_state = 0,
        infoData = self.infoData,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	self:updateDraw()
end

function UnionTheMeetingCheckCell:onEnterTransitionFinish()
end

function UnionTheMeetingCheckCell:init(infoData, index)
    self.infoData = infoData
    if index ~= nil and index < 5 then
        self:onInit()
    end
    self:setContentSize(UnionTheMeetingCheckCell.__size)
	return self
end

function UnionTheMeetingCheckCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function UnionTheMeetingCheckCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
    ccui.Helper:seekWidgetByName(root, "Panel_13"):removeAllChildren(true)
    cacher.freeRef(config_csb.cells.legion.legion_pro_shenhe_list, root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
    self.actions = {}
end

function UnionTheMeetingCheckCell:onExit()
    if self.roots[1] ~= nil then
        local Panel_13 = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_13")
        if Panel_13 ~= nil then
            Panel_13:removeAllChildren(true)
        end
        cacher.freeRef(config_csb.cells.legion.legion_pro_shenhe_list, self.roots[1])
    end
end

function UnionTheMeetingCheckCell:createCell()
	local cell = UnionTheMeetingCheckCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end
