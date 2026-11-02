-- YouTube推广主界面
FansExtensionWindow = class("FansExtensionWindowClass", Window)

local fans_extension_window_open_terminal = {
    _name = "fans_extension_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("FansExtensionWindowClass") == nil then
            fwin:open(FansExtensionWindow:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local fans_extension_window_close_terminal = {
    _name = "fans_extension_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("FansExtensionWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fans_extension_window_open_terminal)
state_machine.add(fans_extension_window_close_terminal)
state_machine.init()

function FansExtensionWindow:ctor()
    self.super:ctor()
    
    self.roots = {}
    self.drawInfo = {}
    self.pageInfo = {}
    self.pageIndex = 0

    app.load("client.activity.fans_extension.FansExtensionPageOneCell")
    app.load("client.activity.fans_extension.FansExtensionPageTwoCell")
    app.load("client.activity.ActivityContactUs")
    app.load("client.cells.activity.activity_icon_cell")

    local function init_fans_extension_window_terminal()
        -- 跳转网页
        local fans_extension_window_goto_web_page_terminal = {
            _name = "fans_extension_window_goto_web_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params and params._datas then
                    local url = params._datas.url
                    if cc.Application:getInstance().openURL then 
                        cc.Application:getInstance():openURL(url)
                    end
                    --handlePlatformRequest(0, CC_OPEN_URL, url)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 切换页面
        local fans_extension_window_change_page_terminal = {
            _name = "fans_extension_window_change_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance and params and params._datas then
                    instance:refushPage(params._datas.page_index)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(fans_extension_window_goto_web_page_terminal)
        state_machine.add(fans_extension_window_change_page_terminal)
        state_machine.init()
    end
    init_fans_extension_window_terminal()
end

function FansExtensionWindow:handleData()
    local scrolNum = dms.count(dms["youtube_video_mould"])
    for i = 1, scrolNum do
        local tempInfo = {}
        tempInfo.imgIndex = dms.string(dms["youtube_video_mould"], i, 2)
        tempInfo.urlAddres = dms.string(dms["youtube_video_mould"], i, 3)
        tempInfo.isRecommend = dms.string(dms["youtube_video_mould"], i, 4)
        table.insert(self.drawInfo, tempInfo)
    end
end

function FansExtensionWindow:onUpdateDraw()
    local root = self.roots[1]
    self.Panel_page_act = ccui.Helper:seekWidgetByName(root, "Panel_page_act")
    self.Button_rule = ccui.Helper:seekWidgetByName(root, "Button_rule")
    self.Button_video = ccui.Helper:seekWidgetByName(root, "Button_video")
    
    self.pageInfo[1] = self.Button_rule
    self.pageInfo[2] = self.Button_video
    -- 如果存在156类型活动，默认打开该活动界面
    self:refushPage(self.btnContactUs == nil and 1 or 156)
end

-- 切换页签
function FansExtensionWindow:refushPage(pageIndex)
    if self.pageIndex == pageIndex then
        return
    end

    local pageChildren = self.Panel_page_act:getChildren()
    for i, v in ipairs(pageChildren) do
        v:setVisible(false)
    end
    self.pageIndex = pageIndex

    -- 第一页和第二页的pageindex固定为1和2，其余活动的pageIndex与活动类型相对应
    if self.pageIndex == 156 then
        if self.pageContactUs == nil then
            self.pageContactUs = ActivityContactUs:createCell()
            self.pageContactUs:init()
            self.Panel_page_act:addChild(self.pageContactUs)
        else
            self.pageContactUs:setVisible(true)
        end
    elseif self.pageIndex == 1 then
        if self.ruleCell == nil then
            self.ruleCell = FansExtensionPageOneCell:createCell()
            self.ruleCell:init()
            self.Panel_page_act:addChild(self.ruleCell)
        else
            self.ruleCell:setVisible(true)
        end
    elseif self.pageIndex == 2 then
        if self.videoCell == nil then
            self.videoCell = FansExtensionPageTwoCell:createCell()
            self.videoCell:init({drawInfo = self.drawInfo})
            self.Panel_page_act:addChild(self.videoCell)
        else
            self.videoCell:setVisible(true)
        end
    end
    self:setTouchState(pageIndex)
end

-- 按钮的交互显示
function FansExtensionWindow:setTouchState(pageIndex)
    for i, v in pairs(self.pageInfo) do
        if i == pageIndex then
            v:setTouchEnabled(false)
            v:setHighlighted(true)
        else
            v:setTouchEnabled(true)
            v:setHighlighted(false)
        end
    end
end

function FansExtensionWindow:init(params)
    self:onInit()
    return self
end

function FansExtensionWindow:onInit()
    local csbItem = csb.createNode("activity/wonderful/youtubu.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    self:handleData()
    self:drawActivityBtn()
    self:onUpdateDraw()
    self:drawBtn()
end

function FansExtensionWindow:drawActivityBtn()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    if ListView_1 ~= nil then
        if _ED.active_activity[156] ~= nil then
            local contactUsCell = ActivityIconCell:createCell()
            contactUsCell:init(contactUsCell.enum_type.ACTIVITY_CONTACT_US)
            self.btnContactUs = ccui.Helper:seekWidgetByName(contactUsCell, "Button_act_but")
            self.pageInfo[156] = self.btnContactUs
            -- 联系我们置于最顶端
            ListView_1:insertCustomItem(contactUsCell, 0)
        end
    end
end

function FansExtensionWindow:drawBtn()
    local root = self.roots[1]
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_youbutu_back"),
        nil,
        {
            terminal_name = "fans_extension_window_close",
            terminal_state = 0,
            touch_black = true
        },
        nil,
        3
    )

    fwin:addTouchEventListener(
        self.Button_rule,
        nil,
        {
            terminal_name = "fans_extension_window_change_page",
            terminal_state = 0,
            touch_black = true,
            page_index = 1
        },
        nil,
        3
    )

    fwin:addTouchEventListener(
        self.Button_video,
        nil,
        {
            terminal_name = "fans_extension_window_change_page",
            terminal_state = 0,
            touch_black = true,
            page_index = 2
        },
        nil,
        3
    )

    fwin:addTouchEventListener(
        self.btnContactUs,
        nil,
        {
            terminal_name = "fans_extension_window_change_page",
            terminal_state = 0,
            touch_black = true,
            page_index = 156
        },
        nil,
        3
    )

end

function FansExtensionWindow:onEnterTransitionFinish()
end

function FansExtensionWindow:onExit()
    state_machine.remove("fans_extension_window_get_award")
    state_machine.remove("fans_extension_window_change_page")
end
