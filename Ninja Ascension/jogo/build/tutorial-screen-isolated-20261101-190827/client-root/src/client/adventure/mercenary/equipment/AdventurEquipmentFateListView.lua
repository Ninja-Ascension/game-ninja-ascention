-- ----------------------------------------------------------------------------------------------------
-- 说明：宿命武器列表
-------------------------------------------------------------------------------------------------------
AdventurEquipmentFateListView = class("AdventurEquipmentFateListViewClass", Window)
    
function AdventurEquipmentFateListView:ctor()
    self.super:ctor()
    self.roots = {}
    self.hero = nil
    
    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0

    app.load("client.adventure.cells.equip.adventure_equip_list_cell")
    -- Initialize adventure mercenary hero explode state machine.
    local function init_adventure_equipment_fate_list_view_terminal()
        state_machine.init()
    end
    
    -- call func init adventure equipment fate list view state machine.
    init_adventure_equipment_fate_list_view_terminal()
end

function AdventurEquipmentFateListView:init(hero)
    self.hero = hero 
    return self
end


function AdventurEquipmentFateListView:onUpdate(dt)
    -- if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
    --     local size = self.currentListView:getContentSize()
    --     local posY = self.currentInnerContainer:getPositionY()
    --     if self.currentInnerContainerPosY == posY then
    --         return
    --     end
    --     self.currentInnerContainerPosY = posY
    --     local items = self.currentListView:getItems()
    --     if items[1] == nil then
    --         return
    --     end
    --     local itemSize = items[1]:getContentSize()
    --     for i, v in pairs(items) do
    --         local tempY = v:getPositionY() + posY
    --         if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
    --             v:unload()
    --         else
    --             v:reload()
    --         end
    --     end
    -- end
end

function AdventurEquipmentFateListView:onEnterTransitionFinish()
    local csbAdventurEquipmentFateListView = csb.createNode("packs/Mercenary/weapon_list.csb")
    local root = csbAdventurEquipmentFateListView:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventurEquipmentFateListView)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventurEquipmentFateListViewClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- 排序算法
    local sortFunc = function( cell1, cell2 )
        return cell2._flag > cell1._flag
    end
    local cells = {}
    -- 绘制列表
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
    listView:removeAllItems()
    local equipment_list = zstring.split(dms.string(dms["pirates_config"], 309, pirates_config.param), ",")
    for i, v in pairs(equipment_list) do
        local cell = AdventureEquipListCell:createCell()
        cell:init(fundEquipWidthId(v) or {user_equiment_template = v}, i , self.hero)
        table.insert(cells,cell)
        if zstring.tonumber(cell.equip.ship_id) > 0 then
           cell._flag = 0
           self.selectCell = cell
        else
            if zstring.tonumber(cell.equip.user_equiment_id) <=0 then
                -- 未拥有的 就按照ID 大小排序
                cell._flag = tonumber(v)
            else
                --- 拥有的
                cell._flag = 1
            end
        end
    end
    table.sort(cells, sortFunc)
    for i, v in pairs(cells) do
        listView:addChild(v)
    end
    self.currentListView = listView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventurEquipmentFateListView:onExit()

end
