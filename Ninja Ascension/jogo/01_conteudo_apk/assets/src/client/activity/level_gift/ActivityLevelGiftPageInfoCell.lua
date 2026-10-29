----------------------------------------------------------------------------------------------------
-- 说明：等级礼包cell
-------------------------------------------------------------------------------------------------------

ActivityLevelGiftPageInfoCell = class("ActivityLevelGiftPageInfoCellClass", Window)
    
function ActivityLevelGiftPageInfoCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.mouldId = 0
    self.function_id = 0
    self.button_go = nil
    self._cell = nil
    app.load("client.activity.level_gift.ActivityLevelGiftPageViewCell")
    -- Initialize all server welfare activity page state machine.
    local function init_activity_level_gift_pageview_cell_terminal()    
    end
    
    -- call func init all server welfare activity state machine.
    init_activity_level_gift_pageview_cell_terminal()
end

function ActivityLevelGiftPageInfoCell:onInit()
    local csbActivityLevelGiftPageInfoCell = csb.createNode("activity/wonderful/activity_Levelpacks_page_1.csb")
    self:addChild(csbActivityLevelGiftPageInfoCell)

    local root = csbActivityLevelGiftPageInfoCell:getChildByName("root")
    table.insert(self.roots, root)
    
    --self:setContentSize(cc.size(80,248))
    self:setContentSize(ccui.Helper:seekWidgetByName(root, "Panel_page"):getContentSize())
    self:onUpdateDraw()
end

function ActivityLevelGiftPageInfoCell:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local Panel = ccui.Helper:seekWidgetByName(root, "Panel_page")
    Panel:removeAllChildren(true)
    local cell = ActivityLevelGiftPageViewCell:createCell()
    cell:init(self.mouldId)
    Panel:addChild(cell)
    self._cell = cell
end

function ActivityLevelGiftPageInfoCell:setBGColor(types)
    local root = self.roots[1]
    if types == 1 then 
        self._cell:setBGColor(types)
        root:setScale(0.90)
    else 
        self._cell:setBGColor(types)
        root:setScale(1)
    end
end

function ActivityLevelGiftPageInfoCell:onEnterTransitionFinish()
   
end

function ActivityLevelGiftPageInfoCell:onExit()
	
end

function ActivityLevelGiftPageInfoCell:init(id)
    self.mouldId = id
    self:onInit()
end

function ActivityLevelGiftPageInfoCell:createCell()
    local cell = ActivityLevelGiftPageInfoCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end