--------------------------------------------------------------------------------------------------------------
--  推送的cell
--------------------------------------------------------------------------------------------------------------
SetUpCell = class("SetUpCellClass", Window)
SetUpCell.__size = nil
--创建cell
local set_up_cell_terminal = {
    _name = "set_up_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SetUpCell:new()
        cell:init()
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(set_up_cell_terminal)
state_machine.init()

function SetUpCell:ctor()
	self.super:ctor()
	self.roots = {}

    self._index = 0
    self._mail_data = nil
    self._ntype = 0
    
    app.load("client.red_alert_time.cells.system.set_up_push_cell")

    local function init_mail_cell_terminal()
        
        state_machine.init()
    end
    
    init_mail_cell_terminal()
end

function SetUpCell:updateDraw()
    local root = self.roots[1]
	local ListView_game_push_set = ccui.Helper:seekWidgetByName(root,"ListView_game_push_set")
    local Image_push_list_box = ccui.Helper:seekWidgetByName(root,"Image_push_list_box")
    local listViewSize = ListView_game_push_set:getContentSize()
    ListView_game_push_set:jumpToTop()
    ListView_game_push_set:removeAllItems()
    local iemsMargin = ListView_game_push_set:getItemsMargin()
    local showId = {}
    local nCoount = 0
    local listheight = 0
    for i, v in pairs(_app_push_notification) do
        if showId[tonumber(v[4])] == nil then
            showId[tonumber(v[4])] = {}
            showId[tonumber(v[4])].id = v[4]
            showId[tonumber(v[4])].name = v[5]
        end
    end

    for i, v in pairs(showId) do
        local cell = state_machine.excute("set_up_push_cell",0, v)
        ListView_game_push_set:addChild(cell)
        nCoount = nCoount + 1
        listheight = listheight + iemsMargin
    end
    listheight = listheight + SetUpPushCell.__size.height * nCoount

    ListView_game_push_set:setContentSize(cc.size(listViewSize.width,listheight))
    -- ListView_game_push_set:addChild(cell)
    ListView_game_push_set:setTouchEnabled(false)
    ListView_game_push_set:requestRefreshView()
    local upHeight = listheight - listViewSize.height
    if upHeight > 0 then
        root:setContentSize(cc.size(root:getContentSize().width, root._height + upHeight))
        SetUpCell.__size = root:getContentSize()
        root:setPositionY(root._y + upHeight)
        Image_push_list_box:setContentSize(cc.size(Image_push_list_box:getContentSize().width,Image_push_list_box._height+upHeight))
    else
        root:setContentSize(cc.size(root:getContentSize().width, root._height))
        SetUpCell.__size = root:getContentSize()
        root:setPositionY(root._y)
        Image_push_list_box:setContentSize(cc.size(Image_push_list_box:getContentSize().width,Image_push_list_box._height))
    end
end

function SetUpCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.system.set_up_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root) 

    root:setTouchEnabled(false)

    if root._height == nil then
        root._height = root:getContentSize().height
    end
    root:setContentSize(cc.size(root:getContentSize().width,root._height))
    if SetUpCell.__size == nil then
        SetUpCell.__size = root:getContentSize()
    end
    if root._y == nil then
        root._y = root:getPositionY()
    end
    root:setPositionY(root._y)
    if ccui.Helper:seekWidgetByName(root,"ListView_game_push_set")._y == nil then
        ccui.Helper:seekWidgetByName(root,"ListView_game_push_set")._y = ccui.Helper:seekWidgetByName(root,"ListView_game_push_set"):getPositionY()
    end
    ccui.Helper:seekWidgetByName(root,"ListView_game_push_set"):setPositionY(ccui.Helper:seekWidgetByName(root,"ListView_game_push_set")._y)
    if ccui.Helper:seekWidgetByName(root,"ListView_game_push_set")._height == nil then
        ccui.Helper:seekWidgetByName(root,"ListView_game_push_set")._height = ccui.Helper:seekWidgetByName(root,"ListView_game_push_set"):getContentSize().height
    end
    ccui.Helper:seekWidgetByName(root,"ListView_game_push_set"):setContentSize(cc.size(ccui.Helper:seekWidgetByName(root,"ListView_game_push_set"):getContentSize().width,
        ccui.Helper:seekWidgetByName(root,"ListView_game_push_set")._height))

    if ccui.Helper:seekWidgetByName(root,"Image_push_list_box")._height == nil then
        ccui.Helper:seekWidgetByName(root,"Image_push_list_box")._height = ccui.Helper:seekWidgetByName(root,"Image_push_list_box"):getContentSize().height
    end
    ccui.Helper:seekWidgetByName(root,"Image_push_list_box"):setContentSize(cc.size(ccui.Helper:seekWidgetByName(root,"Image_push_list_box"):getContentSize().width,
        ccui.Helper:seekWidgetByName(root,"Image_push_list_box")._height))

	self:updateDraw()
end

function SetUpCell:onEnterTransitionFinish()

end

function SetUpCell:init()

    self:onInit()

    self:setContentSize(SetUpCell.__size)
    return self
end

function SetUpCell:clearUIInfo( ... )
    local root = self.roots[1]
    root:setContentSize(cc.size(root:getContentSize().width,root._height))
    root:setPositionY(root._y)
    SetUpCell.__size = root:getContentSize()
    ccui.Helper:seekWidgetByName(root,"ListView_game_push_set"):setPositionY(ccui.Helper:seekWidgetByName(root,"ListView_game_push_set")._y)
     ccui.Helper:seekWidgetByName(root,"Image_push_list_box"):setContentSize(cc.size(ccui.Helper:seekWidgetByName(root,"Image_push_list_box"):getContentSize().width,
        ccui.Helper:seekWidgetByName(root,"Image_push_list_box")._height))
     ccui.Helper:seekWidgetByName(root,"ListView_game_push_set"):setContentSize(cc.size(ccui.Helper:seekWidgetByName(root,"ListView_game_push_set"):getContentSize().width,
        ccui.Helper:seekWidgetByName(root,"ListView_game_push_set")._height))
end

function SetUpCell:onExit()
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.system.set_up_cell, self.roots[1])
end

function SetUpCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function SetUpCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef(config_csb.cells.system.set_up_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end