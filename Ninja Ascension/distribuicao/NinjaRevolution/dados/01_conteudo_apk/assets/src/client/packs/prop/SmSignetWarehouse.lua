-----------------------------
--印记的仓库（忍列传所需道具）
-----------------------------
SmSignetWarehouse = class("SmSignetWarehouseClass", Window)

local sm_signet_warehouse_window_open_terminal = {
    _name = "sm_signet_warehouse_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmSignetWarehouse:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_signet_warehouse_window_open_terminal)
state_machine.init()

function SmSignetWarehouse:ctor()
    self.super:ctor()
    self.roots = {}
    self.prop_list = {}

    self.currentScrollView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    
    local function init_sm_signet_warehouse_terminal()
		--显示界面
		local sm_signet_warehouse_show_terminal = {
            _name = "sm_signet_warehouse_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                if instance.prop_list[1] ~= nil then
                    state_machine.excute("prop_warehouse_show_data_interface", 0, "")
                    state_machine.excute("sm_packs_cell_update_page", 0, {_datas = {cells = instance.prop_list[1]}})
                else
                    state_machine.excute("prop_warehouse_hide_data_interface", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local sm_signet_warehouse_hide_terminal = {
            _name = "sm_signet_warehouse_hide",
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

        local sm_signet_warehouse_update_draw_terminal = {
            _name = "sm_signet_warehouse_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                if instance.prop_list[1] ~= nil then
                    state_machine.excute("prop_warehouse_show_data_interface", 0, "")
                    state_machine.excute("sm_packs_cell_update_page", 0, {_datas = {cells = instance.prop_list[1]}})
                else
                    state_machine.excute("prop_warehouse_hide_data_interface", 0, "")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_signet_warehouse_show_terminal)	
		state_machine.add(sm_signet_warehouse_hide_terminal)
        state_machine.add(sm_signet_warehouse_update_draw_terminal)

        state_machine.init()
    end
    init_sm_signet_warehouse_terminal()
end

function SmSignetWarehouse:onHide()
    local root = self.roots[1]
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_warehouse")
    m_ScrollView:removeAllChildren(true)
    self:setVisible(false)
    self:stopAllActions()
end

function SmSignetWarehouse:onShow()
    self:setVisible(true)
    self:onUpdateDraw()
end

function SmSignetWarehouse:getSortedHeroes()
    local function fightingCapacity(a,b)
        local al = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.prop_quality)
        local bl = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.prop_quality)
            
        if al == bl then
            local aCount = tonumber(a.prop_number)
            local bCount = tonumber(b.prop_number)

            return aCount > bCount
        end

        return al > bl 
    end
    local tSortedHeroes = {}

    for i, prop in pairs(_ED.user_prop) do
        local propData = dms.element(dms["prop_mould"], prop.user_prop_template)
        if dms.atof(propData, prop_mould.storage_page_index) == 20 then
            table.insert(tSortedHeroes, prop)
        end
    end

    table.sort(tSortedHeroes, fightingCapacity)
    return tSortedHeroes
end

function SmSignetWarehouse:onUpdateDraw()
    self.prop_list = {}
    local tSortedHeroes = self:getSortedHeroes()
    local root = self.roots[1]
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_warehouse")
    m_ScrollView:removeAllChildren(true)
    local panel = m_ScrollView:getInnerContainer()
    panel:setContentSize(m_ScrollView:getContentSize())
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = m_ScrollView:getInnerContainerSize()
    local nextY = sSize.height
    local nextX = sSize.width
    local tHeight = 0
    local cellHeight = 0
    local tWidth = 0
    local wPosition = sWidth/4

    local Hlindex = 0
    local number = #tSortedHeroes
    local m_number = math.ceil(number/4)

    cellHeight = m_number*(m_ScrollView:getContentSize().width/4)

    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local first = nil
    for j, v in pairs(tSortedHeroes) do
        local cell = state_machine.excute("sm_packs_cell",0,{v, 0, nil, nil, nil, j})
        panel:addChild(cell)
        table.insert(self.prop_list, cell)
        if j == 1 then
            first = cell
        end
        tWidth = tWidth + wPosition

            if (j-1)%4 ==0 then
                Hlindex = Hlindex+1
                tWidth = 0
                tHeight = sHeight - wPosition*Hlindex  
            end
            if j <= 4 then
                tHeight = sHeight - wPosition
            end
        cell:setPosition(cc.p(tWidth,tHeight))
    end
    m_ScrollView:jumpToTop()

    self.currentScrollView = m_ScrollView
    self.currentInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function SmSignetWarehouse:onUpdate(dt)
    if self.currentScrollView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentScrollView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentScrollView:getChildren()
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

function SmSignetWarehouse:onEnterTransitionFinish()

end

function SmSignetWarehouse:onInit( )
    local csbItem = csb.createNode("packs/warehouse_listvisw.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    self:onUpdateDraw()
    if self.prop_list[1] ~= nil then
        state_machine.excute("prop_warehouse_show_data_interface", 0, "")
        state_machine.excute("sm_packs_cell_update_page", 0, {_datas = {cells = self.prop_list[1]}})
    else
        state_machine.excute("prop_warehouse_hide_data_interface", 0, "")
    end
end

function SmSignetWarehouse:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmSignetWarehouse:onExit()
    state_machine.remove("sm_signet_warehouse_show")    
    state_machine.remove("sm_signet_warehouse_hide")
    state_machine.remove("sm_signet_warehouse_update_draw")
end
