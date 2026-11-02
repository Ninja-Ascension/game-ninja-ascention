-----------------------------
--军团事件
-----------------------------
LegionEvent = class("LegionEventClass", Window)

local legion_event_window_open_terminal = {
    _name = "legion_event_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = LegionEvent:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(legion_event_window_open_terminal)
state_machine.init()

function LegionEvent:ctor()
    self.super:ctor()
    self.roots = {}

    self._count = 0
    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0
    self._Image_event_arrow_down = nil
    self._Image_event_arrow_up = nil

    local function init_legion_event_terminal()
        --显示界面
        local legion_event_show_terminal = {
            _name = "legion_event_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                if instance._count ~= tonumber(_ED.union.union_message_number) then
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --隐藏界面
        local legion_event_hide_terminal = {
            _name = "legion_event_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        state_machine.add(legion_event_show_terminal)  
        state_machine.add(legion_event_hide_terminal)
        state_machine.init()
    end
    init_legion_event_terminal()
end

function LegionEvent:onHide()
    self:setVisible(false)
end

function LegionEvent:onShow()
    self:setVisible(true)
end

function LegionEvent:onUpdateDraw()
    local root = self.roots[1]
    local ListView_legion_event = ccui.Helper:seekWidgetByName(root,"ListView_legion_event")
    ListView_legion_event:jumpToTop()
    ListView_legion_event:removeAllItems()

    local arry = {}
    if _ED.union.union_message_info_list ~= nil then
        arry = _ED.union.union_message_info_list
        local function sortfunction( a,b )
            return tonumber(a.time) > tonumber(b.time)
        end
        table.sort( arry, sortfunction )
    end

    for k,v in pairs(arry) do
        local cell = state_machine.excute("legion_event_create_cell", 0, {v, k})
        ListView_legion_event:addChild(cell)
        self._count = k
    end

    ListView_legion_event:requestRefreshView()
    self.listview = ListView_legion_event
    self.listview_poy = ListView_legion_event:getInnerContainer():getPositionY()
    self.listview_height = ListView_legion_event:getInnerContainer():getPositionY()
end

function LegionEvent:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_event_arrow_down:setVisible(true)
        else
            self._Image_event_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_event_arrow_up:setVisible(true)
        else
            self._Image_event_arrow_up:setVisible(false)
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

function LegionEvent:onEnterTransitionFinish()

end

function LegionEvent:onInit( )
    local csbItem = csb.createNode(string.format(config_csb.legion.legion_tab, 2))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._Image_event_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_event_arrow_down")
    self._Image_event_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_event_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_event_arrow_down:stopAllActions()
    self._Image_event_arrow_up:stopAllActions()
    playActions(self._Image_event_arrow_down)
    playActions(self._Image_event_arrow_up)
    self._Image_event_arrow_down:setVisible(false)
    self._Image_event_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

function LegionEvent:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function LegionEvent:onExit()
    state_machine.remove("legion_event_show")
    state_machine.remove("legion_event_hide")
end
