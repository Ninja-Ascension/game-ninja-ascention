-- ----------------------------------------------------------------------------------------------------
-- 说明：强化装备选择吞噬界面
-------------------------------------------------------------------------------------------------------
SmEquipmentQianghuaAdd = class("SmEquipmentQianghuaAddClass", Window)

local sm_equipment_qianghua_add_open_terminal = {
    _name = "sm_equipment_qianghua_add_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmEquipmentQianghuaAddClass")
        if nil == _homeWindow then
            local panel = SmEquipmentQianghuaAdd:new():init(params)
            fwin:open(panel,fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_equipment_qianghua_add_close_terminal = {
    _name = "sm_equipment_qianghua_add_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local isChoose = params._datas.isChoose
		local _homeWindow = fwin:find("SmEquipmentQianghuaAddClass")
        if nil ~= _homeWindow then
            if isChoose == true then
                state_machine.excute("sm_equipment_qianghua_add_set_content", 0, "")
            else
                _homeWindow.swallow_number = 0
                for i, v in pairs(_homeWindow.swallow_the_array_instanceId_R) do
                    local equipId = tonumber(v)
                    if equipId > 0 then
                        for _, equip in pairs(_ED.user_equiment) do
                           if tonumber(equip.user_equiment_id) == equipId then
                                _homeWindow.swallow_the_array[i] = equip.user_equiment_template
                                break
                            end
                        end
                        _homeWindow.swallow_the_array_instanceId[i] = v
                        _homeWindow.swallow_number = _homeWindow.swallow_number + 1
                    else
                        _homeWindow.swallow_the_array[i] = "0"
                        _homeWindow.swallow_the_array_instanceId[i] = "0"
                    end
                end
            end
    		fwin:close(fwin:find("SmEquipmentQianghuaAddClass"))
        end
        
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_equipment_qianghua_add_open_terminal)
state_machine.add(sm_equipment_qianghua_add_close_terminal)
state_machine.init()
    
function SmEquipmentQianghuaAdd:ctor()
    self.super:ctor()
    self.roots = {}
    self.needEquip = {}
    self.equipNumber = {}

    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0

    app.load("client.cells.utils.multiple_list_view_cell")
    app.load("client.cells.treasure.sm_treasure_swallowed_cell")
    local function init_sm_equipment_qianghua_add_terminal()
        -- 显示界面
        local sm_equipment_qianghua_add_display_terminal = {
            _name = "sm_equipment_qianghua_add_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmEquipmentQianghuaAddWindow = fwin:find("SmEquipmentQianghuaAddClass")
                if SmEquipmentQianghuaAddWindow ~= nil then
                    SmEquipmentQianghuaAddWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_equipment_qianghua_add_hide_terminal = {
            _name = "sm_equipment_qianghua_add_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmEquipmentQianghuaAddWindow = fwin:find("SmEquipmentQianghuaAddClass")
                if SmEquipmentQianghuaAddWindow ~= nil then
                    SmEquipmentQianghuaAddWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭后设置内容
        local sm_equipment_qianghua_add_set_content_terminal = {
            _name = "sm_equipment_qianghua_add_set_content",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("sm_equipment_tab_up_product_set_swallowed_list",0,{instance.swallow_the_array,instance.swallow_number,instance.equip.useExp}) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --cell选择后的数据刷新
        local sm_equipment_qianghua_add_cell_set_data_terminal = {
            _name = "sm_equipment_qianghua_add_cell_set_data",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.swallow_the_array = params[1]
                instance.swallow_number = params[2]
                instance.equip.useExp = params[3]
                instance:numberOfRecords()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_equipment_qianghua_add_display_terminal)
        state_machine.add(sm_equipment_qianghua_add_hide_terminal)
        state_machine.add(sm_equipment_qianghua_add_set_content_terminal)
        state_machine.add(sm_equipment_qianghua_add_cell_set_data_terminal)
        
        state_machine.init()
    end
    init_sm_equipment_qianghua_add_terminal()
end
--获取道具并且设置滚动层
function SmEquipmentQianghuaAdd:setPropSetScrollView()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    local function fightingCapacity(a,b)
        local al = tonumber(a.user_equiment_template)
        local bl = tonumber(b.user_equiment_template)
        local result = false
        if al < bl then
            result = true
        end
        return result 
    end

    --装备位
    local e_index = self.equip.m_index
    if tonumber(e_index) == 5 then
         for i, equip in pairs(_ED.user_equiment) do
            if tonumber(equip.equipment_type) == 4 then
                local giveExp = dms.int(dms["equipment_mould"] ,tonumber(equip.user_equiment_template) ,equipment_mould.initial_supply_escalate_exp)
                if giveExp > 0 then
                    table.insert(self.needEquip, equip)
                end
            end
        end
    elseif tonumber(e_index) == 6 then
        for i, equip in pairs(_ED.user_equiment) do
            if tonumber(equip.equipment_type) == 5 then
                local giveExp = dms.int(dms["equipment_mould"] ,tonumber(equip.user_equiment_template) ,equipment_mould.initial_supply_escalate_exp)
                if giveExp > 0 then
                    table.insert(self.needEquip, equip)
                end
            end
        end
    end
    table.sort(self.needEquip, fightingCapacity)

    local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    ListView_1:removeAllItems()
    local preMultipleCell = nil
    local multipleCell = nil
    for i,v in pairs(self.needEquip) do
        local isSelected = false
        -- for k1,v1 in pairs(self.swallow_the_array) do
        for k1,v1 in pairs(self.swallow_the_array_instanceId) do
            if tonumber(v.user_equiment_id) == tonumber(v1) then
                isSelected = true
                break
            end
        end
        local cell = state_machine.excute("sm_treasure_swallowed_cell",0,{self.needEquip[i],isSelected,self.swallow_the_array,self.swallow_number,self.equip,i, self.swallow_the_array_instanceId})
        if multipleCell == nil then
            multipleCell = MultipleListViewCell:createCell()
            multipleCell:init(ListView_1, SmTreasureSwallowedCell.__size)
            ListView_1:addChild(multipleCell)
            multipleCell.prev = preMultipleCell
            if preMultipleCell ~= nil then
                preMultipleCell.next = multipleCell
            end
        end
        multipleCell:addNode(cell)
        if multipleCell.child2 ~= nil then
            preMultipleCell = multipleCell
            multipleCell = nil
        end
    end
    ListView_1:requestRefreshView()
    self.currentListView = ListView_1
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()

    -- local Image_skill_bg_2 = ccui.Helper:seekWidgetByName(root, "Image_skill_bg_2")
    -- local m_ScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_equ")
    -- m_ScrollView:removeAllChildren(true)
    -- local panel = ccui.Layout:create()
    -- panel:setContentSize(m_ScrollView:getContentSize())
    -- panel:setName("cellPanel")
    -- panel:setPosition(cc.p(0,0))
    -- panel:removeAllChildren(true)
    -- m_ScrollView:addChild(panel)
    -- local height = m_ScrollView:getContentSize().height
    -- local number = #self.needEquip
    -- if number/2 > 0 then
    --     height = math.ceil(number/2)*height
    -- else
    --     height = height
    -- end
    -- if height < Image_skill_bg_2:getContentSize().height-12 then
    --     height = Image_skill_bg_2:getContentSize().height-12
    -- end
    -- local upHeight = 0 
    -- panel:setContentSize(cc.size(m_ScrollView:getContentSize().width, height))
    -- if height > m_ScrollView:getContentSize().height then
    --     m_ScrollView:setContentSize(cc.size(panel:getContentSize().width,Image_skill_bg_2:getContentSize().height-12))
    -- end

    -- local sSize = panel:getContentSize()
    -- local controlSize = m_ScrollView:getContentSize()
    -- local cellWidth = sSize.width / 2
    -- local isUse = {0,0,0,0}
    -- for i = 1, #self.needEquip do
    --     local cell = nil
    --     local isSelected = false
    --     for j=1, 4 do
    --         if isUse[j] ~= 1 then
    --             if tonumber(self.needEquip[i].user_equiment_template) == tonumber(self.swallow_the_array[j]) then
    --                 isSelected = true
    --                 isUse[j] = 1
    --                 break
    --             end
    --         end
    --     end
    --     cell = state_machine.excute("sm_treasure_swallowed_cell",0,{self.needEquip[i],isSelected,self.swallow_the_array,self.swallow_number,self.equip}) 
    --     local cellHeight = cell:getContentSize().height
    --     local row = math.floor((i - 1) / 2 + 1)
    --     local col = math.floor((i - 1) % 2)
    --     local controlHeight = row * cellHeight
    --     if controlHeight < sSize.height then
    --         controlSize.height = sSize.height
    --     else
    --         controlSize.height = controlHeight
    --     end
    --     local pos = cc.p(cellWidth * col + (cellWidth - cell:getContentSize().width)/2,sSize.height - cellHeight * row)
    --     cell:setPosition(pos)
    --     cell.panel = panel
    --     panel:addChild(cell)
    -- end
    -- m_ScrollView:setInnerContainerSize(panel:getContentSize())

end

function SmEquipmentQianghuaAdd:onUpdate(dt)
    if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentListView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentListView:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height/2 < 0 or tempY > size.height + itemSize.height/2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function SmEquipmentQianghuaAdd:numberOfRecords()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local Text_skill_lv_n = ccui.Helper:seekWidgetByName(root,"Text_skill_lv_n")
    local number = 0 
    for i=1, #self.swallow_number do
        if tonumber(self.swallow_number[i]) > 0 then
            number = number + 1
        end
    end
    Text_skill_lv_n:setString(number.."/4")
end

function SmEquipmentQianghuaAdd:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    self:setPropSetScrollView()
    self:numberOfRecords()
end

function SmEquipmentQianghuaAdd:init(params)
    self.equip = params[1]
    self.swallow_the_array = params[2]
    self.swallow_number = params[3]
    self.swallow_the_array_instanceId = params[4]
    self.swallow_the_array_instanceId_R = {}
    table.merge(self.swallow_the_array_instanceId_R, self.swallow_the_array_instanceId)
    self:onInit()
    return self
end

function SmEquipmentQianghuaAdd:onInit()
    local csbSmEquipmentQianghuaAdd = csb.createNode("packs/EquipStorage/sm_equipment_qianghua_add.csb")
    local root = csbSmEquipmentQianghuaAdd:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmEquipmentQianghuaAdd)
	
    self:onUpdateDraw()
    
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_equipment_qianghua_add_close",
        terminal_state = 0,
        touch_black = true,
        isChoose = false,
    },
    nil,3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ok"), nil, 
    {
        terminal_name = "sm_equipment_qianghua_add_close",
        terminal_state = 0,
        touch_black = true,
        isChoose = true,
    },
    nil,3)

end

function SmEquipmentQianghuaAdd:onExit()
    state_machine.remove("sm_equipment_qianghua_add_display")
    state_machine.remove("sm_equipment_qianghua_add_hide")
    
end