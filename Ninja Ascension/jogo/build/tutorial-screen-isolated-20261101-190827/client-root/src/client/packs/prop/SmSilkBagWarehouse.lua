-----------------------------
--忍具的仓库
-----------------------------
SmSilkBagWarehouse = class("SmSilkBagWarehouseClass", Window)

local sm_silkbags_warehouse_window_open_terminal = {
    _name = "sm_silkbags_warehouse_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmSilkBagWarehouse:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_silkbags_warehouse_window_open_terminal)
state_machine.init()

function SmSilkBagWarehouse:ctor()
    self.super:ctor()
    self.roots = {}
    self.prop_list = {}

    self.currentScrollView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    
    local function init_sm_silkbags_warehouse_terminal()
		--显示界面
		local sm_silkbags_warehouse_show_terminal = {
            _name = "sm_silkbags_warehouse_show",
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
		local sm_silkbags_warehouse_hide_terminal = {
            _name = "sm_silkbags_warehouse_hide",
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

        local sm_silkbags_warehouse_update_draw_terminal = {
            _name = "sm_silkbags_warehouse_update_draw",
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

		state_machine.add(sm_silkbags_warehouse_show_terminal)	
		state_machine.add(sm_silkbags_warehouse_hide_terminal)
        state_machine.add(sm_silkbags_warehouse_update_draw_terminal)

        state_machine.init()
    end
    init_sm_silkbags_warehouse_terminal()
end

function SmSilkBagWarehouse:onHide()
    local root = self.roots[1]
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_warehouse")
    m_ScrollView:removeAllChildren(true)
    self:setVisible(false)
    self:stopAllActions()
end

function SmSilkBagWarehouse:onShow()
    self:setVisible(true)
    self:onUpdateDraw()
end

function SmSilkBagWarehouse:getSortedCellDatas()
    --排序
    --1类型排序升序
    --2类型排序降序
    --3时间排序升序
    --4时间排序降序 
    local index = zstring.tonumber(readKey("sm_prop_ware_house_sort_index"))
    self.sortType = index ~= 0 and index or 1
    if fwin:find("SmPropWarehouseClass") then
        self.sortType = fwin:find("SmPropWarehouseClass").sortType
    end

    local sortedCellDatas = {}
    for i,v in ipairs(self:getSortedHeroes()) do
        v.enum_type = 6
        table.insert(sortedCellDatas, v)
    end
    -- for i,v in ipairs(self:getSortedEquips()) do
    --     v.enum_type = 7
    --     table.insert(sortedCellDatas, v)
    -- end
    -- for i,v in ipairs(self:getSortedSilkBags()) do
    --     v.enum_type = 71
    --     table.insert(sortedCellDatas, v)
    -- end
    if self.sortType < 3 then
        if self.sortType == 2 then
            local tmpDatas = {}
            for i = #sortedCellDatas, 1, -1 do
                table.insert(tmpDatas, sortedCellDatas[i])
            end
            sortedCellDatas = tmpDatas
        end
    else
        table.sort(sortedCellDatas, function (a, b)
            local timestampA = a.prop_timestamp
            local timestampB = b.prop_timestamp
            if not timestampA then
                if a.info and a.info.createTime then
                    timestampA = a.info.createTime
                else
                    timestampA = -1
                end
            end
            timestampA = tonumber(timestampA)

            if not timestampB then
                if b.info and b.info.createTime then
                    timestampB = b.info.createTime
                else
                    timestampB = -1
                end
            end
            timestampB = tonumber(timestampB)

            return timestampA > timestampB
        end)
        if self.sortType == 4 then
            local tmpDatas = {}
            for i = #sortedCellDatas, 1, -1 do
                table.insert(tmpDatas, sortedCellDatas[i])
            end
            sortedCellDatas = tmpDatas
        end
    end
    return sortedCellDatas
end

function SmSilkBagWarehouse:getSortedHeroes()
    local function fightingCapacity(a,b)
        local mouldTypeA = dms.int(dms["ship_silk_bag_mould"], tonumber(a.silkBagMouldId), ship_silk_bag_mould.mould_type) * 10000
        local mouldTypeB = dms.int(dms["ship_silk_bag_mould"], tonumber(b.silkBagMouldId), ship_silk_bag_mould.mould_type) * 10000

        local qualityA = dms.int(dms["ship_silk_bag_mould"], tonumber(a.silkBagMouldId), ship_silk_bag_mould.quality_level) * 500
        local qualityB = dms.int(dms["ship_silk_bag_mould"], tonumber(b.silkBagMouldId), ship_silk_bag_mould.quality_level) * 500

        local compareA = mouldTypeA + qualityA + a.silkBagMouldId
        local compareB = mouldTypeB + qualityB + b.silkBagMouldId

        local result = false
        if compareA > compareB then
            result = true
        end
        return result 
    end
     -- print("=============",showFormation)
    local tSortedHeroes = {}

    if _ED.silkbag_pack_info == nil then
         return tSortedHeroes
    end
    tSortedHeroes = self:getNoUseSkilBagInfo()

    table.sort(tSortedHeroes, fightingCapacity)
    return tSortedHeroes
end

function SmSilkBagWarehouse:getNoUseSkilBagInfo()
    local data = {}
    for k, v in pairs(_ED.silkbag_pack_info) do
        if tonumber(v.onUseIndex) == -1 then
            table.insert(data, {info = v, silkBagMouldId = tonumber(v.silkBagMouldId)})
        end
    end
    return data
end

function SmSilkBagWarehouse:onUpdateDraw()
    self.prop_list = {}
    local sortedCellDatas = self:getSortedCellDatas()
    local root = self.roots[1]
    local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_warehouse")
    local panel = m_ScrollView:getInnerContainer()

    local innerContainerPosition = panel:getPositionY()
    local innerContainerContentSize = panel:getContentSize()
    local height
    if innerContainerContentSize.height == m_ScrollView:getContentSize().height then
        height = innerContainerContentSize.height
        innerContainerPosition = -innerContainerContentSize.height
    else
        height = innerContainerContentSize.height - m_ScrollView:getContentSize().height
    end

    m_ScrollView:removeAllChildren(true)
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
    -- if __lua_project_id == __lua_project_l_digital then
    --     wPosition = sWidth/6
    -- end
    local Hlindex = 0
    local number = #sortedCellDatas
    local m_number = math.ceil(number/4)
    -- if __lua_project_id == __lua_project_l_digital then
    --     m_number = math.ceil(number/6)
    -- end
    cellHeight = m_number*(m_ScrollView:getContentSize().width/4)
    -- if __lua_project_id == __lua_project_l_digital then
    --     cellHeight = m_number*(m_ScrollView:getContentSize().width/6)
    -- end
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local first = nil
    for j, v in pairs(sortedCellDatas) do
        -- if j == 1 then
            local cell = state_machine.excute("sm_packs_cell", 0, {v, 0, nil, 71, nil, j})
            panel:addChild(cell)
            table.insert(self.prop_list, cell)
            if j == 1 then
                first = cell
            end
            tWidth = tWidth + wPosition
            -- if __lua_project_id == __lua_project_l_digital then
            --     if (j-1)%6 ==0 then
            --         Hlindex = Hlindex+1
            --         tWidth = 0
            --         tHeight = sHeight - wPosition*Hlindex  
            --     end
            --     if j <= 6 then
            --         tHeight = sHeight - wPosition
            --     end
            -- else
                if (j-1)%4 ==0 then
                    Hlindex = Hlindex+1
                    tWidth = 0
                    tHeight = sHeight - wPosition*Hlindex  
                end
                if j <= 4 then
                    tHeight = sHeight - wPosition
                end
            --end
            cell:setPosition(cc.p(tWidth,tHeight))
        -- else
        --     self:runAction(cc.Sequence:create({cc.DelayTime:create((j-1)*0.05), cc.CallFunc:create(function ( sender )
        --         local cell = state_machine.excute("sm_packs_cell",0,{v,0})
        --         panel:addChild(cell)
        --         table.insert(self.prop_list, cell)
        --         if j == 1 then
        --             first = cell
        --         end
        --         tWidth = tWidth + wPosition
        --         if (j-1)%4 ==0 then
        --             Hlindex = Hlindex+1
        --             tWidth = 0
        --             tHeight = sHeight - wPosition*Hlindex  
        --         end
        --         if j <= 4 then
        --             tHeight = sHeight - wPosition
        --         end
        --         cell:setPosition(cc.p(tWidth,tHeight))
        --     end)})) 
        -- end
    end
    m_ScrollView:jumpToPercentVertical((1 - (-innerContainerPosition / height)) * 100)

    self.currentScrollView = m_ScrollView
    self.currentInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    --调用一次onUpdate
    self.currentInnerContainerPosY = self.currentInnerContainerPosY + 1
end

function SmSilkBagWarehouse:onUpdate(dt)
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

function SmSilkBagWarehouse:onEnterTransitionFinish()

end

function SmSilkBagWarehouse:onInit( )
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

function SmSilkBagWarehouse:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmSilkBagWarehouse:onExit()
    state_machine.remove("sm_silkbags_warehouse_show")    
    state_machine.remove("sm_silkbags_warehouse_hide")
    state_machine.remove("sm_silkbags_warehouse_update_draw")
end
