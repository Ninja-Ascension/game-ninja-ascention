-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏副关卡场景界面
-------------------------------------------------------------------------------------------------------
ConstellationPageCell = class("ConstellationPageCellClass", Window)

function ConstellationPageCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.page = 0
    app.load("client.l_digital.cells.cultivate.constellation.constellation_cell")
end

function ConstellationPageCell:init(params)
    if params then
        self.page = params
    end
    self:onInit()
end

function ConstellationPageCell:onUpdateDraw()
    local root = self.roots[1]
    root:setSwallowTouches(false)
    local Panel_star_lock = ccui.Helper:seekWidgetByName(root,"Panel_star_lock")
    local Text_star_lock_n = ccui.Helper:seekWidgetByName(root,"Text_star_lock_n")
    local need_level = dms.int(dms["constellation_mould"], self.page, constellation_mould.constellation_open_level)
    if need_level > tonumber(_ED.user_info.user_grade) then
        Panel_star_lock:setVisible(true)
        Text_star_lock_n:setString(string.format(tipStringInfo_constellation_tips[2], need_level))
    else
        local ship_group_id = dms.string(dms["constellation_mould"], self.page, constellation_mould.constellation_ship_id)
        local ship_ids = zstring.split(ship_group_id, ",")
        for i, id in ipairs(ship_ids) do
            local panel_cell = ccui.Helper:seekWidgetByName(root,"Panel_star_card_" .. i)
            panel_cell:setSwallowTouches(false)
            local cell = ConstellationCell:createCell()
            cell:init({id, self.page, i})
            cell:setName("constellation_cell")
            panel_cell:addChild(cell)
        end
    end
end


function ConstellationPageCell:showEnterAction( ... )
    local root = self.roots[1]
end

function ConstellationPageCell:onEnterTransitionFinish()
end

function ConstellationPageCell:onInit()
    local csbItem = csb.createNode("cultivate/constellation_page_cell.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    self:onUpdateDraw()
end

function ConstellationPageCell:unLoad()
    local root = self.roots[1]
    if root == nil then
        return
    end
end

function ConstellationPageCell:onExit()
end
-----------------------------------------
function ConstellationPageCell:createCell()
    local cell = ConstellationPageCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end
-----------------------------------------