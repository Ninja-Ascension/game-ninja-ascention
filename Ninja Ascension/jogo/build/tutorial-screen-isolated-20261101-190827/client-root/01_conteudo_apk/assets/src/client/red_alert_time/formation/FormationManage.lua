--------------------------------------------------------------------------------------------------------------
--  说明：阵容管理
--------------------------------------------------------------------------------------------------------------
FormationManage = class("FormationManageClass", Window)

--打开界面
local formation_manage_open_terminal = {
    _name = "formation_manage_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("FormationManageClass") == nil then
            fwin:open(FormationManage:new():init(), fwin._ui)  
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local formation_manage_close_terminal = {
    _name = "formation_manage_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FormationManageClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(formation_manage_open_terminal)
state_machine.add(formation_manage_close_terminal)
state_machine.init()

function FormationManage:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._Image_formation_manage_up = nil
    self._Image_formation_manage_down = nil
    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    local function init_formation_manage_terminal()

    end
    
    init_formation_manage_terminal()
end

function FormationManage:updateDraw()
    local root = self.roots[1]
    local ListView_formation_manage = ccui.Helper:seekWidgetByName(root, "ListView_formation_manage")
    ListView_formation_manage:jumpToTop()
    ListView_formation_manage:removeAllItems()

    local vip_data = dms.element(dms["base_consume"], 82)
    local vip_open_count = {}           -- vip 等级开启的保存阵型数
    for i = 0, 14 do
        local count = dms.atoi(vip_data, base_consume.vip_0_value + i)
        table.insert(vip_open_count, count)
    end

    local need_vip = {}                 -- 每个保存阵型需要vip等级
    for i = 1, 8 do
        local vip_level = 0
        for k, count in pairs(vip_open_count) do
            if i <= count then
                vip_level = k - 1
                break
            end
        end
        table.insert(need_vip, vip_level)
    end

    for i = 1, 8 do
        local cell = nil
        if tonumber(_ED.vip_grade) >= need_vip[i] then
            cell = state_machine.excute("formation_manage_enabled_cell_create", 0, {i})
        else
            cell = state_machine.excute("formation_manage_disabled_cell_create", 0, {i, need_vip[i]})
        end
        ListView_formation_manage:addChild(cell)
    end

    ListView_formation_manage:requestRefreshView()
    self._list_view = ListView_formation_manage
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function FormationManage:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_formation_manage_down:setVisible(true)
        else
            self._Image_formation_manage_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_formation_manage_up:setVisible(true)
        else
            self._Image_formation_manage_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
        local items = self._list_view:getItems()
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

--初始化
function FormationManage:onInit()
    local csbItem = csb.createNode(config_csb.formation.formation_manage)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_formation_manage_close"), nil, 
    {
        terminal_name = "formation_manage_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "formation_manage_close", 
        terminal_state = 0, 
    }, nil, 3)

    self._Image_formation_manage_up = ccui.Helper:seekWidgetByName(root,"Image_formation_manage_up")
    self._Image_formation_manage_down = ccui.Helper:seekWidgetByName(root,"Image_formation_manage_down")

    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_formation_manage_down:stopAllActions()
    self._Image_formation_manage_up:stopAllActions()
    playActions(self._Image_formation_manage_down)
    playActions(self._Image_formation_manage_up)
    self._Image_formation_manage_down:setVisible(false)
    self._Image_formation_manage_up:setVisible(false)

    self:updateDraw()
end

function FormationManage:onEnterTransitionFinish()

end

function FormationManage:init(param)
    self:onInit()
    return self
end

function FormationManage:onExit()

end