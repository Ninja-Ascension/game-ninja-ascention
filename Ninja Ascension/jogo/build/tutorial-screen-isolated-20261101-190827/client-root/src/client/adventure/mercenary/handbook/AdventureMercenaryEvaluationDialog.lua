-- ----------------------------------------------------------------------------------------------------
-- 说明：图鉴评论对话框
-------------------------------------------------------------------------------------------------------
AdventureMercenaryEvaluationDialog = class("AdventureMercenaryEvaluationDialogClass", Window)
    
function AdventureMercenaryEvaluationDialog:ctor()
    self.super:ctor()
    self.roots = {}
    self.ship_id = 0 
    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0

    app.load("client.adventure.cells.handbook.adventure_handbook_evaluation_list_cell")
    -- Initialize adventure mercenary equipment fate state machine.
    local function init_adventure_mercenary_evaluation_terminal()
       
        --打开添加评论对话框
        local adventure_mercenary_equipment_evaluation_add_terminal = {
            _name = "adventure_mercenary_equipment_evaluation_add",
            _init = function (terminal)
                app.load("client.adventure.mercenary.handbook.AdventureMercenaryAddEvaluationDialog")            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureMercenaryAddEvaluationDialog:new():init(instance.ship_id), fwin._dialog)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --刷新列表
        local adventure_mercenary_equipment_evaluation_update_terminal = {
            _name = "adventure_mercenary_equipment_evaluation_update",
            _init = function (terminal)
                app.load("client.adventure.mercenary.handbook.AdventureMercenaryAddEvaluationDialog")            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:initListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_mercenary_equipment_evaluation_add_terminal) 
        state_machine.add(adventure_mercenary_equipment_evaluation_update_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mercenary equipment fate state machine.
    init_adventure_mercenary_evaluation_terminal()
end

function AdventureMercenaryEvaluationDialog:init(shipid)
    self.ship_id = shipid
    return self
end

function AdventureMercenaryEvaluationDialog:initListView()
    local root = self.roots[1]
    local ListView_plun = ccui.Helper:seekWidgetByName(root, "ListView_pinglun")
    
    ListView_plun:removeAllItems()
    local _nCount = 0
    for i,w in pairs(_ED.ship_detail) do
        local cell = AdventureHandbookEvaluationListCell:createCell()
        cell:init(w, i)
        ListView_plun:addChild(cell)
        _nCount = _nCount + 1
        ListView_plun:requestRefreshView()
    end
    if _nCount > 0 then 
        ccui.Helper:seekWidgetByName(root, "Text_dp"):setVisible(false)
    else
        ccui.Helper:seekWidgetByName(root, "Text_dp"):setVisible(true)
    end
    ListView_plun:jumpToTop()    

    self.currentListView = ListView_plun
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY() 
end

function AdventureMercenaryEvaluationDialog:onUpdate(dt)
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
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function AdventureMercenaryEvaluationDialog:onEnterTransitionFinish()
    local csbAdventureMercenaryplun = csb.createNode("packs/Mercenary/yongbing_pinglun.csb")
    local root = csbAdventureMercenaryplun:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureMercenaryplun)

    -- 创建顶部列表窗口
    self:initListView()

    --添加评论
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tianjia"),       nil, 
    {
        terminal_name = "adventure_mercenary_equipment_evaluation_add",   
        terminal_state = 0, 
        isPressedActionEnabled = false
    }, 
    nil, 0)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7"),       nil, 
    {
        func_string = [[fwin:close(fwin:find("AdventureMercenaryEvaluationDialogClass"))]],       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function AdventureMercenaryEvaluationDialog:onExit()
    state_machine.remove("adventure_mercenary_equipment_evaluation_add")
end


