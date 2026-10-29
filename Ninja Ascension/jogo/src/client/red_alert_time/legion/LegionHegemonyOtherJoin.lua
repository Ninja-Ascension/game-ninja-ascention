--------------------------------------------------------------------------------------------------------------
--  说明：军团争霸-其他参赛军团
--------------------------------------------------------------------------------------------------------------
LegionHegemonyOtherJoin = class("LegionHegemonyOtherJoinClass", Window)

--打开界面
local legion_hegemony_other_join_window_open_terminal = {
	_name = "legion_hegemony_other_join_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("LegionHegemonyOtherJoinClass") == nil then
            fwin:open(LegionHegemonyOtherJoin:new():init(params), fwin._ui)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local legion_hegemony_other_join_window_close_terminal = {
	_name = "legion_hegemony_other_join_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionHegemonyOtherJoinClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(legion_hegemony_other_join_window_open_terminal)
state_machine.add(legion_hegemony_other_join_window_close_terminal)
state_machine.init()

function LegionHegemonyOtherJoin:ctor()
	self.super:ctor()
	self.roots = {}

    self.listview = nil
    self.listview_poy = nil
    self.listview_height = 0
    self._Image_participate_arrow_down = nil
    self._Image_participate_arrow_up = nil
end

function LegionHegemonyOtherJoin:onUpdateDraw()
    local root = self.roots[1]
    local Text_participate_n = ccui.Helper:seekWidgetByName(root,"Text_participate_n")
    local Text_not_sign_up_p = ccui.Helper:seekWidgetByName(root,"Text_not_sign_up_p")
    local ListView_vs_troops = ccui.Helper:seekWidgetByName(root,"ListView_vs_troops")
    ListView_vs_troops:jumpToTop()
    ListView_vs_troops:removeAllItems()

    if _ED.union.union_hegemony_all_union_sign_up_list ~= nil then
        for k, v in pairs(_ED.union.union_hegemony_all_union_sign_up_list) do
            local cell = state_machine.excute("legion_hegemony_window_cell_create", 0, {k, v})
            ListView_vs_troops:addChild(cell)
        end
    end

    ListView_vs_troops:requestRefreshView()
    self.listview = ListView_vs_troops
    self.listview_poy = ListView_vs_troops:getInnerContainer():getPositionY()
    self.listview_height = ListView_vs_troops:getInnerContainer():getPositionY()

    if _ED.union.union_hegemony_all_union_sign_up_list ~= nil then
        Text_participate_n:setString(#_ED.union.union_hegemony_all_union_sign_up_list)
    else
        Text_participate_n:setString("0")
    end
end

function LegionHegemonyOtherJoin:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_participate_arrow_down:setVisible(true)
        else
            self._Image_participate_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_participate_arrow_up:setVisible(true)
        else
            self._Image_participate_arrow_up:setVisible(false)
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

function LegionHegemonyOtherJoin:onInit(params)
    local csbItem = csb.createNode(config_csb.legion.legion_hegemony_window)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hegemony_window_close"), nil, 
    {
        terminal_name = "legion_hegemony_other_join_window_close", 
        terminal_state = 0,  
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "legion_hegemony_other_join_window_close", 
        terminal_state = 0,  
        touch_black = true,
    }, nil, 3)

    self._Image_participate_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_participate_arrow_down")
    self._Image_participate_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_participate_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_participate_arrow_down:stopAllActions()
    self._Image_participate_arrow_up:stopAllActions()
    playActions(self._Image_participate_arrow_down)
    playActions(self._Image_participate_arrow_up)
    self._Image_participate_arrow_down:setVisible(false)
    self._Image_participate_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

function LegionHegemonyOtherJoin:onEnterTransitionFinish()

end

function LegionHegemonyOtherJoin:init(params)
	self:onInit(params)
    return self
end

function LegionHegemonyOtherJoin:onExit()

end