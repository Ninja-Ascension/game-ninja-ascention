-- YouTube推广页2
FansExtensionPageTwoCell = class("FansExtensionPageTwoCellClass", Window)

local fans_fans_extension_page_two_cell_change_page_terminal = {
    _name = "fans_fans_extension_page_two_cell_change_page",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("FansExtensionPageTwoCellClass") == nil then
            fwin:open(FansExtensionPageTwoCell:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fans_fans_extension_page_two_cell_change_page_terminal)
state_machine.init()

function FansExtensionPageTwoCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.curPage = 1
    self.curUrl = ""
    self.maxPage = 0

    local function init_fans_extension_page_two_cell_terminal()
        -- 切换
        local fans_extension_page_two_cell_change_page_terminal = {
            _name = "fans_extension_page_two_cell_change_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance and params then
                    local pageType = params._datas.pageType
                    instance.curPage = instance.curPage + pageType
                    if instance.curPage < 1 then 
                        instance.curPage = instance.maxPage
                    end
                    if instance.curPage > instance.maxPage then 
                        instance.curPage = 1
                    end

                    instance:changePage(instance.curPage)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fans_extension_page_two_cell_goto_web_terminal = {
            _name = "fans_extension_page_two_cell_goto_web",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    local url = instance.curUrl
                    state_machine.excute("fans_extension_window_goto_web_page",0,{_datas = {url = url}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fans_extension_page_two_cell_change_page_terminal)
        state_machine.add(fans_extension_page_two_cell_goto_web_terminal)
        state_machine.init()
    end
    init_fans_extension_page_two_cell_terminal()
end

function FansExtensionPageTwoCell:init(params)
    self.drawInfo = params.drawInfo
    self:onInit()
end

function FansExtensionPageTwoCell:onInit()
    local csbFansExtensionPageTwoCell = csb.createNode("activity/wonderful/youtubu_video.csb")
    local root = csbFansExtensionPageTwoCell:getChildByName("root")
    table.insert(self.roots, root)
    root:removeFromParent(false)
    self:addChild(root)
    self:setContentSize(root:getContentSize())

    self:onUpdateDraw()
    self:changePage(1)
end

function FansExtensionPageTwoCell:onUpdateDraw()
    local root = self.roots[1]
    self.Panel_3 = ccui.Helper:seekWidgetByName(root,"Panel_3")
    self.Text_linkto = ccui.Helper:seekWidgetByName(root,"Text_linkto")
    self.Image_hot = ccui.Helper:seekWidgetByName(root,"Image_hot")
    self.maxPage = #self.drawInfo
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_left"),
        nil,
        {
            terminal_name = "fans_extension_page_two_cell_change_page",
            terminal_state = 0,
            isPressedActionEnabled = false,
            pageType = -1
        },
        nil,
        0
    )

    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_right"),
        nil,
        {
            terminal_name = "fans_extension_page_two_cell_change_page",
            terminal_state = 0,
            isPressedActionEnabled = false,
            pageType = 1
        },
        nil,
        0
    )

    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_linkto"),
        nil,
        {
            terminal_name = "fans_extension_page_two_cell_goto_web",
            terminal_state = 0,
            isPressedActionEnabled = false
        },
        nil,
        0
    )
    
end

function FansExtensionPageTwoCell:changePage(pageIndex)
    local curInfo = self.drawInfo[pageIndex]
    self.Panel_3:removeAllChildren(true)
    local imgId = curInfo.imgIndex
    if tostring(imgId) ~= "-1" then 
        self.Panel_3:setBackGroundImage(string.format("images/ui/text/Youtubu_video/youtube_poster_%s.png",imgId))
    end
    self.curUrl = curInfo.urlAddres
    self.Text_linkto:setString(curInfo.urlAddres)
    if tostring(curInfo.isRecommend) == "1" then 
        self.Image_hot:setVisible(true)
    else
        self.Image_hot:setVisible(false)
    end
    
end

function FansExtensionPageTwoCell:createCell()
    local cell = FansExtensionPageTwoCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function FansExtensionPageTwoCell:onExit()
    state_machine.remove("fans_extension_page_two_cell_change_page")
    state_machine.remove("fans_extension_page_two_cell_goto_web")
end
