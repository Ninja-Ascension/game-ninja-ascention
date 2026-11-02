LimSummonViewPreview = class("LimSummonViewPreviewClass", Window)

-- 打开窗口
local lim_summon_view_preview_window_open_terminal = {
    _name = "lim_summon_view_preview_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("LimSummonViewPreviewClass") then
            fwin:open(LimSummonViewPreview:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local lim_summon_view_preview_window_close_terminal = {
    _name = "lim_summon_view_preview_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LimSummonViewPreviewClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(lim_summon_view_preview_window_open_terminal)
state_machine.add(lim_summon_view_preview_window_close_terminal)
state_machine.init()

function LimSummonViewPreview:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.currentScrollViewInnerContainer = nil
	self.currentScrollViewInnerContainerPosY  = 0

    local function init_lim_summon_view_preview_terminal()
        
        local lim_summon_view_preview_close_terminal = 
        {
            _name = "lim_summon_view_preview_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("LimSummonViewPreviewClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(lim_summon_view_preview_close_terminal)
        
        state_machine.init()
    end

    init_lim_summon_view_preview_terminal()
end

function LimSummonViewPreview:init(params)
    self.params = params
    
    self:initData()
    
    if nil ~= self.onInit then
        self:onInit(params)
    end

    return self
end

function LimSummonViewPreview:onUpdate(dt)

end

function LimSummonViewPreview:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/lim_summon/lim_summon_reward.csb")
    self:addChild(csbNode)

    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)

    -- 定义按钮控件
    self.btnClose = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
    {
        terminal_name = "lim_summon_view_preview_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    self:onUpdateDraw()
    self:showData()
end

function LimSummonViewPreview:onUpdateDraw()
    local root = self.roots[1]

    -- 定义除按钮外的其他UI控件
    self.ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
end

function LimSummonViewPreview:initData()
    -- 更新数据
    self.idActivity = self.params

    self.lstPreview, self.allWeight = LimSummonMgr:GetInstance():getActivityPreviewLst(self.idActivity)
end

function LimSummonViewPreview:showData()
    -- 更新显示
    self.ScrollView_1:removeAllChildren(true)
    
    local Column = 4

    local cellList = {}
    for i, v in ipairs(self.lstPreview) do
        local infoPreview = v
        infoPreview.allWeight = self.allWeight

        local cell = LimSummonCellPreview:new()
        cell:init(infoPreview, i)
        table.insert(cellList, cell)
    end

    local info = {}
    info.targetScrollView = self.ScrollView_1
    info.nodeList = cellList
    info.columns = Column
    
    addNodeToScrollView(info)

    self.currentScrollViewInnerContainer = self.ScrollView_1:getInnerContainer()
    self.currentScrollViewInnerContainerPosY = self.currentScrollViewInnerContainer:getPositionY()
end

function LimSummonViewPreview:onUpdate(dt)
    if self.ScrollView_1 ~= nil and self.currentScrollViewInnerContainer ~= nil then
        local size = self.ScrollView_1:getContentSize()
        local posY = self.currentScrollViewInnerContainer:getPositionY()
        if self.currentScrollViewInnerContainerPosY == posY then
            return
        end
        self.currentScrollViewInnerContainerPosY = posY
        local items = self.ScrollView_1:getChildren()
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

function LimSummonViewPreview:onExit()
    state_machine.remove("lim_summon_view_preview_close")
end

function LimSummonViewPreview:close()

end

function LimSummonViewPreview:destroy(window)
 
end