-- ---------------------------
-- 征战技能详情
-- ---------------------------
PveTroopsAttribute = class("PveTroopsAttributeClass", Window)

local pve_troops_attribute_window_open_terminal = {
    _name = "pve_troops_attribute_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("PveTroopsAttributeClass") == nil then
            local _win = PveTroopsAttribute:new()
            _win:init(params)
            fwin:open(_win, fwin._ui)
        end
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local pve_troops_attribute_window_close_terminal = {
    _name = "pve_troops_attribute_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PveTroopsAttributeClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_troops_attribute_window_open_terminal)
state_machine.add(pve_troops_attribute_window_close_terminal)
state_machine.init()

function PveTroopsAttribute:ctor()
    self.super:ctor()
    self.roots = {}

    self.mould_id = 0 
    self._have_lv = 0

    local function init_pve_troops_attribute_terminal()

        state_machine.init()
    end
    init_pve_troops_attribute_terminal()
end

function PveTroopsAttribute:onUpdateDraw()
    local root = self.roots[1]
    -- name
    local Text_attribute_name = ccui.Helper:seekWidgetByName(root,"Text_attribute_name")
    local halo_name = dms.string(dms["pve_buff"], self.mould_id, pve_buff.halo_name)
    Text_attribute_name:setString(halo_name)
    
    -- icon
    local Panel_troops_attribute_icon = ccui.Helper:seekWidgetByName(root,"Panel_troops_attribute_icon")
    Panel_troops_attribute_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{1,3,self.mould_id,12})
    Panel_troops_attribute_icon:addChild(cell) 

    -- 描述
    local Text_infor_prompt_t_1 = ccui.Helper:seekWidgetByName(root,"Text_infor_prompt_t_1")
    local description = dms.string(dms["pve_buff"], self.mould_id, pve_buff.description)
    Text_infor_prompt_t_1:setString(description)

    local talent = dms.string(dms["pve_buff"], self.mould_id, pve_buff.condition)
    local talent_info = zstring.split(talent, ",")

    local ListView_troops_attribute_infor = ccui.Helper:seekWidgetByName(root,"ListView_troops_attribute_infor")
    ListView_troops_attribute_infor:jumpToTop()
    ListView_troops_attribute_infor:removeAllItems()
    for i, v in pairs(talent_info) do
        local cell = state_machine.excute("pve_troops_attribute_cell_create", 0, {i, v,self._have_lv})
        ListView_troops_attribute_infor:addChild(cell)
    end
    ListView_troops_attribute_infor:requestRefreshView()
    self.listview = ListView_troops_attribute_infor
    self.listview_poy = ListView_troops_attribute_infor:getInnerContainer():getPositionY()
    self.listview_height = ListView_troops_attribute_infor:getInnerContainer():getPositionY()
end

function PveTroopsAttribute:onUpdate(dt)
    if self.listview ~= nil then
        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_attribute_arrow_down:setVisible(true)
        else
            self._Image_attribute_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_attribute_arrow_up:setVisible(true)
        else
            self._Image_attribute_arrow_up:setVisible(false)
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

function PveTroopsAttribute:onEnterTransitionFinish()

end

function PveTroopsAttribute:onInit( )
    local csbItem = csb.createNode(config_csb.pve.pve_troops_attribute)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_troops_attribute_close"), nil, 
    {
        terminal_name = "pve_troops_attribute_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "pve_troops_attribute_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self._Image_attribute_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_attribute_arrow_down")
    self._Image_attribute_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_attribute_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_attribute_arrow_down:stopAllActions()
    self._Image_attribute_arrow_up:stopAllActions()
    playActions(self._Image_attribute_arrow_down)
    playActions(self._Image_attribute_arrow_up)
    self._Image_attribute_arrow_down:setVisible(false)
    self._Image_attribute_arrow_up:setVisible(false)

    self:onUpdateDraw()
end

function PveTroopsAttribute:init(params)
    self.mould_id = params[1]
    self._have_lv = params[2]
    self:onInit()
    return self
end

function PveTroopsAttribute:onExit()
end
