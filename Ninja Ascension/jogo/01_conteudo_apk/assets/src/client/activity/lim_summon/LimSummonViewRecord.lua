LimSummonViewRecord = class("LimSummonViewRecordClass", Window)

-- 打开窗口
local lim_summon_view_record_window_open_terminal = {
    _name = "lim_summon_view_record_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local idActivity = params

        local function callbackRecord()
            if nil == fwin:find("LimSummonViewRecordClass") then
                fwin:open(LimSummonViewRecord:new():init(idActivity), fwin._view)
            end
        end

        LimSummonMgr:GetInstance():RequestViewRecord(idActivity, callbackRecord, "lim_summon_view_record_window_open")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local lim_summon_view_record_window_close_terminal = {
    _name = "lim_summon_view_record_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LimSummonViewRecordClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(lim_summon_view_record_window_open_terminal)
state_machine.add(lim_summon_view_record_window_close_terminal)
state_machine.init()

function LimSummonViewRecord:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_lim_summon_view_record_terminal()
        
        local lim_summon_view_record_close_terminal = 
        {
            _name = "lim_summon_view_record_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("LimSummonViewRecordClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local lim_summon_view_record_page_terminal = 
        {
            _name = "lim_summon_view_record_page",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local data = params._datas.info
                if instance then
                    instance:changePage(data)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(lim_summon_view_record_close_terminal)
        state_machine.add(lim_summon_view_record_page_terminal)
        
        state_machine.init()
    end

    init_lim_summon_view_record_terminal()
end

function LimSummonViewRecord:init(params)
    self.params = params
    
    self:initData()
    
    if nil ~= self.onInit then
        self:onInit(params)
    end

    return self
end

function LimSummonViewRecord:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/lim_summon/lim_summon_record.csb")
    self:addChild(csbNode)

    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)

    -- 定义按钮控件
    self.Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
    {
        terminal_name = "lim_summon_view_record_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)
    
    -- 左1页签按钮
    self.Button_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"), nil,
    {
        terminal_name = "lim_summon_view_record_page",
        terminal_state = 0,
        isPressedActionEnabled = true,
        info = -2,
    }, nil, 0)

    -- 左2页签按钮
    self.Button_4 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_4"), nil,
    {
        terminal_name = "lim_summon_view_record_page",
        terminal_state = 0,
        isPressedActionEnabled = true,
        info = -1,
    }, nil, 0)

    -- 左3页签按钮
    self.Button_5 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_5"), nil,
    {
        terminal_name = "lim_summon_view_record_page",
        terminal_state = 0,
        isPressedActionEnabled = true,
        info = 1,
    }, nil, 0)

    -- 左4页签按钮
    self.Button_6 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_6"), nil,
    {
        terminal_name = "lim_summon_view_record_page",
        terminal_state = 0,
        isPressedActionEnabled = true,
        info = 2,
    }, nil, 0)

    self:onUpdateDraw()
    self:showData()
end

function LimSummonViewRecord:onUpdateDraw()
    local root = self.roots[1]

    -- 定义除按钮外的其他UI控件

    -- 当前页码
    self.Text_6 = ccui.Helper:seekWidgetByName(root, "Text_6")
    -- 总页码数
    self.Text_4 = ccui.Helper:seekWidgetByName(root, "Text_4")

    self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    self.currentListView = self.ListView_1
end

function LimSummonViewRecord:initData()
    -- 更新数据
    self.idActivity = self.params

    -- 记录总数
    self.countRecord = LimSummonMgr:GetInstance():getActivityRecordCount(self.idActivity)

    -- 记录表
    self.lstRecord = LimSummonMgr:GetInstance():getActivityRecordLst(self.idActivity)

    -- 总数量
    self.nMaxCountRecord = LimSummonMgr:GetInstance().nMaxCountRecord

    -- 每页的元素数量
    self.nPerCountPageRecord = LimSummonMgr:GetInstance().nPerCountPageRecord

    -- 当前页码
    self.curPage = 0

    self.maxPage = math.ceil(self.countRecord / self.nPerCountPageRecord)
    if self.maxPage <= 0 then 
        self.maxPage = 1
    end
end

function LimSummonViewRecord:showData()
    -- 更新显示
    self:jumpToPage(1)
end

function LimSummonViewRecord:changePage(data)
    local curPage = 1
    if data == -2 then
        curPage = 1
    elseif data == -1 then
        curPage = self.curPage - 1
        if curPage < 1 then
            curPage = 1
        end
    elseif data == 1 then
        curPage = self.curPage + 1
        if curPage > self.maxPage then
            curPage = self.maxPage
        end
    elseif data == 2 then
        curPage = self.maxPage
    else
        curPage = 1
    end

    self:jumpToPage(curPage)
end

function LimSummonViewRecord:jumpToPage(page)
    if self.curPage == page then
        return
    end

    self.curPage = page
    self:showPageNum()
    self:showPageLst()
end

function LimSummonViewRecord:showPageLst()
    local startIndex = (self.curPage - 1) * self.nPerCountPageRecord + 1
    local endIndex = startIndex + self.nPerCountPageRecord - 1

    if endIndex > self.countRecord then
        endIndex = self.countRecord
    end

    self.currentListView:removeAllItems()
    for i = startIndex, endIndex do
        local infoRecord = self.lstRecord[i]
        local cell = LimSummonCellRecord:new()
        cell:init(infoRecord)
        if i%2 == 1 then
            cell:showImg(true)
        else
            cell:showImg(false)
        end
        self.currentListView:addChild(cell)
    end
    self.currentListView:jumpToTop()
    self.currentListView:requestRefreshView()
end

function LimSummonViewRecord:showPageNum()
    self.Text_6:setString(""..self.curPage)
    self.Text_4:setString(""..self.maxPage)
end

function LimSummonViewRecord:onExit()
    state_machine.remove("lim_summon_view_record_close")
    state_machine.remove("lim_summon_view_record_page")
end

function LimSummonViewRecord:close()

end

function LimSummonViewRecord:destroy(window)
 
end