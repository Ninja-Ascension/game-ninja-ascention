-----------------------------
-- 新招募奖励预览
-----------------------------
NewRecruitPreviewWindow = class("NewRecruitPreviewWindowClass", Window)

local new_recruit_preview_window_open_terminal = {
    _name = "new_recruit_preview_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if nil == fwin:find("NewRecruitPreviewWindowClass") then
            local panel = NewRecruitPreviewWindow:new():init(params)
            fwin:open(panel, fwin._ui)
        end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local new_recruit_preview_window_close_terminal = {
    _name = "new_recruit_preview_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local activityWindow = fwin:find("NewRecruitPreviewWindowClass")
        fwin:close(activityWindow)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(new_recruit_preview_window_open_terminal)
state_machine.add(new_recruit_preview_window_close_terminal)
state_machine.init()

function NewRecruitPreviewWindow:ctor()
    self.super:ctor()
    self.roots = {}
    
    -- 定义变量
    self._current_page = 0      -- 当前页签
    self.Button_page = {}       -- 存放页签按钮
    self.Text_page = {}         -- 存放页签文本
    self._page_table = {}

    self.rewardsInfo = {}       -- 奖励预览信息

    -- 加载lua文件
    app.load("client.shop.newrecruit.NewRecruitPreviewWindowTab")

    -- 初始化状态机
    local function init_new_recruit_preview_window_terminal()
        -- 刷新
        local new_recruit_preview_window_update_draw_terminal = {
            _name = "new_recruit_preview_window_update_draw",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local new_recruit_preview_window_change_page_terminal = {
            _name = "new_recruit_preview_window_change_page",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(new_recruit_preview_window_update_draw_terminal)
        state_machine.add(new_recruit_preview_window_change_page_terminal)
        state_machine.init()
    end
    init_new_recruit_preview_window_terminal()
end

-- 切换页面
function NewRecruitPreviewWindow:changeSelectPage( page )
    local root = self.roots[1]
    if page == self._current_page then
        return
    end
    self._current_page = page
    for i, v in ipairs(self.Button_page) do
        if i == page then
            v:setTouchEnabled(false)
            v:setHighlighted(true)
            self.Text_page[i]:setVisible(true)
        else
            v:setTouchEnabled(true)
            v:setHighlighted(false)
            self.Text_page[i]:setVisible(false)
        end
    end

    local Panel_yulan = ccui.Helper:seekWidgetByName(root, "Panel_tab")
    -- 先将所有的界面都隐藏掉
    for k, v in pairs(self._page_table) do
        state_machine.excute("new_recruit_preview_window_tab_hide", 0, v)
    end

    if self._page_table[""..page] == nil then
        self._page_table[""..page] = state_machine.excute("new_recruit_preview_window_tab_open", 0, {Panel_yulan, page})
    else
        state_machine.excute("new_recruit_preview_window_tab_show", 0, self._page_table[""..page])
    end
end

function NewRecruitPreviewWindow:initUI()
    for i, v in ipairs(self.Button_page) do
        v:setTouchEnabled(false)
        v:setHighlighted(true)
        v:setVisible(true)
    end
    for i, v in ipairs(self.Text_page) do
        v:setVisible(false)
    end
    self:changeSelectPage(1)
end

function NewRecruitPreviewWindow:onEnterTransitionFinish()
    local csbItem = csb.createNode("shop/new_recruit_preview.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 保底奖励
	self.Button_min = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_baodi"), nil,
	{
		terminal_name = "new_recruit_preview_window_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
        _page = 1
	}, nil, 0)	
    table.insert(self.Button_page, self.Button_min)
    -- 高级奖励
	self.Button_senior = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gaoji"), nil,
	{
		terminal_name = "new_recruit_preview_window_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
        _page = 2
	}, nil, 0)	
    table.insert(self.Button_page, self.Button_senior)

    -- 普通奖励
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_putong"), nil,
	{
		terminal_name = "new_recruit_preview_window_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
        _page = 3
	}, nil, 0)	
    table.insert(self.Button_page, self.Button_closed)

    -- 关闭按钮
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_2"), nil, 
    {
        terminal_name = "new_recruit_preview_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    -- 保底文本
    self.Text_baodi = ccui.Helper:seekWidgetByName(root, "Text_baodi_2")
    table.insert(self.Text_page, self.Text_baodi)

    -- 高级文本
    self.Text_gaoji = ccui.Helper:seekWidgetByName(root, "Text_gaoji_2")
    table.insert(self.Text_page, self.Text_gaoji)

    -- 普通文本
    self.Text_putong = ccui.Helper:seekWidgetByName(root, "Text_putong_2")
    table.insert(self.Text_page, self.Text_putong)

    self:initUI()

end

function NewRecruitPreviewWindow:onInit( )
    
    
end

function NewRecruitPreviewWindow:init(params)
    self:onInit()
    return self
end

function NewRecruitPreviewWindow:onExit()
    -- 移除状态机
    state_machine.remove("new_recruit_preview_window_update_draw")
    state_machine.remove("new_recruit_preview_window_change_page")
end

function NewRecruitPreviewWindow:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
          sp.SkeletonRenderer:clear()
    end     
    cacher.removeAllTextures()     
    audioUtilUncacheAll() 
end
