-----------------------------
-- 工会管理
-----------------------------
UnionManager = class("UnionManagerClass", Window)

--打开界面
local union_manager_open_terminal = {
	_name = "union_manager_open",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:open(UnionManager:new():init(params), fwin._view)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
--关闭界面
local union_manager_close_terminal = {
	_name = "union_manager_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionManagerClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_manager_open_terminal)
state_machine.add(union_manager_close_terminal)
state_machine.init()

function UnionManager:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
    self._unionData = nil
    self._cell = nil

    local function init_union_manager_terminal()
		local union_manager_change_post_terminal = {
            _name = "union_manager_change_post",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local nType = params._datas._type
                instance._chooseType = nType
                if nType == 1 then
                    local tip = ConfirmTip:new()
                    tip:init(self, instance.quxSureTipCallBack, tipStringInfo_union_str[49])
                    fwin:open(tip, fwin._ui)
                else
                    instance:quxSureTipCallBack(0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_manager_change_post_terminal)
        state_machine.init()
    end
	
    init_union_manager_terminal()
end

function UnionManager:quxSureTipCallBack(n)
    if n ~= 0 then
        return
    end
    local function responseUnionListCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                if tonumber(response.node._chooseType) == 5 then
                    state_machine.excute("union_the_meeting_place_member_refresh_info", 0, nil)
                else
                    response.node._cell.unionData.post = response.node._chooseType
                    response.node._cell:updateDraw()
                end
                state_machine.excute("union_manager_close", 0, "")
            end
        end
    end 
    protocol_command.union_appoint.param_list = _ED.union.union_info.union_id.."\r\n"..self._unionData.id.."\r\n"..self._chooseType
    NetworkManager:register(protocol_command.union_appoint.code, nil, nil, nil, self, responseUnionListCallback, false, nil)
end

function UnionManager:updateDraw()
    local root = self.roots[1]
    local Panel_president_manage = ccui.Helper:seekWidgetByName(root, "Panel_president_manage")
    local Panel_vice_president_manage = ccui.Helper:seekWidgetByName(root, "Panel_vice_president_manage")
    local Panel_elite_manage = ccui.Helper:seekWidgetByName(root, "Panel_elite_manage")
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")

    local mRoot = ccui.RichText:create()
    local re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[8][1], tipStringInfo_union_color[8][2], tipStringInfo_union_color[8][3]), 255, tipStringInfo_union_str[23], config_res.font.font_name, 22)
    mRoot:pushBackElement(re)
    re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[7][1], tipStringInfo_union_color[7][2], tipStringInfo_union_color[7][3]), 255, self._unionData.name, config_res.font.font_name, 22)
    mRoot:pushBackElement(re)
    re = ccui.RichElementText:create(1, cc.c3b(tipStringInfo_union_color[8][1], tipStringInfo_union_color[8][2], tipStringInfo_union_color[8][3]), 255, tipStringInfo_union_str[21], config_res.font.font_name, 22)
    mRoot:pushBackElement(re)
    local width = Text_player_name:getContentSize().width
    local height = Text_player_name:getContentSize().height
    mRoot:setAnchorPoint(cc.p(0, 0))
    mRoot:setPosition(cc.p(0, -height/2))
    Text_player_name:removeAllChildren(true)
    Text_player_name:addChild(mRoot)

    Panel_president_manage:setVisible(false)
    Panel_vice_president_manage:setVisible(false)
    Panel_elite_manage:setVisible(false)

    if tonumber(_ED.union.user_union_info.union_post) == 1 then
        Panel_president_manage:setVisible(true)
        if tonumber(self._unionData.post) == 4 then
            ccui.Helper:seekWidgetByName(root, "Button_remove_appoint"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Button_remove_appoint_0"):setVisible(false)
        elseif tonumber(self._unionData.post) == 3 then
            ccui.Helper:seekWidgetByName(root, "Button_remove_appoint"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Button_appoint_elite"):setVisible(false)
        elseif tonumber(self._unionData.post) == 2 then
            ccui.Helper:seekWidgetByName(root, "Button_appoint_vice_president"):setVisible(false)
            ccui.Helper:seekWidgetByName(root, "Button_remove_appoint_0"):setVisible(false)
        end
    elseif tonumber(_ED.union.user_union_info.union_post) == 2 then
        Panel_vice_president_manage:setVisible(true)
        if tonumber(self._unionData.post) == 4 then
            ccui.Helper:seekWidgetByName(root, "Button_remove_appoint_1"):setVisible(false)
        elseif tonumber(self._unionData.post) == 3 then
            ccui.Helper:seekWidgetByName(root, "Button_appoint_elite_1"):setVisible(false)
        end
    elseif tonumber(_ED.union.user_union_info.union_post) == 3 then
        Panel_elite_manage:setVisible(true)
    end
end

function UnionManager:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_manage_1)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
    
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_appoint_president"), nil, 
    {
        terminal_name = "union_manager_change_post", 
        terminal_state = 0,
        _type = 1,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_appoint_vice_president"), nil, 
    {
        terminal_name = "union_manager_change_post", 
        terminal_state = 0,
        _type = 2,
        isPressedActionEnabled = true
    }, 
    nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_appoint_elite"), nil, 
    {
        terminal_name = "union_manager_change_post", 
        terminal_state = 0,
        _type = 3,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_remove_appoint"), nil, 
    {
        terminal_name = "union_manager_change_post", 
        terminal_state = 0,
        _type = 4,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_remove_appoint_0"), nil, 
    {
        terminal_name = "union_manager_change_post", 
        terminal_state = 0,
        _type = 4,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_appoint_elite_1"), nil, 
    {
        terminal_name = "union_manager_change_post", 
        terminal_state = 0,
        _type = 3,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_remove_appoint_1"), nil, 
    {
        terminal_name = "union_manager_change_post", 
        terminal_state = 0,
        _type = 4,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_out_1"), nil, 
    {
        terminal_name = "union_manager_change_post", 
        terminal_state = 0,
        _type = 5,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_out_2"), nil, 
    {
        terminal_name = "union_manager_change_post", 
        terminal_state = 0,
        _type = 5,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_out"), nil, 
    {
        terminal_name = "union_manager_change_post", 
        terminal_state = 0,
        _type = 5,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_legion_manage"), nil, 
    {
        terminal_name = "union_manager_close", 
        terminal_state = 0,
        _type = 5,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:updateDraw()
end

function UnionManager:onEnterTransitionFinish()

end

function UnionManager:init(params)
    self._unionData = params[1]
    self._cell = params[2]
	self:onInit()
	return self
end

function UnionManager:onExit()
	state_machine.remove("union_manager_change_post")
end
